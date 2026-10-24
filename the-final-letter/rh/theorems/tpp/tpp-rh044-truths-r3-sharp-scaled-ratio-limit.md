# R3 — the scaled ratio `|S_N|·√(2t)/√N → 1`

**Kind:** Claim
**Status:** REFUTED (measured `0.37592469` and `0.30835845` against the claimed limit `1`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §0 "The corrections this round had to make to its own first draft", row R3, line 33

## Statement

The ledger row, verbatim:

> | R3 | "`\|S_N\|·√(2t)/√N → 1`" | false: measured `0.37592469` (`t = 14.1347`), `0.30835845` (`t = 21.0220`); the limit is `√(2t)/√(1/4+t²) = 0.37592375 / 0.30835768` |

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum; `s = 1/2 + it`.
- The two test heights are `t = 14.1347` (the first zero) and `t = 21.0220` (the second zero).
- The claimed normalisation is `|S_N|·√(2t)/√N`; the source's corrected limit is `√(2t)/√(1/4+t²)`.

## Proof / evidence

Refuted by measurement: `0.37592469` at `t = 14.1347` and `0.30835845` at `t = 21.0220`, against the corrected limit values `√(2t)/√(1/4+t²) = 0.37592375` and `0.30835768`. The source records (line 36) that R1–R3 were caught by the round's auditor.

## Dependencies and related results

- [R1 — the sharp fluctuation constant is `1/√(2t)`](tpp-rh044-truths-r1-sharp-fluctuation-constant.md) — the same constant, refuted in unnormalised form.
- [Theorem 1 (Euler–Maclaurin, full first terms)](tpp-rh044-truths-theorem-1-euler-maclaurin-first-terms.md) — the law giving `|S_N − ζ|/√N → 1/√(1/4+t²)`.

## Notes

- The refuted ratio is a rescaling of the R1 constant; the correct large-`N` ratio is `√(2t)/√(1/4+t²)`, not `1`.
- The round keeps the wrong claim with its witness, as in [R1](tpp-rh044-truths-r1-sharp-fluctuation-constant.md).
