# `rh43/lean` — Lean 4 proofs for `rh43/truths.md`

Machine-checked Lean 4 + Mathlib proofs for the rh43 round: the partial sums of the
zeta Dirichlet series at `Re(S) = 0`, the positive/negative split, and the existence
of a **balanced** partial sum.

* No `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`.  A
  temporary `#print axioms` audit over every theorem reports exactly
  `[propext, Classical.choice, Quot.sound]`.
* Everything is stated about the same object as the Python ground truth
  ([`../zeta_split.py`](zeta_split.py)), whose certificates come from
  [`../ivmath.py`](ivmath.py) and are independently reproduced by
  [`../verify/independent_check.py`](verify/independent_check.py).
* Self-contained: `import Mathlib` only.

## Building

The Lean installation lives outside this repository: elan at `$HOME/lean/elan` with
toolchain `leanprover/lean4:v4.35.0-rc2` and Mathlib4 at `$HOME/lean/mathlib4`.
`check.sh` locates the toolchain binary directly, reconstructs `LEAN_PATH` from
`lake env` inside Mathlib, and prepends this directory:

```
cd rh43/lean
./check.sh --all                             # Rh43/Balance.lean, then Rh43.lean
./check.sh Rh43/Balance.lean                 # one module
LEAN_PREFIX=/path/to/lean ./check.sh --all   # if the installation is elsewhere
```

A single module takes seconds to ~1 minute (Mathlib import dominated).

| file | contents |
|---|---|
| [`Rh43/Balance.lean`](Rh43/Balance.lean) | the whole development (38 theorems + 4 definitions) |
| `Rh43.lean` | root module importing `Rh43.Balance` |

## The object

```lean
noncomputable def zetaPartial (N : ℕ) (t : ℝ) : ℂ :=
  ∑ k ∈ Finset.range N, Complex.exp (-(t : ℂ) * Complex.I * Real.log (k + 1))
-- i.e. the sum of n^{-it} for n = 1, …, N

noncomputable def realPartial (N : ℕ) (t : ℝ) : ℝ :=
  ∑ k ∈ Finset.range N, Real.cos (t * Real.log (k + 1))

noncomputable def posRe (N : ℕ) (t : ℝ) : ℝ :=   -- terms with cos > 0
  ∑ k ∈ (Finset.range N).filter (fun k => 0 < Real.cos (t * Real.log (k + 1))),
    Real.cos (t * Real.log (k + 1))

noncomputable def negRe (N : ℕ) (t : ℝ) : ℝ :=   -- terms with cos < 0
  ∑ k ∈ (Finset.range N).filter (fun k => Real.cos (t * Real.log (k + 1)) < 0),
    Real.cos (t * Real.log (k + 1))

def balanced (N : ℕ) (t : ℝ) : Prop := posRe N t = -negRe N t
```

## What is proved, item by item

| theorem | statement |
|---|---|
| `zetaPartial_re` | `(zetaPartial N t).re = realPartial N t` |
| `realPartial_eq_posRe_add_negRe` | `realPartial N t = posRe N t + negRe N t` (the identity, with the `cos = 0` terms vanishing) |
| `posRe_nonneg`, `negRe_nonpos` | `0 ≤ posRe N t`, `negRe N t ≤ 0` |
| `balanced_iff_realPartial_eq_zero` | `balanced N t ↔ realPartial N t = 0` — **the reduction of the round's question to one real equation** |
| `balanced_equal_split` | balance yields two equal positive and two equal negative pieces `P/2, P/2, M/2, M/2` |
| `equal_split_balanced` | conversely, an equal split with `p1 + n1 = 0` gives balance |
| `balanced_iff_equal_split` | the `iff`, with the necessary conjunct `p1 + n1 = 0` (without it the statement is false: `N = 2, t = 0` is a counterexample, `not_balanced_two_zero`) |
| `realPartial_continuous` | `Continuous (fun t => realPartial N t)` |
| `realPartial_three_at_zero` | `realPartial 3 0 = 3` |
| `cos_two_mul_log_two_lt` | `cos ((5/2) log 2) < -0.16` |
| `cos_two_mul_log_three_lt` | `cos ((5/2) log 3) < -0.92` |
| `realPartial_three_five_halves_neg` | `realPartial 3 (5/2) < 0` |
| `exists_zero_realPartial_three` | `∃ t ∈ Icc 0 (5/2), realPartial 3 t = 0` (IVT) |
| `exists_balanced_partial_sum` | `∃ N t, 0 < N ∧ balanced N t` — **the answer of the round** |
| `realPartial_two`, `realPartial_two_pi_div_log_two` | `realPartial 2 t = 1 + cos (t log 2)`, and it vanishes at `π/log 2` |
| `balanced_two`, `exists_balanced_two` | `N = 2` is balanced at `π/log 2` (the *tangential* zero; a sign-change search misses it) |
| `posRe_two_at_pi_div_log_two`, `negRe_two_at_pi_div_log_two` | at that point the positive part is `1` (index `1`) and the negative part is `-1` (index `2`): both parts are non-degenerate |
| `zetaPartial_two`, `zetaPartial_two_pi_div_log_two` | `S_2(π/log 2) = 0` exactly |
| `zetaPartial_three_ne_zero` | `S_3(t) ≠ 0` for **every** real `t` (reduce to `m log 2 = n log 3`, i.e. `3^{\|n\|} = 2^{\|m\|}`) |
| `not_forall_zetaPartial_ne_zero` | the blanket "the complex partial sum never vanishes" is **false**, witness `N = 2` |
| `not_balanced_two_zero` | `t = 0` is unbalanced at `N = 2` (it does **not** say `N = 2` is never balanced — see `balanced_two`) |

## Notes on the proofs

* The two numerical inputs to the `N = 3` witness use Mathlib's
  `Real.log_two_gt_d9` / `Real.log_two_lt_d9`, `Real.log_three_gt_d9` /
  `Real.log_three_lt_d9`, `Real.pi_gt_d20` / `Real.pi_lt_d20`, and the Taylor
  inequalities `Real.one_sub_sq_div_two_le_cos`, `Real.sin_ge_sub_cube`,
  `Real.cos_lt_cos_of_nonneg_of_le_pi`, `Real.cos_pi_sub`, `Real.cos_add_pi_div_two`.
  No numerical axiom is used anywhere.
* The complex split `posPart + negPart = zetaPartial` (with the `cos = 0` terms) is
  deliberately **not** stated: a term with `cos = 0` has nonzero imaginary part and
  belongs to neither filter, so the complex identity is false.  Everything is done at
  the real-part level, where the identity is exact (`realPartial_eq_posRe_add_negRe`).
