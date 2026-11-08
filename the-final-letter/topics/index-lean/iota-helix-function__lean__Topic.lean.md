# `iota-helix-function/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`iota-helix-function`](../iota-helix-function/README.md)

### [`iota-helix-function/lean/Topic.lean`](../iota-helix-function/lean/Topic.lean) — 9 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [48](../iota-helix-function/lean/Topic.lean#L48) | theorem | `radius_pos` | $\forall\,\sigma : \mathbb{R},\ \forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ 0<\mathrm{radius}\ \sigma\ n$ |
| [52](../iota-helix-function/lean/Topic.lean#L52) | theorem | `radius_lt_radius` | $\forall\,\sigma : \mathbb{R},\ \forall\,h\sigma : 0<\sigma,\ \forall\,m\,n : \mathbb{N},\ \forall\,hm : 0<m,\ \forall\,hmn : m<n,\ \mathrm{radius}\ \sigma\ n<\mathrm{radius}\ \sigma\ m$ |
| [57](../iota-helix-function/lean/Topic.lean#L57) | theorem | `step_length` | $\forall\,\sigma\,t : \mathbb{R},\ \forall\,n : \mathbb{N},\ \mathrm{xcoord}\ \sigma\ t\ n^{2}+\mathrm{ycoord}\ \sigma\ t\ n^{2}=\mathrm{radius}\ \sigma\ n^{2}$ |
| [67](../iota-helix-function/lean/Topic.lean#L67) | theorem | `phase_succ_sub` | $\forall\,t : \mathbb{R},\ \forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \mathrm{phase}\ t(n+1)-\mathrm{phase}\ t\ n=\mathrm{Real.pi}-t\cdot\ \mathrm{Real.log}(((n:\mathbb{R})+1)/(n:\mathbb{R}))$ |
| [79](../iota-helix-function/lean/Topic.lean#L79) | theorem | `point_one` | $\forall\,\sigma\,t : \mathbb{R},\ \mathrm{point}\ \sigma\ t\ 1=(1,\ 0,\ 1)$ |
| [83](../iota-helix-function/lean/Topic.lean#L83) | theorem | `real_axis_term` | $\forall\,\sigma : \mathbb{R},\ \forall\,n : \mathbb{N},\ \mathrm{xcoord}\ \sigma\ 0(n+1)=(-1:\mathbb{R})^{n}\cdot\ \mathrm{radius}\ \sigma(n+1)\ \land\ \mathrm{ycoord}\ \sigma\ 0(n+1)=0$ |
| [106](../iota-helix-function/lean/Topic.lean#L106) | lemma | `altSum_even` | $\forall\,a : \mathbb{N}\to\ \mathbb{R},\ \forall\,M : \mathbb{N},\ (\sum\ k\ \in\ \mathrm{Finset.range}(2\cdot\ M),(-1:\mathbb{R})^{k}\cdot\ a\ k)=\sum\ k\ \in\ \mathrm{Finset.range}\ M,(a(2\cdot\ k)-a(2\cdot\ k+1))$ |
| [119](../iota-helix-function/lean/Topic.lean#L119) | lemma | `altSum_pos` | $\forall\,a : \mathbb{N}\to\ \mathbb{R},\ \forall\,hpos : \forall\ k,\ 0<a\ k,\ \forall\,hanti : \forall\ k,\ a(k+1)<a\ k,\ \forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ 0<\sum\ k\ \in\ \mathrm{Finset.range}\ N,(-1:\mathbb{R})^{k}\cdot\ a\ k$ |
| [138](../iota-helix-function/lean/Topic.lean#L138) | theorem | `etaPartial_pos` | $\forall\,\sigma : \mathbb{R},\ \forall\,h\sigma : 0<\sigma,\ \forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ 0<\mathrm{etaPartial}\ \sigma\ N$ |
