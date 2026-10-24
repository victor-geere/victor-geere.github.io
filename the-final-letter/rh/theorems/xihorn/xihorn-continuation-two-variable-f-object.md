# F(w, y) = Σ_{j≥0} A(w+2j)·y^j/j!, holomorphic in both arguments, with F(0, y) = ξ(½ + √y)

**Kind:** Proposition
**Status:** PROVED (paper argument; the w = 0 zeros verified numerically at 60 digits, agreeing with −γ_k² to 6.5e−20 … 7.4e−17 relative)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §8.2, equations (28)–(29) and the w = 0 zero table

## Statement

> Now continue the index as in §1. With a(n) = γ(n)·n!/(2n)! and n = w/2,
>
> ```
> A(w) = Γ_Φ(w)·Γ(w/2 + 1)/Γ(w + 1) = C(w)·Γ(w/2 + 1)                        (28)
> ```
>
> verified against a(n) at w = 2n to 2e−12 (n = 1, 2, 5, 10; n = 0 carries the 4e−7 quadrature error of Γ_Φ at w = 0). This gives the two-variable object
>
> ```
> F(w, y) = Σ_{j≥0} A(w + 2j)·y^j/j!                                         (29)
> ```
>
> holomorphic in both arguments, in which:
>
> * **y** carries the whole degree family, via (27);
> * **w** carries the index, continued off the integers as in §4;
> * the criterion is that **F(w, ·) lies in the Laguerre–Pólya class for every w** — all its y-zeros real and negative.
>
> At w = 0 this is ξ itself: F(0, y) = ξ(½ + √y), so its zeros sit at y = −γ_k². Confirmed, and it is the answer key everything downstream is measured against: at 60 digits and 170 terms the first nine come out as
>
> ```
>   −199.790454832386859   −441.926150574082490   −625.542996894331058
>   −925.673087273896182  −1084.71828178817347   −1412.72078858698393
>  −1674.34156559508088   −1877.23527908977846   −2304.49451112362396
> ```
>
> against −γ_k² for k = 1 … 9, agreeing to 6.5e−20 … 7.4e−17 relative — which is the rounding of the twenty-digit γ_k this directory carries, not a limit of the computation.

## Hypotheses and notation

- Γ_Φ is the Mellin continuation of the moments (equation (21)); C(w) = Γ_Φ(w)/Γ(w+1) is entire (equation (23)).
- a(n) = γ(n)·n!/(2n)! is the Laguerre–Pólya sequence of POSITIVITY.md (12).
- A(w) = Γ_Φ(w)·Γ(w/2+1)/Γ(w+1) is the index-continued version of a(n), read at w = 2n.
- F(w, y) is holomorphic in both arguments; the y-variable carries the Jensen degree family via (27), the w-variable carries the index.
- LP is the Laguerre–Pólya class: entire functions that are locally uniform limits of real-rooted polynomials.
- The source's reported zero computation is at 60 decimal digits with 170 terms; γ_k are the imaginary parts of the first nine non-trivial zeros of ζ.

## Proof / evidence

The source obtains (28) by continuing a(n) = γ(n)·n!/(2n)! with n = w/2, using (2n)! = Γ(2n+1) and Γ(w+1), and reports agreement against a(n) at w = 2n to 2e−12 for n = 1, 2, 5, 10 (n = 0 carries the 4e−7 quadrature error of Γ_Φ at w = 0). It defines F(w, y) by (29), notes holomorphy in both arguments from the entire/holomorphic factors, and identifies F(0, y) = ξ(½ + √y) at w = 0, whose zeros are y = −γ_k². The first nine such zeros are computed at 60 digits and 170 terms and agree with −γ_k² to 6.5e−20 … 7.4e−17 relative.

## Dependencies and related results

- The generating function (27): [xihorn-continuation-generating-function-all-jensen-degrees.md](xihorn-continuation-generating-function-all-jensen-degrees.md).
- The continuation Γ_Φ and C: [xihorn-continuation-continuation-and-pole-string.md](xihorn-continuation-continuation-and-pole-string.md), [xihorn-continuation-entire-repackaging.md](xihorn-continuation-entire-repackaging.md).
- The Jensen/Laguerre–Pólya criterion: [xihorn-positivity-jensen-laguerre-polya-criterion.md](xihorn-positivity-jensen-laguerre-polya-criterion.md).
- The zero flow as w varies: [xihorn-continuation-zero-flow.md](xihorn-continuation-zero-flow.md).

## Notes

- The LP criterion "F(w, ·) ∈ LP for every w" is stated by the source as a **restatement of RH**, not as an established theorem. The source's §8.4 says: "Restating uniformity is not obtaining it. (29) makes the d-direction *visible*; nothing here makes it *tractable*, and the LP condition on F(w, ·) for all w is exactly as hard as it was — it is RH, rewritten once more." Only the holomorphy, the identification (28) and the w = 0 zero agreement are harvested here.
- The source records a correction in this paragraph: "An earlier version of this paragraph reported −199.786 and −442.407; the second of those was wrong, see §8.3 and TODO **A4**."
