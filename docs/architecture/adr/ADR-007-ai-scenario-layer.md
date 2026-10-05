---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-007: The AI-scenario layer

**Status:** Proposed.

## Context

Soren shared Anthropic's economic scenarios and asked to "model this economy on where it's going" [BR]. The brief turns that into three requirements: jobs as bundles of tasks tagged unchanged, augmented, automated or new; an AI-scenario layer with modest, substantial and extreme settings driven by the explorer's five inputs; displacement and career change as first-class intents [BR, AS]. The data track gives a translation per role, but the per-scenario input values sit in a technical report not yet read [LD 9.4].

## Decision

- **Tasks are reference data:** each role carries a time-weighted task list with tags and evidence (`ref.role_task`, `ref.task_exposure`), giving shares A_r (automated), G_r (augmented), U_r (unchanged), N_r (new) [LD 9.3].
- **A scenario is pure data:** the five inputs (capabilities, adoption by sector, autonomy, productivity, adjustment) with a monthly path to 2030. Presets modest, substantial, extreme; custom allowed.
- **The layer is a pure function** `(scenario, month, role) -> multipliers`, with no state, applied by the time engine at the start of each tick.
- **Translation** per [LD 9.4]: displacement share, augmentation saving partly re-absorbed by demand elasticity, net demand shift, adjustment time.
- **Effects** per [CH 2.4, 3.1, 3.7]: opening inflow; `CRIT-5` cancellations; entry-level demand; `ST-10` inflow; re-employment hazards and re-entry pay (`AI-1` to `AI-8`); the move premium (`BEH-12`); `SCR-12`; `NEW-1` to `NEW-3`; tag flips for `scenario_sensitive` tasks.
- **Calibration until the report is read:** presets scaled to the UK envelopes (TBI and Skills Imperative; IPPR central; IPPR worst) [ASM-13]. Labelled as Claude's proposal, not a sourced equivalence [LD 9.4].
- **Checks:** role ranking on A + G against DfE AIOE and ILO WP140 with rho of at least 0.6.
- **Headline measure:** time to the right next role (SC-17).

## Alternatives considered

- **Shock the population directly** (remove X% of jobs). Loses the mechanism (which tasks, which roles, which people) that makes scenario results explainable. Rejected.
- **Let LLM agents imagine the future.** Not reproducible, not grounded. Rejected.

## Consequences

- Scenario results can be explained role by role.
- Results are scenarios, not forecasts, and every page says so [AS].
- Reading Korinek et al. (2026) is a dependency for investor use of scenario numbers.

## References

[AS]; [LD 9]; [CH 2]; [AE 3.5] policy and AI-scenario shock variant.
