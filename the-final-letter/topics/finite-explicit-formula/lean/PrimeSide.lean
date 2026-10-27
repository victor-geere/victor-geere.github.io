import Topic
import Transcend

/-!
# Lean-certified finite prime side

The five prime powers `2,3,4,5,7` contributing to the explicit formula for the
tent autocorrelation, enclosed in rational interval arithmetic.  The sum is
proved negative.  This is the Lean counterpart of the Python `prime_side`
computation; the analytic explicit formula itself is still a source claim.
-/

noncomputable section

namespace FiniteExplicitFormula

open PartialTail

/-- The interval constant `q`. -/
def iconst (q : ℚ) : Iv := ⟨q, q⟩

/-- The polynomial `x^3/2 - x^2 + 2/3` on intervals. -/
def g1Box (x : Iv) : Iv :=
  (((x.mul x).mul x).scale (1 / 2)).sub (x.mul x) |>.add (iconst (2 / 3))

theorem g1Box_mem {x : ℝ} {A : Iv} (h : A.memR x) :
    (g1Box A).memR (x ^ 3 / 2 - x ^ 2 + 2 / 3) := by
  unfold g1Box
  have h2 : (A.mul A).memR (x * x) := Iv.memR_mul h h
  have h3 : ((A.mul A).mul A).memR ((x * x) * x) := Iv.memR_mul h2 h
  have hs : (((A.mul A).mul A).scale (1 / 2)).memR ((1 / 2 : ℝ) * ((x * x) * x)) := by
    simpa using Iv.memR_scale (q := 1 / 2) h3
  have hc : (iconst (2 / 3)).memR (2 / 3 : ℝ) := by
    simp [iconst, Iv.memR]
  have hsub : ((((A.mul A).mul A).scale (1 / 2)).sub (A.mul A)).memR
      ((1 / 2 : ℝ) * ((x * x) * x) - x * x) := Iv.memR_sub hs h2
  have := Iv.memR_add hsub hc
  convert this using 1 <;> ring

/-- The polynomial `-x^3/6 + x^2 - 2x + 4/3` on intervals. -/
def g2Box (x : Iv) : Iv :=
  (((x.mul x).mul x).scale (-1 / 6)).add (x.mul x) |>.sub (x.scale 2) |>.add (iconst (4 / 3))

theorem g2Box_mem {x : ℝ} {A : Iv} (h : A.memR x) :
    (g2Box A).memR (-x ^ 3 / 6 + x ^ 2 - 2 * x + 4 / 3) := by
  unfold g2Box
  have h2 : (A.mul A).memR (x * x) := Iv.memR_mul h h
  have h3 : ((A.mul A).mul A).memR ((x * x) * x) := Iv.memR_mul h2 h
  have hs : (((A.mul A).mul A).scale (-1 / 6)).memR ((-1 / 6 : ℝ) * ((x * x) * x)) := by
    simpa using Iv.memR_scale (q := -1 / 6) h3
  have h2x : (A.scale 2).memR ((2 : ℝ) * x) := by
    simpa using Iv.memR_scale (q := (2 : ℚ)) h
  have hc : (iconst (4 / 3)).memR (4 / 3 : ℝ) := by
    simp [iconst, Iv.memR]
  have h1 : ((((A.mul A).mul A).scale (-1 / 6)).add (A.mul A)).memR
      ((-1 / 6 : ℝ) * ((x * x) * x) + x * x) := Iv.memR_add hs h2
  have h2' : (((((A.mul A).mul A).scale (-1 / 6)).add (A.mul A)).sub (A.scale 2)).memR
      (((-1 / 6 : ℝ) * ((x * x) * x) + x * x) - (2 : ℝ) * x) :=
    Iv.memR_sub h1 h2x
  have := Iv.memR_add h2' hc
  convert this using 1 <;> ring

/-- The rational enclosure of `1/sqrt n` for the five contributing `n`. -/
def sqrtInvBox : ℕ → Iv
  | 2 => ⟨707 / 1000, 708 / 1000⟩
  | 3 => ⟨577 / 1000, 578 / 1000⟩
  | 4 => ⟨1 / 2, 1 / 2⟩
  | 5 => ⟨447 / 1000, 448 / 1000⟩
  | 7 => ⟨377 / 1000, 378 / 1000⟩
  | _ => ⟨0, 0⟩

theorem sqrtInvBox_mem2 : (sqrtInvBox 2).memR (1 / Real.sqrt 2) := by
  have h : (0 : ℝ) < Real.sqrt 2 := Real.sqrt_pos.2 (by norm_num)
  constructor
  · rw [le_div_iff₀ h]
    have hs : (707 / 1000 : ℝ) * Real.sqrt 2 ≤ 1 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 2), Real.sqrt_nonneg 2]
    simpa [sqrtInvBox] using hs
  · rw [div_le_iff₀ h]
    have hs : (1 : ℝ) ≤ (708 / 1000 : ℝ) * Real.sqrt 2 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 2), Real.sqrt_nonneg 2]
    simpa [sqrtInvBox] using hs

theorem sqrtInvBox_mem3 : (sqrtInvBox 3).memR (1 / Real.sqrt 3) := by
  have h : (0 : ℝ) < Real.sqrt 3 := Real.sqrt_pos.2 (by norm_num)
  constructor
  · rw [le_div_iff₀ h]
    have hs : (577 / 1000 : ℝ) * Real.sqrt 3 ≤ 1 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 3), Real.sqrt_nonneg 3]
    simpa [sqrtInvBox] using hs
  · rw [div_le_iff₀ h]
    have hs : (1 : ℝ) ≤ (578 / 1000 : ℝ) * Real.sqrt 3 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 3), Real.sqrt_nonneg 3]
    simpa [sqrtInvBox] using hs

theorem sqrtInvBox_mem4 : (sqrtInvBox 4).memR (1 / Real.sqrt 4) := by
  have h : Real.sqrt 4 = 2 := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]
  simp [sqrtInvBox, Iv.memR, h]

theorem sqrtInvBox_mem5 : (sqrtInvBox 5).memR (1 / Real.sqrt 5) := by
  have h : (0 : ℝ) < Real.sqrt 5 := Real.sqrt_pos.2 (by norm_num)
  constructor
  · rw [le_div_iff₀ h]
    have hs : (447 / 1000 : ℝ) * Real.sqrt 5 ≤ 1 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 5), Real.sqrt_nonneg 5]
    simpa [sqrtInvBox] using hs
  · rw [div_le_iff₀ h]
    have hs : (1 : ℝ) ≤ (448 / 1000 : ℝ) * Real.sqrt 5 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 5), Real.sqrt_nonneg 5]
    simpa [sqrtInvBox] using hs

theorem sqrtInvBox_mem7 : (sqrtInvBox 7).memR (1 / Real.sqrt 7) := by
  have h : (0 : ℝ) < Real.sqrt 7 := Real.sqrt_pos.2 (by norm_num)
  constructor
  · rw [le_div_iff₀ h]
    have hs : (377 / 1000 : ℝ) * Real.sqrt 7 ≤ 1 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 7), Real.sqrt_nonneg 7]
    simpa [sqrtInvBox] using hs
  · rw [div_le_iff₀ h]
    have hs : (1 : ℝ) ≤ (378 / 1000 : ℝ) * Real.sqrt 7 := by
      nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 7), Real.sqrt_nonneg 7]
    simpa [sqrtInvBox] using hs

theorem sqrtInvBox_mem {n : ℕ}
    (hn : n = 2 ∨ n = 3 ∨ n = 4 ∨ n = 5 ∨ n = 7) :
    (sqrtInvBox n).memR (1 / Real.sqrt n) := by
  rcases hn with rfl | rfl | rfl | rfl | rfl
  · exact sqrtInvBox_mem2
  · exact sqrtInvBox_mem3
  · exact sqrtInvBox_mem4
  · exact sqrtInvBox_mem5
  · exact sqrtInvBox_mem7

/-- The interval for `log p`. -/
def logP (p : ℕ) : Iv := logIv 40 ⟨(p : ℚ), (p : ℚ)⟩

theorem logP_mem {p : ℕ} (hp : 1 ≤ p) : (logP p).memR (Real.log p) := by
  apply logIv_memR (N := 40) (A := ⟨(p : ℚ), (p : ℚ)⟩)
  · have hp' : (1 : ℚ) ≤ (p : ℚ) := by exact_mod_cast hp
    simpa using hp'
  · simp [Iv.memR]

/-- One prime term: `-2 · (log p / sqrt n) · g(log n)`. -/
def termBox (n p : ℕ) (g : Iv → Iv) : Iv :=
  ((logP p).mul (sqrtInvBox n)).mul (g (logP n)) |>.scale (-2)

/-- The real value of one prime term. -/
def termValue (n p : ℕ) (g : ℝ → ℝ) : ℝ :=
  -2 * (Real.log p / Real.sqrt n) * g (Real.log n)

theorem termBox_mem {n p : ℕ} (hn : 1 ≤ n) (hp : 1 ≤ p)
    (hnmem : n = 2 ∨ n = 3 ∨ n = 4 ∨ n = 5 ∨ n = 7)
    {gI : Iv → Iv} {gR : ℝ → ℝ}
    (hg : ∀ {A : Iv} {x : ℝ}, A.memR x → (gI A).memR (gR x)) :
    (termBox n p gI).memR (termValue n p gR) := by
  unfold termBox termValue
  have hLp := logP_mem hp
  have hLn := logP_mem hn
  have hS : (sqrtInvBox n).memR (1 / Real.sqrt n) := sqrtInvBox_mem hnmem
  have hLS : ((logP p).mul (sqrtInvBox n)).memR
      (Real.log p * (1 / Real.sqrt n)) := Iv.memR_mul hLp hS
  have hG := hg hLn
  have hprod : (((logP p).mul (sqrtInvBox n)).mul (gI (logP n))).memR
      ((Real.log p * (1 / Real.sqrt n)) * gR (Real.log n)) := Iv.memR_mul hLS hG
  have hscale := Iv.memR_scale (q := (-2 : ℚ)) hprod
  convert hscale using 1 <;> ring

def g1R (x : ℝ) : ℝ := x ^ 3 / 2 - x ^ 2 + 2 / 3
def g2R (x : ℝ) : ℝ := -x ^ 3 / 6 + x ^ 2 - 2 * x + 4 / 3

theorem g1R_mem : ∀ {A : Iv} {x : ℝ}, A.memR x → (g1Box A).memR (g1R x) := by
  intro A x h
  simpa [g1R] using g1Box_mem h

theorem g2R_mem : ∀ {A : Iv} {x : ℝ}, A.memR x → (g2Box A).memR (g2R x) := by
  intro A x h
  simpa [g2R] using g2Box_mem h

/-- The five prime terms. -/
def primeSideBox : Iv :=
  (((((termBox 2 2 g1Box).add (termBox 3 3 g2Box)).add
    (termBox 4 2 g2Box)).add (termBox 5 5 g2Box)).add (termBox 7 7 g2Box))

def primeSideValue : ℝ :=
  termValue 2 2 g1R + termValue 3 3 g2R + termValue 4 2 g2R +
    termValue 5 5 g2R + termValue 7 7 g2R

theorem primeSideBox_mem : primeSideBox.memR primeSideValue := by
  unfold primeSideBox primeSideValue
  have h2 := termBox_mem (n := 2) (p := 2) (by norm_num) (by norm_num) (by decide) (gI := g1Box) (gR := g1R) g1R_mem
  have h3 := termBox_mem (n := 3) (p := 3) (by norm_num) (by norm_num) (by decide) (gI := g2Box) (gR := g2R) g2R_mem
  have h4 := termBox_mem (n := 4) (p := 2) (by norm_num) (by norm_num) (by decide) (gI := g2Box) (gR := g2R) g2R_mem
  have h5 := termBox_mem (n := 5) (p := 5) (by norm_num) (by norm_num) (by decide) (gI := g2Box) (gR := g2R) g2R_mem
  have h7 := termBox_mem (n := 7) (p := 7) (by norm_num) (by norm_num) (by decide) (gI := g2Box) (gR := g2R) g2R_mem
  have h := Iv.memR_add (Iv.memR_add (Iv.memR_add (Iv.memR_add h2 h3) h4) h5) h7
  convert h using 1 <;> ring

theorem primeSide_negative : (primeSideBox.hi : ℝ) < 0 := by
  have h : primeSideBox.hi < (0 : ℚ) := by native_decide
  exact_mod_cast h

theorem primeSideValue_negative : primeSideValue < 0 :=
  lt_of_le_of_lt primeSideBox_mem.2 primeSide_negative

end FiniteExplicitFormula
