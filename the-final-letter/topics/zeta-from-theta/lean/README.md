# Lean layer — zeta from theta

Two modules and the migrated theta layer:

* [`ThetaLayer.lean`](ThetaLayer.lean) — aggregate import of the three layer files;
* [`Topic.lean`](Topic.lean) — the theta-side object, its functional equation,
  the identification with Mathlib's `ζ`, the trivial-zero statement, and the
  assembled functional equation;
* [`Audit.lean`](Audit.lean) — the constant-level provenance audit (D7).

## The migrated layer (namespace `ZetaTheta`)

Moved here from `../../zeta-functional-equation/lean/` (HANDOFF M0) unchanged
except for import lines:

* [`Theta.lean`](Theta.lean) — `θ`, `ψ`, summability, positivity,
  `theta_one_div`;
* [`Mellin.lean`](Mellin.lean) — `hasSum_mellin_psi`;
* [`Zeta.lean`](Zeta.lean) — the Dirichlet form, `mellin_psi_eq_completed`,
  the split integral, `LambdaTilde`, `LambdaTilde_one_sub`,
  `differentiableAt_LambdaTilde`, `completedRiemannZeta_eq_LambdaTilde_all`,
  `riemannZeta_one_sub_theta`.

`zeta-functional-equation` now imports the layer through `ThetaLayer` and its
`check.sh` puts this directory on `LEAN_EXTRA_PATH`; both topics build.

## `Topic.lean` (namespace `ZetaFromTheta`)

| Item | Declaration |
|---|---|
| D1: Dirichlet series | `zetaSeries` |
| T1: convergence for `Re s > 1` | `summable_zetaSeries` |
| T2: the Dirichlet-series bridge | `zetaSeries_eq_riemannZeta` |
| T3: completed form on `Re s > 1` | `zetaSeries_eq_completed_div` |
| **D2**: standalone completed integral | `LambdaTheta` |
| D2: agreement with `mellin ψ (s/2)` | `LambdaTheta_eq_mellin` |
| D2: symmetry `Λ_θ(1−s) = Λ_θ(s)` | `LambdaTheta_one_sub` |
| D2: analyticity off `{0,1}` | `differentiableAt_LambdaTheta` |
| **D3**: theta-side zeta | `zetaTheta` |
| D3: agreement with the series | `zetaTheta_eq_zetaSeries` |
| **D4**: functional equation | `zetaTheta_one_sub` |
| **D5**: identification with `riemannZeta` | `zetaTheta_eq_riemannZeta` |
| D5: strengthened (`s ≠ 0, 1`) | `zetaTheta_eq_riemannZeta_of_ne_zero_one` |
| **D6**: trivial-zero value | `zetaTheta_trivial_zero` |
| **D6**: removable singularity | `zetaTheta_removable_at_trivial_zero` |
| **M6**: assembled functional equation | `riemannZeta_one_sub_from_theta` |
| **M6** (unconditional) | `riemannZeta_one_sub_from_theta'` |
| **D7**: provenance audit | `Audit.lean` + [`AUDIT.md`](AUDIT.md) |

`riemannZeta_one_sub_from_theta'` has the same statement as
`riemannZeta_one_sub_theta'` — no `Γℝ (1 − s) ≠ 0` hypothesis — and its
dependency cone passes the audit.  The conditional
`riemannZeta_one_sub_from_theta` is kept as the direct D4→D5 assembly; the
unconditional version handles the `s = 1 + 2n` branch by the vanishing of both
sides.

## Build

```bash
./check.sh Theta.lean Mellin.lean Zeta.lean ThetaLayer.lean Topic.lean
./check.sh Audit.lean        # provenance audit; prints "provenance OK" lines
```

`check.sh` delegates to `../../tools/check-lean.sh`, which puts this directory on
`LEAN_PATH` and builds against the local Mathlib
(`leanprover/lean4:v4.35.0-rc2`).
