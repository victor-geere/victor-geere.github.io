# `qefe/lean/GaussianInt/RingOfIntegers.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/GaussianInt/RingOfIntegers.lean`](../qefe/lean/GaussianInt/RingOfIntegers.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [39](../qefe/lean/GaussianInt/RingOfIntegers.lean#L39) | lemma | `toQI_mk` | $\forall\,m\,n : \mathbb{Z},\ \mathrm{toQI}(\langle{}m,\ n\rangle:\mathrm{Zsqrtd}(-1))=(m:\mathrm{QI})+(n:\mathrm{QI})\cdot\ \mathrm{iRoot}$ |
| [47](../qefe/lean/GaussianInt/RingOfIntegers.lean#L47) | lemma | `algebraMap_QI_eq_toQI` | $:(\mathrm{algebraMap}(\mathrm{Zsqrtd}(-1))\ \mathrm{QI})=\mathrm{toQI}$ |
| [59](../qefe/lean/GaussianInt/RingOfIntegers.lean#L59) | lemma | `algebraMap_eq_div_den` | $\forall\,q : \mathbb{Q},\ \mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QI}\ q=((q.\mathrm{num}:\mathbb{Z}):\mathrm{QI})/((q.\mathrm{den}:\mathbb{Z}):\mathrm{QI})$ |
| [68](../qefe/lean/GaussianInt/RingOfIntegers.lean#L68) | lemma | `exists_div` | $\forall\,z : \mathrm{QI},\ \exists\ x\ y:\mathrm{Zsqrtd}(-1),\ z=\mathrm{toQI}\ x/\mathrm{toQI}\ y$ |
