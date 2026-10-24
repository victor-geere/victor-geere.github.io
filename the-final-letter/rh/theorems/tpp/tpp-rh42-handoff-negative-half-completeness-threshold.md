# T13 — the negative half is complete iff `p ≤ q = 2.07677517921069`

**Kind:** Claim
**Status:** PROOF-SKETCH (root of `N(p) = 2·3^{−p}`, sign change at `q ± 10^{−6}`) + VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T13; §5.5, §5.3

## Statement

> | T13 | the negative half is complete iff `p ≤ q = 2.07677517921069` | **PROOF-SKETCH** + **VERIFIED** | root of `N(p) = 2·3^{−p}` with sign change at `q ± 10^{−6}` |

The source's §5.5: "The negative half behaves the same way but stays complete longer — its first term is `3^{−p}`, so its completeness threshold is `q = 2.07677517921069` (root of `N(p) = 2·3^{−p}`), larger than `p*`."

## Hypotheses and notation

- `N(p) = (1 − 2^{−p}) ζ(p) − 1` — the negative budget (row T2).
- `3^{−p}` is the first (largest) term of the negative half-series (denominator 3).
- `q` is defined as the root of `N(p) = 2·3^{−p}`; the §5.3 table lists it as "`q` | `N(p) = 2·3^{−p}` | 2.07677517921069 | the **negative** half becomes complete (see §5.5)".

## Proof / evidence

> | T13 | the negative half is complete iff `p ≤ q = 2.07677517921069` | **PROOF-SKETCH** + **VERIFIED** | root of `N(p) = 2·3^{−p}` with sign change at `q ± 10^{−6}` |

The evidence rests on the same completeness mechanism as the positive half (`S = S(tail) ∪ (a_1 + S(tail))`, Brown's criterion) applied to `a_1 = 3^{−p}`.

## Dependencies and related results

- The negative-half analogue of T10 (positive half complete iff `p ≤ p*`).
- Uses `N(p)` (row T2) and the ordering `pN < pP < p* < q` (row T14 / §5.3).
- Restates `rh42/truths.md` Theorem 8 (completeness thresholds) and the four-threshold row.

## Notes

- Status `PROOF-SKETCH` + `VERIFIED`; the threshold is located by a sign change at `q ± 10^{−6}`, and the written proof is part of §7 R1(e) ("the negative half with its own threshold `q`").
- The value `2.07677517921069` is quoted exactly as printed (14 decimal places here; §5.3 prints the same).
