# Note 64 — the Fourier-inversion bridge: plan and status

**Status: No RH proof yet.** This note records the plan for the missing
**Fourier-inversion** step of the critical-line route (note 60), and the
current Lean status of its components.

## 1. What Mathlib provides

Mathlib has the full-line Fourier transform `𝓕` (a typeclass instance on
function spaces) and the **inversion theorem**:

- `MeasureTheory.Integrable.fourierInv_fourier_eq`
  (`Integrable f → Integrable (𝓕 f) → ContinuousAt f v → 𝓕⁻ (𝓕 f) v = f v`),
- `Continuous.fourierInv_fourier_eq`
  (`Continuous f → Integrable f → Integrable (𝓕 f) → 𝓕⁻ (𝓕 f) = f`),

in `Mathlib/Analysis/Fourier/Inversion.lean`.

## 2. The bridge to `fourierG`

Let `g : ℝ → ℂ` be supported on `[−1,1]` and set `g_ext = 1_{[−1,1]} · g`
(extension by zero). Then

`𝓕 g_ext (v) = ∫_{−1}^{1} g(u)·e^{−2πi v u} du = fourierG g (2π v)`,

using Mathlib's convention `𝓕 f v = ∫ x, e^{−2πi v·x} f x dx`. Consequently
Fourier inversion gives, at continuity points `u` of `g_ext`,

`g(u) = ∫_ℝ e^{2πi u v}·fourierG g (2π v) dv` (for `u ∈ (−1,1)`).

## 3. What is Lean-checked already

- `fourierG` and all its structural properties: linearity
  (`fourierG_add`, `fourierG_sub`, `fourierG_neg`, `fourierG_const_mul`,
  `fourierG_zero`, `fourierG_finset_sum`, `fourierG_congr`), symmetries
  (`fourierG_even`, `fourierG_conj`, `fourierG_real_conj`,
  `fourierG_conj_shift`), continuity (`continuous_fourierG`), `L¹` bound
  (`norm_fourierG_le`, `norm_fourierG_le_div`), modulation
  (`fourierG_modulation`), derivative correspondence
  (`hasDerivAt_fourierG`, `deriv_fourierG`, `hasDerivAt_fourierG_moment`,
  `iteratedDeriv_fourierG`), the Riemann–Lebesgue limit
  (`tendsto_fourierG_atTop`), and the closed transforms of `1`, `c`,
  `e^{bu}`, `e^{iau}`, `c·e^{iau}`, `cos(au)`, `sin(au)`, `u`, `u²`, `u³`.

## 4. What remains for the bridge

1. **Define `g_ext`** (indicator of `[−1,1]`) and prove **integrability**
   (from continuity on the compact interval).
2. ~~Identify `𝓕 g_ext v = fourierG g (2π v)`~~ — **done**:
   `fourier_fourierGExt` (with `fourierGExt`) and `integrable_fourierGExt`.
3. **Integrability of `𝓕 g_ext`**: the `C²` decay is now Lean-checked —
   `norm_fourierG_le_div_sq` gives
   `‖ĝ(x)‖ ≤ A/|x| + B/|x|²`, which is integrable on `|x| ≥ 1`; the
   compactness of `[−1,1]` handles the rest. What remains is transporting
   this bound across the `𝓕`–`fourierG` identification (step 2).
4. ~~Apply `Integrable.fourierInv_fourier_eq` at interior points~~ —
   **DONE, unconditionally**: `integrable_fourier_fourierGExt` proves the
   integrability of `𝓕 g_ext` for `C²` `g` with `g(±1) = 0` (the vanishing
   endpoints kill the `1/|x|` boundary term, leaving pure `1/|x|²` decay),
   and `fourier_inversion` gives `𝓕⁻ (𝓕 g_ext) u = g u` for `u ∈ (−1,1)`.

**The Fourier-inversion step of the critical-line route is complete.**

Step 3 is the main remaining work; step 2 is bookkeeping; steps 1 and 4 are
applications of existing Mathlib lemmas.

**No RH proof yet.**
