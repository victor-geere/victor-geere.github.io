# The prime symbol and its regularization

**Status:** the archimedean symbol is exact; the prime symbol is
distributional. A naive cutoff at \(\Re(s)=1/2\) does not converge to
\(-\zeta'/\zeta\), and the failure is quantitative, not numerical. The full
symbol requires a specified regularization. This is an open analytic step.

## 1. The prime symbol

The prime part of the CCM functional is

\[
N_{\text{prime}}(h)=\sum_{n\ge1}\Lambda(n)h(n).
\]

In log coordinates and on a Fourier mode, its symbol is the Dirichlet series

\[
\widehat{\mu_{\text{prime}}}(\xi)
=\sum_{n\ge1}\Lambda(n)\,n^{i\xi}.
\]

Its meromorphic continuation is expected to be

\[
-\frac{\zeta'}{\zeta}\left(\frac12-i\xi\right)
\]

up to normalization, because the Dirichlet series
\(\sum\Lambda(n)n^{-s}=-\zeta'/\zeta(s)\) for \(\Re(s)>1\).

## 2. The naive cutoff fails

Take a sharp cutoff at \(X=20000\) and a regularization
\(n^{-1/2-\epsilon}\):

\[
S_X(\xi;\epsilon)
=\sum_{n\le X}\Lambda(n)\,n^{-1/2-\epsilon}e^{i\xi\log n}.
\]

Comparing with \(-\zeta'/\zeta(1/2+\epsilon-i\xi)\) at \(\epsilon=0.05,0.1\)
and \(\xi=1,2,5\) gives differences of order \(10\)–\(60\), not small
residuals.  For example, at \(\epsilon=0.05\), \(\xi=1\):

\[
S_X\approx -62.54+49.41i,
\qquad
-\frac{\zeta'}{\zeta}\approx -0.978+0.610i.
\]

The partial sum is dominated by a large oscillatory tail.  This is the
expected failure of ordinary convergence at \(\Re(s)=1/2\): the Dirichlet
series for \(-\zeta'/\zeta\) has abscissa of convergence \(1\), and the
critical line is outside it.

## 3. What is needed

A rigorous prime symbol requires:

1. a **specified summation method** (Abel, Cesàro, or a smooth cutoff with a
   controlled kernel);
2. a proof that the regularized limit equals the meromorphic continuation on
   the required domain;
3. a treatment of the pole at \(s=1\) and the zeros.

Without these, the identification
\(\widehat{\mu_{\text{prime}}}=-\zeta'/\zeta\) is formal, not established.
The naive cutoff is not evidence against it; it simply does not test it.

## 4. The archimedean side

The archimedean symbol is exact:

\[
A_{\text{arch}}(\xi)
=\frac12\left[\log\pi-\psi\!\left(-\frac{i\xi}{2}\right)\right],
\]

from [`23-archimedean-symbol.md`](23-archimedean-symbol.md).  The asymmetry
between the two sides is the analytic content of the problem: one side is a
distribution requiring regularization, the other is a digamma function.

## 5. Alternative: the zero sum

The explicit formula gives, for suitable \(h\),

\[
N(h)=\sum_\rho h(\rho)+\text{boundary terms},
\]

where the sum is over the nontrivial zeros.  This avoids the prime
regularization but replaces it with the zero distribution.  The Hodge-index
sign is then a statement about the zero sum.  Deciding which formulation is
more tractable is the next analytic question.

## 6. Next

1. Choose and prove a regularization for the prime symbol.
2. Or work directly with the zero-sum form and the explicit formula.
3. Identify the exact full symbol \(M\) and its domain.
4. Study the gap through the zeros.

No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The exact archimedean symbol](23-archimedean-symbol.md)
