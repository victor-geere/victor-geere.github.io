# The collapse: one exponential, four grids

**Kind:** Proposition
**Status:** VERIFIED (numerical; slope 3.070 within 2.3% of the prolate exponent π = 3.1416; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh32.html`](../../html/rh32.html) — §3 "The collapse: one exponential, four grids", lines 401–435 and boxed fit at lines 423–430

## Statement

> The identity reduces the whole question to one function: how fast does the top concentration eigenvalue approach the mass as the void widens? The classical prolate theory says the deficit 1 − l<sub>1</sub> depends on the void only through its *time-bandwidth* K = nW/2π — the width in units of the kernel wavelength 2π/n — and dies like e<sup>−πK</sup>. Both statements are measured here directly.
>
> Four crystal grids — M = 300 and 600, n = 60 and 120, sixteen nominal widths each — and the deficit collapses onto one curve in K (fig. 1, right). The two grids that share a lattice ratio share their achieved-width ladder exactly, and their deficits agree to 0.6% through K = 3.1 and within 8% out to K = 8.1 — where the deficit itself has fallen ten decades; the residual drift grows smoothly with K and is the finite-n correction to the continuum prolate limit, not scatter.
>
> ln(1 − l<sub>1</sub>) fitted over all four grids, K ∈ [3, 8.6], 44 points: slope α = 3.070, within 2.3% of the prolate exponent π = 3.1416; prefactor 16; every point within 0.22 in ln.
>
> So the crystal's certificate under a void is solved to measurement precision: λ<sub>min</sub>/mass = 1 − l<sub>1</sub>(K) exactly, and 1 − l<sub>1</sub>(K) ≈ 16·e<sup>−3.070K</sup> on the measured range.

## Hypotheses and notation

- l<sub>1</sub> is A's top concentration eigenvalue, so the deficit is 1 − l<sub>1</sub>; the certificate is λ<sub>min</sub>/mass = 1 − l<sub>1</sub>(K).
- K = nW/2π is the time-bandwidth of a void of width W at resolution n; the kernel wavelength is 2π/n.
- The four grids are M = 300, 600 and n = 60, 120, with sixteen nominal widths each; the fit uses K ∈ [3, 8.6] and 44 points.
- Two quantisation notes from the source: the crystal can only cut voids at lattice widths, so points are plotted at their *achieved* K, and at special nominal widths the deletion boundary lands on an atom pair shifting the achieved K by one lattice step.

## Proof / evidence

Numerical measurement of the classical prolate K-dependence and decay rate. The source records both statements as classical predictions measured directly, with the fitted slope α = 3.070 against π = 3.1416, prefactor 16, every point within 0.22 in ln.

## Dependencies and related results

- [rh32-void-identity](rh32-void-identity.md) — reduces the question to the top concentration eigenvalue.
- [rh32-death-of-the-constant](rh32-death-of-the-constant.md) — combines this deficit with the ceiling law to get c(K).
- rh32 §7 notes "the concentration step ... is the classical prolate theory, measured here to 6.2%; on the crystal it is exact".

## Notes


- Status VERIFIED rather than CITED: the source says "Both statements are measured here directly" and reports its own fit; the K-dependence itself is attributed to classical prolate theory.
- The prefactor 16 and the exponent 3.070 are the source's fitted values on the measured range, not exact constants.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
