# Predictions (new words) for the plateau value at L = span+1

**Kind:** Claim
**Status:** VERIFIED (numerical; confirmed exactly in the source's session)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md) — §"[COMPUTABLE]", item (c), prediction block, lines 67–70

## Statement

> **Predictions (new words), test with `p_offset(ones,N,span(ones)+1)`:**
> `{0,3,17}, N=600 → 19`; `{2,9,44}, N=800 → 46`; `{1,6,31,200}, N=1200 → 202`.
> Confirmed exactly in this session; the same call at `L=N−a_m−1` must also return
> those values.

## Hypotheses and notation

- Each prediction is a support `ones`, a truncation length `N`, and the asserted value of `p` at the probe length `L = span(ones) + 1`, with `span = a_m − a_0`.
- `p_offset(ones, N, L)` is the offset-tuple complexity of `rh40/code/digitword.py`; the source's test is the single call `p_offset(ones,N,span(ones)+1)`.
- The supports are `{0,3,17}` at `N = 600`, `{2,9,44}` at `N = 800`, and `{1,6,31,200}` at `N = 1200`; the asserted values are 19, 46 and 202.
- The final sentence asserts that the same values must recur at `L = N − a_m − 1` (the decay boundary).

## Proof / evidence

The source states the predictions as "Confirmed exactly in this session" by the named call; no proof is given. The README's §5 "Reproduced exactly in this session" list confirms that `verify/probes.py` reproduces "the plateau law `max p = a_m + 2`", which is the law these three values instantiate, and the same README records the fitted plateau values `202`, `46`, `19` as the maximum-complexity values of these supports (its §8 test list and §5 entries). The law behind the predictions is proved only much later and only for the large-`L` regime, in [Theorem B](tpp-rh40-k1-theorem-b-plateau.md).

## Dependencies and related results

- [Agent A (c) — the decay law and the plateau value a_m+2](tpp-rh40-round01-agenta-decay-law-and-plateau-value.md) — the plateau law these predictions instantiate.
- [Plateau value = a_m + 2](tpp-rh40-readme-plateau-value-am-plus-2.md) — the README's statement of the same law.
- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) — the proof for `max(span, a_m + 1) ≤ L ≤ N − a_m − 1`.

## Notes

- These are three computed instances, not a general theorem; the source presents them as the `[COMPUTABLE]` predictions required by the round's brief ("Predict the plateau value for at least three words NOT in the list above and give the exact call that tests your prediction").
- The asserted value 202 corresponds to `a_m = 200` (`200 + 2`), 46 to `a_m = 44`, and 19 to `a_m = 17`.
