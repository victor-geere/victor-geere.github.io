# The fibered polarized Hodge-index construction

**Status:** the local realization is constructed and Lean-backed; the global
assembly is open. No RH proof is claimed yet.

## 1. The target

Yuan–Zhang's arithmetic Hodge index theorem applies to a normal geometrically
connected projective variety \(X\) over a number field, of dimension \(n\ge1\),
with nef and big adelic line bundles \(L_1,\dots,L_{n-1}\).  If
\(M\cdot L_1\cdots L_{n-1}=0\), then

\[
M^2\cdot L_1\cdots L_{n-1}\le0.
\]

The CCM programme needs the case where the pairing computes

\[
Z(f)\cdot Z(f)=s(f,f),
\]

with \(Z(f)=\int f(g)Z_g\,d^*g\) the scaling correspondence.  A realization
would give \(s(f,f)\le0\) for all admissible \(f\), hence RH.

No such object is a scheme of finite type over a number field: the scaling
correspondence is a distribution on the adele class space, not an algebraic
cycle.  The construction below is the strongest rigorous substitute: a
**fibered** polarized Hodge-index object whose fibres are genuine polarized
abelian surfaces.

## 2. The local fibre

Fix a prime \(p\) and let

\[
E_p=\mathbb{C}\Big/\Bigl(\mathbb{Z}+\tau_p\mathbb{Z}\Bigr),
\qquad
\tau_p=\frac{\log p}{2\pi i}.
\]

Let \(A_p=E_p\times E_p\).  Its Néron–Severi space is spanned by

\[
H=E_p\times\{\mathrm{pt}\},\qquad
V=\{\mathrm{pt}\}\times E_p,\qquad
\Delta=\text{the diagonal}.
\]

The intersection numbers are

\[
H^2=V^2=\Delta^2=0,\qquad
H\cdot V=H\cdot\Delta=V\cdot\Delta=1,
\]

so the Gram matrix in the basis \((H,V,\Delta)\) is

\[
B=\begin{pmatrix}0&1&1\\1&0&1\\1&1&0\end{pmatrix}.
\]

**Proposition 1 (local polarization and Hodge index).** *The class
\(A=H+V+\Delta\) is ample, \(A^2=6\), and for every real divisor
\(D=aH+bV+c\Delta\),*

\[
6\,D^2\le(A\cdot D)^2,
\]

*with equality iff \(D\) is a multiple of \(A\).  Equivalently, the form is
negative definite on \(A^\perp\).*

*Proof.* \(B\) has eigenvalues \(2,-1,-1\) (the vector \((1,1,1)\) is the
positive direction; \((1,-1,0)\) and \((1,1,-2)\) span the negative part), so
the signature is \((1,2)\).  The displayed inequality is the Hodge index for
this rank-three lattice.  The computation is the Lean model T5–T9 of
[`../../intersection-form-zeta/lean/Topic.lean`](../../intersection-form-zeta/lean/Topic.lean):
`A_sq`, `hodge_inequality`, `hodge_defect`, and `hodge_index`. ∎

The local fibre is therefore a genuine proper polarized complex surface with
the Hodge index.  This is the **local realization**.

### 2.1 The metric obstruction: the local fibre is a Tate curve

The elliptic curve

\[
E_p=\mathbb{C}\Big/\Bigl(\mathbb{Z}+rac{\log p}{2\pi i}\mathbb{Z}\Bigr)
\cong \mathbb{C}^*/(p^{\mathbb{Z}})
\]

is the complex Tate curve with parameter \(q=p\).  Its period \(p^k\) has
\(p\)-adic norm \(p^{-k/2}\), and the CCM local term

\[
rac{\log p}{p^{k/2}}igl(f(p^k)+f(p^{-k})igr)
\]

carries exactly this metric factor.  But the complex torus \(E_p\) and its
Néron–Severi pairing know nothing about the \(p\)-adic norm: the fibrewise
Hodge index is a complex-geometric statement, while the local term is an
**adelic metrized** statement.

This is the precise local/global mismatch.  The local fibre is a **local Tate
curve at \(p\)**, not an elliptic curve over a number field; the base of the
family is the Scaling Site, not \(\operatorname{Spec} K\).  Yuan–Zhang applies
to varieties over a number field with adelic metrics, not to a family of local
Tate curves over a foliated base.  The fibrewise Hodge index is necessary but
does not supply the metric factor \(p^{-k/2}\); a global realization must
metrize the family and prove a Hodge index for the metrized family.

## 3. The fibered object

Let \(\mathcal{S}\) be the Scaling Site and \(\pi:\mathcal{H}\to\mathcal{S}\)
the family whose fibre over the periodic orbit at \(p\) is \(A_p=E_p\times E_p\).
The polarization is fibrewise the class \(A_p\); the global pairing is the
transverse integral of the fibrewise pairings against the CCM trace:

\[
\langle D(f),D(f)\rangle_{\mathcal{H}}
:=\int_{\mathcal{S}} \bigl(D(f)|_{\mathcal{H}_s}\bigr)^2\,d\mu(s).
\]

Here \(d\mu\) is the transverse measure of the foliation, normalized so that
the periodic orbit at \(p\) contributes the local term

\[
\frac{\log p}{p^{k/2}}\bigl(f(p^k)+f(p^{-k})\bigr).
\]

**Proposition 2 (conditional assembly).** *If the longitudinal
Hirzebruch–Riemann–Roch formula on \(\mathcal{H}\) holds with topological side
\(\frac12\langle D(f),D(f)\rangle_{\mathcal{H}}\), then*

\[
\langle D(f),D(f)\rangle_{\mathcal{H}}=s(f,f),
\]

*and the Hodge index gives \(s(f,f)\le0\), hence RH.*

*Proof.* The local HRR (Proposition 1) gives the fibrewise Euler
characteristic \(\frac12D_p^2\).  The longitudinal index theorem assembles the
fibrewise indices against the transverse measure; the normalization is the
explicit formula, whose local \(p\)-term is displayed above.  The global sum is
\(s(f,f)\).  The Hodge index on each fibre is negative definite on
\(A_p^\perp\), and the degree-zero condition places \(D(f)\) there. ∎

The conditional is exactly the missing leg of
[`../../intersection-form-zeta/notes/07-riemann-roch-square.md`](../../intersection-form-zeta/notes/07-riemann-roch-square.md).
The fibrewise theorem does not assemble automatically: the transverse measure,
the metric factor \(p^{-k/2}\), and the \(L^2\)-index localisation are the
analytic input.  The local fibre is a local Tate curve, not a global curve;
the absolute object is the metrized family, not the product of its fibres.

## 4. Why the algebraic candidates fail

### 4.1 The Hecke/Shimura surface

Let \(X=X_0(N)\).  Then \(X\times X\) is proper and polarized over
\(\mathbb{Q}\), and the Hecke correspondences \(T_p\subset X\times X\) are
algebraic.  Yuan–Zhang applies.  But the trace is

\[
\operatorname{Tr}(T_p\mid H^1)=a_p,
\]

whereas the CCM local term is

\[
\frac{\log p}{p^{k/2}}\bigl(f(p^k)+f(p^{-k})\bigr).
\]

These are different functions of \(p\); the Hecke correspondence computes the
\(L\)-function of a weight-two form, not \(\zeta\).  For the trivial
automorphic representation the Hecke eigenvalue is \(1\), and the
correspondence is the identity.  The dictionary fails, so this candidate does
not realize the CCM pairing.

### 4.2 The Scaling Site square

The complex lift \(\Gamma_\mathbb{Q}^2\) carries the correct pairing
\(s(f,f)\), but it is a foliated complex space.  It is not a variety of finite
type over a number field, has no ample class in the sense of Yuan–Zhang, and
its intersection pairing is a principal-value trace.  The hypotheses of
Yuan–Zhang fail.  This is the object the fibered construction is designed to
approximate.

### 4.3 The open realization problem

If a proper polarized realization satisfying Yuan–Zhang's hypotheses existed,
Yuan–Zhang would give \(s(f,f)\le0\) for all admissible \(f\), hence RH.
This is **not an impossibility**: it is an open construction problem.  No such
realization is known, but the failure of the two algebraic candidates above is
not a failure of all realizations.  The realization itself is the target, not a
corollary of the existing theory.

## 5. Conclusion

The local polarized Hodge-index realization is constructed: each fibre
\(E_p\times E_p\) is a proper polarized abelian surface with the Lean-proved
rank-three Hodge index.  The absolute realization is the fibered assembly
\(\mathcal{H}\to\mathcal{S}\); its global Hodge index is the longitudinal HRR,
which remains open.  The algebraic shortcuts fail for proved reasons.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md)
