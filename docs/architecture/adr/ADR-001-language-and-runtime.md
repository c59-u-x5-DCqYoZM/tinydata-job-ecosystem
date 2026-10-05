---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-001: Language and runtime

**Status:** Proposed.

## Context

The brief asks for "TypeScript end to end, strict types, schemas validated at every boundary" [BR]. The careers PoC, which will read this ecosystem's data and whose receipts and scorer we must stay compatible with, is TypeScript on Node 20 or later with `strict`, `noUncheckedIndexedAccess`, Zod and Vitest [POC]. The ecosystem also needs numerical work that is usually done in Python: iterative proportional fitting, integerisation, maximum-likelihood fitting of a conditional logit, survival analysis, maximum-weight matching.

## Decision

- **TypeScript 5, strict, ESM, on Node 22 LTS**, npm workspaces (as careers), with the same compiler options as careers.
- **Zod at every boundary** (experiment files, actions, decisions, exports); JSON Schema is emitted from Zod for editors and for the careers contract check.
- **Numerics in TypeScript**, small and owned: raking, TRS integerisation, Newton-Raphson for the logit, Kaplan-Meier, the Hungarian algorithm, counter-based random streams. Each is verified against reference vectors computed once with standard Python statistical libraries and committed as fixtures. **Python never runs in production or in a run.**
- Packages: `core`, `db`, `engine`, `popsynth`, `agents`, `scorer`, `finance`, `qi`, `vertical-jobs`, and apps `api` (Fastify), `web` (React, Vite) and `cli`.

## Alternatives considered

- **Python for the simulation (Mesa, NumPy, statsmodels).** Stronger numerical libraries, but two languages for two engineers, duplicated contracts with careers, and a harder scorer-parity test. Rejected.
- **Python for population synthesis only.** Tempting, but releases would then be produced by a second toolchain whose determinism we would also have to prove. Rejected; the reference-vector approach gets the benefit without the cost.
- **Rust or Go for the engine.** Faster, but a rule-tier run is expected to take minutes in TypeScript [ASM-25]; speed is not the constraint.

## Consequences

- One language for contracts, engine, exporter and web. The careers scorer can be ported line for line and tested for parity.
- We own a few hundred lines of numerical code and must test it well.
- If a run becomes CPU-bound, the pair-scoring loop is the first candidate for a worker-thread pool or WebAssembly, behind the same interface.

## References

[BR] Interfaces and production grade; [POC] `tsconfig.base.json`, `package.json`, `match.ts`; [JEV 4] the logit is "microseconds per 1,000 pairs".
