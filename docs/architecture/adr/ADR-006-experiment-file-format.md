---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-006: The experiment file format

**Status:** Proposed.

## Context

Soren: "I wonder if we need to run multiple of these simulations. And then and then look for different insights for each one" [BR]. The requirement is interchangeable population, market design, agent design and rules, plus the AI-scenario layer, with every run reporting the same measures [BR]. Investment grade means any number can be traced to the exact configuration that produced it.

## Decision

- **YAML** for people to write and review; **validated by Zod**; **canonicalised** to JSON (sorted keys); the sha256 of the canonical JSON is the `experiment_id`. Same content, same id; one changed character, new id.
- **Top-level parts:** `question` (the hypothesis in words), `population` (five release ids), `horizon` (start, months, warm-up), `seeds` (base, replicates, common random numbers), `base` (market design, agent design, rules, operators, scenario, economics), `arms` (named overrides on the base), `scorecard` (version), `receipts` (level), `budget`, `pins` (exact model ids).
- **Arms as overrides** make every comparison paired. **Common random numbers:** the same replicate index uses the same seed and the same keyed random streams in every arm.
- **Counter-based random streams** keyed by (seed, stream, entity, tick), so a new random draw in one module never shifts another's.
- **Defaults:** 20 replicates [ASM-23], 6 warm-up months, 24 measured months.
- **A run** is (experiment id, arm, replicate) plus the resolved releases, commit, schema version and pins, stored in `sim.run`.
- **The CLI** (`td run <file>`) estimates cost and duration, refuses to start over budget, and prints the run ids.

## Alternatives considered

- **Code as configuration (TypeScript files).** Flexible but not reviewable by Soren or Simon, and hard to hash meaningfully. Rejected.
- **Database rows only.** Hard to diff and review in pull requests. The YAML is stored in the database too (`spec_yaml`), so both needs are met.
- **Independent seeds per arm.** Simpler, but differences between arms then need far more replicates. Rejected.

## Consequences

- Every chart and question-interface answer can cite an experiment id and arm.
- Experiments are reviewed like code.
- Changing a default in code does not change an old experiment's meaning, because releases and the scorecard version are pinned in the file.

## References

[BR] experiment harness; [AE 1, pattern 4; 4.2 repeatability rules; 5]; [LD 12] seed stability.
