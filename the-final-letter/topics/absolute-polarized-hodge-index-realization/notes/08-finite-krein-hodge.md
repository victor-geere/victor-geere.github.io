# The finite Krein/Hodge structure

**Status:** a finite construction of the Lorentzian Hodge–Riemann pair. The
Hodge index on a surface has signature \((1,\rho-1)\); its Hodge star is a
**fundamental symmetry** \(S\) with \(S^2=1\), not a complex structure
\(J^2=-1\). The finite local model is constructed and checked; the global
assembly and CCM dictionary remain open.

## 1. The correction

The previous note used a complex structure \(J\) with \(J^2=-1\) on the
off-diagonal Hermitian pairs.  That is the Hodge star of a **weight-one**
Hodge structure (a curve), where the intersection form is symplectic.  The
Hodge index on a surface is a **weight-two** statement: the intersection form
on the Néron–Severi space has signature \((1,\rho-1)\), and the Hodge star is
an involution \(S^2=1\) (a fundamental symmetry of a Krein space).

The fixed \(J\) was therefore the wrong type.  The correct finite object is a
pair \((Q,S)\):

- \(Q\) is a real symmetric form of signature \((1,\rho-1)\);
- \(S\) is a \(Q\)-orthogonal involution with \(S^2=1\);
- the positive eigenspace of \(S\) is the ample/polarization direction;
- the Hodge–Riemann form \(h(x,y)=Q(x,Sy)\) is positive definite.

## 2. Construction from the ample class

Let \(A\) be a vector with \(Q(A,A)>0\).  Define the reflection

\[
S(x)=x-2\,\frac{Q(x,A)}{Q(A,A)}\,A.
\]

In matrix form,

\[
S=I-\frac{2}{A^{T}QA}\,A A^{T}Q.
\]

**Proposition.** *If \(Q\) has signature \((1,\rho-1)\) and \(Q(A,A)>0\), then*

\[
S^2=I,\qquad S^{T}QS=Q,
\]

*and \(h(x,y)=Q(x,Sy)\) is positive definite.  The eigenvalues of \(S\) are
\(1\) (once) and \(-1\) (\(\rho-1\) times).*

*Proof.*  \(S\) is the reflection in the hyperplane \(A^\perp\); it is an
involution and preserves \(Q\).  The positive eigenspace is spanned by \(A\),
and on \(A^\perp\) the form \(Q\) is negative definite, so \(S=-1\) there.
Hence \(h=QS\) is positive definite. ∎

This is the finite Hodge–Riemann pair: \(Q\) is the intersection form, \(S\)
the Hodge star, \(h\) the polarization.

## 3. The local rank-three model

For the local polarized surface,

\[
Q=B=\begin{pmatrix}0&1&1\\1&0&1\\1&1&0\end{pmatrix},
\qquad A=(1,1,1),
\]

one has \(A^2=6\), and

\[
S=I-\frac{1}{3}A A^{T}B.
\]

The eigenvalues of \(S\) are \(1,-1,-1\); \(h=BS\) is positive definite.  This
is exactly the rank-three Hodge–Riemann package of the local model, now with
the correct Hodge star.

## 4. Relation to the earlier finite forms

- The positive form \(C_{1/2}\) of
  [`04-finite-hodge-riemann.md`](04-finite-hodge-riemann.md) is the analogue
  of \(h\), not of \(Q\).
- The symplectic form \(\omega\) of
  [`06-off-diagonal-dictionary.md`](06-off-diagonal-dictionary.md) is the
  weight-one analogue of \(Q\); the Hodge index needs its Lorentzian
  weight-two counterpart.
- The fixed \(J\) of [`07-finite-real-structure.md`](07-finite-real-structure.md)
  should be replaced by the fundamental symmetry \(S\).  A positive
  polarization cannot change the signature of \(Q\) (Sylvester's law), which
  is why the \(J_\rho\) attempt could not repair a wrong-signature form.

## 5. What remains

1. **The CCM dictionary.**  Identify the Lorentzian \(Q\) with the CCM
   intersection pairing \(s(f,f)\), and \(S\) with the Hodge star of the
   scaling correspondence.
2. **The infinite limit.**  The finite Krein space must pass to the
   Bost–Connes crossed product at \(\beta=1\).
3. **The archimedean term.**  The finite model has no archimedean place.
4. **Rank growth.**  The finite model proves signature \((1,\rho-1)\) for
   every \(\rho\); the local \(\rho=3\) case is the concrete instance.

## 6. Numerical check

[`../python/krein_hodge.py`](../python/krein_hodge.py) constructs \(S\) from
\(Q\) and \(A\), verifies \(S^2=I\), \(S^{T}QS=Q\), the eigenvalue pattern
\((1,-1,-1)\), and the positive definiteness of \(h=QS\).  The tests are in
[`../tests/test_krein_hodge.py`](../tests/test_krein_hodge.py).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Finite real structure](07-finite-real-structure.md)
