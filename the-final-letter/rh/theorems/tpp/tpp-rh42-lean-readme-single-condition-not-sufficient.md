# Refutation R3 — `(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1` and misses `1/5`

**Kind:** Claim
**Status:** PROVED (Lean, machine-checked counterexample; `no sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Reachable.lean — truths.md §3–§5`, row "refutation R3"

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | refutation R3 | `single_condition_not_sufficient` | `(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1` and misses `1/5` |

## Hypotheses and notation

- The refuted single condition: for a non-increasing positive sequence with total `A`, `a_1 ≤ A − a_1` (first term at most the sum of the rest) — the naive form of Brown's criterion.
- Witness sequence `(1/2, 2/5, 1/20, 1/20)`: `a_1 = 1/2` and `A − a_1 = 1/2`, so the condition holds with equality; the sub-sum `1/5` is nevertheless missing.

## Proof / evidence

The evidence is the machine-checked Lean declaration `single_condition_not_sufficient` in `Rh42/Reachable.lean`; the README's `truths.md` mapping places it in `§3–§5`.

## Dependencies and related results

- Refutes the single-condition reading of Brown's criterion; the correct criterion (every `n`) is used for the completeness thresholds.
- Companion of `gap_lemma` (`a > t.sum ⟹ every sub-sum < a is ≤ t.sum`) in the same file.
- Restates the `rh42/truths.md` refuted row R3 (harvested separately as the single-condition refutation), which names the same witness and the same Lean declaration.

## Notes

- The README gives the witness and the declaration name; it does not spell out the proof beyond the machine-checked declaration.
- The missing sub-sum `1/5` is the same rational target that the round's HANDOFF (row T11) shows is not writable in the signed `p = 2` setting.
