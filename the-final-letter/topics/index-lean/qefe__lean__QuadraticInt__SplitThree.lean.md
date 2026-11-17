# `qefe/lean/QuadraticInt/SplitThree.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/SplitThree.lean`](../qefe/lean/QuadraticInt/SplitThree.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [28](../qefe/lean/QuadraticInt/SplitThree.lean#L28) | theorem | `exists_root_sq_add_X_add_one` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=1,\ \exists\ x:\mathrm{ZMod}\ p,\ x^{2}+x+1=0$ |
| [52](../qefe/lean/QuadraticInt/SplitThree.lean#L52) | theorem | `not_irreducible_of_dvd_sq_add_X_add_one` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,m : \mathbb{Z},\ \forall\,hm : (p:\mathbb{Z})\ \mid\ m^{2}+m+1,\ \neg\ \mathrm{Irreducible}(p:\mathrm{EisensteinInt})$ |
| [90](../qefe/lean/QuadraticInt/SplitThree.lean#L90) | theorem | `exists_normE_of_not_irreducible` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hpi : \neg\ \mathrm{Irreducible}(p:\mathrm{EisensteinInt}),\ \exists\ a\ b:\mathbb{Z},\ a^{2}-a\cdot\ b+b^{2}=p$ |
| [160](../qefe/lean/QuadraticInt/SplitThree.lean#L160) | theorem | `prime_normE` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=1,\ \exists\ a\ b:\mathbb{Z},\ a^{2}-a\cdot\ b+b^{2}=p$ |
