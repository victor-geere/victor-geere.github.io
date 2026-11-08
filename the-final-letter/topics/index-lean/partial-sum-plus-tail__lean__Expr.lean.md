# `partial-sum-plus-tail/lean/Expr.lean`

[Back to the split index](index.md) · Topic: [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md)

### [`partial-sum-plus-tail/lean/Expr.lean`](../partial-sum-plus-tail/lean/Expr.lean) — 1 proof

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [69](../partial-sum-plus-tail/lean/Expr.lean#L69) | theorem | `wf_sound` | $\forall\,A : \mathrm{Nat}\to\ \mathrm{Cx},\ \forall\,\sigma : \mathrm{Nat}\to\ \mathbb{C},\ \forall\,hA : \forall\ i,\ \mathrm{Cx.mem}(\sigma\ i)(A\ i),\ \forall\ e:\mathrm{Expr},\ e.\mathrm{wf}\ A=\mathrm{true}\to\ \mathrm{Cx.mem}(e.\mathrm{eval}\ \sigma)\ e.\mathrm{box}\ \vert\ \mathrm{atom}\ i\ b,\ h\Rightarrow\ \mathrm{by}\ \mathrm{simp}\ \mathrm{only}[\mathrm{wf},\ \mathrm{decide}_{\mathrm{eq}_{\mathrm{true}_{\mathrm{eq}}}}]\ \mathrm{at}\ h\ \mathrm{rw}[h]\ \mathrm{exact}\ \mathrm{hA}\ i\ \vert\ \mathrm{add}\ b\ x\ y,\ h\Rightarrow\ \mathrm{by}\ \mathrm{simp}\ \mathrm{only}[\mathrm{wf},\ \mathrm{Bool.and}_{\mathrm{eq}_{\mathrm{true}}},\ \mathrm{decide}_{\mathrm{eq}_{\mathrm{true}_{\mathrm{eq}}}}]\ \mathrm{at}\ h\ \mathrm{obtain}\ \langle\langle{}\mathrm{hx},\ \mathrm{hy}\rangle,\ \mathrm{hb}\rangle$ |
