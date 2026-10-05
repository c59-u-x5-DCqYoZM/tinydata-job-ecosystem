---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-011: A vertical-agnostic core with vertical packs

**Status:** Proposed.

## Context

"we're gonna start with the job economy. or the job ecosystem with this, and then then jobs, and then we're going to look at travel, and then we're going to look at other other um, uh, verticals" [BR]. The careers PoC already runs travel and careers on the same services with one handshake state machine and careers-specific event names [POC README]. The danger is building jobs so deeply into the engine that travel is a rewrite.

## Decision

- **The core** owns: identities (`pop.individual`, `pop.producer`, `pop.opening`), releases and provenance, raking and validation, the truth and signal frameworks, the single-writer engine, receipts and chains, the agent interface and tape, the time engine, the scenario framework, the operator framework, the experiment harness, the scorecard framework, the financial engine, the question interface and the web shell.
- **A vertical pack** implements one interface (`VerticalPack`): reference loaders; extension tables in its own schema; truth and signal specifications; action vocabulary and Zod schemas; market designs, rules and stage maps; operator queue definitions; measures beyond the core set; fee schedule; scenario translation; onboarding page content; exporters.
- **Jobs is the first pack** (schema `jobs`). Travel adds schema `travel` and a pack; ARCHITECTURE section 2 lists what it replaces. Tick length is a pack parameter (monthly for jobs, likely daily for travel [ASM-26]).
- **A rule for every change:** if a change names a jobs concept in a core package, it belongs in the pack.

## Alternatives considered

- **Build jobs now, generalise later.** Faster for weeks, then a rewrite. Rejected.
- **Fully generic tables with JSON attributes.** Weak types and weak queries for the question interface. Rejected in favour of typed extension tables.

## Consequences

- A little more structure from M0; a dependency-cruiser rule keeps `vertical-jobs` out of core packages.
- Travel can reuse the harness, scorecard framework and financial engine.

## References

[BR]; [POC README, CAREERS.md].
