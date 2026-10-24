# The plateau value is not determined by (m, span, N), nor by gaps or (gaps, N)

**Kind:** Claim
**Status:** VERIFIED (numerical; 45/55 keys multi-valued, with explicit counterexamples)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[TESTED]" (c), lines 61–65

## Statement

> (c) Not a function of (m,span,N): 45/55 keys are multi-valued; m=1, span=0, N=20 gives (0,)->2 versus (11,)->10. Not gaps alone, nor (gaps,N): gaps=() at N=20 gives max p = 2,11,10,2 for (0,),(10,),(11,),(19,). Positive law: max p = a_m+2 for every support with N>=2a_m+3 …

## Hypotheses and notation

- A support `(a_0,…,a_m)` at truncation length `N` has `m + 1` ones, `span = a_m − a_0`, and plateau ("max p") value `max_L p(L)`.
- A "key" is an equivalence class of supports sharing the named data; a key is **multi-valued** when two supports in it have different plateau values.
- The specific counterexamples: `m=1, span=0, N=20` admits both `(0,)` with `max p = 2` and `(11,)` with `max p = 10`; with `gaps=()` at `N=20` the supports `(0,), (10,), (11,), (19,)` give `max p = 2, 11, 10, 2` respectively.
- The companion positive law (`max p = a_m+2` for `N >= 2a_m+3`) is stated in the same sentence and is harvested separately.

## Proof / evidence

The source states this as exact computation: "45/55 keys are multi-valued", with the counterexamples written out. The README reports the same conclusion in narrative form — "it is a function of **a_m alone**, which is why the handoff's attempt to read it off `(m, span, N)` could not work" — and the round-1 brief's question (c) asks precisely this ("is the plateau value a function of the gap sequence alone, of the gap sequence and `N`, or never of `(m, span, N)`?").

## Dependencies and related results

- [On the plateau p(L) = a_m+2](tpp-rh40-round01-agentb-plateau-value-am-plus-2.md) — the positive companion law and its verification.
- [Plateau value = a_m + 2](tpp-rh40-readme-plateau-value-am-plus-2.md) — the README's statement of the value and of the `(m, span, N)` obstruction.
- [Theorem E (onset determinacy)](tpp-rh40-k-remaining-theorem-e-onset-determinacy.md) — the later analogue for the plateau *onset*, which is not a function of `(gaps, N)` but is a function of `(gaps, N, a_0)`.

## Notes

- The source's negative half answers question (c) of the round-1 brief; the positive half answers the same question by identifying `a_m` alone (equivalently "the gaps together with `a_0`") as the determining data.
