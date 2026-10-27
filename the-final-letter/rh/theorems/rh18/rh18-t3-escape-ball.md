# T3 — the escape from the lattice

**Kind:** Theorem
**Status:** PROVED (paper argument, from rh17's certified floors; uses the cited Rosser–Schoenfeld bound and IEEE-754/libmpdec directed rounding)
**Area:** rh-html
**Source:** [`rh18.html`](../../html/rh18.html) — §5 "The theorem", "What is proven beyond the equivalence"; labelled "the escape (T3)" in Figure 4

## Statement

> The effective content of the density step: rh17's certified floors m₀(Δ) transfer positivity off the lattice, to every window within ‖d‖<sub>∞</sub> ≤ r* of the certified spline class (perturbations with Var(d′) ≤ 100‖d‖<sub>∞</sub>): r* = 2.4×10⁻¹⁵ at Δ = 0.06, 7.0×10⁻¹⁸ at 0.015.

The source's Figure 4 ledger states it as: "the escape (T3): W &gt; 0 within ‖d‖<sub>∞</sub> ≤ 2×10⁻¹⁵ of the certified Δ = 0.06 class (Var d′ ≤ 100‖d‖<sub>∞</sub>)".

## Hypotheses and notation

- m₀(Δ) are rh17's certified floors: 5.448×10⁻¹¹ (Δ = 0.06), 4.171×10⁻¹³ (0.03), 1.427×10⁻¹³ (0.015).
- r* = m₀/K, the escape radius; the constant K(a) that eats the floor grows like e<sup>a</sup> (measured 13 at a = 2 to 860 at a = 6).
- The perturbation class: windows within ‖d‖<sub>∞</sub> ≤ r* of the certified spline class, with Var(d′) ≤ 100‖d‖<sub>∞</sub>.
- d = g − g<sub>Δ</sub>, the interpolation defect of [T2](rh18-t2-epsilon-bound.md).

## Proof / evidence

The source derives it from the density step of §3: if 𝒲(g⋆ǧ) ≥ m₀‖c‖² on the spline class, then every window within r* = m₀/K of that class in the stated norm still has 𝒲(g⋆ǧ) &gt; 0. The source reports the measured constants: "the constant K(a) that eats the floor grows like e<sup>a</sup> (measured 13 at a = 2 to 860 at a = 6, the prime constant's exponential), while the floors soften with the mesh". It calls these "the first non-lattice windows ever certified in this arc, and a precise measure of how far from (W) the certificates stand."

## Dependencies and related results

- [rh17 T2 — exact sections](../rh17/rh17-t2-exact-sections.md) supplies the certified floors m₀(Δ).
- [T2 — the ε(Δ; g) bound](rh18-t2-epsilon-bound.md) supplies the Lipschitz machinery.
- Superseded in value by [rh19's non-lattice ball](../rh19/rh19-non-lattice-ball.md), which evaluates the same formula at the corner rh18 did not, gaining a factor 2.35×10⁶ (r* = 5.742×10⁻⁹).
- Cited: Rosser–Schoenfeld (1962) through the prime constant's envelope.

## Notes

- The source's own hedge: "Microscopic, and honestly so"; the radius is quoted as 2.4×10⁻¹⁵ at Δ = 0.06 in §5 and as ≤ 2×10⁻¹⁵ in Figure 4 — both figures are reproduced here as stated.
- rh19 §5 restates the derivation as "if 𝒲(g⋆ǧ) ≥ m₀‖c‖² for the spline class, then every window within r* = m₀/K<sub>lin</sub> of that class in the stated norm still has 𝒲(g⋆ǧ) &gt; 0", and reports rh18's best as 2.443×10⁻¹⁵.
- The same passage of the source states further measured results (margin-perturbation stability: dent no Schur margin by more than 3.0×10⁻² of its 0.40–0.70 at η = 10⁻⁶; η* = 3.6×10⁻¹³); these are reported as measurements rather than as a separately labelled theorem and are not harvested here.
