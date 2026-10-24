# `rh41/lean` — Lean 4 proofs for the truths of `rh41/TRUTHS.md`

Machine-checked Lean 4 + Mathlib proofs for the claims collected in
[`../TRUTHS.md`](../../../../twin-prime-parity/rounds/rh41/TRUTHS.md) (the factor-complexity law of the greedy digit
word), plus three corrections and a few sharpenings.

* No `sorry`, no `admit`, no project-specific `axiom`.
* Everything is stated about the same objects as the Python ground truth
  (`../digitword.py`, `../rigorous_check.py`): a word is a support
  `S : Finset ℕ` plus a truncation length `N`, and the factor at window start
  `t` of length `L` is the offset set
  `{a - t : a ∈ S, t ≤ a ≤ t + L - 1}`.

## Building

The Lean installation lives outside this repository: elan at `$HOME/lean/elan`
with toolchain `leanprover/lean4:v4.35.0-rc2` and Mathlib4 at
`$HOME/lean/mathlib4`.  `check.sh` locates the toolchain binary directly and
reconstructs `LEAN_PATH` from `lake env` inside Mathlib (so it works with the
DSH file sandbox, which forbids writes to `$HOME`):

```
cd rh41/lean
./check.sh --all                             # or: ./check.sh Rh41/DigitWord.lean
LEAN_PREFIX=/path/to/lean ./check.sh --all   # if the installation lives elsewhere
```

`check.sh` writes the `.olean` files next to the sources (with `-R`/`-o`), so
`import Rh41.X` works between the files of this directory; `Rh41.lean` is a root
module importing all of them (a good smoke test that there are no name clashes).
A full run takes roughly three minutes.

| file | contents |
|---|---|
| `Rh41/DigitWord.lean` | combinatorial core: Theorem 1, Corollaries 2–4, Theorem 5, claim A1, Theorem 6, the refuted formulas |
| `Rh41/AllZero.lean` | claim A2 (the all-zero factor / gap criterion) |
| `Rh41/WindowCount.lean` | `TRUTHS.md` §2: the exact number of windows containing `a_m` |
| `Rh41/Impossibility.lean` | the mathematical core of Theorem 12 (no linear or affine profile) |
| `Rh41/GreedyResidual.lean` | the residual orbit on `ℚ` (in the sub-namespace `Rh41.Harmonic`, since `Rh41.Alphabet` has a general-alphabet `residual`): Theorems 7 and 8, the squaring law, no two-sided squaring law |
| `Rh41/Alphabet.lean` | general alphabets: Theorem 9 (corrected), Theorem 10, Theorem 11, Theorem 12 |

## What is proved, item by item

### §1 The complexity function

| `TRUTHS.md` | Lean | notes |
|---|---|---|
| Theorem 1 (main) | `DigitWord.complexity_main` | proved in the sharper form (`L ≥ a_m + 1` only; the span hypothesis is redundant). `complexity_main_TRUTHS` restates it with the hypotheses printed in `TRUTHS.md`. |
| Corollary 2 (plateau) | `DigitWord.complexity_plateau` | |
| Corollary 3 (decay) | `DigitWord.complexity_decay` | plus the endpoints `complexity_eq_one_of_le` (`p(N) = 1`) and `complexity_eq_two_of_pred` (`p(N-1) = 2`) |
| Corollary 4 | `DigitWord.max_complexity` | with the auxiliary general bound `complexity_le_max_add_two` (`p(L) ≤ a_m + 2` for *every* `L`, which is what makes the maximum exactly `a_m + 2`) |
| the bound `L ≥ max(span, a_m+1)` is necessary | `DigitWord.refuted_main_formula_all_L` | support `{0,1}`, `N = 2`, `L = 1`: `p = 1`, formula `2` |
| the `{0..199}`, `N = 259` example (`max p = 60`) | `DigitWord.plateau_empty_example` | `native_decide` |
| Theorem 5 (C1 regime) | `DigitWord.complexity_c1` | with the three necessity counterexamples `c1_bound_a0_necessary`, `c1_bound_gap_necessary`, `c1_bound_hedge_necessary` |

### §2 Auxiliary structure

| `TRUTHS.md` | Lean | notes |
|---|---|---|
| all-zero factor iff an extended gap is `≥ L+1` (checked, 95 835 cases) | `AllZero.allZero_iff_hasLargeGap` | proved for **all** supports, `N` and `L`; the Python list `[-1] + ones + [N]` is `AllZero.extSupport` shifted by one |
| `#{t : window contains a_m} = max(0, min(a_m,N−L) − max(0,a_m−L+1) + 1)` (checked, 25 044 603 cases) | `WindowCount.card_windows_containing` | proved for all `N, L, a_m` with `1 ≤ L ≤ N`; stated in `ℤ` to match the Python arithmetic (`ℤ` version via `card_Icc_int`, `cast_max_sub`) |
| offset-tuple count equals bit-string count (checked) | `DigitWord.complexity_eq_bitComplexity` | proved for all supports, via the explicit bijection `toBit`/`bitFactor` |
| Theorem 6 (onset determinacy) | `DigitWord.onset_not_determined_by_gaps` | **corrected**: see below |

### §3 The support: greedy orbits (`Rh41/GreedyResidual.lean`)

| `TRUTHS.md` | Lean | notes |
|---|---|---|
| `r_{k+1} ≤ r_k²` on every active step | `Harmonic.squaring_identity`, `Harmonic.squaring_law` | exact identity for the ratio, then the inequality |
| `r'/r²` has no positive lower bound (refuted row 8) | `Harmonic.no_positive_lower_bound` | |
| Theorem 7 (maps) | `Harmonic.u_map`, `Harmonic.induced_map`, `Harmonic.induced_map_int` | exact rational identities |
| Theorem 8 (rational termination) | `Harmonic.terminates_rat`, `Harmonic.terminates_of_pos_lt_one`, `Harmonic.terminates_from` | plus the tail formulation `Harmonic.residual_shift`, `Harmonic.residual_eventually_zero` |
| `x = 1` has support exactly `{0,1,4}` | `Harmonic.taken_one_iff` | |
| the invariant behind §3 | `Harmonic.residual_invariant` | |

The declarations live in `namespace Rh41.Harmonic` (the file also defines
`active`, `firstActive` and the numerator-decrease lemma `num_sub_inv_lt` that
drives termination).  Two hypotheses are worth noting: `Harmonic.u_map` needs
`1/(n+2) < r` strictly (at equality the residual vanishes and `s = q - 1/r`
becomes `0`), and `Harmonic.induced_map` covers the non-integral case
`{q²/s} ≠ 0` with the terminating integral case proved separately as
`Harmonic.induced_map_int`.

### §4 Alphabets (`Rh41/Alphabet.lean`)

| `TRUTHS.md` | Lean | notes |
|---|---|---|
| Theorem 9, "all partial sums `< x` ⟹ never halts" | `taken_all_of_bounded_partial_sums`, `never_halts_of_partial_sums_lt`, `residual_ge_sub_sum` | proved for any positive alphabet (non-increasing kept in the `_mono` variant) |
| Theorem 9, "halting ⟹ some partial sum `≥ x`" | `le_sum_of_residual_eq_zero` | this is the only true direction of the printed `iff` |
| Theorem 10 row 1 / row 2 shape | `taken_all_of_bounded_partial_sums_mono`, `partial_sums_iff` | |
| Theorem 10 row 3 (with the missing hypothesis) | `exists_taken_ge`, `never_halts_of_tendsto_zero`, `powerAlpha_never_halts`, `powerAlpha_infinitely_many_taken` | needs "no finite sub-sum equals `x`"; `powerAlpha` is `(n+2)^{-p}` for natural `p ≥ 1` |
| Theorem 11 (dichotomy false) | `expAlpha_residual`, `expAlpha_taken`, `expAlpha_support_univ`, `expAlpha_residual_tendsto_zero`, `expAlpha_bounded_gaps_and_termination` | every index taken and `residual = (1/2)^n` |
| Theorem 12 (finite-support/halting forms) | `max_complexity_of_finite_support`, `no_linear_complexity_of_finite_support`, `no_sturmian_complexity_of_finite_support`, `max_complexity_of_halting`, `no_linear_complexity_of_halting` | |
| Theorem 12 (process-independent core) | `Impossibility.no_linear_growth`, `Impossibility.no_affine_profile`, `Impossibility.no_sturmian_profile` | no finite support has a linear/affine (in particular Sturmian) profile; `N` is allowed to grow with `L` |

### §5 Refuted — do not re-propose

| `TRUTHS.md` row | Lean |
|---|---|
| `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for **all** `L` | `DigitWord.refuted_main_formula_all_L` |
| `p(L) = L + 1 + #{pairs at distance ≤ L}` | `DigitWord.refuted_pair_count_formula` |
| `p(L) = L + 1 + #{distinct distances ≤ L}` | `DigitWord.refuted_dist_count_formula` |
| `p(L) = L + 1 + Σ max(0, L−d_j)` | `DigitWord.refuted_gap_deficit_formula` |
| `p(L) = 2L − 10` on `12 ≤ L ≤ 593` | `DigitWord.refuted_slope_formula` |
| `p(L) = min(L + span, N − L + 1)` | `DigitWord.refuted_span_formula` |
| the onset is a function of the gaps | `DigitWord.onset_not_determined_by_gaps` |
| `α_n = (n+2)^{−3/2}` has bounded gaps | `Alphabet.powerAlpha_never_halts`, `Alphabet.powerAlpha_infinitely_many_taken` |
| "bounded gaps OR termination, never both" | `Alphabet.expAlpha_bounded_gaps_and_termination` |
| the residual ratio has a positive lower bound | `Harmonic.no_positive_lower_bound` |

The remaining rows (the first-difference identity with a left-special
correction, `Σ_j |intervals|`, the residual-orbit average limit) are not
formalised; see "Not formalised" below.

## Corrections found while formalising

1. **Theorem 6 / §5 row "the onset is a function of the gaps".**  The printed
   example has the two onsets interchanged.  With `N = 6` the complexity
   profiles are `{0,2} ↦ (2,3,4,3,2,1)` and `{1,3} ↦ (2,3,3,3,2,1)`, so the
   onsets are `3` and `2`, not `2` and `3`.  `rigorous_check.py::onset`
   computes the corrected values, and `DigitWord.onset_not_determined_by_gaps`
   proves them.

2. **Theorem 9 ("halts finitely iff `Σ α_n ≥ x`").**  As printed this is false:
   Theorem 10 row 3 has `Σ α_n = ∞ ≥ x = 1` and never halts, and for
   `α_n = 2^{-(n+1)}` we have `Σ α_n = 1 = x` while the residual is
   `2^{-n} > 0` at every finite step.  The sound statements, both formalised in
   `Rh41/Alphabet.lean`, are:
   * if every finite partial sum is `< x` then every index is taken and the
     residual is never `0` (the process never halts);
   * if the residual reaches `0` at step `N` then `x ≤ Σ_{k<N} α_k`.
   "Termination" is used in `TRUTHS.md` in two different senses (the residual
   hits `0`; the residual tends to `0`), which is the source of the
   inconsistency.  Concretely, Theorem 11's "terminates exactly" is formalised
   as `residual = (1/2)^n → 0`, not as finite termination.

3. **Theorem 10 row 3 needs an extra hypothesis.**  "The residual never reaches
   `0`" is not automatic: it needs "no finite sub-sum of the alphabet equals
   `x`".  `Alphabet.never_halts_of_tendsto_zero` states the theorem with this
   hypothesis made explicit; for `α_n = (n+2)^{-p}`, `x = 1` it holds by
   irrationality of the sub-sums (not formalised).

4. **Theorem 1 is stated with a redundant hypothesis.**  The bound
   `L ≥ a_m + 1` suffices; `L ≥ span` is not needed for the formula (it is
   `a_m < L` that rules out windows to the left of `a_m`).  `complexity_main`
   proves the sharper statement, `complexity_main_TRUTHS` matches the printed
   hypotheses.

5. **Theorem 7 needs strict hypotheses.**  `u' = q²/s - q` is only meaningful
   while the step does not terminate (`1/(n+2) < r`); `s' = 1 - {q²/s}` needs
   `{q²/s} ≠ 0`, the integral case being exactly the terminating step (where
   `s' = 0`), proved as `Harmonic.induced_map_int`.  Likewise the general-index
   termination statement `Harmonic.terminates_from` keeps the invariant
   `r < 1/(i+1)`: the numerator-decrease measure fails for arbitrary `(i, r)`,
   while `Harmonic.terminates_rat` (Theorem 8) needs no extra hypothesis.

6. **The literal phrasing of Theorem 12.**  "For every `c > 0` there is `L`
   with `p(L) < c·L`" is false for a *fixed* truncation `N` once `c·N ≤ a_m+2`.
   `Impossibility.no_linear_growth` states the correct version: for every
   `c > 0` there are `N` and `L` with `1 ≤ L ≤ N` and `p(L) < c·L` (the
   truncation is part of the data and may grow with `L`), and
   `no_affine_profile` / `no_sturmian_profile` give the resulting impossibilities.

## Trust and methodology

* Every theorem is checked by the Lean kernel.  The only non-constructive
  ingredients are classical logic (`classical`, `by_contra`) and Mathlib's
  standard quotient/propositional axioms, not extra assumptions.
* A handful of **concrete numerical facts** (the counterexamples of §5 of
  `TRUTHS.md`, the `max p = 60` example, and the gap-sequence equality in
  Theorem 6) are proved with `native_decide`, i.e. by compiled evaluation of a
  closed decidable proposition.  This is still machine-checked evaluation of a
  closed term, but it relies on the Lean compiler (`Lean.ofReduceBool`) rather
  than on pure kernel reduction; the affected theorems are exactly
  `DigitWord.onset_not_determined_by_gaps` (gap-sequence part),
  `DigitWord.refuted_pair_count_formula`, `DigitWord.refuted_dist_count_formula`,
  `DigitWord.refuted_gap_deficit_formula`, `DigitWord.refuted_slope_formula`,
  `DigitWord.refuted_span_formula`, `DigitWord.plateau_empty_example` and
  `DigitWord.c1_bound_gap_necessary`.  The heavier closed computations cannot be
  done by kernel `decide` (they exceed the heartbeat budget), which is why
  `native_decide` is used there.  `Rh41/Alphabet.lean`,
  `Rh41/GreedyResidual.lean`, `Rh41/AllZero.lean`, `Rh41/WindowCount.lean` and
  `Rh41/Impossibility.lean` use no `native_decide`.
* The *statements* were cross-checked against the Python ground truth
  independently of the Lean proofs by
  [`crosscheck.py`](crosscheck.py) (`python3 rh41/lean/crosscheck.py`, exit 0):

  | statement | reference | cases |
  |---|---|---|
  | `DigitWord.complexity_main` (Theorem 1) | `p_ref` | 397 214 |
  | `DigitWord.complexity_c1` (Theorem 5) | `p_ref` | 117 011 |
  | `AllZero.allZero_iff_hasLargeGap` (claim A2) | `allzero_ref`/`allzero_gap` | 1 444 551 |
  | `WindowCount.card_windows_containing` | brute force | 10 850 |
  | Theorem 6 onsets | `rigorous_check.onset` | 2 |
  | `Harmonic.terminates_rat` census | exact fractions | 277 |

  (1 969 905 cases in total, no violations.)

## Not formalised

* Numerical constants: `p* = 1.7286472389981836181`, the root of `ζ(p) = 3/2`,
  and the observed minimum `1.58·10⁻⁴` of `r'/r²` (the *statements* that these
  quantities exist and have the claimed qualitative properties are formalised;
  the decimal values are not).
* The statistics/measurements: `F3` ("the induced map is not the Gauss map", a
  max-deviation measurement over 12 orbit steps), the visible orbit data
  (max gap `76 762` for `p = 3/2`), and the specific supports such as `1/π`.
* `A(N) = Ω_x(log log N)` as an asymptotic statement about logarithms — the
  underlying inequality `r_{k+1} ≤ r_k²` is formalised
  (`Harmonic.squaring_law`), but the passage to a lower bound for `A(N)` uses
  real logarithms and is left out.
* The first-difference (Cassaigne) identity rows of §5, and the open case of
  non-monotone alphabets.
* `TRUTHS.md` Theorem 5's "C1 law `p(L) = L+1+#{j : d_j < L}`": only the regime
  where the correction vanishes (Theorem 5 itself) is formalised.
