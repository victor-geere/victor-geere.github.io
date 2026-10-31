# The Abel-regularization obstruction

**Status:** a precise obstruction to the naive prime-symbol regularization.
The Abel sums of the prime Dirichlet series oscillate on the critical line and
do not converge to \(-\zeta'/\zeta(1/2-i\xi)\). The identification of the
prime symbol with the zeta logarithmic derivative therefore cannot be
justified by Abel summation; the zero-sum/explicit-formula route is needed.

## 1. The probe

For \(\epsilon>0\), define

\[
S_\epsilon(\xi)
=\sum_{n\ge1}\Lambda(n)\,n^{-1/2+i\xi}e^{-\epsilon n}.
\]

This is the Abel sum of \(\sum\Lambda(n)n^{-s}\) at \(s=1/2-i\xi\).  Using
prime powers up to \(2\cdot10^{6}\):

| \(\epsilon\) | \(\xi=1\) | \(\xi=2\) | \(\xi=5\) |
|---|---|---|---|
| \(10^{-2}\) | \(-5.5468-1.9613i\) | \(-1.3224+0.8978i\) | \(-0.1082-0.1875i\) |
| \(10^{-3}\) | \(14.5606-4.7690i\) | \(2.1332+2.2044i\) | \(-0.0843-0.2014i\) |
| \(10^{-4}\) | \(-21.3500+48.4945i\) | \(5.0754-9.1249i\) | \(-0.0760-0.2876i\) |

The sums oscillate wildly as \(\epsilon\to0\).  They do not converge to

\[
-\frac{\zeta'}{\zeta}\left(\frac12-i\xi\right),
\]

whose values are of order \(1\) for these \(\xi\).

## 2. Why this is expected

The Dirichlet series

\[
\sum_{n\ge1}\Lambda(n)n^{-s}
=-\frac{\zeta'}{\zeta}(s)
\]

converges for \(\Re(s)>1\).  The critical line \(\Re(s)=1/2\) lies outside
its ordinary and Abel summability domain: the pole at \(s=1\) controls the
boundary, and the Abel kernel \(e^{-\epsilon n}\) does not produce the
meromorphic continuation there.

This is not a numerical artefact:

- the effective cutoff \(1/\epsilon\) stays well below the prime-power cutoff
  \(2\cdot10^{6}\) for \(\epsilon\ge10^{-4}\);
- the oscillation persists across three orders of magnitude in \(\epsilon\);
- the values are far larger than the target.

## 3. What it rules out

- The prime symbol is **not** obtained by a simple Abel regularization.
- The formal identity
  \(\widehat{\mu_{\text{prime}}}=-\zeta'/\zeta(1/2-i\xi)\) remains formal.
- A different summation method, or the zero-sum form of the explicit formula,
  is required.

This is a precise obstruction, not a no-go for the construction.

## 4. Alternative: the zero sum

The explicit formula expresses the same functional as a sum over the
nontrivial zeros:

\[
N(h)=\sum_\rho h(\rho)+\text{boundary terms}.
\]

The zero sum avoids the prime regularization but introduces the zero
distribution and its own normalization.  Choosing between the two routes,
and fixing the normalization, is the next analytic task.

## 5. Numerical check

[`../python/prime_abel_probe.py`](../python/prime_abel_probe.py) computes the
table.  The test in
[`../tests/test_prime_abel_probe.py`](../tests/test_prime_abel_probe.py)
asserts the non-convergence between successive \(\epsilon\).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The archimedean sign change](26-archimedean-sign.md)
