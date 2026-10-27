# Why no test vector helps

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §4 "Why no test vector helps", lines 495–528 and boxed table at lines 1047–1057

## Statement

> The plane-wave test vector a<sub>k</sub> = e<sup>ikθ</sup>/√n gives a*T<sub>n</sub>a = ∫K<sub>n</sub> dμ with K<sub>n</sub> the Fejér kernel, so its value can be read straight off the atoms with no matrix at all.

At every point with n < N<sub>eff</sub> the plane wave is within 1.10× of the true λ<sub>min</sub>; past N<sub>eff</sub> the gap opens to 3.5×10<sup>3</sup>. The nine grid points:

> window 0.48   mesh 0.48   n/N<sub>eff</sub> = 8.66   plane wave / λ<sub>min</sub> = 13.50×
> window 0.48   mesh 0.12   n/N<sub>eff</sub> = 8.66   plane wave / λ<sub>min</sub> = 3.14×
> window 0.48   mesh 0.03   n/N<sub>eff</sub> = 8.66   plane wave / λ<sub>min</sub> = 3478.82×
> window 0.12   mesh 0.48   n/N<sub>eff</sub> = 0.64   plane wave / λ<sub>min</sub> = 1.09×
> window 0.12   mesh 0.12   n/N<sub>eff</sub> = 0.64   plane wave / λ<sub>min</sub> = 1.10×
> window 0.12   mesh 0.03   n/N<sub>eff</sub> = 0.64   plane wave / λ<sub>min</sub> = 1.03×
> window 0.03   mesh 0.48   n/N<sub>eff</sub> = 0.13   plane wave / λ<sub>min</sub> = 1.07×
> window 0.03   mesh 0.12   n/N<sub>eff</sub> = 0.13   plane wave / λ<sub>min</sub> = 1.06×
> window 0.03   mesh 0.03   n/N<sub>eff</sub> = 0.13   plane wave / λ<sub>min</sub> = 1.01×

## Hypotheses and notation

- a is the plane-wave vector a<sub>k</sub> = e<sup>ikθ</sup>/√n, a unit vector; a*T<sub>n</sub>a is its Rayleigh quotient.
- K<sub>n</sub> is the Fejér kernel; ∫K<sub>n</sub>dμ is rh28's ceiling and [rh31-fejer-ceiling-dominates-lambda-min](../rh31/rh31-fejer-ceiling-dominates-lambda-min.md)'s object.
- N<sub>eff</sub> is §2's effective count.

## Proof / evidence

The identity a*T<sub>n</sub>a = ∫K<sub>n</sub>dμ is stated as the reason the value can be read off the atoms; the ratios are numerical. The source's reading: "below N<sub>eff</sub> there is no 7% to close, because the plane wave is already within a tenth of optimal and there is nothing for a cleverer vector to buy. Above N<sub>eff</sub> the loss is not a sidelobe, so shaping the sidelobes does not touch it."

## Dependencies and related results

- [rh29-taper-gap-at-depth](../rh29/rh29-taper-gap-at-depth.md) — the taper measurements this explains ("rh28 was optimising in the one regime where the optimum was already achieved").
- [rh30-collapse-in-n-over-neff](rh30-collapse-in-n-over-neff.md) — the N<sub>eff</sub> regime boundary.
- rh28 (the Fejér ceiling).

## Notes


- The source says this "settles rh28's (c) and rh29's (c) together".
- The statement is a numerical finding about the 200-point family, not a theorem about all windows.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
