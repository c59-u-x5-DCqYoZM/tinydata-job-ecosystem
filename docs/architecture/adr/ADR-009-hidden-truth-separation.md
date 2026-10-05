---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-009: Hidden truth walled off from the vault and the agents

**Status:** Proposed.

## Context

The brief: "Synthetic people carry a hidden 'true' capability and way of working, of which their CV and their work data are noisy views, so we can measure which signals recover the truth" [BR]. Shoehorning, fit over time and signal value all need a truth to score against. If the vault or the agents could read it, every result would be contaminated, and the ecosystem would not rehearse the real product's firewall (the vault holds intents and inferences only).

## Decision

- **Four compartments:** world (truth, time engine, outcomes), agents (observable side), vault (only what crossed), scorer (joins truth and log after the run).
- **Enforced twice.** In code: dependency rules forbid vault and agent modules from importing truth modules. In the database: separate roles; `td_vault` has no grant on `truth`, `jobs.person`, `jobs.cv` or `sig.observation`, and builds its state only from actions (verified).
- **Agents get a self-view:** the world module computes a noisy view of the principal's preferences, way of working and capability (with group-specific confidence bias), never the truth rows [ASM-06].
- **Two chains:** the market log (what crossed) and the world log (what really happened), each hash-chained.
- **The true-fit function is non-linear with interactions**, so a linear model in the vault cannot recover it by construction (anti-circularity) [ASM-04].
- **Protected characteristics** live in `truth.person_protected` and are used only by the fairness measure.

## Alternatives considered

- **One state object, discipline by convention.** Fast to build; one stray import contaminates every result. Rejected.
- **No truth, only observable data.** Then signal value and shoehorning cannot be measured at all. Rejected.

## Consequences

- Signal value, shoehorning, fit and tenure become measurable (SC-11 to SC-17).
- The ecosystem demonstrates the firewall in a way counsel can inspect.
- Slight engine complexity: truth-dependent outcomes (interview performance, satisfaction) are computed by the world step and arrive in the market as engine events.

## References

[BR] signals and fit; [JEV 5.4, 5.6]; ARCHITECTURE L3, L4, section 3.
