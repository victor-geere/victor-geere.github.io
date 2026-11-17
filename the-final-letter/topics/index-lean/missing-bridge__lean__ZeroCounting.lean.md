# `missing-bridge/lean/ZeroCounting.lean`

[Back to the split index](index.md) · Topic: [`missing-bridge`](../missing-bridge/README.md)

### [`missing-bridge/lean/ZeroCounting.lean`](../missing-bridge/lean/ZeroCounting.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [41](../missing-bridge/lean/ZeroCounting.lean#L41) | theorem | `verticalLimitIdentification_of_evaluations` | $\forall\,c\,\sigma : \mathbb{R},\ \forall\,A\,P\,A'\,P' : \mathbb{C},\ \forall\,hA : \mathrm{ArchimedeanEvaluation}\ c\ \sigma\ A\ \mathrm{A'},\ \forall\,hP : \mathrm{PrimeEvaluation}\ c\ \sigma\ P\ \mathrm{P'},\ \mathrm{VerticalLimitIdentification}\ c\ \sigma\ A\ P\ \mathrm{A'}\ \mathrm{P'}$ |
| [47](../missing-bridge/lean/ZeroCounting.lean#L47) | theorem | `gaussianZeroTest_norm_le_strip` | $\forall\,c\,\sigma : \mathbb{R},\ \forall\,h\sigma : 0<\sigma,\ \forall\,\rho : \mathbb{C},\ \forall\,h_{0} : 0<\rho.\mathrm{re},\ \forall\,h_{1} : \rho.\mathrm{re}<1,\ \Vert{}\mathrm{gaussianZeroTest}\ c\ \sigma\ \rho\Vert\le(2\cdot\ \mathrm{Real.pi}\cdot\ \sigma^{2}\cdot\ \mathrm{Real.exp}(\sigma^{2}/4)\cdot\ \mathrm{max}(\mathrm{Real.exp}(c/2))(\mathrm{Real.exp}(-(c/2))))\cdot\ \mathrm{Real.exp}(-(\sigma^{2}\cdot\ \rho.\mathrm{im}^{2}))$ |
