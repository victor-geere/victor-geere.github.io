# QEFE research notes — reconstructed finite core

**Status:** duplicate working notes. This folder is **not** a second proof of
the Quantum–Egyptian functional equation and does not promote Theorem 3.1 to a
theorem. It reconstructs only the finite Egyptian/fractional arithmetic that the
notes actually define, and points to the primary reconstruction in
[`../qefe/`](../qefe/README.md) for the broader programme.

**Source:** [`archive/quantum-egyptian-functional-equation/research-deepseek-8.md`](../../archive/quantum-egyptian-functional-equation/research-deepseek-8.md)
(DeepSeek round 8, dated March 2026).
**Corpus:** rounds 1–5 and 7–8 in the same folder (round 6 is absent), plus
[`harmonic-sine-applied.html`](../../archive/quantum-egyptian-functional-equation/harmonic-sine-applied.html)
and its `.tex` source — nine files in total.
**Inventory:** [Scraps](../../scraps.html) item 36 · [Topic index](../README.md) ·
Duplicate of [item 35](../qefe/README.md).

## Provenance, and why this is a notes dossier

The inventory lists item 36 as **“notes duplicate”**. The folder holds the
working drafts behind item 35 (QEFE), not a separate result: the rounds repeat,
qualify, and in places retract one another. The v8 draft is the most polished
member of the set and is the source for this reconstruction, but it is still a
draft:

- **Round 1 argues the opposite of round 8.** In
  [`research-deepseek-1.md`](../../archive/quantum-egyptian-functional-equation/research-deepseek-1.md)
  the author derives a relation `Ψ(s) ~ Ψ(s−1)`, observes that a finite
  Dirichlet polynomial cannot satisfy a Riemann-type `s ↔ 1−s` equation, and
  writes “clearly the functional equation cannot hold for all `s`”. Round 8
  asserts Theorem 3.1 with `s ↔ 1−s` and does not address that objection.
- **The v8 proof is interrupted.** In §5.1 the Mellin split is followed to the
  point where it “merely reproduces the original first part”; the text then
  says the equation follows “after a different manipulation”, which is never
  supplied.
- **The Mellin normalisation changes silently.** §2.4 uses
  `Γ(s) π^{-s} D^{2s}`; §5.3 replaces it by `Γ((s+a)/2) π^{-(s+a)/2} D^s` by
  hand, with the parity `a` asserted rather than derived. Computation C4
  measures the mismatch.
- **The examples are only checked at `s = 1/2`.** At that point the prefactor
  is exactly `1`, so the check is automatic (C5); away from the centre the
  displayed equation fails for the source's own Ising and `SU(2)_4` data
  (documented as C6 in the item 35 ledger).

The primary reconstruction already covers the general QEFE, the worked
examples, the off-centre failure, and the root-number inconsistency. This
dossier therefore **does not re-derive them**. It adapts the finite
Egyptian/fractional core — the one part of the notes that is unconditional —
and records the duplicated and contradictory material honestly.

## Reconstructed objects and notation

The finite input is an integral MTC datum: positive squared quantum dimensions
`d_i²` with `d_0² = 1`, total `D² = Σ_i d_i²`, and Galois signs
`χ_i = ε_i(σ) ∈ {±1}` with `ε_0 = 1`.

| Object | Definition | Role here |
|---|---|---|
| Egyptian denominator | `m_i = D²/d_i²` | positive rational ≥ 1 (T1) |
| Unit-fraction mass | `1/m_i = d_i²/D²` | positive (T2), decreasing in `m_i` (T3) |
| Total Egyptian mass | `Σ_i 1/m_i` | exactly `1` |
| Non-unit Egyptian mass | `1 − 1/D²` | positive for `D² > 1` (T4), `< 1` (T5), increasing in `D²` (T6) |
| Galois character | `χ(m_i) = ε_i(σ)` | signs tabulated for two examples |
| Categorical Dirichlet polynomial | `Ψ(s) = Σ_i χ_i m_i^{-s}` | finite and entire |

Lemma 2.2 of the source, `Σ_{i≠0} 1/m_i = 1 − 1/D²`, is the bridge between the
tables above. Its general proof is the finite identity proved in
[`../qefe/lean/Topic.lean`](../qefe/lean/Topic.lean) (`QEFE.egyptian_total`,
`QEFE.egyptian_fraction_identity`); this folder adapts the surrounding
monotonicity and positivity facts and verifies the two worked examples exactly.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean)
with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a
test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test |
|---|---|---|---|
| T1 | Theorem | If `0 < d² ≤ D²`, the Egyptian denominator satisfies `1 ≤ D²/d²`. | `QEFENotes.egyptianDenom_one_le` |
| T2 | Theorem | Each unit fraction is positive: `0 < m → 0 < 1/m`. | `QEFENotes.unitFraction_pos` |
| T3 | Theorem | Unit fractions are strictly antitone: `0 < a < b → 1/b < 1/a`. | `QEFENotes.unitFraction_strictAnti` |
| T4 | Theorem | The non-unit Egyptian mass is positive: `1 < D² → 0 < 1 − 1/D²`. | `QEFENotes.nonunitMass_pos` |
| T5 | Theorem | The non-unit Egyptian mass never reaches `1`: `0 < D² → 1 − 1/D² < 1`. | `QEFENotes.nonunitMass_lt_one` |
| T6 | Theorem | On `D² > 1`, the non-unit mass is strictly increasing in `D²`. | `QEFENotes.nonunitMass_strictMono` |
| T7 | Theorem | Ising non-unit identity: `1/2 + 1/4 = 1 − 1/4`. | `QEFENotes.ising_nonunit_identity` |
| C1 | Computation | Ising: `D² = 4`, `m = (4,2,4)`, total mass `1`, non-unit mass `3/4`, matching `1 − 1/D²`. | `test_ising_finite_egyptian_core` |
| C2 | Computation | `SU(2)_4`: `D² = 12`, `m = (12,4,3,4,12)`, total mass `1`, non-unit mass `11/12`. | `test_su2_4_finite_egyptian_core` |
| C3 | Computation | `Ψ(0) = 1` and `Ψ(1) = 0` exactly for both worked examples. | `test_psi_at_zero_and_one` |
| C4 | Computation | The §2.4 and §5.3 Mellin normalisations differ off-centre: ratio `≈ 2.0052748` at `s = 3/10`. | `test_two_mellin_normalisations_disagree_off_centre` |
| C5 | Computation | The archived prefactor is exactly `1` at `s = 1/2` and not `1` at `s = 3/10`. | `test_centre_prefactor_degenerates_exactly` |
| C6 | Computation | Edge cases: the trivial category has non-unit mass `0`; empty, non-unit, zero-dimension, bad-sign, and length-mismatched data are rejected. | `test_egyptian_edge_cases` |
| S1 | Source claim | Theorem 3.1, the QEFE `Ψ(s) = ε (D²/π)^{s−1/2} Γ((1−s+a)/2)/Γ((s+a)/2) \overline{Ψ_σ(1−s)}`. | Archived claim; proof interrupted in §5.1, normalisation swapped in §5.3; fails off-centre for the source's own examples. |
| S2 | Source claim | Lemma 4.2, modular transformation of the twisted theta function. | Sketch; depends on a lattice realisation and Poisson summation. |
| S3 | Source claim | Appendix A Galois sign identity. | Deferred to Bantay [5, Lemma 3.4]. |
| S4 | Source claim | v8 is “complete, rigorous, and self-contained”, with “two distinct proofs”. | One proof sketch is present, not two. |
| S5 | Source claim | “The equation holds identically” for Ising and `SU(2)_4`. | Contradicted away from `s = 1/2`. |
| S6 | Source claim | `SU(2)_k → ζ(2s)` as `k → ∞`, and the Riemann-hypothesis suggestion. | Speculative; no limit theorem and no implication. |
| S7 | Source claim | Round 1's conclusion that a finite Dirichlet polynomial cannot satisfy a Riemann-type equation. | Archived self-criticism, never resolved in v8. |
| O1 | Open / conjecture | The correct Mellin normalisation, parity `a`, and root number for a categorical functional equation. | No precise corrected statement is known. |
| O2 | Open / conjecture | A proof of the Galois sign identity from modular-data equivariance rather than citation. | Not formalised. |
| O3 | Open / conjecture | A rigorous normalised `SU(2)_k → ζ(2s)` limit theorem, or a proof that the Galois signs obstruct it. | Open. |

The theorem/computation split is deliberate. T1–T7 are elementary order and
arithmetic facts about the objects the notes define. C1–C6 are exact
calculations, including the measurement of the source's internal inconsistency.
S1–S7 and O1–O3 carry their archived or open status and are **not** theorems of
this reconstruction. In particular, **no row contains a proved Theorem 3.1**;
the QEFE remains a source claim with a documented gap.

## Source claims (not promoted to theorems)

| Claim | Archived status | Reconstruction note |
|---|---|---|
| Theorem 3.1, the QEFE `Ψ(s) = ε (D²/π)^{s−1/2} Γ((1−s+a)/2)/Γ((s+a)/2) \overline{Ψ_σ(1−s)}` | Archived claim; proof interrupted in §5.1 and normalisation swapped in §5.3 | Not formalised. Fails off-centre for the source's own examples (see [`../qefe/`](../qefe/README.md) C6). |
| Lemma 4.2, modular transformation of the twisted theta function | Source lemma with a sketch | Not formalised; depends on a lattice realisation and Poisson summation. |
| Appendix A Galois sign identity, `Σ_μ ε_μ e^{−2πi⟨μ,ν⟩} = ε \overline{ε_{ν^σ}}` | Source claim, computation deferred to Bantay [5, Lemma 3.4] | Not formalised; the appendix states the result it was meant to derive. |
| “Complete, rigorous, and self-contained”, with “two distinct proofs” | Source description | One proof sketch is present, not two; the conformal-character proof is announced but absent. |
| Lemma 2.2, `Σ_{i≠0} 1/m_i = 1 − 1/D²` | Source lemma, correctly proved | Formalised in the primary reconstruction (`QEFE.egyptian_fraction_identity`); its arithmetic is adapted here as T1–T7 and checked in C1–C2. |
| “The equation holds identically” for Ising and `SU(2)_4` | Source assertion | Contradicted away from `s = 1/2`; only the central value is automatic. |
| `SU(2)_k → ζ(2s)` as `k → ∞`, and the Riemann-hypothesis suggestion | Speculative | Open; no limit theorem, no implication, and no evidence for RH. |
| The earlier-round conclusion that a finite Dirichlet polynomial cannot satisfy a Riemann-type equation | Archived self-criticism (round 1) | Never resolved in v8. Recorded as an open contradiction, not as a theorem either way. |

**Nothing in this folder implies the Riemann hypothesis, GRH, the twin-prime
conjecture, Chowla, Sarnak, or Elliott.** The title of the source's §9 is a
suggestion, not a result.

## Python layer

[`python/programme.py`](python/programme.py) is a small exact layer built with
`sympy` only:

- `Datum` — validated finite datum (positive squared dimensions, unit object,
  signs `±1`), with properties `D2`, `denominators`, `reciprocals`,
  `total_mass`, `nonunit_mass`;
- `nonunit_mass(D2)` — the closed form `1 − 1/D²`;
- `categorical_psi(datum, s)` — the finite Dirichlet polynomial;
- `mellin_factor_section_2_4`, `mellin_factor_section_5_3`,
  `normalisation_ratio` — the two competing normalisations;
- `qefe_prefactor(D2, a, s)` — the prefactor of the claimed equation;
- `ISING`, `SU2_4`, `example(name)` — the two worked examples.

All computations are exact rational or gamma expressions; `sympy.N` is used
only to quote the normalisation ratio. No `mpmath` dependency is needed.

```bash
cd the-final-letter/topics/qefe-research-notes
python3 -m pytest -q tests
```

Current result: **6 passed** (under two seconds of test time).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `QEFENotes`
namespace, defines `egyptianDenom`, `unitFraction`, and `nonunitMass`, and
proves T1–T7. It uses only elementary order and field facts over `ℚ`; there is
no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/qefe-research-notes
./lean/check.sh
```

The wrapper calls the shared [`../tools/check-lean.sh`](../tools/check-lean.sh)
against the local Mathlib. Recorded build: [`lean/BUILD.log`](lean/BUILD.log) —
`[check] OK Topic.lean`. What is and is not formalised is set out in
[`lean/README.md`](lean/README.md).

## Open items and known gaps

1. **The central gap is the normalisation, not a missing epsilon.** Reconcile
   §2.4's `Γ(s) π^{-s} D^{2s}` with §5.3's `Γ((s+a)/2) π^{-(s+a)/2} D^s`, and
   derive the parity `a` from the `T`-matrix instead of asserting it. Until
   then no QEFE theorem can be stated precisely.
2. **Resolve round 1 versus round 8.** Either exhibit an infinite family of
   categorical data whose finite polynomials converge to a Riemann-type
   object, or accept the earlier note's conclusion that the finite polynomial
   has no such functional equation.
3. **Formalise the Galois sign identity.** Appendix A is a citation, not a
   proof. A formal version would need the de Boer–Goeree / Coste–Gannon /
   Bantay equivariance.
4. **Theta modularity.** Formalise the lattice realisation and Poisson
   summation behind Lemma 4.2, including rank and determinant hypotheses.
5. **The `SU(2)_k → ζ(2s)` limit.** State a precise normalised limit theorem
   and prove it, or explain why the Galois signs obstruct it. No RH
   consequence follows from the present material.
6. **Deduplication.** Item 35 is the primary reconstruction. This folder should
   keep only the notes-specific finite core and the provenance record; further
   general QEFE work belongs in [`../qefe/`](../qefe/README.md).

## Provenance and links

- [`scraps.html`](../../scraps.html) — inventory item 36 (notes, duplicate).
- [`topics/README.md`](../README.md) — all topic folders.
- [`../qefe/`](../qefe/README.md) — the primary QEFE reconstruction (item 35).
- Source corpus: `archive/quantum-egyptian-functional-equation/` — rounds 1–5,
  7, 8, and the harmonic-sine application.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
