# Prime versus archimedean gap

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** a numerical localization of the gap obstruction. The
archimedean part of the CCM functional has a robust gap; the prime part is
nearly degenerate. The near-degeneracy of the total form at \(K=16\) is
driven by the prime sum, not by the archimedean boundary. This is a structural
finding in a finite basis, not a proof.

## 1. The split

The CCM functional is

\[
N(h)=\underbrace{\sum_{n\ge1}\Lambda(n)h(n)}_{N_{\text{prime}}}
+\underbrace{\int_1^\infty\frac{u^2h(u)-h(1)}{u^2-1}\,d^*u+c\,h(1)}_{N_{\text{arch}}}.
\]

On the plain sine basis, each part gives an antisymmetric matrix; projecting
onto the degree-zero subspace gives spectra \(\mu_{\text{prime}}\),
\(\mu_{\text{arch}}\), and \(\mu_{\text{total}}\).  The gap is the smallest
entry.

## 2. The table

| \(K\) | prime gap | arch gap | total gap |
|---|---|---|---|
| 12 | \(0.00185\) | \(0.2637\) | \(0.2449\) |
| 14 | \(0.01975\) | \(0.2441\) | \(0.1629\) |
| 16 | \(0.01727\) | \(0.2301\) | \(0.0370\) |
| 18 | \(0.00225\) | \(0.2196\) | \(0.0588\) |
| 20 | \(0.00409\) | \(0.2114\) | \(0.0668\) |

## 3. Interpretation

- The **archimedean** gap is robust: it stays between \(0.21\) and \(0.26\)
  across the truncations.  The archimedean boundary is not the source of the
  near-degeneracy.
- The **prime** gap is tiny: \(0.0019\) to \(0.0198\), one to two orders of
  magnitude below the archimedean gap.
- The total gap at \(K=16\) is \(0.0370\), far below the archimedean gap
  \(0.2301\).  The collapse is **prime-driven**: the small prime eigenvalue
  cancels against the archimedean contribution.
- The non-monotone behaviour of the total gap is inherited from the prime
  part, whose small eigenvalues vary erratically with \(K\).

This localizes the global Hodge-index obstruction: a uniform lower bound on
the total form must control the **prime sum**, not the archimedean integral.
The prime sum is the arithmetic input tied to the zeros and the explicit
formula; the archimedean term is well behaved.

## 4. What this does not establish

- It is a finite-basis numerical statement, not a proof of a lower bound or
  of its failure.
- The sign convention of the CCM functional remains unsettled; the split uses
  \(N\) as written.
- It does not prove RH.  It identifies which part of the construction carries
  the hard arithmetic obstruction.

## 5. Next

1. **Prime eigenvectors.**  Examine the small eigenvectors of the prime part
   and compare their support with the explicit-formula/zero contributions.
2. **Lower bound.**  Either prove a uniform lower bound for the prime part or
   show that its small eigenvalues can approach zero.
3. **Archimedean control.**  The archimedean part is numerically robust; a
   proof of its lower bound may be accessible separately.
4. **Global limit.**  Pass to the Bost–Connes crossed product once the prime
   lower bound is understood.

## 6. Numerical check

[`../python/prime_arch_split.py`](../python/prime_arch_split.py) computes the
two components, projects them, and returns the spectra.  The tests in
[`../tests/test_prime_arch_split.py`](../tests/test_prime_arch_split.py)
assert that the components sum to the total, that the archimedean gap is
robust, that the prime gap is small, and that the \(K=16\) total gap is below
the archimedean gap.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Plain basis near-degeneracy](15-plain-basis-near-degeneracy.md)
