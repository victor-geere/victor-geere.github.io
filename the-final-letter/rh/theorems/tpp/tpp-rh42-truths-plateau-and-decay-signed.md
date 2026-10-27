# Plateau and decay (rh41's Theorem 1)

**Kind:** Theorem
**Status:** PROVED (Lean, inherited from rh41; VERIFIED here on signed supports)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §7 "Statements about the signed word's factors"

## Statement

> For `L ≥ a_m + 1`,
> `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`.

## Hypotheses and notation

- `p(L)` counts the distinct length-`L` factors of a length-`N` truncation of the digit word (§0, unsigned reading).
- `a_m` is inherited from rh41's complexity framework and is **not** redefined in this file; the bullet verifies the law on the signed supports `{0,2,4,10}`, `{2,6,38}`, `{0,8}`, `{0,2,4}`.
- `N` is the truncation length; `[L ≤ N−a_m−1]` is the Iverson bracket (`1` if the condition holds, `0` otherwise).
- The support of a signed word is a finite set, so rh41's law applies to it "verbatim".

## Proof / evidence

> Since the support of a signed word is just a finite set, rh41's proved law applies
> verbatim (its Lean `complexity_main` is generic in the support):
>
> * **Plateau and decay (rh41's Theorem 1).** For `L ≥ a_m + 1`,
>   `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`; **VERIFIED** on the signed supports
>   `{0,2,4,10}`, `{2,6,38}`, `{0,8}`, `{0,2,4}`.

## Dependencies and related results

- rh41's Lean declaration `complexity_main` (generic in the support) — cited by the source as the proof vehicle.
- The sibling round's ledger: `../rh41/TRUTHS.md` (the unsigned round, reused and not touched).
- Related harvested statements from the same §7 bullet list: [Corollary 4](tpp-rh42-truths-corollary-4-max-plateau.md), [The C1 regime of a signed word](tpp-rh42-truths-c1-regime-signed-word.md), [The onset is still not determined by (gaps, N)](tpp-rh42-truths-onset-not-determined-by-gaps.md).

## Notes

- The theorem is inherited from rh41 (where it is Theorem 1) and restated here for signed words; the source's own status word for the bullet is **VERIFIED** (on the signed supports), while the sentence introducing the list asserts rh41's proved law applies verbatim. Both are recorded in Proof / evidence.
- The source's §9 list of inherited items names "the unrestricted Theorem 1" among results *not* re-proposed here; this file harvests only the §7 restatement with its signed-support verification.
