# `qefe/lean/GaussianInt/Norm.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/GaussianInt/Norm.lean`](../qefe/lean/GaussianInt/Norm.lean) — 25 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [31](../qefe/lean/GaussianInt/Norm.lean#L31) | lemma | `gaussianVec_zero` | $:\mathrm{gaussianVec}\ 0=1$ |
| [32](../qefe/lean/GaussianInt/Norm.lean#L32) | lemma | `gaussianVec_one` | $:\mathrm{gaussianVec}\ 1=(\langle0,\ 1\rangle:\mathrm{GaussianInt})$ |
| [34](../qefe/lean/GaussianInt/Norm.lean#L34) | lemma | `gaussianVec_linearIndependent` | $:\mathrm{LinearIndependent}\ \mathbb{Z}\ \mathrm{gaussianVec}$ |
| [45](../qefe/lean/GaussianInt/Norm.lean#L45) | lemma | `gaussianVec_span` | $:\top\le\ \mathrm{Submodule.span}\ \mathbb{Z}(\mathrm{Set.range}\ \mathrm{gaussianVec})$ |
| [56](../qefe/lean/GaussianInt/Norm.lean#L56) | lemma | `gaussianBasis_apply_zero` | $:\mathrm{gaussianBasis}(0:\mathrm{Fin}\ 2)=(1:\mathrm{GaussianInt})$ |
| [61](../qefe/lean/GaussianInt/Norm.lean#L61) | lemma | `gaussianBasis_apply_one` | $:\mathrm{gaussianBasis}(1:\mathrm{Fin}\ 2)=(\langle0,\ 1\rangle:\mathrm{GaussianInt})$ |
| [66](../qefe/lean/GaussianInt/Norm.lean#L66) | lemma | `repr_gaussian_zero` | $\forall\,z : \mathrm{GaussianInt},\ \mathrm{gaussianBasis.repr}\ z\ 0=z.\mathrm{re}$ |
| [73](../qefe/lean/GaussianInt/Norm.lean#L73) | lemma | `repr_gaussian_one` | $\forall\,z : \mathrm{GaussianInt},\ \mathrm{gaussianBasis.repr}\ z\ 1=z.\mathrm{im}$ |
| [81](../qefe/lean/GaussianInt/Norm.lean#L81) | lemma | `algebra_norm_gaussian` | $\forall\,z : \mathrm{GaussianInt},\ \mathrm{Algebra.norm}\ \mathbb{Z}\ z=z.\mathrm{norm}$ |
| [95](../qefe/lean/GaussianInt/Norm.lean#L95) | lemma | `absNorm_span_gaussian` | $\forall\,z : \mathrm{GaussianInt},\ \mathrm{Ideal.absNorm}(\mathrm{Ideal.span}\ \{z\})=z.\mathrm{norm}.\mathrm{natAbs}$ |
| [106](../qefe/lean/GaussianInt/Norm.lean#L106) | lemma | `gaussian_unit_norm_eq_one` | $\forall\,u : \mathrm{GaussianInt}\text{ˣ},\ (u:\mathrm{GaussianInt}).\mathrm{norm}=1$ |
| [114](../qefe/lean/GaussianInt/Norm.lean#L114) | lemma | `gaussian_unit_classification` | $\forall\,u : \mathrm{GaussianInt}\text{ˣ},\ (u:\mathrm{GaussianInt})=1\ \lor(u:\mathrm{GaussianInt})=-1\ \lor(u:\mathrm{GaussianInt})=\langle0,\ 1\rangle\ \lor(u:\mathrm{GaussianInt})=\langle0,-1\rangle$ |
| [143](../qefe/lean/GaussianInt/Norm.lean#L143) | lemma | `mem_gaussianUnits` | $\forall\,u : \mathrm{GaussianInt}\text{ˣ},\ u\ \in\ \mathrm{gaussianUnits}$ |
| [163](../qefe/lean/GaussianInt/Norm.lean#L163) | lemma | `gaussianUnits_card_four` | $:\mathrm{Nat.card}\ \mathrm{GaussianInt}\text{ˣ}=4$ |
| [177](../qefe/lean/GaussianInt/Norm.lean#L177) | lemma | `gaussian_norm_mk` | $\forall\,x\,y : \mathbb{Z},\ (\langle{}x,\ y\rangle:\mathrm{GaussianInt}).\mathrm{norm}=x^{2}+y^{2}$ |
| [198](../qefe/lean/GaussianInt/Norm.lean#L198) | lemma | `gaussianToPair_pairToGaussian` | $\forall\,n : \mathbb{N},\ \forall\,p : \{p:\mathbb{Z}\times\ \mathbb{Z}//p.\mathrm{1}^{2}+p.\mathrm{2}^{2}=(n:\mathbb{Z})\},\ \mathrm{gaussianToPair}\ n(\mathrm{pairToGaussian}\ n\ p)=p$ |
| [203](../qefe/lean/GaussianInt/Norm.lean#L203) | lemma | `pairToGaussian_gaussianToPair` | $\forall\,n : \mathbb{N},\ \forall\,z : \{z:\mathrm{GaussianInt}//z.\mathrm{norm}.\mathrm{natAbs}=n\},\ \mathrm{pairToGaussian}\ n(\mathrm{gaussianToPair}\ n\ z)=z$ |
| [216](../qefe/lean/GaussianInt/Norm.lean#L216) | lemma | `absNorm_span_gaussian_of_norm` | $\forall\,n : \mathbb{N},\ \forall\,z : \mathrm{GaussianInt},\ \forall\,hz : z.\mathrm{norm}.\mathrm{natAbs}=n,\ \mathrm{Ideal.absNorm}(\mathrm{Ideal.span}\ \{z\})=n$ |
| [222](../qefe/lean/GaussianInt/Norm.lean#L222) | lemma | `gaussian_span_eq_iff_associated` | $\forall\,x\,y : \mathrm{GaussianInt},\ \mathrm{Ideal.span}(\{x\}:\mathrm{Set}\ \mathrm{GaussianInt})=\mathrm{Ideal.span}(\{y\}:\mathrm{Set}\ \mathrm{GaussianInt})\leftrightarrow\ \mathrm{Associated}\ x\ y$ |
| [238](../qefe/lean/GaussianInt/Norm.lean#L238) | lemma | `normElementsSmul_def` | $\forall\,n : \mathbb{N},\ \forall\,u : \mathrm{GaussianInt}\text{ˣ},\ \forall\,z : \mathrm{NormElements}\ n,\ (\mathrm{normElementsSmul}\ n\ u\ z).\mathrm{val}=(u:\mathrm{GaussianInt})\cdot\ z.\mathrm{val}$ |
| [254](../qefe/lean/GaussianInt/Norm.lean#L254) | lemma | `normElements_ne_zero` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \forall\,z : \mathrm{NormElements}\ n,\ z.\mathrm{val}\ne\ 0$ |
| [263](../qefe/lean/GaussianInt/Norm.lean#L263) | lemma | `normElements_smul_eq_self_iff` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \forall\,u : \mathrm{GaussianInt}\text{ˣ},\ \forall\,z : \mathrm{NormElements}\ n,\ u\ \bullet\ z=z\leftrightarrow\ u=1$ |
| [288](../qefe/lean/GaussianInt/Norm.lean#L288) | lemma | `gaussianUnits_fintype_card` | $:\mathrm{Fintype.card}\ \mathrm{GaussianInt}\text{ˣ}=4$ |
| [314](../qefe/lean/GaussianInt/Norm.lean#L314) | lemma | `normElements_card_eq_four_mul_orbits` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \mathrm{Nat.card}(\mathrm{NormElements}\ n)=4\cdot\ \mathrm{Nat.card}(\mathrm{Quotient}(\mathrm{MulAction.orbitRel}\ \mathrm{GaussianInt}\text{ˣ}(\mathrm{NormElements}\ n)))$ |
| [406](../qefe/lean/GaussianInt/Norm.lean#L406) | theorem | `normElements_card_eq_four_mul_idealCount` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \mathrm{Nat.card}(\mathrm{NormElements}\ n)=4\cdot\ \mathrm{Nat.card}\ \{I:\mathrm{Ideal}\ \mathrm{GaussianInt}//\mathrm{Ideal.absNorm}\ I=n\}$ |
