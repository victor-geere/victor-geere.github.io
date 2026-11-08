# `sin-x-over-x/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`sin-x-over-x`](../sin-x-over-x/README.md)

### [`sin-x-over-x/lean/Topic.lean`](../sin-x-over-x/lean/Topic.lean) — 26 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [66](../sin-x-over-x/lean/Topic.lean#L66) | theorem | `eps_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{eps}\ n$ |
| [70](../sin-x-over-x/lean/Topic.lean#L70) | theorem | `eps_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{eps}$ |
| [78](../sin-x-over-x/lean/Topic.lean#L78) | theorem | `eps_le_eps_of_le` | $\forall\,n\,m : \mathbb{N},\ \forall\,h : n\le\ m,\ \mathrm{eps}\ m\le\ \mathrm{eps}\ n$ |
| [83](../sin-x-over-x/lean/Topic.lean#L83) | theorem | `step_le_self` | $\forall\,r : \mathbb{R},\ \forall\,n : \mathbb{N},\ \mathrm{step}\ r\ n\le\ r$ |
| [90](../sin-x-over-x/lean/Topic.lean#L90) | theorem | `resid_le` | $\forall\,y : \mathbb{R},\ \forall\,n : \mathbb{N},\ \mathrm{resid}\ y\ n\le\ y$ |
| [98](../sin-x-over-x/lean/Topic.lean#L98) | theorem | `delta_eq_zero_of_resid_lt` | $\forall\,y : \mathbb{R},\ \forall\,n : \mathbb{N},\ \forall\,h : \mathrm{resid}\ y\ n<\mathrm{eps}\ n,\ \mathrm{delta}\ y\ n=0$ |
| [106](../sin-x-over-x/lean/Topic.lean#L106) | theorem | `theta_eq_zero_of_forall_lt` | $\forall\,y : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,h : \forall\ n<N,\ y<\mathrm{eps}\ n,\ \mathrm{theta}\ y\ N=0$ |
| [114](../sin-x-over-x/lean/Topic.lean#L114) | theorem | `theta_eq_zero_of_lt_eps` | $\forall\,y : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,h : y<\mathrm{eps}\ N,\ \mathrm{theta}\ y(N+1)=0$ |
| [120](../sin-x-over-x/lean/Topic.lean#L120) | theorem | `greedySine_zero` | $:\mathrm{greedySine}\ 0=0$ |
| [125](../sin-x-over-x/lean/Topic.lean#L125) | theorem | `greedySine_int` | $\forall\,k : \mathbb{Z},\ \mathrm{greedySine}(k:\mathbb{R})=0$ |
| [131](../sin-x-over-x/lean/Topic.lean#L131) | theorem | `greedySine_eq_zero_iff` | $\forall\,\theta : \mathbb{R},\ \mathrm{greedySine}\ \theta=0\leftrightarrow\ \exists\ k:\mathbb{Z},\ \theta=k$ |
| [145](../sin-x-over-x/lean/Topic.lean#L145) | theorem | `greedySine_pos` | $\forall\,\theta : \mathbb{R},\ \forall\,h_{0} : 0<\theta,\ \forall\,h_{1} : \theta<1,\ 0<\mathrm{greedySine}\ \theta$ |
| [154](../sin-x-over-x/lean/Topic.lean#L154) | theorem | `greedySine_five_six` | $:\mathrm{greedySine}(5/6)=1/2$ |
| [162](../sin-x-over-x/lean/Topic.lean#L162) | theorem | `reconSine_error` | $\forall\,y : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,h : \vert{}\mathrm{theta}\ y\ N-y\vert\le\ 1/((N:\mathbb{R})+1),\ \vert{}\mathrm{reconSine}\ y\ N-\mathrm{Real.sin}(\mathrm{Real.pi}\cdot\ y)\vert\le\ \mathrm{Real.pi}/((N:\mathbb{R})+1)$ |
| [179](../sin-x-over-x/lean/Topic.lean#L179) | theorem | `reconSine_eq_zero_of_lt_eps` | $\forall\,y : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,h : y<\mathrm{eps}\ N,\ \mathrm{reconSine}\ y(N+1)=0$ |
| [184](../sin-x-over-x/lean/Topic.lean#L184) | theorem | `reconSinc_eq_zero_of_lt_eps` | $\forall\,y : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,h : y<\mathrm{eps}\ N,\ \mathrm{reconSinc}\ y(N+1)=0$ |
| [190](../sin-x-over-x/lean/Topic.lean#L190) | theorem | `theta_one_two` | $:\mathrm{theta}\ 1\ 2=5/6$ |
| [193](../sin-x-over-x/lean/Topic.lean#L193) | theorem | `theta_one_five` | $:\mathrm{theta}\ 1\ 5=1$ |
| [196](../sin-x-over-x/lean/Topic.lean#L196) | theorem | `reconSine_one_two` | $:\mathrm{reconSine}\ 1\ 2=1/2$ |
| [200](../sin-x-over-x/lean/Topic.lean#L200) | theorem | `reconSine_one_five` | $:\mathrm{reconSine}\ 1\ 5=0$ |
| [205](../sin-x-over-x/lean/Topic.lean#L205) | theorem | `step_zero` | $\forall\,n : \mathbb{N},\ \mathrm{step}\ 0\ n=0$ |
| [213](../sin-x-over-x/lean/Topic.lean#L213) | theorem | `resid_half` | $\forall\,N : \mathbb{N},\ \mathrm{resid}(1/2)(N+1)=0$ |
| [220](../sin-x-over-x/lean/Topic.lean#L220) | theorem | `delta_half_zero` | $\forall\,N : \mathbb{N},\ \mathrm{delta}(1/2)(N+1)=0$ |
| [228](../sin-x-over-x/lean/Topic.lean#L228) | theorem | `theta_half` | $\forall\,N : \mathbb{N},\ \mathrm{theta}(1/2)(N+1)=1/2$ |
| [238](../sin-x-over-x/lean/Topic.lean#L238) | theorem | `reconSine_half` | $\forall\,N : \mathbb{N},\ \mathrm{reconSine}(1/2)(N+1)=1$ |
| [243](../sin-x-over-x/lean/Topic.lean#L243) | theorem | `reconSinc_half` | $\forall\,N : \mathbb{N},\ \mathrm{reconSinc}(1/2)(N+1)=2/\mathrm{Real.pi}$ |
