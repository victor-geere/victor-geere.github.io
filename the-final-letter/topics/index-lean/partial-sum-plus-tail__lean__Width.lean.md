# `partial-sum-plus-tail/lean/Width.lean`

[Back to the split index](index.md) · Topic: [`partial-sum-plus-tail`](../partial-sum-plus-tail/README.md)

### [`partial-sum-plus-tail/lean/Width.lean`](../partial-sum-plus-tail/lean/Width.lean) — 1 proof

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [35](../partial-sum-plus-tail/lean/Width.lean#L35) | theorem | `wfWidth_sound` | $\forall\,A : \mathrm{Nat}\to\ \mathrm{Cx},\ \forall\,\sigma : \mathrm{Nat}\to\ \mathbb{C},\ \forall\,hA : \forall\ i,\ \mathrm{Cx.mem}(\sigma\ i)(A\ i),\ \forall(e:\mathrm{Expr})(w:\mathbb{Q}),\ e.\mathrm{wfWidth}\ A\ w=\mathrm{true}\to\ \mathrm{Cx.mem}(e.\mathrm{eval}\ \sigma)\ e.\mathrm{box}\ \land\ e.\mathrm{box}.\mathrm{width}\le\ w\ \vert\ e,\ w,\ h\Rightarrow\ \mathrm{by}\ \mathrm{simp}\ \mathrm{only}[\mathrm{wfWidth},\ \mathrm{Bool.and}_{\mathrm{eq}_{\mathrm{true}}},\ \mathrm{decide}_{\mathrm{eq}_{\mathrm{true}_{\mathrm{eq}}}}]\ \mathrm{at}\ h\ \mathrm{exact}\ \langle{}\mathrm{Expr.wf}_{\mathrm{sound}}\ \mathrm{hA}\ e\ h.\mathrm{1},\ h.\mathrm{2}\rangle\ \mathrm{end}\ \mathrm{Expr}\ \mathrm{end}\ \mathrm{PartialTail}$ |
