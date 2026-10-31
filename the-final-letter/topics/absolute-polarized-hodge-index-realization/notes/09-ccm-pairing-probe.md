# Probing the CCM bilinear form

**Status:** an uncertified numerical probe, not a check of RH. It identifies
the antisymmetric structure of the CCM pairing and shows that the quadratic
refinement is a small, cancellation-sensitive part of the matrix. No
conclusion about the zeros is drawn.

## 1. What was computed

Take a small basis of smooth compactly supported functions on
\(\mathbb{R}_+^*\),

\[
F_k(x)=\sin\!\left(\frac{k\pi x}{2A}\right)\cos\!\left(\frac{\pi x}{2A}\right),
\qquad |x|\le A,
\]

with \(A=3/2\) and \(k=1,\dots,4\).  For each pair compute

\[
M_{ij}=N(F_i\star\widetilde F_j),
\]

where

\[
N(h)=\sum_{n\ge1}\Lambda(n)h(n)
+\int_1^\infty\frac{u^2h(u)-h(1)}{u^2-1}\,d^*u+c\,h(1),
\qquad c=\frac{\log\pi+\gamma}{2},
\]

and

\[
(F_i\star\widetilde F_j)(u)=\int F_i(v)\,\widetilde F_j(u/v)\,d^*v,
\qquad
\widetilde F_j(u)=u^{-1}F_j(u^{-1}).
\]

This is the CCM bifunctional \(s(f,g)=N(f\star\tilde g)\) of the 2018
Riemann–Roch strategy.

## 2. The observed matrix

The numerical probe gives

```
M =
 [[ 0.00044081  0.07959511  0.17925334  0.18075945]
  [-0.07802292  0.00112864  0.17658168  0.25477669]
  [-0.17780529 -0.17469374  0.00083405  0.17726313]
  [-0.18043486 -0.25383145 -0.17563086  0.00100229]]
```

with

\[
\|M+M^{T}\|\approx 3.0\cdot10^{-3},
\qquad
\|M-M^{T}\|\approx 6.3\cdot10^{-1}.
\]

The bilinear form is dominated by its **antisymmetric** part by a factor of
about \(200\).  The diagonal \(s(f_i,f_i)\) is of order \(10^{-3}\), two
orders of magnitude below the antisymmetric entries.

## 3. Interpretation and caveat

The antisymmetric part is the **intersection pairing**; the symmetric part is
the **quadratic refinement** whose diagonal is \(s(f,f)\).  This is exactly
the off-diagonal/symplectic structure of
[`06-off-diagonal-dictionary.md`](06-off-diagonal-dictionary.md), and it
explains why the Hodge-index sign is a small, cancellation-sensitive
quantity: it is the diagonal of a matrix whose leading part is symplectic.

The diagonal is positive at the \(10^{-3}\) level in this probe.  This is
**not** evidence against RH.  The computed functional is \(N\) as written;
whether it is the CCM \(s\) or its negative (the Weil form) depends on the
sign convention of the archimedean term, which this probe does not settle.  The computation uses adaptive quadrature and a
finite projection onto the two degree-zero constraints; the symmetric part is
the difference of large terms, so its sign is not resolved at this precision.
A certified check would need interval arithmetic, explicit tail bounds for
the prime sum and the archimedean integral, and a controlled projection onto
the degree-zero subspace.

## 4. Relation to the Hodge structure

The Lorentzian Hodge index of
[`08-finite-krein-hodge.md`](08-finite-krein-hodge.md) is the symmetric form
\(Q\) obtained from the antisymmetric pairing by a Hodge star.  The probe
confirms the first half: the CCM pairing is antisymmetric-dominated.  The
missing half is the identification of the Hodge star that produces the
Lorentzian \(Q\), and the certified computation of its quadratic refinement.

## 4a. Cross-check

The matrix above was recomputed independently with a fast vectorised
100-point Gauss–Legendre rule and NumPy (no mpmath).  The two matrices agree
to

\[
\max_{ij}|M^{\text{fast}}_{ij}-M^{\text{mpmath}}_{ij}|
\approx 7.5\cdot10^{-9}.
\]

So the entries — including the small symmetric part — are numerically
reliable to about eight digits.  The antisymmetric dominance is not an
artefact of the quadrature.  The sign-convention caveat above still applies:
reliability of \(N\) is not the same as a certified RH inequality.

## 5. Next

1. **Certified computation.**  Repeat the probe with interval arithmetic and
   explicit error bounds, on a larger basis and with the degree-zero
   projection done exactly.
2. **Hodge star.**  Identify the linear map \(S\) that sends the antisymmetric
   CCM pairing to the Lorentzian \(Q\) of note 08.
3. **Infinite limit.**  Pass from the finite basis to the Bost–Connes
   crossed product.
4. **Archimedean term.**  Separate and certify the archimedean contribution.

The probe is in
[`../python/ccm_pairing_probe.py`](../python/ccm_pairing_probe.py); the fast
cross-check is [`../python/ccm_fast.py`](../python/ccm_fast.py) and
[`../tests/test_ccm_fast.py`](../tests/test_ccm_fast.py).  It is a research
probe, not a certificate.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Finite Krein/Hodge structure](08-finite-krein-hodge.md)
