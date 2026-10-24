# Lean formal core — self-adjoint / CCM operator

## Build

```bash
the-final-letter/topics/self-adjoint-ccm/lean/check.sh
```

The wrapper calls the shared checker at `../../tools/check-lean.sh`, which uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed `BUILD.log` records the last successful run:

```
[check] OK   Topic.lean (7s)
```

## What is formalised

`Topic.lean` defines the generalised Riemann helix, the source's torsion formula, the point-interaction matching coefficient, the CCM half-integer frequencies, and proves seven elementary facts:

| Name | Statement |
|---|---|
| `CCM.helix_on_unit_cylinder` | `(helix φ t).1 ^ 2 + (helix φ t).2.1 ^ 2 = 1`: the helix projects onto the unit cylinder. |
| `CCM.torsion_denom_pos` | `0 < p ^ 6 + p ^ 4 + q ^ 2` for `p > 0`: the torsion denominator is positive. |
| `CCM.torsion_const_phase` | For `φ' = p`, `φ'' = φ''' = 0`, the source torsion is the exact constant `p / (1 + p ^ 2)`. |
| `CCM.torsion_const_phase_pos` | That constant is positive for `p > 0`. |
| `CCM.matching_unitary` | `‖exp (i c)‖ = 1`: the point-interaction matching coefficient is unitary. |
| `CCM.frequency_symmetry` | `μ_{−k−1} = −μ_k` for `μ_k = (2π/L)(k + ½)`. |
| `CCM.prime_power_cutoff_iff` | For `p > 1` and `λ > 0`, `p^m ≤ λ^2 ↔ m log p ≤ 2 log λ`. |

No `sorry`, no `axiom`, no `admit`. The file imports `Mathlib`, uses the namespace `CCM`, and contains no `rfl`-only declarations.

## What is not formalised

The following are recorded as source claims or open items in the programme README, not as theorems:

1. **Derivation of equation (1).** The Lean definition `torsionFormula` is taken from the source. The fact that it equals the Frenet–Serret torsion of `helix` is checked exactly in `python/programme.py` (computation C2) but is not derived in Lean; that would need a development of `deriv`, cross products in `ℝ³`, and the Frenet frame.
2. **Self-adjointness of the Dirac operator.** `matching_unitary` proves only that the matching coefficient has modulus one. It does not construct the operator `D_λ`, its domain, or its self-adjoint extension. The source's self-adjointness assertion relies on the point-interaction theory of Albeverio–Gesztesy–Høegh-Krohn–Holden.
3. **The torsion distribution.** The convergence of the torsion to `Σ c(p^m) p^{−m/2} δ(t − m log p)` plus a smooth background is not formalised; it is a distributional limit requiring a bump-width construction.
4. **The CCM identification.** That the band-limited projection of `D_λ` is the CCM Weil matrix `Q`, the trace formula (4), and the reduction of CCM Conjecture 1 to WKB asymptotics plus a finite-dimensional trace formula are all source claims.
5. **Spectrum identification and GRH.** The claim that the spectrum of `D_∞` is `{±γ_n}`, and the generalisation to all automorphic `L`-functions, are conditional on the source's open Gaps 1–3 and on GRH (the phase `φ` is built from zeros assumed to lie on the critical line).

The source itself is explicit that these are open problems; nothing in this folder upgrades them.

[Back to the programme](../README.md) · [Topic index](../../README.md)
