# `sinc-sine-kernel-moments/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`sinc-sine-kernel-moments`](../sinc-sine-kernel-moments/README.md)

### [`sinc-sine-kernel-moments/lean/Topic.lean`](../sinc-sine-kernel-moments/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [42](../sinc-sine-kernel-moments/lean/Topic.lean#L42) | theorem | `sincN_zero` | $:\mathrm{sincN}\ 0=1$ |
| [46](../sinc-sine-kernel-moments/lean/Topic.lean#L46) | theorem | `sincN_half` | $:\mathrm{sincN}(1/2)=2/\mathrm{Real.pi}$ |
| [55](../sinc-sine-kernel-moments/lean/Topic.lean#L55) | theorem | `sincN_int_eq_zero` | $\forall\,n : \mathbb{Z},\ \forall\,hn : n\ne\ 0,\ \mathrm{sincN}(n:\mathbb{R})=0$ |
| [66](../sinc-sine-kernel-moments/lean/Topic.lean#L66) | theorem | `sincN_pos_of_mem_Ioo` | $\forall\,x : \mathbb{R},\ \forall\,h_{0} : 0<x,\ \forall\,h_{1} : x<1,\ 0<\mathrm{sincN}\ x$ |
| [77](../sinc-sine-kernel-moments/lean/Topic.lean#L77) | theorem | `sineKernel_comm` | $\forall\,x\,y : \mathbb{R},\ \mathrm{sineKernel}\ x\ y=\mathrm{sineKernel}\ y\ x$ |
| [84](../sinc-sine-kernel-moments/lean/Topic.lean#L84) | theorem | `montgomeryF_nonneg` | $\forall\,\alpha : \mathbb{R},\ 0\le\ \mathrm{montgomeryF}\ \alpha$ |
| [94](../sinc-sine-kernel-moments/lean/Topic.lean#L94) | theorem | `kostersKernel_norm` | $\forall\,\mu\,\nu : \mathbb{R},\ \Vert{}\mathrm{kostersKernel}\ \mu\ \nu\Vert=\vert{}\mathrm{sincN}(\mu-\nu)\vert$ |
