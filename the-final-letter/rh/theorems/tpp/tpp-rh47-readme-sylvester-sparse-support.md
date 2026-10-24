# the greedy support is Sylvester-sparse (README §1.5)

**Kind:** Theorem
**Status:** PROVED (paper argument; restatement of rh47 `truths.md` §1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/README.md`](../../research/twin-prime-parity/rounds/rh47/README.md) — §1.5 "The round's own new result: the greedy support is Sylvester-sparse", line 34

## Statement

> **Theorem.**  If `A = {m₁ < m₂ < …}` is the greedy support, then
> `m_{i+1} ≥ m_i(m_i − 1) + 1`.  (After taking `1/m_i` the residual is
> `< 1/(m_i(m_i−1))`.)  Consequently `|A| ≥ 20 ⟹ max A ≥ s₂₀`, a **106 721-digit**
> integer: any target with a support large enough for a parity statistic has its largest
> index beyond any computable `λ`.  The support density is `≈ 3.9·10⁻⁵`.

## Hypotheses and notation

- The greedy support `A = {m₁ < m₂ < …}` of the greedy harmonic-sine word; `m_i` is its `i`-th element.
- The take rule (README §1(A)): alphabet `α_n = (−1)^n/(n+2)^p`; a term is taken iff its sign matches the residual and it does not overshoot; no reuse.
- `s₂₀` is the 20th Sylvester-sequence term; `λ` is the Liouville function.

## Proof / evidence

The README gives the residual remark as the proof and the consequence as immediate:

> (After taking `1/m_i` the residual is `< 1/(m_i(m_i−1))`.)  Consequently `|A| ≥ 20 ⟹ max A ≥ s₂₀`, a **106 721-digit** integer … The support density is `≈ 3.9·10⁻⁵`.

The same paragraph records the empty domain of the specified test:

> This is why the round's *specified* test has an **empty domain**: of 19 900 rational
> targets with denominators `≤ 200` plus 400 with denominators up to `10¹²`, **none** has
> `|A| ≥ 20`.

## Dependencies and related results

- The fuller statement with the two consequences separated: [truths.md §1](tpp-rh47-truths-sylvester-sparse-support.md), [`|A| ≥ 20 ⟹ max A ≥ s₂₀`](tpp-rh47-truths-max-support-sylvester-bound.md), [support density](tpp-rh47-truths-support-density-3-9e-5.md).
- Restated in HANDOFF as [H1](tpp-rh47-handoff-h1-sylvester-sparse-support.md).
- Earlier ledger row: [the support is Sylvester-sparse](tpp-dict-00-sylvester-sparse-support.md).

## Notes

- This is a restatement, in the README, of the round's own new result (`truths.md` §1).
- The README additionally records the relaxed-diagnostic outcome: a nominal `z = −47.9` killed by the controls (positional `z = +0.43`, rank-matched `z = +1.55`), because `m = 2` occurs in 70.5 % of supports.
