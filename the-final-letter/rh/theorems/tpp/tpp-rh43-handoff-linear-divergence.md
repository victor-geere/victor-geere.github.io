# The divergence is linear: |S_N(t)|/N → 1/√(1+t²)

**Kind:** Proposition
**Status:** PROVED (paper argument, Euler summation) + VERIFIED (numerical, certified values)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.4 "The three traps"

## Statement

> 3. **The divergence is linear.** `|S_N(t)|/N → 1/√(1+t²)` (certified: `|S_{10^4}(1)| = 7071.771405`), so the series is not ordinarily summable at `Re(S) = 0` and the question is only well posed for finite `N`. The `√N` picture belongs to `Re(S) = 1/2`.

The header's one-paragraph version states the same:

> the divergence, which is **linear** (`|S_N| ~ N/√(1+t²)`), not `√N` as the neighbouring round's intuition suggests — so only *finite* partial sums make the question well posed.

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{-it}`, `t` real.
- Limit law `|S_N(t)|/N → 1/√(1+t²)`; certified instance `|S_{10^4}(1)| = 7071.771405`.
- Contrast: the `√N` growth picture belongs to `Re(S) = 1/2`.

## Proof / evidence

- **PROVED** by Euler summation in the round (truths.md §4 Theorem 12 gives the expansion `S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N`, `|R_N| ≤ (|t|/2) log N`).
- **VERIFIED** by the auditor with certified values; the ledger records this as **T12**, "**PROVED**+**VERIFIED**", evidence "§4, auditor C6".

## Dependencies and related results

- Harvested truths counterpart: [Theorem 12 (linear divergence)](tpp-rh43-truths-linear-divergence.md), ledger row [T12](tpp-rh43-truths-linear-divergence-ledger.md), refuted statement [F5](tpp-rh43-truths-f5-sqrt-n-growth-refuted.md).
- Related in the truths harvest: [T15 — the N -> infinity asymptotic of the split](tpp-rh43-truths-n-to-infinity-asymptotic-split.md) (this asymptotic material is in `truths.md` §7.5, not in HANDOFF.md).

## Notes

- HANDOFF.md's header calls the `√N` intuition "the neighbouring round's intuition"; the source's correction is recorded rather than deleted (truths.md §5, HANDOFF.md §5).
