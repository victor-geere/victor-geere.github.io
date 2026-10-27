# THEOREM (basic) — `Λ = μ * log` and PNT

**Kind:** Theorem
**Status:** CITED (literature; classical, no source line given in the file)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §1.1, the "THEOREM (basic)" following Definition 1.4

## Statement

> **THEOREM (basic).** `Λ = μ * log`, i.e. `Λ(n) = Σ_{d|n} μ(d) log(n/d)`, and `ψ(x) := Σ_{n≤x} Λ(n) = x + o(x)` **is** the prime number theorem (PNT).

## Hypotheses and notation

- `Λ(n) = log p` if `n = p^k` for a prime `p` and `k ≥ 1`, and `Λ(n) = 0` otherwise (Definition 1.4, von Mangoldt).
- `μ` is the Möbius function (Definition 1.3); `*` is Dirichlet convolution; `log` is the natural logarithm.
- `ψ(x) = Σ_{n≤x} Λ(n)` is the Chebyshev function; the second clause *identifies* `ψ(x) = x + o(x)` with PNT.

## Proof / evidence

- The source states this **without proof** and without a `Source:` line; this harvest records it as a classical result (CITED (literature)).

## Dependencies and related results

- Definition 1.3 (`μ`); Definition 1.4 (`Λ`).
- PNT is used as the equivalence partner of the one-point statement in THEOREM 3.3 (`Σ_{n≤x}λ(n) = o(x) ⟺ PNT`), THEOREM 2.2 and UNVERIFIED 2.3.
- Restated in this file's own §7 ledger under row "1.1 (basic)".

## Notes

- The source gives no proof and no attribution for this item; the status is deliberately not raised above CITED (literature), even though PNT is a proved theorem.
