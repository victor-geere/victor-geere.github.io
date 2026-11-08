# `finite-window-zeros/lean/ZetaBox14.lean`

[Back to the split index](index.md) · Topic: [`finite-window-zeros`](../finite-window-zeros/README.md)

### [`finite-window-zeros/lean/ZetaBox14.lean`](../finite-window-zeros/lean/ZetaBox14.lean) — 17 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [23](../finite-window-zeros/lean/ZetaBox14.lean#L23) | theorem | `mem_S14` | $:\mathrm{Cx.mem}\ \mathrm{s14}\ \mathrm{S14}$ |
| [27](../finite-window-zeros/lean/ZetaBox14.lean#L27) | theorem | `etaPartial_mem_box` | $\forall\,M : \mathbb{N},\ \forall\,hOK : \mathrm{allOK}(\mathrm{params}\ M)\ \mathrm{S14}=\mathrm{true},\ \mathrm{Cx.mem}(\sum\ m\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{pairTerm}\ \mathrm{s14}\ m)(\mathrm{sumBox}(\mathrm{params}\ M)\ \mathrm{S14})$ |
| [42](../finite-window-zeros/lean/ZetaBox14.lean#L42) | theorem | `allOK_100` | $:\mathrm{allOK}(\mathrm{params14}\ 100)\ \mathrm{S14}=\mathrm{true}$ |
| [45](../finite-window-zeros/lean/ZetaBox14.lean#L45) | theorem | `sumValue_params14` | $\forall\,M : \mathbb{N},\ \forall\,s : \mathbb{C},\ \mathrm{sumValue}(\mathrm{params14}\ M)\ s=\sum\ m\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{pairTerm}\ s\ m$ |
| [56](../finite-window-zeros/lean/ZetaBox14.lean#L56) | theorem | `etaPartial_mem_box14` | $\forall\,M : \mathbb{N},\ \forall\,hOK : \mathrm{allOK}(\mathrm{params14}\ M)\ \mathrm{S14}=\mathrm{true},\ \mathrm{Cx.mem}(\sum\ m\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{pairTerm}\ \mathrm{s14}\ m)(\mathrm{sumBox}(\mathrm{params14}\ M)\ \mathrm{S14})$ |
| [61](../finite-window-zeros/lean/ZetaBox14.lean#L61) | theorem | `etaPartial_100_mem14` | $:\mathrm{Cx.mem}(\sum\ m\ \in\ \mathrm{Finset.range}\ 100,\ \mathrm{pairTerm}\ \mathrm{s14}\ m)(\mathrm{sumBox}(\mathrm{params14}\ 100)\ \mathrm{S14})$ |
| [65](../finite-window-zeros/lean/ZetaBox14.lean#L65) | theorem | `allOK_1000` | $:\mathrm{allOK}(\mathrm{params14}\ 1000)\ \mathrm{S14}=\mathrm{true}$ |
| [68](../finite-window-zeros/lean/ZetaBox14.lean#L68) | theorem | `allOK_10000` | $:\mathrm{allOK}(\mathrm{params14}\ 10000)\ \mathrm{S14}=\mathrm{true}$ |
| [71](../finite-window-zeros/lean/ZetaBox14.lean#L71) | theorem | `allOK_100000` | $:\mathrm{allOK}(\mathrm{params14}\ 100000)\ \mathrm{S14}=\mathrm{true}$ |
| [84](../finite-window-zeros/lean/ZetaBox14.lean#L84) | theorem | `allOK_fast_10000` | $:\mathrm{allOK}(\mathrm{paramsFast}\ 10000)\ \mathrm{S14}=\mathrm{true}$ |
| [87](../finite-window-zeros/lean/ZetaBox14.lean#L87) | theorem | `norm_s14_le_fifteen` | $:\Vert{}\mathrm{s14}\Vert\le(15:\mathbb{R})$ |
| [99](../finite-window-zeros/lean/ZetaBox14.lean#L99) | theorem | `tail_s14_1e6` | $:\Vert\sum'\ m:\mathbb{N},\ \mathrm{pairTerm}\ \mathrm{s14}(m+1000000)\Vert\le(1/64:\mathbb{R})$ |
| [145](../finite-window-zeros/lean/ZetaBox14.lean#L145) | theorem | `sumValue_paramsBlock` | $\forall\,offset\,M : \mathbb{N},\ \forall\,s : \mathbb{C},\ \mathrm{sumValue}(\mathrm{paramsBlock}\ \mathrm{offset}\ M)\ s=\sum\ i\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{pairTerm}\ s(\mathrm{offset}+i)$ |
| [157](../finite-window-zeros/lean/ZetaBox14.lean#L157) | theorem | `paramsFast_eq_append` | $\forall\,off\,M : \mathbb{N},\ \mathrm{paramsFast}(\mathrm{off}+M)=\mathrm{paramsFast}\ \mathrm{off}++\mathrm{paramsBlock}\ \mathrm{off}\ M$ |
| [163](../finite-window-zeros/lean/ZetaBox14.lean#L163) | theorem | `allOK_paramsBlock` | $\forall\,N\,off\,M : \mathbb{N},\ \forall\,S : \mathrm{Cx},\ \forall\,h : \mathrm{allOK}(\mathrm{paramsFast}\ N)\ S=\mathrm{true},\ \forall\,hoff : \mathrm{off}+M\le\ N,\ \mathrm{allOK}(\mathrm{paramsBlock}\ \mathrm{off}\ M)\ S=\mathrm{true}$ |
| [180](../finite-window-zeros/lean/ZetaBox14.lean#L180) | theorem | `blockBox_mem` | $\forall\,N\,off\,M : \mathbb{N},\ \forall\,S : \mathrm{Cx},\ \forall\,s : \mathbb{C},\ \forall\,h : \mathrm{allOK}(\mathrm{paramsFast}\ N)\ S=\mathrm{true},\ \forall\,hoff : \mathrm{off}+M\le\ N,\ \forall\,hs : \mathrm{Cx.mem}\ s\ S,\ \mathrm{Cx.mem}(\sum\ i\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{pairTerm}\ s(\mathrm{off}+i))(\mathrm{sumBox}(\mathrm{paramsBlock}\ \mathrm{off}\ M)\ S)$ |
| [189](../finite-window-zeros/lean/ZetaBox14.lean#L189) | theorem | `sum_blocks_eq` | $\forall\,B\,M : \mathbb{N},\ \forall\,s : \mathbb{C},\ (\sum\ j\ \in\ \mathrm{Finset.range}\ B,\ \sum\ i\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{pairTerm}\ s(j\cdot\ M+i))=\sum\ m\ \in\ \mathrm{Finset.range}(B\cdot\ M),\ \mathrm{pairTerm}\ s\ m$ |
