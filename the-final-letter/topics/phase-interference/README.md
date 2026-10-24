# Phase interference — research programme

**Status:** reconstructed finite kernel and phase core; **duplicate and compressed** relative to the GHD programme. The source's generalised Riemann hypothesis claim is an *archived claim*, not a theorem of this reconstruction.
**Inventory:** [Scraps](../../scraps.html) item 28 · [Topic index](../README.md)
**Source:** [`archive/maths/phase-interference/proof.md`](../../archive/maths/phase-interference/proof.md) (Victor Geere, May 2026, self-labelled “COMPLETE & RIGOROUS”).
**Primary topics:** [greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) (inventory item 11) and [GHD correlation kernel](../ghd-correlation-kernel/README.md) (inventory item 25). This folder does not supersede either: it reconstructs only the finite kernel/phase fragment that is genuinely present in the source.

## Provenance and status

The archived note is a short proof draft (132 lines, 15 sections, most sections empty) for the greedy harmonic decomposition (GHD) and its correlation kernel, “rebuilt around phase interference”. It explicitly retracts earlier errors — a false global indicator `δ_n(θ) = 1_{[α_n, π]}(θ)` and “invalid closed-form kernel formulas” — and replaces them with the true recursive selection rule. That correction is the useful mathematical content, and it is what this folder reconstructs.

The note is also a **compressed duplicate**: it reuses the definitions, supports, and kernel of the GHD corpus, and its only new material is the phase-weighted operator of Definition 2.6 and the claimed spectral argument of §12–§13. The spectral argument is not a proof: the determinant identity, the trace-norm bounds, the monotonicity of the determinant argument, and the deformation are all asserted rather than derived. Its conclusion — GRH — is therefore recorded below as an archived claim and is **not** promoted to a theorem.

## Reconstructed objects

Notation follows Definitions 2.1–2.6 of the source. We write `x = θ/π ∈ [0,1]` for the rescaled angle.

| Object | Definition |
|---|---|
| Harmonic step | `α_n = π/(n+2)` |
| True greedy selector | `δ_n(θ) = 1` iff the remainder `θ_n ≥ α_n`; `θ_{n+1} = θ_n − δ_n α_n`, `θ_0 = θ` |
| Accumulated angle | `Φ_n(θ) = Σ_{k<n} δ_k(θ) α_k` |
| Centred function | `φ_n(θ) = δ_n(θ) − θ/π` |
| Correlation kernel | `K(n,m) = ∫_0^π φ_n(θ) φ_m(θ) dθ` |
| Critical-line phase | `w_n(t) = (n+2)^{−it} = exp(−i t log(n+2))` |
| Weighted entry | `M_{n,m}(1/2+it) = K(n,m) w_n(t) w_m(t)` (Definition 2.6) |
| Two-term amplitude | `|w_n(t) + w_m(t)|` |

Because `φ_n ∈ L²[0,π]`, the finite matrix `K` is a Gram matrix and is positive semidefinite; because `φ_n` is real, `K` is symmetric. These are structural facts, not new source claims.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `‖w_n(t)‖ = 1`: every critical-line phase has unit modulus. | `PhaseInterference.phase_norm` |
| T2 | Theorem | `w_n(0) = 1`: the trivial height carries no phase. | `PhaseInterference.phase_zero` |
| T3 | Theorem | `conj (w_n(t)) = w_n(−t)`: time reversal conjugates the phase. | `PhaseInterference.phase_conj` |
| T4 | Theorem | `M_{n,m}(t) = M_{m,n}(t)`: the weighted entry is complex symmetric. | `PhaseInterference.weighted_comm` |
| T5 | Theorem | `conj (M_{n,m}(t)) = M_{n,m}(−t)`. | `PhaseInterference.weighted_conj` |
| T6 | Theorem | `‖M_{n,m}(t)‖ = |K(n,m)|`: weighting does not change the kernel magnitude. | `PhaseInterference.weighted_norm` |
| T7 | Theorem | `‖w_n(t) + w_m(t)‖ ≤ 2`: the two-term interference never exceeds constructive alignment. | `PhaseInterference.phase_add_norm_le` |
| C1 | Computation | The recursive supports `δ_0, δ_1, δ_2` are exactly the fragmented supports of source §3. | `test_alpha_and_support_edge_cases` |
| C2 | Computation | The source's §4 kernel values `K(0,0)=π/12`, `K(1,1)=2π/9`, `K(0,1)=−7π/72`, `K(2,2)=23π/72`, `K(1,2)=π/48` are exact for the true recursion. | `test_source_kernel_values_exact` |
| C3 | Computation | The `4×4` kernel matrix is exactly symmetric and positive semidefinite. | `test_kernel_matrix_symmetric_and_psd` |
| C4 | Computation | `w_n(0)=1` and `w_n(t) conj(w_n(t))=1` for the concrete phase. | `test_phase_unit_modulus_and_trivial_phase` |
| C5 | Computation | Weighted entries are complex symmetric and conjugate under `t ↦ −t`. | `test_weighted_complex_symmetry_and_time_reversal` |
| C6 | Computation | At `t = π/log(3/2)` the phases `w_0, w_1` cancel exactly; at `t=0` they add to `2`. | `test_destructive_and_constructive_interference` |
| C7 | Computation | Boundary cases `θ=π`, `θ=π/2`, `θ=0` follow the recursion, and invalid indices are rejected. | `test_centred_function_and_greedy_digits`, `test_alpha_and_support_edge_cases` |

The exact kernel values are a genuine check on the source: they are **correct** under the retracted-and-replaced recursive definition, even though the source's own surrounding spectral argument is not proved. In particular the diagonal value at `n=1` is `2π/9`, not the value `π/9` that the old single-interval closed form would give — the fragmentation matters.

## Source claims (preserved, not promoted)

| Claim | Source status | Reconstruction note |
|---|---|---|
| “Status: COMPLETE & RIGOROUS”; the note proves GRH. | **Archived claim** | Not proved. The note has no complete derivation; §13 asserts the five steps. GRH remains open in mathematics. |
| Phase interference forces `det(I − M_χ(1/2+it)) = 0` exactly when `L(1/2+it,χ)=0`. | **Archived claim** | Not formalised. Only the finite two-term cancellation and the bound T7 are established here. |
| Operator closeness bound `‖M_χ − L_{s,χ}‖_tr ≤ 2.92 q^{1/2} log(2+|t|)/(1+|t|^{0.6})`. | **Archived claim** | The constant `2.92` is unexplained and no proof is supplied. |
| Error control `|E| ≤ 3.68 q^{1/2} log(2+|s|)/(1+|t|^{0.6})`, and `|E| ≤ 0.37` for `|t|<10`. | **Archived claim** | Same gap; the constants are numerical assertions. |
| `d/dt arg det(I − M_χ(1/2+it)) ≥ 0`. | **Archived claim** | The “phase-driven interference” is not shown to imply monotonicity. |
| Continuous deformation: zeros cannot cross `Re(s)=1/2`. | **Archived claim** | Requires a topology and a zero-counting argument that the note does not give. |
| The true recursive `δ_n` replaces the false global indicator. | **Source correction** | Adopted. Verified exactly for `n ≤ 2` (C1) and for the kernel values (C2). |
| Closed-form kernel formulas of the earlier drafts. | **Withdrawn by the source** | Not used here. The reconstruction integrates the true piecewise supports instead. |

## Open items and known gaps

1. **The spectral argument is absent.** No formal statement of `M_χ`, the Fredholm determinant, or the determinant–zero equivalence is given that could be checked. This folder deliberately stops at the finite kernel and phase algebra.
2. **The GRH conclusion is not a theorem.** It is recorded as an archived claim. Nothing in this folder supports it beyond the elementary finite identities.
3. **The kernel is not formalised in Lean.** The finite support recursion and the exact integrals live in the Python layer. A Lean treatment would need a formal piecewise indicator, interval integration, and a Gram/PSD argument.
4. **The interference is only two-term here.** The source speaks of “massive destructive interference across the entire matrix”; the reconstruction verifies exact two-term cancellation at `t = π/log(3/2)` and the general bound `≤ 2`, not a matrix-level cancellation theorem.
5. **Duplication.** The GHD definitions, supports, and kernel belong to the [primary GHD topic](../greedy-harmonic-decomposition/README.md); this folder should be read as a finite phase-weighted fragment of it, not as an independent programme.

## Python layer

[`python/programme.py`](python/programme.py) implements the exact finite layer:

- `alpha(n)`; `greedy_intervals(n_max)` — the true recursive supports in units of `π`;
- `greedy_digits(theta, n_max)`, `centred(n, theta)` — exact recursive selections and `φ_n`;
- `kernel(n,m)`, `kernel_scaled(n,m)`, `kernel_matrix(n_max)` — exact piecewise integration;
- `is_positive_semidefinite(matrix)` — exact leading-minor test;
- `phase(n,t)`, `weighted(K,n,m,t)`, `destructive_height(n,m)`, `interference_modulus(n,m,t)`.

Results are cached, and the kernel is integrated on the rational rescaled variable `x=θ/π`, so the suite is exact and fast.

```bash
cd the-final-letter/topics/phase-interference
python3 -m pytest -q tests
```

Recorded result: **7 passed**, well under the 20 s budget.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `PhaseInterference.phase` and `PhaseInterference.weighted` and proves T1–T7. It imports Mathlib, uses no `sorry`/`axiom`/`admit`, and contains only elementary norm, conjugation, and ring facts. See [`lean/README.md`](lean/README.md) for what is and is not formalised.

```bash
cd the-final-letter/topics/phase-interference
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

## Provenance

- [`archive/maths/phase-interference/proof.md`](../../archive/maths/phase-interference/proof.md) — the archived source.
- [Greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) — primary topic for Definitions 2.1–2.5.
- [GHD correlation kernel](../ghd-correlation-kernel/README.md) — primary corpus for the kernel and the claimed GRH pathway.
- [`scraps.html`](../../scraps.html) — inventory item 28.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
