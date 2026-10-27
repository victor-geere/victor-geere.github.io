/-
ConeLean/SpectralStructure.lean — deliverable (b1) of goal 3: the finite Wiener–Khinchin identity.

For `Φ : ZMod N → ℂ` the autocorrelation `corr Φ h = Σ_j Φ (j+h) · conj (Φ j)` and the power
spectrum `|𝓕 Φ k|²` are Fourier transforms of one another:

    𝓕 (corr Φ) k = (𝓕 Φ k) * conj (𝓕 Φ k) .

This is the structure route R6 (harmonic analysis of `h ↦ Σ_n λ(n)λ(n+h)`) consumes: it converts
statements about individual shifts into statements about the spectrum and back.
-/
import Mathlib.Analysis.Fourier.ZMod

namespace ConeLean

open scoped BigOperators
open Finset

noncomputable section

variable {N : ℕ} [NeZero N]

/-- Conjugation inverts the standard additive character. -/
lemma star_stdAddChar (y : ZMod N) :
    (starRingEnd ℂ) (ZMod.stdAddChar y) = ZMod.stdAddChar (-y) := by
  rw [ZMod.stdAddChar_apply, ZMod.stdAddChar_apply, AddChar.map_neg_eq_inv, Circle.coe_inv]
  exact (Circle.coe_inv_eq_conj (ZMod.toCircle y)).symm

/-! ## 2. The autocorrelation and Wiener–Khinchin -/

/-- The autocorrelation of `Φ` at shift `h`. -/
noncomputable def autocorr (Φ : ZMod N → ℂ) (h : ZMod N) : ℂ :=
  ∑ j : ZMod N, Φ (j + h) * (starRingEnd ℂ) (Φ j)

/-- The reindexing `(h, j) ↦ (j + h, j)`. -/
def addSwap : ZMod N × ZMod N ≃ ZMod N × ZMod N where
  toFun p := (p.2 + p.1, p.2)
  invFun p := (p.1 - p.2, p.2)
  left_inv := by
    rintro ⟨h, j⟩
    simp
  right_inv := by
    rintro ⟨i, j⟩
    simp

/-- **Wiener–Khinchin, finite form**: the Fourier transform of the autocorrelation is the power
spectrum, `𝓕 (autocorr Φ) k = (𝓕 Φ k) · conj (𝓕 Φ k)`. -/
theorem dft_autocorr (Φ : ZMod N → ℂ) (k : ZMod N) :
    ZMod.dft (autocorr Φ) k = (ZMod.dft Φ k) * (starRingEnd ℂ) (ZMod.dft Φ k) := by
  -- both sides equal the same canonical double sum
  have hL : ZMod.dft (autocorr Φ) k
      = ∑ j : ZMod N, ∑ i : ZMod N,
          ZMod.stdAddChar (-((i - j) * k)) * (Φ i * (starRingEnd ℂ) (Φ j)) := by
    rw [ZMod.dft_apply]
    simp only [autocorr, smul_eq_mul, Finset.mul_sum]
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl (fun j _ => ?_)
    rw [← Equiv.sum_comp (Equiv.addLeft j)
      (fun i => ZMod.stdAddChar (-((i - j) * k)) * (Φ i * (starRingEnd ℂ) (Φ j)))]
    refine Finset.sum_congr rfl (fun x _ => ?_)
    rw [show (Equiv.addLeft j) x = j + x from rfl, add_sub_cancel_left]
  have hR : (ZMod.dft Φ k) * (starRingEnd ℂ) (ZMod.dft Φ k)
      = ∑ j : ZMod N, ∑ i : ZMod N,
          ZMod.stdAddChar (-((i - j) * k)) * (Φ i * (starRingEnd ℂ) (Φ j)) := by
    rw [ZMod.dft_apply, map_sum]
    simp only [map_mul, star_stdAddChar, neg_neg, smul_eq_mul]
    rw [Finset.sum_mul_sum, Finset.sum_comm]
    refine Finset.sum_congr rfl (fun j _ => Finset.sum_congr rfl (fun i _ => ?_))
    have h1 : ZMod.stdAddChar (-(i * k)) * Φ i
          * (ZMod.stdAddChar (j * k) * (starRingEnd ℂ) (Φ j))
        = (ZMod.stdAddChar (-(i * k)) * ZMod.stdAddChar (j * k))
          * (Φ i * (starRingEnd ℂ) (Φ j)) := by ring
    rw [h1, ← AddChar.map_add_eq_mul]
    congr 1
    ring
  rw [hL, hR]

/-! ## 3. Vanishing correlations versus a flat spectrum -/

/-- **Vanishing correlations give a flat spectrum**: if every nonzero shift has zero
autocorrelation then the power spectrum is constant. -/
theorem dft_mul_star_dft_eq_of_corr_eq_zero (Φ : ZMod N → ℂ)
    (h : ∀ j : ZMod N, j ≠ 0 → autocorr Φ j = 0) (k : ZMod N) :
    (ZMod.dft Φ k) * (starRingEnd ℂ) (ZMod.dft Φ k) = autocorr Φ 0 := by
  rw [← dft_autocorr Φ k, ZMod.dft_apply, Finset.sum_eq_single 0]
  · simp
  · intro j _ hj
    rw [h j hj, smul_zero]
  · intro h0
    exact absurd (Finset.mem_univ 0) h0

/-- **A flat spectrum kills every nonzero correlation** — the converse, via Fourier inversion
and the orthogonality of the additive character. -/
theorem corr_eq_zero_of_dft_mul_star_dft_eq (Φ : ZMod N → ℂ) {c : ℂ}
    (h : ∀ k : ZMod N, (ZMod.dft Φ k) * (starRingEnd ℂ) (ZMod.dft Φ k) = c) :
    ∀ j : ZMod N, j ≠ 0 → autocorr Φ j = 0 := by
  have hspec : ZMod.dft (autocorr Φ) = fun _ : ZMod N => c := by
    funext k
    rw [dft_autocorr Φ k, h k]
  have h1 : autocorr Φ = ZMod.dft.symm (fun _ : ZMod N => c) := by
    rw [← LinearEquiv.symm_apply_apply ZMod.dft (autocorr Φ), hspec]
  intro j hj
  rw [h1, ZMod.invDFT_apply]
  have h2 : ∑ x : ZMod N, ZMod.stdAddChar (x * j) • (c : ℂ) = 0 := by
    simp only [smul_eq_mul]
    rw [← Finset.sum_mul, AddChar.sum_mulShift j (ZMod.isPrimitive_stdAddChar N)]
    simp [hj]
  rw [h2, smul_zero]

end

end ConeLean
