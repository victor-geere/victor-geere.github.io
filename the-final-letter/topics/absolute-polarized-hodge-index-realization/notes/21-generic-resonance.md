# The generic \(K=32\) resonance

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** the \(K=32\) gap dip is not a window artefact.  Both the
\(\sin^2\) and poly\(_2\) windows dip at \(K=32\) and recover at \(K=36,40\).
This points to a truncation resonance at the same mode count.  The
uniform-gap question remains open.

## 1. The table

| window | \(K=28\) | \(K=32\) | \(K=36\) | \(K=40\) |
|---|---|---|---|---|
| \(\sin^2\) | \(0.04074\) | \(0.00696\) | \(0.01795\) | \(0.02601\) |
| poly\(_2\) | \(0.04025\) | \(0.014998\) | \(0.019667\) | \(0.025417\) |

## 2. What is generic

- Both windows have a gap around \(0.040\) at \(K=28\).
- Both dip at \(K=32\): \(\sin^2\) to \(0.00696\), poly\(_2\) to \(0.0150\).
- Both recover by \(K=36\) and \(K=40\).
- The dip occurs at the **same mode count** in both windows, so it is a
  property of the truncation, not of the window shape.
- The \(\sin^2\) dip is deeper, consistent with its different spectral
  weighting.

## 3. Possible origin

The highest retained sine mode at \(K=32\) has frequency

\[
\frac{K\pi}{2A}=\frac{32\pi}{3}\approx33.5.
\]

The prime \(31\) lies just below this scale, and the first zeta zero has
imaginary part \(14.13\), so \(2\cdot14.13\approx28.3\).  These numerical
coincidences are suggestive but not evidence; no claim is made.  A systematic
scan in the support radius \(A\) would distinguish a highest-mode effect from
a prime/zero effect: changing \(A\) shifts the frequency of a fixed \(K\),
while a resonance tied to the prime \(31\) would move to a different \(K\).

## 4. Interpretation

- The gap is not uniformly bounded in the tested truncations; both
  well-conditioned windows dip at \(K=32\).
- The resonance is generic, so it cannot be dismissed as a basis artefact.
- A uniform positive lower bound is still neither proved nor disproved.  The
  truncation route is unreliable for settling it.
- The next diagnostic is the \(A\)-scan.

## 5. Caveats

- Finite \(K\le40\), two windows.
- Double precision; conditioning at \(K=40\) is about \(1.4\cdot10^4\) for
  \(\sin^2\) and \(6.6\cdot10^3\) for poly\(_2\).
- The CCM sign convention is still unsettled.

## 6. Next

1. Scan the support radius \(A\) to locate the resonance.
2. Test \(K\) near \(32\) in other windows.
3. Seek a direct lower bound or a different limiting procedure.
4. Pass to the Bost–Connes crossed product at \(\beta=1\).

## 7. Numerical check

[`../python/generic_resonance.py`](../python/generic_resonance.py) computes the
two-window table.  The tests in
[`../tests/test_generic_resonance.py`](../tests/test_generic_resonance.py)
assert the common dip and the deeper \(\sin^2\) value.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Large-\(K\) resonance](20-large-k-resonance.md)
