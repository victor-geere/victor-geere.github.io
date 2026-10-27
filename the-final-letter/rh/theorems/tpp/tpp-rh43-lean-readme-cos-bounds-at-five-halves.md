# The two trigonometric bounds at `t = 5/2`: `cos((5/2) log 2) < -0.16`, `cos((5/2) log 3) < -0.92`

**Kind:** Lemma
**Status:** PROVED (Lean, from Mathlib's log/π bounds and Taylor inequalities; no numerical axiom)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/README.md`](../../research/twin-prime-parity/rounds/rh43/lean/README.md) — "What is proved, item by item" (table rows), "Notes on the proofs"

## Statement

> | theorem | statement |
> |---|---|
> | `cos_two_mul_log_two_lt` | `cos ((5/2) log 2) < -0.16` |
> | `cos_two_mul_log_three_lt` | `cos ((5/2) log 3) < -0.92` |

The "Notes on the proofs" section gives the inputs:

> * The two numerical inputs to the `N = 3` witness use Mathlib's `Real.log_two_gt_d9` / `Real.log_two_lt_d9`, `Real.log_three_gt_d9` / `Real.log_three_lt_d9`, `Real.pi_gt_d20` / `Real.pi_lt_d20`, and the Taylor inequalities `Real.one_sub_sq_div_two_le_cos`, `Real.sin_ge_sub_cube`, `Real.cos_lt_cos_of_nonneg_of_le_pi`, `Real.cos_pi_sub`, `Real.cos_add_pi_div_two`. No numerical axiom is used anywhere.

## Hypotheses and notation

- The bounds are for `cos ((5/2) * Real.log 2)` and `cos ((5/2) * Real.log 3)`.
- Mathlib inputs: `Real.log_two_gt_d9`, `Real.log_two_lt_d9`, `Real.log_three_gt_d9`, `Real.log_three_lt_d9`, `Real.pi_gt_d20`, `Real.pi_lt_d20`, and the Taylor inequalities `Real.one_sub_sq_div_two_le_cos`, `Real.sin_ge_sub_cube`, `Real.cos_lt_cos_of_nonneg_of_le_pi`, `Real.cos_pi_sub`, `Real.cos_add_pi_div_two`.

## Proof / evidence

- **PROVED** in Lean: `cos_two_mul_log_two_lt`, `cos_two_mul_log_three_lt` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean).
- No numerical axiom is used anywhere; the bounds are derived from Mathlib's decimal log/π bounds and the listed Taylor inequalities.

## Dependencies and related results

- These bounds feed [Existence of a balanced partial sum](tpp-rh43-lean-readme-exists-balanced-partial-sum.md) (`realPartial_three_five_halves_neg`).
- Counterparts in the truths harvest: [Theorem 4 (existence of a balanced partial sum)](tpp-rh43-truths-n3-existence-ivt.md), [Theorem 7 (existence for every N ≥ 3)](tpp-rh43-truths-existence-every-n.md).

## Notes

- These are the two numerical inputs named in truths.md §1.2 and HANDOFF.md §2.3 for the `N = 3` witness; the source insists they are derived, not axiomatised.
