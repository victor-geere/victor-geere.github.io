# X2 — the sparse-modification bound corrected to `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`

**Kind:** Claim
**Status:** REFUTED (witness `A = {5}`, `x = 5`: `\|ΔS\| = 4 > 2`); corrected bound stated
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/README.md`](../../research/twin-prime-parity/README.md) — "Corrections this harvest forced on the rounds' own records", row X2

## Statement

> | # | the round's claim | correction | witness |
> |---|---|---|---|
> | X2 | the sparse-modification bound `≤ 2·#{n ≤ x+2 : n ∈ A}` (rh46 §3) | **false** — correct is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}` | witness `A = {5}`, `x = 5`: `\|ΔS\| = 4 > 2` (rh47 §3) |

## Hypotheses and notation

- `A` is the set of indices at which signs are flipped; `ΔS` is the resulting change in the correlation sum.
- `#{…}` denotes cardinality; the corrected bound counts `n ≤ x` such that `n ∈ A` **or** `n+2 ∈ A` (both endpoints of the pair can contribute).
- The refuted bound counted only `n ≤ x+2` with `n ∈ A` and had constant `2`.

## Proof / evidence

- Witness quoted: `A = {5}`, `x = 5`, `|ΔS| = 4 > 2` (recorded as coming from `rh47 §3`).
- The corrected inequality is quoted exactly, including both sides and the constant `4`.

## Dependencies and related results

- Corrects the same bound that `rh46/README.md` §1.4 states as "A refinement the auditor proved" (harvested from that source with status REFUTED and the same witness).
- The `o(x)` conclusion is unaffected in both sources' statements, because the corrected right-hand side is still `O(#{m ≤ x+2 : m ∈ A})`.
- For the finite-prefix construction this bound is the sparsity remark attached to the indeterminacy theorem.

## Notes

- Harvested because the programme README states it as a labelled correction with its witness; the primary status of the original claim is **REFUTED**.
- The source's formatting is preserved: the union inside the set-builder is written with the word `or` (not a `|`), and is reproduced as such.
- The witness is the smallest counterexample to the original constant `2`.
