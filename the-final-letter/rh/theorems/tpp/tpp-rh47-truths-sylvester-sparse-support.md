# the greedy support is Sylvester-sparse: `m_{i+1} ≥ m_i (m_i − 1) + 1`

**Kind:** Theorem
**Status:** PROVED (paper argument; the section heading tags it "PROVED/VERIFIED", the numerical leg being the two consequences)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §1 "The new structural fact: the greedy support is Sylvester-sparse (PROVED/VERIFIED)", line 21

## Statement

> **Theorem.**  Let `A(x) ⊂ {2,3,4,…}` be the support of the greedy word (take `1/m` iff `r ≥ 1/m`).  Listing `A = {m₁ < m₂ < …}`,
>
> ```
> m_{i+1} ≥ m_i (m_i − 1) + 1 .
> ```

## Hypotheses and notation

- The greedy word is built on the harmonic alphabet: the term `1/m` is taken iff the running residual `r` satisfies `r ≥ 1/m`; no index is reused.
- `A(x) ⊂ {2,3,4,…}` is the **support** of the greedy word — the set of taken indices.
- `A = {m₁ < m₂ < …}` lists the support in increasing order, so `m_i` is its `i`-th element.
- `r` is the residual remaining after the terms taken so far.

## Proof / evidence

The source's own proof sketch:

> *Proof sketch.*  After taking `1/m_i` the residual is `r < 1/(m_i(m_i−1))`, so no index below `m_i(m_i−1)+1` can be taken.  ∎

## Dependencies and related results

- Consequences harvested separately: [`|A| ≥ 20` forces `max A ≥ s₂₀`](tpp-rh47-truths-max-support-sylvester-bound.md) and [the support density](tpp-rh47-truths-support-density-3-9e-5.md), both tagged by the source "VERIFIED numerically, 0 violations in 53 159 consecutive pairs".
- Restated elsewhere in this round: [README §1.5](tpp-rh47-readme-sylvester-sparse-support.md), [HANDOFF H1](tpp-rh47-handoff-h1-sylvester-sparse-support.md).
- Earlier ledger entry citing this same result: [the support is Sylvester-sparse](tpp-dict-00-sylvester-sparse-support.md) (dictionary row B7, whose source column is "rh47 `truths.md` §1").
- The same section invokes this fact to argue that the round's specified test (`|A| ≥ 20`) has an **empty domain** — recorded in the consequence file.

## Notes

- This is the round's own new structural fact ("**Theorem.**" at the head of truths.md §1).
- The section heading reads "PROVED/VERIFIED"; the one-line residual argument is the proof, and the numerical tag belongs to the consequences, not to the inequality itself.
- The source's phrasing of the take rule is `1/m` iff `r ≥ 1/m`; the notation `A(x)` records the dependence on the target `x`.
