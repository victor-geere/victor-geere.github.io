# Brown's criterion: sub-sums fill `[0,A]` iff `a_k ≤ T_{k+1}` ∀k

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. C — the ζ budgets and the reachable set", row C5, line 67

## Statement

The ledger row, verbatim:

> | C5 | **Brown's criterion**: sub-sums fill `[0,A]` iff `a_k ≤ T_{k+1}` ∀k | THEOREM | rh42 §3 |

The row is a one-line statement; the precise quantifiers (non-increasing positive `a_1 ≥ a_2 ≥ … > 0`, `A = Σa_n < ∞`, `T_n = Σ_{k≥n}a_k`, sub-sums over arbitrary subsets) are set out in the round and in the sister chapters, harvested as [Theorem 2.1 (Brown's criterion)](tpp-dict-04-brown-criterion.md) and [Brown's criterion](tpp-dict-05-brown-criterion.md).

## Hypotheses and notation

- `a_1 ≥ a_2 ≥ … > 0` with `A = Σ a_n < ∞` (as stated in the sister chapter).
- `T_n = Σ_{k≥n} a_k` is the tail sum from `n`; the condition is `a_k ≤ T_{k+1}` for **every** `k`.
- "Sub-sums fill `[0, A]`" means every `y ∈ [0,A]` is a sum over some subset of the `a_k`.

## Proof / evidence

The ledger records `THEOREM` with source `rh42 §3` and gives no proof itself. The zeta-relations chapter gives a proof, harvested in full at [Theorem 2.1 (Brown's criterion)](tpp-dict-04-brown-criterion.md); the round's statement is [Theorem 6 (Brown's criterion)](tpp-rh42-truths-theorem-6-brown-criterion.md).

## Dependencies and related results

- Governs the completeness thresholds: [C6](tpp-dict-00-positive-half-complete-threshold.md), [C7](tpp-dict-00-negative-half-complete-threshold.md), and the censused reachable set [C8](tpp-dict-00-censused-reachable-set.md).
- The criterion is classical (named for Brown); the ledger nevertheless attributes its proof to the programme's round **rh42 §3**, where the one-step lemmas are machine-checked.

## Notes

- Ledger entry restating round **rh42** (§3).
- A related *refuted* one-step form ("a non-increasing positive sequence whose first term is at most the sum of the rest is complete") is recorded in the sister chapter and harvested as [R3 — a₁ ≤ A − a₁ ⟹ the sub-sums fill [0,A]](tpp-rh42-truths-r3-single-condition-not-sufficient.md).
