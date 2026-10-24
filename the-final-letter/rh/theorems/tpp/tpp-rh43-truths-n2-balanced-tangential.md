# Theorem 3 (N = 2 is balanced, exactly, at `t = pi/log 2`)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`); VERIFIED (numerical, 74-digit certified enclosures)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §1.1 "The small cases" (ledger row T4)

## Statement

> **Theorem 3 (N = 2 is balanced, exactly, at `t = pi/log 2`).**
>
> ```
> S_2(pi/log 2) = 1 + exp(-i pi) = 0          (exactly)
> Re S_2(pi/log 2) = 1 + cos(pi) = 0
> P_2 = 1  (the term n = 1),   M_2 = -1  (the term n = 2)
> ```
>
> The zero is **tangential**: `Re S_2(t) = 1 + cos(t log 2) >= 0`, with equality exactly at `t = (2k+1) pi/log 2`, so a search for a *sign change* misses it. This is why `N = 2` is the trap of this round (see §3.1).

## Hypotheses and notation

- `t` real; `S_2(t) = 1 + 2^{-it} = 1 + exp(-i t log 2)`, `Re S_2(t) = 1 + cos(t log 2)`.
- `k` ranges over the integers; the equality `Re S_2(t) = 0` holds exactly at `t = (2k+1) pi/log 2`.
- `S_2(pi/log 2) = 0` is an exact *complex* vanishing, not only a real-part vanishing.

## Proof / evidence

- **PROVED** in Lean ([`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean)): `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`, `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two`, `zetaPartial_two_pi_div_log_two`.
- **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §2 "with 74-digit certified enclosures by the auditor".
- The smallest zero is quoted in the refutation table (F2) as `pi/log 2 = 4.5323601418271938096276829457166668` (74-digit certified).

## Dependencies and related results

- Related: [N = 1 is degenerate](tpp-rh43-truths-n1-degenerate.md) (T3); [Theorem 4 (existence at N = 3)](tpp-rh43-truths-n3-existence-ivt.md) (T5); [S_2(pi/log 2) = 0 exactly](tpp-rh43-truths-s2-exact-vanishing.md) (T11).
- This result killed the round's first claim "the split can be balanced **iff** `N >= 3`" (refuted statement F1) and "`N = 2` has no root of `Re S_2`" (F2).
- The Lean theorem `not_balanced_two_zero` records only that `t = 0` is unbalanced at `N = 2`; it does **not** say `N = 2` is never balanced.

## Notes

- The source records that the first draft of both the script and the Lean file claimed "no root for `N = 2`"; the auditor's certified enclosure killed it, and the corrected Lean now contains `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`. The corrections are recorded rather than deleted (truths.md §5, HANDOFF.md §2.4/§5).
