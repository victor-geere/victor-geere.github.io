# Lemma L1 (the derivative ladder)

**Kind:** Lemma
**Status:** PROVED (paper argument, elementary; verified symbolically for d = 1 … 8, residual identically 0)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §2 "The two ladders", Lemma L1 (equation (6))

## Statement

> **(Lemma L1 (the derivative ladder).)** For every d ≥ 1, n ≥ 0,
>
> ```
> (d/dX) J_{d,n}(X) = d · J_{d−1,n+1}(X)                                      (6)
> ```

## Hypotheses and notation

- d ≥ 1 and n ≥ 0 are integers.
- J_{d,n} is the **Jensen polynomial of degree d and shift n**, equation (4): J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j, with C(d,j) the binomial coefficient.
- a(n) = γ(n)·n!/(2n)! (equation (3)), γ(n) = 4∫₀^∞ u^{2n}·Φ(u) du; every a(n) > 0.
- F(z) = Σ_{n≥0} a(n)·z^n/n! is the order-½ real entire function with Ξ(t) = F(−t²).

## Proof / evidence

The source's proof, verbatim: "Differentiate (4) termwise: Σ_{j≥1} j·C(d,j)a(n+j)X^{j−1}, reindex k = j−1, and use (k+1)C(d,k+1) = d·C(d−1,k). ∎"

Numerical/symbolic evidence reported in §8: "L1 and L2, generic coefficients, d = 1…8 | residual identically 0".

## Dependencies and related results

- Equation (4) and the notation a(n), F, Ξ from the source's §1.1–1.2.
- [Lemma L2 (the reciprocal ladder)](xihorn-gorz-gap-l2-reciprocal-ladder.md); [Lemma L3 (propagation)](xihorn-gorz-gap-l3-propagation.md) uses L1 in clause (i) and L2 in clause (ii).
- [Corollary 5 (column reduction)](xihorn-gorz-gap-c5-column-reduction.md) and [Corollary 6](xihorn-gorz-gap-c6-hardest-shift-nearly-easiest.md) apply the contrapositive of L3(i) n times, which runs through L1.

## Notes

- The source's standing disclaimer: "The ladder identities of §2 are elementary: L1 is written out verbatim inside [O'S] Corollary 3.3's proof, and L2's reciprocal step is used inside Corollary 3.8's proof (though identity (7) itself is not stated there)." The source's own statement is that L1 itself is not new: "What is new here is the *consequence for the exception sets*".
- The source's §10 scope note: "L1 and L2 are one-line reindexings; L3 is Rolle twice; Theorems 1–3 are set inclusions."
