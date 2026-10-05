---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-003: Single writer, typed actions, and a chained market log compatible with the careers vault

**Status:** Proposed.

## Context

The brief requires every event to write a vault receipt "in the same format the careers code uses (the event, the time and a fingerprint)" so the ecosystem "can be audited like the real vault" [BR]. The research recommends one writer, typed actions and an append-only, hash-chained log with an outside witness [AE patterns A and C]. Reading the careers code shows its audit rail is **append-only with a payload digest, but not hash-chained**: each `AuditEvent` has `id`, `at`, `actor`, `boundary`, `event_type`, `schema_ref`, `consent_ref`, `handle` and `payload_digest = sha256(JSON.stringify(payload))` [POC `audit.ts`, `interfaces.ts`, `handle.ts`].

## Decision

1. **Agents and operators never write state.** They submit typed actions (Zod schemas). One engine per run applies them in a deterministic order: sub-step, then priority class, then a seeded shuffle key.
2. **Rules are validators** on the action protocol. Each returns ok or a refusal naming the rule (`VR-01` ...).
3. **Every applied, refused or engine-originated event writes a receipt** in `sim.receipt`:
   - **Careers fields, unchanged in meaning:** `seq` (careers `id`), `at` (simulated time), `actor` (`skibbit_device` for the individual side, `registry` for the vault, `producer_mcp` for employers and agencies, `system` for the engine and operators), `boundary`, `event_type` (`area.verb`, careers names reused), `schema_ref`, `consent_ref`, `handle`, `payload_digest` computed **exactly** as careers `sha256Json`.
   - **Extension, dropped by the careers projection:** `tick`, `substep`, `action_id`, `agent_id`, `outcome`, `rule_id`, `operator_id`, `approver_id`, `payload` (stored, because everything is synthetic), `digest_alg`, `prev_hash`, `receipt_hash`.
   - **Chain:** `receipt_hash = sha256(canonical JSON of {run_id, seq, at, actor, boundary, event_type, schema_ref, consent_ref, handle, payload_digest, tick, substep, outcome, rule_id, prev_hash})`, keys sorted, no whitespace; `prev_hash` of the first receipt is 64 zeros.
4. **A second chain** (`sim.world_event`) records hidden-truth events, which the vault never reads (ADR-009).
5. **Monthly checkpoints** of both chain heads and the state hash; for pinned runs, heads are also written to a witness store outside the database.
6. **Receipt levels:** `full` (a receipt per scored pair, as careers) and `presented` (receipts for presented pairs and gates, plus a per-sub-step Merkle root of all pair scores) [ASM-25].

## Compatibility test vector

Computed with the careers code's own `sha256Json` (`engineering/poc/packages/shared/src/handle.ts`) and with the ecosystem's canonical encoder:

| Item | Value |
|---|---|
| payload | `{"brief":"BR-201","account":"acct-kestrel"}` |
| `payload_digest` (careers `sha256Json`) | `304e90c244a175c5e7274549ec2bcb3142fdd1d4a3dddc280e0a263abd5a2bc6` |
| receipt core | run `00000000-0000-0000-0000-000000000001`, seq 1, at `2026-11-02T09:00:00Z`, `producer_mcp`, `producer_to_registry`, `brief.placed`, schema `eco-0.1/careers/BriefPlaceRequest`, consent and handle null, tick 0, substep 0, applied, no rule, prev 64 zeros |
| `receipt_hash` | `145090d19f963088afb176be564dc6d06903498068ec7b84ffba2f1e1cbcbfdb` |

Both values are CI fixtures.

## Alternatives considered

- **Copy the careers rail exactly (no chain).** Compatible, but an investor's analyst could not check that nothing was removed or reordered. Rejected; the chain is an extension, not a change.
- **Canonical JSON for `payload_digest` too.** Safer (`JSON.stringify` depends on key order), but it would break byte compatibility with careers. Instead, payloads are built by typed constructors with fixed key order, `digest_alg` records the method, and we propose that careers adopt canonical JSON in a future contract version.
- **An LLM game master adjudicating rules** (Concordia style). Wrong place for rules with legal weight [AE 3.4]. Rejected; an adjudicator is allowed only for fuzzy outcomes, as an experiment arm.

## Consequences

- Every measure, every fee and every operator action is recomputable from the log.
- A careers verifier can re-derive every projected receipt's digest.
- The engine is single-threaded per run; parallelism is across runs.
- Careers has no `operator` actor; operator events project to `system` until careers adds one (open question 9).

## References

[AE 2.3, 3.1, 3.3, 4.1]; [POC] `audit.ts`, `vault.ts` event names, `001-init.sql` triggers.
