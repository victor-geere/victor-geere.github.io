# T2 (exact sections)

**Kind:** Theorem
**Status:** PROVED (computer-assisted; from T1 with L1 and L2; conditional on IEEE-754 and libmpdec directed rounding)
**Area:** rh-html
**Source:** [`rh17.html`](../../html/rh17.html) — §5 "The theorems"

## Statement

> M<sub>Δ</sub> = (matrix in T1's enclosure) + (PSD tail matrix, L1) − (matrix of ∞-norm ≤ ρ<sub>D</sub>, L2). Hence each exact section is positive definite with λ<sub>min</sub> ≥ 5.45×10⁻¹¹, 4.17×10⁻¹³, 1.43×10⁻¹³.

## Hypotheses and notation

- M<sub>Δ</sub> = [E((i−j)Δ)] is the n×n exact section of the kernel E, at Δ ∈ {0.06, 0.03, 0.015} and n = 199, 399, 799.
- "(matrix in T1's enclosure)" is any symmetric Toeplitz matrix whose first row lies within the computed enclosures of E<sub>cert</sub>.
- "PSD tail matrix, L1" is the dropped archimedean tail past the cut R₀, positive semidefinite by [L1](rh17-l1-tail-never-bounded.md).
- "matrix of ∞-norm ≤ ρ<sub>D</sub>, L2" is the aliasing error matrix, with ρ<sub>D</sub> ≤ 4.2×10⁻¹⁸ at Δ = 0.015 by [L2](rh17-l2-aliasing-bound.md).
- The three lower bounds are listed in the mesh order Δ = 0.06, 0.03, 0.015.

## Proof / evidence

The decomposition is E<sub>exact</sub> = E<sub>cert</sub> + (PSD) − D (§2): dropping a positive-semidefinite term lowers the form, so a positive verdict on E<sub>cert</sub> transfers to E<sub>exact</sub> once the remaining term is bounded in ∞-norm by ρ<sub>D</sub>. The source's backend α gives the corresponding exact-section inequality λ<sub>min</sub> ≥ s − ‖F‖<sub>∞</sub> − ρ<sub>Σ</sub> − ρ<sub>D</sub> (equation (4)). All constants are produced and asserted by `compute_rh17.py` (54 named checks); **that script is not in this repository**, so the constants are *asserted by the source*, not *reproducible here* (audit repair 2/5).

## Dependencies and related results

- [T1 — certified sections](rh17-t1-certified-sections.md) supplies the certified enclosure of E<sub>cert</sub>.
- [L1 — the tail is never bounded](rh17-l1-tail-never-bounded.md) supplies the PSD tail.
- [L2 — the aliasing bound](rh17-l2-aliasing-bound.md) supplies ρ<sub>D</sub>.
- [T3 — the equation](rh17-t3-the-equation.md) reads the Schur parameters off T2.

## Notes

- The source's hypothesis list is shared with T1: (i) IEEE-754 double arithmetic behaves as specified; (ii) libmpdec's Decimal arithmetic rounds correctly in directed-rounding contexts; plus two cited classical facts with explicit constants (the strip aliasing bound and the Stirling remainder).
- The floors are shared with T1: 5.45×10⁻¹¹, 4.17×10⁻¹³, 1.43×10⁻¹³ (the lower ends of T1's certified brackets).
- Under "What is not proved" the source states that T1/T2 certify positivity with an explicit floor, not the exact value of λ<sub>min</sub>, and that the certificates concern the cubic-hat autocorrelation windows of rh14, not an arbitrary window family.
