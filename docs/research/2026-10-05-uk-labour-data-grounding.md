---
source: ai
ratified: false
date: 2026-10-05
---

# UK labour-market data grounding for the TinyData job ecosystem

**Track:** architecture phase, research track 2 of 3 (see `product/job-ecosystem/2026-10-05-synthetic-job-ecosystem-brief.md`).
**Ask (Soren, 5 Oct 2026, verbatim extract):** "make sure that we statistically relevant across all of the job functions within that first uh, within those uh, economic verticals that Simon uh, discussed."
**Sectors (Simon, revenue plan v4):** Professional & Business Services (351,253 annual permanent hires), Technology & Digital (72,852), Finance & Insurance (54,639). Source: `corporate/finance/2026-10-05-simon-recruitment-revenue-assumptions-v4.md`.
**Working assumption:** about 2,000 open jobs and about 5,000 people.

## How to read the evidence marks

| Mark | Meaning |
|---|---|
| **[P]** | Read on the primary page this session. |
| **[S]** | Primary page found, but this session's network blocks ons.gov.uk, gov.uk, explore-education-statistics and huggingface.co, so the figure comes from the search engine's extract of that primary page. Re-check on the page before external use. |
| **[U]** | Unverified: secondary source, Claude's recall, or a link not opened. Do not use externally until checked. |
| **[E]** | Claude's estimate. No source; a placeholder to be replaced with a sourced figure. |

All sources accessed 5 October 2026 unless stated.

---

## 1. Summary

**Five core datasets**

1. **ONS Annual Population Survey (APS): employment by SOC 2020 4-digit x SIC 2007 section, 2021 to 2024.** This is the joint occupation x industry frame. ONS ad hoc 3136, free, OGL. [S] [link](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/adhocs/3136employmentbyoccupationandindustrysectionasuk2021to2024)
2. **ONS Workforce Jobs (JOBS02) and the Business Register and Employment Survey (BRES) on Nomis.** These give sector size and the region x industry split at fine SIC level. Free, OGL, Nomis API. [S] [JOBS02](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/workforcejobsbyindustryjobs02/current), [Nomis](https://www.nomisweb.co.uk/) [U for the BRES dataset path]
3. **ONS ASHE Tables 14 and 15.** Pay distributions by SOC 4-digit, and by region x SOC 4-digit. Free, OGL. [S] [Table 14](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/occupation4digitsoc2010ashetable14), [Table 15](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/regionbyoccupation4digitsoc2010ashetable15)
4. **ONS Vacancy Survey (VACS02, X06) plus ONS online job adverts (Textkernel) by SOC 2020.** The Vacancy Survey gives vacancies by industry; the adverts give occupation and place. Free, OGL. [S] [VACS02](https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/unemployment/datasets/vacanciesbyindustryvacs02/current), [Textkernel user guide](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/methodologies/measuringlabourdemandvolumesacrosstheukusingtextkerneldatauserguide)
5. **O*NET 31.0 task statements and the Anthropic Economic Index.** O*NET supplies the task inventory; the Index supplies observed AI usage and the automation or augmentation split per task. They are mapped to UK SOC 2020 via ISCO-08 and calibrated against UK exposure work (DSIT January 2026, DfE November 2023). O*NET is CC BY 4.0 [S]; the Index data is CC-BY and its code MIT [S]. [O*NET](https://www.onetcenter.org/database.html), [Index](https://huggingface.co/datasets/Anthropic/EconomicIndex)

**Sampling approach.**
- Generate hierarchically: sector, then function given sector, then seniority given function, then region given sector and function.
- Fit each layer to official marginals by iterative proportional fitting (raking), then integerise.
- Allocate the 2,000 jobs across sectors in proportion to Simon's hires (73.4% / 15.2% / 11.4%), with a floor of 20 jobs per sector x function cell and design weights to undo the oversampling.
- Size the 5,000 people by supply, not by jobs, so that the supply and demand ratio is an output rather than an input.
- Validate against held-out real data: Census 2021, Textkernel adverts and the Employer Skills Survey.

**Task and exposure approach.**
- Each synthetic role points to a SOC 2020 unit group, which maps to ISCO-08 and then to O*NET-SOC and ESCO.
- It inherits a weighted task list, and each task is tagged:
  - **unchanged:** no exposure and no observed use
  - **augmented:** exposed, with mainly augmentative use
  - **automated:** exposed, with mainly directive use
  - **new:** emerging tasks from ESCO v1.2, O*NET emerging tasks, Skills England and AI mentions in job adverts
- The tag rule draws on Eloundou et al. exposure and Anthropic Economic Index usage.
- The three Anthropic scenarios become UK demand shifts by role. UK anchors calibrate the scale: employment weights, DSIT exposure groups, ONS adoption by industry, the DSIT productivity range, and IPPR, TBI and Skills Imperative displacement ranges.

**Biggest data gaps.**
- **Job function is not an official classification.** Every within-sector function share is built from SOC x SIC and is partly judgement.
- **No official UK figures** for hires by sector, time to hire, notice periods or passive job search.
- **The LFS and APS have lost accredited status.**
- **No occupation x industry vacancy series.**
- **Task-level AI usage is US-mapped.** There is no UK task inventory.

---

## 2. Defining the three sectors (a decision for Simon)

Simon's sector names are commercial, not statistical. Proposed mapping to SIC 2007:

| Simon's sector | Core SIC 2007 | Size anchor | Watch-outs |
|---|---|---|---|
| Professional & Business Services | **M** (69 legal and accounting; 70 head offices and management consultancy; 71 architecture and engineering; 72 R&D; 73 advertising and market research; 74 other professional; 75 veterinary) + **N** (77 rental; 78 employment activities; 79 travel agencies; 80 security; 81 building services and cleaning; 82 office administration and business support) | M: 3,504k workforce jobs [S] ([ONS, Sept 2025 bulletin extract, period stated as June 2025](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/jobsandvacanciesintheuk/latest)); N: 2,952k, September 2025 [S] ([ONS](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/jobsandvacanciesintheuk/december2025)) | N includes cleaning, security and temps registered with agencies (78), which are large and not knowledge work. **Decide:** include all of M+N (matches "PBS" in Skills England and most recruiter usage), or a knowledge-work core (M without 75, plus 78 and 82). The function table shows both. |
| Technology & Digital | **J** (58 publishing incl. 58.2 software publishing; 59 to 60 media; 61 telecoms; 62 computer programming and consultancy; 63 information services), aligned to the DCMS Digital Sector definition | J: 1,602k workforce jobs, September 2025 [S] ([ONS](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/jobsandvacanciesintheuk/december2025)); DCMS Digital Sector 1.81m filled jobs in 2025, 5.2% of UK filled jobs, published 16 July 2026 [S] ([DCMS](https://www.gov.uk/government/statistics/economic-estimates-employment-in-the-digital-sector-january-2025-to-december-2025)) | Tech is also a **function** in every sector: tech roles in banks and consultancies sit in K and M. **Decide:** sector by employer SIC (consistent with Simon) and tag tech functions inside PBS and F&I separately, so they are not double counted. |
| Finance & Insurance | **K** (64 financial services; 65 insurance and pensions; 66 auxiliary, incl. fund management and brokers) | 1,110k workforce jobs, September 2025 [S]; down 78,000 (6.6%) from December 2024 to December 2025 [S] ([ONS](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/jobsandvacanciesintheuk/latest)) | Accountancy, legal and consulting firms serving finance sit in M (TheCityUK's "financial and related professional services" mixes the two). Keep them in PBS. |

**Classification horizon.** UK SIC 2026 was published in April 2026 and aligns with NACE Rev. 2.1. First use is expected in the 2031 Blue Book, so SIC 2007 stays the operating frame for every series used here [S/U] ([ONS UK SIC 2026 revision](https://www.ons.gov.uk/methodology/classificationsandstandards/ukstandardindustrialclassificationofeconomicactivities/uksic2026revisionprocess); detail via [secondary guide](https://siccodes.co.uk/guide/sic-2026-codes-guide) [U]). Design the schema with a `sic_version` field.

**Reconciliation flag on Simon's hire volumes** [E, arithmetic only]:

| Sector | Hires a year | Employment anchor | Implied rate |
|---|---|---|---|
| PBS | 351,253 | M+N, 6.46m | about 5.4% |
| T&D | 72,852 | 1.81m | about 4.0% |
| F&I | 54,639 | 1.11m | about 4.9% |

These look like a subset of all hires, for example agency-mediated permanent placements, rather than total sector hiring. The UK has no official hires series by sector (no UK JOLTS equivalent), so total hires can only be estimated from LFS flows (section 5). Ask Simon what the figure counts before the generator uses it for anything other than sector weights.

---

## 3. Classifications and taxonomies

| Source | What it gives | Licence and access | Cost | Notes |
|---|---|---|---|---|
| **SOC 2020** (ONS) | 9 major groups, 26 sub-major, 104 minor, 412 unit groups [S]; structure and descriptions in Excel/CSV | OGL; download from [SOC 2020 Volume 1](https://www.ons.gov.uk/methodology/classificationsandstandards/standardoccupationalclassificationsoc/soc2020/soc2020volume1structureanddescriptionsofunitgroups); coding index in [Volume 2](https://www.ons.gov.uk/methodology/classificationsandstandards/standardoccupationalclassificationsoc/soc2020/soc2020volume2codingrulesandconventions) | Free | The occupation key for every UK series. Use the [Extended SOC 2020](https://www.ons.gov.uk/methodology/classificationsandstandards/standardoccupationalclassificationsoc/standardoccupationalclassificationsocextensionproject) (6-digit) for finer job titles, e.g. separating actuaries from statisticians. |
| **SOC 2020 to ISCO-08** (ONS) | Mapping note and correspondence | OGL; [ONS page](https://www.ons.gov.uk/methodology/classificationsandstandards/standardoccupationalclassificationsoc/soc2020/classifyingthestandardoccupationalclassification2020soc2020totheinternationalstandardclassificationofoccupationsisco08) | Free | Many-to-many: "There is no simple mapping ... even at the most detailed (unit group) level" [S]. Carry mapping weights, not a single code. |
| **SIC 2007** (ONS) | Industry sections A to U, down to 5-digit | OGL | Free | See section 2. |
| **ESCO v1.2 / v1.2.1** (European Commission) | About 3,039 occupations and 13,890 skills, 28 languages, built as a fifth level under ISCO-08 [S] | Free reuse for any purpose under Commission Decision 2011/833/EU; CSV/RDF download and JSON API [S] ([ESCO v1.2](https://esco.ec.europa.eu/en/about-esco/escopedia/escopedia/esco-v12), [FAQ](https://esco.ec.europa.eu/en/about-esco/faq)) | Free | Best source for **skills** per occupation (essential and optional), European framing. Weak on task time shares. |
| **O*NET 31.0** (US Department of Labor) | Task statements, importance and relevance ratings, detailed work activities, about 900 occupations; 31.0 released August 2026 [S] | CC BY 4.0 [S] ([licence](https://www.onetcenter.org/license_db.html), [database](https://www.onetcenter.org/database.html)); CSV/Excel/JSON download and web services | Free | Best **task inventory** with ratings. US occupations and US job design. |
| **US SOC to ISCO-08 crosswalks** (BLS) | Link O*NET-SOC to ISCO-08 | Public domain; [BLS crosswalks](https://www.bls.gov/soc/soccrosswalks.htm) [U: file vintages not checked] | Free | Chain: SOC 2020 (UK) to ISCO-08 to US SOC 2018 to O*NET-SOC. Each hop loses precision; record the path per role. |
| **LMI for All** (DfE / Warwick IER) | API that has exposed O*NET-derived skills and tasks against UK SOC | [lmiforall.org.uk](https://www.lmiforall.org.uk/) [U: whether it now uses SOC 2020 not checked] | Free | Could save the crosswalk work; check vintage. |

### Defining "job functions"

No official UK statistic counts "functions". A function is a cluster of SOC 2020 unit groups, conditioned on sector. For example, SOC 2421 accountants in a bank count as "finance (in-house)", and in an accountancy firm as "audit and tax (fee-earning)".

Proposed rule:

1. **Function = SOC 2020 unit group(s) x sector context.** A mapping table assigns each of the 412 unit groups to one function per sector, with a split weight where one SOC code serves two functions (e.g. 2433 actuaries, economists and statisticians splits into actuarial or risk in F&I, and data or research in PBS).
2. **Fee-earning against support.** Each function is flagged as the sector's core product (legal in a law firm, underwriting in an insurer) or as a corporate function (HR, finance, IT). This matters because agencies, hiring speed and AI exposure differ.
3. **Seniority is separate from function.** Seniority is derived from SOC major group (1 = managers and directors; 2 = professional; 3 = associate professional; 4 = administrative) and from position in the ASHE pay distribution. It is never baked into the function name.

The function list per sector is in section 10.

---

## 4. Employment counts by occupation x industry

| Source | Grain | Licence, access, cost | Strengths | Limits |
|---|---|---|---|---|
| **APS ad hoc 3136: employment by SOC 2020 4-digit x SIC section A to S, UK, 2021 to 2024** | SOC4 x SIC section, annual | OGL, Excel download, free [S] ([ONS](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/adhocs/3136employmentbyoccupationandindustrysectionasuk2021to2024)) | The only ready-made UK SOC4 x industry table. **First file to download.** | Section level only (M, N, J, K, not 62 or 69.2); small cells suppressed or unreliable; APS lost accreditation (below). |
| **APS/LFS on Nomis** (e.g. APS168 employment by occupation, regional) | SOC x region, annual rolling | OGL, [Nomis](https://www.nomisweb.co.uk/datasets/aps168), free REST API [S] | Region splits (London against the rest). | Same quality caveat; some Nomis tables still on SOC 2010 [S]. |
| **LFS microdata** (UK Data Service) | Person level: SOC, SIC, region, tenure, job search, contract, homeworking | End User Licence via [UK Data Service](https://ukdataservice.ac.uk/) (free registration); finer geography via Secure Access [U] | Lets us build our own cross-tabs (SIC 2-digit x SOC4 x region) and the worker-side variables in section 7. | Sample size; quality issues below. |
| **BRES** (Nomis) | Employee jobs by 5-digit SIC x local area | OGL, Nomis, free [U: latest vintage not checked] | Best for industry x region (e.g. share of K jobs in London). | No occupation. |
| **Census 2021** (England and Wales) | SOC4 x SIC, small areas, as at 21 March 2021 [S] | OGL; [TS063 on Nomis](https://www.nomisweb.co.uk/datasets/c2021ts063); custom cross-tabs via ONS "create a custom dataset" [S] ([ONS industry variable](https://www.ons.gov.uk/census/census2021dictionary/variablesbytopic/labourmarketvariablescensus2021/industrycurrent)) | Full count, so it is ideal as a **held-out validation** set for occupation x industry structure. | 2021, taken during furlough [U: check the ONS caveat wording]; England and Wales only (Scotland 2022 and NI separate). |
| **Workforce Jobs JOBS02** | Jobs by SIC section, quarterly, incl. self-employment | OGL, free [S] | Sector size anchor; employee against self-employed split. | No occupation. |
| **Working Futures / The Skills Imperative 2035** (Warwick IER and Cambridge Econometrics for NFER) | Projections by SOC and sector to 2035, with alternative scenarios | Free PDFs and workbooks [S] ([NFER](https://www.nfer.ac.uk/publications/the-skills-imperative-2035-occupational-outlook-long-run-employment-prospects-for-the-uk/), [alternative scenarios WP2b](https://www.nfer.ac.uk/media/hpuhn0p1/the_skills_imperative_2035_occupational_outlook_longrun_employment_prospects_for_the_uk_alternative_scenarios_working_paper_2b.pdf)) | **Counterfactual baseline**: 2.6m new jobs projected by 2035, nearly 90% in higher-skilled groups, about 2m jobs displaced by new technologies [S]. | Pre-dates frontier agentic AI; check licence on workbooks [U]. |
| **Skills England Sector Skills Needs Assessments 2026** | Priority occupations per sector, projections 2025 to 2035 | Free PDFs [S] ([collection](https://www.gov.uk/government/publications/skills-england-annual-skills-report-and-sectoral-skills-needs-assessments-2026), [PBS, 1 June 2026](https://assets.publishing.service.gov.uk/media/6a185cb2c7335e2ca6daacbf/sna_professional_and_business_services.pdf)) | Digital and Technologies +239,000 jobs in priority occupations (+27.3%); PBS +116,000 (+8.8%); 92% of PBS additional priority employment needs Level 4+ [S]. | Industrial Strategy sector definitions differ from SIC sections. |

**Quality caveat (material).**
- **LFS:** accredited status removed in November 2023 [S].
- **APS:** accreditation suspended in October 2024 [S].
- **August 2026:** ONS told the Office for Statistics Regulation that APS outputs will not be considered for reaccreditation until they move to the Transformed Labour Force Survey (TLFS) [S] ([ONS letter, 11 Aug 2026](https://www.ons.gov.uk/news/statementsandletters/onslettertotheofficeforstatisticsregulationregardingthedesignationoflabourforcesurveyandannualpopulationsurveyoutputs11august2026)).
- **Transition target:** the TLFS is aimed at 2027 for headline statistics [S].

**Implication:** use LFS and APS for **shares and structure**, pooled over 2022 to 2024 to cut noise. Use JOBS02, BRES and Census for **levels**. Say this in the methods note.

---

## 5. Pay distributions (ASHE)

- **Grain.** [Table 14](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/occupation4digitsoc2010ashetable14) covers SOC 4-digit; [Table 15](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/datasets/regionbyoccupation4digitsoc2010ashetable15) covers region x SOC 4-digit. Both give weekly, hourly and annual pay, with percentiles (10th to 90th), by sex and full-time or part-time. SOC 2020 is used from the 2021 edition on [S]. Table 16 covers industry by 4-digit SIC [U].
- **Licence and access.** OGL, Excel, free.
- **Latest figures.** The 2025 provisional edition (published 23 October 2025) suppresses some Table 14 and 15 estimates for quality [S]. The 2026 provisional edition is expected late October 2026 [U: date not checked].
- **Headline figures, April 2025 [S]** ([ONS bulletin](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/earningsandworkinghours/bulletins/annualsurveyofhoursandearnings/2025)):
  - median full-time weekly pay £766.60 (+5.3% nominal)
  - median full-time annual pay £39,039
  - highest-paid occupation: chief executives and senior officials, £99,944
- **Programmers and software development professionals:** median full-time annual pay of £56,914 is reported as ASHE Table 14 2025 provisional by a [secondary site](https://payprecision.co.uk/salaries/software-developer/) [U].
- **London premium:** a London full-time median of about £47,500 (about 22% above the UK) is reported [U, secondary]. Take it from Table 15 directly.
- **Limits:**
  - **Employees only:** no self-employed or contractors, which matters for T&D contracting.
  - **Basic pay only:** bonuses are captured only partly in annual figures, which matters for F&I front office.
  - **No published occupation x industry x region table.** A bespoke cut needs the ASHE microdata via the ONS Secure Research Service (accredited researcher, free but slow) [U].
- **Use.** Fit a lognormal (or a spline through the deciles) per SOC4, shift by region using the Table 15 ratios, and set seniority bands as pay quantiles (entry at the 10th to 25th percentile, director or partner above the 90th) [E: band cut-offs are a design choice].

---

## 6. Vacancies and hiring flows

| Source | Grain | Licence, access, cost | Latest figures | Use |
|---|---|---|---|---|
| **ONS Vacancy Survey: VACS02 (3-month, accredited), X06 (single month by industry and size, not accredited)** | 18 industry sections | OGL, free [S] ([VACS02](https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/unemployment/datasets/vacanciesbyindustryvacs02/current), [X06](https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/unemployment/datasets/x06singlemonthvacanciesestimatesnotdesignatedasnationalstatistics/current)) | About 702,000 vacancies, June to August 2026; down 36,000 (4.9%) on the year, falling in 13 of 18 industries; professional, scientific and technical down 8,000 on the year [S] ([ONS, Aug 2026](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/jobsandvacanciesintheuk/august2026)). X06 last released 15 Sept 2026, next 20 Oct 2026 [S]. | Vacancy **stock by sector**: the real counterpart of our 2,000 jobs. No occupation. |
| **ONS online job adverts (Textkernel), by SOC 2020 x local authority / ITL** | SOC4 x geography, monthly | OGL, free; official statistics in development [S] ([user guide](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/methodologies/measuringlabourdemandvolumesacrosstheukusingtextkerneldatauserguide), [quality metrics](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/qualitymetricsforlabourdemandvolumesbystandardoccupationclassificationsoc2020)); January 2017 to September 2025 release on 24 Oct 2025 [S] | Adverts are a proxy for demand and also reflect changes in recruitment practice [S]. | **Function mix of demand** within a sector (via SOC), and region. Industry of the advertiser is weak or absent [U]. |
| **DfE Occupations in Demand 2025** | SOC 2020 4-digit rated "critical", "elevated" or "not in high demand" from five indicators | Free, Explore Education Statistics [S] ([release](https://explore-education-statistics.service.gov.uk/find-statistics/occupations-in-demand/2025), [methodology](https://explore-education-statistics.service.gov.uk/methodology/occupations-in-demand-2025-methodology)) | 2025 dropped skill-shortage vacancy density (ESS 2024 has no SOC4 breakdown) and uses visa grant density and quarterly advert density [S]. | Direct input to the **"in demand but scarce"** and **"always hiring"** tags per SOC4. |
| **LFS flows (X02)** | Employment, unemployment and inactivity flows, quarterly; microdata for job-to-job moves | OGL, free [S] ([X02](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/datasets/labourforcesurveyflowsestimatesx02)); released 18 Aug 2026 [S] | Q4 2025: 204,000 job-to-job resignations, 64,000 dismissals or redundancies [U: via Statista, citing ONS]. | Estimate **total hires** by sector and occupation (job-to-job plus unemployed-to-employed plus inactive-to-employed), to reconcile Simon's hire volumes. |
| **KPMG and REC UK Report on Jobs** (S&P Global, about 400 agencies) | Monthly diffusion indices: placements, candidate availability, starting pay, by sector and region | Press release free; full sector series by subscription [U] ([Sept 2026](https://kpmg.com/uk/en/media/press-releases/2026/09/kpmg-and-rec-uk-report-on-jobs-september-2026.html), [REC](https://www.rec.uk.com/our-view/reports-jobs)) | September 2026: permanent placements rose for the first time since late 2022; candidate supply rose at the fastest pace in three months [S/P]. | **Direction** of agency-route conditions per sector. Diffusion indices, not levels. |
| **DfE Employer Skills Survey 2024** | Hard-to-fill (HtFV) and skill-shortage vacancies (SSV) by sector and occupation major group | Free report and tables [S] ([release](https://explore-education-statistics.service.gov.uk/find-statistics/employer-skills-survey/2024), [UK report, Nov 2025](https://assets.publishing.service.gov.uk/media/6a1eef8d050971fbebf3bd92/Employer_Skills_Survey_2024_UK_report.pdf)) | 22,712 employers; 345,300 HtFV (850,000 in 2022); 27% of vacancies were SSVs (36% in 2022); Business Services HtFV 58,000 (102,400 in 2022); Information and Communications SSV density 43% to 17%; Financial Services the exception, with no significant fall in employers reporting HtFV [S] | **Scarcity priors** by sector x occupation major group. No SOC4. |
| **Indeed Hiring Lab** | UK postings index by Indeed occupational category, region and city; AI-term and remote-term trackers | CC BY 4.0, GitHub, free [S] ([postings](https://github.com/hiring-lab/job_postings_tracker), [AI tracker](https://github.com/hiring-lab/ai-tracker), [remote tracker](https://github.com/hiring-lab/remote-tracker)) | Daily, refreshed weekly [S]. | **Trend** by category; share of adverts mentioning AI, which feeds the **new** task tag. Index, not counts. |
| **Adzuna API** | Live UK adverts with salary | Free key; 25 calls/minute, 250/day, 2,500/month; commercial use limited to a 14-day trial, then a licence [P] ([terms](https://developer.adzuna.com/docs/terms_of_service)) | | Prototype only, unless licensed. Do not store adverts verbatim. |
| **Lightcast** | Deduplicated postings, skills, SOC-coded | Commercial licence, quoted per contract; public-good access for non-profits since April 2026 [U, secondary] ([Lightcast UK data](https://lightcast.io/uk/about/data), [secondary review](https://jobspipe.dev/blog/lightcast-api)) | Analyst seats from about £2,000 a year [U, reseller] ([The Data City](https://thedatacity.com/product-service/jobs-skills-data/)) | Strongest paid option for advert duration and skills. |
| **Textkernel Jobfeed** | Same data family as the ONS adverts series | Commercial; API and feed not publicly priced [U] ([Jobfeed](https://www.textkernel.com/jobfeed/)) | | Alternative to Lightcast. |

**Time to hire.** There is **no official UK statistic**. The brief's 4.7 weeks (tech) and 5.9 weeks (finance) come from `UK_Recruitment_Journeys.docx`. A secondary page repeats them, attributed to LinkedIn [U] ([NatWest Mentor](https://www.natwestmentor.co.uk/news/time-to-hire-in-the-uk)), but the primary source is not found. Options:
- licensed advert-duration data (Lightcast, Textkernel) as a proxy (advert open days are not time to fill)
- REC or vendor surveys
- our own recruiter interviews

Treat time to hire as **[E] with ranges** until sourced.

---

## 7. Shortage signals

- **Immigration Salary List (ISL).**
  - It replaced the Shortage Occupation List on 4 April 2024 [S].
  - From 22 July 2025, ISL inclusion gives only a discount on the general salary threshold, for example £33,400 instead of £41,700 for RQF 6+ roles. It no longer lowers the skill requirement [U, secondary] ([summary](https://vanessaganguin.com/news/what-jobs-are-on-the-temporary-shortage-list-and-immigration-salary-list-from-22-july-2025/)).
  - The secondary sources name 2433 (actuaries, economists and statisticians) and 2434 (business and related research professionals) in the RQF 6+ salary tables. Whether they sit on the ISL itself is **[U]**: check against [Appendix Immigration Salary List](https://www.gov.uk/guidance/immigration-rules/immigration-rules-appendix-immigration-salary-list) [U: link not opened].
- **Temporary Shortage List (TSL).**
  - **Stage 1** (9 October 2025) shortlisted 82 occupations [S].
  - **Stage 2 final report** (July 2026) recommends 28 occupations for 18 months from 1 January 2027. They are medium-skilled roles in advanced manufacturing, clean energy, digital and technology, and critical infrastructure, including **Data analysts (SOC 3544)**, database administrators and web content technicians [S] ([MAC Stage 2 report](https://assets.publishing.service.gov.uk/media/6a60e04534dfb74772f96d70/MAC_TSL_Stage_2_report.pdf), [Personnel Today](https://www.personneltoday.com/hr/temporary-shortage-list-mac-proposals/)).
  - The interim TSL runs to 31 December 2026 [S].
- **Use.** Shortage lists are a **binary scarcity flag** per SOC4, combined with DfE Occupations in Demand and ESS densities. Few of our three sectors' graduate roles are on these lists, which itself is a signal: scarcity in PBS and F&I is about experience and regulated status (SRA, FCA certification), not national shortage.

---

## 8. Worker side

| Topic | Best UK source | Access | Status |
|---|---|---|---|
| **Tenure** (months with current employer) | LFS microdata (employment length variable) | UK Data Service EUL, free [U: variable name to confirm in LFS User Guide Vol. 3] | Sourced once extracted |
| **Job search while employed** | LFS asks employed respondents whether they are looking for a different or additional job, why, and how [U: variable names, e.g. DIFJOB, to confirm] | As above | Gives **active** search only. **Passive openness** ("would move for the right role") has no official UK source; vendor surveys only [E]. |
| **Mobility** (job-to-job, sector switches, occupation switches) | LFS longitudinal (two-quarter and five-quarter) datasets; X02 flows | UK Data Service; ONS [S] | Sourced; small cells at SOC4 x sector. |
| **Hybrid and remote** | ONS Opinions and Lifestyle Survey: 28% of working adults in Great Britain hybrid-worked, January to March 2025; information and communication 49%, professional, scientific and technical 42%; managers and professionals most likely [S] ([ONS, 11 June 2025](https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/articles/whohasaccesstohybridworkingreatbritain/2025-06-11)); Indeed remote-term tracker for adverts [S] | Free | Sourced by industry; F&I-specific share [U]. |
| **Contract types** (permanent, temporary, self-employed, zero-hours) | ONS EMP07 (temporary), EMP17 (zero-hours) [U: dataset links not opened]; JOBS02 self-employment by industry [S] | Free, OGL | Sourced at sector level. **Contractors in tech** (outside IR35 or umbrella): no official split [E]. |
| **Notice periods** | Statutory minimum only: one week after one month's service, then one week per complete year, up to 12 weeks (Employment Rights Act 1996, s.86) [U: link not opened this session] ([legislation.gov.uk](https://www.legislation.gov.uk/ukpga/1996/18/section/86)) | Free | **Contractual norms** (often one month junior, three months senior, longer with garden leave in F&I front office) are market convention with **no official source** [E]. |
| **Regulated status** | SRA (solicitors), FCA Senior Managers and Certification Regime, ICAEW/ACCA, IFoA (actuaries) | Public registers | Use as claim types; counts per register [U]. |

---

## 9. Task-level data and AI exposure

### 9.1 Sources

| Source | Unit | Origin | UK applicability | Licence and access | Key figures |
|---|---|---|---|---|---|
| **O*NET 31.0 task statements** | Task x O*NET-SOC with importance, relevance and frequency | US | **Medium.** Task content of knowledge jobs travels well; regulated tasks (SRA, FCA, Solvency II, UK GAAP) do not. Needs UK additions. | CC BY 4.0, free [S] | 31.0, August 2026 [S] |
| **ESCO v1.2** | Skills and knowledge per ESCO occupation (ISCO-08 based) | EU | **High** for skills vocabulary; no task time shares | Free reuse (2011/833/EU), API [S] | Section 3 |
| **Eloundou et al., "GPTs are GPTs"** | Task-level exposure labels: E0 none, E1 direct, E2 with tools; occupation β = E1 + 0.5 x E2 [S] | US, O*NET | **Medium.** Capability-based, so it travels if UK tasks match | Paper [arXiv 2303.10130](https://arxiv.org/abs/2303.10130); data on GitHub (openai/GPTs-are-GPTs) [S]; data licence **[U]** | Theoretical exposure; GPT-4 era |
| **Anthropic Economic Index** | Share of Claude conversations per O*NET task; collaboration pattern (directive and feedback loop = automation; iteration, learning and validation = augmentation); from January 2026, "economic primitives" (task complexity, skills, autonomy, success) | Global usage, mapped to US O*NET | **Medium.** Usage is global (the UK is a top-five user country by volume [P]) but task mapping is US | Data CC-BY, code MIT; releases 2026-01-15, 2026-03-24, 2026-06-26 [S] ([HF](https://huggingface.co/datasets/Anthropic/EconomicIndex)) | Claude.ai 45% automated, 52% augmented (Nov 2025); 1P API 75% automated, 25% augmented [P] ([Jan 2026 report](https://www.anthropic.com/research/anthropic-economic-index-january-2026-report)) |
| **Anthropic, "Labor market impacts of AI: a new measure"** (5 March 2026) | "Observed exposure" per occupation: Eloundou β x usage, automated uses full weight, augmentative half weight | US | Medium | Paper page [P] ([link](https://www.anthropic.com/research/labor-market-impacts)); data release not stated on page [P] | Computer programmers 75% coverage; data entry keyers 67%; financial analysts in the top ten; no systematic rise in unemployment for highly exposed workers since late 2022; tentative hiring slowdown for ages 22 to 25 [P] |
| **DSIT, "Assessment of AI capabilities and the impact on the UK labour market"** (28 Jan 2026, Future of Work Unit) | UK workforce by exposure x complementarity | **UK** | **High** | Free [S] ([gov.uk](https://www.gov.uk/government/publications/assessment-of-ai-capabilities-and-the-impact-on-the-uk-labour-market/assessment-of-ai-capabilities-and-the-impact-on-the-uk-labour-market)) | 35% high exposure and high complementarity, 32% high exposure and low complementarity, 33% low exposure; adverts fell 38% for high-exposure occupations against 21% for low, 2022 to 2025; AI could add 0.4 to 1.2 percentage points a year to UK labour productivity growth over the next decade [S] |
| **DfE, "The impact of AI on UK jobs and training"** (Nov 2023) | AI Occupational Exposure (AIOE, Felten et al. method) by UK SOC, sector, region, qualification | **UK** | **High** for ranking; pre-agentic | Free PDF [S] ([link](https://assets.publishing.service.gov.uk/media/656856b8cc1ec500138eef49/Gov.UK_Impact_of_AI_on_UK_Jobs_and_Training.pdf)) | Finance and insurance most exposed sector, then information and communication and professional, scientific and technical; most exposed occupations include management consultants and business analysts, accountants, and finance, legal and business management roles; London and South East most exposed [S] |
| **GLA, "London's workforce exposure to generative AI"** (April 2026) | London occupations by exposure level | **UK (London)** | High, for the regional split | Free [S] ([GLA](https://data.london.gov.uk/blog/londons-workforce-exposure-to-generative-artificial-intelligence), [Personnel Today](https://www.personneltoday.com/hr/london-workers-ai-exposure-2026-gla/)) | At least 46% of London workers (about 2.4m) are in roles where GenAI could automate a share of tasks, against 38% for the UK; 313,000 (about 6%) are in the highest exposure level, largely administrative [S] |
| **ILO, Gmyrek et al., refined global index** (WP140, May 2025) | Exposure by ISCO-08 4-digit, task-based | Global, ISCO | **High via ISCO.** Same occupational spine as ESCO and the SOC 2020 to ISCO-08 mapping | Free paper ([PDF mirror](https://www.developmentaid.org/api/frontend/cms/file/2025/05/WP140_web.pdf)); [data portal](https://pgmyrek.shinyapps.io/AI_Data_Portal_Research/) [S]; data licence **[U]** | 4-digit scores; earlier version covered 427 occupations and 3,265 tasks [S] |
| **IMF, Cazzaniga et al., SDN/2024/001** (Jan 2024) | Exposure and complementarity (C-AIOE) by occupation | Global, incl. UK | Medium; the basis for DSIT's 70% figure [S] | Free [S] ([IMF](https://imf.org/en/Publications/Staff-Discussion-Notes/Issues/2024/01/14/Gen-AI-Artificial-Intelligence-and-the-Future-of-Work-542379)) | 60% of advanced-economy jobs exposed; about 40% globally [S] |
| **OECD Employment Outlook 2023** | Exposure and automation risk | OECD incl. UK | Context | Free [S] ([OECD](https://www.oecd.org/en/publications/oecd-employment-outlook-2023_08785bba-en/full-report/artificial-intelligence-and-jobs-no-signs-of-slowing-labour-demand-yet_5aebe670.html)) | Occupations at highest risk of automation are about 27% of employment (all automation, not only AI) [S] |
| **IPPR, "Transformed by AI"** (27 March 2024) | UK tasks by GenAI exposure; displacement scenarios | **UK** | High, as scenario anchors | Free [S] ([IPPR](https://www.ippr.org/articles/transformed-by-ai)) | 11% of UK tasks exposed now, up to almost 60% with deeper integration; second-wave scenarios: worst 7.9m jobs lost with no GDP gain; central 4.4m lost with +6.3% GDP; best none lost with +13% GDP [S] |
| **Tony Blair Institute** (Nov 2024) | UK displacement path | **UK** | Medium; method criticised (GPT-4 task scoring) [U] | Free [U: primary link not found] ([secondary](https://www.britsafe.org/safety-management/2024/ai-could-displace-3m-uk-jobs-but-losses-to-be-offset-by-newly-created-roles-report-finds)) | 1m to 3m displaced by 2050; peak 60,000 to 275,000 a year, against about 450,000 average annual job losses [U] |
| **ONS Business Insights and Conditions Survey (BICS)**, AI-use questions | Firm AI adoption by industry | **UK** | **High** for the scenario "adoption" input | Free, OGL [U: current question wording and figures not checked] | To extract |

### 9.2 US against UK: what transfers

| Element | US source | Transfers to UK? | UK correction |
|---|---|---|---|
| Task list per occupation | O*NET | Mostly, for knowledge work | Add UK regulated tasks per function (SRA, FCA SMCR, AML, Solvency II, IFRS 17, UK GAAP, IR35); drop US-only tasks (e.g. US tax forms) |
| Theoretical exposure per task | Eloundou | Yes (capability-based) | None needed |
| Observed usage per task | Anthropic Economic Index | Partly: global usage, US mapping | Scale by UK adoption by industry (BICS); check rank order against DfE and DSIT UK rankings |
| Occupation weights | US employment | **No** | Replace with APS 3136 UK SOC4 x SIC weights |
| Scenario magnitudes | Anthropic US GDP, labour share | **No** | Translate via UK anchors in 9.4 |

### 9.3 Attaching a tagged task list to each synthetic role

1. **Map.**
   - Role, then SOC 2020 unit group (and Extended SOC where useful).
   - Then ISCO-08 (ONS mapping, weighted).
   - Then O*NET-SOC (BLS crosswalk) and ESCO occupation.
   - Keep the top one to three O*NET matches with weights.
2. **Build the task bundle.**
   - Take core O*NET tasks with importance and relevance ratings; normalise them to time shares w_t, which sum to 1 per role.
   - Merge near-duplicates across the matched O*NET occupations.
   - Add 2 to 5 UK-specific tasks per function from regulator handbooks [E: hand-curated].
3. **Tag each task.** Proposed rule, thresholds to be tuned:
   - **unchanged:** Eloundou E0, or no observed usage in the Economic Index.
   - **augmented:** E1 or E2, with usage present, and augmentation patterns dominant (iteration, learning, validation).
   - **automated:** E1, with usage present, and automation patterns dominant (directive, feedback loop).
   - **new:** not in O*NET. Sources, in order of strength:
     - O*NET emerging tasks
     - ESCO v1.2 new skills [S]
     - Skills England D&T skill list: "machine-learning-assisted development tools, low/no-code automation ... governing AI, audit trails, and bias testing" [S]
     - AI-term job adverts (Indeed AI tracker)
4. **Store per task:**
   - the tag
   - the evidence (β, usage share, automation ratio, source release date)
   - a confidence level
   - a `scenario_sensitivity` flag (does the tag flip under the substantial or extreme capability settings?)
5. **Roll up per role:**
   - A_r = automated share (time-weighted)
   - G_r = augmented share
   - U_r = unchanged share
   - N_r = new-task share
6. **UK check.**
   - Compare the role ranking on A_r + G_r with the DfE AIOE and ILO WP140 rankings using Spearman's rho.
   - Flag roles where US-derived and UK-derived ranks disagree by more than one quintile.

### 9.4 Translating the Anthropic scenarios into UK demand shifts (proposal, [E])

The explorer has five inputs: capabilities C, adoption D, autonomy U, productivity P and adjustment J ([doc](../../../docs/reference/2026-10-05-anthropic-economic-scenarios.md); [Anthropic page, v1.0, September 2026](https://www.anthropic.com/institute/econ-scenarios) [P]). The page gives outcome figures but not per-scenario input values [P]:

| Scenario | GDP | Labour share of GDP |
|---|---|---|
| Modest | +1.6% | 59.4% |
| Substantial | +8.3% | 56.1% |
| Extreme | +32.4% | 45.2% |

The input values must come from the technical report (Korinek et al., 2026) [U: not yet read].

Per role r, under scenario s, to 2030:

- displaced work share = A_r x C_s x D_s(UK, sector) x U_s
- augmentation saving = G_r x D_s(UK, sector) x (P_s minus 1) / P_s, partly re-absorbed by demand growth with sector elasticity e (0 to 1)
- net demand shift = baseline projection growth (Skills Imperative / Skills England) minus displaced share minus augmentation saving x (1 minus e) plus N_r x D_s
- adjustment time for displaced people = J_s, scaled by UK LFS unemployment-to-employment exit rates for the person's previous occupation

**UK figures that make this work:**
- **Employment weights:** APS 3136.
- **Adoption D by sector:** ONS BICS AI use by industry [U].
- **Exposure ordering:** DfE AIOE; DSIT's exposure x complementarity groups. The 35/32/33 split sets the share of roles where G dominates against A.
- **Productivity range:** DSIT's 0.4 to 1.2 percentage points a year.
- **Observed early demand signal:** DSIT's adverts fall of 38% against 21%; ONS Textkernel adverts by SOC.
- **Displacement envelopes for calibration:**
  - Modest is calibrated to TBI and Skills Imperative-like magnitudes (low hundreds of thousands peak unemployment effect).
  - Substantial to IPPR central (4.4m jobs economy-wide).
  - Extreme to IPPR worst (7.9m) and beyond, consistent with Anthropic's labour-share fall.
  - This mapping is Claude's proposal, not a sourced equivalence.
- **Sector concentration:** DfE ranks finance and insurance as the most exposed sector, then information and communication and professional services [S].

---

## 10. Job functions per sector

**Read first.**
- The **employment shares are Claude's estimates [E]**. They are planning placeholders to be replaced by shares computed from APS ad hoc 3136 (SOC4 x section), split within sections using LFS microdata and BRES.
- The **AI exposure ratings** combine DfE 2023 (sector and occupation ranking), the Anthropic Economic Index and the Anthropic observed-exposure paper (programmers, customer service, data entry, market research and financial analysts high), and GLA 2026 (administrative roles highest).
- Ratings: H = high, M = medium, L = low.
- **Confidence** has two parts: share confidence / exposure confidence.
- SOC 2020 codes are given only where checked this session (3544, 2433, 2434) or recalled with high confidence. All codes are **[U]** until checked against SOC 2020 Volume 1.

### Professional & Business Services (SIC M + N)

| Function | Example SOC 2020 unit groups [U] | Indicative share of sector employment [E] | AI exposure | Likely task mix today | Confidence |
|---|---|---|---|---|---|
| Legal (solicitors, barristers, paralegals, legal secretaries) | 2412 barristers and judges; 2413 solicitors and lawyers; legal associate professionals | 8% | H (DfE: legal professionals) | Augmented research and drafting; automated document review | Low / Medium |
| Accounting, audit and tax | 2421 chartered and certified accountants; 2423 taxation experts; bookkeepers | 10% | H (DfE: accountants) | Automated reconciliation and bookkeeping; augmented audit judgement | Low / Medium |
| Consulting and business analysis | 2431 management consultants and business analysts; 2434 business and related research professionals | 6% | H (DfE top-ranked) | Augmented analysis and writing | Low / Medium |
| Engineering and architecture | Civil and other engineers; architects; technicians | 10% | M | Augmented design documentation; unchanged site work | Low / Low |
| Science and R&D | Scientists, lab technicians | 3% | M | Augmented literature and analysis; unchanged lab work | Low / Low |
| Marketing, advertising and market research | Marketing professionals; market research | 5% | H (Index: market research analysts) | Automated copy and research summaries | Low / Medium |
| Sales and business development | Business sales executives; account managers | 5% | M | Augmented prospecting; unchanged relationships | Low / Low |
| Recruitment and HR services (incl. agency recruiters) | Recruitment consultants; HR officers; HR administrators | 5% | M to H (DfE: HR administrators) | Automated screening and admin; augmented sourcing | Low / Medium |
| Technology and data (in-house) | 2134 programmers; 3544 data analysts | 6% | H | Augmented coding; automated reporting | Low / High |
| Corporate finance and operations (in-house) | Finance officers; purchasing; operations managers | 6% | M to H | Automated transactional finance | Low / Medium |
| Administration, secretarial and customer service | Office administrators; PAs; receptionists; call centre staff | 14% | H (GLA: administrative highest level) | Automated scheduling, data entry, first-line service | Low / High |
| Facilities, security and cleaning (N 80 to 81) | Security guards; cleaners; grounds staff | 18% | L | Unchanged | Medium / High |
| Leadership and general management | Directors; senior managers; partners | 4% | M | Augmented | Low / Low |

If PBS is restricted to the knowledge-work core (section 2), drop the facilities row and rescale the rest. That also lifts legal, accounting and consulting by about 1.2 times [E].

### Technology & Digital (SIC J, DCMS Digital Sector)

| Function | Example SOC 2020 unit groups [U] | Indicative share [E] | AI exposure | Likely task mix today | Confidence |
|---|---|---|---|---|---|
| Software engineering | 2134 programmers and software development professionals; testers | 25% | H (observed exposure 75% for computer programmers, US [P]) | Augmented, shifting to automated for routine code | Medium / High |
| Infrastructure, cloud, DevOps and IT operations | IT network professionals; IT operations technicians | 13% | M | Augmented scripting; unchanged incident ownership | Low / Medium |
| Data, analytics and AI/ML | 3544 data analysts (on the proposed TSL [S]); data scientists | 7% | H | Automated reporting; augmented modelling; new AI-governance tasks | Low / Medium |
| Cyber security | Cyber security professionals | 4% | M | Augmented triage; new AI-threat tasks | Low / Low |
| Product management | Product managers (often coded to IT project or business roles) | 4% | M | Augmented specs and research | Low / Low |
| Design (UX/UI) and content, incl. publishing and media | Web and UX designers; journalists; editors | 6% | H for content, M for UX | Automated drafting; augmented design | Low / Medium |
| Telecoms and network engineering | Telecoms engineers and technicians | 7% | L to M | Unchanged field work | Low / Medium |
| Sales, account management and customer success | Business sales executives; account managers | 10% | M | Augmented | Low / Low |
| Marketing | Marketing professionals | 5% | H | Automated content | Low / Medium |
| Delivery and business analysis | IT project and programme managers; IT business analysts | 6% | M to H | Augmented documentation | Low / Medium |
| Corporate functions (finance, HR, legal) | As PBS | 6% | M to H | As PBS | Low / Medium |
| Customer support and administration | Customer service; IT user support | 5% | H (Index: customer service among the most exposed [P]) | Automated first line | Low / High |
| Leadership | CTOs; directors | 2% | M | Augmented | Low / Low |

Tech functions inside PBS and F&I (e.g. bank engineering teams) are counted in those sectors, flagged `function_family = technology`, so cross-sector tech questions can be asked without double counting.

### Finance & Insurance (SIC K)

| Function | Example SOC 2020 unit groups [U] | Indicative share [E] | AI exposure | Likely task mix today | Confidence |
|---|---|---|---|---|---|
| Retail banking and customer service (branch, contact centre) | Bank and post office clerks; customer service | 15% | H | Automated servicing | Low / High |
| Advice, relationship management and sales | 2422 finance and investment analysts and advisers; financial advisers; brokers | 11% | H (DfE: finance and investment analysts) | Augmented analysis; unchanged trust relationship | Low / Medium |
| Investment, trading and asset management (front office) | Fund managers; traders; analysts | 8% | H (Index: financial analysts top ten, US [P]) | Augmented research; automated execution | Low / Medium |
| Corporate and investment banking | Bankers; analysts | 4% | H | Augmented pitch and model work; automated junior tasks (watch the 22 to 25 hiring signal [P]) | Low / Medium |
| Underwriting and claims | Insurance underwriters; claims handlers and assessors | 8% | H | Automated simple claims; augmented complex underwriting | Low / Medium |
| Actuarial and pricing | 2433 actuaries, economists and statisticians (shared code) | 2% | H (DfE: actuaries, economists) | Augmented modelling; regulated sign-off unchanged | Low / Medium |
| Risk management | Risk analysts and managers | 6% | M to H | Augmented | Low / Low |
| Compliance, financial crime and AML | Compliance officers; financial crime analysts | 7% | M to H | Automated screening; augmented investigation; unchanged accountable judgement (SMCR) | Low / Medium |
| Finance, audit and tax (in-house) | 2421 accountants; financial managers | 7% | H (DfE: financial managers) | Automated close and reconciliation | Low / Medium |
| Operations, payments, middle and back office | Financial administrators; credit controllers; settlements | 10% | H | Automated | Low / High |
| Technology and data | 2134 programmers; 3544 data analysts | 12% | H | As T&D | Low / High |
| Legal | In-house lawyers | 1% | H | As PBS legal | Low / Medium |
| HR, marketing and other corporate | HR, marketing | 6% | M to H | As PBS | Low / Low |
| Leadership | Senior Managers (SMCR) | 3% | M | Augmented; accountability unchanged | Low / Low |

**What the table says, even before the real shares arrive.**
- The functions most exposed are also the large volume functions in F&I (servicing, operations) and PBS (administration).
- The roles that are scarce today (data, cyber, actuarial, experienced regulated professionals) are mostly augmented, not automated.
- So the ecosystem should expect, under the substantial scenario, falling volume in entry-level and operations hiring while scarcity persists at the experienced end.
- This is Claude's reading and needs testing [E].

---

## 11. Sampling frame and method

### 11.1 Target universes

- **Jobs.** The stock of open permanent vacancies in the three sectors at a reference month. The real counterpart is the ONS Vacancy Survey stock by industry (VACS02/X06), with function and region mix from ONS Textkernel adverts by SOC. The about 2,000 jobs are a sample of this universe.
- **People.** The working-age population with a current or most recent job in one of the three sectors, or entering them, who are in the market: actively searching, open to moves, unemployed, returning, or switching in. The real counterpart is LFS or APS employment and job-search status.

### 11.2 Strata

| Dimension | Levels | Source of the target distribution |
|---|---|---|
| Sector | 3 | Simon's hires (jobs); employment anchors (people) |
| Function | 12 to 14 per sector (section 10) | APS 3136 SOC4 x section, via the function mapping; adverts by SOC for demand |
| Seniority | 5: entry, mid, senior, lead or manager, director or partner | SOC major group mix plus ASHE pay deciles [E for band cut-offs] |
| Region | 4: London; South East and East; rest of England; Scotland, Wales and Northern Ireland | BRES or APS region x industry; Textkernel adverts by ITL1; ASHE Table 15 for pay |
| Route (jobs only) | Direct or agency | Simon's 30/70 or 20/80 (unresolved in plan v4) [E] |
| Search status (people only) | Active employed, passive open, unemployed, returner, career changer, contractor | LFS job search and status variables; passive and contractor shares [E] |

A full cross is 3 x 13 x 5 x 4 = 780 cells, too many for 2,000 jobs. So:

1. **Generate hierarchically, not by full cross.** Sector, then function given sector, then seniority given function, then region given sector and function. Each conditional comes from a real two-way table.
2. **Fit with iterative proportional fitting (raking).** Start from a seed (the APS microdata cross-tab, or a uniform prior) and rake to all available one-way and two-way marginals:
   - sector x function
   - function x region
   - function x seniority
   - sector x region
3. **Integerise with TRS (truncate, replicate, sample).** This is a standard spatial-microsimulation integerisation method [U: cite Lovelace and Ballas, 2013, link not checked].

### 11.3 Allocating the 2,000 jobs

Sector totals are in proportion to Simon's hires (arithmetic from plan v4):

| Sector | Hires | Share | Jobs |
|---|---|---|---|
| PBS | 351,253 | 73.4% | 1,468 |
| T&D | 72,852 | 15.2% | 304 |
| F&I | 54,639 | 11.4% | 228 |
| **Total** | 478,745 | 100% | 2,000 |

- **Floor.** Each sector x function cell gets at least 20 jobs. At proportional allocation, T&D cyber (4% of 304, about 12) and F&I actuarial (2% of 228, about 5) would be too thin to say anything. The floor uses about 800 of the 2,000; the rest is allocated proportionally.
- **Design weights.** w = (target population share of cell) / (sample share of cell), stored on every job.
- **Two views.** Dashboards report weighted figures for "the market" and unweighted figures for "coverage".
- **Precision.** At n = 2,000, a 10% share has a standard error of about 0.7 percentage points. Within T&D (n = 304) a 5% function has a standard error of about 1.25 points: a relative error of about 25%, so the 95% interval is roughly ±50% of the share. Hence the floor [E: arithmetic, binomial].
- **Better option, recommended.** Generate a **full-scale frame population**, e.g. 1:20 of the real vacancy stock in the three sectors, from the same fitted model at negligible cost. Draw the 2,000-job working sample from it by stratified sampling. Marginals can then be validated on the large frame, and the sample is a known draw from it.

### 11.4 Allocating the 5,000 people

Do **not** fix people at 2.5 per job per cell. That would hard-code the supply and demand ratio, which is a headline output.

1. **Supply share per sector x function x region:** employment x active-search rate (LFS) + unemployed whose last job was in the cell (LFS) + passive-open share [E].
2. **Split:**
   - about 4,500 people across the in-sector cells by supply share
   - about 500 entrants from outside: graduates, returners, career changers, and displaced workers from other sectors [E]
3. **Floor and weights.** A floor of 30 people per sector x function cell, with weights as for jobs.
4. **Emergent ratio.** The resulting people-to-jobs ratio per cell becomes the scarcity measure. Check it against the scarcity priors (ESS densities, Occupations in Demand ratings, TSL/ISL flags).

### 11.5 Attributes after the frame

| Attribute | How it is drawn |
|---|---|
| Pay | From the fitted ASHE distribution for SOC4 x region, at the seniority quantile band |
| Hybrid or remote | ONS rates by industry |
| Contract type | JOBS02, EMP07, EMP17 |
| Tenure | LFS |
| Notice period | [E] |
| Time to hire | [E ranges] |
| Hiring pattern tag (fill fast, always hiring, scarce, hard to find, routine) | Rule over Occupations in Demand rating x ESS density x advert persistence [E] |
| Task bundle and AI tags | Section 9.3 |

---

## 12. Validating synthetic marginals against real ones

| Test | Against | Pass rule (proposed [E]) |
|---|---|---|
| **One-way marginals** (sector, function, region, seniority): total variation distance (TVD) and Hellinger distance; chi-square goodness of fit as a diagnostic only, because n is a design choice | Fitting targets | Weighted TVD ≤ 0.02 per marginal |
| **Two-way tables** (sector x function, function x region): standardised root mean square error (SRMSE), and the cell-level Z-statistic used in synthetic-microdata evaluation [U: Voas and Williamson, 2001, link not checked]; Cramér's V compared, real against synthetic | APS 3136, BRES | SRMSE ≤ 0.1; no cell with abs(Z) > 1.96 that holds more than 1% of the population |
| **Pay**: quantile error at deciles; two-sample Kolmogorov-Smirnov against a distribution fitted to ASHE deciles | ASHE Tables 14 and 15 | Each decile within ±5% |
| **Hold-out structure** (data not used in fitting) | Census 2021 occupation x industry (England and Wales); Textkernel adverts SOC mix by region; ESS hard-to-fill rates by sector | Rank correlation of cell shares ≥ 0.8 |
| **Seed stability**: rerun 20 seeds | Self | Coefficient of variation of each headline measure ≤ 5% |
| **Effective sample size** after weighting (Kish) | Self | Report it; warn when a cell's effective n < 15 |
| **Face validity**: recruiters (Simon's network) blind-rate a mix of real (licensed) and synthetic job briefs and CVs | Expert panel | Synthetic not reliably distinguishable (accuracy ≤ 60%) |
| **AI layer**: Spearman's rho between role exposure (A + G) and DfE AIOE and ILO WP140 ranks | UK and ISCO rankings | rho ≥ 0.6; disagreements listed |

---

## 13. What we can only estimate, and the biggest gaps

| Item | Why there is no clean source | Best available proxy |
|---|---|---|
| **Function shares within sectors** | Function is not an official classification | APS 3136 SOC4 x section, with a mapping table and LFS microdata [E until computed] |
| **Seniority distribution** | No UK series by level | SOC major group plus ASHE quantiles |
| **Total hires by sector and function** | No UK JOLTS | LFS flows; Simon's figure is a different (agency-led) quantity [E] |
| **Vacancies by occupation x industry** | The Vacancy Survey has industry only; adverts have occupation, but industry is weak | Combine them, and reconcile with raking |
| **Time to hire, time to fill** | No official statistic | Licensed advert duration; recruiter interviews; the brief's figures (source unverified) |
| **Notice periods** | Statutory minimum only | Contract norms from recruiter interviews [E] |
| **Passive job openness** | The LFS captures active search only | Vendor surveys [U]; our own consumer research |
| **Direct against agency route by function** | No official split | Simon's plan; REC [E] |
| **Contractor share in tech** | No official split | Recruiter data; HMRC IR35 statistics [U] |
| **UK task inventory** | No UK O*NET | O*NET plus ESCO plus UK regulated tasks |
| **UK task-level AI usage** | The Economic Index maps to US O*NET; the UK appears only in country aggregates | Index scaled by UK adoption (BICS) and checked against DfE, DSIT and ILO |
| **"New" tasks** | Nobody measures them systematically | Advert text (AI tracker), ESCO additions, Skills England |
| **Scenario input values** | Anthropic gives outcomes on the page; inputs are in the technical report | Read Korinek et al. 2026 [U] |
| **LFS/APS quality** | Accreditation removed or suspended; TLFS transition aimed at 2027 [S] | Pool years; levels from JOBS02, BRES and Census |

---

## 14. Source register

| Dataset | Publisher | Access | Licence | Cost | Mark |
|---|---|---|---|---|---|
| SOC 2020 Vol. 1 and 2, Extended SOC | ONS | Download | OGL | Free | S |
| SOC 2020 to ISCO-08 | ONS | Download | OGL | Free | S |
| UK SIC 2007 / 2026 | ONS | Download | OGL | Free | S/U |
| APS ad hoc 3136 (SOC4 x SIC section) | ONS | Excel | OGL | Free | S |
| APS on Nomis (e.g. APS168) | ONS / Nomis | Web, REST API | OGL | Free | S |
| LFS microdata | ONS / UK Data Service | EUL registration; Secure Access | UKDS EUL | Free | U |
| BRES | ONS / Nomis | Web, API | OGL | Free | U |
| Census 2021 (TS063, custom) | ONS / Nomis | Web, API, custom builder | OGL | Free | S |
| JOBS02 | ONS | Excel | OGL | Free | S |
| DCMS Digital Sector employment 2025 | DCMS | Web | OGL | Free | S |
| Skills Imperative 2035 (Working Futures) | NFER / Warwick IER | PDF, workbooks | Check | Free | S/U |
| Skills England SNAs 2026 | Skills England | PDF | OGL | Free | S |
| ASHE Tables 14, 15, 16 | ONS | Excel | OGL | Free | S/U |
| ASHE microdata | ONS SRS | Accredited researcher | Restricted | Free | U |
| VACS02, X06 | ONS | Excel | OGL | Free | S |
| Online adverts by SOC 2020 (Textkernel) | ONS | Excel | OGL | Free | S |
| Occupations in Demand 2025 | DfE | Explore Education Statistics | OGL | Free | S |
| Employer Skills Survey 2024 | DfE | Report, tables | OGL | Free | S |
| LFS flows X02 | ONS | Excel | OGL | Free | S |
| Report on Jobs | KPMG, REC, S&P Global | Press release; subscription for series | Proprietary | Free / paid | S/U |
| Indeed Hiring Lab trackers | Indeed | GitHub | CC BY 4.0 | Free | S |
| Adzuna API | Adzuna | API key | Proprietary; 14-day commercial trial | Free tier / licence | P |
| Lightcast | Lightcast | Licence | Proprietary | Quote | U |
| Textkernel Jobfeed | Textkernel | Licence | Proprietary | Quote | U |
| ISL, TSL (MAC reports) | Home Office, MAC | Web, PDF | OGL | Free | S/U |
| ONS hybrid working | ONS | Web | OGL | Free | S |
| O*NET 31.0 | US DOL / O*NET Center | Download, web services | CC BY 4.0 | Free | S |
| ESCO v1.2 | European Commission | Download, API | Free reuse (2011/833/EU) | Free | S |
| BLS SOC crosswalks | BLS | Download | Public domain | Free | U |
| Eloundou et al. labels | OpenAI / authors | GitHub | U | Free | S/U |
| Anthropic Economic Index | Anthropic | Hugging Face | Data CC-BY; code MIT | Free | S/P |
| DSIT AI labour-market assessment | DSIT | Web | OGL | Free | S |
| DfE impact of AI on UK jobs | DfE | PDF | OGL | Free | S |
| GLA London GenAI exposure | GLA | Web, PDF | OGL [U] | Free | S |
| ILO WP140 | ILO | PDF, data portal | U | Free | S/U |
| IMF SDN/2024/001 | IMF | PDF | IMF terms | Free | S |
| OECD Employment Outlook 2023 | OECD | Web | OECD terms | Free | S |
| IPPR Transformed by AI | IPPR | PDF | IPPR terms | Free | S |
| TBI AI and the labour market | TBI | Web | U | Free | U |
| ONS BICS (AI use) | ONS | Excel | OGL | Free | U |

**Verification log.**
- **Blocked domains.** Direct fetches of ons.gov.uk, gov.uk, data.london.gov.uk, explore-education-statistics.service.gov.uk, huggingface.co and lewissilkin.com were blocked by this session's network proxy. Figures from those pages are marked [S] and must be re-read on the page before external use.
- **Pages read directly [P]:**
  - the Anthropic econ-scenarios page
  - the Anthropic Economic Index January 2026 report
  - "Labor market impacts of AI"
  - the Adzuna developer terms

## 15. Next steps (proposed, not started)

1. **Download and compute.** Download APS 3136, JOBS02, VACS02/X06, ASHE Tables 14 and 15, Textkernel SOC adverts and Occupations in Demand 2025. Replace every [E] share in section 10 with computed shares.
2. **Sector definition.** Simon to confirm the PBS definition (all of M+N, or the knowledge-work core) and what his hire volumes count.
3. **Crosswalk.** Build the SOC 2020 to function mapping table (412 rows x 3 sectors) and the SOC 2020 to ISCO-08 to O*NET chain. This is a reviewable artefact for `engineering-architect`.
4. **Scenario inputs.** Read the Korinek et al. technical report for the per-scenario input values.
5. **Licensing.** Decide on one licensed postings source (Lightcast or Textkernel) only if time to fill and advert duration become load-bearing for investor material.
