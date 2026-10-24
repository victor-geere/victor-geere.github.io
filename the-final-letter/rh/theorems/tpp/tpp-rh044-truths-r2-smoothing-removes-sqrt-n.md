# R2 — "smoothing removes the `√N` fluctuation; the smoothed error is `O(N^{−1/2})`"

**Kind:** Claim
**Status:** REFUTED (measured last-decade exponents `0.5000` for all six weights)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §0 "The corrections this round had to make to its own first draft", row R2, line 32

## Statement

The ledger row, verbatim:

> | R2 | "smoothing removes the `√N` fluctuation; the smoothed error is `O(N^{−1/2})`" | false.  `\|S_N^φ − ζ\|·√N → ∞` for **every** weight; the measured exponents are `0.5000` (last decade, `N = 10^4 → 10^5`) for all six weights tested.  Smoothing changes only the constant `\|M_φ(s)\|` |

## Hypotheses and notation

- `S_N^φ(s)` is the smoothed partial sum with weight `φ` on `[0,1]`; the sharp cutoff is `φ ≡ 1`.
- `M_φ(s) = ∫_0^1 φ(u)u^{−s}du` is the weight's Mellin transform.
- "Last decade" means the log–log exponent fitted over `N = 10^4 → 10^5`.

## Proof / evidence

Refuted by the round's measurements: `|S_N^φ − ζ|·√N → ∞` for every weight tested, with last-decade exponent `0.5000` for all of them; smoothing changes only the constant `|M_φ(s)|`. The replacing law is [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md), `|S_N^φ − ζ|/√N → |M_φ(s)|`.

## Dependencies and related results

- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the correcting result.
- [R1](tpp-rh044-truths-r1-sharp-fluctuation-constant.md), [R3](tpp-rh044-truths-r3-sharp-scaled-ratio-limit.md), [R4](tpp-rh044-truths-r4-theta-identity-correction.md) — the other first-draft corrections of §0.
- [Consequence 1 — the `√N` growth is universal](tpp-rh044-truths-consequence-1-sqrt-n-growth-universal.md).
- [handoff fact 2 — smoothing removes the fluctuations](tpp-rh044-handoff-fact-2-smoothing-removes-fluctuations.md) — the same assertion as it stood in the round's reconnaissance.

## Notes

- Caught as a first-draft claim of the round's reconnaissance by the round's auditor (source line 36).
- The source's "six weights" count in this row is the same count that appears in [Theorem 2](tpp-rh044-truths-theorem-2-weight-law.md), whose accompanying table lists five rows; the discrepancy is recorded, not corrected, here.
