---
source: ai
ratified: false
date: 2026-10-05
---

# Build plan: the first deliverable (release 1.0)

**Companion to** [`ARCHITECTURE.md`](./ARCHITECTURE.md). **Status:** proposed; nothing starts before Soren reviews the architecture [BR].

## Sizing basis

- **Two engineers** (M and P) working with coding agents [ASM-15]. "ew" is engineer-weeks; "weeks" are calendar weeks with both working.
- Estimates are Claude's [E], from the scope of each layer; they will be re-sized at the end of M0.
- **Order rule:** the rule tier first, with no LLM cost (economics baseline, today's market, the vault), then signals, then agents, then scenarios, as the agent-environments research recommends [AE 5]. Every milestone ends with something Soren and Simon can see.
- **QA gate:** every milestone passes `qa-reviewer` before `project-manager` marks it done; financial milestones also pass `cfo` and `investment-lead` [BR].

## Summary

| Milestone | What | ew | Weeks | Ends at week |
|---|---|---|---|---|
| M0 | Foundations: repo, CI, database, receipts, random streams | 2 | 1 | 1 |
| M1 | Reference data and taxonomy | 4 | 2 | 3 |
| M2 | Population release 1, validation, browsable page, careers export | 6 | 3 | 6 |
| M3 | Engine, vault and operators at rule tier; three arms | 6 | 3 | 9 |
| M4 | Scorecard, financial model with reconciliation, dashboards | 5 | 2.5 | 11.5 |
| M5 | Signals, truth experiments, the conditional logit | 4 | 2 | 13.5 |
| M6 | Agents: archetypes, live sample, tape, budgets | 5 | 2.5 | 16 |
| M7 | AI-scenario layer | 3 | 1.5 | 17.5 |
| M8 | Question interface, scenario planning, operator console view | 4 | 2 | 19.5 |
| M9 | Onboarding pages for both sides | 3 | 1.5 | 21 |
| M10 | Investment-grade pack and release 1.0 | 2 | 1 | 22 |
| **Total** | | **44** | **about 22** | |

Done strictly in order, release 1.0 lands in about 22 weeks; overlapping M7 with M6 and M9 with M8 where people are free may save two or three. **The core credible cut is M0 to M4 (about 11 to 12 weeks):** a validated population, three market designs running, the full scorecard, and Simon's plan reproduced and then re-run on modelled funnels. M5 to M10 complete release 1.0.

---

## M0. Foundations (2 ew, week 1)

**Build:** monorepo (`core`, `db`, `engine`, `popsynth`, `agents`, `scorer`, `finance`, `qi`, `vertical-jobs`, apps `api`, `web`, `cli`); strict TypeScript as careers; Vitest; GitHub Actions with a Postgres 16 service; migrations runner; migration 0001 from `schema.sql`; Kysely types; canonical JSON and hashing; receipt chain library with the careers projection; counter-based random streams; the `VerticalPack` interface; dependency rules (vault and agents cannot import truth; core cannot import `vertical-jobs`).

**Acceptance tests:**
1. `npm test` green in CI on a clean clone.
2. Receipt compatibility: the ADR-003 vector reproduces (`payload_digest 304e90c2...`, `receipt_hash 145090d1...`), and a projected receipt validates against the vendored careers `AuditEvent` schema.
3. Database firewall tests pass: vault role refused on `truth` and `jobs.person`; reader refused on `sim`; operator refused on case truth labels and receipts; append-only and two-person constraints hold.
4. Random streams: adding a draw to stream A leaves stream B's sequence unchanged.

**What Soren and Simon see:** a one-page "receipt verifier" output: a toy chain built, verified, tampered, and the tamper caught.

## M1. Reference data and taxonomy (4 ew, weeks 2 to 3)

**Build:** loaders for APS 3136, JOBS02, BRES, VACS02 and X06 (by section), ASHE 14 and 15, Textkernel SOC adverts, Occupations in Demand 2025, ESS 2024, LFS X02, ONS hybrid working, O*NET 31.0, ESCO v1.2, the Economic Index, DfE AIOE, ILO WP140 [LD 14]; the function mapping (412 SOC units x 3 sectors with split weights); task bundles and exposure tags; marginal targets with held-out flags; `meta.parameter` loaded from [CH] and [SP] with ids, confidence and sources. Releases `ref-2026.10.0` and `par-2026.10.0`.

**Acceptance tests:**
1. Every source in [LD 14] used by the frame is in `meta.source` with licence, access date and evidence mark; every file checksummed.
2. Every [E] share in [LD 10] is replaced by a computed share or explicitly kept as E with a range.
3. Function mapping: every SOC unit in the three sectors' frame is mapped; weights per SOC sum to 1.
4. Task bundles: time shares per role sum to 1; the A + G role ranking against DfE AIOE gives rho of at least 0.6, or the disagreements are listed.
5. The VACS02 three-sector vacancy share replaces ASM-01, and the sampling fraction is recomputed.

**What Soren and Simon see:** the function table per sector with real shares and sources (a spreadsheet), and two decisions for Simon: the PBS definition (all of M and N, or the knowledge-work core) and what his hire volumes count [LD 2].

## M2. Population release 1 (6 ew, weeks 4 to 6)

**Build:** raking and TRS integerisation; hierarchical frame; jobs (about 2,000 open), employers and agencies (about 200), people at the same sampling fraction (structured) with 5,000 profiled; hidden truth; structured CVs from the CV noise parameters; signal observations; batch-authored CV prose and briefs for the profiled tier (pinned model, tape keys stored); the release-gate validation suite; release `pop-2026.10.0`; spreadsheet and CSV export; the browsable population page; the careers seed exporter; the first research readout.

**Acceptance tests:**
1. Release-gate validation [LD 12]: weighted TVD at most 0.02 on one-way marginals; SRMSE at most 0.1 on two-way tables; ASHE deciles within 5%; held-out rank correlation at least 0.8; seed stability CV at most 5% over 20 seeds; effective sample size reported per cell.
2. Every row `synthetic = true`; every domain ends in `.example`; no synthetic employer name matches the real-company list.
3. Floors met: at least 20 jobs and 30 profiled people per sector x function cell.
4. Careers bridge: `jsonDirCareersSeedSource(<export>)` in the careers repository loads employers, briefs, the claim register and every persona with zero schema errors; the export report counts functions not exported for lack of a careers role family.
5. Authoring cost within 20% of the estimate (about $100 batched on Sonnet 5.5 [ASM-11]).

**What Soren and Simon see:** the browsable page (filter by sector, role and hiring pattern; open a profile, its CV and what the CV misses), and **the first research readout**: critical, fast, scarce and always-hiring roles per sector, and the most common and least-served intents, each number tagged with its source and marked synthetic. This is the brief's original first deliverable [BR].

## M3. Engine, vault and operators at rule tier (6 ew, weeks 7 to 9)

**Build:** the single-writer engine (two-phase sub-steps, ordering, validators, receipts, checkpoints); the time engine (monthly ticks, weekly sub-steps, arrivals, exits, transitions, triggers, promotions, satisfaction and quits, backfills); rule-tier agents from [CH]; market designs `careers-vault-v1` (with `scorer-v0` and the parity test), `today-market-v1` and `dmp-baseline-v1` with stage maps; operator queues at rule tier (company checks, flagged briefs with triage precision and recall, failed claims, disputed outcomes, data requests, incidents) with the two-person rule and backlog feedback; the experiment file, CLI, runs table and partitions; the invariant checker.

**Acceptance tests:**
1. **Replay determinism:** a 24-month E2 run replayed from its seed gives identical final receipt and world hashes.
2. **Scorer parity** with careers `scoreCareersFeatures` on 1,000 shared vectors, to the hundredth.
3. **Careers attacks reproduced as refusals:** skip-confirm, fabricated claim, current employer, over-scope reveal, tampered certificate; plus an operator acting alone on a sensitive case and an operator action carrying a score field. All refused with a named rule; invariant checker finds zero breaches.
4. **Stylised facts:** E0 matching-function elasticity on unemployment in 0.5 to 0.7; a Beveridge curve; baseline open stock within 5% of 2,000; time to fill by pattern within the [CH 3.2] ranges.
5. **Performance:** a 24-month rule-tier run in under 5 minutes on one core; 20 seeds of three arms in under 30 minutes on 8 cores [ASM-25].

**What Soren and Simon see:** the first arm comparison (economics baseline, today's market, the vault) on a handful of measures with seed intervals, and the event log of one vault run with a working "verify chain" button.

## M4. Scorecard, financial model, dashboards (5 ew, weeks 10 to 11.5)

**Build:** all 25 scorecard measures with toy-log tests; `rpt` population and experiment aggregation with paired differences; the financial model in plan mode (workbook cells loaded) and ecosystem mode; the operating-cost line from SC-25; reprice on existing ledgers; standing dashboards (funnels both sides against 100 / 40 / 40 / 20 / 1, feeder funnels, supply and demand, time to fill, operator queues, financials); XLSX export laid out beside Simon's plan; the one-page run readout.

**Acceptance tests:**
1. **Reconciliation:** plan mode reproduces every output cell of Simon's workbook (per-hire exact; totals within £1 [ASM-28]); the anchors £2,390, £910, £6,475, £6,845, £12.62m, £9.77m and £22.4m appear exactly; the test fails if any input changes without the expected output change. *Depends on the workbook export (open question 2).*
2. Ecosystem mode on E2 produces revenue by stream with intervals carried from the seed intervals of the modelled funnel.
3. Every measure's toy-log test passes; every dashboard number shows its source class, run ids, replicates and interval; every table shows rows returned against rows existing.
4. Reprice of a fee change on an existing run finishes in under 2 seconds and changes no non-financial measure.

**What Simon sees:** his plan reproduced to the pound, then the same plan with the funnel the vault arm actually produced, side by side, flat and percentage fee modes, promotion on and off, with operating cost and contribution. **Simon gets read-only access from here.**

## M5. Signals, truth experiments and the logit (4 ew, weeks 12 to 13.5)

**Build:** the signal catalogue release; signal-set rules; E3 and E3b; shoehorning, fit, tenure, oracle and signal-value measures exercised in full; `logit-v1` fitting with held-out labels and the independence-of-irrelevant-alternatives test; the insight-evidence table.

**Acceptance tests:**
1. E3 signal-value table with seed intervals for S0 to S5; per-signal leave-one-out values.
2. `logit-v1` meets the [JEV 7] criteria against `scorer-v0` on the held-out truth labels (ECE at most 0.05; 100% determinism and recompute from the log).
3. At least the candidate rows I3, I4, I5, I8 and P1 have an `rpt.insight_evidence` entry (supported or not) for Soren to ratify.

**What Soren sees:** which signals find who can really do the job, what they cost the person, and how much shoehorning the vault removes.

## M6. Agents: archetypes and the live sample (5 ew, weeks 14 to 16)

**Build:** archetype elicitation (Batch API), surrogates; the live tier for 50 to 100 profiled agents; decision tape; model pins; budget estimator and hard stop; the fidelity ladder on E2; the sensitivity arm; E4 (adversarial) and E5 (capability mix) at first scale.

**Acceptance tests:**
1. A live run replays from the tape with **zero** API calls and identical final hashes.
2. Actual cost within 20% of the pre-run estimate; the budget stop halts a deliberately underfunded run cleanly.
3. Injection and impersonation attempts succeed against code-enforced rules zero times (SC-21).
4. Fidelity ladder report: which measures differ between tiers beyond seed noise.

**What Soren sees:** the agent-to-agent economy observable: manifests, typed messages, cost of talk, where rules hold and where agents behave in ways the rules missed.

## M7. AI-scenario layer (3 ew, weeks 16.5 to 17.5)

**Build:** scenario presets and the pure scenario function; task-tag flips; E7 (today's market and the vault under baseline, modest, substantial, extreme).

**Acceptance tests:**
1. Displacement under each preset falls inside its calibration envelope [ASM-13].
2. SC-17 (time to the right next role) reported by age band and scenario.
3. Every scenario page carries "scenario, not forecast" and the preset's provenance.

**What Soren sees:** how volume, time to the right next role and cost per hire move as AI changes the three sectors.

## M8. Question interface, scenario planning, operator console view (4 ew, weeks 18 to 19.5)

**Build:** the semantic layer; `run_query` with AST checks; `propose_scenario`; question log; the 100-question evaluation set; the scenario planning page (levers marked reprice or rerun, named scenarios, compare four, base, low and high, tornado); the operator console view of a run (queues, SLAs, two-person approvals, case receipts), aligned with the operator prototype screen.

**Acceptance tests:**
1. Evaluation: at least 90% result equivalence on the 100 gold questions.
2. Safety: DDL, DML, catalogue access, multiple statements and long queries all refused; nothing outside `rpt` readable.
3. Soren asks ten questions of his own in a live session and each answer shows its SQL and row counts.
4. The operator console shows no identity and no truth field (automated check over rendered pages).

**What Soren sees:** "which Finance & Insurance roles are hardest to fill?" answered with the query shown; "what does a flat £1,850 fee do to year-3 revenue?" turned into a reprice he can run.

## M9. Onboarding pages for both sides (3 ew, weeks 20 to 21)

**Build:** individual onboarding (synthetic persona, findings, confirm, wants, where you stand) and employer onboarding (company check, structured brief, the market for this role, cost per hire against the agency route), on live ecosystem numbers with sources.

**Acceptance tests:**
1. Both pages work on a phone (no horizontal scroll at 390 px) and pass an accessibility check.
2. Every number on them links to its measure and run.
3. A walkthrough with Soren on each page; `product-designer` and `design-principal` taste pass.

## M10. Investment-grade pack and release 1.0 (2 ew, week 22)

**Build:** methods note; sensitivity on the five biggest levers; base, low and high; the readout pack; published releases; access for Kingston and the wider team.

**Acceptance tests:**
1. No number in the pack without its source or its scenario; every one traces to a pinned, replayable run.
2. `cfo`, `investment-lead` and `qa-reviewer` sign off.
3. All [unverified] figures used in the pack checked against primary sources [CH, LD].

---

## Dependencies and risks to the plan

| Dependency | Needed by | If late |
|---|---|---|
| Soren's approval of ADR-010 (population scale) | M2 | Build the fallback (5,000 plus background pool); costs about a week to switch later |
| Simon's workbook cell export and definitions | M4 | Reconciliation runs on the headline anchors only; the cell-level test waits |
| VACS02 by section | M1 | ASM-01 stays; sampling fraction flagged |
| Korinek et al. scenario inputs | M7 | Presets stay calibrated to UK envelopes and labelled as such |
| Live-agent budget approval | M6 | E4 and E5 run at rule tier only |
| Operations owner for queue parameters | M3 | Illustrative parameters, labelled |
