# `prime-spectrum-tensor/lean/MidpointRule.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/MidpointRule.lean`](../prime-spectrum-tensor/lean/MidpointRule.lean) — 1 proof

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [24](../prime-spectrum-tensor/lean/MidpointRule.lean#L24) | theorem | `midpoint_rule_bound` | $\forall\,f : \mathbb{R}\to\ \mathbb{R},\ \forall\,a\,b\,B : \mathbb{R},\ \forall\,hab : a\le\ b,\ \forall\,hf : \forall\ x\ \in\ \mathrm{Set.Icc}\ a\ b,\ \mathrm{HasDerivAt}\ f(\mathrm{deriv}\ f\ x)\ x,\ \forall\,hf' : \forall\ x\ \in\ \mathrm{Set.Icc}\ a\ b,\ \mathrm{HasDerivAt}(\mathrm{deriv}\ f)(\mathrm{deriv}(\mathrm{deriv}\ f)\ x)\ x,\ \forall\,hB : \forall\ x\ \in\ \mathrm{Set.Icc}\ a\ b,\ \vert{}\mathrm{deriv}(\mathrm{deriv}\ f)\ x\vert\le\ B,\ \forall\,hcont : \mathrm{Continuous}\ f,\ \vert(\int\ x\ \text{in}\ a..b,\ f\ x)-(b-a)\cdot\ f((a+b)/2)\vert\le\ B\cdot(b-a)^{3}/4$ |
