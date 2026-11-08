# `qefe-research-notes/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`qefe-research-notes`](../qefe-research-notes/README.md)

### [`qefe-research-notes/lean/Topic.lean`](../qefe-research-notes/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [35](../qefe-research-notes/lean/Topic.lean#L35) | theorem | `egyptianDenom_one_le` | $\forall\,D_{2}\,d_{2} : \mathbb{Q},\ \forall\,hd : 0<\mathrm{d2},\ \forall\,hle : \mathrm{d2}\le\ \mathrm{D2},\ 1\le\ \mathrm{egyptianDenom}\ \mathrm{D2}\ \mathrm{d2}$ |
| [42](../qefe-research-notes/lean/Topic.lean#L42) | theorem | `unitFraction_pos` | $\forall\,m : \mathbb{Q},\ \forall\,hm : 0<m,\ 0<\mathrm{unitFraction}\ m$ |
| [50](../qefe-research-notes/lean/Topic.lean#L50) | theorem | `unitFraction_strictAnti` | $\forall\,a\,b : \mathbb{Q},\ \forall\,ha : 0<a,\ \forall\,hab : a<b,\ \mathrm{unitFraction}\ b<\mathrm{unitFraction}\ a$ |
| [57](../qefe-research-notes/lean/Topic.lean#L57) | theorem | `nonunitMass_pos` | $\forall\,D_{2} : \mathbb{Q},\ \forall\,h : 1<\mathrm{D2},\ 0<\mathrm{nonunitMass}\ \mathrm{D2}$ |
| [66](../qefe-research-notes/lean/Topic.lean#L66) | theorem | `nonunitMass_lt_one` | $\forall\,D_{2} : \mathbb{Q},\ \forall\,h : 0<\mathrm{D2},\ \mathrm{nonunitMass}\ \mathrm{D2}<1$ |
| [74](../qefe-research-notes/lean/Topic.lean#L74) | theorem | `nonunitMass_strictMono` | $:\mathrm{StrictMonoOn}\ \mathrm{nonunitMass}(\mathrm{Set.Ioi}\ 1)$ |
| [84](../qefe-research-notes/lean/Topic.lean#L84) | theorem | `ising_nonunit_identity` | $:\mathrm{unitFraction}\ 2+\mathrm{unitFraction}\ 4=\mathrm{nonunitMass}\ 4$ |
