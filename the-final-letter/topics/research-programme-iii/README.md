# Research Programme III — categorical Dirichlet polynomials

**Status:** proposal, reconstructed as a small finite formal core; every limit and Riemann-hypothesis claim remains open or a source claim.  
**Source:** [`archive/maths/rh/research/programme 3/01-research-programme.tex`](../../archive/maths/rh/research/programme%203/01-research-programme.tex)  
**Inventory:** [Scraps](../../scraps.html) item 20 · [Topic index](../README.md)

> This folder does **not** prove the Riemann hypothesis, the convergence of the categorical polynomials to `ζ(2s)`, or the Quantum–Egyptian functional equation. The archived proposal is a research plan; the companion manuscripts in the same source folder dispute two of its central claims.

## Provenance and status

The specified source is `01-research-programme.tex`, a five-phase proposal: construct the finite-level categorical Dirichlet polynomials `Ψ_k(s)`, prove `Ψ̂_k(s) → ζ(2s)`, derive a finite-level explicit formula, control the zero distribution, and conclude RH for `ζ(s)` in the limit.

The same archived folder contains two further manuscripts:

- [`categorical-dirichlet-polynomials.tex`](../../archive/maths/rh/research/programme%203/categorical-dirichlet-polynomials.tex), which argues that the normalised polynomials converge to `0` for `Re s > 1/2` rather than to `ζ(2s)`, and that the Mellin exponent in the QEFE derivation is mismatched;
- [`categorical-dirichlet.tex`](../../archive/maths/rh/research/programme%203/categorical-dirichlet.tex), which gives a character-sum heuristic for a vanishing limit and contains a visibly incomplete lower-bound argument inside its own proof.

Those companion texts are *also* source claims. Neither has been checked line by line here. They are cited because ignoring them would make the dossier misleading. The net position is: **the limit question is contested and open**, not settled in either direction.

## Objects and notation

For a level `k ≥ 1` put `N = k + 2`. The simple objects of `SU(2)_k` are labelled by spins `j = 0, 1/2, …, k/2`, equivalently by the integers

\[
n = 2j+1 \in \{1,2,\ldots,N-1\}.
\]

| Object | Definition in the proposal |
|---|---|
| Quantum dimension | `d_n = sin(π n / N) / sin(π / N)` |
| Total quantum dimension squared | `D_k² = N / (4 sin²(π / N))` |
| Egyptian denominator | `m_n = D_k² / d_n² = N / (4 sin²(π n / N))` |
| Sign character | `χ_n ∈ {±1}`, a Galois sign attached to the object |
| Categorical Dirichlet polynomial | `Ψ_k(s) = Σ_n χ_n m_n^{-s}` |
| Completed function | `Λ_k(s) = (D_k²/π)^{s/2} Γ((s+a_k)/2) Ψ_k(s/2)` |
| Normalised polynomial | `Ψ̂_k(s) = Ψ_k(s) / Ψ_k(1/2)` |

The sign character `χ` is described abstractly in the proposal (a homomorphism from the Grothendieck ring to `{±1}`). No explicit formula for `χ` is given in `01-research-programme.tex`; the companion manuscripts propose the Jacobi symbol, but that identification is not verified here. The Python layer therefore requires the signs to be supplied by the caller.

### Internal inconsistencies found while reconstructing

These are not editorial nitpicks: they change the arithmetic of the model.

1. **Factor of two in `D_k²`.** The standard `SU(2)_k` value is `N/(2 sin²(π/N))`, not `N/(4 sin²(π/N))`. The latter is the literal formula in the proposal, so it is the one implemented. With the literal formula the midpoint denominator is `N/4`, which need not be an integer.
2. **The assertion “all `m_{j,k}` are integers” fails for the literal formula.** At `k = 3` and `n = 1` the value is `(5+√5)/2`; at `k = 4` and `n = 3` it is `3/2`. Computation C4 records this counterexample. With the standard factor `2` the values at these levels are integers.
3. **The stated asymptotic constant is inconsistent.** The proposal writes `m_n ∼ N³/(3π² n²)`; the literal definition gives `N³/(4π² n²)`. Computation C7 verifies the `1/(4π²)` constant numerically to high precision.
4. **Parity of `n`.** Half-integer spins give even `n`, so the object labels are all integers `1, …, N-1`, not only odd integers. This is respected in both the Python and Lean layers.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | Reflection symmetry of quantum dimensions: `qdim N (N − n) = qdim N n`. | `RPIII.qdim_symm` |
| T2 | Theorem | Reflection symmetry of Egyptian denominators: `m(N − n) = m(n)`. | `RPIII.egyptianDenom_symm` |
| T3 | Theorem | Positivity of the Egyptian denominator for `0 < n < N`, `N > 0`. | `RPIII.egyptianDenom_pos` |
| T4 | Theorem | Exact midpoint value `m(N/2) = N/4` for `N ≠ 0`. | `RPIII.egyptianDenom_mid` |
| T5 | Theorem | The triangle bound `|Σ χ_n m_n^{-s}| ≤ Σ m_n^{-s}` for real `s` and `|χ_n| = 1`. | `RPIII.psi_abs_le` |
| T6 | Theorem | Conditional zero reflection: if `Λ s = ε conj(Λ(1−s))`, `ε = ±1`, and `Λ(conj s) = conj(Λ s)`, then `Λ ρ = 0 ⇒ Λ(1−conj ρ) = 0`. | `RPIII.zero_reflection` |
| T7 | Theorem | Positivity of the explicit-formula weight `log m / √m` for `m > 1`. | `RPIII.log_weight_pos` |
| C1 | Computation | `d_n = d_{N−n}` exactly for levels `k ≤ 10`. | `test_quantum_dimension_symmetry_exact` |
| C2 | Computation | The defining ratio `D_k²/d_n²` equals `N/(4 sin²(π n/N))` exactly for `k ≤ 8`. | `test_egyptian_denominator_is_dimension_ratio_exact` |
| C3 | Computation | At the reflection fixed point `n = N/2`, `m_n = N/4` exactly for even `k ≤ 12`. | `test_midpoint_denominator_is_exact_rational` |
| C4 | Computation | The literal integrality claim fails: `m_{0,3} = (5+√5)/2`, and the midpoint fixed point does not exist for odd `N`. | `test_literal_integrality_claim_fails_at_k3` |
| C5 | Computation | The exact triangle bound holds for a non-trivial sign pattern. | `test_psi_obeys_trivial_triangle_bound` |
| C6 | Computation | The normalisation `Ψ̂_k(s) = Ψ_k(s)/Ψ_k(1/2)` equals `1` at `s = 1/2`. | `test_normalisation_fixes_value_at_half` |
| C7 | Computation | The literal leading constant is `1/(4π²)`, not `1/(3π²)`; checked at `N = 4002` with tolerance `1e-8`. | `test_literal_leading_constant_is_one_over_four_pi_squared` |
| S1 | Source claim | `D_k² = N/(4 sin²(π/N))` and `m_n = N/(4 sin²(π n/N))`. | Source definition; implemented literally. See S1 below. |
| S2 | Source claim | All `m_{j,k}` are integers. | Asserted; contradicted by C4. Not proved. |
| S3 | Source claim | `m_{j,k} ∼ N³/(3π²(2j+1)²)`. | Asserted; contradicted by C7. Not proved. |
| S4 | Source claim | The QEFE `Λ_k(s) = ε_k conj(Λ_k(1−s))`. | Cited to QEFE Thm 3.5; contested. Not formalised. |
| S5 | Source claim | `Ψ̂_k(s) → ζ(2s)` uniformly on compact subsets of `Re s > 1/2`. | Numerical evidence in the source; contested by companion manuscripts. Open. |
| S6 | Source claim | `Λ_k` has finitely many zeros, symmetric about `Re s = 1/2`, with an explicit formula. | Phase 3 proposal; not formalised. |
| S7 | Source claim | In the limit all zeros lie on the critical line, proving RH. | Ultimate goal; open. |
| O1 | Open / conjecture | Determine whether `Ψ̂_k(s)` converges at all, and if so to what. | Open / contested. |
| O2 | Open / conjecture | Correct and prove the QEFE for a suitable theta function. | Open. |
| O3 | Open / conjecture | Derive the finite-level explicit formula with explicit gamma terms. | Open. |
| O4 | Open / conjecture | Prove a zero-distribution or critical-line statement for `Λ_k`. | Open. |
| O5 | Open / conjecture | Determine the Galois signs `χ_{j,k}` explicitly. | Open. |
| O6 | Open / conjecture | Reconcile the factor of two in `D_k²` and the integrality/asymptotic claims. | Open; see inconsistencies above. |

T6 is deliberately conditional. It proves the elementary symmetry mechanism, not that the proposal's `Λ_k` satisfies its hypotheses. The proposal asserts the functional equation; the companion manuscript disputes its derivation.

## Source claims (not promoted to theorems)

| # | Claim | Source status | Reconstruction note |
|---|---|---|---|
| S1 | `D_k² = N/(4 sin²(π/N))` and `m_n = N/(4 sin²(π n/N))` | Definition in the proposal | Implemented literally. The factor differs from the standard `SU(2)_k` value; see inconsistency 1. |
| S2 | All `m_{j,k}` are integers. | Asserted in the proposal | **Contradicted by C4** for the literal definition. Not a theorem. |
| S3 | `m_{j,k} ∼ N³/(3π²(2j+1)²)` as `k → ∞`. | Asserted in the proposal | **Contradicted by C7** for the literal definition, which gives `1/(4π²)`. Not a theorem. |
| S4 | The QEFE `Λ_k(s) = ε_k conj(Λ_k(1−s))`. | Proposal cites QEFE Theorem 3.5 | Contested: the companion manuscript reports a Mellin-exponent mismatch. Not formalised. |
| S5 | `Ψ̂_k(s) → ζ(2s)` uniformly on compact subsets of `Re s > 1/2`, away from the pole. | Proposal calls it numerical evidence and a central task | Contested: companion manuscripts claim the normalised limit is `0`. Open, not a theorem. |
| S6 | `Λ_k` has finitely many zeros, symmetric about `Re s = 1/2`, with a finite-level explicit formula. | Proposal's Phase 3 | Not formalised. T6 only proves the abstract reflection mechanism. |
| S7 | In the limit all zeros lie on the critical line, proving RH. | Proposal's ultimate goal | Open. Not claimed here. |

## Open items and known gaps

1. **Convergence to `ζ(2s)`.** The source gives numerical evidence; the companion manuscripts claim the opposite. A precise statement, a corrected normalisation, and a proof (or disproof) are all missing.
2. **The QEFE.** The theta-function modular relation and the Mellin exponent need an independent check. The companion critique is itself not fully rigorous.
3. **The explicit formula.** The finite-level formula is asserted, not derived here. The gamma terms and the exact test-function class are unspecified.
4. **Zero distribution and the critical line.** No zero-counting or Levinson/Rouché argument is formalised.
5. **The Galois signs `χ_{j,k}`.** `01-research-programme.tex` gives no explicit formula. The Jacobi-symbol proposal in the companion manuscript is unverified.
6. **Integrality and normalisation.** The literal `D_k²` formula and the integrality claim are incompatible. A corrected reconstruction should choose the standard factor `2` and re-derive the asymptotics.

## Python layer

[`python/programme.py`](python/programme.py) uses exact sympy algebra:

- `level_size(k)`, `object_indices(k)`;
- `quantum_dimension(k, n)`, `total_quantum_dimension_squared(k)`;
- `egyptian_denominator(k, n)`, `egyptian_denominator_from_ratio(k, n)`;
- `midpoint_denominator(k)`;
- `psi(k, s, signs)`, `trivial_bound(k, sigma)`, `normalised_psi(k, s, signs)`;
- `scaled_leading_term(k, n)`.

The signs are supplied by the caller; the default all-ones pattern is a bookkeeping device, not a claim about the modular tensor category. The module raises `ValueError` for invalid levels, labels, or signs, and `ZeroDivisionError` when a chosen sign pattern makes `Ψ_k(1/2) = 0`.

```bash
cd the-final-letter/topics/research-programme-iii
python3 -m pytest -q tests
```

Current result: **8 passed** (under one second).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and defines `RPIII.qdim`, `RPIII.D2`, `RPIII.egyptianDenom`, and `RPIII.psi`. It proves T1–T7. There is no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/research-programme-iii
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`. See [`lean/README.md`](lean/README.md) for what is and is not formalised.

## Provenance

- [`01-research-programme.tex`](../../archive/maths/rh/research/programme%203/01-research-programme.tex) — the proposal.
- [`categorical-dirichlet-polynomials.tex`](../../archive/maths/rh/research/programme%203/categorical-dirichlet-polynomials.tex) — companion critique of the limit and the QEFE.
- [`categorical-dirichlet.tex`](../../archive/maths/rh/research/programme%203/categorical-dirichlet.tex) — companion character-sum analysis.
- [`scraps.html`](../../scraps.html) — inventory entry 20.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
