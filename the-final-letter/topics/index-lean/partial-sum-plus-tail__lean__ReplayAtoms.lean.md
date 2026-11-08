# `partial-sum-plus-tail/lean/ReplayAtoms.lean`

[Back to the split index](index.md) · Topic: [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md)

### [`partial-sum-plus-tail/lean/ReplayAtoms.lean`](../partial-sum-plus-tail/lean/ReplayAtoms.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [50](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L50) | theorem | `Iv.memR_mono` | $\forall\,x : \mathbb{R},\ \forall\,A\,B : \mathrm{Iv},\ \forall\,h : B.\mathrm{memR}\ x,\ \forall\,hlo : A.\mathrm{lo}\le\ B.\mathrm{lo},\ \forall\,hhi : B.\mathrm{hi}\le\ A.\mathrm{hi},\ A.\mathrm{memR}\ x$ |
| [58](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L58) | theorem | `log_two_mem_A3` | $:\mathrm{Cx.mem}((\mathrm{Real.log}\ 2:\mathbb{C}))(A\ 3)$ |
| [66](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L66) | theorem | `log_three_mem_A5` | $:\mathrm{Cx.mem}((\mathrm{Real.log}\ 3:\mathbb{C}))(A\ 5)$ |
| [74](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L74) | theorem | `log_four_mem_A7` | $:\mathrm{Cx.mem}((\mathrm{Real.log}\ 4:\mathbb{C}))(A\ 7)$ |
| [82](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L82) | theorem | `log_one_mem_A1` | $:\mathrm{Cx.mem}((0:\mathbb{C}))(A\ 1)$ |
| [86](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L86) | theorem | `atom_mem_lt` | $:\forall\ i:\mathrm{Nat},\ i<23\to\ \mathrm{Cx.mem}(\sigma\ i)(A\ i)$ |
| [117](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L117) | theorem | `atom_mem'` | $:\forall\ i:\mathrm{Nat},\ \mathrm{Cx.mem}(\sigma\ i)(\mathrm{A'}\ i)$ |
| [124](../partial-sum-plus-tail/lean/ReplayAtoms.lean#L124) | theorem | `cert_mem_closed` | $:\mathrm{Cx.mem}(\mathrm{cert.eval}\ \sigma)\ \mathrm{cert.box}$ |
