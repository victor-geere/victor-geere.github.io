# 11. von Mangoldt sieves — `publish/001-von-mangoldt-sieves`

> Source: [`research/truths.md`](../rh/research/truths.md), §11. Status language is the ledger’s own.

Lean: [`VonMangoldtSieves.lean`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean).

| result | statement | status | Lean proof |
|---|---|---|---|
| support | `Λ n ≠ 0 ↔ IsPrimePow n` | PROVED (Lean) | [`support_ne_zero_iff`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L28) |
| prime powers | `Λ(pᵏ) = log p` | PROVED (Lean) | [`apply_prime_pow`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L33) |
| divisor identity | `Σ_{d∣n} Λ d = log n` | PROVED (Lean) | [`divisor_identity`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L40) |
| Möbius inversion | `Λ = μ ∗ log` | PROVED (Lean) | [`moebius_convolution`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L44) |
| non-additive / non-multiplicative | with witnesses | PROVED (Lean) | [`not_additive`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L50), [`not_multiplicative`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L64) |
| bound | `Λ n ≤ log n` | PROVED (Lean) | [`le_log`](../rh/research/publish/001-von-mangoldt-sieves/VonMangoldtSieves.lean#L78) |

---
