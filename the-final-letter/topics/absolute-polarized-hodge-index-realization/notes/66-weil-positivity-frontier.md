# Note 66 — Weil positivity: what is proved, what is not

**Status: No RH proof yet.** This note consolidates the positivity frontier
after the assembly of the Paley–Wiener chain (notes 64, 65) and the numerical
findings of rounds 440–446.

## 1. The functional

For a test function `g` on `[−1,1]` and `h = paleyWiener g`
(`h(s) = ∫_{−1}^{1} g(u)e^{i(s−1/2)u}du`), the **zero functional** is

`W(h) = Σ_ρ h(γ_ρ)`,

summed over the nontrivial zeros `ρ = β + iγ` of `ζ`. In the classical Weil
form the argument is the **real** `γ`; evaluating `h` at the complex zero
`1/2 + iγ` instead makes the sum diverge like `e^{γ}` (numerical witness:
round 446 gave `10⁸¹`), which is why the real-line evaluation is essential.

## 2. What is Lean-checked

- The test-function zero side `∮ Z'/Z·h = 2πi(Σh(ρ) − h(0) − h(1))`.
- The contour-shift identity for the Paley–Wiener class
  (`contour_shift_paleyWiener`).
- The three Fubini swaps (`Z'/Z`, `L_Λ`, `arch`) and the fully assembled
  `u`-superposition (`integral_logDeriv_paleyWiener_u_superposition`).
- The closed exponential-kernel prime sum.
- The **reality of the zero sum** (`sum_paleyWiener_conj_real`, the
  abstract-reflection form `finset_sum_conj_real_of_reflection`, and the
  conjugation-closed forms `finset_sum_conj_real_of_conj_closed` and
  `finset_sum_eq_sum_re_of_conj_closed`, the latter showing the sum reduces to
  the real parts; and the reflection form `finset_sum_eq_sum_re_of_reflection`,
  which uses the actual zero symmetry `ρ ↦ conj(1−ρ)`).
- The **reflection pairing** of zeros `ρ ↔ conj(1−ρ)`
  (`completedZeta_zero_conj_one_sub`), and the fact that the critical line is
  exactly its fixed locus, so RH is the statement that the reflection fixes
  every nontrivial zero (`completedZeta_re_eq_half_iff_conj_one_sub_eq_self`).
- The Fourier inversion (`fourier_inversion`).
- The finite-level cone positivity (`weil_cone_explicit` and its certificate
  layer).

### Lean-checked critical-line form

`paleyWiener_critical_line_eq_integral` gives `h(1/2+it) = ∫g(u)e^{−tu}du`, the
form in which the autocorrelation identity `∫(f⋆f*)e^{−tu} = |∫f e^{−tu}|²`
expresses termwise positivity. For the **pointwise nonnegative cone** the
positivity is Lean-checked: `paleyWiener_critical_line_ofReal` identifies the
value with the real integral `∫g(u)e^{−tu}du`, and
`paleyWiener_critical_line_ofReal_nonneg` shows it is a nonnegative real.

### Lean-checked positivity transfer

`sum_re_nonneg_of_each_nonneg` and `sum_nonneg_of_each_nonneg_real` formalise the
step "termwise nonnegative ⟹ sum nonnegative (and real)" for the zero sum.

## 3. The autocorrelation cone: a text-proof of termwise positivity

If `g` is the **convolution autocorrelation** `g(u) = ∫f(v)·conj(f(u−v))dv`,
then `∫g(u)e^{−tu}du = A·conj A = |A|² ≥ 0` where `A = ∫f(s)e^{−ts}ds`, so
the critical-line values are **termwise nonnegative**, and the zero sum
`W(h_g) = 2Σ_{γ>0} h_g(γ) ≥ 0` *provided all zeros lie on the critical line*.
This is the easy direction `RH ⟹ W ≥ 0`.

**Lean-checked (rounds 461–462):** `integrable_autocorrelation_kernel`
discharges the product-integrability hypothesis for compactly supported `f`;
`autocorrelation_exponential_eq_norm_sq_of_compactSupport` is the identity
unconditionally for such `f`; `autocorrelation_transform_nonneg` states that the
transform is a **nonnegative real number** (`Complex.normSq` of the Fourier
value); and for `f` supported in `[−1/2,1/2]` the transfer is complete:
`autocorrelation_eq_zero_off_Ioo` (vanishing off `(−1,1)`),
`paleyWiener_autocorrelation_eq_transform` (interval = full line) and
**`paleyWiener_autocorrelation_nonneg`**: the critical-line value
`h(1/2+it)` is a nonnegative real — the trivial direction of Weil positivity in
its sharpest form for the autocorrelation cone. Finally, assembled
(round 463): **`sum_paleyWiener_autocorrelation_nonneg_of_critical_line`** and
**`weil_zero_sum_nonneg_real_of_critical_line`** state that if every zero in `S`
lies on the critical line, the zero sum is a nonnegative real — i.e.
**RH ⟹ Weil positivity is Lean-checked** for the autocorrelation cone.

*Correction (round 460):* the identity requires the **convolution** form
`∫f(v)conj f(u−v)dv`, not the correlation form `∫f(v+u)conj f(v)dv`, which
gives `A·conj(∫f e^{tv}dv)` instead of `|A|²`. The convolution identity is now
**Lean-checked** (`autocorrelation_exponential_eq_norm_sq`, conditional on the
product integrability — automatic for compactly supported `f`), with the
supporting lemmas `conj_integral_exp` and `inner_shift`.

The substance of Weil's criterion is the converse: `W(h_g) ≥ 0` for all `g`
in the cone forces all zeros onto the line. The numerical evidence (round 446)
shows that outside the cone the functional is **negative** (`W ≈ −0.0138` for
`g(u) = (1−u²)²`), so the cone restriction is essential.

## 4. What is missing

1. **The Hadamard partial fraction** for `Z'/Z`:
   `Z'/Z(s) = Σ_ρ (1/(s−ρ) + 1/ρ) + (pole/archimedean terms)`.
   This is the bridge between the Euler-product side (Lean-checked) and the
   zero side, and the only known route to the classical Weil formula's
   constants. The dossier has the finite canonical-product machinery
   (`logDeriv_finiteCanonicalProduct`) but not the infinite product for `ξ`.
2. **Uniform positivity on the infinite-level cone** — RH-equivalent; note 61
   (the *Angular Bochner framework*) argues this must lie outside the finite
   angular/Bochner calculus.

### Numerical status of the partial fraction

`test_partial_fraction_sum_nearly_real` records that `S_N` at `x = 3` is
nearly real (`Im ≈ −0.0042`), and that its convergence is slow
(`≈ (log N)/N`): the extracted Hadamard constant drifts
(`−0.134, −0.138, −0.141` at `N = 50, 100, 200`), so an exact numerical
determination requires the Riemann–von Mangoldt counting and summation by
parts.

## 5. Honest summary

The discrete, finite-`T` and finite-level statements are Lean-checked or
numerically verified. The passage to the infinite level — either through the
Hadamard partial fraction or through uniform cone positivity — is the open,
RH-equivalent step. No claim of an RH proof is made.

**No RH proof yet.**
