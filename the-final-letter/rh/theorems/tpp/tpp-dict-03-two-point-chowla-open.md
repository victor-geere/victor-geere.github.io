# OPEN 3.4 (the target)

**Kind:** Claim
**Status:** OPEN
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §3.3

## Statement

> **OPEN 3.4 (the target).** With

```
S(x) := Σ_{n≤x} λ(n) λ(n+2) ,        (★)   S(x) = o(x) .
```

The file's status line: *Status:* **OPEN.** This is the `k = 2`, `h = (0,2)` case of Chowla 3.1. It is the statement rh46 was asked to establish; rh46 established that it is open, and no progress on it is claimed here.

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2).
- `S(x) := Σ_{n≤x} λ(n) λ(n+2)`; `(★)` is the source's label for this target statement.
- `o(x)` is as `x → ∞`.

## Proof / evidence

- The source states this as **OPEN**: no proof is given or claimed.
- The source records (as OPEN 4.1, the same statement restated) that "No proof is known, unconditionally or conditionally on RH in the elementary Dirichlet-series sense. It is **not** implied by any averaged statement in the literature (§4.3), and it is **not** decided by any finite computation (§6, `F4`)."
- By [`THEOREM 4.4`](tpp-dict-03-log-averaged-no-implication.md) the log-averaged theorems do not imply it; by [`THEOREM 4.6`](tpp-dict-03-almost-all-insufficient.md) the almost-all-shifts and almost-all-scales statements do not imply it; by [`F4`](tpp-dict-03-f4-finite-prefix-indeterminacy.md) no finite computation can decide it.

## Dependencies and related results

- [Conjecture 3.1](tpp-dict-03-chowla-conjecture.md) (`k = 2`, `h = (0,2)` case); [THEOREM 3.5](tpp-dict-03-two-point-equidistribution.md) (the equivalent equidistribution form); [THEOREM 5.1](tpp-dict-03-exact-relation-twin-primes.md) (its exact relation to twin primes).
- [THEOREM 3.8](tpp-dict-03-tao-log-two-point-chowla.md) and [THEOREM 3.9](tpp-dict-03-tao-teravainen-log-all-orders.md) are the log-averaged theorems that come closest.
- Restatements to note: **OPEN 4.1** (the same statement, "the central statement") and the §7 ledger rows "3.4" and "4.1".

## Notes

- Harvested with Status **OPEN** exactly as the source records it. The formula `(★)` is reproduced verbatim.
- The source's own disclaimer: "This is the `k = 2`, `h = (0,2)` case of Chowla 3.1. It is the statement rh46 was asked to establish; rh46 established that it is open, and no progress on it is claimed here."
