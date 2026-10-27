# The crystal's atom-sum identity

**Kind:** Lemma
**Status:** PROVED (paper argument; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh32.html`](../../html/rh32.html) — §2 "The identity: a void is a concentration operator", lines 349–366 and boxed statement at lines 359–366

## Statement

> Take the crystal: 2M equispaced atoms on the circle, unit weights, mirror symmetric. Its certificate is perfect, and the reason is one line. For any polynomial p(z) = Σ<sub>k&lt;n</sub> c<sub>k</sub>z<sup>k</sup> with n ≤ 2M, the atom sum of |p|<sup>2</sup> hits every pair frequency k−l with |k−l| &lt; n ≤ 2M, and a full lattice sum of e<sup>i(k−l)θ</sup> vanishes unless 2M divides k−l — so only the diagonal survives:
>
> Σ<sub>atoms</sub> |p(θ<sub>j</sub>)|<sup>2</sup> = 2M·‖c‖<sup>2</sup>   for every p of degree &lt; n ≤ 2M   (verified on random polynomials to 2.4×10<sup>−15</sup>),
>
> so the moment matrix is T<sub>n</sub> = 2M·I exactly — every off-diagonal moment E(k), 0 &lt; k &lt; 2M, is zero to machine precision (4.3×10<sup>−12</sup>).

## Hypotheses and notation

- The crystal is 2M equispaced atoms on the circle with unit weights, mirror symmetric.
- p(z) = Σ<sub>k&lt;n</sub> c<sub>k</sub>z<sup>k</sup> is a polynomial of degree &lt; n ≤ 2M; ‖c‖<sup>2</sup> = Σ|c<sub>k</sub>|<sup>2</sup>.
- T<sub>n</sub> is the Toeplitz moment matrix; E(k) its off-diagonal moments; I the identity.

## Proof / evidence

One line, given in the source: the lattice sum of e<sup>i(k−l)θ</sup> vanishes unless 2M divides k−l, and |k−l| &lt; 2M, so only the diagonal k = l survives. Verification: random polynomials to 2.4×10<sup>−15</sup>, off-diagonal moments zero to machine precision (4.3×10<sup>−12</sup>).

## Dependencies and related results

- [rh31-crystal-lemma](../rh31/rh31-crystal-lemma.md) — the same exactness in eigenvalue form (λ/mass = 1 out to n = 2m).
- [rh32-void-identity](rh32-void-identity.md) — the identity after deleting atoms from an arc.
- [rh30-anchor-exact-trig-quadrature](../rh30/rh30-anchor-exact-trig-quadrature.md) — the classical quadrature fact this is the mirror-symmetric case of.

## Notes

- The source states this is unconditional elementary linear algebra: "the crystal of §§2–4 is synthetic — equispaced atoms, no arithmetic input".
- rh33 §2 later notes ρ = 1 on the mirrored crystal "to 9.9×10<sup>−15</sup>" as the special case of its loss constant.
