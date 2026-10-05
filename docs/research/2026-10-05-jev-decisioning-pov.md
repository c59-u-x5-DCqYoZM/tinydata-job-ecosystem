---
source: ai
ratified: false
date: 2026-10-05
---

# Jev inside the vault? A point of view for the TinyData team

Owner: `ai-architect`. Status: proposed, not ratified. Audience: the TinyData team (business cofounders, Philip, Craig, Kingston Tam). Presentable version: `ai/architecture/2026-10-05-jev-decisioning-pov.html`.

## Soren's question, verbatim (5 October 2026)

> also -- Also, I've got a serious um, technical question for the um, uh, for the engineering team and the technical architecture team. of the overall tiny data project. I'm wondering if a JEV decisioning model would be helpful. I've been reading a lot about this recently and these JEV models do probabilities, decision. I'm wondering if they're exact and they're very cheap. I'm wondering if they're exactly what we need for inside the vault. Um, so can you please research these and come up with a PO view, POV I'm thinking of presenting this into the uh, into the uh, skibbit into the tiny data tiny data team because I'm wondering if it would let us get out of the LLM situation and into a JEV model that could do some part of the process inference matching feels like based on the probabilities it might be a very interesting technical solution

Earlier, 21 September 2026: "Could we use the JEV model for TinyData?" Source: `team/soren-notes/2026-10-05-jev-decisioning-question.md`.

---

## The answer, in one paragraph

**"JEV" is Jev, a decision model from TypeSafe AI**, launched in early access on 15 September 2026. It is not a language model. You give it text (the "state") and a set of typed questions, and it returns a choice, a score or a yes/no probability for each question, in one pass. TypeSafe reports 70 to 500 ms per call and $0.042 per million input tokens, with output free ([InfoQ](https://www.infoq.com/news/2026/10/typesafe-ai-jev-released/), [MarkTechPost](https://www.marktechpost.com/2026/09/19/typesafe-ai-releases-jev/)). Soren read about it in Lenny's *How I AI* newsletters ([28 Sept](https://www.lennysnewsletter.com/p/how-i-ai-jev-for-beginners-i-left), [5 Oct](https://www.lennysnewsletter.com/p/how-i-ai-8-real-jev-use-cases-how)). **Our answer is partly: yes to the idea, at the edges; no to Jev inside the vault.** The idea is right: TinyData's decisions should be probabilities over a fixed set of options, not generated prose, and an LLM should be used only where the question is open-ended. Jev itself does not fit the vault, for four reasons:

1. **It is hosted only.** Jev runs on TypeSafe's US servers, with no published weights and no documented EU region ([innfactory](https://innfactory.ai/en/ai-models/typesafe-jev/), [Opper](https://opper.ai/provider/typesafe)). Sending a person's facts to it would be a new crossing to a third party.
2. **It is not exact.** One user reports that identical requests return different probabilities, and that reordering the options changes the result ([report on X](https://x.com/neural_avb/status/2101736546391244854), unverified). Independent tests find it overconfident ([arXiv 2609.37647](https://arxiv.org/html/2609.37647v1)).
3. **It gives no reasons** ([Reticle](https://www.reticle.sh/blog/what-jev-cannot-do)).
4. **The vault already holds structured facts and is already LLM-free.** `match.ts` is a deterministic weighted scorer. On structured facts, Jev adds nothing that a formula cannot do exactly.

The "exact, cheap probabilities" Soren wants inside the vault come from a fitted **choice model** (conditional logit). Jev-style deciders belong at the edges: TypeSafe's hosted Jev on *employer* text, an open-weights decider on the person's *device*, and either one in the synthetic job ecosystem.

---

## 1. What Jev is

### How we identified it

The note was transcribed from voice. Three readings were tested: Jev (TypeSafe), JEPA (LeCun) and GEV (generalised extreme value) discrete-choice models. **Jev is confirmed:**

- The two *How I AI* newsletters in Soren's reading match his words: "a decision model, not a language model" that "returns predefined values such as a category, score, or probability".
- The timing fits: launch on 15 Sept, his first question on 21 Sept, then newsletters on 28 Sept and 5 Oct.

We found no other "JEV" in AI or decision science, apart from the products that copy it and a JevBench leaderboard ([MarkTechPost on Strands Decider](https://www.marktechpost.com/2026/10/01/aws-strands-labs-releases-strands-decider-2b/)).

### Fact sheet

Verification key:
- **V:** vendor statement, reported by press or docs mirrors.
- **I:** independent test.
- **U:** unverified: a single report, or a figure we could not check.

We could not open TypeSafe's own pages in full from this session. Every row was read through search summaries of the linked pages. Re-check against [docs.typesafe.ai](https://docs.typesafe.ai/models) before any external use.

| Property | What we found | Status | Source |
|---|---|---|---|
| What it does | Takes a state plus typed questions. Returns Choice (one of up to 255 options, with a probability per option), Score (on a rubric) or a yes/no probability. All questions are answered in one parallel pass. It is non-autoregressive: it does not generate text token by token. | V | [InfoQ](https://www.infoq.com/news/2026/10/typesafe-ai-jev-released/), [TypeSafe docs](https://docs.typesafe.ai/models), [Cloudflare](https://developers.cloudflare.com/ai/models/typesafe/jev/) |
| TypeSafe's own design rule | Paraphrased by the guides: code owns control flow, deterministic rules and side effects; Jev supplies narrow semantic judgements; authorisation, payments and thresholds stay in application code. | V (secondary wording) | [Hugging Face guide](https://huggingface.co/blog/sora-2/jev-ai-typesafe-ai-a-practical-guide-to-typed-deci), [MarkTechPost coding guide](https://www.marktechpost.com/2026/09/23/a-coding-guide-to-typesafe-ai-jev/) |
| API | `POST https://api.typesafe.ai/v1/systemone`, model route `jev-latest`, with Python and JavaScript SDKs | V | [Hugging Face guide](https://huggingface.co/blog/sora-2/jev-ai-typesafe-ai-a-practical-guide-to-typed-deci), [Opper](https://opper.ai/provider/typesafe) |
| Price | $0.042 per million input tokens; output free. The newsletters relay "4 cents per million input tokens". No published plan tiers. | V | [MarkTechPost](https://www.marktechpost.com/2026/09/19/typesafe-ai-releases-jev/), [eesel](https://www.eesel.ai/blog/typesafe-jev-pricing) |
| Latency | 70 to 500 ms per call | V | [InfoQ](https://www.infoq.com/news/2026/10/typesafe-ai-jev-released/) |
| Context | 32k tokens for the state plus the longest question; 64k for the state plus all questions | V | [InfoQ](https://www.infoq.com/news/2026/10/typesafe-ai-jev-released/) |
| Access | Early access from a waitlist | V | [eesel](https://www.eesel.ai/blog/typesafe-jev-pricing) |
| **Can it run on the device?** | **No.** No open weights, no self-hosting, no on-premises option. It runs only on TypeSafe's servers. | V | [innfactory](https://innfactory.ai/en/ai-models/typesafe-jev/) |
| **UK and EU processing** | No EU region documented. Services are hosted in the US, and the vendor's DPA covers international transfers. | V, U on the DPA terms | [innfactory](https://innfactory.ai/en/ai-models/typesafe-jev/), [Opper](https://opper.ai/provider/typesafe) |
| **Data retention and training** | Not trained on customer requests or responses. Zero data retention is offered to enterprise customers, on request. | V | [Opper](https://opper.ai/provider/typesafe), [eesel](https://www.eesel.ai/blog/typesafe-jev-pricing) |
| How it was trained | Transformer-based, trained on synthetic data with "Reinforcement Learning for Calibrated Decisions" (RLCD). No architecture paper, weights or full model card is published. | V | [Turing Post](https://www.turingpost.com/p/what-is-jev-rlcd), [TypeSafe docs](https://docs.typesafe.ai/models) |
| **Calibration** | Claimed: a 0.8 means right about 80% of the time. Measured: an expected calibration error of 0.06 on a prompt-injection set, but overconfident on average in every benchmark of one study, by 5.8 to 13.6 points. On some multi-class sets, labels scored 0.80 to 0.95 matched humans only 15% of the time. | V claim; I mixed | [Paper Compute](https://papercompute.com/concepts/jev/), [arXiv 2609.37647](https://arxiv.org/html/2609.37647v1), [MindStudio](https://www.mindstudio.ai/blog/jev-vs-classic-classifiers-benchmark) |
| **Determinism** | The output *shape* is fixed. The *values* are reported to vary on identical requests and to shift when the options are reordered. The route `jev-latest` moves when the model updates (a third-party listing shows "Jev 1.13"). | U (single user report); V on versioning | [X report](https://x.com/neural_avb/status/2101736546391244854), [Opper model page](https://opper.ai/typesafe/jev-1-13-0) |
| **Explanations** | None. It returns an option and a probability, with no rationale. Third-party tools estimate reasons by re-running masked variants of the input, at extra calls per decision. | I | [Reticle](https://www.reticle.sh/blog/what-jev-cannot-do), [jev-why](https://github.com/Mahad-007/jev-why) |
| Security | Prompt injection placed in the state can influence the verdict | I | [VentureBeat](https://venturebeat.com/security/companies-are-putting-jev-in-charge-of-ai-agent-decisions-and-prompt-injection-can-influence-the-verdict) |
| Accuracy overall | One eight-day independent test found it level with mid-price LLMs and behind the frontier | I | [DEV](https://dev.to/gde/jev-after-eight-days-of-independent-tests-level-with-mid-price-llms-behind-the-frontier-1kln) |

**The newsletter figures are a host's own tests, not benchmarks.** As relayed from the *How I AI* episodes and their walkthroughs ([Claire Vo](https://www.chatprd.ai/how-i-ai/jev-ai-data-analysis-product-insights), [John Lindquist](https://www.chatprd.ai/how-i-ai/john-lindquist-jev-workflows)):

- 17,000 pull-request pairs compared for 9 cents
- 200,000 classifications for about $4
- 5 GB of JSON for 40 cents
- "10x faster and 4x cheaper than a low-reasoning LLM without sacrificing accuracy"

These are single runs on the hosts' own tasks. The guidance in those episodes matches ours: think of Jev as "an if/else statement, not prompt engineering"; it is best "when the action space is defined and natural language must be routed into it"; and "creative reasoning, open-ended analysis, brainstorming, and image interpretation still belong to LLMs".

### Jev compared with OpenAI's Decisions API and an open alternative

| | **Jev** (TypeSafe) | **Decisions API** (OpenAI) | **Strands Decider 2B** (AWS, open) |
|---|---|---|---|
| What | A dedicated decision model | GPT-6 Luna restricted to a bounded answer set, returning an answer plus a probability | An open decision model, about 1.9bn parameters |
| Inputs | Text | Text and images | Text |
| Status | Early access | Limited preview from 29 Sept 2026; no public docs, schema or price yet | Released 1 Oct 2026 |
| Latency | 70 to 500 ms (V) | About 150 ms, against 1.6 s for a standard call (OpenAI's slide) | Median 106 ms on an RTX 3090 (V) |
| Price | $0.042 per million input tokens | Not published | Free; your own compute |
| Weights, on device | No | No | **Yes**, Apache 2.0, with weights, training code and data. Reported to run on CPU or Apple silicon (U for laptops and phones). |
| EU processing | No EU region documented | OpenAI offers EU data residency for eligible API endpoints. Whether this endpoint is eligible is unknown (U). | Wherever you run it |
| Calibration | See above | Not yet independently tested | Brier 0.35 and 72% on JevBench (V) |
| Sources | above | [The Decoder](https://the-decoder.com/openai-expands-codex-and-its-api-at-devday-with-security-scans-a-decisions-api-and-ultrafast/), [DeepNoodle](https://deepnoodle.ai/atlas/timeline/2026-09-29-openai-decisions-api), [OpenAI EU residency](https://openai.com/index/introducing-data-residency-in-europe/) | [TechCrunch](https://techcrunch.com/2026/10/01/amazon-releases-its-own-jev-clone-as-decision-models-flood-the-web/), [MarkTechPost](https://www.marktechpost.com/2026/10/01/aws-strands-labs-releases-strands-decider-2b/) |

### Related approaches (Soren's "exact" and "probabilities" also point here)

- **Choice models: logit and generalised extreme value (GEV).** McFadden's conditional logit and the GEV family (nested logit and others) give choice probabilities in **closed form**, with no simulation ([McFadden 1974](https://www.econbiz.de/Record/conditional-logit-analysis-of-qualitative-choice-behavior-mcfadden-daniel/10002395479), [Train ch. 4](https://eml.berkeley.edu/choice2/ch4.pdf), [Koppelman and Sethi](https://transportation.northwestern.edu/docs/research/core-topics/transportation-demand-economics-and-forecasting/Koppelmann_ClosedFormModels.pdf)). They are standard in job choice and in two-sided matching ([Choo and Siow 2006](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=881048), [Galichon](https://www.jstor.org/stable/j.ctt1q1xs9h)). This is what "exact and very cheap" means in practice. They need structured inputs, which is exactly what the vault holds.
- **Probabilistic circuits and small Bayesian networks.** Circuits give exact answers in tractable time ([Choi, Vergari, Van den Broeck 2020](http://starai.cs.ucla.edu/papers/ProbCirc20.pdf)). General Bayesian networks are exact but NP-hard in the worst case ([Cooper 1990](https://www.semanticscholar.org/paper/The-Computational-Complexity-of-Probabilistic-Using-Cooper/ed5324bb3a19f0dcc2e90e482c06373b934fc28c)). Small ones (naive Bayes, noisy-OR) are a good fit for pooling evidence into one fact confidence on the device.
- **Calibrated classifiers** (boosted trees with Platt or isotonic scaling, [Niculescu-Mizil and Caruana 2005](https://dblp.org/rec/conf/icml/Niculescu-MizilC05.html)): cheap and deterministic, but less transparent than a logit.
- **Stable matching** ([Gale and Shapley 1962](https://sites.math.rutgers.edu/~zeilberg/EM22/gs.pdf)): deterministic market clearing, if we ever match in rounds.
- **JEPA** ([LeCun 2022](https://openreview.net/pdf?id=BZ5a1r-kVsf), [I-JEPA](https://openaccess.thecvf.com/content/CVPR2023/html/Assran_Self-Supervised_Learning_From_Images_With_a_Joint-Embedding_Predictive_Architecture_CVPR_2023_paper.html), [V-JEPA 2](https://arxiv.org/abs/2506.09985), [AMI Labs](https://www.hpcwire.com/aiwire/2026/03/11/yann-lecuns-ami-secures-1b-seed-to-develop-ai-world-models/)): it learns representations, chiefly from images and video, and outputs no decisions or probabilities. It is not for the vault: the seam forbids embeddings (VLT-07). The I-JEPA classes in Philip's extension bundle fit transformers.js library code, which has shipped I-JEPA since December 2024 ([PR #1073](https://github.com/huggingface/transformers.js/pull/1073)). *We did not re-open the bundle to confirm nothing calls them.*

---

## 2. The vault today, and where an LLM sits

**The vault's job** (`product/careers/2026-09-18-careers-vault-operation.md`): take the crossing, check claims, enforce exclusions and floors, match briefs to candidacies, explain every match, never take paid input, and keep a receipt trail. Inference on the device turns a person's own data into facts the person confirms. The Magna Carta, Article II: "raw data stays on the device", "only intent crosses", and every match is "logged ... in a form a regulator can inspect". Article VII: "We log everything that crosses the trust boundary."

| Place | Today | Planned | Source |
|---|---|---|---|
| Vault matching | **No LLM.** Six fixed weights (domain 0.24, level 0.20, pattern 0.16, band 0.16, sector 0.12, start 0.12) with a reason per feature. No configuration; a test proves paid fields change nothing. | Replaceable `MatchEngine` seam. Canon prefers on-device final fit, with the vault as a pre-filter. | `engineering/poc/services/registry/src/careers/match.ts`, ADR-004 |
| Claims, exclusions, floors | **No model.** A digest is checked against a register, a salted hash is compared, an integer is compared. | Real attestation rails | `claim-verifier.ts`, `vault.ts`, `engineering/poc/CAREERS.md` |
| Device fact inference | Careers facts are fixtures "standing in for the extractor"; travel uses rules "shaped like the LLM extractor contract" | **An LLM extractor on the device**: email and calendar to draft facts from a fixed vocabulary, which the person confirms (M3) | CAREERS.md, ADR-003 |
| Philip's extension | **Small LLM on the device**: Qwen2.5-0.5B names browsing topics; MiniLM makes embeddings (transformers.js) | Becomes the device at M1 | `prototype/three-sides-careers/architecture.html` |
| Brief intake | Briefs arrive already structured (MCP `place_brief`) | Real employers will write free text that must map onto the controlled vocabulary | CAREERS.md, careers-vault-operation step 3 |
| Job ecosystem | Not built | LLM-authored population; live LLM agents on a sample of 50 to 100; a Claude interface for business questions | `product/job-ecosystem/2026-10-05-synthetic-job-ecosystem-brief.md` |

**"Getting out of the LLM situation" therefore means three things:**

1. **Keep the vault LLM-free as it grows.** It already is.
2. **Shrink the device LLM where the question is bounded.** Careers facts are labels from a controlled vocabulary, so the extractor answers multiple-choice questions, which is Jev's shape.
3. **Use deciders, not LLMs, for routing and classification at the edges** (brief intake, triage, the ecosystem).

---

## 3. Jev and the vault: the fiduciary test

**Can Jev run on facts already confirmed and minimised?** Technically yes. Architecturally, it is the wrong trade.

1. **Sending them to Jev is a crossing.** Candidacy fields under a handle are pseudonymised, and pseudonymised data is still personal data under UK GDPR. Calling TypeSafe from the vault would add:
   - a new processor and a transfer to the US, with zero retention only on an enterprise agreement
   - a new line in every person's receipts
   - a new answer to the question "who saw my candidacy?"

   Article VII's "we do not collect what we do not need" sets the bar: the transfer needs a reason the vault cannot meet on its own.
2. **On structured facts, a formula wins.** Jev's strength is reading *unstructured* text into a defined set of options. By the time anything reaches the vault, it is already a controlled vocabulary of integers and enums. Here a fitted choice model is exact, free, instant, explainable, and runs on our own hardware.
3. **Receipts must re-derive.** Today a third party can recompute every digest from the ledger export (VEN-16). A Jev score cannot be recomputed by anyone:
   - the weights are closed
   - repeated runs are reported to vary
   - `jev-latest` moves when TypeSafe updates the model

   We could log the request digest and the response, but logging a score does not let anyone check it.
4. **No reasons, and it can be steered.** Every match must be explained (VEN-18), and Jev gives no rationale. Briefs are written by employers, and text injected into a brief can influence the verdict ([VentureBeat](https://venturebeat.com/security/companies-are-putting-jev-in-charge-of-ai-agent-decisions-and-prompt-injection-can-influence-the-verdict)). That is paid influence by another route, which ADR-004 forbids.
5. **Regulation favours the explainable model.** Recruitment and selection systems are high-risk under the EU AI Act, Annex III, point 4 ([text](https://artificialintelligenceact.eu/annex/3/)). The UK Data (Use and Access) Act 2025 replaced Article 22 with Articles 22A to 22D, which require meaningful information, the right to make representations, human intervention and a route to challenge ([Handley Gill](https://www.handleygill.co.uk/handley-gill-blog/section-80-data-use-and-access-act-2025-article-22a-uk-gdpr-automated-decision-making-automated-processing-meaningful-human-involvement), [ICO](https://ico.org.uk/media2/bbzdvqqy/adm-impact-assessment.pdf)). Whether a vault ranking is a "significant decision" is for `privacy-counsel`. Either way, a published formula is far easier to defend than a closed score.

**Where Jev, or a Jev-style decider, does fit:**

| Edge | Model | Why it passes the fiduciary test |
|---|---|---|
| **Brief intake, employer side.** Map an employer's free-text brief onto role family, seniority, pattern, sector and wanted facts. The employer confirms the mapping. | Hosted Jev, or the Decisions API | The text is the employer's business data, not a person's. It is bounded and routing-shaped, which is TypeSafe's own sweet spot. The employer's confirmation gives a human check. |
| **Brief triage.** Fake job, spam, a discriminatory requirement or a mismatched band goes to human review. | Hosted Jev, with thresholds in our code | Producer-side text. It only flags; it never decides. |
| **Fact questions on the device.** "Does this item evidence `fact:people_manager`?" | **Open-weights decider** (Strands Decider 2B or similar) on the device, then an exact Bayesian combiner, then the person confirms | Raw data never leaves the device. Hosted Jev is ruled out here. |
| **Claim triage on the device.** Is this the right document for the claim, and is it legible? | Open decider on the device | Triage only. Verification itself stays cryptographic. |
| **Job ecosystem.** Agent decisions at volume. | Hosted Jev or the Decisions API is fine | Synthetic data only. Cheap enough for thousands of runs. |

---

## 4. Best fit per task

**Exact** means the same inputs always give the same number, computed by formula. It does *not* mean the model is right about the world. Costs are order-of-magnitude estimates unless cited.

| Task | Best fit | Why | Cost | Exact | Explainable, auditable | On device | Data needs |
|---|---|---|---|---|---|---|---|
| Fact inference on the device | Open decider for bounded labels; an exact Bayes combiner; a small LLM only for open-ended findings | Raw text needs a neural reader, and the labels are bounded | Device compute only | Combiner yes; reader no | Each fact points to its sources; the person confirms | **Must** (rules out hosted Jev) | Labelled synthetic items per label |
| Claim checking | Deterministic: signed attestations | "Verified" must be binary | Negligible | Yes | Receipt per check | Evidence on the device | None |
| Claim triage | Open decider on the device | A bounded "right document?" question | Device | No | Flag only | Yes | Synthetic documents |
| Exclusions and floors | Deterministic rules | They are the person's instructions | Negligible | Yes | Receipts | Either | None |
| Brief intake and triage | **Hosted Jev** or the Decisions API; thresholds in our code; employer confirms | Routing employer free text into a fixed vocabulary | About $0.00002 per 500-token brief at Jev's list price (derived) | No | Employer confirms the mapping; flags go to a human | n/a (employer data) | Few |
| Matching and ranking | **Conditional logit**, nested by role family if needed | A calibrated version of today's linear scorer, with the same firewall | Microseconds per 1,000 pairs (estimate) | **Yes, closed form** | Published coefficients; exact per-feature contributions; recomputable from the ledger | Yes, so the device can compute final fit | Outcomes; cold start from today's weights |
| Explaining a match | The logit's additive contributions, rendered by templates; optional LLM rephrasing on the device | The explanation is the model itself | Negligible | Yes | Reasons sum to the score | Yes | None |
| Predicting acceptance | Binary logit, person side; employer side kept separate | Same family, calibrated | Negligible | Yes | Yes | Yes | Handshake outcomes |
| Predicting time to fill | Discrete-time hazard model (a logit per week) | Handles briefs still open (censoring) | Negligible | Yes | Yes | Aggregate | Open and close dates |
| Fraud and anomaly | Rules plus Bayesian rate monitoring (ADR-007 ratio); Jev for text-level triage only | Rare events must be explainable to the account blocked | Negligible | Yes | Yes | Vault | Event counts |
| Ecosystem simulation | Logit agents for bulk runs; Jev or the Decisions API for text decisions; LLM agents on a sample | Thousands of cheap, reproducible runs | Low | Logit yes | Yes | n/a | Benchmarks plus the agent sample |

---

## 5. Honest limits

1. **Neither Jev nor a logit invents insight.** A decider answers *our* questions. It cannot notice the calendar-to-BMW commute insight the brand promises. Open-ended findings still need an LLM, on the device.
2. **A logit cannot read a CV.** It needs structured inputs, so the edge reader is still required.
3. **An open 2B decider on a phone is unproven.** Today the extension runs 0.5B-scale models. A 2B model may be fine on a laptop and heavy on a phone (U).
4. **Cold start.** We have no real outcomes, so the logit starts as today's weights rescaled. The synthetic ecosystem tests mechanics, not the real world. **Fitting a logit to data generated by a logit only recovers our own assumptions**; the proof plan guards against this.
5. **The basic logit assumes independence of irrelevant alternatives**: adding a near-copy of one job takes share equally from every other. Nested logit fixes this and stays closed form. Mixed logit needs simulation, so it is no longer exact ([Train ch. 4](https://eml.berkeley.edu/choice2/ch4.pdf)).
6. **Learning from outcomes is processing.** It needs a lawful basis from `privacy-counsel`. Past hiring bias in the outcomes would be learned too, so protected characteristics and their proxies stay out of the features, and fairness checks run per release.
7. **Cheap decisions get used more** ([Sophos, "Jev's Paradox"](https://www.sophos.com/en-us/blog/jevs-paradox-hidden-cost-of-cheap-ai-decisions)). The mandate and the person's confirmation stay the brake on automated judgement about people.
8. **Vendor facts move weekly.** Jev is three weeks old and in early access. Every V and U row needs a re-check before anything leaves the team.

**Where an LLM still earns its place:** open-ended findings on the device; writing the synthetic population; the agent sample that calibrates the ecosystem; rephrasing explanations for the person on the device; the business-question interface over synthetic data.

---

## 6. Recommended architecture

**Deciders at the edges route text into fixed options. An exact choice model in the vault decides. Rules and cryptography hold the lines. An LLM is used only where the question is open.**

```
EMPLOYER SIDE              DEVICE (raw data lives here)        VAULT (intent + inferences only)
-----------------------    --------------------------------    ----------------------------------------
free-text brief            email, calendar, CV, browsing       crossing: whitelist, lint, sig    [rules]
   |                          |                                claims: signed attestations       [crypto]
   v                          v                                exclusion hash, pay floor         [rules]
Jev (hosted): map to       open decider: bounded fact Qs       matching: conditional logit       [exact]
controlled vocabulary,       -> label + p                        p(person picks brief | options,
triage flags                  |                                    incl. "stay where I am")
   |                          v                                  coefficients versioned + published
employer confirms          Bayes combiner -> fact + conf       reasons: beta_k * x_k per feature  [exact]
   |                       [exact]                             receipt: model version, coefficient
   v                          |                                  digest, feature digest, score
POST /v1/briefs  ========>    v                                anomaly: beta-binomial monitor    [exact]
                           PERSON CONFIRMS -> gateway.ts ====> never: paid input, raw data,
                              ^                                  embeddings, third-party model calls
                              |  device recomputes final fit with the same published coefficients
                              +------------------------------------------------------------------
```

**The matching model, in plain terms.** Each brief gets a utility from the same six whitelisted features: U = β·x. The probability that the person would pick it, out of the briefs on offer plus "stay where I am", is exp(U) divided by the sum of exp(U) across the options. Today's scorer already *is* a linear utility with hand-set weights, so the change is small: learn β from outcomes, and report a calibrated probability instead of an unlabelled 0.94. `pickCareersScoringInput()` stays the firewall.

**Why this strengthens the fiduciary claim:**

1. **No hidden judgement.** The whole decision function is a short list of published numbers. A regulator, the person or an employer can recompute any match from the ledger export. The certificate digest proves the inputs, and the coefficient digest proves the model.
2. **Deterministic.** Same inputs, same coefficients, same score, every time. There is no vendor update behind our back.
3. **No third party in the vault.** No personal fact leaves the vault for scoring. The only hosted model call sits on employer text, before the brief crosses in.
4. **Whose probability?** The person's representative screens by the person's predicted acceptance under their mandate (today, the 0.8 threshold in MD-0002). Employer-side probabilities never reorder what the person is shown. This is Article II's separation ("the thing that knows you must not be the thing that sells to you") written into the objective function.
5. **Portable.** The coefficients are a few hundred bytes, so the device can compute its own final fit. That keeps ADR-004's on-device option open and makes decision 9 (where matching runs) a deployment choice, not a rewrite.

---

## 7. Proof plan (proposed; do not build yet)

**Question:** On careers matching, how do Jev, today's rule scorer, a fitted choice model and an LLM ranker compare on accuracy, calibration, determinism, cost, latency and explanation? And separately, how good is Jev at brief intake?

**Data.** Use the synthetic job ecosystem when it exists. Until then, scale the careers seed up through `CareersSeedSource` (`CAREERS_SEED_DIR`). All data is synthetic, so hosted models (Jev, the Decisions API, a frontier LLM) are allowed in this test only.

**Anti-circularity.** Two label sources, each held out:
- **(a) LLM-agent labels.** 50 to 100 persona agents (the brief's layer 3) accept or decline briefs given their full synthetic CV and wants, including information that is *not* in the six features.
- **(b) A misspecified generator.** A "true" utility with interactions and non-linear terms that the logit does not share.

**Experiment A: matching.**

| Arm | What |
|---|---|
| A1 | Today's scorer, unchanged. Its score is mapped to a probability by Platt scaling only, for a fair calibration comparison. |
| A2 | Conditional logit on the six features with an outside option, fitted by maximum likelihood. A2b is a nested logit by role family. |
| A3 | **Jev**: the state is a text rendering of the coarsened candidacy and brief; one Choice question ranks the briefs, plus a yes/no question per pair. |
| A4 | Strands Decider 2B run locally, with the same questions as A3 |
| A5 | LLM ranker: a frontier model on the same text |

**Experiment B: brief intake.** Generate 300 synthetic free-text briefs with known controlled-vocabulary fields. Measure Jev, the Decisions API (if preview access is granted) and an LLM on field-level accuracy, calibration and cost, and count how often the employer would have to correct the mapping.

**Metrics:**
- top-1 and top-3 accuracy and NDCG
- log-loss, Brier score and expected calibration error (ECE), with reliability plots
- **determinism**: 10 identical repeats per arm, reporting the spread of probabilities
- **order sensitivity**: shuffle the options and report rank changes
- **injection**: brief text with planted instructions, and the change in rank
- cost per 1,000 matches; p50 and p95 latency
- explanation fidelity: do the reasons reproduce the score exactly?
- third-party recompute from the ledger
- the paid-input invariance test
- outcome rates across synthetic groups

**Success criteria:**
- **Vault matching:** the logit (A2) stays the vault model if:
  - it is within 2 points of the best of A3 to A5 on top-3 accuracy on label set (a), and ahead of A1 on both label sets
  - its ECE is 0.05 or less
  - determinism and recompute are 100%
  - it costs under 1% of A5's cost per 1,000 matches
- **If Jev or the LLM wins on (a) by more than 5 points**, find out what it sees that the features miss. Add that as a new **structured fact inferred on the device**, not a hosted model in the vault, and rerun.
- **Brief intake:** Jev is adopted for brief intake if its field-level accuracy is 95% or more at a threshold that sends 20% or fewer of briefs to employer review, with ECE of 0.05 or less on this task.

**Owners and size.** `ai-prototype-engineer` builds it, `eval-engineer` sets the rubric before the first run, and Philip reviews. About 4 to 6 working days (estimate). Jev requires early-access approval. An ADR (`adr-001-vault-decision-model.md`) follows the results, not before.

---

## Top three recommendations

1. **Make the vault's decision model a calibrated conditional logit, and publish it.** Keep the same whitelist and firewall. Version the coefficients and put their digest in every match receipt, so anyone can recompute any match. This gives Soren "exact, cheap, probabilities" in the vault, keeps it LLM-free, and needs no third party.
2. **Use Jev where it is strongest and the fiduciary line is not crossed.** Use hosted Jev for employer-side brief intake and triage, and for the synthetic ecosystem. On the person's side, use an open-weights decider *on the device* for bounded fact and claim-triage questions. Never send a person's facts to a hosted decision model.
3. **Prove it before committing.** Run both experiments with the anti-circularity labels and the determinism, order and injection tests, then write the ADR. Settle "whose probability" ranks in the same pass: ours is the person's.

---

## Questions for Soren and the team

1. **Soren:** does "inside the vault" mean the matching itself, or anywhere in the TinyData flow? This POV says yes at the edges and no in the matching core.
2. **All:** do we agree the vault ranks by the *person's* predicted choice?
3. **All:** are we comfortable publishing coefficients? It is strong for trust. The risk is employers writing briefs to suit the formula, which brief triage would need to catch.
4. **Philip:** can the extension carry a 2B decider on a mid-range laptop? Is a phone realistic, or do we stay at 0.5B scale?
5. **Craig:** does an exact model in the vault, with the same model on the device, settle decision 9 as option C?
6. **Privacy counsel, through Soren:** what lawful basis covers learning coefficients from confirmed outcomes? Is a vault ranking a "significant decision" under Article 22A?
7. **Kingston:** would you review or run the experiment as a first piece of partnership work?
8. **Soren:** shall we apply for Jev early access and the Decisions API preview now, for synthetic-only testing?

---

## Sources

**Jev and its alternatives** (vendor and press figures; see the status column above):
- [InfoQ](https://www.infoq.com/news/2026/10/typesafe-ai-jev-released/)
- [MarkTechPost launch](https://www.marktechpost.com/2026/09/19/typesafe-ai-releases-jev/)
- [MarkTechPost coding guide](https://www.marktechpost.com/2026/09/23/a-coding-guide-to-typesafe-ai-jev/)
- [TypeSafe docs](https://docs.typesafe.ai/models)
- [Cloudflare](https://developers.cloudflare.com/ai/models/typesafe/jev/)
- [Hugging Face guide](https://huggingface.co/blog/sora-2/jev-ai-typesafe-ai-a-practical-guide-to-typed-deci)
- [Opper provider](https://opper.ai/provider/typesafe)
- [Opper Jev 1.13](https://opper.ai/typesafe/jev-1-13-0)
- [innfactory](https://innfactory.ai/en/ai-models/typesafe-jev/)
- [eesel pricing](https://www.eesel.ai/blog/typesafe-jev-pricing)
- [Turing Post on RLCD](https://www.turingpost.com/p/what-is-jev-rlcd)
- [Paper Compute](https://papercompute.com/concepts/jev/)
- [The Decoder, Decisions API](https://the-decoder.com/openai-expands-codex-and-its-api-at-devday-with-security-scans-a-decisions-api-and-ultrafast/)
- [DeepNoodle, Decisions API](https://deepnoodle.ai/atlas/timeline/2026-09-29-openai-decisions-api)
- [OpenAI EU residency](https://openai.com/index/introducing-data-residency-in-europe/)
- [TechCrunch, Strands Decider](https://techcrunch.com/2026/10/01/amazon-releases-its-own-jev-clone-as-decision-models-flood-the-web/)
- [MarkTechPost, Strands Decider](https://www.marktechpost.com/2026/10/01/aws-strands-labs-releases-strands-decider-2b/)

**Newsletters and walkthroughs** (the hosts' own tests):
- [How I AI, 28 Sept](https://www.lennysnewsletter.com/p/how-i-ai-jev-for-beginners-i-left)
- [How I AI, 5 Oct](https://www.lennysnewsletter.com/p/how-i-ai-8-real-jev-use-cases-how)
- [ChatPRD, Claire Vo](https://www.chatprd.ai/how-i-ai/jev-ai-data-analysis-product-insights)
- [ChatPRD, John Lindquist](https://www.chatprd.ai/how-i-ai/john-lindquist-jev-workflows)

**Independent evaluation and critique:**
- [arXiv 2609.37647](https://arxiv.org/html/2609.37647v1)
- [DEV](https://dev.to/gde/jev-after-eight-days-of-independent-tests-level-with-mid-price-llms-behind-the-frontier-1kln)
- [MindStudio](https://www.mindstudio.ai/blog/jev-vs-classic-classifiers-benchmark)
- [Reticle](https://www.reticle.sh/blog/what-jev-cannot-do)
- [jev-why](https://github.com/Mahad-007/jev-why)
- [VentureBeat](https://venturebeat.com/security/companies-are-putting-jev-in-charge-of-ai-agent-decisions-and-prompt-injection-can-influence-the-verdict)
- [X report on determinism](https://x.com/neural_avb/status/2101736546391244854)
- [Sophos](https://www.sophos.com/en-us/blog/jevs-paradox-hidden-cost-of-cheap-ai-decisions)

**Related approaches:**
- [McFadden 1974](https://www.econbiz.de/Record/conditional-logit-analysis-of-qualitative-choice-behavior-mcfadden-daniel/10002395479)
- [Train ch. 4](https://eml.berkeley.edu/choice2/ch4.pdf)
- [Koppelman and Sethi](https://transportation.northwestern.edu/docs/research/core-topics/transportation-demand-economics-and-forecasting/Koppelmann_ClosedFormModels.pdf)
- [Choo and Siow](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=881048)
- [Galichon](https://www.jstor.org/stable/j.ctt1q1xs9h)
- [Gale and Shapley](https://sites.math.rutgers.edu/~zeilberg/EM22/gs.pdf)
- [Probabilistic circuits](http://starai.cs.ucla.edu/papers/ProbCirc20.pdf)
- [Cooper 1990](https://www.semanticscholar.org/paper/The-Computational-Complexity-of-Probabilistic-Using-Cooper/ed5324bb3a19f0dcc2e90e482c06373b934fc28c)
- [Niculescu-Mizil and Caruana](https://dblp.org/rec/conf/icml/Niculescu-MizilC05.html)
- [LeCun 2022](https://openreview.net/pdf?id=BZ5a1r-kVsf)
- [I-JEPA](https://openaccess.thecvf.com/content/CVPR2023/html/Assran_Self-Supervised_Learning_From_Images_With_a_Joint-Embedding_Predictive_Architecture_CVPR_2023_paper.html)
- [V-JEPA 2](https://arxiv.org/abs/2506.09985)
- [AMI Labs](https://www.hpcwire.com/aiwire/2026/03/11/yann-lecuns-ami-secures-1b-seed-to-develop-ai-world-models/)
- [transformers.js I-JEPA](https://github.com/huggingface/transformers.js/pull/1073)

**Regulation:**
- [EU AI Act, Annex III](https://artificialintelligenceact.eu/annex/3/)
- [Handley Gill on Article 22A](https://www.handleygill.co.uk/handley-gill-blog/section-80-data-use-and-access-act-2025-article-22a-uk-gdpr-automated-decision-making-automated-processing-meaningful-human-involvement)
- [ICO](https://ico.org.uk/media2/bbzdvqqy/adm-impact-assessment.pdf)

**Repository:**
- `product/careers/2026-09-18-careers-vault-operation.md`
- `engineering/poc/CAREERS.md`
- `engineering/poc/services/registry/src/careers/match.ts`
- `prototype/three-sides-careers/architecture.html`
- `engineering/six-day-build/adrs/` (ADR-003, ADR-004, ADR-007)
- `gtm/positioning/way-of-the-skibbit-magna-carta-v1.md` (Articles II and VII)
- `docs/reference/2026-10-05-anthropic-economic-scenarios.md`
- `product/job-ecosystem/2026-10-05-synthetic-job-ecosystem-brief.md`
