# `rh42/lean` — Lean 4 proofs for `rh42/truths.md`

Machine-checked Lean 4 + Mathlib proofs for the claims of the rh42 round (the
*signed* "Tau" alphabet, its ζ budgets, the exact reachable set and the parity
lock of the signed word).

* No `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`.
* Everything is stated about the same objects as the Python ground truth
  ([`../reachable.py`](../python/reachable.py), [`../helix_zeta.py`](../python/helix_zeta.py)).
* `Rh41.DigitWord` (from [`../../rh41/lean`](../../rh41/lean)) is imported by
  `Rh42/Tau.lean` for the factor-complexity reuse; the rh41 development itself is
  untouched.

## Building

The Lean installation lives outside this repository: elan at `$HOME/lean/elan`
with toolchain `leanprover/lean4:v4.35.0-rc2` and Mathlib4 at
`$HOME/lean/mathlib4`.  `check.sh` locates the toolchain binary directly,
reconstructs `LEAN_PATH` from `lake env` inside Mathlib, and prepends both this
directory and `../../rh41/lean` so the local imports resolve:

```
cd rh42/lean
./check.sh --all                             # every module, then the root
./check.sh Rh42/Reachable.lean               # one module
LEAN_PREFIX=/path/to/lean ./check.sh --all   # if the installation is elsewhere
```

`check.sh` writes `.olean` files next to the sources.  A single module takes
seconds to ~1 minute (Mathlib import dominated); the whole development is a few
minutes.

| file | contents |
|---|---|
| `Rh42/Budget.lean` | the budget closed forms |
| `Rh42/Reachable.lean` | Brown's criterion one-step lemmas, sub-sums, gap lemma, greedy |
| `Rh42/Tau.lean` | the signed greedy on `ℚ`: parity lock and even gaps |
| `Rh42.lean` | root module importing all three |

## What is proved, item by item

### `Rh42/Budget.lean` — `truths.md` §2

| `truths.md` | Lean | statement |
|---|---|---|
| `P(2) = π²/24` | `hasSum_even_zeta_two`, `positiveBudget_two` | `HasSum (fun k => 1/(2k)^2) (π²/24)` and the `k ≥ 1` budget `∑' k, 1/(2(k+1))^2 = π²/24` |
| `N(2) = π²/8 − 1` | `tsum_odd_zeta_two`, `negativeBudget_two` | `∑' k, 1/(2k+1)^2 = π²/8` and the budget from the denominator `3` on |
| `P(4) = π⁴/1440` | `hasSum_even_zeta_four`, `positiveBudget_four` | |
| `N(4) = π⁴/96 − 1` | `tsum_odd_zeta_four`, `negativeBudget_four` | |
| `P(2) + N(2) = π²/6 − 1` | `budget_two_sum` | the budget interval's length at `p = 2` |

All from Mathlib's `hasSum_zeta_two` / `hasSum_zeta_four`, splitting the `ζ`
series into its even and odd parts (`HasSum.mul_left`, `tsum_even_add_odd`,
`Summable.comp_injective`).

### `Rh42/Reachable.lean` — `truths.md` §3–§5

| `truths.md` | Lean | notes |
|---|---|---|
| Theorem 6, sufficiency step | `Icc_subset_union_shift`, `greedy_step_optimal` | if the tail fills `[0,T]` and `0 ≤ a ≤ T`, then `S ∪ (a+S)` fills `[0,a+T]` |
| Theorem 6, necessity step | `gap_of_subset_Icc` | if `S ⊆ [0,T]` and `a > T`, then `(T,a)` is a gap |
| the interval merge | `Icc_union_Icc_shift` | `[0,T] ∪ [a,a+T] = [0,a+T]` for `0 ≤ a ≤ T` |
| the sub-sum operator | `subSums`, `subSums_cons`, `mem_subSums_cons` | the recursion `S = S' ∪ (a + S')` |
| `0` and the total are sub-sums | `zero_mem_subSums`, `sum_mem_subSums` | |
| sub-sums lie in `[0, sum]` | `subSums_nonneg`, `subSums_le_sum` | |
| the finite gap lemma | `gap_lemma` | `a > t.sum` ⟹ every sub-sum `< a` is `≤ t.sum` |
| Theorem 10, doubling step | `subSums_cons_disjoint` | the two pieces are disjoint, giving `2^{n_min−1}` components |
| refutation R3 | `single_condition_not_sufficient` | `(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1` and misses `1/5` |
| the greedy on a list | `greedySum`, `greedySum_cons`, `greedySum_mem_subSums`, `greedySum_le` | the greedy's total is a sub-sum that never overshoots |

### `Rh42/Tau.lean` — `truths.md` §7

| `truths.md` | Lean | notes |
|---|---|---|
| the alphabet and the rule | `tauTerm`, `tauStep`, `tauTake`, `tauTake_iff`, `tauStep_eq_sub_of_cond`, `tauStep_eq_self_of_not` | `α_n = (−1)^n/(n+2)^p`, taken iff the sign matches and it fits |
| even terms are positive, odd terms negative | `tauTerm_pos_of_even`, `tauTerm_neg_of_odd`, `tauTerm_nonneg_iff_even` | |
| Theorem 14, sign invariance | `tauStep_nonneg`, `tauStep_pos_of_lt`, `tauStep_nonpos`, `tauStep_neg` | a positive residual stays `≥ 0` (and `> 0` when the term is strictly smaller) |
| Theorem 14, parity lock | `tauStep_eq_self_of_odd`, `take_parity`, `tauStep_eq_self_of_even`, `take_parity_neg` | a positive target only ever takes even indices; a negative target odd ones |
| the residual sequence and the support | `tauResidual`, `tauResidual_succ`, `tauTaken`, `support`, `mem_support`, `tauResidual_nonneg`, `tauResidual_nonpos` | |
| Theorem 14, even gaps | `support_subset_even`, `support_subset_odd_of_neg`, `support_gap_even_and_two_le`, `support_gap_even` (and the `_of_neg` mirrors) | consecutive taken indices differ by an even number `≥ 2` |
| the C1 regime | `GapsAtLeast`, `two_le_of_even_pos`, `c1_range_le_two_of_gap_eq_two`, `complexity_c1_example` | an even positive gap is `≥ 2`; a support with a gap equal to `2` has rh41 C1 range `L ≤ 2` (verified on `{2,4}` with `N = 10`: `p(2) = 3`) |
