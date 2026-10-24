# Harmonic–categorical Hilbert–Pólya — research programme

**Status:** archived RH proof claim; finite operator core reconstructed; global proof and RH **not** formalised.  
**Inventory:** [Scraps](../../scraps.html) item 14 · [Topic index](../README.md).  
**Source:** [`archive/maths/rh/research/harmonic-categorical-hilbert-polya/rh-proof.md`](../../archive/maths/rh/research/harmonic-categorical-hilbert-polya/rh-proof.md) ([TeX](../../archive/maths/rh/research/harmonic-categorical-hilbert-polya/rh-proof.tex), [PDF](../../archive/maths/rh/research/harmonic-categorical-hilbert-polya/rh-proof.pdf)).

## Provenance and status

The archived manuscript is titled *“A Rigorous Proof of the Riemann Hypothesis via the Harmonic–Categorical Hilbert–Pólya Operator”* (V. Geere et al., dated 2026). It claims a complete proof of RH by combining:

1. a greedy harmonic expansion of the sine function and a transfer operator on the Hardy space;
2. finite-dimensional Hermitian truncations `H_k`;
3. an eigenvalue–determinant correspondence for `H_k` and `Δ_k(t) = det(I − A_k(t))`;
4. a Fredholm determinant identity for the full transfer operator;
5. uniform convergence of truncated determinants and a Hurwitz argument.

The folder is an **archived claim**, not an accepted result. The archive also contains build artefacts (`aux`, `fls`, `log`, `out`, `synctex`, `toc`) and a `geo/` folder; the manuscript itself is 195 lines and several of its key steps cite companion papers that are not present in the archive. The topic overlaps inventory item 17 (Harmonic Sine Transform) and item 26 (greedy-harmonic Hilbert–Pólya); it must not be merged with those as if it were an independent confirmation.

**What this reconstruction does.** It extracts the finite operator/spectral algebra that the manuscript actually writes down and proves a small, genuine core of it in Lean 4/Mathlib. It does not formalise the infinite transfer operator, the Fredholm determinant, the Hurwitz limit, or RH. The global proof is left in the archive with its status intact.

## What the source claims

The manuscript asserts, in its own numbering:

- **Lemma 4.1** — the eigenvalues of the Hermitian matrix `H_k` coincide, with multiplicity, with the real zeros of `Δ_k(t) = det(I − A_k(t))`.
- **Theorem 5.1** — the full transfer operator `L_s` is trace class for `Re s > 1` and
  `det(I − L_s) = ζ(s)/ζ(2s) · e^{P(s)}`, with `P` entire, extending to a regularised determinant for `Re s > 1/2`.
- **Proposition 6.1** — `Δ_k → Δ` uniformly on compact subsets of `ℝ`.
- **§7 / Theorem 7.1** — every zero of `Δ` is real, hence every non-trivial zero of `ζ` lies on `Re s = 1/2` (RH).

These are recorded below as **Source claim** rows. None is promoted to a theorem of this reconstruction.

### Known gaps in the source argument

These are mathematical observations, not formalisations:

1. **Category mismatch in Lemma 4.1.** `H_k` is defined at `t = 0` as `i d/dt log U_k(t)|_{t=0}`; its eigenvalues are fixed real numbers. The zeros of `Δ_k(t)` are values of the parameter `t`. Identifying the two sets requires a specific spectral-flow construction that the manuscript sketches by reference to an absent “supplementary note [3]”.
2. **The polar decomposition step.** `A_k(t)` is not assumed invertible; a polar decomposition generally gives a partial isometry, not a unitary `U_k(t)`. The branch of `log U_k` and its differentiability are asserted, not proved.
3. **The determinant identity.** Theorem 5.1 is a source claim whose proof is a sketch and whose detailed arguments are delegated to companion papers [6,7] that are not in the archive. In particular the entire factor `e^{P(s)}` and its zero-free property are not constructed.
4. **Uniform convergence.** Proposition 6.1 relies on Hilbert–Schmidt estimates in an absent companion paper [9]; no explicit truncation bound is given.
5. **The Hurwitz passage.** Even granting real zeros for each `Δ_k`, Hurwitz’s theorem transfers zeros of a locally uniform limit. The manuscript uses this to conclude that *all* zeros of `Δ` are real, but its displayed argument only controls limits of the real zero sets `Z_k`; complex zeros of `Δ` are not excluded by that step.
6. **The final implication.** The step from “zeros of `Δ` are real” to “all non-trivial zeros of `ζ` have real part `1/2`” depends on the unproved identity (6) and on the cancellation of the `ζ(1+2it)` pole.

## Reconstructed objects and notation

The reconstruction works with a finite `j`-series truncation and a real transfer parameter. The source's structural identities (triangularity, constant diagonal, determinant) are algebraic and do not depend on the field; the Python layer also evaluates the complex critical-line parameter `s = 1/2 + it`.

| Object | Definition |
|---|---|
| Truncation index | `k ∈ ℕ`, truncation dimension `d_k = k + 1` |
| Transfer parameter | `s ∈ ℝ` in Lean; `s ∈ ℂ` in the Python critical-line check |
| `j`-series truncation | `N ∈ ℕ`, sum over `j = 0, …, N−1` |
| Truncated weight | `c_{s,r}(N) = Σ_{j=0}^{N−1} (j+1)/(j+2)^{s+1+r}` |
| Matrix entry | `A_k(s,N)_{m,n} = binom(n,m) · c_{s,n−m}(N)` for `m ≤ n`, and `0` for `m > n` |
| Truncated operator | `A_k(s,N)`, a `(k+1) × (k+1)` real matrix |
| Finite determinant | `Δ_k(s,N) = det(I − A_k(s,N))` |
| Hermitian discriminant | `disc₂(a,b,d) = (a−d)² + 4b²` for `[[a,b],[b,d]]` |
| Source Hamiltonian | `H_k = i d/dt log U_k(t)|_{t=0}` — **not defined here** |

The Lean development uses the names `HCHP.weight`, `HCHP.entry`, `HCHP.A`, `HCHP.disc2`.

## Theorem ledger

Every **Theorem** row is proved in [`lean/Topic.lean`](lean/Topic.lean) with no `sorry`, `axiom`, or `admit`. Every **Computation** row is covered by [`tests/test_programme.py`](tests/test_programme.py). Source claims and open items are not theorems.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The truncated weight is positive: `0 < c_{s,r}(N)` for `N > 0`. | `HCHP.weight_pos` |
| T2 | Theorem | Entries strictly below the diagonal vanish: `n < m → A_k(s,N)_{m,n} = 0`. | `HCHP.entry_eq_zero_of_lt` |
| T3 | Theorem | The truncation `A_k(s,N)` is upper triangular. | `HCHP.A_upperTriangular` |
| T4 | Theorem | Every diagonal entry of `A_k` is the same weight `c_{s,0}(N)`. | `HCHP.A_diag` |
| T5 | Theorem | Finite determinant identity: `det A_k = c_{s,0}(N)^{k+1}`. | `HCHP.det_A` |
| T6 | Theorem | Finite determinant of Lemma 4.1: `det(I − A_k) = (1 − c_{s,0}(N))^{k+1}`. | `HCHP.det_one_sub_A` |
| T7 | Theorem | The characteristic polynomial of a real symmetric `2 × 2` matrix splits over `ℝ` into real roots `(a+d ± √disc₂)/2`. | `HCHP.hermitian2_charpoly_splits` |
| C1 | Computation | Exact truncated weights, including the empty sum `N = 0`. | `test_weight_exact_values_and_empty_sum` |
| C2 | Computation | `entry` reproduces source equation (2), and is exactly zero below the diagonal. | `test_entry_matches_source_formula_and_below_diagonal` |
| C3 | Computation | `A_k` is upper triangular, has constant diagonal, and `tr A_k = (k+1)c`. | `test_matrix_A_upper_triangular_and_constant_diagonal` |
| C4 | Computation | `det A_k = c^{k+1}` and `det(I − A_k) = (1 − c)^{k+1}` for exact rational `s`. | `test_det_A_and_det_one_minus_A_closed_forms` |
| C5 | Computation | A real symmetric `2 × 2` matrix has non-negative discriminant and real roots with `tr = a+d`, `det = ad − b²`. | `test_symmetric_2x2_real_spectrum` |
| C6 | Computation | The critical-line parameter `s = 1/2 + it` preserves triangularity, constant diagonal, and the trace formula. | `test_source_critical_line_parameter` |
| C7 | Computation | Edge cases: `N = 0` gives the zero matrix and `det(I) = 1`; `k = 0` gives a scalar; invalid indices raise. | `test_edge_cases_and_invalid_inputs` |

“All theorems are proved” means every Theorem row has a corresponding Lean declaration and every Computation row has a pytest test. It does **not** mean the source's RH claim is proved.

## Source claims (not promoted)

| # | Kind | Claim | Archived status | Reconstruction note |
|---|---|---|---|---|
| S1 | Source claim | Lemma 4.1: eigenvalues of `H_k` = real zeros of `Δ_k`, with multiplicity. | Archived claim; proof sketch. | Not formalised. The finite determinant `Δ_k` is computed (T6), but `H_k` and the spectral-flow correspondence are not defined. |
| S2 | Source claim | Theorem 5.1: `det(I − L_s) = ζ(s)/ζ(2s) e^{P(s)}` and its regularised extension. | Archived claim; companion papers absent. | Not formalised. No trace-class operator, Fredholm determinant, or entire factor is constructed here. |
| S3 | Source claim | Proposition 6.1: `Δ_k → Δ` uniformly on compact sets. | Archived claim; error estimates absent. | Not formalised. The finite determinants are exact, but no convergence statement is proved. |
| S4 | Source claim | `H_k` is Hermitian because `U_k(t)` is unitary and `H_k = i d/dt log U_k`. | Archived claim; sketch. | Only the `2 × 2` real-symmetric spectral fact (T7) is formalised. Differentiable polar decomposition and the logarithm branch are missing. |
| S5 | Source claim | §7: all zeros of `Δ` are real, hence all zeros of `ζ` lie on the critical line. | Archived claim; argument has the gap noted above. | Not formalised. RH is **not** asserted as a theorem anywhere in this folder. |
| S6 | Source claim | Theorem 7.1: the Riemann Hypothesis. | Archived claim, **withdrawn from promotion**. | Kept only as the source's headline claim. The global proof and RH remain archived. |
| S7 | Source claim | `L_s` is trace class for `Re s > 1`, Hilbert–Schmidt for `Re s > 1/2`; the family extends meromorphically. | Archived claim. | Not formalised; the finite truncations are all that is computed. |

## Open items and conjectures

| # | Kind | Statement |
|---|---|---|
| O1 | Open / conjecture | Give a precise spectral-flow theorem relating eigenvalues of a finite Hermitian `H_k` to zeros of `Δ_k(t)`, with a correct multiplicity statement and without assuming invertibility of `A_k(t)`. |
| O2 | Open / conjecture | Construct the full transfer operator `L_s` on `H²(𝔻)` and prove the Fredholm determinant identity of source Theorem 5.1, including the entire factor and its zero-free property in the critical strip. |
| O3 | Open / conjecture | Prove uniform Hilbert–Schmidt convergence `‖A_k(t) − L_{1/2+it}‖_{S₂} → 0` on compact `t`-intervals with explicit error bounds. |
| O4 | Open / conjecture | Repair the Hurwitz argument so that it controls all complex zeros of the limit `Δ`, not only limits of the real sets `Z_k`. |
| O5 | Open / conjecture | Establish the differentiability of `t ↦ U_k(t)`, the existence of a continuous branch of `log U_k`, and hence the Hermitian nature of `H_k`. |
| O6 | Open / conjecture | Prove the analytic continuation and regularised determinant theory needed to pass from `Re s > 1` to the critical line. |
| O7 | Open / conjecture | The Riemann Hypothesis itself. The archived manuscript claims it; this reconstruction does not. |

## Python layer and how to run it

[`python/programme.py`](python/programme.py) is an exact `sympy` layer with no import side effects. It provides:

- `weight(s, r, N)`, `entry(s, N, m, n)`, `matrix_A(s, N, k)`;
- `is_upper_triangular`, `diag_constant`, `det_A`, `det_one_minus_A`;
- `discriminant_2x2`, `charpoly_2x2`, `eigenvalues_2x2`, `realise_symmetric_2x2`.

All arithmetic is exact rational/algebraic (`sympy`); no numerical tolerance is used. The critical-line check uses the exact complex parameter `s = 1/2 + i/3`. `mpmath` is not needed.

```bash
cd the-final-letter/topics/harmonic-categorical-hilbert-polya
python3 -m pytest -q tests
```

Recorded result: **7 passed** (about 10 s on the development machine).

## Lean layer and how to run it

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib, opens the namespace `HCHP`, and proves T1–T7. It uses a real transfer parameter and a finite `j`-series truncation; the complex analytic statements of the source are deliberately outside its scope.

```bash
cd the-final-letter/topics/harmonic-categorical-hilbert-polya
./lean/check.sh
```

The script delegates to [`../tools/check-lean.sh`](../tools/check-lean.sh), which uses the local Mathlib installation at `~/lean/mathlib4` (Lean `v4.35.0-rc2`). The recorded build is [`lean/BUILD.log`](lean/BUILD.log).

What is **not** formalised: the operator `L_s`, its trace-class/Fredholm theory, the polar decomposition and logarithm, the Hamiltonian `H_k`, uniform convergence, Hurwitz’s theorem, and RH. See [`lean/README.md`](lean/README.md) for the precise boundary.

## Relation to the rest of the programme

- [Scraps inventory](../../scraps.html) — item 14 (archived claim), with overlaps at items 17 and 26.
- [Topic index](../README.md) — all reconstructed topics.
- [Greedy harmonic decomposition](../greedy-harmonic-decomposition/README.md) — the finite greedy/angle layer used by the source's §2.
- [The Final Letter](../../index.html).

This folder follows the [programme standard](../PROGRAMME-STANDARD.md): a Theorem is only a Lean-proved statement; a Computation is only a tested exact calculation; an archived claim stays an archived claim.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
