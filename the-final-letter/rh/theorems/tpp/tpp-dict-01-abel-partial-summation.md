# (P4) Abel/partial summation

**Kind:** Theorem
**Status:** CITED (literature; one-directional only)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §3 "Prerequisites: what the programme uses from analysis", "(P4)", line 90

## Statement

> **(P4) Abel/partial summation.**  If `D(s) = Σ a_n n^{−s}` converges for `σ > β` then
> `Σ_{n≤x} a_n = O(x^{β+ε})`.  *Status:* THEOREM (one-directional only; the converse
> fails — that failure is exactly why the correlation's Euler-product route is dead,
> rh46 §5).

## Hypotheses and notation

- `D(s) = Σ a_n n^{−s}` is a Dirichlet series converging for `σ > β`.
- The conclusion is a bound on the partial sums `Σ_{n≤x} a_n`, of the form `O(x^{β+ε})` (for every `ε > 0`, as the source's `ε` indicates).
- The source stresses the implication is **one-directional**.

## Proof / evidence

The source gives no proof; it states the result with the status line quoted above.

## Dependencies and related results

- The failure of the converse is the recorded reason the correlation `Σ λ(n)λ(n+2)` has no Euler-product route: ledger row F3 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md), harvested as [the correlation is not multiplicative](tpp-dict-00-correlation-not-multiplicative.md).
- The source's §5 item "No route from the correlation `Σλ(n)λ(n+2)` to `ζ`" invokes precisely this failure.

## Notes

- Listed by the source under **§3 "Prerequisites"**; hence **CITED (literature)**.
- The *failure of the converse* is what the programme actually uses; the source states the positive direction only.
