# Lean formalisation

## Toolchain

The development uses the same installation as `~/workspace/rh`:

- Lean 4 at `~/lean/elan/toolchains/leanprover--lean4---v4.35.0-rc2/bin/lean` (resolved from `~/lean/mathlib4/lean-toolchain`).
- Mathlib at `~/lean/mathlib4`.
- `check.sh` reconstructs `LEAN_PATH` from `lake env`, exactly like the `~/workspace/rh` scripts. It does not rely on the elan shims.

## Build

```
cd the-final-letter/lean
./check.sh --all
```

Expected output (recorded in [`BUILD.log`](../../lean/BUILD.log)):

```
[check] OK   FinalLetter/Chowla.lean
[check] OK   FinalLetter/Synthesis.lean
[check] OK   FinalLetter.lean
```

## Modules

### `FinalLetter/Chowla.lean`

The vendored finite-prefix development. It imports Mathlib only. It defines `Omega`, `liouville`, `corr`, `corrAsymptotic`, `shiftProd`, `liouvilleSlice`, `corrSlice`, and proves the 42-theorem finite-prefix layer, including:

- `corr_abs_le`, `corr_zero`, `corrAsymptotic_zero_false`;
- `liouville_mul`, `liouville_mem`, `liouville_sq`, `liouville_abs_le_one`;
- `shiftProd_not_completely_multiplicative`;
- `slice_agree`, `slice_ne`, `corrSlice_eq_corr_of_lt`;
- `corrSlice_sub_corr_self_eq`, `exists_corrSlice_ne_corr`;
- `corrSliceSqSub` (ℓ²-mass `4`);
- `corrAsymptotic_reading`.

It contains no `sorry`, no `axiom`, and no `native_decide`.

### `FinalLetter/Synthesis.lean`

The new synthesis layer. It imports `FinalLetter.Chowla` and `Mathlib.NumberTheory.LSeries.RiemannZeta`.

Definitions:

```
def RiemannHypothesis : Prop :=
  ∀ s ∈ riemannZetaZeros, 0 < s.re → s.re < 1 → s.re = 1/2

def TwinPrimeConjecture : Prop :=
  ∀ N : ℕ, ∃ p : ℕ, N < p ∧ Nat.Prime p ∧ Nat.Prime (p + 2)

def ChowlaTwoPoint : Prop := Rh46.corrAsymptotic 2

def corrOf (g : ℕ → ℤ) (h N : ℕ) : ℤ :=
  ∑ n ∈ Finset.Icc 1 N, g n * g (n + h)

def AgreesBelow (g : ℕ → ℤ) (a : ℕ) : Prop :=
  ∀ n : ℕ, n < a → g n = Rh46.liouville n
```

Theorems:

- `finite_prefix_indeterminacy` — for `a ≠ 0`, there is `g` agreeing below `a`, differing from `λ`, and reproducing `corr h N` on every prefix `N+h<a`;
- `slice_perturbation` — the exact two-summand perturbation identity;
- `finite_prefix_witness` — the `h=2, a=5` witness;
- `corr_abs_le`, `corr_zero`, `corrAsymptotic_zero_false`;
- `shiftProd_not_completely_multiplicative`;
- `slice_l2_mass` — the perturbation has ℓ²-mass `4`;

### `FinalLetter.lean`

The root module, importing the two.

## What is not formalised

The Riemann-side conversion theorem, the Davenport–Heilbronn sharpness theorem, the measure-theoretic tightness/limit theorems, the greedy complexity law, the budget/balance theory, and the explicit formula are **not** formalised in this development. They are formalised in the source repository to varying degrees (`Rh41`, `Rh42`, `Rh43`, `Rh45`, `Rh46`, `Rh47`, `Op56`, `ConeLean`, `TppLean`) and are cited in [Proofs](proofs.md). Formalising the full conversion theorem would require a substantial measure-theory and analytic-number-theory development; this letter formalises the logical core that survives both programmes: finite-prefix indeterminacy and the well-posedness of the two walls.

## Verification status

The build is `[check] OK`, with no warnings in the recorded run. There is no `sorry` and no `axiom`. The inherited deprecation/unused-variable linters are disabled at the top of the vendored file; this changes no proof.

[Back to README](README.md) · [Back to index](../../index.html)
