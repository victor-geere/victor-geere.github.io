# Lemma 1 (a window has multiplicity one, and is recognised by its last offset)

**Kind:** Lemma
**Status:** PROVED (paper argument; not formalised in Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md`](../../research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md) — §2 "Proof", Lemma 1

## Statement

> ### Lemma 1 (a window has multiplicity one, and is recognised by its last offset)
>
> Assume `L ≥ span`, so the window `[0, L−1]` reaches `a_m`. For any `t` with `0 ≤ t ≤ N − L`:
>
> **(i)** If `a_m ∈ [t, t+L−1]` then `a_m − t ∈ F(t)` and `a_m − t = max F(t)`: every offset in `F(t)` is `a − t` with `a ≤ a_m`, and `a − t ≥ 0`.
>
> **(ii)** Hence if `F(t) = F(t')` and both windows contain `a_m`, then `a_m − t = max F(t) = max F(t') = a_m − t'`, so `t = t'`. So the map `t ↦ F(t)` is **injective on the set of windows containing `a_m`**. ∎

The source's own gloss: "*This is the whole content of K1. Everything below is bookkeeping.*"

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of `w`; `span := a_m − a_0`.
- `F(t) = { a − t : a ∈ {a_0,…,a_m},  t ≤ a ≤ t + L − 1 }` is the offset tuple of the length-`L` factor at window start `t`.
- `L ≥ span` is exactly the condition that the window `[0, L−1]` reaches `a_m`.
- `t` ranges over `0 ≤ t ≤ N − L`, the window starts of a truncation of length `N`.

## Proof / evidence

The source states and proves the lemma in §2 in the two numbered steps quoted above; the proof is complete as printed (no external input, no computation). It is a paper proof only: §5 records "The proof is not formalised in Lean", and adds that "Lemma 1 is now the natural first formalisation target (`Finset` injection on the windows containing the maximal support point)".

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — whose proof this lemma carries ("This is the whole content of K1").
- [Lemma 2 (how many windows contain `a_m` …)](tpp-rh40-k1-lemma-2-windows-containing-a-m.md) — the counting half of the same proof.
- The later round's formalisation of the complexity law ([Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md)) uses the same injectivity argument; see Notes.

## Notes

- This is a "named/labelled declaration" rung of K1's own argument, not a bare mention of an outside result.
- The source's statement of this lemma carries the count of windows only in §2's proof of Theorem A, not in the lemma itself.
