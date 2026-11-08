# `proof-99-global-harmonic-framework/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`proof-99-global-harmonic-framework`](../proof-99-global-harmonic-framework/README.md)

### [`proof-99-global-harmonic-framework/lean/Topic.lean`](../proof-99-global-harmonic-framework/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [44](../proof-99-global-harmonic-framework/lean/Topic.lean#L44) | theorem | `a_pos` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ 0<a\ n$ |
| [52](../proof-99-global-harmonic-framework/lean/Topic.lean#L52) | theorem | `b_pos` | $\forall\,n : \mathbb{N},\ 0<b\ n$ |
| [60](../proof-99-global-harmonic-framework/lean/Topic.lean#L60) | theorem | `b_lt_a` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ b\ n<a\ n$ |
| [75](../proof-99-global-harmonic-framework/lean/Topic.lean#L75) | theorem | `telescoping` | $\forall\,N : \mathbb{N},\ \mathrm{Finset.sum}(\mathrm{Finset.range}\ N)(\lambda\ k:\mathbb{N}\Rightarrow(1:\mathbb{R})/(((k:\mathbb{R})+1)\cdot((k:\mathbb{R})+2)))=(N:\mathbb{R})/((N:\mathbb{R})+1)$ |
| [91](../proof-99-global-harmonic-framework/lean/Topic.lean#L91) | theorem | `telescoping_tendsto` | $:\mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{Finset.sum}(\mathrm{Finset.range}\ N)(\lambda\ k:\mathbb{N}\Rightarrow(1:\mathbb{R})/(((k:\mathbb{R})+1)\cdot((k:\mathbb{R})+2))))\ \mathrm{atTop}(\mathcal{N}\ 1)$ |
| [115](../proof-99-global-harmonic-framework/lean/Topic.lean#L115) | theorem | `det_rank_one` | $\forall\,N : \mathbb{N},\ \forall\,u\,v : \mathrm{Fin}\ N\to\ \mathbb{R},\ (1+\mathrm{Matrix.replicateCol}\ \mathrm{PUnit}\ u\cdot\ \mathrm{Matrix.replicateRow}\ \mathrm{PUnit}\ v).\mathrm{det}=1+\sum\ i,\ v\ i\cdot\ u\ i$ |
| [126](../proof-99-global-harmonic-framework/lean/Topic.lean#L126) | theorem | `det_diagonal_sq_pos` | $\forall\,N : \mathbb{N},\ \forall\,d : \mathrm{Fin}\ N\to\ \mathbb{R},\ \forall\,hd : \forall\ i,\ 0<d\ i,\ 0<(\mathrm{Matrix.diagonal}\ d\cdot\ \mathrm{Matrix.diagonal}\ d).\mathrm{det}$ |
