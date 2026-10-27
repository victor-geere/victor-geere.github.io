# `gap_lemma` — the finite gap lemma

**Kind:** Lemma
**Status:** PROVED (Lean, machine-checked; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Reachable.lean — truths.md §3–§5`

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | the finite gap lemma | `gap_lemma` | `a > t.sum` ⟹ every sub-sum `< a` is `≤ t.sum` |

## Hypotheses and notation

- `t` is a list of terms, `t.sum` its total.
- `a` is the first (largest) term of the extended list, in the gap situation `a > t.sum`.
- "sub-sum" as in `subSums` (a sum over a sub-multiset).

## Proof / evidence

The evidence is the machine-checked declaration `gap_lemma` in `Rh42/Reachable.lean`; the README gives no separate proof text.

## Dependencies and related results

- Uses `subSums`, `subSums_nonneg`, `subSums_le_sum`.
- Companion of `gap_of_subset_Icc` (necessity step of Theorem 6) and `Icc_union_Icc_shift` of the same file.
- The corresponding §5.5 statement in the round's HANDOFF is the subset-sum recursion and the gap `(total − a_1, a_1)`.

## Notes

- The statement is quoted exactly as the README's notes column gives it, including the symbol `⟹`.
- The case is the "otherwise" branch of completeness: the first term exceeds the sum of the rest.
