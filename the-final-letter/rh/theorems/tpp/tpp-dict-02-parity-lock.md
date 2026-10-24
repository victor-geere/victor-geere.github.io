# Theorem 2.3 (parity lock — THEOREM, Lean)

**Kind:** Theorem
**Status:** PROVED (Lean: `tauStep_nonneg`, `take_parity`, `support_subset_even`, `support_gap_even_and_two_le` in `rh42/lean/Rh42/Tau.lean`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) — §2 "The signed (Tau) reading — the \"harmonic sine\"", "Theorem 2.3 (parity lock — THEOREM, Lean)", line 57

## Statement

> **Theorem 2.3 (parity lock — THEOREM, Lean).**  For a positive target every take occurs
> at an **even** index; for a negative target every take occurs at an **odd** index.
> Hence every gap of a signed support is **even and ≥ 2**.

## Hypotheses and notation

- The signed (Tau) rule of Definition 2.2 is in force: at step `n`, take `α_n` iff `sign(α_n) = sign(r_n)` **and** `|α_n| ≤ |r_n|`; then `r_{n+1} = r_n − α_n`; otherwise skip it forever.
- The Tau alphabet is `α_n = (−1)^n/(n+2)^p`, `n = 0,1,2,…` (Definition 2.1).
- "Take" = an index at which a term is used; the "signed support" is the set of taken indices.
- Target sign: positive target (positive height `x = sin(2πθ)`) versus negative target.

## Proof / evidence

The source gives the proof verbatim:

> *Proof.*  The residual stays non-negative at a positive target (it can reach `0`
> exactly), and odd-index terms are negative, so the sign test rejects them.  ∎

and the machine-checked evidence:

> *Status:* THEOREM, machine-checked in `rh42/lean/Rh42/Tau.lean`
> (`tauStep_nonneg`, `take_parity`, `support_subset_even`, `support_gap_even_and_two_le`).

## Dependencies and related results

- Definition 2.1 (the Tau alphabet) and Definition 2.2 (the signed rule) — definitions, not harvested.
- [Corollary 2.4 (Egyptian transfer)](tpp-dict-02-egyptian-transfer.md) — the reformulation of the signed rule as a classical Egyptian greedy.

## Notes

- The source records the following caveat verbatim: "the strict form 'the residual stays `> 0`' is false (`x = 1/2`, `p = 1`: equality at the first take), which is why the checked statements are the non-strict ones." The non-strict form above is the harvested statement; the strict form must not be substituted.
- Ledger entry: §2 material of the dictionary restating the **rh42** round (the source cites `rh42 §2`, `rh42/lean`).
