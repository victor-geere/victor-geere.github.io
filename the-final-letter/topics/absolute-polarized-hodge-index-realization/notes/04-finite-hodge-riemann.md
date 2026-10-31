# The finite Hodge–Riemann package

**Status:** a proved finite-dimensional Hodge–Riemann pair: a positive
half-weight Hermitian form and a transverse form with the Hodge-index sign.
The global endomotive limit and the CCM dictionary remain open. No RH proof is claimed yet.

## 1. The half-weight form

Keep the notation of [`03-kms-hodge-index.md`](03-kms-hodge-index.md):
\(\mathcal{A}=M_n(\mathbb{C})\), \(\varphi(a)=\operatorname{Tr}(\rho a)\),
\(\rho=\operatorname{diag}(p_1,\dots,p_n)\), \(H=-\log\rho\).  For
\(s\in\mathbb{R}\) define

\[
C_s(a,b)=\varphi\bigl(a^*\Delta^s b\bigr),
\qquad
\Delta^s(b)=\rho^s b\,\rho^{-s}.
\]

The case \(s=1/2\) is the **half-weight form**; the case \(s=0\) is the
ordinary Hilbert-space form \(\varphi(a^*b)\).

## 2. Positivity of the half-weight form

**Proposition 1.** *For every \(s\in\mathbb{R}\) and every \(a\),*

\[
C_s(a,a)
=\sum_{i,j}p_i^{\,s}p_j^{\,1-s}\,|a_{ij}|^2
\ge0.
\]

*In particular \(C_{1/2}(a,a)=\sum_{i,j}(p_ip_j)^{1/2}|a_{ij}|^2\) is positive
definite.*

*Proof.*  The matrix elements of \(\rho^s a\rho^{-s}\) are
\(p_i^s a_{ij} p_j^{-s}\).  Hence

\[
\varphi(a^*\rho^s a\rho^{-s})
=\sum_i p_i\sum_j \bar a_{ji}\,p_j^s a_{ji}\,p_i^{-s}
=\sum_{i,j}p_i^{1-s}p_j^s|a_{ji}|^2
=\sum_{i,j}p_i^s p_j^{1-s}|a_{ij}|^2.
\]

Every term is nonnegative, and every \(p_i>0\). ∎

Thus the half-weight form is a genuine positive-definite polarization.

## 3. The transverse form is its modular derivative

**Proposition 2.** *For self-adjoint \(a\), with
\(B(a,b)=\varphi(a^*[H,b])\),*

\[
B(a,a)=-\left.\frac{d}{ds}C_s(a,a)\right|_{s=0}
=\frac12\sum_{i,j}(p_i-p_j)|a_{ij}|^2\log\frac{p_i}{p_j}\ge0.
\]

*Proof.*  Differentiate the formula of Proposition 1:

\[
\frac{d}{ds}C_s(a,a)
=\sum_{i,j}p_i^s p_j^{1-s}|a_{ij}|^2\log\frac{p_i}{p_j}.
\]

At \(s=0\),

\[
\left.\frac{d}{ds}C_s(a,a)\right|_{0}
=\sum_{i,j}p_j|a_{ij}|^2\log\frac{p_i}{p_j}
=-B(a,a),
\]

where the last identity is the explicit formula of
[`03-kms-hodge-index.md`](03-kms-hodge-index.md) after exchanging \(i\) and
\(j\). ∎

## 4. The finite Hodge–Riemann pair

Combining the two propositions:

- \(C_{1/2}\) is a positive-definite Hermitian form: the **polarization**;
- \(B\) is the negative modular derivative of \(C_s\), and \(-B\) is negative
  semidefinite on \(\ker\varphi\): the **Hodge-index sign** on degree-zero
  classes.

This is the finite-dimensional Hodge–Riemann package for the KMS/endmotive
model.  It is stronger than the sign theorem alone: the polarization and the
Hodge index are two facets of the same one-parameter family \(C_s\).

## 5. What remains

1. **Global limit.**  The Bost–Connes crossed product at \(\beta=1\) is
   infinite-dimensional; the finite pair must be extended to the KMS weight.
2. **Dictionary.**  The modular Hamiltonian \(H\) must be identified with the
   periodic-orbit length \(\log p\), and \(C_{1/2}\) with the CCM trace.
3. **Archimedean term.**  The finite model has no archimedean place; the
   boundary term of the explicit formula is absent.
4. **The CCM pairing is indefinite.**  \(C_{1/2}\) is positive definite;
   \(s(f,f)\) is not.  The dictionary must map the difference of positive
   forms (the Hodge decomposition), not the positive form alone.

## 6. Numerical check

[`../python/finite_hodge_riemann.py`](../python/finite_hodge_riemann.py)
computes \(C_s\) on Hermitian bases, verifies positive definiteness at
\(s=1/2\), and checks that the finite difference of \(C_s\) at \(s=0\) equals
\(-B\).  The tests are in
[`../tests/test_finite_hodge_riemann.py`](../tests/test_finite_hodge_riemann.py).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Finite KMS Hodge index](03-kms-hodge-index.md)
