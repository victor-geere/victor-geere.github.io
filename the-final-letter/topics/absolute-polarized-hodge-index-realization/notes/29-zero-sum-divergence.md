# Zero-sum divergence for compactly supported functions

**Status:** a precise obstruction to naive zero-sum evaluations. For a
compactly supported test function, the Fourier transform is entire of
exponential type and grows in imaginary directions; the zero sum over the
zeros diverges. The explicit formula is an identity of distributions, not an
absolutely convergent sum. This is not a failure of the formula.

## 1. The tent test

Let

\[
F(x)=\left(1-\frac{|x|}{A}\right)_+,\qquad A=1,
\]

which is compactly supported and continuous.  Then \(h=F*F_-\) is compactly
supported, and the CCM functional is finite:

\[
N(h)\approx1.3708034987.
\]

The zero sum is

\[
Z_N=\sum_{k=1}^{N}2\left|\widehat F(\rho_k)\right|^2,
\qquad \rho_k=\frac12+i\gamma_k.
\]

At \(N=80\) this gives

\[
Z_{80}\approx8.0\cdot10^{165},
\]

which is not close to \(N(h)\).

## 2. Why it diverges

For compactly supported \(F\), \(\widehat F\) is entire of exponential type.
Numerically, along the critical line,

| \(\gamma\) | \(|\widehat F(1/2+i\gamma)|\) |
|---|---|
| 1 | \(1.06\) |
| 5 | \(5.81\) |
| 10 | \(219.7\) |
| 14 | \(6127.9\) |
| 20 | \(1.21\cdot10^{6}\) |

The growth is exponential, so \(|\widehat F(\rho)|^2\) grows exponentially
and the zero sum diverges.

This is the Paley–Wiener trade-off: compact support in \(x\) forces
exponential growth in the imaginary direction.  The transform decays on the
real axis but not on the critical line.

## 3. What it means

- The naive zero sum is **not** a valid numerical evaluation for CCM test
  functions.
- The explicit formula is an identity of **distributions**; it requires a
  contour shift or a regularization, not a pointwise sum.
- The symbol-sign theorem
  \(s(F,F)=\langle M,|\widehat F|^2\rangle\) remains the correct framework,
  but \(M\) and the zero sum are distributions.
- The failed Gaussian and tent checks are class/regularization issues, not
  evidence against the explicit formula.

## 4. What would fix it

1. Shift the contour in the explicit formula to a line where the test
   function decays, and account for the residues.
2. Use a test-function class with a convergent zero sum (at the cost of
   non-compact support), and match it to the compactly supported class by a
   density argument.
3. Work distributionally with \(M\) and prove its sign on a suitable cone.

## 5. Numerical check

[`../python/zero_sum_probe.py`](../python/zero_sum_probe.py) computes
\(\widehat F\) on the critical line and shows the exponential growth.  The
test in
[`../tests/test_zero_sum_probe.py`](../tests/test_zero_sum_probe.py) asserts
the growth.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The test-function class](28-test-function-class.md)
