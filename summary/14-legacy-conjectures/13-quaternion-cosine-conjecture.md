# Quaternion-cosine central conjecture

**Programme:** quaternion-cosine geometric approach.
**Source:** [`riemann-hypothesis.html`](archive/essays/rh/riemann-hypothesis.html), Part IV “The Central Conjecture”; the programme is explicitly labelled speculative.
**Status:** speculative conjecture; not a proof.

## Statement

The Riemann xi function $\xi(s)$ has a zero at $s=\sigma+it$ if and only if all three conditions hold:

1. **Geometric condition.** The minimum energy satisfies
   $$
   \inf_{x>0}E(x;t,\sigma)=0.
   $$
2. **Dyadic condition.** The frequency ratio $t/x^2$ admits a dyadic expansion aligned with the natural logarithmic spacing of primes.
3. **Symmetry condition.** The functional-equation warping factor $2\sigma-1$ preserves this dyadic alignment.

The programme’s reformulation is that the symmetry condition holds **if and only if** $\sigma=\tfrac12$, because only there does the warping factor vanish and the dyadic frequency hierarchy become invariant.

## Context

The energy is built from a quaternion-lifted divisor detector:
$$
\phi(x)=\cos(2\pi x)\mathbf{i}+\cos(2\pi p/x)\mathbf{j},
\qquad
E(x;t,\sigma)=[1-\cos(2\pi t/x)]^2+[1-\cos(2\pi x)]^2.
$$
The intention is to turn the zero condition into an alignment condition on dyadic frequencies and then use the Euler product. The essay itself lists deep obstacles (prime-phase control, the explicit formula, spectral realisation) and does not claim a proof.

## Status

Speculative. The essay’s own conclusion is that the framework provides geometric intuition but remains far from a rigorous proof. It is not used by the canonical paper; the canonical programme replaced this route with the exact finite Euler-sum pair. Archived for provenance.

[Back to folder README](summary/14-legacy-conjectures/README.md) · [Back to the summary index](summary/README.md)
