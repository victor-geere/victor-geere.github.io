# `geometric-dynamical-phase-transitions/lean/PartialSumTail.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/PartialSumTail.lean`](../geometric-dynamical-phase-transitions/lean/PartialSumTail.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [25](../geometric-dynamical-phase-transitions/lean/PartialSumTail.lean#L25) | theorem | `tsum_eq_finite_add_tail` | $\forall\,f : \mathbb{N}\to\ \mathbb{k},\ \forall\,hf : \mathrm{Summable}\ f,\ \forall\,K : \mathbb{N},\ \sum'\ n,\ f\ n=\sum\ n\ \in\ \mathrm{Finset.range}\ K,\ f\ n+\sum'\ n,\ f(n+K)$ |
| [30](../geometric-dynamical-phase-transitions/lean/PartialSumTail.lean#L30) | theorem | `truncation_residual_le_tail_norm` | $\forall\,f : \mathbb{N}\to\ \mathbb{k},\ \forall\,hf : \mathrm{Summable}\ f,\ \forall\,K : \mathbb{N},\ \Vert(\sum'\ n,\ f\ n)-\sum\ n\ \in\ \mathrm{Finset.range}\ K,\ f\ n\Vert\le\ \sum'\ n,\ \Vert{}f(n+K)\Vert$ |
| [41](../geometric-dynamical-phase-transitions/lean/PartialSumTail.lean#L41) | theorem | `truncation_residual_le_finset_tail_norm` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{DecidableEq}\ \iota],\ \forall\,s : \mathrm{Finset}\ \iota,\ \forall\,tail : \iota\to\ \mathbb{k},\ \forall\,lhs\,computed : \mathbb{k},\ \forall\,hsplit : \mathrm{lhs}=\mathrm{computed}+\sum\ i\ \in\ s,\ \mathrm{tail}\ i,\ \Vert{}\mathrm{lhs}-\mathrm{computed}\Vert\le\ \sum\ i\ \in\ s,\ \Vert{}\mathrm{tail}\ i\Vert$ |
| [60](../geometric-dynamical-phase-transitions/lean/PartialSumTail.lean#L60) | theorem | `truncation_residual_le_three_tails` | $\forall\,lhs\,rhsTrue\,rhsComputed\,zeroTail\,primeTail\,archTail : \mathbb{k},\ \forall\,hlhs : \mathrm{lhs}=\mathrm{rhsTrue},\ \forall\,hsplit : \mathrm{rhsTrue}=\mathrm{rhsComputed}+(\mathrm{zeroTail}+\mathrm{primeTail}+\mathrm{archTail}),\ \Vert{}\mathrm{lhs}-\mathrm{rhsComputed}\Vert\le\ \Vert{}\mathrm{zeroTail}\Vert+\Vert{}\mathrm{primeTail}\Vert+\Vert{}\mathrm{archTail}\Vert$ |
