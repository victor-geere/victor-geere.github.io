# F7 — "a balance point implies the *terms* can be split two-and-two"

**Kind:** Claim
**Status:** REFUTED (witness `N = 6`, `t = 1.3625080873…`, exact subset-sum defect `0.169962576…`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §5 "The referee's corner: falsified statements of this round"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | F7 | "a balance point implies the *terms* can be split two-and-two" | false at the certified roots: `N = 6`, `t = 1.3625080873…`, the positive terms miss `P/2` by an exact subset-sum defect of `0.169962576…` (the term `cos(t log 1) = 1` can never be in a half while `P < 2`). The numeric pieces `P/2, M/2` are equal; the term-level partition is not. |

## Hypotheses and notation

- The falsified implication: balance (`P = |M|`) implies the *term-level* two-and-two partition (the positive terms partition into two subsets of equal sum, likewise the negative terms).
- Witness: `N = 6`, `t = 1.3625080873…` (the certified smallest positive root, 47-digit bracket `[1.36250808733474170983, +8.76e-47]`); exact subset-sum defect of the positive side `0.169962576…`.
- Structural cause: `cos(t log 1) = 1` can never lie in a half while `P < 2`.

## Proof / evidence

- Ledger row F7: status "**REFUTED**", evidence "§5, with witnesses".
- The full statement of the failure is [Theorem 11′](tpp-rh43-truths-term-level-split-fails.md) (T9′), **VERIFIED** exactly by exhaustive subset-sum at the certified roots.
- HANDOFF.md §5 banks the correction: "'the terms split two-and-two at a balance point' — **false** at the certified roots; the term `cos(t log 1) = 1` can never lie in a half while `P < 2` (`N = 6`: exact defect `0.16996…`)."

## Dependencies and related results

- Related: [Theorem 11′ (the term-level split fails)](tpp-rh43-truths-term-level-split-fails.md); [Theorem 11 (the numeric split is exact)](tpp-rh43-truths-numeric-split-exact.md) (T9).

## Notes

- The source records this as one of the six corrections banked in HANDOFF.md §5, to be contrasted with T9 (numeric pieces `P/2, M/2` are equal).
