---
source: mixed
ratified: false
date: 2026-10-05
---

# Brief: the TinyData job ecosystem

## Soren's brief, verbatim (5 October 2026)

> We want, we want to model um, what different industries look like, what are the insights that we get from people's resumes, so I'm thinking of a much larger synthetic base, 2,000 potential jobs within those industries. We want to pull um, you know, uh, prospective profiles uh, of different kinds of ways that people work, what the different intents are, like cover the whole range of use cases across those three industries. that people might have in looking for their job. Same thing from the employer standpoint. What are all the things they're looking for? Which roles are critical? Which roles are faster to hire? Which roles are more in demand, but less available? Like look at all those kinds of use cases against the economy. You know, ones that need to be filled fast, ones that are constantly looking for, ones that are very difficult to find. You know, all those kinds of things. And then the same on the other side. So we want to do an employer base and a um, and a uh, individual base inside this synthetic economy. Run it outside of Skibbit. Create a, a, a, a tiny data. Create it as its own thing as a mirror of the economy. Uh, and of the uh, of the job economy, and then let's access it access it but I'm wondering if it needs its own repo or maybe its own branch um, but let's keep it and its code base separate and then use it as a resource and market research tool for uh, for these other parts of the uh, for these other parts of the projects and to build off of.

Earlier context, also Soren's: "We want to model. Synthetic economy." Simon's instruction (5 Oct): "So when you are building synthetic data, do it on these sectors": Professional & Business Services, Technology & Digital, Finance & Insurance.

## Claude's reading, for Soren to approve

### What it is

A standalone TinyData asset: a synthetic mirror of the UK job ecosystem in the three focus sectors. It has an **employer base** and an **individual base**, built to look like the real market. It is not a Skibbit product and does not depend on Skibbit. Other parts of the project read from it: the careers prototype, the matching code, Simon's revenue plan, the decks and the consumer tests.

### What it is for

1. **Market research.** What each industry looks like: its roles, how hard each is to fill, and what people in it want.
2. **Insights from CVs.** What a person's CV and working life reveal, and what a CV never says. This feeds the onboarding "findings" and the product's promise.
3. **Use-case coverage.** Every kind of job seeker and every kind of hiring need, so no product decision rests on one story (Naomi).
4. **A base to build on.** Data that the matching code, the fee model (Q29, Q30) and the revenue plan can run against.

### The employer base

- **Jobs:** about 2,000 jobs across the three sectors, weighted by Simon's hire volumes (roughly 73% Professional & Business Services, 15% Technology & Digital, 11% Finance & Insurance; see the open questions).
- **Employers:** synthetic, sized from Simon's counts (850 large employers, 2,785 agencies, scaled down), including agencies hiring for clients.
- **Each role carries:**
  - criticality to the business
  - typical time to hire (sector benchmarks, e.g. 4.7 weeks for tech, 5.9 weeks for finance)
  - demand against supply: **in demand but scarce**, **fill fast**, **always hiring**, **hard to find**, **routine**
  - pay band
  - the claims that matter (right to work, regulated status such as SRA or FCA)
  - the route (direct or agency)
  - what the employer is really looking for, beyond the job title

### The individual base

- **Coverage:** profiles covering the whole range of how people work and why they move. That spans early career to senior and partner, and employed-and-quietly-open through to actively searching, returning, career-changing or contracting.
- **Ways of working:** hybrid, remote, office, cross time zone, async, regulated.
- **Intents:** step up, more pay, more flexibility, leave a bad manager, sector switch, relocation, stability, purpose.
- **For each person:**
  - a synthetic CV
  - the richer evidence a CV never shows, as in the onboarding (patterns in calendar, writing and learning)
  - stated wants (floor, location, when available, who must never see them)
  - claims to check

### What it lets us ask

- **For employers:** which roles are critical, which are fastest to hire, and which are most in demand but least available.
- **For individuals:** which intents are common, which go unserved, and what the CV misses.
- **Across both:** where supply and demand do not meet, how long a candidacy waits for a fitting role, and how the matching rules (blocked employer, floor, checked claims) change outcomes.

### Grounding

Real public figures wherever they exist: ONS vacancy mix, REC market size, Simon's revenue plan v4, and the sector time-to-hire and fee benchmarks in `UK_Recruitment_Journeys.docx`. Every person, employer and job is invented and flagged synthetic. Distributions are sourced; individual records are generated.

### Where it lives (Soren asked: own repo or own branch?)

**Recommendation: its own repository, e.g. `tinydata-job-ecosystem`.** It has its own codebase and its own users (research, the decks, the careers code). A branch would drift from the trunk and could not be depended on cleanly. A repository can be versioned, shared with Simon and Kingston on its own terms, and consumed as a data package.

If a new repository cannot be created from a cloud session (the GitHub connection here is scoped to this repository), it starts as a self-contained top-level folder, `job-ecosystem/`, with its own package and README, ready to lift out unchanged. The `agentic-commerce/` folder used the same approach.

### First deliverable (proposed)

1. **Taxonomies:** sectors, role families, role archetypes, hiring patterns and intents, each with sources.
2. **Generator:** about 2,000 jobs, about 200 employers and agencies, and an individual base (size to agree), reproducible from a seed.
3. **Data in plain formats:** JSON and CSV, plus a spreadsheet for the group and Simon.
4. **A browsable page:** filter by sector, role and hiring pattern; see a profile, its CV and what the CV misses.
5. **A first research readout:** the critical, fast, scarce and always-hiring roles per sector, and the most common and least-served intents.

### Open questions for Soren

1. **"2,000 potential jobs":** 2,000 job openings (briefs) at a point in time, or 2,000 distinct roles (job types)? This brief assumes openings.
2. **Individual base size:** about 5,000 people (2.5 per opening), or a different ratio?
3. **Time:** a snapshot of the market today, or simulated month by month (people and roles arriving and leaving)? Snapshot first is faster.
4. **AI agents:** later, as a second phase acting as candidates and recruiters on this base, or not at all?
5. **Repository:** confirm its own repository, and its name.
6. **Who else uses it:** shared with Simon (he owns the revenue plan) and Kingston from the start, or internal first?

---

## Soren's follow-up, verbatim (5 October 2026)

> I'm wondering if this should be a combination of AI agents and synthetic consumers. I don't know. What do you think about that? Or maybe it's all synthetic AI agents building this. Um, um, uh, so, yeah, we want to be able to see um, and we want to uh, uh, Yeah, the questions must answer. What is the matching percentages? Um, what's the amount of time? Uh, how is our uh, how is our you know as in any market? How is our supply and demand ratio? Uh, we need matching percent. We need um, contracts uh, contracts completed. We need um, yeah. Uh, so, but we need tables, dashboards, all those kinds of things, so we can see exactly what we're doing. Um, uh, so yeah, we want to compare funnel rates and we want to look at all the feeding funnels. And from both sides, so that we start to see an operating vault marketplace and economy. Complete with logs, uh, with uh, modeled financial output on the other end based on uh, the parameters that we're able to change and that, uh, and that, and that Simon did.

## Claude's reading of the follow-up (proposed, for approval)

### The design: three layers

1. **AI agents write the population once.** Jobs, employers, CVs, the evidence a CV never shows, and what employers really want are authored with AI, then frozen as versioned data.
2. **A simulation engine runs the market** month by month, using probabilities sourced from public benchmarks and Simon's plan. It is fast, cheap and repeatable: change a setting, rerun, and compare.
3. **Live AI agents on a sample** (50 to 100) play candidates and recruiters at decision points: accept or decline, what to share, writing a brief. Their choices calibrate the engine's probabilities and surface behaviour the rules miss.

This replaces open question 4 and answers question 3: simulated over time, not a snapshot.

### What the ecosystem must answer

| Measure | Cut by |
|---|---|
| Match percentage (candidacies matched, briefs matched) | Sector, role type, hiring pattern, route |
| Time to match and time to fill | Same |
| Supply and demand ratio | Sector, role type; flags scarce, always-hiring, fill-fast |
| Contracts completed (hires) | Sector, route, month |
| Funnel rates, person side: wants to move, matched, talks, shares name, interview, offer, hire | Against Simon's 100 / 40 / 40 / 20 / 1 |
| Funnel rates, employer side: brief, matches, handshakes, hire | Against the same |
| Feeder funnels: where candidacies and briefs come from, and where they drop out | Both sides |
| Financial output: revenue by stream, cost per hire against the £6,475 baseline, TinyData take | Every lever in Simon's plan v4 |

### Logs

Every event writes a vault receipt in the same format the careers code uses (the event, the time and a fingerprint). The ecosystem can be audited like the real vault.

### Levers (from Simon's plan v4, all adjustable)

- **Fees:** per-event fees, the hire fee mode (flat or percentage, Q29) and ranking promotion (Q30, off by default; it never moves a match score).
- **Routes:** the split between direct and agency (30/70 or 20/80).
- **Producers:** the ramp, seat tiers and the share of hires that can be attributed to us.
- **Funnel:** the funnel's conversion rates.

### Outputs

1. A dashboard page with the levers on it: the ecosystem running, per sector and per side.
2. The tables behind it.
3. A spreadsheet export for Simon, beside his plan.
4. The event log.
5. A one-page readout per run.

### Still open

- **Question 1:** 2,000 open jobs, or 2,000 job types?
- **Question 2:** how many people?
- **Question 5:** its own repository, and its name.
- **Question 6:** shared with Simon and Kingston from the start?
- **New:** approve the three-layer design. The live-agent sample has a running cost per run, to be estimated before it is switched on.


---

## Soren's direction, verbatim (5 October 2026)

> lets use ecosystem, for the name not economy.  also this needs to be porduction code with an interface for bsuiness quezrtions and reporting and financia modelling.   this alll shoudl be investment grade material    and it neecd o eb compelling from btoh sides we need to onboarding page s

## Claude's reading (proposed, for approval)

### Name

**The TinyData job ecosystem.** Repository `tinydata-job-ecosystem`. Earlier sections above that said "economy" in Claude's text now say "ecosystem"; Soren's verbatim words are unchanged.

### Production grade, not a prototype

- **Code:** TypeScript end to end, strict types, schemas validated at every boundary, tests for every rule and every financial calculation, continuous integration, versioned data releases, reproducible runs from a seed, documented API.
- **Data store:** a real database (Postgres) with migrations; the same receipt format as the vault.
- **Correctness:** financial outputs reconcile to Simon's plan v4 when run on his inputs, with a reconciliation test that fails if they drift.
- **Honesty:** every assumption tagged with its source or marked illustrative; synthetic records flagged at the schema level.

### Interfaces

1. **Business questions.** Ask in plain English ("which Finance & Insurance roles are hardest to fill?", "what does a flat £1,850 fee do to year-3 revenue?"). The answer comes back as a table or chart, with the exact query shown so anyone can check it. Built on Claude over the ecosystem's database, read-only.
2. **Reporting.** Standing dashboards for match percentage, time to fill, supply and demand, funnels from both sides, contracts completed and the event log, cut by sector, role, hiring pattern and route. Exportable to spreadsheet and PDF.
3. **Financial modelling.** Every lever in Simon's plan as a control: fees, the hire fee mode (Q29), ranking promotion (Q30, off by default, never moves a match), routes, producer ramp, conversion rates. Runs are saved as named scenarios and compared side by side: revenue by stream, cost per hire against £6,475, TinyData's take, cash.

### Investment grade

The outputs are written to be put in front of investors and their analysts: sourced assumptions, a methods note, sensitivity on the five biggest levers, scenario comparison (base, low, high), and no number on a page without its source or its scenario. The financial model is checked by the `cfo` and `investment-lead` agents before anything leaves the team.

### Compelling from both sides: onboarding pages

Two onboarding pages, one per side, which show what joining feels like and feed the ecosystem:

- **Individual onboarding.** Add your CV and LinkedIn, see what it finds, confirm, and say what you want. The person joins the ecosystem and can see where they stand: roles that fit, demand for people like them, and time to match.
- **Employer onboarding.** Company checks, place a brief, and see the market for that role: how many people fit, how scarce they are, the expected time to fill, and cost per hire against the agency route.

They should be serious, fiduciary-grade design, in step with the Skibbit redesign under way (the individual page) and the TinyData black-and-white system (the employer page).

### Still open (unchanged)

1. 2,000 open jobs, or 2,000 job types? (Assumed: open jobs.)
2. How many people? (Suggested: about 5,000.)
3. Approve the three-layer design (AI-authored population, simulation engine, live agent sample).
4. Its own repository, `tinydata-job-ecosystem`: confirm.
5. Shared with Simon and Kingston from the start, or internal first?

---

## Soren's direction, verbatim (5 October 2026): the architecture phase

> Please, please do a deep dive with an architect and market research expert and agents that understand how do these environments work. Look at the one F um, one, one F repository where all the agents were brought together and how they communicated the rules were made, et cetera. This needs to be, we need to think about this as creating the basis for a fully fledged um, economic model. that we're gonna start with, and we're gonna start with the job economy. or the job ecosystem with this, and then then jobs, and then we're going to look at travel, and then we're going to look at other other um, uh, verticals. Where we create an ecosystem around this. So this is this is the first one. So please put some architectural time into this. Don't let it just be me kind of doing my hey, what about this, this, that, and the other thing. This needs to have real foundational layers, it needs to have real database layers, it needs to have real kind of operating uh, approaches that we can that we can use to ask economic questions, questions about emphasis, questions about um, you know, even even like consumer questions about people in their career laddering, what's appealing to them, and we should have a lot of dynamic energy in this and uh, we want to create this from uh, from these uh, these the, these views of real jobs and uh, and real um, people and and careers and what they're trying to do and make sure that we statistically relevant across all of the job functions within that first uh, within those uh, economic verticals that Simon uh, discussed. Or within those, yeah, within those industrial uh,

## Claude: how the architecture phase runs (5 October 2026)

1. **Three research tracks, in parallel**, written to `product/job-ecosystem/research/`:
   - **Agent environments:** how existing multi-agent simulations work, including the repository Soren meant by "one F" (unconfirmed; candidates are Magentic Marketplace, Generative Agents, AgentSociety and Project Sid), how agents communicate, and who enforces the rules.
   - **UK labour-market data grounding:** SOC and SIC, ONS, ASHE, vacancies, shortage lists, and a sampling frame that is statistically representative across every job function in the three sectors.
   - **Careers and hiring behaviour:** career ladders, move intents, what appeals, and employer hiring patterns, each with evidence-based parameters.
2. **Architecture**, by `engineering-architect`, built from the three tracks. It covers:
   - the foundational layers and the database
   - the simulation engine and the agent layer
   - the vault rules
   - the question interface, reporting and the financial model
   - how the same core carries travel and later verticals
3. **Soren reviews the architecture before any build starts.**

**Identified, 5 Oct 2026.** "The one F repository" is **1F916**: a public society of AI agents at https://1f916.ai, source at https://github.com/1f916-ai/1f916 (AGPL-3.0). Soren explored it in August in the session "1f916.ai UI exploration", which produced "The 1F916 Observatory" artifact. Agents from many models join as numbered citizens. They post, comment and vote under a seven-rule constitution with hard daily caps. A maintainer agent applies only what survives open debate, and citizens verify a hash-chained public record with a daily witness ritual. It is the lead case study in the agent-environments research.

---

## Soren, verbatim (5 October 2026): many simulations, not one

> I mean, I don't need to say, mean to say that that one's entirely right. I'm just saying that it's an example of one that could be that could be kind of an interesting thing. I I wonder if we need to run multiple of these simulations. And then and then look for different insights for each one because in the end we're building an agent-to-agent economy so we want to understand how are these agents kind of working within this how are they structured kind of all those all those different uh, all those different pieces right

## Claude's reading: an experiment harness (requirement for the architecture)

1F916 is one example to learn from, not the template.

The ecosystem is built as an **experiment harness**. Each run combines four parts, and every run reports the same measures, so the differences between runs are the insight:

- **Population:** the shared synthetic people, jobs and employers.
- **Market design:** how the market is organised.
- **Agent design:** how the agents are structured and how they communicate.
- **Rules:** what is enforced, and by whom.

First experiments:

| Experiment | Design | What it tells us |
|---|---|---|
| Today's market | Job boards, CVs into ATS bots, recruiters searching | The baseline TinyData must beat |
| The TinyData vault | Agents meet only through the vault: checked claims, code names, receipts | Our match rate, time to fill, cost per hire |
| Open square (1F916 style) | Agents talk in public, propose and vote on rules | Emergent coordination, norms, failure modes |
| Adversarial | Fake jobs, fabricated CVs, spam agents, paid ranking on | Whether trust holds; the cost of Q30 |
| Agent capability mix | Cheap against frontier models, on either side | Whether richer agents win unfairly; what the vault must protect |
| Economics baseline | Classic search-and-matching model, no AI | A sanity check against labour-market theory |

**Requirement:** market design, agent design and rules are interchangeable parts, never hard-coded. That keeps the agent-to-agent economy observable (how the agents are structured, how they communicate, who enforces what), and lets the same core carry travel and later verticals.


---

## Soren added (5 October 2026): Anthropic's economic scenarios

Soren shared https://www.anthropic.com/institute/econ-scenarios ("what about incorporating this thinking?"). Summary: `docs/reference/2026-10-05-anthropic-economic-scenarios.md`.

**Claude's reading: three requirements for the architecture.**

1. **Jobs as bundles of tasks.** Each role carries its tasks, each tagged unchanged, augmented, automated or new by AI, with UK exposure data where it exists.
2. **An AI-scenario layer in the harness.** Modest, substantial and extreme settings, driven by the explorer's five inputs (capabilities, adoption, autonomy, productivity, adjustment). They change demand per role, the flows of people between roles, and pay.
3. **Displacement and career change as first-class intents** on the individual side. Time to find the right next role becomes a headline measure.

---

## Decisions, 5 October 2026

Soren: "go with your suggestions on the ecosystem brief". The open questions are settled as proposed:

| Question | Decision |
|---|---|
| 2,000 jobs | 2,000 open jobs (briefs) at any point in the simulation, across the three sectors |
| Individual base | About 5,000 people (2.5 per open job), stratified to be representative |
| Design | Three layers: AI-authored population, a simulation engine running month by month, live agents on a sample of 50 to 100; inside an experiment harness with interchangeable market design, agent design and rules, plus the AI-scenario layer |
| Home | Its own repository, `tinydata-job-ecosystem` |
| Sharing | Simon from the start (his revenue plan is the reconciliation target); Kingston and the wider team once the first deliverable exists. Claude's call, since no suggestion had been made on this point; Soren can change it |

Next: the architecture, from the three research tracks, reviewed by Soren before the build starts.

---

## Soren, verbatim (5 October 2026): model where the economy is going; signals; fit

> And then if we if we take the Anthropic information and we use that as sort of a um, we kind of use that as a as a re as a as a forward looking economic principle, we've got we've got Simon's piece. Um, we should look at things like, you know, there's more applications to jobs and less real finding. You know, the, the, this kind of thing. Okay, but we need to model this economy on where it's going. And then create that view but we want we want people to be able to scenario plan and to actually simulate what if we change different elements in the environment what happens when we pick up certain kinds of signals like the key thing there is what are the unexpected or undiscovered signals that help you a really find the person who can do the real job that you want like flow of work, kind of like Anthropic, who does the real work, and then B, how do you pick up those signals from the individuals? And then the other side of it, which is where will individuals really be happy? What's the kind of way that they really work that suits them over time? Because a lot of people you know, they try to shoehorn themselves into jobs as I was saying the other day. We were saying this, that's no good because that's not really you. The problem is, is, you know, you're you're you're you're you you have the talents that are you, you tend to shoehorn yourself into jobs that aren't right for you because you need a job because you don't have enough visibility into all the jobs. And that your actual skills are in demand by somebody, the challenge is how do you find them? You know, you're trying to find them by by by throwing your, you know, by going for these all these jobs that maybe semi-suited for you and changing your way of doing it and you know and this kind of thing and that's just that, that you know changing who you are and rewriting your resume in some kind of AI special thing but that's not going to find you the job and it may be the job that is for you is far and distant from where you are but they'll take a remote thing and that by having this job marketplace we truly match people and jobs individuals and jobs and that's kind of at the heart of what this is which i think goes into several compelling stories on both sides of the equation which you need to keep a complete eye on and a complete running register of what are the um insights and compelling positioning pieces that we're going to go test on each side of this of this proposition um also we've got to get the website up and we have to get the producer deck done And uh, all those things are uh,

## Claude's reading: requirements for the architecture

1. **Forward-looking, not a snapshot of today.** The baseline is where the market is going: Anthropic's scenarios as the forward principle, Simon's revenue plan as the commercial frame, and today's dynamics as the starting point (more applications, less real finding: applications per job up about 111% in three years, recruiters per organisation down about 56%, per the 1 Oct dossier).
2. **Scenario planning for people, not only for us.** A "what if" interface: change elements of the environment (AI scenario, market design, rules, which signals the vault can see, remote openness, fee settings) and watch the ecosystem respond.
3. **Signal discovery is a core experiment.** Which unexpected or undiscovered signals predict the person who can really do the job? Work-flow and real-work evidence, in the spirit of the Anthropic Economic Index's view of who actually does what work, against CV keywords. The harness runs signal experiments: give the vault different signal sets and measure match quality, time to fill and retention. Synthetic people carry a hidden "true" capability and way of working, of which their CV and their work data are noisy views, so we can measure which signals recover the truth.
4. **How signals are picked up from individuals.** For each signal: where it comes from on the device (calendar, documents, writing, code, learning), what it costs the person, and what consent it needs. Only confirmed signals cross.
5. **Fit and happiness over time, not only placement.** The individual side models how each person really works and what suits them. Outcomes include tenure, satisfaction and growth after the hire, not just the hire. "Shoehorning" (taking a semi-suited role because nothing better is visible) is modelled explicitly, and the ecosystem measures how much of it a true-matching market removes.
6. **Visibility and distance.** The right job may be far away and open to remote work. The ecosystem models geography and remote openness so the value of wider visibility can be measured.
7. **A running register of insights and positioning to test,** for both sides, kept current: `gtm/positioning/insights-and-positioning-register.md`. The ecosystem feeds it; consumer and producer tests confirm or kill each item.
