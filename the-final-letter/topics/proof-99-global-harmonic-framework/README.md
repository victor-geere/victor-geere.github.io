# Proof-99 / Global Harmonic Framework — research programme

**Status:** archived claim, reconstructed finite formal core. The source claims a proof of the Riemann Hypothesis; this folder does **not** treat that claim as proved.  
**Source:** [`archive/maths/proof-99/paper.md`](../../archive/maths/proof-99/paper.md) (901 lines, synthesising `proof-99.html`, `proof-99-plain.html`, `proof-99-ghf.html`, `proof-99-hardy.html`, `proof-99-mono.html`, `proof-99-addn.html`, `proof-99-app-1.html`).  
**Inventory:** [Scraps](../../scraps.html) item 29 · [Topic index](../README.md).

## Provenance and status

The archived paper is a Version 2.0 synthesis attributed to the “GHF Consortium” (May 2026) and carries the DOI-like string `10.5281/zenodo.1234567`, which has the shape of a placeholder rather than a verifiable record. It is an **archived claim**: the paper itself closes by saying that RH has not been accepted as proved and that the argument awaits peer review and independent verification of the Mayer–Ruelle similarity construction. The inventory note records that the topic overlaps items 14 and 26 (Hilbert–Pólya material).

This reconstruction reads the source literally, extracts the finite spectral and algebraic bookkeeping that the source actually defines, and formalises that part. It does not attempt to reproduce or validate the global proof. In particular, the claimed derivation of RH is recorded as a **Source claim**, never as a theorem.

## What the source constructs

The Global Harmonic Framework (GHF) is an operator-theoretic attempt to connect ζ(s) to the Gauss map and the Mayer–Ruelle transfer operator. The finite objects are:

| Object | Definition |
|---|---|
| First coefficient sequence | `a n = 1 / sqrt(n(n+1))`, `n ≥ 1` |
| Second coefficient sequence | `b n = 1 / (n+1)`, `n ≥ 1` |
| GHD correlation kernel | `K = I + |a⟩⟨b|`, i.e. `K u = u + a · Σ bₘ uₘ` |
| Diagonal weighting | `D(s) = diag((n+2)^(−(s+1/2)))` |
| Weighted Gram operator | `M(s) = D(s) K D(s)` |
| Critical-line family | `M_t = M(1/2 + it)`, `t ∈ ℝ` |
| Similarity target | `𝓛_s f(x) = Σ_{n≥1} (x+n)^(−2s) f(1/(x+n))` |
| Claimed determinant | `det(I − M(s)) = ζ(s)/ζ(2s) · e^{P(s)}` |
| Mismatch function | `A_J(t) = −d/dt arg F_reg(t)` |
| Counting functions | `N₀(T)` critical-line zeros, `N(T)` all non-trivial zeros |

The source’s chain is: define `K` and `M(s)`; prove `M(s)` trace-class for `Re(s) > 1/2`; claim `M(s)` is unitarily equivalent to `𝓛_s`; invoke the classical determinant formula; restrict to the critical line; identify the spectral shift with `A_J`; compute `∫ A_J` two ways; conclude `N₀(T) = N(T)`; infer RH.

Only the first step — the finite coefficient and determinant algebra — is reconstructed here.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is checked in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `0 < a n` for `n ≥ 1` | `GHF.a_pos` |
| T2 | Theorem | `0 < b n` for every `n` | `GHF.b_pos` |
| T3 | Theorem | `b n < a n` for `n ≥ 1`; the two sequences are distinct | `GHF.b_lt_a` |
| T4 | Theorem | `Σ_{k=1}^{N} 1/(k(k+1)) = N/(N+1)`; the source’s `Σ |a n|² = 1` at finite truncation | `GHF.telescoping` |
| T5 | Theorem | that sum tends to `1` as `N → ∞`; `Σ |a n|² = 1` | `GHF.telescoping_tendsto` |
| T6 | Theorem | the finite rank-one determinant lemma: `det(I + |a⟩⟨b|) = 1 + Σ bᵢ aᵢ` | `GHF.det_rank_one` |
| T7 | Theorem | if `D = diag(d)` with `dᵢ > 0`, then `det(D · D) = Π dᵢ² > 0` | `GHF.det_diagonal_sq_pos` |
| C1 | Computation | `Σ_{n=1}^{N} aₙ² = N/(N+1)` exactly for `N ≤ 40` | `test_telescoping_partial_sum_exact` |
| C2 | Computation | `Σ_{n=1}^{N} bₙ² = H_{N+1}^{(2)} − 1` exactly for `N ≤ 10` | `test_b_squared_partial_matches_harmonic` |
| C3 | Computation | `det(I + |a⟩⟨b|) = 1 + ⟨b,a⟩` exactly for `N = 1,2,3` | `test_rank_one_determinant_matches_lemma` |
| C4 | Computation | `det(D K D) = Π dₙ² · (1 + Σ aₙbₙ)` exactly for `s = 1/2` and `s = 1`, `N ≤ 2` | `test_weighted_gram_determinant_critical_line` |
| C5 | Computation | `|(n+2)^(−(1+it))| = 1/(n+2)` to `10⁻³⁰` for several `n, t` | `test_critical_line_modulus` |
| C6 | Computation | the canonical kernel’s asymmetry defect equals `a₁b₂ − a₂b₁ > 0` (a source erratum) | `test_canonical_kernel_is_not_symmetric` |

## Source claims (not promoted to theorems)

These are recorded with the source’s own status. None is treated as proved in this folder.

| Claim | Source status | Reconstruction note |
|---|---|---|
| **RH**: every non-trivial zero has `Re(ρ) = 1/2` | Archived claim (the paper says RH is “not accepted as proved by the broader mathematical community”) | Not formalised and not asserted. The conclusion rests on the unconditional equality `N₀(T) = N(T)`, which is exactly what is at issue. |
| Trace-class property of `M(s)` for `Re(s) > 1/2` | “Proved in full”, Section 4.5 | Elementary estimate; not formalised here (infinite-dimensional trace class is outside this finite core). |
| Mayer–Ruelle similarity `U M(s) U* = 𝓛_s` | Claimed in Section 6; the source concedes the appendix reaches the matrix form only “up to a diagonal trace-class correction” | **Not established.** The appendix reference (Technical Report Eqs. 4.3.17–4.3.29) is not in the repository. |
| `det(I − 𝓛_s) = ζ(s)/ζ(2s) e^{Q(s)}` | External classical result (Mayer 1991, Pollicott 1993, Rugh 1996) | Cited, not formalised. |
| `M̃_t = D̃ K D̃` is self-adjoint because `K` is symmetric | Source claim, Sections 8.2–8.3 | **False for the `K` actually defined.** With `K = I + |a⟩⟨b|` and `a ≠ b`, the kernel is not symmetric: `K₁₂ − K₂₁ = a₁b₂ − a₂b₁ ≠ 0` (computed exactly as C6). The similarity kernel displayed in Section 6.3 is symmetric, but it is not the same operator as Definition 2.1. |
| `M_t` is `J`-self-adjoint: `M_t* = J M_t J` | Source claim, Section 8.2 | Follows from the diagonal form of `D`; not formalised. It does not repair the non-symmetry of `K`. |
| Birman–Krein identification `A_J(t) = ξ(t)` | Source claim, Lemma 5.2 | Conditional on the similarity and self-adjointness claims; not formalised. |
| Local expansion `A_J(t) = −m/(t−γ) + H(t)` at a zero of multiplicity `m` | “Proved in full”, Section 11.1 | Plausible contour calculation, but depends on the determinant identity and the regularisation; not formalised. |
| `∫₀ᵀ A_J = πN₀(T) + O(log T)` and `= πN(T) + O(log T)` | Source lemmas 7.1–7.2, with sketches | The `O(log T)` error bookkeeping in Section 13 is a sketch; the two identities are not independent estimates of the same integral in the form stated. |
| `N₀(T) = N(T)` for all `T` from an integer plus an `O(log T)` bound | Source Theorem 7.3 | The stated argument compares a bound that grows with `T` against a single integer difference; as written it does not give equality for every fixed `T`. Recorded as an archived claim, not a theorem. |
| Hardy Z reformulation | Source says it is a reformulation, not an independent proof (Section 15.3) | Not formalised. |
| Hilbert–Pólya eigenvalue identification | Source explicitly says it is **not established** (Section 17.3) | Open. |

## Open items and gaps

1. **Is there a genuinely symmetric finite kernel?** The source needs `K` symmetric for the self-adjoint reduction. The natural repair is `K_sym = I + ½(|a⟩⟨b| + |b⟩⟨a|)`, but no source document analyses this operator. This is the first concrete open question.
2. **Does the similarity theorem hold?** No complete proof of `U M(s) U* = 𝓛_s` exists in the repository, and the source itself reduces the claim to a citation of an unavailable technical report.
3. **Can `N₀(T) = N(T)` be derived from the stated asymptotics?** A uniform error term (not merely `O(log T)` along a sequence) is needed to control an integer-valued difference. As stated, the implication is not valid.
4. **What is the precise relation between the GHF kernel and the Mayer–Ruelle operator?** Even granting the determinant identity, the source does not identify the spectra.
5. **Hilbert–Pólya.** The source’s own Section 17.3 lists the eigenvalue identification as unproved.

## Python layer

[`python/programme.py`](python/programme.py) implements the finite objects exactly:

- `a(n)`, `b(n)`, `a_squared(n)`, `b_squared(n)`;
- `telescoping_partial(N)`, `b_squared_partial(N)`;
- `rank_one_kernel(N)`, `rank_one_det(N)`, `rank_one_det_formula(N)`;
- `weighted_diagonal(N, s)`, `weighted_gram(N, s)`, `weighted_gram_det(N, s)`, `weighted_gram_det_formula(N, s)`;
- `critical_line_modulus(n, t)`, `symmetry_defect(N)`.

The weighted determinant identity implemented is

```
det(D K D) = (Πₙ dₙ²) · (1 + Σₙ aₙ bₙ),      dₙ = (n+2)^(−(s+1/2)),
```

which is the finite matrix determinant lemma applied to `M(s) = D² + (Da)(bᵀD)`. The correction term is independent of `s` because the weights cancel in `bᵀ D⁻² D a`.

Run the tests from the repository root:

```bash
python3 -m pytest the-final-letter/topics/proof-99-global-harmonic-framework/tests -q
```

Current result: **7 passed** (well under the 20 s budget). The suite includes edge cases (`N = 0`, invalid indices) and a test that records the non-symmetry erratum.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the `GHF` namespace, defines `a` and `b`, and proves T1–T7. Run:

```bash
the-final-letter/topics/proof-99-global-harmonic-framework/lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

What is **not** formalised: infinite-dimensional trace class, the Fredholm determinant, the Mayer–Ruelle operator, the similarity theorem, `ζ`, the Birman–Krein formula, the argument principle, and every step of the claimed RH proof. See [`lean/README.md`](lean/README.md).

## Provenance

- Source paper: [`archive/maths/proof-99/paper.md`](../../archive/maths/proof-99/paper.md).
- Related archived files: `proof-99.html`, `proof-99-plain.html`, `proof-99-ghf.html`, `proof-99-hardy.html`, `proof-99-mono.html`, `proof-99-addn.html`, `proof-99-app-1.html` in the same directory.
- [`scraps.html`](../../scraps.html) — inventory entry 29.
- [`topics/README.md`](../README.md) — all topic folders.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
