# The large-\(K\) resonance

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** a correction to the smooth-window stability reading.  The
poly\(_2\)-windowed gap is stable through \(K=28\), drops to about \(0.015\)
at \(K=32\), and recovers to \(0.025\) at \(K=40\).  The \(K=32\) dip is
stable under quadrature refinement, so it is a genuine resonance of the
truncated family.  The uniform-gap question remains open.

## 1. The table

| \(K\) | \(\operatorname{cond}H\) | gap |
|---|---|---|
| 24 | \(1109\) | \(0.0411\) |
| 28 | \(1878\) | \(0.0403\) |
| 32 | \(2988\) | \(0.0150\) |
| 36 | \(4527\) | \(0.0197\) |
| 40 | \(6593\) | \(0.0254\) |

## 2. The dip is not quadrature

The \(K=32\) gap is

\[
0.014997696235138552,\quad
0.014997696235139085,\quad
0.014997696235139787
\]

for \(200,300,400\) Gauss–Legendre nodes.  It is stable to twelve digits, so
the dip is a property of the truncated matrix, not of the quadrature.

## 3. The small eigenvector at \(K=32\)

The total small eigenvector has

- effective modes \(\mathrm{PR}=8.18\);
- dominant indices \(14,20,21,23,30,31\);
- top-six mass \(0.708\).

It is partially concentrated in the higher modes, but broader than the sharp
\(K=16\) vector (PR \(4.74\), top mass \(0.84\)).  The resonance is neither a
purely UV artefact nor a single localized arithmetic mode.

## 4. Interpretation

- The gap is **not monotone** in \(K\).  The stable range \(K\le28\) does not
  persist.
- The \(K=32\) resonance is genuine in the poly\(_2\) truncation, and the
  recovery at \(K=36,40\) does not rule out further dips.
- This corrects the round-20/21 reading of a “stable gap”: stability holds
  up to \(K=28\), not uniformly.
- A uniform positive lower bound is neither established nor disproved.  The
  truncation route is inconclusive; a direct analytic bound or a different
  limiting procedure is needed.

## 5. Caveats

- Finite \(K\le40\), one window family.
- Double precision; conditioning grows to about \(6.6\cdot10^3\) at \(K=40\).
- The CCM sign convention is still unsettled.

## 6. Next

1. Test whether the \(K=32\) resonance persists for other well-conditioned
   windows.
2. Use higher precision to push beyond \(K=40\).
3. Seek a direct lower bound on the antisymmetric spectrum.
4. Pass to the Bost–Connes crossed product at \(\beta=1\).

## 7. Numerical check

[`../python/large_k_gap.py`](../python/large_k_gap.py) computes the table and
the \(K=32\) eigenvector.  The tests in
[`../tests/test_large_k_gap.py`](../tests/test_large_k_gap.py) assert the
stable range, the dip, its quadrature stability, and the recovery.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Window robustness](19-window-robustness.md)
