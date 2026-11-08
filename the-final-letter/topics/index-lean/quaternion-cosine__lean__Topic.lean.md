# `quaternion-cosine/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`quaternion-cosine`](../quaternion-cosine/README.md)

### [`quaternion-cosine/lean/Topic.lean`](../quaternion-cosine/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [48](../quaternion-cosine/lean/Topic.lean#L48) | theorem | `quaternion_relations` | $:I\cdot\ I=-1\ \land\ J\cdot\ J=-1\ \land\ K\cdot\ K=-1\ \land\ I\cdot\ J=K\ \land\ J\cdot\ I=-K$ |
| [56](../quaternion-cosine/lean/Topic.lean#L56) | theorem | `phase_normSq` | $\forall\,a\,b : \mathbb{R},\ \mathrm{Quaternion.normSq}(\mathrm{phase}\ a\ b)=a^{2}+b^{2}$ |
| [64](../quaternion-cosine/lean/Topic.lean#L64) | theorem | `energy_nonneg` | $\forall\,a\,b : \mathbb{R},\ 0\le\ \mathrm{energy}\ a\ b$ |
| [69](../quaternion-cosine/lean/Topic.lean#L69) | theorem | `energy_eq_zero_iff` | $\forall\,a\,b : \mathbb{R},\ \mathrm{energy}\ a\ b=0\leftrightarrow\ \mathrm{Real.cos}\ a=1\ \land\ \mathrm{Real.cos}\ b=1$ |
| [85](../quaternion-cosine/lean/Topic.lean#L85) | theorem | `cos_two_pi_mul_eq_one_iff` | $\forall\,x : \mathbb{R},\ \mathrm{Real.cos}(2\cdot\ \mathrm{Real.pi}\cdot\ x)=1\leftrightarrow\ \exists\ n:\mathbb{Z},\ x=n$ |
| [105](../quaternion-cosine/lean/Topic.lean#L105) | theorem | `detector_eq_zero_iff` | $\forall\,x\,p : \mathbb{R},\ \forall\,\_hx : x\ne\ 0,\ \mathrm{detector}(2\cdot\ \mathrm{Real.pi}\cdot\ x)(2\cdot\ \mathrm{Real.pi}\cdot\ p/x)=0\leftrightarrow(\exists\ m:\mathbb{Z},\ x=m)\ \land(\exists\ n:\mathbb{Z},\ p/x=n)$ |
| [134](../quaternion-cosine/lean/Topic.lean#L134) | theorem | `warp_eq_zero_iff` | $\forall\,\sigma : \mathbb{R},\ \mathrm{warp}\ \sigma=0\leftrightarrow\ \sigma=1/2$ |
