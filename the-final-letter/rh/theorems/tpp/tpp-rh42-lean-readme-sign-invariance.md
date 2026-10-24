# Theorem 14, sign invariance — a positive residual stays `≥ 0` (and `> 0` when the term is strictly smaller)

**Kind:** Theorem
**Status:** PROVED (Lean, machine-checked; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Tau.lean — truths.md §7`

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | Theorem 14, sign invariance | `tauStep_nonneg`, `tauStep_pos_of_lt`, `tauStep_nonpos`, `tauStep_neg` | a positive residual stays `≥ 0` (and `> 0` when the term is strictly smaller) |

## Hypotheses and notation

- `tauStep` is the signed ("Tau") greedy step on `ℚ`: the alphabet is `α_n = (−1)^n/(n+2)^p`, taken iff the sign matches the residual and its size does not overshoot.
- `tauStep_nonneg`, `tauStep_nonpos` record the sign of the residual after a step; `tauStep_pos_of_lt`, `tauStep_neg` the strict forms under the strict-size hypothesis.
- "Theorem 14" is the `truths.md` numbering of the round (parity lock / sign invariance of the signed word).

## Proof / evidence

The evidence is the machine-checked declarations in `Rh42/Tau.lean` (`truths.md` §7). The README's file row describes `Rh42/Tau.lean` as "the signed greedy on `ℚ`: parity lock and even gaps". The build contract is `./check.sh --all`, and the README's preamble states there is no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`.

## Dependencies and related results

- Part of `rh42/truths.md` Theorem 14 (parity lock), harvested separately and also listed in the round's HANDOFF as row T9.
- The strict forms are the companion of the parity lock declarations (`tauStep_eq_self_of_odd`, `take_parity`, `tauStep_eq_self_of_even`, `take_parity_neg`).
- `tauTerm`, `tauStep`, `tauTake`, `tauTake_iff`, `tauStep_eq_sub_of_cond`, `tauStep_eq_self_of_not` supply the alphabet and the rule.

## Notes

- The statement is quoted from the README's notes column verbatim; the README does not print the Lean signatures.
- The four declarations cover both signs (positive and negative residual); the README's `_nonneg`/`_nonpos` wording is reproduced.
