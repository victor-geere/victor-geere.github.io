# `frozen-truths/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`frozen-truths`](../frozen-truths/README.md)

### [`frozen-truths/lean/Topic.lean`](../frozen-truths/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [39](../frozen-truths/lean/Topic.lean#L39) | theorem | `lastChord_mul_twin` | $\forall\,N : \mathbb{R},\ \forall\,hN : 0<N,\ \forall\,s : \mathbb{R},\ \mathrm{lastChord}\ N\ s\cdot\ \mathrm{lastChord}\ N(1-s)=\mathrm{lastChordSquare}\ N$ |
| [63](../frozen-truths/lean/Topic.lean#L63) | theorem | `lastChord_abs` | $\forall\,N\,s : \mathbb{R},\ \forall\,hN : 1<N,\ \vert{}\mathrm{lastChord}\ N\ s\vert=(N-1)/2\cdot\ N^{-(2\cdot\ s)}$ |
| [76](../frozen-truths/lean/Topic.lean#L76) | theorem | `lastChord_twin_abs_eq_iff` | $\forall\,N\,s : \mathbb{R},\ \forall\,hN : 1<N,\ \vert{}\mathrm{lastChord}\ N\ s\vert=\vert{}\mathrm{lastChord}\ N(1-s)\vert\leftrightarrow\ s=1/2$ |
| [93](../frozen-truths/lean/Topic.lean#L93) | theorem | `lastChord_limit` | $:\mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordSquare}(N:\mathbb{R}))\ \mathrm{atTop}(\mathcal{N}(1/4))$ |
| [117](../frozen-truths/lean/Topic.lean#L117) | theorem | `exp_neg_abs_log_ratio` | $\forall\,m\,n : \mathbb{R},\ \forall\,hm : 0<m,\ \forall\,hn : 0<n,\ \mathrm{Real.exp}(-\vert{}\mathrm{Real.log}(m/n)\vert)=\mathrm{min}\ m\ n/\mathrm{max}\ m\ n$ |
| [138](../frozen-truths/lean/Topic.lean#L138) | theorem | `cosh_weight_gt_one` | $\forall\,\alpha\,u : \mathbb{R},\ \forall\,h\alpha : \alpha\ne\ 0,\ \forall\,hu : 0<u,\ 1<\mathrm{Real.cosh}(\alpha\cdot\ u)$ |
| [144](../frozen-truths/lean/Topic.lean#L144) | theorem | `cosh_weight_even` | $\forall\,\alpha\,u : \mathbb{R},\ \mathrm{Real.cosh}(\alpha\cdot\ u)=\mathrm{Real.cosh}((-\alpha)\cdot\ u)$ |
