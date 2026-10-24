# GHD correlation kernel — research programme

**Status:** reconstructed finite formal core + exact computation layer; archived GRH claim preserved as a non-theorem.  
**Source:** [`archive/maths/ghd-correlation-kernel/overview.html`](../../archive/maths/ghd-correlation-kernel/overview.html), a landing page for a 42-file archive (32 HTML pages, plus Markdown notes, errata, critique, style sheet, and Python scripts).  
**Inventory:** [Scraps](../../scraps.html) item 25 · [Topic index](../README.md).  
**Overlaps:** inventory items 11 (greedy harmonic decomposition) and 28 (phase interference); this folder is the duplicate-prone GHD/GRH bundle, not a new independent programme.

## Provenance and status

The archive is the GHD/Correlation-Kernel cluster of the Harmonic Sine Transform (HST) programme, dated May 2026. The overview page is a directory, not a paper: the mathematical content lives in the linked `greedy-harmonic-thresholds.html`, `closed-form-kernel.html`, `off-diagonal-kernel-formula.html`, `correlation-kernel.html`, and the GRH capstone pages. The cluster asserts a “complete, self-contained logical pathway to GRH”.

That assertion is an **archived claim**, not a result of this reconstruction. The archive itself contains:

- [`critique.html`](../../archive/maths/ghd-correlation-kernel/critique.html), which identifies two unclosed gaps: the Fredholm-determinant identity and the continuous deformation across conductors;
- [`vanishing_result.md`](../../archive/maths/ghd-correlation-kernel/vanishing_result.md), a later negative-result note: the exact greedy kernel does **not** produce a Fredholm determinant vanishing at the Riemann zeros;
- [`errata.md`](../../archive/maths/ghd-correlation-kernel/errata.md), whose threshold identity is written as `θ_n* = π/(n + 1/2)` (not `π/(n+2)`), and whose “proofs” are assertions rather than derivations.

GRH remains open in mainstream mathematics. Nothing below claims otherwise.

## What the source actually defines

The finite core is a set of centred step functions on `[0, π]` and their Gram matrix. The source conflates two different objects, and the distinction is the main finding of this reconstruction.

| Object | Definition |
|---|---|
| Harmonic angle | `α n = π / (n + 2)`, for `n = 0, 1, 2, …` |
| Actual greedy digit | `δ n(θ) = 1` when the residual at step `n` is at least `α n`; else `0` |
| Actual residual | `r n(θ) = θ − ∑_{k<n} δ k(θ) α k` |
| **Step model** | `s n(θ) = 1[θ ≥ α n]`, i.e. the residual is ignored |
| Centred functions | `φ n = δ n − θ/π` (true) and `ψ n = s n − θ/π` (step model) |
| Step-model kernel | `Kstep(n,m) = ∫₀^π ψ n ψ m dθ`, with `a = 1/(n+2)`, `b = 1/(m+2)`: `Kstep(n,m) = π((a²+b²)/2 − max(a,b) + 1/3)` |
| Diagonal in threshold form | `Kdiag(t) = (t³ + (π − t)³)/(3π²)` |
| True greedy kernel | `Kgreedy(n,m) = ∫₀^π φ n φ m dθ`, computed exactly for small `n` by interval splitting |
| Finite Gram matrix | `K_N = (⟨φ n, φ m⟩)_{0 ≤ n,m < N}`, positive semidefinite by construction |

The source's closed forms are formulas for `Kstep`, not for `Kgreedy`. They agree with the source's diagonal formula `K(n,n) = (π/3)(1 + (n+1)³)/(n+2)³`, because at `t = α n` the threshold form reduces to it. They do **not** agree with the true greedy kernel: for example `Kstep(0,1) = π/72`, while `Kgreedy(0,1) = −7π/72` (the archive's own `vanishing_result.md` records the latter).

### Two archived claims are false as printed

1. **Selection monotonicity is false.** The actual digit is not a step function of `θ`. At `θ = π/4`, `δ 2 = 1`; at the larger target `θ = π/2`, `δ 2 = 0`, because `δ 0` consumes the whole angle. So `θ n* = α n` can hold as the *infimum* of the support while `δ n` is not `1[θ ≥ α n]`.
2. **The printed off-diagonal formula is wrong.** For `n = 0, m = 1` it gives `143π/1296`; the exact integral is `π/72`. The correct step-model formula is the `max(a,b)` expression above. This is recorded as computation C4 and should be treated as an erratum.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are never presented as theorems.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `0 < α n` for every `n`. | `GHD.alpha_pos` |
| T2 | Theorem | `n ↦ α n` is strictly antitone. | `GHD.alpha_strictAnti` |
| T3 | Theorem | Exact diagonal entry at the threshold: `Kdiag(α n) = (π/3)(1 + (n+1)³)/(n+2)³`. | `GHD.Kdiag_alpha_closed` |
| T4 | Theorem | `Kdiag(t) > 0` for `0 < t < π`. | `GHD.Kdiag_pos` |
| T5 | Theorem | Diagonal symmetry: `Kdiag(t) = Kdiag(π − t)`. | `GHD.Kdiag_symm` |
| T6 | Theorem | Exact rational constant: `Kdiag(π/2) = π/12`. | `GHD.Kdiag_half` |
| T7 | Theorem | Finite off-diagonal symmetry: `Kstep(a,b) = Kstep(b,a)`. | `GHD.Kstep_symm` |
| C1 | Computation | At `θ = α n`, index `n` is selected and no earlier index is, for `n ≤ 12`. | `test_threshold_at_own_angle_is_selected` |
| C2 | Computation | `Kdiag(α n) = Kdiag_n(n)` exactly for `n ≤ 30`; `Kdiag(π/2) = π/12`; symmetry about `π/2`. | `test_diagonal_closed_form_and_half_value` |
| C3 | Computation | The corrected off-diagonal formula equals the defining integral for seven index pairs, is symmetric, and reduces to the diagonal at `n = m`. | `test_off_diagonal_closed_form_matches_integral` |
| C4 | Computation | The archived off-diagonal formula is refuted: `K_off_source(0,1) = 143π/1296 ≠ π/72 = K(0,1)`. | `test_archived_off_diagonal_formula_is_refuted` |
| C5 | Computation | The finite step-model section is exactly symmetric and positive definite for size 7 (all leading principal minors positive). | `test_finite_kernel_is_symmetric_and_positive_semidefinite` |
| C6 | Computation | The actual greedy digit is not monotone: `δ 2(π/4) = 1` but `δ 2(π/2) = 0`; the step model is not the true kernel. | `test_actual_greedy_digits_are_not_monotone` |
| C7 | Computation | The true greedy kernel has the archive's exact small values `K(0,0)=π/12`, `K(1,1)=2π/9`, `K(0,1)=−7π/72`, `K(2,2)=23π/72`, `K(1,2)=π/48`, and is PSD. | `test_true_greedy_kernel_matches_archived_small_values` |
| C8 | Computation | Edge cases: negative indices raise `ValueError`; the empty matrix is handled; `n = m` is the diagonal edge case; swapped arguments agree. | `test_edge_cases` |

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| Exact threshold identity `θ n* = α n = π/(n+2)` for all `n` | Archived theorem, “proved by induction” | The attained instance is tested (C1). The claimed consequence `δ n = 1[θ ≥ α n]` is false (C6). The errata variant `π/(n + 1/2)` is inconsistent with the archive's own tables. |
| Diagonal closed form `K(n,n) = (π/3)(1+(n+1)³)/(n+2)³` | Archived theorem | Correct for the step model (T3, C2). Not established for the true greedy kernel, where `K(1,1) = 2π/9 ≠ π/9`. |
| Off-diagonal closed form `(π/6)[a³+b³−2ab+6a²b+6ab²]` | Archived claim, “exact” | Refuted as printed (C4). The corrected step-model formula is C3. |
| Selection monotonicity `θ ↦ δ n(θ)` | Archived lemma (Lemma 4.1) | Refuted by C6. The error propagates into the threshold paper and the closed-form derivation. |
| Kernel is positive semidefinite | Archived claim | True for any Gram matrix, including both the step model and the true kernel (C5, C7), but this does not identify the two. |
| Leading eigenvalue `λ 1(N) ≈ 1.028 N`; eigenvalue suppression at zeta zeros `10⁻⁷`–`10⁻¹¹` | Numerical observation | Not reproduced here. The archive's own `vanishing_result.md` reports that the determinant does **not** vanish at the zeros; suppression of one eigenvalue is not a zero of the determinant. |
| Fredholm determinant recovers `L(s,χ)/L(2s,χ²)`; monotonicity of the argument; deformation across conductors | Archived claim, “Programme IIX” | `critique.html` documents that the determinant identity and the deformation are not derived. Not Lean theorems; not accepted here. |
| GRH follows from the GHD/HST construction | Archived claim | Open in mainstream mathematics. The archive's status page asserts completion; its own critique and negative-result note contradict that assertion. |
| Trace asymptotic `∑_{n≤N}K(n,n) = (π/3)(N − 3 log N + π²/2 + O(1))` | Archived proposition | Not verified. The leading `πN/3` is consistent with `K(n,n) → π/3`, but the constant and the logarithmic term are unchecked. |
| Sieve density `D(N,θ) = (θ/π) log(N+2) + O(1)` | Archived lemma | Not formalised or tested; exact harmonic targets are a boundary case, and the true digits are not monotone. |

## Python layer

[`python/programme.py`](python/programme.py) is an exact sympy module (no floating point except in explicit numerical displays):

- `alpha`, `alpha_scaled`, `step_indicator`, `model_phi`;
- `greedy_digits`, `greedy_accumulated` — the **actual** recursion, including residual tracking;
- `K_diag`, `K_diag_n`, `K_off`, `K_off_source` — the step-model formula, its diagonal, the corrected off-diagonal, and the archived formula verbatim;
- `kernel_integral` — exact integration of the step functions via `Piecewise`;
- `scaled_kernel_matrix`, `leading_principal_minors`, `is_positive_semidefinite` — exact finite PSD certificates;
- `true_kernel_matrix` — exact interval-splitting computation of the true greedy kernel (small sizes only);
- `diagonal_trace`, `selection_word_report` — small diagnostics.

Run the suite from the topic folder:

```bash
cd the-final-letter/topics/ghd-correlation-kernel && python3 -m pytest -q tests
```

Recorded result: **8 passed** (under 20 seconds; the run takes 3–15 seconds depending on cache and machine load). The edge-case test covers negative indices and empty matrices.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `GHD` namespace, defines `alpha`, `Kdiag`, and `Kstep`, and proves T1–T7. It contains no `sorry`, `axiom`, or `admit`.

```bash
cd the-final-letter/topics/ghd-correlation-kernel && ./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

What is **not** formalised is listed in [`lean/README.md`](lean/README.md): the true greedy recursion and its kernel, the non-monotonicity counterexample as a Lean theorem, positive semidefiniteness of a general finite Gram matrix, the threshold induction, and every analytic/GRH claim. The Lean core deliberately formalises the exact step-model entries and their finite positivity/symmetry, which is what the source actually computes correctly.

## Open items and known gaps

1. **The true greedy kernel has no closed form.** The step model is not the greedy kernel. An efficient exact description of the supports of `δ n` (the interval partition grows with `N`) is open in this reconstruction; only small-`N` exact values are available.
2. **The threshold statement needs to be restated.** `θ n* = α n` is an attained infimum, not the threshold of a step function. A correct monotonicity statement would have to track the residual, and the archive's Lemma 4.1 must be withdrawn.
3. **The off-diagonal formula needs an erratum** in the archived page. Until corrected, downstream “exact kernel” spectral computations are using wrong entries.
4. **The GRH pathway is open and externally contradicted.** The Fredholm determinant identity, the uniform bound on `P χ`, the monotonicity of the argument, and the deformation across primitive characters are asserted rather than proved; the archive's own critique says the two central gaps remain, and the negative-result note kills the determinant-zero mechanism.
5. **Spectral asymptotics are unverified.** The `1.028 N` leading eigenvalue and the `7–11` order suppression are numerical observations, not theorems; the determinant does not vanish at the zeros.

## Provenance

- [`archive/maths/ghd-correlation-kernel/overview.html`](../../archive/maths/ghd-correlation-kernel/overview.html) — source landing page (item 25).
- [`archive/maths/ghd-correlation-kernel/closed-form-kernel.html`](../../archive/maths/ghd-correlation-kernel/closed-form-kernel.html), [`off-diagonal-kernel-formula.html`](../../archive/maths/ghd-correlation-kernel/off-diagonal-kernel-formula.html), [`correlation-kernel.html`](../../archive/maths/ghd-correlation-kernel/correlation-kernel.html) — kernel definitions and claimed closed forms.
- [`archive/maths/ghd-correlation-kernel/vanishing_result.md`](../../archive/maths/ghd-correlation-kernel/vanishing_result.md) — archived negative result and exact true-kernel values.
- [`archive/maths/ghd-correlation-kernel/critique.html`](../../archive/maths/ghd-correlation-kernel/critique.html) — documented GRH gaps.
- [`scraps.html`](../../scraps.html) — inventory entry 25.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
