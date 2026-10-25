# Harmonic sine and the eta function — research programme

**Status:** fragment reconstructed into a small formal core and an exact computation layer. The archived source's uniqueness claim for `α = 1/2` is **not** adopted as a theorem; it is recorded as an archived/speculative source claim, and the analytic-continuation material is left open.  
**Source:** [`archive/maths/rh/research/harmonic-sine-eta/harmonic-sine-eta-v2.html`](../../archive/maths/rh/research/harmonic-sine-eta/harmonic-sine-eta-v2.html) (with the `v2.tex` source and the companion [`infinite-series-sin-cos.html`](../../archive/maths/rh/research/harmonic-sine-eta/infinite-series-sin-cos.html)).  
**Inventory:** [Scraps](../../scraps.html) item 16 · [Topic index](../README.md).

## What the programme is

The source proposes a **non-greedy harmonic sine reconstruction**. Instead of selecting signs greedily, it fixes the alternating signs `(-1)^(n-1)` and studies the series

\[
\mathcal S_\alpha(\theta)=\sum_{n=1}^{\infty}(-1)^{n-1}n^{-\alpha}\sin(\theta\log n),
\qquad
\mathcal C_\alpha(\theta)=\sum_{n=1}^{\infty}(-1)^{n-1}n^{-\alpha}\cos(\theta\log n).
\]

These are the imaginary and real parts of the Dirichlet eta function

\[
\eta(\alpha+i\theta)=\sum_{n=1}^{\infty}(-1)^{n-1}n^{-\alpha-i\theta}
=\sum_{n=1}^{\infty}(-1)^{n-1}n^{-\alpha}e^{-i\theta\log n},
\]

up to the sign convention on `θ`; the source writes the exponent as `e^{iθ log n}`. The source then imposes a greedy angular condition on the partial sums `S_N`,

\[
\operatorname{Re}\!\left(\overline{S_{N-1}}\,w_N\right)\le 0
\quad\text{for all }N,\qquad w_N=N^{-\alpha}e^{i\theta\log N},
\]

together with `η(α+iθ) = 0`, and asserts that this forces `α = 1/2`.

This folder reconstructs the **finite algebra** that the programme actually uses: positive decreasing weights, the period-two alternating sign, the pairing of adjacent terms, and the finite factorisation of even eta truncations. The convergence, analytic continuation, zero-free-region and uniqueness arguments are preserved as source claims and open items. The source is a short fragment: it gives no complete proof of its central assertion, and one of its steps (a zero-free region for `Re(s) > 1/2`) is not a classical theorem.

## Provenance and source status

| Item | Detail |
|---|---|
| Canonical source | `harmonic-sine-eta-v2.html`, a self-contained HTML note titled “Harmonic Sine Reconstruction and the Dirichlet Eta Function” |
| TeX source | `harmonic-sine-eta-v2.tex` in the same folder (the HTML and TeX agree) |
| Companion | `infinite-series-sin-cos.html` / `.tex` in the same folder |
| Inventory description | “Fragment; eta companion” (item 16) |
| Archived status | **Fragment / archived speculative claim.** Not a proved paper, not a duplicate of a proved result. |
| Relationship to other topics | Uses the alternating (non-greedy) sine series; distinct from the greedy reconstruction of [item 11](../greedy-harmonic-decomposition/README.md) and from the superseded [harmonic-sine claim](../harmonic-sine/README.md). |

## Reconstructed objects and notation

The Lean and Python layers use the series index `n ≥ 1`, while the Lean truncation index runs over `0, …, N-1`.

| Object | Definition | Lean name |
|---|---|---|
| Weight | `weight α n = (n+1)^(-α)`, the `n`-th series weight `(n+1)^{-α}` | `HarmonicEta.weight` |
| Eta term | `etaTerm α n = (-1)^n weight α n` | `HarmonicEta.etaTerm` |
| Eta truncation | `etaPartial α N = Σ_{n<N} etaTerm α n`, i.e. `Σ_{k=1}^N (-1)^{k-1} k^{-α}` | `HarmonicEta.etaPartial` |
| Cosine truncation | `cosPartial α θ N = Σ_{n<N} (-1)^n (n+1)^{-α} cos(θ log(n+1))` | `HarmonicEta.cosPartial` |
| Sine truncation | `sinPartial α θ N = Σ_{n<N} (-1)^n (n+1)^{-α} sin(θ log(n+1))` | `HarmonicEta.sinPartial` |
| Positive harmonic sum | `H_N(α) = Σ_{n=1}^N n^{-α}` | `(range N).sum (weight α)` |
| Greedy condition | `Re(conj(S_{N-1}) w_N) ≤ 0` for all `N` | `programme.greedy_condition_holds` |

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a passing pytest test in [`tests/test_programme.py`](tests/test_programme.py). Rows marked **Source claim** and **Open / conjecture** are *not* theorems of this reconstruction.

| # | Kind | Statement | Lean / test |
|---|---|---|---|
| T1 | Theorem | The weight is positive: for `α > 0` and every `n`, `0 < weight α n`. | `HarmonicEta.weight_pos` |
| T2 | Theorem | The weight is strictly decreasing: for `α > 0`, `weight α (n+1) < weight α n`. | `HarmonicEta.weight_lt_succ` |
| T3 | Theorem | The alternating sign has period two: `(-1)^(n+2) = (-1)^n`. | `HarmonicEta.sign_period_two` |
| T4 | Theorem | Pairing adjacent terms: the even eta truncation is `Σ_{k<N} (weight α (2k) − weight α (2k+1))`. | `HarmonicEta.etaPartial_two_mul` |
| T5 | Theorem | Finite even factorisation: `A_{2N}(α) = H_{2N}(α) − 2^(1−α) H_N(α)`, where `A_{2N}` is the even eta truncation. | `HarmonicEta.etaPartial_even_factor` |
| T6 | Theorem | Even eta truncations are positive: for `α > 0` and `N > 0`, `0 < etaPartial α (2N)`. | `HarmonicEta.etaPartial_even_pos` |
| T7 | Theorem | At `θ = 0`: `cosPartial α 0 N = etaPartial α N` and `sinPartial α 0 N = 0`. | `HarmonicEta.cos_sin_at_zero` |
| C1 | Computation | The finite even factorisation `A_{2N} = H_{2N} − 2^(1−α) H_N` holds exactly for several rational `α` and `N`. | `test_even_factorisation_exact` |
| C2 | Computation | Even eta truncations are strictly positive for several `α > 0` and `N`; invalid `α ≤ 0` and index `0` are rejected. | `test_even_partial_sums_positive_and_input_validation` |
| C3 | Computation | The complex eta truncation equals `C_α(θ) + i S_α(θ)` to `1e-20`. | `test_cosine_sine_decomposition_numeric` |
| C4 | Computation | `η(s) = (1 − 2^(1−s)) ζ(s)` for real `s > 1`, checked to `1e-25` with mpmath. | `test_eta_zeta_factorisation_numeric` |
| C5 | Computation | `η(1/2 + iγ₁) = 0` at the first non-trivial zeta zero `γ₁ ≈ 14.1347`, residual below `1e-30`. | `test_eta_zero_on_critical_line` |
| C6 | Computation | The alternating harmonic partial sums approach `log 2`, with the alternating-series error bound `1/(N+1)`. | `test_alternating_harmonic_limit` |
| C7 | Computation | Consecutive eta terms alternate in sign, i.e. the sign word is period two. | `test_alternating_signs` |
| C8 | Computation (edge case) | At `θ = 0` the greedy condition fails: `Re(conj(S_{N-1}) w_N) > 0` for the tested `N ≤ 8` (and for every `N ≥ 2` by the accompanying positivity argument). | `test_greedy_condition_edge_theta_zero` |

Auxiliary private lemmas in the Lean file (`sum_range_pair`, `sum_range_odd_weight`) split a `2N`-term sum into even/odd indices and extract the factor `2^(−α)`. They support T4–T5 and are not counted as programme theorems.

## Source claims (not promoted to theorems)

These are recorded with the source's status, not adopted as proved here.

| Claim | Source status | Reconstruction note |
|---|---|---|
| `S_α` and `C_α` converge for every `α > 0` and equal the imaginary/real parts of `η(α+iθ)`. | Source claim; standard background | Not formalised. The finite truncations, the sign alternation and the `θ = 0` reduction are formalised; convergence and the limit identification are not. |
| The greedy condition plus `η(α+iθ) = 0` characterises admissible `(α, θ)`. | Source claim | The condition is implemented and tested; the characterisation is not proved. |
| For `α > 1/2`, `η(α+iθ)` has no zeros “by the classical zero-free region”. | Source claim; **unsupported as stated** | The classical zero-free region is `Re(s) > 1`, not `Re(s) > 1/2`. A zero-free half-plane `Re(s) > 1/2` would already give the Riemann hypothesis. This step cannot be used as a theorem. |
| For `α < 1/2`, zeros exist by the functional equation but fail the greedy condition. | Source claim; speculative | The factorisation `η(ρ) = 0` for a zeta zero `ρ` needs analytic continuation, and the failure of the greedy condition is asserted, not proved. |
| At `α = 1/2`, zeros on the critical line satisfy the greedy condition by the Riemann–Siegel formula; partial sums are of order `n^{-1/4}`. | Source claim; unproved | No Riemann–Siegel estimate is formalised or numerically verified here. |
| Therefore `α = 1/2` is the unique admissible exponent, giving a new characterisation of the non-trivial zeros “without assuming RH”. | Archived claim | **Not a theorem.** The argument uses an unproved zero-free half-plane, and the conclusion would encode critical-line information. It remains a speculative source claim. |

The source's central uniqueness assertion is therefore best read as an **archived research proposal**, not a result. In particular, the existence of zeros of `η` with `Re(s) = 1/2` is classical only in the sense that the non-trivial zeros of `ζ` that are known lie on that line; it does not prove that all zeros are there.

## Open items and known gaps

1. **Convergence and real/imaginary identification.** Formalise the convergence of `S_α`, `C_α` for `α > 0` (Dirichlet/alternating-series argument) and the identity with `η(α+iθ)`. This is the largest missing analytic layer.
2. **Analytic continuation and functional equation.** The claims about zeros with `α < 1/2` rely on the completed zeta function and the functional equation; neither is formalised.
3. **Zero-free region.** Replace the source's “classical” `Re(s) > 1/2` assertion with the correct classical region `Re(s) > 1`, and determine what, if anything, survives for `1/2 < α ≤ 1`.
4. **Greedy condition at zeros.** Decide rigorously whether the condition `Re(conj(S_{N-1}) w_N) ≤ 0` holds at any zero, and whether it can select a unique exponent. The `θ = 0` edge case shows the condition is not vacuous.
5. **Uniqueness of `α = 1/2`.** The source gives no complete proof. A precise statement would have to exclude `α < 1/2` without assuming the conclusion, and would need a quantitative Riemann–Siegel estimate. It remains an open/conjectural item.
6. **Relation to RH.** Any statement that the admissible zeros are exactly the critical-line zeros is at least as strong as the Riemann hypothesis; it is not claimed here.

## Python layer

[`python/programme.py`](python/programme.py) implements, with exact sympy arithmetic plus mpmath for the high-precision checks:

- `weight(alpha, n)`, `eta_term(alpha, n)`;
- `eta_partial(alpha, N)`, `harmonic_partial(alpha, N)`;
- `eta_partial_even_exact`, `even_factorisation_rhs`, `even_factorisation_holds`;
- `complex_partial(alpha, theta, N)`, `sine_partial`, `cosine_partial`;
- `eta_via_zeta(s)`, `eta_zero_residual(gamma)`, `first_critical_zero()`;
- `greedy_condition_values`, `greedy_condition_holds`;
- `alternating_harmonic_partial(N)`.

`eta_via_zeta` and `eta_zero_residual` use the analytic-continuation identity only as a **numerical cross-check**; they are not used to claim a theorem.

Run the suite from this folder:

```bash
cd the-final-letter/topics/harmonic-sine-eta
python3 -m pytest -q tests
```

Recorded result: **8 passed** (under 20 seconds). The tests cover every `Computation` row and the edge case `θ = 0`, including input validation.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `HarmonicEta` namespace, defines `weight`, `etaTerm`, `etaPartial`, `cosPartial`, `sinPartial`, and proves T1–T7. It contains no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/harmonic-sine-eta
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — last successful check of `Topic.lean`. The shared checker is [`../tools/check-lean.sh`](../tools/check-lean.sh), which elaborates against the local Mathlib at `~/lean/mathlib4`.

### What is not formalised

- Convergence of either series and the identification with `η`.
- The Euler product, analytic continuation, functional equation, and zero-free regions.
- The Riemann–Siegel formula and any estimate for partial sums at zeros.
- The source's greedy-condition characterisation and the uniqueness of `α = 1/2`.
- Any statement about the Riemann hypothesis.

See [`lean/README.md`](lean/README.md) for a declaration-by-declaration account.

## Provenance

- [`scraps.html`](../../scraps.html) — inventory entry 16, described as a fragment.
- [`topics/README.md`](../README.md) — all topic folders.
- [`archive/maths/rh/research/harmonic-sine-eta/`](../../archive/maths/rh/research/harmonic-sine-eta) — the source HTML, TeX and companion notes.
- [`../greedy-harmonic-decomposition/`](../greedy-harmonic-decomposition/README.md) — the completed pilot for the dossier format.
- [`summary/12-open-problems/withdrawn-and-refuted.md`](../../summary/12-open-problems/withdrawn-and-refuted.md) — the withdrawn-and-refuted ledger.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
