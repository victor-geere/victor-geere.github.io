# The exact archimedean symbol

**Status:** an exact continuum computation. On a Fourier mode, the
archimedean term of the CCM functional reduces to a digamma function. This is
the first exact piece of the full symbol; the prime symbol remains the
distributional continuation of \(-\zeta'/\zeta\).

## 1. The computation

In log coordinates \(x=\log u\), the archimedean term is

\[
A_{\text{arch}}(h)
=\int_0^\infty\frac{e^{2x}h(x)-h(0)}{e^{2x}-1}\,dx+c\,h(0),
\qquad
c=\frac{\log\pi+\gamma}{2}.
\]

Take the Fourier mode \(h(x)=e^{i\xi x}\).  Expanding

\[
\frac{1}{e^{2x}-1}=\sum_{k\ge1}e^{-2kx}
\]

gives

\[
A_{\text{arch}}(\xi)
=\sum_{k\ge1}\left(\frac{1}{2k-2-i\xi}-\frac{1}{2k}\right)+c
=\sum_{m\ge0}\left(\frac{1}{2m-i\xi}-\frac{1}{2m+2}\right)+c.
\]

The even/odd decomposition of the digamma series

\[
\psi(b)-\psi(a)
=\sum_{n\ge0}\left(\frac{1}{n+a}-\frac{1}{n+b}\right)
\]

with \(a=-i\xi\), \(b=2\) gives

\[
\sum_{m\ge0}\left(\frac{1}{2m-i\xi}-\frac{1}{2m+2}\right)
=\frac12\bigl[\psi(2)-\psi(-i\xi/2)\bigr]
=-\frac{\gamma}{2}-\frac12\psi(-i\xi/2).
\]

Adding \(c\),

\[
\boxed{
A_{\text{arch}}(\xi)
=\frac12\left[\log\pi-\psi\!\left(-\frac{i\xi}{2}\right)\right].
}
\]

## 2. Properties

- **Pole at \(\xi=0\).**  \(\psi(z)\) has a pole at \(z=0\), so
  \(A_{\text{arch}}\) has the archimedean pole there.  The degree-zero
  condition removes it.
- **Symmetry.**  For real \(\xi\),
  \(A_{\text{arch}}(-\xi)=\overline{A_{\text{arch}}(\xi)}\).
- **No truncation.**  This is an exact identity for the Fourier symbol, not a
  finite-basis approximation.

## 3. Numerical check

[`../python/arch_symbol.py`](../python/arch_symbol.py) compares the partial
series with the digamma formula.  At \(M=10^{5}\) terms the difference is
\(5\cdot10^{-6}\), matching the tail bound \(1/(2M)\).  The tests in
[`../tests/test_arch_symbol.py`](../tests/test_arch_symbol.py) check the
formula, the symmetry, and the shrinking tail.

## 4. Relation to the full symbol

The full CCM symbol is

\[
M(\xi)=\widehat{\mu_{\text{prime}}}(\xi)+A_{\text{arch}}(\xi),
\]

where

\[
\widehat{\mu_{\text{prime}}}(\xi)
=\sum_{n\ge1}\Lambda(n)n^{i\xi}
\]

is the distributional prime symbol.  Its meromorphic continuation is the
logarithmic derivative of zeta,

\[
-\frac{\zeta'}{\zeta}\left(\frac12-i\xi\right),
\]

up to normalization.  The archimedean symbol above is the exact gamma-factor
counterpart.  The zeros of \(\zeta\) are the zeros/poles of the continued
\(M\).

## 5. Next

1. Fix the normalization and domain of the prime symbol.
2. Combine it with \(A_{\text{arch}}\) and identify \(M\) with the explicit
   formula symbol.
3. Study the spectral gap of the full operator through the zeros of \(M\).
4. Pass to the Bost–Connes crossed product.

No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The continuum gap](22-continuum-gap.md)
