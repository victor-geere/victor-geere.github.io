# Theorem 3.3 (the complex split is a different question)

**Kind:** Theorem
**Status:** PROVED (Lean: `zetaPartial_two_pi_div_log_two`, `zetaPartial_three_ne_zero`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §3 "The balance split at `Re(S) = 0` (rh43)", "Theorem 3.3 (the complex split is a different question)", line 88

## Statement

> **Theorem 3.3 (the complex split is a different question).**  `S_2(π/log 2) = 0`
> exactly, while `S_3(t) ≠ 0` for **every** real `t` (reduce to `m log 2 = n log 3`,
> i.e. `3^{|m|} = 2^{|n|}`).

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}` as in [Theorem 3.1](tpp-dict-04-balance-split-identity.md), but here `S_N` is treated as a **complex** value, not only its real part.
- `N = 2` case: `t = π/log 2`.
- `N = 3` case: for every real `t`; the reduction is to `m log 2 = n log 3`, equivalently `3^{|m|} = 2^{|n|}`.

## Proof / evidence

The source's status line, verbatim:

> *Status:* THEOREM (Lean: `zetaPartial_two_pi_div_log_two`,
> `zetaPartial_three_ne_zero`).

The two named Lean declarations are the evidence; the parenthetical reduction is the source's own indication of the `N = 3` argument.

## Dependencies and related results

- [Theorem 3.2 (attainability)](tpp-dict-04-attainability-of-balance.md) — the real-part balance question, contrasted here with the complex-value question.

## Notes

- Ledger entry for the **rh43** round (section headed "(rh43)").
- The theorem's content is exactly the contrast printed: the `N = 2` complex value vanishes at `t = π/log 2`, but no real `t` makes `S_3(t)` vanish.
