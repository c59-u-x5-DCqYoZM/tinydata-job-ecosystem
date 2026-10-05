---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-008: Question interface safety

**Status:** Proposed.

## Context

The brief: ask in plain English, get a table or chart "with the exact query shown so anyone can check it. Built on Claude over the ecosystem's database, read-only" [BR]. The research warns about silent truncation and pages that look complete [AE 2.6]. An LLM writing SQL can write a wrong query, an expensive query or, if allowed, a destructive one; authored text in the data could carry injected instructions.

## Decision

Defence in layers; each holds if the others fail.

1. **A reporting schema.** Claude sees only `rpt`: measure definitions, run and experiment measures, insight evidence, projections, as documented views. No prose, no messages, no truth rows, no receipts.
2. **One tool for data, `run_query(sql)`.** The SQL is parsed to a Postgres AST and refused unless it is a single `SELECT` (CTEs allowed, read-only), referencing only allowlisted `rpt` relations and allowlisted functions, with no system catalogues; a `LIMIT` is imposed.
3. **A read-only role.** Executed as `td_reader`: no grants outside `rpt`, `default_transaction_read_only = on`, `statement_timeout = 10s`, inside an explicit read-only transaction. Verified: the role is refused on `sim.*` and cannot insert.
4. **Honest answers.** The UI shows the SQL, rows returned against rows existing, the experiment and arm ids, each measure's source class, intervals, and the caveat that the data is synthetic and scenario-based.
5. **What-ifs are proposals.** A second tool, `propose_scenario`, returns an experiment-file diff or a reprice request for a person to run. Claude has no tool that starts a run or writes anything.
6. **Pinned model and prompt**, logged per question in `qi.question_log` with cost.
7. **An evaluation gate:** 100 questions with gold queries (including Soren's and Simon's examples, such as "which Finance & Insurance roles are hardest to fill?"); a prompt or model change ships only at 90% result equivalence or better [ASM-29]; safety tests (DDL, DML, catalogue access, multiple statements, long queries) must all be refused.

## Alternatives considered

- **Text-to-SQL over the whole database.** More expressive, but exposes truth and logs to accidental misreading, and makes questions slow. Rejected.
- **Pre-built dashboards only.** Safe but not what was asked. Kept alongside.
- **Let Claude run experiments.** Cost and reproducibility risk without a human decision. Rejected.

## Consequences

- Every answer is checkable by someone who reads SQL, and reproducible by re-running the query.
- New questions sometimes need a new `rpt` view; that is a reviewed change.
- Running cost is a few pence per question (ARCHITECTURE section 8).

## References

[BR] interfaces; [AE 2.7 lesson 4, pattern F].
