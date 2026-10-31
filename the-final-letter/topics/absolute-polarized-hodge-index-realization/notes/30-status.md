# Status and the Fejér normalization mismatch

> **Correction (round 45).** The “symbol-sign reduction” below is one implication only; the pointwise converse is withdrawn. See [38-rescue.md](38-rescue.md) §2.1. The Fejér mismatch remains a normalization check.

**Status (original, superseded by the banner above):** consolidation after thirty rounds. The dossier contains rigorous
partial results and precise obstructions; it does not contain the absolute
polarized Hodge-index realization or an RH proof.

## 1. The Fejér check

Take the bandlimited Fejér kernel

\[
h(x)=\left(\frac{\sin(ax)}{ax}\right)^2,
\qquad a=10.
\]

Its Fourier transform is compactly supported,

\[
\widehat h(\xi)=\frac{\pi}{a}\left(1-\frac{|\xi|}{2a}\right)_+,
\]

so the zero sum is finite.  Numerically:

\[
N(h)\approx8.78327992474,
\qquad
\sum_{\rho}\widehat h(\rho)\approx0.18426304406,
\]

a difference of about \(8.599\).

The mismatch is not a numerical error.  The CCM functional is defined for
convolution squares \(h=f*f^\#\), and its prime term is
\(\sum\Lambda(n)h(n)\).  The standard explicit formula for an arbitrary \(h\)
has the \(n^{-1/2}\) weighting and a minus sign:
\[
-\sum_n\frac{\Lambda(n)}{\sqrt n}\bigl(h(\log n)+h(-\log n)\bigr).
\]
The CCM \(h=f*f^\#\) already carries the convolution normalization; comparing
it with the explicit formula for an unrelated \(h\) is invalid.  The Fejér
kernel is therefore another normalization check, not a test of the identity.

## 2. What is rigorously established

- **Local Hodge index.**  \(E_p\times E_p\), rank-three NS, \(A^2=6\),
  \(6D^2\le(A\cdot D)^2\) (Lean T5–T9).
- **Finite KMS Hodge index.**  For a finite-dimensional \(C^*\)-algebra with
  a faithful state, \(-B\preceq0\) on the self-adjoint part of the kernel.
- **Finite Hodge–Riemann pair.**  \(C_{1/2}\succ0\) and \(B=-C'_0\).
- **Lorentzian Krein/Hodge structure.**  \(S^2=1\), \(h=QS\succ0\),
  signature \((1,\rho-1)\).
- **Exact archimedean symbol.**
  \(A_{\text{arch}}(\xi)=\frac12[\log\pi-\psi(-i\xi/2)]\).
- **Symbol-sign reduction.**
  \(s(F,F)=\langle M,|\widehat F|^2\rangle\); the Hodge index is the sign of
  \(M\).
- **Archimedean sign change.**  \(\Re A_{\text{arch}}\) crosses zero at
  \(\xi_c=6.2288527\); the archimedean part alone is indefinite.
- **Abel obstruction.**  The prime Dirichlet series does not Abel-sum to
  \(-\zeta'/\zeta\) on the critical line.
- **Zero-sum divergence.**  For compactly supported test functions, the
  naive zero sum diverges exponentially.

## 3. What is open

1. A rigorous regularization of the prime symbol, or a correct zero-sum
   normalization for convolution squares.
2. The sign of the full symbol \(M\).
3. The Bost–Connes crossed-product limit at \(\beta=1\).
4. The relation to Yuan–Zhang and the Weil positivity.

## 4. Assessment

The construction has been reduced to a precise distributional sign problem:

\[
M=A_{\text{arch}}+\widehat{\mu_{\text{prime}}},
\qquad
\text{Hodge index}\iff M\le0.
\]

The archimedean half is exact; the arithmetic half is a distribution whose
regularization and sign are open.  This is a reduction, not a realization.
No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Zero-sum divergence](29-zero-sum-divergence.md)
