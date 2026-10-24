# A bigger cut is the same theorem with a longer sum

**Kind:** Corollary
**Status:** PROVED (paper argument, from L1 and L2); VERIFIED (numerical, dropped weight 3.12×10⁻³ at R = 600 → 7.63×10⁻⁶ at 4800, 409×)
**Area:** rh-html
**Source:** [`rh27a.html`](../../html/rh27a.html) — §2 "(a) A bigger cut needs no new error analysis"

## Statement

> So the two together: **the quadrature rule is certified once, for every J; the truncation is free, for every J; and a bigger cut is the same theorem with a longer sum.** It costs arithmetic and nothing else. That is checked and not asserted — every one of the 96,001 interval nodes of the AT table is verified nonnegative past r₊, which is L1 made concrete on the object the certificate actually uses.

The measurements that accompany it:

> What a longer sum buys is arithmetic, and it is measured rather than bounded: the weight still dropped at v = 0 falls from 3.12×10⁻³ at R = 600 to 7.63×10⁻⁶ at 4800 — 409× — while the aliasing factor sits 15 orders below the smallest of them at every cut tried. The quadrature was never the constraint.

## Hypotheses and notation

- Two things must be justified separately: the rule (trapezoid instead of the integral) and the truncation (stopping at J instead of infinity).
- L1 (ψ̃ ≥ 0 past r₊ = 6.289836) certifies the truncation for every J; L2 (aliasing factor 2.96×10⁻²² at h = 0.05) certifies the rule on the whole half-line.
- "The weight still dropped at v = 0" is the archimedean weight discarded past the cut, relative to C<sub>h</sub>(0).
- J = 96,000 in rh27a's certificates (as against 12,000 before).

## Proof / evidence

The corollary is drawn in the paper argument: L1 makes the dropped tail a positive semidefinite Toeplitz form, so truncating lowers λ<sub>min</sub> and any J gives a valid lower bound, a larger J a better one; L2 is independent of J. The numbers 3.12×10⁻³, 7.63×10⁻⁶ and 409× are measured, and the AT table's 96,001 interval nodes are reported as verified nonnegative past r₊.

## Dependencies and related results

- [rh27a-l1-one-sided-cut](rh27a-l1-one-sided-cut.md) and [rh27a-l2-aliasing-bound](rh27a-l2-aliasing-bound.md) — the two lemmas the corollary combines.
- rh17 §1, where both lemmas were stated and each used once.
- The longer cut is what makes rh27a's three depth-18 certificates possible ([rh27a-three-certificates-at-depth-18](rh27a-three-certificates-at-depth-18.md)).

## Notes

- The source presents this as answering rh26 §6's pricing of a bigger cut ("the single most expensive thing in §5"); it states that the price was right and the reasoning behind it was not.
- The corollary is a statement about the archimedean integral, not about ζ.
