# T14 — Friedlander–Iwaniec: `X² + Y⁴` captures its primes

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.1, row T14 of the "What is proved" table

## Statement

> **T14** — infinitely many primes of the form `x²+y⁴` — a **parity-breaking** asymptotic-sieve theorem.

The row's status and citation: THEOREM | [Friedlander–Iwaniec, *The polynomial `X²+Y⁴` captures its primes*, Ann. of Math. **148** (1998) 945–1040](http://www.emis.mi.sanu.ac.rs/emis/journals/Annals/148_3/4.html) | **verified** (journal listing: title, authors, volume, pages, 1998; MSC keywords include *"parity; bilinear form hypothesis; asymptotic sieve"*).

## Hypotheses and notation

- `x`, `y` range over the integers; `x² + y⁴` is the polynomial whose prime values are counted.
- "Captures its primes" means the asymptotic sieve yields an asymptotic formula for the number of primes represented.
- The relevant bilinear structure is the factorisation `x² + y⁴ = (x + iy²)(x − iy²)` in the Gaussian integers `ℤ[i]` (as used in HEURISTIC 5.4).

## Proof / evidence

- No proof is given; the row cites Friedlander–Iwaniec, Ann. of Math. **148** (1998) 945–1040, marked **verified** in Appendix A row FI1 ("EMIS journal listing (title, authors, volume, pages, year; MSC keywords include 'parity; bilinear form hypothesis; asymptotic sieve')").
- The source describes it as "the classical demonstration that parity *can* be broken" (HEURISTIC 5.4).

## Dependencies and related results

- [T15 (the asymptotic sieve)](tpp-dict-03-t15-asymptotic-sieve.md) and [T16 (BFI large moduli)](tpp-dict-03-t16-bfi-large-moduli.md) are the machinery; [HEURISTIC 5.4](tpp-dict-03-missing-input-heuristic.md) presents T14 as the prototype route across a parity barrier.
- Contrast: for the twin primes the two linear forms `n` and `n+2` admit no such factorisation ([HEURISTIC 5.4](tpp-dict-03-missing-input-heuristic.md); [THEOREM 2.1](tpp-dict-03-selberg-parity-principle.md)).

## Notes

- The source labels this a "**parity-breaking** asymptotic-sieve theorem" — it shows a parity barrier can be crossed with an appropriate bilinear input, not that the twin-prime parity barrier is crossed.
- The link given is the EMIS journal listing, as in the source.
