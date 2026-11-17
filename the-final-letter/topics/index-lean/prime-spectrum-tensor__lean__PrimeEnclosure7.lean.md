# `prime-spectrum-tensor/lean/PrimeEnclosure7.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/PrimeEnclosure7.lean`](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean) — 20 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [24](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L24) | theorem | `six_fifths_domination` | $\forall\,x : \mathbb{R},\ \forall\,hx : \mathrm{Real.log}\ 5\le\ x,\ -100\cdot(x-6/5)^{2}\le-7\cdot\ x$ |
| [43](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L43) | theorem | `inv_six_telescope` | $\forall\,n : \mathbb{N},\ (((n:\mathbb{R})+5)^{6})^{-1}\le(1/5)\cdot((((n:\mathbb{R})+4)^{5})^{-1}-(((n:\mathbb{R})+5)^{5})^{-1})$ |
| [65](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L65) | theorem | `sum_tail_inv_six_le` | $\forall\,N : \mathbb{N},\ \sum\ n\ \in\ \mathrm{Finset.range}\ N,(((n:\mathbb{R})+5)^{6})^{-1}\le\ 1/5120$ |
| [87](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L87) | theorem | `six_fifths_term_le` | $\forall\,n : \mathbb{N},\ \mathrm{primeSummand}(6/5)(n+5)\le\ \mathrm{Real.sqrt}\ \mathrm{Real.pi}/20\cdot(((n:\mathbb{R})+5)^{6})^{-1}$ |
| [143](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L143) | theorem | `six_fifths_tail_le` | $:\sum'\ n:\mathbb{N},\ \mathrm{primeSummand}(6/5)(n+5)\le\ 1/50000$ |
| [162](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L162) | theorem | `primeSummand_two_six_fifths` | $:\mathrm{primeSummand}(6/5)\ 2\le\ 1/10000000000$ |
| [202](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L202) | theorem | `six_fifths_exponent_three` | $:-100\cdot(\mathrm{Real.log}\ 3-6/5)^{2}\ \in\ \mathrm{Set.Icc}(-(102799321/100000000):\mathbb{R})(-(25694761/25000000))$ |
| [211](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L211) | theorem | `primeSummand_three_six_fifths` | $:\mathrm{primeSummand}(6/5)\ 3\ \in\ \mathrm{Set.Icc}(20107/1000000:\mathbb{R})(20114/1000000)$ |
| [260](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L260) | theorem | `six_fifths_exponent_four` | $:-100\cdot(\mathrm{Real.log}\ 4-6/5)^{2}\ \in\ \mathrm{Set.Icc}(-(542284369/156250000):\mathbb{R})(-(8676363609/2500000000))$ |
| [299](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L299) | theorem | `prime_sum_split_six_fifths` | $:(\sum'\ n:\mathbb{N},\ \mathrm{primeSummand}(6/5)\ n)=\mathrm{primeSummand}(6/5)\ 2+\mathrm{primeSummand}(6/5)\ 3+\mathrm{primeSummand}(6/5)\ 4+\sum'\ n:\mathbb{N},\ \mathrm{primeSummand}(6/5)(n+5)$ |
| [323](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L323) | theorem | `vonMangoldt_four` | $:\mathrm{ArithmeticFunction.vonMangoldt}\ 4=\mathrm{Real.log}\ 2$ |
| [329](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L329) | theorem | `primeSummand_four_six_fifths` | $:\mathrm{primeSummand}(6/5)\ 4\ \in\ \mathrm{Set.Icc}(955/1000000:\mathbb{R})(956/1000000)$ |
| [396](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L396) | theorem | `primeTerm_mem_six_fifths` | $:\mathrm{primeTerm}(6/5)(1/20)\ \in\ \mathrm{Set.Icc}(-42181/1000000:\mathbb{R})(-42124/1000000)$ |
| [415](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L415) | theorem | `exp_neg_144_le` | $:\mathrm{Real.exp}(-144:\mathbb{R})\le\ 1/1000000000$ |
| [430](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L430) | theorem | `inv_sq_telescope` | $\forall\,n : \mathbb{N},\ (((n:\mathbb{R})+2)^{2})^{-1}\le(((n:\mathbb{R})+1)^{-1}-((n:\mathbb{R})+2)^{-1})$ |
| [441](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L441) | theorem | `sum_inv_sq_le` | $\forall\,N : \mathbb{N},\ \sum\ n\ \in\ \mathrm{Finset.range}\ N,(((n:\mathbb{R})+2)^{2})^{-1}\le\ 1$ |
| [456](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L456) | theorem | `neg_term_le` | $\forall\,n : \mathbb{N},\ \mathrm{primeSummand}(-(6/5))(n+1)\le\ \mathrm{Real.sqrt}\ \mathrm{Real.pi}/20\cdot(1/1000000000)\cdot(((n:\mathbb{R})+1)^{2})^{-1}$ |
| [522](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L522) | theorem | `sum_inv_sq_succ_le` | $\forall\,N : \mathbb{N},\ \sum\ n\ \in\ \mathrm{Finset.range}\ N,(((n:\mathbb{R})+1)^{2})^{-1}\le\ 2$ |
| [541](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L541) | theorem | `primeTerm_mem_neg_six_fifths` | $:\mathrm{primeTerm}(-(6/5))(1/20)\ \in\ \mathrm{Set.Icc}(-(1/100000):\mathbb{R})\ 0$ |
| [573](../prime-spectrum-tensor/lean/PrimeEnclosure7.lean#L573) | theorem | `primeTerm_sym_mem_six_fifths` | $:(\mathrm{primeTerm}(6/5)(1/20)+\mathrm{primeTerm}(-(6/5))(1/20))/2\ \in\ \mathrm{Set.Icc}(-21100000/1000000000:\mathbb{R})(-21030000/1000000000)$ |
