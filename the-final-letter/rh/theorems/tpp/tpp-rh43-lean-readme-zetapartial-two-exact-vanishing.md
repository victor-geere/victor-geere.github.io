# `zetaPartial_two_pi_div_log_two` — `S_2(π/log 2) = 0` exactly

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table row)

## Statement

> | theorem | statement |
> |---|---|
> | `zetaPartial_two`, `zetaPartial_two_pi_div_log_two` | `S_2(π/log 2) = 0` exactly |

with the definition of the complex partial sum, from the same file:

```lean
noncomputable def zetaPartial (N : ℕ) (t : ℝ) : ℂ :=
  ∑ k ∈ Finset.range N, Complex.exp (-(t : ℂ) * Complex.I * Real.log (k + 1))
-- i.e. the sum of n^{-it} for n = 1, …, N
```

## Hypotheses and notation

- `zetaPartial N t = ∑ k ∈ Finset.range N, Complex.exp (-(t : ℂ) * Complex.I * Real.log (k + 1))`, the sum of `n^{-it}` for `n = 1, …, N`.
- The statement is the exact complex vanishing `zetaPartial 2 (Real.pi / Real.log 2) = 0`.

## Proof / evidence

- **PROVED** in Lean: `zetaPartial_two`, `zetaPartial_two_pi_div_log_two` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- The file reports no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`; the axiom audit reports exactly `[propext, Classical.choice, Quot.sound]`.

## Dependencies and related results

- Counterpart in the truths harvest: [T11 — S_2(pi/log 2) = 0 exactly](tpp-rh43-truths-s2-exact-vanishing.md); refuted statement [F4](tpp-rh43-truths-f4-complex-never-vanishes-refuted.md) uses this as its witness.
- Related harvested Lean README file: [`N = 2` is balanced at `π/log 2`](tpp-rh43-lean-readme-balanced-two.md).
- Companion: [`zetaPartial_three_ne_zero` — the complex partial sum never vanishes at N = 3](tpp-rh43-lean-readme-zetapartial-three-ne-zero.md).

## Notes

- The same table lists `not_forall_zetaPartial_ne_zero`: the blanket "the complex partial sum never vanishes" is **false**, witness `N = 2`.
