# `intersection-form-zeta/lean/Enclosure.lean`

[Back to the split index](index.md) · Topic: [`intersection-form-zeta`](../intersection-form-zeta/README.md)

### [`intersection-form-zeta/lean/Enclosure.lean`](../intersection-form-zeta/lean/Enclosure.lean) — 37 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [35](../intersection-form-zeta/lean/Enclosure.lean#L35) | theorem | `digamma_quarter` | $:\mathrm{Complex.digamma}(1/4:\mathbb{C})=-(\mathrm{Real.eulerMascheroniConstant}:\mathbb{C})-(\mathrm{Real.pi}:\mathbb{C})/2-3\cdot\ \mathrm{Complex.log}\ 2$ |
| [68](../intersection-form-zeta/lean/Enclosure.lean#L68) | lemma | `hasDerivAt_log_one_add` | $\forall\,x : \mathbb{R},\ \forall\,hx : 0\le\ x,\ \mathrm{HasDerivAt}(\lambda\ t:\mathbb{R}\Rightarrow\ \mathrm{Real.log}(1+t))(1/(1+x))\ x$ |
| [74](../intersection-form-zeta/lean/Enclosure.lean#L74) | lemma | `hasDerivAt_quad` | $\forall\,x : \mathbb{R},\ \mathrm{HasDerivAt}(\lambda\ t:\mathbb{R}\Rightarrow\ t-t^{2}/2)(1-x)\ x$ |
| [83](../intersection-form-zeta/lean/Enclosure.lean#L83) | lemma | `log_one_add_ge` | $\forall\,x : \mathbb{R},\ \forall\,hx : 0\le\ x,\ x-x^{2}/2\le\ \mathrm{Real.log}(1+x)$ |
| [120](../intersection-form-zeta/lean/Enclosure.lean#L120) | lemma | `hasDerivAt_cubic` | $\forall\,x : \mathbb{R},\ \mathrm{HasDerivAt}(\lambda\ t:\mathbb{R}\Rightarrow\ t-t^{2}/2+t^{3}/3)(1-x+x^{2})\ x$ |
| [129](../intersection-form-zeta/lean/Enclosure.lean#L129) | lemma | `log_one_add_le` | $\forall\,x : \mathbb{R},\ \forall\,hx : 0\le\ x,\ \mathrm{Real.log}(1+x)\le\ x-x^{2}/2+x^{3}/3$ |
| [168](../intersection-form-zeta/lean/Enclosure.lean#L168) | lemma | `gammaLower_step` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \mathrm{gammaLower}(n+1)-\mathrm{gammaLower}\ n=1/(n+1)+1/(2\cdot\ n\cdot(n+1))-\mathrm{Real.log}(1+1/n)$ |
| [184](../intersection-form-zeta/lean/Enclosure.lean#L184) | lemma | `gammaLower_strictMono_step` | $\forall\,n : \mathbb{N},\ \forall\,hn : 3\le\ n,\ \mathrm{gammaLower}\ n<\mathrm{gammaLower}(n+1)$ |
| [204](../intersection-form-zeta/lean/Enclosure.lean#L204) | lemma | `gammaUpper_step` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \mathrm{gammaUpper}(n+1)-\mathrm{gammaUpper}\ n=1/(n+1)+1/(2\cdot(n+1))-1/(2\cdot(n+2))-\mathrm{Real.log}(1+1/n)$ |
| [221](../intersection-form-zeta/lean/Enclosure.lean#L221) | lemma | `gammaUpper_strictAnti_step` | $\forall\,n : \mathbb{N},\ \forall\,hn : 3\le\ n,\ \mathrm{gammaUpper}(n+1)<\mathrm{gammaUpper}\ n$ |
| [237](../intersection-form-zeta/lean/Enclosure.lean#L237) | lemma | `tendsto_one_div_two_mul_nat` | $:\mathrm{Tendsto}(\lambda\ n:\mathbb{N}\Rightarrow(1:\mathbb{R})/(2\cdot\ n))\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [245](../intersection-form-zeta/lean/Enclosure.lean#L245) | lemma | `tendsto_gammaLower` | $:\mathrm{Tendsto}\ \mathrm{gammaLower}\ \mathrm{atTop}(\mathcal{N}\ \mathrm{Real.eulerMascheroniConstant})$ |
| [254](../intersection-form-zeta/lean/Enclosure.lean#L254) | lemma | `monotone_gammaLower_shift` | $:\mathrm{Monotone}(\lambda\ k:\mathbb{N}\Rightarrow\ \mathrm{gammaLower}(k+3))$ |
| [259](../intersection-form-zeta/lean/Enclosure.lean#L259) | lemma | `tendsto_gammaLower_shift` | $:\mathrm{Tendsto}(\lambda\ k:\mathbb{N}\Rightarrow\ \mathrm{gammaLower}(k+3))\ \mathrm{atTop}(\mathcal{N}\ \mathrm{Real.eulerMascheroniConstant})$ |
| [264](../intersection-form-zeta/lean/Enclosure.lean#L264) | lemma | `gammaLower_le_gamma` | $\forall\,k : \mathbb{N},\ \mathrm{gammaLower}(k+3)\le\ \mathrm{Real.eulerMascheroniConstant}$ |
| [270](../intersection-form-zeta/lean/Enclosure.lean#L270) | lemma | `gammaLower_lt_gamma` | $\forall\,k : \mathbb{N},\ \mathrm{gammaLower}(k+3)<\mathrm{Real.eulerMascheroniConstant}$ |
| [279](../intersection-form-zeta/lean/Enclosure.lean#L279) | lemma | `tendsto_one_div_two_mul_add_one_nat` | $:\mathrm{Tendsto}(\lambda\ n:\mathbb{N}\Rightarrow(1:\mathbb{R})/(2\cdot(n+1)))\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [289](../intersection-form-zeta/lean/Enclosure.lean#L289) | lemma | `tendsto_gammaUpper` | $:\mathrm{Tendsto}\ \mathrm{gammaUpper}\ \mathrm{atTop}(\mathcal{N}\ \mathrm{Real.eulerMascheroniConstant})$ |
| [297](../intersection-form-zeta/lean/Enclosure.lean#L297) | lemma | `antitone_gammaUpper_shift` | $:\mathrm{Antitone}(\lambda\ k:\mathbb{N}\Rightarrow\ \mathrm{gammaUpper}(k+3))$ |
| [302](../intersection-form-zeta/lean/Enclosure.lean#L302) | lemma | `tendsto_gammaUpper_shift` | $:\mathrm{Tendsto}(\lambda\ k:\mathbb{N}\Rightarrow\ \mathrm{gammaUpper}(k+3))\ \mathrm{atTop}(\mathcal{N}\ \mathrm{Real.eulerMascheroniConstant})$ |
| [307](../intersection-form-zeta/lean/Enclosure.lean#L307) | lemma | `gammaUpper_ge_gamma` | $\forall\,k : \mathbb{N},\ \mathrm{Real.eulerMascheroniConstant}\le\ \mathrm{gammaUpper}(k+3)$ |
| [313](../intersection-form-zeta/lean/Enclosure.lean#L313) | lemma | `gammaUpper_gt_gamma` | $\forall\,k : \mathbb{N},\ \mathrm{Real.eulerMascheroniConstant}<\mathrm{gammaUpper}(k+3)$ |
| [342](../intersection-form-zeta/lean/Enclosure.lean#L342) | theorem | `logPartialQ_cast` | $\forall\,a : \mathbb{Q},\ \forall\,N : \mathbb{N},\ ((\mathrm{logPartialQ}\ N\ a:\mathbb{Q}):\mathbb{R})=\sum\ k\ \in\ \mathrm{Finset.range}\ N,(2:\mathbb{R})\cdot(1/(2\cdot(k:\mathbb{R})+1))\cdot((a:\mathbb{R})/((a:\mathbb{R})+2))^{2\cdot\ k+1}$ |
| [353](../intersection-form-zeta/lean/Enclosure.lean#L353) | theorem | `logRemQ_cast` | $\forall\,a : \mathbb{Q},\ \forall\,N : \mathbb{N},\ ((\mathrm{logRemQ}\ N\ a:\mathbb{Q}):\mathbb{R})=(2:\mathbb{R})\cdot((a:\mathbb{R})/((a:\mathbb{R})+2))^{2\cdot\ N+1}/((2\cdot(N:\mathbb{R})+1)\cdot(1-((a:\mathbb{R})/((a:\mathbb{R})+2))^{2}))$ |
| [361](../intersection-form-zeta/lean/Enclosure.lean#L361) | theorem | `logPartialQ_le_log` | $\forall\,x : \mathbb{Q},\ \forall\,hx : 1\le\ x,\ \forall\,N : \mathbb{N},\ (\mathrm{logPartialQ}\ N(x-1):\mathbb{R})\le\ \mathrm{Real.log}(x:\mathbb{R})$ |
| [375](../intersection-form-zeta/lean/Enclosure.lean#L375) | theorem | `log_le_logPartialQ_add_rem` | $\forall\,x : \mathbb{Q},\ \forall\,hx : 1\le\ x,\ \forall\,N : \mathbb{N},\ \mathrm{Real.log}(x:\mathbb{R})\le(\mathrm{logPartialQ}\ N(x-1):\mathbb{R})+(\mathrm{logRemQ}\ N(x-1):\mathbb{R})$ |
| [457](../intersection-form-zeta/lean/Enclosure.lean#L457) | theorem | `logPoint_mem` | $\forall\,N : \mathbb{N},\ \forall\,x : \mathbb{Q},\ \forall\,hx : 1\le\ x,\ (\mathrm{logPointLo}\ N\ x:\mathbb{R})\le\ \mathrm{Real.log}(x:\mathbb{R})\ \land\ \mathrm{Real.log}(x:\mathbb{R})\le(\mathrm{logPointHi}\ N\ x:\mathbb{R})$ |
| [467](../intersection-form-zeta/lean/Enclosure.lean#L467) | theorem | `log200_mem` | $\forall\,N : \mathbb{N},\ (\mathrm{log200Lo}\ N:\mathbb{R})\le\ \mathrm{Real.log}\ 200\ \land\ \mathrm{Real.log}\ 200\le(\mathrm{log200Hi}\ N:\mathbb{R})$ |
| [494](../intersection-form-zeta/lean/Enclosure.lean#L494) | theorem | `gammaBoundLo_lt` | $\forall\,N : \mathbb{N},\ (\mathrm{gammaBoundLo}\ N:\mathbb{R})<\mathrm{Real.eulerMascheroniConstant}$ |
| [506](../intersection-form-zeta/lean/Enclosure.lean#L506) | theorem | `gammaBoundHi_gt` | $\forall\,N : \mathbb{N},\ \mathrm{Real.eulerMascheroniConstant}<(\mathrm{gammaBoundHi}\ N:\mathbb{R})$ |
| [522](../intersection-form-zeta/lean/Enclosure.lean#L522) | theorem | `gamma_mem` | $:(\mathrm{gammaLo}:\mathbb{R})<\mathrm{Real.eulerMascheroniConstant}\ \land\ \mathrm{Real.eulerMascheroniConstant}<(\mathrm{gammaHi}:\mathbb{R})$ |
| [530](../intersection-form-zeta/lean/Enclosure.lean#L530) | theorem | `Omega_zero` | $:\mathrm{Omega}\ 0=-\mathrm{Real.log}\ \mathrm{Real.pi}-\mathrm{Real.eulerMascheroniConstant}-\mathrm{Real.pi}/2-3\cdot\ \mathrm{Real.log}\ 2$ |
| [556](../intersection-form-zeta/lean/Enclosure.lean#L556) | theorem | `pi_mem` | $:(\mathrm{piLo}:\mathbb{R})<\mathrm{Real.pi}\ \land\ \mathrm{Real.pi}<(\mathrm{piHi}:\mathbb{R})$ |
| [565](../intersection-form-zeta/lean/Enclosure.lean#L565) | theorem | `log_pi_mem` | $\forall\,N : \mathbb{N},\ (\mathrm{logPointLo}\ N\ \mathrm{piLo}:\mathbb{R})\le\ \mathrm{Real.log}\ \mathrm{Real.pi}\ \land\ \mathrm{Real.log}\ \mathrm{Real.pi}\le(\mathrm{logPointHi}\ N\ \mathrm{piHi}:\mathbb{R})$ |
| [582](../intersection-form-zeta/lean/Enclosure.lean#L582) | theorem | `omegaZero_mem` | $\forall\,N : \mathbb{N},\ (\mathrm{omegaZeroLo}\ N:\mathbb{R})\le\ \mathrm{Omega}\ 0\ \land\ \mathrm{Omega}\ 0\le(\mathrm{omegaZeroHi}\ N:\mathbb{R})$ |
| [599](../intersection-form-zeta/lean/Enclosure.lean#L599) | theorem | `digamma_conj` | $\forall\,z : \mathbb{C},\ \forall\,hz : \forall\ m:\mathbb{N},\ z\ne-(m:\mathbb{C}),\ \mathrm{Complex.digamma}(\mathrm{conj}\ z)=\mathrm{conj}(\mathrm{Complex.digamma}\ z)$ |
| [623](../intersection-form-zeta/lean/Enclosure.lean#L623) | theorem | `Omega_even` | $\forall\,t : \mathbb{R},\ \mathrm{Omega}(-t)=\mathrm{Omega}\ t$ |
