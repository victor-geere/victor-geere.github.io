# Orthonormal polarization and the exact degree-zero projection

**Status:** a rigorous finite theorem plus an exact degree-zero check. In an
orthonormal polarization, the Hodge-index form is
\(R=\Omega U=-(-\Omega^2)^{1/2}\), which is symmetric and negative definite
for invertible antisymmetric \(\Omega\). The probe and its degree-zero
projection verify the hypotheses. The global limit remains open.

## 1. The theorem

**Theorem.** *Let \(A\) be a real invertible antisymmetric matrix. Then*

\[
U=A(-A^2)^{-1/2}
\]

*is orthogonal, \(U^2=-I\), and*

\[
R=A U=-(-A^2)^{1/2}
\]

*is symmetric and negative definite.*

*Proof.*  \(A\) is normal with purely imaginary eigenvalues \(\pm i\mu_j\),
\(\mu_j>0\).  The matrix \(-A^2\) is positive definite, so its square root
\(P=(-A^2)^{1/2}\) is well defined by functional calculus.  Set \(U=AP^{-1}\).
Since \(A\) and \(P\) commute (both are functions of \(A\)),
\(U^2=A^2P^{-2}=A^2(-A^2)^{-1}=-I\), and
\(U^{T}U=P^{-1}A^{T}AP^{-1}=P^{-1}(-A^2)P^{-1}=I\).  Finally
\(R=AU=A^2P^{-1}=-P\), which is symmetric and negative definite. ∎

Thus an orthonormal polarization reduces the finite Hodge-index construction
to a theorem of linear algebra.  The only hypothesis is invertibility of
\(\Omega\) on the subspace.

## 2. The orthonormalized probe

Starting from the \(L^2\) Gram \(H\), let

\[
H=V\Lambda V^{T},\qquad W=V\Lambda^{-1/2}V^{T},
\]

so \(W^{T}HW=I\).  The transformed CCM symplectic form is

\[
\widetilde\Omega=W^{T}\Omega W,
\qquad
\widetilde\Omega^{T}=-\widetilde\Omega.
\]

Numerically,

\[
\|W^{T}HW-I\|\approx3.3\cdot10^{-12},
\qquad
\|\widetilde\Omega+\widetilde\Omega^{T}\|\approx2.7\cdot10^{-13},
\]

and

\[
\operatorname{eig}(\widetilde\Omega)
\approx\{\pm0.8962\,i,\ \pm0.3015\,i\}.
\]

So \(\widetilde\Omega\) is invertible and the theorem applies.  The resulting
Hodge-index form has

\[
\operatorname{eig}(R)\approx
\{-0.8962,\,-0.8962,\,-0.3015,\,-0.3015\},
\]

signature \((0,4)\), with symmetry defect \(3.0\cdot10^{-13}\).

## 3. The exact degree-zero projection

The degree-zero conditions are

\[
\int f(u)\,d^*u=0,
\qquad
\int f(u)\,du=0.
\]

On the probe basis they become two linear functionals
\(\ell_1,\ell_2\).  In the orthonormal basis, form the \(2\times4\) matrix
\(\widetilde\ell\) and take its nullspace \(C\).  The projected symplectic
form is

\[
\widetilde\Omega_p=C^{T}\widetilde\Omega\,C.
\]

Numerically \(\widetilde\Omega_p\) is a \(2\times2\) invertible antisymmetric
matrix with eigenvalues

\[
\pm0.4152\,i
\]

(up to the arbitrary normalization of \(C\)), and the projected Hodge-index
form has

\[
\operatorname{eig}(R_p)\approx\{-0.4152,\,-0.4152\},
\]

signature \((0,2)\).  So the Hodge-index sign survives the exact degree-zero
projection.

## 4. What this establishes

- The finite Hodge-index form is symmetric and negative definite on the full
  four-dimensional probe.
- It is also negative definite on the exact degree-zero subspace.
- The construction is rigorous linear algebra; the only numerical inputs are
  the CCM symplectic matrix and the \(L^2\) Gram, both cross-checked.

## 5. Caveats

1. **Finite probe.**  This is a four-function model, not the full CCM space.
2. **Sign convention.**  The construction uses the antisymmetric part
   \(\Omega\) of the CCM bifunctional; it does not settle whether the full
   functional is \(s\) or \(-W\), and it does not prove RH.
3. **Global limit.**  The Bost–Connes crossed product and the archimedean
   term are not addressed.
4. **Normalization of \(C\).**  The eigenvalues of \(R_p\) scale with the
   chosen nullspace basis; the signature is invariant.

## 6. Numerical check

[`../python/polarization.py`](../python/polarization.py) now includes
`orthonormalize`, `star_from_antisymmetric`, `degree_zero_projection`, and
`check_orthonormal`.  The tests are in
[`../tests/test_polarization_orthonormal.py`](../tests/test_polarization_orthonormal.py).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Polarization Hodge index](12-polarization-hodge-index.md)
