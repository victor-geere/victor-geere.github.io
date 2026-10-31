# The Riemann–Roch square: the missing leg of the Frobenius alternative

**Status:** a research reduction and a no-go, not a proof of RH. The
Riemann–Roch strategy is due to Connes–Consani (2018); the local HRR on the
periodic orbits is standard and is proved here; the global longitudinal HRR on
the square of the complex lift is stated precisely and remains the missing
leg. A no-go in §4.2 shows that no known Hodge-index theorem can supply it: a
realization of the CCM pairing on a proper arithmetic surface would already
prove RH. The finite checks are in
[`../python/riemann_roch_square.py`](../python/riemann_roch_square.py).

## 1. The strategy, restated

[`05-frobenius-alternative.md`](05-frobenius-alternative.md) replaces the
missing Frobenius by the scaling correspondence; its polarization is Weil
positivity. The 2018 Riemann–Roch strategy of Connes–Consani turns the
polarization into a **Riemann–Roch problem on the square of the Scaling Site**.

Let \(f\in C_c^\infty(\mathbb{R}_+^*)\) and define

\[
s(f,f):=N(f\star \tilde f),
\qquad
N(h):=\sum_{n\ge1}\Lambda(n)h(n)
+\int_1^\infty \frac{u^2h(u)-h(1)}{u^2-1}\,d^*u+c\,h(1),
\]

with \(c=\tfrac12(\log\pi+\gamma)\). The Weil criterion is

\[
\mathrm{RH}\iff s(f,f)\le0
\quad\text{for all }f\text{ with }
\int f\,d^*u=\int f\,du=0.
\]

The divisor of the scaling correspondence is

\[
D(f)=\int f(\lambda)\,\Psi_\lambda\,d^*\lambda
\quad\text{on the square of the Scaling Site,}
\]

and the key identity is

\[
s(f,f)=D(f)\bullet D(f).
\]

The **Riemann–Roch strategy** assumes \(s(f,f)>0\) and aims to derive a
contradiction from the existence part of a Riemann–Roch theorem on the
square: the positivity of the self-intersection is the leading term of the
topological side, so a suitable multiple of \(D(f)\) (or of \(-D(f)\)) should
become effective. But \(D(f)\) has degree and codegree zero, and an effective
divisor of degree zero is zero; contradiction.

This is the precise sense in which “the legs are there”:

| Weil's proof | arithmetic counterpart | status |
|---|---|---|
| surface \(C\times C\) | square of the complex lift \(\Gamma_\mathbb{Q}^2\) | constructed (2018) |
| Frobenius correspondence | scaling correspondences \(\Psi_\lambda\) | constructed / Witt lift |
| degree and codegree | \(\hat f(1)\), \(\hat f(0)\) | known |
| adjust degree by trivial correspondences | Fubini step | known (CCM 2007) |
| Riemann–Roch on the square | HRR / longitudinal index theorem | **missing** |
| Hodge index | the HRR inequality itself | **missing** |

The missing inequality is the **arithmetic Castelnuovo–Severi bound** for the
scaling correspondence.  With

\[
Z(f)=\int f(g)Z_g\,d^*g,
\qquad d(Z)=\hat f(1),\qquad d_0(Z)=\hat f(0),
\]

it reads

\[
Z(f)\cdot_{\mathrm{trans}}Z(f)
\le 2\,d(Z)d_0(Z)-\Delta\cdot\Delta\,f*f^\#(1),
\]

where \(\cdot_{\mathrm{trans}}\) is the distributional transverse intersection
(the local principal-value terms of CCM (6.3)).  By CCM Proposition 7.2 this
inequality is **equivalent to RH**.  It is a quadratic bound in
\((d,d_0)\), not a linear dimension formula.

The curve-level Riemann–Roch theorem for \(\overline{\mathrm{Spec}\,\mathbb{Z}}\)
(Connes–Consani 2023) is a first theorem in this direction, but the strategy
needs the **square**, not the curve.

## 2. What is proved: the local HRR on a periodic orbit

The complex lift \(\Gamma(p)\) of the periodic orbit at a prime \(p\) is a
compact foliated space; its exceptional leaf is the elliptic curve

\[
E_p=p^{\mathbb{Z}}\backslash\mathbb{C}^*
\cong \mathbb{C}/\left(\mathbb{Z}+\tfrac{\log p}{2\pi i}\mathbb{Z}\right).
\]

On the square \(E_p\times E_p\), which is a complex torus of dimension two,
the Hirzebruch–Riemann–Roch theorem is elementary.

**Proposition 1 (local HRR).** *Let \(A\) be a complex torus of dimension two
and \(L\) a holomorphic line bundle on \(A\), with \(D\) a divisor representing
\(L\). Then*

\[
\chi(A,L)=\dim H^0(A,L)-\dim H^1(A,L)+\dim H^2(A,L)=\frac12 D^2.
\]

*If \(D^2>0\), then \(H^0(A,L)\neq0\) or \(H^0(A,L^{-1})\neq0\); hence \(D\) or
\(-D\) is effective.*

*Proof.* The tangent bundle of a complex torus is trivial, so its Todd class
is \(1\). The Chern character is \(1+c_1(L)+\tfrac12c_1(L)^2\), and the
integral of \(c_1(L)^2\) over \(A\) is \(D^2\). HRR gives
\(\chi(A,L)=\frac12D^2\). If \(D^2>0\), then \(\chi>0\), so at least one of
\(H^0(A,L)\) and \(H^2(A,L)\) is nonzero. Serre duality and \(K_A=0\) give
\(H^2(A,L)\cong H^0(A,L^{-1})^*\). ∎

This is the local existence/effectivity step. It is unconditional.

## 3. The global assembly: a conditional theorem

The global object is the square \(\Gamma_\mathbb{Q}^2\) of the complex lift.
It is a foliated space whose leaves are products of the leaves of
\(\Gamma_\mathbb{Q}\) (upper half-planes, elliptic curves, and the classical
orbit). The divisor \(D(f)\) lifts to a divisor \(\widetilde D(f)\) on
\(\Gamma_\mathbb{Q}^2\), and the line bundle is
\(E(f)=\mathcal{O}(\widetilde D(f))\).

**Theorem 2 (conditional global HRR ⇒ RH).** *Assume:*

1. **(Global HRR.)** *The longitudinal Hirzebruch–Riemann–Roch formula on
   \(\Gamma_\mathbb{Q}^2\) holds for \(E(f)\), with topological side
   \(\tfrac12\widetilde D(f)^2\):*
   \[
   \chi(\Gamma_\mathbb{Q}^2,E(f))=\frac12\,s(f,f).
   \]
2. **(Serre duality and degree.)** *The leafwise Serre duality identifies
   \(H^2(E(f))\) with \(H^0(E(f)^{-1})^*\), and the degree/codegree of
   \(D(f)\) vanish under \(\int f\,d^*u=\int f\,du=0\).*

*Then \(s(f,f)\le0\) for all such \(f\), i.e. RH.*

*Proof.* Suppose \(s(f,f)>0\). By (1), \(\chi>0\), so
\(H^0(E(f))\oplus H^2(E(f))\neq0\). By (2), \(E(f)\) or \(E(f)^{-1}\) has a
nonzero section, so \(D(f)\) or \(-D(f)\) is effective. But both have degree
and codegree zero, and an effective divisor of degree zero is zero,
contradiction. ∎

The theorem is exactly the 2018 strategy, with the missing step isolated as
(1). The local Proposition 1 is the periodic-orbit shadow of (1); the
difficulty is the global leafwise assembly.

## 4. The missing leg, precisely

The global HRR (1) is a **longitudinal index theorem** for the foliated
surface \(\Gamma_\mathbb{Q}^2\). The candidate tool is the
Connes–Skandalis longitudinal index theorem for foliations:

- the leaves are Riemann surfaces, so the leafwise \(\bar\partial_{E}\) operator
  is elliptic along the leaves;
- the transverse space carries the Haar measure of the almost periodic
  compactification \(G=\mathbb{A}_\mathbb{Q}/(\mathbb{Q},+)\);
- the analytic index is a class in \(K_0(C^*(\mathcal{F}))\), and the
  transverse trace \(\tau\) gives the Euler characteristic;
- the topological index is the leafwise integral of
  \(\operatorname{ch}(E)\operatorname{Td}(\mathcal{F})\).

There are three technical obstructions, and they are the exact content of the
missing leg:

1. **The Todd class of the foliation.** On the elliptic leaves the Todd class
   is \(1\), which gives Proposition 1. On the generic hyperbolic leaves it is
   not \(1\). The 2018 paper *expects* the relevant Todd genus to be \(1\);
   this must be proved, or the extra Todd terms must be shown to cancel
   against the normalization of \(E(f)\).
2. **The logarithmic divergence.** The naive self-intersection of the
   diagonal diverges like \(\log\Lambda\). The complex lift and the almost
   periodic compactification are designed to remove this divergence; the
   longitudinal trace must be normalized so that the divergent term is
   absorbed into the archimedean contribution of the explicit formula.
3. **The Witt lift of the correspondences.** The Frobenius correspondences
   \(\Psi_\lambda\) are not holomorphic for the naive complex structure. The
   Witt construction of §7.1 of the 2018 paper restores holomorphy by
   twisting with the automorphisms \(\theta_\lambda\). The line bundle
   \(E(f)\) must be built from this twisted correspondence, and its first
   Chern class must be identified with \(D(f)\).

If these three points are settled, Theorem 2 gives RH. Conversely, the
failure of any one of them is exactly the failure of the strategy; there is no
other gap in the argument.

### 4.1 A route to the longitudinal HRR: \(L^2\)-index localisation

The leaves of \(\Gamma_\mathbb{Q}^2\) are products of the leaves of
\(\Gamma_\mathbb{Q}\): the exceptional elliptic curve \(E_p\) at each prime,
and the upper half-plane \(\mathbb{H}\) for the generic orbit, together with
the classical orbit.  This suggests a localisation mechanism for the
longitudinal HRR:

1. **Vanishing on hyperbolic leaves.**  By the \(L^2\)-Hodge–de Rham theorem,
   \(\mathbb{H}^2\) has no nonzero \(L^2\)-harmonic forms, so its
   \(L^2\)-Euler characteristic vanishes.  The same holds for the classical
   orbit away from its boundary.  Hence the leafwise index of the twisted
   \(\bar\partial\) is supported on the elliptic leaves, provided the twist
   is supported there.
2. **Localisation of the twist.**  The divisor
   \(D(f)=\int f(\lambda)\Psi_\lambda d^*\lambda\) is a continuous sum of
   Frobenius correspondences.  The leafwise index of the twisted
   \(\bar\partial\) is the Lefschetz index of the correspondence
   \(\Psi_\lambda\).  The Atiyah–Bott localisation formula for the foliation
   expresses this index as a sum over the fixed points of the correspondence.
   The fixed points of the scaling correspondence are exactly the periodic
   orbits.  This is the localisation lemma that must be proved; it replaces the
   vague “support of the curvature” by a standard fixed-point formula.
3. **Local HRR.**  On each \(E_p^2\), Proposition 1 gives
   \(\chi=\tfrac12D_p^2\).
4. **Assembly.**  The sum over \(p\) of the local contributions is the prime
   side of the explicit formula; the boundary of the classical orbit supplies
   the archimedean term.  The resulting trace is \(\tfrac12s(f,f)\).

This is not yet a proof: step 2 (support of the curvature) and the boundary
computation in step 4 are open.  But it identifies the longitudinal HRR with
two concrete analytic lemmas, and it explains why the elliptic periodic orbits
are the only leaves that can contribute to the index.  The \(L^2\)-index
theorem of Atiyah and the Connes–Skandalis longitudinal index theorem are the
standard tools.

### 4.2 No-go: no known Hodge-index theorem supplies the missing inequality

The natural hope is to realize the CCM pairing as the self-intersection of an
adelic line bundle on a proper arithmetic surface and then apply the
Yuan–Zhang arithmetic Hodge index theorem.  That hope is blocked.

**Proposition (no-go, conditional on Yuan–Zhang).** *Suppose there are a
number field \(K\), a normal geometrically connected projective variety
\(X/K\) of dimension \(n\ge1\), nef and big adelic line bundles
\(L_1,\dots,L_{n-1}\), and a \(\mathbb{Q}\)-linear assignment
\(f\mapsto M_f\) to integrable adelic line bundles such that*

\[
M_f\cdot L_1\cdots L_{n-1}=0,
\qquad
M_f^2\cdot L_1\cdots L_{n-1}=-c\,
\operatorname{Tr}(\vartheta_m(f\star f^\#)\mid H^1)
$$

*with \(c>0\).  Then \(\operatorname{Tr}(\cdots)\ge0\) for all \(f\),
hence RH.*

*Proof.* Yuan–Zhang's Theorem 1.3 gives
\(M_f^2\cdot L_1\cdots L_{n-1}\le0\) from
\(M_f\cdot L_1\cdots L_{n-1}=0\).  The display then gives the trace
inequality, which by CCM Proposition 6.2/7.2 is RH. ∎

Since Yuan–Zhang is a theorem and RH is open, **no such realization is known,
and any such realization would prove RH**.  The missing hypothesis is
therefore the realization itself, not a metric or positivity condition that
one could check afterwards.  The obstruction is structural:

- \(\operatorname{Spec}\mathbb{Z}\) is not a variety over a number field; it
  is the base, of relative dimension zero, so Yuan–Zhang's \(n\ge1\) fails.
- there is no ample class on \(\overline{\operatorname{Spec}\mathbb{Z}}\);
  its Picard monoid is a monoid of rank-one torsion-free groups;
- \(Z(f)\) is a distribution/cyclic-module correspondence, not an adelic line
  bundle with coherent models;
- \(Z(f)\cdot_{\mathrm{trans}}Z(f)\) is a principal-value trace, with no
  comparison theorem to algebraic intersections.

The Fargues–Fontaine curve does not fill the gap either: it is local at one
prime, has genus zero (so \(\Delta^2=+2\), the wrong sign), and has no
global assembly matching the CCM trace.  The curve-level Riemann–Roch theorem
is about a different object and does not produce the surface pairing.

The conclusion is sharp: **the missing leg is the absolute Hodge-index
realization, and it is equivalent to RH.**  It cannot be a lemma proved en
route from the known legs.

## 5. What the curve-level Riemann–Roch theorem does and does not give

The 2023 theorem of Connes–Consani,

\[
\dim H^0(D)-\dim H^1(D)
=\left\lceil\frac{\deg D+\log2}{\log3}\right\rceil'-\mathbf{1}_L,
\]

is a Riemann–Roch theorem for the **curve** \(\overline{\mathrm{Spec}\,\mathbb{Z}}\).
It is exact, but its content is a linear dimension formula, not the
quadratic Castelnuovo bound needed on the square.  Three precise facts make
the gap clear.

### 5.1 Effectivity is trivial, not the missing leg

**Theorem A.** *For an Arakelov divisor \(D=\sum a_j\{p_j\}+a\{\infty\}\) on
\(\overline{\mathrm{Spec}\,\mathbb{Z}}\),*
\[
\dim H^0(D)>0
\iff L(D)\neq\{0\}
\iff \deg D\ge0
\iff [D]\text{ contains an effective divisor}.
\]

*Proof.* Let \(q_0=\prod p_j^{a_j}\).  Then
\(\operatorname{div}(q_0)=\sum a_j\{p_j\}-(\sum a_j\log p_j)\{\infty\}\), so
\(D-\operatorname{div}(q_0)=(\deg D)\{\infty\}\).  Hence every class has the
representative \((\deg D)\{\infty\}\), and
\[
L(D)=q_0^{-1}\{m\in\mathbb{Z}:|m|\le e^{\deg D}\}.
\]
The dimension is \(\lceil\log_3(2n+1)\rceil\) with \(n=\lfloor e^{\deg D}\rfloor\),
which vanishes iff \(\deg D<0\).  Conversely, a nonzero section gives an
effective divisor in the class, whose degree is \(\deg D\ge0\). ∎

Thus the 2023 theorem does not supply effectivity; effectivity is a
consequence of linear equivalence and the sign of the degree.  The hard
step in Weil's proof is not effectivity but the **Castelnuovo–Severi bound**,
which is the missing inequality of §4.

### 5.2 The dimension is subadditive, not submodular

Write \(F(d)=\lceil\log_3(2\lfloor e^d\rfloor+1)\rceil\) for \(d\ge0\), and
\(F(d)=0\) for \(d<0\).  Then \(h^0(D)=F(\deg D)\).

**Proposition B (subadditivity).** *For all divisors \(D,E\),*
\[
\dim H^0(D+E)\le \dim H^0(D)+\dim H^0(E).
\]

*Proof.* If \(d,e\ge0\), put \(n_d=\lfloor e^d\rfloor\), \(n_e=\lfloor e^e\rfloor\).
Then \(n_{d+e}\le(n_d+1)(n_e+1)\), and
\[
2(n_d+1)(n_e+1)+1\le(2n_d+1)(2n_e+1)
\]
because the difference is \(2n_dn_e-2\ge0\).  Hence
\(2n_{d+e}+1\le3^{F(d)}3^{F(e)}\), so \(F(d+e)\le F(d)+F(e)\).  If \(d<0\)
or \(e<0\), use monotonicity and \(F(d)=0\). ∎

In particular \(h^0(2D)\le2h^0(D)\).  The stronger-looking inequalities fail:

- **Submodularity fails.** \(D=E=\{\infty\}\): \(h^0(D+E)=3>2=h^0(D)\)
  (with \(h^0(D\wedge E)=2\)).
- **Log-concavity / Hodge-index fails.** \(D=0.6\{\infty\}\),
  \(E=0.1\{\infty\}\): \(h^0(D)^2=1<2=h^0(D+E)h^0(D-E)\).

So the curve-level dimension cannot be used as a Hodge-index quadratic form;
its true inequality points in the opposite direction.

### 5.3 Serre duality is not dimension-preserving

The 2023 theorem proves Serre duality as an isomorphism of
\(\mathbb{S}[\pm1]\)-modules,
\[
H^0(K-D)\cong\operatorname{Hom}(H^1(D),U(1)_{1/4}),
\]
but the \(\mathbb{S}[\pm1]\)-dimension is **not** preserved by this duality.
For \(D=-2\{\infty\}\), the paper's \(H^1\) dimension formula gives
\(h^1(D)=\lceil(2-\log2)/\log3\rceil=2\), while
\(h^0(K-D)=F(2-2\log2)=1\).  In general
\(h^1(D)-h^0(K-D)\in\{0,1\}\) for \(\deg D<-\log2\).  Hence the classical
route “\(h^0(K-D)=h^1(D)\Rightarrow\) Castelnuovo” is unavailable in this
category.

### 5.4 Consequence

The curve-level Riemann–Roch theorem is a **linear** theorem about
\(\mathbb{S}[\pm1]\)-dimensions; the missing Castelnuovo–Severi bound is a
**quadratic** inequality on the square.  The former does not imply the
latter, and the dimension inequalities point the wrong way.  This is why the
2023 theorem, important as it is, does not close the Riemann–Roch strategy.

## 6. What would complete the proof

A completion needs one theorem and two computations:

1. **Theorem (longitudinal HRR).** For the foliated surface
   \(\Gamma_\mathbb{Q}^2\) and the Witt-lifted line bundle \(E(f)\),
   \(\chi=\frac12 s(f,f)\), with the transverse trace normalized by the
   explicit formula.
2. **Computation (Todd class).** The Todd class of the foliation is \(1\) on
   the elliptic leaves and its hyperbolic contribution cancels in the
   trace.
3. **Computation (Chern class).** The first Chern class of \(E(f)\) is the
   class of \(D(f)=\int f(\lambda)\Psi_\lambda d^*\lambda\), and its
   self-intersection is \(s(f,f)\).

This is the precise “leg” the structure demands. The local HRR is proved;
the global longitudinal HRR is open.

## Source claims and computations

- **S15.** Connes–Consani, *The Riemann–Roch strategy: complex lift of the
  Scaling Site* (2018): the strategy, the complex lift, and the Witt lift of
  the Frobenius correspondences. Standard; not formalised.
- **S16.** Connes–Skandalis longitudinal index theorem for foliations.
  Standard; not formalised.
- **S17.** Connes–Consani, *Riemann–Roch for \(\overline{\mathrm{Spec}\,\mathbb{Z}}\)*
  (2023): the curve-level theorem and Serre duality. Standard; not formalised.
- **S18.** Hirzebruch–Riemann–Roch on a complex torus (Proposition 1).
  Standard; proved here.
- **C46.** The curve-level dimension formula of S17 for small \(a\).
- **C47.** The local HRR \(\chi=\frac12D^2\) on a complex torus.
- **C48.** The periodic-orbit local term of the explicit formula.

[Back to the dossier](../README.md) · [Frobenius alternative](05-frobenius-alternative.md) ·
[Angular Bochner attack](06-angular-bochner-attack.md)
