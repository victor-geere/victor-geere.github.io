# The single condition `a₁ ≤ A − a₁` is not sufficient for completeness: the four-term counterexample `(1/2, 2/5, 1/20, 1/20)`

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) — `single_condition_not_sufficient` (lines 171–187)

## Statement

> The four-term counterexample: `a`<sub>`1`</sub>` = 1/2` equals the sum of the rest, yet `1/5` is not a sub-sum, so the single condition `a`<sub>`1`</sub>` ≤ A − a`<sub>`1`</sub> does not imply completeness (it is the *unimodality* of `h`, verified in `reachable.py`, that rescues the `p`-series).
>
> Lean statement (`single_condition_not_sufficient`):
>
> `(1 / 5 : ℚ) ∉ subSums [1 / 2, 2 / 5, 1 / 20, 1 / 20] ∧ (1 / 2 : ℚ) = (1 / 2 + 2 / 5 + 1 / 20 + 1 / 20) - 1 / 2`

## Hypotheses and notation

- The list is `(a`<sub>`1`</sub>`, a`<sub>`2`</sub>`, a`<sub>`3`</sub>`, a`<sub>`4`</sub>`) = (1/2, 2/5, 1/20, 1/20)`; `subSums` is the sub-sum set, so `A = 1/2 + 2/5 + 1/20 + 1/20 = 1`.
- `a`<sub>`1`</sub>` ≤ A − a`<sub>`1`</sub>` is the single condition being tested (here `1/2 = 1 − 1/2`, equality).
- Completeness means that the sub-sums fill the whole interval `[0, A]` (Brown's criterion, quoted in the file header).
- `h` is the term sequence of the `p`-series; `reachable.py` is the numerical ground-truth script of the round.

## Proof / evidence

Machine-checked in `Rh42/Reachable.lean` as the `theorem` `single_condition_not_sufficient`; equivalently, this is the refutation labelled "refutation R3" by the rh42 Lean README.

- Non-membership: if `1/5` were a sub-sum of `[1/2, 2/5, 1/20, 1/20]`, then either it is a sub-sum of `[2/5, 1/20, 1/20]`, where `gap_lemma` at `a = 2/5` forces it `≤ 1/20 + 1/20 = 1/10 < 1/5`, or it equals `1/2 + y` with `y ≥ 0`, hence `≥ 1/2`. Both are impossible.
- The equality `1/2 = (1/2 + 2/5 + 1/20 + 1/20) − 1/2` is closed by `norm_num`.

The file header states: "there is no `sorry`, no `admit`, no new axiom and no `native_decide`."

## Dependencies and related results

- Uses the finite gap lemma [`lean-rh42-reachable-finite-gap-lemma.md`](lean-rh42-reachable-finite-gap-lemma.md) and the bounds [`lean-rh42-reachable-sub-sums-endpoints-and-bounds.md`](lean-rh42-reachable-sub-sums-endpoints-and-bounds.md).
- The rh42 Lean README lists this row as "refutation R3" ↔ `single_condition_not_sufficient`.

## Notes

- The declaration is a Lean `theorem`; the result is a counterexample refuting a proposed completeness test (the single condition `a`<sub>`1`</sub>` ≤ A − a`<sub>`1`</sub>`), not a positive completeness statement.
- The helper lemmas `nonneg_twentieths` and `nonneg_counterexample` in the same file are arithmetic non-negativity checks supporting this proof and are not harvested separately.
