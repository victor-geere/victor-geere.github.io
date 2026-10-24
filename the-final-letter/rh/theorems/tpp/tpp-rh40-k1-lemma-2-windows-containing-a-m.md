# Lemma 2 (how many windows contain `a_m`, and whether they are non-zero)

**Kind:** Lemma
**Status:** PROVED (paper argument; not formalised in Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md`](../../research/twin-prime-parity/rounds/rh40/K1_plateau_theorem.md) — §2 "Proof", Lemma 2

## Statement

> ### Lemma 2 (how many windows contain `a_m`, and whether they are non-zero)
>
> Assume `L ≥ a_m + 1`. The windows containing `a_m` are those with `t ≤ a_m ≤ t + L − 1`, i.e.
>
> ```
> max(0, a_m − L + 1) ≤ t ≤ min(a_m, N − L).
> ```
>
> (i) Since `L ≥ a_m + 1` we have `a_m − L + 1 ≤ 0`, so the lower end is `0`.
> (ii) Since `L ≤ N − 1`, we have `N − L ≥ 1 > 0`, so also `a_m ≤ N − L` would be needed for the upper end to be `a_m`; but `a_m ≤ N − L` **iff** `L ≤ N − a_m`. So the count is
>
> ```
> # {t : a_m ∈ [t, t+L−1]} = min(a_m, N − L) + 1 = min(a_m + 1, N − L + 1).
> ```
>
> (iii) Every such window contains a 1, so none of them gives the all-zero factor.
> (iv) Conversely every window that does **not** contain `a_m` lies strictly to the right of `a_m`, i.e. `t > a_m`; such a window exists iff `a_m + 1 ≤ N − L`, i.e. iff
>
> ```
> L ≤ N − a_m − 1.
> ```
>
> A window to the right of `a_m` contains no 1 at all, so it contributes the all-zero factor, and there is at most one such factor. Hence
>
> ```
> p(L) = min(a_m + 1, N − L + 1) + [ L ≤ N − a_m − 1 ].        ∎
> ```

The source's own note: "*Note that Lemma 2(ii) is not vacuous and not automatic: `L ≤ N − a_m` fails whenever `L` is large, which is exactly the regime where the window counting saturates at `N − L + 1` and the "decay" appears.*"

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of `w`; `p(L) = #{ F(t) : 0 ≤ t ≤ N − L }`.
- Hypothesis `L ≥ a_m + 1` (this lemma), together with `L ≤ N − 1` used in step (ii).
- `[·]` is the Iverson bracket, `[ L ≤ N − a_m − 1 ]`.
- The all-zero factor is the offset tuple realised by a window meeting no support point; there is at most one such factor.

## Proof / evidence

The source proves the lemma in the four numbered steps quoted above; the final displayed line is the reassembly of Theorem A's formula. Paper proof only; §5 records the proof is not formalised in Lean. The later round's Lean `complexity_main` formalises the same formula (see Dependencies).

## Dependencies and related results

- [Lemma 1 (a window has multiplicity one …)](tpp-rh40-k1-lemma-1-window-multiplicity-one.md) — supplies the injectivity used to convert the window count into the factor count, and (in §2's Lemma 3) the same for the range `span ≤ L ≤ a_m`.
- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) — the formula this lemma assembles.
- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) — obtained from the same formula by `L ≤ N − a_m − 1`.
- [The exact number of windows containing a_m](tpp-rh41-truths-claim-window-count-containing-a-m.md) — the later round's claim `#{ t : window contains a_m } = max(0, min(a_m,N−L) − max(0,a_m−L+1) + 1)` (CHECKED over 25 044 603 cases; Lean-proved for all `1 ≤ L ≤ N`), which reproduces the count derived here.

## Notes

- The source's §3(e) uses this lemma to explain why the formula is `min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` and not `min(a_m+2, N−L+1)`.
- The interval `[max(0, a_m − L + 1), min(a_m, N − L)]` is quoted exactly as printed.
