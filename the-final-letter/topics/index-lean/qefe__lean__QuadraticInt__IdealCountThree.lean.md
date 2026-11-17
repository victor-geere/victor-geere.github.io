# `qefe/lean/QuadraticInt/IdealCountThree.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/IdealCountThree.lean`](../qefe/lean/QuadraticInt/IdealCountThree.lean) — 16 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [23](../qefe/lean/QuadraticInt/IdealCountThree.lean#L23) | lemma | `eisensteinBasis_zero` | $:\mathrm{eisensteinBasis}\ 0=(1:\mathrm{EisensteinInt})$ |
| [27](../qefe/lean/QuadraticInt/IdealCountThree.lean#L27) | lemma | `eisensteinBasis_one` | $:\mathrm{eisensteinBasis}\ 1=\mathrm{omega}$ |
| [31](../qefe/lean/QuadraticInt/IdealCountThree.lean#L31) | lemma | `repr_eisenstein_zero` | $\forall\,z : \mathrm{EisensteinInt},\ \mathrm{eisensteinBasis.repr}\ z\ 0=z.\mathrm{re}$ |
| [38](../qefe/lean/QuadraticInt/IdealCountThree.lean#L38) | lemma | `repr_eisenstein_one` | $\forall\,z : \mathrm{EisensteinInt},\ \mathrm{eisensteinBasis.repr}\ z\ 1=z.\mathrm{im}$ |
| [46](../qefe/lean/QuadraticInt/IdealCountThree.lean#L46) | lemma | `algebra_norm_three` | $\forall\,z : \mathrm{EisensteinInt},\ \mathrm{Algebra.norm}\ \mathbb{Z}\ z=\mathrm{normE}\ z$ |
| [62](../qefe/lean/QuadraticInt/IdealCountThree.lean#L62) | lemma | `absNorm_span_three` | $\forall\,z : \mathrm{EisensteinInt},\ \mathrm{Ideal.absNorm}(\mathrm{Ideal.span}\ \{z\})=(\mathrm{normE}\ z).\mathrm{natAbs}$ |
| [77](../qefe/lean/QuadraticInt/IdealCountThree.lean#L77) | lemma | `unitsSix_fintype_card` | $:\mathrm{Fintype.card}\ \mathrm{EisensteinInt}\text{ˣ}=6$ |
| [90](../qefe/lean/QuadraticInt/IdealCountThree.lean#L90) | lemma | `normElementsSmulThree_def` | $\forall\,n : \mathbb{N},\ \forall\,u : \mathrm{EisensteinInt}\text{ˣ},\ \forall\,z : \mathrm{NormElementsThree}\ n,\ (\mathrm{normElementsSmulThree}\ n\ u\ z).\mathrm{val}=(u:\mathrm{EisensteinInt})\cdot\ z.\mathrm{val}$ |
| [107](../qefe/lean/QuadraticInt/IdealCountThree.lean#L107) | lemma | `normElementsThree_ne_zero` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \forall\,z : \mathrm{NormElementsThree}\ n,\ z.\mathrm{val}\ne\ 0$ |
| [115](../qefe/lean/QuadraticInt/IdealCountThree.lean#L115) | lemma | `normElementsThree_smul_eq_self_iff` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \forall\,u : \mathrm{EisensteinInt}\text{ˣ},\ \forall\,z : \mathrm{NormElementsThree}\ n,\ u\ \bullet\ z=z\leftrightarrow\ u=1$ |
| [148](../qefe/lean/QuadraticInt/IdealCountThree.lean#L148) | lemma | `normElementsToPairThree_pairTo` | $\forall\,n : \mathbb{N},\ \forall\,p : \{p:\mathbb{Z}\times\ \mathbb{Z}//p.\mathrm{1}^{2}-p.\mathrm{1}\cdot\ p.\mathrm{2}+p.\mathrm{2}^{2}=(n:\mathbb{Z})\},\ \mathrm{normElementsToPairThree}\ n(\mathrm{pairToNormElementsThree}\ n\ p)=p$ |
| [154](../qefe/lean/QuadraticInt/IdealCountThree.lean#L154) | lemma | `pairToNormElementsThree_normElementsToPair` | $\forall\,n : \mathbb{N},\ \forall\,z : \mathrm{NormElementsThree}\ n,\ \mathrm{pairToNormElementsThree}\ n(\mathrm{normElementsToPairThree}\ n\ z)=z$ |
| [191](../qefe/lean/QuadraticInt/IdealCountThree.lean#L191) | lemma | `normElementsThree_card_eq_six_mul_orbits` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \mathrm{Nat.card}(\mathrm{NormElementsThree}\ n)=6\cdot\ \mathrm{Nat.card}(\mathrm{Quotient}(\mathrm{MulAction.orbitRel}\ \mathrm{EisensteinInt}\text{ˣ}(\mathrm{NormElementsThree}\ n)))$ |
| [218](../qefe/lean/QuadraticInt/IdealCountThree.lean#L218) | lemma | `span_eq_iff_associated_three` | $\forall\,x\,y : \mathrm{EisensteinInt},\ \mathrm{Ideal.span}(\{x\}:\mathrm{Set}\ \mathrm{EisensteinInt})=\mathrm{Ideal.span}(\{y\}:\mathrm{Set}\ \mathrm{EisensteinInt})\leftrightarrow\ \mathrm{Associated}\ x\ y$ |
| [223](../qefe/lean/QuadraticInt/IdealCountThree.lean#L223) | lemma | `absNorm_span_three_of_norm` | $\forall\,n : \mathbb{N},\ \forall\,z : \mathrm{EisensteinInt},\ \forall\,hz : (\mathrm{normE}\ z).\mathrm{natAbs}=n,\ \mathrm{Ideal.absNorm}(\mathrm{Ideal.span}\ \{z\})=n$ |
| [290](../qefe/lean/QuadraticInt/IdealCountThree.lean#L290) | theorem | `normElementsThree_card_eq_six_mul_idealCount` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \mathrm{Nat.card}(\mathrm{NormElementsThree}\ n)=6\cdot\ \mathrm{Nat.card}\ \{I:\mathrm{Ideal}\ \mathrm{EisensteinInt}//\mathrm{Ideal.absNorm}\ I=n\}$ |
