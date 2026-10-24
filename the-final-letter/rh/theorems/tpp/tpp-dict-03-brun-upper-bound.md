# THEOREM 2.5 (Brun; the upper bound)

**Kind:** Theorem
**Status:** CITED (literature; bibliographic details marked **unverified citation** in the source, Appendix A row Br1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §2.3

## Statement

> **THEOREM 2.5 (Brun; the upper bound).** `π₂(x) ≪ x/(log x)²`. More generally for an admissible `h = (h_1, …, h_k)`, `#{n ≤ x : n+h_i prime for all i} ≪_h x/(log x)^k`.

## Hypotheses and notation

- `π₂(x) := #{p ≤ x : p+2 prime}`.
- `h = (h_1, …, h_k)` is an admissible `k`-tuple (Definition 1.6); the implied constant may depend on `h` (subscript `_h`).
- `≪` is Vinogradov notation.

## Proof / evidence

- The source gives no proof; the status line reads: *Status:* THEOREM (Brun 1919/1920; also Selberg's `Λ²` sieve). *Source:* classical; bibliographic details are marked **unverified citation** in Appendix A (Br1).
- Appendix A row Br1: V. Brun, *La série `1/5 + 1/7 + 1/11 + 1/13 + …` est convergente ou finie*, Bull. Sci. Math. **43** (1919) 100–104, 124–128 — "**UNVERIFIED CITATION** … This file could not verify the bibliographic details. The *mathematical content* (`π₂(x) ≪ x/(log x)²`, i.e. Theorem 2.5) is standard and is treated as a theorem."
- The source's explanation ("Why the upper bound is unaffected by parity"): an upper bound needs only a non-negative majorant of the indicator of the primes, which Brun's and Selberg's weights supply; the parity obstruction enters the main term of the *lower*-bound problem, not an inequality in this direction.

## Dependencies and related results

- Definition 1.6 (admissible tuple).
- Restated as §4.1 row **T13** ("`π₂(x) ≪ x/(log x)²` (upper bound only) | THEOREM | V. Brun (1919/1920) | **unverified citation**").
- Companions: [`THEOREM 2.6`](tpp-dict-03-chen-p2.md) (the lower bound stops at `P₂`) and [`OPEN 2.7`](tpp-dict-03-twin-prime-open.md) (the missing lower bound).
- Restated in the §7 ledger row "2.5".

## Notes

- The mathematics is treated as a theorem, but the **bibliographic citation is unverified** by the source; that hedge is preserved here.
- Note that the source cites the `≪` bound only; no lower bound is claimed (see OPEN 2.7).
