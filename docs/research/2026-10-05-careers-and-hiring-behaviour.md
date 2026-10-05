---
source: ai
ratified: false
date: 2026-10-05
---

# Careers and hiring behaviour: typologies and simulation parameters for the TinyData job ecosystem

**Track:** careers and hiring behaviour (one of three research tracks for the architecture phase; see `product/job-ecosystem/2026-10-05-synthetic-job-ecosystem-brief.md`).
**Owner:** `consumer-researcher`. **Status:** draft, not ratified. **Scope:** UK first, EU where evidenced, US used only where no UK equivalent exists and flagged as such.

## The ask, in Soren's words (quoted from the brief, 5 October 2026)

> "consumer questions about people in their career laddering, what's appealing to them"

> "what the different intents are, like cover the whole range of use cases across those three industries. that people might have in looking for their job. Same thing from the employer standpoint. What are all the things they're looking for? Which roles are critical? Which roles are faster to hire? Which roles are more in demand, but less available? ... ones that need to be filled fast, ones that are constantly looking for, ones that are very difficult to find."

Plus the Anthropic scenarios layer (`docs/reference/2026-10-05-anthropic-economic-scenarios.md`): in the substantial scenario about 40% of knowledge workers are no longer in their 2026 occupation by 2030, and "how long does it take people to find a new job" is a core input.

## How to read this document

Every parameter carries a **default**, a **range** for sensitivity runs, a **confidence** rating and a **source**.

| Confidence | Meaning |
|---|---|
| **H** (high) | Robust, representative UK or EU data, or a peer-reviewed result that replicates. |
| **M** (medium) | One robust source, or robust non-UK data (usually US) applied to the UK, or a large but non-representative industry dataset. |
| **L** (low) | Vendor or recruiter surveys, self-selected panels, secondary reporting of a figure we could not trace to the primary source. |
| **A** (assumed) | Claude's modelling estimate, anchored to the evidence cited beside it. Must be calibrated (see section 7). |

**[unverified]** marks any figure taken from secondary reporting or search summaries that has not been checked against the primary document. Nothing marked [unverified] should go into an investor document until checked.

Two structural cautions apply to the whole evidence base:

1. **Recruiter and vendor surveys over-state mobility.** Michael Page, Robert Walters, Hays and LinkedIn panels are drawn from people already in contact with recruiters. Representative sources (ONS, CIPD Good Work Index) show lower intention to move. Defaults below lean on the representative sources and use the panels for the mix of reasons, not the level.
2. **Much behavioural evidence is US.** Search-behaviour economics (Faberman et al.), displacement losses (Jacobson, LaLonde and Sullivan) and the AI hiring studies (Brynjolfsson et al.) are US. UK equivalents are cited where they exist.

---

## 1. Individual side

### 1.1 Career ladders per sector

Ladders are the backbone of "career laddering" questions. Each synthetic person sits on a rung, with a time-in-grade and a probability of stepping up internally, moving out at the same level, or moving out a level up. Rungs below are the common UK structures; titles vary by firm and the ecosystem should store a normalised **level (L1 to L8)** alongside the firm-specific title.

**Professional & Business Services (about 73% of simulated openings in Simon's weighting)**

| Level | Audit, tax, consulting (Big Four and mid-tier) | Law (SRA-regulated) | Recruitment agency | Business functions (HR, marketing, operations) |
|---|---|---|---|---|
| L1 | Graduate or associate (trainee ACA/ACCA) | Paralegal, trainee solicitor (2 years) | Resourcer | Assistant, coordinator |
| L2 | Senior associate (often post-qualification) | Newly qualified (NQ) solicitor | Consultant | Executive, advisor |
| L3 | Assistant manager | Associate (2 to 5 PQE) | Senior consultant | Senior advisor, business partner |
| L4 | Manager | Senior associate (5+ PQE) | Principal consultant, team lead | Manager |
| L5 | Senior manager | Counsel, legal director | Manager, associate director | Head of |
| L6 | Director, associate partner | Partner (salaried) | Director | Director |
| L7 | Partner | Equity partner | Managing director | Chief officer |

**Technology & Digital (about 15%)**

| Level | Individual contributor track | Manager track | Product and data |
|---|---|---|---|
| L1 | Graduate, junior engineer | | Associate product manager, junior analyst |
| L2 | Engineer | | Product manager, data analyst |
| L3 | Senior engineer | | Senior PM, senior data scientist |
| L4 | Staff engineer | Engineering manager | Group PM, lead data scientist |
| L5 | Principal engineer | Senior EM, head of engineering | Head of product, head of data |
| L6 | Distinguished engineer, fellow | Director, VP engineering | Director, VP product |
| L7 | | CTO | CPO, chief data officer |

The **fork at senior engineer (L3)** is the key career-laddering decision in tech: stay on the individual-contributor track or move to management. It is a recurring move intent in its own right.

**Finance & Insurance (about 11%)**

| Level | Banking and markets | Insurance and underwriting | Actuarial | Risk, compliance, finance |
|---|---|---|---|---|
| L1 | Analyst (often a graduate scheme) | Underwriting assistant, claims handler | Actuarial student | Analyst |
| L2 | Associate | Underwriter | Part-qualified actuary | Senior analyst |
| L3 | Vice president (VP) | Senior underwriter | Newly qualified (FIA) | Manager |
| L4 | Director, executive director | Class or line underwriter | Senior actuary | Senior manager |
| L5 | Managing director | Head of underwriting | Head of pricing or reserving | Head of (often an SM&CR certified role) |
| L6 | Partner, group head | Chief underwriting officer | Chief actuary (SMF holder) | Chief risk or compliance officer (SMF holder) |

**Ladder parameters**

| ID | Parameter | Default | Range | Conf. | Basis |
|---|---|---|---|---|---|
| LAD-1 | Typical time in grade, L1 to L4 | 2.5 years | 1.5 to 4 | A | Common UK practice: Big Four promotes annually to biennially, banking analyst to associate after 2 to 3 years, law trainee contract fixed at 2 years [unverified]. |
| LAD-2 | Typical time in grade, L4 and above | 4 years | 3 to 7 | A | Fewer slots per rung; pyramid narrows. |
| LAD-3 | Annual internal promotion probability, L1 to L3 | 30% | 20 to 40 | A | Consistent with LAD-1. |
| LAD-4 | Annual internal promotion probability, L4 and above | 12% | 6 to 20 | A | |
| LAD-5 | Share of engineers who ever reach staff (L4 IC) or above | 15% | 10 to 25 | A [unverified] | Industry levelling data, not checked. |
| LAD-6 | "Up or out" voluntary attrition at L1 to L3 in Big Four and banking | 20% per year | 15 to 25 | L [unverified] | Widely reported; no primary UK source checked. |
| LAD-7 | External moves that are also a level-up | 40% of voluntary moves | 30 to 50 | A | Mobility is the main route to faster progression (see INT-2 and BEH-12). |

**Why internal routes matter for the simulation.** Employees stay about 41% longer at firms that hire from within ([LinkedIn Global Talent Trends 2020](https://www.linkedin.com/business/talent/blog/talent-management/employees-stay-41-percent-longer-at-companies-that-do-this), M). Internal mobility converts to hire at roughly 32 times the rate of an inbound application ([Gem 2026 Recruiting Benchmarks](https://www.gem.com/blog/key-takeaways-from-the-2026-recruiting-benchmarks-report), M, US-weighted). The ecosystem should model internal promotion as a competing outcome to an external match, or it will over-state the market's ability to fill senior roles.

### 1.2 Job-search states

A person is in exactly one state at a time and moves between states monthly. The first five states describe people in work; the rest are entry or re-entry states.

**What the evidence says about the level of intent**

- **Representative UK:** about one in five workers say they are likely to quit in the next 12 months ([CIPD Good Work Index 2024, via Blake Morgan](https://www.blakemorgan.co.uk/cipd-good-work-index-2024/), H, figure [unverified] against the report). In the 2025 index, 34% of those whose job harms their mental health intend to quit, against a lower overall rate; a quarter of workers say work harms their mental health ([CIPD Good Work Index 2025](https://www.cipd.org/globalassets/media/knowledge/knowledge-hub/reports/2025-pdfs/8868-good-work-index-2025-report-web1.pdf), H).
- **Global representative-ish:** 29% very or extremely likely to switch employer in 12 months ([PwC Hopes and Fears 2025](https://www.pwc.com/jg/en/publications/hopes-and-fears.html), M; 49,843 workers in 48 countries).
- **Recruiter panels:** 47% "actively job hunting" ([Michael Page Talent Trends 2025](https://www.personneltoday.com/hr/michael-page-talent-trends/), L for level); 37% of UK professionals "career cushioning", of whom a third were actively applying ([Robert Walters, 2023](https://www.peoplemanagement.co.uk/article/1825366/one-third-professionals-career-cushioning-looking-roles-survey-finds), L).
- **Passive share:** the oft-quoted "70% of the workforce is passive" traces to LinkedIn Talent Trends 2015 ([secondary summary](https://www.corporatenavigators.com/articles/recruiting-trends/currently-employed-workers-open-to-new-roles/), L, dated).
- **Actual moves:** about 708,000 job-to-job moves in Q3 2025, almost 30% below the late-2021 peak ([House of Commons Library, Sept 2026](https://researchbriefings.files.parliament.uk/documents/CBP-9366/CBP-9366.pdf), H, figure [unverified]; underlying series is [ONS X02](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/labourforcesurveyflowsestimatesx02)). On about 30 million employees that is roughly 2.3% a quarter, or about 9% a year economy-wide. The ONS caveats LFS quality.
- **Intention converts to action at about half.** Roughly 20% "likely to quit" against roughly 9% actual annual job-to-job moves implies a conversion of about 0.45 (A).

**State definitions and default stock shares** (for people in work in the three sectors)

| ID | State | Definition | Default share | Range | Conf. |
|---|---|---|---|---|---|
| ST-1 | Not looking | Would not take a call; content or locked in (deferred bonus, visa, life event) | 32% | 25 to 45 | M |
| ST-2 | Passive, open | Not searching, but would talk to a credible, tailored approach | 35% | 25 to 45 | L |
| ST-3 | Quietly looking | Updated CV, monitoring the market, occasional applications ("career cushioning") | 17% | 12 to 25 | L |
| ST-4 | Active | Applied or interviewed in the last four weeks | 8% | 5 to 12 | M |
| ST-5 | Contractor or interim | Working on contracts; always partly in market near contract end | 8% | 5 to 12 | M |

**Entry and re-entry states** (sized as stocks relative to the in-work base, plus seasonal inflows)

| ID | State | Default | Range | Conf. | Basis |
|---|---|---|---|---|---|
| ST-6 | Laid off or redundant, searching | 2.5% stock | 1.5 to 4 | M | UK redundancy rate about 4.9 to 5.3 per 1,000 employees per quarter, i.e. about 2% a year ([ONS BEIR series](https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/redundancies/timeseries/beir/lms), H); candidate availability "surged amid redundancies" through 2025 ([KPMG and REC Report on Jobs, Dec 2025](https://kpmg.com/uk/en/media/press-releases/2025/12/kpmg-rec-uk-report-on-jobs.html), M). |
| ST-7 | Returner (career break of 1 year or more) | 1.5% stock | 1 to 3 | L | About 427,000 UK female professionals on a career break, 2016 ([PwC, Women Returners](https://www.pwc.co.uk/economic-services/women-returners/pwc-research-women-returners-nov-2016.pdf), M, dated). |
| ST-8 | Graduate or early-career entrant | Annual inflow, September peak; size from employer graduate demand (EMP pattern P6) | | M | [ISE 2025](https://ise.org.uk/knowledge/insights/498/5_trends_you_need_to_know_from_ises_recruitment_survey_2025/). |
| ST-9 | Deliberate career changer, reskilling | 1.5% stock | 1 to 3 | L | About 1 in 10 UK workers changed career in 10 years ([Careershifters compilation](https://www.careershifters.org/career-change-statistics?field_country_focus_value=UK), L). |
| ST-10 | AI-displaced | Scenario-driven: 0.5% (modest), 3% (substantial), 8% (extreme) stock by 2030 | | A | Section 2. |

**Monthly transition defaults (in-work states)**

These are assumed values chosen so that the base reproduces an annual voluntary external move rate of about 10 to 13% in these three sectors (higher than the 9% economy-wide figure, because professional and tech workers are more mobile; the sector uplift is A). Calibrate against ONS X02 by sector before use.

| From \ to | Not looking | Passive | Quietly looking | Active | Moves employer this month |
|---|---|---|---|---|---|
| Not looking | stays | 4% | 1% | 0.5% | 0.02% |
| Passive | 3% | stays | 4% | 1.5% | 0.1% (approached and moved) |
| Quietly looking | 2% | 8% | stays | 10% | 1.5% |
| Active | 1% | 3% | 8% | stays | 12% |

Triggers that override the matrix: a bad-manager event, a missed promotion, a bonus paid (moves to ST-3 and ST-4 cluster in the weeks after UK bonus season, January to March, in finance [unverified]), a return-to-office mandate, a redundancy notice (to ST-6), and an AI restructuring of the person's team (section 2).

### 1.3 Move intents

Each person carries a **primary intent** and up to two **secondary intents**. The primary intent drives what they filter on; the secondaries drive what tips a decision.

**Evidence on reasons**

- UK professionals considering a move: work-life balance or workload 38%, limited advancement 35%, better benefits 34%, job security 22% ([People Management on a 2025 UK survey](https://www.peoplemanagement.co.uk/article/1968807/half-uk-workers-looking-change-jobs-year-survey-finds), L [unverified]; the 55% "salary decisive" figure in some summaries comes from a Robert Walters Belgium page and should not be used for the UK).
- UK career cushioners' drivers: lack of progression 42%, work-life balance 39%, feeling underpaid 31% ([Robert Walters via People Management](https://www.peoplemanagement.co.uk/article/1825366/one-third-professionals-career-cushioning-looking-roles-survey-finds), L).
- Flexibility: about 3% of UK employees, roughly 1.1 million people, changed job in a year specifically over lack of flexibility ([CIPD, 2025](https://www.cipd.org/en/about/press-releases/over-million-changed-jobs-over-lack-of-flexibility-cipd-research/), H). 49% of professionals will not accept a role without flexible arrangements ([Hays](https://www.hays.co.uk/market-insights/article/top-hiring-trends), L [unverified]).
- Manager: one in two US adults has left a job to get away from a manager at some point ([Gallup](https://www.gallup.com/workplace/236570/employees-lot-managers.aspx), M, US, lifetime not annual). Poor line-manager relationships are a named driver of "unhealthy work" in the UK ([CIPD 2025](https://www.cipd.org/en/about/press-releases/one-in-four-workers-say-work-has-negative-impact-on-their-health-cipd/), H).
- Purpose: 44% of Gen Z and 45% of millennials have left a role that lacked purpose ([Deloitte Gen Z and Millennial Survey 2025](https://www.deloitte.com/global/en/about/press-room/deloitte-2025-gen-z-and-millennial-survey.html), M, global).
- Pay ambition is cooling: intention to ask for a pay rise fell from 43% to 37%, and for promotion from 35% to 32% ([PwC Hopes and Fears 2025](https://www.pwc.com/gx/en/news-room/press-releases/2025/pwc-2025-global-workforce-survey.html), M). Three in four UK professionals feel more confident changing jobs than asking for a rise ([Robert Walters UK 2026](https://www.robertwalters.co.uk/insights/news/blog/uk-professionals-more-confident-changing-jobs-than-asking-for-pay-rise.html), L).

**Default primary-intent mix for voluntary movers** (in-work states ST-1 to ST-5)

| ID | Intent | Default share | Range | Conf. | Notes |
|---|---|---|---|---|---|
| INT-1 | Pay and total reward | 26% | 20 to 35 | M | Most cited single reason across sources. Rises when inflation is high. |
| INT-2 | Progression, step up a level | 20% | 15 to 28 | M | Largest driver for career cushioners. |
| INT-3 | Flexibility, workload, work-life balance | 14% | 10 to 20 | M | Includes return-to-office push. |
| INT-4 | Escape a manager or culture | 10% | 6 to 15 | L | Often the real reason behind a stated pay or progression reason. |
| INT-5 | Learning, skills, including AI skills | 7% | 4 to 12 | L | Rising; see section 2. |
| INT-6 | Stability and security | 7% | 4 to 15 | M | Counter-cyclical: doubles in a downturn (A). |
| INT-7 | Purpose and values | 5% | 3 to 10 | L | Higher among under-30s. |
| INT-8 | Relocation or location | 4% | 2 to 7 | L | Moving region adds to the pay rise, especially under 30 ([Resolution Foundation](https://www.resolutionfoundation.org/app/uploads/2017/08/Get-a-move-on.pdf), M). |
| INT-9 | Sector or career switch | 7% | 4 to 12 | L | Overlaps with ST-9. |

**Forced or semi-forced moves** sit outside the voluntary mix: redundancy (ST-6), contract end (ST-5), restructuring by AI (ST-10), visa expiry. One UK 2025 survey reports redundancy as the leading driver of career moves at 27% ([via Totaljobs/compilations](https://www.totaljobs.com/recruiter-advice/hiring-people/uk-industry-salary-and-benefit-trends/), L [unverified]); treat as a signal that forced moves are a large minority of all moves in a soft market.

**How intents vary** (multipliers applied to the default mix, then renormalised; all A unless cited)

| Cut | Pay | Progression | Flexibility | Manager | Learning | Stability | Purpose | Evidence |
|---|---|---|---|---|---|---|---|---|
| Under 30 | 1.1 | 1.3 | 0.8 | 1.0 | 1.5 | 0.7 | 1.5 | Deloitte (purpose, mentorship); RF (young gain most from moving). |
| 30 to 44 | 1.0 | 1.0 | 1.3 | 1.0 | 0.9 | 1.0 | 0.9 | Caring years. |
| 45 and over | 0.9 | 0.6 | 1.2 | 1.1 | 0.7 | 1.6 | 1.0 | Ageing Better on re-employment risk (section 2). |
| Women | 0.9 | 1.0 | 1.4 | 1.0 | 1.0 | 1.0 | 1.1 | 91% of women full-timers work or want to work flexibly against 84% of men ([Timewise](https://timewise.co.uk/article/flexible-working-talent-imperative/), M). |
| Men | 1.1 | 1.0 | 0.8 | 1.0 | 1.0 | 1.0 | 0.9 | |
| L1 to L3 | 1.1 | 1.3 | 0.9 | 1.1 | 1.3 | 0.9 | 1.0 | |
| L5 and above | 1.0 | 0.8 | 1.0 | 0.9 | 0.7 | 1.0 | 1.3 | Senior moves more about scope, equity and mandate. |
| Technology & Digital | 1.0 | 1.0 | 1.2 (remote) | 1.0 | 1.4 | 1.0 | 1.0 | Half of tech professionals job-hunting for flexibility, purpose, wellbeing ([Michael Page tech](https://www.michaelpage.co.uk/news/media-releases/talent-trends-technology-press-release-study), L). |
| Finance & Insurance | 1.3 (bonus) | 1.0 | 0.9 | 1.0 | 0.9 | 1.0 | 0.8 | Bonus and deferred-pay cycles. |
| Professional & Business Services | 1.0 | 1.2 | 1.1 (burnout) | 1.1 | 1.0 | 1.0 | 1.0 | Up-or-out pyramids. |

### 1.4 Deal-breakers and what appeals

Deal-breakers are hard filters: a match that breaks one is never shown, which matters for the vault rules (floor, blocked employer).

| ID | Deal-breaker | Share holding it as hard | Conf. | Evidence |
|---|---|---|---|---|
| DB-1 | Pay below personal floor | 95% | M | Near universal; floor = reservation wage (BEH-13). |
| DB-2 | No flexibility or hybrid (where currently hybrid) | 45% | M | 43 to 49% across sources; Hays 49% [unverified]. Women about 52% would turn down an offer without needed flexibility ([Marie Claire and LinkedIn via Timewise search](https://www.marieclaire.co.uk/life/flexible-working-women-747309), L). |
| DB-3 | Full-time office (five days) | 30% | A | Subset of DB-2. |
| DB-4 | Specific employer must never see me (current employer, competitor, ex-employer) | 60% of passive and quietly looking | A | Confidentiality is the core passive-candidate fear; to test in interviews. |
| DB-5 | Poor employer reputation or reviews | 20% | L | 19% of renegers cited hearing bad things about the employer ([Robert Half via HR Dive](https://www.hrdive.com/news/nearly-one-third-of-candidates-back-out-after-theyve-accepted-a-job-offer/555006/), L). |
| DB-6 | Commute or relocation beyond a set radius | 50% | A | |
| DB-7 | No visa sponsorship (for those who need it) | 100% of that segment | H | Rule, not preference. |
| DB-8 | Role likely to be automated or "AI-replaced" | 15% now, scenario-rising | A | Section 2. |

**What appeals** (ranked levers that raise acceptance and response; effect sizes A)

1. **Pay shown up front and above the floor.** Response uplift 1.3x when pay is disclosed (A).
2. **A tailored approach that shows the sender understood the person.** Personalised outreach replies at 25 to 35% against 13 to 18% generic ([Pin, vendor data](https://www.pin.com/blog/email-vs-linkedin-vs-sms-recruiting/), L).
3. **Flexibility stated as a right, not a favour.** Two in five women avoid raising flexibility for fear of harming their chances ([Timewise](https://timewise.co.uk/article/flexible-working-talent-imperative/), M).
4. **A visible next rung** (progression path and timing).
5. **Manager quality and mentorship** (Deloitte's "mentorship, meaning and financial security").
6. **Learning and AI tooling**, especially for the augmented cohort (section 2).
7. **Confidentiality guarantees** for the passive and quietly looking: this is Skibbit's and TinyData's structural edge and should be tested directly.

### 1.5 Behaviour parameters for the simulation

| ID | Parameter | Default | Range | Conf. | Source and note |
|---|---|---|---|---|---|
| BEH-1 | Reply rate to a tailored approach: Not looking / Passive / Quietly looking / Active | 3% / 15% / 35% / 55% | ±50% relative | A | Anchored on 13 to 25% average InMail reply rates ([Pin](https://www.pin.com/blog/email-vs-linkedin-vs-sms-recruiting/), L). LinkedIn enforces a 13% recruiter InMail floor [unverified]. |
| BEH-2 | Reply rate multiplier, personalised vs generic | 1.8x | 1.4 to 2.5 | L | Same source. |
| BEH-3 | Agree to first conversation, given reply | 60% | 45 to 75 | A | |
| BEH-4 | Offer acceptance, all candidates | 82% | 78 to 86 | M | Gem 2026 benchmarks (165m applicants, 1.2m hires, US-weighted); Ashby 81% ([Gem](https://www.gem.com/blog/key-takeaways-from-the-2026-recruiting-benchmarks-report); [Ashby](https://www.ashbyhq.com/talent-trends-report/reports/2023-trends-report-offer-acceptance-rates)). |
| BEH-5 | Offer acceptance by state: Active / Passive / Laid off | 86% / 70% / 90% | | M | Direction from [Faberman, Mueller, Sahin and Topa](https://www.nber.org/system/files/working_papers/w23731/w23731.pdf) (Econometrica 2022, US): non-employed accept 45 to 49% of all offers, employed 20 to 33%. Their denominator includes unsolicited and informal offers, so levels here are rescaled to the 82% formal-offer benchmark (A). |
| BEH-6 | Offer quality gap, employed vs unemployed | Employed get higher pay offers at equal characteristics; employed searchers are at least 3x more effective per application | | M | Faberman et al. (US). Supports modelling "search from a job" as advantaged. |
| BEH-7 | Renege after accepting an offer (per accepted offer) | 6% | 3 to 12 | L | 44% of candidates have reneged at least once (lifetime), up from 36% in 2019; top reasons: better offer 46%, counteroffer 27% ([Gartner via HR Executive](https://hrexecutive.com/why-new-hires-are-jilting-employers-and-what-to-do-about-it/); [HR Dive](https://www.hrdive.com/news/nearly-one-third-of-candidates-back-out-after-theyve-accepted-a-job-offer/555006/), L). Per-offer rate is A. Graduates: 10% (A). |
| BEH-8 | Counteroffer made when a person resigns | 35% overall; 55% scarce or critical roles; 15% routine | | A | No robust UK source. |
| BEH-9 | Counteroffer accepted, given made | 25% | 15 to 40 | A [unverified] | |
| BEH-10 | Leaves within 12 months after accepting a counteroffer | 50% | 35 to 65 | L | CEB (now Gartner) via HBR 2016 ([discussion](https://blog.theinterviewguys.com/the-counteroffer-stat-everyone-cites-is-fake-the-real-reason-to-walk/)). The recruiter "80% leave in 6 to 12 months" figure is untraceable folklore ([discussion](https://www.linkedin.com/pulse/so-do-80-people-who-accept-counteroffers-really-leave-ken-davies)); do not use. |
| BEH-11 | Notice period: L1 to L2 / L3 to L4 / L5 / L6+ | 4 weeks / 1 to 3 months / 3 months / 6 months incl. garden leave | | M [unverified] | Standard UK contractual practice in these sectors; regulated F&I roles longest. Drives "time to start", which employers feel as time to fill. |
| BEH-12 | Pay uplift on a voluntary external move (median) | +10% | +5 to +15 | M | UK job movers' pay growth reached 10% in 2022, the highest since the early 2000s; movers' rises typically about 5.5x stayers' ([Resolution Foundation](https://www.resolutionfoundation.org/press-releases/growing-disloyalty-bonus-as-pay-growth-for-job-movers-hits-10-per-cent-for-first-time-since-early-2000s/), M). Cyclical: in the US the switcher premium vanished for six months in 2025 ([Atlanta Fed](https://www.atlantafed.org/research-and-data/data/features/chcs/2025/09/11/wage-growth-tracker), M). Make it a scenario lever. |
| BEH-13 | Reservation wage (floor) relative to current pay | Passive +8%; Quietly +5%; Active +0%; Laid off: 0% falling 1 point a month after month 3, floor -15% | | A | Consistent with BEH-12 and declining reservation wages in unemployment (literature direction, M). |
| BEH-14 | Internal promotion pay rise | +8% | +5 to +12 | A | |
| BEH-15 | Applications per active search episode: experienced / graduate | 15 / 35 | 8 to 30 / 20 to 60 | L | UK figures range from 12 to 162 applications per job, depending on method ([StandOut CV](https://standout-cv.com/stats/how-many-applications-to-get-a-job), L). |
| BEH-16 | Inbound application to interview rate | 6% | 3 to 12 | M | 8% of applicants pass screening; 0.5% receive offers ([Gem](https://www.gem.com/blog/key-takeaways-from-the-2026-recruiting-benchmarks-report), M). |
| BEH-17 | Hire rate multiplier vs inbound: sourced / referral / internal | 5x / 11x / 32x | | M | Gem 2026. |
| BEH-18 | Gender: applications per search, women vs men | 0.8x | | M | Women apply to 20% fewer jobs and are 16% more likely to be hired per application ([LinkedIn Gender Insights](https://www.linkedin.com/business/talent/blog/talent-acquisition/how-women-find-jobs-gender-report), M, global). |
| BEH-19 | Gender: hire probability per application, women vs men | 1.16x | | M | Same. |
| BEH-20 | Candidate experiences employer ghosting after an interview (per process) | 20% | 12 to 30 | L | 61% of job seekers ghosted after an interview at least once; stage-specific 12 to 23% ([Greenhouse 2024](https://www.greenhouse.com/blog/greenhouse-2024-state-of-job-hunting-report), L). |
| BEH-21 | Hiring process length, application to offer (UK average) | 29 days | 20 to 45 | M | UK 28.6 days ([Glassdoor](https://www.onrec.com/news/news-archive/glassdoor-economics-report-uncovers-hiring-process-taking-longer-uk-jobseekers-rep), M, dated 2017). Sector benchmarks from the brief: 4.7 weeks tech, 5.9 weeks finance. |
| BEH-22 | Annual voluntary turnover: Tech / PBS / F&I | 15% / 18% / 12% | ±5 points | A [unverified] | Calibrate against ONS X02 by industry. |

---

## 2. The AI-era cohorts (new, from the scenarios)

The scenarios model jobs as bundles of tasks that AI leaves **unchanged, augments, automates, or creates new**. That gives three new individual archetypes, each a first-class state with its own parameters.

**What the evidence says about where AI is biting, as of late 2026**

- **Entry level first, through hiring not firing.** Employment of 22 to 25 year olds in the most AI-exposed US occupations is 19% below where it would be if it had kept pace with less-exposed peers; experienced workers show no comparable gap; the effect runs through reduced hiring and is concentrated where AI substitutes rather than complements ([Stanford Digital Economy Lab, Aug 2026 update](https://digitaleconomy.stanford.edu/news/canariesaug26/); [paper](https://digitaleconomy.stanford.edu/publication/canaries-in-the-coal-mine-six-facts-about-the-recent-employment-effects-of-artificial-intelligence/), M, US).
- **UK graduate intake is shrinking.** Graduate hiring fell 8% while apprenticeship hiring rose 8% ([ISE 2025](https://ise.org.uk/knowledge/insights/492/apprenticeships_rise_as_graduate_vacancies_drop_8/), H). Big Four UK graduate intakes against 2023: KPMG -29%, Deloitte -18%, EY -11%, PwC -6% ([City AM](https://www.cityam.com/big-four-slash-graduate-jobs-as-ai-takes-on-entry-level-work/), M [unverified]). Graduate postings were 13% down year on year at their lowest since 2020 ([Indeed Hiring Lab UK](https://hiringlab.indeed.com/uk/blog/2025/12/09/indeed-2026-uk-jobs-hiring-trends-report/), M).
- **UK exposure lands on our three sectors.** Finance and insurance is the most AI-exposed sector; management consultants, business analysts, accountants and legal professionals are among the most exposed occupations ([DfE, The impact of AI on UK jobs and training, 2023](https://assets.publishing.service.gov.uk/media/656856b8cc1ec500138eef49/Gov.UK_Impact_of_AI_on_UK_Jobs_and_Training.pdf), H). Bank of England research reports online adverts fell 15% in the most exposed third of occupations against 6% in the least, without attributing it to AI ([secondary report](https://www.resultsense.com/news/2026-08-06-boe-ai-exposure-hiring-slowdown/), M [unverified]). The Bank's agents expect headcount reductions to be modest and mostly through attrition ([BoE Agents' summary, March 2026](https://www.bankofengland.co.uk/agents-summary/2026/march-2026), H).
- **Exposure is broad.** About 80% of US workers could see at least 10% of tasks affected by LLMs, and 19% at least half ([Eloundou et al.](https://arxiv.org/pdf/2303.10130), M). On Claude, automation-pattern use overtook augmentation for the first time in mid-2025 (49.1% against 47%), then swung back to 52% augmentation by November 2025 ([Anthropic Economic Index, Sept 2025](https://www.anthropic.com/research/anthropic-economic-index-september-2025-report), M, with later figures [unverified]).

### 2.1 AI-displaced workers (ST-10)

**Who:** people whose role was automated, cut or not backfilled because AI absorbed its tasks. Mostly mid-career in exposed occupations (finance operations, KYC and compliance analysts, paralegal and document review, junior audit, insurance claims and underwriting support, customer and HR administration), plus graduates who never got onto the ladder (a "non-entry" form of displacement that the Stanford data suggests is the dominant one so far).

**Evidence on outcomes**

- **Wage scarring is real and persistent.** In the UK an unemployment spell carries about a 6% wage penalty on re-entry and about 14% after three years ([Arulampalam, Warwick](https://warwick.ac.uk/fac/soc/economics/staff/swarulampalam/publications/wagelossmarch01.pdf), H). In the US, high-tenure displaced workers lose about 25% a year long-term ([Jacobson, LaLonde and Sullivan](https://research.upjohn.org/up_workingpapers/11/), H), and losses are roughly twice as large when displacement happens in a recession ([Davis and von Wachter](https://pmc.ncbi.nlm.nih.gov/articles/PMC5521015/), H).
- **Technology-driven displacement is worse.** Workers displaced from occupations hit by technological change suffer larger earnings losses, partly because they must switch occupation ([Braxton and Taska, AER 2023](https://ideas.repec.org/a/aea/aecrev/v113y2023i2p279-316.html), M, US).
- **Switching occupation costs specific human capital.** Returns to five years of occupational tenure are 12 to 20%, and occupation, not employer, is where most human capital sits ([Kambourov and Manovskii](https://www.sas.upenn.edu/~manovski/papers/occupation_specific_HC.pdf), H; the "18% drop on switching" figure in secondary summaries is [unverified]). Occupational switching among the unemployed is large and pro-cyclical, including in the UK ([Carrillo-Tudela and Visschers](https://repository.essex.ac.uk/34821/1/Econometrica%20-%202023%20-%20Carrillo%E2%80%90Tudela%20-%20Unemployment%20and%20Endogenous%20Reallocation%20Over%20the%20Business%20Cycle.pdf), H).
- **Age is the biggest single moderator.** Over-50s made redundant are three times less likely than younger workers to be back in work within three months; 29% of older unemployed have been out more than 12 months against 13% of younger ([Centre for Ageing Better](https://ageing-better.org.uk/work-state-ageing-2023-4), H).
- **Time to re-employment is lengthening in tech.** Median time for laid-off tech workers reportedly rose from 3.2 months (2024) to 4.7 months (early 2026) ([secondary analysis](https://longyield.substack.com/p/the-great-tech-reckoning-900000-jobs), L [unverified]); in the 2023 cycle, 79% of re-hired tech layoffs found work within three months, and 42% earned more, 37% about the same, 21% less ([ZipRecruiter](https://www.ziprecruiter-research.org/survey-of-recently-laid-off-workers), L, US, survivorship bias: only the re-hired were asked).

**Intents and appeals.** Primary intents shift sharply: income replacement and stability (INT-6) dominate early; after three to six months, a growing share accept a sector or occupation switch (INT-9). What appeals: speed, honest market pricing ("what am I worth now"), a map from their tasks to roles that still need them, credible reskilling with a guaranteed interview, and protection from age and gap bias. The core TinyData promise ("what a CV never says") is most valuable here, because their job title may have stopped existing.

| ID | Parameter | Default (baseline) | Modest | Substantial | Extreme | Conf. |
|---|---|---|---|---|---|---|
| AI-1 | Median months to re-employment, under 50 | 3.5 | 4 | 7 | 15 | M (baseline), A (scenarios; mapped to the explorer's Adjustment input) |
| AI-2 | Median months to re-employment, 50 and over | 9 | 10 | 15 | 30+ | M (baseline from Ageing Better ratios), A |
| AI-3 | Re-employed within 3 months, under 50 | 45% | 40% | 25% | 12% | A |
| AI-4 | Pay at re-entry vs previous, median | -6% | -8% | -15% | -25% | H (baseline, Arulampalam), A |
| AI-5 | Pay at re-entry distribution (higher / about the same / lower) | 30 / 35 / 35 | 25 / 35 / 40 | 15 / 30 / 55 | 10 / 20 / 70 | A (shape from ZipRecruiter, shifted for survivorship) |
| AI-6 | Switches occupation on re-employment | 45% | 50% | 65% | 75% | A [unverified baseline] |
| AI-7 | Pay penalty for occupation switch, unless into an AI-complement role | -12% | -12% | -15% | -20% | M (Kambourov and Manovskii direction) |
| AI-8 | Share who exit to inactivity or self-employment within 12 months | 8% | 10% | 18% | 30% | A |

### 2.2 Augmented workers who want to move up or across (sub-state of ST-1 to ST-4)

**Who:** people whose role is being augmented rather than automated, who use AI daily and want to monetise or extend it: the analyst who now does a senior analyst's output, the engineer orchestrating coding agents, the lawyer running AI-assisted review, the underwriter building pricing tools.

**Evidence**

- Daily generative-AI users are more likely to report gains in job security (58% vs 36%) and salary (52% vs 32%); daily use rose from 14% to 22% of the workforce ([PwC Hopes and Fears 2025](https://www.pwc.com/gx/en/news-room/press-releases/2025/pwc-2025-global-workforce-survey.html), M, global).
- Postings with AI skills pay 28% more, 43% with two or more AI skills; 51% of postings asking for AI skills are outside IT; premiums are highest where AI combines with domain expertise, for example lawyers ([Lightcast, July 2025](https://lightcast.io/resources/blog/beyond-the-buzz-press-release-2025-07-23), M). PwC reports a 56% premium on a different method ([PwC AI Jobs Barometer 2025](https://www.pwc.com/gx/en/news-room/press-releases/2025/ai-linked-to-a-fourfold-increase-in-productivity-growth.html), M).
- Skills sought change 66% faster in the most AI-exposed jobs (same PwC source), so CVs go stale faster here.
- 75% of knowledge workers use generative AI and 78% of those bring their own tools ([Microsoft and LinkedIn Work Trend Index 2024](https://blogs.microsoft.com/blog/2024/05/08/microsoft-and-linkedin-release-the-2024-work-trend-index-on-the-state-of-ai-at-work/), M, global). Much of this use is invisible on a CV.

**Intents and appeals.** Monetise the productivity gain (pay), take a bigger scope (step up), move across into a newly created AI-adjacent role (AI governance, data governance, AI product, model risk), or move to an employer that is further ahead. Appeals: proof that their AI-enabled output counts, roles defined by outcomes, access to better tools, and pay that reflects the premium.

| ID | Parameter | Default | Range | Conf. |
|---|---|---|---|---|
| AUG-1 | Share of in-work base who are daily AI users (three sectors) | 30% now; 45% modest, 65% substantial, 85% extreme by 2030 | | A (anchored on PwC 22% all-sector daily use; our sectors are more exposed) |
| AUG-2 | Intent mix for the augmented cohort: pay / step up / move across to AI-adjacent role / move to AI-forward employer / other | 30 / 30 / 20 / 15 / 5 | ±10 points each | A |
| AUG-3 | Reply-rate multiplier vs non-augmented peers at the same state | 1.3x | 1.1 to 1.6 | A |
| AUG-4 | Pay uplift on move for those who can evidence AI-augmented output | +18% | +10 to +28 | L (Lightcast posting premium is an upper bound on realised uplift) |
| AUG-5 | Probability the employer can verify AI-augmented output from a CV alone | 15% | 5 to 30 | A; the insight-layer gap (section 4) |

### 2.3 Deliberate career changers and reskillers (ST-9)

**Who:** people choosing to leave an exposed or unrewarding occupation before they are pushed: accountants into data, recruiters into people analytics, lawyers into legal technology or compliance, teachers or public-sector staff into tech, mid-career finance staff into product.

**Evidence**

- About one in three UK workers say they want to change career completely; the most common age of change is about 31; about 1 in 10 actually changed career in a decade (compilations at [Careershifters](https://www.careershifters.org/career-change-statistics?field_country_focus_value=UK), L, marketing surveys).
- The UK's main state reskilling route, Skills Bootcamps, reports positive outcomes (new job, new role or more responsibilities) for about 56% of completers within six months, against a 75% target ([DfE evaluation, 2022 to 2023 cohort](https://assets.publishing.service.gov.uk/media/683729a7dc6ebc5eca0cbb29/Evaluation_of_skills_bootcamps_-_2022_to_2023_-_completions_and_outcomes_report.pdf), H, figure [unverified] against the report).
- Employers rarely act on skills over credentials: fewer than 1 in 700 US hires came from the wave of dropped degree requirements, and about 45% of firms changed postings in name only ([Harvard Business School and Burning Glass Institute, 2024](https://www.hbs.edu/managing-the-future-of-work/Documents/research/Skills-Based%20Hiring.pdf), H, US). That is the core barrier career changers face, and the core opening for verified evidence.
- 39% of key skills are expected to change by 2030; 80% of employers plan to upskill and two-thirds plan to hire for AI skills ([WEF Future of Jobs 2025](https://www.weforum.org/press/2025/01/future-of-jobs-report-2025-78-million-new-job-opportunities-by-2030-but-urgent-upskilling-needed-to-prepare-workforces/), M, global employer survey).

**Intents and appeals.** Purpose and future-proofing first, pay second (they accept a short-term cut). Appeals: employers who will read transferable evidence rather than titles, a credible bridge role, a known time and cost to switch, and anonymity while they test the water.

| ID | Parameter | Default | Range | Conf. |
|---|---|---|---|---|
| CC-1 | Time from decision to first role in new occupation | 12 months | 6 to 24 | A |
| CC-2 | Completion of a reskilling programme, given start | 70% | 55 to 85 | A [unverified] |
| CC-3 | Positive outcome within 6 months of completion | 56% | 45 to 70 | H [unverified] |
| CC-4 | First-year pay vs pre-change pay | -12% | -25 to +5 | M (direction from Kambourov and Manovskii), A level |
| CC-5 | Years to recover pre-change pay | 3 | 2 to 5 | A |
| CC-6 | Hire probability multiplier when the employer screens on verified skills rather than title history | 1.8x | 1.2 to 3 | A; key product hypothesis to test |

### 2.4 Mapping the Anthropic scenarios onto the individual base

| Lever | Modest | Substantial | Extreme | Notes |
|---|---|---|---|---|
| Annual occupation-change hazard (knowledge workers) | 5% | 11% | 20% | Substantial: 59.7% "still there" by 2030 implies about 11% a year over 4.25 years (1 minus 0.597 to the power 1/4.25). Baseline 5% is A. |
| Entry-level demand in exposed occupations vs 2024 | -10% | -30% | -60% | Anchored on the Stanford 19% gap and UK graduate cuts (A). |
| Displaced stock (ST-10) by 2030 | 0.5% | 3% | 8% | A |
| Median months to re-employment (AI-1) | 4 | 7 | 15 | Explorer "Adjustment" input |
| Knowledge-worker real wage change | normal | flat | -10% or worse | From the scenarios page |
| BEH-12 move premium | +10% | +6% | +2% | Weaker bargaining power (A) |
| INT-6 stability weight multiplier | 1.0 | 1.6 | 2.5 | Counter-cyclical intents (A) |

---

## 3. Employer side

### 3.1 Role criticality

| ID | Tier | Definition | Examples | Share of roles | Vacancy cost multiplier (x daily salary cost) | Conf. |
|---|---|---|---|---|---|---|
| CRIT-1 | Mission or regulatory critical | Business cannot legally or practically operate, or revenue stops, without it | SM&CR senior managers (SMF holders), MLRO, chief actuary, COLP and COFA in law firms, partners with client books, lead engineers on revenue systems, cyber incident leads | 8% | 3 to 5x | A |
| CRIT-2 | Revenue or delivery core | Directly produces billable work or revenue | Fee-earners, consultants, client-facing bankers, underwriters, product engineers, recruiters on desk | 35% | 1.5 to 2.5x | A |
| CRIT-3 | Enabling | Supports the core; work can be covered or delayed | HR, finance operations, marketing, internal IT, analysts | 42% | 1.0x | A |
| CRIT-4 | Transitional or automatable | Tasks largely automatable; vacancies are candidates for not refilling | Data entry, first-line KYC, document review, claims administration, junior reporting | 15% | 0.5x | A |

Anchors: a vacant critical role was estimated at about US$14,700 a month in lost output and cover costs, with 41% of leaders saying a long vacancy led another employee to resign ([CFOtech on a 2026 survey](https://cfotech.news/story/vacant-roles-cost-firms-usd-14-700-a-month-survey-finds), L). The common rule of thumb is annual salary divided by working days for each day vacant, before multipliers for revenue roles (L).

| ID | Parameter | Default | Range | Conf. |
|---|---|---|---|---|
| CRIT-5 | Probability a CRIT-4 vacancy is cancelled rather than filled | 15% now; 20% modest, 40% substantial, 65% extreme | | A; BoE agents: reductions mostly via attrition, i.e. not refilling |

### 3.2 Hiring patterns

Every opening carries exactly one pattern. These map directly to Soren's words: "fill fast", "constantly looking", "very difficult to find", "in demand but less available", plus routine and seasonal graduate intake.

| ID | Pattern | What defines it | Typical roles in the three sectors |
|---|---|---|---|
| P1 | **Routine** | Balanced supply and demand; standard process | HR advisors, finance operations, marketing executives, mid-level project managers, business analysts |
| P2 | **Always hiring** (evergreen) | Continuous requisitions for many seats; churn-driven; employer always in market | Recruitment consultants, audit and tax seniors, KYC and onboarding analysts, sales and business development, customer success, scale-up software engineers |
| P3 | **Fill fast** | Urgent: backfill after a sudden exit, project start, regulatory deadline; cost of delay high | Interim finance and change roles, contract developers, regulatory remediation, maternity cover, interim heads |
| P4 | **In demand but scarce** | High demand across many employers and thin supply; candidates hold several offers | AI and ML engineers, data engineers, cloud security, experienced credit risk managers, data governance managers, senior product managers |
| P5 | **Hard to find** | Low volume, niche, very thin supply; often executive search | Qualified actuaries in specialist lines, specialist tax partners, quant researchers, penetration testers with niche mixes, SMF-eligible compliance heads, lateral partners with books |
| P6 | **Seasonal graduate intake** | Annual cohort; fixed calendar; very high applicant volume | Big Four, bank and insurer graduate schemes, training contracts, tech graduate programmes |

**Evidence on scarcity**

- 36% of all UK vacancies were skill-shortage vacancies in 2022, up from 22% in 2017; for professional occupations 43% of employers with hard-to-fill vacancies cited applicants lacking skills, qualifications or experience ([DfE Employer Skills Survey 2022](https://assets.publishing.service.gov.uk/media/672a2743094e4e60c466d160/Employer_Skills_Survey_2022_research_report__Nov_2024_.pdf), H).
- AI is now the scarcest technology skill, the largest jump in a tech skills shortage in more than 15 years ([Nash Squared and Harvey Nash Digital Leadership Report 2025](https://www.nashsquared.com/post/ai-creates-the-worlds-biggest-tech-skills-shortage-in-over-15-years-finds-nash-squared-harvey-nash-report), M).
- UK cyber: the annual workforce gap narrowed to about 3,800, but 49% of businesses report a basic and 30% an advanced cyber skills gap; demand is for unusual mixes such as coding plus cloud ([DSIT Cyber skills 2025, via Cyber Exchange](https://www.cyberexchange.uk.net/news/dsit-publishes-latest-insights-on-uk-cyber-security-skills-in-the-uk-labour-market-report/), H). This is why P4 and P5 are about **combinations** of skills, not titles.
- Software developers, software engineers, cyber security and IT roles are listed among skills in short supply for permanent placements even as overall IT vacancies fell ([KPMG and REC Report on Jobs](https://kpmg.com/uk/en/media/press-releases/2025/12/kpmg-rec-uk-report-on-jobs.html), M).
- Fewer UK employers struggle to attract candidates in a softer market: 53% in 2026 against 64% in 2024 and 77% in 2022 ([CIPD Resourcing and talent planning 2026, via Omni RMS](https://www.omnirms.com/knowledge-hub/cipd-resourcing-and-talent-planning-report-2026/), H [unverified]).
- Graduate roles receive 140 applications per vacancy on average, up 14% in a year, a record since 1991 ([ISE](https://ise.org.uk/knowledge/insights/552/the_application_explosion_key_insights_for_employers/), H).

**Pattern parameters** (defaults for the 2026 baseline; all A unless a source is given)

| Parameter | P1 Routine | P2 Always hiring | P3 Fill fast | P4 In demand, scarce | P5 Hard to find | P6 Graduate intake |
|---|---|---|---|---|---|---|
| Share of openings, all three sectors | 38% | 20% | 12% | 10% | 8% | 12% |
| Qualified candidates per opening (supply to demand ratio) | 3.0 | 2.0 | 1.5 | 0.6 | 0.3 | 8+ (140 applicants, M) |
| Median time to fill, days (requisition to accepted offer) | 30 | 25 per seat, continuous | 12 | 60 | 95 | 70 (application to offer), fixed calendar |
| Time-to-fill range, days | 20 to 45 | 15 to 40 | 5 to 21 | 40 to 120 | 60 to 180 | 50 to 100 |
| Offer acceptance | 85% | 80% | 75% | 68% | 75% | 82% |
| Fall-through after acceptance (renege plus counteroffer) | 5% | 8% | 10% | 15% | 10% | 10% |
| Leaves within first year | 12% | 25% | n/a (contract) | 12% | 8% | 10% |
| Share placed via agency or search | 35% | 50% | 70% | 60% | 80% | 5% |
| Counteroffer risk (BEH-8) | 15% | 15% | 25% | 55% | 50% | n/a |
| Vacancy cost multiplier | 1.0 | 1.2 | 2.0 | 2.5 | 3.0 | 0.3 (cohort deferred, not lost) |
| Conf. | M | A | A | L | L | M |

Time-to-fill anchors: UK average 28.6 days ([Glassdoor](https://www.glassdoor.com/blog/time-to-hire-in-25-countries/), M, dated); brief benchmarks 4.7 weeks tech, 5.9 weeks finance; UK business and finance, legal and science roles all above 5.5 weeks ([NatWest Mentor, 2026](https://www.natwestmentor.co.uk/news/time-to-hire-in-the-uk), L); senior AI engineer roles 90 to 120 days against about 25 for a generic software role ([KORE1, vendor](https://www.kore1.com/time-to-fill-tech-role-2026/), L, US).

**Sector tilt** (replace the all-sector shares above)

| Pattern | PBS | Tech & Digital | F&I |
|---|---|---|---|
| P1 Routine | 40% | 30% | 36% |
| P2 Always hiring | 22% | 20% | 15% |
| P3 Fill fast | 11% | 14% | 12% |
| P4 In demand, scarce | 6% | 20% | 13% |
| P5 Hard to find | 7% | 8% | 12% |
| P6 Graduate intake | 14% | 8% | 12% |

All A, to be replaced by the labour-data track's vacancy mix and shortage data where it gives better numbers.

### 3.3 What employers screen for beyond the job title

Each brief carries **hard filters** (pass or fail) and **weighted signals**.

| ID | Screen | Type | Applies to | Prevalence or weight | Conf. |
|---|---|---|---|---|---|
| SCR-1 | Right to work; sponsorship availability | Hard | All | 100% checked | H (legal requirement) |
| SCR-2 | Regulatory status: SM&CR certification or SMF approval, SRA practising certificate, FCA approved person | Hard | F&I senior and certified roles; law | 100% of those roles | H |
| SCR-3 | Professional qualification: ACA, ACCA, CIMA, CFA, IFoA (FIA), CII | Hard or strong | Audit, tax, finance, actuarial, insurance | 70% of relevant roles hard | M |
| SCR-4 | Security clearance (SC or DV) | Hard | Government-facing tech and consulting | 5% of tech roles | A |
| SCR-5 | Sector experience ("must have Lloyd's market", "must have Big Four") | Strong | Most mid and senior roles | Weight 0.20 | A |
| SCR-6 | Pedigree of employer and education | Strong, often tacit | Graduate, consulting, banking | Weight 0.15 | M (degree resets largely cosmetic: HBS and Burning Glass) |
| SCR-7 | Book of business or client portfolio | Hard for lateral hires | Partners, bankers, senior recruiters | | M |
| SCR-8 | Notice period and start date | Strong | Fill-fast roles | Weight 0.25 in P3 | A |
| SCR-9 | Salary expectation within band | Hard at extremes | All | | M |
| SCR-10 | Trajectory (time in grade, promotions, tenure pattern; "job-hopping" flags) | Weighted | Mid and senior | Weight 0.10 | A |
| SCR-11 | Ways of working: hybrid days, location, time zones, async | Hard or weighted | All | | M |
| SCR-12 | AI fluency and evidence of AI-augmented output | Weighted, rising | Redesigned and new roles | Weight 0.05 now, 0.20 substantial scenario | A |
| SCR-13 | Background and reference checks | Hard post-offer | Regulated roles | 90% of EMEA employers find discrepancies in screening ([HireRight 2025](https://www.hireright.com/company/newsroom/identity-fraud-and-candidate-discrepancies-remain-key-concerns-for-employers), M) | M |

**What predicts performance is not what most screens look at.** In the corrected meta-analysis, structured interviews top the validity ranking at about .42 and unstructured interviews fall to about .19; years of job experience and years of education sit near the bottom ([Sackett, Zhang, Berry and Lievens, 2022](https://gwern.net/doc/statistics/meta-analysis/2021-sackett.pdf); [SIOP summary](https://www.siop.org/tip-article/is-cognitive-ability-the-best-predictor-of-job-performance-new-research-says-its-time-to-think-again/), H; exact figures for experience and education [unverified]). This is the scientific case for the insight layer in section 4.

### 3.4 Time to hire and fall-through by role type

Funnel defaults per opening (inbound-led routine role unless stated):

| Stage | Default conversion | Conf. | Source |
|---|---|---|---|
| Applicants per hire (UK) | 72 | L | SmartRecruiters 2025 via [StandOut CV](https://standout-cv.com/stats/how-many-applications-to-get-a-job) [unverified] |
| Applicants to screened in | 8% | M | Gem |
| Interviews per hire | 20 (up 42% since 2021) | M | Gem |
| Offer accepted | 82% | M | Gem, Ashby |
| Fall-through after acceptance | see pattern table | L | Gartner reneging; counteroffers |
| Start date after acceptance | BEH-11 notice periods | M | |

Fall-through causes for the simulation, in order of weight (A): better competing offer (46% of reneges), counteroffer (27%), negative information about the employer (19%), personal circumstances (8%). Shares from the Robert Half and Gartner reporting cited in BEH-7.

### 3.5 Agency versus direct

| ID | Parameter | Default | Range | Conf. | Source |
|---|---|---|---|---|---|
| AG-1 | Share of UK employers using an agency in a year | 85% | 75 to 90 | L | 86% used one in 2024 ([compilation](https://proplaybooks.co.uk/blog/uk-recruitment-statistics-2026), L [unverified]) |
| AG-2 | Share of permanent hires via agency: large employers / SMEs | 40% / 60% | 30 to 50 / 50 to 70 | L | Same compilation [unverified]; Simon's plan uses 30/70 or 20/80 direct to agency by value, to reconcile |
| AG-3 | UK recruitment industry turnover | £42.9bn (2024/25) | | H | [REC](https://www.rec.uk.com/our-view/news/press-releases/recruitment-sector-contributes-more-40-pounds-billion-year-uk-economy-despite-tough-job-market) |
| AG-4 | Permanent agency fee, % of first-year salary | 18% | 15 to 25 | L [unverified] | Common UK practice; contingent; retained search 25 to 33% |
| AG-5 | Median cost of recruiting (CIPD): senior managers / others | £3,500 / £2,000 (2026); £2,000 / £1,500 (2024) | | H [unverified for 2026] | [CIPD 2024 report](https://www.cipd.org/globalassets/media/knowledge/knowledge-hub/reports/2024-pdfs/8662-resource-and-talent-planning-2024-report-web.pdf); [2026 via Omni](https://www.omnirms.com/knowledge-hub/cipd-resourcing-and-talent-planning-report-2026/). CIPD medians exclude much agency spend; Simon's £6,475 cost-per-hire baseline is the figure to reconcile against. |
| AG-6 | Agency share by pattern | See pattern table | | A | |

### 3.6 Offer acceptance by employer behaviour

| Lever | Effect on acceptance | Conf. |
|---|---|---|
| Process length beyond 30 days in P4 roles | -2 points per extra week | A; strong candidates are off market within 2 to 3 weeks ([KORE1](https://www.kore1.com/time-to-fill-tech-role-2026/), L) |
| Pay stated in the first approach | +4 points | A |
| Flexibility matches the candidate's need | +6 points; mismatch triggers DB-2 | A |
| Ghosting earlier in the process | -8 points on later offers to that person; reputational spill-over | A; Greenhouse |

### 3.7 Roles redesigned or newly created by AI

| Type | Definition | Default share of openings (2026) | Substantial 2030 | Conf. |
|---|---|---|---|---|
| NEW-1 AI-native new roles | Titles that did not exist or barely existed in 2022: AI engineer, ML platform, AI product manager, AI governance and assurance, model risk for generative AI, agent operations | 3% (Tech: 10%) | 8% | A, anchored on UK LinkedIn Jobs on the Rise 2025: AI engineer first, data governance manager fourth, AI researcher ninth ([Onrec](https://www.onrec.com/news/statistics/linkedin-reveals-the-jobs-the-rise-for-2025), M) |
| NEW-2 Redesigned roles | Existing titles whose task bundle now requires AI skills | 15% | 45% | A, anchored on AI skills in a record 9.4% of UK job adverts ([Indeed via Global Banking and Finance](https://www.globalbankingandfinance.com/uk-hiring-falls-demand-ai-skills-jumps-job-site-indeed/), M [unverified]) and 51% of AI-skill postings outside IT (Lightcast) |
| NEW-3 Shrinking roles | Title persists, fewer seats, more senior mix (entry rungs removed) | 15% | 30% | A; Big Four and ISE graduate cuts |

**How hiring for new and redesigned roles differs** (parameters for NEW-1 and NEW-2, A unless cited)

- **No title history to screen on.** Candidates cannot show "five years as an AI governance manager". Hiring falls back on adjacent titles and pedigree unless evidence of the work exists. Title-match weight 0.3x normal; evidence weight 2x.
- **Specs are unstable.** Hiring managers revise the brief mid-process: probability of a re-briefed requisition 30% (against 10% routine).
- **Longer and costlier.** Time to fill 1.5x the pattern default; pay premium +28% (range +20 to +56%) (Lightcast; PwC).
- **More internal redeployment.** Half of employers plan to re-orient their business around AI and 80% plan to upskill (WEF); share filled internally 35% against 20% routine.
- **More trial routes.** Contract-to-permanent and secondments: 25% of NEW-1 start as contract.
- **Entry rungs shrink.** NEW-3 roles hire 30% fewer L1s per L3 than in 2023 (Big Four cuts of 6 to 29% as the anchor).

---

## 4. The insight layer: what a CV never says

### 4.1 Why CVs are a weak signal (evidence)

1. **CV fields barely predict performance.** Years of experience and education rank near the bottom of validity tables; structured, evidence-based assessment ranks at the top (Sackett et al. 2022, H).
2. **CVs are frequently wrong.** 90% of EMEA employers find discrepancies in screening, most often in employment history (64%) and qualifications (47%); 13% find one in every five candidates ([HireRight 2025 via People Management](https://www.peoplemanagement.co.uk/article/1923118/nine-10-businesses-report-candidate-discrepancies-during-screening-process-report-finds), M).
3. **AI now writes many of them.** Among graduate employers that allow AI, the most common use is writing CVs and cover letters (61%); two-thirds of employers worry applicants misrepresent their abilities through AI; 79% are redesigning or reviewing selection because of it ([ISE](https://ise.org.uk/knowledge/insights/552/the_application_explosion_key_insights_for_employers/), H).
4. **Machines filter out qualified people.** 88% of employers in the US, UK and Germany admit qualified candidates are screened out for lacking exact keywords, with employment gaps a common trigger ([Harvard Business School and Accenture, Hidden Workers, 2021, summary](https://www.brianheger.com/hidden-workers-untapped-talent-harvard-business-school-and-accenture/), M).
5. **Skills rhetoric is not practice.** Degree requirements dropped, behaviour unchanged (HBS and Burning Glass, H).
6. **Some people systematically under-claim.** Women apply to 20% fewer roles and are more likely to be hired when they do (LinkedIn, M); returners are likely to re-enter below their potential, two-thirds of them ([PwC](https://www.pwc.co.uk/economic-services/women-returners/pwc-research-women-returners-nov-2016.pdf), M).
7. **CVs go stale fastest where AI is changing work.** Skills change 66% faster in exposed jobs (PwC, M), and AI use is mostly self-sourced and unrecorded (Microsoft WTI, M).

### 4.2 CV field against real work data

| What the CV says | What it omits | What work data shows (calendar, writing, documents, code, learning, tools) | Who cares most | Sensitivity |
|---|---|---|---|---|
| Title and level | Real scope: budget, team, stakeholders, decision rights | Seniority of meeting counterparts, who escalates to them, documents they author vs approve | Employers screening P4, P5, NEW-1 | Medium |
| Years in role | Rate of growth; learning velocity | New tools adopted, courses completed, new domains in their writing over time | Career changers, early careers | Low |
| "Proficient in X" | Depth and recency | Frequency and recency of use in code, documents, models | Tech, data, actuarial | Low |
| Achievements bullet | Whether it is verifiable and theirs | Authorship trails, review comments, shipped artefacts | All, especially after HireRight-style discrepancies | Medium |
| Gaps | Caring, study, side projects, illness | Learning and project activity in the gap (only if the person chooses to share) | Returners, displaced | High |
| Nothing | Ways of working: async, cross-time-zone, focus time, response patterns | Calendar shape, time zones, meeting load, focus blocks | Remote and hybrid employers | Medium |
| Nothing | Influence: who seeks their help | Inbound requests, mentoring, cross-team collaboration | Manager-track hiring | Medium |
| Nothing or a buzzword | AI fluency and AI-augmented output | Prompts, agent workflows, before-and-after output volume and quality | Augmented cohort, NEW-1, NEW-2 | Medium |
| Nothing | Overload, a bad manager, flight risk | Meeting overload, after-hours work, fragmentation | The individual only: **never shown to employers** | Very high |
| Nothing | Transferable task bundle | Which tasks they actually do (task mix), mapped to roles that need those tasks | Displaced and career changers | Low |

The last two rows are the product's moral line and its biggest value: the person sees their flight-risk signals and their transferable task bundle; employers only ever see claims the person has checked and chosen to share.

### 4.3 Insight-layer parameters (each synthetic person carries a "true" profile and a "CV" profile)

| ID | Parameter | Default | Range | Conf. |
|---|---|---|---|---|
| CV-1 | Material discrepancy (false employer, dates, qualification) per CV | 5% | 2 to 13 | L (HireRight-informed) |
| CV-2 | Minor inflation (title, scope, skill level) per CV | 25% | 15 to 40 | A |
| CV-3 | Share of skills used at work that are absent from the CV | 35% | 20 to 50 | A [unverified]; key hypothesis to test |
| CV-4 | Under-claim multiplier on CV-3: women / returners / career changers | 1.2x / 1.4x / 1.5x | | A, direction from LinkedIn and PwC |
| CV-5 | Share of applications with AI-written CV text: graduates / experienced | 60% / 35% | | L / A |
| CV-6 | Probability an ATS rejects a qualified applicant (false negative) | 25% | 10 to 40 | A, direction from Hidden Workers |
| CV-7 | Share of AI-augmented output visible from CV alone | 15% | 5 to 30 | A (= AUG-5) |
| CV-8 | Validity of a CV screen vs an evidence-based screen (correlation with true fit) | 0.20 vs 0.40 | | M, scaled from Sackett et al. |

---

## 5. Research questions the ecosystem should answer

Each question lists the parameters it needs. "Measures" refers to the brief's headline measures (match percentage, time to match, supply to demand, contracts completed, funnel rates).

### Individual side

| # | Question | Parameters needed |
|---|---|---|
| Q-I1 | How many people in each sector and level are reachable now (active plus quietly looking plus passive), and how does that change by month? | ST-1 to ST-5 shares, transition matrix, BEH-1 |
| Q-I2 | Which intents are most common, and which go unserved by the jobs on offer? | INT-1 to INT-9, intent multipliers, DB-1 to DB-8, employer pattern mix and flexibility offered |
| Q-I3 | What does the next rung look like for a given ladder position, and is it faster to climb inside or by moving? | LAD-1 to LAD-7, BEH-12, BEH-14 |
| Q-I4 | What pay rise does a mover realistically get, by sector, level and intent? | BEH-12, BEH-13, AUG-4, scenario lever on BEH-12 |
| Q-I5 | How long from "open to move" to starting a new role? | Transition matrix, BEH-11, BEH-21, pattern TTF |
| Q-I6 | Which deal-breakers remove the most matches, and for whom (women, over-45s, returners)? | DB-1 to DB-8, intent multipliers by gender and age |
| Q-I7 | What appeals enough to move a passive person to reply? | BEH-1, BEH-2, appeal levers in 1.4 |
| Q-I8 | How long does an AI-displaced person take to re-enter, at what pay, and in which occupation? | AI-1 to AI-8, scenario table |
| Q-I9 | Which augmented workers can step up, and what is their evidence worth? | AUG-1 to AUG-5, CV-7, NEW-1 and NEW-2 parameters |
| Q-I10 | Which career-change routes work best (time, cost, pay recovery)? | CC-1 to CC-6, SCR-6, CV-4 |
| Q-I11 | What does a CV miss for each archetype, and how does showing it change match rates? | CV-1 to CV-8, SCR weights |
| Q-I12 | How does a person's confidentiality preference (who must never see them) change their match rate and time to match? | DB-4, BEH-1 by state, employer counts per sector |

### Employer side

| # | Question | Parameters needed |
|---|---|---|
| Q-E1 | Which roles are critical, and what does a month of vacancy cost? | CRIT-1 to CRIT-5, pattern vacancy multipliers, pay bands (labour-data track) |
| Q-E2 | Which roles are fastest and slowest to fill, and why? | Pattern TTF, BEH-11, SCR filters, supply to demand ratios |
| Q-E3 | Which roles are in demand but scarce, and where is the shortfall largest? | Pattern shares by sector, qualified candidates per opening, ST shares by occupation |
| Q-E4 | Which roles are always hiring, and is that churn or growth? | P2 share, first-year leaver rate, BEH-22 |
| Q-E5 | Where do offers fall through, and how much is counteroffers? | BEH-4 to BEH-10, pattern fall-through |
| Q-E6 | When does an agency beat direct, on time and cost? | AG-1 to AG-6, pattern agency share, BEH-17 |
| Q-E7 | How do new and redesigned AI roles hire differently, and what does it cost? | NEW-1 to NEW-3 parameters, SCR-12, AUG parameters |
| Q-E8 | How many graduate seats disappear under each scenario, and where do those graduates go? | P6 share, scenario entry-level lever, ST-8 inflow |
| Q-E9 | What happens to time to fill and quality when screening uses verified evidence instead of CVs? | CV-6, CV-8, CC-6, SCR weights |

### Across both sides

| # | Question | Parameters needed |
|---|---|---|
| Q-X1 | Where do supply and demand not meet, by sector, pattern and level? | ST shares by occupation, pattern shares, DB filters |
| Q-X2 | How long does a candidacy wait for a fitting role, and a brief for a fitting person? | Everything in the transition matrix plus pattern parameters |
| Q-X3 | How do the vault rules (blocked employer, floor, checked claims) change match percentage, time to fill and contracts completed? | DB-4, BEH-13, CV-1 to CV-3, SCR-13 |
| Q-X4 | How do the funnels compare with Simon's 100 / 40 / 40 / 20 / 1? | BEH-1 to BEH-7, BEH-16, BEH-17, pattern acceptance |
| Q-X5 | Under modest, substantial and extreme AI scenarios, how do volume, time to match and cost per hire move? | Scenario table (2.4), CRIT-5, NEW-1 to NEW-3 |

---

## 6. The ten most decision-relevant parameters

Ranked by how much they move the headline measures (match percentage, time to fill, contracts completed, revenue) and by how uncertain they are. These are the first ten to calibrate.

| Rank | Parameter | Default | Conf. | Why it matters |
|---|---|---|---|---|
| 1 | Search-state mix (ST-1 to ST-4): passive 35%, quietly looking 17%, active 8% | | M to L | Sets the addressable supply; the passive share is TinyData's whole thesis and the evidence is weakest exactly there. |
| 2 | Monthly move hazard, calibrated to 10 to 13% annual voluntary external moves | | M | Drives contracts completed; economy-wide anchor is about 9% (ONS). |
| 3 | Reply rate to a tailored approach by state (BEH-1): 3 / 15 / 35 / 55% | | A | First step of every funnel; personalisation roughly doubles it. |
| 4 | Offer acceptance and fall-through: 82% accept, 6% renege, counteroffer chain 35% made, 25% accepted, 50% leave within a year | | M / L / A | Determines how many matches become hires, especially in scarce roles. |
| 5 | Time to fill by hiring pattern: 30 / 25 / 12 / 60 / 95 / 70 days, plus notice periods | | M to L | Headline employer measure; notice periods add 1 to 6 months to time to start. |
| 6 | Hiring-pattern mix and supply to demand ratio per pattern (e.g. P4 10% of openings at 0.6 candidates each) | | A | Answers Soren's "in demand but less available" question directly. |
| 7 | Pay uplift on a move (+10%) and reservation wage by state | | M | Determines whether matches clear and the value of a hire, hence the fee base. |
| 8 | Time to re-employment for the displaced: 3.5 months under 50, 9 months over 50, scenario-scaled to 7 and 15 | | M / A | The scenarios' "Adjustment" input and a headline TinyData measure. |
| 9 | Annual occupation-change hazard: 5% baseline, 11% substantial, 20% extreme | | A (derived) | Sets the career-changer and displaced volume, and the value of evidence over titles. |
| 10 | Agency share of hires and cost per hire: 40% large employers, 60% SMEs; fee about 18%; reconcile with Simon's £6,475 | | L | Sets the revenue pool TinyData competes for and the savings it can claim. |

---

## 7. Gaps, calibration and the primary research we should run

**Biggest evidence gaps**

1. **Passive-candidate behaviour in the UK.** No representative UK source for how many people would reply to a confidential, tailored approach, or what makes them reply. Everything on BEH-1 is assumed.
2. **Counteroffers.** No robust UK data on how often they are made or accepted.
3. **CV omission (CV-3).** No study measures the share of real work skills missing from CVs. It underpins the "what a CV never says" promise and is currently an assumption.
4. **UK displacement by AI.** No UK study yet tracks AI-displaced workers' re-employment. The baseline uses general UK unemployment-scarring evidence.
5. **Sector-specific turnover and job-to-job rates.** Need ONS X02 or APS by industry (labour-data track).

**Calibration steps (proposed, not started)**

1. **Labour-data track:** replace sector tilts and turnover (BEH-22, pattern shares) with ONS X02, the ONS vacancy survey, ASHE and the Employer Skills Survey by SIC and SOC.
2. **Verify every [unverified] figure** against its primary document before anything goes to Simon, Kingston or an investor.
3. **Primary research (UK first, then one EU market, then the US as the Phase 1c demand test):**
   - A quantitative survey of about 1,500 workers across the three sectors, representative by level, age and gender (online panel, about two weeks). It measures search state, intents, deal-breakers, reply propensity to a confidential approach, and what they believe their CV misses.
   - 20 to 30 qualitative interviews covering displaced, augmented and career-changing workers, plus 10 to 15 hiring managers and in-house recruiters across the six hiring patterns. The interview guide is to be drafted by `consumer-researcher` with `product-designer`.
   - **Confidence discipline:** the survey can set levels. The interviews can only set mechanisms and language. They are not a basis for prevalence.
4. **Live-agent sample (layer 3 of the architecture):** use the 50 to 100 live agents to test sensitivity on BEH-1, BEH-7 to BEH-10 and CV-3. They are not ground truth: their outputs are hypotheses, to be checked against the survey.

**Lexicon note for `ai/taxonomy/`** (shared with `ai-researcher`): people say "step up", "more money", "better balance", "get away from my boss", "something more meaningful", "future-proof myself" and "I was made redundant". They rarely say "progression intent" or "displacement". Intent labels in the ecosystem should store the person's own phrase alongside the normalised INT code.

---

## Sources (consolidated)

Representative and official: [ONS X02 flows](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/labourforcesurveyflowsestimatesx02); [ONS redundancy rate](https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/redundancies/timeseries/beir/lms); [House of Commons Library labour market briefing](https://researchbriefings.files.parliament.uk/documents/CBP-9366/CBP-9366.pdf); [CIPD Good Work Index 2025](https://www.cipd.org/globalassets/media/knowledge/knowledge-hub/reports/2025-pdfs/8868-good-work-index-2025-report-web1.pdf); [CIPD flexibility research](https://www.cipd.org/en/about/press-releases/over-million-changed-jobs-over-lack-of-flexibility-cipd-research/); [CIPD Resourcing and talent planning 2024](https://www.cipd.org/globalassets/media/knowledge/knowledge-hub/reports/2024-pdfs/8662-resource-and-talent-planning-2024-report-web.pdf); [DfE Employer Skills Survey 2022](https://assets.publishing.service.gov.uk/media/672a2743094e4e60c466d160/Employer_Skills_Survey_2022_research_report__Nov_2024_.pdf); [DfE AI and UK jobs 2023](https://assets.publishing.service.gov.uk/media/656856b8cc1ec500138eef49/Gov.UK_Impact_of_AI_on_UK_Jobs_and_Training.pdf); [DfE Skills Bootcamps evaluation](https://assets.publishing.service.gov.uk/media/683729a7dc6ebc5eca0cbb29/Evaluation_of_skills_bootcamps_-_2022_to_2023_-_completions_and_outcomes_report.pdf); [Bank of England Agents' summary March 2026](https://www.bankofengland.co.uk/agents-summary/2026/march-2026); [DSIT cyber skills 2025](https://www.cyberexchange.uk.net/news/dsit-publishes-latest-insights-on-uk-cyber-security-skills-in-the-uk-labour-market-report/); [Centre for Ageing Better](https://ageing-better.org.uk/work-state-ageing-2023-4); [Eurostat job-to-job transitions (EU comparison, values not yet pulled)](https://ec.europa.eu/eurostat/databrowser/view/lfsi_long_e07/default/table?lang=en).

Academic: [Faberman, Mueller, Sahin and Topa](https://www.nber.org/system/files/working_papers/w23731/w23731.pdf); [Jacobson, LaLonde and Sullivan](https://research.upjohn.org/up_workingpapers/11/); [Davis and von Wachter](https://pmc.ncbi.nlm.nih.gov/articles/PMC5521015/); [Arulampalam](https://warwick.ac.uk/fac/soc/economics/staff/swarulampalam/publications/wagelossmarch01.pdf); [Braxton and Taska](https://ideas.repec.org/a/aea/aecrev/v113y2023i2p279-316.html); [Kambourov and Manovskii](https://www.sas.upenn.edu/~manovski/papers/occupation_specific_HC.pdf); [Carrillo-Tudela and Visschers](https://repository.essex.ac.uk/34821/1/Econometrica%20-%202023%20-%20Carrillo%E2%80%90Tudela%20-%20Unemployment%20and%20Endogenous%20Reallocation%20Over%20the%20Business%20Cycle.pdf); [Sackett et al. 2022](https://gwern.net/doc/statistics/meta-analysis/2021-sackett.pdf); [Brynjolfsson, Chandar and Chen](https://digitaleconomy.stanford.edu/publication/canaries-in-the-coal-mine-six-facts-about-the-recent-employment-effects-of-artificial-intelligence/); [Eloundou et al.](https://arxiv.org/pdf/2303.10130); [HBS and Burning Glass, skills-based hiring](https://www.hbs.edu/managing-the-future-of-work/Documents/research/Skills-Based%20Hiring.pdf).

Think tanks and research institutes: [Resolution Foundation, disloyalty bonus](https://www.resolutionfoundation.org/press-releases/growing-disloyalty-bonus-as-pay-growth-for-job-movers-hits-10-per-cent-for-first-time-since-early-2000s/); [Resolution Foundation, Get a move on](https://www.resolutionfoundation.org/app/uploads/2017/08/Get-a-move-on.pdf); [ISE recruitment survey 2025](https://ise.org.uk/knowledge/insights/498/5_trends_you_need_to_know_from_ises_recruitment_survey_2025/); [ISE application explosion](https://ise.org.uk/knowledge/insights/552/the_application_explosion_key_insights_for_employers/); [Timewise](https://timewise.co.uk/article/flexible-working-talent-imperative/); [WEF Future of Jobs 2025](https://www.weforum.org/press/2025/01/future-of-jobs-report-2025-78-million-new-job-opportunities-by-2030-but-urgent-upskilling-needed-to-prepare-workforces/); [Anthropic Economic Index](https://www.anthropic.com/research/anthropic-economic-index-september-2025-report); [Atlanta Fed Wage Growth Tracker](https://www.atlantafed.org/research-and-data/data/features/chcs/2025/09/11/wage-growth-tracker).

Industry and vendor (L unless noted): [PwC Hopes and Fears 2025](https://www.pwc.com/gx/en/news-room/press-releases/2025/pwc-2025-global-workforce-survey.html) (M); [PwC AI Jobs Barometer 2025](https://www.pwc.com/gx/en/news-room/press-releases/2025/ai-linked-to-a-fourfold-increase-in-productivity-growth.html) (M); [PwC Women Returners](https://www.pwc.co.uk/economic-services/women-returners/pwc-research-women-returners-nov-2016.pdf) (M); [Deloitte Gen Z and Millennial 2025](https://www.deloitte.com/global/en/about/press-room/deloitte-2025-gen-z-and-millennial-survey.html) (M); [Microsoft and LinkedIn Work Trend Index 2024](https://blogs.microsoft.com/blog/2024/05/08/microsoft-and-linkedin-release-the-2024-work-trend-index-on-the-state-of-ai-at-work/) (M); [LinkedIn Gender Insights](https://www.linkedin.com/business/talent/blog/talent-acquisition/how-women-find-jobs-gender-report) (M); [LinkedIn internal mobility](https://www.linkedin.com/business/talent/blog/talent-management/employees-stay-41-percent-longer-at-companies-that-do-this) (M); [LinkedIn Jobs on the Rise UK 2025](https://www.onrec.com/news/statistics/linkedin-reveals-the-jobs-the-rise-for-2025) (M); [Lightcast](https://lightcast.io/resources/blog/beyond-the-buzz-press-release-2025-07-23) (M); [Indeed Hiring Lab UK](https://hiringlab.indeed.com/uk/blog/2025/12/09/indeed-2026-uk-jobs-hiring-trends-report/) (M); [KPMG and REC Report on Jobs](https://kpmg.com/uk/en/media/press-releases/2025/12/kpmg-rec-uk-report-on-jobs.html) (M); [REC market size](https://www.rec.uk.com/our-view/news/press-releases/recruitment-sector-contributes-more-40-pounds-billion-year-uk-economy-despite-tough-job-market) (H); [Nash Squared and Harvey Nash](https://www.nashsquared.com/post/ai-creates-the-worlds-biggest-tech-skills-shortage-in-over-15-years-finds-nash-squared-harvey-nash-report) (M); [HireRight 2025](https://www.hireright.com/company/newsroom/identity-fraud-and-candidate-discrepancies-remain-key-concerns-for-employers) (M); [Gem 2026 benchmarks](https://www.gem.com/blog/key-takeaways-from-the-2026-recruiting-benchmarks-report) (M); [Ashby](https://www.ashbyhq.com/talent-trends-report/reports/2023-trends-report-offer-acceptance-rates) (M); [Greenhouse](https://www.greenhouse.com/blog/greenhouse-2024-state-of-job-hunting-report); [Glassdoor time to hire](https://www.glassdoor.com/blog/time-to-hire-in-25-countries/) (M); [Gallup](https://www.gallup.com/workplace/236570/employees-lot-managers.aspx) (M); [Michael Page Talent Trends](https://www.personneltoday.com/hr/michael-page-talent-trends/); [Robert Walters career cushioning](https://www.peoplemanagement.co.uk/article/1825366/one-third-professionals-career-cushioning-looking-roles-survey-finds); [Robert Walters UK 2026](https://www.robertwalters.co.uk/insights/news/blog/uk-professionals-more-confident-changing-jobs-than-asking-for-pay-rise.html); [Hays](https://www.hays.co.uk/market-insights/article/top-hiring-trends); [Gartner reneging via HR Executive](https://hrexecutive.com/why-new-hires-are-jilting-employers-and-what-to-do-about-it/); [Robert Half via HR Dive](https://www.hrdive.com/news/nearly-one-third-of-candidates-back-out-after-theyve-accepted-a-job-offer/555006/); [IPSE IR35 Spotlight 2025](https://www.ipse.co.uk/campaigns/ir35/ir35-spotlight-2025); [ZipRecruiter laid-off survey](https://www.ziprecruiter-research.org/survey-of-recently-laid-off-workers); [Pin outreach benchmarks](https://www.pin.com/blog/email-vs-linkedin-vs-sms-recruiting/); [KORE1 time to fill](https://www.kore1.com/time-to-fill-tech-role-2026/); [City AM on Big Four graduate cuts](https://www.cityam.com/big-four-slash-graduate-jobs-as-ai-takes-on-entry-level-work/); [Hidden Workers summary](https://www.brianheger.com/hidden-workers-untapped-talent-harvard-business-school-and-accenture/); [Careershifters compilation](https://www.careershifters.org/career-change-statistics?field_country_focus_value=UK); [StandOut CV](https://standout-cv.com/stats/how-many-applications-to-get-a-job); [CFOtech vacancy cost](https://cfotech.news/story/vacant-roles-cost-firms-usd-14-700-a-month-survey-finds); [UK recruitment statistics compilation](https://proplaybooks.co.uk/blog/uk-recruitment-statistics-2026).
