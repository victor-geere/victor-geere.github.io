# `finite-explicit-formula/lean/PrimeSide.lean`

[Back to the split index](index.md) · Topic: [`finite-explicit-formula`](../finite-explicit-formula/README.md)

### [`finite-explicit-formula/lean/PrimeSide.lean`](../finite-explicit-formula/lean/PrimeSide.lean) — 15 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [26](../finite-explicit-formula/lean/PrimeSide.lean#L26) | theorem | `g1Box_mem` | $\forall\,x : \mathbb{R},\ \forall\,A : \mathrm{Iv},\ \forall\,h : A.\mathrm{memR}\ x,\ (\mathrm{g1Box}\ A).\mathrm{memR}(x^{3}/2-x^{2}+2/3)$ |
| [44](../finite-explicit-formula/lean/PrimeSide.lean#L44) | theorem | `g2Box_mem` | $\forall\,x : \mathbb{R},\ \forall\,A : \mathrm{Iv},\ \forall\,h : A.\mathrm{memR}\ x,\ (\mathrm{g2Box}\ A).\mathrm{memR}(-x^{3}/6+x^{2}-2\cdot\ x+4/3)$ |
| [72](../finite-explicit-formula/lean/PrimeSide.lean#L72) | theorem | `sqrtInvBox_mem2` | $:(\mathrm{sqrtInvBox}\ 2).\mathrm{memR}(1/\mathrm{Real.sqrt}\ 2)$ |
| [84](../finite-explicit-formula/lean/PrimeSide.lean#L84) | theorem | `sqrtInvBox_mem3` | $:(\mathrm{sqrtInvBox}\ 3).\mathrm{memR}(1/\mathrm{Real.sqrt}\ 3)$ |
| [96](../finite-explicit-formula/lean/PrimeSide.lean#L96) | theorem | `sqrtInvBox_mem4` | $:(\mathrm{sqrtInvBox}\ 4).\mathrm{memR}(1/\mathrm{Real.sqrt}\ 4)$ |
| [101](../finite-explicit-formula/lean/PrimeSide.lean#L101) | theorem | `sqrtInvBox_mem5` | $:(\mathrm{sqrtInvBox}\ 5).\mathrm{memR}(1/\mathrm{Real.sqrt}\ 5)$ |
| [113](../finite-explicit-formula/lean/PrimeSide.lean#L113) | theorem | `sqrtInvBox_mem7` | $:(\mathrm{sqrtInvBox}\ 7).\mathrm{memR}(1/\mathrm{Real.sqrt}\ 7)$ |
| [125](../finite-explicit-formula/lean/PrimeSide.lean#L125) | theorem | `sqrtInvBox_mem` | $\forall\,n : \mathbb{N},\ \forall\,hn : n=2\ \lor\ n=3\ \lor\ n=4\ \lor\ n=5\ \lor\ n=7,\ (\mathrm{sqrtInvBox}\ n).\mathrm{memR}(1/\mathrm{Real.sqrt}\ n)$ |
| [138](../finite-explicit-formula/lean/PrimeSide.lean#L138) | theorem | `logP_mem` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1\le\ p,\ (\mathrm{logP}\ p).\mathrm{memR}(\mathrm{Real.log}\ p)$ |
| [152](../finite-explicit-formula/lean/PrimeSide.lean#L152) | theorem | `termBox_mem` | $\forall\,n\,p : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \forall\,hp : 1\le\ p,\ \forall\,hnmem : n=2\ \lor\ n=3\ \lor\ n=4\ \lor\ n=5\ \lor\ n=7,\ \forall\,gI : \mathrm{Iv}\to\ \mathrm{Iv},\ \forall\,gR : \mathbb{R}\to\ \mathbb{R},\ \forall\,hg : \forall\ \{A:\mathrm{Iv}\}\ \{x:\mathbb{R}\},\ A.\mathrm{memR}\ x\to(\mathrm{gI}\ A).\mathrm{memR}(\mathrm{gR}\ x),\ (\mathrm{termBox}\ n\ p\ \mathrm{gI}).\mathrm{memR}(\mathrm{termValue}\ n\ p\ \mathrm{gR})$ |
| [172](../finite-explicit-formula/lean/PrimeSide.lean#L172) | theorem | `g1R_mem` | $:\forall\ \{A:\mathrm{Iv}\}\ \{x:\mathbb{R}\},\ A.\mathrm{memR}\ x\to(\mathrm{g1Box}\ A).\mathrm{memR}(\mathrm{g1R}\ x)$ |
| [176](../finite-explicit-formula/lean/PrimeSide.lean#L176) | theorem | `g2R_mem` | $:\forall\ \{A:\mathrm{Iv}\}\ \{x:\mathbb{R}\},\ A.\mathrm{memR}\ x\to(\mathrm{g2Box}\ A).\mathrm{memR}(\mathrm{g2R}\ x)$ |
| [189](../finite-explicit-formula/lean/PrimeSide.lean#L189) | theorem | `primeSideBox_mem` | $:\mathrm{primeSideBox.memR}\ \mathrm{primeSideValue}$ |
| [199](../finite-explicit-formula/lean/PrimeSide.lean#L199) | theorem | `primeSide_negative` | $:(\mathrm{primeSideBox.hi}:\mathbb{R})<0$ |
| [203](../finite-explicit-formula/lean/PrimeSide.lean#L203) | theorem | `primeSideValue_negative` | $:\mathrm{primeSideValue}<0$ |
