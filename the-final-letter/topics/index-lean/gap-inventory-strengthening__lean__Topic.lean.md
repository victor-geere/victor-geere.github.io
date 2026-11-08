# `gap-inventory-strengthening/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`gap-inventory-strengthening`](../gap-inventory-strengthening/README.md)

### [`gap-inventory-strengthening/lean/Topic.lean`](../gap-inventory-strengthening/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [42](../gap-inventory-strengthening/lean/Topic.lean#L42) | theorem | `chord_product` | $\forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ \forall\,s : \mathbb{R},\ \mathrm{chord}\ N\ s\cdot\ \mathrm{chord}\ N(1-s)=\mathrm{chordClosed}\ N$ |
| [56](../gap-inventory-strengthening/lean/Topic.lean#L56) | theorem | `chord_one` | $\forall\,s : \mathbb{R},\ \mathrm{chord}\ 1\ s=0$ |
| [61](../gap-inventory-strengthening/lean/Topic.lean#L61) | theorem | `chord_half` | $\forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ \mathrm{chord}\ N(1/2)=(1-(N:\mathbb{R}))/(2\cdot(N:\mathbb{R}))$ |
| [71](../gap-inventory-strengthening/lean/Topic.lean#L71) | theorem | `chord_product_pos` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ 0<\mathrm{chordClosed}\ N$ |
| [82](../gap-inventory-strengthening/lean/Topic.lean#L82) | theorem | `chord_product_quarter` | $\forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ \mathrm{chordClosed}\ N=1/4-1/(2\cdot(N:\mathbb{R}))+1/(4\cdot(N:\mathbb{R})^{2})$ |
| [93](../gap-inventory-strengthening/lean/Topic.lean#L93) | theorem | `chord_product_tendsto` | $:\mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{chordClosed}\ N)\ \mathrm{atTop}(\mathcal{N}(1/4))$ |
| [117](../gap-inventory-strengthening/lean/Topic.lean#L117) | theorem | `pole_dichotomy` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,\delta : \mathbb{R},\ \forall\,h\delta : 0<\delta,\ \mathrm{north}\ N\ \delta\cdot\ \mathrm{south}\ N\ \delta=1\ \land\ \mathrm{north}\ N\ \delta<1\ \land\ 1<\mathrm{south}\ N\ \delta$ |
