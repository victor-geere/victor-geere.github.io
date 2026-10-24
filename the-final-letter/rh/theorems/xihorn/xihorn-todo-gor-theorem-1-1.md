# [GOR⁺] Theorem 1.1 — n ≥ c·e^d forces hyperbolicity

**Kind:** Theorem
**Status:** CITED (literature — Griffin–Ono–Rolen–Thorner–Tripp–Wagner, Adv. Math. 397 (2022) 108186)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §H3 "Find where the Turán criteria actually start to hold"

## Statement

> Both papers certify through Turán's Theorem III and **both bound the onset
> only asymptotically** — n ≥ c·e^d for J ([GOR⁺] Theorem 1.1, with **c never
> given**) and n/log²n ≥ d^{3/4}/2 for P ([O'S] Theorem 1.3, "d large"). Where
> it *actually* starts is a finite computation, and here it is.

## Hypotheses and notation

- The conclusion is hyperbolicity of J^{d,n} once n ≥ c·e^d, c a positive constant.
- **c is never given** in the source.
- The source's comparison: "the measured J onset grows *more slowly* than e^d over 8 ≤ d ≤ 16 — the implied c falls from 0.0171 to 0.0003 — so the exponential regime their proof needs has not begun at these degrees."

## Proof / evidence

The source states the bound without proof and without a value of c. It records that [GOR⁺]'s bound "cannot be compared at all: **no c is given**", and that the measured onsets (J: n₀ = 0 for d = 3–7, then 51, 129, 251, 434, 693, 1048, 1518, 2126, 2897 for d = 8…16) grow more slowly than e^d.

## Dependencies and related results

- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the measured table.
- [[O'S] Theorem 1.3](xihorn-todo-os-theorem-1-3.md) — the polynomial replacement.
- [[GOR⁺] Theorem 1.1 from H_track.md](xihorn-h-track-gor-theorem-1-1.md).

## Notes

- The source's framing of C1: "[GOR⁺] Theorem 1.1 makes the d-uniformity *effective* — J_{d,n} is hyperbolic once n ≥ c·e^d, with 0.9634 the exponent their proof yields" (the 0.9634 is stated in §C1 of the same file).
