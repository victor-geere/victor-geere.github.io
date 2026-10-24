# Lean formal core — periodic orbits on Bruhat–Tits trees

## Build

```bash
cd the-final-letter/topics/periodic-orbits
./lean/check.sh
```

The wrapper calls the shared `../../tools/check-lean.sh`, which elaborates
`Topic.lean` against the local Mathlib installation at `~/lean/mathlib4`
(Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last
successful check.

## What is proved

`Topic.lean` defines

- `PeriodicOrbits.qdim p r = sin(π r / p) / sin(π / p)`, the quantum
  dimension of the label `r = 2j + 1` in `SU(2)_{p-2}`;
- `PeriodicOrbits.Smat p r r' = sqrt(2/p) * sin(π r r' / p)`, the modular
  `S`-matrix;
- `PeriodicOrbits.Dsq p = p / (2 * sin²(π/p))`, the squared total quantum
  dimension;
- `PeriodicOrbits.rtWeight p n = p^{-n}`, the local RT weight;
- `PeriodicOrbits.writhe w = w.sum`, the writhe of a braid word encoded as a
  list of signed generator exponents.

It proves seven theorems:

| Name | Statement |
|---|---|
| `qdim_pos` | `0 < r < p → 0 < qdim p r` |
| `qdim_symm` | `r ≤ p → qdim p r = qdim p (p - r)` |
| `smat_one` | `1 < p → Smat p 1 r = sqrt(2/p) * sin(π/p) * qdim p r` |
| `Dsq_pos` | `1 < p → 0 < Dsq p` |
| `rtWeight_pos` | `0 < p → 0 < rtWeight p n` |
| `geom_rtWeight` | `Σ_{n<N} p^{-n} = (1 - p^{-N}) / (1 - p^{-1})` for `p > 1` |
| `fullTwist_writhe_pos` | `2 ≤ n → 0 < writhe (replicate (n(n-1)) 1)` |

No `sorry`, no `axiom`, no `admit`.

## What is not formalised, and why

The source is not merely incomplete: it contradicts itself. `3_1.tex` states
`RT_{C_p}(β) = p^{-n}` as a theorem, `3_2.tex` retracts it to an open
conjecture after finding that the weighted Gauss sum `G_p` differs from
`τ_p = e^{iπ/4}p^{-1/2}`, and the later repair sections (`3_2b`, `3_3`,
`3_4`, `3_4a–c`) re-assert it using the column `ℓ = (p-1)/2`. That column
is identically zero because `2ℓ + 1 = p`, so `S_{jℓ} = sin(π(2j+1)) = 0`.
The bundled `verify.py` simply returns `p**(-n)` and compares it with itself.
There is therefore no valid proof of the local identity to formalise.

Not formalised here:

- the Bruhat–Tits tree, the shift `σ_p`, and the orbit-to-braid construction
  (`2_1.tex` gives examples but no general algorithm);
- the Reshetikhin–Turaev invariant and its Verlinde/Kirby–Melvin reduction;
- the claimed Seifert fibration and its invariants;
- the local identity `RT = p^{-n}`;
- the global adelic transfer operator, its spectral reality, and the
  identification of its spectrum with the zeros of `ζ` (RH).

These are recorded as **Source claim** or **Open / conjecture** in the
programme dossier. The Lean theorems above are the finite modular-data and
bookkeeping facts that any genuine repair would still need.

## Relationship to the Python layer

The Python tests check the same finite facts (and the falsification
computations C3–C4) exactly or at a stated high-precision tolerance. The
Lean file proves the order/positivity/symmetry core unconditionally; the
Python layer computes the `S`-matrix, the Gauss sums, the Möbius counts,
and the writhe bookkeeping.

[Back to the programme](../README.md) · [Topic index](../../README.md)
