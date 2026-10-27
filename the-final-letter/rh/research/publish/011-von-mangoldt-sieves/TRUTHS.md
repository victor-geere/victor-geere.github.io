## 11. von Mangoldt sieves — `publish/001-von-mangoldt-sieves`

Lean: [`VonMangoldtSieves.lean`](VonMangoldtSieves.lean).

| result | statement | status | Lean proof |
|---|---|---|---|
| support | `Λ n ≠ 0 ↔ IsPrimePow n` | PROVED (Lean) | [`support_ne_zero_iff`](VonMangoldtSieves.lean#L28) |
| prime powers | `Λ(pᵏ) = log p` | PROVED (Lean) | [`apply_prime_pow`](VonMangoldtSieves.lean#L33) |
| divisor identity | `Σ_{d∣n} Λ d = log n` | PROVED (Lean) | [`divisor_identity`](VonMangoldtSieves.lean#L40) |
| Möbius inversion | `Λ = μ ∗ log` | PROVED (Lean) | [`moebius_convolution`](VonMangoldtSieves.lean#L44) |
| non-additive / non-multiplicative | with witnesses | PROVED (Lean) | [`not_additive`](VonMangoldtSieves.lean#L50), [`not_multiplicative`](VonMangoldtSieves.lean#L64) |
| bound | `Λ n ≤ log n` | PROVED (Lean) | [`le_log`](VonMangoldtSieves.lean#L78) |
