# F5 — "|S_N(t)| grows like N^{1/2}"

**Kind:** Claim
**Status:** REFUTED (certified value `|S_{10^4}(1)| = 7071.771405`; the growth is linear)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §5 "The referee's corner: falsified statements of this round"

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | F5 | "`|S_N(t)|` grows like `N^{1/2}`" | certified `|S_{10^4}(1)| = 7071.771405`; the growth is linear, `1/sqrt(1+t^2)`. |

## Hypotheses and notation

- The falsified claim: `|S_N(t)|` grows like a power `N^{1/2}`.
- Certified witness: `|S_{10^4}(1)| = 7071.771405`, against the linear law `|S_N|/N -> 1/sqrt(1+t^2)` (`1/sqrt 2 = 0.70710678` at `t = 1`).

## Proof / evidence

- Ledger row F5: status "**REFUTED**", evidence "§5, with witnesses".
- The corrected result is [Theorem 12 (linear divergence)](tpp-rh43-truths-linear-divergence.md), proved by first-order Euler summation and verified by the auditor.
- The source records the correction: the script's docstring claimed `N^{1/2}` growth (F5) and this is fixed here.

## Dependencies and related results

- Related: [Theorem 12 (linear divergence)](tpp-rh43-truths-linear-divergence.md); the `sqrt N` picture "belongs to `Re(S) = 1/2`".

## Notes

- The ledger's refutation table attributes the falsified growth claim to the neighbouring round's intuition (HANDOFF.md §2.4: "not `√N` as the neighbouring round's intuition suggests").
