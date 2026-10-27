# Lean formal core — Quantum–Egyptian functional equation

## Build

```bash
cd the-final-letter/topics/qefe
./lean/check.sh
```

The wrapper calls the shared [`tools/check-lean.sh`](../../tools/check-lean.sh),
which uses the local Mathlib installation at `~/lean/mathlib4` (Lean
`v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last
successful check.

## What is proved

[`Topic.lean`](Topic.lean) imports Mathlib and defines, in the `QEFE` namespace:

| Definition | Meaning |
|---|---|
| `egyptianDenom D2 d2` | `D² / d²`, the Egyptian denominator |
| `egyptianUnit D2` | `1 - 1/D²`, the non-unit Egyptian mass |
| `gammaRatio a s` | `Γ((1-s+a)/2) / Γ((s+a)/2)` |
| `qefePrefactor D2 a s` | `(D²/π)^(s-1/2) * gammaRatio a s` |

It proves:

| Name | Statement |
|---|---|
| `egyptianDenom_pos` | `0 < D²/d²` when `0 < D²` and `0 < d²` |
| `inv_egyptianDenom` | `(D²/d²)⁻¹ = d²/D²` for non-zero `D²`, `d²` |
| `egyptianUnit_pos` | `0 < 1 - 1/D²` when `1 < D²` |
| `egyptian_total` | `Σ_i 1/m_i = 1` for finite positive `d_i²` summing to `D²` |
| `egyptian_fraction_identity` | Lemma 2.2: with `d_0² = 1`, `Σ_{i≠0} 1/m_i = 1 - 1/D²` |
| `gammaRatio_center` | `gammaRatio a (1/2) = 1` for `a ≥ 0` |
| `qefePrefactor_center` | `qefePrefactor D2 a (1/2) = 1` for `D² > 0`, `a ≥ 0` |

The formal core is exactly the elementary part of the source: the
Egyptian-denominator algebra and the finite Egyptian-fraction identity, plus the
central-point evaluation of the gamma factor. It uses finitely supported sums
over `Fin (n+1)` and does not assume any categorical axioms.

## What is not formalised

The following remain **source claims or open items** in the programme dossier,
and are deliberately absent from `Topic.lean`:

- **Theorem 3.1 (the QEFE itself).** The archived proof is interrupted in §5.1,
  changes Mellin normalisation between §2.4 and §5.3, and fails off-centre for
  the source's own worked examples (see the Python test
  `test_claimed_functional_equation_fails_off_centre`).
- **Lemma 4.2 (modular transformation of the twisted theta function).** This
  needs a lattice/VOA realisation, Poisson summation, and the discriminant-group
  Fourier transform.
- **The Galois sign identity of Appendix A.** The source defers it to an
  external lemma; no self-contained proof is given.
- **Existence and integrality of the MTC data.** `egyptian_total` and
  `egyptian_fraction_identity` take a finite list of positive squared quantum
  dimensions summing to `D²` as a hypothesis. They do not construct an MTC.
- **The `SU(2)_k → ζ(2s)` limit and the Riemann-hypothesis discussion.** These
  are speculative in the source and are not formalised here.

The Ising and `SU(2)_4` examples are checked exactly in Python rather than in
Lean; they are arithmetic instances of the finite identity, not new formal
content.

## Honesty note

No declaration in `Topic.lean` is a restatement of the QEFE. The file proves the
correct finite lemma the source actually needs, and two exact facts about the
central point. It does not prove, and is not intended to suggest, the Riemann
hypothesis, GRH, twin primes, Chowla, Sarnak, or Elliott.

[Back to the programme](../README.md) · [Topic index](../../README.md)
