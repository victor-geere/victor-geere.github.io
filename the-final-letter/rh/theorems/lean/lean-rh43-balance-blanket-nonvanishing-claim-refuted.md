# The blanket non-vanishing claim for the complex partial sums is false

**Kind:** Theorem
**Status:** PROVED (Lean, machine-checked counterexample; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §7, lines 457–461

## Statement

> **The blanket non-vanishing claim is false**, with the `N = 2` witness.

```lean
theorem not_forall_zetaPartial_ne_zero :
    ¬ ∀ (N : ℕ) (t : ℝ), 0 < N → zetaPartial N t ≠ 0
```

i.e. it is not the case that every non-empty truncation `zetaPartial N t` of the zeta Dirichlet series on the critical line is non-zero.

## Hypotheses and notation

- `zetaPartial N t = ∑_{k<N} (k+1)^{-it} = ∑_{k<N} exp(-i t log (k+1))`.
- The quantified claim being refuted is `∀ (N : ℕ) (t : ℝ), 0 < N → zetaPartial N t ≠ 0`.
- The witness is `N = 2`, `t = π / log 2`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `not_forall_zetaPartial_ne_zero` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 458–461). It applies the hypothetical blanket statement to `N = 2` and `t = π / log 2` (`0 < 2` by `norm_num`) and contradicts [`zetaPartial 2 (π / log 2) = 0`](lean-rh43-balance-zeta-partial-two-vanishes-at-pi-log-two.md).

## Dependencies and related results

- [The complex partial sum vanishes at `N = 2`, `t = π / log 2`](lean-rh43-balance-zeta-partial-two-vanishes-at-pi-log-two.md).
- [The `N = 3` truncation never vanishes](lean-rh43-balance-zeta-partial-three-never-vanishes.md) — the surviving positive statement about a single `N`.
- Harvested counterpart from the round's README: [`zetaPartial_two_pi_div_log_two` — `S_2(π/log 2) = 0` exactly](../tpp/tpp-rh43-lean-readme-zetapartial-two-exact-vanishing.md).

## Notes

- This is a refutation of a quantified claim, not of any single-`N` statement; the source notes that nothing is claimed for `N ≥ 4`, which remains open here.
