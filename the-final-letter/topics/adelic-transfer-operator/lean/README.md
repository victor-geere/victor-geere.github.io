# Lean formal core — adelic transfer operator

## Build

```bash
cd the-final-letter/topics/adelic-transfer-operator
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

The wrapper calls the shared checker at `../../tools/check-lean.sh`, which elaborates `Topic.lean` against the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed `BUILD.log` records the last successful run.

## What is formalised

`Topic.lean` imports Mathlib and works in the namespace `Adelic`. It defines:

| Definition | Meaning |
|---|---|
| `Adelic.qdim p a` | `sin(π a / p) / sin(π / p)`, the quantum dimension in the `1 … p − 1` labelling (`a = 2j + 1`). |
| `Adelic.sEntry p a b` | `sqrt(2/p) sin(π a b / p)`, the `S`-matrix entry. |
| `Adelic.rtWeight p n` | `(p⁻¹)^n`, the local RT weight `p^{−n}`. |
| `Adelic.localDet x` | `(1 − x)⁻¹`, the scalar local Fredholm/Euler factor. |

It proves the following, with no `sorry`, `axiom`, or `admit`:

| Name | Statement |
|---|---|
| `Adelic.qdim_one` | `qdim p 1 = 1` (given `sin(π/p) ≠ 0`). |
| `Adelic.qdim_pos` | `0 < qdim p a` for `0 < a < p`. |
| `Adelic.sEntry_symm` | `sEntry p a b = sEntry p b a`. |
| `Adelic.sEntry_one_eq_mul_qdim` | `sEntry p 1 b = sEntry p 1 1 * qdim p b` (given `sin(π/p) ≠ 0`). |
| `Adelic.rtWeight_geom` | `∑_{k<N} p^{−k} = (p^{−N} − 1)/(p^{−1} − 1)` for `p ≠ 1`. |
| `Adelic.localDet_gt_one` | `1 < (1 − x)⁻¹` for `0 < x < 1`. |
| `Adelic.localDet_eq_tsum` | `(1 − x)⁻¹ = ∑' n, x^n` for `‖x‖ < 1`. |

These are elementary local facts: normalisation, positivity, symmetry, the identity-row/quantum-dimension identity used in the source's Verlinde reduction, a finite geometric identity, and the geometric-series expansion of the Euler factor.

## What is not formalised

The archived source is a thesis outline. The Lean file deliberately stops at the scalar local bookkeeping:

- No modular tensor category, fusion category, ribbon structure, or Reshetikhin–Turaev invariant is defined.
- No braid, framing, Seifert-fibred 3-manifold, or Gauss sum is constructed.
- No transfer operator `L_{p,s}` on `ℓ²(V(T_p))` is defined; there is no trace, nuclearity, or Fredholm determinant of an operator. `localDet` is only the scalar factor `(1 − x)⁻¹`.
- No restricted tensor product, strong operator convergence, or adelic Hilbert space is defined.
- No theta function, modular transformation, Ruelle pressure, variational principle, or zero-counting argument is formalised.
- The Riemann-hypothesis conclusion of the source is not formalised, and no part of this file asserts it.

The source's local RT theorem (`RT_{C_p}(β) = p^{−n}`), the local determinant identity (`det(1 − L_{p,s}) = (1 − p^{−s})⁻¹`), the global determinant identity, the functional equation, and the Ruelle exclusion argument are recorded as source claims or open items in the [programme README](../README.md). They are not Lean theorems here.

## Conventions and caveats

- The source labels objects by spins `j = 0, 1/2, …, (p−2)/2`; the Lean file uses `a = 2j + 1 ∈ {1, …, p − 1}`. The identity object is `a = 1`.
- The source's `S`-matrix formula is real and symmetric; `sEntry_symm` records the symmetry. The involution `S² = I` is checked exactly in the Python layer, not proved in Lean.
- The source claims `p^n + 1` periodic orbits of length `n`. This count is not formalised; it does not match the periodic points of the boundary map `z ↦ pz` as stated. See open item O9 in the programme README.

[Back to the programme](../README.md) · [Topic index](../../README.md)
