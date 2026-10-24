# Conjecture 3.1 (Chowla, 1965; `k`-point form)

**Kind:** Claim
**Status:** OPEN (for every `k ≥ 2`; the case `k = 1` is PNT, a theorem)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.1

## Statement

> **Conjecture 3.1 (Chowla, 1965; `k`-point form).** For any `k ≥ 1` and any distinct non-negative integers `h_1, …, h_k`,

```
Σ_{n≤x} λ(n+h_1) λ(n+h_2) ⋯ λ(n+h_k) = o(x)      (x → ∞) .
```

> Equivalently (see 3.4), for every sign pattern `ε ∈ {±1}^k`, `#{n ≤ x : (λ(n+h_1), …, λ(n+h_k)) = ε} = x/2^k + o(x)`.

The file's status line: *Status:* **OPEN** for every `k ≥ 2`. The general `k = 1` case is PNT. The stronger statement with **affine** forms `a_i n + b_i`, `a_i b_j ≠ a_j b_i` is the standard formulation (verified in the abstracts of [Tao, arXiv:1509.05422](https://arxiv.org/abs/1509.05422) and [Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628)).

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2).
- `h_1, …, h_k` are **distinct non-negative integers**; `ε` ranges over the `2^k` sign patterns in `{±1}^k`.
- The affine generalisation uses forms `a_i n + b_i` with `a_i b_j ≠ a_j b_i`.

## Proof / evidence

- The source states this as a conjecture with **no proof**; the `k = 1` case is [THEOREM 3.3](tpp-dict-03-one-point-chowla-iff-pnt.md) (equivalent to PNT).
- The affine formulation is recorded as verified in the abstracts of Tao, arXiv:1509.05422 and arXiv:1605.04628.

## Dependencies and related results

- [`THEOREM 3.3`](tpp-dict-03-one-point-chowla-iff-pnt.md) (`k = 1`, equivalent to PNT); [`OPEN 3.4`](tpp-dict-03-two-point-chowla-open.md) (`k = 2`, `h = (0,2)`); OPEN 4.2 (the full conjecture among the open statements); [`THEOREM 3.5`](tpp-dict-03-two-point-equidistribution.md) (the equivalent equidistribution form at `k = 2`).
- The log-averaged versions that **are** theorems: [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md), [THEOREM 3.9](tpp-dict-03-tao-teravainen-log-all-orders.md).
- Restated in the §7 ledger row "3.1".

## Notes

- Harvested with Status **OPEN** exactly as the source records it: the source marks the conjecture open for every `k ≥ 2` and does not claim any partial result beyond the `k = 1` case.
- The random-sign model that predicts the `o(x)` size is separately labelled HEURISTIC 3.2 and is not part of this conjecture.
