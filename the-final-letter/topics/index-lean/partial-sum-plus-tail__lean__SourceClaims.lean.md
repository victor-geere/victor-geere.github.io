# `partial-sum-plus-tail/lean/SourceClaims.lean`

[Back to the split index](index.md) · Topic: [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md)

### [`partial-sum-plus-tail/lean/SourceClaims.lean`](../partial-sum-plus-tail/lean/SourceClaims.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [26](../partial-sum-plus-tail/lean/SourceClaims.lean#L26) | theorem | `riemannZeta_nat_re_le` | $\forall\,m : \mathbb{N},\ \forall\,hm : 2\le\ m,\ (\mathrm{riemannZeta}(m:\mathbb{C})).\mathrm{re}\le\ 1+1/((m:\mathbb{R})-1)$ |
| [105](../partial-sum-plus-tail/lean/SourceClaims.lean#L105) | theorem | `eta_eq_one_sub_two_cpow_mul_zeta` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{eta}\ s=(1-(2:\mathbb{C})^{1-s})\cdot\ \mathrm{riemannZeta}\ s$ |
| [178](../partial-sum-plus-tail/lean/SourceClaims.lean#L178) | theorem | `LFunction_eq_hurwitz_sum` | $\forall\,N : \mathbb{N},\ \forall\,[\mathrm{NeZero}\ N],\ \forall\,\chi : \mathrm{DirichletCharacter}\ \mathbb{C}\ N,\ \forall\,hN : N\ne\ 1,\ \forall\,s : \mathbb{C},\ \mathrm{DirichletCharacter.LFunction}\ \chi\ s=(N:\mathbb{C})^{-s}\cdot\ \sum\ j\ \in\ \mathrm{Finset.univ.erase}(0:\mathrm{ZMod}\ N),\ \chi\ j\cdot\ \mathrm{HurwitzZeta.hurwitzZeta}(\mathrm{ZMod.toAddCircle}\ j)\ s$ |
