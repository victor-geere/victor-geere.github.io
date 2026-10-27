# A non-lattice ball

**Kind:** Theorem
**Status:** PROVED (paper argument, from [rh18's T3](../rh18/rh18-t3-escape-ball.md) with the certified floor m₀ = 2.296×10⁻⁶)
**Area:** rh-html
**Source:** [`rh19.html`](../../html/rh19.html) — §5 "The escape, and the theorem", equation (4) and theorem box "What is proven"

## Statement

> r* = m₀/K<sub>lin</sub> = 5.742×10⁻⁹   at Δ = 0.24, n = 18, a = 2.28   (rh18's best: 2.443×10⁻¹⁵).

and, as stated in the theorem box:

> A non-lattice ball. By rh18's T3 with the floor m₀ = 2.296×10⁻⁶: 𝒲(g⋆ǧ) &gt; 0 for every window within 5.742×10⁻⁹ of the Δ = 0.24 spline class of half-support 2.28.

## Hypotheses and notation

- m₀ = 2.296×10⁻⁶ is the certified floor of the Δ = 0.24, n = 18, a = 2.28 rung of [The rungs](rh19-the-rungs.md).
- K<sub>lin</sub> is rh18's Lipschitz constant for the window class, growing like e<sup>a</sup> through the prime constant P(2a + 2Δ) and the pole constant 8B<sub>i</sub>²sinh(a + Δ).
- The norm is the one rh18 fixed: ‖d‖<sub>∞</sub> ≤ r* with Var(d′) ≤ 100‖d‖<sub>∞</sub>.
- The escape radius r* = m₀/K<sub>lin</sub> is rh18's T3 formula.

## Proof / evidence

The source observes that rh18 evaluated r* at one corner (a = 6, on Δ = 0.06, 0.03, 0.015) and got 2.443×10⁻¹⁵; since K<sub>lin</sub> grows like e<sup>a</sup> with support and m₀ falls with a, the maximum sits at the coarsest mesh and the narrowest support — the corner opposite the one rh18 measured. Evaluating rh18's own formula there gives 5.742×10⁻⁹, "a factor 2.35×10⁶" — "a genuine ball of non-lattice windows, of radius 5.742×10⁻⁹ in the norm rh18 fixed, on which Weil's quadratic form is proven positive without reference to any lattice." The document's pipeline runs 40 named checks in 243 s.

## Dependencies and related results

- [rh18 T3 — the escape from the lattice](../rh18/rh18-t3-escape-ball.md) supplies the formula and the norm.
- [The rungs](rh19-the-rungs.md) supplies m₀ = 2.296×10⁻⁶ and the certified floor at Δ = 0.24, n = 18.
- rh21's [window barrier](../rh21/rh21-window-barrier.md) bounds how far this kind of gain can be pushed by changing the window.

## Notes

- The source's framing: "That is the theorem the order asked for, and it came from reading rh18's own formula in the direction rh18 did not."
- The value is quoted exactly as the source writes it: 5.742×10⁻⁹, against rh18's best 2.443×10⁻¹⁵ (Figure 4 labels the gain 2.35×10⁶).
- The r* column of Figure 1 (5.74×10⁻⁹ for the Δ = 0.24, n = 18 row) is this same number.
