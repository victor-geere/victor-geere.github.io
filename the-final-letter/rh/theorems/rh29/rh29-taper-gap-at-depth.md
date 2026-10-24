# 5 · (c) A better test vector

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh29.html`](../../html/rh29.html) — §5 "(c) A better test vector — where rh28 was right, and where it wasn't", lines 1652–1691 and boxed table at lines 1672–1676

## Statement

> For that purpose it fails. At v = 18 the Hann taper is 1.37 times λ<sub>min</sub> against the rectangle's 1.12, and the best of six tapers is a wide Gaussian at 1.11, which is nothing. At v = 18 the plane wave is already almost optimal and there is no 7% to win.
>
> But the idea is right in the place rh28 did not look.
>
> At v = 72 the rectangle is 23.4 times λ<sub>min</sub> and a half-cosine taper is 2.99, closing 91% of the gap the plane wave opens. The taper matters exactly where rh28 assumed it would not.

The boxed table:

> n = 151   v = 18   λ<sub>min</sub> = 8.55×10<sup>−2</sup>  —  rectangle 1.12   Hann 1.37   Hann² 1.61   half-cosine 1.18   Gaussian, 1.11   Gaussian, 1.60   nulls 2.9
> n = 301   v = 36   λ<sub>min</sub> = 2.90×10<sup>−3</sup>  —  rectangle 7.92   Hann 16.95   Hann² 28.94   half-cosine 7.48   Gaussian, 4.02   Gaussian, 28.43   nulls 35.8
> n = 601   v = 72   λ<sub>min</sub> = 4.87×10<sup>−4</sup>  —  rectangle 23.39   Hann 5.61   Hann² 12.03   half-cosine 2.99   Gaussian, 4.80   Gaussian, 14.88   nulls 65.0

## Hypotheses and notation

- The entries are Rayleigh-quotient ratios of a test vector to λ<sub>min</sub> at the stated section length n and depth v (all ratios are ×λ<sub>min</sub>).
- "nulls" is the polynomial that vanishes at the m heaviest atoms (m = 294 at v = 72).
- rh28's proposal being tested is a Hann-tapered plane wave to close the last 7% of the gap it saw at v = 18.

## Proof / evidence

Numerical. The source's mechanism for the failure of the null-placing polynomial: "Forcing the nulls costs a coefficient vector whose norm is all in the corners, and the Rayleigh quotient pays for it." Its stated diagnosis: "the ceiling is not limited by the test vector's sidelobes, which is what a taper fixes, but by the norm it costs to be small on the atoms."

## Dependencies and related results

- [rh29-depth-curve-past-one-decade](rh29-depth-curve-past-one-decade.md) — the λ<sub>min</sub> values against which these ratios are taken.
- rh28 (the Fejér ceiling and the Hann-taper proposal), [rh30-plane-wave-near-optimal-below-neff](../rh30/rh30-plane-wave-near-optimal-below-neff.md) — rh30 §4 later explains why no taper helps below N<sub>eff</sub>.

## Notes


- The source states a negative and a positive in the same section: the Hann taper fails at the depth rh28 proposed it for, and the half-cosine taper succeeds at a depth rh28 did not consider.
- The source records that the null-placing vector, "the vector that ought to be ideal", is 65 times λ<sub>min</sub> at v = 72, worse than the plane wave by a factor of three.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
