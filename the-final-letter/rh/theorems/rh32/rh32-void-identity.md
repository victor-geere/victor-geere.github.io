# A void is a concentration operator

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED by two independent eigensolvers)
**Area:** rh-html
**Source:** [`rh32.html`](../../html/rh32.html) — §2 "The identity: a void is a concentration operator", lines 368–397 and boxed statement at lines 376–386

## Statement

> Now delete the atoms in an arc of width W. The moment matrix of the remaining measure is T<sub>n</sub> = 2M·I − A, where A is the moment operator of the deleted atoms alone — a sum, over deleted atoms, of rank-two projectors built from the cosine and sine coefficient vectors c<sub>a</sub> = (cos kθ<sub>a</sub>)<sub>k&lt;n</sub>, s<sub>a</sub> = (sin kθ<sub>a</sub>)<sub>k&lt;n</sub>. Hence, exactly:
>
> λ<sub>min</sub>(T<sub>n</sub>) = 2M − λ<sub>max</sub>(A),   λ<sub>max</sub>(A) computable from the tiny Gram matrix of the deleted atoms' vectors.
>
> Verified by two independent eigensolvers — Toeplitz inertia bisection on the big matrix against Jacobi on the small Gram — to 9.1×10<sup>−13</sup> at (M = 300, n = 60, K = 2), and to 5.2×10<sup>−11</sup> at (M = 600, n = 60, K = 8), where the Gram is 160 × 160 and λ<sub>min</sub> has fallen ten orders below the mass.

The source adds:

> A is a familiar object: it is the **discrete prolate concentration operator** of the void — the operator whose top eigenvector is the degree-n polynomial most concentrated on the deleted arc. Its spectrum has the classical three-part shape (fig. 1, left): a plateau of eigenvalues hugging the mass, a plunge, and an exponential tail. At K = 4 the plateau holds exactly 4 eigenvalues above half the mass — Landau's count: *a void of K kernel wavelengths steals K degrees of freedom* — and the top eigenvalue's deficit is 5.5×10<sup>−5</sup>.

## Hypotheses and notation

- The starting point is [rh32-crystal-atom-sum-identity](rh32-crystal-atom-sum-identity.md): 2M equispaced unit atoms, T<sub>n</sub> = 2M·I.
- An arc of width W is emptied of atoms; A is the moment operator of the deleted atoms, a sum of rank-two projectors from c<sub>a</sub>, s<sub>a</sub>.
- K = nW/2π is the void's time-bandwidth (width in kernel wavelengths 2π/n).
- The Gram matrix of the deleted atoms' vectors is small (160 × 160 at M = 600, n = 60, K = 8).

## Proof / evidence

Paper argument: subtracting the crystal's identity from the deleted atoms' moment operator gives T<sub>n</sub> = 2M·I − A exactly, and λ<sub>min</sub>(2M·I − A) = 2M − λ<sub>max</sub>(A). Verified by two independent eigensolvers at the stated tolerances.

## Dependencies and related results

- [rh32-crystal-atom-sum-identity](rh32-crystal-atom-sum-identity.md) — the starting identity.
- [rh32-prolate-deficit-collapse](rh32-prolate-deficit-collapse.md) — the deficit 1 − l<sub>1</sub>(K) of A's top eigenvalue.
- [rh32-death-of-the-constant](rh32-death-of-the-constant.md) — the consequence for rh31's constant.
- [rh31-carathodory-toeplitz-restated](../rh31/rh31-carathodory-toeplitz-restated.md) — the Toeplitz/PSD fact the subtraction uses.

## Notes

- The source calls the operator "discrete prolate concentration operator" — the classical discrete prolate (Slepian) object; the three-part spectrum and Landau's count are cited as classical shape statements, the numbers measured here.
- Unconditional: "the identity, the collapse, and the crystal death curve are unconditional elementary linear algebra."
