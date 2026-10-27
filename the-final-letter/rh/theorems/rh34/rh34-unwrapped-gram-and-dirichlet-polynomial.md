# The unwrapped Gram: G[i][j] = E(log i − log j), one parameter, Dirichlet polynomial trial function

**Kind:** Claim
**Status:** PROVED (paper argument, by construction); VERIFIED (numerical)
**Area:** rh-html
**Source:** [`rh34.html`](../../html/rh34.html) — §3 "The unwrapped Gram"

## Statement

> The gear rates log n are not a lattice. Sample E there and nothing folds:
>
> G[i][j] = E(log i − log j),   and
> ∑<sub>i,j</sub> c<sub>i</sub>c<sub>j</sub> G[i][j] = ∑<sub>γ</sub> ĥ(γ)² ∣∑<sub>i</sub> c<sub>i</sub> i<sup>iγ</sup>∣<sup>2</sup>

> — so G is positive definite by construction, and *the trial function is a Dirichlet polynomial*. Both facts check out: λ<sub>min</sub>(G) &gt; 0, and two independent eigensolvers — Cholesky inertia bisection and cyclic Jacobi — agree on it to 1.2×10⁻¹². At N = 24, λ<sub>min</sub>(G)/mass = 0.2939.

> One structural remark, which is the reason this object is worth building at all. The lattice needs E at n points kΔ, so it has two parameters, (Δ, n). G needs E at the log(i/j), so it has one, N. **The arc's entire (Δ, n) grid — every mesh, every ladder, rh31's 336 points — is a property of the sampling, not of the measure.** The same E serves both.

## Hypotheses and notation

- E is rh34 §2's moment function, the same linear functional of the measure the lattice row samples.
- The sampling points are the log-differences log i − log j of the gear rates; the matrix index i, j runs to N.
- ∑<sub>i</sub> c<sub>i</sub> i<sup>iγ</sup> is the Dirichlet polynomial carried by a coefficient vector c.

## Proof / evidence

By construction: writing the quadratic form with the measure exhibits ∑<sub>γ</sub> ĥ(γ)²∣∑<sub>i</sub> c<sub>i</sub> i<sup>iγ</sup>∣<sup>2</sup> ≥ 0, so G is positive definite; the trial function is a Dirichlet polynomial. Numerical: λ<sub>min</sub>(G) &gt; 0 and the two eigensolvers agree to 1.2×10⁻¹²; at N = 24, λ<sub>min</sub>(G)/mass = 0.2939. rh35 §2 later verifies the same object reproduces the arithmetic lattice's Toeplitz matrix when built on a geometric set.

## Dependencies and related results

- [rh17](../rh17/rh17-t1-certified-sections.md) — the lattice row this object replaces as the thing to bound.
- [rh35-toeplitz-is-a-gram-on-geometric-rates](../rh35/rh35-toeplitz-is-a-gram-on-geometric-rates.md) — the frame identity that makes the two samplings one family.
- [rh30-effective-count-set-by-window](../rh30/rh30-effective-count-set-by-window.md) — N<sub>eff</sub>, the count whose (Δ, n) dependence the source calls a property of the sampling.

## Notes

- The source's own summary of the section is structural: the object is worth building because it has one parameter instead of two, and the same E serves both samplings.
- §3's statements are arithmetic on the construction and unconditional; §4 onward is conditional on RH in the same way every document since rh29 has been.
