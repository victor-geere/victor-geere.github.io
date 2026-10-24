# 5. The smoothing bridge — `rh044`

> Source: [`research/truths.md`](../rh/research/truths.md), §5. Status language is the ledger’s own.

Lean: [`Rh044/Smoothing.lean`](../rh/research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean)
(32 theorems). Prose: [`rounds/rh044/README.md`](../rh/research/twin-prime-parity/rounds/rh044/README.md).

| result | statement | status | evidence |
|---|---|---|---|
| weight defect identity | `zetaSum N s − smoothedSum N φ s = Σ (1−φ(n/N))·zetaTerm s n` | PROVED (Lean) | [`weighted_decomposition`](../rh/research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L121) |
| triangle-inequality bound | `‖zetaSum − smoothedSum‖ ≤ Σ ‖1−φ(n/N)‖·‖zetaTerm s n‖` | PROVED (Lean) | [`norm_smoothedSum_sub_zetaSum_le`](../rh/research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L204) |
| radial decay | `‖zetaTerm (σ+tI) n‖ = n^{−σ}` | PROVED (Lean) | [`abs_zetaTerm`](../rh/research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L215) |
| summability comparison | `σ > 1` comparison for the defect sum | PROVED (Lean) | [`summable_norm_zetaTerm`](../rh/research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L249) |
| quad-weight identities | `quadWeight` closed forms and defect identities | PROVED (Lean) | [`quadWeight_defect_eq`](../rh/research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L336), [`zetaSum_sub_smoothedSum_quadWeight`](../rh/research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean#L365) |
| **main result** | `\|S_N^φ(1/2+it) − ζ(1/2+it)\| / √N → \|M_φ(s)\|`, `M_φ(s)=∫₀¹φ(u)u^{−s}du` | PROVED (paper) + VERIFIED to 5–7 digits | [`rounds/rh044/README.md`](../rh/research/twin-prime-parity/rounds/rh044/README.md) §2 |
| refuted | "smoothing removes the `√N`" is **false**; the earlier `1/√(2t)` constant is wrong | REFUTED | `README.md` §2 |

---
