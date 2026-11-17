# `qefe/lean/QuadraticInt/FormulaThree.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/FormulaThree.lean`](../qefe/lean/QuadraticInt/FormulaThree.lean) — 23 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [30](../qefe/lean/QuadraticInt/FormulaThree.lean#L30) | lemma | `chi3_zero` | $:\mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(0:\mathrm{ZMod}\ 3)=0$ |
| [31](../qefe/lean/QuadraticInt/FormulaThree.lean#L31) | lemma | `chi3_one` | $:\mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(1:\mathrm{ZMod}\ 3)=1$ |
| [32](../qefe/lean/QuadraticInt/FormulaThree.lean#L32) | lemma | `chi3_two` | $:\mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(2:\mathrm{ZMod}\ 3)=-1$ |
| [34](../qefe/lean/QuadraticInt/FormulaThree.lean#L34) | lemma | `chi3_nat_split` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=1,\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(p:\mathrm{ZMod}\ 3)=1$ |
| [45](../qefe/lean/QuadraticInt/FormulaThree.lean#L45) | lemma | `chi3_nat_inert` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=2,\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(p:\mathrm{ZMod}\ 3)=-1$ |
| [56](../qefe/lean/QuadraticInt/FormulaThree.lean#L56) | lemma | `chi3_mul_zmod` | $:\forall\ a\ b:\mathrm{ZMod}\ 3,\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(a\cdot\ b)=\mathrm{quadraticChar}(\mathrm{ZMod}\ 3)\ a\cdot\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)\ b$ |
| [60](../qefe/lean/QuadraticInt/FormulaThree.lean#L60) | lemma | `chi3_pow_split` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=1,\ \forall\,j : \mathbb{N},\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)((p^{j}:\mathbb{N}):\mathrm{ZMod}\ 3)=1$ |
| [68](../qefe/lean/QuadraticInt/FormulaThree.lean#L68) | lemma | `chi3_pow_inert` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=2,\ \forall\,j : \mathbb{N},\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)((p^{j}:\mathbb{N}):\mathrm{ZMod}\ 3)=(-1:\mathbb{Z})^{j}$ |
| [77](../qefe/lean/QuadraticInt/FormulaThree.lean#L77) | lemma | `chi3_pow_three` | $\forall\,j : \mathbb{N},\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)((3^{j}:\mathbb{N}):\mathrm{ZMod}\ 3)=\text{if}\ j=0\ \text{then}\ 1\ \text{else}\ 0$ |
| [89](../qefe/lean/QuadraticInt/FormulaThree.lean#L89) | lemma | `divisorSumChi3_split` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=1,\ \forall\,k : \mathbb{N},\ \mathrm{divisorSumChi3}(p^{k})=(k+1:\mathbb{Z})$ |
| [99](../qefe/lean/QuadraticInt/FormulaThree.lean#L99) | lemma | `divisorSumChi3_inert` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp_{3} : p\ \%\ 3=2,\ \forall\,k : \mathbb{N},\ \mathrm{divisorSumChi3}(p^{k})=\text{if}\ \mathrm{Even}\ k\ \text{then}\ 1\ \text{else}\ 0$ |
| [112](../qefe/lean/QuadraticInt/FormulaThree.lean#L112) | lemma | `divisorSumChi3_three` | $\forall\,k : \mathbb{N},\ \mathrm{divisorSumChi3}(3^{k})=1$ |
| [127](../qefe/lean/QuadraticInt/FormulaThree.lean#L127) | lemma | `chi3_mul` | $\forall\,a\,b : \mathbb{Z},\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(a\cdot\ b)=\mathrm{quadraticChar}(\mathrm{ZMod}\ 3)\ a\cdot\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)\ b$ |
| [132](../qefe/lean/QuadraticInt/FormulaThree.lean#L132) | lemma | `divisorSumChi3_mul` | $\forall\,m\,n : \mathbb{N},\ \forall\,hmn : \mathrm{Nat.Coprime}\ m\ n,\ \mathrm{divisorSumChi3}(m\cdot\ n)=\mathrm{divisorSumChi3}\ m\cdot\ \mathrm{divisorSumChi3}\ n$ |
| [166](../qefe/lean/QuadraticInt/FormulaThree.lean#L166) | lemma | `idealCountThree_one` | $:\mathrm{idealCountThree}\ 1=1$ |
| [176](../qefe/lean/QuadraticInt/FormulaThree.lean#L176) | lemma | `idealCountFunThree_isMultiplicative` | $:\mathrm{idealCountFunThree.IsMultiplicative}$ |
| [194](../qefe/lean/QuadraticInt/FormulaThree.lean#L194) | lemma | `divisorSumFunThree_isMultiplicative` | $:\mathrm{divisorSumFunThree.IsMultiplicative}$ |
| [200](../qefe/lean/QuadraticInt/FormulaThree.lean#L200) | lemma | `idealCountThree_prime_pow_eq` | $\forall\,p\,i : \mathbb{N},\ \forall\,hp : p.\mathrm{Prime},\ \mathrm{idealCountFunThree}(p^{i})=\mathrm{divisorSumFunThree}(p^{i})$ |
| [236](../qefe/lean/QuadraticInt/FormulaThree.lean#L236) | theorem | `idealCountThreeFormula` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ (\mathrm{idealCountThree}\ n:\mathbb{Z})=\mathrm{divisorSumChi3}\ n$ |
| [250](../qefe/lean/QuadraticInt/FormulaThree.lean#L250) | theorem | `rThree_formula` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \mathrm{Nat.card}(\mathrm{NormElementsThree}\ n)=6\cdot\ \mathrm{idealCountThree}\ n$ |
| [254](../qefe/lean/QuadraticInt/FormulaThree.lean#L254) | theorem | `idealCountThree_eq_divisorSum` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \mathrm{idealCountThree}\ n=(\mathrm{divisorSumChi3}\ n).\mathrm{toNat}$ |
| [267](../qefe/lean/QuadraticInt/FormulaThree.lean#L267) | theorem | `idealCountThree_closed` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ (\mathrm{idealCountThree}\ n:\mathbb{Z})=\sum\ d\ \in\ n.\mathrm{divisors},\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(d:\mathrm{ZMod}\ 3)$ |
| [274](../qefe/lean/QuadraticInt/FormulaThree.lean#L274) | theorem | `rThree_closed` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ (\mathrm{Nat.card}(\mathrm{NormElementsThree}\ n):\mathbb{Z})=6\cdot\ \sum\ d\ \in\ n.\mathrm{divisors},\ \mathrm{quadraticChar}(\mathrm{ZMod}\ 3)(d:\mathrm{ZMod}\ 3)$ |
