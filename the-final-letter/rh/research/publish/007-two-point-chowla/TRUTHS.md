## 7. Two-point Chowla and the finite-prefix theorem — `rh46`

Lean: [`Rh46/Chowla.lean`](Rh46/Chowla.lean)
(462 lines, cleaned of the `Check*`/`Test*`/`Scratch*` scratch files). Prose:
[`rounds/rh46/README.md`](ROUND-NOTES.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| trivial bound | `\|S(x,h)\| ≤ x` for every `h,x` | PROVED (Lean) | [`corr_abs_le`](Rh46/Chowla.lean#L210) |
| sharpness | `S(x,0) = x`; so `o(x)` is not formal | PROVED (Lean) | [`corr_zero`](Rh46/Chowla.lean#L227), [`corrAsymptotic_zero_false`](Rh46/Chowla.lean#L239) |
| **finite-prefix indeterminacy** | a modifiable `λ''` agreeing with `λ` on `[1,a)` with `S''(x)/x → 1` | PROVED (Lean) | [`corrSlice_eq_corr_of_lt`](Rh46/Chowla.lean#L381), [`corrSlice_ne_corr_self_statement`](Rh46/Chowla.lean#L427), [`slice_agree`](Rh46/Chowla.lean#L332) |
| ℓ²-mass of perturbation | exactly `4` | PROVED (Lean) | [`corrSliceSqSub`](Rh46/Chowla.lean#L392) |
| shifted product not multiplicative | `shiftProd` is not completely multiplicative | PROVED (Lean) | [`shiftProd_not_completely_multiplicative`](Rh46/Chowla.lean#L298) |
| elementary λ facts | multiplicativity, `λ(n) ∈ {±1}`, `λ²=1`, `λ(mn)` on nonzero | PROVED (Lean) | [`liouville_mul`](Rh46/Chowla.lean#L162), [`liouville_mem`](Rh46/Chowla.lean#L174) |
| **two-point Chowla `Σ λ(n)λ(n+2) = o(x)`** | — | **OPEN** | [`rounds/rh46/README.md`](ROUND-NOTES.md) |
| `corrSlice_sub_corr_self_eq` | recorded statement, not elaborated | **OPEN (recorded)** | comment at [`Chowla.lean`](Rh46/Chowla.lean) lines ~410–418 |

**Certified scratch caveat.** The `rh46/lean/` directory also contains unrelated
`Check*.lean`, `Test*.lean`, `Scratch*.lean` files; a few of those contain anonymous
`example`s with `sorry` (Check10/14/24, Test12/18/25, Scratch2). **None is imported by
`Rh46.lean`** — the deliverable is `Rh46/Chowla.lean`.
