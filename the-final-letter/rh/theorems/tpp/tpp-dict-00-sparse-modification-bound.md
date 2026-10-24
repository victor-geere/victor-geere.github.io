# a sparse modification cannot move `S`: `≤ 4·#{m ≤ x+2 : m ∈ A}`

**Kind:** Theorem
**Status:** PROVED (paper argument; corrected in rh47)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F5, line 107

## Statement

The ledger row, verbatim:

> | F5 | a **sparse** modification cannot move `S`: `≤ 4·#{m ≤ x+2 : m ∈ A}` | THEOREM (corrected in rh47) | [`../../rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) §3 |

## Hypotheses and notation

- `S` is the two-point correlation `Σ_{n≤x} λ(n)λ(n+2)` ([F1](tpp-dict-00-correlation-trivial-bound.md)).
- `A` is the sparse set of indices at which the modification is made; `#{m ≤ x+2 : m ∈ A}` counts its elements up to `x+2`.
- The bound on the change in `S` is `4·#{m ≤ x+2 : m ∈ A}`.

## Proof / evidence

The ledger records `THEOREM (corrected in rh47)` with source `rh47 truths.md §3` (`../rounds/rh47/truths.md` from the dictionary) and gives no proof. The capstone chapter records the same bound as [B4 — the support could be the positive-density witness (refuted)](tpp-dict-05-b4-support-positive-density-witness-refuted.md), where the corrected sparse bound is quoted as moving `S(x)` by `O(log log x) = o(x)`.

## Dependencies and related results

- [F4 — finite-prefix indeterminacy](tpp-dict-00-finite-prefix-indeterminacy.md) is the phenomenon this bound formalises for sparse modifications.
- [F1 — the trivial bound `|S| ≤ x`](tpp-dict-00-correlation-trivial-bound.md).

## Notes

- The ledger's own qualifier is preserved: the result is **corrected in rh47** (i.e. an earlier form of the bound was wrong, as the ledger's parenthetical indicates).
- The set `A` is not further specified in this row; no definition is invented here.
