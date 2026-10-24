# (7) The moment expansion — ξ(½ + z) = Σ_{n≥0} γ(n)·z^{2n}/(2n)!, with γ(n) > 0 for every n

**Kind:** Proposition
**Status:** PROVED (paper argument; verified against an independent ξ at 60 digits)
**Area:** xi-horn
**Source:** [`xi-horn/POSITIVITY.md`](../../xi-horn/POSITIVITY.md) — §1 "The move", equation (7)

## Statement

> Expand the transform instead of evaluating it. From (2) of the README,
>
> ```
> ξ(½ + z) = Σ_{n≥0}  γ(n) · z^{2n} / (2n)! ,      γ(n) = 4∫₀^∞ u^{2n}·Φ(u) du   (7)
> ```
>
> γ(n) > 0 for every *n*, because Φ > 0. Verified against an independent ξ:
>
> ```
>   z      Σ γ(n)z^{2n}/(2n)!     ξ(½+z)              rel. error
>   0.1    0.49723565025592       0.49723565025592    1.6e-61
>   0.9    0.50650585657646       0.50650585657646    0
>   2.0    0.54509420701213       0.54509420701213    0
>   4.0    0.71618708371159       0.71618708371159    2.3e-61
> ```
>
> (34 terms; γ(0) = ξ(½) = 0.4971207782.)
>
> **γ(n) is the sequence of even moments of the horn's profile about the throat.** Everything from here is a statement about that sequence — i.e. about the silhouette — and *t* never reappears.

## Hypotheses and notation

- ξ(s) = ½·s(s−1)·π^{−s/2}·Γ(s/2)·ζ(s) is the completed zeta function (README §2); Ξ(t) = ξ(½ + it).
- Φ is the horn's weight, even and positive on ℝ.
- γ(n) = 4∫₀^∞ u^{2n}·Φ(u)du are the even moments of the horn's profile about the throat (u = 0).
- The Taylor expansion of ξ about ½ carries only even powers because Φ is even.
- The verification uses 34 terms at 60 decimal digits; γ(0) = ξ(½) = 0.4971207782.

## Proof / evidence

The source obtains (7) by expanding the Fourier-transform representation (README (2)) in powers of z = it, using the evenness of Φ, so that only even moments γ(n) appear. Positivity γ(n) > 0 is immediate from Φ > 0. The source reports verification against an independent ξ at z = 0.1, 0.9, 2.0, 4.0 with relative errors 1.6e−61, 0, 0, 2.3e−61.

## Dependencies and related results

- The normalisation ξ(½ + it) = 2∫_{−∞}^{∞}Φ(u)e^{itu}du: [xihorn-readme-xi-as-fourier-transform.md](xihorn-readme-xi-as-fourier-transform.md).
- The forced log-convexity of the same sequence: [xihorn-positivity-moment-sequence-forced-log-convex.md](xihorn-positivity-moment-sequence-forced-log-convex.md).
- The Mellin continuation γ(n) = Γ_Φ(2n): [xihorn-continuation-continuation-and-pole-string.md](xihorn-continuation-continuation-and-pole-string.md).

## Notes

- Equation (7) restates README (2) in the Taylor-expansion form; only the even powers survive because Φ is even.
- The source's §7 reconstruction notes that the moments themselves still want extended precision, for the honest reason that γ(n) at n ≈ 34 is a 10⁻⁷ quantity extracted from an integrand spanning 30 orders.
