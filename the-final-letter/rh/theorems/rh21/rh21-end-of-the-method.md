# The end of the method

**Kind:** Theorem
**Status:** VERIFIED (numerical, from the measured sieve cost of 4.3 µs per gear and the two-term row radius (3); evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh21.html`](../../html/rh21.html) — §4 "The radius, and what the wall really is", theorem box "The end of the method"

## Statement

> With the arithmetic repaired — both terms of (3), not just the logarithm — the certified horizon at Δ = 0.24 is limited by the prime comb and by nothing else, at <b>v ≈ 26.5 for a day of computation and 30.1 for a month</b>. The arithmetic ceiling at that point is 49.8, comfortably out of reach. rh19's successor (ii) is therefore retired as a wrong diagnosis: the row radius is worth fixing, it is worth about 30 in v, and after that the method ends at the sieve.

## Hypotheses and notation

- The row radius per unit gear mass has two terms, (3): rad/M<sub>k</sub> = (2/3)·δu + Δ·δw, δu the logarithm's error and δw the hat arithmetic's; in rh19's lane both are 1.87×10⁻¹⁶, a ratio of 0.9972.
- Lanes and their arithmetic ceilings: bare log, double hat → v = 17.5; two-double log (rh19) → 20.0; two-double log + double-double hat → 20.9; double-double throughout → 49.8; exact Decimal-40 → 113.4.
- Sieve cost at horizon v: every prime power below e<sup>v+2Δ</sup>, at the measured 4.3 µs per gear — 2 hours at v = 24, 98 hours at v = 28, 677 hours at v = 30.
- Δ = 0.24.

## Proof / evidence

The two error terms of the row radius are measured and found all but equal, so "a perfect logarithm caps at v = 20.9 against rh19's 20.0"; fixing both terms of (3) reaches v = 49.8 (113.4 in exact arithmetic). The sieve cost is then extrapolated from the measured throughput: a day reaches v = 26.5, a month 30.1. The document's 32 named checks in 57 s include "the balance of the two radius terms" and "the sieve crossover".

## Dependencies and related results

- Retires rh19's successor (ii) as a wrong diagnosis; touches rh19's [ceiling](../rh19/rh19-horizon-ceiling.md).
- Contrasts with [the floor power law](rh21-floor-power-law.md), which retires rh19's successor (iii) as a mis-stated question.
- Sets up [the window barrier](rh21-window-barrier.md), the successor rh20 raised.

## Notes


- The source lists this box under §4 and its Figure 2 states the same limit as "the end of the method is the comb, at v ≈ 27–30 — not the arithmetic rh19 blamed".
- Status: the box is in the source's theorem style, but its content rests on a measured per-gear cost and on the two-term radius model (3); it is recorded here as VERIFIED (numerical) rather than PROVED.
- The source's successor list after this: only the window search remains — "not 'make the arithmetic better' but 'make the window better'".

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
