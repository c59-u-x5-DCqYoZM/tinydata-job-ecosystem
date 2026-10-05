---
source: ai
ratified: false
date: 2026-10-05
---

# ADR-005: Vault decisions as a calibrated choice model

**Status:** Proposed.

## Context

The Jev POV concludes that the vault's decisions should be "a calibrated conditional logit, and publish it", with no hosted model on personal data, coefficients versioned with their digest in every match receipt, and the vault ranking by the **person's** predicted choice [JEV 6, recommendations]. The careers PoC's scorer is a deterministic six-feature weighted sum with gates in a fixed order [POC `match.ts`]. The POV's proof plan needs a data source with anti-circularity safeguards; this ecosystem is that source [JEV 7].

## Decision

1. **`scorer-v0`:** a port of the careers scorer (weights 0.24, 0.20, 0.16, 0.16, 0.12, 0.12; gates exclusion, role family, floor, in that order), with a **parity test** against `scoreCareersFeatures` on shared vectors. This is the vault arm's reference.
2. **`logit-v1`:** a conditional logit over the same whitelisted features (plus confirmed signal labels when the experiment allows them), with an outside option ("stay where I am"); P(person picks brief j) = exp(U_j) / (exp(U_0) + sum exp(U_k)). Fitted by maximum likelihood; nested by role family if the independence-of-irrelevant-alternatives test fails.
3. **Coefficients are a `decision_model` release:** versioned, published inside the ecosystem, digest in every match receipt, so any match recomputes from the log.
4. **Labels for fitting** come from two held-out sources: live and archetype agent choices that see information outside the features, and the non-linear truth model (ADR-009). A logit is never fitted to data a logit generated.
5. **Ranking objective:** the person's predicted acceptance. Employer-side probabilities never reorder what the person is shown.
6. **No hosted model inside the vault**, even here, so the ecosystem rehearses the real design. Jev or the Decisions API may be tested as separate arms in the proof plan (synthetic data only), not as the vault.
7. **The allowlist firewall** (`pickScoringInput`) and the policing test that paid fields change nothing carry over unchanged.

## Alternatives considered

- **Keep hand-set weights.** Exact but uncalibrated; scores are not probabilities. Kept only as `scorer-v0`.
- **An LLM ranker or hosted decider.** Not exact, not recomputable, injectable, no reasons [JEV 3]. Rejected for the vault.
- **Mixed logit.** Better at heterogeneity, but needs simulation and stops being closed form [JEV 5.5]. Deferred.

## Consequences

- "Exact, cheap probabilities" in the vault, recomputable by anyone holding the log.
- The success criteria in [JEV 7] (within 2 points of the best arm on top-3 accuracy, ECE at most 0.05, 100% determinism and recompute) become an ecosystem experiment.
- Publishing coefficients invites briefs written to the formula; brief triage and the adversarial arm measure that.

## References

[JEV 2, 4, 5, 6, 7]; [POC] `match.ts`, `vault.ts`.
