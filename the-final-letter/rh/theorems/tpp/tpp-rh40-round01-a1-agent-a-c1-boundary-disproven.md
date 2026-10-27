# A1 — C1 boundary L_max = 1 + min(min_j d_j, min_j(d_j+d_{j+1}))

**Kind:** Claim
**Status:** REFUTED (on 6 000–17 375 sampled eligible words the rule fails *inside* its own claimed range and is too early elsewhere)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) — §2.2 "From Agent A", verdict-table row A1; the test is §3.2

## Statement

> C1 boundary `L_max = 1 + min(min_j d_j, min_j(d_j+d_{j+1}))`

## Hypotheses and notation

- C1 is the law `p(L) = L + 1`; `L_max` is its claimed largest valid `L`.
- `d_j` are the consecutive gaps of the support; "eligible" means `N ≥ 2a_m + 3` (the §3.2 test table).

## Proof / evidence

The verdict-table row's verdict reads: "**DISPROVEN**"; its mediator check reads: "on 6 000–17 375 sampled eligible words the rule fails *inside* its own claimed range and is too early elsewhere; see §3.2". §3.2's table gives: eligible words sampled 6 000 – 17 375; "violations of C1 *inside* `[1, L_max]` **4 903 / 17 375**"; "cases where C1 still holds at `L_max + 1` (rule too early) **449 / 17 375**"; "the four dialogue words exact, as A claimed".

## Dependencies and related results

- Register rows F1 (Theorem D), F2, F3, F4, J13 of [`truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md); row A2 of the same table; ledger error rows 11 and 12.

## Notes

- The rule remains exactly correct on the four dialogue words — the source calls that "itself a useful clue: the boundary depends on more than `min_j d_j` and `min_j(d_j + d_{j+1})`".
