# `periodic-orbits/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`periodic-orbits`](../periodic-orbits/README.md)

### [`periodic-orbits/lean/Topic.lean`](../periodic-orbits/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [47](../periodic-orbits/lean/Topic.lean#L47) | theorem | `qdim_pos` | $\forall\,p\,r : \mathbb{N},\ \forall\,hp : 0<p,\ \forall\,hr : 0<r,\ \forall\,hrp : r<p,\ 0<\mathrm{qdim}\ p\ r$ |
| [68](../periodic-orbits/lean/Topic.lean#L68) | theorem | `qdim_symm` | $\forall\,p\,r : \mathbb{N},\ \forall\,hp : 0<p,\ \forall\,hr : r\le\ p,\ \mathrm{qdim}\ p\ r=\mathrm{qdim}\ p(p-r)$ |
| [84](../periodic-orbits/lean/Topic.lean#L84) | theorem | `smat_one` | $\forall\,p\,r : \mathbb{N},\ \forall\,hp : 1<p,\ \mathrm{Smat}\ p\ 1\ r=\mathrm{Real.sqrt}(2/(p:\mathbb{R}))\cdot\ \mathrm{Real.sin}(\mathrm{Real.pi}/(p:\mathbb{R}))\cdot\ \mathrm{qdim}\ p\ r$ |
| [100](../periodic-orbits/lean/Topic.lean#L100) | theorem | `Dsq_pos` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1<p,\ 0<\mathrm{Dsq}\ p$ |
| [114](../periodic-orbits/lean/Topic.lean#L114) | theorem | `rtWeight_pos` | $\forall\,p : \mathbb{N},\ \forall\,hp : 0<p,\ \forall\,n : \mathbb{N},\ 0<\mathrm{rtWeight}\ p\ n$ |
| [121](../periodic-orbits/lean/Topic.lean#L121) | theorem | `geom_rtWeight` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1<p,\ \forall\,N : \mathbb{N},\ \sum\ n\ \in\ \mathrm{Finset.range}\ N,\ \mathrm{rtWeight}\ p\ n=(1-\mathrm{rtWeight}\ p\ N)/(1-((p:\mathbb{R}))^{-1})$ |
| [134](../periodic-orbits/lean/Topic.lean#L134) | theorem | `fullTwist_writhe_pos` | $\forall\,n : \mathbb{N},\ \forall\,hn : 2\le\ n,\ 0<\mathrm{writhe}(\mathrm{List.replicate}(n\cdot(n-1))(1:\mathbb{Z}))$ |
