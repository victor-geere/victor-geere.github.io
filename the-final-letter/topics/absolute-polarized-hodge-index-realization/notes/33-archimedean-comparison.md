# Comparing the archimedean factors

> **Correction (round 45).** The table below compares values on two different contours. The exact relation is \(\operatorname{Re}A_{\text{arch}}(\xi)=-\tfrac12\Omega(\xi+\tfrac i2)\); the crossing \(6.22885\) is the crossing of \(\Omega\) on the shifted contour, not a competing real-line zero. See [38-rescue.md](38-rescue.md) §3.

**Status (original, superseded by the banner above):** a precise comparison of the CCM archimedean symbol with the
standard Weil archimedean factor. They have opposite qualitative behaviour
and different zero crossings; they are not constant multiples. A contour or
normalization shift is required to relate them. No sign claim is made.

## 1. The two functions

\[
A_{\text{ccm}}(\xi)
=\frac12\left[\log\pi-\psi\!\left(-\frac{i\xi}{2}\right)\right],
\]

\[
\Omega(t)
=\Re\psi\!\left(\frac14+\frac{it}{2}\right)-\log\pi.
\]

## 2. The table

| \(t\) | \(\Omega(t)\) | \(A_{\text{ccm}}(t)\) |
|---|---|---|
| \(0.01\) | \(-5.3706\) | \(+0.8610\) |
| \(2\) | \(-1.1616\) | \(+0.5250\) |
| \(4\) | \(-0.4542\) | \(+0.2151\) |
| \(6\) | \(-0.0473\) | \(+0.0184\) |
| \(6.22885\) | \(-0.00976\) | \(0\) |
| \(6.28319\) | \(-0.00106\) | \(-0.00427\) |
| \(8\) | \(+0.2409\) | \(-0.1234\) |
| \(10\) | \(+0.4643\) | \(-0.2340\) |

## 3. The crossings

\[
\xi_{\text{ccm}}=6.228852737027347,
\qquad
t_{\text{Weil}}=6.289835988836903.
\]

They differ by \(0.061\), about \(1\%\) of \(2\pi=6.28319\).  Both are close
to \(2\pi\), but neither equals it.

## 4. Interpretation

- The two functions have **opposite qualitative behaviour**: \(\Omega\) is
  negative near \(0\) and positive at infinity; \(A_{\text{ccm}}\) is positive
  near \(0\) and negative at infinity.
- They are **not constant multiples**: the magnitudes at \(0.01\) are
  \(5.37\) and \(0.86\), and the ratio varies.
- They are two different normalizations of the same gamma-factor
  contribution.  The relation requires a contour shift or a change of the
  test-function measure, not a simple sign flip.
- The near-coincidence of the crossings (both near \(2\pi\)) is notable, but
  it is not an identity.

## 5. Consequence

The CCM archimedean term is not the standard Weil archimedean factor.  The
normalization dictionary of
[`32-normalization-dictionary.md`](32-normalization-dictionary.md) is
therefore incomplete: the archimedean normalizations differ by more than a
constant.  A rigorous contour-integral derivation must account for this.

No sign claim about the CCM form is made.

## 6. Numerical check

[`../python/arch_compare.py`](../python/arch_compare.py) computes both
functions and their crossings.  The tests in
[`../tests/test_arch_compare.py`](../tests/test_arch_compare.py) assert the
two crossing values, their separation, and the opposite signs near zero.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[The normalization dictionary](32-normalization-dictionary.md)
