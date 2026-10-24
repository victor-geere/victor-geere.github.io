# The lift hits every station (ϑ̃(n) ≡ ϑ<sub>n</sub> mod 2π)

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`rh3/README.md`](../../rh3/README.md) — §5 "The ledger: the uniform-pitch lift", lines 138–139

## Statement

> ϑ̃(n) ≡ ϑ<sub>n</sub> (mod 2π) for every *n*: the lift hits every station exactly, and differs from the bare angle only by *c* whole turns per level — the **carries**.

## Hypotheses and notation

- ϑ̃ is the uniform-pitch lift ϑ̃(x) = (x − 1)·p − t·log x (eq. (10)), with p = A + c·τ, A = π (half-turns on) or 0 (off), and c = max(0, ⌈(t − A)/τ⌉) (eq. (10)).
- ϑ<sub>n</sub> = (n−1)π − t·log n is the bare lab angle of the *a*-vertex on circle *n* (eq. (8)); it is defined only mod 2π by the clock.
- τ = 2π; *c* is the number of whole turns per level, called the "carry".

## Proof / evidence

The source states this without proof. It is immediate from (10): at x = n the difference ϑ̃(n) − ϑ<sub>n</sub> = (n − 1)(A + c·τ) − (n − 1)π equals (n − 1)·cτ when A = π and (n − 1)·(cτ − π) when A = 0 — the source asserts the mod-2π agreement in both cases but writes out only the half-turns-on arithmetic.

## Dependencies and related results

- [rh3-readme-one-way-lift-rate](rh3-readme-one-way-lift-rate.md) — the rate ϑ̃′(x) = p − t/x, strictly increasing and ≥ 0 everywhere, which is why the lift is a lift at all.
- The station spacing along the thread is the ledger δ<sub>n</sub> = ϑ̃(n)/τ (eq. (12)), read as "carries per level".

## Notes

- The source's own framing: "a station has no winding memory", so the whole-turn freedom is fixed once for the whole thread; (8) alone is defined only mod 2π. The statement is the bookkeeping that makes the drawn thread a one-way bolt rather than a per-segment choice.
- δ is never reduced mod 2π in the figure (it prints δ<sub>n</sub> under each of the first ten gears, `LEDGER = 10`).
