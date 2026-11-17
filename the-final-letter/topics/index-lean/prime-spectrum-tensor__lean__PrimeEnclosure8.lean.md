# `prime-spectrum-tensor/lean/PrimeEnclosure8.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/PrimeEnclosure8.lean`](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean) — 15 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [22](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L22) | theorem | `sqrt_five_mem` | $:(2236067/1000000:\mathbb{R})\le\ \mathrm{Real.sqrt}\ 5\ \land\ \mathrm{Real.sqrt}\ 5\le\ 2236068/1000000$ |
| [28](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L28) | theorem | `vonMangoldt_five` | $:\mathrm{ArithmeticFunction.vonMangoldt}\ 5=\mathrm{Real.log}\ 5$ |
| [34](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L34) | theorem | `seven_fifths_domination` | $\forall\,x : \mathbb{R},\ \forall\,hx : \mathrm{Real.log}\ 7\le\ x,\ -100\cdot(x-7/5)^{2}\le-3\cdot\ x-22$ |
| [63](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L63) | theorem | `seven_fifths_term_le` | $\forall\,n : \mathbb{N},\ \mathrm{primeSummand}(7/5)(n+7)\le\ \mathrm{Real.sqrt}\ \mathrm{Real.pi}/20\cdot(1/1000000000)\cdot(((n:\mathbb{R})+7)^{2})^{-1}$ |
| [142](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L142) | theorem | `seven_fifths_tail_le` | $:\sum'\ n:\mathbb{N},\ \mathrm{primeSummand}(7/5)(n+7)\le\ 1/10000000$ |
| [166](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L166) | theorem | `seven_fifths_exponent_four` | $:-100\cdot(\mathrm{Real.log}\ 4-7/5)^{2}\ \in\ \mathrm{Set.Icc}(-(117402854881/6250000000000):\mathbb{R})(-(469610048961/25000000000000))$ |
| [208](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L208) | theorem | `seven_fifths_exponent_three` | $:-100\cdot(\mathrm{Real.log}\ 3-7/5)^{2}\ \in\ \mathrm{Set.Icc}(-(908359321/100000000):\mathbb{R})(-(227074761/25000000))$ |
| [214](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L214) | theorem | `seven_fifths_exponent_five` | $:-100\cdot(\mathrm{Real.log}\ 5-7/5)^{2}\ \in\ \mathrm{Set.Icc}(-(10966068961/2500000000):\mathbb{R})(-(4386423395641/1000000000000))$ |
| [220](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L220) | theorem | `primeSummand_four_7_5` | $:\mathrm{primeSummand}(7/5)\ 4\ \in\ \mathrm{Set.Icc}(30141/1000000:\mathbb{R})(30144/1000000)$ |
| [291](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L291) | theorem | `primeSummand_three_7_5` | $:\mathrm{primeSummand}(7/5)\ 3\ \in\ \mathrm{Set.Icc}(63/10000000:\mathbb{R})(64/10000000)$ |
| [357](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L357) | theorem | `primeSummand_five_7_5` | $:\mathrm{primeSummand}(7/5)\ 5\ \in\ \mathrm{Set.Icc}(7935/10000000:\mathbb{R})(7945/10000000)$ |
| [428](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L428) | theorem | `primeSummand_six_7_5` | $:\mathrm{primeSummand}(7/5)\ 6\le\ 1/100000$ |
| [487](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L487) | theorem | `primeSummand_two_7_5` | $:\mathrm{primeSummand}(7/5)\ 2\le\ 1/100000000000000000000$ |
| [524](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L524) | theorem | `prime_sum_split_seven_fifths` | $:(\sum'\ n:\mathbb{N},\ \mathrm{primeSummand}(7/5)\ n)=\mathrm{primeSummand}(7/5)\ 2+\mathrm{primeSummand}(7/5)\ 3+\mathrm{primeSummand}(7/5)\ 4+\mathrm{primeSummand}(7/5)\ 5+\mathrm{primeSummand}(7/5)\ 6+\sum'\ n:\mathbb{N},\ \mathrm{primeSummand}(7/5)(n+7)$ |
| [555](../prime-spectrum-tensor/lean/PrimeEnclosure8.lean#L555) | theorem | `primeTerm_mem_seven_fifths` | $:\mathrm{primeTerm}(7/5)(1/20)\ \in\ \mathrm{Set.Icc}(-61920/1000000:\mathbb{R})(-61850/1000000)$ |
