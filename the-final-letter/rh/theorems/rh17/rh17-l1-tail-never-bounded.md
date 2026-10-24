# L1 — the tail is never bounded, because it helps

**Kind:** Lemma
**Status:** PROVED (paper argument; every constant evaluated as an interval, not as a float)
**Area:** rh-html
**Source:** [`rh17.html`](../../html/rh17.html) — §2 "What stands between a float and a theorem", lemma L1

## Statement

> Each dropped term is c<sub>j</sub>cos(r<sub>j</sub>v) with c<sub>j</sub> = h·B(r<sub>j</sub>)²ψ̃(r<sub>j</sub>)/π, and a cosine kernel cos(r(u−w)) is positive semidefinite; a nonnegative combination of them is too. So the dropped tail is PSD on every grid the moment every c<sub>j</sub> ≥ 0, i.e. the moment ψ̃ ≥ 0 past the cut — and then E<sub>exact</sub> = E<sub>cert</sub> + (PSD) − D means certifying E<sub>cert</sub> certifies E<sub>exact</sub>. The sign fact is three elementary lines: for r ≥ 20, |z| = |¼+ir/2| ≥ 10, and Stirling with its corrections summed crudely gives Re ψ(z) ≥ ln|z| − C₀ with C₀ ≤ 0.0021, so

> (2)  ψ̃(r) ≥ ln(r/2π) − C₀ ≥ ln(10/π) − C₀ ≥ 1.1558   for every r ≥ 20,

## Hypotheses and notation

- ψ̃(r) = Re ψ(¼ + ir/2) − ln π, with ψ the digamma function.
- h is the trapezoid step, r<sub>j</sub> the trapezoid nodes, B the hat transform, R₀ the cut of the archimedean integral.
- The dropped tail is the infinite-trapezoid sum's tail past R₀; each dropped term is c<sub>j</sub>cos(r<sub>j</sub>v) with c<sub>j</sub> = h·B(r<sub>j</sub>)²ψ̃(r<sub>j</sub>)/π.
- E<sub>exact</sub> = E<sub>cert</sub> + (PSD) − D, where D is the aliasing error bounded by L2.
- C₀ ≤ 0.0021 is the crude Stirling correction constant; the estimate is "three elementary lines".

## Proof / evidence

The source states the argument in full: the honest worst-case bound on the tail past R₀ is ~10⁻⁸ per entry at the finest mesh, against a smallest eigenvalue of 10⁻¹³ — "hopeless by five orders" — so the tail is not bounded but dropped, being a nonnegative combination of cosine kernels and therefore PSD ("Bochner's easy direction", §6). The sign fact ψ̃ ≥ 1.1558 for r ≥ 20 is proved by the Stirling bound Re ψ(z) ≥ ln|z| − C₀ with C₀ ≤ 0.0021, and the constant is "evaluated as intervals, not floats". The source also reports the certified machine evidence: the ψ̃ table (64,001 points to r = 3200) has width ≤ 6.5×10⁻²¹.

## Dependencies and related results

- Uses the digamma Stirling asymptotics (NIST DLMF §5.11, cited in the source's references).
- Paired with [L2 — the aliasing bound](rh17-l2-aliasing-bound.md), which bounds the remaining term D.
- Feeds [T2 — exact sections](rh17-t2-exact-sections.md).
- Reused verbatim in rh19 §2 as "L1, that truncating the archimedean integral at R₀ removes a positive-definite tail (ψ̃ > 0 beyond r ≈ 2π)".

## Notes

- The density is negative only below r = 6.3, far below any cut; the source flags the placement of the cut as "a different and more delicate question" (the finest mesh is indefinite with the cut at 2.4 or 3.8 notches and recovers only past 5.7).
- The source is explicit that the lemma's value is that it refuses to bound the tail: with the naive tail bound in place of the PSD drop the radii would land at 10⁻⁸, five orders above the quantity they must not disturb.
- The source labels the constant 1.1558 as certified "for every r ≥ 20", not for all r ≥ 0.
