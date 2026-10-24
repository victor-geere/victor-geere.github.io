# Lean formal core — Research Programme III

## Build

```bash
the-final-letter/topics/research-programme-iii/lean/check.sh
```

The script wraps the shared checker at [`../../tools/check-lean.sh`](../../tools/check-lean.sh) and uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

`Topic.lean` defines the finite objects of the proposal:

- `RPIII.qdim N n = sin(π n/N) / sin(π/N)`;
- `RPIII.D2 N = N / (4 sin²(π/N))` (the proposal's literal normalisation);
- `RPIII.egyptianDenom N n = N / (4 sin²(π n/N))`;
- `RPIII.psi S s m χ = Σ_{i∈S} χ_i m_i^{-s}`.

It proves seven elementary facts:

| Name | Statement |
|---|---|
| `qdim_symm` | `qdim N (N − n) = qdim N n` |
| `egyptianDenom_symm` | `egyptianDenom N (N − n) = egyptianDenom N n` |
| `egyptianDenom_pos` | `0 < egyptianDenom N n` for `0 < n < N`, `0 < N` |
| `egyptianDenom_mid` | `egyptianDenom N (N/2) = N/4` for `N ≠ 0` |
| `psi_abs_le` | `|psi S s m χ| ≤ Σ m_i^{-s}` when `0 < m_i` and `|χ_i| = 1` |
| `zero_reflection` | if `Λ s = ε star(Λ(1−s))`, `ε = ±1`, and `Λ(star s) = star(Λ s)`, then `Λ ρ = 0 ⇒ Λ(1−star ρ) = 0` (`star` on `ℂ` is complex conjugation) |
| `log_weight_pos` | `0 < log m / √m` for `m > 1` |

There is no `sorry`, no `axiom`, and no `admit`.

The last three deserve a word. `psi_abs_le` is the triangle-inequality bound that the proposal uses for its trivial estimate. `zero_reflection` formalises the *abstract* mechanism by which a functional equation of QEFE type reflects zeros across the critical line; it is a conditional theorem and does not assert that the proposal's `Λ_k` satisfies the two hypotheses. `log_weight_pos` proves positivity of the weight `log m / √m` appearing in the proposal's explicit formula.

## What is not formalised

- The exact Galois signs `χ_{j,k}`: the proposal defines them abstractly and gives no formula.
- The Quantum–Egyptian functional equation for `Λ_k`. The companion manuscript in the same source folder disputes its derivation.
- The convergence `Ψ̂_k(s) → ζ(2s)`, and the competing claim that the normalised limit is `0`.
- The finite-level explicit formula, its gamma terms, and any zero-counting argument.
- The critical-line/zero-distribution argument and the Riemann-hypothesis conclusion.
- The proposal's integrality claim for `m_{j,k}`. The literal normalisation used here makes the claim false at `k = 3`; this is recorded as a computation counterexample in the programme README, not hidden.

These are recorded as source claims or open items in the [programme dossier](../README.md). They are not Lean theorems here.

## Note on the normalisation

The file follows the proposal's literal formula `D_k² = N/(4 sin²(π/N))`. The standard `SU(2)_k` total quantum dimension squared is `N/(2 sin²(π/N))`. The factor of two is discussed in the programme README; using it would change the integrality behaviour but not the elementary symmetry and positivity theorems proved here.

[Back to the programme](../README.md) · [Topic index](../../README.md)
