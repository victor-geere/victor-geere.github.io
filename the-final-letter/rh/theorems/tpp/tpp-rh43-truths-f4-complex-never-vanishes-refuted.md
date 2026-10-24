# F4 — "the complex partial sum never vanishes for N >= 2"

**Kind:** Claim
**Status:** REFUTED (smallest witness `N = 2`, `t = pi/log 2`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §5 "The referee's corner: falsified statements of this round"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | F4 | "the complex partial sum never vanishes for `N >= 2`" | `N = 2`, `t = pi/log 2`: `S_2 = 1 + e^{-i pi} = 0` exactly. |

## Hypotheses and notation

- The falsified claim: `S_N(t) != 0` for every `N >= 2` and every real `t`.
- Witness: `N = 2`, `t = pi/log 2`, where `S_2(t) = 1 + exp(-i pi) = 0` exactly.

## Proof / evidence

- Ledger row F4: status "**REFUTED**", evidence "§5, with witnesses".
- Witness proved in Lean as `zetaPartial_two_pi_div_log_two`; the refutation is formalised in Lean as `not_forall_zetaPartial_ne_zero`.
- HANDOFF.md §5 banks the correction: "'the complex partial sum never vanishes for `N ≥ 2`' — false at `N = 2`; and 'it vanishes for `N = 3`' is also false, provably (F4, T10/T11)."

## Dependencies and related results

- Related: [S_2(pi/log 2) = 0 exactly](tpp-rh43-truths-s2-exact-vanishing.md) (T11); [S_3(t) != 0](tpp-rh43-truths-s3-nonvanishing.md) (T10/Theorem 8).

## Notes

- The refutation cuts both ways in the source's record: the blanket non-vanishing is false at `N = 2`, while vanishing at `N = 3` is provably false.
