# `phase-interference/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`phase-interference`](../phase-interference/README.md)

### [`phase-interference/lean/Topic.lean`](../phase-interference/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [25](../phase-interference/lean/Topic.lean#L25) | theorem | `phase_norm` | $\forall\,n : \mathbb{N},\ \forall\,t : \mathbb{R},\ \Vert{}\mathrm{phase}\ n\ t\Vert=1$ |
| [29](../phase-interference/lean/Topic.lean#L29) | theorem | `phase_zero` | $\forall\,n : \mathbb{N},\ \mathrm{phase}\ n\ 0=1$ |
| [32](../phase-interference/lean/Topic.lean#L32) | theorem | `phase_conj` | $\forall\,n : \mathbb{N},\ \forall\,t : \mathbb{R},\ (\mathrm{starRingEnd}\ \mathbb{C})(\mathrm{phase}\ n\ t)=\mathrm{phase}\ n(-t)$ |
| [39](../phase-interference/lean/Topic.lean#L39) | theorem | `weighted_comm` | $\forall\,K : \mathbb{R},\ \forall\,n\,m : \mathbb{N},\ \forall\,t : \mathbb{R},\ \mathrm{weighted}\ K\ n\ m\ t=\mathrm{weighted}\ K\ m\ n\ t$ |
| [44](../phase-interference/lean/Topic.lean#L44) | theorem | `weighted_conj` | $\forall\,K : \mathbb{R},\ \forall\,n\,m : \mathbb{N},\ \forall\,t : \mathbb{R},\ (\mathrm{starRingEnd}\ \mathbb{C})(\mathrm{weighted}\ K\ n\ m\ t)=\mathrm{weighted}\ K\ n\ m(-t)$ |
| [51](../phase-interference/lean/Topic.lean#L51) | theorem | `weighted_norm` | $\forall\,K : \mathbb{R},\ \forall\,n\,m : \mathbb{N},\ \forall\,t : \mathbb{R},\ \Vert{}\mathrm{weighted}\ K\ n\ m\ t\Vert=\vert{}K\vert$ |
| [57](../phase-interference/lean/Topic.lean#L57) | theorem | `phase_add_norm_le` | $\forall\,n\,m : \mathbb{N},\ \forall\,t : \mathbb{R},\ \Vert{}\mathrm{phase}\ n\ t+\mathrm{phase}\ m\ t\Vert\le\ 2$ |
