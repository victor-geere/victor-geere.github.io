# `partial-sum-plus-tail/lean/CpowBox.lean`

[Back to the split index](index.md) · Topic: [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md)

### [`partial-sum-plus-tail/lean/CpowBox.lean`](../partial-sum-plus-tail/lean/CpowBox.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [30](../partial-sum-plus-tail/lean/CpowBox.lean#L30) | theorem | `logIvRat_mem` | $\forall\,N\,b : \mathbb{N},\ \forall\,hb : 1\le\ b,\ (\mathrm{logIvRat}\ N\ b).\mathrm{memR}(\mathrm{Real.log}(b:\mathbb{R}))$ |
| [70](../partial-sum-plus-tail/lean/CpowBox.lean#L70) | theorem | `expIBox_mem` | $\forall\,t : \mathbb{R},\ \forall\,A : \mathrm{Iv},\ \forall\,k\,n : \mathbb{N},\ \forall\,ht : A.\mathrm{memR}\ t,\ \forall\,hk : 0<k,\ \forall\,hlo : (-1:\mathbb{Q})\le(A.\mathrm{scale}(1/(k:\mathbb{Q}))).\mathrm{lo},\ \forall\,hhi : (A.\mathrm{scale}(1/(k:\mathbb{Q}))).\mathrm{hi}\le\ 1,\ \forall\,hn : 0<n,\ (\mathrm{expIBox}\ k\ n\ A).\mathrm{mem}(\mathrm{Complex.exp}((t:\mathbb{C})\cdot\ \mathrm{Complex}.I))$ |
| [97](../partial-sum-plus-tail/lean/CpowBox.lean#L97) | theorem | `cpowBox_mem` | $\forall\,N\,k\,kI\,n : \mathbb{N},\ \forall\,b : \mathbb{N},\ \forall\,hb : 1\le\ b,\ \forall\,S : \mathrm{Cx},\ \forall\,s : \mathbb{C},\ \forall\,hs : \mathrm{Cx.mem}\ s\ S,\ \forall\,hk : 0<k,\ \forall\,hkI : 0<\mathrm{kI},\ \forall\,hn : 0<n,\ \forall\,hexplo : (-1:\mathbb{Q})\le((\mathrm{cpowExponent}\ N\ b\ S).\mathrm{re.scale}(1/(k:\mathbb{Q}))).\mathrm{lo},\ \forall\,hexphi : ((\mathrm{cpowExponent}\ N\ b\ S).\mathrm{re.scale}(1/(k:\mathbb{Q}))).\mathrm{hi}\le\ 1,\ \forall\,hIlo : (-1:\mathbb{Q})\le((\mathrm{cpowExponent}\ N\ b\ S).\mathrm{im.scale}(1/(\mathrm{kI}:\mathbb{Q}))).\mathrm{lo},\ \forall\,hIhi : ((\mathrm{cpowExponent}\ N\ b\ S).\mathrm{im.scale}(1/(\mathrm{kI}:\mathbb{Q}))).\mathrm{hi}\le\ 1,\ \mathrm{Cx.mem}(((b:\mathbb{R}):\mathbb{C})^{-s})(\mathrm{cpowBox}\ N\ k\ \mathrm{kI}\ n\ b\ S)$ |
