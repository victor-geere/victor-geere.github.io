# Note 69 — Assessment of `zeta_cone_concepts.html`

**Status: No RH proof yet.** An external HTML/Three.js visualisation
(`~/Desktop/zeta_cone_concepts.html`) was supplied with the framing
"unconditional positivity of the zeta cone". This note records what the file
actually asserts, what is unconditional, and why it does not close the
RH-relevant gap.

## 1. What the file contains

It is a **browser visualisation** of the terms of the zeta series:

- each term `n^{−s}` is drawn at radius `n^{−σ}` and angle `−t ln n`;
- the height is chosen so the radial distance matches the term modulus, so the
  points lie on a right circular **cone** (a rendering device, not a
  mathematical cone of functions);
- a "cake slice" generator partitions the integers into finitely many angular
  sectors, each an infinite sub-series expressible as a linear combination of
  shifted zetas `ζ(s + imt)`.

## 2. The "unconditional positivity" line

The file states:

> The untwisted kernel `K(u) = sinc(tu)` (or Fejér) is of positive type by
> Bochner: its Fourier transform is a non-negative triangle. This is the one
> firm positive object; **arithmetic twists re-introduce open problems.**

This is correct as far as it goes, and it is **not** an RH statement:

- `sinc` is the Fourier transform of an indicator (up to normalisation), whose
  transform is non-negative — the classical Bochner-positive-definiteness of
  the untwisted kernel;
- the file itself concedes that the **arithmetic twist** is where the open
  problem lies.

## 3. Relation to the dossier

The dossier's own cone positivity (Weil's criterion) is exactly a statement
about the **arithmetic** (von Mangoldt-twisted) kernel:

- the **untwisted** positivity is the trivial/termwise part, and its analytic
  core is already Lean-checked here: `fourierG_one_eq`
  (`∫_{−1}^{1} e^{−ixu}du = 2 sin x/x`), the autocorrelation identity
  `autocorrelation_exponential_eq_norm_sq` (`∫(f⋆f*)e^{−tu} = |A|²`), and
  `paleyWiener_autocorrelation_nonneg`; the direction **RH ⟹ Weil positivity**
  is `weil_zero_sum_nonneg_real_of_critical_line`.
- the **arithmetic** positivity (positivity forcing the zeros onto the line) is
  the RH-equivalent statement recorded in notes 61 and 66 and remains open.

## 3b. Why no numerical test was added for the sinc claim

The untwisted statement "the Fourier transform of `sinc` is a non-negative
triangle/indicator" is the classical Dirichlet integral
`∫_ℝ sinc(x)e^{−iωx}dx = π·1_{|ω|<1}`, a textbook identity. A numerical check
would only re-verify a closed form (and the naive oscillatory quadrature is
numerically delicate), so no test was added: it would not test any programme
claim. The programme's *concrete* untwisted transforms are the ones already
Lean-checked (`fourierG_one_eq` and the autocorrelation identity).

## 4. Conclusion

The file is a visualisation with a correct remark about the untwisted kernel.
Its "unconditional positivity" is the untwisted Bochner positivity, which the
dossier already has (in Lean-checked form for the concrete transforms); it does
**not** establish positivity of the arithmetic zeta cone, and by its own text
the arithmetic twist "re-introduces open problems". No claim is upgraded.

**No RH proof yet.**
