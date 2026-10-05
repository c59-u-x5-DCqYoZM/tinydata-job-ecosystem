-- source: ai / ratified: false / date: 2026-10-05
-- TinyData job ecosystem: core Postgres 16 DDL (architecture draft, migration 0001 to 0007 in one file).
-- Verified to execute on PostgreSQL 16 in an empty database (see BUILD-PLAN.md M0).
-- Every person, employer and job is synthetic; the schema enforces it (CHECK (synthetic)).
-- Conventions: snake_case; text ids with prefixes; money as numeric(14,2) GBP; simulated time as timestamptz.

BEGIN;

---------------------------------------------------------------------------
-- Roles (created idempotently; LOGIN is granted per environment, not here)
---------------------------------------------------------------------------
DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'td_owner')  THEN CREATE ROLE td_owner  NOLOGIN; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'td_world')  THEN CREATE ROLE td_world  NOLOGIN; END IF;  -- time engine, hidden truth
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'td_vault')  THEN CREATE ROLE td_vault  NOLOGIN; END IF;  -- market and vault rules engine
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'td_agent')  THEN CREATE ROLE td_agent  NOLOGIN; END IF;  -- agent layer (observable side)
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'td_operator') THEN CREATE ROLE td_operator NOLOGIN; END IF; -- vault operator console
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'td_scorer') THEN CREATE ROLE td_scorer NOLOGIN; END IF;  -- scorecard and financial model
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'td_reader') THEN CREATE ROLE td_reader NOLOGIN; END IF;  -- question interface, dashboards
END $$;

CREATE SCHEMA meta;   -- sources, parameters, data releases
CREATE SCHEMA ref;    -- reference data (jobs vertical pack)
CREATE SCHEMA pop;    -- core population identities (vertical-agnostic)
CREATE SCHEMA jobs;   -- jobs vertical extension tables (travel would add its own schema)
CREATE SCHEMA truth;  -- hidden truth: never readable by td_vault
CREATE SCHEMA sig;    -- signal catalogue and observations
CREATE SCHEMA sim;    -- experiments, runs, actions, receipts, world events, decision tape
CREATE SCHEMA fin;    -- fee schedules, ledger, plan v4, projections, reconciliation
CREATE SCHEMA rpt;    -- scorecard results and read-only views (the only schema td_reader sees)
CREATE SCHEMA qi;     -- question interface log

---------------------------------------------------------------------------
-- meta: provenance for every number
---------------------------------------------------------------------------
CREATE TABLE meta.source (
  source_id      text PRIMARY KEY,                    -- e.g. 'ons-aps-adhoc-3136'
  title          text NOT NULL,
  publisher      text NOT NULL,
  url            text,
  licence        text NOT NULL,                       -- 'OGL', 'CC BY 4.0', 'proprietary', ...
  accessed_on    date NOT NULL,
  evidence_mark  text NOT NULL CHECK (evidence_mark IN ('P','S','U','E','A','H','M','L')),
  research_ref   text NOT NULL                        -- 'docs/research/<file>.md#section'
);

CREATE TABLE meta.data_release (
  release_id         text PRIMARY KEY,                -- '<kind>-<YYYY.MM>.<patch>', e.g. 'pop-2026.10.0'
  kind               text NOT NULL CHECK (kind IN ('reference','parameters','population','decision_model','signals')),
  vertical           text NOT NULL,                   -- 'jobs'
  content_hash       char(64) NOT NULL,               -- sha256 over the canonical export
  built_by_commit    char(40) NOT NULL,
  built_at           timestamptz NOT NULL,
  parent_release     text REFERENCES meta.data_release,
  generator_seed     bigint,
  status             text NOT NULL CHECK (status IN ('draft','validated','published','withdrawn')),
  validation_report  jsonb,
  notes              text
);

CREATE TABLE meta.parameter (
  param_id       text NOT NULL,                       -- research ids, e.g. 'BEH-4', 'ST-2', 'CV-3'
  release_id     text NOT NULL REFERENCES meta.data_release,
  value          jsonb NOT NULL,
  range_low      jsonb,
  range_high     jsonb,
  confidence     text NOT NULL CHECK (confidence IN ('H','M','L','A','E')),
  source_id      text REFERENCES meta.source,
  illustrative   boolean NOT NULL,
  note           text,
  PRIMARY KEY (param_id, release_id)
);

CREATE TABLE meta.model_price (                        -- dated, so a cost estimate can always be re-derived
  provider              text NOT NULL,
  model_id              text NOT NULL,               -- exact dated model id, never an alias
  effective_from        date NOT NULL,
  input_per_mtok_usd    numeric(10,4) NOT NULL,
  output_per_mtok_usd   numeric(10,4) NOT NULL,
  cache_read_per_mtok_usd numeric(10,4),
  batch_discount        numeric(4,3) NOT NULL DEFAULT 0,
  source_url            text NOT NULL,
  PRIMARY KEY (provider, model_id, effective_from)
);

---------------------------------------------------------------------------
-- ref: reference data for the jobs vertical
---------------------------------------------------------------------------
CREATE TABLE ref.sector (
  sector_code  text PRIMARY KEY CHECK (sector_code IN ('professional_business_services','technology_digital','finance_insurance')),
  name         text NOT NULL,
  sic_version  text NOT NULL DEFAULT 'SIC2007',
  sic_sections text[] NOT NULL                        -- e.g. {M,N}; decision pending with Simon
);

CREATE TABLE ref.region (
  region_code  text PRIMARY KEY,                      -- matches careers LocationBand: london, south_east, ...
  name         text NOT NULL,
  itl1_codes   text[] NOT NULL,
  centroid_lat numeric(8,5) NOT NULL,
  centroid_lon numeric(8,5) NOT NULL
);

CREATE TABLE ref.region_distance (
  from_region  text NOT NULL REFERENCES ref.region,
  to_region    text NOT NULL REFERENCES ref.region,
  km           integer NOT NULL CHECK (km >= 0),
  PRIMARY KEY (from_region, to_region)
);

CREATE TABLE ref.soc_unit (
  soc2020      char(4) PRIMARY KEY,
  title        text NOT NULL,
  major_group  smallint NOT NULL CHECK (major_group BETWEEN 1 AND 9),
  isco08       text[] NOT NULL DEFAULT '{}'           -- many-to-many; weights in ref.soc_isco_weight
);

CREATE TABLE ref.function (
  function_id     text PRIMARY KEY,                   -- 'pbs.legal', 'td.software_engineering', 'fi.underwriting'
  sector_code     text NOT NULL REFERENCES ref.sector,
  name            text NOT NULL,
  function_family text NOT NULL,                      -- 'technology' lets cross-sector tech questions avoid double counting
  fee_earning     boolean NOT NULL,
  careers_role_family text                            -- nullable: careers RoleFamily has 9 values today
);

CREATE TABLE ref.function_soc_map (
  release_id   text NOT NULL REFERENCES meta.data_release,
  function_id  text NOT NULL REFERENCES ref.function,
  soc2020      char(4) NOT NULL REFERENCES ref.soc_unit,
  split_weight numeric(5,4) NOT NULL CHECK (split_weight > 0 AND split_weight <= 1),
  PRIMARY KEY (release_id, function_id, soc2020)
);

CREATE TABLE ref.pay_quantile (
  release_id   text NOT NULL REFERENCES meta.data_release,
  soc2020      char(4) NOT NULL REFERENCES ref.soc_unit,
  region_code  text NOT NULL REFERENCES ref.region,
  quantile     smallint NOT NULL CHECK (quantile BETWEEN 1 AND 99),
  annual_gbp   integer NOT NULL CHECK (annual_gbp > 0),
  source_id    text NOT NULL REFERENCES meta.source,
  PRIMARY KEY (release_id, soc2020, region_code, quantile)
);

CREATE TABLE ref.task (
  task_id      text PRIMARY KEY,                      -- 'onet:15-1252.00:t123' or 'uk:fca-smcr:attest'
  statement    text NOT NULL,
  origin       text NOT NULL CHECK (origin IN ('onet','esco','uk_regulated','emerging')),
  task_cluster text NOT NULL                          -- capability is modelled per cluster, not per task
);

CREATE TABLE ref.role_task (
  release_id   text NOT NULL REFERENCES meta.data_release,
  soc2020      char(4) NOT NULL REFERENCES ref.soc_unit,
  function_id  text NOT NULL REFERENCES ref.function,
  task_id      text NOT NULL REFERENCES ref.task,
  time_share   numeric(6,5) NOT NULL CHECK (time_share > 0 AND time_share <= 1),
  PRIMARY KEY (release_id, soc2020, function_id, task_id)
);

CREATE TABLE ref.task_exposure (
  release_id          text NOT NULL REFERENCES meta.data_release,
  task_id             text NOT NULL REFERENCES ref.task,
  tag                 text NOT NULL CHECK (tag IN ('unchanged','augmented','automated','new')),
  eloundou_label      text CHECK (eloundou_label IN ('E0','E1','E2')),
  usage_share         numeric(9,8),
  automation_ratio    numeric(5,4),
  evidence_release    date,
  confidence          text NOT NULL CHECK (confidence IN ('H','M','L','A','E')),
  scenario_sensitive  boolean NOT NULL DEFAULT false, -- does the tag flip under substantial or extreme?
  PRIMARY KEY (release_id, task_id)
);

CREATE TABLE ref.marginal_target (
  release_id     text NOT NULL REFERENCES meta.data_release,
  universe       text NOT NULL CHECK (universe IN ('jobs','people')),
  dimension_set  text NOT NULL,                       -- 'sector x function', 'function x region', ...
  cell           jsonb NOT NULL,                      -- {"sector":"finance_insurance","function":"fi.actuarial"}
  target_share   numeric(9,8) NOT NULL CHECK (target_share >= 0 AND target_share <= 1),
  held_out       boolean NOT NULL DEFAULT false,      -- true: validation only, never used in fitting
  source_id      text NOT NULL REFERENCES meta.source,
  PRIMARY KEY (release_id, universe, dimension_set, cell)
);

---------------------------------------------------------------------------
-- pop: vertical-agnostic identities (travel reuses these three tables)
---------------------------------------------------------------------------
CREATE TABLE pop.individual (
  release_id     text NOT NULL REFERENCES meta.data_release,
  individual_id  text NOT NULL CHECK (individual_id ~ '^P-[0-9]{6}$'),
  vertical       text NOT NULL,
  depth          text NOT NULL CHECK (depth IN ('structured','profiled')),
  stratum        text NOT NULL,
  design_weight  numeric(14,4) NOT NULL CHECK (design_weight > 0),
  region_code    text NOT NULL REFERENCES ref.region,
  synthetic      boolean NOT NULL DEFAULT true CHECK (synthetic),
  generator      text NOT NULL,                       -- generator name and version
  PRIMARY KEY (release_id, individual_id)
);

CREATE TABLE pop.producer (
  release_id     text NOT NULL REFERENCES meta.data_release,
  producer_id    text NOT NULL CHECK (producer_id ~ '^E-[0-9]{5}$'),
  vertical       text NOT NULL,
  kind           text NOT NULL,                       -- jobs: 'employer' | 'agency'
  design_weight  numeric(14,4) NOT NULL CHECK (design_weight > 0),
  synthetic      boolean NOT NULL DEFAULT true CHECK (synthetic),
  generator      text NOT NULL,
  PRIMARY KEY (release_id, producer_id)
);

CREATE TABLE pop.opening (
  release_id     text NOT NULL REFERENCES meta.data_release,
  opening_id     text NOT NULL CHECK (opening_id ~ '^J-[0-9]{6}$'),
  producer_id    text NOT NULL,
  vertical       text NOT NULL,
  stratum        text NOT NULL,
  design_weight  numeric(14,4) NOT NULL CHECK (design_weight > 0),
  synthetic      boolean NOT NULL DEFAULT true CHECK (synthetic),
  generator      text NOT NULL,
  PRIMARY KEY (release_id, opening_id),
  FOREIGN KEY (release_id, producer_id) REFERENCES pop.producer (release_id, producer_id)
);

CREATE TABLE pop.validation_result (
  release_id   text NOT NULL REFERENCES meta.data_release,
  test_id      text NOT NULL,                         -- 'tvd.sector', 'srmse.sector_x_function', 'pay.decile', ...
  statistic    text NOT NULL,
  value        numeric NOT NULL,
  threshold    numeric NOT NULL,
  pass         boolean NOT NULL,
  detail       jsonb,
  PRIMARY KEY (release_id, test_id)
);

---------------------------------------------------------------------------
-- jobs: vertical extension tables (observable side only)
---------------------------------------------------------------------------
CREATE TABLE jobs.employer (
  release_id      text NOT NULL,
  producer_id     text NOT NULL,
  legal_name      text NOT NULL,
  company_number  char(8) NOT NULL CHECK (company_number ~ '^[0-9A-Z]{8}$'),   -- careers EmployerAccount shape
  domain          text NOT NULL CHECK (domain ~ '^[a-z0-9-]+(\.[a-z0-9-]+)*\.example$'), -- RFC 2606: never a real domain
  sector_code     text REFERENCES ref.sector,         -- null only for employers outside the focus sectors
  size_band       text NOT NULL CHECK (size_band IN ('micro','small','medium','large','1000_plus')),
  kind            text NOT NULL CHECK (kind IN ('employer','agency')),
  hq_region       text NOT NULL REFERENCES ref.region,
  PRIMARY KEY (release_id, producer_id),
  FOREIGN KEY (release_id, producer_id) REFERENCES pop.producer (release_id, producer_id)
);

CREATE TABLE jobs.person (
  release_id        text NOT NULL,
  individual_id     text NOT NULL,
  sector_code       text REFERENCES ref.sector,        -- null for entrants from outside the three sectors
  function_id       text REFERENCES ref.function,
  soc2020           char(4) REFERENCES ref.soc_unit,
  level             smallint NOT NULL CHECK (level BETWEEN 1 AND 8),             -- normalised ladder L1 to L8
  seniority         text NOT NULL CHECK (seniority IN ('entry','associate','senior','manager','lead','head_of','director','executive')),
  current_employer  text,                              -- producer_id; device-side only in careers terms
  search_state      text NOT NULL CHECK (search_state IN ('ST-1','ST-2','ST-3','ST-4','ST-5','ST-6','ST-7','ST-8','ST-9','ST-10')),
  ai_cohort         text NOT NULL CHECK (ai_cohort IN ('none','augmented','displaced','changer')),
  intent_primary    text NOT NULL CHECK (intent_primary ~ '^INT-[1-9]$'),
  intent_secondary  text[] NOT NULL DEFAULT '{}',
  intent_phrase     text NOT NULL,                     -- the person's own words, alongside the code
  current_pay_gbp   integer CHECK (current_pay_gbp > 0),
  pay_floor_gbp     integer NOT NULL CHECK (pay_floor_gbp > 0),
  work_mode         text NOT NULL CHECK (work_mode IN ('remote','hybrid','on_site')),
  max_office_days   smallint NOT NULL CHECK (max_office_days BETWEEN 0 AND 5),
  max_commute_km    integer NOT NULL CHECK (max_commute_km >= 0),
  relocation_open   boolean NOT NULL,
  notice_weeks      smallint NOT NULL CHECK (notice_weeks BETWEEN 0 AND 52),
  tenure_months     integer NOT NULL CHECK (tenure_months >= 0),
  never_see         text[] NOT NULL DEFAULT '{}',      -- producer_ids that must never see this person
  PRIMARY KEY (release_id, individual_id),
  FOREIGN KEY (release_id, individual_id) REFERENCES pop.individual (release_id, individual_id)
);

CREATE TABLE jobs.cv (                                 -- the noisy, structured view of the person
  release_id         text NOT NULL,
  individual_id      text NOT NULL,
  claimed_title      text NOT NULL,
  claimed_level      smallint NOT NULL CHECK (claimed_level BETWEEN 1 AND 8),
  claimed_skills     text[] NOT NULL,
  years_experience   numeric(4,1) NOT NULL,
  qualifications     text[] NOT NULL DEFAULT '{}',
  employment_gaps    smallint NOT NULL DEFAULT 0,
  ai_polished        boolean NOT NULL,                 -- CV-5
  discrepancy        text NOT NULL CHECK (discrepancy IN ('none','minor_inflation','material')),  -- CV-1, CV-2
  PRIMARY KEY (release_id, individual_id),
  FOREIGN KEY (release_id, individual_id) REFERENCES pop.individual (release_id, individual_id)
);

CREATE TABLE jobs.cv_document (                        -- prose, profiled depth only, AI-authored then frozen
  release_id     text NOT NULL,
  individual_id  text NOT NULL,
  cv_markdown    text NOT NULL,
  author_model   text NOT NULL,                        -- pinned model id at write time
  prompt_version text NOT NULL,
  tape_key       char(64) NOT NULL,                    -- the authoring call in the decision tape
  PRIMARY KEY (release_id, individual_id),
  FOREIGN KEY (release_id, individual_id) REFERENCES pop.individual (release_id, individual_id)
);

CREATE TABLE jobs.job (
  release_id        text NOT NULL,
  opening_id        text NOT NULL,
  brief_ref         text NOT NULL CHECK (brief_ref ~ '^BR-[0-9]{3,6}$'),          -- careers BriefPlaceRequest id shape
  client_producer   text,                              -- the client when an agency hires for one
  route             text NOT NULL CHECK (route IN ('direct','agency')),
  function_id       text NOT NULL REFERENCES ref.function,
  soc2020           char(4) NOT NULL REFERENCES ref.soc_unit,
  level             smallint NOT NULL CHECK (level BETWEEN 1 AND 8),
  seniority         text NOT NULL CHECK (seniority IN ('entry','associate','senior','manager','lead','head_of','director','executive')),
  title             text NOT NULL CHECK (length(title) BETWEEN 3 AND 80),
  shape             text NOT NULL CHECK (shape IN ('permanent_full_time','permanent_part_time','fixed_term_contract')),
  hiring_pattern    text NOT NULL CHECK (hiring_pattern IN ('P1','P2','P3','P4','P5','P6')),
  criticality       text NOT NULL CHECK (criticality IN ('CRIT-1','CRIT-2','CRIT-3','CRIT-4')),
  ai_role_type      text NOT NULL CHECK (ai_role_type IN ('none','NEW-1','NEW-2','NEW-3')),
  band_min_gbp      integer NOT NULL CHECK (band_min_gbp > 0),
  band_max_gbp      integer NOT NULL,
  work_mode         text NOT NULL CHECK (work_mode IN ('remote','hybrid','on_site')),
  office_days       smallint NOT NULL CHECK (office_days BETWEEN 0 AND 5),
  location_band     text NOT NULL REFERENCES ref.region,
  required_claims   text[] NOT NULL DEFAULT '{}',      -- right_to_work, qualification, employment_history
  regulated_status  text,                              -- 'SRA', 'FCA_SMCR_certified', 'SMF', ...
  wants_facts       text[] NOT NULL DEFAULT '{}',      -- careers fact labels the brief asks for
  CHECK (band_min_gbp <= band_max_gbp),
  PRIMARY KEY (release_id, opening_id),
  FOREIGN KEY (release_id, opening_id) REFERENCES pop.opening (release_id, opening_id)
);

---------------------------------------------------------------------------
-- truth: the hidden-truth model. td_vault has NO grant on this schema.
---------------------------------------------------------------------------
CREATE TABLE truth.person (
  release_id          text NOT NULL,
  individual_id       text NOT NULL,
  -- way of working (0..1)
  wow_async           numeric(4,3) NOT NULL,
  wow_collaborative   numeric(4,3) NOT NULL,
  wow_focus_need      numeric(4,3) NOT NULL,
  wow_tz_flex         numeric(4,3) NOT NULL,
  wow_office_tolerance numeric(4,3) NOT NULL,
  wow_regulated_comfort numeric(4,3) NOT NULL,
  -- preference weights (sum to 1)
  pref_pay            numeric(4,3) NOT NULL,
  pref_progression    numeric(4,3) NOT NULL,
  pref_flexibility    numeric(4,3) NOT NULL,
  pref_manager        numeric(4,3) NOT NULL,
  pref_learning       numeric(4,3) NOT NULL,
  pref_stability      numeric(4,3) NOT NULL,
  pref_purpose        numeric(4,3) NOT NULL,
  pref_commute        numeric(4,3) NOT NULL,
  learning_velocity   numeric(4,3) NOT NULL,
  ai_fluency          numeric(4,3) NOT NULL,
  true_reservation_gbp integer NOT NULL,
  PRIMARY KEY (release_id, individual_id),
  FOREIGN KEY (release_id, individual_id) REFERENCES pop.individual (release_id, individual_id)
);

CREATE TABLE truth.person_capability (
  release_id     text NOT NULL,
  individual_id  text NOT NULL,
  task_cluster   text NOT NULL,
  level          numeric(4,3) NOT NULL CHECK (level BETWEEN 0 AND 1),
  PRIMARY KEY (release_id, individual_id, task_cluster),
  FOREIGN KEY (release_id, individual_id) REFERENCES pop.individual (release_id, individual_id)
);

CREATE TABLE truth.person_protected (                  -- fairness checks only; never a feature anywhere
  release_id     text NOT NULL,
  individual_id  text NOT NULL,
  age_band       text NOT NULL CHECK (age_band IN ('16_24','25_29','30_44','45_49','50_64','65_plus')),
  gender         text NOT NULL CHECK (gender IN ('female','male','other')),
  returner       boolean NOT NULL,
  PRIMARY KEY (release_id, individual_id),
  FOREIGN KEY (release_id, individual_id) REFERENCES pop.individual (release_id, individual_id)
);

CREATE TABLE truth.job (
  release_id          text NOT NULL,
  opening_id          text NOT NULL,
  manager_quality     numeric(4,3) NOT NULL,
  true_remote_open    boolean NOT NULL,                -- may differ from the stated work_mode
  true_pay_ceiling_gbp integer NOT NULL,
  wow_async_demand    numeric(4,3) NOT NULL,
  wow_collab_demand   numeric(4,3) NOT NULL,
  wow_office_demand   numeric(4,3) NOT NULL,
  progression_rate    numeric(4,3) NOT NULL,
  fake                boolean NOT NULL DEFAULT false,  -- adversarial arm: a fake job
  PRIMARY KEY (release_id, opening_id),
  FOREIGN KEY (release_id, opening_id) REFERENCES pop.opening (release_id, opening_id)
);

CREATE TABLE truth.job_requirement (                   -- what the job really needs, per task cluster
  release_id     text NOT NULL,
  opening_id     text NOT NULL,
  task_cluster   text NOT NULL,
  weight         numeric(5,4) NOT NULL CHECK (weight > 0 AND weight <= 1),
  min_level      numeric(4,3) NOT NULL CHECK (min_level BETWEEN 0 AND 1),
  PRIMARY KEY (release_id, opening_id, task_cluster),
  FOREIGN KEY (release_id, opening_id) REFERENCES pop.opening (release_id, opening_id)
);

---------------------------------------------------------------------------
-- sig: signals are data. What crosses is a careers fact label, never the value.
---------------------------------------------------------------------------
CREATE TABLE sig.signal_def (
  signal_id         text PRIMARY KEY,                  -- 'cal.focus_blocks', 'code.recency.python', 'cv.title'
  channel           text NOT NULL CHECK (channel IN ('cv','calendar','documents','writing','code','learning','tools','claims','references')),
  views_latent      text[] NOT NULL,                   -- e.g. {wow_focus_need} or {cap:data_modelling}
  noise_sd          numeric(5,4) NOT NULL,
  bias              numeric(5,4) NOT NULL DEFAULT 0,
  coverage          numeric(4,3) NOT NULL CHECK (coverage BETWEEN 0 AND 1),   -- share of people for whom it exists
  person_cost_min   numeric(6,1) NOT NULL,             -- minutes of the person's effort
  sensitivity       text NOT NULL CHECK (sensitivity IN ('low','medium','high','very_high')),
  consent_level     text NOT NULL CHECK (consent_level IN ('none','confirm','explicit','never_crosses')),
  maps_to_fact      text,                              -- careers CareersFactLabel, or null
  fact_threshold    numeric(4,3),                      -- confidence needed before a fact is drafted
  version           integer NOT NULL
);

CREATE TABLE sig.observation (
  release_id     text NOT NULL,
  individual_id  text NOT NULL,
  signal_id      text NOT NULL REFERENCES sig.signal_def,
  observed       numeric NOT NULL,
  present        boolean NOT NULL,
  confirmed      boolean,                              -- the person's simulated confirmation of the drafted fact
  PRIMARY KEY (release_id, individual_id, signal_id),
  FOREIGN KEY (release_id, individual_id) REFERENCES pop.individual (release_id, individual_id)
);

---------------------------------------------------------------------------
-- sim: experiments, runs, agents, actions, receipts (the market log), world events, tape
---------------------------------------------------------------------------
CREATE TABLE sim.experiment (
  experiment_id  char(64) PRIMARY KEY,                 -- sha256 of the canonical JSON of the experiment file
  name           text NOT NULL,
  version        integer NOT NULL,
  spec           jsonb NOT NULL,
  spec_yaml      text NOT NULL,
  created_by     text NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now(),
  UNIQUE (name, version)
);

CREATE TABLE sim.run (
  run_id                 uuid PRIMARY KEY,
  experiment_id          char(64) NOT NULL REFERENCES sim.experiment,
  arm                    text NOT NULL,
  replicate              integer NOT NULL CHECK (replicate >= 0),
  seed                   bigint NOT NULL,
  reference_release      text NOT NULL REFERENCES meta.data_release,
  parameter_release      text NOT NULL REFERENCES meta.data_release,
  population_release     text NOT NULL REFERENCES meta.data_release,
  signal_release         text REFERENCES meta.data_release,
  decision_model_release text REFERENCES meta.data_release,
  code_commit            char(40) NOT NULL,
  engine_version         text NOT NULL,
  schema_version         integer NOT NULL,
  model_pins             jsonb NOT NULL DEFAULT '{}',  -- {"live_individual":"<exact model id>", ...}
  receipt_level          text NOT NULL CHECK (receipt_level IN ('full','presented')),
  status                 text NOT NULL CHECK (status IN ('queued','running','succeeded','failed','budget_stopped')),
  budget_usd             numeric(10,2) NOT NULL DEFAULT 0,
  spent_usd              numeric(10,2) NOT NULL DEFAULT 0,
  started_at             timestamptz,
  finished_at            timestamptz,
  final_receipt_hash     char(64),
  final_world_hash       char(64),
  retention              text NOT NULL CHECK (retention IN ('pinned','standard')) DEFAULT 'standard',
  UNIQUE (experiment_id, arm, replicate)
);

CREATE TABLE sim.agent_manifest (
  run_id          uuid NOT NULL REFERENCES sim.run,
  agent_id        text NOT NULL,                       -- 'ind-P-000412', 'emp-E-00031', 'agy-E-00102', 'adv-0003'
  manifest_version integer NOT NULL,
  side            text NOT NULL CHECK (side IN ('individual','producer','vault','operator','maintainer','adversary')),
  principal_id    text,                                -- the individual or producer it acts for
  tier            text NOT NULL CHECK (tier IN ('rule','archetype','live')),
  provider        text,
  model_id        text,                                -- exact pinned id, frozen at write time
  prompt_version  text,
  memory_design   text NOT NULL CHECK (memory_design IN ('none','retrieval','reflection')),
  delegation      jsonb NOT NULL,                      -- what it may do without asking its principal
  tools           text[] NOT NULL,
  budget          jsonb NOT NULL,                      -- actions and tokens per simulated week
  strategy_tags   text[] NOT NULL DEFAULT '{}',        -- honest, broker, fake_job, fabricated_cv, spam, injector
  topology_slot   text NOT NULL,                       -- bilateral_vault, forum, brokered, open_board
  PRIMARY KEY (run_id, agent_id, manifest_version)
);

CREATE TABLE sim.action (                              -- every typed action submitted, applied or refused
  run_id         uuid NOT NULL,
  action_id      bigint NOT NULL,
  tick           integer NOT NULL,                     -- month index from horizon start
  substep        smallint NOT NULL CHECK (substep BETWEEN 0 AND 5),
  order_key      char(64) NOT NULL,                    -- seeded shuffle key: deterministic order within a substep
  agent_id       text NOT NULL,
  action_type    text NOT NULL,                        -- 'candidacy.emit', 'brief.place', 'handshake.request', ...
  body           jsonb NOT NULL,
  tape_key       char(64),                             -- set when the decision came from an LLM call
  PRIMARY KEY (run_id, action_id)
) PARTITION BY LIST (run_id);

CREATE TABLE sim.receipt (                             -- the market log: careers AuditEvent fields + chain extension
  run_id          uuid NOT NULL,
  seq             bigint NOT NULL CHECK (seq >= 1),    -- gap-free within a run; careers 'id'
  at              timestamptz NOT NULL,                -- simulated time; careers 'at'
  actor           text NOT NULL CHECK (actor IN ('skibbit_device','registry','producer_mcp','system')),
  boundary        text NOT NULL CHECK (boundary IN ('device_to_registry','registry_to_device','registry_to_producer','producer_to_registry','internal')),
  event_type      text NOT NULL CHECK (event_type ~ '^[a-z_]+\.[a-z_]+$'),
  schema_ref      text NOT NULL,
  consent_ref     text,
  handle          char(64),
  payload_digest  char(64) NOT NULL,                   -- sha256(JSON.stringify(payload)), as careers sha256Json
  -- ecosystem extension (dropped by the careers projection)
  tick            integer NOT NULL,
  substep         smallint NOT NULL,
  action_id       bigint,
  agent_id        text,
  outcome         text NOT NULL CHECK (outcome IN ('applied','refused','engine')),
  rule_id         text,                                -- the rule that refused, e.g. 'VR-03-floor'
  operator_id     text,                                -- set on operator.* events (actor projects to 'system' for careers)
  approver_id     text,                                -- second operator on two-person actions
  payload         jsonb NOT NULL,                      -- stored because every record is synthetic
  digest_alg      text NOT NULL DEFAULT 'sha256-json-stringify-v1',
  prev_hash       char(64) NOT NULL,                   -- 64 zeros for seq 1
  receipt_hash    char(64) NOT NULL,
  PRIMARY KEY (run_id, seq),
  CHECK (outcome <> 'refused' OR rule_id IS NOT NULL),
  CHECK (event_type NOT LIKE 'operator.%' OR operator_id IS NOT NULL),
  CHECK (approver_id IS NULL OR approver_id <> operator_id)
) PARTITION BY LIST (run_id);

CREATE TABLE sim.operator_case (                       -- the vault operator's queues, simulated
  run_id            uuid NOT NULL,
  case_id           bigint NOT NULL,
  queue             text NOT NULL CHECK (queue IN ('company_check','flagged_brief','failed_claim','disputed_outcome',
                                                   'data_request','incident','auditor_access','rules_model_health',
                                                   'record_integrity','fees')),
  subject_ref       text NOT NULL,                     -- account id, brief ref, code name or certificate id; never an identity
  opened_seq        bigint NOT NULL,                   -- the receipt that opened the case
  opened_at         timestamptz NOT NULL,
  priority          smallint NOT NULL CHECK (priority BETWEEN 1 AND 4),
  sla_hours         integer NOT NULL CHECK (sla_hours > 0),
  sensitive         boolean NOT NULL,                  -- needs two-person approval to resolve
  status            text NOT NULL CHECK (status IN ('open','in_review','awaiting_second','resolved','escalated')),
  assigned_operator text,
  second_approver   text,
  resolution        text CHECK (resolution IN ('upheld','rejected','corrected','suspended','released','referred')),
  resolved_seq      bigint,                            -- the receipt that resolved it
  resolved_at       timestamptz,
  truth_label       text,                              -- scorer only: was the flag real (e.g. a fake job)? never shown to operators
  PRIMARY KEY (run_id, case_id),
  CHECK (status <> 'resolved' OR (resolved_seq IS NOT NULL AND resolution IS NOT NULL)),
  CHECK (NOT (sensitive AND status = 'resolved') OR (second_approver IS NOT NULL AND second_approver <> assigned_operator))
) PARTITION BY LIST (run_id);

CREATE TABLE sim.world_event (                         -- hidden-truth log: a separate chain the vault never reads
  run_id        uuid NOT NULL,
  seq           bigint NOT NULL CHECK (seq >= 1),
  at            timestamptz NOT NULL,
  tick          integer NOT NULL,
  substep       smallint NOT NULL,
  event_type    text NOT NULL CHECK (event_type ~ '^[a-z_]+\.[a-z_]+$'),  -- 'person.state_changed', 'job.filled_outside', ...
  subject_id    text NOT NULL,
  payload       jsonb NOT NULL,
  prev_hash     char(64) NOT NULL,
  event_hash    char(64) NOT NULL,
  PRIMARY KEY (run_id, seq)
) PARTITION BY LIST (run_id);

CREATE TABLE sim.message (                             -- typed agent messages, recorded as data
  run_id        uuid NOT NULL,
  message_id    bigint NOT NULL,
  receipt_seq   bigint NOT NULL,                       -- every message crosses the log
  thread_id     text NOT NULL,
  sender        text NOT NULL,
  receiver      text,                                  -- null for a broadcast channel
  channel       text NOT NULL CHECK (channel IN ('bilateral_vault','forum','brokered','open_board')),
  kind          text NOT NULL CHECK (kind IN ('Search','Introduce','Message','Propose','Counter','Share','Accept','Decline','Withdraw','Report','Post','Comment','Vote')),
  body          jsonb NOT NULL,                        -- free text lives only here, never in state
  PRIMARY KEY (run_id, message_id)
) PARTITION BY LIST (run_id);

CREATE TABLE sim.checkpoint (                          -- monthly chain heads; also written to the witness store
  run_id         uuid NOT NULL REFERENCES sim.run,
  tick           integer NOT NULL,
  receipt_seq    bigint NOT NULL,
  receipt_head   char(64) NOT NULL,
  world_seq      bigint NOT NULL,
  world_head     char(64) NOT NULL,
  state_hash     char(64) NOT NULL,
  PRIMARY KEY (run_id, tick)
);

CREATE TABLE sim.decision_tape (                       -- every LLM call, keyed so a replay never calls a model
  tape_key        char(64) PRIMARY KEY,                -- sha256(model_id|prompt_version|schema_version|state_hash|sample_index)
  provider        text NOT NULL,
  model_id        text NOT NULL,
  prompt_version  text NOT NULL,
  decision_schema text NOT NULL,
  state_hash      char(64) NOT NULL,
  sample_index    integer NOT NULL,
  request         jsonb NOT NULL,
  response        jsonb NOT NULL,
  decision        jsonb,                               -- null when the response failed validation
  valid           boolean NOT NULL,
  input_tokens    integer NOT NULL,
  output_tokens   integer NOT NULL,
  cost_usd        numeric(12,6) NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE sim.run_cost (
  run_id         uuid NOT NULL REFERENCES sim.run,
  tier           text NOT NULL CHECK (tier IN ('archetype','live','adjudicator','authoring')),
  model_id       text NOT NULL,
  calls          integer NOT NULL,
  tape_hits      integer NOT NULL,
  input_tokens   bigint NOT NULL,
  output_tokens  bigint NOT NULL,
  cost_usd       numeric(12,4) NOT NULL,
  PRIMARY KEY (run_id, tier, model_id)
);

-- Append-only enforcement, as the careers audit rail does with triggers.
CREATE FUNCTION sim.refuse_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'append-only: % on %.% refused', TG_OP, TG_TABLE_SCHEMA, TG_TABLE_NAME;
END $$;

CREATE TRIGGER receipt_append_only BEFORE UPDATE OR DELETE ON sim.receipt
  FOR EACH ROW EXECUTE FUNCTION sim.refuse_mutation();
CREATE TRIGGER world_event_append_only BEFORE UPDATE OR DELETE ON sim.world_event
  FOR EACH ROW EXECUTE FUNCTION sim.refuse_mutation();
CREATE TRIGGER operator_case_no_delete BEFORE DELETE ON sim.operator_case
  FOR EACH ROW EXECUTE FUNCTION sim.refuse_mutation();
CREATE TRIGGER action_append_only BEFORE UPDATE OR DELETE ON sim.action
  FOR EACH ROW EXECUTE FUNCTION sim.refuse_mutation();
-- Retention drops whole partitions (DETACH + DROP), which row triggers do not block, by design.

---------------------------------------------------------------------------
-- fin: fees, ledger, Simon's plan v4, projections, reconciliation
---------------------------------------------------------------------------
CREATE TABLE fin.fee_schedule (
  fee_schedule_id    text PRIMARY KEY,                 -- 'plan-v4', 'flat-1850-promo-off', ...
  hire_fee_mode      text NOT NULL CHECK (hire_fee_mode IN ('flat','percentage')),   -- Q29
  flat_hire_fee_gbp  numeric(10,2),
  pct_direct         numeric(5,2),
  pct_agency         numeric(5,2),
  job_wave_gbp       numeric(8,2) NOT NULL,
  handshake_gbp      numeric(8,2) NOT NULL,
  consent_gbp        numeric(8,2) NOT NULL,
  ranking_promotion_gbp numeric(8,2) NOT NULL,
  ranking_promotion_enabled boolean NOT NULL DEFAULT false,                         -- Q30: never read by the matcher
  seat_tiers_gbp     numeric(10,2)[] NOT NULL,         -- {1999,4999,8999}
  candidate_pays_gbp numeric(8,2) NOT NULL DEFAULT 0 CHECK (candidate_pays_gbp = 0),
  source_id          text REFERENCES meta.source,
  CHECK (hire_fee_mode <> 'flat' OR flat_hire_fee_gbp IS NOT NULL),
  CHECK (hire_fee_mode <> 'percentage' OR (pct_direct IS NOT NULL AND pct_agency IS NOT NULL))
);

CREATE TABLE fin.ledger_entry (                        -- fees accrue only from receipted events
  run_id           uuid NOT NULL,
  entry_id         bigint NOT NULL,
  receipt_seq      bigint NOT NULL,
  sim_month        date NOT NULL,
  stream           text NOT NULL CHECK (stream IN ('job_wave','ranking_promotion','handshake','consent','hire_fee')),
  route            text NOT NULL CHECK (route IN ('direct','agency')),
  sector_code      text NOT NULL REFERENCES ref.sector,
  producer_id      text NOT NULL,
  amount_gbp       numeric(14,2) NOT NULL CHECK (amount_gbp >= 0),
  fee_schedule_id  text NOT NULL REFERENCES fin.fee_schedule,
  PRIMARY KEY (run_id, entry_id),
  FOREIGN KEY (run_id, receipt_seq) REFERENCES sim.receipt (run_id, seq)
);

CREATE TABLE fin.plan_v4_cell (                        -- Simon's workbook, cell by cell: inputs and outputs
  workbook_version text NOT NULL,                      -- 'UK Recruitment Revenue Assumptions v4'
  sheet            text NOT NULL,
  cell             text NOT NULL,                      -- 'C14'
  role             text NOT NULL CHECK (role IN ('input','output')),
  label            text NOT NULL,
  value            numeric NOT NULL,
  PRIMARY KEY (workbook_version, sheet, cell)
);

CREATE TABLE fin.scenario (                            -- a named financial scenario: levers plus where the funnel comes from
  scenario_id      text PRIMARY KEY,                   -- 'plan-v4-replica', 'base', 'low', 'high', ...
  mode             text NOT NULL CHECK (mode IN ('plan','ecosystem')),
  fee_schedule_id  text NOT NULL REFERENCES fin.fee_schedule,
  route_split_direct_pct numeric(5,2) NOT NULL CHECK (route_split_direct_pct BETWEEN 0 AND 100),
  attributable_share numeric(5,4) NOT NULL,
  producer_ramp    jsonb NOT NULL,                     -- producers live by month, per route
  seat_mix         jsonb NOT NULL,
  funnel_source    text NOT NULL CHECK (funnel_source IN ('plan_v4','experiment')),
  experiment_id    char(64) REFERENCES sim.experiment,
  arm              text,
  created_at       timestamptz NOT NULL DEFAULT now(),
  CHECK (funnel_source <> 'experiment' OR (experiment_id IS NOT NULL AND arm IS NOT NULL))
);

CREATE TABLE fin.projection (                          -- UK-scaled monthly outputs per stream and entity
  scenario_id   text NOT NULL REFERENCES fin.scenario,
  month         date NOT NULL,
  sector_code   text NOT NULL REFERENCES ref.sector,
  route         text NOT NULL CHECK (route IN ('direct','agency')),
  stream        text NOT NULL CHECK (stream IN ('job_wave','ranking_promotion','handshake','consent','hire_fee','saas_seat','ad_hoc','data_collaboration')),
  entity        text NOT NULL CHECK (entity IN ('skibbit_ltd','vaultco','sector_vault')),
  amount_gbp    numeric(16,2) NOT NULL,
  hires         numeric(14,2) NOT NULL,
  ci_low_gbp    numeric(16,2),
  ci_high_gbp   numeric(16,2),
  PRIMARY KEY (scenario_id, month, sector_code, route, stream, entity)
);

CREATE TABLE fin.operating_cost (                      -- operating-cost input: the vault has to be run by people
  scenario_id   text NOT NULL REFERENCES fin.scenario,
  month         date NOT NULL,
  cost_line     text NOT NULL CHECK (cost_line IN ('operator_staff','company_checks','claim_rails','infrastructure','llm','audit')),
  driver        text NOT NULL,                       -- 'cases x minutes / productive hours', 'checks x unit price', ...
  quantity      numeric(14,2) NOT NULL,
  unit_cost_gbp numeric(12,2) NOT NULL,
  amount_gbp    numeric(16,2) NOT NULL,
  illustrative  boolean NOT NULL DEFAULT true,
  PRIMARY KEY (scenario_id, month, cost_line)
);

CREATE TABLE fin.reconciliation_result (
  checked_at     timestamptz NOT NULL DEFAULT now(),
  code_commit    char(40) NOT NULL,
  scenario_id    text NOT NULL REFERENCES fin.scenario,
  sheet          text NOT NULL,
  cell           text NOT NULL,
  expected       numeric NOT NULL,
  actual         numeric NOT NULL,
  tolerance_abs  numeric NOT NULL,
  pass           boolean NOT NULL,
  PRIMARY KEY (checked_at, scenario_id, sheet, cell)
);

---------------------------------------------------------------------------
-- rpt: scorecard results. The question interface and dashboards read only this schema.
---------------------------------------------------------------------------
CREATE TABLE rpt.measure_def (
  measure_id    text PRIMARY KEY,                      -- 'SC-01' .. 'SC-24'
  name          text NOT NULL,
  unit          text NOT NULL,
  definition    text NOT NULL,
  source_class  text NOT NULL CHECK (source_class IN ('log','truth','log+truth','financial','plan')),
  scorecard_version text NOT NULL
);

CREATE TABLE rpt.run_measure (
  run_id       uuid NOT NULL REFERENCES sim.run,
  measure_id   text NOT NULL REFERENCES rpt.measure_def,
  cut          jsonb NOT NULL DEFAULT '{}',            -- {"sector":"finance_insurance","pattern":"P4"}
  weighting    text NOT NULL CHECK (weighting IN ('weighted','unweighted')),
  value        numeric,
  n            integer NOT NULL,                       -- rows the measure rests on
  n_censored   integer NOT NULL DEFAULT 0,
  PRIMARY KEY (run_id, measure_id, cut, weighting)
);

CREATE TABLE rpt.experiment_measure (                  -- across replicates: mean and seed interval
  experiment_id char(64) NOT NULL REFERENCES sim.experiment,
  arm           text NOT NULL,
  measure_id    text NOT NULL REFERENCES rpt.measure_def,
  cut           jsonb NOT NULL DEFAULT '{}',
  weighting     text NOT NULL CHECK (weighting IN ('weighted','unweighted')),
  replicates    integer NOT NULL,
  mean          numeric,
  ci95_low      numeric,
  ci95_high     numeric,
  diff_vs_arm   text,                                  -- paired comparison arm (common random numbers)
  diff_mean     numeric,
  diff_ci95_low numeric,
  diff_ci95_high numeric,
  PRIMARY KEY (experiment_id, arm, measure_id, cut, weighting)
);

CREATE TABLE rpt.insight_evidence (                    -- moves register rows from Claim to Modelled
  register_row   text NOT NULL,                        -- 'I3', 'P1', 'B2'
  experiment_id  char(64) NOT NULL REFERENCES sim.experiment,
  arm            text NOT NULL,
  measure_id     text NOT NULL REFERENCES rpt.measure_def,
  direction_ok   boolean NOT NULL,
  ci_excludes_zero boolean NOT NULL,
  tiers_agree    boolean NOT NULL,
  stylised_facts_pass boolean NOT NULL,
  replay_verified boolean NOT NULL,
  proposed_status text NOT NULL CHECK (proposed_status IN ('Modelled','Not supported')),
  ratified       boolean NOT NULL DEFAULT false,
  PRIMARY KEY (register_row, experiment_id, arm, measure_id)
);

-- Example read-only view: the person-side funnel per arm, in Simon's event units and as conversion.
CREATE VIEW rpt.v_funnel_person AS
SELECT e.name AS experiment, m.arm, d.measure_id, d.name AS measure, m.cut, m.weighting,
       m.replicates, m.mean, m.ci95_low, m.ci95_high
FROM rpt.experiment_measure m
JOIN sim.experiment e ON e.experiment_id = m.experiment_id
JOIN rpt.measure_def d ON d.measure_id = m.measure_id
WHERE d.measure_id IN ('SC-06','SC-07');

-- Every scorecard result with its definition and experiment name: the main surface for questions.
CREATE VIEW rpt.v_measure AS
SELECT e.name AS experiment, e.version, m.arm, d.measure_id, d.name AS measure, d.unit, d.source_class,
       m.cut, m.weighting, m.replicates, m.mean, m.ci95_low, m.ci95_high,
       m.diff_vs_arm, m.diff_mean, m.diff_ci95_low, m.diff_ci95_high
FROM rpt.experiment_measure m
JOIN sim.experiment e ON e.experiment_id = m.experiment_id
JOIN rpt.measure_def d ON d.measure_id = m.measure_id;

-- The operator console's queue: no identities (none exist in vault state), no truth_label.
CREATE VIEW rpt.v_operator_queue AS
SELECT run_id, case_id, queue, subject_ref, opened_at, priority, sla_hours, sensitive, status,
       assigned_operator, second_approver, resolution, resolved_at,
       opened_at + make_interval(hours => sla_hours) AS sla_due_at
FROM sim.operator_case;

-- Financial projections by scenario, month, stream and entity.
CREATE VIEW rpt.v_projection AS
SELECT s.scenario_id, s.mode, s.fee_schedule_id, f.hire_fee_mode, f.ranking_promotion_enabled,
       s.route_split_direct_pct, p.month, p.sector_code, p.route, p.stream, p.entity,
       p.amount_gbp, p.hires, p.ci_low_gbp, p.ci_high_gbp
FROM fin.projection p
JOIN fin.scenario s ON s.scenario_id = p.scenario_id
JOIN fin.fee_schedule f ON f.fee_schedule_id = s.fee_schedule_id;

---------------------------------------------------------------------------
-- qi: every question asked, the SQL run, and what came back
---------------------------------------------------------------------------
CREATE TABLE qi.question_log (
  question_id     uuid PRIMARY KEY,
  asked_by        text NOT NULL,
  asked_at        timestamptz NOT NULL DEFAULT now(),
  question        text NOT NULL,
  model_id        text NOT NULL,
  prompt_version  text NOT NULL,
  semantic_layer_version text NOT NULL,
  generated_sql   text,
  ast_check       text NOT NULL CHECK (ast_check IN ('pass','refused','not_sql')),
  refusal_reason  text,
  rows_returned   integer,
  rows_total      integer,                             -- rows existing, so truncation is visible
  duration_ms     integer,
  answer          text,
  cost_usd        numeric(10,6)
);

---------------------------------------------------------------------------
-- Grants: the firewall in the database. td_vault cannot read truth; td_reader sees rpt only.
---------------------------------------------------------------------------
REVOKE ALL ON SCHEMA truth FROM PUBLIC;
-- The vault knows only what crossed: candidacies and briefs arrive as typed actions, never as table reads.
-- It reads reference data, the KYB-checked employer accounts and the signal catalogue; nothing about people.
GRANT USAGE ON SCHEMA meta, ref, jobs, sig, sim TO td_vault;
GRANT SELECT ON ALL TABLES IN SCHEMA meta, ref TO td_vault;
GRANT SELECT ON jobs.employer, sig.signal_def TO td_vault;
GRANT INSERT ON sim.receipt, sim.action, sim.message TO td_vault;
GRANT INSERT, UPDATE ON sim.operator_case TO td_vault;   -- only the single writer moves a case, and each move is a receipt

-- Agents act on the observable side: stated wants, CV, device-side signal observations, their own briefs.
-- Their self-knowledge of preferences arrives as a noisy self-view computed by the world module, never as truth rows.
GRANT USAGE ON SCHEMA meta, ref, pop, jobs, sig, sim TO td_agent;
GRANT SELECT ON ALL TABLES IN SCHEMA meta, ref, pop, jobs, sig TO td_agent;
GRANT INSERT ON sim.action, sim.message TO td_agent;

GRANT USAGE ON SCHEMA meta, ref, pop, jobs, truth, sig, sim TO td_world;
GRANT SELECT ON ALL TABLES IN SCHEMA meta, ref, pop, jobs, truth, sig TO td_world;
GRANT INSERT ON sim.world_event, sim.checkpoint TO td_world;

GRANT USAGE ON SCHEMA meta, ref, pop, jobs, truth, sig, sim, fin, rpt TO td_scorer;
GRANT SELECT ON ALL TABLES IN SCHEMA meta, ref, pop, jobs, truth, sig, sim, fin TO td_scorer;
GRANT INSERT ON ALL TABLES IN SCHEMA rpt, fin TO td_scorer;

-- Operators: the console reads a queue view with no identity and no truth columns, and acts only by
-- submitting typed actions to the single writer. No grant reaches scores, matches, receipts or truth.
GRANT USAGE ON SCHEMA rpt, sim TO td_operator;
GRANT SELECT ON rpt.v_operator_queue TO td_operator;
GRANT INSERT ON sim.action TO td_operator;

GRANT USAGE ON SCHEMA rpt TO td_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA rpt TO td_reader;
ALTER ROLE td_reader SET default_transaction_read_only = on;
ALTER ROLE td_reader SET statement_timeout = '10s';

COMMIT;

-- Per-run partitions are created by the engine at run start, for example:
--   CREATE TABLE sim.receipt_r_<run_hex> PARTITION OF sim.receipt FOR VALUES IN ('<run uuid>');
-- and dropped by retention (standard runs) after the scorecard and a Parquet archive are written.
