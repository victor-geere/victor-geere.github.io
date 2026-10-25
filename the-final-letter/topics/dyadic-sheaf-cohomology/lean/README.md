# Lean formal core — dyadic sheaf cohomology

## Build

```bash
the-final-letter/topics/dyadic-sheaf-cohomology/lean/check.sh
```

The wrapper calls the shared `../../tools/check-lean.sh`, which elaborates
`Topic.lean` against the local Mathlib installation (Lean `v4.35.0-rc2`,
Mathlib at `~/lean/mathlib4`). The committed [`BUILD.log`](BUILD.log)
records the last successful check.

## What is proved

`Topic.lean` works in the namespace `DyadicSheaf` and defines

- `dyadicRadius k = (1/2 : ℝ) ^ k`, the radius of the source's dyadic
  ball `U_v^(k) = {2^{-k} ≤ |x| < 2^{-k+1}}`;
- `energy t x = (1 - cos(2πt/x))² + (1 - cos(2πx))²`, the source's
  alignment energy.

It proves seven facts:

| Name | Statement |
|---|---|
| `dyadicRadius_pos` | `0 < dyadicRadius k` |
| `dyadicRadius_succ` | `dyadicRadius (k+1) = dyadicRadius k / 2` |
| `dyadicRadius_strictAnti` | `dyadicRadius` is strictly antitone |
| `dyadicRadius_tendsto_zero` | `dyadicRadius k → 0` as `k → ∞` |
| `energy_nonneg` | `0 ≤ energy t x` |
| `energy_eq_zero_iff` | `energy t x = 0 ↔ cos(2πt/x) = 1 ∧ cos(2πx) = 1` |
| `energy_vanishes_of_dvd` | for `x ≥ 1`, `x ∣ p ⇒ energy p x = 0` |

The last one is the forward direction of the source's divisor-detection
identity. There is no `sorry`, no `axiom`, and no `admit`.

## What is not formalised

The source's cohomological content is not in this file, because the
source does not define it precisely enough to state a theorem:

- the site (open subsets of `A_Q^×`), the sheaves `F₀` and `F₁`, and
  their restriction maps;
- the conjectural differential `d`, in either the root-of-unity form or
  the idele-class Haar-integral form (the source itself calls these
  ill-defined);
- the anti-involution `τ` and the assertion `τ² = id ⇔ Re(s) = 1/2`;
- the vanishing of `H¹` off the critical line and its one-dimensionality
  at zeros;
- the identification of a regularised Euler characteristic with `ξ(s)`;
- the implication from any cohomological statement to the Riemann
  hypothesis.

Those are recorded as source claims or open items in the
[programme README](../README.md). The finite symmetry
`energy t x = energy t (t/x)` is proved in Lean as `energy_symm` (T8)
and checked in the Python layer (test C8); the Lean file also proves the
forward divisor-detection direction and the elementary energy algebra.

## Note on scope

This is a genuine but small formal core. It formalises the only part of
the source that is a definition rather than a speculation: the dyadic
filtration and the alignment energy. It does not pretend that the dyadic
sheaf complex, its `H¹`, or the RH bridge have been formalised.

[Back to the programme](../README.md) · [Topic index](../../README.md)
