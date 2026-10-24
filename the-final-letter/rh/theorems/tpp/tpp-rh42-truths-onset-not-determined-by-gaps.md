# The onset is still not determined by (gaps, N)

**Kind:** Claim
**Status:** CHECKED (exhaustive finite: 210 of 402 keys multi-valued)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §7 "Statements about the signed word's factors"

## Statement

> **The onset is still not determined by `(gaps, N)`.** **CHECKED** over the
> parity-locked supports: **210 of 402** keys `(gaps, N)` are multi-valued. The
> parity constraint does not repair rh41's Theorem 6.

## Hypotheses and notation

- "Onset" is rh41's onset observable of the factor-count law; the claim is that the map from `(gaps, N)` to the onset is not single-valued.
- "Parity-locked supports" are the supports obeying the parity lock of [Theorem 14](tpp-rh42-truths-theorem-14-parity-lock.md) (all gaps even and `≥ 2`).
- A key `(gaps, N)` is **multi-valued** when two parity-locked supports with the same gaps and truncation length `N` give different onsets.
- rh41's Theorem 6 is the corresponding non-injectivity statement in the unsigned round.

## Proof / evidence

> **CHECKED** over the parity-locked supports: **210 of 402** keys `(gaps, N)` are
> multi-valued.

The source gives the exhaustive count `210 of 402` as the whole certificate; no script section is named for it in this bullet.

## Dependencies and related results

- [Theorem 14 (parity lock, T9)](tpp-rh42-truths-theorem-14-parity-lock.md) — the parity constraint that is shown not to repair the phenomenon.
- rh41's Theorem 6 (the unsigned onset result) — named as not repaired.

## Notes

- This is a negative/non-injectivity result stated with an exhaustive finite check; the source marks it **CHECKED**, and this file keeps that status (it is not a proof of a general statement).
- The exact numbers `210` and `402` are quoted as printed.
