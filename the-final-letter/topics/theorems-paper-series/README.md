# Theorems / paper series — research programme

**Status:** archived claim, reconstructed finite formal core + exact computation
layer. The paper series claims a proof of the Riemann hypothesis; **that claim
is not accepted here.** The finite greedy identities are reconstructed and
proved, and several source theorems are shown to be false by exact
counterexample.

**Source:** [`archive/maths/theorems/paper.md`](../../archive/maths/theorems/paper.md)
(731 lines). The folder also contains `paper1.md`–`paper4.md`,
[`miniproof.md`](../../archive/maths/theorems/miniproof.md) and
`miniproof_parser.py`; only `paper.md` is reconstructed in this folder.

**Inventory:** [Scraps](../../scraps.html) item 32 · [Topic index](../README.md).
**Overlaps:** item 9 ([GDST](../gdst/README.md)), item 24
([GDST twin series](../gdst-twin-series/README.md)) and item 25
([GHD correlation kernel](../ghd-correlation-kernel/README.md)). This folder
does not re-audit those sources; where their formal cores already exist, they
are cross-referenced rather than duplicated.

## What the source is

`paper.md` is a self-contained GDST paper. Its abstract and §3 claim a proof of
the Riemann hypothesis in three stages: a greedy harmonic expansion of
`θ/π`; a transfer operator `L_s` on `H²(𝔻)` with a Fredholm determinant
identity `det(I − L_s) = ζ(s)/ζ(2s)·e^{P(s)}`; and a family of Jacobi matrices
`J_σ` whose spectra are `σ`-independent, making `J_{1/2}` self-adjoint and
forcing every non-trivial zero onto `Re s = 1/2`.

The paper is candid about its own gaps: §5 lists twelve analytic inputs —
trace-class property, similarity to the Mayer operator, the telescoping trace
sum, the determinant identity, the kernel closed form, the Jacobi spectral
theory, the Hausdorff moment problem and `σ`-independence — as tasks "marked
as axioms or `sorry` in the Isabelle formalisation". Those are the load-bearing
steps, so the global RH claim is an **archived claim**, not a theorem.

There are also elementary errors in §1 that the archived status had not caught.
Two of them are fatal to the paper's later sections, and this folder records
them as errata with exact counterexamples rather than silently repairing them.
The salvageable mathematical content is the finite greedy recursion and the
finite selected/rejected split of §2.1; that is what is formalised below.

## Reconstructed objects

Normalise the target to `x = θ/π ∈ [0, 1]`. The harmonic fractions are
`α_n = 1/(n+2)`. The greedy pass over indices `0, …, N−1` is the recursion

```
r_0 = x,      δ_n = 1 iff α_n ≤ r_n,      r_{n+1} = r_n − δ_n α_n.
```

| Object | Definition |
|---|---|
| Harmonic fraction | `α n = 1/(n+2)` |
| Greedy remainder | `run x N = r_N`, after processing `0, …, N−1` |
| Selection word | `δ n = 1` iff `α n ≤ run x n` |
| Selected prefix | `E_N(w) = Σ_{k<N, δ_k=1} w k` |
| Rejected prefix | `Ω_N(w) = Σ_{k<N, δ_k=0} w k` |
| Full prefix | `H_N(w) = Σ_{k<N} w k` |
| GDST weight | `w k = (k+2)^(−s)` on `Re s > 0` |

The exact finite core is:

1. **greedy invariant** `r_N = x − E_N(α)`, i.e. `x = E_N(α) + r_N`
   (the source's equation (1.1));
2. **selected/rejected split** `E_N(w) + Ω_N(w) = H_N(w)` for every weight `w`
   (the finite form of `ζ(s) − 1 = E(θ,s) + Ω(θ,s)`).

Both are proved in Lean for arbitrary `N`; neither needs the infinite series.
The source's digit monotonicity is *not* available, because it is false.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean)
with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** is
tested in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The harmonic fraction is positive: `0 < α n`. | `GDST.alpha_pos` |
| T2 | Theorem | The harmonic fractions strictly decrease: `StrictAnti α`. | `GDST.alpha_strictAnti` |
| T3 | Theorem | Every remainder is at most the target: `run x N ≤ x`. | `GDST.run_le_self` |
| T4 | Theorem | Non-negative targets have non-negative remainders: `0 ≤ x → 0 ≤ run x N`. | `GDST.run_nonneg` |
| T5 | Theorem | Finite greedy invariant: `run x N = x − E_N(α)`. | `GDST.run_eq_sub_selected` |
| T6 | Theorem | Finite selected/rejected split: `E_N(w) + Ω_N(w) = H_N(w)`. | `GDST.selected_add_rejected` |
| T7 | Theorem | The source's `θ = π` example: `run 1 5 = 0` and `E_5(α) = 1 = 1/2 + 1/3 + 1/6`. | `GDST.gdst_pi_example` |
| C1 | Computation | The invariant residual `r_N − (x − E_N(α))` is exactly zero on a rational grid and `N ∈ {0,1,2,5,13,40}`. | `test_greedy_invariant_is_exact` |
| C2 | Computation | `E_N + Ω_N − H_N = 0` for symbolic `s` in `w k = (k+2)^(−s)`, a rational grid, and `N ∈ {0,1,2,6,12}`. | `test_selected_plus_rejected_equals_total` |
| C3 | Computation | `θ = π` selects exactly `{0, 1, 4}` and terminates: `1 = 1/2 + 1/3 + 1/6`. | `test_pi_example_terminates_at_indices_0_1_4` |
| C4 | Computation | `0 ≤ r_N ≤ x`, and the repaired bound `r_N ≤ 1/(N+1)`; the source's strict `r_0 < 1/2` fails at `x = 1`. | `test_remainders_are_nonnegative_and_below_next_fraction` |
| C5 | Computation | Edge cases: `x = 0` rejects everything; `x = 1/2` selects exactly index `0`; `499/1000` rejects index `0`; negative indices and non-rational targets are rejected. | `test_alpha_values_and_invalid_indices`, `test_zero_and_threshold_targets_are_edge_cases` |
| C6 | Computation | The arithmetic step of the source's Theorem 1.6: `(m+1)(m+2) − 1 ≥ m(m−1)` for `2 ≤ m < 200`. | `test_source_growth_arithmetic_step` |
| C7 | Computation | **Refutation:** digit monotonicity (source Theorem 1.7) fails at `n = 1`: `999/2000 < 1/2`, but `δ_1(999/2000) = 1` and `δ_1(1/2) = 0`. | `test_digit_monotonicity_theorem_is_false` |

## Source claims and errata

These are assertions of the archived paper, recorded with their status. None is
a theorem of this reconstruction.

| # | Claim (source label) | Archived status | Reconstruction note |
|---|---|---|---|
| S1 | Greedy harmonic expansion `x = Σ δ_n/(n+2)` (Thm 1.5) | Source theorem, proof sketch | The finite invariant T5 is proved; the limit `r_N → 0` is not formalised. |
| S2 | Super-exponential sparsity `n_{k+1} ≥ n_k(n_k−1)` (Thm 1.6) | Archived claim | The printed proof contains a sign typo (E5), so the sparsity claim is not established by it. Only its arithmetic tail is tested (C6). Not adopted. |
| S3 | Digit monotonicity (Thm 1.7) | **Refuted here** | Exact counterexample C7. The greedy word is not monotone in the target. |
| S4 | Threshold representation `δ_n(θ) = 1[θ ≥ θ_n*]` (Thm 1.9) | **Refuted as stated** | Depends on S3. For `n = 1` the infimum is `1/3`, yet `δ_1(1/2) = 0` although `1/2 ≥ 1/3` (E3). |
| S5 | Closed-form correlation kernel (Thm 1.14) | Archived claim, internally inconsistent | At `n = 0` the stated diagonal `(π/12)(1 − 3/(n+2))` equals `−π/24 < 0`, impossible for a Gram-matrix diagonal; it also disagrees with the diagonal kernel of item 11, `(t³ + (π−t)³)/(3π²) = π/12` at `t = π/2` (E4). |
| S6 | `L_s` is trace-class on `H²(𝔻)` for `Re s > 1/2` (Thm 2.4) | Source claim | Rests on a Mayer–Efrat citation and an unproved similarity; appendix tasks 1.1–1.3, 2.1–2.2. Not formalised. |
| S7 | Meromorphic continuation of `E(θ,s)` with poles at the non-trivial zeros (Thm 2.5) | Source claim | Depends on S6, S8 and the resolvent identity (2.2), which is asserted without proof. |
| S8 | Fredholm determinant identity (Thm 2.7) | Source claim | Appendix task 4.1 lists it as unproved; the perturbation formula in Step 2 is misquoted. |
| S9 | Telescoping trace sum (Thm 2.8) | Source claim | Appendix task 3.1; the periodic-orbit computation and the "Markov-hole" correction are not carried out. |
| S10 | `σ`-independence of the Jacobi spectra (Thm 3.3) | Source claim | The moment comparison does not establish equality of supports; the Stieltjes-transform sentence is not an argument. |
| S11 | **Riemann hypothesis** (Thm 3.4) | **Archived claim** | Not proved in the source: the appendix inputs are open, §1 contains refuted lemmas, and §3.3 Step 4 is a non sequitur (E6). This folder does **not** claim RH, GRH, twin primes, Chowla, Sarnak, or Elliott. |

### Errata with exact evidence

- **E1 — Lemma 1.3 is false as stated.** It claims `r_n < 1/(n+2)` for all
  `n ≥ 0`. At `x = 1`, `r_0 = 1/2`, not `< 1/2`. The correct sharp statement
  after `N` processed indices is `r_N ≤ 1/(N+1)`, with equality only at
  `N = 1, x = 1`; C4 tests the repaired bound.
- **E2 — Theorem 1.7 (digit monotonicity) is false.** `999/2000 < 1/2`, but
  `δ_1(999/2000) = 1` while `δ_1(1/2) = 0`: at `1/2` the first fraction is
  taken, leaving remainder `0`; just below `1/2` the first fraction is skipped,
  so the second one fits. C7 checks this exactly.
- **E3 — Theorem 1.9(2) is false.** `δ_1(x) = 1` on `[1/3, 1/2) ∪ [5/6, 1]`
  (check `δ_1(0.9) = 1`), so the digit set is not the interval `[1/3, π]`
  claimed as an up-set. In particular `δ_1(1/2) = 0` although `1/2 ≥ 1/3`.
- **E4 — Theorem 1.14 is inconsistent.** The stated diagonal formula is
  negative at `n = 0` and disagrees with the direct threshold integral. The
  "proof sketch" defers the computation to a companion paper.
- **E5 — Theorem 1.6's proof contains a sign typo, not an invalid step.** It
  writes `r_m < r_{m−1} − 1/(m+2)` although the algorithm gives equality; the
  intended symbol is `=`. Read literally the line is false, but the repair is
  clerical, and the printed argument still does not establish the claimed lower
  bound on `m'`. The super-exponential claim is left open here, not refuted.
- **E6 — §3.3 Step 4 is a non sequitur.** From `ρ − 1/2 ∈ spec(J_{1/2}) ⊂ ℝ`
  the paper concludes `Im ρ = 0` *or* `Re ρ = 1/2`. An element of `ℝ` has zero
  imaginary part, so the argument yields `Im ρ = 0` (impossible for a
  non-trivial zero only if one already knows the zeros are non-real), not
  `Re ρ = 1/2`.

## Open items and conjectures

| # | Open item | Status |
|---|---|---|
| O1 | Is the selected-index sequence super-exponentially sparse? The source's proof is defective (E5); a correct proof or counterexample is needed. | Open |
| O2 | Describe the digit sets `{x ∈ [0,1] : δ_n(x) = 1}`. They are not up-sets (C7/E3); are they finite unions of intervals, and what is their measure? | Open |
| O3 | Prove convergence of `E(θ,s)` and `Ω(θ,s)` and the infinite identity `E + Ω = ζ(s) − 1` on a half-plane. The finite split T6 is proved; the limit is not. | Open (cf. item 24) |
| O4 | Compute the correct correlation kernel for non-monotone greedy digits and decide its positivity/spectral properties. | Open (cf. items 11, 25) |
| O5 | Construct the transfer operator, prove the similarity and the Fredholm determinant identity. | Open |
| O6 | Decide whether any self-adjoint operator constructed from the GDST has spectrum encoding the non-trivial zeros. | Open (Hilbert–Pólya) |
| O7 | The Riemann hypothesis itself. | Open — the source's claimed proof is archived, not accepted. |

## Python layer

[`python/programme.py`](python/programme.py) is an exact sympy layer with no
numerical tolerances. It implements `alpha`, `alpha_angle`, `run`, `digits`,
`selected_sum`, `rejected_sum`, `total_sum`, `invariant_residual`,
`complement_residual`, `dirichlet_weight`, `pi_example`,
`remainder_bound_holds`, `next_index_lower_bound`,
`projected_next_index_ge_quadratic`, and `monotonicity_counterexample`.

```bash
cd the-final-letter/topics/theorems-paper-series
python3 -m pytest -q tests
```

Current result: **8 passed** in about 2 seconds. The tests use exact rational
arithmetic throughout; the only `ValueError` cases are the explicitly tested
invalid inputs.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) imports Mathlib and works in namespace
`GDST`. It defines `alpha`, `run`, `selectedWeight`, `rejectedWeight` and
`totalWeight` over `ℚ`, and proves T1–T7. The file contains no `sorry`,
`axiom`, or `admit`.

```bash
cd the-final-letter/topics/theorems-paper-series
./lean/check.sh
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log). See
[`lean/README.md`](lean/README.md) for what is and is not formalised.

## Open items and known gaps

1. **No global claim is formalised.** The transfer operator, its trace-class
   property, the Fredholm determinant, the Jacobi matrices, the moment problem
   and the RH conclusion are all far beyond this finite core. The appendix's
   twelve tasks remain open.
2. **The source is not merely incomplete; parts are wrong.** C7 and E1–E6 are
   exact, checkable failures, not gaps in the reconstruction. Any future use of
   the paper's §1.2–§1.3 must replace the monotonicity and threshold lemmas.
3. **The finite split is word-level, not greedy-specific.** T6 holds for every
   binary selection word; the greedy recursion enters T3–T5 and C1–C7. This
   mirrors, but does not duplicate, the twin-series folder (item 24), which
   keeps the arbitrary-word complement as its core.
4. **The companion papers are unaudited.** `paper1.md`–`paper4.md` and the
   MiniProof parser are recorded as provenance only; no claim from them is
   adopted.
5. **Consequence for the inventory.** Item 32 is an archived claim. The
   readable salvage is the finite greedy layer; the RH programme is not
   advanced by this folder.

## Provenance

- Source: [`paper.md`](../../archive/maths/theorems/paper.md); companion
  fragments [`paper1.md`](../../archive/maths/theorems/paper1.md),
  [`paper2.md`](../../archive/maths/theorems/paper2.md),
  [`paper3.md`](../../archive/maths/theorems/paper3.md),
  [`paper4.md`](../../archive/maths/theorems/paper4.md);
  [`miniproof.md`](../../archive/maths/theorems/miniproof.md) and
  [`miniproof_parser.py`](../../archive/maths/theorems/miniproof_parser.py).
- [Scraps inventory](../../scraps.html) item 32; related items 9, 24 and 25.
- [Topic index](../README.md) · [The Final Letter](../../index.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
