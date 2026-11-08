# `finite-window-zeros/lean/EMOnLine.lean`

[Back to the split index](index.md) · Topic: [`finite-window-zeros`](../finite-window-zeros/README.md)

### [`finite-window-zeros/lean/EMOnLine.lean`](../finite-window-zeros/lean/EMOnLine.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [44](../finite-window-zeros/lean/EMOnLine.lean#L44) | theorem | `zero_unique_of_contraction` | $\forall\,f\,f' : \mathbb{C}\to\ \mathbb{C},\ \forall\,x_{0} : \mathbb{C},\ \forall\,r\,q : \mathbb{R},\ \forall\,Y : \mathbb{C},\ \forall\,hq_{1} : q<1,\ \forall\,h : \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{x0}\ r,\ \mathrm{HasDerivAt}\ f(\mathrm{f'}\ z)\ z,\ \forall\,hC : \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{x0}\ r,\ \Vert1-Y\cdot\ \mathrm{f'}\ z\Vert\le\ q,\ \forall\,x\,y : \mathbb{C},\ \forall\,hx : x\ \in\ \mathrm{Metric.closedBall}\ \mathrm{x0}\ r,\ \forall\,hy : y\ \in\ \mathrm{Metric.closedBall}\ \mathrm{x0}\ r,\ \forall\,hfx : f\ x=0,\ \forall\,hfy : f\ y=0,\ x=y$ |
| [61](../finite-window-zeros/lean/EMOnLine.lean#L61) | theorem | `zeta_zero_unique` | $\forall\,Y : \mathbb{C},\ \forall\,hC : \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \Vert1-Y\cdot\ \mathrm{deriv}\ \mathrm{riemannZeta}\ z\Vert\le(1/4:\mathbb{R}),\ \forall\,x\,y : \mathbb{C},\ \forall\,hx : x\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \forall\,hy : y\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \forall\,hfx : \mathrm{riemannZeta}\ x=0,\ \forall\,hfy : \mathrm{riemannZeta}\ y=0,\ x=y$ |
| [74](../finite-window-zeros/lean/EMOnLine.lean#L74) | theorem | `zeta_zero_one_sub_conj` | $\forall\,z : \mathbb{C},\ \forall\,hz : \mathrm{riemannZeta}\ z=0,\ \forall\,him : z.\mathrm{im}\ne\ 0,\ \mathrm{riemannZeta}(1-(\mathrm{starRingEnd}\ \mathbb{C})\ z)=0$ |
| [93](../finite-window-zeros/lean/EMOnLine.lean#L93) | theorem | `mem_ball_one_sub_conj` | $\forall\,z : \mathbb{C},\ \forall\,hz : z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ (1-(\mathrm{starRingEnd}\ \mathbb{C})\ z)\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5)$ |
| [102](../finite-window-zeros/lean/EMOnLine.lean#L102) | theorem | `im_ne_zero_of_ball` | $\forall\,z : \mathbb{C},\ \forall\,hz : z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ z.\mathrm{im}\ne\ 0$ |
| [120](../finite-window-zeros/lean/EMOnLine.lean#L120) | theorem | `zeta_zero_14_on_line_simple` | $:\exists\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \mathrm{riemannZeta}\ z=0\ \land\ z.\mathrm{re}=(1/2:\mathbb{R})\ \land\ \mathrm{deriv}\ \mathrm{riemannZeta}\ z\ne\ 0$ |
| [141](../finite-window-zeros/lean/EMOnLine.lean#L141) | theorem | `zeta_zero_14_on_line` | $:\exists\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \mathrm{riemannZeta}\ z=0\ \land\ z.\mathrm{re}=(1/2:\mathbb{R})$ |
| [147](../finite-window-zeros/lean/EMOnLine.lean#L147) | theorem | `zeta_zero_14_simple` | $:\exists\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \mathrm{riemannZeta}\ z=0\ \land\ \mathrm{deriv}\ \mathrm{riemannZeta}\ z\ne\ 0$ |
