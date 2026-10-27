# Theorem 8 (algebraic independence at work)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; `#print axioms` = `[propext, Classical.choice, Quot.sound]`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §2 "The complex picture: `S_N(t) = 0` is a different question" (ledger row T10)

## Statement

> **Theorem 8 (algebraic independence at work).** For `N = 3`, `S_3(t) != 0` for every real `t`.

**PROVED** in Lean (`Rh43.zetaPartial_three_ne_zero`): writing `x = exp(-i t log 2)`, `y = exp(-i t log 3)`, the equation `1 + x + y = 0` forces `cos(t log 2) = cos(t log 3) = -1/2`, hence `3t log 2, 3t log 3` in `2 pi Z`; a nonzero solution then gives integers `n, m != 0` with `m log 2 = n log 3`, hence `3^{|n|} = 2^{|m|}`, which forces `3 | 2`. The audit reports only `propext, Classical.choice, Quot.sound`.

## Hypotheses and notation

- `t` real; `S_3(t) = 1 + 2^{-it} + 3^{-it} = 1 + x + y` with `x = exp(-i t log 2)`, `y = exp(-i t log 3)`.
- `!=` is the source's negation of equality; `|n|`, `|m|` are absolute values of the integers `n, m` produced by the reduction.

## Proof / evidence

- Lean declaration: `zetaPartial_three_ne_zero` in [`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean): `zetaPartial_three_ne_zero (t : ℝ) : zetaPartial 3 t ≠ 0`.
- The reduction is to `m log 2 = n log 3`, i.e. `3^{|n|} = 2^{|m|}`, which is impossible for nonzero `n, m`.
- The Lean README records the axiom audit: `#print axioms` over every theorem reports exactly `[propext, Classical.choice, Quot.sound]`.
- HANDOFF.md §2.4 records this as the second of "the three traps": "`S_2(π/log 2) = 0` exactly, while `S_3(t) ≠ 0` for *every* real `t`".

## Dependencies and related results

- Related: [S_2(pi/log 2) = 0 exactly](tpp-rh43-truths-s2-exact-vanishing.md) (T11); [Why the complex picture is not the question](tpp-rh43-truths-complex-picture-not-the-question.md) (Theorem 9); [Balance needs only the real equation](tpp-rh43-truths-balance-needs-only-real-equation.md) (T10).
- The blanket statement "the complex partial sum never vanishes for `N >= 2`" is refuted at `N = 2` (F4); the Lean declaration `not_forall_zetaPartial_ne_zero` records that refutation.

## Notes

- The source says the proof is by "algebraic independence at work", but the written argument given is the elementary reduction to `3^{|n|} = 2^{|m|}`; no appeal to a general independence theorem is made in the text.
