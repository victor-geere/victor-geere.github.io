# The three traps of the round

**Kind:** Claim
**Status:** PROVED (all three components: the `N = 2` tangential zero and the `S_3` non-vanishing in Lean; the linear divergence by Euler summation)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.4 "The three traps"

## Statement

> 1. **The `N = 2` tangential zero.** `Re S_2 ≥ 0` with zeros at `(2k+1)π/log 2`. The first draft of both the script and the Lean file said "`N = 2` has no root"; the auditor's certified enclosure killed it. The corrected Lean now contains `realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`.
> 2. **The complex sum is a different question.** `S_2(π/log 2) = 0` exactly, while `S_3(t) ≠ 0` for *every* real `t` — proved in Lean (`zetaPartial_three_ne_zero`) by reducing to `m log 2 = n log 3`, i.e. `3^|n| = 2^|m|`. A blanket "the complex partial sum never vanishes" is false and was removed.
> 3. **The divergence is linear.** `|S_N(t)|/N → 1/√(1+t²)` (certified: `|S_{10^4}(1)| = 7071.771405`), so the series is not ordinarily summable at `Re(S) = 0` and the question is only well posed for finite `N`. The `√N` picture belongs to `Re(S) = 1/2`.

## Hypotheses and notation

- The three traps correspond to readings/warnings of the round: (1) the `N = 2` zero is tangential (`Re S_2 ≥ 0`, zeros at `(2k+1)π/log 2`); (2) the complex equation `S_N(t) = 0` is a different question; (3) the growth of `|S_N|` is linear with constant `1/√(1+t²)`.
- Certified instance: `|S_{10^4}(1)| = 7071.771405`.

## Proof / evidence

- Each trap is backed by the round's own evidence: Lean declarations (`realPartial_two_pi_div_log_two`, `balanced_two`, `exists_balanced_two`, `zetaPartial_three_ne_zero`) for (1) and (2); the certified value `|S_{10^4}(1)| = 7071.771405` for (3).
- The round's ledger records the components as **T4**, **T10/T11** and **T12**.

## Dependencies and related results

- Harvested component files: [N = 2 is balanced exactly at π/log 2](tpp-rh43-handoff-n2-tangential-zero.md), [The complex sum is a different question](tpp-rh43-handoff-complex-sum-different-question.md), [The divergence is linear](tpp-rh43-handoff-linear-divergence.md).
- Harvested truths counterparts: [T4](tpp-rh43-truths-n2-balanced-ledger.md), [T10](tpp-rh43-truths-s3-nonvanishing-ledger.md), [T11](tpp-rh43-truths-s2-exact-vanishing.md), [T12](tpp-rh43-truths-linear-divergence-ledger.md).

## Notes

- This entry is the source's own labelled summary of the three corrected/misleading points; each component is also harvested separately.
