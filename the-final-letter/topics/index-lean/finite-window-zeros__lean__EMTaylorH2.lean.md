# `finite-window-zeros/lean/EMTaylorH2.lean`

[Back to the split index](index.md) · Topic: [`finite-window-zeros`](../finite-window-zeros/README.md)

### [`finite-window-zeros/lean/EMTaylorH2.lean`](../finite-window-zeros/lean/EMTaylorH2.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [50](../finite-window-zeros/lean/EMTaylorH2.lean#L50) | theorem | `taylorCoef_one` | $:\mathrm{taylorCoef}\ 1=\mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}$ |
| [53](../finite-window-zeros/lean/EMTaylorH2.lean#L53) | theorem | `cBound_nonneg` | $\forall\,k : \mathbb{N},\ \forall\,h_{2} : 2\le\ k,\ \forall\,h_{6} : k\le\ 6,\ (0:\mathbb{R})\le\ \mathrm{cBound}\ k$ |
| [57](../finite-window-zeros/lean/EMTaylorH2.lean#L57) | theorem | `taylorPoly_sub_eq` | $\forall\,w : \mathbb{C},\ \mathrm{taylorPoly}\ w-\mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}=\sum\ j\ \in\ \mathrm{Finset.range}\ 5,(((j+2:\mathbb{N})):\mathbb{C})\cdot\ \mathrm{taylorCoef}(j+2)\cdot\ w^{j+1}$ |
| [73](../finite-window-zeros/lean/EMTaylorH2.lean#L73) | theorem | `norm_taylorCoef_le` | $\forall\,k : \mathbb{N},\ \forall\,h_{2} : 2\le\ k,\ \forall\,h_{6} : k\le\ 6,\ \Vert{}\mathrm{taylorCoef}\ k\Vert\le\ \mathrm{cBound}\ k$ |
| [84](../finite-window-zeros/lean/EMTaylorH2.lean#L84) | theorem | `norm_taylorPoly_sub_le` | $\forall\,w : \mathbb{C},\ \forall\,hw : \Vert{}w\Vert\le(1/5:\mathbb{R}),\ \Vert{}\mathrm{taylorPoly}\ w-\mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(154/1000:\mathbb{R})$ |
| [117](../finite-window-zeros/lean/EMTaylorH2.lean#L117) | theorem | `norm_deriv_sub_le_of_taylor_remainder` | $\forall\,z : \mathbb{C},\ \forall\,hz : \Vert{}z-\mathrm{s14}\Vert\le(1/5:\mathbb{R}),\ \forall\,hrem : \Vert{}\mathrm{deriv}\ \mathrm{riemannZeta}\ z-\mathrm{taylorPoly}(z-\mathrm{s14})\Vert\le(14/1000:\mathbb{R}),\ \Vert{}\mathrm{deriv}\ \mathrm{riemannZeta}\ z-\mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(47/250:\mathbb{R})$ |
| [131](../finite-window-zeros/lean/EMTaylorH2.lean#L131) | theorem | `h2_of_taylor_remainder` | $\forall\,hrem : \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \Vert{}\mathrm{deriv}\ \mathrm{riemannZeta}\ z-\mathrm{taylorPoly}(z-\mathrm{s14})\Vert\le(14/1000:\mathbb{R}),\ \forall\ z\ \in\ \mathrm{Metric.closedBall}\ \mathrm{s14}(1/5),\ \Vert{}\mathrm{deriv}\ \mathrm{riemannZeta}\ z-\mathrm{deriv}\ \mathrm{riemannZeta}\ \mathrm{s14}\Vert\le(47/250:\mathbb{R})$ |
