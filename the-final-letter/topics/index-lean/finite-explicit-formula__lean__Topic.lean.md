# `finite-explicit-formula/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`finite-explicit-formula`](../finite-explicit-formula/README.md)

### [`finite-explicit-formula/lean/Topic.lean`](../finite-explicit-formula/lean/Topic.lean) — 31 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [28](../finite-explicit-formula/lean/Topic.lean#L28) | theorem | `tent_nonneg` | $\forall\,x : \mathbb{R},\ 0\le\ \mathrm{tent}\ x$ |
| [30](../finite-explicit-formula/lean/Topic.lean#L30) | theorem | `tent_continuous` | $:\mathrm{Continuous}\ \mathrm{tent}$ |
| [34](../finite-explicit-formula/lean/Topic.lean#L34) | theorem | `tentAutocorr_even` | $\forall\,x : \mathbb{R},\ \mathrm{tentAutocorr}(-x)=\mathrm{tentAutocorr}\ x$ |
| [37](../finite-explicit-formula/lean/Topic.lean#L37) | theorem | `tentAutocorr_nonneg` | $\forall\,x : \mathbb{R},\ 0\le\ \mathrm{tentAutocorr}\ x$ |
| [66](../finite-explicit-formula/lean/Topic.lean#L66) | theorem | `tentAutocorr_pos` | $\forall\,x : \mathbb{R},\ \forall\,h : \vert{}x\vert<2,\ 0<\mathrm{tentAutocorr}\ x$ |
| [93](../finite-explicit-formula/lean/Topic.lean#L93) | theorem | `integral_sq_zero_one` | $:(\int\ x\ \text{in}(0:\mathbb{R})..1,\ x^{2})=1/3$ |
| [103](../finite-explicit-formula/lean/Topic.lean#L103) | theorem | `integral_tent_sq` | $:\int\ x\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ x^{2}=2/3$ |
| [136](../finite-explicit-formula/lean/Topic.lean#L136) | theorem | `integral_id_zero_one` | $:(\int\ x\ \text{in}(0:\mathbb{R})..1,\ x)=1/2$ |
| [145](../finite-explicit-formula/lean/Topic.lean#L145) | theorem | `integral_tent` | $:\int\ x\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ x=1$ |
| [179](../finite-explicit-formula/lean/Topic.lean#L179) | theorem | `hasDeriv_g01` | $\forall\,x : \mathbb{R},\ \mathrm{HasDerivAt}(\lambda\ y:\mathbb{R}\Rightarrow\ y^{4}/8-y^{3}/3+2\cdot\ y/3)(x^{3}/2-x^{2}+2/3)\ x$ |
| [195](../finite-explicit-formula/lean/Topic.lean#L195) | theorem | `integral_g01` | $:\int\ x\ \text{in}(0:\mathbb{R})..1,\ \mathrm{tentAutocorr}\ x=11/24$ |
| [215](../finite-explicit-formula/lean/Topic.lean#L215) | theorem | `tentAutocorr_one` | $:\mathrm{tentAutocorr}\ 1=1/6$ |
| [218](../finite-explicit-formula/lean/Topic.lean#L218) | theorem | `tentAutocorr_two` | $:\mathrm{tentAutocorr}\ 2=0$ |
| [224](../finite-explicit-formula/lean/Topic.lean#L224) | theorem | `hasDeriv_g12` | $\forall\,x : \mathbb{R},\ \mathrm{HasDerivAt}\ \mathrm{F2}(-x^{3}/6+x^{2}-2\cdot\ x+4/3)\ x$ |
| [246](../finite-explicit-formula/lean/Topic.lean#L246) | theorem | `integral_g12` | $:\int\ x\ \text{in}(1:\mathbb{R})..2,\ \mathrm{tentAutocorr}\ x=1/24$ |
| [268](../finite-explicit-formula/lean/Topic.lean#L268) | theorem | `contOn_g01` | $:\mathrm{ContinuousOn}\ \mathrm{tentAutocorr}(\mathrm{Set.Icc}(0:\mathbb{R})\ 1)$ |
| [274](../finite-explicit-formula/lean/Topic.lean#L274) | theorem | `contOn_g12` | $:\mathrm{ContinuousOn}\ \mathrm{tentAutocorr}(\mathrm{Set.Icc}(1:\mathbb{R})\ 2)$ |
| [287](../finite-explicit-formula/lean/Topic.lean#L287) | theorem | `integral_g02` | $:\int\ x\ \text{in}(0:\mathbb{R})..2,\ \mathrm{tentAutocorr}\ x=1/2$ |
| [295](../finite-explicit-formula/lean/Topic.lean#L295) | theorem | `integral_tentAutocorr` | $:\int\ x\ \text{in}(-2:\mathbb{R})..2,\ \mathrm{tentAutocorr}\ x=1$ |
| [319](../finite-explicit-formula/lean/Topic.lean#L319) | theorem | `autocorr_at_zero` | $:\int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-0)=\mathrm{tentAutocorr}\ 0$ |
| [327](../finite-explicit-formula/lean/Topic.lean#L327) | theorem | `tent_zero` | $:\mathrm{tent}\ 0=1$ |
| [330](../finite-explicit-formula/lean/Topic.lean#L330) | theorem | `tent_one` | $:\mathrm{tent}\ 1=0$ |
| [333](../finite-explicit-formula/lean/Topic.lean#L333) | theorem | `autocorr_at_one` | $:\int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-1)=\mathrm{tentAutocorr}\ 1$ |
| [381](../finite-explicit-formula/lean/Topic.lean#L381) | theorem | `autocorr_at_three_halves` | $:\int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-3/2)=\mathrm{tentAutocorr}(3/2)$ |
| [451](../finite-explicit-formula/lean/Topic.lean#L451) | theorem | `autocorr_at_five_halves` | $:\int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-5/2)=\mathrm{tentAutocorr}(5/2)$ |
| [469](../finite-explicit-formula/lean/Topic.lean#L469) | theorem | `autocorr_at_two` | $:\int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-2)=\mathrm{tentAutocorr}\ 2$ |
| [487](../finite-explicit-formula/lean/Topic.lean#L487) | theorem | `tentAutocorr_eq_zero_of_two_le` | $\forall\,x : \mathbb{R},\ \forall\,hx : 2\le\ \vert{}x\vert,\ \mathrm{tentAutocorr}\ x=0$ |
| [498](../finite-explicit-formula/lean/Topic.lean#L498) | theorem | `autocorr_eq_zero_of_two_le` | $\forall\,x : \mathbb{R},\ \forall\,hx : 2\le\ \vert{}x\vert,\ \int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-x)=0$ |
| [519](../finite-explicit-formula/lean/Topic.lean#L519) | theorem | `autocorr_outside_support` | $\forall\,x : \mathbb{R},\ \forall\,hx : 2\le\ \vert{}x\vert,\ \int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-x)=\mathrm{tentAutocorr}\ x$ |
| [523](../finite-explicit-formula/lean/Topic.lean#L523) | theorem | `autocorr_between_one_two` | $\forall\,x : \mathbb{R},\ \forall\,hx_{1} : 1\le\ x,\ \forall\,hx_{2} : x\le\ 2,\ \int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-x)=\mathrm{tentAutocorr}\ x$ |
| [594](../finite-explicit-formula/lean/Topic.lean#L594) | theorem | `autocorr_between_neg_two_neg_one` | $\forall\,x : \mathbb{R},\ \forall\,hx_{1} : -2\le\ x,\ \forall\,hx_{2} : x\le-1,\ \int\ t\ \text{in}(-1:\mathbb{R})..1,\ \mathrm{tent}\ t\cdot\ \mathrm{tent}(t-x)=\mathrm{tentAutocorr}\ x$ |
