# The C1 regime of a signed word (new, corrected)

**Kind:** Claim
**Status:** VERIFIED (numerical, on the listed examples)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §7 "Statements about the signed word's factors"

## Statement

> **The C1 regime of a signed word (new, corrected).** C1 says `p(L) = L+1` for
> `L ≤ min(min gap, a_0, N−a_0−1)`. By Theorem 14 every gap of a signed word is
> even and `≥ 2`, so the C1 range is `L ≤ min gap`, and it sits inside `L ≤ 2`
> exactly when the support has a gap of length `2`. The full range is
> `min(min gap, a_0, N−a_0−1)`: for `{4,8,12}`, `N = 20` it is `L ≤ 4` and
> `p(1..4) = 2, 3, 4, 5`; for `{2,6,38}`, `N = 22` the min gap is `4` but
> `a_0 = 2`, so the range is `L ≤ 2`; and for `{0,2,4,10}`, `N = 22` the min gap is
> `2` but `a_0 = 0` **empties** the C1 range, even though `p(1) = 2` and
> `p(2) = 3` still hold by hand and `L = 3` already violates `L ≤ min gap`. **VERIFIED.**

## Hypotheses and notation

- `p(L)` counts the distinct length-`L` factors of a length-`N` truncation of the digit word (§0).
- `a_0` is the first element of the support; `min gap` is the minimum gap of the support; `N` is the truncation length.
- `p(1..4) = 2, 3, 4, 5` is the source's shorthand for the values at `L = 1, 2, 3, 4`.
- C1 is rh41's regime name for the regime in which the factor count is `L+1`.

## Proof / evidence

> ... **VERIFIED.**

The evidence is the source's own case list above (three worked supports `{4,8,12}`, `{2,6,38}`, `{0,2,4,10}` with their stated ranges and values); no separate script section is cited for this bullet.

## Dependencies and related results

- [Theorem 14 (parity lock, T9)](tpp-rh42-truths-theorem-14-parity-lock.md) — every gap of a signed word is even and `≥ 2`.
- [Plateau and decay (rh41's Theorem 1)](tpp-rh42-truths-plateau-and-decay-signed.md) and [Corollary 4](tpp-rh42-truths-corollary-4-max-plateau.md) from the same bullet list.

## Notes

- The source explicitly flags this bullet as a correction, quoted verbatim: "*(A previous formulation of this bullet claimed the C1 range is always `L ≤ 2`; that is false — an even gap can be larger — and the corrected statement is the one above.)*"
- The example `{0,2,4,10}`, `N = 22` shows the range can be **empty** (because `a_0 = 0`), while `p(1) = 2` and `p(2) = 3` still hold by hand.
