# `eml-universal-operator/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`eml-universal-operator`](../eml-universal-operator/README.md)

### [`eml-universal-operator/lean/Topic.lean`](../eml-universal-operator/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [26](../eml-universal-operator/lean/Topic.lean#L26) | theorem | `exp_identity` | $\forall\,z : \mathbb{R},\ \mathrm{eml}\ z\ 1=\mathrm{Real.exp}\ z$ |
| [31](../eml-universal-operator/lean/Topic.lean#L31) | theorem | `unit_identity` | $:\mathrm{eml}\ 0\ 1=1$ |
| [35](../eml-universal-operator/lean/Topic.lean#L35) | theorem | `eml_eq_exp_sub_log` | $\forall\,x\,y : \mathbb{R},\ \mathrm{eml}\ x\ y=\mathrm{eml}\ x\ 1-\mathrm{Real.log}\ y$ |
| [40](../eml-universal-operator/lean/Topic.lean#L40) | theorem | `one_le_eml` | $\forall\,x : \mathbb{R},\ \forall\,hx : 0\le\ x,\ 1\le\ \mathrm{eml}\ x\ 1$ |
| [45](../eml-universal-operator/lean/Topic.lean#L45) | theorem | `strictMono_first` | $:\mathrm{StrictMono}(\lambda\ x:\mathbb{R}\Rightarrow\ \mathrm{eml}\ x\ 1)$ |
| [53](../eml-universal-operator/lean/Topic.lean#L53) | theorem | `log_identity` | $\forall\,z : \mathbb{R},\ \forall\,hz : 0<z,\ \mathrm{eml}\ 1(\mathrm{eml}(\mathrm{eml}\ 1\ z)\ 1)=\mathrm{Real.log}\ z$ |
| [64](../eml-universal-operator/lean/Topic.lean#L64) | theorem | `sqrt_identity` | $\forall\,u : \mathbb{R},\ \forall\,hu : 0<u,\ \mathrm{eml}(\mathrm{Real.log}\ u/2)\ 1=\mathrm{Real.sqrt}\ u$ |
