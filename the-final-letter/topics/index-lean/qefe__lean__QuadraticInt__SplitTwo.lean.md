# `qefe/lean/QuadraticInt/SplitTwo.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/SplitTwo.lean`](../qefe/lean/QuadraticInt/SplitTwo.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [31](../qefe/lean/QuadraticInt/SplitTwo.lean#L31) | theorem | `isSquare_neg_two` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{8} : p\ \%\ 8=1\ \lor\ p\ \%\ 8=3,\ \mathrm{IsSquare}((-2:\mathbb{Z}):\mathrm{ZMod}\ p)$ |
| [53](../qefe/lean/QuadraticInt/SplitTwo.lean#L53) | theorem | `not_irreducible_of_dvd_sq_add_two` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,m : \mathbb{Z},\ \forall\,hm : (p:\mathbb{Z})\ \mid\ m^{2}+2,\ \neg\ \mathrm{Irreducible}(p:\mathrm{R2})$ |
| [95](../qefe/lean/QuadraticInt/SplitTwo.lean#L95) | theorem | `exists_nat_repr_of_not_irreducible` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hpi : \neg\ \mathrm{Irreducible}(p:\mathrm{R2}),\ \exists\ a\ b:\mathbb{N},\ a^{2}+2\cdot\ b^{2}=p$ |
| [175](../qefe/lean/QuadraticInt/SplitTwo.lean#L175) | theorem | `prime_sq_add_two_sq` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{hp}:\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{8} : p\ \%\ 8=1\ \lor\ p\ \%\ 8=3,\ \exists\ a\ b:\mathbb{N},\ a^{2}+2\cdot\ b^{2}=p$ |
