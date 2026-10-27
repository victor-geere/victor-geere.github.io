# Lean formal core — frozen truths

## Build

```bash
the-final-letter/topics/frozen-truths/lean/check.sh
```

The script uses the shared local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`) through [`../../tools/check-lean.sh`](../../tools/check-lean.sh). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is defined

`Topic.lean` opens `namespace FrozenTruths` and defines:

- `lastChord N s = ((1 - N) / 2) * N ^ (-(2 * s))` — the unmatched last-chord boundary term \(H_N(s)\);
- `lastChordSquare N = (N - 1) ^ 2 / (4 * N ^ 2)` — the constant pairing value \(Q_N\).

## What is proved

| Name | Statement | Source |
|---|---|---|
| `lastChord_mul_twin` | `H_N(s) * H_N(1 - s) = Q_N` for `0 < N`. | 11.1, 14.1 |
| `lastChord_abs` | `|H_N(s)| = ((N-1)/2) * N^(-2s)` for `1 < N`. | 2.8, 11.2 |
| `lastChord_twin_abs_eq_iff` | `|H_N(s)| = |H_N(1-s)| ↔ s = 1/2` for `1 < N`. | 11.2, 14.4 |
| `lastChord_limit` | `Q_N → 1/4` as `N → ∞`. | 11.1 |
| `exp_neg_abs_log_ratio` | `exp(-|log(m/n)|) = min m n / max m n` for `0 < m`, `0 < n`. | 1.14 |
| `cosh_weight_gt_one` | `α ≠ 0` and `0 < u` imply `1 < cosh(α u)`. | 12.3, 13.3 |
| `cosh_weight_even` | `cosh(α u) = cosh((-α) u)`. | 12.3 |

No `sorry`, no `axiom`, no `admit`, and no vacuous `rfl`-only declaration. `lastChord_mul_twin` is the genuine monomial identity behind the "last-chord product"; `lastChord_twin_abs_eq_iff` uses strict monotonicity of `N ↦ N^x` for `N > 1` to prove that the self-dual abscissa is unique.

## What is not formalised

The source's analytic content is not in this file. In particular:

- the uniform Euler–Maclaurin expansion 3.2 and the floor 4.4;
- two-sided tracking 11.3, the product-at-twins limit 11.4, the dichotomy 11.5, and the north/south lift 11.6;
- Riemann's \(\Phi\), the cosine representation 12.1, and the non-vanishing \(K(\alpha,\gamma)\neq0\) for \(\alpha\neq0\);
- the mean-value identities of §6, the Rouché count of §10, and the Jensen/Li tower of §15;
- the Riemann hypothesis and all other RH-equivalent statements.

These are recorded as source claims or open items in the [programme dossier](../README.md). The Lean core is intentionally the elementary algebraic layer that the source's §11 uses; it is not a formalisation of the programme's analytic estimates.

[Back to the programme](../README.md) · [Topic index](../../README.md)
