# Lean formal core — Riemann helix

## Build

```bash
the-final-letter/topics/riemann-helix/lean/check.sh
```

The wrapper calls the shared [`tools/check-lean.sh`](../../tools/check-lean.sh), which elaborates `Topic.lean` against the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is defined

| Name | Definition |
|---|---|
| `RiemannHelix.helix R c t` | the point `(R cos t, R sin t, c t)` of the circular helix |
| `RiemannHelix.curvature R c` | the constant curvature `R / (R² + c²)` |
| `RiemannHelix.torsion R c` | the constant torsion `c / (R² + c²)` |

The closed forms are the classical Frenet invariants of a circular helix. Their derivation from the Frenet–Serret formulae is verified symbolically in the Python layer (`test_frenet_torsion_matches_closed_form`, `test_frenet_curvature_matches_closed_form`); the Lean file takes the closed forms as the definitions and proves their algebraic and order properties.

## What is proved

| Name | Statement |
|---|---|
| `helix_on_cylinder` | `(helix R c t).1 ^ 2 + (helix R c t).2.1 ^ 2 = R ^ 2` |
| `torsion_pos` | `0 < R → 0 < c → 0 < torsion R c` |
| `torsion_strictAnti_radius` | `0 < R₁ → R₁ < R₂ → 0 < c → torsion R₂ c < torsion R₁ c` |
| `torsion_scale` | `0 < R → 0 < c → 0 < λ → torsion (λR) (λc) = torsion R c / λ` |
| `torsion_not_scale_invariant` | `0 < R → 0 < c → 0 < λ → λ ≠ 1 → torsion (λR) (λc) ≠ torsion R c` |
| `torsion_half_ne_unit` | `torsion (1/2) 1 ≠ torsion 1 1` (the exact values are `4/5` and `1/2`) |
| `curvature_torsion_inversion` | `κ² + τ² = 1/(R²+c²)`, `κ/(κ²+τ²) = R`, `τ/(κ²+τ²) = c` |

No `sorry`, no `axiom`, no `admit`.

`torsion_scale` and `torsion_half_ne_unit` are not decoration: they are the formal counterpart of the audit in the programme README. The archived note uses “scaling does not change the torsion” to pass from RH to the torsion identity; torsion in fact scales as `1/λ`, and in the constant-rate case `(R, c) = (1/2, 1)` has torsion `4/5`, not `1/2`. (The source's own `C_{1/2}` is not a uniform scaling of `C_1`, and its torsion depends on the phase `φ`.) Consequently the Lean core proves the *opposite* of the source's proof step, not the source's RH equivalence.

## What is not formalised

- The varying-radius curve `C_r(t) = (r(t) cos φ(t), r(t) sin φ(t), t)` and its torsion formula. A direct sympy computation produces a large expression involving `r′, r″, r‴, φ′, φ″, φ‴`; its singularity analysis is not attempted here.
- The distributional limit `τ₁ → τ₀`, the prime-supported measure with weights `log p / p^{m/2}`, and the archimedean term `τ_arch`. This needs distribution theory, mollifiers, and the Weil explicit formula; it is recorded as source claim S2.
- The existence of the interpolating phase `φ` and radius `r` (source claim S5).
- The converse forcing `r` to be constant (source claim S4) and the RH equivalence itself (source claim S3 / open item O1).
- The density of `{m log p}` (source claim S6). The literal claim on `[0,∞)` is false; the useful statement on `[log 2,∞)` would need the prime number theorem.

The source's displayed torsion formula is also not formalised: it is not the correct Frenet torsion, as `test_source_torsion_formula_disagrees` shows. A formalisation of the corrected formula would require a substantial differential-geometry development of space curves; the programme instead keeps the closed-form invariants as definitions and proves the properties the argument actually uses.

## Honest status

This is a small genuine formal core about the helix invariant `c/(R²+c²)` and its curvature–torsion inversion. It is **not** a formalisation of the Riemann Hypothesis, of the explicit formula, or of the archived equivalence. Those remain source claims and open items in the [programme dossier](../README.md).

[Back to the programme](../README.md) · [Topic index](../../README.md)
