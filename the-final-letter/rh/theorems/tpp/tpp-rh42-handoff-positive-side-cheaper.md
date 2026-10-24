# T4 — `P(p) > N(p)` for all `p > 0`; the asymmetry is `1−η(p)`

**Kind:** Claim
**Status:** PROVED (paper argument; from `η(p) < 1`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T4; discussion in §5.1

## Statement

> | T4 | `P(p) > N(p)` for all `p > 0`; the asymmetry is `1−η(p)` | **PROVED** | `η(p) < 1` |

The source's §5.1 states the same in prose: "their difference is governed by η alone: `P(p) − N(p) = 1 − η(p) > 0` for every `p > 0` (η is the alternating series, strictly between `1 − 2^{−p}` and `1`). **The positive side is always the cheaper one**; the asymmetry is `1 − η(p)`, i.e. exactly the "half-turn" deficit of the alternating series."

## Hypotheses and notation

- `p > 0`.
- `η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p} = (1 − 2^{1−p}) ζ(p)` (`p ≠ 1`), `η(1) = ln 2`.
- `P(p) − N(p) = 1 − η(p)` is row T3.

## Proof / evidence

> | T4 | `P(p) > N(p)` for all `p > 0`; the asymmetry is `1−η(p)` | **PROVED** | `η(p) < 1` |

The source's §5.1 supplies the bracketed bound "(η is the alternating series, strictly between `1 − 2^{−p}` and `1`)".

## Dependencies and related results

- Uses row T3 (`P − N = 1 − η(p)`).
- Quantified by T14's threshold ordering `pN < pP < p*` and by the values of `P`, `N` at `p*` (T15: `P(p*) = 0.603469`, `N(p*) = 0.396531`).

## Notes

- The source gives no separate drawn-out proof; the justification in the evidence cell is `η(p) < 1`.
- The phrase "the positive side is always the cheaper one" is the source's gloss, not an additional claim.
