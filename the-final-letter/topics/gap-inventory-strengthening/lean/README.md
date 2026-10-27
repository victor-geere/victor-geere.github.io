# Lean formal core — gap inventory

## Build

```bash
the-final-letter/topics/gap-inventory-strengthening/lean/check.sh
```

The script uses the shared local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). It elaborates `Topic.lean` and writes `Topic.olean` beside it; `BUILD.log` records the last successful run.

## What is proved

`Topic.lean` imports `Mathlib` and opens the namespace `GapInventory`. It defines

- `chord N s = ((1 − N)/2) · N^(−2s)`;
- `north N δ = N^(−2δ)` and `south N δ = N^(2δ)`;
- `chordClosed N = (N − 1)²/(4N²)`.

It proves seven declarations:

| Name | Statement |
|---|---|
| `chord_product` | `chord N s * chord N (1 − s) = chordClosed N` for `0 < N` |
| `chord_one` | `chord 1 s = 0` |
| `chord_half` | `chord N (1/2) = (1 − N)/(2N)` for `0 < N` |
| `chord_product_pos` | `0 < chordClosed N` for `1 < N` |
| `chord_product_quarter` | `chordClosed N = 1/4 − 1/(2N) + 1/(4N²)` for `0 < N` |
| `chord_product_tendsto` | `chordClosed N → 1/4` as `N → ∞` |
| `pole_dichotomy` | for `1 < N`, `δ > 0`: `north N δ * south N δ = 1`, `north N δ < 1`, `1 < south N δ` |

There is **no `sorry`, no `axiom`, and no `admit`**. The first and last theorems carry the mathematical content: the product identity requires `Real.rpow_add` and the exact evaluation of `N^(−2)`, while the dichotomy combines the exponent law with `Real.one_lt_rpow` and the strict inverse bound.

## What is not formalised

`gaps.html` is a checklist. Its substantive statements are about the paper's depth-one finite Euler sums `η_N^{(N²)}`, the completed `ξ`, the measures `μ_N`, `ν_N`, Lindelöf-type estimates, Jensen counts, and Rouché disks. None of those objects is defined in this file, and none of the following is a Lean theorem here:

- the closed-item rows A–P8, L₀, T;
- Identity L (speed/jet bound), L<sub>m</sub>, L<sub>band</sub>;
- the tail closure T (Lemmas 9.2–9.6);
- Addendum C (DH sharpness, Corollary C.10), Addendum D (mod `p`), Addendum E (holonomy), Addendum F (placement);
- Lemma F.8, Corollary F.9, Lemma F.10;
- the refined quadratic asymptotic of Addendum A;
- the tracking statement `η_N^{(N²)}(ρ) η_N^{(N²)}(1 − ρ) → 1/4` on the tightness window;
- the remaining slice `K(α,γ) ≠ 0` for `α ≠ 0`, `γ ≠ 0`, and Open item F.4.

The step from `chord_product` to the tracking statement is exactly the analytic input the source does not supply in `gaps.html`. The formal core is deliberately the algebraic skeleton, not the gap.

## Why this is the right size

The source offers no self-contained theorem beyond the last-chord monomial identity; its "closed" rows are pointers into `publication.html`. Formalising any of them would mean rebuilding the paper's `η_N`, measures, and asymptotics, which is outside both the source text and this reconstruction. The seven declarations above are the elementary facts the source actually writes out and uses, and they are proved rather than restated.

[Back to the programme](../README.md) · [Topic index](../../README.md)
