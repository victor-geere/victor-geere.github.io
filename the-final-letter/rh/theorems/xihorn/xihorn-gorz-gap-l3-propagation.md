# Lemma L3 (propagation)

**Kind:** Lemma
**Status:** PROVED (paper argument, Rolle twice; 4 946 implications checked, 0 violations)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §2 "The two ladders", Lemma L3

## Statement

> **(Lemma L3 (propagation).)** If J_{d,n} is hyperbolic then so are J_{d−1,n+1} and J_{d−1,n}.

## Hypotheses and notation

- A real polynomial is **hyperbolic** if all its zeros are real (§1.2).
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); all its coefficients are strictly positive, so it has degree exactly d and J_{d,n}(0) = a(n) ≠ 0; its zeros, being real, are all negative.
- J\*\_{d,n}(X) := X^d·J_{d,n}(1/X) is the reversal of [L2](xihorn-gorz-gap-l2-reciprocal-ladder.md); its zeros are the reciprocals of those of J_{d,n}.
- a(n) = γ(n)·n!/(2n)! > 0 for every n (equation (3)) — this positivity is what L3 and the reduction (5) need, and the source says it is used nowhere else.
- Rolle's theorem.

## Proof / evidence

The source's proof, verbatim: "J_{d,n} has strictly positive coefficients, so it has degree exactly d and J_{d,n}(0) = a(n) ≠ 0; its zeros, being real, are all negative. (i) Rolle applied to a hyperbolic polynomial gives a hyperbolic derivative; by (6) that derivative is d·J_{d−1,n+1}. (ii) J\*\_{d,n} has as its zeros the reciprocals of those of J_{d,n} — d real numbers, since none is 0 — so J\*\_{d,n} is hyperbolic of degree d. Rolle again, with (7), makes J\*\_{d−1,n} hyperbolic; a(n) ≠ 0 and a(n+d−1) ≠ 0, so reversing once more gives J_{d−1,n}. ∎"

The source also reports both implications are strictly one-way, so L3 has content: over 300 random positive rational sequences, in exact arithmetic, the scan produced 6 973 hyperbolic and 18 227 non-hyperbolic instances — "the test is not vacuous" — and checked 4 946 instances of L3 with **0 violations**. A separate run of 300 sequences found the converse, "J_{d−1,n} hyperbolic ⟹ J_{d,n} hyperbolic", failing in 3 975 of 20 700 trials (§8).

Provenance given by the source: "Clause (i) is exactly the step inside [O'S] Corollary 3.3; the reciprocal of clause (ii) is the step inside [O'S] Corollary 3.8. What follows from putting them together is not in either paper."

## Dependencies and related results

- [L1](xihorn-gorz-gap-l1-derivative-ladder.md) (equation (6)) and [L2](xihorn-gorz-gap-l2-reciprocal-ladder.md) (equation (7)); Rolle.
- Feeds [Theorem 1 (nesting)](xihorn-gorz-gap-t1-nesting.md) (contrapositive of L3(ii)), [Corollary 5](xihorn-gorz-gap-c5-column-reduction.md) and [Corollary 6](xihorn-gorz-gap-c6-hardest-shift-nearly-easiest.md) (n-fold application of the contrapositive of L3(i)).

## Notes

- The source's §10 restates the content: "L3 is Rolle twice".
- The strict one-wayness is the source's own justification that L3 is not a triviality: the converse was tried and failed in 3 975 of 20 700 trials.
