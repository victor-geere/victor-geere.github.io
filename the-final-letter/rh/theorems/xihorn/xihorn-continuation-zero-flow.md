# The zero flow — varying w deforms ξ with its zeros moving along the negative real axis

**Kind:** Claim
**Status:** VERIFIED (numerical, 60 digits, K = 128 vs K = 140 stable; replaces an earlier wrong table)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §8.3 "The flow", zero-flow table

## Statement

> Varying w continuously deforms ξ, and the zeros move smoothly along the negative real axis:
>
> ```
>     w        z₁          z₂           z₃           z₄           z₅
>     0    −199.7905   −441.9262    −625.5430    −925.6731   −1084.7183
>     1    −221.2555   −464.8058    −658.1144    −949.5500   −1127.7697
>     2    −242.9143   −488.3206    −690.2310    −975.4251   −1169.1825
>     4    −286.8341   −536.9185    −753.5670   −1031.2855   −1248.9157
>     8    −377.1699   −638.9887    −878.7527   −1153.1895   −1402.0928
>    12    −470.9035   −746.1074   −1004.2606   −1283.1656   −1552.3739
> ```
>
> Real, negative, monotone, and smooth — a continuous flow on the zero set of which the integer Jensen shifts are snapshots. dz₁/dw by central differences on this data is −21.47 at w = 0, −21.76 at w = 2, −23.01 at w = 8.
>
> **This table replaces an earlier one, which was wrong in its second column** (TODO **A4**). The old z₂ printed −442.41 at w = 0, where the answer is checkable against −γ₂² = −441.92615 and is −441.9262; and −739.87 at w = 12, where it is −746.1074. The z₁ column reproduced everywhere and still does. Every entry above is stable between K = 128 and K = 140, and is produced by `rust/bin/b2_flow` at sixty digits, by bisection inside a one-root bracket rather than by a global solve on a degree-K polynomial.

## Hypotheses and notation

- The zeros z_k(w) are the negative real zeros of F(w, ·) = Σ_{j≥0} A(w+2j)·y^j/j!, ordered by magnitude (equation (29)).
- K is the truncation order of the polynomial whose roots are bisected; the table is stable between K = 128 and K = 140.
- dz₁/dw is a central-difference estimate on the tabulated data; the source quotes −21.47 (w = 0), −21.76 (w = 2), −23.01 (w = 8).
- The reference values −γ_k² are the w = 0 zeros from the F(0, y) = ξ(½ + √y) identification; the twenty-digit γ_k this directory carries has rounding 6.5e−20 … 7.4e−17 relative.

## Proof / evidence

The source reports a numerical computation (`rust/bin/b2_flow`) at sixty digits, by bisection inside a one-root bracket rather than a global polynomial solve, stable between K = 128 and K = 140. Central differences on the tabulated values give dz₁/dw = −21.47, −21.76, −23.01 at w = 0, 2, 8. The corrected z₂ column is checked against −γ₂² = −441.92615 at w = 0, where the table gives −441.9262.

## Dependencies and related results

- The two-variable object F(w, y) (29): [xihorn-continuation-two-variable-f-object.md](xihorn-continuation-two-variable-f-object.md).
- The truncation-order law that decides how many terms a given root needs: [xihorn-continuation-truncation-order-law-k-req.md](xihorn-continuation-truncation-order-law-k-req.md).

## Notes

- This is a correction of an earlier table in the same file (TODO **A4**): the second column was wrong at w = 0 and w = 12 ("−442.41" for "−441.9262"; "−739.87" for "−746.1074"), while the z₁ column reproduced.
- It is numerical evidence, not a certified flow theorem; the source gives no interval enclosure.
