# The polarization and the finite Hodge index

**Status:** a finite constructive realization. With the \(L^2\) polarization
\(H\), the polar decomposition of \(A=H^{-1}\Omega\) gives a compatible
complex structure \(U\), and \(R=\Omega U\) is symmetric and negative
definite. This is the Hodge-index sign on the probe. The sign convention of
the CCM functional and the global limit remain open.

## 1. The polarization

On the four-dimensional probe space spanned by

\[
F_k(x)=\sin\!\left(\frac{k\pi x}{2A}\right)\cos\!\left(\frac{\pi x}{2A}\right),
\qquad |x|\le A,
\]

use the \(L^2\) Gram matrix

\[
H_{ij}=\int_{-A}^{A}F_i(x)F_j(x)\,dx.
\]

\(H\) is positive definite (though ill-conditioned; see below).  It is the
positive polarization that the raw symmetric part \(S\) lacked.

## 2. The compatible complex structure

Let \(\Omega\) be the antisymmetric part of the CCM probe matrix and

\[
A=H^{-1}\Omega.
\]

Because \(\Omega\) is antisymmetric, \(A\) is \(H\)-skew:

\[
A^{T}H+HA=0.
\]

Hence \(A^2\) is \(H\)-negative and the polar decomposition

\[
A=U P,\qquad P=(-A^2)^{1/2},
\]

gives an \(H\)-orthogonal complex structure

\[
U^2=-I,\qquad U^{T}HU=H.
\]

Numerically, on the probe:

\[
\|U^2+I\|\approx 2.8\cdot10^{-10},
\qquad
\|U^{T}HU-H\|\approx 4.7\cdot10^{-12}.
\]

## 3. The Hodge-index form

Define

\[
R(x,y)=\Omega(x,Uy).
\]

Then \(R\) is symmetric (numerical symmetry defect
\(2.3\cdot10^{-13}\)) and its eigenvalues are

\[
\{-8.30\cdot10^{-1},\,-3.37\cdot10^{-1},\,
-1.20\cdot10^{-2},\,-1.50\cdot10^{-5}\}.
\]

All are negative: \(R\) is **negative definite**.  This is the finite
Hodge-index sign, obtained from the CCM symplectic part and the \(L^2\)
polarization.

## 4. What this establishes

- The raw symmetric part \(S\) of the probe is not a polarization, as found in
  [`11-hodge-star-obstruction.md`](11-hodge-star-obstruction.md).
- The \(L^2\) polarization \(H\) **does** give a compatible complex structure
  \(U\) by polar decomposition.
- The resulting form \(R=\Omega U\) is symmetric and negative definite.
- This is a finite realization of the Hodge-index sign on the four-dimensional
  probe space.

## 5. Caveats

1. **Conditioning.**  \(H\) has condition number \(\approx5.8\cdot10^{4}\).
   The polar decomposition is accurate here, but a better-conditioned basis is
   desirable.
2. **Degree-zero projection.**  The probe space is the full four-dimensional
   span, not the exact degree-zero subspace.  Negative definiteness on the
   whole space implies it on every subspace, so the degree-zero restriction is
   also negative definite — but the projection should still be done exactly
   for the arithmetic statement.
3. **Sign convention.**  The CCM functional \(N\) may be \(s\) or \(-W\);
   the construction uses only its antisymmetric part \(\Omega\) and the
   \(L^2\) polarization, so the Hodge-index sign is independent of that
   ambiguity.  It does not prove RH.
4. **The global limit.**  This is a finite matrix statement, not the
   Bost–Connes crossed product.

## 6. Numerical check

[`../python/polarization.py`](../python/polarization.py) computes \(H\),
\(A\), \(U\), and \(R\), and verifies the identities and the negative
definiteness.  The tests are in
[`../tests/test_polarization.py`](../tests/test_polarization.py).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Hodge-star obstruction](11-hodge-star-obstruction.md)
