# TinyData job ecosystem

A synthetic, agent-populated mirror of the UK job market: an employer base and an individual base across three focus sectors (Professional & Business Services, Technology & Digital, Finance & Insurance), with a vault in the middle that enforces the rules. It is a research and modelling resource for TinyData, built to answer economic, hiring and career questions, and to model revenue on Simon Massey's revenue-plan levers.

It is the first of several vertical ecosystems: jobs first, then travel, then others.

## Status

**Architecture phase.** Nothing is built yet. The brief is in `docs/brief.md`; research lands in `docs/research/`; the architecture follows, for Soren's review before any build starts.

## What it will be (from the brief)

- **Population:** about 2,000 open jobs and about 5,000 synthetic people, statistically representative across the job functions in the three sectors, grounded in public UK data.
- **Engine:** the population is authored once with AI, a simulation engine runs it month by month, and live AI agents act on a sample.
- **Experiment harness:** market design, agent design and rules are interchangeable parts, and an AI-scenario layer (modest, substantial, extreme) runs over them. Every run reports the same measures.
- **Measures:** match percentage, time to match and fill, supply and demand ratio, contracts completed, funnels from both sides, event logs (vault receipts), and the financial output.
- **Interfaces:** business questions in plain English, reporting dashboards, financial modelling with scenarios, and onboarding pages for both sides.
- **Standard:** production code and investment-grade output. Every number carries its source or its scenario.

## Relationship to the main repository

The careers proof of concept in `c59-u-x5-DCqYoZM/Claude_Code_Skibbit` (`engineering/poc`) will read this ecosystem's data through its seed-source interface. This repository has its own codebase and no dependency on that one.

## Conventions

- Every commit carries a provenance trailer: `Source: ai`, `Source: irl` or `Source: mixed`.
- Soren's words are quoted verbatim, and interpretation goes in separate, dated sections.
- All people, employers and jobs are synthetic and flagged as such in the schema.
- UK English. No em dashes or en dashes.
