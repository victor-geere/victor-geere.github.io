# The constraints: matched winding, and a carry-proof increment floor of ≥ ½

**Kind:** Claim
**Status:** PROVED (paper argument); VERIFIED (numerical, across torsions and depths)
**Area:** rh-html
**Source:** [`rh37.html`](../../html/rh37.html) — §2 "The constraints", boxed

## Statement

> **(i) Matched winding.** Where the a-helix passes through a gear it has completed *the same number of rotations about the cone* as that gear has itself. One cumulative count, never reduced mod 2π.
> **(ii) Carry-proof monotonicity.** That count's increment carries a uniform floor — half a turn per level, at any torsion — so no small positive increase, and no residual swinging the whole way round through a carry, can interrupt it.

> Constraint (i) fixes the normalisation the sign convention left implicit. Writing W(n, t) = θ(n, t)/2π, the count is the helix's winding at depth n − 1 *and* gear n's own rotation count, and W(1, t) = 0 at every torsion. So **gear 1 never turns**: depth 0, radius 1 for every σ, rate log 1 = 0, winding 0 — the origin of all four coordinates and the construction's one fixed point. At zero torsion W(n, 0) = (n − 1)/2 exactly, so consecutive a's sit antipodally.

> Constraint (ii) is the one with teeth. The increment is ½ + (t/2π) log(1 + 1/n) discretely and (π + t/n)/2π on the continuous extension, and both are **≥ ½** for every n and every t ≥ 0, with equality only as t → 0. Because that floor does not depend on where in the turn the helix happens to be, a carry is pure bookkeeping: between gears 3 and 4 at t = 331 the residual falls by 0.345 while the count climbs by 15.66.

> And it *disqualifies* the opposed convention read as a winding — not the sign itself (refuted by rh38 §4; see Notes). rh3 §6 and rh5 §3 write the torsion as −t log n against half-turns of +π, whose increment π − t log(1 + 1/n) has no floor. At t = 1 its least value is still positive, 2.448; it crosses zero at t = π/log 2 = 4.53, *below the first zero of zeta*; by γ₁ it is −6.656 and by γ = 331 it is −226.3. The "reversal at x* = t/π" those documents report is the signature of the missing floor. A corollary used throughout: nothing defined mod 2π may be made to carry the monotonicity, so the fold and every residual statement are disqualified as carriers by construction.

## Hypotheses and notation

- W(n, t) = θ(n, t)/2π is the cumulative winding; a "gear" is a level on the unit ladder, depth n − 1, radius 1 for every σ, rate log n.
- The increment is ½ + (t/2π) log(1 + 1/n) discretely, (π + t/n)/2π continuously.
- The opposed convention writes the torsion as −t·log n against half-turns of +π.

## Proof / evidence

Arithmetic plus numerical checks: both increment forms are ≥ ½ for every n and every t ≥ 0, equality only as t → 0; the opposed increment is positive at t = 1 (2.448), crosses zero at t = π/log 2 = 4.53, is −6.656 by γ₁ and −226.3 by γ = 331; the residual between gears 3 and 4 at t = 331 falls by 0.345 while the count climbs 15.66.

## Dependencies and related results

- [rh37-majorant-b-and-pole-free-form](rh37-majorant-b-and-pole-free-form.md) — the machinery built on these coordinates.
- [rh38-mirror-conjugation-invariance](../rh38/rh38-mirror-conjugation-invariance.md) and [rh38-uniform-lift-definition](../rh38/rh38-uniform-lift-definition.md) — where the opposed convention is reinstated with a lift, and this section's "excludes" inference is corrected.
- [rh36-why-log-2-self-map](../rh36/rh36-why-log-2-self-map.md) — gear 1's stationarity as an accident of a frequency list, made an axiom here.

## Notes

- **The source's exclusion claim is later corrected.** rh38 §4 states that rh34 §2, rh35 §2 and rh37 §2 all say carry-proof monotonicity excludes rh3 §6's opposed sign, and that it does not: what has no floor is the *bare increment* read as a winding, and (8) is not a winding. The measurements quoted here stand; the inference does not. This file preserves rh37's own statement and flags the correction.
- §2 is arithmetic on the construction and unconditional.

- **Correction (2025-10-06, session 003 residual-defect repair).** The Statement claimed the half-turn floor *excludes* rh3 §6's opposed sign, and the Status graded that inference `PROVED`. The archive's own rh38 §4 corrects it: `rh38.html:620-622` — "rh34 §2, rh35 §2 and rh37 §2 all say that carry-proof monotonicity excludes rh3 §6's opposed sign. **It does not**" — and `:627-628` — "What does not stand is the inference." The measurements stand; the inference does not, and it is no longer inside the `PROVED` scope.
