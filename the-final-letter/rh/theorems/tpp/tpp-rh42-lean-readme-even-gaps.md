# Theorem 14, even gaps — consecutive taken indices differ by an even number `≥ 2`

**Kind:** Theorem
**Status:** PROVED (Lean, machine-checked; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Tau.lean — truths.md §7`

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | Theorem 14, even gaps | `support_subset_even`, `support_subset_odd_of_neg`, `support_gap_even_and_two_le`, `support_gap_even` (and the `_of_neg` mirrors) | consecutive taken indices differ by an even number `≥ 2` |

## Hypotheses and notation

- `support` is the set of indices at which the signed rule takes a term; `mem_support` its membership lemma.
- `support_subset_even` / `support_subset_odd_of_neg`: the support lies in the even indices for a positive target and the odd indices for a negative one.
- `support_gap_even_and_two_le`, `support_gap_even`: consecutive taken indices differ by an even number, and by at least `2`.
- `_of_neg` mirrors are the negative-target versions of the same declarations.

## Proof / evidence

The evidence is the machine-checked declarations in `Rh42/Tau.lean` (`truths.md` §7), under the build contract `./check.sh --all` with no `sorry`/`admit`/`axiom`/`native_decide`.

## Dependencies and related results

- Uses the parity lock (`take_parity`, `take_parity_neg`) and the residual/support layer of the same file.
- Same content as the round's HANDOFF ledger row T9 ("all gaps are even and at least 2"), harvested separately, and as `rh42/truths.md` Theorem 14.

## Notes

- Quoted from the README's notes column verbatim; the parenthetical "(and the `_of_neg` mirrors)" is the source's.
- The gap statement is the signed-word constraint that the round's HANDOFF §5.6.3 says governs the C1 regime and plateau onset ("which the unsigned word does not have").
