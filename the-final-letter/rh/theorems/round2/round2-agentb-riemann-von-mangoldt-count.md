# Riemann–von Mangoldt: N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + small

**Kind:** Theorem
**Status:** CITED (literature; checked numerically at T = 300)
**Area:** workspace
**Source:** [`round2_agentB.md`](../../research/various/round2_agentB.md) — §(ii) "EXPLICIT FORMULA — PARTIALLY VERIFIED, NORMALIZATION OPEN", lines 30–32

## Statement

> Verified: Riemann–von Mangoldt N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + small.
>   T=300: exact N = 138 (zetazero), main = 137.7119, S = +0.2881. NO PRIMES appear on the main
>   term; the prime information is entirely in S(T).

## Hypotheses and notation

- N(T) is the number of nontrivial zeros of ζ(s) with 0 < Im ρ ≤ T (counting multiplicity per the source's usage).
- S(T) is the argument/error term S(T) = (1/π) arg ζ(1/2 + iT) in the standard decomposition; the source writes it additively as "+ S(T) + small".
- "zetazero" is the numerical source of the exact count N = 138 at T = 300.

## Proof / evidence

The source lists the formula under "Verified" and reports the numerical check at T = 300: exact
count 138, main term 137.7119, S = +0.2881, with the remainder "small". It emphasises that the prime
information is carried entirely by S(T) and not by the main term.

## Dependencies and related results

- [round2-agentb-log-zeta-versus-zeta-prime](round2-agentb-log-zeta-versus-zeta-prime.md) — the companion statement that the explicit formula's prime side matches −ζ′/ζ, not log ζ.

## Notes

- Status CITED (literature) with the source's numerical check recorded: this is the classical
  Riemann–von Mangoldt count; the workspace verified it at T = 300 but did not prove it.
- The same section records that the archimedean normalization of the full explicit-formula identity
  was NOT verified and is "Reported as OPEN, not claimed"; that open item is deliberately not
  harvested.
