# The `N = 2` truncation is balanced at `t = π / log 2`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §6, lines 391–396

## Statement

> **`N = 2` is balanced at `t = π / log 2`.**

```lean
theorem balanced_two : balanced 2 (Real.pi / Real.log 2) :=
  (balanced_iff_realPartial_eq_zero 2 _).mpr realPartial_two_pi_div_log_two
```

and the source adds the plain existence form

```lean
theorem exists_balanced_two : ∃ t : ℝ, balanced 2 t := ⟨_, balanced_two⟩
```

At this point the positive and the negative parts are both non-trivial: `posRe = 1` (the summand `n = 1`) and `negRe = -1` (the summand `n = 2`).

## Hypotheses and notation

- `balanced N t := posRe N t = -negRe N t`; here `N = 2` and `t = π / log 2`.
- The point is the one where `realPartial 2 (π / log 2) = 0`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `balanced_two` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 392–393), obtained from [`realPartial 2 (π / log 2) = 0`](lean-rh43-balance-real-partial-two-vanishes-at-pi-log-two.md) via the accounting theorem `balanced_iff_realPartial_eq_zero`. `exists_balanced_two` (line 396) is the corollary discarding the witness and is not harvested separately.

## Dependencies and related results

- [`realPartial 2` vanishes at `t = π / log 2`](lean-rh43-balance-real-partial-two-vanishes-at-pi-log-two.md).
- [The positive and negative totals at `t = π / log 2`](lean-rh43-balance-pos-and-neg-totals-at-pi-over-log-two.md) — `posRe = 1`, `negRe = -1` at this point.
- [Main theorem: a balanced partial sum exists](lean-rh43-balance-balanced-partial-sum-exists.md).
- Harvested counterpart from the round's README: [`balanced_two` / `exists_balanced_two` — N = 2 is balanced at `π/log 2`](../tpp/tpp-rh43-lean-readme-balanced-two.md).

## Notes

- This does not contradict [the failure of balance at `N = 2`, `t = 0`](lean-rh43-balance-two-not-balanced-at-zero.md): the source stresses that the two statements concern different values of `t`.
