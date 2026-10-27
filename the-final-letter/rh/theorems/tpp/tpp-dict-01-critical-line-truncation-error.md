# (P3) The Dirichlet series on the critical line

**Kind:** Theorem
**Status:** CITED (literature; local verification cited)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §3 "Prerequisites: what the programme uses from analysis", "(P3)", line 85

## Statement

> **(P3) The Dirichlet series on the critical line.**  For `σ = 1/2` the series converges
> conditionally; the partial sums satisfy `|S_N(1/2+it) − ζ(1/2+it)| = √N/|s−1| + O(1)`,
> so a sharp truncation *always* has error `Θ(√N)` at the zero.  *Verified:* rh43 §7.6,
> with the constant `1/√(1/4+t²)` (an earlier draft's `1/√(2t)` is REFUTED, rh044 §0 R1).

## Hypotheses and notation

- `s = σ + it` with `σ = 1/2`; `S_N` is the partial sum `Σ_{n≤N} n^{−s}` (at `σ = 1/2` the series converges only conditionally).
- The error is measured against `ζ(1/2+it)`; the leading term is `√N/|s−1|`.
- `1/√(1/4+t²)` is the source's value of the sharp constant; it equals `1/|s−1|` at `σ = 1/2`.

## Proof / evidence

The source gives no proof of its own; it records the status and the local verifications, verbatim:

> *Verified:* rh43 §7.6, with the constant `1/√(1/4+t²)` (an earlier draft's `1/√(2t)`
> is REFUTED, rh044 §0 R1).

## Dependencies and related results

- [(P1) Euler product and analytic continuation of `ζ`](tpp-dict-01-euler-product-and-continuation.md).
- The refutation of the earlier constant `1/√(2t)` is recorded in ledger row E2 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md), harvested as [the sharp constant](tpp-dict-00-sharp-constant-refuted.md); the same result appears as [the sharp error at a zero](tpp-dict-05-sharp-error-at-a-zero.md).

## Notes

- Listed by the source under **§3 "Prerequisites"**; hence **CITED (literature)**, with the local verification recorded in the qualifier and here.
- The source **explicitly contradicts an earlier draft**: the constant `1/√(2t)` is REFUTED (rh044 §0 R1) and `1/√(1/4+t²)` is the sharp one.
