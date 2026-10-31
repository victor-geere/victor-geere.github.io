# The Hermitian CCM pairing

**Status:** a structural reading of the CCM bilinear form, supported by the
finite probe. The CCM bifunctional is Hermitian; its real part is the
Hodge-index form and its imaginary part is the symplectic intersection form.
The real part is small and not yet certified. No RH proof is claimed yet.

## 1. The split

Write the CCM bifunctional as

\[
s(f,g)=N(f\star\tilde g).
\]

It is not symmetric.  Split it into real and imaginary parts:

\[
s(f,g)=S(f,g)+i\,\Omega(f,g),
\qquad
S(f,g)=\frac12\bigl(s(f,g)+s(g,f)\bigr),
\quad
\Omega(f,g)=\frac1{2i}\bigl(s(f,g)-s(g,f)\bigr).
\]

On a real basis, \(S\) is the symmetric part and \(\Omega\) the antisymmetric
part.  The quadratic refinement of the CCM inequality is

\[
s(f,f)=S(f,f).
\]

## 2. The probe

The finite probe of
[`09-ccm-pairing-probe.md`](09-ccm-pairing-probe.md) gives the matrix

```
M =
 [[ 0.00044081  0.07959511  0.17925334  0.18075945]
  [-0.07802292  0.00112864  0.17658168  0.25477669]
  [-0.17780529 -0.17469374  0.00083405  0.17726313]
  [-0.18043486 -0.25383145 -0.17563086  0.00100229]]
```

with

\[
\|S\|\approx 3.0\cdot10^{-3},
\qquad
\|\Omega\|\approx 6.3\cdot10^{-1}.
\]

The imaginary/symplectic part dominates by a factor of about \(200\).  The
diagonal \(S(f_i,f_i)\) is of order \(10^{-3}\).  The matrix has been
cross-checked by an independent fast quadrature to \(7.5\cdot10^{-9}\), so
the split is numerically reliable; the sign convention of the functional is
still not settled.

## 3. Interpretation

- \(\Omega\) is the **intersection/symplectic form** of the scaling
  correspondence.  It is the leading structure.
- \(S\) is the **quadratic refinement**.  The Hodge-index inequality
  \(s(f,f)\le0\) is the statement that \(S\) is negative semidefinite on the
  degree-zero subspace.
- The earlier attempts to identify the whole \(s\) with a symmetric
  Lorentzian \(Q\) were therefore mis-specified: the symmetric \(Q\) is the
  **real part** \(S\), not the full Hermitian form.

This also explains the state-dependent signatures of
[`07-finite-real-structure.md`](07-finite-real-structure.md): a fixed complex
structure acting on the full form mixes the large symplectic part into the
symmetric part.  The Hodge star must act on the **real part**, after the
complex structure has separated \(S\) from \(\Omega\).

## 4. Relation to the finite Hodge structures

The finite Hodge–Riemann pair of
[`04-finite-hodge-riemann.md`](04-finite-hodge-riemann.md) and the
Lorentzian Krein pair of
[`08-finite-krein-hodge.md`](08-finite-krein-hodge.md) model the **real
part** \(S\).  The symplectic form \(\Omega\) is the weight-one/intersection
counterpart.  The missing dictionary is the complex structure that extracts
\(S\) from \(s\), and the Hodge star that turns \(S\) into the Lorentzian
\(Q\).

## 5. What remains

1. **Certified real part.**  Compute \(S\) with interval arithmetic and
   explicit tail bounds; the probe's \(10^{-3}\) diagonal is not resolved.
2. **Complex structure.**  Identify the map that separates \(S\) from
   \(\Omega\) and sends \(S\) to the Lorentzian \(Q\).
3. **Infinite limit.**  Pass to the Bost–Connes crossed product at
   \(\beta=1\).
4. **Archimedean term.**  Separate and certify the archimedean contribution.

## 6. Numerical check

[`../python/ccm_structure.py`](../python/ccm_structure.py) performs the exact
linear-algebra split of the probe matrix and verifies that the antisymmetric
part dominates by more than a factor of \(100\).  The tests are in
[`../tests/test_ccm_structure.py`](../tests/test_ccm_structure.py).  This
certifies the **split**, not the numerical evaluation of \(s\).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[CCM probe](09-ccm-pairing-probe.md)
