# Proposition 2

**Kind:** Proposition
**Status:** PROVED (paper argument; 34 016 instances checked, 0 violations)
**Area:** xi-horn
**Source:** [`xi-horn/initial-segments.md`](../../xi-horn/initial-segments.md) — §3 "The staircase — how bad a gap can be, unconditionally"

## Statement

> **Proposition 2.** For any positive sequence and any m < n:
> if n ∈ E(d) then m ∈ E(d + n − m). Equivalently `D(m) ≤ D(n) + (n − m)`.

## Hypotheses and notation

- Any **positive sequence** a(n) > 0 — not necessarily the Taylor data of
  anything in the ambient class.
- E(d), D(n) as in [Proposition 1](xihorn-initial-segments-p1-three-equivalences.md) / [gorz-gap.md](../../xi-horn/gorz-gap.md) §1:
  `E(d) = { n ≥ 0 : J_{d,n} not hyperbolic }`, `D(n) = min { d : n ∈ E(d) }`.
- J_{d,n} hyperbolic means all its zeros are real.
- [gorz-gap L3(i)](xihorn-gorz-gap-l3-propagation.md): `J_{d+1,n−1}` not hyperbolic whenever
  `J_{d,n}` is not hyperbolic.

## Proof / evidence

The source's proof, verbatim: "The contrapositive of gorz-gap L3(i) says:
J_{d,n} not hyperbolic ⟹ J_{d+1,n−1} not hyperbolic. Apply it n − m times.
(This is the same n-fold iteration that proves gorz-gap's Corollaries 5 and 6;
Corollary 6 is the m = 0 case.) ∎"

Stress test recorded in §3 and §9: over 300 random positive rational sequences
(d ≤ 8, n ≤ 8; 4 339 hyperbolic and 17 261 non-hyperbolic instances, "so the
test is not vacuous"), **34 016 staircase instances, 0 violations**.

## Dependencies and related results

- [Lemma L3 (propagation)](xihorn-gorz-gap-l3-propagation.md) of [gorz-gap.md](../../xi-horn/gorz-gap.md); the source notes it is
  "gorz-gap's L3(i) iterated, which is Rolle's theorem".
- Sharpness: "The witnesses below make the bound sharp: each one saturates
  `D(m) = D(n) + (n − m)` with equality along its whole anti-diagonal" — see
  [the (z²−6z+13)e^z witness](xihorn-initial-segments-witness-z2-6z-13.md),
  [Witness A](xihorn-initial-segments-witness-a-order-half.md) and
  [Witness B](xihorn-initial-segments-witness-b-final-segment.md).
- Quoted in §8 as the one-sided fact that survives: "gaps are bounded by the
  staircase (Proposition 2) whatever happens".

## Notes

- "So a gap is a strictly bounded defect: a shift missing from E(d) below an
  exception joins at latest n − m degrees later, and E(d) always contains the
  45°-shadow `{n − k : n ∈ E(d−k)}`."
- The proposition is unconditional and about arbitrary positive sequences; it is
  the only result in the file that does not use membership in the class.
- The status's numerical qualifier records the §9 regression only; the proof
  itself is the n-fold iteration above.
