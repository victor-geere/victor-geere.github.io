# p-adic and stochastic zeta — research programme

**Status:** adjacent reconstruction; small formal core from the p-adic material, zeta and stochastic bridges left open.  
**Source:** [`archive/essays/p-adic.html`](../../archive/essays/p-adic.html) — “p-adic Numbers and the Kubota–Leopoldt p-adic Zeta Function”, attributed in the file to Grok 3 (xAI).  
**Inventory:** [Scraps](../../scraps.html) item 41 · [Topic index](../README.md).

## Provenance and source assessment

The source is a short, AI-generated expository essay. It introduces the p-adic norm, finite base-`p` encodings, p-adic geometry and calculus in outline, and states the Kubota–Leopoldt interpolation formula

\[
\zeta_p(1-k)=\left(1-p^{k-1}\right)\zeta(1-k).
\]

It is not a research paper: it contains no proofs of the Kubota–Leopoldt existence, continuity or analyticity assertions, and its recurring “forex price” and schemes discussion is speculative framing with no mathematical content. **The source contains no stochastic process, no stochastic representation of zeta, and no p-adic spectral analysis.** Those phrases come from the inventory label for item 41 (“Kubota–Leopoldt p-adic zeta, p-adic spectral analysis, and stochastic-process representations of zeta”), not from the essay. This dossier therefore reconstructs only what the essay actually defines: the local p-adic norm, the finite digit encoding, the local Euler factor, and the rational value forced by the interpolation formula at `k = 2`.

The essay makes no claim about the Riemann hypothesis, GRH, twin primes, Chowla or Sarnak. No such claim is attributed to it here.

## Reconstructed objects and notation

| Object | Definition | Role |
|---|---|---|
| `pNorm p q` | Mathlib's `padicNorm p q` on `ℚ` | the p-adic norm of the source |
| `encode p s` | `Nat.ofDigits p s`, i.e. `s₀ + s₁p + s₂p² + ⋯` | finite little-endian digit encoding |
| `eulerFactor p` | `1 − p⁻¹` | local Euler factor at `s = 1` |
| `klFactor p k` | `1 − p^(k−1)` | Kubota–Leopoldt interpolation factor |
| `klValue p` | `(1 − p) · (−1/12)` | value at `s = −1` (`k = 2`), using `ζ(−1) = −1/12` |

The Python layer additionally has exact rationals `padic_norm`, `padic_norm_rational`, `kl_value`, and the archimedean context value `η(2) = π²/12`.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom` or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | For a prime `p`, `‖pⁿ‖_p = p^{−n}`. | `PadicStoch.pNorm_p_pow` |
| T2 | Theorem | For a prime `p`, `n ↦ ‖pⁿ‖_p` is strictly antitone. | `PadicStoch.pNorm_p_pow_strictAnti` |
| T3 | Theorem | The p-adic norm is non-archimedean: `‖q+r‖_p ≤ max(‖q‖_p, ‖r‖_p)`. | `PadicStoch.pNorm_nonarchimedean` |
| T4 | Theorem | The source's worked example: base `3`, digits `[2,1,0]`, encodes `5`. | `PadicStoch.encode_example` |
| T5 | Theorem | The finite Euler-factor identity `(1−p⁻¹)Σ_{k<N} p^{−k} = 1−p^{−N}`. | `PadicStoch.eulerFactor_telescope` |
| T6 | Theorem | At `k=2` the interpolation bookkeeping gives `klValue p = (p−1)/12`. | `PadicStoch.klValue_eq` |
| T7 | Theorem | For `p > 1`, `klValue p > 0`. | `PadicStoch.klValue_pos` |
| C1 | Computation | `v₂(12)=2`, `v₃(12)=1`; `‖12‖₂=1/4`, `‖12‖₃=1/3`, `‖5‖₅=1/5`, `‖0‖₂=0`; valuation of `0` and base `1` rejected. | `test_padic_valuation_and_norm` |
| C2 | Computation | The ultrametric inequality holds on a grid of rationals for `p = 2,3,5`, with exact edge values. | `test_padic_norm_is_ultrametric_on_grid` |
| C3 | Computation | `encode 3 [2,1,0] = 5`; empty string gives `0`; invalid digits rejected. | `test_encode_source_example` |
| C4 | Computation | Every digit string of length `≤ 4` over `{0,…,p−1}` encodes below `p^length`, for `p = 2,3,5`. | `test_encode_bound_on_all_small_digit_strings` |
| C5 | Computation | The Euler-factor telescoping identity holds exactly for `N = 0,1,7` and `p = 2,3,5`. | `test_euler_factor_and_telescope` |
| C6 | Computation | `ζ(−1) = −1/12`, `ζ(−3) = 1/120`, and `kl_value(p,2) = (p−1)/12`; `k=4` checked too. | `test_kubota_leopoldt_rational_values` |
| C7 | Computation | The archimedean context value `η(2) = π²/12`. | `test_eta_two_archimedean_context` |

### What the theorem rows do and do not mean

T1–T3 formalise the norm statements the essay uses as definitions or standard facts. T4 is exactly the essay's worked encoding example. T5 is the finite geometric identity behind the local Euler factor; it is not the analytic Euler product. T6–T7 are the rational bookkeeping obtained by substituting the classical value `ζ(−1) = −1/12` into the stated interpolation formula at `k = 2`. **They are not a construction of the Kubota–Leopoldt function and do not prove its interpolation property for general `k`.**

## Source claims (not promoted to theorems)

Every row in this table is of kind **Source claim**; none is used as a theorem in the reconstruction.

| Source claim | Archived status | Reconstruction note |
|---|---|---|
| `ℚ_p` is the completion of `ℚ` under `‖·‖_p`; `ℤ_p` is compact and totally disconnected. | Standard exposition, asserted without proof | Not formalised. Mathlib has a p-adic completion, but this reconstruction does not develop it. |
| An infinite digit sequence converges to an element of `ℤ_p`, giving a compact encoding. | Source assertion | Only finite encodings are tested (C3–C4). No convergence or compactness proof. |
| `ζ_p(1−k) = (1−p^{k−1}) ζ(1−k)` for all `k ≥ 2`. | Source definition/claim | Not proved. Only the rational right-hand side at `k = 2` is formalised (T6) and numerically checked at `k = 2,4` (C6). |
| `ζ_p` is continuous and analytic on `ℤ_p`, unlike `ζ` at `s = 1`. | Source claim | Not formalised; no p-adic analytic function is constructed here. |
| `ζ_p` is built from p-adic measures and integrals. | Source claim | Not formalised. |
| The values connect to Bernoulli numbers. | Standard context | Only `B₂ = 1/6` and `B₄ = −1/30` are used in exact computations; no general Bernoulli/Kummer theory is developed. |
| p-adic encodings could model forex prices and lead to predictive models. | Speculative framing | No mathematical claim; not formalised and not treated as evidence. |
| Schemes could classify price behaviours. | Speculative framing | No mathematical claim; not formalised. |

## Open / conjecture

These are **not** theorems of the reconstruction. They are the main unresolved statements, with the reason each remains open.

| # | Kind | Statement | Why it is open |
|---|---|---|---|
| O1 | Open | Define the p-adic measure and the Kubota–Leopoldt function `ζ_p`, and prove `ζ_p(1−k) = (1−p^{k−1}) ζ(1−k)` for all `k ≥ 2`. | No p-adic measure or interpolation theorem is constructed here; only the `k = 2` rational prefactor is formalised (T6). |
| O2 | Open | `ζ_p` is continuous and analytic on `ℤ_p` and regular at `s = 1`. | The source asserts this without proof; no p-adic analytic function is constructed. |
| O3 | Open | Give a precise stochastic-process representation of `ζ` or of a p-adic zeta analogue. | The source contains no stochastic content; the phrase is an inventory label, so there is not yet a statement to formalise. |
| O4 | Open | Formulate the p-adic spectral/transfer-operator problem referred to by the inventory. | The essay defines no operator, spectral problem or transfer operator. |
| O5 | Open | Define a p-adic eta analogue and relate it to `ζ_p`. | The essay defines no eta function. C7 checks only the archimedean value `η(2) = π²/12`. |
| O6 | Open | Prove the Kummer-type congruences that make the interpolation formula consistent across `k`. | Outside the formal core; only the exact values at `k = 2` and `k = 4` are computed. |
| O7 | Open | Relate this p-adic material to the RH/GRH programme, if such a relation exists. | The essay makes no RH/GRH claim, and nothing here bears on RH, GRH, twin primes, Chowla or Sarnak. |

The source's speculative “forex” and “schemes” remarks are not mathematical conjectures and are therefore not listed as open problems.

## Python layer

[`python/programme.py`](python/programme.py) is an exact `sympy` module:

- `padic_valuation(p, n)`, `padic_norm(p, n)` for non-zero integers, with `‖0‖_p = 0`;
- `padic_valuation_rational(p, q)`, `padic_norm_rational(p, q)`, `ultrametric_holds(p, q, r)`;
- `encode_digits(p, digits)` and `encode_bound_holds(p, digits)`;
- `euler_factor(p)`, `euler_telescope(p, N)`;
- `zeta_at_negative_integer(k)`, `kl_factor(p, k)`, `kl_value(p, k)`;
- `eta_at_two()`, the archimedean context check.

Run the suite:

```bash
cd the-final-letter/topics/padic-stochastic-zeta
python3 -m pytest -q tests
```

Current result: **7 passed** (a few seconds on a cold sympy import, under one second warm). The tests use exact rational arithmetic throughout; the only transcendental value is the closed form `π²/12` in C7, checked by symbolic simplification.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the namespace `PadicStoch`, and proves T1–T7. Definitions: `pNorm`, `encode`, `eulerFactor`, `klFactor`, `klValue`.

```bash
cd the-final-letter/topics/padic-stochastic-zeta
./lean/check.sh
```

The wrapper calls the shared `../../tools/check-lean.sh`, which uses the local Mathlib installation at `~/lean/mathlib4`. The last successful output is recorded in [`lean/BUILD.log`](lean/BUILD.log).

The file contains no `sorry`, `axiom` or `admit`. What is **not** formalised: the p-adic completion and its topology, infinite digit convergence, the Kubota–Leopoldt measure/function, analyticity, Bernoulli/Kummer congruences, any stochastic process, and any p-adic spectral operator. See [`lean/README.md`](lean/README.md) for the item-by-item account.

## Links

- [Scraps inventory](../../scraps.html) — item 41.
- [Topic index](../README.md) — all reconstructed topics.
- [The Final Letter](../../index.html).
- [Programme standard](../PROGRAMME-STANDARD.md).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
