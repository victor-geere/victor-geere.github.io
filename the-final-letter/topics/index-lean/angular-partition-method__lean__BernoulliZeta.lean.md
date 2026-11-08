# `angular-partition-method/lean/BernoulliZeta.lean`

[Back to the split index](index.md) · Topic: [`angular-partition-method`](../angular-partition-method/README.md)

### [`angular-partition-method/lean/BernoulliZeta.lean`](../angular-partition-method/lean/BernoulliZeta.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [33](../angular-partition-method/lean/BernoulliZeta.lean#L33) | theorem | `X_mul_expm1DivX` | $:(\mathrm{PowerSeries}.X:\mathrm{PowerSeries}\ \mathbb{C})\cdot\ \mathrm{expm1DivX}=\mathrm{PowerSeries.exp}\ \mathbb{C}-1$ |
| [45](../angular-partition-method/lean/BernoulliZeta.lean#L45) | theorem | `bernoulliPowerSeries_mul_expm1DivX` | $:\mathrm{bernoulliPowerSeries}\ \mathbb{C}\cdot\ \mathrm{expm1DivX}=1$ |
| [59](../angular-partition-method/lean/BernoulliZeta.lean#L59) | theorem | `X_mul_gSeries` | $:(\mathrm{PowerSeries}.X:\mathrm{PowerSeries}\ \mathbb{C})\cdot\ \mathrm{gSeries}=\mathrm{bernoulliPowerSeries}\ \mathbb{C}-1$ |
| [71](../angular-partition-method/lean/BernoulliZeta.lean#L71) | theorem | `gSeries_coeff` | $\forall\,k : \mathbb{N},\ \mathrm{gSeries.coeff}\ k=(\mathrm{bernoulli}(k+1):\mathbb{C})/(\mathrm{Nat.factorial}(k+1):\mathbb{C})$ |
| [78](../angular-partition-method/lean/BernoulliZeta.lean#L78) | theorem | `X_mul_exp_sub_one_mul_gSeries` | $:(\mathrm{PowerSeries}.X:\mathrm{PowerSeries}\ \mathbb{C})\cdot(\mathrm{PowerSeries.exp}\ \mathbb{C}-1)\cdot\ \mathrm{gSeries}=\mathrm{PowerSeries}.X-(\mathrm{PowerSeries.exp}\ \mathbb{C}-1)$ |
| [98](../angular-partition-method/lean/BernoulliZeta.lean#L98) | theorem | `hasSum_mul_range` | $\forall\,a\,b : \mathbb{N}\to\ \mathbb{C},\ \forall\,A\,B : \mathbb{C},\ \forall\,ha : \mathrm{HasSum}\ a\ A,\ \forall\,hb : \mathrm{HasSum}\ b\ B,\ \forall\,ha' : \mathrm{Summable}\ \lambda\ n\Rightarrow\ \Vert{}a\ n\Vert,\ \forall\,hb' : \mathrm{Summable}\ \lambda\ n\Rightarrow\ \Vert{}b\ n\Vert,\ \mathrm{HasSum}(\lambda\ n\Rightarrow\ \sum\ k\ \in\ \mathrm{Finset.range}(n+1),\ a\ k\cdot\ b(n-k))(A\cdot\ B)$ |
| [113](../angular-partition-method/lean/BernoulliZeta.lean#L113) | theorem | `hasFPowerSeriesAt_mul_ofScalars` | $\forall\,f\,g : \mathbb{C}\to\ \mathbb{C},\ \forall\,a\,b : \mathbb{N}\to\ \mathbb{C},\ \forall\,ha : \mathrm{HasFPowerSeriesAt}\ f(\mathrm{FormalMultilinearSeries.ofScalars}\ \mathbb{C}\ a)\ 0,\ \forall\,hb : \mathrm{HasFPowerSeriesAt}\ g(\mathrm{FormalMultilinearSeries.ofScalars}\ \mathbb{C}\ b)\ 0,\ \mathrm{HasFPowerSeriesAt}(\lambda\ z\Rightarrow\ f\ z\cdot\ g\ z)(\mathrm{FormalMultilinearSeries.ofScalars}\ \mathbb{C}(\lambda\ n\Rightarrow\ \sum\ k\ \in\ \mathrm{Finset.range}(n+1),\ a\ k\cdot\ b(n-k)))\ 0$ |
