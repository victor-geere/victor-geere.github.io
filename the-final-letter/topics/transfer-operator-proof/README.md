# Transfer-operator proof (rh.html) — research programme

**Status:** reconstructed finite formal core + exact computation layer. The archived source is an **exploratory programme, not a proof**; the Riemann Hypothesis and the analytic continuation of the operator family remain **open** here and in the source.  
**Source:** [`archive/maths/rh.html`](../../archive/maths/rh.html) — “A Transfer Operator Proof of the Riemann Hypothesis — Final Version” (dated July 2026 in the file).  
**Inventory:** [Scraps](../../scraps.html) item **33** · [Topic index](../README.md).

## What the programme is

The source proposes a Hilbert–Pólya strategy: realise the nontrivial zeros of `ζ` as the spectrum of a regularised transfer operator `L̃_s`, equip the space with a Petersson pairing, prove self-adjointness and vanishing deficiency indices, and conclude that the spectrum is real, hence that every zero lies on `Re s = ½`. Parts VI–IX of the source then audit that strategy and conclude that each load-bearing step is either circular or equivalent to RH. The document ends, correctly, with the status **open**.

This folder does not reassert the strategy. It reconstructs the **finite algebra the source actually defines** — the diagonal Euler-product operator, its finite Fredholm determinant, the Euclidean self-adjointness of a real diagonal operator, and the indefinite Krein form of Definition 3.1 — and records everything analytic, spectral and RH-related as a source claim or an open item.

### What the source defines

| Object | Source definition | Reconstruction |
|---|---|---|
| von Mangoldt weight | `Λ(n) = log p` if `n = p^k`, else `0` (Def. 2.1) | `programme.von_mangoldt`; not needed in Lean |
| transfer eigenvalue | `p^{-s}` for primes `p` (Def. 2.2) | `TransferOperator.primeWeight` |
| finite Fredholm determinant | `∏_p (1 - p^{-s}) = 1/ζ(s)` for `Re s > 1` (Thm. 2.2) | `TransferOperator.fredholmDet`, `programme.fredholm_det` |
| model pairing | finite Euclidean diagonal form `Σ w_i x_i y_i` | `TransferOperator.diagForm`, `diagEnergy` |
| Petersson pairing | `⟨f,g⟩_ξ = (1/2πi)∫ f ḡ(1−w̄) (ξ'/ξ) dw` (Def. 3.1) | modelled finitely by `kreinForm`; the analytic integral is **not** formalised |
| completed `ξ` | `ξ(s) = ½ s(s−1) π^{−s/2} Γ(s/2) ζ(s)` (Def. 1.2) | `programme.xi_numeric` for numerical checks only |

The source itself corrects two earlier errors: `Ψ_P(s) = ∏_p sin(πs/p)` is **not** a prime sieve (it vanishes at every integer `n ≥ 2`, composites included), and the Petersson pairing is an **indefinite Krein form**, not a positive inner product. Both corrections are preserved below.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom` or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are **not** theorems of this reconstruction.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | **Theorem** | For a positive prime `p` and any real `s`, `p^{-s} > 0`. | `TransferOperator.primeWeight_pos` |
| T2 | **Theorem** | For a prime `p ≥ 2` and `s > 0`, `p^{-s} < 1`; hence `1` is not an eigenvalue of the Euler-product model. | `TransferOperator.primeWeight_lt_one` |
| T3 | **Theorem** | If every finite eigenvalue is `< 1`, the finite determinant `∏(1−λ_i)` is positive (in particular nonzero). | `TransferOperator.fredholmDet_pos` |
| T4 | **Theorem** | The finite determinant vanishes exactly when some eigenvalue equals `1`. | `TransferOperator.fredholmDet_eq_zero_iff` |
| T5 | **Theorem** | A real diagonal operator is symmetric for the Euclidean pairing: `Σ w_i x_i y_i = Σ w_i y_i x_i`. | `TransferOperator.diagForm_symm` |
| T6 | **Theorem** | A positive diagonal weight gives nonnegative energy: `0 ≤ Σ w_i x_i²` when all `w_i ≥ 0`. | `TransferOperator.diagEnergy_nonneg` |
| T7 | **Theorem** | If a Krein sign is negative, the form has a negative direction; symmetry does not imply positivity. | `TransferOperator.kreinForm_negative_direction` |
| C1 | **Computation** | Exact von Mangoldt values, including `Λ(1)=0`, `Λ(4)=log 2`, `Λ(6)=0`, and rejection of `n<1`. | `test_von_mangoldt_values_and_edge_case` |
| C2 | **Computation** | The truncated `Ψ_P` vanishes at every integer `2 ≤ n ≤ 30`, primes **and** composites. | `test_prime_sieve_does_not_isolate_primes` |
| C3 | **Computation** | `Ψ_P(5/2) ≠ 0` numerically, and the empty truncation equals `1`. | `test_prime_sieve_nonzero_off_integers` |
| C4 | **Computation** | For `p ∈ {2,3,5,7,11,29}` and four positive `s`, `0 < p^{-s} < 1`; `p=1` is rejected. | `test_prime_weights_stay_in_unit_interval` |
| C5 | **Computation** | The finite determinant is `1/3` on `(1/2,1/3)`, `0` on `(1/2,1)`, and `1` on the empty family; the truncation `p ≤ 5` at `s=2` equals `144/225`. | `test_fredholm_determinant_vanishes_iff_eigenvalue_one` |
| C6 | **Computation** | The diagonal form is symmetric and the energy is positive on a nonzero vector, zero on the zero vector, negative for a negative weight. | `test_diagonal_form_is_symmetric_and_positive` |
| C7 | **Computation** | A `(+,−)` Krein form is symmetric, has positive and negative directions, and a nonzero isotropic vector. | `test_krein_form_is_symmetric_but_indefinite` |
| C8 | **Computation** | The classical symmetry `ξ(s) = ξ(1−s)` holds at two points to `1e-14` (mpmath, 30 digits). | `test_xi_functional_equation_numeric` |

## Source claims (not promoted to theorems)

The archived source labels several of these “Theorem”. We record them with the source's status and do **not** claim them as proved here.

| Claim | Source status | Reconstruction note |
|---|---|---|
| **Riemann Hypothesis:** all nontrivial zeros satisfy `Re s = ½` (source Thm. 5.2) | **Archived claim / not proved** | The source's own Part VI says the argument is circular; it is **open** here and everywhere. |
| Determinant identity `det(1 − L̃_s) = ∏_p(1 − p^{-s}) = 1/ζ(s)` for `Re s > 1` (Thm. 2.2) | Source theorem for `Re s > 1` | The finite determinant is formalised (T4); the infinite Euler product and its convergence are not. |
| Self-adjointness of `L̃_s` on the critical line (Thm. 3.2) | Source theorem with a proof sketch | Not formalised. The proof deforms a contour through the zeros of `ξ`, and the pairing is indefinite (Caveat 2). |
| Vanishing deficiency indices / essential self-adjointness (Thm. 4.2) | Source theorem with a proof sketch | Not formalised; depends on uniqueness of Dirichlet series and the unproved self-adjointness. |
| Purely real spectrum `σ(L̃_s) ⊂ ℝ` (Thm. 5.1) | Source theorem, conditional | Only the finite diagonal analogue (T5–T6) is proved. Reality for the analytic family is open. |
| `L̃_s` maps the prime sieve to the zero sieve, `L̃_s[Ψ_P] = ξ` (Thm. 2.3) | Source theorem | Not formalised; the source itself calls the Ruelle/Selberg motivation “not a proof”. |
| No trace-class `T` has `det(1−sT) = ξ(s)/ξ(0)` (Thm. 6.3) | Source theorem, quoting Hadamard genus theory | Not formalised; recorded as an external analytic claim. |
| Li's criterion: RH ⇔ `λ_n ≥ 0` for all `n` (Thm. 6.4) | External theorem (Li 1997; Bombieri–Lagarias) | Not formalised; it is an RH-equivalent reformulation, not a proof of RH. |
| Riemann–von Mangoldt explicit formula (Thm. 6.5) | Classical theorem | Not formalised; the source uses it to explain the continuation obstruction. |
| `0 ≤ Λ ≤ 0.22`, `RH ⇔ Λ = 0` (Thm. 7.3, 8.2, 8.3) | External theorems (Rodgers–Tao; Polymath 15) | Not formalised; the remaining gap is an **open** numerical/analytic problem. |
| `Ψ_P` isolates the primes | **Withdrawn** by the source's own correction | Refuted by C2: `Ψ_P` vanishes at composites as well. |
| The Petersson pairing is a genuine inner product | **Withdrawn** by the source's Caveat 2 | It is an indefinite Krein form; modelled by C7/T7. |

## Open items and known gaps

1. **RH itself.** Nothing in this folder proves, disproves, or numerically resolves the Riemann Hypothesis. C8 checks a classical symmetry of `ξ`; it does not check the location of its zeros.
2. **Determinant completion.** Construct a trace-class (or Hilbert–Schmidt `det₂`) operator whose determinant is an entire completion of `ξ`, independently of the zeros. The source's `A e_ρ = ρ^{-1} e_ρ` is built *from* the zeros and is therefore circular; no trace-class realisation exists (source Thm. 6.3, not formalised).
3. **Metric positivity / unbroken PT.** The source identifies this with the Weil–Li positivity criterion, which is equivalent to RH. It is not derived anywhere.
4. **Analytic continuation into `½ < Re s ≤ 1`.** The Euler-built operator converges only for `Re s > 1`; continuing the *operator family* is not the same as continuing `1/ζ`. This remains open.
5. **Deficiency indices and spectral reality.** Essential self-adjointness of the analytic `L̃_s` is not established; the finite diagonal facts T5–T6 do not transfer to the infinite-dimensional, indefinite setting.
6. **de Bruijn–Newman gap.** The unconditional bounds leave `Λ ∈ [0, 0.22]`; showing `Λ = 0` is exactly RH.

## Python layer

[`python/programme.py`](python/programme.py) is importable without side effects and uses exact sympy arithmetic, with mpmath only in `xi_numeric`.

- `primes_up_to(n)`, `von_mangoldt(n)`;
- `prime_sieve(s, primes)`, `prime_weight(p, s)`;
- `fredholm_det(eigenvalues)`, `truncated_euler_product(s, primes)`;
- `diagonal_form`, `diagonal_energy`, `krein_form`;
- `xi_numeric(s, dps)`.

```bash
python3 -m pytest the-final-letter/topics/transfer-operator-proof/tests -q
```

Current result: **8 passed** in about 0.3 s.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, uses the namespace `TransferOperator`, and defines `primeWeight`, `fredholmDet`, `diagForm`, `diagEnergy`, `kreinForm`. It proves T1–T7. There is no `sorry`, `axiom` or `admit`.

```bash
the-final-letter/topics/transfer-operator-proof/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log). What is **not** formalised is listed in [`lean/README.md`](lean/README.md): the analytic Euler product, the `ξ` completion, self-adjointness and deficiency indices of the operator family, Li/Weil positivity, the explicit formula, the de Bruijn–Newman constant, and RH.

## Provenance

- [`archive/maths/rh.html`](../../archive/maths/rh.html) — the archived “Final Version”, status **EXPLORATORY PROGRAMME — NOT A COMPLETE PROOF**.
- [`scraps.html`](../../scraps.html) — inventory entry 33.
- [`topics/README.md`](../README.md) — all topic folders.
- [`PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md) — the dossier and ledger standard.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
