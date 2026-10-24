# Witness A: (z² − 8z + 73)·cosh(√z)

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, exact Sturm counts, d ≤ 14, n ≤ 22; ν window-certified)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §5 "The order-½ witnesses, and the final-segment law"

## Statement

> **Witness A: (z² − 8z + 73)·cosh(√z)**, zeros 4 ± i√57.
>
> ```
> E(1) = ∅
> E(2) = {1}               <-- 0 ∉ E(2), 1 ∈ E(2): a gap at degree 2
> E(d) = {0, 1}            3 ≤ d ≤ 14        D(0) = 3,  D(1) = 2
>
> pair of f^(n):  4 ± 7.55i  →  1.63 ± 4.77i  →  all zeros in window real
>                 (n = 0)        (n = 1)           (n ≥ 2, so ν = 2)
> ```
>
> The Turán inequality fails **only at n = 1** — an isolated Turán failure
> strictly after a Turán success, which no initial-segment picture permits.

## Hypotheses and notation

- Order **½ exactly** — "the same order as ξ's F" — with positive Taylor data
  `a(m) = m!·(1/(2m−4)! + b/(2m−2)! + c/(2m)!)`, here b = −8, c = 73
  (positive for all m: checked exactly for m ≤ 59, and for larger m the leading
  term dominates — |b|/((2m−2)(2m−3)) + c-term < 1 already at m = 4 resp.
  m = 6).
- Zeros `4 ± i√57`; E(d), D(n), ν as in [Proposition 1](xihorn-initial-segments-p1-three-equivalences.md) / [gorz-gap.md](../../xi-horn/gorz-gap.md) §1.
- An objection from [gorz-gap.md](../../xi-horn/gorz-gap.md) §6 is what this witness answers: "ξ's F has order ½,
  and witnesses should live in the same house. They do."

## Proof / evidence

"Tables are exact Sturm counts over d ≤ 14, n ≤ 22; the non-real pair of each
f^(n) is tracked by root-finding an 80-term truncation at 40 digits inside
|z| < 400."

Number (§9): pair of f^(n) 4 ± 7.5498i → 1.6335 ± 4.7734i → real (ν = 2).

## Dependencies and related results

- Companion witness [Witness B](xihorn-initial-segments-witness-b-final-segment.md); the e^z witness
  [the minimal witness: (z² − 6z + 13)·e^z](xihorn-initial-segments-witness-z2-6z-13.md).
- [Proposition 4](xihorn-initial-segments-p4-turan-forces-tame-half.md) is the contrasting positive result: in the
  quadratic model Turán does repair the property; this witness shows the
  raw sequence-level failure mode is real.
- The source's §8 summary: "positivity + genus alone ⟹ nothing: §4–§5
  witnesses."

## Notes

- **ν here is window-certified, not proved.** §11 item 4: "The gaps themselves
  are unconditional (each cell is an exact Sturm count); the statements 'E(d)
  stabilises at {0,1} resp. {0,1,2,3}' rest on d ≤ 14, n ≤ 22 plus the tracked
  death of the pair inside |z| < 400. A defect beyond the window is unseen, not
  absent." (Same honesty clause as TODO G4.)
- The source's reading: the Turán inequality failing only at n = 1 is "an
  isolated Turán failure strictly after a Turán success, which no
  initial-segment picture permits."
- The final-segment law of §5 is a scan observation made on Witness B's pattern
  and is explicitly **not** harvested: "A scan observation, not a theorem"
  (§11 item 3: "The final-segment law is a scan, not a theorem").
