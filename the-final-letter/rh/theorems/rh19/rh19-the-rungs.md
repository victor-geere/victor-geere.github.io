# The rungs

**Kind:** Theorem
**Status:** PROVED (computer-assisted interval certificate; rh17's backend α — 40-digit Cholesky, 90-digit residual bound, interval row radius plus ρ<sub>D</sub>; conditional on IEEE-754, libmpdec, and that libm's log is correctly rounded to one ulp on [½, 1))
**Area:** rh-html
**Source:** [`rh19.html`](../../html/rh19.html) — §2 "The certificates", theorem box "The rungs"; the certified values are tabulated in Figure 1

## Statement

> For each pair (Δ, n) below, the section [E<sub>Δ</sub>((j−k)Δ)]<sub>j,k&lt;n</sub> is positive definite, with λ<sub>min</sub> bounded below by the stated m₀ — proven, not measured: a Cholesky factor computed at 40 digits, its residual ‖T − sI − RᵀR‖<sub>∞</sub> bounded at 90 digits, and the interval radius of the rows plus the trapezoid aliasing radius ρ<sub>D</sub> subtracted. This is rh17's backend α, applied to meshes and horizons it never saw.

The pairs and their certified floors (Figure 1; v = (n−1)Δ is the horizon, a the window half-support, r* the escape radius the floor buys):

| Δ | n | v | a | certified m₀ | margin | r* | lane |
|---|---|---|---|---|---|---|---|
| 0.24 | 18 | 4.08 | 2.28 | 2.296×10⁻⁶ | 49,022,298× | 5.74×10⁻⁹ | α |
| 0.24 | 51 | 12.00 | 6.24 | 4.937×10⁻⁹ | 1,842× | 1.18×10⁻¹³ | α |
| 0.24 | 68 | 16.08 | 8.28 | 4.551×10⁻¹⁰ | 23× | 1.10×10⁻¹⁵ | α |
| 0.24 | 76 | 18.00 | 9.24 | 9.953×10⁻¹¹ | 2.8× | 8.26×10⁻¹⁷ | α |
| 0.12 | 34 | 3.96 | 2.10 | 2.661×10⁻⁸ | 801,382× | 1.06×10⁻¹⁰ | α |
| 0.12 | 101 | 12.00 | 6.12 | 9.834×10⁻¹⁰ | 497× | 3.43×10⁻¹⁴ | α |
| 0.12 | 134 | 15.96 | 8.10 | 2.558×10⁻¹¹ | 2.8× | 9.50×10⁻¹⁷ | α |
| 0.06 | 199 | 11.88 | 6.00 | 5.291×10⁻¹¹ | 35× | 2.37×10⁻¹⁵ | α |

The last row is the regression row, rebuilding rh17's 5.448×10⁻¹¹ through rh19's lane at 5.291×10⁻¹¹.

## Hypotheses and notation

- E<sub>Δ</sub>(v) = pole + archimedean − comb is rh15's kernel, rebuilt from scratch: B(r) = Δ·sinc²(rΔ/2) the hat transform, the archimedean term integrated against ψ̃(r) = Re ψ(¼ + ir/2) − ln π, and the comb Σ Λ(m)m<sup>−1/2</sup>C<sub>Δ</sub>(ln m ∓ v) over every prime power.
- The section is a rung of (L), the lattice statement rh18 proved equivalent to RH.
- m₀ is the certified lower bound on λ<sub>min</sub>; "margin" is the float λ<sub>min</sub>'s margin over the proven row radius; r* = m₀/K<sub>lin</sub>.
- Reused constants: [L1](../rh17/rh17-l1-tail-never-bounded.md) (the PSD tail drop) and [L2](../rh17/rh17-l2-aliasing-bound.md), recomputed here to ρ<sub>D</sub> ≤ 4.4×10⁻¹⁷ at Δ = 0.24; the row radius is new (§3).
- Hypotheses named by the source: Weil's criterion (cited); IEEE-754 and libmpdec; and that libm's log is correctly rounded to within one ulp on [½, 1), spot-verified against Decimal on 20,007 gears (worst deviation 1.58×10⁻¹⁶).

## Proof / evidence

Backend α unchanged from [rh17 T1](../rh17/rh17-t1-certified-sections.md): a 40-digit Cholesky factor, a 90-digit exact-product residual, and the interval radius of the rows plus ρ<sub>D</sub> subtracted. The source's verification: 40 named checks in 243 s; rh17's row midpoints rebuilt to 3.3×10⁻¹⁵ across all 199 entries; rh18's `comb_f` reproduced to 1.5×10⁻¹³; P(12.12) = 853.99 recovered; every one of the eight α runs asserted to return a positive certified floor. The comb (37,422,901 gears, every prime power below e<sup>20.4</sup>) runs in IEEE double widened by the proven row-radius bound rad<sub>k</sub> ≤ M<sub>k</sub>·[(2/3)·δu(kΔ) + Δ·7.8×10⁻¹⁶] (§3, equation (2)), with the two-double log ln m = e·ln2 + ln f from (f, e) = frexp(m).

## Dependencies and related results

- [L1](../rh17/rh17-l1-tail-never-bounded.md), [L2](../rh17/rh17-l2-aliasing-bound.md), and rh17's backend α.
- [rh18 T — P2, closed](../rh18/rh18-t-p2-closed.md) makes each rung a rung of (L).
- [The non-lattice ball](rh19-non-lattice-ball.md) consumes the strongest floor, m₀ = 2.296×10⁻⁶.
- rh21 §4 finds the certified horizon here is limited by the sieve, not the arithmetic; rh21's [decay-law correction](../rh21/rh21-floor-power-law.md) supersedes the exponential law rh19's §4 ceiling was built on.

## Notes

- The source's own summary in §5 restates this as "Seven new rungs of (L) … at meshes Δ = 0.24 and 0.12 and horizons up to v = 18.00"; the last table row is the regression row at Δ = 0.06, not a new rung.
- "Not proved: RH. Each row is one rung; the conjunction over every mesh and every n is the hypothesis itself."
- The source notes the regression floor 5.291×10⁻¹¹ is 2.9% lower than rh17's 5.448×10⁻¹¹, "precisely the price of rh19's larger row radius".
