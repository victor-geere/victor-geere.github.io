# 7. Two-point Chowla and the finite-prefix theorem — `rh46`

> Source: [`research/truths.md`](../../rh/research/truths.md), §7. Status language is the ledger’s own.

Lean: [`Rh46/Chowla.lean`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean)
(530 lines, **42 theorems**; since the OP-11 closure it contains **no statement recorded
without proof**). Prose:
[`rounds/rh46/README.md`](../../rh/research/twin-prime-parity/rounds/rh46/README.md).

| result | statement | status | Lean proof |
|---|---|---|---|
| trivial bound | `\|S(x,h)\| ≤ x` for every `h,x` | PROVED (Lean) | [`corr_abs_le`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L210) |
| sharpness | `S(x,0) = x`; so `o(x)` is not formal | PROVED (Lean) | [`corr_zero`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L227), [`corrAsymptotic_zero_false`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L239) |
| **finite-prefix indeterminacy** | a modifiable `λ''` agreeing with `λ` on `[1,a)` with `S''(x)/x → 1` | PROVED (Lean) | [`corrSlice_eq_corr_of_lt`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L381), [`exists_corrSlice_ne_corr`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean), [`slice_agree`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L332) |
| ℓ²-mass of perturbation | exactly `4` | PROVED (Lean) | [`corrSliceSqSub`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L392) |
| shifted product not multiplicative | `shiftProd` is not completely multiplicative | PROVED (Lean) | [`shiftProd_not_completely_multiplicative`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L298) |
| elementary λ facts | multiplicativity, `λ(n) ∈ {±1}`, `λ²=1`, `λ(mn)` on nonzero | PROVED (Lean) | [`liouville_mul`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L162), [`liouville_mem`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean#L174) |
| **two-point Chowla `Σ λ(n)λ(n+2) = o(x)`** | — | **OPEN** (2026 reassessment: still out of reach; every 2020–2026 advance is log-averaged / shift-averaged / conditional) | [`rounds/rh46/README.md`](../../rh/research/twin-prime-parity/rounds/rh46/README.md), [`open/OP-01-04-16-17-18-tractability.md`](../../rh/research/twin-prime-parity/open/OP-01-04-16-17-18-tractability.md) |
| `corrSlice_sub_corr_self_eq` | `corrSlice h a a − corr h a = −2λ(a)λ(a+h) − 2λ(a−h)λ(a)` for `0 < h < a` | **PROVED (Lean, OP-11)** | [`corrSlice_sub_corr_self_eq`](../../rh/research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean), helper `slice_term_sub` |

**Certified scratch caveat.** The `rh46/lean/` directory also contains unrelated
`Check*.lean`, `Test*.lean`, `Scratch*.lean` files; a few of those contain anonymous
`example`s with `sorry` (Check10/14/24, Test12/18/25, Scratch2). **None is imported by
`Rh46.lean`** — the deliverable is `Rh46/Chowla.lean`.

---
