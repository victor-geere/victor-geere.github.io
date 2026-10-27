# The Schur margin separates the processes

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh16.html`](../../html/rh16.html) — §4 "Which readings were ever about ζ"

## Statement

> The Schur margin 1 − max|ρ<sub>k</sub>| on the same four. Here they separate: ζ 0.6231, GUE-like 0.6166, rigid 0.5914, Poisson 0.5229 — a spread of 0.100 against a quadrature error bar of 5×10<sup>−8</sup>, i.e. two million times larger than the noise. This reading is about the process.

and:

> ζ's margin sits 0.0064 from the GUE-like process and 0.100 from Poisson — sixteen times nearer the one than the other, and nearer GUE than the rigid lattice too (0.0316).

## Hypotheses and notation

- The Schur margin is 1 − max|ρ<sub>k</sub>| of the reflection-coefficient sequence of rh15's recursion, run on ζ and on the three surrogates of the same mean density (1/2π)log(r/2π): Poisson, GUE-like (Wigner surmise) and perfectly rigid (equal gaps).
- The quadrature error bar on the margin is 5×10<sup>−8</sup> (the margin moves by at most 2.8×10<sup>−6</sup> between independent quadratures in rh15 §5).

## Proof / evidence

The source reports the four margins: ζ 0.6231, GUE-like 0.6166, rigid 0.5914, Poisson 0.5229, with the spread 0.100 against the error bar 5×10<sup>−8</sup>. It reads the result as Montgomery's pair correlation and Odlyzko's statistics "visible here as a single scalar read off a prime-built recursion", and qualifies it honestly: "This is a weak test of universality, not a new one — one number, one realisation of each surrogate, no error bars on the surrogates themselves — but it is the right sign, and it is the cheapest form the statement has taken in this arc."

## Dependencies and related results

- [The notch law cannot tell which process it is looking at](rh16-notch-law-process-blind.md) — the companion reading that does not separate the processes.
- [RH ⟺ the Schur sequence never leaves the open unit disc](../rh15/rh15-rh-equivalent-schur-sequence.md) — the margin's source.
- [The widest positivity certificate](../rh15/rh15-widest-positivity-certificate.md) — where the margin 0.301754 at the finest mesh is certified.

## Notes


- One realisation per surrogate, no error bars on the surrogates; the source calls it a weak test of universality and does not claim more.
- The comparison is between a single scalar per process, not a distributional test.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
