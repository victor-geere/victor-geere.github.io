# [O'S] Corollary 3.2 — the Jensen criterion

**Kind:** Corollary
**Status:** CITED (literature — O'Sullivan, *Zeros of Jensen polynomials and asymptotics for the Riemann xi function*, arXiv:2007.13582v2)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §1.2 "Jensen polynomials and the criterion", quoted theorem box

## Statement

> **[O'S] Corollary 3.2.** *The function F^{(n)}(z) is hyperbolic if and only if J_{d,n}(z) is hyperbolic for all d ≥ 1.*

## Hypotheses and notation

- Quoted verbatim from the source except that "[O'S]'s symbol for the order-½ function is written F here, per §1.1".
- F(z) = Σ_{n≥0} a(n)·z^n/n! = Ξ(√−z) is real entire of order ½ and of genus 0, hence of Pólya's class "genus 1\*" — the class in which the Jensen criterion is stated.
- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); F^{(n)} denotes the n-th derivative.
- Hyperbolic = all zeros real.

## Proof / evidence

The source states the provenance: "His proof is one line from the fact that the Taylor coefficients of F^{(n)} are those of F shifted by n, plus his Theorem 3.1 = Pólya–Schur [PS14, p. 111]; it applies because F, and therefore every F^{(n)}, is real entire of order ½."

The source derives from it (its equation (5)): "Every a(n) > 0, so F(z) > 0 for z ≥ 0 and any real zero of F is negative; since Ξ(t) = F(−t²), F is hyperbolic exactly when every zero of Ξ is real. Hence RH ⟺ F ∈ LP ⟺ J_{d,n} hyperbolic for all d ≥ 1, n ≥ 0 (5), which is [O'S] Theorem 1.1, and is the criterion GORZ set out to attack."

## Dependencies and related results

- Pólya–Schur [PS14, p. 111] = [O'S] Theorem 3.1, cited inside the quoted proof.
- Used by [Theorem 2 (initial segment)](xihorn-gorz-gap-t2-initial-segment.md) and [Corollary 7](xihorn-gorz-gap-c7-column-decides-nu-zero.md).
- The same criterion appears, in the ξ^(n) form, in the companion source: [xihorn-uniformity-osullivan-corollary-32.md](xihorn-uniformity-osullivan-corollary-32.md).

## Notes

- This is a rung of the source's own argument, not a result of the source: it is quoted in a theorem box and marked as [O'S]'s.
- The source records the note that the criterion is stated in Pólya's class "genus 1\*", which is why the order-½ property of F is load-bearing.
