# Window robustness

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** the stable gap is not an artefact of one window.  Across
well-conditioned smooth windows the gap stays around \(0.04\)–\(0.05\); across
poorly conditioned windows it decreases, tracking the conditioning.  This
supports a uniform positive gap in well-conditioned smooth families, but is
not a proof.

## 1. The windows

\[
w_{\sin^2}=\sin^2\!\left(\frac{\pi(x+A)}{2A}\right),\qquad
w_{\sin^4}=\sin^4\!\left(\frac{\pi(x+A)}{2A}\right),
\]

\[
w_{\mathrm{poly}_2}=\left(1-\frac{x^2}{A^2}\right)^2,\qquad
w_{\mathrm{poly}_4}=\left(1-\frac{x^2}{A^2}\right)^4.
\]

Each multiplies the plain sine basis.  The first and third are well
conditioned; the second and fourth are progressively worse.

## 2. The table

| window | \(K\) | \(\operatorname{cond}H\) | gap |
|---|---|---|---|
| \(\sin^2\) | 16 | \(543\) | \(0.0522\) |
| \(\sin^2\) | 20 | \(1170\) | \(0.0511\) |
| \(\sin^2\) | 24 | \(2226\) | \(0.0391\) |
| \(\sin^4\) | 16 | \(4.27\cdot10^{4}\) | \(0.0795\) |
| \(\sin^4\) | 20 | \(1.75\cdot10^{5}\) | \(0.0402\) |
| \(\sin^4\) | 24 | \(5.81\cdot10^{5}\) | \(0.0123\) |
| poly\(_2\) | 16 | \(293\) | \(0.0546\) |
| poly\(_2\) | 20 | \(603\) | \(0.0489\) |
| poly\(_2\) | 24 | \(1109\) | \(0.0411\) |
| poly\(_4\) | 16 | \(1.54\cdot10^{4}\) | \(0.0530\) |
| poly\(_4\) | 20 | \(5.73\cdot10^{4}\) | \(0.0437\) |
| poly\(_4\) | 24 | \(1.76\cdot10^{5}\) | \(0.0104\) |

## 3. Interpretation

- The well-conditioned windows (\(\sin^2\), poly\(_2\)) give a **stable gap**
  around \(0.04\)–\(0.055\) through \(K=24\).
- The poorly conditioned windows (\(\sin^4\), poly\(_4\)) show a decreasing
  gap as the condition number grows; at \(K=24\) the gaps are \(0.012\) and
  \(0.010\), likely numerical.
- The apparent collapse therefore tracks **conditioning**, not arithmetic.
  The best-conditioned window (poly\(_2\)) gives the cleanest stable sequence:
  \(0.0546,0.0489,0.0411\).
- This is evidence for a uniform positive gap in well-conditioned smooth
  families.  It does not prove one.

## 4. Caveats

- Finite \(K\le24\).
- Four window choices; other smooth windows may differ.
- Double precision; conditioning is the limiting factor.
- The CCM sign convention is still unsettled.

## 5. Next

1. Prove a lower bound for a well-conditioned smooth family, or pass to a
   continuum limit.
2. Use higher precision to push the poorly conditioned windows.
3. Pass to the Bost–Connes crossed product at \(\beta=1\).
4. Control the archimedean term separately.

## 6. Numerical check

[`../python/window_robustness.py`](../python/window_robustness.py) computes the
table.  The tests in
[`../tests/test_window_robustness.py`](../tests/test_window_robustness.py)
assert stability for the well-conditioned windows and the conditioning
advantage of poly\(_2\).

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Smooth-window stability](18-smooth-window-stability.md)
