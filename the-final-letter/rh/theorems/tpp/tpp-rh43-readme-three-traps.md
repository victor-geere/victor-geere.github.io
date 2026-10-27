# Three traps are part of the answer

**Kind:** Claim
**Status:** PROVED (all three components: the `N = 2` tangential zero and the `S_3` non-vanishing in Lean; the divergence by Euler summation)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/README.md`](../../research/twin-prime-parity/rounds/rh43/README.md) — "Three traps are part of the answer and are recorded, not hidden"

## Statement

> Three traps are part of the answer and are recorded, not hidden: the `N = 2` zero is **tangential** (a sign-change scan misses it); the *complex* partial sum is a different question (`S_2(π/log 2) = 0` exactly, while `S_3(t) ≠ 0` for **every** `t`, proved in Lean); and the infinite series does **not** converge in the ordinary sense at `Re(S) = 0` — `|S_N(t)| ~ N/√(1+t²)` grows **linearly**, so only finite partial sums make the question well posed.

## Hypotheses and notation

- Trap 1: the `N = 2` zero of `Re S_2` at `t = π/log 2` is tangential.
- Trap 2: the complex equation `S_N(t) = 0` — `S_2(π/log 2) = 0` exactly, `S_3(t) ≠ 0` for every real `t`.
- Trap 3: `|S_N(t)| ~ N/√(1+t²)` (linear growth), so only finite partial sums make the question well posed.

## Proof / evidence

- Components: `N = 2` and `S_3` results **PROVED in Lean**; divergence established by Euler summation and verified numerically (truths.md §4, auditor C6).
- Harvested component files: [N = 2 is balanced exactly at π/log 2](tpp-rh43-handoff-n2-tangential-zero.md), [The complex sum is a different question](tpp-rh43-handoff-complex-sum-different-question.md), [The divergence is linear](tpp-rh43-handoff-linear-divergence.md).

## Dependencies and related results

- Harvested handoff counterpart: [The three traps of the round](tpp-rh43-handoff-three-traps.md).
- Harvested truths counterparts: [T4](tpp-rh43-truths-n2-balanced-ledger.md), [T10](tpp-rh43-truths-s3-nonvanishing-ledger.md), [T11](tpp-rh43-truths-s2-exact-vanishing.md), [T12](tpp-rh43-truths-linear-divergence-ledger.md).

## Notes

- The README's phrasing "recorded, not hidden" matches the round's house rule that every falsified statement is kept in truths.md §5.
