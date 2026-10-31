# The naive zero sum diverges on compact support

**Status:** a numerical diagnostic of the explicit-formula obstruction. It
explains why the compact-support Gram cannot be inserted into a naive zero
sum, and why the distributional explicit formula is a genuine global input.
No RH proof yet.

## 1. The measurement

For the tent \(F(x)=(1-|x|)_+\), whose Fourier transform is entire of
exponential type, evaluate \(|\hat F(1/2+i\gamma)|\) at increasing heights:

| \(\gamma\) | \(|\hat F(1/2+i\gamma)|\) |
|---|---|
| 1 | \(1.065\) |
| 2 | \(1.357\) |
| 5 | \(5.809\) |
| 10 | \(2.197\cdot10^{2}\) |
| 14 | \(6.128\cdot10^{3}\) |
| 20 | \(1.212\cdot10^{6}\) |
| 30 | \(1.187\cdot10^{10}\) |
| 50 | \(2.074\cdot10^{18}\) |

The growth is exponential: from \(\gamma=10\) to \(\gamma=50\) the average
logarithmic rate is about \(0.92\) per unit, consistent with
\(|\hat F(1/2+i\gamma)|\sim e^{\gamma}/\gamma^{2}\) for this tent.

## 2. Why the naive sum fails

The zero sum of the explicit formula is a sum over the nontrivial zeros
\(\rho=1/2+i\gamma\) of terms involving \(\hat F(\rho)\). For a compactly
supported \(F\), \(\hat F\) is entire of exponential type \(A\), so on the
critical line it grows like \(e^{A|\gamma|}\) in the imaginary direction.
The terms of the zero sum therefore grow exponentially, while the number of
zeros grows only linearly. The naive sum
\[
\sum_{\rho}|\hat F(\rho)|^{2}
\]
**diverges**.

This is not a failure of the explicit formula; it is the reason the formula
is **distributional**: it requires a test-function class decaying in the
imaginary direction (e.g. Gaussian or Schwartz), or a regularised pairing,
not the compact-support basis used for the finite Gram matrices.

## 3. Consequence for the programme

- The compact-support Gram certificates (notes 44, 47) are finite positive
  objects; they cannot be substituted into a naive zero sum.
- The missing distributional explicit formula is not a bookkeeping identity:
  its convergence requires the correct test-function class.
- The Gaussian rung is the natural one for the zero sum, since its transform
  decays in the imaginary direction.

## 4. Bottom line

- The naive zero sum diverges on compact support, exponentially.
- The explicit formula must be distributional / Gaussian-class.
- No RH proof yet.

[Back to the dossier](../README.md) · [Frontier](48-frontier.md) ·
[Gaussian interval entries](44-first-interval-entry.md) ·
[Research journal](../research-journal.md)
