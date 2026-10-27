# Theorem 2.1 (Brown's criterion)

**Kind:** Theorem
**Status:** PROVED (paper argument; one-step lemmas machine-checked in `Rh42/Reachable.lean`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §2 "The exact reachable set (rh42)", "Theorem 2.1 (Brown's criterion)", line 41

## Statement

> **Theorem 2.1 (Brown's criterion).**  Let `a_1 ≥ a_2 ≥ … > 0` with `A = Σa_n < ∞`,
> `T_n = Σ_{k≥n}a_k`, and `S` the set of sub-sums over arbitrary subsets.  Then
> ```
> S = [0, A]   ⟺   a_n ≤ T_{n+1}   for every n .
> ```

## Hypotheses and notation

- `a_1 ≥ a_2 ≥ … > 0` — a non-increasing positive sequence.
- `A = Σ a_n < ∞`; `T_n = Σ_{k≥n} a_k` is the tail sum from `n`.
- `S` is the set of sub-sums over **arbitrary subsets**; `[0, A]` is the closed real interval.

## Proof / evidence

The source gives the proof verbatim:

> *Proof (⟸).*  Run the greedy at `y ∈ [0,A]`; its residual decreases to `r ≥ 0`.  If
> `r > 0`, choose `m` with `a_k < r` for all `k ≥ m`.  Every term from `m` on is taken.
> Let `k₁` be the largest skipped index below `m` (it exists).  Then
> `r_{k₁} = r + T_{k₁+1} > T_{k₁+1}` while the skip gives `a_{k₁} > r_{k₁}`, so
> `a_{k₁} > T_{k₁+1}` — contradiction.
> *(⟹).*  If `a_k > T_{k+1}`, any sub-sum `s < a_k` avoids `a_k` and all earlier
> indices, so `s ≤ T_{k+1}`: the interval `(T_{k+1}, a_k)` is a gap.  ∎

The source's status line reads:

> *Status:* THEOREM (one-step lemmas machine-checked: `Rh42/Reachable.lean`).

## Dependencies and related results

- Governs the "completeness" claims of [Theorem 2.2 (completeness thresholds)](tpp-dict-04-completeness-thresholds.md) and the interval count of [Theorem 2.3 (census)](tpp-dict-04-census-of-reachable-set.md).
- §5 of [`02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) restates the criterion: "the sub-sums of `a_1 ≥ a_2 ≥ … > 0` fill `[0, A]` iff `a_k ≤ T_{k+1}` for every `k`".
- The same **rh42** theorem is recorded in the existing harvest file [Theorem 6 (Brown's criterion)](tpp-rh42-truths-theorem-6-brown-criterion.md).

## Notes

- Ledger entry for the **rh42** round (the section is headed "(rh42)").
- The source appends a **Warning (recorded)**, quoted verbatim: the "one-step" form "*a non-increasing positive sequence whose first term is at most the sum of the rest is complete*" is **REFUTED** (`(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1 = 1/2` and misses `1/5`; `single_condition_not_sufficient`). That refutation is a separate labelled warning, not a numbered theorem, and is recorded here rather than harvested as its own file; the existing harvest file [R3 — a₁ ≤ A − a₁ ⟹ the sub-sums fill [0, A]](tpp-rh42-truths-r3-single-condition-not-sufficient.md) covers it.
