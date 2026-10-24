# Theorem 1 (main)

**Kind:** Theorem
**Status:** PROVED (paper argument; Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §1 "The complexity function"

## Statement

> **Theorem 1 (main).** For `L ≥ max(span, a_m + 1)`,
>
> ```
> p(L) = min(a_m + 1, N − L + 1) + [ L ≤ N − a_m − 1 ].
> ```

## Hypotheses and notation

- `x ∈ (0,1)`; the greedy rule at step `n` compares the residual `r` with `1/(n+2)`: take the digit 1 iff `r ≥ 1/(n+2)`, and subtract. The word is `w(x) = δ_0δ_1…`.
- The word's support is `0 ≤ a_0 < … < a_m`; `span = a_m − a_0` and `d_j = a_j − a_{j−1}`.
- `p(L) = #{ distinct length-L factors of w } = #{ {a − t : t ≤ a ≤ t+L−1} : 0 ≤ t ≤ N−L }` for a truncation of length `N`.
- `[·]` is the Iverson bracket (`[ L ≤ N − a_m − 1 ]`).
- The Lean restatement `DigitWord.complexity_main_TRUTHS` matches the printed hypotheses; `DigitWord.complexity_main` proves the sharper form (see Notes).

## Proof / evidence

> *Proof.* Let `t ∈ [0, N−L]`. If the window `[t, t+L−1]` contains `a_m`, then `a_m − t ∈ F(t)` and it is the **maximum** of `F(t)` (every offset is `a−t ≤ a_m−t` and non-negative). Hence `F(t) = F(t')` forces `a_m − t = a_m − t'`, i.e. `t = t'`: the map is injective on the windows containing `a_m`, which number `max(0, min(a_m, N−L) − max(0, a_m−L+1) + 1) = min(a_m+1, N−L+1)`. A window that does not contain `a_m` lies entirely to the right of `a_m` (`L ≥ span`), so it meets no support point and gives the single all-zero factor; one exists iff `a_m + 1 ≤ N − L`. ∎

The round's Lean 4 + Mathlib development also proves it (`Rh41/DigitWord.lean`, no `sorry`): `DigitWord.complexity_main` (sharper hypothesis) and `DigitWord.complexity_main_TRUTHS` (printed hypotheses). The statement was cross-checked against the Python ground truth `p_ref` over 397 214 cases (`crosscheck.py`, exit 0).

## Dependencies and related results

- [Refuted — the main formula for all L](tpp-rh41-truths-refuted-main-formula-all-l.md): the hypothesis `L ≥ max(span, a_m+1)` is necessary.
- [Corollary 2 (plateau)](tpp-rh41-truths-corollary-2-plateau.md), [Corollary 3 (decay)](tpp-rh41-truths-corollary-3-decay.md), [Corollary 4](tpp-rh41-truths-corollary-4-max-complexity.md).
- [Correction 4 — Theorem 1 is stated with a redundant hypothesis](tpp-rh41-lean-readme-correction-4-theorem-1-redundant-hypothesis.md).

## Notes

- The bound `L ≥ max(span, a_m+1)` is **necessary**: for support `{0,1}`, `N = 2`, `L = 1` the formula gives 2 but `p = 1` (the source's own counterexample, repeated in §5).
- The round's Lean README records that the span hypothesis is redundant: `L ≥ a_m + 1` suffices, and `complexity_main` proves that sharper statement.
