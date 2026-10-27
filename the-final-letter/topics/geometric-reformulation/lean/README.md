# Lean formal core — geometric reformulation

## Build

```bash
the-final-letter/topics/geometric-reformulation/lean/check.sh 2>&1 | tee lean/BUILD.log
```

The script is a thin wrapper around the shared `../../tools/check-lean.sh` and uses the local Mathlib installation (`~/lean/mathlib4`, Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check: `[check] OK Topic.lean`.

## What is defined

`Topic.lean` opens the namespace `GeometricReformulation` and defines:

- `helixTorsion ω = ω / (1 + ω²)` — torsion of the unit helix `(cos (ωt), sin (ωt), t)`;
- `scaledTorsion c ω = ω / (1 + c²ω²)` — torsion of `(c cos (ωt), c sin (ωt), t)`;
- `coneRadius σ t k = exp (−(σπ/t) k)` — the radius `x_k^{-σ}` at the `k`-th intersection of the twin conical helices;
- `primeWeight p m = log p / p^{m/2}` — the weight of the atom `m log p` in the source's geometric prime distribution.

The torsion closed forms are obtained from the Frenet–Serret formula. The derivative algebra is checked symbolically in [`../python/programme.py`](../python/programme.py) (computations C1–C2) and taken as definitions here; Lean does not re-derive them.

## What is proved

| Name | Statement |
|---|---|
| `helixTorsion_pos` | `0 < ω → 0 < helixTorsion ω` |
| `helixTorsion_lt_half` | `ω ≠ 1 → helixTorsion ω < 1/2` |
| `helixTorsion_symm` | `ω ≠ 0 → helixTorsion ω = helixTorsion ω⁻¹` |
| `scaledTorsion_half_one` | `scaledTorsion (1/2) 1 = 4/5` |
| `scaling_not_torsion_invariant` | `scaledTorsion (1/2) 1 ≠ helixTorsion 1` |
| `coneRadius_pos_and_strictAnti` | for `σ, t > 0`, all cone radii are positive and `k ↦ coneRadius σ t k` is strictly antitone |
| `primeWeight_pos` | `p > 1 → 0 < primeWeight p m` |

No `sorry`, no `axiom`, no `admit`. There is no vacuous `rfl`-only padding: T2 and T5 are genuine inequalities, T3 is a field identity with a nonzero hypothesis, T6 is a monotonicity theorem over `ℕ`, and T7 is a positivity theorem for the source's weights.

## Two source corrections recorded by the formal core

1. **Equation (3.2) is not the Frenet torsion.** For a curve `C(t) = (cos φ(t), sin φ(t), t)`, the Frenet torsion is

   \[
   \tau = \frac{\phi'(\phi'^4-\phi'\phi'''+3\phi''^2)}
              {\phi'^6+\phi'^4+\phi''^2}.
   \]

   The archived formula has an extra factor `(φ'²+1)` in the denominator. At linear phase `φ(t)=ωt` the archived formula gives `ω/(1+ω²)²`, while the true torsion is `ω/(1+ω²)`. This is computation C3.

2. **Torsion is not invariant under constant scaling.** For `(c cos (ωt), c sin (ωt), t)` the torsion is `ω/(1+c²ω²)`, not `ω/(1+ω²)`. In particular `c=1/2, ω=1` gives `4/5`, so the source's step `r ≡ 1/2 ⇒ tors_r = tors_1` in the proof of Theorem 4.1 is false. This is `scaling_not_torsion_invariant` together with computation C2.

## What is not formalised

- The Frenet–Serret derivative calculation and the general non-linear-phase torsion.
- The phase interpolation `φ(γ_n)=2πn` and any analytic property of `φ` (monotonicity, smoothness, mollification).
- The Weil explicit formula and the distributional identity of Conjecture 3.1.
- The geometric prime distribution as a distribution; only its atom weights are formalised.
- The corrected Theorem 4.1 and any equivalence with RH.
- The CCM Dirac operator with point interactions, its self-adjoint domain, the finite truncation, and the Eigencoefficient Prime Sum Conjecture.
- The source's Möbius identity; it is false as stated, and the correction is tested in Python (C6), not formalised in Lean.

These items are recorded as **Source claim** or **Open / conjecture** rows in the programme ledger. In particular, RH and CCM Conjecture 1 are not theorems of this file.

[Back to the programme](../README.md) · [Topic index](../../README.md)
