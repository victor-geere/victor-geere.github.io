# Theorem 5.1 (Weil form — with the archimedean term)

**Kind:** Theorem
**Status:** CITED (literature, classical explicit formula; source also NUMERICAL, ≥20 digits)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §5 "The explicit formula (rh45)", "Theorem 5.1 (Weil form — with the archimedean term)", line 153

## Statement

> **Theorem 5.1 (Weil form — with the archimedean term).**  For `g` even with
> `φ(t) = ∫g(u)e^{itu}du` and `Φ(s) = φ((s−1/2)/i)`,
> ```
> Σ_ρ Φ(ρ) = Φ(1) + Φ(0) − Σ_{n≥2}(Λ(n)/√n)[g(log n)+g(−log n)] + (1/2π)∫_ℝ φ(t)Ψ(t)dt ,
> Ψ(t) = −log π + Re ψ(1/4+it/2) ,     Φ(1)+Φ(0) = 2φ(i/2) for even g .
> ```

## Hypotheses and notation

- `g` is even; `φ(t) = ∫g(u)e^{itu}du` is its Fourier transform; `Φ(s) = φ((s−1/2)/i)`.
- The sum `Σ_ρ` runs over the nontrivial zeros `ρ` of `ζ`; `Λ` is the von Mangoldt function.
- `Ψ(t) = −log π + Re ψ(1/4+it/2)` is the archimedean term, with `ψ` the digamma function.
- For even `g`, `Φ(1)+Φ(0) = 2φ(i/2)`.

## Proof / evidence

The source's status line, verbatim:

> *Status:* THEOREM (classical) + NUMERICAL (≥20 digits on four kernels:
> residuals `1.6·10⁻⁴⁴`, `9.6·10⁻⁴⁶`, `−1.1·10⁻⁶³`).

The source labels the formula classical and gives no proof; it reports numerical residuals on four kernels (three residual figures are printed) at ≥20 digits.

## Dependencies and related results

- [Theorem 5.2 (counting)](tpp-dict-04-zero-counting.md) and [Theorem 5.3 (zeros from the formula, not from the partial sum)](tpp-dict-04-zeros-from-the-formula.md) — the rest of §5.

## Notes

- Ledger entry for the **rh45** round (section headed "(rh45)").
- The source records draft errors as **REFUTED**, quoted verbatim: omitting the archimedean term (size `−1.196346718078`) and using pole arguments `F(1)+F(0)` instead of `2φ(i/2)` (size `−0.659766246421`); "the first Cauchy test had both, and a divergent prime side." These refuted forms are the source's own corrections and are not harvested as theorems.
- The source says "≥20 digits on four kernels" but prints three residual values; the discrepancy is reproduced rather than repaired.
