---
source: ai
ratified: false
date: 2026-10-05
---

# Architecture decision records

Each record is **Proposed** until Soren ratifies it. Format: context, decision, alternatives considered, consequences, assumptions, references. Tags such as [LD] and [ASM-nn] are defined in `../ARCHITECTURE.md`.

| ADR | Decision | Status |
|---|---|---|
| [001](./ADR-001-language-and-runtime.md) | TypeScript on Node 22, strict, matching the careers PoC | Proposed |
| [002](./ADR-002-database.md) | PostgreSQL 16 with schemas as compartments and roles as the firewall | Proposed |
| [003](./ADR-003-single-writer-event-log-and-receipts.md) | One writer, typed actions, a chained market log in the careers receipt format | Proposed |
| [004](./ADR-004-three-tier-agents.md) | Three agent tiers behind one decision interface, with a decision tape | Proposed |
| [005](./ADR-005-vault-decisions-as-calibrated-choice-model.md) | Vault matching as a calibrated conditional logit, after a careers-parity scorer | Proposed |
| [006](./ADR-006-experiment-file-format.md) | Content-addressed YAML experiment files with arms, seeds and common random numbers | Proposed |
| [007](./ADR-007-ai-scenario-layer.md) | AI scenarios as a pure function over task bundles | Proposed |
| [008](./ADR-008-question-interface-safety.md) | Claude writes checked, read-only SQL over a reporting schema; never starts runs | Proposed |
| [009](./ADR-009-hidden-truth-separation.md) | Hidden truth walled off from the vault and the agents | Proposed |
| [010](./ADR-010-population-scale.md) | One sampling fraction for people and jobs; 5,000 profiled people | Proposed, needs Soren |
| [011](./ADR-011-vertical-pack-boundary.md) | A vertical-agnostic core with vertical packs | Proposed |
| [012](./ADR-012-releases-migrations-and-operator-console.md) | Versioned data releases, forward-only migrations, and the operator console rules | Proposed |
