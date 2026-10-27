# Lean formal core — nested spheres and continuous cone

## Build

```bash
the-final-letter/topics/nested-spheres-continuous-cone/lean/check.sh
```

The shared checker elaborates `Topic.lean` against the local Mathlib
installation at `~/lean/mathlib4`. The committed `BUILD.log` records the last
successful run.

## What is proved

`Topic.lean` uses the namespace `NestedSpheres` and defines

- `fibreRadius N = 1 / N`, the radius of the `N`-th nested Hopf fibre;
- `meanZeroCoeff N m`, the coefficient `1 - N` when `N ∣ m` and `1` otherwise;
- `chord N = 2 sin (π / N)`, the edge length of the regular `N`-gon.

It proves:

| Name | Statement |
|---|---|
| `fibreRadius_pos` | `0 < fibreRadius N` for `N ≥ 1` |
| `fibreRadius_strictAnti` | `fibreRadius (N + 1) < fibreRadius N` for `N ≥ 1` |
| `fibreRadius_tendsto_zero` | `fibreRadius N → 0` |
| `meanZeroCoeff_self` | `meanZeroCoeff N N = 1 - N` |
| `meanZeroCoeff_period_sum` | `∑_{i=0}^{N-1} meanZeroCoeff N (i+1) = 0` |
| `chord_le_arc` | `chord N ≤ 2π / N` for `N ≥ 1` |
| `localDiagonal_integral` | `∫_{-1}^{1} (1 - R φ)(-φ) = -∫φ + R∫φ²` for interval-integrable `φ` |

Every declaration is complete; there is no unfinished proof and no new
axiom. `localDiagonal_integral` is the corrected local-diagonal identity:
the archived continuous-cone note asserted the constant `-1/2`, while the
canonical Lemma 6.3 gives the `R`-dependent expression above. The Lean
statement makes the correction explicit.

## What is not formalised

- The infinite purification identity `∑ c_m(N) m^{-s} = (1 - N^{1-s}) ζ(s)`
  and its meromorphic continuation. Only the exact one-period mean-zero sum
  is formalised here.
- The uniform-in-height Hausdorff estimate of Lemma 3.2; `chord_le_arc`
  proves the per-edge `O(1/N)` chord bound, not the full geometric comparison.
- The filtration of measures, Prokhorov tightness, residual mass bounds and
  the pure-point limit theorem. These rely on analytic number theory and
  measure theory far beyond the elementary core.
- The withdrawn continuous-cone differential inequality and its `c₁ = 1/2`
  drift term. The local diagonal is formalised only as the corrected integral
  identity; no differential inequality is derived from it.
- The Riemann hypothesis. Neither archived note is accepted as a proof, and
  nothing in this file asserts it.

These items are recorded as source claims or open items in the programme
dossier.

[Back to the programme](../README.md) · [Topic index](../../README.md)
