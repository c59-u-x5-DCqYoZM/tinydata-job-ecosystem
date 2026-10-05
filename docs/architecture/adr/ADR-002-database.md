---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-002: Database

**Status:** Proposed.

## Context

Soren asked for "real database layers" [BR]. The ecosystem holds reference data, versioned populations, hidden truth that some components must never read, per-run logs in the millions of rows, financial outputs and a reporting surface that an LLM will query. The careers PoC uses SQLite with append-only triggers [POC `001-init.sql`]. The brief names Postgres [BR].

## Decision

**PostgreSQL 16, managed, in a UK or EU region [ASM-22].** The schema is in `../schema.sql` and was executed and tested on PostgreSQL 16.

- **Schemas are compartments:** `meta`, `ref`, `pop`, `jobs`, `truth`, `sig`, `sim`, `fin`, `rpt`, `qi`.
- **Roles are the firewall:** `td_world` (reads truth), `td_vault` (reads reference data, employer accounts and the signal catalogue; nothing about people), `td_agent` (the observable side), `td_operator` (only the operator queue view; acts by inserting actions), `td_scorer` (joins truth and log after a run), `td_reader` (only `rpt`, read-only by default, ten-second statement timeout). Verified: the vault role is refused on `truth.*` and `jobs.person`; the reader is refused on `sim.*`.
- **Append-only by trigger** on actions, receipts, world events, and no deletes on operator cases, as careers does for its audit rail.
- **List partitions per run** on the high-volume tables; retention drops a run's partitions after its scorecard and Parquet archive are written.
- **Constraints carry rules:** `CHECK (synthetic)`; the candidate pays £0; a refusal receipt names its rule; a sensitive operator case cannot be resolved by one person.
- **Kysely** for typed queries; **DuckDB** for analysis over Parquet archives.

## Alternatives considered

- **SQLite, as careers.** Simple, but no roles or grants, so the firewall would live in code only; weak concurrency for parallel runs. Rejected.
- **A columnar store (ClickHouse, DuckDB) as primary.** Excellent for scorecards, weak for constraints, roles and transactional engine writes. Kept as the analysis layer.
- **An event store (EventStoreDB, Kafka).** The log is per run and finite; Postgres with hash chaining gives the guarantees we need without a second system. Rejected.

## Consequences

- The firewall can be demonstrated in the database, not only asserted in code.
- Partition management is engine responsibility; foreign keys into partitioned receipt tables require ledger rows to be removed before a partition is dropped.
- A managed instance is a running cost from M0.

## References

[BR] Production grade; [AE 3.1] Magentic Marketplace's Postgres `agents`, `actions`, `logs` tables; [AE 3.5] AgentSociety's columnar replay; [POC] the careers audit rail triggers.
