# `007/lean` — Lean 4 formalisation of generalisation #6 (character sums)

Machine-checked core of `research/twin-prime-parity/007/`: replacing the parity
sieve `c = 1_{2|m}` of OP-5/OP-6 by a general periodic coefficient (a Dirichlet
character is the zero-mean case).

Toolchain: Lean `v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`. No `lake`
project file: `check.sh` rebuilds `LEAN_PATH` from `lake env` inside Mathlib
(copied from `../../006/lean/check.sh`).

## Building

```
cd research/twin-prime-parity/007/lean
./check.sh --all                 # Defs, Leading, Blocks, Obstruction, root
./check.sh Op57/Blocks.lean      # one module
LEAN_PREFIX=/path/to/lean ./check.sh --all
```

## Status

`./check.sh --all` → **5/5 `[check] OK`**. **0 `sorry`** and **0 `axiom`**
declarations in the development. `#print axioms` on every theorem gives exactly
`[propext, Classical.choice, Quot.sound]` — in particular **no `native_decide`**
(006's one inherited caveat is absent here).

| file | contents |
|---|---|
| `Op57/Defs.lean` | `IsPeriodic`, the twisted boundary functional `PhiChi`, the twisted generating function `F`, the block polynomial `fblock`, `endpointValue`; the geometry lemmas `geom_term`, `geom_norm_lt_one` |
| `Op57/Leading.lean` | the anchor: **`leading_forced_of_hasSum_geom`** (`Σ_k x^{qk+s} = 1 ⊢ x^s = 1 − x^q`), the parity specialisations `leading_forced_parity_even` (`x² = 1/2`) and `leading_forced_parity_odd` (`x² + x = 1`), and the exact roots `x = 1/√2` and `x = (√5−1)/2` |
| `Op57/Blocks.lean` | `periodic_mod`, `periodic_eq_of_mod_eq`; the **regrouping** `hasSum_F_of_periodic` and **`F_eq_fblock`**: `F_r(x) = f_r(x)/(1−x^q)`; `fblock_mod`, `F_mod` |
| `Op57/Obstruction.lean` | `chi3`, `chi4`; the block polynomials; **`chi3_F_lt_one`, `chi4_F_lt_one`** (`F_r(x) < 1` for all `r`, all `x ∈ [0,1)`) and the no-threshold corollaries `chi3_no_leading_threshold`, `chi4_no_leading_threshold` |
| `Op57.lean` | root module |

## What is proved, in words

1. **Regrouping.** For a `q`-periodic coefficient and `|x| < 1`,
   `Σ_{j≥1} c(r+j) x^j = (Σ_{s=1}^{q} c(r+s) x^s)/(1 − x^q)`.
2. **Forced leading equation.** A residue-class sieve forces `x^s = 1 − x^q`;
   for the parity sieve this is `x² = 1/2` (even `r`, `x = 1/√2`) or
   `x² + x = 1` (odd `r`, `x = (√5−1)/2`). This is the character-sum analogue of
   006's `Op56.leadingCoeff_forced` (`x = 1/2`).
3. **Non-existence for `χ₃`, `χ₄`.** The twisted generating function is strictly
   below `1` on `[0,1)` for every residue, so the leading threshold equation has
   no solution: the OP-5 threshold is destroyed by these twists.

## Axiom check

```lean
import Op57
#print axioms Op57.F_eq_fblock
#print axioms Op57.chi3_F_lt_one
#print axioms Op57.leading_forced_parity_odd_eq
```

## Not formalised here

The limit law `Φ_c(p,n) → F_{n mod q}(e^{−p/n})` with error `O(1/n)` and the
second-order expansion `p(n) = a n + g + c/n + O(1/n²)` are established
numerically (`../verify/`) and stated in `../notes/generalisation-06.md`. They
need the analytic estimates of the same kind as 006's `PhiAsymptotic.lean`.
