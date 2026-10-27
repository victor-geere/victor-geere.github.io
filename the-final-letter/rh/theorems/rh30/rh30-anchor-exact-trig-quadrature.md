# The anchor: exact Gauss quadrature on a grid

**Kind:** Proposition
**Status:** CITED (literature, Gauss quadrature for trigonometric polynomials; VERIFIED numerically to 4×10<sup>−13</sup>)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §5 "The lower bound, and the two ways it fails", subsection "The anchor", lines 1080–1092

## Statement

> Start with the ideal configuration. If the atoms are n equally spaced points of equal weight, then Gauss quadrature for trigonometric polynomials is exact: ∑<sub>j</sub> q(θ<sub>j</sub>)·(2π/N) = ∫q for every trig polynomial q of degree &lt; N. So T<sub>n</sub> is a multiple of the identity and λ<sub>min</sub> is the entire mass. With 4,308 atoms and n = 151 that is reproduced to 4×10<sup>−13</sup>.

## Hypotheses and notation

- The atoms are N equally spaced points of equal weight on the circle; q is a trigonometric polynomial of degree < N.
- T<sub>n</sub> is the Toeplitz section; λ<sub>min</sub> its smallest eigenvalue; the mass is ‖μ‖.
- The 4,308 atoms are rh29's zero table cut at γ ≤ 4800.

## Proof / evidence

Gauss quadrature for trigonometric polynomials is classical and is cited rather than reproved; the source's own numerical check is that the configuration's λ<sub>min</sub> = the entire mass "with 4,308 atoms and n = 151 ... reproduced to 4×10<sup>−13</sup>". The source uses it as the baseline for every loss measured in the arc: "Everything the arc has ever measured is a loss against this."

## Dependencies and related results

- [rh30-loss-splits-into-weights-and-positions](rh30-loss-splits-into-weights-and-positions.md) — the four controls measured against this anchor.
- [rh32-crystal-atom-sum-identity](../rh32/rh32-crystal-atom-sum-identity.md) — the same exactness re-derived for the mirrored crystal.

## Notes

- Status is CITED (literature) because the exactness is the classical quadrature fact; the numerical reproduction at 4,308 atoms is the source's verification, quoted exactly.
- The source's pairing: "grid positions, equal weights — the anchor — λ<sub>min</sub>/‖μ‖ = 1.0000".
