# `nested-spheres-continuous-cone/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`nested-spheres-continuous-cone`](../nested-spheres-continuous-cone/README.md)

### [`nested-spheres-continuous-cone/lean/Topic.lean`](../nested-spheres-continuous-cone/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [37](../nested-spheres-continuous-cone/lean/Topic.lean#L37) | theorem | `fibreRadius_pos` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ 0<\mathrm{fibreRadius}\ N$ |
| [42](../nested-spheres-continuous-cone/lean/Topic.lean#L42) | theorem | `fibreRadius_strictAnti` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ \mathrm{fibreRadius}(N+1)<\mathrm{fibreRadius}\ N$ |
| [51](../nested-spheres-continuous-cone/lean/Topic.lean#L51) | theorem | `fibreRadius_tendsto_zero` | $:\mathrm{Tendsto}\ \mathrm{fibreRadius}\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [61](../nested-spheres-continuous-cone/lean/Topic.lean#L61) | theorem | `meanZeroCoeff_self` | $\forall\,N : \mathbb{N},\ \mathrm{meanZeroCoeff}\ N\ N=1-(N:\mathbb{Z})$ |
| [66](../nested-spheres-continuous-cone/lean/Topic.lean#L66) | theorem | `meanZeroCoeff_period_sum` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ (\sum\ i\ \in\ \mathrm{Finset.range}\ N,\ \mathrm{meanZeroCoeff}\ N(i+1))=0$ |
| [99](../nested-spheres-continuous-cone/lean/Topic.lean#L99) | theorem | `chord_le_arc` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ \mathrm{chord}\ N\le\ 2\cdot\ \mathrm{Real.pi}/(N:\mathbb{R})$ |
| [116](../nested-spheres-continuous-cone/lean/Topic.lean#L116) | theorem | `localDiagonal_integral` | $\forall\,R : \mathbb{R},\ \forall\,\varphi : \mathbb{R}\to\ \mathbb{R},\ \forall\,h\varphi : \mathrm{IntervalIntegrable}\ \varphi\ \mathrm{volume}(-1)\ 1,\ \forall\,h\varphi_{2} : \mathrm{IntervalIntegrable}(\lambda\ u\Rightarrow\ \varphi\ u^{2})\ \mathrm{volume}(-1)\ 1,\ (\int\ u\ \text{in}(-1:\mathbb{R})..1,(1-R\cdot\ \varphi\ u)\cdot(-\varphi\ u))=-(\int\ u\ \text{in}(-1:\mathbb{R})..1,\ \varphi\ u)+R\cdot\ \int\ u\ \text{in}(-1:\mathbb{R})..1,\ \varphi\ u^{2}$ |
