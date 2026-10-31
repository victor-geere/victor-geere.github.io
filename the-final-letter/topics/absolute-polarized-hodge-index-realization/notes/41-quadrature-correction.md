# Quadrature correction: the weights, not the sign

**Status:** the archimedean-sign "correction" of notes 38–39 is **withdrawn**.
The fixed-grid archimedean sums in `python/rescue_probe.py` omitted the
quadrature weights `ws`, so the archimedean matrix was multiplied by
\(1/\Delta t\) (about \(12\times\) at the default grid). With the weights
restored and the integral evaluated exactly — sympy closed-form Fourier
transforms and `mp.quad` on \([0,\infty)\) — the sibling dossier's
**cosh / \(+\Omega\)** convention is the unique one that passes the compact
support test. The \(-\Omega\) form I proposed has a small negative residual.
The recorded normalization \(N\) remains rejected. The certificate below is
numerical, not interval-certified. No RH proof yet.

## 1. The bug

In `weil_compact_gram` and `weil_compact_gram_corrected` the archimedean
matrix was assembled as

```python
A = (1/pi) * ((FH * Om) @ FH.T)
```

with `FH` sampled on a grid of spacing \(\Delta t = t_{\max}/n_t\). The sum
therefore represented \( \Delta t^{-1}\int \) rather than \(\int\). At the
default grid \(\Delta t = 250/3000\), the archimedean term was inflated by
\(12\). This is not a truncation error: it is a weight error, and it reversed
the sign comparison.

The exact replacement is
`weil_compact_gram_exact` in
[`../python/rescue_probe.py`](../python/rescue_probe.py): the Fourier
transforms are exact (derivatives of the closed form
\(4(\sin t-t\cos t)/t^3\)), the archimedean integral runs to infinity with
`mp.quad`, and the prime sum is the exact finite sum \(n=2,\dots,7\) because
\(h=F*F_-\) is supported in \([-2,2]\).

## 2. The exact four-way test

\(4\times4\) basis \(F_k(x)=(1-x^2)_+x^{2k}\), \(k=0,\dots,3\), eigenvalues
of the Gram matrix:

| pole term | \(+\Omega\) | \(-\Omega\) |
|---|---|---|
| \(\cosh\): \(2\int h\cosh(u/2)\) | \(0,\ 1.1\cdot10^{-7},\ 9.98\cdot10^{-5},\ 1.67\cdot10^{-3}\) | \(-3.03\cdot10^{-4},\ -1.93\cdot10^{-5},\ 3.88\cdot10^{-2},\ 5.42\) |
| additive: \((\int F)^2+\widehat F(1)^2\) | \(-0.573,\ 1.1\cdot10^{-7},\ 3.00\cdot10^{-4},\ 1.09\cdot10^{-2}\) | \(-3.63\cdot10^{-4},\ -1.94\cdot10^{-5},\ 3.29\cdot10^{-2},\ 4.87\) |

Only the first entry is positive semidefinite (the zero eigenvalue is
numerical). The sibling dossier's convention — cosh pole, \(+\Omega\) — is
therefore the supported one on this rung.

**Round 12 verification.** The cosh \(+\Omega\) result is not a low-precision
artefact. At `dps=40` the \(4\times4\) spectrum is
\(1.28\cdot10^{-9},1.11\cdot10^{-7},9.96\cdot10^{-5},1.67\cdot10^{-3}\);
at `dps=30` the \(5\times5\) spectrum is
\(8\cdot10^{-12},3.2\cdot10^{-9},6.9\cdot10^{-7},1.2\cdot10^{-4},2.3\cdot10^{-3}\).
Both are positive at the numerical floor. The other three combinations remain
negative on the same tests.

## 3. What is withdrawn, what is retained

**Withdrawn.**

- The claim that the standard explicit formula forces \(-\Omega\) on this
  test. It was an artefact of the missing weights.
- The numbers \(-4.4\cdot10^{-3}\), \(-2.7\cdot10^{-4}\) and \(-2.06\cdot10^{1}\)
  in note 39: they came from the misnormalised sums.
- The interpretation of the \(-\Omega\) residual as the main open problem.

**Retained.**

- The recorded normalization \(N\) is still indefinite and rejected.
- The exact identities `arch_contour_identity` and `symbol_identity` are
  unchanged; they are statements about the symbols, not about which sign the
  finite functional uses.
- The Lean core, the rational shadows, the tensor-factor identity and the
  "No RH proof yet." status are unchanged.
- The finite certificate is numerical; an interval enclosure is still open.

## 4. Consequence for the programme

The finite, exact compact-support test now supports one normalization: the
sibling's cosh \(+\Omega\) functional. The immediate target is not "find the
sign" but "interval-certify the cosh \(+\Omega\) Gram matrix", then check the
Bost–Connes compatibility and attempt the cone.

This is a better position than note 39 recorded: the sign question is closed
on this rung, and the open question is quantitative (an interval bound), not
conceptual.

## 5. Bottom line

- The missing weights, not the sign, produced the \(-20.6\) verdict.
- The exact cosh \(+\Omega\) Gram is positive semidefinite on the tested
  basis; the other three combinations fail.
- The recorded \(N\) remains rejected; the finite evidence is numerical.
- No RH proof yet.

[Back to the dossier](../README.md) · [Rescue](38-rescue.md) ·
[Broad-test discrepancy](39-broad-test-discrepancy.md) ·
[Research journal](../research-journal.md)
