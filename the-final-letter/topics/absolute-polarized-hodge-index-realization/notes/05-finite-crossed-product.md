# The finite crossed-product Hodge index

**Status:** the finite KMS Hodge index and the half-weight Hodge–Riemann pair
extend from matrix algebras to every finite-dimensional \(C^*\)-algebra with a
faithful state. This covers the finite quotients of the Bost–Connes crossed
product. The infinite limit and the CCM dictionary remain open.

## 1. The general finite theorem

Let \(\mathcal{A}\) be a finite-dimensional \(C^*\)-algebra and \(\varphi\) a
faithful state.  Represent \(\mathcal{A}\) faithfully on a finite-dimensional
Hilbert space; then \(\varphi(a)=\operatorname{Tr}(\rho\,\pi(a))\) for a
positive density matrix \(\rho\).  Choose an orthonormal basis diagonalising
\(\rho\), with eigenvalues \(p_1,\dots,p_n>0\), and put
\(H=-\log\rho\), \(\delta(a)=[H,\pi(a)]\).

**Theorem.** *For every self-adjoint \(a\in\mathcal{A}\),*

\[
\operatorname{Re}\varphi\bigl(a^*\delta(a)\bigr)
=\frac12\sum_{i,j}(p_i-p_j)\,|(\pi(a))_{ij}|^2\log\frac{p_i}{p_j}
\ge0,
\]

*with equality if and only if \(\delta(a)=0\).*

*Proof.*  The proof of
[`03-kms-hodge-index.md`](03-kms-hodge-index.md) applies verbatim to the
matrix entries of \(\pi(a)\); for self-adjoint \(a\) one has
\(|a_{ij}|=|a_{ji}|\), and every term is nonnegative by
\((x-y)\log(x/y)\ge0\). ∎

The same argument gives the half-weight pair: with
\(\Delta^s(b)=\rho^s b\rho^{-s}\),

\[
C_s(a,b)=\varphi(a^*\Delta^s b),\qquad
C_s(a,a)=\sum_{i,j}p_i^s p_j^{1-s}|(\pi(a))_{ij}|^2\ge0,
\]

and \(B(a,a)=-\frac{d}{ds}C_s(a,a)|_{s=0}\).  Hence every finite-dimensional
\(C^*\)-algebra with a faithful state carries the finite Hodge–Riemann pair.

## 2. The finite Bost–Connes quotient

The simplest non-commutative finite quotient is the crossed product

\[
\mathcal{A}_{3,2}=C^*(\mathbb{Z}/3\mathbb{Z})\rtimes\mathbb{Z}/2\mathbb{Z},
\]

where \(\mathbb{Z}/2\) acts by inversion \(x\mapsto -x\).  It is
six-dimensional, spanned by \(U_xV^\epsilon\), \(x\in\mathbb{Z}/3\),
\(\epsilon\in\{0,1\}\), with \(U_xU_y=U_{x+y}\), \(V^2=1\),
\(VU_xV=U_{-x}\).  A faithful state is \(\varphi(a)=\operatorname{Tr}(\rho a)\)
with \(\rho>0\); if \(\rho\) does not commute with \(V\), the state is
non-tracial and the transverse form is nonzero.

By the theorem, every such state gives the Hodge-index sign.  This is the
finite-level shadow of the Bost–Connes KMS state: the translations \(U_x\)
are the periodic-orbit directions, and the inversion \(V\) is the unit
(scaling) action.

## 3. What this does and does not give

- It gives the Hodge–Riemann pair on every finite quotient, not just on
  \(M_n(\mathbb{C})\).
- It does not give the infinite crossed product
  \(C^*(\mathbb{Q}/\mathbb{Z})\rtimes\mathbb{N}^\times\), nor the
  \(\beta=1\) limit.
- It does not identify the modular Hamiltonian \(H\) with the CCM length
  \(\log p\), nor the state \(\varphi\) with the CCM trace.
- It does not add the archimedean term.

The remaining gap is therefore the **infinite-dimensional limit and the
dictionary**, not the finite positivity.

## 3a. The quotient family

The same check runs for \(C^*(\mathbb Z/N)\rtimes\mathbb Z/2\) with inversion,
\(N=3,4,5\): Hermitian dimensions \(2N=6,8,10\), and the Hodge index holds
for both a tracial and a non-tracial faithful state in every case
(`test_finite_bc_quotient_family`). This is the finite quotient family, not
the infinite crossed product.

## 4. Numerical check

[`../python/finite_crossed_product.py`](../python/finite_crossed_product.py)
constructs \(\mathcal{A}_{3,2}\) on \(\ell^2(\mathbb{Z}/3)\), samples random
faithful states, and verifies:

- the transverse form is nonnegative on the algebra;
- \(-B\) is negative semidefinite on the kernel of \(\varphi\);
- a tracial state gives the zero form;
- a non-tracial state gives a positive form.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Finite Hodge–Riemann package](04-finite-hodge-riemann.md)
