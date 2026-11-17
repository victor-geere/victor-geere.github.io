# `qefe/lean/GaussianInt/TwoSquares.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/GaussianInt/TwoSquares.lean`](../qefe/lean/GaussianInt/TwoSquares.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [33](../qefe/lean/GaussianInt/TwoSquares.lean#L33) | lemma | `r2_eq_natCard_pairs` | $\forall\,n : \mathbb{N},\ \mathrm{r2}\ n=\mathrm{Nat.card}\ \{p:\mathbb{Z}\times\ \mathbb{Z}//p.\mathrm{1}^{2}+p.\mathrm{2}^{2}=(n:\mathbb{Z})\}$ |
| [60](../qefe/lean/GaussianInt/TwoSquares.lean#L60) | lemma | `r2_eq_natCard_gaussian` | $\forall\,n : \mathbb{N},\ \mathrm{r2}\ n=\mathrm{Nat.card}\ \{z:\mathrm{GaussianInt}//z.\mathrm{norm}.\mathrm{natAbs}=n\}$ |
| [65](../qefe/lean/GaussianInt/TwoSquares.lean#L65) | theorem | `r2_eq_four_mul_idealCount` | $\forall\,n : \mathbb{N},\ \forall\,hn : 0<n,\ \mathrm{r2}\ n=4\cdot\ \mathrm{Nat.card}\ \{I:\mathrm{Ideal}\ \mathrm{GaussianInt}//\mathrm{Ideal.absNorm}\ I=n\}$ |
| [70](../qefe/lean/GaussianInt/TwoSquares.lean#L70) | theorem | `twoSquaresFormula_of_idealCount` | $\forall\,h : \mathrm{IdealCountFormula},\ \mathrm{TwoSquaresFormula}$ |
| [79](../qefe/lean/GaussianInt/TwoSquares.lean#L79) | theorem | `twoSquaresFormula` | $:\mathrm{TwoSquaresFormula}$ |
