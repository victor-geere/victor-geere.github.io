# Theorem 1

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** xi-horn
**Source:** [`xi-horn/rh30-10-a.md`](../../xi-horn/rh30-10-a.md) — §2 "The exact form of the problem"

## Statement

> **Theorem 1.** For any finite positive measure μ on 𝕋,
>
> ```
> λ_min(T_n(μ)) = min { ∫q dμ : q ≥ 0, q a trig polynomial of degree ≤ n−1,
>                                (1/2π)∫q dθ = 1 }                          (5)
> ```

## Hypotheses and notation

- 𝕋 the circle; μ any finite positive measure on 𝕋 (no RH needed for the
  identity itself — "Theorems 1–4 are unconditional statements about an
  arbitrary positive measure on the circle; only their application to μ
  inherits RH").
- Under RH the measure is `μ = Σ_ρ ĥ(γ_ρ)²·δ  at  γ_ρΔ′ mod 2π`, `‖μ‖ = E_h(0)`
  (2), where `T_n[j][k] = E_h((j−k)Δ′)`, `E_h(v) = Σ_ρ ĥ(γ_ρ)²cos(γ_ρ v)` (1);
  the window sets the weights, the mesh the positions.
- `D = n − 1`; q ranges over non-negative trigonometric polynomials of degree
  ≤ n−1 with mean `(1/2π)∫q dθ = 1`.

## Proof / evidence

The source's proof, verbatim: "λ_min = min over ‖c‖₂ = 1 of c*T_nc = ∫|p|²dμ
with p = Σ_{k<n}c_ke^{ikθ}, and ‖c‖₂² = (1/2π)∫|p|²dθ. By Fejér–Riesz the set
{|p|² : deg p ≤ n−1} is exactly the set of non-negative trig polynomials of
degree ≤ n−1. ∎"

Numerical check recorded in §2 and §10: "the minimising eigenvector's q = |p|²
has min q = 1.6e−9 ≥ 0, mean 1.0000000000, and ∫q dμ = λ_min to 12 digits."

## Dependencies and related results

- Fejér–Riesz (cited, classical).
- Three consequences drawn by the source in §2:
  **(i)** "It is one linear program" — (5) is a linear objective over the cone
  of non-negative trig polynomials, and its dual is `max{t : T_n − tI ⪰ 0}`;
  "every bound is a *relaxation*, and a relaxation is chosen by deciding which
  property of q to keep."
  **(ii)** rh30 §5's three routes (Gershgorin, Koksma, Marcinkiewicz–Zygmund)
  are three relaxations that keep the same property: "All three replace
  'q ≥ 0' by a bound on how fast q moves."
  **(iii)** "The relaxation is where the loss lives, so the loss is nameable."
- Feeds [Theorem 3](xihorn-rh30-10-a-t3-arc-mass-floor.md) (whose proof minimises over feasible q) and
  [F1](xihorn-rh30-10-a-f1-mean-one-bounds.md)–[F3](xihorn-rh30-10-a-f3-level-sets-few-long.md).

## Notes

- The source calls this "the rewriting that makes 'uses q ≥ 0' a definite
  phrase rather than a wish."
- §7 of the source records that the exact n-grid quadrature (8) "has no error
  term" and cannot be used on its own: "the positive quadratures for Lebesgue
  measure exact to degree n−1 are *precisely* the rotated n-grids (one
  parameter, by the para-orthogonal theory), and no rotation of a grid lands on
  the ordinates." (Recorded, not harvested as a separate result.)
