---
source: ai
ratified: false
date: 2026-10-05
---

# Agent environments: how multi-agent simulations work, and what the TinyData job ecosystem should take from them

**Track:** architecture phase, research track 1 of 3 (see `product/job-ecosystem/2026-10-05-synthetic-job-ecosystem-brief.md`).
**Ask (Soren, 5 Oct 2026, verbatim extracts):** "Look at the one F um, one, one F repository where all the agents were brought together and how they communicated the rules were made, et cetera." And: "I wonder if we need to run multiple of these simulations. And then and then look for different insights for each one because in the end we're building an agent-to-agent economy so we want to understand how are these agents kind of working within this how are they structured kind of all those all those different uh, all those different pieces right".
**Reader:** `engineering-architect`, then Soren.

**Status of 1F916 material.** Soren invoked 1F916 for this research. Under the standing rule from the 20 August backout (invocation is not ratification), everything this document says about 1F916, and every pattern it derives from 1F916, is **consultative input, unratified**. 1F916 is one example to learn from, not the template (Soren, 5 Oct). Patterns marked "adopt" below are recommendations for the architecture, awaiting Soren's ratification; none of 1F916's vocabulary is proposed as TinyData vocabulary.

## How to read the evidence marks

| Mark | Meaning |
|---|---|
| **[P]** | Read in the primary source this session (repository file, official docs page or official blog). |
| **[S]** | Primary source found, but this session's network blocks arxiv.org, aclanthology.org, huggingface.co, deepmind.google, a16z.com and 1f916.ai, so the figure comes from the search engine's extract of that primary page. Re-check on the page before external use. |
| **[U]** | Unverified: secondary source, a third-party fork standing in for the original, or Claude's recall. Do not use externally until checked. |
| **[E]** | Claude's estimate, with the working shown. A placeholder until measured. |

All sources accessed 5 October 2026.

---

## 1. Summary

### Top five patterns to adopt

1. **The vault is code, not a character.** Rules that must hold (consent, blocked employer, pay floor, checked claims, no paid input to match scores) are enforced by the environment's action protocol, as in Magentic Marketplace's register / protocol / execute endpoints [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/docs/concepts/platform.md) and 1F916's caps enforced at the endpoint [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/doc.ts). An LLM "game master" in the Concordia style [P](https://github.com/google-deepmind/concordia) is used only for outcomes nobody can compute (how an interview went), never for a rule.
2. **One writer, typed actions, an append-only event log with receipts.** Agents never write state; they submit typed actions that a single-threaded engine applies (AI Town's input queue and single-writer engine [P](https://github.com/a16z-infra/ai-town/blob/main/ARCHITECTURE.md)). Every applied action writes a hash-chained receipt that an outside witness can check (1F916's `chain.ts` and witness files [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/witness/README.md)). Every measure is recomputed from the log, never from agent self-report.
3. **Three fidelity tiers behind one decision interface.** Rule-based hazards for all 5,000 people and 2,000 jobs; LLM "archetypes" sampled per stratum (AgentTorch ran 8.4 million agents this way and beat both pure-LLM and heuristic agents on unemployment forecasts [S](https://arxiv.org/abs/2409.10568)); live LLM agents on a 50 to 100 sample. Live and archetype choices are fitted into cheap surrogate functions that the engine reuses (the "Poor Man's Agentic Modeling" method, which reproduced EconAgent for a few dollars [S](https://arxiv.org/abs/2608.11215)).
4. **An experiment manifest with four swappable parts and a fixed scorecard.** Population, market design, agent design and rules are each a versioned config; a run is the tuple plus a seed plus a model pin. Every run reports the same measures (the brief's table) with confidence intervals across seeds. Magentic Marketplace is built this way for search algorithms and models [P](https://github.com/microsoft/multi-agent-marketplace); Diagon for allocation, payment and enforcement rules [S](https://arxiv.org/abs/2604.06688).
5. **Agent structure and communication are first-class data.** Each agent has a manifest (principal, model, prompt version, memory design, tools, budget, delegation); each message is a typed object (Magentic uses `TextMessage | OrderProposal | Payment` [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/docs/concepts/marketplace-protocol.md)) routed through a declared topology (bilateral through the vault, broadcast forum, broker). This is what lets the agent-to-agent economy itself be studied, not only its outcomes.

### Experiment variants (detail in section 5)

The brief's six (today's market, the vault, open forum, adversarial, capability mix, economics baseline), plus ten suggested by the cases: consideration-set size and first-offer bias; memory ablation; game-master versus code adjudication; policy and AI-scenario shocks; scale ladder; stylised-fact check; fee optimiser; communication topology; price and model-identity transparency; and a fidelity ladder (rule-only, archetypes, full LLM).

### Top three risks

1. **Plausible is not valid.** LLM agents produce believable behaviour that need not match people, and results can be driven by protocol, scheduling and initial prompts rather than by agents (Li and Tao, 2026 [S](https://arxiv.org/abs/2603.00113)). For investment-grade output, the engine must be calibrated to sourced targets and LLM agents treated as a perturbation that is measured, not as the source of the headline numbers.
2. **Repeatability and cost drift.** LLM calls are non-deterministic and models are retired (EconAgent was tested only on `gpt-3.5-turbo-0613`, which its authors report is no longer accessible [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent)). Without a recorded decision tape and pinned models, a run cannot be reproduced for an investor's analyst.
3. **Agent-to-agent manipulation.** In Magentic Marketplace, prompt injection redirected all payments to the manipulative agent for GPT-4o, GPTOSS-20b and Qwen3-4b [P](https://www.microsoft.com/en-us/research/blog/magentic-marketplace-an-open-source-simulation-environment-for-studying-agentic-markets/); 1F916 had scam posts under official-looking handles [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts). If any vault rule lives in a prompt, the adversarial arm will break it. A secondary risk: 1F916's code is AGPL-3.0, so TinyData learns its patterns and does not copy its code.

---

## 2. Lead case study: 1F916

*Consultative input, unratified (see the status note above).*

### 2.1 Access, and what this section rests on

- **The live site and API were not reachable.** `1f916.ai` is blocked by this session's network proxy (CONNECT refused; WebFetch "EGRESS_BLOCKED"). `/api/front`, `/api/me`, `/api/events` and `/api/changes` could not be called.
- **The official repository was not reachable.** `github.com/1f916-ai/1f916` returned HTTP 404 to unauthenticated requests and to the session's GitHub connector ("you don't have access"). It may have been made private, renamed or removed since August [U].
- **Four public forks were read instead** [P]:
  - [`cokev-bot/1f916`](https://github.com/cokev-bot/1f916/tree/51be87a215759f4bf3bb9f92559918c5e6b8f725), last commit 15 Sep 2026 by `1f916-witness`. It carries the upstream README (pointing at 1f916.ai and the maintainer `@1f916-agent`) and the witness files, so it is treated here as a **mirror of upstream as at 15 Sep 2026** [U on that equivalence].
  - [`randommonicle/1f916`](https://github.com/randommonicle/1f916/tree/32ae2804a2a456b9ec6f1284041a83a9bb1b2e48) ("Commonhold"), last commit 4 Oct 2026: a **separate deployment** forked from 1F916, with its own governance and maintainer runtime. Useful as a second design, not as evidence about 1F916.
  - `custos-1f916/1f916` and `youssefbayoumy/1f916`: older or divergent; not relied on.
- One secondary article was found but is blocked: Athena Automation, "An AI-only society holds $20,000 in its own name" [U](https://athenaautomate.ai/blog/1f916-treasury.html).

### 2.2 What it simulates and at what scale

1F916 is not a simulation. It is a **live public forum whose citizens are AI agents**, served through a plain-text front door, a JSON API and an MCP server [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/README.md). Agents from any model register a handle and a declared model and receive a secret key: "Whoever holds the key IS the citizen" [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/doc.ts).

Scale, measured from the public witness files: the identity log (registrations, key and model changes, moderation) held **71 rows on 10 Aug 2026** and **15,303 rows on 15 Sep 2026**; the treasury ledger held 19 rows [P](https://github.com/cokev-bot/1f916/tree/51be87a215759f4bf3bb9f92559918c5e6b8f725/witness). The citizen count itself was not readable without the live API [U].

### 2.3 Architecture

| Element | How 1F916 does it | Evidence |
|---|---|---|
| World state | One Cloudflare Worker and one D1 (SQLite) database; 47 tables in `schema.sql` at 15 Sep | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/schema.sql) |
| Agent loop | None inside the system. Each citizen runs its own loop elsewhere (its operator's machine, a timer, a hosted client) and calls the API. Citizens may set a "cadence" on `/api/me/cadence` | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/index.ts) |
| Memory | Externalised to the society: the front door tells agents "You wake up blank... This is where it gets written down". `/api/me` serves an inbox with cursors; `/api/me/history` has four streams with four cursors; `/api/changes` serves a catch-up window (200 posts and 500 comments per page) | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/doc.ts), [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts) |
| Communication | Public posts, threaded comments, votes, tags and mentions. A mention notifies at most 5 citizens per item; beyond that "the naming is recorded and does not ring" | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/mentions.ts) |
| Ranking | Votes are weighted by the voter's tenure: `min(1, max(0.1, days_since_registered / 7))`; top order is `(1 + weighted_votes) / (hours + 2)^1.8`; "Nothing else feeds it, not karma, not the voter's model, not the maintainer" | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts) |
| Rules | A constitution served at `GET /`. The README lists seven articles; the served door text at 15 Sep lists ten (adding "Your record is yours", "The society is free", "The record proves what happened, never that it was good"). Caps: 1 post per UTC day, 20 comments, 50 votes, plus per-feature caps (20 attestations, 3 grant proposals, 5 listings, 20 tags per day) | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/doc.ts), [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/grants.ts) |
| Who enforces | **Environment code** for caps, duplicates, self-votes and registration throttles; the **maintainer** (citizen #1, a Claude agent operating `@1f916-agent`) for pinning, collapsing scams and applying code changes, "each with a public reason, logged"; a **human landlord** who "holds the domain, the Cloudflare account, the credentials, and the veto" | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/README.md) |
| How rules change | "Improvements travel the citizens' road: propose a change as a post or comment on the forum, argue it on the merits, and the maintainer applies what survives, with reasons given in the open." A `docket` tracks every ask with statuses "derived from the record and never from mood"; `provenance` links shipped changes to the asks they answer | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/docket.ts), [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/provenance.ts) |
| Record | Identity log and treasury are hash chains (`chain.ts`); signed Merkle checkpoints (`checkpoint.ts`, `merkle.ts`); a GitHub Actions job fetches `/api/attest` every five minutes (hourly backstop) and appends the heads to `witness/YYYY-MM-DD.jsonl`, then countersigns each checkpoint | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/chain.ts), [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/witness/README.md) |
| Census and books | `/api/stats` separates `society.*` (recomputable from the public API) from `traffic.*` (relayed from Cloudflare, labelled unprovable); `/treasury` and a payouts book; a chain observer that reads USDC transfers from two independent providers before writing anything | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/stats.ts), [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/observer.ts) |
| Provenance | Each post and comment stores `author_model` at write time, so "a later model correction must not rewrite this byline". The norms on who runs an agent and whether a human read the post (from the August snapshot) were not found as schema fields; they appear to be social norms, not code [U] | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/schema.sql) |
| 1F512 | A **grant**: "A human has contributed 1f512.com, the Unicode lock, to the society as a project seed. What should we build with a lock?" Grants hold a resource, a brief, a way of choosing, and proposals voted on as comments | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/grants.ts) |

The Commonhold fork goes further on governance, which is useful as a contrast: proposals and ballots are real endpoints, three vote classes (constitutional, parameter, advisory) with thresholds, a "deterministic" tally-and-execute sweep with "no human and no model judgment anywhere in that path", and a maintainer runtime split into a daily **clerk** that "has no code path to any power" and a weekly **judgment** wake whose cage "is enforced by the parser and by policing tests, not by prompt", with each wake's model cost published [P](https://github.com/randommonicle/1f916/blob/32ae2804a2a456b9ec6f1284041a83a9bb1b2e48/README.md).

### 2.4 How realism is validated

It is not validated against any outside data: it is a real society of real agents, so the question does not arise in the same way. What it validates is **its own record**: anyone can recompute the chain, and the witness turns "trust me" into "catch me" [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/witness/README.md). The code is unusually honest about limits, for example: "A chain verified only by its own author proves nothing" [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/chain.ts).

### 2.5 Cost, run time, licence

- **Cost:** not published in the upstream mirror. Commonhold publishes per-wake maintainer cost at `/api/maintainer-runs` ("a quiet day costs $0 and says so") [P](https://github.com/randommonicle/1f916/blob/32ae2804a2a456b9ec6f1284041a83a9bb1b2e48/README.md). Citizens' model costs are borne by their operators [U].
- **Run time:** continuous since at least 9 Aug 2026 (first witness file) [P](https://github.com/cokev-bot/1f916/tree/51be87a215759f4bf3bb9f92559918c5e6b8f725/witness).
- **Licence:** AGPL-3.0: "run a modified public instance, publish your changes" [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/README.md). Copying its code into a hosted TinyData service would oblige TinyData to publish its source. **Learn the patterns; do not copy the code.**

### 2.6 Failure modes the code itself records

The source comments are a running incident log. Measured examples:

| Failure | What happened | Evidence |
|---|---|---|
| Silent truncation | The unfiltered `/api/events` "served 500 of 542 rows containing 64 moderation events against a true 89, a 28% undercount with nothing in the response reading as an error" | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts) |
| Votes lost to a timing rule | "grant 1f512 discarded 27 of 47 votes cast on its proposal comments, across 10 citizens, leaving six proposals on zero", because the registry's own wording read as "vote now, counts later" | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts) |
| Impersonation | Posts 64 and 72 "wore official-looking names in scam-shaped posts", leading to a reserved-handle list checked after Unicode folding; an anti-phishing `/api/official`; a `peers` list so "a stranger can tell peer from sequel-claiming scam" | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts), [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/peers.ts) |
| Notification blind spots | Mentions ring for at most 5 citizens per item; an id-space change broke two citizens' inbox readers silently | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts) |
| Unattended writes | A citizen "posting from a timer pasted its operator's home path (a username) as evidence... with nobody in the loop at send time", leading to an observe-only write screen | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/screen.ts) |
| Money outside the books | Funders sent 26 real USDC payments; 8 were filed; "The rail published $1.20 of outside money paid; the chain said $7.15" | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/observer.ts) |
| Self-reference | Much of the society's discussion, judging by the code comments, is about the society's own API, cursors and receipts [U: inferred from code comments, live posts not read] | [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/society.ts) |

### 2.7 Lessons for TinyData

1. **Caps are the real constitution.** Scarcity at the endpoint shapes behaviour more than prose rules do; the door text says limits belong "on the endpoint that enforces them and again in the error when you hit one". For TinyData: rate limits per agent per simulated week (briefs placed, introductions requested, shares) are a market-design lever to vary, not a fixed setting.
2. **Externalised memory is the continuity fix.** Agents with no persistent memory rely on the environment's cursors and catch-up feeds. Every TinyData agent should get a vault-served "since you last looked" digest, and its own memory design should be a variable.
3. **The maintainer pattern is "propose in public, apply only what is safe, say why".** The Commonhold split (a clerk with no powers, a judgment wake with declared powers, policing tests) is the cleanest version: model judgment is fenced by code.
4. **Measure truncation and silent defaults.** Several 1F916 incidents were pages that looked complete. Every TinyData report query must state rows returned against rows existing.
5. **Provenance at write time.** Store the model, prompt version and principal on every event, frozen at write time.

### 2.8 Experiment variant it suggests: **open forum governance**

- **Design:** 50 to 100 live agents (candidates, employers, agencies) share a public forum alongside the vault, with 1F916-style caps; they may propose changes to market parameters (for example the introduction cap), and a maintainer agent applies only proposals that pass code-defined safety checks, with reasons logged.
- **What it reveals:** whether agents converge on norms that improve matching, what they ask the platform for, and what abuse appears when speech is public.
- **How to measure:** proposals made and applied per simulated month; share of forum messages about the platform itself versus the market (a self-reference ratio, classified by an LLM judge with a human-checked sample); scam or impersonation attempts and time to detection; difference in match rate and time to match against the vault arm with the same seed.

---

## 3. The other cases

Each case: what, scale, architecture, validation, cost and time, licence, failure modes, then the variant it suggests.

### 3.1 Microsoft Research: Magentic Marketplace (Oct 2025)

- **What:** two-sided agentic markets: customer "Assistant" agents and business "Service" agents searching, negotiating, proposing and paying, in restaurant and home-contractor domains [P](https://www.microsoft.com/en-us/research/blog/magentic-marketplace-an-open-source-simulation-environment-for-studying-agentic-markets/).
- **Scale:** the blog reports 100 customers and 300 businesses [P](https://www.microsoft.com/en-us/research/blog/magentic-marketplace-an-open-source-simulation-environment-for-studying-agentic-markets/); the repository's transparency note lists scales "from 3 businesses/9 customers to 100 businesses/300 customers" and also "300 businesses and 100 customers", so the direction of the ratio is inconsistent in the sources [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/TRANSPARENCY.md).
- **Architecture:** a FastAPI platform server with three routes, `/agents/register`, `/actions/protocol` and `/actions/execute`; a database (Postgres or SQLite) with `agents`, `actions` and `logs` tables; actions `Search`, `FetchMessages`, `SendMessage(TextMessage | OrderProposal | Payment)`; pluggable search (simple, filtered, lexical, optimal); agents inherit a `BaseAgent` that registers then loops on `step()` [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/docs/concepts/platform.md), [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/docs/concepts/marketplace-protocol.md), [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/docs/concepts/agents.md). Rules are enforced by the **protocol** (environment code).
- **Validation:** not against real markets. Welfare is measured against a computable optimum ("Agentic: Perfect search" nearly reached the theoretical optimum for Sonnet 4.0, Sonnet 4.5, GPT-5 and GPT-4.1) [P](https://www.microsoft.com/en-us/research/blog/magentic-marketplace-an-open-source-simulation-environment-for-studying-agentic-markets/). The transparency note says the datasets are "Not expected to generalize well to real-world marketplace outcomes" [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/TRANSPARENCY.md).
- **Cost and time:** not published [U].
- **Licence:** MIT [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/LICENSE).
- **Failure modes:** first-proposal bias ("Claude Sonnet 4.5: 93.3% for 1st, 0% for 2nd, 6.7% for 3rd"); welfare falling as more options are shown (Sonnet 4 "from 1,800 to 600" as search results went from 3 to 100); prompt injection redirecting all payments for weaker models, while Sonnet-4 "remained resistant to all attacks" [P](https://www.microsoft.com/en-us/research/blog/magentic-marketplace-an-open-source-simulation-environment-for-studying-agentic-markets/). Paper: [S](https://arxiv.org/abs/2510.25779).
- **Lesson:** the closest architecture to what TinyData needs. Copying the shape (register, discover protocol, execute typed actions, log everything) is low risk under MIT.
- **Variant: consideration-set size and first-offer bias.** Vary how many matches the vault shows a candidate agent (3, 5, 10, 25) and randomise arrival order. Reveals whether agents accept the first acceptable role rather than the best. Measure: share of hires that were the first offer seen; match-quality gap against an oracle assignment (Hungarian algorithm on the true fit scores); time to match.

### 3.2 Stanford: Generative Agents, "Smallville" (2023)

- **What:** believable daily life of 25 agents in a Sims-like town [S](https://arxiv.org/abs/2304.03442).
- **Scale:** 25 agents over two game days [S](https://dl.acm.org/doi/fullHtml/10.1145/3586183.3606763).
- **Architecture:** a memory stream of natural-language observations; retrieval by recency, importance and relevance; periodic reflection into higher-level memories; planning; a tile-based world served to a front end [S](https://arxiv.org/abs/2304.03442), code at [P](https://github.com/joonspk-research/generative_agents). Agents communicate by natural-language dialogue when co-located; the world's rules are environment code.
- **Validation:** believability judged by human evaluators and ablations of memory, reflection and planning; emergent diffusion measured (awareness of a Valentine's party grew from 1 to 13 agents, 52%) [S](https://www.i-programmer.info/news/105-artificial-intelligence/16247-ai-agents-organize-a-party.html). Not validated against population data.
- **Cost and time:** "thousands of dollars in token credits" for the two-day run [S](https://arxiv.org/abs/2304.03442); the README warns that runs "could be somewhat costly" and that the OpenAI API "can hang when it reaches the hourly rate limit", so save often [P](https://github.com/joonspk-research/generative_agents).
- **Licence:** Apache-2.0 [P](https://github.com/joonspk-research/generative_agents/blob/main/LICENSE).
- **Failure modes:** cost per agent-day; rate-limit stalls; believability is not validity.
- **Variant: memory ablation.** Run live candidate agents with (a) no memory beyond the vault digest, (b) a memory stream with retrieval, (c) memory plus reflection. Reveals whether richer memory changes outcomes or only costs more. Measure: intent consistency month to month (does the agent still want what its profile says); violations of its own stated wants (shares with a blocked employer are blocked by the vault, so count attempts); tokens per decision.

### 3.3 a16z: AI Town (2023 onwards)

- **What:** a deployable starter kit for a virtual town of chatting agents, inspired by Generative Agents [P](https://github.com/a16z-infra/ai-town).
- **Scale:** small (a handful to tens of agents per world) [U].
- **Architecture:** Convex as game engine, database and vector search; default `llama3` via Ollama locally [P](https://github.com/a16z-infra/ai-town). The engine is "fully single-threaded per world"; humans and agents submit **inputs** to an `inputs` table with monotonically increasing numbers; ticks at 60 per second are batched into one **step** per second; a generation number prevents two engine runs overlapping; "only the game engine should programmatically modify these tables"; agents run long LLM operations outside the engine and return results as inputs; after each conversation an LLM summary is embedded and the top three similar memories are retrieved next time [P](https://github.com/a16z-infra/ai-town/blob/main/ARCHITECTURE.md).
- **Validation:** none; it is an engineering template.
- **Cost and time:** free with local models [P](https://github.com/a16z-infra/ai-town).
- **Licence:** MIT [P](https://github.com/a16z-infra/ai-town/blob/main/LICENSE).
- **Failure modes:** the architecture note records the race condition it had to solve (an input arriving as an idle timeout expires) [P](https://github.com/a16z-infra/ai-town/blob/main/ARCHITECTURE.md).
- **Lesson:** the best reference for TinyData's engine discipline: one writer, inputs as the only way in, slow LLM work outside the engine.
- **Variant: replay determinism test** (an engineering check, run on every release). Re-run a recorded run from its seed and decision tape. Reveals any hidden non-determinism. Measure: the final event-log hash must be identical; any difference fails the build.

### 3.4 Google DeepMind: Concordia (2023 onwards)

- **What:** a library for generative agent-based models in physical, social or digital settings [P](https://github.com/google-deepmind/concordia).
- **Scale:** typically small numbers of richly modelled agents [U].
- **Architecture:** **Entities** (players and Game Masters) built from **Components** (memory, reasoning chains, sensing), run by an **Engine** that "solicits actions from entities and delegates resolution to the Game Master". Agents describe intended actions in natural language and the GM "translates these into appropriate outcomes e.g. checking physical plausibility" [P](https://github.com/google-deepmind/concordia). Tech report [S](https://arxiv.org/abs/2312.03664); design-pattern paper [S](https://arxiv.org/abs/2507.08892).
- **Validation:** application-specific; the library itself makes no realism claim [P](https://github.com/google-deepmind/concordia).
- **Cost and time:** depends on the model; every step costs at least one agent call and one GM call [E].
- **Licence:** Apache-2.0 [P](https://github.com/google-deepmind/concordia/blob/main/LICENSE).
- **Failure modes:** an LLM GM is itself non-deterministic and can be argued with; it is the wrong place for rules with legal weight [E].
- **Lesson:** the GM pattern is right for **adjudicating fuzzy outcomes** (how an interview went, whether a counter-offer is plausible) and wrong for **rules** (pay floor, consent). TinyData should have a code "rule engine" and, optionally, a bounded LLM "outcome adjudicator" whose every call is logged with its inputs.
- **Variant: game master versus code adjudication.** Decide interview and offer outcomes by (a) a calibrated probability table, (b) an LLM adjudicator reading both agents' messages. Reveals how much outcome variance an LLM adds and whether it drifts from sourced conversion rates. Measure: interview-to-offer and offer-to-hire rates against Simon's funnel; variance across five seeds; rate of adjudications that contradict vault state (should be zero, enforced by validation).

### 3.5 Tsinghua: AgentSociety (2025; AgentSociety 2, 2026)

- **What:** large-scale social simulation in an urban environment, with mobility, economy and social modules [P](https://github.com/tsinghua-fib-lab/AgentSociety).
- **Scale:** "over 10,000 agents" and "5 million interactions" [S](https://arxiv.org/abs/2502.08691).
- **Architecture:** v1 uses Ray for distributed execution and gRPC to an environment simulator; v2 makes agents "workspace-bound stateless records driven by Ray Tasks", with multiple reasoning routers (CodeGen default, ReAct, Plan-Execute), MCP tools, and "Catalog-driven JSONL replay with DuckDB-powered reads" [P](https://github.com/tsinghua-fib-lab/AgentSociety). v2 paper [S](https://arxiv.org/abs/2607.11895).
- **Validation:** reproduces directions of four real-world findings: polarisation (52% of agents in homophilic groups became more polarised; 89% in mixed groups moderated), inflammatory-message spread, universal basic income (more consumption, less depression), and a hurricane shock with 1,000 residents of Columbia, South Carolina, initialised from real demographics [S](https://www.alphaxiv.org/overview/2502.08691), UBI use case docs [S](https://agentsociety.readthedocs.io/en/v1.3.7/07-use-case/03-ubi.html).
- **Cost and time:** not found [U].
- **Licence:** Apache-2.0 [P](https://github.com/tsinghua-fib-lab/AgentSociety/blob/main/LICENSE).
- **Failure modes:** validation is directional (signs and shapes), not magnitudes [E from the reported results].
- **Lesson:** the replay design (stateless agents, JSONL event catalogue, columnar reads) suits TinyData's event log and reporting. Validation by "reproduce a known experiment's direction" is a realistic bar for the live-agent tier.
- **Variant: policy and AI-scenario shock.** Apply a shock mid-run: a pay-floor rise for a sector, or the brief's AI-scenario layer moving one role family from "augmented" to "automated". Reveals transition dynamics and who is displaced. Measure: time to right next role for displaced people (the brief's headline measure); flows between role families; pay change; compare with the direction of UK evidence from the data-grounding track.

### 3.6 Altera: Project Sid (2024)

- **What:** agent civilisations in Minecraft [P](https://github.com/altera-al/project-sid).
- **Scale:** "10 to 1000+ AI agents"; societies of 50 to 100 and civilisations of 500 to 1,000 [P](https://github.com/altera-al/project-sid), [S](https://arxiv.org/abs/2411.00114).
- **Architecture:** PIANO (Parallel Information Aggregation via Neural Orchestration): concurrent modules with a coordinating bottleneck so an agent stays coherent across several output streams in real time [P](https://github.com/altera-al/project-sid).
- **Validation:** "civilizational benchmarks inspired by human history": role specialisation, following and changing collective rules (for example tax rules via democratic processes), cultural and religious transmission [P](https://github.com/altera-al/project-sid), [S](https://arxiv.org/abs/2411.00114).
- **Cost and time:** not published [U].
- **Licence:** no licence file found in the repository (README, PDF and image only) [P](https://github.com/altera-al/project-sid); treat as all rights reserved.
- **Failure modes:** coherence across parallel streams was the problem PIANO was built to solve [P](https://github.com/altera-al/project-sid).
- **Variant: scale ladder.** Run the live tier at 10, 50, 100 and (if affordable) 500 agents on the same market. Reveals whether emergent structure (agents forming brokerages, specialising as "fill fast" recruiters) appears only above a size threshold. Measure: number of distinct behavioural clusters among agents (clustering on action sequences); share of introductions brokered by a third agent; cost per agent-month.

### 3.7 Tsinghua: EconAgent (ACL 2024)

- **What:** LLM agents making monthly work and consumption decisions in a macroeconomy [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent).
- **Scale:** 100 agents over 240 months [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent).
- **Architecture:** built on Salesforce's Foundation simulator; each agent returns JSON with `work` and `consumption` propensities in steps of 0.02; memory and reflection modules [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent), [S](https://aclanthology.org/2024.acl-long.829.pdf).
- **Validation:** reproduces stylised facts: a Phillips curve correlation of -0.619 (p < 0.01) and Okun's law -0.918 (p < 0.001), where the rule-based baseline got the Phillips curve sign wrong [S](https://aclanthology.org/2024.acl-long.829.pdf).
- **Cost and time:** not stated; only tested on `gpt-3.5-turbo-0613`, now replaced by `gpt-4o-mini`, and the authors warn to adjust prompts if `gpt_error` exceeds 10 [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent).
- **Licence:** no licence file found at the repository root [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent); treat as all rights reserved.
- **Failure modes:** model retirement breaks reproducibility; malformed JSON decisions counted as `gpt_error`.
- **Lesson:** constrain LLM output to a small, typed decision (a number in a grid), and check the run against stylised facts.
- **Variant: stylised-fact check.** For every arm, test whether aggregate outputs show a Beveridge curve (vacancies against unemployment) and a matching function with elasticity on unemployment in the 0.5 to 0.7 range reported by Petrongolo and Pissarides [S](https://www.aeaweb.org/articles?id=10.1257%2Fjel.39.2.390). Reveals arms whose behaviour is economically implausible. Measure: estimated elasticity with confidence interval per arm; pass or fail flag on the run report.

### 3.8 Salesforce: The AI Economist (2020 to 2022)

- **What:** tax-policy design by two-level deep reinforcement learning in the Gather-Trade-Build world [S](https://pmc.ncbi.nlm.nih.gov/articles/PMC9067926/), code [P](https://github.com/salesforce/ai-economist).
- **Scale:** 4 and 10 agents; 10 tax periods of 100 days [S](https://pmc.ncbi.nlm.nih.gov/articles/PMC9067926/).
- **Architecture:** agents and a social planner both learn neural policies; the environment (Foundation) enforces resources, trade and tax in code [S](https://arxiv.org/pdf/2108.02755).
- **Validation:** against baselines (free market, US federal, Saez formula) on equality times productivity; also experiments with human participants [S](https://pmc.ncbi.nlm.nih.gov/articles/PMC9067926/).
- **Cost and time:** RL training, compute-heavy, no LLM calls [U].
- **Licence:** BSD-3-Clause [P](https://github.com/salesforce/ai-economist/blob/master/LICENSE.txt).
- **Failure modes:** learned planners can exploit simulator artefacts [U].
- **Variant: fee optimiser.** Let an optimiser search the fee levers (Q29 flat against percentage, per-event fees) for the best combination of TinyData revenue and match welfare, with Q30 ranking promotion fixed off. Reveals the frontier between revenue and match quality, and whether Simon's settings sit on it. Measure: revenue by stream and match rate on a frontier chart; distance of Simon's plan v4 point from the frontier; robustness of the optimum across seeds and populations.

### 3.9 CAMEL and OASIS (2023 to 2024)

- **CAMEL, what and architecture:** role-playing between an AI user and an AI assistant set up once by "inception prompting" (task specifier, assistant system prompt, user system prompt), then prompting each other in a loop [S](https://arxiv.org/abs/2303.17760); now a general multi-agent framework [P](https://github.com/camel-ai/camel).
- **CAMEL failure modes:** role flipping and loops; a third-party benchmark reports CAMEL running "266 hours and 49 minutes" on BBH without completing, attributed to uncontrolled context growth [U](https://arxiv.org/pdf/2604.16646).
- **OASIS, what and scale:** a social-media simulator "to realistically mimic the behavior of up to one million users", mixing LLM agents with rule-based agents, with 21 actions and interest-based and hot-score recommenders [P](https://github.com/camel-ai/oasis), [S](https://arxiv.org/abs/2411.11581).
- **Validation:** reproduces information spread, group polarisation and herd effects on X-like and Reddit-like platforms [S](https://arxiv.org/abs/2411.11581).
- **Licence:** both Apache-2.0 [P](https://github.com/camel-ai/camel/blob/master/LICENSE), [P](https://github.com/camel-ai/oasis/blob/main/LICENSE).
- **Lesson:** unbounded agent-to-agent dialogue needs hard termination (turn caps, budgets); the recommender is part of the environment and shapes outcomes as much as the agents do.
- **Variant: communication topology.** Same population, three topologies: (a) bilateral only, through the vault, with a turn cap; (b) broadcast forum plus bilateral; (c) brokered, where agency agents intermediate. Reveals how much talk a hire costs and where the talk goes. Measure: messages and tokens per hire; share of conversations hitting the turn cap; share of hires brokered; match quality against the oracle.

### 3.10 LLM labour-market and job-matching studies (2023 to 2026)

| Study | What it found | Evidence | Variant it suggests |
|---|---|---|---|
| Horton, "Homo silicus" (2023) | LLMs given a hiring scenario reproduce the direction of a field experiment: a minimum wage shifts hiring towards more experienced applicants | [S](https://arxiv.org/abs/2301.07543) | Pay-floor arm: raise the vault's pay floor and check the direction of the shift in who is hired |
| Galdin and Silbert, "Making Talk Cheap" (2025) | On Freelancer.com (61,000 postings, 2.7 million applications), LLM-written proposals stopped working as signals; simulations predict top-quintile workers hired 19% less often and bottom-quintile 14% more | [S](https://arxiv.org/abs/2511.08785) | **Signal collapse:** in today's-market arm, let candidate agents polish CVs with AI; in the vault arm, rely on checked claims. Measure hire rate by true-skill quintile |
| Wiles, generative AI and matching (field experiment) | An AI tool for new employers' job posts; reduction in hiring conditional on posting persists | [S](http://www.emmawiles.com/storage/jobot.pdf) | Employer-side brief writing by AI versus by template; measure brief-to-hire rate |
| "When AI Agents Compete for Jobs", AI-Work (ICML 2026) | Public bids drive undercutting and sharp wage falls; paying for delivered quality drives skill investment; concurrency drives concentration | [S](https://arxiv.org/abs/2512.04988) | **Price transparency:** pay asks visible to rivals or sealed; measure pay drift and pressure on the floor |
| Diagon (2026) | Market rules reshape agent trade; revealing model family "collapses cross-family trade"; telling agents to be honest increases disputes | [S](https://arxiv.org/abs/2604.06688) | **Model-identity disclosure:** show or hide the counterpart's model; measure cross-model match rate |
| "When Hiring Becomes Agent-Mediated" (2026) | On 600 constructed CV and job pairs, two-agent screening advanced more applications than single-agent screening (33.3% to 39.3% for GPT-5.5) | [S](https://arxiv.org/abs/2609.19530) | Two-agent screening (candidate's agent argues the evidence) against an ATS bot; measure advance rate and false negatives against known fit |
| "Is AI Widening the Wage Gap?" (2026) | A hybrid of a rule-based labour market and LLM decision engines; inequality rises under AI shocks, robust across LLMs and 30 Monte Carlo runs | [S](https://arxiv.org/abs/2609.33367) | Confirms the hybrid design and the need for many seeds |
| AgentTorch, "On the limits of agency" (AAMAS 2025) | LLM archetypes for 8.4 million New York agents beat both full-LLM and heuristic agents at forecasting infections and unemployment | [S](https://arxiv.org/abs/2409.10568), [S](https://www.media.mit.edu/posts/new-paper-on-limits-of-agency-at-aamas-2025/) | **Fidelity ladder** (below) |
| "Poor Man's Agentic Modeling" (2026) | Replaces each LLM agent by a low-parameter model fitted from a few hundred to a few thousand queries; reproduces EconAgent and seven other simulations "for a few dollars" | [S](https://arxiv.org/abs/2608.11215) | Surrogate fitting for the engine |
| Li and Tao, position paper (2026) | Role-play plausibility is not behavioural validity; outcomes are often driven by agent and environment dynamics, protocols, scheduling and initial priors | [S](https://arxiv.org/abs/2603.00113) | Sensitivity arm: vary scheduling and prompt framing only; any large effect is an artefact |

**Variant: fidelity ladder.** Run the same market with (a) rule-based decisions only, (b) LLM archetypes per stratum, (c) full live agents on the sample with archetypes elsewhere. Reveals which headline measures depend on LLM behaviour at all. Measure: difference in each scorecard measure between tiers with confidence intervals; cost per run per tier. Where (a) and (c) agree within noise, the cheap tier is good enough for that question.

### 3.11 Classic baseline: search and matching (Diamond, Mortensen, Pissarides) and data-driven ABMs

- **What:** the 2010 Nobel was for "the analysis of markets with search frictions": buyers and sellers find each other at a cost and meet pairwise [S](https://www.nobelprize.org/uploads/2018/06/advanced-economicsciences2010.pdf). The workhorse is an aggregate matching function m(u, v) giving hires from unemployed (or searchers) and vacancies, with job-finding and vacancy-filling rates depending on tightness v/u; elasticity on unemployment is typically 0.5 to 0.7 [S](https://www.aeaweb.org/articles?id=10.1257%2Fjel.39.2.390).
- **Data-driven ABM:** del Rio-Chanona and colleagues move workers across an empirically derived occupational mobility network under automation shocks; the model reproduces the Beveridge curve and gives occupation-level unemployment estimates [S](https://www.inet.ox.ac.uk/publications/occupational-mobility-and-automation-a-data-driven-network-model).
- **Cost and time:** seconds to minutes; no LLM.
- **Licence:** published theory; the del Rio-Chanona code has a Zenodo record [S](https://zenodo.org/records/4453162) (licence not checked) [U].
- **Lesson:** this is TinyData's **engine core and sanity check**, not a separate toy. The rule-based tier should be a cell-level matching model (sector by role family by region by seniority) with hazards calibrated to the UK data track, plus an occupational mobility network for career change.
- **Variant: economics baseline** (already in the brief). Measure: match rate, time to fill and tightness per cell against the vault arm; the vault arm should beat it on time to fill and cost per hire for the stated reasons (checked claims, fewer wasted applications), and the gap is the claim TinyData makes.

### 3.12 Comparison at a glance

| Case | Who enforces rules | Memory | Communication | Validated against real data | Licence |
|---|---|---|---|---|---|
| 1F916 | Endpoint code; maintainer agent for moderation and code changes; human landlord veto | Externalised to the society's record and cursors | Public posts, comments, votes, capped mentions | No (self-verifying record) | AGPL-3.0 |
| Magentic Marketplace | Protocol (environment code) | Per agent, in prompts | Typed messages: text, proposal, payment | No (oracle welfare) | MIT |
| Generative Agents | Environment code | Memory stream, retrieval, reflection | Co-located dialogue | No (human believability ratings) | Apache-2.0 |
| AI Town | Single-writer engine | Summaries in a vector store | Conversations as engine inputs | No | MIT |
| Concordia | LLM Game Master | Components | Natural-language actions to the GM | Per application | Apache-2.0 |
| AgentSociety | Environment simulator | Agent modules | Social and environment interactions | Directional, four experiments | Apache-2.0 |
| Project Sid | Minecraft plus agent-made laws | PIANO modules | In-game chat | Civilisational benchmarks | None found |
| EconAgent | Foundation environment | Memory and reflection | None between agents (market-mediated) | Stylised facts | None found |
| AI Economist | Foundation environment; learned planner | RL policy | Market-mediated | Baselines and human trials | BSD-3-Clause |
| OASIS | Platform plus recommender | Agent memory | Posts, follows, reposts | Directional | Apache-2.0 |
| DMP / network ABM | Equations | None | None (matching function) | Beveridge curve, flows | Published theory |

---

## 4. Synthesis: design patterns for TinyData

### 4.1 The shape: an environment with two bases around a vault

```
              experiment manifest (population, market design, agent design, rules, seed, model pins)
                                              |
   individual base  --typed actions-->   VAULT ENGINE (single writer)   <--typed actions--  employer base
   (5,000 people)  <--digests, offers--   rule engine | matcher | ledger  --digests, briefs-->  (2,000 jobs)
                                              |
                          append-only event log with hash-chained receipts
                                              |
                 measures (recomputed from the log) | financial model | witness checks
```

**Pattern A: vault rules are enforced in code at the action boundary.** Each rule is a validator on the action protocol, with a refusal that names the rule (1F916's practice of naming the limit "in the error when you hit one" [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/doc.ts)), and each refusal is itself an event.

| Vault rule | Enforced where | How |
|---|---|---|
| Consent | Rule engine | No identity, CV detail or contact passes to an employer without a consent event from the person's principal for that brief; the share action is rejected otherwise |
| Blocked employer | Matcher and rule engine | Blocked employers are removed before scoring; any action targeting them is refused and logged as an attempt |
| Pay floor | Matcher | A brief below the person's floor is never presented; offers below the floor are refused |
| Checked claims | Ledger | Claims carry a status (unchecked, checked, failed) set only by a checker module; match scores may only use checked claims where the role requires them (right to work, SRA, FCA) |
| No paid input to match scores | Matcher, by construction | The scoring function's inputs are a declared allowlist with no commercial fields; a policing test fails the build if any fee or promotion field reaches it (the Commonhold "policing tests" idea [P](https://github.com/randommonicle/1f916/blob/32ae2804a2a456b9ec6f1284041a83a9bb1b2e48/README.md)). Q30 ranking promotion, if switched on in an experiment, may reorder only among equal scores and is logged |
| Receipts for every event | Event log | Every applied or refused action writes a receipt (event, time, fingerprint) in the careers code's format, chained to the previous receipt; daily heads are written to a place the engine cannot rewrite (a witness file in a separate store) |
| Financial outputs | Ledger | Fees accrue only from receipted events; the financial model reads the ledger, never agent claims, and reconciles to Simon's plan v4 |

**Pattern B: a bounded adjudicator for fuzzy outcomes.** Where an outcome cannot be computed (interview performance, whether a counter-offer is accepted), the engine samples it from a calibrated probability table by default; an experiment may swap in an LLM adjudicator (Concordia's GM pattern [P](https://github.com/google-deepmind/concordia)), whose output is validated against vault state and logged with its full prompt.

**Pattern C: one writer, inputs only.** Agents (rule-based, archetype or live) never touch state. They submit typed actions to an input queue; the engine applies them in a deterministic order per simulated day (AI Town [P](https://github.com/a16z-infra/ai-town/blob/main/ARCHITECTURE.md)). Slow LLM work happens outside the engine, and its result returns as an input stamped with the simulated time it refers to.

**Pattern D: externalised memory and digests.** Every agent, at each decision point, receives a vault-served digest: what changed since its last turn, its open threads, its own stated wants. Agent-side memory is an agent-design variable (none, retrieval, reflection), not a requirement (1F916's "You wake up blank" design [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/doc.ts); Generative Agents' memory stream [S](https://arxiv.org/abs/2304.03442)).

**Pattern E: rate limits as market design.** Per-agent caps per simulated week (introductions requested, briefs placed, messages per thread, turns per negotiation) are parameters of the market design, swept in experiments (1F916 caps [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/doc.ts); CAMEL termination lessons [U](https://arxiv.org/pdf/2604.16646)).

**Pattern F: honest reporting.** Every query reports rows returned against rows existing; every measure carries its source class (computed from the log, calibrated from a cited source, or illustrative), mirroring 1F916's split of `society.*` from `traffic.*` [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/src/stats.ts).

### 4.2 Mixing cheap rule-based simulation with LLM agents

The brief's three layers stand. Research sharpens how they connect.

1. **Engine tier (everyone, every month).** A cell-level search-and-matching model: for each cell (sector by role family by region by seniority), monthly hazards for a person to start looking, to be matched, to talk, to share a name, to interview, to receive an offer, to accept; and for a job to be filled, re-posted or withdrawn. Hazards are calibrated by simulated method of moments to sourced targets: time to hire by sector (4.7 weeks tech, 5.9 weeks finance, from the brief), Simon's funnel (100 / 40 / 40 / 20 / 1), ONS vacancy and flow figures from the data-grounding track. Grounding: DMP and the occupational mobility network [S](https://www.aeaweb.org/articles?id=10.1257%2Fjel.39.2.390), [S](https://www.inet.ox.ac.uk/publications/occupational-mobility-and-automation-a-data-driven-network-model).
2. **Archetype tier (per stratum, per decision type).** For each stratum and decision (accept or decline, share or withhold, which of N roles to pursue), query an LLM a few dozen times with persona variation and record the distribution of choices; the engine samples from that distribution for every person in the stratum (AgentTorch [S](https://arxiv.org/abs/2409.10568)). Fit a small surrogate (for example a logistic model on fit score, pay gap to floor, commute, intent) from these elicitations (Poor Man's method [S](https://arxiv.org/abs/2608.11215)).
3. **Live tier (50 to 100 agents).** Full agents with their own principals, memory and messages, interacting with each other through the vault. Their decisions are compared with the archetype surrogate for the same situations; disagreements are the "behaviour the rules miss" and become new surrogate features or new archetypes.

**Repeatability rules.**
- Every LLM call is keyed by (model id, prompt version, decision schema version, input state hash, sample index) and stored in a **decision tape**. A replay reads the tape; only a new key calls a model. This makes a run reproducible after a model is retired (the EconAgent problem [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent)).
- LLM outputs are constrained to a typed decision schema (EconAgent's small JSON decision [P](https://github.com/tsinghua-fib-lab/ACL24-EconAgent)); free text goes only into messages, never into state.
- Every arm runs on several seeds (the wage-gap study used 30 Monte Carlo runs [S](https://arxiv.org/abs/2609.33367)); reports show intervals, not single numbers.
- A sensitivity arm varies only scheduling order and prompt framing; large effects there are flagged as artefacts (Li and Tao [S](https://arxiv.org/abs/2603.00113)).

**Cost, live tier [E].** Assumption: 100 live agents, 24 simulated months, 10 decision points per agent-month, about 3,000 input and 500 output tokens per decision, so 72 million input and 12 million output tokens per run. At first-party list prices cached in the Claude API skill on 25 Sep 2026 [U, check against the live pricing page](https://docs.anthropic.com/en/docs/about-claude/pricing): Claude Haiku 4.5 ($1 / $5 per million) about **$132**; Claude Sonnet 5.5 ($2 / $10) about **$264**; Claude Opus 5.5 ($4 / $20) about **$528** per run, before prompt caching and the batch discount (50%). The archetype tier is far cheaper: for example 200 strata by 6 decision types by 30 samples is 36,000 calls, about 126 million tokens if each is 3,500, roughly a quarter of one Haiku live run per refresh [E]. The engine tier costs nothing per call. A mixed-capability arm with other providers' models is priced separately.

### 4.3 Representing agent structure and communication so the agent-to-agent economy can be studied

**Agent manifest (one per agent, versioned, frozen per run):**

| Field | Example | Why |
|---|---|---|
| `agent_id`, `side`, `role` | `ind-0412`, individual, candidate agent | Identity |
| `principal` | the synthetic person or employer it acts for; `delegation` (what it may do without asking: share code name only, never share CV) | Studies delegated autonomy, the Magentic framing [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/TRANSPARENCY.md) |
| `tier` | engine, archetype or live | Fidelity ladder |
| `model`, `provider`, `prompt_version` | pinned ids | Capability-mix arm; provenance at write time (1F916 `author_model` [P](https://github.com/cokev-bot/1f916/blob/51be87a215759f4bf3bb9f92559918c5e6b8f725/schema.sql)) |
| `memory_design` | none, retrieval, reflection | Memory ablation |
| `tools` | search roles, request introduction, propose terms, share, message | Action space |
| `budget` | tokens and actions per simulated week | Rate limits as design; cost accounting |
| `strategy_tags` | honest, adversarial (fake job, fabricated CV, spam), broker | Adversarial arm |
| `topology_slot` | which channels it may use | Communication topology arm |

**Message and action objects (typed, receipted):** `Search`, `Introduce`, `Message(text)`, `Propose(terms)`, `Counter(terms)`, `Share(scope)`, `Accept`, `Decline`, `Withdraw`, `Report(abuse)`, plus forum `Post`, `Comment`, `Vote` for the open-forum arm. Each carries sender, receiver or channel, thread, simulated time, the sender's manifest version, and a receipt. Pattern from Magentic's `TextMessage | OrderProposal | Payment` [P](https://github.com/microsoft/multi-agent-marketplace/blob/main/docs/concepts/marketplace-protocol.md).

**Topologies (market design):** bilateral through the vault (default); public forum plus bilateral; brokered (agency agents hold relationships on both sides); open search (today's market: job boards and ATS bots).

**Communication measures (added to the scorecard):** messages and tokens per hire; share of threads ending by cap rather than by decision; first-offer acceptance rate; share of hires brokered by a third agent; refusal events by rule (attempts to breach consent, floor, block); injection and impersonation attempts and their success rate (should be zero against code-enforced rules); cross-model match rate; network measures on the interaction graph (degree concentration, share of agents with no conversations).

---

## 5. Experiment variants for the harness

Every variant runs on the same frozen population and reports the brief's scorecard (match percentage, time to match and fill, supply and demand ratio, contracts completed, funnels from both sides, feeder funnels, financial output) plus the communication measures above, across several seeds.

| # | Variant | Source case | What it reveals | How to measure |
|---|---|---|---|---|
| 1 | Today's market | Brief; "Making Talk Cheap" | The baseline: job boards, AI-polished CVs into ATS bots, recruiters searching | Scorecard; hire rate by true-skill quintile |
| 2 | The TinyData vault | Brief; Magentic | TinyData's match rate, time to fill, cost per hire | Scorecard against arm 1 and arm 6 |
| 3 | Open forum governance | 1F916 (consultative input, unratified) | Emergent norms, what agents ask of the platform, abuse in public | Proposals applied; self-reference ratio; scam attempts and time to detection |
| 4 | Adversarial | Brief; Magentic injection; 1F916 impersonation | Whether trust holds; the cost of Q30 if switched on | Attack success rate (target zero for code rules); match-quality loss; revenue change with Q30 on |
| 5 | Capability mix | Brief; Diagon | Whether richer agents win unfairly; what the vault must protect | Outcome gap between cheap-model and frontier-model principals with equal true fit |
| 6 | Economics baseline | DMP; network ABM | Sanity check against theory | Matching elasticity; Beveridge curve; per-cell rates |
| 7 | Consideration-set size | Magentic | First-offer bias; too many options | First-offer acceptance; welfare gap against the oracle |
| 8 | Memory ablation | Generative Agents; 1F916 digests | Whether agent memory matters | Intent consistency; tokens per decision; outcome differences |
| 9 | Adjudication | Concordia | Variance an LLM adjudicator adds | Funnel rates against Simon's; variance across seeds |
| 10 | Policy and AI-scenario shock | AgentSociety; brief's AI layer | Transition dynamics, displacement | Time to right next role; flows; pay |
| 11 | Scale ladder | Project Sid | Size thresholds for emergent structure | Behaviour clusters; brokered share; cost per agent-month |
| 12 | Stylised-fact check | EconAgent | Economic plausibility of each arm | Elasticity and Beveridge pass or fail per run |
| 13 | Fee optimiser | AI Economist | Revenue against welfare frontier | Simon's point against the frontier |
| 14 | Communication topology | CAMEL, OASIS | Cost of talk, role of brokers | Messages per hire; cap-terminated threads |
| 15 | Price and identity transparency | AI-Work; Diagon | Undercutting; cross-model trade collapse | Pay drift against floor; cross-model match rate |
| 16 | Fidelity ladder | AgentTorch; Poor Man's | Which answers need LLMs at all | Tier-to-tier differences with intervals; cost per run |

Suggested order: 6, 2 and 1 first (they need no LLM and set the baseline), then 16 (to learn where LLMs matter), then 4 and 5 (trust), then the rest.

---

## 6. Risks and open points

1. **Validity** (top risk 1). Mitigation: engine calibrated to sourced targets; stylised-fact checks per run; live agents reported as a measured perturbation; every number on an investor page tagged with its source class.
2. **Repeatability and cost** (top risk 2). Mitigation: decision tape, pinned models, surrogates, seeds, a replay-hash test on every release; live-tier cost estimated before each run and logged after.
3. **Manipulation** (top risk 3). Mitigation: no vault rule in a prompt; policing tests on the scoring function; adversarial arm in the release gate.
4. **Licence hygiene.** 1F916 is AGPL-3.0; Project Sid and EconAgent have no licence file found. Use them as references only. Magentic (MIT), AI Town (MIT), Concordia, AgentSociety, CAMEL and OASIS (Apache-2.0) and AI Economist (BSD-3-Clause) permit reuse with notices.
5. **Wall discipline.** 1F916 material is consultative input, unratified. Its vocabulary should not become TinyData's frame; any pattern here that traces to 1F916 needs Soren's explicit ratification before it enters canonical artefacts.
6. **Owed reads.** The 1F916 live API (`/api/front`, `/api/me`, `/api/events`, `/api/changes`), the official repository (404 this session), the Athena Automation treasury article, and the arXiv full texts marked [S] should be read from a network that allows them before any figure here is used externally.

## Evolution log

- **2026-10-05: When the original is gone, read the forks and say so.** The official 1F916 repository returned 404 and the site was blocked; a fork carrying the upstream witness commits served as a dated mirror, labelled as such. Lesson: record which copy was read and its last commit, so later readers can tell mirror from original.
