# (8) The moment sequence is forced log-convex — Cauchy–Schwarz for ANY positive weight

**Kind:** Lemma
**Status:** PROVED (paper argument, elementary)
**Area:** xi-horn
**Source:** [`xi-horn/POSITIVITY.md`](../../xi-horn/POSITIVITY.md) — §2 "The trap: γ carries no information on its own", equation (8)

## Statement

> The first thing to try is log-concavity of γ, and it fails — necessarily.
>
> By Cauchy–Schwarz with f = uⁿ√Φ and g = u^{n+2}√Φ:
>
> ```
> γ(n+1)² ≤ γ(n)·γ(n+2)          for ANY positive weight whatsoever            (8)
> ```
>
> So the moment sequence of the horn is **forced log-convex**, and the observed Δ²log γ > 0 at every n up to 32 is not a fact about ζ. It is the same free positivity as rh3 §10's ⟨a,b⟩ = cos(π/6)|η|² — true of everything, therefore about nothing.
>
> This is worth stating loudly because it is the third time in this arc that an attractive inequality has turned out to be Cauchy–Schwarz in costume.

## Hypotheses and notation

- γ(n) = 4∫₀^∞ u^{2n}·Φ(u)du are the even moments of any positive weight Φ (the statement is for ANY positive weight whatsoever).
- Δ²log γ(n) = log γ(n+2) − 2 log γ(n+1) + log γ(n) is the second log-difference; log-convexity is Δ²log γ > 0.
- f = uⁿ√Φ and g = u^{n+2}√Φ are the Cauchy–Schwarz pair.

## Proof / evidence

The source gives the one-line proof: Cauchy–Schwarz with f = uⁿ√Φ, g = u^{n+2}√Φ, whose inner product is γ(n+1) and whose norms squared are γ(n) and γ(n+2). Since the argument uses only Φ > 0, it holds for any positive weight, so the observed log-convexity of γ carries no information about ζ in particular. The source notes Δ²log γ > 0 was observed at every n up to 32.

## Dependencies and related results

- The moment expansion defining γ(n): [xihorn-positivity-moment-expansion-of-xi.md](xihorn-positivity-moment-expansion-of-xi.md).
- The correct location of the content (log-concavity of c(n) = γ(n)/(2n)!): [xihorn-positivity-turan-inequality-for-xi.md](xihorn-positivity-turan-inequality-for-xi.md).
- The margin identity that compares the forced defect with the factorial gain: [xihorn-positivity-margin-identity.md](xihorn-positivity-margin-identity.md).

## Notes

- The source presents (8) as a trap rather than a result about ζ: it is stated as a lemma forced by Cauchy–Schwarz, with the conclusion that "the moment sequence of the horn is forced log-convex".
