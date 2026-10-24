# Key exact identity (weight defect)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §2 "The exact weighted decomposition", lines 117–127

## Statement

> **Key exact identity (weight defect).** The sharp sum and the smoothed sum differ term by term by the defect `1 - φ (n/N)`: `zetaSum N s - smoothedSum N φ s = ∑_{n≤N} (1 - φ (n/N)) · zetaTerm s n`. Pure algebra; no estimate is involved.

```lean
theorem weighted_decomposition (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) :
    zetaSum N s - smoothedSum N φ s
      = ∑ n ∈ Finset.Icc 1 N, (((1 - φ ((n : ℝ) / N) : ℝ)) : ℂ) * zetaTerm s n
```

where the two sums are defined in the same file (lines 75–81) by

```lean
noncomputable def zetaSum (N : ℕ) (s : ℂ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 N, zetaTerm s n

noncomputable def smoothedSum (N : ℕ) (φ : ℝ → ℝ) (s : ℂ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 N, ((φ ((n : ℝ) / N) : ℝ) : ℂ) * zetaTerm s n
```

## Hypotheses and notation

- `N : ℕ` — the cutoff; the index range is `Finset.Icc 1 N`, which is empty (sum `0`) when `N = 0`, and the summand `n = 1` is always present for `N ≥ 1`.
- `φ : ℝ → ℝ` — an arbitrary weight, sampled at the normalised abscissae `n/N`.
- `s : ℂ` — arbitrary complex argument.
- `zetaSum N s = ∑_{n=1}^{N} zetaTerm s n` is the sharp (cutoff) sum; `smoothedSum N φ s = ∑_{n=1}^{N} φ (n/N) · zetaTerm s n` is the smoothed sum.
- The "weight defect" is `1 - φ (n/N)`, cast from `ℝ` to `ℂ` inside the sum.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `weighted_decomposition` in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) (lines 121–127). The file describes it as "pure algebra (no estimates)": the proof unfolds both sums, applies `Finset.sum_sub_distrib`, and closes each summand under `Finset.sum_congr rfl` with `push_cast` and `ring_nf`.
- No `sorry`, no extra axiom, no computation by reflection (file header).

## Dependencies and related results

- The definitions `zetaTerm`, `zetaSum`, `smoothedSum` of the same file (lines 71–81).
- [Two-weight triangle bound](lean-rh044-smoothing-two-weight-triangle-bound.md) and [The error bound with the radial decay substituted](lean-rh044-smoothing-error-bound-rpow.md) — the norm bounds obtained from this identity via the triangle inequality.
- The source also proves the degenerate-weight lemmas `smoothedSum_one` (lines 129–134: `φ ≡ 1` recovers the sharp sum) and `smoothedSum_zero_of_weight_eq_zero` (lines 136–144: a weight vanishing on `Finset.Icc 1 N` forces `smoothedSum N φ s = 0`), and combines the latter with this identity in `zetaSum_eq_sum_defect_of_weight_eq_zero` (lines 146–153).

## Notes

- The file header calls this "the *key exact identity*" and the bridge "between the sharp and the smoothed truncation".
- The degenerate-weight declarations `smoothedSum_one`, `smoothedSum_zero_of_weight_eq_zero` and `zetaSum_eq_sum_defect_of_weight_eq_zero` are recorded here as specialisations/side lemmas rather than as separate harvested files: they are `_one` / `_zero` degenerate cases whose content is contained in this identity. The source reads the vanishing-weight case as "the trivial obstruction that has to be excluded for the numerics to mean anything".
- The identity is exact: no estimate, no analytic continuation, no zeta function and no infinite series enter it — "everything is an ordinary finite sum over `ℂ`".
