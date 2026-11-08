# `finite-window-zeros/lean/BoxNorm.lean`

[Back to the split index](index.md) · Topic: [`finite-window-zeros`](../finite-window-zeros/README.md)

### [`finite-window-zeros/lean/BoxNorm.lean`](../finite-window-zeros/lean/BoxNorm.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [10](../finite-window-zeros/lean/BoxNorm.lean#L10) | theorem | `maxAbsIv_nonneg` | $\forall\,I : \mathrm{Iv},\ 0\le\ \mathrm{maxAbsIv}\ I$ |
| [13](../finite-window-zeros/lean/BoxNorm.lean#L13) | theorem | `abs_le_maxAbsIv` | $\forall\,I : \mathrm{Iv},\ \forall\,x : \mathbb{R},\ \forall\,hx : I.\mathrm{memR}\ x,\ \vert{}x\vert\le(\mathrm{maxAbsIv}\ I:\mathbb{R})$ |
| [35](../finite-window-zeros/lean/BoxNorm.lean#L35) | theorem | `norm_le_of_mem_box` | $\forall\,B : \mathrm{Cx},\ \forall\,z : \mathbb{C},\ \forall\,hz : \mathrm{Cx.mem}\ z\ B,\ \forall\,R : \mathbb{R},\ \forall\,hR_{0} : 0\le\ R,\ \forall\,hR : (\mathrm{maxAbsIv}\ B.\mathrm{re})^{2}+(\mathrm{maxAbsIv}\ B.\mathrm{im})^{2}\le\ R^{2},\ \Vert{}z\Vert\le\ R$ |
