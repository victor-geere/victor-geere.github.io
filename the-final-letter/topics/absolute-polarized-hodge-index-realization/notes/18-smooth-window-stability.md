# Smooth-window stability

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** a smooth, well-conditioned truncation in which the gap stabilises
instead of collapsing. The sharp-basis \(K=16\) drop is a UV artefact; with
the \(C^1\) \(\sin^2\)-windowed sine basis the gap stays in
\([0.038,0.054]\) for \(K=16,\dots,26\). This supports a uniform positive gap
in this family, but is not a proof.

## 1. The basis

Multiply the plain sine basis by the smooth window

\[
w(x)=\sin^2\!\left(\frac{\pi(x+A)}{2A}\right),
\qquad
F_k(x)=\sin\!\left(\frac{k\pi(x+A)}{2A}\right)w(x).
\]

The window vanishes quadratically at \(\pm A\), so \(F_k\in C^1\) and the
boundary derivative jump of the sharp sine basis is removed.  Unlike the
cosine window, the Gram matrix remains moderately conditioned.

## 2. The table

| \(K\) | \(\operatorname{cond}H\) | gap |
|---|---|---|
| 12 | \(210\) | \(0.2902\) |
| 14 | \(347\) | \(0.0376\) |
| 16 | \(543\) | \(0.0522\) |
| 18 | \(812\) | \(0.0539\) |
| 20 | \(1170\) | \(0.0511\) |
| 22 | \(1635\) | \(0.0519\) |
| 24 | \(2226\) | \(0.0391\) |
| 26 | \(2964\) | \(0.0382\) |

## 3. Interpretation

- The sharp-basis \(K=16\) drop to \(0.037\) was a UV artefact of the
  derivative discontinuity; the smooth window removes the spike.
- For \(K\ge16\), the smooth-window gap stays in \([0.038,0.054]\): it is
  bounded away from zero in this family, though it is small.
- The low gap is consistent with the prime-driven structure of
  [`16-prime-archimedean-split.md`](16-prime-archimedean-split.md): the
  archimedean part has a much larger gap, and the prime part supplies the
  small eigenvalue.
- This is evidence **for** a uniform positive gap in the smooth-window
  truncation, not a proof.  It also shows that the earlier collapse reading
  was basis-dependent.

## 4. Caveats

- Finite truncations \(K\le26\).
- One window choice; other smooth windows may differ.
- Double precision; the Gram condition grows to about \(3\cdot10^3\) at
  \(K=26\).
- The CCM sign convention is still unsettled; the gap is a property of the
  antisymmetric part.

## 5. Next

1. Prove a lower bound for the smooth-window family, or pass to a continuum
   limit.
2. Check whether the stable gap persists for other smooth windows.
3. Pass to the Bost–Connes crossed product at \(\beta=1\).
4. Control the archimedean term separately.

## 6. Numerical check

[`../python/smooth_window_gap.py`](../python/smooth_window_gap.py) implements
the windowed basis and the gap.  The tests in
[`../tests/test_smooth_window_gap.py`](../tests/test_smooth_window_gap.py)
assert positivity at \(K=16,20,24\) and moderate conditioning.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[UV localization](17-uv-localization.md)
