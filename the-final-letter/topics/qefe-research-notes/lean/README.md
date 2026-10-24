# Lean formal core — QEFE research notes

## Build

```bash
cd the-final-letter/topics/qefe-research-notes
./lean/check.sh
```

The wrapper calls the shared [`../../tools/check-lean.sh`](../../tools/check-lean.sh),
which uses the local Mathlib installation at `~/lean/mathlib4` (Lean
`v4.35.0-rc2`). The committed [`BUILD.log`](BUILD.log) records the last
successful check.

## What is proved

[`Topic.lean`](Topic.lean) defines, over `ℚ`:

- `QEFENotes.egyptianDenom D2 d2 = D2 / d2`;
- `QEFENotes.unitFraction m = 1 / m`;
- `QEFENotes.nonunitMass D2 = 1 - 1 / D2`.

It proves seven facts:

| Name | Statement |
|---|---|
| `egyptianDenom_one_le` | `0 < d² → d² ≤ D² → 1 ≤ D²/d²` |
| `unitFraction_pos` | `0 < m → 0 < 1/m` |
| `unitFraction_strictAnti` | `0 < a → a < b → 1/b < 1/a` |
| `nonunitMass_pos` | `1 < D² → 0 < 1 - 1/D²` |
| `nonunitMass_lt_one` | `0 < D² → 1 - 1/D² < 1` |
| `nonunitMass_strictMono` | `StrictMonoOn nonunitMass (Set.Ioi 1)` |
| `ising_nonunit_identity` | `1/2 + 1/4 = 1 - 1/4` |

No `sorry`, no `axiom`, no `admit`.

These are the elementary order facts that the notes use when they say that
growing the total dimension makes the non-unit Egyptian fractions a better
approximation of `1`, together with the Ising instance of Lemma 2.2. The
concrete Ising identity is included because it links the abstract definitions
to the source's first worked example.

## What is not formalised

- **Theorem 3.1, the Quantum–Egyptian functional equation.** It is an archived
  claim with an interrupted proof and a silent change of Mellin normalisation.
  It is not a theorem here, and no statement of it appears in `Topic.lean`.
  The primary reconstruction of the general QEFE, including the off-centre
  counterexamples, is in [`../../qefe/`](../../qefe/README.md); this folder
  deliberately does not duplicate it.
- **Lemma 2.2 in full generality.** The general finite identity
  `Σ_i 1/m_i = 1` and its non-unit form are proved once, in
  [`../../qefe/lean/Topic.lean`](../../qefe/lean/Topic.lean)
  (`QEFE.egyptian_total`, `QEFE.egyptian_fraction_identity`). Re-proving them
  here would be a second proof of the same lemma, which the topic brief
  explicitly asks us to avoid.
- **Lemma 4.2, theta modularity.** It needs a lattice realisation and Poisson
  summation, neither of which is in Mathlib in a form that matches the source's
  hypotheses.
- **The Appendix A Galois sign identity.** The source itself defers the
  computation to Bantay; formalising it would require the
  de Boer–Goeree / Coste–Gannon / Bantay equivariance for modular data.
- **The two Mellin normalisations.** The mismatch between
  `Γ(s) π^{-s} D^{2s}` and `Γ((s+a)/2) π^{-(s+a)/2} D^s` is measured exactly in
  [`../tests/test_programme.py`](../tests/test_programme.py) (C4). Rendering
  gamma factors and the parity convention in Lean would not settle the
  substantive question, which is which normalisation (if either) is correct.
- **The `SU(2)_k → ζ(2s)` limit and the Riemann-hypothesis suggestion.** Both
  are speculative in the source; neither is stated as a precise theorem.

## Why the formal core is small

The source is a duplicated working-notes corpus, not a finished paper. The
notes contain one correctly proved finite lemma (Lemma 2.2), two worked
examples, and a disputed analytic derivation. The honest formal core is
therefore the finite arithmetic around Lemma 2.2 — positivity, monotonicity,
and bounds for the Egyptian mass — plus one concrete instance. Anything larger
would either duplicate [`../../qefe/`](../../qefe/README.md) or formalise a
statement the source has not established.

[Back to the programme](../README.md) · [Topic index](../../README.md)
