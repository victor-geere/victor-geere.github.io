# Repair: pole handling in the explicit-formula layer

**Status:** in progress (2026-11-18). Authorised repair of the vacuous
`hF_ne` hypothesis in `ExplicitFormula.lean`.

## Defect

`completedZeta` is defined as

```lean
cexp (-(s/2) * log π) * Gamma (s/2) * riemannZeta s
```

Mathlib gives `Gamma 0 = 0`, so `completedZeta 0 = 0`; similarly the value at
`1` is the junk value of `riemannZeta 1`. Consequently

```lean
example : completedZeta 0 = 0 := by simp [completedZeta]
example : (0 : ℂ) * (-1) * completedZeta 0 = 0 := by simp
```

The contour theorems require

```lean
hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0
```

while also requiring the rectangle `[-1,2] × [-T,T] ⊆ U`, which contains `0`.
So `hF_ne` is impossible and the contour theorems have no instances.

There is a second, independent defect: substituting finite divided slopes
`dslope h 0` and `dslope h 1` does not cancel the pole of `h·Z'/Z` at `0` or `1`.
The correct residue terms are `h 0 / z` and `h 1 / (z-1)`.

## Repair design

1. Define the pole-corrected product using Mathlib's **entire**
   `completedRiemannZeta₀`:

   ```lean
   Fext s = s * (s - 1) * completedRiemannZeta₀ s + 1
   ```

   This has `Fext 0 = 1`, `Fext 1 = 1`, is entire, and equals
   `s(s−1)Z(s)` away from the poles (proved in `lean/Repair.lean`).

2. `Fext` is already proved entire (`differentiable_Fext`). Its logarithmic
   derivative is analytic on the contour; no local pole extension is needed.

3. Reprove the remainder as
   `h · Fext'/Fext − Σ_{ρ∈S} hρ/(z−ρ) − h0/z − h1/(z−1)`,
   which is analytic at `0` and `1` because `Fext(0)=Fext(1)=1` and the
   `h0/z`, `h1/(z−1)` terms cancel the simple poles of `h·Z'/Z`.

4. Replace `hF_ne` by a condition on `Fext` away from the finite zero set, so it
   is satisfiable at `0` and `1`.

5. Rebuild `differentiableOn_globalRemainder`,
   `exists_analyticOnNhd_globalRemainder`, `test_function_explicit_formula` and
   `contour_shift_paleyWiener`, then revalidate the finite-window M3 bridge.

## Non-goals

No RH/GRH claim. The repair is about pole bookkeeping, not the truth of the
explicit formula.

## Progress (2026-11-18)

`lean/Repair.lean` now proves:

| Result | theorem |
|---|---|
| `Fext` is entire | `differentiable_Fext` |
| `Fext 0 = 1`, `Fext 1 = 1` | `Fext_zero`, `Fext_one` |
| `Fext s = s(s−1)Z(s)` away from `0,1` | `Fext_apply_ne` |
| `logDeriv Fext = 1/s + 1/(s−1) + logDeriv Z` away from `0,1` | `logDeriv_Fext_eq` |
| Corrected remainder differentiable on `U \ S` | `differentiableOn_globalRemainder_repair` |
| Corrected analytic remainder extension | `exists_analyticOnNhd_globalRemainder_repair` |

Also proved:

| Result | theorem |
|---|---|
| Corrected boundary decomposition | `logDeriv_mul_eq_remainder_plus_residues_repair` |
| **Corrected test-function explicit formula** | `test_function_explicit_formula_repair` |

The next step is the corrected Paley–Wiener contour shift
(`contour_shift_paleyWiener_repair`), then revalidating the finite-window M3
bridge.
