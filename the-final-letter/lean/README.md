# Lean formalisation

## Toolchain

Same installation as `~/workspace/rh`:

- Lean 4 `v4.35.0-rc2`, resolved from `~/lean/mathlib4/lean-toolchain`.
- Mathlib at `~/lean/mathlib4`.
- `check.sh` reconstructs `LEAN_PATH` from `lake env`; it does not rely on the elan shims.

## Build

```
cd the-final-letter/lean
./check.sh --all
```

Recorded clean build: [`BUILD.log`](BUILD.log).

## Modules

- [`FinalLetter/Chowla.lean`](FinalLetter/Chowla.lean) — the vendored, `sorry`-free finite-prefix development (42 theorems). It defines `Ω`, `λ`, `corr`, `corrAsymptotic`, `shiftProd`, `liouvilleSlice`, `corrSlice`, and proves the finite-prefix layer.
- [`FinalLetter/Synthesis.lean`](FinalLetter/Synthesis.lean) — the new synthesis: defines `RiemannHypothesis`, `TwinPrimeConjecture`, `ChowlaTwoPoint`, `corrOf`, `AgreesBelow`; proves `finite_prefix_indeterminacy`, `slice_perturbation`, `finite_prefix_witness`, `corr_abs_le`, `corr_zero`, `corrAsymptotic_zero_false`, `shiftProd_not_completely_multiplicative`, `slice_l2_mass`.
- [`FinalLetter.lean`](FinalLetter.lean) — root module.

## What is not formalised

The RH conversion theorem, the Davenport–Heilbronn sharpness, the measure-theoretic tightness/limit theorems, the greedy complexity law, the budget/balance theory, and the explicit formula. They are formalised to varying degrees in `~/workspace/rh` (`Rh41`, `Rh42`, `Rh43`, `Rh45`, `Rh46`, `Rh47`, `Op56`, `ConeLean`, `TppLean`) and cited in [Proofs](../categories/05-proofs/proofs.md).

## Objective III

The certified evaluator is a separate development under
[`../topics/partial-sum-plus-tail/lean`](../topics/partial-sum-plus-tail/lean/README.md).
Its Euler–Maclaurin layer is proved in `EulerMaclaurin.lean` (T36–T43), with a
focused mirror and tests in [`../topics/euler-maclaurin`](../topics/euler-maclaurin/README.md).

## Status

`[check] OK` for all three modules; no `sorry`; no `axiom`. The open statements are `def`s. The inherited deprecation/unused-variable linters are disabled at the top of the vendored file; this changes no proof.

[Back to proofs](../categories/05-proofs/lean.md) · [Back to README](../README.md)
