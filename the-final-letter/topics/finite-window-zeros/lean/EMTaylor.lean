import EMDeriv

/-!
# The `K = 3` generator factored through `21^{-s}`, and the Taylor route to `h2`

`h1` is proved in `EMDeriv.lean`.  The remaining Krawczyk input is
`h2 : ∀ z ∈ closedBall s14 (1/5), ‖ζ′(z) − ζ′(s14)‖ ≤ 47/250`, which is proved
by a Taylor model: the true variation is `0.13928`, achieved by the first few
Taylor coefficients of `ζ` at `s14`.

The key structural fact is that the `K = 3` Euler–Maclaurin generator factors as

`zetaEMGen 3 20 s = Σ_{n≤20} n^{-s} + 21^{-s} · Ψ₃(s)`

with `Ψ₃` a **rational** function of `s`.  Hence every derivative at `s14` is
a Gaussian rational (from `1/(s14−1)`, `P₃(−s14)`, `P₅(−s14)`) times a power of
`log 21`, i.e. amenable to the same point-box arithmetic as `Vbox`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open PartialTail
open Filter Topology

/-! ## Folding the higher `21`-powers -/

theorem cpow21_neg_three : (21 : ℂ) ^ (((-3 : ℤ)) : ℂ) = (1 / 9261 : ℂ) := by
  rw [Complex.cpow_intCast]
  norm_num

theorem cpow21_neg_five : (21 : ℂ) ^ (((-5 : ℤ)) : ℂ) = (1 / 4084101 : ℂ) := by
  rw [Complex.cpow_intCast]
  norm_num

/-- `21^(-(s+3)) = 21^(-s) / 9261`. -/
theorem pow21_neg_add_three (s : ℂ) :
    (21 : ℂ) ^ (-(s + 3)) = (21 : ℂ) ^ (-s) / 9261 := by
  rw [show -(s + 3) = (-s) + ((-3 : ℤ) : ℂ) by push_cast; ring,
    Complex.cpow_add _ _ (by norm_num : (21 : ℂ) ≠ 0), cpow21_neg_three]
  ring

/-- `21^(-(s+5)) = 21^(-s) / 4084101`. -/
theorem pow21_neg_add_five (s : ℂ) :
    (21 : ℂ) ^ (-(s + 5)) = (21 : ℂ) ^ (-s) / 4084101 := by
  rw [show -(s + 5) = (-s) + ((-5 : ℤ) : ℂ) by push_cast; ring,
    Complex.cpow_add _ _ (by norm_num : (21 : ℂ) ≠ 0), cpow21_neg_five]
  ring

/-! ## The explicit `K = 3` generator -/

/-- The `K = 3` generator, written out in its six pieces. -/
theorem zetaEMGen_three_explicit (s : ℂ) :
    zetaEMGen 3 20 s =
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s)))
        + (21 : ℂ) ^ (1 - s) / (s - 1)
        + (21 : ℂ) ^ (-s) / 2
        + (1 / 12 : ℂ) * s * (21 : ℂ) ^ (-(s + 1))
        + (1 / 720 : ℂ) * (descPochhammer ℂ 3).eval (-s) * (21 : ℂ) ^ (-(s + 3))
        - (1 / 30240 : ℂ) * (descPochhammer ℂ 5).eval (-s) * (21 : ℂ) ^ (-(s + 5)) := by
  have hP3 : (descPochhammer ℂ 3).eval (-s) = (-s) * (-s - 1) * (-s - 2) := by
    simp [descPochhammer]
    ring
  have hP5 : (descPochhammer ℂ 5).eval (-s) =
      (-s) * (-s - 1) * (-s - 2) * (-s - 3) * (-s - 4) := by
    simp [descPochhammer]
    ring
  rw [zetaEMGen_three_expand, zetaEMGen_one, zetaBase]
  simp only [emGShift, descPochhammer_zero, Polynomial.eval_zero,
    Polynomial.eval_one, hP3, hP5, zero_add, Nat.cast_ofNat, Nat.cast_zero, mul_one,
    add_zero, sub_zero]
  rw [emCoef_two, emCoef_three]
  push_cast
  ring

/-- `Ψ₃`: the rational factor of the `K = 3` generator after `21^{-s}`. -/
noncomputable def Psi3 (s : ℂ) : ℂ :=
  21 / (s - 1) + 1 / 2 + s / 252
    + (descPochhammer ℂ 3).eval (-s) / (720 * 9261)
    - (descPochhammer ℂ 5).eval (-s) / (30240 * 4084101)

/-- **The factorization** `zetaEMGen 3 20 s = Σ_{n≤20} n^{-s} + 21^{-s}·Ψ₃(s)`. -/
theorem gen3_eq_sum_psi (s : ℂ) :
    zetaEMGen 3 20 s =
      (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-s))) + (21 : ℂ) ^ (-s) * Psi3 s := by
  rw [zetaEMGen_three_explicit, pow21_one_sub, pow21_neg_succ, pow21_neg_add_three,
    pow21_neg_add_five, Psi3]
  field_simp
  ring



/-! ## Iterated derivatives of `b^{-s}` -/

/-- **`iteratedDeriv k (b^{-s}) = (-log b)^k · b^{-s}`** for `b ≠ 0`.

This is the exponential factor of every Taylor coefficient of the generator: for
`b = 21` it produces the powers of `log 21`, and for `b = n` it produces the
moments `(log n)^k` of the base sum. -/
theorem iteratedDeriv_cpow_neg (b : ℂ) (hb : b ≠ 0) (k : ℕ) :
    iteratedDeriv k (fun s : ℂ => b ^ (-s)) =
      fun s => (-Complex.log b) ^ k * b ^ (-s) := by
  induction k with
  | zero =>
      funext s
      rw [iteratedDeriv_zero]
      simp
  | succ k ih =>
      rw [iteratedDeriv_succ, ih]
      funext s
      have h := (hasDerivAt_cpow_neg hb s).const_mul ((-Complex.log b) ^ k)
      rw [h.deriv]
      ring

/-- `s ↦ b^{-s}` is `C^∞` for `b ≠ 0`. -/
theorem contDiffAt_cpow_neg (b : ℂ) (hb : b ≠ 0) (n : WithTop ℕ∞) (s : ℂ) :
    ContDiffAt ℂ n (fun s : ℂ => b ^ (-s)) s := by
  have hfun : (fun s : ℂ => b ^ (-s)) = fun s => Complex.exp (-s * Complex.log b) := by
    funext z
    rw [Complex.cpow_def, if_neg hb, mul_comm]
  rw [hfun]
  exact Complex.contDiff_exp.contDiffAt.comp s (by fun_prop)

/-- **The base sum differentiated `k` times.** -/
theorem iteratedDeriv_sum_cpow (k : ℕ) (s : ℂ) :
    iteratedDeriv k
        (fun z : ℂ => ∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-z))) s
      = ∑ n ∈ Finset.range 20,
          (-Complex.log ((((n + 1 : ℝ)) : ℂ))) ^ k * ((((n + 1 : ℝ)) : ℂ) ^ (-s)) := by
  have hf : ∀ n ∈ Finset.range 20,
      ContDiffAt ℂ (k : WithTop ℕ∞) (fun z : ℂ => ((((n + 1 : ℝ)) : ℂ) ^ (-z))) s := by
    intro n hn
    refine contDiffAt_cpow_neg _ ?_ k s
    intro hzero
    have hre := congrArg Complex.re hzero
    rw [Complex.ofReal_re, Complex.zero_re] at hre
    have hn0 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    linarith
  have hfun : (fun z : ℂ => ∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
      = ∑ n ∈ Finset.range 20, fun z : ℂ => ((((n + 1 : ℝ)) : ℂ) ^ (-z)) := by
    funext z
    simp [Finset.sum_apply]
  rw [hfun]
  rw [iteratedDeriv_sum (n := k) (x := s) (I := Finset.range 20)
    (f := fun (n : ℕ) => fun z : ℂ => ((((n + 1 : ℝ)) : ℂ) ^ (-z))) hf]
  apply Finset.sum_congr rfl
  intro n hn
  exact congrFun (iteratedDeriv_cpow_neg _ (by
    intro hzero
    have hre := congrArg Complex.re hzero
    rw [Complex.ofReal_re, Complex.zero_re] at hre
    have hn0 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    linarith) k) s


/-- **Leibniz with the `21^{-s}` factor.** -/
theorem iteratedDeriv_mul_pow21 (k : ℕ) (g : ℂ → ℂ) (s : ℂ)
    (hg : ContDiffAt ℂ (k : WithTop ℕ∞) g s) :
    iteratedDeriv k (fun s : ℂ => (21 : ℂ) ^ (-s) * g s) s
      = ∑ i ∈ Finset.range (k + 1),
          (k.choose i : ℂ) * ((-Complex.log 21) ^ i * (21 : ℂ) ^ (-s))
            * iteratedDeriv (k - i) g s := by
  have hf : ContDiffAt ℂ (k : WithTop ℕ∞) (fun s : ℂ => (21 : ℂ) ^ (-s)) s :=
    contDiffAt_cpow_neg _ (by norm_num) k s
  have hfm : (fun s : ℂ => (21 : ℂ) ^ (-s) * g s)
      = (fun s : ℂ => (21 : ℂ) ^ (-s)) * g := rfl
  rw [hfm, iteratedDeriv_mul (n := k) (x := s) (f := fun s : ℂ => (21 : ℂ) ^ (-s))
    (g := g) hf hg]
  apply Finset.sum_congr rfl
  intro i hi
  rw [iteratedDeriv_cpow_neg (21 : ℂ) (by norm_num) i]


/-- **`d^j/ds^j (s-1)^{-1} = (-1)^j · j! · ((s-1)^{j+1})^{-1}`.** -/
theorem iteratedDeriv_inv_sub_one (j : ℕ) {s : ℂ} (hs : s ≠ 1) :
    iteratedDeriv j (fun s : ℂ => (s - 1)⁻¹) s
      = (-1 : ℂ) ^ j * (((j.factorial : ℕ)) : ℂ) * (((s - 1) ^ (j + 1))⁻¹) := by
  induction j generalizing s with
  | zero =>
      rw [iteratedDeriv_zero]
      simp
  | succ j ih =>
      rw [iteratedDeriv_succ]
      have heq : iteratedDeriv j (fun s : ℂ => (s - 1)⁻¹) =ᶠ[𝓝 s]
          fun t => (-1 : ℂ) ^ j * (((j.factorial : ℕ)) : ℂ) * (((t - 1) ^ (j + 1))⁻¹) := by
        filter_upwards [isOpen_ne.mem_nhds hs] with t ht
        exact ih ht
      rw [heq.deriv_eq]
      have hs1 : s - 1 ≠ 0 := sub_ne_zero.mpr hs
      have hpow : HasDerivAt (fun t : ℂ => (t - 1) ^ (j + 1))
          ((j + 1 : ℕ) * (s - 1) ^ j) s := by
        have h1 : HasDerivAt (fun t : ℂ => t - 1) (1 : ℂ) s :=
          (hasDerivAt_id s).sub_const (1 : ℂ)
        have hp := h1.pow (j + 1)
        convert hp using 1
        push_cast
        ring
      have hinv : HasDerivAt (fun t : ℂ => ((t - 1) ^ (j + 1))⁻¹)
          (-((j + 1 : ℕ) * (s - 1) ^ j) / ((s - 1) ^ (j + 1)) ^ 2) s :=
        hpow.inv (pow_ne_zero _ hs1)
      have hc := hinv.const_mul ((-1 : ℂ) ^ j * (((j.factorial : ℕ)) : ℂ))
      rw [hc.deriv]
      have hnp : (s - 1) ^ (j + 1) ≠ 0 := pow_ne_zero _ hs1
      rw [Nat.factorial_succ]
      push_cast
      field_simp
      ring


/-- The formal derivative, as a plain function. -/
def PolyD : Polynomial ℂ → Polynomial ℂ := fun p => Polynomial.derivative p

/-- `j`-fold formal derivative. -/
def polyIter : ℕ → Polynomial ℂ → Polynomial ℂ
  | 0, p => p
  | (j + 1), p => PolyD (polyIter j p)

/-- **Polynomial factor, `j`-th derivative:** `d^j/ds^j p(-s) = (-1)^j p^{(j)}(-s)`. -/
theorem iteratedDeriv_polynomial_neg (p : Polynomial ℂ) (j : ℕ) :
    iteratedDeriv j (fun s : ℂ => p.eval (-s))
      = fun s => (-1 : ℂ) ^ j * ((polyIter j p).eval (-s)) := by
  induction j with
  | zero =>
      funext s
      rw [iteratedDeriv_zero]
      simp [polyIter]
  | succ j ih =>
      rw [iteratedDeriv_succ, ih]
      funext s
      have hc : HasDerivAt (fun s : ℂ => -s) (-1) s := hasDerivAt_neg s
      have hq : HasDerivAt (fun x : ℂ => (polyIter j p).eval x)
          ((polyIter j p).derivative.eval (-s)) (-s) :=
        (polyIter j p).hasDerivAt (-s)
      have hmul := (hq.comp s hc).const_mul ((-1 : ℂ) ^ j)
      have hd := hmul.deriv
      simp only [Function.comp_apply] at hd
      rw [hd, show polyIter (j + 1) p = Polynomial.derivative (polyIter j p) from rfl]
      ring

/-- **Linearity of `iteratedDeriv` over a finite sum.** -/
theorem iteratedDeriv_finset_sum {ι : Type*} (I : Finset ι) (f : ι → ℂ → ℂ) (n : ℕ) (s : ℂ)
    (hf : ∀ i ∈ I, ContDiffAt ℂ (n : WithTop ℕ∞) (f i) s) :
    iteratedDeriv n (fun z : ℂ => ∑ i ∈ I, f i z) s
      = ∑ i ∈ I, iteratedDeriv n (f i) s := by
  have hfun : (fun z : ℂ => ∑ i ∈ I, f i z) = ∑ i ∈ I, f i := by
    funext z
    simp [Finset.sum_apply]
  rw [hfun, iteratedDeriv_sum (n := n) (x := s) (I := I) (f := f) hf]


/-- Polynomials are smooth. -/
theorem contDiff_polynomial_eval (p : Polynomial ℂ) (n : WithTop ℕ∞) :
    ContDiff ℂ n (fun s : ℂ => p.eval s) := by
  have h := Polynomial.contDiff_aeval (R := ℂ) (𝕜 := ℂ) p n
  simpa using h

theorem contDiffAt_polynomial_eval_neg (p : Polynomial ℂ) (n : WithTop ℕ∞) (s : ℂ) :
    ContDiffAt ℂ n (fun s : ℂ => p.eval (-s)) s :=
  (contDiff_polynomial_eval p n).contDiffAt.comp s (by fun_prop)

/-- Decomposition of `Ψ₃` into five explicit terms. -/
def psiTerm : Fin 5 → ℂ → ℂ
  | 0 => fun s => 21 * (s - 1)⁻¹
  | 1 => fun s => (1 / 2 : ℂ)
  | 2 => fun s => s / 252
  | 3 => fun s => (descPochhammer ℂ 3).eval (-s) / (720 * 9261)
  | 4 => fun s => -((descPochhammer ℂ 5).eval (-s) / (30240 * 4084101))

theorem Psi3_eq_sum : Psi3 = fun s => ∑ i : Fin 5, psiTerm i s := by
  funext s
  simp only [Psi3, psiTerm, Fin.sum_univ_five]
  rw [div_eq_mul_inv]
  ring


/-- Term 0: the pole factor, scaled by `21`. -/
theorem iteratedDeriv_psiTerm_zero (j : ℕ) (s : ℂ) :
    iteratedDeriv j (psiTerm 0) s
      = 21 * iteratedDeriv j (fun s : ℂ => (s - 1)⁻¹) s := by
  simp [psiTerm]

/-- Term 1: the constant `1/2`. -/
theorem iteratedDeriv_psiTerm_one (j : ℕ) (s : ℂ) :
    iteratedDeriv j (psiTerm 1) s = if j = 0 then (1 / 2 : ℂ) else 0 := by
  simp [psiTerm, iteratedDeriv_const]

/-- `d^n/ds^n (fun x => x)` (the `id` version with matching syntax). -/
theorem iteratedDeriv_fun_id' (n : ℕ) (s : ℂ) :
    iteratedDeriv n (fun x : ℂ => x) s = if n = 0 then s else if n = 1 then 1 else 0 := by
  have h : (fun x : ℂ => x) = id := rfl
  rw [h, iteratedDeriv_id]

/-- Term 2: `s/252`. -/
theorem iteratedDeriv_psiTerm_two (j : ℕ) (s : ℂ) :
    iteratedDeriv j (psiTerm 2) s =
      if j = 0 then s / 252 else if j = 1 then (1 / 252 : ℂ) else 0 := by
  obtain (_ | _ | j) := j <;> simp [psiTerm, iteratedDeriv_fun_id']

/-- Term 3: `P₃(-s)/(720·9261)`. -/
theorem iteratedDeriv_psiTerm_three (j : ℕ) (s : ℂ) :
    iteratedDeriv j (psiTerm 3) s
      = (1 / (720 * 9261 : ℂ)) *
          iteratedDeriv j (fun s : ℂ => (descPochhammer ℂ 3).eval (-s)) s := by
  simp [psiTerm]
  ring

/-- Term 4: `-P₅(-s)/(30240·4084101)`. -/
theorem iteratedDeriv_psiTerm_four (j : ℕ) (s : ℂ) :
    iteratedDeriv j (psiTerm 4) s
      = (-(1 / (30240 * 4084101 : ℂ))) *
          iteratedDeriv j (fun s : ℂ => (descPochhammer ℂ 5).eval (-s)) s := by
  simp [psiTerm]
  ring


/-- **The `j`-th derivative of `Ψ₃`** (all five terms), for `s ≠ 1`. -/
theorem iteratedDeriv_Psi3 (j : ℕ) (s : ℂ) (hs : s ≠ 1) :
    iteratedDeriv j Psi3 s
      = 21 * ((-1 : ℂ)^j * (((j.factorial : ℕ)) : ℂ) * (((s - 1) ^ (j + 1))⁻¹))
        + (if j = 0 then (1 / 2 : ℂ) else 0)
        + (if j = 0 then s / 252 else if j = 1 then (1 / 252 : ℂ) else 0)
        + (1 / (720 * 9261 : ℂ)) * ((-1 : ℂ)^j * ((polyIter j (descPochhammer ℂ 3)).eval (-s)))
        - (1 / (30240 * 4084101 : ℂ)) * ((-1 : ℂ)^j * ((polyIter j (descPochhammer ℂ 5)).eval (-s))) := by
  have hs1 : s - 1 ≠ 0 := sub_ne_zero.mpr hs
  rw [Psi3_eq_sum, iteratedDeriv_finset_sum]
  · simp only [Fin.sum_univ_five, iteratedDeriv_psiTerm_zero, iteratedDeriv_psiTerm_one,
      iteratedDeriv_psiTerm_two, iteratedDeriv_psiTerm_three, iteratedDeriv_psiTerm_four,
      iteratedDeriv_inv_sub_one j hs, iteratedDeriv_polynomial_neg]
    ring
  · intro i hi
    fin_cases i
    · simp only [psiTerm]; fun_prop
    · simp only [psiTerm]; fun_prop
    · simp only [psiTerm]; fun_prop
    · simp only [psiTerm]
      exact ContDiffAt.div_const (contDiffAt_polynomial_eval_neg (descPochhammer ℂ 3) _ s) _
    · simp only [psiTerm]
      exact ContDiffAt.neg (ContDiffAt.div_const
        (contDiffAt_polynomial_eval_neg (descPochhammer ℂ 5) _ s) _)


/-- **`Ψ₃` is smooth away from the pole** (needed for the `iteratedDeriv` add/mul rules). -/
theorem contDiffAt_Psi3 (n : WithTop ℕ∞) {s : ℂ} (hs : s ≠ 1) :
    ContDiffAt ℂ n Psi3 s := by
  have hs1 : s - 1 ≠ 0 := sub_ne_zero.mpr hs
  rw [Psi3_eq_sum]
  apply ContDiffAt.sum
  intro i hi
  fin_cases i
  · simp only [psiTerm]
    fun_prop
  · simp only [psiTerm]
    exact contDiffAt_const
  · simp only [psiTerm]
    fun_prop
  · simp only [psiTerm]
    exact ContDiffAt.div_const (contDiffAt_polynomial_eval_neg (descPochhammer ℂ 3) _ s) _
  · simp only [psiTerm]
    exact ContDiffAt.neg (ContDiffAt.div_const
      (contDiffAt_polynomial_eval_neg (descPochhammer ℂ 5) _ s) _)


/-- **The `k`-th derivative of the `K = 3` generator**, in closed form. -/
theorem iteratedDeriv_gen3 (k : ℕ) {s : ℂ} (hs : s ≠ 1) :
    iteratedDeriv k (zetaEMGen 3 20) s
      = (∑ n ∈ Finset.range 20,
            (-Complex.log ((((n + 1 : ℝ)) : ℂ))) ^ k * ((((n + 1 : ℝ)) : ℂ) ^ (-s)))
        + ∑ i ∈ Finset.range (k + 1),
            (k.choose i : ℂ) * ((-Complex.log 21) ^ i * (21 : ℂ) ^ (-s))
              * iteratedDeriv (k - i) Psi3 s := by
  have hsum : ContDiffAt ℂ (k : WithTop ℕ∞)
      (fun z : ℂ => ∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-z))) s := by
    apply ContDiffAt.sum
    intro n hn
    refine contDiffAt_cpow_neg _ ?_ k s
    intro hzero
    have hre := congrArg Complex.re hzero
    rw [Complex.ofReal_re, Complex.zero_re] at hre
    have hn0 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    linarith
  have hprod : ContDiffAt ℂ (k : WithTop ℕ∞)
      (fun z : ℂ => (21 : ℂ) ^ (-z) * Psi3 z) s :=
    (contDiffAt_cpow_neg 21 (by norm_num) k s).mul (contDiffAt_Psi3 k hs)
  have hfun : (zetaEMGen 3 20 : ℂ → ℂ)
      = fun z : ℂ => (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
        + (21 : ℂ) ^ (-z) * Psi3 z := by
    funext z
    exact gen3_eq_sum_psi z
  rw [hfun]
  rw [show (fun z : ℂ => (∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
        + (21 : ℂ) ^ (-z) * Psi3 z)
      = (fun z : ℂ => ∑ n ∈ Finset.range 20, ((((n + 1 : ℝ)) : ℂ) ^ (-z)))
        + (fun z : ℂ => (21 : ℂ) ^ (-z) * Psi3 z) from rfl]
  rw [iteratedDeriv_add hsum hprod, iteratedDeriv_sum_cpow,
    iteratedDeriv_mul_pow21 k Psi3 s (contDiffAt_Psi3 _ hs)]


/-- The `k`-th power of the `log b` point box. -/
def logBoxPow (N b : ℕ) : ℕ → Cx
  | 0 => ptBox 1 0
  | (k + 1) => (logBoxPow N b k).mul ⟨logIvRat N b, (⟨0, 0⟩ : Iv)⟩

theorem mem_logBoxPow (N b k : ℕ) (hb : 1 ≤ b) :
    (logBoxPow N b k).mem ((Complex.log (((b : ℕ) : ℝ) : ℂ)) ^ k) := by
  induction k with
  | zero => simpa [logBoxPow] using (mem_ptBox (q := 1) (r := 0) (by simp) (by simp) :
      (ptBox 1 0).mem (1 : ℂ))
  | succ k ih =>
      rw [logBoxPow, pow_succ]
      exact Cx.mem_mul ih (mem_logBox' N b hb)


/-- One atom of the `k`-th derivative sum: `(log n)^k · n^{-s14}`. -/
def derivAtomPow (k n : ℕ) : Cx :=
  (cpowBox 20 16 48 24 n S14).mul (logBoxPow 20 n k)

/-- Fold of `derivAtomPow k` over `n = 1..M`. -/
def dsPowPow (k : ℕ) : ℕ → Cx
  | 0 => ⟨⟨0, 0⟩, ⟨0, 0⟩⟩
  | (M + 1) => (dsPowPow k M).add (derivAtomPow k (M + 1))

theorem dsPowPow_mem (k M : ℕ)
    (h : ∀ n, n < M → CpowConditions 20 16 48 24 (n + 1) S14) :
    (dsPowPow k M).mem
      (∑ n ∈ Finset.range M,
        ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14)) * ((Complex.log (((n + 1 : ℕ) : ℝ) : ℂ)) ^ k)) := by
  induction M with
  | zero => simp [dsPowPow, Cx.mem, Iv.memR]
  | succ M ih =>
      rw [dsPowPow, Finset.sum_range_succ]
      apply Cx.mem_add
      · exact ih (fun n hn => h n (by omega))
      · obtain ⟨hb, hk, hkI, hn, he1, he2, hI1, hI2⟩ := h M (by omega)
        exact Cx.mem_mul (cpowBox_mem hb mem_S14 hk hkI hn he1 he2 hI1 hI2)
          (mem_logBoxPow 20 (M + 1) k (by omega))

/-! ## Exact values of `Ψ₃^{(j)}(s14)` -/

theorem P3_mono : descPochhammer ℂ 3 = Polynomial.X ^ 3 - 3 * Polynomial.X ^ 2 + 2 * Polynomial.X := by
  simp [descPochhammer]
  ring_nf

theorem P5_mono : descPochhammer ℂ 5 = Polynomial.X ^ 5 - 10 * Polynomial.X ^ 4 + 35 * Polynomial.X ^ 3
    - 50 * Polynomial.X ^ 2 + 24 * Polynomial.X := by
  simp [descPochhammer]
  ring_nf

theorem inv_pow_s14_sub_one (m : ℕ) :
    ((s14 - 1) ^ m)⁻¹ =
      ((((-2 / 785 : ℝ) : ℂ) + ((-56 / 785 : ℝ) : ℂ) * Complex.I) ^ m) := by
  rw [← inv_pow]
  congr 1
  rw [inv_eq_one_div, inv_s14_sub_one]

/-- Real part of `Ψ₃^{(j)}(s14)`, `j ≤ 6` (exact). -/
def psiRe : ℕ → ℚ
  | 0 => 39765388134947 / 88640021191680
  | 1 => 26981771701667341 / 243538458224140800
  | 2 => 38985956058659131 / 23897211213243816000
  | 3 => -10127609715859404893 / 3126551800399399260000
  | 4 => -101763989839147157867 / 613585790828382104775000
  | 5 => 15691992412343226121901 / 48166484580027995224837500
  | 6 => 1297363014162432 / 36738176211523328125
  | _ => 0

/-- Imaginary part of `Ψ₃^{(j)}(s14)`, `j ≤ 6` (exact). -/
def psiIm : ℕ → ℚ
  | 0 => -31957632314371 / 22160005297920
  | 1 => -1849142049389 / 241605613317600
  | 2 => 12952590191792761 / 853471829044422000
  | 3 => 25995669568631621 / 55831282149989272500
  | 4 => -20144741568085642927 / 21913778243870789456250
  | 5 => -3316669526016 / 46800224473278125
  | 6 => 5083137461477376 / 36738176211523328125
  | _ => 0

theorem iteratedDeriv_Psi3_val (j : ℕ) (hj : j ≤ 6) :
    iteratedDeriv j Psi3 s14 = ((psiRe j : ℚ) : ℂ) + ((psiIm j : ℚ) : ℂ) * Complex.I := by
  interval_cases j <;>
  · rw [iteratedDeriv_Psi3 _ s14 s14_ne_one, P3_mono, P5_mono, inv_pow_s14_sub_one]
    simp [polyIter, PolyD, psiRe, psiIm, pow_succ, pow_two]
    apply Complex.ext <;>
      simp [s14, Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im,
        Complex.mul_re, Complex.mul_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im, pow_succ, pow_two] <;>
      norm_num

/-! ## The boxes -/

/-- The point box at `Ψ₃^{(j)}(s14)`. -/
def psiBox (j : ℕ) : Cx := ptBox (psiRe j) (psiIm j)

theorem mem_psiBox (j : ℕ) (hj : j ≤ 6) :
    (psiBox j).mem (iteratedDeriv j Psi3 s14) := by
  rw [iteratedDeriv_Psi3_val j hj]
  apply mem_ptBox <;> simp [psiBox]

/-- The point box at `(-1)^i`. -/
def signBox (i : ℕ) : Cx := ptBox ((-1 : ℚ) ^ i) 0

theorem neg_one_pow_re (i : ℕ) : ((-1 : ℂ) ^ i).re = ((-1 : ℝ) ^ i) := by
  induction i with
  | zero => simp
  | succ i ih => rw [pow_succ, pow_succ]; simp [ih, Complex.mul_re, Complex.neg_re, Complex.one_re]

theorem neg_one_pow_im (i : ℕ) : ((-1 : ℂ) ^ i).im = 0 := by
  induction i with
  | zero => simp
  | succ i ih => rw [pow_succ]; simp [ih, Complex.mul_im]

theorem mem_signBox (i : ℕ) : (signBox i).mem ((-1 : ℂ) ^ i) := by
  apply mem_ptBox
  · show ((-1 : ℂ) ^ i).re = (((-1 : ℚ) ^ i : ℚ) : ℝ)
    rw [neg_one_pow_re]
    push_cast
    ring
  · show ((-1 : ℂ) ^ i).im = ((0 : ℚ) : ℝ)
    rw [neg_one_pow_im]
    norm_num

/-- The point box at the binomial coefficient. -/
def chooseBox (k i : ℕ) : Cx := ptBox ((k.choose i : ℕ) : ℚ) 0

theorem mem_chooseBox (k i : ℕ) : (chooseBox k i).mem ((k.choose i : ℂ)) := by
  apply mem_ptBox
  · push_cast
    simp [chooseBox]
  · simp [chooseBox]

/-- One term of the `21^{-s14}`-side scalar box. -/
def sTerm (k i : ℕ) : Cx :=
  (chooseBox k i).mul ((signBox i).mul ((logBoxPow 20 21 i).mul
    ((cpowBox 20 16 48 24 21 S14).mul (psiBox (k - i)))))

/-- Fold of the scalar-box terms over `i = 0..M-1`. -/
def sBox (k : ℕ) : ℕ → Cx
  | 0 => ⟨⟨0, 0⟩, ⟨0, 0⟩⟩
  | (M + 1) => (sBox k M).add (sTerm k M)

/-- The scalar value summed by `sBox`. -/
def sVal (k i : ℕ) : ℂ :=
  (k.choose i : ℂ) * (-Complex.log 21) ^ i * (21 : ℂ) ^ (-s14) * iteratedDeriv (k - i) Psi3 s14

theorem sTerm_mem (k i : ℕ) (hk : k ≤ 6) (hi : i ≤ k) : (sTerm k i).mem (sVal k i) := by
  have hki : k - i ≤ 6 := by omega
  have hlog : (logBoxPow 20 21 i).mem ((Complex.log 21) ^ i) := by
    have h := mem_logBoxPow 20 21 i (by norm_num)
    rw [show (Complex.log 21) = Complex.log ((((21 : ℕ) : ℝ)) : ℂ) by rw [cpow21_base]]
    exact h
  have hcp : (cpowBox 20 16 48 24 21 S14).mem ((21 : ℂ) ^ (-s14)) := by
    have hbase : ((21 : ℂ) ^ (-s14)) = (((((21 : ℕ) : ℝ)) : ℂ) ^ (-s14)) := by
      rw [cpow21_base]
    rw [hbase]
    obtain ⟨hb, hk', hkI, hn, he1, he2, hI1, hI2⟩ :=
      CpowConditions_of_OK (by native_decide : CpowOK 20 16 48 24 21 S14 = true)
    exact cpowBox_mem hb mem_S14 hk' hkI hn he1 he2 hI1 hI2
  simp only [sTerm]
  have h := Cx.mem_mul (mem_chooseBox k i)
    (Cx.mem_mul (mem_signBox i) (Cx.mem_mul hlog (Cx.mem_mul hcp (mem_psiBox (k - i) hki))))
  convert h using 2
  simp only [sVal]
  rw [show (-Complex.log 21 : ℂ) = (-1) * Complex.log 21 by ring, mul_pow]
  ring

theorem sBox_mem (k : ℕ) (hk : k ≤ 6) (M : ℕ) (hM : M ≤ k + 1) :
    (sBox k M).mem (∑ i ∈ Finset.range M, sVal k i) := by
  induction M with
  | zero => simp [sBox, Cx.mem, Iv.memR]
  | succ M ih =>
      rw [sBox, Finset.sum_range_succ]
      apply Cx.mem_add
      · exact ih (by omega)
      · exact sTerm_mem k M hk (by omega)

/-- The box for the `k`-th derivative of the `K = 3` generator at `s14`. -/
def gen3Box (k : ℕ) : Cx := ((signBox k).mul (dsPowPow k 20)).add (sBox k (k + 1))

/-- `(-1)^k · Σ (log n)^k n^{-s14} = Σ (-log n)^k n^{-s14}`. -/
theorem sign_mul_dsPow (k : ℕ) :
    (-1 : ℂ) ^ k * (∑ n ∈ Finset.range 20,
        ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14)) * (Complex.log ((((n + 1 : ℕ) : ℝ) : ℂ))) ^ k)
      = ∑ n ∈ Finset.range 20,
        (-Complex.log ((((n + 1 : ℕ) : ℝ) : ℂ))) ^ k * ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14)) := by
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro n hn
  rw [show (-Complex.log ((((n + 1 : ℕ) : ℝ) : ℂ))) = (-1 : ℂ) * Complex.log
      ((((n + 1 : ℕ) : ℝ) : ℂ)) by ring, mul_pow]
  ring

/-- Cast bridge between the `ℕ`-cast and `ℝ`-cast forms of the base sum. -/
theorem base_sum_cast (k : ℕ) :
    (∑ n ∈ Finset.range 20,
        (-Complex.log ((((n + 1 : ℝ)) : ℂ))) ^ k * ((((n + 1 : ℝ)) : ℂ) ^ (-s14)))
      = ∑ n ∈ Finset.range 20,
        (-Complex.log ((((n + 1 : ℕ) : ℝ) : ℂ))) ^ k
          * ((((n + 1 : ℕ) : ℝ) : ℂ) ^ (-s14)) := by
  apply Finset.sum_congr rfl
  intro n hn
  have hc : ((((n + 1 : ℕ) : ℝ)) : ℂ) = ((((n + 1 : ℝ)) : ℂ)) := by push_cast; ring
  rw [hc]

theorem gen3Box_mem (k : ℕ) (hk : k ≤ 6) :
    (gen3Box k).mem (iteratedDeriv k (zetaEMGen 3 20) s14) := by
  have hb := Cx.mem_mul (mem_signBox k)
    (dsPowPow_mem k 20 (sumOK_conditions (by native_decide : sumOK 20 = true)))
  have hs := sBox_mem k hk (k + 1) (le_refl _)
  have h := Cx.mem_add hb hs
  rw [iteratedDeriv_gen3 k s14_ne_one, base_sum_cast]
  convert h using 2
  · exact (sign_mul_dsPow k).symm
  · apply Finset.sum_congr rfl
    intro i hi
    simp only [sVal]
    ring
  · rfl

/-! ## Corner bounds -/

theorem norm_gen3_deriv_le (k : ℕ) (hk : k ≤ 6) {q : ℚ} (hq0 : 0 ≤ q)
    (hq : (maxAbsIv (gen3Box k).re) ^ 2 + (maxAbsIv (gen3Box k).im) ^ 2 ≤ q ^ 2) :
    ‖iteratedDeriv k (zetaEMGen 3 20) s14‖ ≤ (q : ℝ) := by
  have hqr : ((maxAbsIv (gen3Box k).re) ^ 2 + (maxAbsIv (gen3Box k).im) ^ 2 : ℝ) ≤
      ((q : ℚ) : ℝ) ^ 2 := by exact_mod_cast hq
  have hq0r : (0 : ℝ) ≤ ((q : ℚ) : ℝ) := by exact_mod_cast hq0
  exact norm_le_of_mem_box (gen3Box_mem k hk) hq0r (by simpa using hqr)

theorem corner_gen3_two :
    (maxAbsIv (gen3Box 2).re) ^ 2 + (maxAbsIv (gen3Box 2).im) ^ 2 ≤ ((70 / 100 : ℚ)) ^ 2 := by
  native_decide

theorem corner_gen3_three :
    (maxAbsIv (gen3Box 3).re) ^ 2 + (maxAbsIv (gen3Box 3).im) ^ 2 ≤ ((61 / 100 : ℚ)) ^ 2 := by
  native_decide

theorem corner_gen3_four :
    (maxAbsIv (gen3Box 4).re) ^ 2 + (maxAbsIv (gen3Box 4).im) ^ 2 ≤ ((55 / 100 : ℚ)) ^ 2 := by
  native_decide

theorem corner_gen3_five :
    (maxAbsIv (gen3Box 5).re) ^ 2 + (maxAbsIv (gen3Box 5).im) ^ 2 ≤ ((53 / 100 : ℚ)) ^ 2 := by
  native_decide

theorem corner_gen3_six :
    (maxAbsIv (gen3Box 6).re) ^ 2 + (maxAbsIv (gen3Box 6).im) ^ 2 ≤ ((53 / 100 : ℚ)) ^ 2 := by
  native_decide

/-- `|gen₃^{(2)}(s14)| ≤ 0.70`.  True value `0.6378`. -/
theorem norm_gen3_deriv_two :
    ‖iteratedDeriv 2 (zetaEMGen 3 20) s14‖ ≤ ((70 / 100 : ℚ) : ℝ) :=
  norm_gen3_deriv_le 2 (by norm_num) (q := 70 / 100) (by norm_num) corner_gen3_two

/-- `|gen₃^{(3)}(s14)| ≤ 0.61`.  True value `0.5506`. -/
theorem norm_gen3_deriv_three :
    ‖iteratedDeriv 3 (zetaEMGen 3 20) s14‖ ≤ ((61 / 100 : ℚ) : ℝ) :=
  norm_gen3_deriv_le 3 (by norm_num) (q := 61 / 100) (by norm_num) corner_gen3_three

/-- `|gen₃^{(4)}(s14)| ≤ 0.55`.  True value `0.5005`. -/
theorem norm_gen3_deriv_four :
    ‖iteratedDeriv 4 (zetaEMGen 3 20) s14‖ ≤ ((55 / 100 : ℚ) : ℝ) :=
  norm_gen3_deriv_le 4 (by norm_num) (q := 55 / 100) (by norm_num) corner_gen3_four

/-- `|gen₃^{(5)}(s14)| ≤ 0.53`.  True value `0.4789`. -/
theorem norm_gen3_deriv_five :
    ‖iteratedDeriv 5 (zetaEMGen 3 20) s14‖ ≤ ((53 / 100 : ℚ) : ℝ) :=
  norm_gen3_deriv_le 5 (by norm_num) (q := 53 / 100) (by norm_num) corner_gen3_five

/-- `|gen₃^{(6)}(s14)| ≤ 0.53`.  True value `0.4802`. -/
theorem norm_gen3_deriv_six :
    ‖iteratedDeriv 6 (zetaEMGen 3 20) s14‖ ≤ ((53 / 100 : ℚ) : ℝ) :=
  norm_gen3_deriv_le 6 (by norm_num) (q := 53 / 100) (by norm_num) corner_gen3_six

end FiniteWindowZeros
