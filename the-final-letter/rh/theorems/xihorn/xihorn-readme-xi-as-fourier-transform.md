# (2) ξ(½ + it) = 2∫_{−∞}^{∞} Φ(u)·e^{itu} du = 4∫₀^∞ Φ(u)·cos(ut) du

**Kind:** Theorem
**Status:** CITED (literature; 1859 material, verified numerically to ten digits)
**Area:** xi-horn
**Source:** [`xi-horn/README.md`](../../xi-horn/README.md) — §2 "Normalisation", equation (2)

## Statement

> With ξ(s) = ½·s(s−1)·π^{−s/2}·Γ(s/2)·ζ(s) and Φ as in (1):
>
> ```
> ξ(½ + it) = 2 ∫_{−∞}^{∞} Φ(u)·e^{itu} du = 4 ∫₀^{∞} Φ(u)·cos(ut) du        (2)
> ```
>
> The imaginary part vanishes identically by evenness, so the left side is real for real *t*. Verified against an independent ξ at *t* = 0, 5, 17 to ten digits.
>
> The constant 2 is convention-dependent (sources differ on whether the factor sits in Φ or in ξ). The geometry does not care; fix one convention and state it, as here.
>
> Write **Ξ(t) = ξ(½ + it)** throughout.

## Hypotheses and notation

- ξ(s) = ½·s(s−1)·π^{−s/2}·Γ(s/2)·ζ(s) is the completed zeta function in this convention.
- Φ is the horn's weight, even and positive on ℝ (equation (1)).
- t is real; the imaginary part of the integral vanishes identically by evenness, so ξ(½ + it) is real for real t.
- The factor 2 is convention-dependent; the source fixes it here.
- Ξ(t) = ξ(½ + it) is the notation used throughout the directory.

## Proof / evidence

The source states the Fourier representation (2) as "1859 material" (its §0) and reports verification against an independent ξ at t = 0, 5, 17 to ten digits; the reduction from the two-sided to the one-sided cosine integral uses the evenness of Φ. No proof is reproduced.

## Dependencies and related results

- Φ's evenness (the theta functional equation): [xihorn-readme-phi-even-is-theta-functional-equation.md](xihorn-readme-phi-even-is-theta-functional-equation.md).
- The Taylor/moment expansion derived from (2): [xihorn-positivity-moment-expansion-of-xi.md](xihorn-positivity-moment-expansion-of-xi.md).
- The two threads whose sum reproduces Ξ: [xihorn-readme-two-threads-and-xi-real-part.md](xihorn-readme-two-threads-and-xi-real-part.md).

## Notes

- The source's §0 disclaimer is explicit: "**Nothing here is new mathematics.** The object is Riemann's Ξ as the Fourier transform of Φ, which is 1859 material".
- The numerical verification is to ten digits, as the source states; it is not a certified enclosure.
