# Claim A1 — offset tuples and bit strings define the same factor complexity

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 513–515, declaration `Rh41.complexity_eq_bitComplexity`

## Statement

> **Claim A1.** The offset-tuple count and the bit-string count of length-`L` factors agree, for every support and every truncation.

Formally (Lean 4 / Mathlib):

```lean
theorem complexity_eq_bitComplexity (S : Finset ℕ) (N L : ℕ) (hL : 1 ≤ L) :
    complexity S N L = bitComplexity S N L
```

The section header notes: "`TRUTHS.md` §2 records this as *checked* over all words of length `≤ 14`. It is in fact a theorem: the offset set of the ones in a window and the bit string of the window determine each other."

## Hypotheses and notation

- `S : Finset ℕ`, `N L : ℕ` with `1 ≤ L`.
- `complexity S N L` counts distinct offset sets `factor S L t = {a - t : a ∈ S, t ≤ a ≤ t + L - 1}` over window starts `t ∈ [0, N-L]`.
- `bitComplexity S N L = ((range (N - L + 1)).image (fun t => bitFactor S L t)).card`, where `bitFactor S L t : Fin L → Bool` is `fun i => decide (t + i.val ∈ S)`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.complexity_eq_bitComplexity` in `Rh41/DigitWord.lean` (lines 515–526). The key steps are `toBit_factor` (reading the offset set as a bit string gives the bit string of the window, `toBit L (factor S L t) = bitFactor S L t`) and `card_image_toBit` (`toBit L` is injective on sets contained in `range L`).

## Dependencies and related results

- [`Rh41.DigitWord.mem_factor_iff`](lean-rh41-digitword-main-complexity-law.md) — the unfolding `i.val ∈ factor S L t ↔ t + i.val ∈ S` behind the equivalence; it is auxiliary and not harvested separately.

## Notes

- The definition of record used by the Python ground-truth layer (`rh41/digitword.py`) is the offset set; the theorem says switching to bit strings does not change `p(L)`.
