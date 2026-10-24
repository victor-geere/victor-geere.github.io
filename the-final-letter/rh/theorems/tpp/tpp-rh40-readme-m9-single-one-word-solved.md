# M9 — the single-one word is completely solved

**Kind:** Claim
**Status:** VERIFIED (numerical; first half exact on all a < 60, N < 120; combined law has zero counterexamples for 1 ≤ a < 40, N ≥ 2a + 4)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M9** (lines 183–196)

## Statement

> **M9 — the single-one word is completely solved.** For a word with exactly one 1 at position `a` and `N ≥ 2a + 4`:
>
> ```
> p(L) = min(L, a+1) + 1     for  L ≤ N − a − 1
> p(L) = N − L + 1           for  L ≥ N − a − 1
> ```
>
> The first half is exact on all `a < 60, N < 120`; the combined law has **zero counterexamples** for `1 ≤ a < 40, N ≥ 2a + 4`. Note this is the same eligibility condition `N ≥ 2a_m + 3`-ish under which the plateau law `a_m + 2` holds, which is a real structural hint: the non-degenerate regime is exactly where the plateau exists. In the degenerate sliver `N < 2a + 4` the closed form needs extra care and the mediator did not chase it.

## Hypotheses and notation

- The word is a 0/1 word of truncation length `N` with exactly one 1, at position `a` (`0 ≤ a < N`).
- `p(L)` is the number of distinct length-`L` factors of the truncation.
- Regime: `N ≥ 2a + 4`; the law is stated with `L` in the two ranges separated by `L = N − a − 1`.
- The associated eligibility condition for the `m`-one case is `N ≥ 2a_m + 3`; the source calls the coincidence "a real structural hint".

## Proof / evidence

The source states this without proof: it is an exact-enumeration record ("The first half is exact on all `a < 60, N < 120`; the combined law has **zero counterexamples** for `1 ≤ a < 40, N ≥ 2a + 4`").

**Corrected attribution (audit repair 5a, 2025-10-06).** The README's §5 "Reproduced exactly in this session" list says `verify/probes.py` reproduces "the single-one law `p(L) = min(L, a+1) + 1` (for `L ≤ N−a−1`) then `N−L+1`". It does not: the string `min(L` does not occur in that script, and no enumerator for the law existed anywhere in the repository when the session-002 audit looked. The enumerator now exists — [`verify/single_one_law_verify.py`](../../research/twin-prime-parity/rounds/rh40/verify/single_one_law_verify.py), with log `verify/single_one_law_verify.log`, written independently of `code/digitword.py` — and it corroborates the quoted ranges: **239 599/239 599** for the first half under the reading `1 ≤ a < 60, a < N < 120, 1 ≤ L ≤ N−a−1` (the wider reading that also admits `a = 0` or `L = 0` gives 251 990, also 0 counterexamples), and 0 counterexamples for the combined law on `1 ≤ a < 40, N ≥ 2a + 4`. The same script records a proof of the law on its stated range, so the first half is no longer numerical-only in principle; the status below is left at VERIFIED (numerical) because that proof is not formalised and the degenerate sliver of the second half is still unchased.

## Dependencies and related results

- [Plateau value = a_m + 2](tpp-rh40-readme-plateau-value-am-plus-2.md) — the companion law under the same eligibility condition; the single-one case is the `m = 0` analogue.
- [M3 — the plateau and the decay boundary](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) — the decay branch `p(L) = N − L + 1` seen here on the second range.
- [Theorem A (the large-L regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — the general large-`L` law that specialises to the second branch.

## Notes

- The source is explicit about the untested sliver: "In the degenerate sliver `N < 2a + 4` the closed form needs extra care and the mediator did not chase it." This file preserves that limitation.
- The source labels the result as "completely solved" but supports it by enumeration, not proof; the status recorded here is therefore VERIFIED (numerical), not PROVED. Since 2025-10-06 the enumeration has a committed enumerator (`verify/single_one_law_verify.py`), where before it had none — that is the whole content of repair 5a.
