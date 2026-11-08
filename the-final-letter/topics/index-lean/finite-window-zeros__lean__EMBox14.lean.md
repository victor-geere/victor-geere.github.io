# `finite-window-zeros/lean/EMBox14.lean`

[Back to the split index](index.md) · Topic: [`finite-window-zeros`](../finite-window-zeros/README.md)

### [`finite-window-zeros/lean/EMBox14.lean`](../finite-window-zeros/lean/EMBox14.lean) — 33 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [37](../finite-window-zeros/lean/EMBox14.lean#L37) | theorem | `mem_ptBox` | $\forall\,q\,r : \mathbb{Q},\ \forall\,z : \mathbb{C},\ \forall\,hq : z.\mathrm{re}=(q:\mathbb{R}),\ \forall\,hr : z.\mathrm{im}=(r:\mathbb{R}),\ (\mathrm{ptBox}\ q\ r).\mathrm{mem}\ z$ |
| [50](../finite-window-zeros/lean/EMBox14.lean#L50) | theorem | `inv_s14_sub_one` | $:(1:\mathbb{C})/(\mathrm{s14}-1)=((-2/785:\mathbb{R}):\mathbb{C})+((-56/785:\mathbb{R}):\mathbb{C})\cdot\ \mathrm{Complex}.I$ |
| [63](../finite-window-zeros/lean/EMBox14.lean#L63) | theorem | `mem_S2box` | $:\mathrm{Cx.mem}(\mathrm{s14}-1)\ \mathrm{S2box}$ |
| [77](../finite-window-zeros/lean/EMBox14.lean#L77) | theorem | `csPow_mem` | $\forall\,M : \mathbb{N},\ \forall\,h : \forall\ n,\ n<M\to\ \mathrm{CpowConditions}\ 20\ 16\ 48\ 24(n+1)\ \mathrm{S14},\ (\mathrm{csPow}\ M).\mathrm{mem}(\sum\ n\ \in\ \mathrm{Finset.range}\ M,((((n+1:\mathbb{N}):\mathbb{R}):\mathbb{C})^{-\mathrm{s14}}))$ |
| [92](../finite-window-zeros/lean/EMBox14.lean#L92) | theorem | `sumOK_conditions` | $\forall\,M : \mathbb{N},\ \forall\,h : \mathrm{sumOK}\ M=\mathrm{true},\ \forall\ n,\ n<M\to\ \mathrm{CpowConditions}\ 20\ 16\ 48\ 24(n+1)\ \mathrm{S14}$ |
| [116](../finite-window-zeros/lean/EMBox14.lean#L116) | theorem | `corner_Bzeta` | $:(\mathrm{maxAbsIv}\ \mathrm{Bzeta.re})^{2}+(\mathrm{maxAbsIv}\ \mathrm{Bzeta.im})^{2}\le((11/100:\mathbb{Q}))^{2}$ |
| [123](../finite-window-zeros/lean/EMBox14.lean#L123) | theorem | `norm_s14_le` | $:\Vert{}\mathrm{s14}\Vert\le(14.5:\mathbb{R})$ |
| [130](../finite-window-zeros/lean/EMBox14.lean#L130) | theorem | `norm_s14_add_one_le` | $:\Vert{}\mathrm{s14}+1\Vert\le(15.5:\mathbb{R})$ |
| [139](../finite-window-zeros/lean/EMBox14.lean#L139) | theorem | `norm_s14_add_two_le` | $:\Vert{}\mathrm{s14}+2\Vert\le(16.5:\mathbb{R})$ |
| [148](../finite-window-zeros/lean/EMBox14.lean#L148) | theorem | `norm_s14_add_three_le` | $:\Vert{}\mathrm{s14}+3\Vert\le(17.5:\mathbb{R})$ |
| [157](../finite-window-zeros/lean/EMBox14.lean#L157) | theorem | `norm_descPochhammer_three_le` | $:\Vert(\mathrm{descPochhammer}\ \mathbb{C}\ 3).\mathrm{eval}(-\mathrm{s14})\Vert\le(4320:\mathbb{R})$ |
| [176](../finite-window-zeros/lean/EMBox14.lean#L176) | theorem | `norm_descPochhammer_four_le` | $:\Vert(\mathrm{descPochhammer}\ \mathbb{C}\ 4).\mathrm{eval}(-\mathrm{s14})\Vert\le(65000:\mathbb{R})$ |
| [202](../finite-window-zeros/lean/EMBox14.lean#L202) | theorem | `emConst_four` | $:2\cdot(\mathrm{riemannZeta}(4:\mathbb{C})).\mathrm{re}/(2\cdot\ \mathrm{Real.pi})^{4}=(1/720:\mathbb{R})$ |
| [214](../finite-window-zeros/lean/EMBox14.lean#L214) | theorem | `pow21_neg_four` | $:(21:\mathbb{R})^{-(4:\mathbb{R})}=1/194481$ |
| [218](../finite-window-zeros/lean/EMBox14.lean#L218) | theorem | `pow21_neg_three` | $:(21:\mathbb{R})^{-(3:\mathbb{R})}=1/9261$ |
| [223](../finite-window-zeros/lean/EMBox14.lean#L223) | theorem | `norm_remainder_two_le` | $:\Vert{}\mathrm{zetaEMRemainder}\ 2\ 20\ \mathrm{s14}\Vert\le(1/250:\mathbb{R})$ |
| [260](../finite-window-zeros/lean/EMBox14.lean#L260) | theorem | `norm_b4term_le` | $:\Vert(-(\mathrm{emCoef}\ 2):\mathbb{C})\cdot\ \mathrm{emGShift}\ \mathrm{s14}\ 20\ 3\ 0\Vert\le(1/1000:\mathbb{R})$ |
| [289](../finite-window-zeros/lean/EMBox14.lean#L289) | theorem | `zetaEMGen_one_expand` | $:\mathrm{zetaEMGen}\ 1\ 20\ \mathrm{s14}=(\sum\ n\ \in\ \mathrm{Finset.range}\ 20,((((n+1:\mathbb{R}):\mathbb{C})^{-\mathrm{s14}})))+(21:\mathbb{C})^{1-\mathrm{s14}}/(\mathrm{s14}-1)+(21:\mathbb{C})^{-\mathrm{s14}}/2+(1/12:\mathbb{C})\cdot\ \mathrm{s14}\cdot(21:\mathbb{C})^{-(\mathrm{s14}+1)}$ |
| [300](../finite-window-zeros/lean/EMBox14.lean#L300) | theorem | `cpow_21_one_sub` | $:(21:\mathbb{C})^{1-\mathrm{s14}}=(21:\mathbb{C})^{-\mathrm{s14}}\cdot\ 21$ |
| [306](../finite-window-zeros/lean/EMBox14.lean#L306) | theorem | `cpow_21_neg_succ` | $:(21:\mathbb{C})^{-(\mathrm{s14}+1)}=(21:\mathbb{C})^{-\mathrm{s14}}\cdot(21:\mathbb{C})^{-1}$ |
| [314](../finite-window-zeros/lean/EMBox14.lean#L314) | theorem | `scalar_eq` | $:(21:\mathbb{C})/(\mathrm{s14}-1)+1/2+(1/12:\mathbb{C})\cdot\ \mathrm{s14}\cdot(21:\mathbb{C})^{-1}=((177437/395640:\mathbb{R}):\mathbb{C})+((-20383/14130:\mathbb{R}):\mathbb{C})\cdot\ \mathrm{Complex}.I$ |
| [333](../finite-window-zeros/lean/EMBox14.lean#L333) | theorem | `three_terms_eq` | $:(21:\mathbb{C})^{1-\mathrm{s14}}/(\mathrm{s14}-1)+(21:\mathbb{C})^{-\mathrm{s14}}/2+(1/12:\mathbb{C})\cdot\ \mathrm{s14}\cdot(21:\mathbb{C})^{-(\mathrm{s14}+1)}=(21:\mathbb{C})^{-\mathrm{s14}}\cdot(((177437/395640:\mathbb{R}):\mathbb{C})+((-20383/14130:\mathbb{R}):\mathbb{C})\cdot\ \mathrm{Complex}.I)$ |
| [347](../finite-window-zeros/lean/EMBox14.lean#L347) | theorem | `mem_Bzeta` | $:\mathrm{Cx.mem}(\mathrm{zetaEMGen}\ 1\ 20\ \mathrm{s14})\ \mathrm{Bzeta}$ |
| [371](../finite-window-zeros/lean/EMBox14.lean#L371) | theorem | `zeta_norm_le_115` | $:\Vert{}\mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(23/200:\mathbb{R})$ |
| [398](../finite-window-zeros/lean/EMBox14.lean#L398) | theorem | `zeta_norm_le_eighth` | $:\Vert{}\mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(1/8:\mathbb{R})$ |
| [403](../finite-window-zeros/lean/EMBox14.lean#L403) | theorem | `hmap_zeta` | $:\Vert{}\mathrm{Yk}\cdot\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert+(1/4:\mathbb{R})\cdot(1/4:\mathbb{R})\le(1/4:\mathbb{R})$ |
| [410](../finite-window-zeros/lean/EMBox14.lean#L410) | theorem | `norm_Yk_le` | $:\Vert{}\mathrm{Yk}\Vert\le(1.29:\mathbb{R})$ |
| [423](../finite-window-zeros/lean/EMBox14.lean#L423) | theorem | `hmap_zeta_fifth` | $:\Vert{}\mathrm{Yk}\cdot\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert+(1/4:\mathbb{R})\cdot(1/5:\mathbb{R})\le(1/5:\mathbb{R})$ |
| [431](../finite-window-zeros/lean/EMBox14.lean#L431) | theorem | `fifth_ball_ne_one` | $:\forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ z\ne\ 1$ |
| [446](../finite-window-zeros/lean/EMBox14.lean#L446) | theorem | `zeta_zero_fifth_ball` | $\forall\,Y : \mathbb{C},\ \forall\,hY : Y\ne\ 0,\ \forall\,hC : \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \Vert1-Y\cdot\ \mathrm{deriv}\ \mathrm{riemannZeta}\ z\Vert\le(1/4:\mathbb{R}),\ \forall\,hmap : \Vert{}Y\cdot\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert+(1/4:\mathbb{R})\cdot(1/5:\mathbb{R})\le(1/5:\mathbb{R}),\ \exists\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \mathrm{riemannZeta}\ z=0$ |
| [454](../finite-window-zeros/lean/EMBox14.lean#L454) | theorem | `Yk_ne_zero` | $:\mathrm{Yk}\ne\ 0$ |
| [469](../finite-window-zeros/lean/EMBox14.lean#L469) | theorem | `hC_of_bounds` | $\forall\,h_{1} : \Vert1-\mathrm{Yk}\cdot\ \mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(1/200:\mathbb{R}),\ \forall\,h_{2} : \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \Vert{}\mathrm{deriv}\ \mathrm{riemannZeta}\ z-\mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(47/250:\mathbb{R}),\ \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \Vert1-\mathrm{Yk}\cdot\ \mathrm{deriv}\ \mathrm{riemannZeta}\ z\Vert\le(1/4:\mathbb{R})$ |
| [499](../finite-window-zeros/lean/EMBox14.lean#L499) | theorem | `zeta_zero_14_of_bounds` | $\forall\,h_{1} : \Vert1-\mathrm{Yk}\cdot\ \mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(1/200:\mathbb{R}),\ \forall\,h_{2} : \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \Vert{}\mathrm{deriv}\ \mathrm{riemannZeta}\ z-\mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(47/250:\mathbb{R}),\ \exists\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \mathrm{riemannZeta}\ z=0$ |
