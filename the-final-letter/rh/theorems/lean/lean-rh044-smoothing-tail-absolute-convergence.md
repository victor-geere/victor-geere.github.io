# Absolute convergence of the tail for `σ > 1`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §4 "The radial decay of the term", lines 245–256

## Statement

> **Absolute convergence of the tail for `σ > 1`.** The `ℕ`-indexed series of the term moduli, `∑' n, ‖zetaTerm (σ : ℂ) (n + 1)‖`, is summable; the proof "compares it with the real `p`-series `∑ (n + 1)^{-σ}` via `abs_zetaTerm_ofReal` and `Real.summable_nat_rpow`".

```lean
theorem summable_norm_zetaTerm (σ : ℝ) (hσ : 1 < σ) :
    Summable (fun n : ℕ => ‖zetaTerm (σ : ℂ) (n + 1)‖)
```

## Hypotheses and notation

- `σ : ℝ` with the hypothesis `hσ : 1 < σ` — the abscissa beyond which the real `p`-series `∑ m^{-σ}` converges.
- The series is indexed by `n : ℕ` and sums the moduli of the terms at Dirichlet index `n + 1`; its first term is `‖zetaTerm (σ : ℂ) 1‖ = 1`, so the shift by one is what matches `Finset.Icc 1 N`.
- `Summable` is Mathlib's summability predicate for a series in `ℝ`; the corresponding Mathlib `p`-series statement is `Real.summable_nat_rpow (p := -σ)`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `summable_norm_zetaTerm` in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) (lines 249–256). The proof obtains `Summable (fun m : ℕ => (m : ℝ) ^ (-σ))` from `Real.summable_nat_rpow` using `1 < σ` (`linarith`), shifts it by one with `summable_nat_add_iff 1`, and identifies the summand with the term modulus by the `.symm` of `abs_zetaTerm_ofReal σ (by omega : 1 ≤ n + 1)`.
- No extra axiom and no computation by reflection (file header).

## Dependencies and related results

- [Radial decay `‖zetaTerm (σ + t·I) n‖ = n^{-σ}`](lean-rh044-smoothing-radial-decay.md) — the identification of the summand (via `abs_zetaTerm_ofReal`).
- Mathlib facts used: `Real.summable_nat_rpow`, `summable_nat_add_iff`.

## Notes

- This is the only summability / infinite-series statement in the file. The file header stresses that no infinite series enters the definitions: "No analytic continuation, no zeta function and no infinite series enter the definitions: everything is an ordinary finite sum over `ℂ`."
- The source states the comparison direction in the doc comment of the auxiliary comparison `norm_zetaTerm_le_rpow`: "For `n ≥ 1` the modulus of the term is at most `n^{-σ}`; for `σ > 1` these are the summable `p`-series terms."
