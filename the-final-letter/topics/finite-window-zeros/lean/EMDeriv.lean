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

/-- On the `0.35`-ball, `‖P₆(s)‖ <= 30000000`. -/
theorem norm_P6_ball {s : ℂ} (hs : ‖s - s14‖ ≤ (0.35 : ℝ)) :
    ‖(descPochhammer ℂ 6).eval (-s)‖ ≤ (30000000 : ℝ) := by
  have h6 : (descPochhammer ℂ 6).eval (-s) =
      (-s) * (-s - 1) * (-s - 2) * (-s - 3) * (-s - 4) * (-s - 5) := by
    simp [descPochhammer]
    ring
  rw [h6, norm_mul, norm_mul, norm_mul, norm_mul, norm_mul]
  have e0 : ‖-s‖ = ‖s‖ := norm_neg s
  have e1 : ‖-s - 1‖ = ‖s + 1‖ := by rw [show -s - 1 = -(s + 1) by ring, norm_neg]
  have e2 : ‖-s - 2‖ = ‖s + 2‖ := by rw [show -s - 2 = -(s + 2) by ring, norm_neg]
  have e3 : ‖-s - 3‖ = ‖s + 3‖ := by rw [show -s - 3 = -(s + 3) by ring, norm_neg]
  have e4 : ‖-s - 4‖ = ‖s + 4‖ := by rw [show -s - 4 = -(s + 4) by ring, norm_neg]
  have e5 : ‖-s - 5‖ = ‖s + 5‖ := by rw [show -s - 5 = -(s + 5) by ring, norm_neg]
  rw [e0, e1, e2, e3, e4, e5]
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
    have h : ‖s14 + (4:ℂ)‖ ≤ (18.5 : ℝ) := by
      have h2 := norm_add_le s14 (4 : ℂ)
      have h3 : ‖(4 : ℂ)‖ = (4 : ℝ) := by norm_num
      rw [h3] at h2
      linarith [norm_s14_le]
    have hb := ball_add_le (s := s) hs (t := (4:ℂ)) (c := 18.5) h (by norm_num) (by norm_num)
    linarith
  have p5 : ‖s + 5‖ ≤ (19.85 : ℝ) := by
    have h : ‖s14 + (5:ℂ)‖ ≤ (19.5 : ℝ) := by
      have h2 := norm_add_le s14 (5 : ℂ)
      have h3 : ‖(5 : ℂ)‖ = (5 : ℝ) := by norm_num
      rw [h3] at h2
      linarith [norm_s14_le]
    have hb := ball_add_le (s := s) hs (t := (5:ℂ)) (c := 19.5) h (by norm_num) (by norm_num)
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
  have m5 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ ≤
      14.85 * 15.85 * 16.85 * 17.85 * 18.85 * 19.85 :=
    mul_le_mul m4 p5 (norm_nonneg _) (by norm_num)
  exact m5.trans (by norm_num)

/-! ## `h1(b)`: the residual ball at radius `1/2`

`ζ′ = (zetaEMGen 1 20)′ + H′` with `H = ζ − zetaEMGen 1 20 = B₄ + B₆ + R₃` on the
open `1/2`-ball around `s14`.  The radius `1/2` is the *integer-exponent* choice:
`Re z > 0` on the ball, so `21^{-Re z - 3} ≤ 21^{-3}` (and likewise for `-5`, `-6`)
with no `rpow`-at-a-rational-exponent lemma.  One Cauchy application gives `|H′|`
(the three-piece split of an earlier plan is the same `2M/ρ`, with more plumbing).
-/

theorem mem_ball_half {s : ℂ} : s ∈ Metric.ball s14 (1/2 : ℝ) ↔ ‖s - s14‖ < (1/2 : ℝ) := by
  rw [Metric.mem_ball, dist_eq_norm]

/-- On the open `1/2`-ball, `Re s > 0`. -/
theorem re_pos_of_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) : 0 < s.re := by
  have h := Complex.abs_re_le_norm (s - s14)
  rw [Complex.sub_re] at h
  have hsre : s14.re = (1/2 : ℝ) := by norm_num [s14]
  rw [hsre] at h
  have := (abs_lt.mp (lt_of_le_of_lt h hs)).1
  linarith

/-- On the open `1/2`-ball, `1 < Im s < 20`. -/
theorem im_bounds_of_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    1 < s.im ∧ s.im < 20 := by
  have h := Complex.abs_im_le_norm (s - s14)
  rw [Complex.sub_im] at h
  have hsim : s14.im = (14 : ℝ) := by norm_num [s14]
  rw [hsim] at h
  have h2 := abs_lt.mp (lt_of_le_of_lt h hs)
  constructor <;> linarith [h2.1, h2.2]

/-- The open `1/2`-ball avoids the pole at `1`. -/
theorem ne_one_of_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) : s ≠ 1 := by
  intro h
  subst h
  have h2 := Complex.abs_im_le_norm ((1 : ℂ) - s14)
  have h3 : ((1 : ℂ) - s14).im = -14 := by norm_num [s14]
  rw [h3] at h2
  norm_num at h2
  linarith

theorem norm_s14_add_four_le : ‖s14 + (4 : ℂ)‖ ≤ (18.5 : ℝ) := by
  have h2 := norm_add_le s14 (4 : ℂ)
  have h3 : ‖(4 : ℂ)‖ = (4 : ℝ) := by norm_num
  rw [h3] at h2
  linarith [norm_s14_le]

theorem norm_s14_add_five_le : ‖s14 + (5 : ℂ)‖ ≤ (19.5 : ℝ) := by
  have h2 := norm_add_le s14 (5 : ℂ)
  have h3 : ‖(5 : ℂ)‖ = (5 : ℝ) := by norm_num
  rw [h3] at h2
  linarith [norm_s14_le]

theorem norm_s_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) : ‖s‖ ≤ (15 : ℝ) := by
  have h1 : ‖s‖ ≤ ‖s - s14‖ + ‖s14‖ := by
    have h := norm_add_le (s - s14) s14
    simpa using h
  have h2 : ‖s14‖ ≤ (14.5 : ℝ) := norm_s14_le
  linarith

theorem norm_s_add_one_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖s + 1‖ ≤ (16 : ℝ) := by
  have h1 : ‖s + 1‖ ≤ ‖s - s14‖ + ‖s14 + 1‖ := by
    have h := norm_add_le (s - s14) (s14 + (1 : ℂ))
    rwa [show s - s14 + (s14 + (1 : ℂ)) = s + 1 by ring] at h
  have h2 : ‖s14 + 1‖ ≤ (15.5 : ℝ) := norm_s14_add_one_le
  linarith

theorem norm_s_add_two_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖s + 2‖ ≤ (17 : ℝ) := by
  have h1 : ‖s + 2‖ ≤ ‖s - s14‖ + ‖s14 + 2‖ := by
    have h := norm_add_le (s - s14) (s14 + (2 : ℂ))
    rwa [show s - s14 + (s14 + (2 : ℂ)) = s + 2 by ring] at h
  have h2 : ‖s14 + 2‖ ≤ (16.5 : ℝ) := norm_s14_add_two_le
  linarith

theorem norm_s_add_three_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖s + 3‖ ≤ (18 : ℝ) := by
  have h1 : ‖s + 3‖ ≤ ‖s - s14‖ + ‖s14 + 3‖ := by
    have h := norm_add_le (s - s14) (s14 + (3 : ℂ))
    rwa [show s - s14 + (s14 + (3 : ℂ)) = s + 3 by ring] at h
  have h2 : ‖s14 + 3‖ ≤ (17.5 : ℝ) := norm_s14_add_three_le
  linarith

theorem norm_s_add_four_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖s + 4‖ ≤ (19 : ℝ) := by
  have h1 : ‖s + 4‖ ≤ ‖s - s14‖ + ‖s14 + 4‖ := by
    have h := norm_add_le (s - s14) (s14 + (4 : ℂ))
    rwa [show s - s14 + (s14 + (4 : ℂ)) = s + 4 by ring] at h
  have h2 : ‖s14 + 4‖ ≤ (18.5 : ℝ) := norm_s14_add_four_le
  linarith

theorem norm_s_add_five_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖s + 5‖ ≤ (20 : ℝ) := by
  have h1 : ‖s + 5‖ ≤ ‖s - s14‖ + ‖s14 + 5‖ := by
    have h := norm_add_le (s - s14) (s14 + (5 : ℂ))
    rwa [show s - s14 + (s14 + (5 : ℂ)) = s + 5 by ring] at h
  have h2 : ‖s14 + 5‖ ≤ (19.5 : ℝ) := norm_s14_add_five_le
  linarith

/-- On the `1/2`-ball, `‖P₃(s)‖ ≤ 15·16·17 = 4080`. -/
theorem norm_P3_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖(descPochhammer ℂ 3).eval (-s)‖ ≤ (4080 : ℝ) := by
  have h3 : (descPochhammer ℂ 3).eval (-s) = (-s) * (-s - 1) * (-s - 2) := by
    simp [descPochhammer]
    ring
  rw [h3, norm_mul, norm_mul]
  have e0 : ‖-s‖ = ‖s‖ := norm_neg s
  have e1 : ‖-s - 1‖ = ‖s + 1‖ := by rw [show -s - 1 = -(s + 1) by ring, norm_neg]
  have e2 : ‖-s - 2‖ = ‖s + 2‖ := by rw [show -s - 2 = -(s + 2) by ring, norm_neg]
  rw [e0, e1, e2]
  have p0 : ‖s‖ ≤ (15 : ℝ) := norm_s_ball_half hs
  have p1 : ‖s + 1‖ ≤ (16 : ℝ) := norm_s_add_one_ball_half hs
  have p2 : ‖s + 2‖ ≤ (17 : ℝ) := norm_s_add_two_ball_half hs
  have m1 : ‖s‖ * ‖s + 1‖ ≤ 15 * 16 :=
    mul_le_mul p0 p1 (norm_nonneg _) (by norm_num)
  have m2 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ ≤ 15 * 16 * 17 :=
    mul_le_mul m1 p2 (norm_nonneg _) (by norm_num)
  exact m2.trans (by norm_num)

/-- On the `1/2`-ball, `‖P₅(s)‖ ≤ 15·…·19 = 1395360`. -/
theorem norm_P5_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖(descPochhammer ℂ 5).eval (-s)‖ ≤ (1395360 : ℝ) := by
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
  have p0 : ‖s‖ ≤ (15 : ℝ) := norm_s_ball_half hs
  have p1 : ‖s + 1‖ ≤ (16 : ℝ) := norm_s_add_one_ball_half hs
  have p2 : ‖s + 2‖ ≤ (17 : ℝ) := norm_s_add_two_ball_half hs
  have p3 : ‖s + 3‖ ≤ (18 : ℝ) := norm_s_add_three_ball_half hs
  have p4 : ‖s + 4‖ ≤ (19 : ℝ) := norm_s_add_four_ball_half hs
  have m1 : ‖s‖ * ‖s + 1‖ ≤ 15 * 16 :=
    mul_le_mul p0 p1 (norm_nonneg _) (by norm_num)
  have m2 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ ≤ 15 * 16 * 17 :=
    mul_le_mul m1 p2 (norm_nonneg _) (by norm_num)
  have m3 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ ≤ 15 * 16 * 17 * 18 :=
    mul_le_mul m2 p3 (norm_nonneg _) (by norm_num)
  have m4 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ ≤ 15 * 16 * 17 * 18 * 19 :=
    mul_le_mul m3 p4 (norm_nonneg _) (by norm_num)
  exact m4.trans (by norm_num)

/-- On the `1/2`-ball, `‖P₆(s)‖ ≤ 15·…·20 = 27907200`. -/
theorem norm_P6_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖(descPochhammer ℂ 6).eval (-s)‖ ≤ (27907200 : ℝ) := by
  have h6 : (descPochhammer ℂ 6).eval (-s) =
      (-s) * (-s - 1) * (-s - 2) * (-s - 3) * (-s - 4) * (-s - 5) := by
    simp [descPochhammer]
    ring
  rw [h6, norm_mul, norm_mul, norm_mul, norm_mul, norm_mul]
  have e0 : ‖-s‖ = ‖s‖ := norm_neg s
  have e1 : ‖-s - 1‖ = ‖s + 1‖ := by rw [show -s - 1 = -(s + 1) by ring, norm_neg]
  have e2 : ‖-s - 2‖ = ‖s + 2‖ := by rw [show -s - 2 = -(s + 2) by ring, norm_neg]
  have e3 : ‖-s - 3‖ = ‖s + 3‖ := by rw [show -s - 3 = -(s + 3) by ring, norm_neg]
  have e4 : ‖-s - 4‖ = ‖s + 4‖ := by rw [show -s - 4 = -(s + 4) by ring, norm_neg]
  have e5 : ‖-s - 5‖ = ‖s + 5‖ := by rw [show -s - 5 = -(s + 5) by ring, norm_neg]
  rw [e0, e1, e2, e3, e4, e5]
  have p0 : ‖s‖ ≤ (15 : ℝ) := norm_s_ball_half hs
  have p1 : ‖s + 1‖ ≤ (16 : ℝ) := norm_s_add_one_ball_half hs
  have p2 : ‖s + 2‖ ≤ (17 : ℝ) := norm_s_add_two_ball_half hs
  have p3 : ‖s + 3‖ ≤ (18 : ℝ) := norm_s_add_three_ball_half hs
  have p4 : ‖s + 4‖ ≤ (19 : ℝ) := norm_s_add_four_ball_half hs
  have p5 : ‖s + 5‖ ≤ (20 : ℝ) := norm_s_add_five_ball_half hs
  have m1 : ‖s‖ * ‖s + 1‖ ≤ 15 * 16 :=
    mul_le_mul p0 p1 (norm_nonneg _) (by norm_num)
  have m2 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ ≤ 15 * 16 * 17 :=
    mul_le_mul m1 p2 (norm_nonneg _) (by norm_num)
  have m3 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ ≤ 15 * 16 * 17 * 18 :=
    mul_le_mul m2 p3 (norm_nonneg _) (by norm_num)
  have m4 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ ≤ 15 * 16 * 17 * 18 * 19 :=
    mul_le_mul m3 p4 (norm_nonneg _) (by norm_num)
  have m5 : ‖s‖ * ‖s + 1‖ * ‖s + 2‖ * ‖s + 3‖ * ‖s + 4‖ * ‖s + 5‖ ≤
      15 * 16 * 17 * 18 * 19 * 20 :=
    mul_le_mul m4 p5 (norm_nonneg _) (by norm_num)
  exact m5.trans (by norm_num)

/-! ### The three residual pieces on the `1/2`-ball -/

theorem pow21_neg_five : (21 : ℝ) ^ (-(5 : ℝ)) = 1 / 4084101 := by
  rw [show (-(5 : ℝ)) = ((-5 : ℤ) : ℝ) by norm_num, Real.rpow_intCast]
  norm_num

theorem pow21_neg_six : (21 : ℝ) ^ (-(6 : ℝ)) = 1 / 85766121 := by
  rw [show (-(6 : ℝ)) = ((-6 : ℤ) : ℝ) by norm_num, Real.rpow_intCast]
  norm_num

/-- `ζ(6) = π⁶/945` (from `riemannZeta_two_mul_nat` and `B₆ = 1/42`). -/
theorem riemannZeta_six : riemannZeta (6 : ℂ) = ((Real.pi ^ 6 / 945 : ℝ) : ℂ) := by
  have hz := riemannZeta_two_mul_nat (k := 3) (by norm_num : (3 : ℕ) ≠ 0)
  have h6c : (6 : ℂ) = 2 * ((3 : ℕ) : ℂ) := by norm_num
  rw [h6c, hz]
  have hb : (((_root_.bernoulli (2 * 3) : ℚ)) : ℂ) = (1 / 42 : ℂ) := by
    have h0 : _root_.bernoulli 6 = (1 / 42 : ℚ) := by decide +kernel
    have h1 : _root_.bernoulli (2 * 3) = _root_.bernoulli 6 := by norm_num
    rw [h1, h0]
    norm_num
  have hf : ((((Nat.factorial (2 * 3)) : ℕ)) : ℂ) = (720 : ℂ) := by
    have h0 : Nat.factorial (2 * 3) = 720 := by decide +kernel
    rw [h0]
    norm_num
  rw [hb, hf]
  have h1 : (-1 : ℂ) ^ (3 + 1) = 1 := by norm_num
  have h2 : (2 : ℂ) ^ (2 * 3 - 1) = 32 := by norm_num
  have h3 : (Real.pi : ℂ) ^ (2 * 3) = (Real.pi : ℂ) ^ 6 := by norm_num
  rw [h1, h2, h3]
  push_cast
  field_simp
  ring

/-- The `K = 3` Euler–Maclaurin constant: `2·Re ζ(6)/(2π)⁶ = 1/30240`. -/
theorem emConst_six : 2 * (riemannZeta (6 : ℂ)).re / (2 * Real.pi) ^ 6 = (1 / 30240 : ℝ) := by
  have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
  have h6 : (riemannZeta (6 : ℂ)).re = Real.pi ^ 6 / 945 := by
    rw [riemannZeta_six, Complex.ofReal_re]
  rw [h6]
  field_simp
  ring

/-- `|B₄| ≤ (1/720)·4080·21^{-3}` on the `1/2`-ball. -/
theorem norm_b4_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖(-(emCoef 2) : ℂ) * emGShift s 20 3 0‖ ≤ (62 / 100000 : ℝ) := by
  rw [norm_mul]
  have he : ‖(-(emCoef 2) : ℂ)‖ = (1 / 720 : ℝ) := by
    rw [emCoef_two]
    norm_num
  rw [he]
  have hg : ‖emGShift s 20 3 0‖ =
      ‖(descPochhammer ℂ 3).eval (-s)‖ * ((0 + (20 : ℝ) + 1) ^ (-s.re - 3)) :=
    norm_emGShift s 20 3 (le_refl 0)
  rw [hg]
  have h21 : ((0 : ℝ) + 20 + 1) = 21 := by norm_num
  rw [h21]
  have hP := norm_P3_ball_half hs
  have hsig : 0 ≤ s.re := le_of_lt (re_pos_of_ball_half hs)
  have hexp : -s.re - 3 ≤ -(3 : ℝ) := by linarith
  have hpow : (21 : ℝ) ^ (-s.re - 3) ≤ (21 : ℝ) ^ (-(3 : ℝ)) :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) hexp
  rw [pow21_neg_three] at hpow
  calc (1 / 720) * (‖(descPochhammer ℂ 3).eval (-s)‖ * (21 : ℝ) ^ (-s.re - 3))
      ≤ (1 / 720) * ((4080 : ℝ) * (1 / 9261)) := by
        apply mul_le_mul_of_nonneg_left _ (by norm_num)
        exact mul_le_mul hP hpow (by positivity) (by norm_num)
    _ ≤ (62 / 100000 : ℝ) := by norm_num

/-- `|B₆| ≤ (1/30240)·1395360·21^{-5}` on the `1/2`-ball. -/
theorem norm_b6_ball_half {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖(-(emCoef 3) : ℂ) * emGShift s 20 5 0‖ ≤ (12 / 1000000 : ℝ) := by
  rw [norm_mul]
  have he : ‖(-(emCoef 3) : ℂ)‖ = (1 / 30240 : ℝ) := by
    rw [emCoef_three]
    norm_num
  rw [he]
  have hg : ‖emGShift s 20 5 0‖ =
      ‖(descPochhammer ℂ 5).eval (-s)‖ * ((0 + (20 : ℝ) + 1) ^ (-s.re - 5)) :=
    norm_emGShift s 20 5 (le_refl 0)
  rw [hg]
  have h21 : ((0 : ℝ) + 20 + 1) = 21 := by norm_num
  rw [h21]
  have hP := norm_P5_ball_half hs
  have hsig : 0 ≤ s.re := le_of_lt (re_pos_of_ball_half hs)
  have hexp : -s.re - 5 ≤ -(5 : ℝ) := by linarith
  have hpow : (21 : ℝ) ^ (-s.re - 5) ≤ (21 : ℝ) ^ (-(5 : ℝ)) :=
    Real.rpow_le_rpow_of_exponent_le (by norm_num) hexp
  rw [pow21_neg_five] at hpow
  calc (1 / 30240) * (‖(descPochhammer ℂ 5).eval (-s)‖ * (21 : ℝ) ^ (-s.re - 5))
      ≤ (1 / 30240) * ((1395360 : ℝ) * (1 / 4084101)) := by
        apply mul_le_mul_of_nonneg_left _ (by norm_num)
        exact mul_le_mul hP hpow (by positivity) (by norm_num)
    _ ≤ (12 / 1000000 : ℝ) := by norm_num

/-- **`M_R(K = 3)` on the `1/2`-ball**: `‖zetaEMRemainder 3 20 s‖ ≤ 6·10⁻⁵`. -/
theorem norm_remainder_three_ball_le {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖zetaEMRemainder 3 20 s‖ ≤ (6 / 100000 : ℝ) := by
  have hre : 0 < s.re := re_pos_of_ball_half hs
  have h := norm_zetaEMRemainder_le_of_re_pos 3 20 (by norm_num) s hre
  rw [show (2 * 3 : ℕ) = 6 from by norm_num] at h
  simp only [Nat.cast_ofNat] at h
  rw [emConst_six, show ((20 : ℝ) + 1) = 21 from by norm_num] at h
  have hP := norm_P6_ball_half hs
  have hA : (21 : ℝ) ^ (-s.re - 6) ≤ (1 / 85766121 : ℝ) := by
    have hexp : -s.re - 6 ≤ -(6 : ℝ) := by linarith
    have h1 := Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 21) hexp
    rwa [pow21_neg_six] at h1
  have hB : (21 : ℝ) ^ (1 - s.re - 6) / (s.re + 6 - 1) ≤ (1 / 20420505 : ℝ) := by
    have hexp : 1 - s.re - 6 ≤ -(5 : ℝ) := by linarith
    have h1 := Real.rpow_le_rpow_of_exponent_le (by norm_num : (1 : ℝ) ≤ 21) hexp
    have hpos : (0 : ℝ) < s.re + 6 - 1 := by linarith
    have hden : (5 : ℝ) ≤ s.re + 6 - 1 := by linarith
    have h2 : (21 : ℝ) ^ (1 - s.re - 6) / (s.re + 6 - 1) ≤
        (21 : ℝ) ^ (-(5 : ℝ)) / (s.re + 6 - 1) :=
      div_le_div_of_nonneg_right h1 (le_of_lt hpos)
    have h3 : (21 : ℝ) ^ (-(5 : ℝ)) / (s.re + 6 - 1) ≤ (21 : ℝ) ^ (-(5 : ℝ)) / 5 :=
      div_le_div_of_nonneg_left (by positivity) (by norm_num) hden
    calc (21 : ℝ) ^ (1 - s.re - 6) / (s.re + 6 - 1)
        ≤ (21 : ℝ) ^ (-(5 : ℝ)) / (s.re + 6 - 1) := h2
      _ ≤ (21 : ℝ) ^ (-(5 : ℝ)) / 5 := h3
      _ = (1 / 20420505 : ℝ) := by rw [pow21_neg_five]; norm_num
  calc ‖zetaEMRemainder 3 20 s‖
      ≤ (1 / 30240) * ‖(descPochhammer ℂ 6).eval (-s)‖ *
          ((21 : ℝ) ^ (-s.re - 6) + (21 : ℝ) ^ (1 - s.re - 6) / (s.re + 6 - 1)) := h
    _ ≤ (1 / 30240) * (27907200 : ℝ) *
          ((1 / 85766121 : ℝ) + (1 / 20420505 : ℝ)) := by
        apply mul_le_mul
        · exact mul_le_mul_of_nonneg_left hP (by norm_num)
        · exact add_le_add hA hB
        · have h1 : (0 : ℝ) < (21 : ℝ) ^ (-s.re - 6) := Real.rpow_pos_of_pos (by norm_num) _
          have h2 : (0 : ℝ) < (21 : ℝ) ^ (1 - s.re - 6) := Real.rpow_pos_of_pos (by norm_num) _
          have h3 : (0 : ℝ) < s.re + 6 - 1 := by linarith
          exact add_nonneg (le_of_lt h1) (le_of_lt (div_pos h2 h3))
        · norm_num
    _ ≤ (6 / 100000 : ℝ) := by norm_num

/-! ### The residual function and its Cauchy bound -/

/-- `ζ` minus the `K = 1` generator; on the `1/2`-ball this is `B₄ + B₆ + R₃`. -/
def zetaResid (s : ℂ) : ℂ := riemannZeta s - zetaEMGen 1 20 s

theorem zetaEMGen_three_expand (s : ℂ) :
    zetaEMGen 3 20 s = zetaEMGen 1 20 s
      + (-(emCoef 2) : ℂ) * emGShift s 20 3 0
      + (-(emCoef 3) : ℂ) * emGShift s 20 5 0 := by
  have h2 : zetaEMGen 3 20 s = zetaEMGen 2 20 s + (-(emCoef 3) : ℂ) * emGShift s 20 5 0 := by
    have h := zetaEMGen_succ 2 20 s
    simpa using h
  have h1 : zetaEMGen 2 20 s = zetaEMGen 1 20 s + (-(emCoef 2) : ℂ) * emGShift s 20 3 0 := by
    have h := zetaEMGen_succ 1 20 s
    simpa using h
  rw [h2, h1]

theorem differentiableAt_zetaEMGen_one {s : ℂ} (hs : s ≠ 1) :
    DifferentiableAt ℂ (zetaEMGen 1 20) s :=
  (hasDerivAt_zetaEMGen_one s hs).differentiableAt

theorem differentiableOn_zetaResid :
    DifferentiableOn ℂ zetaResid (Metric.ball s14 (1/2 : ℝ)) := by
  intro s hs
  have hne : s ≠ 1 := ne_one_of_ball_half (mem_ball_half.mp hs)
  exact ((differentiableAt_riemannZeta hne).sub
    (differentiableAt_zetaEMGen_one hne)).differentiableWithinAt

/-- `‖H‖ ≤ 7·10⁻⁴` on the `1/2`-ball, where `H = ζ − zetaEMGen 1 20`. -/
theorem norm_zetaResid_le {s : ℂ} (hs : ‖s - s14‖ < (1/2 : ℝ)) :
    ‖zetaResid s‖ ≤ (7 / 10000 : ℝ) := by
  have hζ : riemannZeta s = zetaEM 20 s :=
    zeta_eq_zetaEM_of_im 20 (re_pos_of_ball_half hs) (im_bounds_of_ball_half hs).1
      (im_bounds_of_ball_half hs).2
  have hsplit : zetaEM 20 s = zetaEMGen 3 20 s + zetaEMRemainder 3 20 s := by
    rw [zetaEMRemainder]
    ring
  have hval : zetaResid s = (-(emCoef 2) : ℂ) * emGShift s 20 3 0
      + (-(emCoef 3) : ℂ) * emGShift s 20 5 0 + zetaEMRemainder 3 20 s := by
    rw [zetaResid, hζ, hsplit, zetaEMGen_three_expand]
    ring
  have h4 := norm_b4_ball_half hs
  have h6 := norm_b6_ball_half hs
  have hr := norm_remainder_three_ball_le hs
  calc ‖zetaResid s‖
      = ‖(-(emCoef 2) : ℂ) * emGShift s 20 3 0 + (-(emCoef 3) : ℂ) * emGShift s 20 5 0
          + zetaEMRemainder 3 20 s‖ := by rw [hval]
    _ ≤ ‖(-(emCoef 2) : ℂ) * emGShift s 20 3 0
            + (-(emCoef 3) : ℂ) * emGShift s 20 5 0‖
          + ‖zetaEMRemainder 3 20 s‖ := norm_add_le _ _
    _ ≤ (‖(-(emCoef 2) : ℂ) * emGShift s 20 3 0‖
            + ‖(-(emCoef 3) : ℂ) * emGShift s 20 5 0‖)
          + ‖zetaEMRemainder 3 20 s‖ := by
        linarith [norm_add_le ((-(emCoef 2) : ℂ) * emGShift s 20 3 0)
          ((-(emCoef 3) : ℂ) * emGShift s 20 5 0)]
    _ ≤ (62 / 100000 : ℝ) + (12 / 1000000 : ℝ) + (6 / 100000 : ℝ) := by
        linarith [h4, h6, hr]
    _ ≤ (7 / 10000 : ℝ) := by norm_num

/-- **`h1(b)`**: `|H′(s14)| ≤ 2·(7·10⁻⁴)/(1/2) = 28·10⁻⁴`, one Cauchy application. -/
theorem norm_deriv_zetaResid_le : ‖deriv zetaResid s14‖ ≤ (28 / 10000 : ℝ) := by
  have hR : (0 : ℝ) < 1 / 2 := by norm_num
  have h := norm_deriv_le_of_norm_le_on_ball (f := zetaResid) (c := s14) (R := 1 / 2)
    (M := 7 / 10000) hR differentiableOn_zetaResid
    (fun z hz => norm_zetaResid_le (mem_ball_half.mp hz))
  have h2 : 2 * (7 / 10000 : ℝ) / (1 / 2) = (28 / 10000 : ℝ) := by norm_num
  linarith [h, h2]

theorem deriv_zeta_eq_gen_one_add :
    deriv riemannZeta s14 = deriv (zetaEMGen 1 20) s14 + deriv zetaResid s14 := by
  have hfun : riemannZeta = fun s => zetaEMGen 1 20 s + zetaResid s := by
    funext s
    show riemannZeta s = zetaEMGen 1 20 s + (riemannZeta s - zetaEMGen 1 20 s)
    ring
  rw [hfun]
  exact deriv_add (differentiableAt_zetaEMGen_one s14_ne_one)
    ((differentiableAt_riemannZeta s14_ne_one).sub (differentiableAt_zetaEMGen_one s14_ne_one))

/-! ### `h1(c)`: the box for `1 - Yk·(gen₁)′` and the assembly -/

/-- `Yk` as a point box. -/
def Ybox : Cx := ptBox (12436403768 / 10000000000) (-3397942771 / 10000000000)

/-- The box for `1 - Yk·V`, with `V ∈ Vbox`. -/
def Wbox : Cx := (ptBox 1 0).sub (Ybox.mul Vbox)

theorem mem_Ybox : Ybox.mem Yk := by
  apply mem_ptBox <;> simp [Yk]

theorem mem_Wbox :
    Wbox.mem (1 - Yk * deriv (zetaEMGen 1 20) s14) :=
  Cx.mem_sub (mem_ptBox (by simp) (by simp)) (Cx.mem_mul mem_Ybox mem_Vbox)

/-- The corner test for `Wbox`: the true value `|1 − Yk·V| = 3.62·10⁻⁴`. -/
theorem corner_Wbox :
    (maxAbsIv Wbox.re) ^ 2 + (maxAbsIv Wbox.im) ^ 2 ≤ ((1 / 2000 : ℚ)) ^ 2 := by
  native_decide

theorem norm_Wbox_le :
    ‖1 - Yk * deriv (zetaEMGen 1 20) s14‖ ≤ (1 / 2000 : ℝ) := by
  apply norm_le_of_mem_box mem_Wbox (by norm_num)
  have hcast : ((maxAbsIv Wbox.re) ^ 2 + (maxAbsIv Wbox.im) ^ 2 : ℝ) ≤
      (((1 / 2000 : ℚ) : ℝ)) ^ 2 := by
    exact_mod_cast corner_Wbox
  simpa using hcast

/-- **`h1` — the point enclosure of `ζ′` at `1/2 + 14i`.**

`1 − Yk·ζ′ = (1 − Yk·(gen₁)′) − Yk·H′` with `|H′| ≤ 28·10⁻⁴` (T…), so
`‖1 − Yk·ζ′‖ ≤ 1/2000 + 1.29·28·10⁻⁴ = 4.112·10⁻³ ≤ 1/200`. -/
theorem h1_deriv : ‖1 - Yk * deriv riemannZeta s14‖ ≤ (1 / 200 : ℝ) := by
  have hsplit : 1 - Yk * deriv riemannZeta s14 =
      (1 - Yk * deriv (zetaEMGen 1 20) s14) - Yk * deriv zetaResid s14 := by
    rw [deriv_zeta_eq_gen_one_add]
    ring
  calc ‖1 - Yk * deriv riemannZeta s14‖
      = ‖(1 - Yk * deriv (zetaEMGen 1 20) s14) - Yk * deriv zetaResid s14‖ := by rw [hsplit]
    _ ≤ ‖1 - Yk * deriv (zetaEMGen 1 20) s14‖ + ‖Yk * deriv zetaResid s14‖ :=
        norm_sub_le _ _
    _ ≤ (1 / 2000 : ℝ) + 1.29 * (28 / 10000 : ℝ) := by
        have hm : ‖Yk * deriv zetaResid s14‖ ≤ (1.29 : ℝ) * (28 / 10000 : ℝ) := by
          rw [norm_mul]
          exact mul_le_mul norm_Yk_le norm_deriv_zetaResid_le (norm_nonneg _) (by norm_num)
        linarith [norm_Wbox_le, hm]
    _ ≤ (1 / 200 : ℝ) := by norm_num

end FiniteWindowZeros
