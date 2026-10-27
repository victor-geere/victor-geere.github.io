# The positive half is complete iff `2 ≤ ζ(p)` iff `p ≤ p*`

**Kind:** Proposition
**Status:** PROOF-SKETCH (the equivalence is stated with its algebra) + VERIFIED (numerical, both directions at `p* ± 10^{−6}`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §5.5 "The budget is *not* sufficient: the reachable set and its gaps"

## Statement

> For the positive half the *first* completeness condition is
>
> ```
> 2^{−p} ≤ P(p) − 2^{−p}   ⟺   2 ≤ ζ(p)   ⟺   p ≤ p* .
> ```
>
> **So rh41's threshold `p*` is exactly the exponent at which the signed sine set stops being
> an interval.** Verified in both directions at `p* ± 10^{−6}`, and by reaching all 11 tested
> targets in `[0, P(1.5)]` at `p = 1.5` but not at `p = 1.8`.

Appendix A restates the chain as: `positive half complete  ⟺  2^{−p} ≤ P(p) − 2^{−p}  ⟺  ζ(p) ≥ 2  ⟺  p ≤ p*`.

## Hypotheses and notation

- `P(p) = 2^{−p} ζ(p)` (HANDOFF ledger row T2); the first positive term is `2^{−p}`.
- `p* = 1.7286472389981836181`, the root of `ζ(p) = 2` (row T14).
- "complete": the subset sums of the positive half-series fill `[0, P(p)]` (Brown's criterion, harvested from `HANDOFF.md` §5.5).

## Proof / evidence

- The source gives no proof text beyond the displayed chain; the intermediate arithmetic is not written out in this document.
- Numerical verification: "Verified in both directions at `p* ± 10^{−6}`, and by reaching all 11 tested targets in `[0, P(1.5)]` at `p = 1.5` but not at `p = 1.8`."
- The ledger row T10 records the same statement with the status `PROOF-SKETCH` + `VERIFIED` (Brown's criterion; both directions at `p* ± 10^{−6}`; 11/11 targets at `p = 1.5`).

## Dependencies and related results

- Uses Brown's criterion and the subset-sum recursion of §5.5.
- Same content as ledger row T10 (harvested separately); the threshold `p*` is row T14.
- Restates `rh42/truths.md` Theorem 8 (completeness thresholds).

## Notes

- The status is honest to the source: the *equivalence* is displayed with its algebra in §5.5, while the round's ledger calls the whole statement `PROOF-SKETCH`; no complete written proof is claimed in this document.
- The `p = 1.8` half is the numerical disproof of completeness above the threshold and is the first appearance of the gap phenomenon.
