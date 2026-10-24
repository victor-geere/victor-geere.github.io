# The detection law: D(0) = ⌊β^{−2}⌋ + 1

**Kind:** Claim
**Status:** PROVED (paper argument, exact collapse of (13) in the model; VERIFIED numerically/exactly — K = 1 … 64 measured against the closed form, exact agreement)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §7.3 "The detection law — [GOR⁺] Remark (3), as a formula", equation (14)

## Statement

> Take b = 2 − 1/K, c = 1 in §7.1: q₀ has a conjugate pair approaching the double root −1 as K grows, with |Δ₀| < 4 so ν = 1 for every K. Writing β for the imaginary part of that pair, (13) collapses to
>
> ```
> D(0) = ⌊ β^{−2} ⌋ + 1                                                       (14)
> ```
>
> exactly.

## Hypotheses and notation

- The model is the [exactly solvable family](xihorn-gorz-gap-toy-model-closed-form.md) G(z) = (z² + b z + c)·e^z with b = 2 − 1/K, c = 1; q₀(z) = z² + bz + c.
- β = Im(root) is the imaginary part of the model's conjugate pair; ν = 1 for every K since |Δ₀| < 4; D(n) := min{ d : n ∈ E(d) }, so D(0) is the witness degree of shift 0.
- ⌊·⌋ is the floor.

## Proof / evidence

The source derives it as the collapse of (13) in this parameter slice, then checks it by brute force against the closed form:

```
   K       β = Im(root)     D(0) measured   D(0) from (14)
    1      0.866025               2               2
    2      0.661438               3               3
    4      0.484123               5               5
    8      0.347985               9               9
   16      0.248039              17              17
   32      0.176085              33              33
   64      0.124756              65              65
   10²     9.987e−02            n/a            101      (β^{−2} = 100.2506)
   10³     3.162e−02            n/a           1001      (β^{−2} = 1000.2501)
   10⁶     1.000e−03            n/a        1000001      (β^{−2} = 1000000.25)
```

The source's reading: "**The count stays 1; the degree needed to see it is unbounded.** That is the exact shape of the GORZ gap: uniformity in the number of exceptions coexists with unboundedness in the degree that exhibits them, and it is why Theorem 3 costs nothing and ν costs everything. It is also [GOR⁺] Remark (3) — 'ultimately quite inefficient at detecting zeros' — with an exponent: detection degree ≍ (distance off the line)^{−2}."

Run the other way: "In this model 'hyperbolic through degree D' forces β ≤ D^{−1/2}; at [GOR⁺]'s D = 9 × 10²⁴ that is β ≤ 3.3 × 10⁻¹³."

## Dependencies and related results

- Equations (11)–(13) of [the exactly solvable model](xihorn-gorz-gap-toy-model-closed-form.md); ν and D(n) as in [Theorem 2](xihorn-gorz-gap-t2-initial-segment.md) and [Theorem 3](xihorn-gorz-gap-t3-uniformity-constant.md).
- [GOR⁺] Remark (3) is the remark it formalizes; [GOR⁺] Corollary 1.3 ([harvested](xihorn-gorz-gap-gorplus-corollary-13.md)) supplies the D = 9 × 10²⁴ figure quoted.

## Notes

- The source's own limit on the claim: "**For ξ no such converse is available** — that is precisely what [GOR⁺] Remark (3) says is unlikely — so this is the model's lesson about the shape of the obstruction, not a statement about ζ."
- In the measured rows K = 1 … 64 the comparison is exact rational arithmetic; for K = 10², 10³, 10⁶ the source reports "n/a" for the measured value and only the closed form (with β^{−2} printed alongside).
