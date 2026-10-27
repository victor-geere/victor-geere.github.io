# Witness B: (z² − 60z + 1681)·cosh(√z)

**Kind:** Claim
**Status:** CHECKED (exhaustive finite, exact Sturm counts, d ≤ 14, n ≤ 22; ν window-certified)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §5 "The order-½ witnesses, and the final-segment law"

## Statement

> **Witness B: (z² − 60z + 1681)·cosh(√z)**, zeros 30 ± i√781.
>
> ```
> E(2) = {3}          E(3) = {2, 3}          E(4) = {1, 2, 3}
> E(d) = {0, 1, 2, 3}   5 ≤ d ≤ 14
>
> D(n) = 5, 4, 3, 2    strictly decreasing
>
> pair of f^(n):  30 ± 27.9i → 21.5 ± 22.1i → 12.4 ± 16.0i → 2.28 ± 8.49i → real
>                 (n = 0)      (n = 1)        (n = 2)         (n = 3)        (ν = 4)
> ```
>
> The pair marches toward the origin at roughly nine units per derivative and
> dies just past it; detectability improves monotonically along the walk.

The file's introduction states the same content as: "**(z² − 60z + 1681)·cosh(√z)**
has witness degrees D(n) = 5, 4, 3, 2: strictly **decreasing**, the exact mirror
of the conjectured monotone picture, saturating the unconditional staircase
bound of §3 with equality at every step."

## Hypotheses and notation

- Order ½ exactly, positive Taylor data
  `a(m) = m!·(1/(2m−4)! + b/(2m−2)! + c/(2m)!)`, here b = −60, c = 1681, the
  same order-½ family as [Witness A](xihorn-initial-segments-witness-a-order-half.md).
- Zeros `30 ± i√781`; E(d), D(n), ν as in [Proposition 1](xihorn-initial-segments-p1-three-equivalences.md) / [gorz-gap.md](../../xi-horn/gorz-gap.md) §1.
- The staircase bound of [Proposition 2](xihorn-initial-segments-p2-staircase.md): `D(m) ≤ D(n) + (n − m)`;
  here it is attained with equality at every step.

## Proof / evidence

"Tables are exact Sturm counts over d ≤ 14, n ≤ 22; the non-real pair of each
f^(n) is tracked by root-finding an 80-term truncation at 40 digits inside
|z| < 400."

Number (§9): pair of f^(n)
30±27.95i → 21.45±22.10i → 12.44±16.00i → 2.28±8.49i → real.

Independent cross-check: "The exact tables and the independently computed
trajectory agree on E_∞ = [0, ν) — Theorem 2 cross-checked two ways."

## Dependencies and related results

- [Proposition 2 (the staircase)](xihorn-initial-segments-p2-staircase.md) — saturated with equality here.
- [Witness A](xihorn-initial-segments-witness-a-order-half.md) and the e^z witness
  [the minimal witness: (z² − 6z + 13)·e^z](xihorn-initial-segments-witness-z2-6z-13.md).
- [gorz-gap Theorem 2](xihorn-gorz-gap-t2-initial-segment.md) (E_∞ = [0, ν)) is the result cross-checked two ways
  by this witness.

## Notes

- **ν here is window-certified, not proved.** §11 item 4: the gaps are
  unconditional exact Sturm counts, but the stabilisation statement
  ("E(d) = {0, 1, 2, 3}") rests on d ≤ 14, n ≤ 22 plus the tracked death of the
  pair inside |z| < 400; "a zero beyond that window is unseen, not absent."
- Witness B's pattern is what prompts the **final-segment law** of §5, which the
  source explicitly declines to call a theorem — "A scan observation, not a
  theorem" (§11 item 3) — and which is therefore **not harvested here**. The law
  reads `E(d) = { ν−d+1, …, ν−1 } for 2 ≤ d ≤ ν, i.e. D(n) = ν − n + 1` at the
  positivity binding, scanned at s = 30, 40, 60, 90 (ν = 4, 4, 5, 6); it
  "deforms away from the binding — at s = 40, c = 2961 the tables show
  E(2) = {3} with ν = 5 and an uptick D(4) = 3 > D(3) = 2" — and it is "a
  right-half-plane phenomenon: the left-plane instance (z² + 2z + 2)cosh√z of
  gorz-gap §7.2 has D(0) = 3 = ν + 2, breaking it by one."
