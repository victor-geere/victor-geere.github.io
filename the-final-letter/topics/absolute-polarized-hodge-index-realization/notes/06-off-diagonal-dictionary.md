# The off-diagonal dictionary

**Status:** a structural correction to the dictionary. The CCM local term is
an **off-diagonal bilinear form**, not the diagonal half-weight norm. The
finite Hodge–Riemann pair supplies the bilinear form; the global assembly
remains open. No RH proof is claimed yet.

## 1. The diagonal derivative vanishes

Recall

\[
C_s(a,a)=\sum_{i,j}p_i^s p_j^{1-s}|a_{ij}|^2
\]

from [`04-finite-hodge-riemann.md`](04-finite-hodge-riemann.md).  At the
half-weight point \(s=1/2\),

\[
\left.\frac{d}{ds}C_s(a,a)\right|_{s=1/2}
=\sum_{i,j}(p_ip_j)^{1/2}|a_{ij}|^2\log\frac{p_i}{p_j}.
\]

For self-adjoint \(a\), swapping \(i\) and \(j\) shows that this sum is zero:
the weight \((p_ip_j)^{1/2}\) is symmetric, while \(\log(p_i/p_j)\) is
antisymmetric.  Hence the half-weight-times-log term **cannot** be the
diagonal quadratic form.  The CCM local term

\[
\frac{\log p}{p^{k/2}}\bigl(h(p^k)+h(p^{-k})\bigr)
\]

is therefore not a diagonal norm.

## 2. The off-diagonal form

For a pair \(a,b\), define

\[
C_s(a,b)=\operatorname{Tr}\bigl(\rho\,a^*\rho^s b\,\rho^{-s}\bigr).
\]

Then

\[
C_s(a,b)=\sum_{i,j}p_i^{1-s}p_j^s\,\overline{a_{ji}}\,b_{ji}
=\sum_{i,j}p_i^s p_j^{1-s}\,\overline{a_{ij}}\,b_{ij}.
\]

Differentiating at \(s=1/2\),

\[
\left.\frac{d}{ds}C_s(a,b)\right|_{1/2}
=\sum_{i,j}(p_ip_j)^{1/2}\,\overline{a_{ij}}\,b_{ij}
\log\frac{p_i}{p_j}.
\]

This vanishes when \(b=a\) and \(a\) is self-adjoint, but it is nonzero for
\(b\neq a\).  It is the **off-diagonal** half-weight-times-log form.

For **self-adjoint** \(a,b\), the derivative is purely imaginary:
swapping \(i\) and \(j\) shows
\(D(a,b)=-\overline{D(a,b)}\).  The form is therefore **symplectic** on
Hermitian pairs, not symmetric.  The CCM local term is real, so the dictionary
must either use non-Hermitian representatives \((a,b)\), or pair the
symplectic form with a complex structure.  This is another precise condition
on the dictionary, not a detail.

## 3. Relation to the earlier off-diagonal wall

This is the same phenomenon as in
[`../../intersection-form-zeta/notes/08-three-attacks-and-the-wall.md`](../../intersection-form-zeta/notes/08-three-attacks-and-the-wall.md):
the missing positivity is **off-diagonal**, not a diagonal kernel bound.
The finite Hodge–Riemann pair \((C_{1/2},B)\) gives the diagonal polarization
and the transverse sign; the CCM local term lives in the off-diagonal
\(C_s(a,b)\).  The dictionary must map a single test function \(f\) to a
**pair** \((a,b)\), not to one algebra element.

## 4. What remains

1. **The map \(f\mapsto(a,b)\).**  The test function must produce two
   algebra elements whose off-diagonal pairing has the half-weight-times-log
   form.  This is the finite-level dictionary.
2. **The infinite limit.**  The pair \((a,b)\) must live in the Bost–Connes
   crossed product, and the off-diagonal form must pass to the \(\beta=1\)
   limit.
3. **The archimedean term.**  The finite off-diagonal form has no
   archimedean place.
4. **The real/symplectic structure.**  On Hermitian pairs the off-diagonal
   form is purely imaginary.  The real CCM pairing must come from the
   symplectic form composed with a complex structure, or from non-Hermitian
   representatives.  The Hodge-index sign is the content of the earlier finite
   theorem applied to that real structure.

## 5. Numerical check

[`../python/off_diagonal.py`](../python/off_diagonal.py) verifies:

- the diagonal derivative at \(s=1/2\) vanishes for self-adjoint \(a\);
- the off-diagonal derivative is nonzero for \(a\neq b\);
- the real part is symmetric and the imaginary part antisymmetric under
  swapping \(a,b\).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Finite Hodge–Riemann package](04-finite-hodge-riemann.md)
