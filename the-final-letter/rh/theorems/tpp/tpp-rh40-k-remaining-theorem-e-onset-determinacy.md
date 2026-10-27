# Theorem E — determinacy of the plateau onset

**Kind:** Theorem
**Status:** PROVED (negative half by exhaustive counterexample, positive half by construction/tautology)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §2.1 "A determinacy theorem for the onset (new)"

## Statement

> **Theorem E.** Let `onset(w) = min{ L : p(L) = max_L p(L) }`. Then `onset` is **not** a function of `(gaps, N)` alone, but **is** a function of `(gaps, N, a_0)` — equivalently of the full support and `N`.

## Hypotheses and notation

- `w` is a finitely supported 0/1 word of length `N` with support `0 ≤ a_0 < … < a_m < N`; `gaps = (d_1, …, d_m)`, `d_j = a_j − a_{j−1}`.
- `p(L)` is the number of distinct length-`L` factors; `onset(w) = min{ L : p(L) = max_L p(L) }` is the first length attaining the maximum.
- A key `(gaps, N)` is multi-valued when two supports with the same gaps and the same `N` (hence different `a_0`) give different onsets.

## Proof / evidence

The source splits the proof and labels the halves:

> *Proof of the negative half.* Exhaustive counterexample: `gaps = (2,)`, `N = 6` gives `onset = 2` for the support `(0,2)` and `onset = 3` for `(1,3)`, `(2,4)`, `(3,5)`. Over all supports with `m+1 ≤ 4`, `6 ≤ N ≤ 24` there are **2 299** distinct `(gaps, N)` keys and **1 486** of them carry more than one onset value.
>
> *The positive half is a tautology, and should be said so.* The map `(a_0, d_1, …, d_m, N) ↦ onset` is a function because `a_0` and the gaps determine the support completely (`a_j = a_0 + d_1 + … + d_j`) and the onset is a function of the support and `N`. The corpus check reflects that: on the same corpus the number of distinct `(gaps, N, a_0)` keys equals the number of words, so the "0 failures" is a restatement of completeness, not evidence. **The content of Theorem E is entirely in the negative half.**

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) and [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) — the value `max_L p(L) = a_m + 2` whose onset Theorem E concerns.
- [Theorem 6 (onset determinacy)](tpp-rh41-truths-theorem-6-onset-determinacy.md) — the same determinacy statement in the later round, with different corpus counts (`3 896 of 7 521` keys multi-valued) and a Lean formalisation; see Notes.
- [The onset is still not determined by (gaps, N)](tpp-rh42-truths-onset-not-determined-by-gaps.md) — the signed-round sequel.

## Notes

- **Restatement round.** The same statement appears as "Theorem 6 (onset determinacy)" in the later round `research/twin-prime-parity/rounds/rh41/TRUTHS.md`, already harvested as [tpp-rh41-truths-theorem-6-onset-determinacy.md](tpp-rh41-truths-theorem-6-onset-determinacy.md), where the corpus is `3 896 of 7 521` keys and the result is machine-checked as `DigitWord.onset_not_determined_by_gaps` (`native_decide`). The counts differ between rounds; both are quoted exactly as printed in their own sources.
- The source draws the methodological consequence itself: "**This is why every candidate formula failed.** Register J11/J12 and E8 list four refuted candidates; all four were functions of the gap sequence (and `N`) and so were *provably* incapable of working before they were even tested."
- The register `rounds/truths.md` row E8a carries the same content under the name "Theorem E (determinacy)" and cites `K_remaining.md §2.1`; E8 (the onset having no formula found so far, with measured onsets 605, 6065, 250, 60, 53) remains `OPEN` and is **not** harvested here as a theorem.
- K2 as a whole is labelled **PARTIAL** in the source's §0 summary ("determinacy settled (a shift-invariance theorem); no closed form").
- Quantities quoted exactly as printed: `(2,)`, `N = 6`, onsets `2` and `3`, `m+1 ≤ 4`, `6 ≤ N ≤ 24`, `2 299` keys, `1 486` multi-valued.
