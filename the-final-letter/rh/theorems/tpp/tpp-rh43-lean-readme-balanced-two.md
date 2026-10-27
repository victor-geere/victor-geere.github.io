# `balanced_two` / `exists_balanced_two` — N = 2 is balanced at `π/log 2`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table rows)

## Statement

> | theorem | statement |
> |---|---|
> | `realPartial_two`, `realPartial_two_pi_div_log_two` | `realPartial 2 t = 1 + cos (t log 2)`, and it vanishes at `π/log 2` |
> | `balanced_two`, `exists_balanced_two` | `N = 2` is balanced at `π/log 2` (the *tangential* zero; a sign-change search misses it) |
> | `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two` | at that point the positive part is `1` (index `1`) and the negative part is `-1` (index `2`): both parts are non-degenerate |

## Hypotheses and notation

- `realPartial 2 t = 1 + cos (t log 2)`; at `t = π/log 2` this is `1 + cos π = 0`.
- `balanced_two` is the balance `posRe 2 (π/log 2) = -negRe 2 (π/log 2)`; `exists_balanced_two` is the existential `∃ t, balanced 2 t`.
- At the balance point the positive part is `1` (term index `1`) and the negative part is `-1` (term index `2`), so both parts are non-degenerate.
- The zero is *tangential*: a sign-change search misses it.

## Proof / evidence

- **PROVED** in Lean: `realPartial_two`, `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`, `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- The README notes the corresponding refutation declaration `not_balanced_two_zero` (only that `t = 0` is unbalanced at `N = 2`).

## Dependencies and related results

- Counterpart in the truths harvest: [Theorem 3 (N = 2 is balanced)](tpp-rh43-truths-n2-balanced-tangential.md), ledger row [T4](tpp-rh43-truths-n2-balanced-ledger.md).
- Related harvested Lean README file: [`zetaPartial_two` / `zetaPartial_two_pi_div_log_two` — the exact complex vanishing](tpp-rh43-lean-readme-zetapartial-two-exact-vanishing.md).

## Notes

- The README stresses that `not_balanced_two_zero` "does **not** say `N = 2` is never balanced — see `balanced_two`".
