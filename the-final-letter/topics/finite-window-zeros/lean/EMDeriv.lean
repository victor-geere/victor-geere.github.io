import EMBox14

/-!
# Derivatives of the Euler–Maclaurin base terms in `s`

Step 4 of the handoff needs `ζ′`, hence the derivative of the explicit Euler–Maclaurin
expression in `s`.  Mathlib has no `HasDerivAt (fun s => b ^ s)`, so this file builds
the chain from `Complex.cpow_def`:

`b ^ z = exp (z * log b)`, so `d/dz b^z = b^z * log b` and `d/dz b^{-z} = -(b^{-z} log b)`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open Filter Topology
open PartialTail

/-- **`d/dz b^z = b^z · log b`** for `b ≠ 0`. -/
theorem hasDerivAt_cpow_exp {b : ℂ} (hb : b ≠ 0) (s : ℂ) :
    HasDerivAt (fun z : ℂ => b ^ z) (b ^ s * Complex.log b) s := by
  have h1 : HasDerivAt (fun z : ℂ => z * Complex.log b) (Complex.log b) s := by
    simpa using (hasDerivAt_id s).mul_const (Complex.log b)
  have h2 : HasDerivAt (fun z : ℂ => Complex.exp (z * Complex.log b))
      (Complex.exp (s * Complex.log b) * Complex.log b) s :=
    (Complex.hasDerivAt_exp (s * Complex.log b)).comp s h1
  have hfun : (fun z : ℂ => b ^ z) = fun z => Complex.exp (z * Complex.log b) := by
    funext z
    rw [Complex.cpow_def, if_neg hb, mul_comm]
  have hval : Complex.exp (s * Complex.log b) * Complex.log b = b ^ s * Complex.log b := by
    rw [Complex.cpow_def, if_neg hb, mul_comm (Complex.log b) s]
  rw [hval] at h2
  rw [hfun]
  exact h2

/-- **`d/dz b^{-z} = -(b^{-z} · log b)`** for `b ≠ 0`. -/
theorem hasDerivAt_cpow_neg {b : ℂ} (hb : b ≠ 0) (s : ℂ) :
    HasDerivAt (fun z : ℂ => b ^ (-z)) (-(b ^ (-s) * Complex.log b)) s := by
  have h1 : HasDerivAt (fun z : ℂ => -z) (-1) s := hasDerivAt_neg s
  have h2 : HasDerivAt (fun z : ℂ => b ^ (-z)) ((b ^ (-s) * Complex.log b) * (-1)) s :=
    (hasDerivAt_cpow_exp hb (-s)).comp s h1
  convert h2 using 1
  ring

/-- **The base sum, differentiated.**  `d/ds Σ_{n<N} (n+1)^{-s} = -Σ (n+1)^{-s} log (n+1)`. -/
theorem hasDerivAt_sum_cpow (N : ℕ) (s : ℂ) :
    HasDerivAt (fun z : ℂ => ∑ n ∈ Finset.range N, ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
      (-∑ n ∈ Finset.range N,
        ((((n + 1 : ℝ)) : ℂ) ^ (-s)) * Complex.log ((((n + 1 : ℝ)) : ℂ))) s := by
  have h : ∀ n ∈ Finset.range N,
      HasDerivAt (fun z : ℂ => ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
        (-(((((n + 1 : ℝ)) : ℂ) ^ (-s)) * Complex.log ((((n + 1 : ℝ)) : ℂ)))) s := by
    intro n _
    have hb : ((((n + 1 : ℝ)) : ℂ)) ≠ 0 := by
      have hpos : (0 : ℝ) < ((n : ℝ) + 1) := by positivity
      exact_mod_cast hpos.ne'
    simpa using hasDerivAt_cpow_neg hb s
  have hs := HasDerivAt.sum h
  have hfun : (∑ x ∈ Finset.range N, fun z : ℂ => ((((x + 1 : ℝ)) : ℂ) ^ (-z)))
      = fun z : ℂ => ∑ x ∈ Finset.range N, ((((x + 1 : ℝ)) : ℂ) ^ (-z)) := by
    funext z
    simp [Finset.sum_apply]
  rw [hfun] at hs
  simpa [Finset.sum_neg_distrib] using hs

/-- **`d/dz 21^(1-z) = -log 21 · 21^(1-s)`.** -/
theorem hasDerivAt_pow21_one_sub (s : ℂ) :
    HasDerivAt (fun z : ℂ => (21 : ℂ) ^ (1 - z)) (-(Complex.log 21) * (21 : ℂ) ^ (1 - s)) s := by
  have hg : HasDerivAt (fun z : ℂ => 1 - z) (-1) s :=
    (hasDerivAt_id s).const_sub (1 : ℂ)
  have h := (hasDerivAt_cpow_exp (b := (21 : ℂ)) (by norm_num) (1 - s)).comp s hg
  have hfun : ((fun z : ℂ => (21 : ℂ) ^ z) ∘ (fun z : ℂ => 1 - z)) =
      fun z : ℂ => (21 : ℂ) ^ (1 - z) := rfl
  rw [hfun] at h
  convert h using 1
  ring

/-- **`d/dz 21^(-z) = -log 21 · 21^(-s)`.** -/
theorem hasDerivAt_pow21_neg (s : ℂ) :
    HasDerivAt (fun z : ℂ => (21 : ℂ) ^ (-z)) (-(Complex.log 21) * (21 : ℂ) ^ (-s)) s := by
  have h := hasDerivAt_cpow_neg (b := (21 : ℂ)) (by norm_num) s
  convert h using 1
  ring

/-- **The pole term, differentiated:**
`d/dz [21^(1-z)/(z-1)] = 21^(1-s)·(-log21/(s-1) - 1/(s-1)²)`. -/
theorem hasDerivAt_pole (s : ℂ) (hs : s ≠ 1) :
    HasDerivAt (fun z : ℂ => (21 : ℂ) ^ (1 - z) / (z - 1))
      ((21 : ℂ) ^ (1 - s) * (-(Complex.log 21) / (s - 1) - 1 / (s - 1) ^ 2)) s := by
  have hnum := hasDerivAt_pow21_one_sub s
  have hden : HasDerivAt (fun z : ℂ => z - 1) (1 : ℂ) s :=
    (hasDerivAt_id s).sub_const (1 : ℂ)
  have hne : (s - 1) ≠ 0 := sub_ne_zero.mpr hs
  have hinv : HasDerivAt (fun z : ℂ => (z - 1)⁻¹) (-1 / (s - 1) ^ 2) s := hden.inv hne
  have h := hnum.mul hinv
  have hfun : (fun z : ℂ => (21 : ℂ) ^ (1 - z) / (z - 1))
      = fun z : ℂ => (21 : ℂ) ^ (1 - z) * (z - 1)⁻¹ := by
    funext z
    rw [div_eq_mul_inv]
  rw [hfun]
  convert h using 1
  field_simp
  ring

/-- **The `deriv` bridge.**  `ζ` and `zetaEM 20` agree on a neighbourhood of
`s14` (both are analytic on the strip `0 < Re s`, `1 < Im s < 20`), so their
derivatives agree there.  This lets `deriv riemannZeta s14` be replaced by the
explicit `deriv (zetaEM 20) s14`. -/
theorem deriv_zeta_eq_deriv_zetaEM :
    deriv riemannZeta s14 = deriv (zetaEM 20) s14 := by
  have heq : riemannZeta =ᶠ[𝓝 s14] zetaEM 20 := by
    filter_upwards [Metric.ball_mem_nhds s14 (by norm_num : (0 : ℝ) < 1 / 2)] with z hz
    have hd : ‖z - s14‖ < 1 / 2 := by
      simpa [dist_eq_norm] using Metric.mem_ball.mp hz
    have hre : (z - s14).re = z.re - s14.re := Complex.sub_re _ _
    have him : (z - s14).im = z.im - s14.im := Complex.sub_im _ _
    have h1 : |z.re - s14.re| ≤ ‖z - s14‖ := by
      have := Complex.abs_re_le_norm (z - s14)
      rwa [hre] at this
    have h2 : |z.im - s14.im| ≤ ‖z - s14‖ := by
      have := Complex.abs_im_le_norm (z - s14)
      rwa [him] at this
    have hsre : s14.re = 1 / 2 := by norm_num [s14]
    have hsim : s14.im = 14 := by norm_num [s14]
    rw [hsre] at h1
    rw [hsim] at h2
    refine zeta_eq_zetaEM_of_im 20 ?_ ?_ ?_
    · have hlt : |z.re - 1 / 2| < 1 / 2 := lt_of_le_of_lt h1 hd
      have := (abs_lt.mp hlt).1
      linarith
    · have hlt : |z.im - 14| < 1 / 2 := lt_of_le_of_lt h2 hd
      have := (abs_lt.mp hlt).1
      linarith
    · have hlt : |z.im - 14| < 1 / 2 := lt_of_le_of_lt h2 hd
      have := (abs_lt.mp hlt).2
      linarith
  exact heq.deriv_eq

/-- **`d/dz b^(-(z+c)) = -log b · b^(-(z+c))`** for `b ≠ 0`: the `B₂` boundary
term `s·21^(-(s+1))` needs the case `c = 1`. -/
theorem hasDerivAt_cpow_neg_shift {b : ℂ} (hb : b ≠ 0) (c s : ℂ) :
    HasDerivAt (fun z : ℂ => b ^ (-(z + c))) (-(Complex.log b) * b ^ (-(s + c))) s := by
  have hg : HasDerivAt (fun z : ℂ => z + c) (1 : ℂ) s :=
    (hasDerivAt_id s).add_const c
  have h := (hasDerivAt_cpow_neg hb (s + c)).comp s hg
  have hfun : ((fun z : ℂ => b ^ (-z)) ∘ (fun z : ℂ => z + c)) =
      fun z : ℂ => b ^ (-(z + c)) := rfl
  rw [hfun] at h
  convert h using 1
  ring

/-- **The explicit Euler–Maclaurin expression, as a function of `s`.**  This is
T315 with `s14` replaced by a variable, which is what the derivative needs. -/
theorem zetaEMGen_one_fun (s : ℂ) :
    zetaEMGen 1 20 s =
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s)))
        + (21 : ℂ) ^ (1 - s) / (s - 1) + (21 : ℂ) ^ (-s) / 2
        + (1 / 12 : ℂ) * s * (21 : ℂ) ^ (-(s + 1)) := by
  rw [zetaEMGen_one, zetaBase]
  simp only [emGShift, descPochhammer, Polynomial.eval_one, one_mul]
  have h1 : (((↑(20 : ℕ) : ℝ) + 1 : ℝ) : ℂ) = (21 : ℂ) := by norm_num
  have h2 : (((0 : ℝ) + (↑(20 : ℕ) : ℝ) + 1 : ℝ) : ℂ) = (21 : ℂ) := by norm_num
  rw [h1, h2]
  rw [show (-(s + (↑(0 : ℕ) : ℂ)) : ℂ) = -s by norm_num]

/-- **The derivative of `zetaEMGen 1 20`**, in explicit form. -/
theorem hasDerivAt_zetaEMGen_one (s : ℂ) (hs : s ≠ 1) :
    HasDerivAt (zetaEMGen 1 20)
      (-(∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s)) * Complex.log ((((n + 1 : ℝ)) : ℂ)))
        + (21 : ℂ) ^ (1 - s) * (-(Complex.log 21) / (s - 1) - 1 / (s - 1) ^ 2)
        - Complex.log 21 * (21 : ℂ) ^ (-s) / 2
        + (1 / 12 : ℂ) * ((21 : ℂ) ^ (-(s + 1)) + s * (-(Complex.log 21) * (21 : ℂ) ^ (-(s + 1))))) s := by
  have hfun : zetaEMGen 1 20 = fun z : ℂ =>
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
        + (21 : ℂ) ^ (1 - z) / (z - 1) + (21 : ℂ) ^ (-z) / 2
        + (1 / 12 : ℂ) * z * (21 : ℂ) ^ (-(z + 1)) :=
    funext zetaEMGen_one_fun
  rw [hfun]
  have hsum := hasDerivAt_sum_cpow 20 s
  have hpole := hasDerivAt_pole s hs
  have hpow := hasDerivAt_pow21_neg s
  have hhalf : HasDerivAt (fun z : ℂ => (21 : ℂ) ^ (-z) / 2)
      (-(Complex.log 21) * (21 : ℂ) ^ (-s) / 2) s := hpow.div_const 2
  have hz : HasDerivAt (fun z : ℂ => z) (1 : ℂ) s := hasDerivAt_id s
  have hsh := hasDerivAt_cpow_neg_shift (b := (21 : ℂ)) (by norm_num) 1 s
  have hb2 : HasDerivAt (fun z : ℂ => (1 / 12 : ℂ) * z * (21 : ℂ) ^ (-(z + 1)))
      ((1 / 12 : ℂ) * ((21 : ℂ) ^ (-(s + 1)) + s * (-(Complex.log 21) * (21 : ℂ) ^ (-(s + 1))))) s := by
    have h := (hz.const_mul (1 / 12 : ℂ)).mul hsh
    convert h using 1
    ring
  have hall := ((hsum.add hpole).add hhalf).add hb2
  convert hall using 1
  ring

/-! ## The `ζ′` enclosure

`deriv (zetaEMGen 1 20) s14` is T339's expression at `s14`.  Every `21`-power in
it is a rational multiple of the single atom `21^{-s14}`, so the whole enclosure
is `-Σ n^{-s14} log n` plus one atom times a rational-scalar box. -/

/-- `n^{-s14} · log n` — one atom of the derivative sum. -/
def derivAtom (n : ℕ) : Cx :=
  (cpowBox 20 16 48 24 n S14).mul ⟨logIvRat 20 n, ⟨0, 0⟩⟩

/-- The fold of `derivAtom` over `n = 1..M`. -/
def dsPow : ℕ → Cx
  | 0 => ⟨⟨0, 0⟩, ⟨0, 0⟩⟩
  | (M + 1) => (dsPow M).add (derivAtom (M + 1))

/-- The rational scalar multiplying `21^{-s14}`:
`A0 + A1·log 21` with
`A0 = 17190769/155288700 - (4704/616225)i` and
`A1 = -177437/395640 + (20383/14130)i`. -/
def scalarBox : Cx :=
  (ptBox (17190769 / 155288700) (-4704 / 616225)).add
    ((ptBox (-177437 / 395640) (20383 / 14130)).mul ⟨logIvRat 20 21, ⟨0, 0⟩⟩)

/-- Enclosure of `deriv (zetaEMGen 1 20) s14`. -/
def Vbox : Cx :=
  (dsPow 20).neg.add ((cpowBox 20 16 48 24 21 S14).mul scalarBox)

theorem mem_logBox (N b : ℕ) (hb : 1 ≤ b) :
    (⟨logIvRat N b, (⟨0, 0⟩ : Iv)⟩ : Cx).mem (((Real.log (b : ℝ)) : ℝ) : ℂ) := by
  refine ⟨?_, ?_⟩
  · exact logIvRat_mem hb
  · simp only [Iv.memR, Complex.ofReal_im]
    norm_num

/-- **Fold soundness** for the derivative sum. -/
theorem dsPow_mem (M : ℕ)
    (h : ∀ n, n < M → CpowConditions 20 16 48 24 (n + 1) S14) :
    (dsPow M).mem
      (∑ n ∈ Finset.range M,
        ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14)) * (((Real.log ((n + 1 : ℕ) : ℝ)) : ℝ) : ℂ)) := by
  induction M with
  | zero => simp [dsPow, Cx.mem, Iv.memR]
  | succ M ih =>
      rw [dsPow, Finset.sum_range_succ]
      apply Cx.mem_add
      · exact ih (fun n hn => h n (by omega))
      · obtain ⟨hb, hk, hkI, hn, he1, he2, hI1, hI2⟩ := h M (by omega)
        exact Cx.mem_mul (cpowBox_mem hb mem_S14 hk hkI hn he1 he2 hI1 hI2)
          (mem_logBox 20 (M + 1) (by omega))

-- `ζ′(s14) ≈ 0.7482337 + 0.2044365i`, so `|V| ≈ 0.776`.
example : (maxAbsIv Vbox.re) ^ 2 + (maxAbsIv Vbox.im) ^ 2 ≤ ((4 / 5 : ℚ)) ^ 2 := by
  native_decide

/-! ## Folding the `21`-powers onto one atom -/

/-- `21^(1-s) = 21 · 21^(-s)`. -/
theorem pow21_one_sub (s : ℂ) : (21 : ℂ) ^ (1 - s) = 21 * (21 : ℂ) ^ (-s) := by
  rw [show (1 : ℂ) - s = (1 : ℂ) + (-s) by ring,
    Complex.cpow_add _ _ (by norm_num : (21 : ℂ) ≠ 0), Complex.cpow_one]

/-- `21^(-(s+1)) = 21^(-s) / 21`. -/
theorem pow21_neg_succ (s : ℂ) : (21 : ℂ) ^ (-(s + 1)) = (21 : ℂ) ^ (-s) / 21 := by
  rw [show -(s + 1) = (-s) + (-1 : ℂ) by ring,
    Complex.cpow_add _ _ (by norm_num : (21 : ℂ) ≠ 0), Complex.cpow_neg_one,
    div_eq_mul_inv]

/-! ## The scalar identities behind `Vbox` -/

/-- Coefficient of `log 21` in the `ζ′` scalar. -/
def A1c : ℂ := ((-177437 / 395640 : ℝ) : ℂ) + ((20383 / 14130 : ℝ) : ℂ) * Complex.I

/-- Constant part of the `ζ′` scalar. -/
def A0c : ℂ := ((17190769 / 155288700 : ℝ) : ℂ) + ((-4704 / 616225 : ℝ) : ℂ) * Complex.I

theorem s14_ne_one : s14 ≠ 1 := by
  intro h
  have him := congrArg Complex.im h
  simp [s14] at him

theorem A1_eq : 21 * (-1 / (s14 - 1)) - 1 / 2 - s14 / 252 = A1c := by
  rw [show (-1 : ℂ) / (s14 - 1) = -1 * (1 / (s14 - 1)) by ring, inv_s14_sub_one,
    show s14 / 252 = s14 * (1 / 252 : ℂ) by ring]
  apply Complex.ext <;>
    simp [A1c, s14, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
      Complex.neg_re, Complex.neg_im, Complex.sub_re, Complex.sub_im,
      Complex.I_re, Complex.I_im] <;>
    norm_num

theorem A0_eq : 21 * (-1 / (s14 - 1) ^ 2) + 1 / 252 = A0c := by
  rw [show (-1 : ℂ) / (s14 - 1) ^ 2 = -((1 / (s14 - 1)) ^ 2) by
        rw [one_div_pow]; ring,
    inv_s14_sub_one]
  apply Complex.ext <;>
    simp [A0c, s14, pow_two, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im,
      Complex.neg_re, Complex.neg_im, Complex.sub_re, Complex.sub_im,
      Complex.I_re, Complex.I_im] <;>
    norm_num

/-- **The `ζ′` scalar, factored.**  The `21`-part of T339 at `s14` is
`21^{-s14}` times `log21·A1 + A0`. -/
theorem scalar_eq_deriv :
    21 * (-Complex.log 21 / (s14 - 1) - 1 / (s14 - 1) ^ 2) - Complex.log 21 / 2
      + (1 / 12) * (1 / 21 - s14 * Complex.log 21 / 21)
    = Complex.log 21 * A1c + A0c := by
  have h1 := A1_eq
  have h0 := A0_eq
  linear_combination Complex.log 21 * h1 + h0

/-- **The `log` bridge.**  `dsPow_mem` records `↑(Real.log b)`; T339 uses
`Complex.log ↑b`.  This is the rewrite between them. -/
theorem ofReal_log_natCast (b : ℕ) (hb : 1 ≤ b) :
    ((Real.log (b : ℝ) : ℝ) : ℂ) = Complex.log ((b : ℝ) : ℂ) :=
  Complex.ofReal_log (by positivity)

/-- **`V` refactored.**  T339's derivative at `s14`, with the `21`-powers folded
onto `21^{-s14}` (T342/T343) and the scalar factored (T347). -/
theorem V_eq :
    -(∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s14)) * Complex.log ((((n + 1 : ℝ)) : ℂ)))
        + (21 : ℂ) ^ (1 - s14) * (-(Complex.log 21) / (s14 - 1) - 1 / (s14 - 1) ^ 2)
        - Complex.log 21 * (21 : ℂ) ^ (-s14) / 2
        + (1 / 12 : ℂ) * ((21 : ℂ) ^ (-(s14 + 1))
            + s14 * (-(Complex.log 21) * (21 : ℂ) ^ (-(s14 + 1))))
      = -(∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s14)) * Complex.log ((((n + 1 : ℝ)) : ℂ)))
        + (21 : ℂ) ^ (-s14) * (Complex.log 21 * A1c + A0c) := by
  rw [pow21_one_sub, pow21_neg_succ]
  linear_combination ((21 : ℂ) ^ (-s14)) * scalar_eq_deriv

/-- **The `log` box, phrased with `Complex.log`** so that the membership proof
does not have to bridge `↑(Real.log b)` to `Complex.log ↑b` inside the goal. -/
theorem mem_logBox' (N b : ℕ) (hb : 1 ≤ b) :
    (⟨logIvRat N b, (⟨0, 0⟩ : Iv)⟩ : Cx).mem (Complex.log (((b : ℕ) : ℝ) : ℂ)) := by
  rw [← ofReal_log_natCast b hb]
  exact mem_logBox N b hb

/-- **The cast bridge for the `21` base.**  `cpowBox`/`logIvRat` are keyed by
`b : ℕ`, so their values are phrased with `(((21:ℕ):ℝ):ℂ)`; the derivative
lemmas use `(21:ℂ)`.  This is the rewrite between them. -/
theorem cpow21_base : (21 : ℂ) = (((↑(21 : ℕ) : ℝ)) : ℂ) := by norm_num

/-- **`h1(a)`: the `ζ′` membership.**  `deriv (zetaEMGen 1 20) s14` lies in `Vbox`. -/
theorem mem_Vbox : Cx.mem (deriv (zetaEMGen 1 20) s14) Vbox := by
  rw [(hasDerivAt_zetaEMGen_one s14 s14_ne_one).deriv, V_eq, cpow21_base, Vbox, scalarBox]
  apply Cx.mem_add
  · apply Cx.mem_neg
    have h := dsPow_mem 20 (sumOK_conditions (by native_decide : sumOK 20 = true))
    have hbridge : (∑ n ∈ Finset.range 20,
          ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14)) * (((Real.log ((n + 1 : ℕ) : ℝ)) : ℝ) : ℂ))
        = ∑ n ∈ Finset.range 20,
            ((((n + 1 : ℝ)) : ℂ) ^ (-s14)) * Complex.log ((((n + 1 : ℝ)) : ℂ)) := by
      apply Finset.sum_congr rfl
      intro n _
      have hc : ((((n + 1 : ℕ) : ℝ)) : ℂ) = ((((n + 1 : ℝ)) : ℂ)) := by
        push_cast
        ring
      rw [ofReal_log_natCast (n + 1) (by omega), hc]
    rw [hbridge] at h
    exact h
  · apply Cx.mem_mul
    · obtain ⟨hb, hk, hkI, hn, he1, he2, hI1, hI2⟩ :=
        CpowConditions_of_OK (by native_decide : CpowOK 20 16 48 24 21 S14 = true)
      exact cpowBox_mem hb mem_S14 hk hkI hn he1 he2 hI1 hI2
    · have h0 : (ptBox (17190769 / 155288700) (-4704 / 616225)).mem A0c := by
        apply mem_ptBox <;> simp [A0c]
      have h1 : (ptBox (-177437 / 395640) (20383 / 14130)).mem A1c := by
        apply mem_ptBox <;> simp [A1c]
      have hl : (⟨logIvRat 20 21, (⟨0, 0⟩ : Iv)⟩ : Cx).mem
          (Complex.log (((↑(21 : ℕ) : ℝ)) : ℂ)) :=
        mem_logBox' 20 21 (by norm_num)
      have hm := Cx.mem_mul h1 hl
      have hsum := Cx.mem_add h0 hm
      convert hsum using 1
      ring

/-! ## `rpow` bounds for the residual ball (`h1(b)`) -/

/-- `21^(-7/2) <= 1/9261 = 21^(-3)`. -/
theorem pow21_neg_seven_half : (21 : ℝ) ^ (-(7 : ℝ) / 2) ≤ 1 / 9261 := by
  have h1 : (21 : ℝ) ^ (-(7 : ℝ) / 2) ≤ (21 : ℝ) ^ (-(3 : ℝ)) := by
    apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
    norm_num
  rw [pow21_neg_three] at h1
  exact h1

/-- `21^(-11/2) <= 1/4084101 = 21^(-5)`. -/
theorem pow21_neg_eleven_half : (21 : ℝ) ^ (-(11 : ℝ) / 2) ≤ 1 / 4084101 := by
  have h1 : (21 : ℝ) ^ (-(11 : ℝ) / 2) ≤ (21 : ℝ) ^ (-(5 : ℝ)) := by
    apply Real.rpow_le_rpow_of_exponent_le (by norm_num)
    norm_num
  have h5 : (21 : ℝ) ^ (-(5 : ℝ)) = 1 / 4084101 := by
    rw [show (-(5 : ℝ)) = ((-5 : ℤ) : ℝ) by norm_num, Real.rpow_intCast]
    norm_num
  rw [h5] at h1
  exact h1

/-! ## Pochhammer bounds on the radius-`0.35` ball (`h1(b)`) -/

/-- On the `0.35`-ball, `|s| <= 14.85`. -/
theorem norm_le_ball {s : ℂ} (hs : ‖s - s14‖ ≤ (0.35 : ℝ)) : ‖s‖ ≤ (14.85 : ℝ) := by
  have h1 : ‖s‖ ≤ ‖s - s14‖ + ‖s14‖ := by
    have h := norm_add_le (s - s14) s14
    simpa using h
  have h2 : ‖s14‖ ≤ (14.5 : ℝ) := norm_s14_le
  linarith

/-- Triangle step used by the Pochhammer ball bounds. -/
theorem ball_add_le {s : ℂ} {r : ℝ} (hs : ‖s - s14‖ ≤ r) {c : ℝ} {t : ℂ}
    (hk : ‖s14 + t‖ ≤ c) (hr : (0:ℝ) ≤ r) (hc : (0:ℝ) ≤ c) :
    ‖s + t‖ ≤ r + c := by
  have h : ‖s + t‖ ≤ ‖s - s14‖ + ‖s14 + t‖ := by
    have h0 := norm_add_le (s - s14) (s14 + t)
    rwa [show s - s14 + (s14 + t) = s + t by ring] at h0
  linarith

/-- On the `0.35`-ball, `‖P₃(s)‖ <= 4500`. -/
theorem norm_P3_ball {s : ℂ} (hs : ‖s - s14‖ ≤ (0.35 : ℝ)) :
    ‖(descPochhammer ℂ 3).eval (-s)‖ ≤ (4500 : ℝ) := by
  have h3 : (descPochhammer ℂ 3).eval (-s) = (-s) * (-s - 1) * (-s - 2) := by
    simp [descPochhammer]
    ring
  rw [h3, norm_mul, norm_mul]
  have hA : ‖-s‖ = ‖s‖ := norm_neg s
  have hB : ‖-s - 1‖ = ‖s + 1‖ := by rw [show -s - 1 = -(s + 1) by ring, norm_neg]
  have hC : ‖-s - 2‖ = ‖s + 2‖ := by rw [show -s - 2 = -(s + 2) by ring, norm_neg]
  rw [hA, hB, hC]
  have p1 : ‖s‖ ≤ (14.85 : ℝ) := norm_le_ball hs
  have p2 : ‖s + 1‖ ≤ (15.85 : ℝ) := by
    have h : ‖s + 1‖ ≤ ‖s - s14‖ + ‖s14 + 1‖ := by
      have h0 := norm_add_le (s - s14) (s14 + 1)
      rwa [show s - s14 + (s14 + 1) = s + 1 by ring] at h0
    have h' : ‖s14 + 1‖ ≤ (15.5 : ℝ) := norm_s14_add_one_le
    linarith
  have p3 : ‖s + 2‖ ≤ (16.85 : ℝ) := by
    have h : ‖s + 2‖ ≤ ‖s - s14‖ + ‖s14 + 2‖ := by
      have h0 := norm_add_le (s - s14) (s14 + 2)
      rwa [show s - s14 + (s14 + 2) = s + 2 by ring] at h0
    have h' : ‖s14 + 2‖ ≤ (16.5 : ℝ) := norm_s14_add_two_le
    linarith
  have m1 : ‖s‖ * ‖s + 1‖ ≤ 14.85 * 15.85 :=
    mul_le_mul p1 p2 (norm_nonneg _) (by norm_num)
  have m2 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ ≤ 14.85 * 15.85 * 16.85 :=
    mul_le_mul m1 p3 (norm_nonneg _) (by norm_num)
  exact m2.trans (by norm_num)

/-- On the `0.35`-ball, `‖P₅(s)‖ <= 2000000`. -/
theorem norm_P5_ball {s : ℂ} (hs : ‖s - s14‖ ≤ (0.35 : ℝ)) :
    ‖(descPochhammer ℂ 5).eval (-s)‖ ≤ (2000000 : ℝ) := by
  have h5 : (descPochhammer ℂ 5).eval (-s) =
      (-s) * (-s - 1) * (-s - 2) * (-s - 3) * (-s - 4) := by
    simp [descPochhammer]
    ring
  rw [h5, norm_mul, norm_mul, norm_mul, norm_mul]
  have e0 : ‖-s‖ = ‖s‖ := norm_neg s
  have e1 : ‖-s - 1‖ = ‖s + 1‖ := by rw [show -s - 1 = -(s + 1) by ring, norm_neg]
  have e2 : ‖-s - 2‖ = ‖s + 2‖ := by rw [show -s - 2 = -(s + 2) by ring, norm_neg]
  have e3 : ‖-s - 3‖ = ‖s + 3‖ := by rw [show -s - 3 = -(s + 3) by ring, norm_neg]
  have e4 : ‖-s - 4‖ = ‖s + 4‖ := by rw [show -s - 4 = -(s + 4) by ring, norm_neg]
  rw [e0, e1, e2, e3, e4]
  have p0 : ‖s‖ ≤ (14.85 : ℝ) := norm_le_ball hs
  have p1 : ‖s + 1‖ ≤ (15.85 : ℝ) := by
    have h := ball_add_le (s := s) hs (t := (1:ℂ)) (c := 15.5) norm_s14_add_one_le
      (by norm_num) (by norm_num)
    linarith
  have p2 : ‖s + 2‖ ≤ (16.85 : ℝ) := by
    have h := ball_add_le (s := s) hs (t := (2:ℂ)) (c := 16.5) norm_s14_add_two_le
      (by norm_num) (by norm_num)
    linarith
  have p3 : ‖s + 3‖ ≤ (17.85 : ℝ) := by
    have h := ball_add_le (s := s) hs (t := (3:ℂ)) (c := 17.5) norm_s14_add_three_le
      (by norm_num) (by norm_num)
    linarith
  have p4 : ‖s + 4‖ ≤ (18.85 : ℝ) := by
    have h : ‖s + 4‖ ≤ ‖s - s14‖ + ‖s14 + 4‖ := by
      have h0 := norm_add_le (s - s14) (s14 + 4)
      rwa [show s - s14 + (s14 + 4) = s + 4 by ring] at h0
    have h' : ‖s14 + 4‖ ≤ (18.5 : ℝ) := by
      have h2 := norm_add_le s14 (4 : ℂ)
      rw [show s14 + (4 : ℂ) = s14 + 4 from rfl] at h2
      have h3 : ‖(4 : ℂ)‖ = (4 : ℝ) := by norm_num
      rw [h3] at h2
      linarith [norm_s14_le]
    linarith
  have m1 : ‖s‖ * ‖s + 1‖ ≤ 14.85 * 15.85 :=
    mul_le_mul p0 p1 (norm_nonneg _) (by norm_num)
  have m2 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ ≤ 14.85 * 15.85 * 16.85 :=
    mul_le_mul m1 p2 (norm_nonneg _) (by norm_num)
  have m3 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ ≤ 14.85 * 15.85 * 16.85 * 17.85 :=
    mul_le_mul m2 p3 (norm_nonneg _) (by norm_num)
  have m4 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ ≤
      14.85 * 15.85 * 16.85 * 17.85 * 18.85 :=
    mul_le_mul m3 p4 (norm_nonneg _) (by norm_num)
  exact m4.trans (by norm_num)

end FiniteWindowZeros
