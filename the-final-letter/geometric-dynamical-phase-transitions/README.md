# Geometric dynamical phase transitions — paper bundle

This folder is a self-contained copy of the canonical paper `publication.html` and its local dependencies. It was assembled from the repository root so that the paper can be read, served, or archived without relying on sibling files elsewhere in the site.

## What is here

| File | Role |
|---|---|
| [`publication.html`](publication.html) | The canonical paper: geometric dynamical phase transitions and the spectral measure of the Riemann zeros. |
| [`publication-addendum-A.html`](publication-addendum-A.html) | Companion addendum: refined quadratic asymptotic for `η_N(N²)`. Not linked from the paper body, but part of the same publication corpus. |
| [`gaps.html`](gaps.html) | Gap inventory and closure checklist. |
| [`truths.md`](truths.md) | Ninety frozen truths, the last-chord pairing, and the remaining Jensen/Li gap. |
| [`todo.md`](todo.md) | Strengthening and construction checklist. |
| [`tensor.html`](tensor.html) | The prime-spectrum tensor companion. |
| [`viz.html`](viz.html) | Nested-spheres visualisation (Three.js). |
| [`projection.html`](projection.html) | Stereographic projection from the north pole. |
| [`geometric_dqpt_test.py`](geometric_dqpt_test.py) | Numerical companion to the geometric DQPT construction. |
| [`quantum_fisher_zeros_test.py`](quantum_fisher_zeros_test.py) | Numerical companion to Addendum F: Fisher zeros, clock zeros, and the zero-count checks. |
| [`maths/nested_spheres_RH.html`](maths/nested_spheres_RH.html) | Working note: nested spheres and Davenport rotations. |
| [`maths/continuous_cone_RH_solution.html`](maths/continuous_cone_RH_solution.html) | Working note: continuous-cone depth-of-closure bound. |
| [`maths/nested_spheres_RH.md`](maths/nested_spheres_RH.md) | Markdown source of the nested-spheres note. |
| [`maths/continuous_cone_RH_solution.md`](maths/continuous_cone_RH_solution.md) | Markdown source of the continuous-cone note. |

## Dependencies

The only external dependencies are **MathJax 3** (all mathematical pages) and **Three.js 0.160.0** (the `viz.html` and `projection.html` visualisations), both loaded from `cdn.jsdelivr.net`. There are no local scripts, stylesheets, fonts, or images required; every local link in the copied pages resolves inside this folder. The `maths/` subdirectory preserves the relative paths used by the paper.

## Status

The working notes in `maths/` claim a geometric proof of the Riemann hypothesis. The canonical paper does **not** adopt that claim: its changelog and `gaps.html` record the local-diagonal identity as false, and `summary/13-working-notes/` in the parent repository audits both notes claim by claim. The authoritative status remains the canonical paper and the [summary status ledger](../summary/STATUS.md).

[Back to the final letter](../index.html) · [Scraps](../scraps.html)
