---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-012: Versioned data releases, forward-only migrations, and the operator console rules

**Status:** Proposed.

## Context

Investment grade needs every number traceable to the data it was computed on [BR]. Soren added: "we probablky need a vault operator console". The direction that came with it: operators never see identities, cannot change scores or matches, every operator action is a receipted event, two-person approval for sensitive actions, and the workload is modelled as part of the simulation, on the scorecard and as an operating cost. A prototype screen is being built separately (`prototype/three-sides-careers/operator.html` in the main repository).

## Decision: releases and migrations

- **Releases** of kinds `reference`, `parameters`, `population`, `signals`, `decision_model`; ids `<kind>-<YYYY.MM>.<patch>`; immutable once published (the release id is in every release-scoped primary key); a manifest with content hash, generator commit and seed, parent and validation report; lifecycle draft, validated, published, withdrawn. Runs pin all releases.
- **Migrations** in plain SQL, forward-only, numbered, checksummed, transactional; expand then contract; no down-migrations (restore instead); `sim.run.schema_version` on every run; CI applies all migrations to an empty database and to the last release snapshot, then runs grant and constraint tests.

## Decision: the operator console

- **Ten queues:** company checks, flagged briefs (including fake jobs), failed claims, disputed outcomes, data requests, incidents, auditor access, rules and model health, record integrity, fees (ARCHITECTURE L6).
- **Never identities.** The console reads `rpt.v_operator_queue`, which has no identity and no truth column; vault state holds code names only.
- **Never scores or matches.** No operator action type can carry a score, rank or match field (policing test). Rule and decision-model changes are new releases with two-person approval, never edits.
- **Everything receipted.** Operator actions are typed actions through the single writer; receipts carry `operator_id` and `approver_id`; the schema refuses an `operator.*` receipt without an operator.
- **Two-person rule.** Sensitive actions (override a failed check, suspend an account, reverse a claim failure, void a certificate, erasure, containment that blocks a producer, every auditor grant, deploying a rules or model release, any attestation, any fee credit) need a second, different operator. Enforced by the engine and by a table constraint (verified on PostgreSQL 16).
- **Simulated workload.** Operators are agents; cases arrive from market events; service times, headcount and SLAs are market-design parameters [ASM-27]; backlogs feed back into the market; SC-25 reports queue health, triage precision and recall against truth, and operating cost per hire; `fin.operating_cost` takes it into the financial model.

## Alternatives considered

- **Mutable reference tables.** Simpler, but old runs would silently change meaning. Rejected.
- **Operators outside the simulation.** Would hide a real cost and a real bottleneck. Rejected.
- **Two-person rule by policy only.** Unverifiable. Rejected in favour of code plus constraint.

## Consequences

- A run from any month can be replayed on exactly its data.
- The operator console concept is tested in the ecosystem before the real one is built; the queue names and sensitive-action list are shared with the prototype screen.
- Careers needs an additive `operator` actor for full receipt compatibility.

## References

[BR]; [LD 12]; [AE 2.3] the maintainer's public, logged reasons; Soren's addition, 5 October 2026.
