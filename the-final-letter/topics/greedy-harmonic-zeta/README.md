# Greedy harmonic zeta — research programme

**Status:** archived claim, reconstructed finite formal core. The source's Riemann-hypothesis reformulation is **not** proved here and is not a theorem of this reconstruction.  
**Source:** [`archive/maths/rh/research/greedy-harmonic-zeta/rh-reformulation.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/rh-reformulation.html), with the companion addendum, eta-critical review, and the v2/v3 provability papers in the same directory.  
**Inventory:** [Scraps](../../scraps.html) item 13 · [Topic index](../README.md).

## Provenance and status

The inventory groups 21 files under `archive/maths/rh/research/greedy-harmonic-zeta/`. The primary document is `rh-reformulation.html`; it defines a greedy condition on the partial sums of the Dirichlet eta function and asserts an equivalence with RH (Theorems 4.1 and 5.1). The companion `rh-reformulation-addendum.html` is explicitly a research roadmap and says that no proof is given. `sine-harmonic-zeta-provability.html`, `sine-harmonic-zeta-v2.html`, and `sine-harmonic-zeta-v3.html` study a related critical-exponent question; v3 advertises "a rigorous proof" of the exponent 1/2.

This folder is a reconstruction, not an endorsement. The archived status is preserved: the RH equivalence, the critical-exponent uniqueness theorem, and the v2 greedy characterisation are **source claims**. The finite eta/Dirichlet identities and the elementary greedy-step inequality are separated out and proved or computed below.

A reading of the source reveals three concrete problems that the reconstruction records rather than repairs:

1. **Sign inconsistency.** Definition 2.1 requires `Re(conj(S_{N-1}) w_N) ≤ 0` for every `N`, where `S_{N-1}` already contains the alternating signs. But at even `N` the alternating series *subtracts* `w_N`. The condition for the alternating sign itself to be greedy is `(-1)^{N-1} Re(conj(S_{N-1}) w_N) ≤ 0`, not the raw inequality. The two conditions differ at even `N`.
2. **The first zero fails both finite readings.** Using the first non-trivial zeta zero `t_1 ≈ 14.1347251417`, the raw condition first fails at `N = 4`, and the sign-corrected alternating condition fails already at `N = 2`. Both facts are exact high-precision computations in [`tests/test_programme.py`](tests/test_programme.py). They do not disprove RH; they show that the source's finite greedy condition is not satisfied by the first zero as written.
3. **The analytic "proof" is circular or unsupported.** Theorem 4.1 Part II uses the absence of zeros for `σ > 1/2`, which is a form of RH, and the appendix replaces estimates by phrases such as "one can show". The v3 paper invokes 2026 zero-density and discorrelation results; even taking those references at face value, the step "for `α > 1/2`, η has no zeros on `Re(s) = α`" assumes the conclusion. No part of this is formalised.

## Reconstructed objects and notation

| Object | Definition |
|---|---|
| Magnitude | `term σ n = (n+1)^(-σ)`, with `n ≥ 0`; in one-based notation `n^{-σ}` |
| Finite zeta sum | `zetaPartial σ N = ∑_{k<N} term σ k = ∑_{n=1}^{N} n^{-σ}` |
| Finite eta sum | `etaPartial σ N = ∑_{k<N} (-1)^k term σ k = ∑_{n=1}^{N} (-1)^{n-1} n^{-σ}` |
| Correlation | `corr S w = Re(conj S · w)` for `S, w ∈ ℂ` |
| Greedy step | `|S + w|² = |S|² + |w|² + 2 corr S w` |
| Raw source condition | `corr (S_{N-1}) w_N ≤ 0` for all `N` |
| Sign-corrected condition | `(-1)^{N-1} corr (S_{N-1}) w_N ≤ 0` for all `N` |
| Finite eta–zeta identity | `etaPartial σ (2m) = zetaPartial σ (2m) − 2·2^(−σ)·zetaPartial σ m` |

The finite identity is the truncation of the classical relation `η(s) = (1 − 2^{1−s}) ζ(s)`; it holds for every `N`, not only even `N`, but the Lean theorem states the even case, which is what the induction proves. At `σ = 0` the ordinary alternating partial sums are `0` for even `N` and `1` for odd `N`; they do not converge. The classical value `η(0) = 1/2` is recovered by Abel summation, `∑_{n≥1} (−1)^{n−1} r^n = r/(1+r) → 1/2`.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean) with no unfinished proof and no extra axiom. Every row marked **Computation** is tested in [`tests/test_programme.py`](tests/test_programme.py). The suite currently reports **9 passed**.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | `0 < (n+1)^(-σ)` for every real `σ` and every `n`. | `GreedyZeta.term_pos` |
| T2 | Theorem | For `σ > 0`, `n ↦ (n+1)^(-σ)` is strictly decreasing. | `GreedyZeta.term_strictAnti` |
| T3 | Theorem | Finite eta–zeta identity: `η_{2m}(σ) = Z_{2m}(σ) − 2·2^(−σ)·Z_m(σ)`. | `GreedyZeta.eta_zeta_even` |
| T4 | Theorem | `η_{2m}(0) = 0` for every `m`. | `GreedyZeta.eta_zero_even` |
| T5 | Theorem | `η_{2m+1}(0) = 1` for every `m`. | `GreedyZeta.eta_zero_odd` |
| T6 | Theorem | Quadratic identity `|S+w|² = |S|² + |w|² + 2 Re(conj S · w)`. | `GreedyZeta.normSq_add_corr` |
| T7 | Theorem | If `Re(conj S · w) ≤ 0`, then adding `w` is closer than subtracting it: `|S+w|² ≤ |S−w|²`. | `GreedyZeta.greedy_closer` |
| C1 | Computation | The finite eta–zeta residual is exactly `0` for `N = 0..12` and `σ ∈ {1/2, 3/5, 2, s}` with `s` symbolic. | `test_finite_eta_zeta_identity_exact` |
| C2 | Computation | `η_N(0) = 0` for even `N` and `1` for odd `N`, `N ≤ 21`. | `test_eta_zero_finite_even_odd` |
| C3 | Computation | Abel summation gives `η(0) = 1/2`, with the exact remainder `(−1)^N r^(N+1)/(1+r)`. | `test_abel_eta_zero_value_and_limit` |
| C4 | Computation | At the first zero, the raw source condition holds at `N = 2` but first fails at `N = 4`. | `test_raw_greedy_condition_fails_at_first_zero` |
| C5 | Computation | At the first zero, the alternating sign is not the greedy sign at `N = 2`; the sign-corrected condition fails there. | `test_alternating_sign_is_not_greedy_at_first_zero` |
| C6 | Computation | Finite scans at `σ = 0.4, 0.6, 0.7` and the first zero ordinate also fail by `N ≤ 10`. | `test_off_critical_line_points_also_fail_finite_scan` |
| C7 | Computation | The mpmath correlation agrees with the sympy exact evaluation to `10^-30` at a shared 40-digit ordinate. | `test_greedy_correlation_matches_sympy` |
| C8 | Computation | Edge cases: `N = 0` sums vanish, negative indices and bad scan parameters raise `ValueError`. | `test_partial_sums_and_edge_cases`, `test_greedy_scan_argument_validation` |

## Source claims (not promoted to theorems)

| Claim | Source status | Reconstruction note |
|---|---|---|
| `η(s) = (1 − 2^{1−s}) ζ(s)` for `Re(s) > 0` | Classical identity quoted by the source | Only the finite truncation T3 is formalised. The analytic continuation and the factor `1 − 2^{1−s}` are not formalised. |
| Theorem 4.1: `η(s) = 0` plus the greedy condition iff `σ = 1/2` and `η(1/2+it) = 0`. | Archived claim; proof sketch only | Not a theorem here. The proof uses the Riemann–Siegel formula, an approximate functional equation, and an appendix of unsupported estimates. The finite computations C4–C6 contradict the natural finite reading at the first zero. |
| Theorem 5.1: RH is equivalent to "every non-trivial zero satisfies the greedy condition". | Archived claim | Not proved and not reproved here. RH remains open. |
| Critical exponent `α = 1/2` is the unique exponent for which the alternating signs can be greedy (v3 claims a rigorous proof). | Archived claim; v3 self-described as rigorous | Not verified. The `α > 1/2` step assumes a zero-free half-plane, which is essentially the conclusion. The cited 2026 results are not independently checked in this folder. |
| v2 Conjecture 3.1: the alternating greedy sign sequence occurs iff `η(1/2+it) = 0`. | Archived conjecture | Not a theorem. The finite computation C5 shows that, with the alternating sign included, the first zero fails at `N = 2`; the literal finite conjecture is therefore not supported. |
| Density of the phases `{t log n mod 2π}` and the claim that this forces `η(α+it) = 0` under the greedy condition. | Source lemma/argument | Not formalised. The density statement needs precise hypotheses on `t`; the passage from density to a contradiction is heuristic. |
| The energy `E(N) = |S_N|² + ∑_{k>N} |w_k|²` is non-increasing under the greedy condition. | Addendum, "one can show" | Not formalised; no proof is supplied in the source. |
| No zeros of `η` for `σ > 1/2`. | Used inside the proof of Theorem 4.1 and v3 | This is not the classical zero-free region (which only gives a region near `Re(s) = 1`); as stated for the whole half-plane it is equivalent to RH. Recorded as an archived claim, not used. |

## Open / conjecture

These are precise unresolved statements, not theorems and not computations.

| # | Kind | Statement | Status |
|---|---|---|---|
| O1 | Open / conjecture | A repaired finite greedy condition on the eta partial sums is equivalent to RH. | Open. The source's candidate is sign-inconsistent (Definition 2.1 versus the alternating series), and both finite readings fail at the first zero (C4, C5). |
| O2 | Open / conjecture | v2 Conjecture 3.1: the alternating signs are the greedy signs for all `N` iff `η(1/2 + it) = 0`. | Open as an infinite statement; the literal finite reading fails at `N = 2` for the first zero (C5). |
| O3 | Open / conjecture | Uniform control of the phases `{t log n}` and of `arg S_{N-1}` sufficient to force `σ = 1/2` under a greedy hypothesis. | Open; the source supplies only a sketch and a density heuristic. |
| O4 | Open / conjecture | The complex analytic identity `η(s) = (1 − 2^(1−s)) ζ(s)` and the continuation needed for the equivalence. | Open formalisation; only the real finite truncation T3 is in Lean. |

## Python layer

[`python/programme.py`](python/programme.py) provides:

- `term(sigma, n)`, `zeta_partial`, `eta_partial`, `eta_zeta_residual` — exact sympy arithmetic;
- `eta_zero_finite`, `abel_eta_zero`, `abel_eta_zero_limit` — the `σ = 0` edge;
- `greedy_correlation`, `first_greedy_violation`, `greedy_sign`, `alternating_sign` — high-precision mpmath checks of the raw and sign-corrected conditions.

The module imports without side effects. mpmath is used only for the complex greedy scan; all identities are checked in sympy first.

```bash
cd the-final-letter/topics/greedy-harmonic-zeta
python3 -m pytest -q tests
```

Current result: **9 passed** in well under two seconds.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) defines `GreedyZeta.term`, `zetaPartial`, `etaPartial`, and `corr`, and proves T1–T7. The proofs use elementary order facts (`Real.rpow_lt_rpow_of_neg`), finite-sum manipulations, parity of `(-1)^n`, and `Complex.normSq_add`/`normSq_sub`. The file imports Mathlib, uses the `GreedyZeta` namespace, and contains no unfinished proof or extra axiom.

```bash
cd the-final-letter/topics/greedy-harmonic-zeta
./lean/check.sh 2>&1 | tee lean/BUILD.log
```

Recorded build: [`lean/BUILD.log`](lean/BUILD.log) — `[check] OK Topic.lean`.

## Open items and known gaps

1. **A correct finite statement of the greedy condition.** The source must decide whether `w_N` is signed or unsigned. C5 shows that the first zero satisfies neither the raw condition for all `N` nor the sign-corrected alternating condition. A repaired formulation, and a proof or refutation of its equivalence with RH, is open.
2. **Formalise the complex eta–zeta identity.** T3 is the real, even-`N` truncation. The complex identity `η(s) = (1 − 2^{1−s}) ζ(s)` and the analytic continuation are not formalised.
3. **Formalise the analytic equivalence (if it can be repaired).** The Riemann–Siegel formula, the approximate functional equation, uniform error bounds, and the phase-density argument are all outside the Lean file. The source's appendix is not a proof.
4. **Adjudicate the v3 "rigorous proof".** The critical-exponent argument needs an independent audit; the present reconstruction records it as an archived claim because its key step assumes the desired zero-free half-plane.
5. **Formalise the energy monotonicity.** The addendum's energy inequality is stated without proof and is not in Lean.
6. **Relation to item 11.** The name "greedy harmonic" is shared with the greedy harmonic decomposition (item 11), but the mathematics here is the eta/Dirichlet exponent question, not the angle decomposition. The overlap is thematic; the two topics are not duplicates.

## Provenance and links

- [Scraps inventory](../../scraps.html), item 13.
- [Topic index](../README.md).
- Primary source: [`rh-reformulation.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/rh-reformulation.html).
- Companion: [`rh-reformulation-addendum.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/rh-reformulation-addendum.html), [`sine-harmonic-eta-crit.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/sine-harmonic-eta-crit.html), [`sine-harmonic-zeta-provability.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/sine-harmonic-zeta-provability.html), [`sine-harmonic-zeta-v2.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/sine-harmonic-zeta-v2.html), [`sine-harmonic-zeta-v3.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/sine-harmonic-zeta-v3.html).

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
