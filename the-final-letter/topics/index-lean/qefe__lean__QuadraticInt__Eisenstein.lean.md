# `qefe/lean/QuadraticInt/Eisenstein.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/Eisenstein.lean`](../qefe/lean/QuadraticInt/Eisenstein.lean) — 55 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [40](../qefe/lean/QuadraticInt/Eisenstein.lean#L40) | theorem | `re_zero` | $:(0:\mathrm{EisensteinInt}).\mathrm{re}=0$ |
| [41](../qefe/lean/QuadraticInt/Eisenstein.lean#L41) | theorem | `im_zero` | $:(0:\mathrm{EisensteinInt}).\mathrm{im}=0$ |
| [42](../qefe/lean/QuadraticInt/Eisenstein.lean#L42) | theorem | `re_one` | $:(1:\mathrm{EisensteinInt}).\mathrm{re}=1$ |
| [43](../qefe/lean/QuadraticInt/Eisenstein.lean#L43) | theorem | `im_one` | $:(1:\mathrm{EisensteinInt}).\mathrm{im}=0$ |
| [44](../qefe/lean/QuadraticInt/Eisenstein.lean#L44) | theorem | `re_add` | $\forall\,z\,w : \mathrm{EisensteinInt},\ (z+w).\mathrm{re}=z.\mathrm{re}+w.\mathrm{re}$ |
| [45](../qefe/lean/QuadraticInt/Eisenstein.lean#L45) | theorem | `im_add` | $\forall\,z\,w : \mathrm{EisensteinInt},\ (z+w).\mathrm{im}=z.\mathrm{im}+w.\mathrm{im}$ |
| [46](../qefe/lean/QuadraticInt/Eisenstein.lean#L46) | theorem | `re_neg` | $\forall\,z : \mathrm{EisensteinInt},\ (-z).\mathrm{re}=-z.\mathrm{re}$ |
| [47](../qefe/lean/QuadraticInt/Eisenstein.lean#L47) | theorem | `im_neg` | $\forall\,z : \mathrm{EisensteinInt},\ (-z).\mathrm{im}=-z.\mathrm{im}$ |
| [48](../qefe/lean/QuadraticInt/Eisenstein.lean#L48) | theorem | `re_mul` | $\forall\,z\,w : \mathrm{EisensteinInt},\ (z\cdot\ w).\mathrm{re}=z.\mathrm{re}\cdot\ w.\mathrm{re}-z.\mathrm{im}\cdot\ w.\mathrm{im}$ |
| [50](../qefe/lean/QuadraticInt/Eisenstein.lean#L50) | theorem | `im_mul` | $\forall\,z\,w : \mathrm{EisensteinInt},\ (z\cdot\ w).\mathrm{im}=z.\mathrm{re}\cdot\ w.\mathrm{im}+z.\mathrm{im}\cdot\ w.\mathrm{re}-z.\mathrm{im}\cdot\ w.\mathrm{im}$ |
| [66](../qefe/lean/QuadraticInt/Eisenstein.lean#L66) | theorem | `re_sub` | $\forall\,z\,w : \mathrm{EisensteinInt},\ (z-w).\mathrm{re}=z.\mathrm{re}-w.\mathrm{re}$ |
| [69](../qefe/lean/QuadraticInt/Eisenstein.lean#L69) | theorem | `im_sub` | $\forall\,z\,w : \mathrm{EisensteinInt},\ (z-w).\mathrm{im}=z.\mathrm{im}-w.\mathrm{im}$ |
| [92](../qefe/lean/QuadraticInt/Eisenstein.lean#L92) | theorem | `re_mk` | $\forall\,a\,b : \mathbb{Z},\ (\langle{}a,\ b\rangle:\mathrm{EisensteinInt}).\mathrm{re}=a$ |
| [93](../qefe/lean/QuadraticInt/Eisenstein.lean#L93) | theorem | `im_mk` | $\forall\,a\,b : \mathbb{Z},\ (\langle{}a,\ b\rangle:\mathrm{EisensteinInt}).\mathrm{im}=b$ |
| [94](../qefe/lean/QuadraticInt/Eisenstein.lean#L94) | theorem | `re_intCast` | $\forall\,n : \mathbb{Z},\ (n:\mathrm{EisensteinInt}).\mathrm{re}=n$ |
| [95](../qefe/lean/QuadraticInt/Eisenstein.lean#L95) | theorem | `im_intCast` | $\forall\,n : \mathbb{Z},\ (n:\mathrm{EisensteinInt}).\mathrm{im}=0$ |
| [96](../qefe/lean/QuadraticInt/Eisenstein.lean#L96) | theorem | `re_natCast` | $\forall\,n : \mathbb{N},\ (n:\mathrm{EisensteinInt}).\mathrm{re}=(n:\mathbb{Z})$ |
| [97](../qefe/lean/QuadraticInt/Eisenstein.lean#L97) | theorem | `im_natCast` | $\forall\,n : \mathbb{N},\ (n:\mathrm{EisensteinInt}).\mathrm{im}=0$ |
| [110](../qefe/lean/QuadraticInt/Eisenstein.lean#L110) | theorem | `re_omega` | $:\mathrm{omega.re}=0$ |
| [111](../qefe/lean/QuadraticInt/Eisenstein.lean#L111) | theorem | `im_omega` | $:\mathrm{omega.im}=1$ |
| [114](../qefe/lean/QuadraticInt/Eisenstein.lean#L114) | theorem | `omega_sq` | $:\mathrm{omega}^{2}=-1-\mathrm{omega}$ |
| [117](../qefe/lean/QuadraticInt/Eisenstein.lean#L117) | theorem | `omega_sq_add_omega_add_one` | $:\mathrm{omega}^{2}+\mathrm{omega}+1=0$ |
| [126](../qefe/lean/QuadraticInt/Eisenstein.lean#L126) | theorem | `star_mk` | $\forall\,a\,b : \mathbb{Z},\ \mathrm{star}(\langle{}a,\ b\rangle:\mathrm{EisensteinInt})=\langle{}a-b,-b\rangle$ |
| [127](../qefe/lean/QuadraticInt/Eisenstein.lean#L127) | theorem | `re_star` | $\forall\,z : \mathrm{EisensteinInt},\ (\mathrm{star}\ z).\mathrm{re}=z.\mathrm{re}-z.\mathrm{im}$ |
| [128](../qefe/lean/QuadraticInt/Eisenstein.lean#L128) | theorem | `im_star` | $\forall\,z : \mathrm{EisensteinInt},\ (\mathrm{star}\ z).\mathrm{im}=-z.\mathrm{im}$ |
| [133](../qefe/lean/QuadraticInt/Eisenstein.lean#L133) | theorem | `normE_mk` | $\forall\,a\,b : \mathbb{Z},\ \mathrm{normE}(\langle{}a,\ b\rangle:\mathrm{EisensteinInt})=a^{2}-a\cdot\ b+b^{2}$ |
| [136](../qefe/lean/QuadraticInt/Eisenstein.lean#L136) | theorem | `normE_mul` | $\forall\,z\,w : \mathrm{EisensteinInt},\ \mathrm{normE}(z\cdot\ w)=\mathrm{normE}\ z\cdot\ \mathrm{normE}\ w$ |
| [139](../qefe/lean/QuadraticInt/Eisenstein.lean#L139) | theorem | `normE_zero` | $:\mathrm{normE}(0:\mathrm{EisensteinInt})=0$ |
| [141](../qefe/lean/QuadraticInt/Eisenstein.lean#L141) | theorem | `normE_one` | $:\mathrm{normE}(1:\mathrm{EisensteinInt})=1$ |
| [143](../qefe/lean/QuadraticInt/Eisenstein.lean#L143) | theorem | `normE_nonneg` | $\forall\,z : \mathrm{EisensteinInt},\ 0\le\ \mathrm{normE}\ z$ |
| [148](../qefe/lean/QuadraticInt/Eisenstein.lean#L148) | theorem | `normE_eq_zero_iff` | $\forall\,z : \mathrm{EisensteinInt},\ \mathrm{normE}\ z=0\leftrightarrow\ z=0$ |
| [161](../qefe/lean/QuadraticInt/Eisenstein.lean#L161) | theorem | `normE_pos` | $\forall\,z : \mathrm{EisensteinInt},\ \forall\,hz : z\ne\ 0,\ 0<\mathrm{normE}\ z$ |
| [167](../qefe/lean/QuadraticInt/Eisenstein.lean#L167) | theorem | `mul_star` | $\forall\,z : \mathrm{EisensteinInt},\ z\cdot\ \mathrm{star}\ z=(\mathrm{normE}\ z:\mathrm{EisensteinInt})$ |
| [178](../qefe/lean/QuadraticInt/Eisenstein.lean#L178) | lemma | `basisVec_linInd` | $:\mathrm{LinearIndependent}\ \mathbb{Z}\ \mathrm{basisVec}$ |
| [188](../qefe/lean/QuadraticInt/Eisenstein.lean#L188) | lemma | `basisVec_span` | $:\top\le\ \mathrm{Submodule.span}\ \mathbb{Z}(\mathrm{Set.range}\ \mathrm{basisVec})$ |
| [205](../qefe/lean/QuadraticInt/Eisenstein.lean#L205) | theorem | `isUnit_iff_normE_eq_one` | $\forall\,z : \mathrm{EisensteinInt},\ \mathrm{IsUnit}\ z\leftrightarrow\ \mathrm{normE}\ z=1$ |
| [222](../qefe/lean/QuadraticInt/Eisenstein.lean#L222) | lemma | `unit_normE_eq_one` | $\forall\,u : \mathrm{EisensteinInt}\text{ˣ},\ \mathrm{normE}(u:\mathrm{EisensteinInt})=1$ |
| [227](../qefe/lean/QuadraticInt/Eisenstein.lean#L227) | theorem | `normE_eq_one_cases` | $\forall\,z : \mathrm{EisensteinInt},\ \forall\,h : \mathrm{normE}\ z=1,\ (z=1)\ \lor(z=-1)\ \lor(z=\mathrm{omega})\ \lor(z=-\mathrm{omega})\ \lor(z=-1-\mathrm{omega})\ \lor(z=1+\mathrm{omega})$ |
| [250](../qefe/lean/QuadraticInt/Eisenstein.lean#L250) | theorem | `units6_card` | $:\mathrm{units6.card}=6$ |
| [253](../qefe/lean/QuadraticInt/Eisenstein.lean#L253) | theorem | `mem_units6` | $\forall\,z : \mathrm{EisensteinInt},\ \forall\,hz : \mathrm{IsUnit}\ z,\ z\ \in\ \mathrm{units6}$ |
| [257](../qefe/lean/QuadraticInt/Eisenstein.lean#L257) | theorem | `isUnit_of_mem_units6` | $\forall\,z : \mathrm{EisensteinInt},\ \forall\,hz : z\ \in\ \mathrm{units6},\ \mathrm{IsUnit}\ z$ |
| [271](../qefe/lean/QuadraticInt/Eisenstein.lean#L271) | theorem | `units_card_six` | $:\mathrm{Nat.card}\ \mathrm{EisensteinInt}\text{ˣ}=6$ |
| [289](../qefe/lean/QuadraticInt/Eisenstein.lean#L289) | lemma | `nearest_spec` | $\forall\,q : \mathbb{Q},\ \vert{}q-(\mathrm{nearest}\ q:\mathbb{Q})\vert\le\ 1/2$ |
| [319](../qefe/lean/QuadraticInt/Eisenstein.lean#L319) | lemma | `residual_normE` | $\forall\,x\,y : \mathrm{EisensteinInt},\ \mathrm{normE}(\mathrm{residual}\ x\ y)=(\mathrm{remRe}\ x\ y)^{2}-\mathrm{remRe}\ x\ y\cdot\ \mathrm{remIm}\ x\ y+(\mathrm{remIm}\ x\ y)^{2}$ |
| [323](../qefe/lean/QuadraticInt/Eisenstein.lean#L323) | lemma | `emod_fact` | $\forall\,x\,y : \mathrm{EisensteinInt},\ \mathrm{emod}\ x\ y\cdot(\mathrm{normE}\ y:\mathrm{EisensteinInt})=y\cdot\ \mathrm{residual}\ x\ y$ |
| [341](../qefe/lean/QuadraticInt/Eisenstein.lean#L341) | lemma | `remIm_bound` | $\forall\,B\,N\,n : \mathbb{Z},\ \forall\,hN : 0<N,\ \forall\,h : \vert(B:\mathbb{Q})/(N:\mathbb{Q})-(n:\mathbb{Q})\vert\le\ 1/2,\ (2\cdot(B-n\cdot\ N))^{2}\le\ N^{2}$ |
| [362](../qefe/lean/QuadraticInt/Eisenstein.lean#L362) | lemma | `remRe_bound` | $\forall\,A\,B\,N\,m\,n : \mathbb{Z},\ \forall\,hN : 0<N,\ \forall\,h : \vert(A:\mathbb{Q})/(N:\mathbb{Q})-((B:\mathbb{Q})/(N:\mathbb{Q})-(n:\mathbb{Q}))/2-(m:\mathbb{Q})\vert\le\ 1/2,\ (2\cdot(A-m\cdot\ N)-(B-n\cdot\ N))^{2}\le\ N^{2}$ |
| [389](../qefe/lean/QuadraticInt/Eisenstein.lean#L389) | lemma | `remIm_sq_le` | $\forall\,x\,y : \mathrm{EisensteinInt},\ \forall\,hN : 0<\mathrm{normE}\ y,\ (2\cdot\ \mathrm{remIm}\ x\ y)^{2}\le(\mathrm{normE}\ y)^{2}$ |
| [394](../qefe/lean/QuadraticInt/Eisenstein.lean#L394) | lemma | `remRe_sq_le` | $\forall\,x\,y : \mathrm{EisensteinInt},\ \forall\,hN : 0<\mathrm{normE}\ y,\ (2\cdot\ \mathrm{remRe}\ x\ y-\mathrm{remIm}\ x\ y)^{2}\le(\mathrm{normE}\ y)^{2}$ |
| [399](../qefe/lean/QuadraticInt/Eisenstein.lean#L399) | lemma | `residual_bound` | $\forall\,x\,y : \mathrm{EisensteinInt},\ \forall\,hN : 0<\mathrm{normE}\ y,\ 16\cdot\ \mathrm{normE}(\mathrm{residual}\ x\ y)\le\ 7\cdot(\mathrm{normE}\ y)^{2}$ |
| [407](../qefe/lean/QuadraticInt/Eisenstein.lean#L407) | lemma | `emod_normE_lt` | $\forall\,x\,y : \mathrm{EisensteinInt},\ \forall\,hy : y\ne\ 0,\ \mathrm{normE}(\mathrm{emod}\ x\ y)<\mathrm{normE}\ y$ |
| [429](../qefe/lean/QuadraticInt/Eisenstein.lean#L429) | lemma | `normE_mul_le` | $\forall\,a\,b : \mathrm{EisensteinInt},\ \forall\,hb : b\ne\ 0,\ \mathrm{normE}\ a\le\ \mathrm{normE}(a\cdot\ b)$ |
| [441](../qefe/lean/QuadraticInt/Eisenstein.lean#L441) | lemma | `natAbs_normE_emod_lt` | $\forall\,a\,b : \mathrm{EisensteinInt},\ \forall\,hb : b\ne\ 0,\ (\mathrm{normE}(\mathrm{emod}\ a\ b)).\mathrm{natAbs}<(\mathrm{normE}\ b).\mathrm{natAbs}$ |
| [450](../qefe/lean/QuadraticInt/Eisenstein.lean#L450) | lemma | `natAbs_normE_le_mul` | $\forall\,a\,b : \mathrm{EisensteinInt},\ \forall\,hb : b\ne\ 0,\ (\mathrm{normE}\ a).\mathrm{natAbs}\le(\mathrm{normE}(a\cdot\ b)).\mathrm{natAbs}$ |
| [459](../qefe/lean/QuadraticInt/Eisenstein.lean#L459) | lemma | `ediv_zero` | $\forall\,a : \mathrm{EisensteinInt},\ \mathrm{ediv}\ a\ 0=0$ |
