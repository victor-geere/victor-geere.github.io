# The Hodge-star compatibility obstruction

**Status:** a numerical compatibility obstruction in the raw CCM probe. The
symmetric part \(S\) is indefinite and ill-conditioned, and
\(T=S^{-1}\Omega\) is not a complex structure or an involution up to scale.
The Hodge star must be built from a polarization, not from \(S\) alone. This
is not a no-go for the construction.

## 1. The candidate star

From the Hermitian split \(M=S+\Omega\) of
[`10-hermitian-ccm-pairing.md`](10-hermitian-ccm-pairing.md), the naive Hodge
star is

\[
T=S^{-1}\Omega.
\]

If \(S\) and \(\Omega\) were compatible, a normalization of \(T\) would
satisfy \(T^2=-1\) (complex structure) or \(T^2=1\) (fundamental symmetry).

## 2. The diagnostics

On the \(4\times4\) probe matrix:

\[
\operatorname{cond}(S)\approx 1.60\cdot10^{3},
\]

\[
\operatorname{eig}(S)\approx
\{-2.59\cdot10^{-4},\,-1.81\cdot10^{-6},\,
7.67\cdot10^{-4},\,2.90\cdot10^{-3}\},
\]

so \(S\) has signature \((2,2)\) and is ill-conditioned.  The candidate star
has

\[
\operatorname{eig}(T)\approx
\{\pm187.98\,i,\ \pm36.98\,i\},
\]

and

\[
T^2-\frac{\operatorname{tr}T^2}{4}I
\]

has norm \(\approx1.40\cdot10^{6}\).  No single normalization of \(T\)
therefore gives \(T^2=\pm I\).

## 3. Interpretation

The raw Hermitian split does **not** carry a compatible Hodge structure:

- \(S\) is not positive definite, so it is not a polarization;
- \(\Omega\) and \(S\) are not compatible: the two imaginary eigenvalue pairs
  of \(T\) have different magnitudes (\(187.98\) and \(36.98\)), so no scalar
  rescaling makes \(T\) an involution;
- the Hodge star cannot be extracted from \(S\) alone.

This is consistent with the earlier corrections: the Hodge-index form is the
**real part after a complex structure**, not the full symmetric part of the
raw bilinear form.  The missing datum is a positive polarization \(h\) and the
polar decomposition of \(\Omega\) with respect to \(h\).

## 4. What would fix it

1. **A polarization.**  Use a positive-definite form \(h\) (for example the
   finite Hodge–Riemann form \(C_{1/2}\) of
   [`04-finite-hodge-riemann.md`](04-finite-hodge-riemann.md)) and compute
   the \(h\)-self-adjoint operator \(A=h^{-1}\Omega\).  Its polar part gives a
   compatible complex structure \(J\).
2. **A better-conditioned basis.**  The \(4\times4\) probe has a nearly
   singular \(S\); a larger basis or an exact degree-zero projection may
   improve the conditioning.
3. **The Hodge–Riemann relations.**  After \(J\) is fixed, check
   \(h(x,y)=Q(x,Jy)\) and the signature \((1,\rho-1)\) on the primitive part.

## 5. Numerical check

[`../python/hodge_star_probe.py`](../python/hodge_star_probe.py) computes
\(T\), its eigenvalues, and the \(T^2\)-scalar defect.  The tests are in
[`../tests/test_hodge_star_probe.py`](../tests/test_hodge_star_probe.py):
they assert the ill-conditioning, the \((2,2)\) signature, the purely
imaginary eigenvalues, and the non-scalar \(T^2\).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Hermitian CCM pairing](10-hermitian-ccm-pairing.md)
