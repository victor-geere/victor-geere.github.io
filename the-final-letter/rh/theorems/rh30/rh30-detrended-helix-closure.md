# The detrended helix: closure becomes balance

**Kind:** Proposition
**Status:** PROVED (paper argument; verified at every level and numerically)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §8 "The detrended helix", lines 1467–1493 and 1579–1588

## Statement

> Detrend them. Put every origin on one axis, gear n at depth z = n−1, one unit apart, the unit being r<sub>1</sub> = 1. The marked point on gear n is then the step vector itself, at planar angle
>
> θ<sub>n</sub> = −t log n + (n−1)π,
>
> the torsion plus the half-turn that presents aaaa… as aAaA…, so that r<sub>n</sub>e<sup>iθ<sub>n</sub></sup> = (−1)<sup>n−1</sup>n<sup>−s</sup> exactly — verified at every level. And then
>
> ∑<sub>n</sub> r<sub>n</sub>e<sup>iθ<sub>n</sub></sup> = ∑<sub>n</sub> (−1)<sup>n−1</sup>n<sup>−s</sup> = η(s).

and

> Closure becomes balance. In the offset picture "the helix closes" is a statement about a path returning to 0. Detrended it is ∑ r<sub>n</sub>e<sup>iθ<sub>n</sub></sup> = 0: the marked points balance about the axis. Same equation, different kind of object — a condition on a point set carried on coaxial circles rather than on a path.

## Hypotheses and notation

- Gear n has radius r<sub>n</sub> = n−½ and sits at depth z = n−1, one unit apart, the unit being r<sub>1</sub> = 1.
- s is the complex variable; t = Im s is the torsion parameter (t = γ<sub>1</sub> in the figure's example).
- η is the Dirichlet eta function.

## Proof / evidence

Paper argument (the angle identity is exact: r<sub>n</sub>e<sup>iθ<sub>n</sub></sup> = (−1)<sup>n−1</sup>n<sup>−s</sup>, "verified at every level"). The source's numerical record: at s = ½ + iγ<sub>1</sub> the sum vanishes to 10<sup>−14</sup> by accelerated summation; taken the honest slow way, 200 000 gears leave 1.1×10<sup>−3</sup>, the series being only conditionally convergent. The construction is also checked to 10<sup>−14</sup> in the sense that gear n's marked point is gear n+1's origin in the offset picture.

## Dependencies and related results

- [rh30-prime-side-row-positive-definite](rh30-prime-side-row-positive-definite.md) — §9's consequence drawn from this picture.
- rh13 onward (the arc's documents about point sets carried on coaxial circles), rh4 (the gears' construction).

## Notes

- The source calls §8 "a construction note, and it turns out to carry a consequence"; the identity itself is the algebraic content, the pictures are the same twelve level terms.
- The source also records that the origins in the offset picture "wander": projecting the twelve origins onto any direction, "the best of 720 directions puts only 7 of the eleven steps in the same sense."
