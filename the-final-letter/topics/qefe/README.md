# Quantum–Egyptian functional equation (QEFE) — reconstructed programme

**Status:** archived claim reconstructed as an elementary formal core plus an
exact computation layer. The central functional equation is **not** promoted to
a theorem: the archived proof has an acknowledged gap, and the source's own
worked examples satisfy the displayed identity only at the central point.  
**Source:** [`archive/qefe/quantum-egyptian-functional-equation-v8.html`](../../archive/qefe/quantum-egyptian-functional-equation-v8.html)
(v8, dated March 2026; the folder also holds v1–v7, the TeX source, and two
earlier drafts).  
**Inventory:** [Scraps](../../scraps.html) item 35 · [Topic index](../README.md).

## Provenance and what the source contains

The QEFE corpus is a single-author programme, not a published result. Version 8
is the latest archived draft and presents itself as "complete, rigorous, and
self-contained", with "two distinct proofs (lattice-theoretic and
conformal-character)". The text actually contains one proof sketch: a lattice
realisation of an integral modular tensor category (MTC), a Poisson-summation
argument for a twisted theta function, and a Mellin-transform derivation of a
Riemann-zeta-type functional equation. The two proofs promised in the
introduction are not both present.

The source defines:

- the **Egyptian denominators** `m_i = D² / d_i²` of an integral MTC, where
  `D² = Σ_i d_i²` is the squared total quantum dimension;
- a **Galois character** `χ(m_i) = ε_i(σ)` read off the action of a Galois
  automorphism `σ` on the modular `S`-matrix;
- the **categorical Dirichlet series** `Ψ(s) = Σ_i χ(m_i) m_i^{-s}`;
- a **twisted theta function** `Θ(τ) = Σ_i χ(m_i) exp(-π (m_i/D)² τ)` and its
  Mellin transform;
- a claimed functional equation of Riemann-zeta type, with parity `a ∈ {0,1}`,
  root number `ε = ±1`, and a Galois-conjugate category;
- explicit data for the Ising MTC and `SU(2)_4`;
- speculative sections on Chern–Simons theory, the Langlands programme, a limit
  to `ζ(2s)`, and the Riemann hypothesis.

The archived status of the central claim is **source claim / unproved**. The
Riemann-hypothesis material is **speculative** and is not a result of this
reconstruction. Nothing here implies RH, GRH, the twin-prime conjecture, Chowla,
Sarnak, or Elliott.

## Reconstruction strategy

The source has a genuine, fully elementary core: the Egyptian-denominator
algebra and Lemma 2.2. That core is formalised in Lean and checked exactly in
Python. The analytic functional equation, the lattice theta transformation, and
the Galois sign identity are kept as source claims. The Python layer also tests
the source's own examples against its displayed equation, which is how the
off-centre failure is documented rather than hidden.

## Objects and notation

| Object | Definition | Role here |
|---|---|---|
| Squared quantum dimensions | `d_i² > 0`, `Σ_i d_i² = D²` | finite input datum |
| Egyptian denominator | `m_i = D² / d_i²` | reconstructed exactly |
| Unit denominator | `m_0 = D²` because `d_0 = 1` | used in Lemma 2.2 |
| Egyptian reciprocal sums | `Σ_i 1/m_i = 1`, `Σ_{i≠0} 1/m_i = 1 - 1/D²` | Theorem T5 |
| Galois signs | `χ(m_i) = ε_i(σ) ∈ {±1}` | tabulated for the two examples |
| Categorical Dirichlet series | `Ψ(s) = Σ_i χ(m_i) m_i^{-s}` | exact finite series |
| Gamma ratio | `Γ((1-s+a)/2) / Γ((s+a)/2)` | exact at `s = 1/2` |
| QEFE prefactor | `(D²/π)^(s-1/2) Γ((1-s+a)/2) / Γ((s+a)/2)` | exact at `s = 1/2` |
| Claimed QEFE | `Ψ(s) = ε · prefactor · conjugate(Ψ_σ(1-s))` | **source claim**, not a theorem |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean)
with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a
test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test / reference |
|---|---|---|---|
| T1 | Theorem | If `D² > 0` and `d² > 0`, the Egyptian denominator `D²/d²` is positive. | `QEFE.egyptianDenom_pos` |
| T2 | Theorem | `(D²/d²)⁻¹ = d²/D²` for non-zero `D²`, `d²`. | `QEFE.inv_egyptianDenom` |
| T3 | Theorem | If `D² > 1`, the non-unit Egyptian mass `1 - 1/D²` is positive. | `QEFE.egyptianUnit_pos` |
| T4 | Theorem | For finite positive `d_i²` summing to `D²`, `Σ_i 1/m_i = 1`. | `QEFE.egyptian_total` |
| T5 | Theorem | **Lemma 2.2:** with `d_0² = 1`, `Σ_{i≠0} 1/m_i = 1 - 1/D²`. | `QEFE.egyptian_fraction_identity` |
| T6 | Theorem | At `s = 1/2`, `Γ((1-s+a)/2)/Γ((s+a)/2) = 1` for `a ≥ 0`. | `QEFE.gammaRatio_center` |
| T7 | Theorem | At `s = 1/2`, the QEFE prefactor is exactly `1` for `D² > 0`, `a ≥ 0`. | `QEFE.qefePrefactor_center` |
| C1 | Computation | Ising and `SU(2)_4` satisfy `Σ 1/m_i = 1` and `Σ_{i≠0} 1/m_i = 1 - 1/D²` exactly. | `test_egyptian_identity_examples` |
| C2 | Computation | Malformed MTC data (wrong sum, zero `d²`, negative `D²`, empty) is rejected. | `test_egyptian_denominator_validation` |
| C3 | Computation | `Ψ(0) = 1` and `Ψ(1) = 0` exactly for both examples. | `test_dirichlet_series_exact_values` |
| C4 | Computation | At `s = 1/2`, gamma ratio and full prefactor equal `1` exactly. | `test_gamma_ratio_and_prefactor_at_centre` |
| C5 | Computation | The archived QEFE holds at `s = 1/2` for both worked examples. At the centre both sides are real, so this checks a real identity and is not evidence off-centre. | `test_claimed_functional_equation_at_centre` |
| C6 | Computation | **The archived QEFE fails off-centre** for the source's own Ising and `SU(2)_4` data. | `test_claimed_functional_equation_fails_off_centre` |
| C7 | Computation | The Ising sign product is `-1`, contradicting the source's `ε = 1`; `SU(2)_4` gives `+1`. | `test_ising_sign_product_inconsistency` |
| C8 | Computation | `categorical_psi` rejects mismatched or empty coefficient lists. | `test_categorical_psi_rejects_mismatched_lengths` |
| S1 | Source claim | Theorem 3.1: the QEFE for any integral MTC. | Archived claim; proof gap and off-centre failure documented below. |
| S2 | Source claim | Lemma 4.2: modular transformation of the twisted theta function. | Not formalised; lattice/Poisson-summation input. |
| S3 | Source claim | Appendix A Galois sign identity. | Not formalised; deferred to an external lemma in the source. |
| S4 | Source claim | "The equation holds identically" for Ising and `SU(2)_4`. | Contradicted by C6 away from `s = 1/2`. |
| O1 | Open / conjecture | A corrected Mellin normalisation, parity, and root number for a categorical functional equation. | No precise corrected statement is known. |
| O2 | Open / conjecture | The `SU(2)_k → ζ(2s)` limit and any Riemann-hypothesis consequence. | Speculative in the source; no proof. |

The distinction matters: T1–T7 are elementary facts about the objects the
source defines. C1–C8 are exact or high-precision calculations. S1–S4 and O1–O2
are recorded with their archived or open status and are **not** theorems of this
reconstruction. Neither the Theorem nor the Computation rows contain Theorem 3.1
of the source.

## Why the central claim is not a theorem here

Three independent reasons, all recorded in the source itself or reproducible
from its data:

1. **The derivation is explicitly interrupted.** In §5.1 the text derives an
   identity, observes that it "merely reproduces the original first part", and
   then says "Instead, we obtain the functional equation ... after a different
   manipulation". §5.2 offers a candidate replacement, but it is a heuristic
   manipulation rather than a derivation of the displayed identity.
2. **The Mellin normalisation is inconsistent.** §2.4 computes the Mellin
   transform with a factor `D^{2s}` and `Γ(s)`; §5.3 replaces it with `D^s` and
   `Γ((s+a)/2)` by hand, invoking a "standard result" about theta
   characteristics without matching it to the categorical theta series. The
   parity `a` is asserted, not derived.
3. **The worked examples do not satisfy the displayed equation off-centre.**
   Using the tabulated data and the source's own choices `ε = 1`, `a = 0`
   (Ising) and `a = 1` (`SU(2)_4`), the exact residual `Ψ(s) - RHS(s)` is:

   | `s` | Ising residual | `SU(2)_4` residual |
   |---|---|---|
   | `3/10` | `0.451760…` | `0.313807…` |
   | `1/2` | `0` | `0` |
   | `7/10` | `-1.158287…` | `-0.510693…` |
   | `13/10` | `11.621092…` | `-20.531524…` |

   The equality at `s = 1/2` is automatic because T7 makes the prefactor `1`;
   it is not evidence for the general identity. C6 asserts failure with a
   tolerance of `0.1` at 25-digit evaluation.
4. **The root number is internally inconsistent.** Appendix A defines
   `ε = ∏_μ ε_μ / |∏_μ ε_μ|`. For Ising the signs are `(1, -1, 1)`, so the
   product is `-1`, while §6.1 states `ε = 1`. C7 records this.

None of this shows that no corrected categorical functional equation exists. It
shows that the v8 statement, as written, is an archived claim with a broken
proof and counterexamples among its own examples.

## Source claims (not promoted to theorems)

| Claim | Archived status | Reconstruction note |
|---|---|---|
| Lemma 2.2, Egyptian fraction identity | Source lemma, proved correctly | Fully formalised as T4/T5 under the stated finite hypotheses. |
| Theorem 3.1, the QEFE | Source claim; proof has an explicit gap | Not formalised. Fails off-centre for the source's examples (C6). |
| Lemma 4.2, modular transformation of `Θ` | Source lemma, sketch | Not formalised; depends on Huang/Dong–Li–Mason lattice realisation and Poisson summation. |
| Galois sign identity (Appendix A) | Source claim, cites Bantay | Not formalised; the appendix defers the computation to an external lemma. |
| "The equation holds identically" for Ising and `SU(2)_4` | Source assertion | Contradicted by C6. Only the central value is verified. |
| `SU(2)_k → ζ(2s)` as `k → ∞` | Speculative limit | Open. No rigorous limit theorem is stated or proved. |
| Riemann-hypothesis connection | Speculative suggestion | Open. No implication is claimed or proved. |
| "Two independent proofs" | Source description | The archived text contains one proof sketch, not two. |
| Chern–Simons / Langlands interpretations | Interpretive discussion | Not mathematical claims of this reconstruction. |

## Open items and known gaps

1. **Correct formulation.** Determine the correct Mellin normalisation, parity
   convention, and root-number definition for a categorical Dirichlet series.
   Until then the QEFE is a conjecture-shaped source claim.
2. **Theta modularity.** Formalise the lattice realisation and the Poisson
   summation step (Lemma 4.2), including the rank and determinant hypotheses.
3. **Galois sign identity.** Prove the Appendix A identity from the
   de Boer–Goeree / Coste–Gannon / Bantay equivariance instead of citing it.
4. **Root number.** Reconcile the product-of-signs definition with the
   per-example values; the Ising case is already inconsistent.
5. **`SU(2)_k` limit.** State and prove a limit theorem for the normalised
   series, or record precisely why the Galois signs obstruct it.
6. **Scope of T5.** T5 assumes a finite list of positive `d_i²` summing to `D²`
   with `d_0² = 1`. It does not construct an MTC or verify integrality from
   categorical axioms; that input is taken as a hypothesis.

## Python layer

[`python/programme.py`](python/programme.py) provides:

- `egyptian_denominators(D2, dsq)` — exact `m_i`, with validation;
- `egyptian_reciprocal_sums(D2, dsq)` — total and non-unit Egyptian sums;
- `ising()` and `su2_4()` — the two worked examples, with signs and parity;
- `categorical_psi(m, chi, s)` and `psi_of(data, s)` — exact Dirichlet series;
- `gamma_ratio(a, s)` and `qefe_prefactor(D2, a, s)` — gamma/prefactor data;
- `qefe_rhs(data, s, epsilon=None)` and `functional_equation_residual(...)`;
- `sign_product(data)` — the Appendix A root number from the signs.

Run the tests from the topic folder:

```bash
cd the-final-letter/topics/qefe
python3 -m pytest -q tests
```

Current result: **8 passed** in under two seconds. Only `sympy` is required;
`mpmath` is not needed because all checks are exact or evaluated by `sympy.N`.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `QEFE`
namespace, and proves T1–T7. It defines `egyptianDenom`, `egyptianUnit`,
`gammaRatio`, and `qefePrefactor`. There is no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/qefe
./lean/check.sh
```

The wrapper calls the shared [`tools/check-lean.sh`](../tools/check-lean.sh)
against the local Mathlib. Recorded build: [`lean/BUILD.log`](lean/BUILD.log) —
`[check] OK Topic.lean`. What is and is not formalised is set out in
[`lean/README.md`](lean/README.md).

## Provenance and related material

- [`scraps.html`](../../scraps.html) — inventory item 35.
- [`topics/README.md`](../README.md) — all topic folders.
- Source corpus: `archive/qefe/quantum-egyptian-functional-equation-v8.html`
  (plus v1–v7, `.tex`, and earlier drafts).
- Duplicate inventory item 36, `qefe-research-notes`, covers the same corpus.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
