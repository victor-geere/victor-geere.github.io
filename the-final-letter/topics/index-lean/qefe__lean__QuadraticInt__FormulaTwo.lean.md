# `qefe/lean/QuadraticInt/FormulaTwo.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/FormulaTwo.lean`](../qefe/lean/QuadraticInt/FormulaTwo.lean) — 20 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [34](../qefe/lean/QuadraticInt/FormulaTwo.lean#L34) | lemma | `chi8_nat_split` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp : p\ \%\ 8=1\ \lor\ p\ \%\ 8=3,\ \mathrm{ZMod.}\chi_{8}'(p:\mathrm{ZMod}\ 8)=1$ |
| [40](../qefe/lean/QuadraticInt/FormulaTwo.lean#L40) | lemma | `chi8_nat_inert` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp : p\ \%\ 8=5\ \lor\ p\ \%\ 8=7,\ \mathrm{ZMod.}\chi_{8}'(p:\mathrm{ZMod}\ 8)=-1$ |
| [46](../qefe/lean/QuadraticInt/FormulaTwo.lean#L46) | lemma | `chi8_mul_zmod` | $:\forall\ a\ b:\mathrm{ZMod}\ 8,\ \mathrm{ZMod.}\chi_{8}'(a\cdot\ b)=\mathrm{ZMod.}\chi_{8}'\ a\cdot\ \mathrm{ZMod.}\chi_{8}'\ b$ |
| [49](../qefe/lean/QuadraticInt/FormulaTwo.lean#L49) | lemma | `chi8_pow_split` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp : p\ \%\ 8=1\ \lor\ p\ \%\ 8=3,\ \forall\,j : \mathbb{N},\ \mathrm{ZMod.}\chi_{8}'((p^{j}:\mathbb{N}):\mathrm{ZMod}\ 8)=1$ |
| [57](../qefe/lean/QuadraticInt/FormulaTwo.lean#L57) | lemma | `chi8_pow_inert` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp : p\ \%\ 8=5\ \lor\ p\ \%\ 8=7,\ \forall\,j : \mathbb{N},\ \mathrm{ZMod.}\chi_{8}'((p^{j}:\mathbb{N}):\mathrm{ZMod}\ 8)=(-1:\mathbb{Z})^{j}$ |
| [66](../qefe/lean/QuadraticInt/FormulaTwo.lean#L66) | lemma | `chi8_pow_two` | $\forall\,j : \mathbb{N},\ \mathrm{ZMod.}\chi_{8}'((2^{j}:\mathbb{N}):\mathrm{ZMod}\ 8)=\text{if}\ j=0\ \text{then}\ 1\ \text{else}\ 0$ |
| [77](../qefe/lean/QuadraticInt/FormulaTwo.lean#L77) | lemma | `divisorSumChi8_split` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp : p\ \%\ 8=1\ \lor\ p\ \%\ 8=3,\ \forall\,k : \mathbb{N},\ \mathrm{divisorSumChi8}(p^{k})=(k+1:\mathbb{Z})$ |
| [88](../qefe/lean/QuadraticInt/FormulaTwo.lean#L88) | lemma | `divisorSumChi8_inert` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,hp : p\ \%\ 8=5\ \lor\ p\ \%\ 8=7,\ \forall\,k : \mathbb{N},\ \mathrm{divisorSumChi8}(p^{k})=\text{if}\ \mathrm{Even}\ k\ \text{then}\ 1\ \text{else}\ 0$ |
| [102](../qefe/lean/QuadraticInt/FormulaTwo.lean#L102) | lemma | `divisorSumChi8_two` | $\forall\,k : \mathbb{N},\ \mathrm{divisorSumChi8}(2^{k})=1$ |
| [117](../qefe/lean/QuadraticInt/FormulaTwo.lean#L117) | lemma | `chi8_mul` | $\forall\,a\,b : \mathbb{Z},\ \mathrm{ZMod.}\chi_{8}'(a\cdot\ b)=\mathrm{ZMod.}\chi_{8}'\ a\cdot\ \mathrm{ZMod.}\chi_{8}'\ b$ |
| [121](../qefe/lean/QuadraticInt/FormulaTwo.lean#L121) | lemma | `divisorSumChi8_mul` | $\forall\,m\,n : \mathbb{N},\ \forall\,hmn : \mathrm{Nat.Coprime}\ m\ n,\ \mathrm{divisorSumChi8}(m\cdot\ n)=\mathrm{divisorSumChi8}\ m\cdot\ \mathrm{divisorSumChi8}\ n$ |
| [155](../qefe/lean/QuadraticInt/FormulaTwo.lean#L155) | lemma | `idealCountTwo_one` | $:\mathrm{idealCountTwo}\ 1=1$ |
| [165](../qefe/lean/QuadraticInt/FormulaTwo.lean#L165) | lemma | `idealCountFunTwo_isMultiplicative` | $:\mathrm{idealCountFunTwo.IsMultiplicative}$ |
| [182](../qefe/lean/QuadraticInt/FormulaTwo.lean#L182) | lemma | `divisorSumFunTwo_isMultiplicative` | $:\mathrm{divisorSumFunTwo.IsMultiplicative}$ |
| [188](../qefe/lean/QuadraticInt/FormulaTwo.lean#L188) | lemma | `idealCountTwo_prime_pow_eq` | $\forall\,p\,i : \mathbb{N},\ \forall\,hp : p.\mathrm{Prime},\ \mathrm{idealCountFunTwo}(p^{i})=\mathrm{divisorSumFunTwo}(p^{i})$ |
| [229](../qefe/lean/QuadraticInt/FormulaTwo.lean#L229) | theorem | `idealCountTwoFormula` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ (\mathrm{idealCountTwo}\ n:\mathbb{Z})=\mathrm{divisorSumChi8}\ n$ |
| [243](../qefe/lean/QuadraticInt/FormulaTwo.lean#L243) | theorem | `rTwo_formula` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \mathrm{Nat.card}(\mathrm{NormElementsTwo}\ n)=2\cdot\ \mathrm{idealCountTwo}\ n$ |
| [247](../qefe/lean/QuadraticInt/FormulaTwo.lean#L247) | theorem | `idealCountTwo_eq_divisorSum` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \mathrm{idealCountTwo}\ n=(\mathrm{divisorSumChi8}\ n).\mathrm{toNat}$ |
| [265](../qefe/lean/QuadraticInt/FormulaTwo.lean#L265) | theorem | `idealCountTwo_closed` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ (\mathrm{idealCountTwo}\ n:\mathbb{Z})=\sum\ d\ \in\ n.\mathrm{divisors},\ \mathrm{ZMod.}\chi_{8}'(d:\mathrm{ZMod}\ 8)$ |
| [272](../qefe/lean/QuadraticInt/FormulaTwo.lean#L272) | theorem | `rTwo_closed` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ (\mathrm{Nat.card}(\mathrm{NormElementsTwo}\ n):\mathbb{Z})=2\cdot\ \sum\ d\ \in\ n.\mathrm{divisors},\ \mathrm{ZMod.}\chi_{8}'(d:\mathrm{ZMod}\ 8)$ |
