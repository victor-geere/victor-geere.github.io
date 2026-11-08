# `greedy-harmonic-hilbert-polya/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`greedy-harmonic-hilbert-polya`](../greedy-harmonic-hilbert-polya/README.md)

### [`greedy-harmonic-hilbert-polya/lean/Topic.lean`](../greedy-harmonic-hilbert-polya/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [56](../greedy-harmonic-hilbert-polya/lean/Topic.lean#L56) | theorem | `disc0_pos` | $:0<\mathrm{disc0}$ |
| [61](../greedy-harmonic-hilbert-polya/lean/Topic.lean#L61) | theorem | `Q0_roots` | $:\mathrm{Q0}((3+\mathrm{Real.sqrt}\ 5)/4)=0\ \land\ \mathrm{Q0}((3-\mathrm{Real.sqrt}\ 5)/4)=0$ |
| [67](../greedy-harmonic-hilbert-polya/lean/Topic.lean#L67) | theorem | `Q_const_pos` | $\forall\,n : \mathbb{N},\ 0<(2\cdot(n:\mathbb{R})+3)/(((n:\mathbb{R})+1)\cdot((n:\mathbb{R})+2)^{2})$ |
| [72](../greedy-harmonic-hilbert-polya/lean/Topic.lean#L72) | theorem | `Q_discriminant` | $\forall\,n : \mathbb{N},\ \mathrm{disc}\ n=((2\cdot(n:\mathbb{R})+3)\cdot(2\cdot(n:\mathbb{R})^{2}+5\cdot(n:\mathbb{R})-1))/(((n:\mathbb{R})+1)\cdot((n:\mathbb{R})+2)^{2})$ |
| [82](../greedy-harmonic-hilbert-polya/lean/Topic.lean#L82) | theorem | `Q_discriminant_pos` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ 0<\mathrm{disc}\ n$ |
| [95](../greedy-harmonic-hilbert-polya/lean/Topic.lean#L95) | theorem | `Q_roots` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ Q\ n(\mathrm{lamPlus}\ n)=0\ \land\ Q\ n(\mathrm{lamMinus}\ n)=0$ |
| [125](../greedy-harmonic-hilbert-polya/lean/Topic.lean#L125) | theorem | `Q_vieta` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \mathrm{lamPlus}\ n+\mathrm{lamMinus}\ n=(2\cdot(n:\mathbb{R})+3)/((n:\mathbb{R})+2)\ \land\ \mathrm{lamPlus}\ n\cdot\ \mathrm{lamMinus}\ n=(2\cdot(n:\mathbb{R})+3)/(((n:\mathbb{R})+1)\cdot((n:\mathbb{R})+2)^{2})$ |
