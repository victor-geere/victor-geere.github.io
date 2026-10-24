# Lemma L2 (the reciprocal ladder)

**Kind:** Lemma
**Status:** PROVED (paper argument, elementary; verified symbolically for d = 1 … 8, residual identically 0)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §2 "The two ladders", Lemma L2 (equation (7))

## Statement

> **(Lemma L2 (the reciprocal ladder).)** Write J\*\_{d,n}(X) := X^d·J_{d,n}(1/X) = Σ_k C(d,k)·a(n+d−k)·X^k. Then for every d ≥ 1, n ≥ 0,
>
> ```
> (d/dX) J*_{d,n}(X) = d · J*_{d−1,n}(X)                                      (7)
> ```

## Hypotheses and notation

- d ≥ 1 and n ≥ 0 are integers.
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); J\*\_{d,n} is its reversal, X^d·J_{d,n}(1/X) = Σ_k C(d,k)·a(n+d−k)·X^k.
- a(n) = γ(n)·n!/(2n)! > 0 for every n (equation (3)); positivity is what L3(ii) needs.

## Proof / evidence

The source's proof, verbatim: "Identical bookkeeping on the reversed coefficient list. ∎"

Numerical/symbolic evidence reported in §8: "L1 and L2, generic coefficients, d = 1…8 | residual identically 0".

## Dependencies and related results

- Equation (4) and the notation a(n) from the source's §1.1–1.2.
- [Lemma L1 (the derivative ladder)](xihorn-gorz-gap-l1-derivative-ladder.md); [Lemma L3 (propagation)](xihorn-gorz-gap-l3-propagation.md) uses L2 in clause (ii).

## Notes

- The source's standing disclaimer: "…L2's reciprocal step is used inside Corollary 3.8's proof (though identity (7) itself is not stated there)."
- L3(ii) is the clause that consumes L2, and it needs a(n) ≠ 0 and a(n+d−1) ≠ 0 for the second reversal; the source has both because "Both were verified symbolically with generic coefficients for d = 1 … 8".
