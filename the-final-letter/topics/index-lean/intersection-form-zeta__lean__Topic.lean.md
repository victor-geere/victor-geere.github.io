# `intersection-form-zeta/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`intersection-form-zeta`](../intersection-form-zeta/README.md)

### [`intersection-form-zeta/lean/Topic.lean`](../intersection-form-zeta/lean/Topic.lean) — 31 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [33](../intersection-form-zeta/lean/Topic.lean#L33) | theorem | `B_comm` | $\forall\,a\,b\,c\,a'\,b'\,c' : \mathbb{Q},\ B\ a\ b\ c\ \mathrm{a'}\ \mathrm{b'}\ \mathrm{c'}=B\ \mathrm{a'}\ \mathrm{b'}\ \mathrm{c'}\ a\ b\ c$ |
| [39](../intersection-form-zeta/lean/Topic.lean#L39) | theorem | `B_self` | $\forall\,a\,b\,c : \mathbb{Q},\ B\ a\ b\ c\ a\ b\ c=2\cdot(a\cdot\ b+a\cdot\ c+b\cdot\ c)$ |
| [45](../intersection-form-zeta/lean/Topic.lean#L45) | theorem | `A_sq` | $:B\ 1\ 1\ 1\ 1\ 1\ 1=6$ |
| [49](../intersection-form-zeta/lean/Topic.lean#L49) | theorem | `A_dot` | $\forall\,a\,b\,c : \mathbb{Q},\ B\ a\ b\ c\ 1\ 1\ 1=2\cdot(a+b+c)$ |
| [55](../intersection-form-zeta/lean/Topic.lean#L55) | theorem | `hodge_inequality` | $\forall\,a\,b\,c : \mathbb{Q},\ 6\cdot\ B\ a\ b\ c\ a\ b\ c\le(B\ a\ b\ c\ 1\ 1\ 1)^{2}$ |
| [61](../intersection-form-zeta/lean/Topic.lean#L61) | theorem | `hodge_defect` | $\forall\,a\,b\,c : \mathbb{Q},\ (B\ a\ b\ c\ 1\ 1\ 1)^{2}-6\cdot\ B\ a\ b\ c\ a\ b\ c=2\cdot((a-b)^{2}+(b-c)^{2}+(c-a)^{2})$ |
| [69](../intersection-form-zeta/lean/Topic.lean#L69) | theorem | `hodge_index` | $\forall\,a\,b\,c : \mathbb{Q},\ \forall\,h : a+b+c=0,\ B\ a\ b\ c\ a\ b\ c=-(a^{2}+b^{2}+c^{2})$ |
| [79](../intersection-form-zeta/lean/Topic.lean#L79) | theorem | `hodge_index_nonpos` | $\forall\,a\,b\,c : \mathbb{Q},\ \forall\,h : a+b+c=0,\ B\ a\ b\ c\ a\ b\ c\le\ 0$ |
| [85](../intersection-form-zeta/lean/Topic.lean#L85) | theorem | `hodge_index_eq_zero` | $\forall\,a\,b\,c : \mathbb{Q},\ \forall\,h : a+b+c=0,\ B\ a\ b\ c\ a\ b\ c=0\leftrightarrow\ a=0\ \land\ b=0\ \land\ c=0$ |
| [99](../intersection-form-zeta/lean/Topic.lean#L99) | theorem | `indefinite` | $:0<B\ 1\ 1\ 0\ 1\ 1\ 0\ \land\ B\ 1(-1)\ 0\ 1(-1)\ 0<0$ |
| [104](../intersection-form-zeta/lean/Topic.lean#L104) | theorem | `A_pos` | $:0<B\ 1\ 1\ 1\ 1\ 1\ 1$ |
| [121](../intersection-form-zeta/lean/Topic.lean#L121) | theorem | `shadow_posSemidef` | $\forall\,L : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R},\ \mathrm{Matrix.PosSemidef}(L\cdot\ L^{H})$ |
| [126](../intersection-form-zeta/lean/Topic.lean#L126) | theorem | `shadow_quadratic_nonneg` | $\forall\,L : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R},\ \forall\,x : \mathrm{Fin}\ 4\to\ \mathbb{R},\ 0\le\ x\cdot{}_{v}((L\cdot\ L^{H})\cdot{}_{v}\ x)$ |
| [134](../intersection-form-zeta/lean/Topic.lean#L134) | theorem | `ldl_posDef` | $\forall\,L : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R},\ \forall\,d : \mathrm{Fin}\ 4\to\ \mathbb{R},\ \forall\,hd : \forall\ i,\ 0<d\ i,\ \forall\,hL : \mathrm{IsUnit}\ L,\ \mathrm{Matrix.PosDef}(L\cdot\ \mathrm{Matrix.diagonal}\ d\cdot\ L^{H})$ |
| [143](../intersection-form-zeta/lean/Topic.lean#L143) | theorem | `ldl_posDef_rat` | $\forall\,L : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{Q},\ \forall\,d : \mathrm{Fin}\ 4\to\ \mathbb{Q},\ \forall\,hd : \forall\ i,\ 0<d\ i,\ \forall\,hL : \mathrm{IsUnit}\ L,\ \mathrm{Matrix.PosDef}(L\cdot\ \mathrm{Matrix.diagonal}\ d\cdot\ L^{H})$ |
| [190](../intersection-form-zeta/lean/Topic.lean#L190) | theorem | `shadowD_pos` | $:\forall\ i,\ 0<\mathrm{shadowD}\ i$ |
| [194](../intersection-form-zeta/lean/Topic.lean#L194) | theorem | `shadowL_lower` | $:\mathrm{shadowL.IsLowerTriangular}$ |
| [197](../intersection-form-zeta/lean/Topic.lean#L197) | theorem | `shadowL_det` | $:\mathrm{shadowL.det}=1$ |
| [201](../intersection-form-zeta/lean/Topic.lean#L201) | theorem | `shadowL_unit` | $:\mathrm{IsUnit}\ \mathrm{shadowL}$ |
| [205](../intersection-form-zeta/lean/Topic.lean#L205) | theorem | `shadow_factor` | $:\mathrm{shadowL}\cdot\ \mathrm{diagonal}\ \mathrm{shadowD}\cdot\ \mathrm{shadowL}^{H}=\mathrm{shadowP}$ |
| [212](../intersection-form-zeta/lean/Topic.lean#L212) | theorem | `shadowP_posDef` | $:\mathrm{shadowP.PosDef}$ |
| [221](../intersection-form-zeta/lean/Topic.lean#L221) | theorem | `abs_quad_le_row_sum` | $\forall\,D : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R},\ \forall\,t : \mathbb{R},\ \forall\,hD : \forall\ i\ j,\ D\ j\ i=D\ i\ j,\ \forall\,hrow : \forall\ i,\ \sum\ j,\ \vert{}D\ i\ j\vert\le\ t,\ \forall\,x : \mathrm{Fin}\ 4\to\ \mathbb{R},\ \vert\sum\ i,\ x\ i\cdot(\sum\ j,\ D\ i\ j\cdot\ x\ j)\vert\le\ t\cdot\ \sum\ i,\ x\ i^{2}$ |
| [324](../intersection-form-zeta/lean/Topic.lean#L324) | theorem | `abs_quad_le_row_sum_rat` | $\forall\,D : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{Q},\ \forall\,t : \mathbb{Q},\ \forall\,hD : \forall\ i\ j,\ D\ j\ i=D\ i\ j,\ \forall\,hrow : \forall\ i,\ \sum\ j,\ \vert{}D\ i\ j\vert\le\ t,\ \forall\,x : \mathrm{Fin}\ 4\to\ \mathbb{Q},\ \vert\sum\ i,\ x\ i\cdot(\sum\ j,\ D\ i\ j\cdot\ x\ j)\vert\le\ t\cdot\ \sum\ i,\ x\ i^{2}$ |
| [427](../intersection-form-zeta/lean/Topic.lean#L427) | theorem | `box_ge` | $\forall\,A\,P\,E : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R},\ \forall\,t : \mathbb{R},\ \forall\,hA : A.\mathrm{IsHermitian},\ \forall\,hP : P.\mathrm{IsHermitian},\ \forall\,hrow : \forall\ i,\ \sum\ j,\ E\ i\ j\le\ t,\ \forall\,hbox : \forall\ i\ j,\ \vert{}A\ i\ j-(P+t\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R}))\ i\ j\vert\le\ E\ i\ j,\ \forall\ x,\ x\cdot{}_{v}(P\cdot{}_{v}\ x)\le\ x\cdot{}_{v}(A\cdot{}_{v}\ x)$ |
| [462](../intersection-form-zeta/lean/Topic.lean#L462) | theorem | `box_ge_rat` | $\forall\,A\,P\,E : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{Q},\ \forall\,t : \mathbb{Q},\ \forall\,hA : A.\mathrm{IsHermitian},\ \forall\,hP : P.\mathrm{IsHermitian},\ \forall\,hrow : \forall\ i,\ \sum\ j,\ E\ i\ j\le\ t,\ \forall\,hbox : \forall\ i\ j,\ \vert{}A\ i\ j-(P+t\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{Q}))\ i\ j\vert\le\ E\ i\ j,\ \forall\ x,\ x\cdot{}_{v}(P\cdot{}_{v}\ x)\le\ x\cdot{}_{v}(A\cdot{}_{v}\ x)$ |
| [497](../intersection-form-zeta/lean/Topic.lean#L497) | theorem | `posDef_of_box` | $\forall\,A\,P\,E : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R},\ \forall\,t : \mathbb{R},\ \forall\,hA : A.\mathrm{IsHermitian},\ \forall\,hP : P.\mathrm{PosDef},\ \forall\,hrow : \forall\ i,\ \sum\ j,\ E\ i\ j\le\ t,\ \forall\,hbox : \forall\ i\ j,\ \vert{}A\ i\ j-(P+t\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R}))\ i\ j\vert\le\ E\ i\ j,\ A.\mathrm{PosDef}$ |
| [516](../intersection-form-zeta/lean/Topic.lean#L516) | theorem | `posDef_of_box_rat` | $\forall\,A\,P\,E : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{Q},\ \forall\,t : \mathbb{Q},\ \forall\,hA : A.\mathrm{IsHermitian},\ \forall\,hP : P.\mathrm{PosDef},\ \forall\,hrow : \forall\ i,\ \sum\ j,\ E\ i\ j\le\ t,\ \forall\,hbox : \forall\ i\ j,\ \vert{}A\ i\ j-(P+t\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{Q}))\ i\ j\vert\le\ E\ i\ j,\ A.\mathrm{PosDef}$ |
| [575](../intersection-form-zeta/lean/Topic.lean#L575) | theorem | `shadowA_herm` | $:\mathrm{shadowA.IsHermitian}$ |
| [579](../intersection-form-zeta/lean/Topic.lean#L579) | theorem | `shadowA_mem_box` | $:\forall\ i\ j,\ \vert{}\mathrm{shadowA}\ i\ j-(\mathrm{shadowP}+\mathrm{shadowT}\ \bullet\ 1)\ i\ j\vert\le\ \mathrm{shadowE}\ i\ j$ |
| [585](../intersection-form-zeta/lean/Topic.lean#L585) | theorem | `shadowE_row` | $:\forall\ i,\ \sum\ j,\ \mathrm{shadowE}\ i\ j\le\ \mathrm{shadowT}$ |
| [589](../intersection-form-zeta/lean/Topic.lean#L589) | theorem | `shadowA_posDef` | $:\mathrm{shadowA.PosDef}$ |
