# C<sub>n</sub> ≥ λ<sub>min</sub> always

**Kind:** Proposition
**Status:** PROVED (paper argument, one line)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §5 "The law that survives", lines 1022–1035

## Statement

> The natural quantification is the emptiest-arc density: take the Fejér kernel K<sub>n</sub> — a bump of width ~2π/n — and slide it around the circle:
>
> C<sub>n</sub>(μ) = min<sub>θ</sub> ∫ K<sub>n</sub>(θ − t) dμ(t).
>
> C<sub>n</sub> ≥ λ<sub>min</sub> always, by one line: the plane-wave vector localised at the emptiest θ is a unit test vector whose Rayleigh quotient is exactly the integral (rh28's ceiling, rh30 §4's plane wave — the arc has been computing this object since two documents before it knew what it was).

## Hypotheses and notation

- K<sub>n</sub> is the Fejér kernel, a bump of width ~2π/n; μ is rh29's atomic measure.
- C<sub>n</sub>(μ) is the emptiest-arc density: the minimum over θ of the Fejér-smeared measure.
- The plane-wave vector localised at the emptiest θ is a unit test vector; its Rayleigh quotient is ∫K<sub>n</sub>(θ−t)dμ(t), and λ<sub>min</sub> is the infimum of Rayleigh quotients over unit vectors.

## Proof / evidence

The source gives the one-line proof: the localised plane-wave vector is a unit test vector whose Rayleigh quotient equals the integral, and λ<sub>min</sub> is a minimum over unit vectors, so C<sub>n</sub> ≥ λ<sub>min</sub>. The identity a*T<sub>n</sub>a = ∫K<sub>n</sub>dμ for the plane wave is stated in rh30 §4.

## Dependencies and related results

- [rh30-plane-wave-near-optimal-below-neff](../rh30/rh30-plane-wave-near-optimal-below-neff.md) — the plane wave whose Rayleigh quotient is the integral.
- [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md) — the measured tightness of this inequality.
- [rh31-localisation-conjecture](rh31-localisation-conjecture.md) — §8(a)'s target, λ<sub>min</sub> ≥ c·C<sub>n</sub>(μ).

## Notes

- Only the inequality C<sub>n</sub> ≥ λ<sub>min</sub> is proved here; the source's content claim is about how tight it is, which is [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md).
- The source notes the object itself is older than its name: "rh28's ceiling, rh30 §4's plane wave — the arc has been computing this object since two documents before it knew what it was."
