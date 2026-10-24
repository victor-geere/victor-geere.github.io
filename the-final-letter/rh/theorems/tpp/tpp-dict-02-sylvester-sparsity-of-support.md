# Theorem 4.1 (Sylvester-sparsity of the support — THEOREM)

**Kind:** Theorem
**Status:** PROVED (paper argument; source also NUMERICAL, 0 violations in 53 159 consecutive pairs)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) — §4 "The new sparsity theorem (rh47) — the programme's cleanest structural fact", "Theorem 4.1 (Sylvester-sparsity of the support — THEOREM)", line 94

## Statement

> **Theorem 4.1 (Sylvester-sparsity of the support — THEOREM).**  Let `A(x) = {m_1 < m_2
> < …}` be the greedy support.  Then
> ```
> m_{i+1} ≥ m_i (m_i − 1) + 1 .
> ```
> *Consequences.*
> * `|A| ≥ 20 ⟹ max A ≥ s_20` (the Sylvester sequence), an integer with **106 721
>   digits**; so a target whose support is large enough for a parity statistic has its
>   largest index beyond any computable `λ`.
> * The support **density** is `≈ 3.9·10⁻⁵` (mean support size `2.95 → 3.90` for
>   `N = 10² → 10⁵`).
> * The size class is non-empty: the ladder `x_k = (s_{k+1}−2)/(s_{k+1}−1)` has support
>   exactly `{s_1,…,s_k}`.

## Hypotheses and notation

- `A(x) = {m_1 < m_2 < …}` is the greedy support of Definition 1.1, written in the shifted alphabet `m = n+2` (so `A(x) ⊂ {2,3,4,…}`).
- `s_k` is the Sylvester sequence; `s_20` is the 20th Sylvester number.
- The density figure `≈ 3.9·10⁻⁵` is for mean support size `2.95 → 3.90` over `N = 10² → 10⁵`.
- The ladder is `x_k = (s_{k+1}−2)/(s_{k+1}−1)`, with support exactly `{s_1,…,s_k}`.

## Proof / evidence

The source gives the proof verbatim:

> *Proof.*  After taking `1/m_i` the residual satisfies `r < 1/(m_i(m_i−1))` (the
> standard greedy remainder bound), so no index below `m_i(m_i−1)+1` can be taken.  ∎

and the status line:

> *Status:* THEOREM (proof above) + NUMERICAL (0 violations in 53 159 consecutive pairs).
> *Source:* rh47 `truths.md` §1.

## Dependencies and related results

- Definition 1.1 (the greedy rule) — definition, not harvested.
- The §5 budgets and reachable-set results of this chapter restate the material harvested from [`04-zeta-relations.md`](tpp-dict-04-even-odd-split-of-zeta.md) (Theorems 1.1–2.3 there).

## Notes

- Ledger entry: the theorem restates **rh47** `truths.md` §1, as the source states (the section heading names rh47).
- The count "53 159" is printed with a space as the thousands separator in the source and is reproduced exactly.
