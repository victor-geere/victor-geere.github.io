# The finite real structure

**Status:** a finite construction of the real Hodge-index pairing. The
off-diagonal symplectic form, composed with an explicit complex structure
\(J\), gives a real symmetric form with mixed signature. The global limit and
the CCM dictionary remain open.

## 1. The symplectic form

From [`06-off-diagonal-dictionary.md`](06-off-diagonal-dictionary.md), for
self-adjoint \(a,b\),

\[
\omega(a,b)=\operatorname{Im}D(a,b),
\qquad
D(a,b)=\sum_{i,j}(p_ip_j)^{1/2}\overline{a_{ij}}\,b_{ij}
\log\frac{p_i}{p_j}.
\]

\(\omega\) is real and antisymmetric on the self-adjoint part; it is the
finite-level symplectic/intersection form.

## 2. The complex structure

On the self-adjoint basis of \(M_n(\mathbb{C})\), pair the real and imaginary
off-diagonal elements:

\[
S_{ij}=E_{ij}+E_{ji},\qquad A_{ij}=i(E_{ij}-E_{ji}),\qquad i<j.
\]

Define \(J(S_{ij})=A_{ij}\), \(J(A_{ij})=-S_{ij}\), and \(J=0\) on the diagonal
part.  Then \(J^2=-1\) on the off-diagonal Hermitian subspace, and \(J\) maps
self-adjoint elements to self-adjoint elements.

## 3. The real form and its signature

Define

\[
g(a,b)=\omega(a,Jb).
\]

Because \(\omega\) is antisymmetric and \(J^2=-1\), \(g\) is symmetric.  On
the six-dimensional off-diagonal Hermitian subspace of \(M_3(\mathbb{C})\),
the numerical signature is

\[
(1,1,4)
\]

for a generic faithful state: one positive direction, one negative direction,
and a four-dimensional kernel.  The positive direction is the polarization;
the negative direction is the **Hodge-index direction**.  The kernel consists
of the directions on which the modular length vanishes.

**Proposition.** *The real form \(g(a,b)=\omega(a,Jb)\) is symmetric.*

**Correction (state dependence).** *The signature of \(g\) is not universal.
For random faithful states on \(M_3(\mathbb{C})\), the numerical signatures
of \((\mathcal{H},g)\) are*

\[
(4,2,3),\qquad (2,4,3),\qquad (0,6,3),
\]

*so the nondegenerate part is \((4,2)\), \((2,4)\), or \((0,6)\), not a
universal \((1,\rho-1)\).  The fixed complex structure \(J\) is therefore
not the Hodge star of a polarized Hodge structure.*

The reason is structural: \(J\) is fixed on the algebra, while the state
\(\rho\) varies.  A Hodge structure requires a compatibility between the
complex structure and the polarization; the positive form \(C_{1/2}\) of
[`04-finite-hodge-riemann.md`](04-finite-hodge-riemann.md) is the natural
candidate for that polarization, and the Hodge star must be built from it
(e.g. by polar decomposition of \(g\) with respect to \(C_{1/2}\)), not
fixed by hand.

## 4. Relation to the local polarized surface

The rank-three local model of
[`01-fibered-construction.md`](01-fibered-construction.md) has signature
\((1,2)\).  The finite matrix model does **not** reproduce this signature
with the fixed \(J\); its signature is state-dependent.  The local abelian
surface has a fixed polarization, while the finite model varies the state.
The Hodge-index pair therefore requires a state-dependent Hodge star, not the
fixed \(J\) used here.

## 5. What remains

1. **The map \(f\mapsto(a,b)\).**  The test function must produce the pair
   whose real form \(g\) is the CCM local term.
2. **The infinite limit.**  The pair \((a,b)\) must live in the Bost–Connes
   crossed product, and \(g\) must pass to the \(\beta=1\) limit.
3. **The archimedean term.**  The finite model has no archimedean place.
4. **The state-dependent Hodge star.**  Build \(J_\rho\) from the
   polarization \(C_{1/2}\), and prove that the resulting real form has
   signature \((1,\rho-1)\).  The fixed \(J\) fails this test.

## 6. Numerical check

[`../python/real_structure.py`](../python/real_structure.py) builds \(J\),
computes \(g\), and records the state dependence of the signature: the
observed signatures are \((4,2,3)\), \((2,4,3)\), and \((0,6,3)\) for
random faithful states on \(M_3(\mathbb{C})\).  The tests are in
[`../tests/test_real_structure.py`](../tests/test_real_structure.py).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Off-diagonal dictionary](06-off-diagonal-dictionary.md)
