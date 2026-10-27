# Lean formal core — greedy-harmonic Hilbert–Pólya

## Build

```bash
cd the-final-letter/topics/greedy-harmonic-hilbert-polya
./lean/check.sh
```

The wrapper delegates to the shared `../../tools/check-lean.sh`, which uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last successful check.

## What is proved

[`Topic.lean`](Topic.lean) defines

- `GHHP.Q0 s = s² − (3/2)s + 1/4`;
- `GHHP.Q n s = s² − ((2n+3)/(n+2))s + (2n+3)/((n+1)(n+2)²)`, `n ≥ 1`;
- `GHHP.disc0` and `GHHP.disc n`;
- `GHHP.lamPlus n` and `GHHP.lamMinus n`, the source's explicit roots.

It proves:

| Name | Statement |
|---|---|
| `disc0_pos` | `0 < disc0` (the base discriminant is `5/4`) |
| `Q0_roots` | `Q0 ((3 ± √5)/4) = 0` |
| `Q_const_pos` | `0 < (2n+3)/((n+1)(n+2)²)` |
| `Q_discriminant` | `disc n = (2n+3)(2n²+5n−1)/((n+1)(n+2)²)` |
| `Q_discriminant_pos` | `0 < disc n` for `n ≥ 1` |
| `Q_roots` | `Q n (lamPlus n) = 0 ∧ Q n (lamMinus n) = 0` for `n ≥ 1` |
| `Q_vieta` | the sum and product of `lamPlus n`, `lamMinus n` equal the coefficients of `Q n` for `n ≥ 1` |

No `sorry`, no `axiom`, no `admit`. The proofs are elementary real algebra: positivity, `field_simp`, `ring`, `nlinarith`, and `Real.sq_sqrt`. `Q_vieta` is the per-block trace/determinant bookkeeping that the source's Haar trace formula uses.

## What is not formalised

- **The derivation of `Qₙ` from `H`.** The source's Theorem 7.1 is an integration-by-parts sketch on scaling and wavelet functions. The Lean file starts from the quadratics as definitions; it does not construct the Haar basis, the Galerkin matrix, or `H`.
- **The operator `H = −i(x∂_x + 1/2)` and its domain.** Essential self-adjointness, the transmission condition `φ(1⁻) = φ(0⁺)`, and the resolvent kernel are not formalised.
- **The transfer operator `ℒ_s` and the Fredholm determinant identity** `det(I − ℒ_s) = ζ(s)/ζ(2s)e^{P(s)}`. This is a source claim; the archive's audit files explicitly call it unproved.
- **The Haar trace formula and its convergence.** Only the per-block trace identity is proved; the infinite trace and the periodic-orbit side are not.
- **The spectral shift function, the twisted Selberg formula, the mismatch `Δ(t)`, the fixed-point map `φ`, and the Jacobian-conditioned mismatch.**
- **The Mellin correspondence and its bijectivity.** This is the central open statement. It is recorded in the programme README as open, not as a Lean theorem.
- **RH and GRH.** Nothing here proves or assumes them. The `framework.html` claim that RH/GRH is proved is an archived, withdrawn claim.

These gaps are not cosmetic: the source's analytic framework depends on operator-theoretic facts that would require a substantial formalisation before the quadratic factors could be connected to `ζ`.

[Back to the programme](../README.md) · [Topic index](../../README.md)
