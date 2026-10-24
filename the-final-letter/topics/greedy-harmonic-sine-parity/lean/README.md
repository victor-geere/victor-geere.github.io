# Lean formal core — greedy harmonic sine / twin-prime parity

## Build

```bash
cd the-final-letter/topics/greedy-harmonic-sine-parity
./lean/check.sh
```

The wrapper calls the shared checker at [`../../tools/check-lean.sh`](../../tools/check-lean.sh), which elaborates `Topic.lean` against the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is defined

`Topic.lean` imports `Mathlib`, opens the namespace `GSP`, and defines the finite-prefix/parity objects of the archived rh46 layer:

| Definition | Meaning |
|---|---|
| `GSP.Omega n` | `ArithmeticFunction.cardFactors n`, the number of prime factors counted with multiplicity. |
| `GSP.liouville n` | `(-1) ^ Omega n`, with `liouville 0 = 1`. |
| `GSP.corr h N` | `∑_{1 ≤ n ≤ N} liouville n * liouville (n + h)`. |
| `GSP.shiftProd h n` | `liouville n * liouville (n + h)`. |
| `GSP.liouvilleSlice a n` | `liouville` with the single value at `a` negated. |
| `GSP.corrSlice h a N` | The correlation computed from `liouvilleSlice a`. |

## What is proved

| Name | Statement | Role |
|---|---|---|
| `GSP.liouville_sq` | `liouville n ^ 2 = 1` for every `n`. | The sign/parity fact behind the trivial bound. |
| `GSP.corr_abs_le` | `|corr h N| ≤ N`. | The source's trivial bound P15. |
| `GSP.corr_zero` | `corr 0 N = N`. | Sharpness: the bound is attained at zero shift. |
| `GSP.slice_agree` | `n < a → liouvilleSlice a n = liouville n`. | A one-point flip is invisible on earlier indices. |
| `GSP.corrSlice_eq_corr_of_lt` | `N + h < a → corrSlice h a N = corr h N`. | Prefix agreement of the correlations. |
| `GSP.corrSliceSqSub` | `1 ≤ a → a ≤ N → ∑_{1≤n≤N} (slice − λ)² = 4`. | The exact `ℓ²` mass of the flip. |
| `GSP.shiftProd_two_five` | `shiftProd 2 (5*5) ≠ shiftProd 2 5 * shiftProd 2 5`. | Non-complete-multiplicativity witness for the Chowla summand. |

There is no `sorry`, no `axiom`, and no `admit` in the file. All seven declarations are genuine statements about the source's objects, not tautologies or `rfl` padding; the `rfl` steps that occur are local definitional unfoldings inside larger proofs.

## Fidelity to the source

The definitions are adapted from `/Users/victor/workspace/rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (outside this repository, so not imported). The reconstruction keeps the source's conventions:

- `Omega 0 = 0` and `liouville 0 = 1`, the one point where this `liouville` differs from Mathlib's `ArithmeticFunction.liouville` (which is `0` at `0`);
- the correlation sums over `Finset.Icc 1 N`, so index `0` is outside every prefix;
- the slice flips a *value*, not a factor, which is why the perturbation has `ℓ²` mass exactly `4` rather than a growing mass.

The proofs of `liouville_sq`, `corr_abs_le`, `corr_zero`, `slice_agree`, `corrSlice_eq_corr_of_lt`, `corrSliceSqSub` and `shiftProd_two_five` follow the elementary strategy of the source declarations of the same names, simplified to the seven facts this dossier claims. The source's additional declarations (complete multiplicativity on nonzero arguments, the `0`-case counterexample, the exact perturbation identity `corrSlice_sub_corr_self_eq`, and the explicit witness `exists_corrSlice_ne_corr`) are not reproduced here; the mass identity and the prefix agreement are the parts used by the reconstruction's ledger.

## What is deliberately not formalised

1. **The asymptotic reading of the finite-prefix theorem.** The source concludes that the truth of `corrAsymptotic h` cannot be decided from any initial segment. That is a statement about the limit of `corr h N / N`; this file proves the prefix lemmas but does **not** define `corrAsymptotic` and does **not** prove any limit statement. In particular, `corrAsymptotic 2` is not stated.
2. **Two-point Chowla.** `Σ_{n≤x} λ(n)λ(n+2) = o(x)` is open in the source and is not a theorem here.
3. **The greedy digit word.** The factor-complexity law, budgets, Brown reachability and the parity lock (source rh41/rh42) are different objects. They are recorded as source claims in the dossier, not formalised in this Lean file.
4. **Sylvester-sparsity.** The source proves this on paper and verifies it numerically; it is not formalised here.
5. **Bridges B1–B5.** These are statistical/numerical refutations in the source, not formal statements, and are not reconstructed.
6. **The explicit-formula and smoothing layers.** These source theorems (rh43–rh45) lie outside this topic's selected finite-prefix/parity footprint.

## Why the core is small

The harvested source is a programme report, not a single theorem. Most of its content is a barrier ledger: negative findings, numerical controls, and open problems. The one clean parity-side theorem is the finite-prefix indeterminacy theorem, and its elementary content is exactly the slice algebra formalised here. The grand claims (RH, twin primes, Chowla, Sarnak, Elliott) have no proof in the source and none here; shrinking the Lean file to this finite core is the honest reconstruction.

[Back to the programme](../README.md) · [Topic index](../../README.md)
