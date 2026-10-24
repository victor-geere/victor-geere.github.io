# Lean formal core — greedy harmonic transfer operator

## Important limitation

The archived source directory
`archive/maths/rh/research/greedy-harmonic-transfer-operator/` is empty.
There is no source definition, theorem, or conjecture to formalise. The
definitions in `Topic.lean` are therefore **reconstruction choices made for
this folder**, not recovered mathematics. The file proves only elementary
facts about those choices.

No claim about the Riemann hypothesis, GRH, twin primes, Chowla, Sarnak, or
Elliott is made here.

## Build

```bash
the-final-letter/topics/greedy-harmonic-transfer-operator/lean/check.sh
```

The wrapper calls the shared `../../tools/check-lean.sh` and uses the local
Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed
`BUILD.log` records the last successful check.

## Definitions

Namespace: `GreedyHarmonicTransfer`.

| Name | Definition |
|---|---|
| `weight n` | `1 / (n + 2)` — the normalised greedy harmonic angle `α_n / π` |
| `transfer a` | `fun n => weight n * a (n + 1)` — a weighted shift |
| `transferIter k a` | the `k`-fold iterate of `transfer` |
| `remainder θ n` | `θ - weight n` — one-step normalised remainder |
| `totalWeight N` | `Σ_{n < N} weight n` — finite transferred mass |

## What is proved

| Name | Statement |
|---|---|
| `weight_pos` | `0 < weight n` |
| `weight_le_half` | `weight n ≤ 1/2` |
| `weight_strictAnti` | `weight` is strictly antitone |
| `transfer_nonneg` | `T` preserves pointwise non-negativity |
| `transfer_mono` | `T` is pointwise monotone |
| `transferIter_nonneg` | every iterate `T^k` preserves non-negativity |
| `totalWeight_two` | `totalWeight 2 = 5/6` |

There is no `sorry`, no `axiom`, and no `admit`.

## What is not formalised

- **A canonical source operator.** None exists in the archive, so there is
  nothing to formalise. O1 in the programme ledger is a proposed target.
- **Spectral theory.** The weighted shift is not proved bounded, compact,
  self-adjoint, or to have any prescribed spectrum.
- **A Hilbert–Pólya realisation.** O3 is a wider hope, not a source claim and
  not a theorem here.
- **The GHD threshold recursion.** The adjacent greedy-harmonic programme has
  its own results; this placeholder does not import or reprove them.
- **Correctness of the reconstruction.** T1–T7 validate consequences of the
  chosen definitions, not the choice of definition itself.

These limitations are deliberate: with an empty source, a larger formal file
would manufacture mathematics rather than reconstruct it.

[Back to the programme](../README.md) · [Topic index](../../README.md)
