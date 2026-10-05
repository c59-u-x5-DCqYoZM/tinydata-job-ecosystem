---
source: mixed
ratified: false
date: 2026-10-05
---

# Simon's UK recruitment revenue plan (v4): what it says, and where it meets our rules

**Drive:** "Copy of UK Recruitment Revenue Assumptions v4.xlsx", https://docs.google.com/spreadsheets/d/1xMZJoEGoUPWaDWLbf53nTgLzEmJzaSIt (shared to sorenmills@gmail.com, 5 Oct 2026). The workbook is the source of truth; the figures below are copied from it, not recalculated. Simon's covering note: `team/soren-notes/2026-10-05-simon-focus-sectors.md`.

## The market (Recruitment Spend tab)

| Item | Figure | Sheet's source or note |
|---|---|---|
| UK recruitment turnover 2024/25 | £42,900m | REC Industry Status Report |
| Permanent share | 28%, so £12,012m | REC |
| Average placed salary | £37,000 | Indicative |
| Blended contingency fee | 17.5% | Mid-point of 15 to 20% |
| Traditional cost per hire ("Engagement Number") | £6,475 | Salary x fee |
| Agency-mediated permanent placements a year | 1,855,135 | Top-down estimate |

## The three focus sectors

| Sector | Annual hires (est.) | Spend | Companies 1,000+ staff | Agencies | Typical fee |
|---|---|---|---|---|---|
| Professional & Business Services | 351,253 | £2,274.4m | 400 | 1,320 | 17 to 20% |
| Technology & Digital | 72,852 | £471.7m | 200 | 1,061 | 18 to 22% |
| Finance & Insurance | 54,639 | £353.8m | 250 | 404 | 17 to 20% |
| **Target sectors** | **478,745** | **£3,099.9m** | **850** | **2,785** | |

The sheet marks the company counts as order-of-magnitude estimates; the agency counts come from the Agency Central directory, September 2026.

## Two routes to market

| | Route 1: direct to companies | Route 2: via recruitment agencies |
|---|---|---|
| Volume share | 30% (Section C) or 20% (pricing tab) | 70% (Section C) or 80% (pricing tab) |
| Producers at full scale | 89 companies | 258 agencies |
| Hire fee | 5% of first-year salary, £1,850 | 1% of first-year salary, £370 |
| Skibbit cost per hire, whole funnel | £2,390 | £910, on top of the agency's own fee |
| Against the £6,475 baseline | 63% saving | £6,845 combined, so no saving to the employer; value goes to the agency |
| Revenue, 3 years (Oct 2026 to Sep 2029) | £12.62m | £9.77m |

## Pricing and funnel

- **Funnel per 100 intent waves:** 40 job waves, 40 ranking promotions, 40 handshakes, 20 consents, 1 hire. The shape is carried over from the New Cars model, pending real data.
- **Per-event fees:** job wave £3, handshake £3 and consent £3 (all anchored to LinkedIn's £3 cost per click). Ranking promotion is £6.
- **Seat licences (per seat, per year):** £1,999 base, £4,999 enhanced, £8,999 AI agent. These are benchmarked against LinkedIn Recruiter.
- **Other producer products:** ad hoc projects £5,000; data collaboration £10,000 a year.
- **Not priced yet:** the sector vault licence is TBD.
- **The candidate pays nothing.**

## Revenue split across entities (System Revenues tab)

- **Total system revenue over 3 years:** £22.4m.
- **Skibbit Ltd:** takes 100% of SaaS and ad hoc revenue.
- **Transaction fees:** 25% to VaultCo and 75% to the sector vaults.

## Where the plan meets our recorded rules: decisions for Soren and Simon

Claude's reading, 5 Oct 2026, not Simon's words:

1. **Hire fee as a percentage of salary.** The plan charges 5% (direct) and 1% (agency). ADR-005 and the team's recommendation say a flat fee, never a percentage. The Kingston briefing currently says "never a percentage of salary". One of the two has to change.
2. **Paid ranking promotion.** "Employer pays to have a role featured to a matched candidate." The vault's rule is that nobody can pay to move a match, and the prototype says so on screen. A featured slot shown beside an unpaid ranking might be compatible; paying to raise the score is not. This needs a ruling.
3. **Route volume split.** Section C says 30/70; the pricing tab says 20/80.
4. **Agency route economics.** The employer pays more than today (£6,845 against £6,475). That is a deliberate tooling proposition to agencies, but it weakens a "cheaper hiring" message to employers on that route.
5. **Entity structure.** The split across Skibbit Ltd, VaultCo, HoldCo and sector vaults assumes a corporate structure that is still being aligned. See the "fiduciary is a subsidiary of the marketplace" risk in `gtm/brand/two-brand-architecture-proposal.md`.

## How the synthetic economy uses it

`engineering/poc` takes these figures as tagged, illustrative defaults: sector weights, the funnel, the fee schedule and the £6,475 baseline. Items 1 and 2 are config switches, not settled behaviour. The match score never takes paid input in any setting.
