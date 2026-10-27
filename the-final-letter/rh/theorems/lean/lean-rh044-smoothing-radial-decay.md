# Radial decay

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §4 "The radial decay of the term", lines 210–262

## Statement

> **Radial decay.** For `n ≥ 1` the modulus of the `n`-th term depends only on the real part `σ` of `s = σ + t·I`, and equals exactly `n^{-σ}`: `‖zetaTerm (σ + t·I) n‖ = (n : ℝ) ^ (-σ)`.

```lean
theorem abs_zetaTerm (σ t : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖zetaTerm ((σ : ℂ) + (t : ℂ) * Complex.I) n‖ = (n : ℝ) ^ (-σ)
```

The file carries the same content in the following specialised / equivalent forms, folded into this file (see Notes):

```lean
theorem abs_zetaTerm_ofReal (σ : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖zetaTerm (σ : ℂ) n‖ = (n : ℝ) ^ (-σ)          -- the case t = 0

theorem norm_zetaTerm_le_rpow (σ : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖zetaTerm ((σ : ℂ)) n‖ ≤ (n : ℝ) ^ (-σ)         -- "Explicit comparison with the p-series"

theorem abs_cpow_neg_eq (σ t : ℝ) {n : ℕ} (hn : 1 ≤ n) :
    ‖(n : ℂ) ^ (-(((σ : ℂ) + (t : ℂ) * Complex.I)))‖ = (n : ℝ) ^ (-σ)
```

## Hypotheses and notation

- `σ t : ℝ`, with `s = σ + t·I` written `(σ : ℂ) + (t : ℂ) * Complex.I`.
- `n : ℕ` with `hn : 1 ≤ n`; `(n : ℝ) ^ (-σ)` is the real power (`Real.rpow`) of the positive base `n ≥ 1`. (`Real.rpow_neg` and `Real.rpow_def_of_pos` are applied under `hn : 0 < n`.)
- `‖·‖` is the complex norm; `Complex.norm_exp` reduces `‖exp z‖` to `Real.exp z.re`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`, all in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) §4; no extra axiom and no computation by reflection.
  - `abs_zetaTerm` (lines 215–231): the real part of `-((σ + t·I) · log n)` is computed to be `-(σ · log n)`, and the goal is closed with `Complex.norm_exp`, `Real.exp_neg`, `Real.rpow_neg` and `Real.rpow_def_of_pos`.
  - `abs_zetaTerm_ofReal` (lines 234–237): the case `t = 0`, obtained by `simpa` from `abs_zetaTerm σ 0 hn`.
  - `norm_zetaTerm_le_rpow` (lines 241–243): `le_of_eq` of `abs_zetaTerm_ofReal`.
  - `abs_cpow_neg_eq` (lines 260–262): the same equality for the principal-branch power `(n : ℂ) ^ (-s)`, transferred by `zetaTerm_eq`.

## Dependencies and related results

- [The term is the principal-branch power](lean-rh044-smoothing-zeta-term-principal-branch-power.md) — used by `abs_cpow_neg_eq`.
- [Absolute convergence of the tail for `σ > 1`](lean-rh044-smoothing-tail-absolute-convergence.md) — compares the term moduli with the real `p`-series using `abs_zetaTerm_ofReal`.
- Mathlib facts used: `Complex.norm_exp`, `Real.exp_neg`, `Real.rpow_neg`, `Real.rpow_def_of_pos`.

## Notes

- The file header stresses that `‖zetaTerm (σ + t·I) n‖` "depends only on the real part `σ`" — the decay is radial, independent of `t`.
- `abs_zetaTerm_ofReal`, `norm_zetaTerm_le_rpow` and `abs_cpow_neg_eq` are folded into this one file because they are the same equality in the case `t = 0`, the same comparison weakened to `≤`, and the same statement transported across `zetaTerm_eq`. The source labels `norm_zetaTerm_le_rpow` "**Explicit comparison with the `p`-series**" and uses it for the tail summability.
- The source calls `n^{-σ}` "the exact radial decay"; the equality, not merely a bound, is what the file proves.
