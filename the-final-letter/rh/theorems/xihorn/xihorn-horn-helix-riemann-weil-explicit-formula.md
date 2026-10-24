# The Riemann–Weil explicit formula — the ledger that joins the horn and the prime helix

**Kind:** Theorem
**Status:** CITED (literature; rh10 §1's convention, re-verified here independently of rh10 — difference 1.3×10⁻⁷ with 120 zeros)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix.md`](../../xi-horn/horn-helix.md) — §8 "The ledger that joins them: the explicit formula", equation (7); §13 dictionary, term "two columns of one ledger"

## Statement

> The one identity that pairs them is Riemann–Weil, in [rh10](../../html/rh10.html) §1's convention: for even *h* with Fourier partner *g*,
>
> ```
> Σ_ρ h(γ_ρ) = h(i/2) + h(−i/2)
>              + (1/2π)∫ h(r)·[Re ψ(¼ + ir/2) − ln π] dr
>              − 2 Σ_{n≥2} Λ(n)/√n · g(log n)                                (7)
> ```
>
> The last term is §6's radius column, sampled by *g* at the prime-helix depths. The left side is the horn's closure points, sampled by *h*.

## Hypotheses and notation

- *h* is even, with Fourier partner *g* (h(r) = ∫g(u)e^{iru}du in the adelic file's convention; the source writes "for even *h* with Fourier partner *g*").
- The sum on the left is over the non-trivial zeros ρ, written with ordinates γ_ρ.
- Λ is the von Mangoldt function; ψ is the digamma function; the archimedean integral is against Re ψ(¼ + ir/2) − ln π.
- Verified in the source with h(r) = e^{−(r−t₀)²/2w²} + e^{−(r+t₀)²/2w²}, w = 0.7, t₀ = 20, and 120 zeros.

## Proof / evidence

This is rh10 §1's identity, quoted and not re-derived here; the source says "is the Riemann–Weil explicit formula, which [rh10](../../html/rh10.html) §1 already implements and verifies". It is then "Verified here independently of rh10": zeros side 0.688847411525; pole term h(±i/2) = 3.4e−179; archimedean term 0.646283211198; prime side −2ΣΛ(n)g(log n)/√n = 0.042564069146; arithmetic total 0.688847280344; difference 1.3e−7 (120 zeros + quadrature). §12 lists the same rows; §8 notes "rh10 reports 3×10⁻⁶ for the same identity at three test functions; this is the same computation done from the horn's side of the vocabulary."

## Dependencies and related results

- rh10 §1 (the explicit formula as an instrument) → previously harvested as [rh10-riemann-weil-explicit-formula.md](../rh10/rh10-riemann-weil-explicit-formula.md).
- The prime-side column is §6's radius column Λ(n)/√n.
- Adelic per-place form: [the local Weil term at a finite place](xihorn-horn-helix-adelic-local-weil-term-finite-place.md) and [the archimedean local kernel](xihorn-horn-helix-adelic-archimedean-local-kernel.md) (horn-helix-adelic.md (11)–(15)).
- §11.1: "(7) verifies it; it does not verify positivity of it" — the RH obstruction is unchanged.

## Notes

- The source states plainly that nothing here is new mathematics: "§8 is the Riemann–Weil explicit formula, which rh10 §1 already implements and verifies."
- The verification is numerical and at one test function (w = 0.7, t₀ = 20, 120 zeros); the residual 1.3e−7 is attributed by the source to "120 zeros + quadrature".
- The source's framing of (7) is "two *columns of one ledger*, and the ledger is the only place they meet" — the horn and the prime helix cannot be compared pointwise ([closure and pole](xihorn-horn-helix-closure-and-pole.md)).
