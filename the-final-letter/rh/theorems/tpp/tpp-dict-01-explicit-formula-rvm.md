# (P5) The explicit formula (Riemann–von Mangoldt)

**Kind:** Theorem
**Status:** CITED (literature, classical; archimedean term mandatory)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) — §3 "Prerequisites: what the programme uses from analysis", "(P5)", line 95

## Statement

> **(P5) The explicit formula (Riemann–von Mangoldt).**  For a suitable test pair
> `(g, φ)` with `φ(t) = ∫ g(u)e^{itu}du` and `Φ(s) = φ((s−1/2)/i)`,
> ```
> Σ_ρ Φ(ρ) = Φ(1) + Φ(0) − Σ_{n≥2} (Λ(n)/√n)[g(log n)+g(−log n)] + (1/2π)∫_ℝ φ(t)Ψ(t)dt ,
> Ψ(t) = −log π + Re ψ(1/4 + it/2) .
> ```

The source appends, verbatim:

> *Status:* THEOREM (classical).  **The archimedean term is not optional** — an earlier
> draft omitted it and was REFUTED (rh45 §3.6, with the decomposition of the error).

## Hypotheses and notation

- `(g, φ)` is a **suitable test pair** (the source states no further regularity conditions): `φ(t) = ∫ g(u)e^{itu}du`, `Φ(s) = φ((s−1/2)/i)`.
- The sum `Σ_ρ` is over the non-trivial zeros `ρ` of `ζ`.
- `Λ` is the von Mangoldt function; `ψ` is the digamma function; the integral is over `ℝ`.
- `Ψ(t) = −log π + Re ψ(1/4 + it/2)` is the **archimedean** term, which the source stresses is not optional.

## Proof / evidence

The source gives no proof; it cites the formula as classical and records the refutation of the draft that omitted the archimedean term, quoted above.

## Dependencies and related results

- [(P1) Euler product and analytic continuation of `ζ`](tpp-dict-01-euler-product-and-continuation.md) and [(P6) Counting formula](tpp-dict-01-zero-counting-formula.md).
- Ledger row E5 of [`00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) records the same correction, harvested as [the Weil explicit formula needs the archimedean term](tpp-dict-00-weil-explicit-formula-archimedean-term.md); see also [the explicit formula with the archimedean term](tpp-dict-05-explicit-formula-archimedean-term.md).

## Notes

- Listed by the source under **§3 "Prerequisites"**; hence **CITED (literature)**.
- The source **explicitly records a refuted earlier draft** (rh45 §3.6): omitting the archimedean term (or the poles `2φ(i/2)`, as ledger row E5 phrases it) is wrong.
