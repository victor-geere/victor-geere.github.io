# T10 — the positive half is complete (reachable = `[0, P]`) iff `p ≤ p*`, `ζ(p*) = 2`

**Kind:** Claim
**Status:** PROOF-SKETCH (Brown's criterion; both directions at `p* ± 10^{−6}`) + VERIFIED (numerical, 11/11 targets at `p = 1.5`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T10; §5.5 "The budget is *not* sufficient"

## Statement

> | T10 | the positive half is complete (reachable = `[0, P]`) **iff** `p ≤ p*`, `ζ(p*) = 2` | **PROOF-SKETCH** + **VERIFIED** | Brown's criterion; both directions at `p* ± 10^{−6}`; 11/11 targets at `p = 1.5` |

The source's §5.5 states the criterion it rests on: "For the positive half the *first* completeness condition is

```
2^{−p} ≤ P(p) − 2^{−p}   ⟺   2 ≤ ζ(p)   ⟺   p ≤ p* .
```

**So rh41's threshold `p*` is exactly the exponent at which the signed sine set stops being an interval.** Verified in both directions at `p* ± 10^{−6}`, and by reaching all 11 tested targets in `[0, P(1.5)]` at `p = 1.5` but not at `p = 1.8`."

## Hypotheses and notation

- `P(p) = 2^{−p} ζ(p)` (row T2).
- `p* = 1.7286472389981836181`, the root of `ζ(p) = 2` (row T14 / §5.3).
- "complete": the subset sums of the positive half-series fill `[0, P(p)]`; "reachable" is the set of signed sub-sums attainable by the rule.
- Author's caution: the row's own text in Appendix A writes the equivalence as `positive half complete ⟺ 2^{−p} ≤ P(p) − 2^{−p} ⟺ ζ(p) ≥ 2 ⟺ p ≤ p*`.

## Proof / evidence

> | T10 | the positive half is complete (reachable = `[0, P]`) **iff** `p ≤ p*`, `ζ(p*) = 2` | **PROOF-SKETCH** + **VERIFIED** | Brown's criterion; both directions at `p* ± 10^{−6}`; 11/11 targets at `p = 1.5` |

The §5.5 mechanism: "A non-increasing positive sequence whose first term is at most the sum of the rest is **complete** — its subset sums fill `[0, total]` (Brown's criterion; the greedy achieves every value)." and "Otherwise `S(subset sums) = S(tail) ∪ (a_1 + S(tail))`, `S(tail) ⊆ [0, total − a_1]`, so incompleteness produces a gap `(total − a_1, a_1)` whenever `a_1 > total − a_1`, and the construction recurses on the tail."

## Dependencies and related results

- Uses Brown's criterion and the subset-sum recursion (§5.5).
- Threshold value `p*` from §5.3 / row T14; the gap structure at `p = 2, 3` is T11/T12.
- Restates `rh42/truths.md` Theorem 6 (Brown's criterion) and Theorem 8 (completeness thresholds).

## Notes

- The status is **PROOF-SKETCH**, not a written-out proof; the equivalence is `VERIFIED` numerically at `p* ± 10^{−6}` and by 11/11 targets at `p = 1.5`.
- The proof plan is §7 R1 of the same document: "(b) Brown's completeness criterion and the greedy's optimality on complete sequences".
- The threshold value is quoted to 19 significant digits (`1.7286472389981836181`) in §5.3 and as `p* = 1.7286472390` in the §5.1 table; both forms are the source's.
