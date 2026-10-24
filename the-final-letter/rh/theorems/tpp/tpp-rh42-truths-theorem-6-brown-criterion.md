# Theorem 6 (Brown's criterion, T10/T13 core)

**Kind:** Theorem
**Status:** PROVED (paper argument; two one-step lemmas machine-checked in Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §3 "The exact reachable set: Brown's criterion"

## Statement

> Let `a_1 ≥ a_2 ≥ … > 0` with `A = Σ a_n < ∞`, `T_n = Σ_{k≥n} a_k`, and let `S`
> be the set of sub-sums. Then
>
> ```
> S = [0, A]   ⟺   a_n ≤ T_{n+1}   for every n.
> ```

## Hypotheses and notation

- `a_1 ≥ a_2 ≥ … > 0` — a non-increasing positive sequence.
- `A = Σ a_n < ∞`; `T_n = Σ_{k≥n} a_k` is the tail sum from `n` (so `T_{n+1} = T_n − a_n`).
- `S` is the set of sub-sums, over *arbitrary* subsets of `ℕ` — infinite subsets included, "which is exactly what a greedy that never stops taking terms produces."
- `[0, A]` is the closed real interval.

## Proof / evidence

The source gives the complete proof, quoted verbatim:

> **PROVED.** *(⟸)* Run the greedy at `y ∈ [0,A]`; its residual `r_k` decreases to
> `r ≥ 0`. If `r > 0`, choose `m` with `a_k < r` for all `k ≥ m` (possible since
> `a_k → 0`); then `a_k < r ≤ r_k`, so every term from `m` on is taken. Let `k₁` be
> the largest skipped index below `m` — one exists, since otherwise the taken sum
> would already be `A ≥ y` and `r ≤ 0`. All indices above `k₁` are taken, so
> `r_{k₁} = r + T_{k₁+1} > T_{k₁+1}`, while the skip at `k₁` says
> `a_{k₁} > r_{k₁}`; hence `a_{k₁} > T_{k₁+1}`, contradicting the hypothesis.
> *(⟹)* If `a_k > T_{k+1}`, any sub-sum `s < a_k` avoids `a_k` and all earlier
> indices (they are `≥ a_k`), so `s ≤ T_{k+1}`: the interval `(T_{k+1}, a_k)` is a
> gap. ∎

Machine-checked components: the two one-step lemmas are in [`lean/Rh42/Reachable.lean`](../../research/twin-prime-parity/rounds/rh42/lean/Rh42/Reachable.lean) (`Icc_subset_union_shift`, `gap_of_subset_Icc`), "together with the finite sub-sum operator and its gap lemma (`gap_lemma`)."

## Dependencies and related results

- Used by Theorem 8 (completeness thresholds) and Theorem 10 (census); the finite form `subSums_cons_disjoint` is cited in Theorem 10.
- Related handoff ledger row R1 (§11): "write out the reachable-set theory" — target, now DONE via `reachable.py`, `Reachable.lean`, Theorem 6–11.
- The refuted single-condition form is [R3 — a₁ ≤ A − a₁ ⟹ the sub-sums fill [0, A]](tpp-rh42-truths-r3-single-condition-not-sufficient.md).

## Notes

- The source states a correction to the handoff, quoted verbatim: "The handoff's §5.5 attributes Brown's criterion in the form *"a non-increasing positive sequence whose first term is at most the sum of the rest is complete"*. That single condition is **not** sufficient — see **Theorem 12 (REFUTED)** below — and the correct statement needs **every** `n`, which is what makes the `p`-series work."
- The cross-reference "**Theorem 12 (REFUTED)**" does **not** match the numbering of this file: Theorem 12 here is the `p = 2` structure theorem. The refutation actually intended is the refuted row R3 of §9, machine-checked as `single_condition_not_sufficient` in `Reachable.lean`. This file records the discrepancy and does not repair the source's text.
