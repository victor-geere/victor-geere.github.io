# Theorem 11 (greedy optimality, new)

**Kind:** Theorem
**Status:** PROVED (paper argument; case analysis over Theorem 7 and Theorem 8)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §4 "The census theorem: exactly which targets are writable"

## Statement

> For these sequences the greedy's limit is exactly
>
> ```
> s_G(x) = max { s ∈ S : s ≤ x },
> ```
>
> so the stall residual is `x − max{s ∈ S : s ≤ x}`.

## Hypotheses and notation

- "These sequences" = the positive half-series `a_k = (2k)^{−p}` (and the corresponding budget/alphabet sequences of §2) with the greedy rule of §0.
- `S` is the set of sub-sums (reachable set).
- `s_G(x)` is the limit of the greedy at target `x`; the stall residual is `x` minus the greedy's limit.
- `V_{n+1}` denotes the value function of the tail problem from index `n+1` (as used in the source's proof).

## Proof / evidence

The source gives the complete proof, quoted verbatim:

> **PROVED.** At every index
> `n` one of the two cases holds: if `h(n) ≤ 0` then `T_{n+1} ≤ a_n`, so taking
> `a_n` is optimal (`V_{n+1}(x) ≤ T_{n+1} ≤ a_n ≤ a_n + V_{n+1}(x − a_n)`); if
> `h(n) > 0` then by Theorem 7 every `h(j)` with `j > n` is positive, so the tail
> from `n+1` is complete by Theorem 8 and taking `a_n` is again optimal
> (`Icc_subset_union_shift`). The two cases cover every `n`, so descending
> induction from `n_min` proves optimality everywhere. ∎

## Dependencies and related results

- [Theorem 7 (unimodality)](tpp-rh42-truths-theorem-7-unimodality.md) and [Theorem 8 (completeness thresholds, T10, T13)](tpp-rh42-truths-theorem-8-completeness-thresholds.md); the Lean lemma `Icc_subset_union_shift` in [`lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean).
- Handoff ledger row T7 (§11) records the consequence "reachable ⊆ budget; above it, residual → `x − P(p)`" as PROVED (Theorem 6 + 11) — harvested as [T7 — reachable ⊆ budget](tpp-rh42-truths-t7-reachable-subset-of-budget.md).
- Greedy optimality is **not** a general fact; the counterexample is [R4 — the greedy is optimal for a decreasing sequence](tpp-rh42-truths-r4-greedy-not-optimal.md).

## Notes

- The source states explicitly, and immediately after, the refutation of the general claim: "Greedy optimality is *not* a general fact: on the decreasing sequence `(1/2, 3/10, 3/10)` at `x = 3/5` the greedy takes `1/2`, while `3/10 + 3/10 = 3/5` is the maximum sub-sum `≤ x`. It is Theorem 7 that rescues the `p`-series. **VERIFIED** exactly, `reachable.py` §1." That refutation is harvested as R4.
