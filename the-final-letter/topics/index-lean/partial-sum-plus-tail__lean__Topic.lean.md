# `partial-sum-plus-tail/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md)

### [`partial-sum-plus-tail/lean/Topic.lean`](../partial-sum-plus-tail/lean/Topic.lean) — 10 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [28](../partial-sum-plus-tail/lean/Topic.lean#L28) | theorem | `tsum_eq_finite_add_tail` | $\forall\,f : \mathbb{N}\to\ \mathbb{k},\ \forall\,hf : \mathrm{Summable}\ f,\ \forall\,K : \mathbb{N},\ \sum'\ n,\ f\ n=\sum\ n\ \in\ \mathrm{Finset.range}\ K,\ f\ n+\sum'\ n,\ f(n+K)$ |
| [33](../partial-sum-plus-tail/lean/Topic.lean#L33) | theorem | `truncation_residual_le_tail_norm` | $\forall\,f : \mathbb{N}\to\ \mathbb{k},\ \forall\,hf : \mathrm{Summable}\ f,\ \forall\,K : \mathbb{N},\ \Vert(\sum'\ n,\ f\ n)-\sum\ n\ \in\ \mathrm{Finset.range}\ K,\ f\ n\Vert\le\ \sum'\ n,\ \Vert{}f(n+K)\Vert$ |
| [42](../partial-sum-plus-tail/lean/Topic.lean#L42) | theorem | `truncation_residual_le_finset_tail_norm` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{DecidableEq}\ \iota],\ \forall\,s : \mathrm{Finset}\ \iota,\ \forall\,tail : \iota\to\ \mathbb{k},\ \forall\,lhs\,computed : \mathbb{k},\ \forall\,hsplit : \mathrm{lhs}=\mathrm{computed}+\sum\ i\ \in\ s,\ \mathrm{tail}\ i,\ \Vert{}\mathrm{lhs}-\mathrm{computed}\Vert\le\ \sum\ i\ \in\ s,\ \Vert{}\mathrm{tail}\ i\Vert$ |
| [61](../partial-sum-plus-tail/lean/Topic.lean#L61) | theorem | `truncation_residual_le_three_tails` | $\forall\,lhs\,rhsTrue\,rhsComputed\,zeroTail\,primeTail\,archTail : \mathbb{k},\ \forall\,hlhs : \mathrm{lhs}=\mathrm{rhsTrue},\ \forall\,hsplit : \mathrm{rhsTrue}=\mathrm{rhsComputed}+(\mathrm{zeroTail}+\mathrm{primeTail}+\mathrm{archTail}),\ \Vert{}\mathrm{lhs}-\mathrm{rhsComputed}\Vert\le\ \Vert{}\mathrm{zeroTail}\Vert+\Vert{}\mathrm{primeTail}\Vert+\Vert{}\mathrm{archTail}\Vert$ |
| [97](../partial-sum-plus-tail/lean/Topic.lean#L97) | theorem | `negOne_pow_im` | $\forall\,n : \mathbb{N},\ ((-1:\mathbb{C})^{n}).\mathrm{im}=0$ |
| [103](../partial-sum-plus-tail/lean/Topic.lean#L103) | theorem | `negOne_pow_re` | $\forall\,n : \mathbb{N},\ ((-1:\mathbb{C})^{n}).\mathrm{re}=(-1:\mathbb{R})^{n}$ |
| [109](../partial-sum-plus-tail/lean/Topic.lean#L109) | theorem | `etaTerm_re` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \forall\,\sigma\,t : \mathbb{R},\ (\mathrm{Complex.exp}(-(\sigma+t\cdot\ \mathrm{Complex}.I)\cdot(\mathrm{Real.log}(n:\mathbb{R}):\mathbb{C}))).\mathrm{re}=(n:\mathbb{R})^{-\sigma}\cdot\ \mathrm{Real.cos}(t\cdot\ \mathrm{Real.log}(n:\mathbb{R}))$ |
| [129](../partial-sum-plus-tail/lean/Topic.lean#L129) | theorem | `etaTerm_im` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \forall\,\sigma\,t : \mathbb{R},\ (\mathrm{Complex.exp}(-(\sigma+t\cdot\ \mathrm{Complex}.I)\cdot(\mathrm{Real.log}(n:\mathbb{R}):\mathbb{C}))).\mathrm{im}=-((n:\mathbb{R})^{-\sigma}\cdot\ \mathrm{Real.sin}(t\cdot\ \mathrm{Real.log}(n:\mathbb{R})))$ |
| [150](../partial-sum-plus-tail/lean/Topic.lean#L150) | theorem | `etaPartial_re` | $\forall\,M : \mathbb{N},\ \forall\,\sigma\,t : \mathbb{R},\ (\mathrm{etaPartial}\ M(\sigma+t\cdot\ \mathrm{Complex}.I)).\mathrm{re}=\mathrm{etaCos}\ M\ \sigma\ t$ |
| [161](../partial-sum-plus-tail/lean/Topic.lean#L161) | theorem | `etaPartial_im` | $\forall\,M : \mathbb{N},\ \forall\,\sigma\,t : \mathbb{R},\ (\mathrm{etaPartial}\ M(\sigma+t\cdot\ \mathrm{Complex}.I)).\mathrm{im}=-\mathrm{etaSin}\ M\ \sigma\ t$ |
