# `partial-sum-plus-tail/lean/IBox.lean`

[Back to the split index](index.md) · Topic: [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md)

### [`partial-sum-plus-tail/lean/IBox.lean`](../partial-sum-plus-tail/lean/IBox.lean) — 37 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [45](../partial-sum-plus-tail/lean/IBox.lean#L45) | theorem | `min4_le_left` | $\forall\,a\,b\,c\,d : \alpha,\ \mathrm{min4}\ a\ b\ c\ d\le\ a$ |
| [48](../partial-sum-plus-tail/lean/IBox.lean#L48) | theorem | `min4_le_right` | $\forall\,a\,b\,c\,d : \alpha,\ \mathrm{min4}\ a\ b\ c\ d\le\ b$ |
| [51](../partial-sum-plus-tail/lean/IBox.lean#L51) | theorem | `min4_le_third` | $\forall\,a\,b\,c\,d : \alpha,\ \mathrm{min4}\ a\ b\ c\ d\le\ c$ |
| [54](../partial-sum-plus-tail/lean/IBox.lean#L54) | theorem | `min4_le_fourth` | $\forall\,a\,b\,c\,d : \alpha,\ \mathrm{min4}\ a\ b\ c\ d\le\ d$ |
| [57](../partial-sum-plus-tail/lean/IBox.lean#L57) | theorem | `le_max4_left` | $\forall\,a\,b\,c\,d : \alpha,\ a\le\ \mathrm{max4}\ a\ b\ c\ d$ |
| [60](../partial-sum-plus-tail/lean/IBox.lean#L60) | theorem | `le_max4_right` | $\forall\,a\,b\,c\,d : \alpha,\ b\le\ \mathrm{max4}\ a\ b\ c\ d$ |
| [63](../partial-sum-plus-tail/lean/IBox.lean#L63) | theorem | `le_max4_third` | $\forall\,a\,b\,c\,d : \alpha,\ c\le\ \mathrm{max4}\ a\ b\ c\ d$ |
| [66](../partial-sum-plus-tail/lean/IBox.lean#L66) | theorem | `le_max4_fourth` | $\forall\,a\,b\,c\,d : \alpha,\ d\le\ \mathrm{max4}\ a\ b\ c\ d$ |
| [81](../partial-sum-plus-tail/lean/IBox.lean#L81) | theorem | `min_mul_endpoints` | $\forall\,a_{1}\,a_{2}\,x\,y : R,\ \forall\,h_{1} : a_{1}\le\ x,\ \forall\,h_{2} : x\le\ a_{2},\ \mathrm{min}(a_{1}\cdot\ y)(a_{2}\cdot\ y)\le\ x\cdot\ y$ |
| [89](../partial-sum-plus-tail/lean/IBox.lean#L89) | theorem | `min_mul_two` | $\forall\,x\,b_{1}\,b_{2}\,y : R,\ \forall\,h_{1} : b_{1}\le\ y,\ \forall\,h_{2} : y\le\ b_{2},\ \mathrm{min}(x\cdot\ b_{1})(x\cdot\ b_{2})\le\ x\cdot\ y$ |
| [97](../partial-sum-plus-tail/lean/IBox.lean#L97) | theorem | `mul_endpoints_le_max` | $\forall\,a_{1}\,a_{2}\,x\,y : R,\ \forall\,h_{1} : a_{1}\le\ x,\ \forall\,h_{2} : x\le\ a_{2},\ x\cdot\ y\le\ \mathrm{max}(a_{1}\cdot\ y)(a_{2}\cdot\ y)$ |
| [105](../partial-sum-plus-tail/lean/IBox.lean#L105) | theorem | `mul_le_max_two` | $\forall\,x\,b_{1}\,b_{2}\,y : R,\ \forall\,h_{1} : b_{1}\le\ y,\ \forall\,h_{2} : y\le\ b_{2},\ x\cdot\ y\le\ \mathrm{max}(x\cdot\ b_{1})(x\cdot\ b_{2})$ |
| [113](../partial-sum-plus-tail/lean/IBox.lean#L113) | theorem | `min4_mul_le` | $\forall\,a_{1}\,a_{2}\,b_{1}\,b_{2}\,x\,y : R,\ \forall\,hx_{1} : a_{1}\le\ x,\ \forall\,hx_{2} : x\le\ a_{2},\ \forall\,hy_{1} : b_{1}\le\ y,\ \forall\,hy_{2} : y\le\ b_{2},\ \mathrm{min4}(a_{1}\cdot\ b_{1})(a_{1}\cdot\ b_{2})(a_{2}\cdot\ b_{1})(a_{2}\cdot\ b_{2})\le\ x\cdot\ y$ |
| [125](../partial-sum-plus-tail/lean/IBox.lean#L125) | theorem | `mul_le_max4` | $\forall\,a_{1}\,a_{2}\,b_{1}\,b_{2}\,x\,y : R,\ \forall\,hx_{1} : a_{1}\le\ x,\ \forall\,hx_{2} : x\le\ a_{2},\ \forall\,hy_{1} : b_{1}\le\ y,\ \forall\,hy_{2} : y\le\ b_{2},\ x\cdot\ y\le\ \mathrm{max4}(a_{1}\cdot\ b_{1})(a_{1}\cdot\ b_{2})(a_{2}\cdot\ b_{1})(a_{2}\cdot\ b_{2})$ |
| [171](../partial-sum-plus-tail/lean/IBox.lean#L171) | lemma | `zero_mul` | $\forall\,A : \mathrm{Iv},\ (\langle0,\ 0\rangle:\mathrm{Iv}).\mathrm{mul}\ A=\langle0,\ 0\rangle$ |
| [174](../partial-sum-plus-tail/lean/IBox.lean#L174) | lemma | `mul_zero` | $\forall\,A : \mathrm{Iv},\ A.\mathrm{mul}(\langle0,\ 0\rangle:\mathrm{Iv})=\langle0,\ 0\rangle$ |
| [177](../partial-sum-plus-tail/lean/IBox.lean#L177) | lemma | `add_zero` | $\forall\,A : \mathrm{Iv},\ A.\mathrm{add}\ \langle0,\ 0\rangle=A$ |
| [180](../partial-sum-plus-tail/lean/IBox.lean#L180) | lemma | `zero_add` | $\forall\,A : \mathrm{Iv},\ (\langle0,\ 0\rangle:\mathrm{Iv}).\mathrm{add}\ A=A$ |
| [183](../partial-sum-plus-tail/lean/IBox.lean#L183) | lemma | `sub_zero` | $\forall\,A : \mathrm{Iv},\ A.\mathrm{sub}\ \langle0,\ 0\rangle=A$ |
| [191](../partial-sum-plus-tail/lean/IBox.lean#L191) | theorem | `mem_add` | $\forall\,x\,y : \mathbb{Q},\ \forall\,A\,B : \mathrm{Iv},\ \forall\,hx : A.\mathrm{mem}\ x,\ \forall\,hy : B.\mathrm{mem}\ y,\ (A.\mathrm{add}\ B).\mathrm{mem}(x+y)$ |
| [201](../partial-sum-plus-tail/lean/IBox.lean#L201) | theorem | `mem_neg` | $\forall\,x : \mathbb{Q},\ \forall\,A : \mathrm{Iv},\ \forall\,hx : A.\mathrm{mem}\ x,\ A.\mathrm{neg}.\mathrm{mem}(-x)$ |
| [209](../partial-sum-plus-tail/lean/IBox.lean#L209) | theorem | `mem_sub` | $\forall\,x\,y : \mathbb{Q},\ \forall\,A\,B : \mathrm{Iv},\ \forall\,hx : A.\mathrm{mem}\ x,\ \forall\,hy : B.\mathrm{mem}\ y,\ (A.\mathrm{sub}\ B).\mathrm{mem}(x-y)$ |
| [213](../partial-sum-plus-tail/lean/IBox.lean#L213) | theorem | `mem_scale` | $\forall\,q\,x : \mathbb{Q},\ \forall\,A : \mathrm{Iv},\ \forall\,hx : A.\mathrm{mem}\ x,\ (A.\mathrm{scale}\ q).\mathrm{mem}(q\cdot\ x)$ |
| [225](../partial-sum-plus-tail/lean/IBox.lean#L225) | theorem | `mem_mul` | $\forall\,x\,y : \mathbb{Q},\ \forall\,A\,B : \mathrm{Iv},\ \forall\,hx : A.\mathrm{mem}\ x,\ \forall\,hy : B.\mathrm{mem}\ y,\ (A.\mathrm{mul}\ B).\mathrm{mem}(x\cdot\ y)$ |
| [232](../partial-sum-plus-tail/lean/IBox.lean#L232) | theorem | `mem_inflate` | $\forall\,r\,x : \mathbb{Q},\ \forall\,A : \mathrm{Iv},\ \forall\,hr : 0\le\ r,\ \forall\,hx : A.\mathrm{mem}\ x,\ (A.\mathrm{inflate}\ r).\mathrm{mem}\ x$ |
| [243](../partial-sum-plus-tail/lean/IBox.lean#L243) | theorem | `memR_add` | $\forall\,x\,y : \mathbb{R},\ \forall\,A\,B : \mathrm{Iv},\ \forall\,hx : A.\mathrm{memR}\ x,\ \forall\,hy : B.\mathrm{memR}\ y,\ (A.\mathrm{add}\ B).\mathrm{memR}(x+y)$ |
| [255](../partial-sum-plus-tail/lean/IBox.lean#L255) | theorem | `memR_neg` | $\forall\,x : \mathbb{R},\ \forall\,A : \mathrm{Iv},\ \forall\,hx : A.\mathrm{memR}\ x,\ A.\mathrm{neg}.\mathrm{memR}(-x)$ |
| [265](../partial-sum-plus-tail/lean/IBox.lean#L265) | theorem | `memR_sub` | $\forall\,x\,y : \mathbb{R},\ \forall\,A\,B : \mathrm{Iv},\ \forall\,hx : A.\mathrm{memR}\ x,\ \forall\,hy : B.\mathrm{memR}\ y,\ (A.\mathrm{sub}\ B).\mathrm{memR}(x-y)$ |
| [269](../partial-sum-plus-tail/lean/IBox.lean#L269) | theorem | `memR_scale` | $\forall\,q : \mathbb{Q},\ \forall\,x : \mathbb{R},\ \forall\,A : \mathrm{Iv},\ \forall\,hx : A.\mathrm{memR}\ x,\ (A.\mathrm{scale}\ q).\mathrm{memR}((q:\mathbb{R})\cdot\ x)$ |
| [297](../partial-sum-plus-tail/lean/IBox.lean#L297) | theorem | `memR_mul` | $\forall\,x\,y : \mathbb{R},\ \forall\,A\,B : \mathrm{Iv},\ \forall\,hx : A.\mathrm{memR}\ x,\ \forall\,hy : B.\mathrm{memR}\ y,\ (A.\mathrm{mul}\ B).\mathrm{memR}(x\cdot\ y)$ |
| [309](../partial-sum-plus-tail/lean/IBox.lean#L309) | theorem | `memR_inflate` | $\forall\,r : \mathbb{Q},\ \forall\,x : \mathbb{R},\ \forall\,A : \mathrm{Iv},\ \forall\,hr : 0\le\ r,\ \forall\,hx : A.\mathrm{memR}\ x,\ (A.\mathrm{inflate}\ r).\mathrm{memR}\ x$ |
| [354](../partial-sum-plus-tail/lean/IBox.lean#L354) | theorem | `mem_add` | $\forall\,z\,w : \mathbb{C},\ \forall\,Z\,W : \mathrm{Cx},\ \forall\,hz : Z.\mathrm{mem}\ z,\ \forall\,hw : W.\mathrm{mem}\ w,\ (Z.\mathrm{add}\ W).\mathrm{mem}(z+w)$ |
| [361](../partial-sum-plus-tail/lean/IBox.lean#L361) | theorem | `mem_neg` | $\forall\,z : \mathbb{C},\ \forall\,Z : \mathrm{Cx},\ \forall\,hz : Z.\mathrm{mem}\ z,\ Z.\mathrm{neg}.\mathrm{mem}(-z)$ |
| [366](../partial-sum-plus-tail/lean/IBox.lean#L366) | theorem | `mem_sub` | $\forall\,z\,w : \mathbb{C},\ \forall\,Z\,W : \mathrm{Cx},\ \forall\,hz : Z.\mathrm{mem}\ z,\ \forall\,hw : W.\mathrm{mem}\ w,\ (Z.\mathrm{sub}\ W).\mathrm{mem}(z-w)$ |
| [370](../partial-sum-plus-tail/lean/IBox.lean#L370) | theorem | `mem_scale` | $\forall\,q : \mathbb{Q},\ \forall\,z : \mathbb{C},\ \forall\,Z : \mathrm{Cx},\ \forall\,hz : Z.\mathrm{mem}\ z,\ (Z.\mathrm{scale}\ q).\mathrm{mem}((q:\mathbb{C})\cdot\ z)$ |
| [376](../partial-sum-plus-tail/lean/IBox.lean#L376) | theorem | `mem_mul` | $\forall\,z\,w : \mathbb{C},\ \forall\,Z\,W : \mathrm{Cx},\ \forall\,hz : Z.\mathrm{mem}\ z,\ \forall\,hw : W.\mathrm{mem}\ w,\ (Z.\mathrm{mul}\ W).\mathrm{mem}(z\cdot\ w)$ |
| [387](../partial-sum-plus-tail/lean/IBox.lean#L387) | theorem | `mem_inflate` | $\forall\,r : \mathbb{Q},\ \forall\,z : \mathbb{C},\ \forall\,Z : \mathrm{Cx},\ \forall\,hr : 0\le\ r,\ \forall\,hz : Z.\mathrm{mem}\ z,\ (Z.\mathrm{inflate}\ r).\mathrm{mem}\ z$ |
