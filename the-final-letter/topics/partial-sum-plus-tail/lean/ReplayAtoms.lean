import Replay
import Transcend

/-!
# Atom discharge for the concrete ζ(2) replay

The generated replay `Replay.lean` left the atom boxes `A i` as hypotheses.
This file defines the true atom values `σ i` and proves every box with the
kernel-checked enclosures of `Transcend.lean`: `logIv_memR` for the four
logarithms, and `norm_num` for the rational powers.  The result is
`Replay.cert_mem` with no atom hypothesis.
-/

noncomputable section

namespace PartialTail.Replay

open PartialTail

/-- The true value of each atom of the ζ(2) replay. -/
def σ (i : Nat) : ℂ :=
  if i < 23 then
    match i with
    | 0 => 2
    | 1 => 0
    | 2 => 1
    | 3 => Complex.ofReal (Real.log 2)
    | 4 => (1 / 4 : ℂ)
    | 5 => Complex.ofReal (Real.log 3)
    | 6 => (1 / 9 : ℂ)
    | 7 => Complex.ofReal (Real.log 4)
    | 8 => 1
    | 9 => (1 / 4 : ℂ)
    | 10 => (1 / 4 : ℂ)
    | 11 => (1 / 16 : ℂ)
    | 12 => 1
    | 13 => 0
    | 14 => 1
    | 15 => (1 / 64 : ℂ)
    | 16 => 1
    | 17 => 0
    | 18 => 1
    | 19 => 2
    | 20 => 3
    | 21 => (1 / 1024 : ℂ)
    | 22 => 0
    | _ => 0
  else 0

theorem Iv.memR_mono {x : ℝ} {A B : Iv} (h : B.memR x)
    (hlo : A.lo ≤ B.lo) (hhi : B.hi ≤ A.hi) : A.memR x := by
  constructor
  · have : ((A.lo : ℚ) : ℝ) ≤ ((B.lo : ℚ) : ℝ) := by exact_mod_cast hlo
    linarith [h.1]
  · have : ((B.hi : ℚ) : ℝ) ≤ ((A.hi : ℚ) : ℝ) := by exact_mod_cast hhi
    linarith [h.2]

theorem log_two_mem_A3 : Cx.mem ((Real.log 2 : ℂ)) (A 3) := by
  have h := logIv_memR (N := 24) (A := ⟨2, 2⟩) (x := 2) (by norm_num) (by norm_num [Iv.memR])
  have hlo : (A 3).re.lo ≤ (logIv 24 ⟨2, 2⟩).lo := by native_decide
  have hhi : (logIv 24 ⟨2, 2⟩).hi ≤ (A 3).re.hi := by native_decide
  refine ⟨Iv.memR_mono h hlo hhi, ?_⟩
  rw [Complex.ofReal_im]
  norm_num [A, Iv.memR]

theorem log_three_mem_A5 : Cx.mem ((Real.log 3 : ℂ)) (A 5) := by
  have h := logIv_memR (N := 40) (A := ⟨3, 3⟩) (x := 3) (by norm_num) (by norm_num [Iv.memR])
  have hlo : (A 5).re.lo ≤ (logIv 40 ⟨3, 3⟩).lo := by native_decide
  have hhi : (logIv 40 ⟨3, 3⟩).hi ≤ (A 5).re.hi := by native_decide
  refine ⟨Iv.memR_mono h hlo hhi, ?_⟩
  rw [Complex.ofReal_im]
  norm_num [A, Iv.memR]

theorem log_four_mem_A7 : Cx.mem ((Real.log 4 : ℂ)) (A 7) := by
  have h := logIv_memR (N := 48) (A := ⟨4, 4⟩) (x := 4) (by norm_num) (by norm_num [Iv.memR])
  have hlo : (A 7).re.lo ≤ (logIv 48 ⟨4, 4⟩).lo := by native_decide
  have hhi : (logIv 48 ⟨4, 4⟩).hi ≤ (A 7).re.hi := by native_decide
  refine ⟨Iv.memR_mono h hlo hhi, ?_⟩
  rw [Complex.ofReal_im]
  norm_num [A, Iv.memR]

theorem log_one_mem_A1 : Cx.mem ((0 : ℂ)) (A 1) := by
  norm_num [A, Cx.mem, Iv.memR]

/-- The atom boxes, restricted to the 23 atoms actually used. -/
theorem atom_mem_lt : ∀ i : Nat, i < 23 → Cx.mem (σ i) (A i) := by
  intro i hi
  interval_cases i
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · exact log_one_mem_A1
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · exact log_two_mem_A3
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · exact log_three_mem_A5
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · exact log_four_mem_A7
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]
  · norm_num [σ, A, Cx.mem, Iv.memR]

/-- The totalised atom-box function: the real `A` on the used atoms, default elsewhere. -/
def A' (i : Nat) : Cx :=
  if i < 23 then A i else ⟨⟨0, 0⟩, ⟨0, 0⟩⟩

theorem atom_mem' : ∀ i : Nat, Cx.mem (σ i) (A' i) := by
  intro i
  by_cases hi : i < 23
  · simpa [A', hi] using atom_mem_lt i hi
  · simp [A', hi, σ, Cx.mem, Iv.memR]

/-- The ζ(2) replay, with every atom discharged. -/
theorem cert_mem_closed : Cx.mem (cert.eval σ) cert.box :=
  Expr.wf_sound atom_mem' cert (by native_decide)

end PartialTail.Replay
