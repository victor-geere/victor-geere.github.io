# The arc's Toeplitz matrix is the Gram matrix of a geometric set of rates — the same matrix written twice

**Kind:** Claim
**Status:** PROVED (paper argument, by construction); VERIFIED (numerical, agrees to 4.0×10⁻¹⁹ of the mass)
**Area:** rh-html
**Source:** [`rh35.html`](../../html/rh35.html) — §2 "The frame"

## Statement

> Then the identity that makes it a frame. Build G on the rates of the geometric set of ratio e<sup>Δ</sup> and it reproduces the arc's Toeplitz matrix to 4.0×10⁻¹⁹ of the mass — not approximately, but because they are the same matrix written twice. **The arc has been sampling the moment function at rates the construction does not have** — and it is worse than that: e<sup>kΔ</sup> is never a level, since k = log m / Δ is 5.776 at m = 2 and 9.155 at m = 3 and never an integer, so those rates belong to no gear at all.

> That change of frame is not decoration. §2 shows that the arc's Toeplitz matrix — the object it has been bounding since rh17 — **is itself the Gram matrix of a set of gear rates**: sampling the moment function at v = kΔ is sampling it at the rates of e<sup>kΔ</sup>, a geometric set with irrational ratios. So rh34's "lattice versus multiplicative" was never two objects. It was two members of one family, and the question in (a) is which member does better and why.

## Hypotheses and notation

- G[i][j] = E(log i − log j) is rh34 §3's unwrapped Gram; a "gear rate" is log n for a level n on the unit ladder.
- The geometric set has ratio e<sup>Δ</sup>; its rates are the sample points kΔ of the Toeplitz row.
- k = log m / Δ is the level index at which the prime-power rate log m would sit; it is 5.776 at m = 2 and 9.155 at m = 3.

## Proof / evidence

By construction, verified numerically to 4.0×10⁻¹⁹ of the mass: the Toeplitz matrix sampled at v = kΔ is the Gram matrix built on the rates e<sup>kΔ</sup>. The instrument also normalises the distance from a sample to the nearest gear rate by the local gap: uniform samples average a half and 4,000 of them read 0.495, the arc's sixty lattice points at Δ = 0.12 read 0.384, and rh33's six resonant moments read 0.259.

## Dependencies and related results

- [rh34-unwrapped-gram-and-dirichlet-polynomial](../rh34/rh34-unwrapped-gram-and-dirichlet-polynomial.md) — the object the frame carries.
- [rh34-lattice-conditioning-versus-multiplicative-structure](../rh34/rh34-lattice-conditioning-versus-multiplicative-structure.md) — the "lattice versus multiplicative" division this identity collapses.
- rh29's zero table (4,308 ordinates, γ ≤ 4800) is used from §3 on.

## Notes

- The source states the identity is exact ("the same matrix written twice"), the 4.0×10⁻¹⁹ being a numerical check rather than the ground of the claim.
- §2's statements about the construction are arithmetic on the helix and unconditional.
