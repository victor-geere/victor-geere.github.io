# Factorisation and theta — research programme

**Status:** speculative essay vein; finite formal core and exact computation layer reconstructed. The theta–zeta bridge and every analytic limit remain source claims or open items.  
**Source:** [`archive/essays/factorisation-theta-zeta.html`](../../archive/essays/factorisation-theta-zeta.html) ("The Theta Function and Its Mathematical Connections").  
**Inventory:** [Scraps](../../scraps.html) item 43 · [Topic index](../README.md).

## Provenance and source assessment

The source is a single short HTML essay (about 10 KB, seven prose sections). It has no numbered theorem environments, no proofs beyond substitution and differentiation, and no bibliography. Its mathematical content is the following chain.

1. The **divisor detector** `f_k(x) = cos(2πk/x) + cos(2πx) − 2` for a positive integer `k`.
2. The claim that its roots are **exactly the integer divisors** of `k`, each a **double zero**.
3. A reminder that `ζ(s)² = Σ τ(n) n^{-s}` for `Re s > 1`.
4. The classical **theta function** `θ(t) = Σ_{n∈ℤ} e^{-πn²t}` and its functional equation `θ(1/t) = √t θ(t)`.
5. A sketch of the **Mellin transform** route from `θ` to the zeta functional equation.
6. The finite **divisor theta sum** `s_k(t) = Σ_{d|k, d∈ℤ} e^{-πd²t} = 2 Σ_{d|k, d>0} e^{-πd²t}`.
7. The admission that a direct map from `f_k` to `θ` is "elusive" and that the correspondence "remains indirect".

The essay is therefore best read as an expository, speculative vein, not as a proof of new arithmetic. Nothing in it states or proves the Riemann hypothesis. The only bridge to zeta is the standard theta–Mellin derivation, quoted without the convergence and continuation details. This dossier formalises the genuinely elementary finite layer (the detector algebra and finite theta sums) and keeps the analytic bridge explicitly open.

One small erratum in the source: it writes the derivative of `cos(2πk/x)` with a leading minus sign. The correct derivative is `+(2πk/x²) sin(2πk/x)`. The conclusion `f'(d) = 0` at a divisor is unaffected, and the computation layer certifies the correct second derivative.

## Reconstructed objects and notation

| Object | Definition | Role in the source |
|---|---|---|
| Divisor detector | `f_k(x) = cos(2πk/x) + cos(2πx) − 2`, `k ∈ ℕ₊`, `x ≠ 0` | Roots at divisors of `k` |
| Integer divisors | `D(k) = {d ∈ ℤ : d ∣ k}` | Root set claimed by the source |
| Detector multiplicity | `f_k(d) = f_k'(d) = 0`, `f_k''(d) = −4π²((k/d)²/d² + 1) ≠ 0` | "Double zeros" claim |
| Theta function | `θ(t) = Σ_{n∈ℤ} e^{-πn²t}`, `t > 0` | Classical object introduced in §4 |
| Finite theta sum | `Θ_N(t) = Σ_{n=0}^{N−1} e^{-πn²t}` | Truncation used in the formal core |
| Divisor theta sum | `s_k(t) = Σ_{d∈D(k)} e^{-πd²t}` | Source's finite "restricted theta" |
| Zeta | `ζ(s) = Σ n^{-s}` for `Re s > 1`, then by continuation | Only reached through the classical Mellin sketch |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is exercised in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are *not* theorems of this reconstruction.

The Lean definition uses totalised division, so `divisorDetector k 0 = 0` and both cosines equal `1` at `x = 0`. That is a Lean convention (division by zero is defined as zero), not a claim that `0` divides `k`; T4/T5 are stated for non-zero inputs. The Python layer rejects `x = 0`.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The detector is non-positive: `f_k(x) ≤ 0` for all real `x` (total convention at `x = 0`). | `FactorisationTheta.divisorDetector_nonpos` |
| T2 | Theorem | `f_k(x) = 0` iff both cosines equal `1`. | `FactorisationTheta.divisorDetector_eq_zero_iff` |
| T3 | Theorem | The detector is even: `f_k(−x) = f_k(x)`, hence roots come in `±d` pairs. | `FactorisationTheta.divisorDetector_neg` |
| T4 | Theorem | Every non-zero divisor `d` of `k` is a root: `f_k(d) = 0`. | `FactorisationTheta.divisorDetector_of_dvd` |
| T5 | Theorem | For a non-zero integer `x`, `f_k(x) = 0 ↔ x ∣ k`. | `FactorisationTheta.divisorDetector_eq_zero_iff_dvd` |
| T6 | Theorem | The finite theta sum is positive when non-empty: `0 < Θ_N(t)` for `N > 0`. | `FactorisationTheta.finiteTheta_pos` |
| T7 | Theorem | The finite theta sum is antitone in `t`: `t₁ ≤ t₂ → Θ_N(t₂) ≤ Θ_N(t₁)`. | `FactorisationTheta.finiteTheta_antitone` |
| C1 | Computation | Every signed integer divisor of `k ∈ {1,2,6,12}` is an exact root. | `test_divisor_detector_roots_at_all_integer_divisors` |
| C2 | Computation | Non-divisors are not roots: `f_6(4) = −2`, `f_6(9) = −3/2`, and a numerical grid on `k = 12`. | `test_divisor_detector_is_negative_off_divisors` |
| C3 | Computation | Divisors are exactly double zeros: closed-form `f''(d) = −4π²((k/d)²/d² + 1) ≠ 0` for all positive divisors of `12`. | `test_divisors_are_double_zeros` |
| C4 | Computation | `s_k(t) = 2 Σ_{d|k,d>0} e^{-πd²t}` exactly, for `k ∈ {1,6,12,36}`. | `test_divisor_theta_is_twice_the_positive_side` |
| C5 | Computation | `Θ_N(t) > 0` and `Θ_N` decreases on a grid; edge case `Θ_0(t) = 1`. | `test_finite_theta_positive_and_antitone` |
| C6 | Computation | Truncated `θ(1/t) = √t θ(t)` residual `< 10⁻⁴⁰` at 50 digits for `t ∈ {0.7, 1, 2}` (numerical evidence only). | `test_theta_functional_equation_numerically` |

The edge-case and input-validation checks live in `test_invalid_inputs_and_edge_cases`; they are supporting tests, not ledger rows.

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| The roots of `f_k` are precisely the integer divisors of `k`, positive and negative. | Source assertion, §2 | T4 gives divisor ⇒ root and T5 gives root ⇒ divisor for non-zero **integer** inputs. The reduction from an arbitrary real root to an integer input is not formalised in Lean (it follows from T2 and `Real.cos_eq_one_iff`). C1/C2 test the finite cases. |
| Every root is a double zero. | Source assertion, §2 | The source's derivative display has a sign typo. C3 checks `f(d) = f'(d) = 0` and `f''(d) ≠ 0` for `k = 12`; the general Lean statement of multiplicity is not formalised. |
| `ζ(s)² = Σ τ(n) n^{-s}` for `Re s > 1`. | Source = classical Dirichlet-series identity | Not formalised; stated only as background. |
| `θ(t) > 0` for all `t > 0`, with no real zeros. | Source assertion, §4 | T6 proves positivity of the finite truncation only. The infinite statement is not formalised. |
| `θ(1/t) = √t θ(t)`. | Source = classical theta functional equation, attributed to Poisson summation | Not formalised. C6 is a numerical truncation check, not a proof. |
| The Mellin transform of `(θ(t) − 1)/2` gives `π^{-s/2} Γ(s/2) ζ(s)` and, after splitting at `1`, the zeta functional equation. | Source sketch, §5 | Not formalised. Requires measure theory, the incomplete gamma integral, and analytic continuation. |
| `s_k(t) = 2 Σ_{d|k,d>0} e^{-πd²t}`. | Source assertion, §6 | C4 verifies it exactly; it is a finite identity, not an infinite-theta result. |
| A direct expression of `f_k` in terms of `θ` exists. | Source explicitly says this is elusive/indirect | Recorded as open; no formula is asserted by the source. |

## Open items and gaps

1. **No zeta or RH theorem.** The source does not state RH and proves nothing about the zeros of `ζ`. The theta–Mellin route is the ordinary classical construction; it is not a new proof of the functional equation, and it says nothing about the critical line.
2. **Real-root characterisation.** Extend T5 from integer inputs to all real `x ≠ 0` in Lean, using `Real.cos_eq_one_iff` twice.
3. **Exact multiplicity in general.** Formalise `f_k''(d) = −4π²((k/d)²/d² + 1) ≠ 0` for all positive divisors, not only the tested `k = 12` cases.
4. **Infinite theta algebra.** Formalise convergence of `θ(t)`, its positivity, and the functional equation. This needs Poisson summation or the classical modular transformation, far beyond the essay's elementary layer.
5. **Mellin/zeta bridge.** Formalise the Mellin transform computation and the zeta functional equation, including convergence and continuation. This is a substantial analytic project and is deliberately left open.
6. **The `f_k`–`θ` dictionary.** The source itself concedes that no precise mapping is known. Any such dictionary would be a new conjecture and must be stated separately, not inferred from this essay.

## Python layer

[`python/programme.py`](python/programme.py) uses sympy for exact work. It provides:

- `divisor_detector(k, x)` and its exact first/second derivatives;
- `positive_divisors(k)`, `integer_divisors(k)`;
- `double_zero_certificate(k, d)` and `expected_second_derivative(k, d)`;
- `divisor_theta(k, t)` (signed sum) and `divisor_theta_positive_side(k, t)`;
- `finite_theta(N, t)` and `functional_equation_residual(t, N, dps)`;
- `detector_sign_on_integers(k, x_max)`.

Run the suite from this folder:

```bash
cd the-final-letter/topics/factorisation-theta
python3 -m pytest -q tests
```

Current result: **20 passed** (7 test functions, several parametrised). The suite runs in under 20 seconds (about 1 second once the sympy cache is warm). Numerical assertions state their tolerance in the test names/docstrings (`1e-30` for sign and monotonicity checks, `1e-40` for the functional-equation residual).

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the namespace `FactorisationTheta`, and proves T1–T7. It contains no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/factorisation-theta
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log). What is and is not formalised is explained in [`lean/README.md`](lean/README.md).

## Provenance and links

- [Source essay](../../archive/essays/factorisation-theta-zeta.html) — "The Theta Function and Its Mathematical Connections".
- [Scraps inventory](../../scraps.html) — item 43.
- [Topic index](../README.md) — all reconstructed topics.
- [Programme standard](../PROGRAMME-STANDARD.md).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
