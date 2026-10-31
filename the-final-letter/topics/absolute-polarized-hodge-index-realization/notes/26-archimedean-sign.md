# The archimedean sign change

> **Correction (round 45).** The archimedean crossing is a real property of \(A_{\text{arch}}\), but the inference that the full symbol requires pointwise prime cancellation is withdrawn: the pointwise symbol is not the form. See [38-rescue.md](38-rescue.md) §2.1 and §3.

**Status (original, superseded by the banner above):** an exact sign result. The real part of the archimedean symbol is
positive for small \(|\xi|\) and negative for large \(|\xi|\), crossing zero
at \(\xi_c\approx6.22885\). The archimedean part alone is therefore
indefinite; the Hodge-index sign is a genuine prime–archimedean cancellation.

## 1. The real part

\[
A_{\text{arch}}(\xi)
=\frac12\left[\log\pi-\psi\!\left(-\frac{i\xi}{2}\right)\right].
\]

For real \(\xi\),

\[
\Re A_{\text{arch}}(\xi)
=\frac12\left[\log\pi-\Re\psi\!\left(-\frac{i\xi}{2}\right)\right].
\]

Numerically:

| \(\xi\) | \(\Re A_{\text{arch}}\) |
|---|---|
| \(0.01\) | \(0.86096\) |
| \(0.5\) | \(0.82532\) |
| \(1\) | \(0.73681\) |
| \(2\) | \(0.52504\) |
| \(5\) | \(0.10744\) |
| \(6.22885\) | \(0\) |
| \(10\) | \(-0.23403\) |
| \(20\) | \(-0.57934\) |
| \(50\) | \(-1.03714\) |

The positive crossing is

\[
\xi_c=6.2288527370273477\ldots
\]

For large \(\xi\),

\[
\Re A_{\text{arch}}(\xi)
\sim\frac12\left(\log\pi-\log\frac{\xi}{2}\right)\to-\infty,
\]

which matches the numerical values to \(10^{-4}\) at \(\xi=100\).

## 2. The imaginary part

The imaginary part is odd:

\[
\Im A_{\text{arch}}(-\xi)=-\Im A_{\text{arch}}(\xi).
\]

For real \(F\), \(|\widehat F|^2\) is even, so the odd imaginary part cancels
in the pairing.  Only the even real part contributes to the quadratic form.

## 3. Consequence

- The archimedean-only quadratic form is **indefinite**: positive for
  low-frequency test functions, negative for high-frequency ones.
- The negative definiteness of the CCM form cannot come from the archimedean
  term alone.  It requires the prime term to cancel the positive
  low-frequency archimedean contribution.
- This is the exact-symbol counterpart of the earlier prime/archimedean
  split (which was a truncation diagnostic).  Here the statement is exact.
- The prime symbol is therefore essential and cannot be replaced by an
  archimedean positivity argument.

## 4. What remains

1. Regularize the prime symbol and determine its sign.
2. Prove the total symbol \(M=A_{\text{arch}}+\widehat{\mu_{\text{prime}}}\)
   is nonpositive (or find where it fails).
3. Relate the sign to the zeros and the explicit formula.
4. Pass to the Bost–Connes crossed product.

No RH proof is claimed yet.

## 5. Numerical check

[`../python/arch_symbol.py`](../python/arch_symbol.py) now includes
`arch_real`, `arch_imag`, and `arch_crossing`.  The tests in
[`../tests/test_arch_symbol.py`](../tests/test_arch_symbol.py) check the
crossing value, the sign on both sides, and the odd imaginary part.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The symbol-sign theorem](25-symbol-sign.md)
