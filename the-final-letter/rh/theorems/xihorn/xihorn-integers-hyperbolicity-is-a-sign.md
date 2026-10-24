# Hyperbolicity is the sign of the discriminant

**Kind:** Claim
**Status:** CITED (literature; classical)
**Area:** xi-horn
**Source:** [`xi-horn/INTEGERS.md`](../../xi-horn/INTEGERS.md) — §5 "Beat it in topological space, then bring it back"

## Statement

> **Why that kills the precision problem.** Hyperbolicity of a polynomial is the **sign of its discriminant** (for d = 2, 3; for d ≥ 4 a finite chain of subresultant signs). A sign is a topological fact. It is decidable from *enclosures* of the coefficients — you never need γ(n) exactly, only intervals tight enough to separate the discriminant from 0. That is exact certified arithmetic, and it is precisely the technique rh19–rh27a already run.

## Hypotheses and notation

- Hyperbolic means all roots real.
- For degree d = 2, 3 hyperbolicity is the sign of the discriminant; for d ≥ 4 it is a finite chain of subresultant signs.
- "Signs are certifiable from enclosures": γ(n) need only be enclosed tightly enough to separate the relevant sign quantity from 0.

## Proof / evidence

The source states the criterion as classical and draws the certification consequence: a sign is a topological fact decidable from interval enclosures of the coefficients, which is the technique rh19–rh27a already run. No proof is given; the source's conclusion is that "the *precision* question is closed — hyperbolicity is a sign, signs are certifiable from enclosures, and precision will never be why something fails."

## Dependencies and related results

- The LP/Jensen equivalence (17): [xihorn-integers-lp-closedness-and-rh-equivalence.md](xihorn-integers-lp-closedness-and-rh-equivalence.md).
- The computed discriminants: [xihorn-integers-positive-jensen-discriminants.md](xihorn-integers-positive-jensen-discriminants.md).

## Notes

- The source's own hedge: this closes the precision question only; "**What is actually open**, then, is not margin decay" but the finitely many small-n exceptions at each d with no uniform-in-d control.
