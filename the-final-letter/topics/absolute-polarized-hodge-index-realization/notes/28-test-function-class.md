# The test-function class

**Status:** a technical correction to the zero-sum comparisons. The CCM test
functions are compactly supported on \(\mathbb{R}_+^*\), so their Fourier
transforms are entire of exponential type. The zero sum over the zeros is
conditionally convergent, not absolutely. Gaussian test functions are outside
this class; their transforms grow along the critical line, and the numerical
zero-sum comparisons using Gaussians are invalid.

## 1. The correct class

The CCM functional is defined for real compactly supported functions \(f\) on
\(\mathbb{R}_+^*\).  In log coordinates \(x=\log u\),

\[
F(x)=f(e^x)
\]

is compactly supported on \(\mathbb{R}\).  Its Fourier transform

\[
\widehat F(\xi)=\int F(x)e^{-i\xi x}\,dx
\]

is entire of exponential type (Paley–Wiener).  It does **not** decay along
the critical line \(\Re(s)=1/2\); it oscillates and grows in imaginary
directions.

## 2. Consequence for the zero sum

The explicit formula

\[
N(F*F_-)=\sum_\rho \widehat{F*F_-}(\rho)+\text{boundary}
\]

involves \(\widehat{F*F_-}=|\widehat F|^2\).  For compactly supported \(F\),
\(|\widehat F|^2\) is entire of exponential type and the zero sum is
**conditionally convergent**, not absolutely.  It cannot be truncated by a
rapidly decaying Gaussian factor.

A Gaussian \(h(x)=e^{-x^2/(4\sigma^2)}\) has Fourier transform
\(e^{-\sigma^2\xi^2}\), which decays on the real axis but **grows** for
\(\xi=\frac12+i\gamma\):
\[
\left|e^{-\sigma^2(\frac12+i\gamma)^2}\right|
=e^{\sigma^2(\gamma^2-\frac14)}.
\]
So the Gaussian zero sum is not a valid test of the explicit formula in this
class.

## 3. What this explains

- The failed Gaussian zero-sum comparisons of round 25 were not evidence
  against the explicit formula; they used functions outside the class.
- The normalization mismatch and the large oscillatory tails are symptoms of
  the wrong test-function class.
- The symbol pairing
  \(\langle M,|\widehat F|^2\rangle\) is the correct framework for compactly
  supported \(F\); the prime symbol and the zero sum are distributions on
  this class.

## 4. What remains

1. Choose compactly supported test functions with explicitly computable
   Fourier transforms and conditional zero sums.
2. Prove the conditional convergence and the explicit-formula identity on
   this class.
3. Determine the sign of \(M\) on this class.
4. Pass to the Bost–Connes crossed product.

No RH proof is claimed yet.

## 5. Numerical implications

The finite truncations of notes 14–21 used compactly supported functions, so
they were in the right class, but they approximated the operator by finite
matrices (the truncation error).  The Gaussian checks were in the wrong
class.  The correct numerical test needs compactly supported functions and a
controlled conditional zero sum, not a Gaussian.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The Abel obstruction](27-abel-obstruction.md)
