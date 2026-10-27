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


end FiniteWindowZeros
