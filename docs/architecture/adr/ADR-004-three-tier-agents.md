---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-004: Three agent tiers behind one decision interface

**Status:** Proposed.

## Context

The approved design has "live agents on a sample of 50 to 100" over a simulation engine [BR decisions]. Soren wants to understand "how are these agents kind of working within this how are they structured" [BR]. The research shows LLM archetypes per stratum beat both pure-LLM and heuristic agents at forecasting unemployment (AgentTorch), and that LLM agents can be replaced by fitted surrogates for a few dollars [AE 4.2]. It also warns that plausible is not valid and that retired models break replays [AE risks 1 and 2].

## Decision

- **One interface:** `DecisionPolicy.decide(request) -> result`, with a closed set of decision kinds, each with a Zod result schema. The engine does not know which tier answered.
- **Rule tier** for everyone: calibrated hazards and logit surrogates from [CH].
- **Archetype tier** per stratum and decision kind: a pinned model sampled a few dozen times with persona variation; the engine samples from the recorded distribution; a surrogate is fitted to it.
- **Live tier** for 50 to 100 agents: full agents with principals, memory design, tools and budgets, communicating through the market design's channels.
- **Typed outputs:** LLMs answer through a tool whose JSON Schema is the decision schema; an invalid answer is retried once, then the rule tier decides and the miss is counted.
- **Decision tape:** every call keyed by sha256(model id, prompt version, schema version, state hash, sample index) and stored; replay reads the tape and only a new key calls a model.
- **Agent manifests and typed messages are data** (`sim.agent_manifest`, `sim.message`), frozen per run.
- **Agents see a self-view, not truth** (ADR-009).
- **Headline numbers come from the calibrated engine;** live behaviour is reported as a measured perturbation, through the fidelity ladder.

## Alternatives considered

- **All agents live.** About $132 to $528 per live run for 100 agents [AE 4.2]; 5,000 or more would be one to two orders of magnitude more, unreplayable without a tape, and still not valid. Rejected.
- **No LLM agents.** Cheap and clean, but cannot surface behaviour the rules miss or test manipulation. Rejected.
- **A different interface per tier.** Would let tier differences leak into the engine. Rejected.

## Consequences

- Any run is reproducible after a model is retired.
- The fidelity ladder can say which measures need LLMs at all.
- The tape stores prompts and responses, so storage grows with live runs; tape rows are shared across runs by key.

## References

[AE 3.6, 3.7, 3.10, 4.2, 4.3]; [CH 1.5, 6].
