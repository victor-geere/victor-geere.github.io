# `intersection-form-zeta/lean/Certificate.lean`

[Back to the split index](index.md) · Topic: [`intersection-form-zeta`](../intersection-form-zeta/README.md)

### [`intersection-form-zeta/lean/Certificate.lean`](../intersection-form-zeta/lean/Certificate.lean) — 10 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [96](../intersection-form-zeta/lean/Certificate.lean#L96) | theorem | `certD_pos` | $:\forall\ i,\ 0<\mathrm{certD}\ i$ |
| [100](../intersection-form-zeta/lean/Certificate.lean#L100) | theorem | `certL_lower` | $:\mathrm{certL.IsLowerTriangular}$ |
| [102](../intersection-form-zeta/lean/Certificate.lean#L102) | theorem | `certL_det` | $:\mathrm{certL.det}=1$ |
| [106](../intersection-form-zeta/lean/Certificate.lean#L106) | theorem | `certL_unit` | $:\mathrm{IsUnit}\ \mathrm{certL}$ |
| [110](../intersection-form-zeta/lean/Certificate.lean#L110) | theorem | `cert_factor` | $:\mathrm{certL}\cdot\ \mathrm{diagonal}\ \mathrm{certD}\cdot\ \mathrm{certL}^{H}=\mathrm{certP}$ |
| [117](../intersection-form-zeta/lean/Certificate.lean#L117) | theorem | `certP_posDef` | $:\mathrm{certP.PosDef}$ |
| [141](../intersection-form-zeta/lean/Certificate.lean#L141) | theorem | `certA_herm` | $:\mathrm{certA.IsHermitian}$ |
| [145](../intersection-form-zeta/lean/Certificate.lean#L145) | theorem | `certA_mem_box` | $:\forall\ i\ j,\ \vert{}\mathrm{certA}\ i\ j-(\mathrm{certP}+\mathrm{certT}\ \bullet\ 1)\ i\ j\vert\le\ \mathrm{certE}\ i\ j$ |
| [151](../intersection-form-zeta/lean/Certificate.lean#L151) | theorem | `certE_row` | $:\forall\ i,\ \sum\ j,\ \mathrm{certE}\ i\ j\le\ \mathrm{certT}$ |
| [155](../intersection-form-zeta/lean/Certificate.lean#L155) | theorem | `certA_posDef` | $:\mathrm{certA.PosDef}$ |
