# UV localization of the small eigenvector

> **Truncation diagnostic.** This note studies finite compressions, not the
> full-space spectral gap. It is superseded as evidence about the gap by
> [`22-continuum-gap.md`](22-continuum-gap.md).

**Status:** a diagnostic of the \(K=16\) near-degeneracy. The total small
eigenvector is localized in the highest sine modes, unlike the broad prime and
archimedean small eigenvectors. This indicates a high-frequency (UV)
truncation effect of the sharp sine basis, not a stable arithmetic mode. The
uniform-gap question remains open.

## 1. The measurement

For \(K=16\), project the prime, archimedean, and total antisymmetric forms
onto the degree-zero subspace and take the eigenvector of the smallest
\(|\mu|\).  Measure its effective number of modes

\[
\mathrm{PR}(v)=\frac{\left(\sum_j|v_j|^2\right)^2}{\sum_j|v_j|^4},
\]

the top four coefficients, and the fraction of the mass they carry.

## 2. The table

| part | \(\mu\) | effective modes | top indices | top mass |
|---|---|---|---|---|
| prime | \(0.01727\) | \(6.27\) | \(1,2,3,15\) | \(0.655\) |
| archimedean | \(0.23008\) | \(13.47\) | \(8,10,13,15\) | \(0.366\) |
| total | \(0.03701\) | \(4.74\) | \(12,13,14,15\) | \(0.839\) |

## 3. Interpretation

- The **total** small eigenvector is concentrated in the last four modes
  (\(12\)–\(15\)) and carries \(84\%\) of its mass there.  It is a
  high-frequency mode.
- The **prime** small eigenvector is broader (effective modes \(6.3\)), and
  the **archimedean** one is very broad (\(13.5\)).
- The total near-degeneracy at \(K=16\) is therefore a **high-frequency
  cancellation** between the prime and archimedean parts, not a localized
  arithmetic configuration.
- The sharp sine basis has a derivative discontinuity at the boundary, which
  produces high-frequency modes.  The \(K=16\) drop is plausibly a UV
  truncation artefact of this basis, not evidence that the gap collapses in a
  smooth limit.

This weakens the \(K=16\) near-degeneracy as evidence for a collapsing gap.
The uniform-gap question is still open: the sharp basis is well-conditioned
but has UV artefacts, while the windowed basis is smooth but ill-conditioned.

## 4. What would settle it

A **smooth, well-conditioned basis** — for example a smooth window with
orthogonalisation carried out in high precision, or a spectral basis with
controlled boundary behaviour — would test whether the UV-localized drop
persists.  If it disappears, the uniform-gap route is still viable; if it
persists, the gap question is genuinely arithmetic.

## 5. Numerical check

[`../python/uv_localization.py`](../python/uv_localization.py) computes the
three small eigenvectors and their participation ratios.  The tests in
[`../tests/test_uv_localization.py`](../tests/test_uv_localization.py) assert
the UV localization of the total vector and the broader prime/archimedean
vectors.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Prime versus archimedean gap](16-prime-archimedean-split.md)
