# OPEN 2.7 — the twin prime lower bound

**Kind:** Claim
**Status:** OPEN
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §2.3

## Statement

> **OPEN 2.7.** `π₂(x) ≫ x/(log x)²`, equivalently `π₂(x) → ∞`, equivalently the twin prime conjecture. The gap between `P₂` (theorem, 2.6) and `P₁ = prime` (open) is *exactly* the parity barrier: the sieve-with-an-extra-condition technique ("Chen's switch") moves the obstruction up by one prime factor and no further. In general, sieve methods give lower bounds for `P_r` for `r ≥ 2` and never for `r = 1`.

The file's status line: *Status:* **OPEN**.

## Hypotheses and notation

- `π₂(x) := #{p ≤ x : p+2 prime}`.
- `P₂` = integers with at most two prime factors (with multiplicity); `P₁` = the primes.
- `≫` is Vinogradov notation.

## Proof / evidence

- The source states this as **OPEN**: no proof is known.
- The source presents the equivalence with the quantitative twin prime conjecture (Conjecture 1.8 with `h = (0,2)`), and cites [`THEOREM 2.6`](tpp-dict-03-chen-p2.md) as the theorem at `P₂` and [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) as the reason bounded-depth sieves cannot reach `P₁`.

## Dependencies and related results

- [`THEOREM 2.5`](tpp-dict-03-brun-upper-bound.md) (upper bound); [`THEOREM 2.6`](tpp-dict-03-chen-p2.md) (lower bound at `P₂`); [`THEOREM 2.1`](tpp-dict-03-selberg-parity-principle.md) (the parity no-go for the method class); [`THEOREM 5.1`](tpp-dict-03-exact-relation-twin-primes.md) (relation to `S(x) = o(x)`); [`THEOREM 5.2`](tpp-dict-03-no-bounded-depth-sieve-lower-bound.md).
- Also listed in OPEN 4.2; the same quantitative conjecture appears in [Conjecture 1.8](tpp-dict-03-hardy-littlewood-dickson-k-tuples.md).
- Restated in the §7 ledger row "2.7".

## Notes

- Harvested because the source labels it as a numbered statement of the file; the status is exactly the source's **OPEN**, and no part of it is to be read as proved.
- The surrounding paragraph ("the gap … is *exactly* the parity barrier") is the source's own reading and is reproduced without strengthening.
