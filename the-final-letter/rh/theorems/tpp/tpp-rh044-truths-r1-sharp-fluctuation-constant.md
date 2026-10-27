# R1 — the sharp fluctuation constant is `1/√(2t)`

**Kind:** Claim
**Status:** REFUTED (false by a factor 2.66 at `t = 14.1347`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §0 "The corrections this round had to make to its own first draft", row R1, line 31

## Statement

The ledger row, verbatim:

> | R1 | the sharp fluctuation constant is `1/√(2t)` | false by a factor 2.66 at `t = 14.1347`: `1/√(2t) = 0.1880794` vs the measured `0.07070353`.  The true constant is `1/\|s−1\| = 1/√(1/4+t²) = 0.0707035277318`; normalised, `\|S_N−ζ\|·\|s−1\|/√N = 1.0000025` at `N = 10^5` |

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum of `ζ`, and `s = 1/2 + it` lies on the critical line.
- The reference height is `t = 14.1347`, i.e. the first zero `t₁ = 14.134725141734693`.
- The "sharp fluctuation constant" is the limit of `|S_N(s) − ζ(s)|/√N`.
- On the critical line `|s−1| = √(1/4 + t²)`.

## Proof / evidence

Refuted by the round's own measurement at `t = 14.1347`: `1/√(2t) = 0.1880794` against the measured `0.07070353`, a factor 2.66. The correcting constant `1/|s−1| = 1/√(1/4+t²) = 0.0707035277318` is confirmed by the normalisation `|S_N−ζ|·|s−1|/√N = 1.0000025` at `N = 10^5`. The source records (line 36) that R1–R3 were caught by the round's auditor; R4 by the main agent before the audit.

## Dependencies and related results

- [Theorem 1 (Euler–Maclaurin, full first terms)](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md) — supplies the true constant `1/|s−1|`.
- [R3 — the scaled ratio `|S_N|·√(2t)/√N → 1`](tpp-rh044-truths-r3-sharp-scaled-ratio-limit.md) — the companion refuted claim about the same constant.
- [handoff fact 1 — the sharp cutoff constant `1/√(2t)`](tpp-rh044-handoff-fact-1-sharp-cutoff-constant.md) — the same wrong constant as it stood in the round's reconnaissance.

## Notes

- Only the constant is refuted; the `√N` growth itself is true and is [Theorem 1](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md).
- This corrects the earlier round's critical-line coefficient `1/√(2t)` (rh43 ledger row T16″); the round keeps the wrong claim here with its witness, per its house rule that refuted statements are kept.
