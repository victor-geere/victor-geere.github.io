# The zero count

**Kind:** Claim
**Status:** VERIFIED (numerical, with caveat)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/README.md`](../../research/twin-prime-parity/rounds/rh044/README.md) — "The settled facts", fact 5, lines 89–91

## Statement

> **5. The zero count.**  `N(30) = 3`, `N(35) = 5`; the Riemann–von Mangoldt main term
> is `3.5647` at `T = 30`, so `N(30) − main = −0.5647 = S(30)/π`, inside the expected
> oscillation.

## Hypotheses and notation

- `N(T)` denotes the zero count, obtained via sign changes of the Riemann–Siegel `Z`-function.
- `S(T)` is the argument term of the Riemann–von Mangoldt formula; the main term is `(T/2π)log(T/2πe) + 7/8`.

## Proof / evidence

Numerical: the counts are obtained via `Z`-sign changes, and the difference from the main term at `T = 30` is identified with `S(30)/π`. The ledger adds the caveat that "the main term alone rounds to 4 and does **not** determine the count".

## Dependencies and related results

- [T5 — the zero count](tpp-rh044-truths-t5-zero-count.md) — the source's ledger version (T5); this file is its README restatement.
- [T4 — zero localisation](tpp-rh044-truths-t4-zero-localisation.md) / [README fact 4](tpp-rh044-readme-fact-4-zero-localisation.md) — the same `Z`-based bracketing.

## Notes

- Restatement of round **rh044** §5 (the ledger's T5); `N(35) = 5` agrees with the five zeros listed in [T4](tpp-rh044-truths-t4-zero-localisation.md).
- The caveat is carried in the ledger; the README states the counts more briefly without it.
