# The quadrature lemma is refuted on the unwrapped Gram as well (factor 0.344)

**Kind:** Claim
**Status:** REFUTED (numerical search, 7,702 evaluations, six restarts)
**Area:** rh-html
**Source:** [`rh35.html`](../../html/rh35.html) — §4 "The lemma on G"

## Statement

> rh34 §5 tried eleven modulation frequencies by hand, found that rh33's counterexample does not transfer, and concluded that rh32's quadrature lemma was *merely unproven* on G rather than dead. It also named the failure branch: *"the search drives λ<sub>min</sub>(G) below rh33's 0.55 factor, in which case the lemma is dead on G too and (b) closes negative."*

> Six restarts of coordinate descent over an eight-frequency weight profile, 7,702 evaluations, the profile held nonnegative throughout: λ<sub>min</sub>(G)/mass falls from 0.2939 to 0.1010, a factor 0.344. That is past rh34's own 0.707 and past rh33's 0.55. **The failure branch has fired.**

> The optimum is degenerate, and every restart finds it to five figures: the entire budget on *one* frequency, log 2, at the extreme the nonnegativity constraint allows — weight 1.000 on gear 2's rate and 2.9×10⁻¹² on everything else. Confirmed by cyclic Jacobi against Cholesky inertia bisection to 3.6×10⁻¹³.

> The lemma is dead in both samplings, and the arc has no surviving version of it.

## Hypotheses and notation

- The eight-frequency weight profile is held nonnegative throughout; six restarts of coordinate descent, 7,702 evaluations.
- The comparison thresholds: rh34's 0.707 (the worst hand-tried modulation) and rh33's 0.55 (the aliased counterexample on the wrapped lattice).
- G is the unwrapped Gram; λ<sub>min</sub>(G)/mass starts at 0.2939.

## Proof / evidence

Numerical: λ<sub>min</sub>(G)/mass falls from 0.2939 to 0.1010, a factor 0.344; the optimum puts weight 1.000 on log 2 and 2.9×10⁻¹² on everything else; the smallest eigenvalue is confirmed by cyclic Jacobi against Cholesky inertia bisection to 3.6×10⁻¹³.

## Dependencies and related results

- [rh34-counterexample-needs-the-alias](../rh34/rh34-counterexample-needs-the-alias.md) — rh34 §5's eleven hand-tried frequencies and its named failure branch.
- rh32's quadrature lemma (proposed there) and rh33's refutation of it on the folded lattice.
- [rh36-the-vector-is-the-zeta-partial-sum](../rh36/rh36-the-vector-is-the-zeta-partial-sum.md) — the later naming of the object being attacked.

## Notes

- The lemma refuted is rh32's, not a result of this document; the harvest records it here because rh35 states the refutation as its own §4 result with the failure branch satisfied.
- The source also keeps the narrower surviving statement: the *same* modulation rh33 used does not transfer, because there is no alias to carry it.
