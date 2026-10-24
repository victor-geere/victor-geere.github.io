# The Mellin transform of a Collatz path is (1/s) times its orbit Dirichlet series

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`qa.md`](../../research/various/qa.md) — Q12, lines 437–446; listed as "Rigorous, classical" in the Part II "Notes on rigor", line 583

## Statement

> Write the path of n as n₀ = n, n_{k+1} = T(n_k), and attach its **orbit-counting function**
>
>    A_n(x) = #{k ≥ 0 : n_k ≤ x}.
>
> This is a step function, so it has a Mellin transform in the Perron/distributional sense, and the transform is exactly the **orbit Dirichlet series**:
>
>    ∫₀^∞ A_n(x) x^{-s-1} dx = (1/s) Σ_{k≥0} n_k^{-s} = (1/s) Z_n(s),
>      Z_n(s) = Σ_{k≥0} T^k(n)^{-s}.

## Hypotheses and notation

- T is the standard Collatz map; n₀ = n, n_{k+1} = T(n_k) is the orbit (the source's "path").
- A_n(x) = #{k ≥ 0 : n_k ≤ x} is the orbit-counting (step) function of that orbit.
- Z_n(s) = Σ_{k≥0} T^k(n)^{−s} is the orbit Dirichlet series.
- The Mellin transform is taken in the Perron/distributional sense, since A_n is a step function.

## Proof / evidence

The source states the identity and lists it as "Rigorous, classical" in the Part II "Notes on rigor" (line 583: "the identity ∫ A_n(x) x^{−s−1} dx = (1/s) Σ n_k^{−s}"). It supplies no proof; the identity is a term-by-term Mellin transform of a step function: ∫₀^∞ 1_{[n_k, ∞)}(x) x^{−s−1} dx = n_k^{−s}/s for Re s > 0.

The source then distinguishes the two cases: a divergent orbit gives convergence of Z_n(s) for Re(s) > 0; under the conjecture the path is eventually periodic and the raw series diverges for every s, so the transform is only meaningful truncated at the stopping time σ(n), Z_n(s) = Σ_{k=0}^{σ(n)} n_k^{−s}, "a finite Dirichlet polynomial — an **entire function** of s."

## Dependencies and related results

- The source's later correction (Follow-up to Q12, lines 481–513) revises its own "nothing is known beyond density results" claim and points to Kontorovich & Miller (arXiv:math/0412003) on Benford behaviour of 3x+1 iterates, and names Bernstein & Lagarias, "The 3x+1 Conjugacy Map" (Canad. J. Math. 48 (1996), 1154–1169) and Applegate & Lagarias, "Lower bounds for the total stopping time of 3x+1 iterates" (Math. Comp. 72 (2003), 1035–1049) as the rigorous machinery the object rests on.
- [qa-collatz-2-adic-measure-preserving](qa-collatz-2-adic-measure-preserving.md) — the 2-adic setting in which the orbit series is well-defined.

## Notes

- The status is PROVED (paper argument): the source gives the identity and the source's own notes classify it as rigorous/classical; it is an elementary Mellin computation, and no external reference is attached to it specifically.
- The source's evaluative claims around it ("its near-triviality is the interesting part"; "the conjecture 'σ(n) = O(log n)' is exactly a growth statement about the coefficients of F(s)") are its own framing, not part of the identity.
