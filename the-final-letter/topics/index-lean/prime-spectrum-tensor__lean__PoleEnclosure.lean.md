# `prime-spectrum-tensor/lean/PoleEnclosure.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/PoleEnclosure.lean`](../prime-spectrum-tensor/lean/PoleEnclosure.lean) — 22 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [39](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L39) | theorem | `two_cosh_real` | $\forall\,x : \mathbb{R},\ 2\cdot\ \mathrm{Real.cosh}\ x=\mathrm{Real.exp}\ x+\mathrm{Real.exp}(-x)$ |
| [46](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L46) | theorem | `poleTerm_eq_inv20` | $\forall\,c : \mathbb{R},\ \mathrm{poleTerm}\ c(1/20)=(\mathrm{Real.pi}/100)\cdot\ \mathrm{Real.exp}(1/1600)\cdot\ \mathrm{Real.cosh}(c/2)$ |
| [57](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L57) | theorem | `pi_div_hundred_mem` | $:(31415/1000000:\mathbb{R})\le\ \mathrm{Real.pi}/100\ \land\ \mathrm{Real.pi}/100\le\ 31416/1000000$ |
| [64](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L64) | theorem | `exp_inv1600_mem` | $:(1+1/1600-1/1000000:\mathbb{R})\le\ \mathrm{Real.exp}(1/1600)\ \land\ \mathrm{Real.exp}(1/1600)\le\ 1+1/1600+1/1000000$ |
| [75](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L75) | theorem | `cosh_01_mem` | $:(10050041/10000000:\mathbb{R})\le\ \mathrm{Real.cosh}(1/10)\ \land\ \mathrm{Real.cosh}(1/10)\le\ 10050042/10000000$ |
| [87](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L87) | theorem | `cosh_02_mem` | $:(10200667/10000000:\mathbb{R})\le\ \mathrm{Real.cosh}(1/5)\ \land\ \mathrm{Real.cosh}(1/5)\le\ 10200668/10000000$ |
| [99](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L99) | theorem | `cosh_03_mem` | $:(10453385/10000000:\mathbb{R})\le\ \mathrm{Real.cosh}(3/10)\ \land\ \mathrm{Real.cosh}(3/10)\le\ 10453386/10000000$ |
| [112](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L112) | theorem | `poleTerm_between` | $\forall\,c : \mathbb{R},\ \forall\,clo\,chi : \mathbb{R},\ \forall\,h : \mathrm{clo}\le\ \mathrm{Real.cosh}(c/2)\ \land\ \mathrm{Real.cosh}(c/2)\le\ \mathrm{chi},\ \forall\,hclo : 0\le\ \mathrm{clo},\ (31415/1000000:\mathbb{R})\cdot(1+1/1600-1/1000000)\cdot\ \mathrm{clo}\le\ \mathrm{poleTerm}\ c(1/20)\ \land\ \mathrm{poleTerm}\ c(1/20)\le(31416/1000000:\mathbb{R})\cdot(1+1/1600+1/1000000)\cdot\ \mathrm{chi}$ |
| [134](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L134) | theorem | `poleTerm_neg` | $\forall\,c\,\sigma : \mathbb{R},\ \mathrm{poleTerm}(-c)\ \sigma=\mathrm{poleTerm}\ c\ \sigma$ |
| [139](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L139) | theorem | `poleTerm_mem_c0` | $:(31434/1000000:\mathbb{R})\le\ \mathrm{poleTerm}\ 0(1/20)\ \land\ \mathrm{poleTerm}\ 0(1/20)\le\ 31436/1000000$ |
| [150](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L150) | theorem | `poleTerm_mem_c1` | $:(31591/1000000:\mathbb{R})\le\ \mathrm{poleTerm}(1/5)(1/20)\ \land\ \mathrm{poleTerm}(1/5)(1/20)\le\ 31593/1000000$ |
| [162](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L162) | theorem | `poleTerm_mem_c2` | $:(32065/1000000:\mathbb{R})\le\ \mathrm{poleTerm}(2/5)(1/20)\ \land\ \mathrm{poleTerm}(2/5)(1/20)\le\ 32067/1000000$ |
| [174](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L174) | theorem | `poleTerm_mem_c3` | $:(32859/1000000:\mathbb{R})\le\ \mathrm{poleTerm}(3/5)(1/20)\ \land\ \mathrm{poleTerm}(3/5)(1/20)\le\ 32861/1000000$ |
| [186](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L186) | theorem | `cosh_04_mem` | $:(10810723/10000000:\mathbb{R})\le\ \mathrm{Real.cosh}(2/5)\ \land\ \mathrm{Real.cosh}(2/5)\le\ 10810724/10000000$ |
| [198](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L198) | theorem | `poleTerm_mem_c4` | $:(33982/1000000:\mathbb{R})\le\ \mathrm{poleTerm}(4/5)(1/20)\ \land\ \mathrm{poleTerm}(4/5)(1/20)\le\ 33985/1000000$ |
| [210](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L210) | theorem | `cosh_three_fifths_mem` | $:(1185460/1000000:\mathbb{R})\le\ \mathrm{Real.cosh}(3/5)\ \land\ \mathrm{Real.cosh}(3/5)\le\ 1185470/1000000$ |
| [224](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L224) | theorem | `poleTerm_mem_c6` | $:(37264/1000000:\mathbb{R})\le\ \mathrm{poleTerm}(6/5:\mathbb{R})(1/20)\ \land\ \mathrm{poleTerm}(6/5:\mathbb{R})(1/20)\le\ 37267/1000000$ |
| [236](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L236) | theorem | `cosh_seven_tenths_mem` | $:(1255168/1000000:\mathbb{R})\le\ \mathrm{Real.cosh}(7/10)\ \land\ \mathrm{Real.cosh}(7/10)\le\ 1255170/1000000$ |
| [250](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L250) | theorem | `poleTerm_mem_c75` | $:(39455/1000000:\mathbb{R})\le\ \mathrm{poleTerm}(7/5:\mathbb{R})(1/20)\ \land\ \mathrm{poleTerm}(7/5:\mathbb{R})(1/20)\le\ 39458/1000000$ |
| [266](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L266) | theorem | `cosh_half_mem` | $:(1127625/1000000:\mathbb{R})\le\ \mathrm{Real.cosh}(1/2)\ \land\ \mathrm{Real.cosh}(1/2)\le\ 1127627/1000000$ |
| [280](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L280) | theorem | `poleTerm_mem_c5` | $:(35446/1000000:\mathbb{R})\le\ \mathrm{poleTerm}(1:\mathbb{R})(1/20)\ \land\ \mathrm{poleTerm}(1:\mathbb{R})(1/20)\le\ 35448/1000000$ |
| [292](../prime-spectrum-tensor/lean/PoleEnclosure.lean#L292) | theorem | `poleTerm_pos` | $\forall\,c\,\sigma : \mathbb{R},\ \forall\,h\sigma : \sigma\ne\ 0,\ 0<\mathrm{poleTerm}\ c\ \sigma$ |
