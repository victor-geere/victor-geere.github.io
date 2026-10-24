# T2 — the ε(Δ; g) bound

**Kind:** Theorem
**Status:** PROVED (paper argument; every constant computed — one by exact sieve, one by interval cells, the rest by elementary inequalities with their integrals priced)
**Area:** rh-html
**Source:** [`rh18.html`](../../html/rh18.html) — §3 "The analytic care, performed", equation (5); labelled "T2" in Figure 4

## Statement

> ε(Δ; g) = ‖f−f<sub>Δ</sub>‖<sub>∞</sub>·[P(2a+2Δ) + 8B<sub>i</sub>² sinh(a+Δ)] + (1/π)∫|d̂|(|ĝ|+|ĝ<sub>Δ</sub>|)·env(r) dr = O(Δ²),

> every piece explicit. Evaluated: for the quartic window, ε = 1.62 at Δ = 0.06, 9.6×10⁻² at 0.015, 5.9×10⁻³ at 0.00375 — the Δ² ladder exactly (ratio 16.9 per double-halving); for the raised cosine, 5.8×10⁻² at the finest certified mesh.

Context stated with it: |𝒲(g⋆ǧ) − 𝒲(g<sub>Δ</sub>⋆ǧ<sub>Δ</sub>)| ≤ ε(Δ; g), for C² windows supported in [−a, a], where g<sub>Δ</sub> is the hat-spline interpolant of g on Δℤ and d = g − g<sub>Δ</sub>. The source concludes: "The arrow (L) ⟹ (W) follows for C² windows by (5) and for all of 𝒜 by one more density step inside the same constants … With (2), the chain closes: (L) ⟺ (W) ⟺ (Bo)."

## Hypotheses and notation

- 𝒜 = real g, compactly supported, continuous, with g′ of bounded variation; C² windows supported in [−a, a] for the stated evaluation.
- g<sub>Δ</sub> is the hat-spline interpolant on Δℤ (a lattice window, g<sub>Δ</sub> = g at every knot); d = g − g<sub>Δ</sub>.
- Spline moduli (3): ‖d‖<sub>∞</sub> ≤ Δ²‖g″‖<sub>∞</sub>/8, ‖d‖<sub>1</sub> ≤ 2(a+Δ)‖d‖<sub>∞</sub>, Var(d′) ≤ Var(g′) + (2a+2Δ)‖g″‖<sub>∞</sub> (classical, Schoenberg 1973, cited; "verified against measurement on both test windows").
- Prime constant: P(x) = Σ<sub>log n ≤ x</sub> Λ(n)n<sup>−1/2</sup>; P(12.12) = 853.99 exact by sieve; envelope P(x) ≤ 2·1.03883·e<sup>x/2</sup> from Rosser–Schoenfeld's ψ(t) &lt; 1.03883t by partial summation, tight to ratio 0.960 at x = 12.2.
- Pole constant: ∫(f−f<sub>Δ</sub>)·2cosh(v/2) bounded by ‖f−f<sub>Δ</sub>‖<sub>∞</sub>·8 sinh(a+Δ) ≈ 1700 at a = 6.
- Archimedean envelope (4): −5.3722 ≤ ψ̃(0) ≤ ψ̃(r) ≤ ln(2+r) for every r ≥ 0, from ψ̃ monotone increasing and interval cells.
- env(r) is that envelope; B<sub>i</sub>² the pole weight; the ‖f − f<sub>Δ</sub>‖<sub>∞</sub> factor is Young's inequality.

## Proof / evidence

The source performs the analytic care: fixes the class 𝒜 (because the archimedean term diverges on C⁰), proves the transform ladder |ĝ(r)| ≤ min(‖g‖<sub>1</sub>, Var(g′)/r²), prices each term of (1) separately with the constants above, and folds them into (5); the archimedean difference closes by an integral evaluated as an upper Riemann sum on outward cells plus a closed tail. Reported evaluations are quoted in the Statement. Verification: 47 named checks in 2.5 minutes.

## Dependencies and related results

- [T1a — the Weil identity at arbitrary nodes](rh18-t1a-weil-identity.md) supplies equation (2).
- Supplies the arrow (L) ⟹ (W) in [T — P2, closed](rh18-t-p2-closed.md).
- Cited: J. B. Rosser and L. Schoenfeld (1962); I. J. Schoenberg, *Cardinal Spline Interpolation* (1973); NIST DLMF §5.11 for Stirling with explicit remainders.
- rh19's escape radius [rh19-non-lattice-ball](../rh19/rh19-non-lattice-ball.md) is built from this bound's constant K<sub>lin</sub>.

## Notes

- Hypothesis explicitly cited: Rosser–Schoenfeld's ψ(t) &lt; 1.03883t (1962), used under the prime constant's displayed envelope; the sieve value itself is exact and hypothesis-free.
- The source records a finding that contradicts the naive reading of the bound: the measured lattice-vs-direct gaps are 7×10⁻⁹ against ε(0.015; g₁) = 9.6×10⁻², i.e. 2.4×10⁸ inside the bound, because the interpolation defect is spectrally exiled to r ~ π/Δ. The bound is not slack "against its own hypotheses"; the measurement simply does not see it.
- The density step for all of 𝒜 converges at rate Δ·Var instead of Δ²; the constants are unchanged.
