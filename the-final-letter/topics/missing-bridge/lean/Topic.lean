import GaussianZeroSide
import Archimedean
import GaussianGram
import DensityCertificates
import DensityCertificates5
import Assembly
import ZeroTail
import Transfer

/-!
# The missing bridge — formal core

This topic isolates the three statements that a positivity proof for the Weil
form would have to supply, after the review of
[`weil-positivity`](../weil-positivity/README.md):

1. an identity writing the **prime side** as a manifest sum of squares, i.e. an
   extension of the rank-one factorization off the critical line;
2. a **positivity-preserving deformation/continuation** of the Weil form;
3. a genuinely **weaker, satisfiable** statement that implies positivity and
   is independently provable.

None of the three is proved here, and this file makes no claim to prove them.
What it does is pin down the elementary facts any attempt has to start from:

* the on-line rank-one factorization is exactly a sum of squares
  (`onLineQuad_eq_sum_sq`) and is therefore nonnegative (`onLineQuad_nonneg`);
* the same block is **not** PSD for an off-line quadruple at some separation
  (`offLineBlock_not_psd`), so the sum-of-squares form cannot be extended
  off the line without additional arithmetic input
  (`not_all_offLine_blocks_psd`);
* the off-line contribution is unbounded (`offLine_growth`);
* the PSD cone is convex and closed under one-parameter deformations
  (`posSemidef_convexCombination`, `posSemidef_add_smul`), which is the
  elementary half of any continuation argument;
* strict positivity is stable under an entrywise margin
  (`strict_margin_transfer`), and the finite 4×4 Gaussian certificate
  (`centre_certificate_satisfiable`) is an instance: this is the template for
  objective 3, and the reason it does not scale to the infinite form.

The three objectives themselves are recorded as open rows in the dossier.
-/

noncomputable section
open Complex Matrix
open scoped BigOperators

namespace MissingBridge
open AbsoluteHodgeExplicitFormula AbsoluteHodgeSymbol AbsoluteHodgeRectangle
open PrimeSpectrumTensor

/-! ## 1.  The on-line prototype: a manifest sum of squares -/

/-- The on-line Gaussian quadratic form at one critical-line frequency, for a
finite family of centres `a` and real coefficients `c`. -/
def onLineQuad {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ γ : ℝ)
    (c : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, c i * c j *
    (2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) *
      Real.cos ((a i - a j) * γ))

/-- **The on-line form is a manifest sum of squares.**  It equals the squared
cosine mode plus the squared sine mode; the rank-one factorization
`H_{a−b}(1/2+iγ) = φ_a(γ) conj φ_b(γ)` is exactly this identity. -/
theorem onLineQuad_eq_sum_sq {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ γ : ℝ) (c : ι → ℝ) :
    onLineQuad a σ γ c =
      (∑ i, c i * gaussianCosMode (a i) σ γ) ^ 2 +
        (∑ i, c i * gaussianSinMode (a i) σ γ) ^ 2 := by
  unfold onLineQuad
  have hterm : ∀ i j : ι,
      c i * c j * (2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2)) *
        Real.cos ((a i - a j) * γ)) =
      (c i * gaussianCosMode (a i) σ γ) *
          (c j * gaussianCosMode (a j) σ γ) +
        (c i * gaussianSinMode (a i) σ γ) *
          (c j * gaussianSinMode (a j) σ γ) := by
    intro i j
    rw [zeroSideGramReal_term (a i) (a j) σ γ]
    ring
  simp_rw [hterm]
  calc ∑ i, ∑ j, ((c i * gaussianCosMode (a i) σ γ) *
            (c j * gaussianCosMode (a j) σ γ) +
          (c i * gaussianSinMode (a i) σ γ) *
            (c j * gaussianSinMode (a j) σ γ))
      = ∑ i, ((∑ j, (c i * gaussianCosMode (a i) σ γ) *
              (c j * gaussianCosMode (a j) σ γ)) +
            (∑ j, (c i * gaussianSinMode (a i) σ γ) *
              (c j * gaussianSinMode (a j) σ γ))) := by
        apply Finset.sum_congr rfl
        intro i _
        rw [Finset.sum_add_distrib]
    _ = (∑ i, ∑ j, (c i * gaussianCosMode (a i) σ γ) *
              (c j * gaussianCosMode (a j) σ γ)) +
          (∑ i, ∑ j, (c i * gaussianSinMode (a i) σ γ) *
              (c j * gaussianSinMode (a j) σ γ)) := by
        rw [Finset.sum_add_distrib]
    _ = ((∑ i, c i * gaussianCosMode (a i) σ γ) *
            (∑ j, c j * gaussianCosMode (a j) σ γ)) +
          ((∑ i, c i * gaussianSinMode (a i) σ γ) *
            (∑ j, c j * gaussianSinMode (a j) σ γ)) := by
        rw [← Finset.sum_mul_sum, ← Finset.sum_mul_sum]
    _ = (∑ i, c i * gaussianCosMode (a i) σ γ) ^ 2 +
          (∑ i, c i * gaussianSinMode (a i) σ γ) ^ 2 := by
        ring

/-- The on-line form is nonnegative, as a sum of squares. -/
theorem onLineQuad_nonneg {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ γ : ℝ) (c : ι → ℝ) :
    0 ≤ onLineQuad a σ γ c := by
  rw [onLineQuad_eq_sum_sq]
  positivity

/-! ## 2.  The obstruction: the sum of squares does not extend off the line -/

/-- **An off-line quadruple breaks the isolated block at some separation.**
This is the harvested `offLineQuad_obstruction_all`, restated in the form the
bridge question needs: the on-line sum of squares has no off-line analogue with
a nonnegative off-diagonal. -/
theorem offLineBlock_not_psd (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ,
      ¬ (!![(offLineQuad 0 σ δ γ).re, (offLineQuad c σ δ γ).re;
          (offLineQuad c σ δ γ).re, (offLineQuad 0 σ δ γ).re]).PosSemidef :=
  offLineQuad_obstruction_all σ δ γ hσ hδ

/-- **No uniform block positivity off the line.**  For every off-line
quadruple there is a separation at which the block fails; equivalently, the
hypothesis "the block is PSD for every separation" forces the zero onto the
critical line. -/
theorem not_all_offLine_blocks_psd (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ¬ ∀ c : ℝ,
      (!![(offLineQuad 0 σ δ γ).re, (offLineQuad c σ δ γ).re;
          (offLineQuad c σ δ γ).re, (offLineQuad 0 σ δ γ).re]).PosSemidef := by
  intro h
  obtain ⟨c, hc⟩ := offLineBlock_not_psd σ δ γ hσ hδ
  exact hc (h c)

/-- **The off-line contribution is unbounded.**  For every bound `K` there is a
separation whose contribution exceeds it; this is the growth that any
manifest-sum-of-squares extension would have to absorb. -/
theorem offLine_growth (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) (K : ℝ) :
    ∃ c : ℝ, K < |(offLineQuad c σ δ γ).re| := by
  obtain ⟨c, hc⟩ := exists_offLineQuad_gt_all σ δ γ hσ hδ K
  exact ⟨c, lt_of_lt_of_le hc (le_abs_self _)⟩

/-! ## 3.  Deformation: the elementary convexity of the PSD cone -/

/-- **The PSD cone is convex.**  A straight-line homotopy between two PSD
matrices stays PSD; this is the elementary half of a positivity-preserving
continuation. -/
theorem posSemidef_convexCombination {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℝ} (hA : A.PosSemidef) (hB : B.PosSemidef)
    {t : ℝ} (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    (t • A + (1 - t) • B).PosSemidef :=
  (hA.smul ht0).add (hB.smul (by linarith))

/-- A nonnegative one-parameter deformation of a PSD matrix is PSD. -/
theorem posSemidef_add_smul {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℝ} (hA : A.PosSemidef) (hB : B.PosSemidef)
    {t : ℝ} (ht : 0 ≤ t) :
    (A + t • B).PosSemidef :=
  hA.add (hB.smul ht)

/-! ## 4.  The weaker statement: strict positivity with an entrywise margin -/

/-- **Entrywise margin transfer** (harvested `posDef_of_entry_bound`).  If
`C − t·I` is positive definite and `G` is symmetric with every entry within
`ε` of `C`, then `ε · n < t` forces `G` to be positive definite.  This is the
precise form of a satisfiable, margin-carrying positivity statement. -/
theorem strict_margin_transfer {n : Type*} [Fintype n] [DecidableEq n]
    {C G : Matrix n n ℝ} {t ε : ℝ}
    (hGsym : ∀ i j, G i j = G j i)
    (hC : (C - t • (1 : Matrix n n ℝ)).PosDef)
    (hε0 : 0 ≤ ε)
    (hε : ∀ i j, |G i j - C i j| ≤ ε)
    (hdim : ε * (Fintype.card n : ℝ) < t) :
    G.PosDef :=
  posDef_of_entry_bound hGsym hC hε0 hε hdim

/-- The rational centre minus its margin is positive definite (harvested). -/
theorem centre_sub_margin_posDef :
    (gramCentre4 - gramMargin • (1 : Matrix (Fin 4) (Fin 4) ℝ)).PosDef :=
  gramCentre4_sub_posDef

/-- **The finite certificate is satisfiable.**  The rational 4×4 Gaussian Gram
centre is positive definite, so the margin statement is not vacuous.  This is
the template for objective 3; it is a finite statement and does not imply
positivity of the infinite Weil form. -/
theorem centre_certificate_satisfiable : gramCentre4.PosDef :=
  gaussianGram4_posDef_of_entry_bound gramCentre4_symm
    (fun i j => by simp) le_rfl (by norm_num [gramMargin])


/-! ## 5.  O2 first round: what a no-crossing theorem can and cannot do -/

/-- **A positivity-preserving map need not be eigenvalue-monotone.**  The
congruence `A ↦ S A Sᵀ` preserves positive semidefiniteness for every real
`S`, but it can lower the least eigenvalue (computation C8).  This is the gap
between "positivity-preserving" and "λ_min nondecreasing": a maximum principle
that only knows positivity is preserved does not give a no-crossing theorem. -/
theorem posSemidef_sandwich {m n : Type*} [Fintype m] [Fintype n]
    [DecidableEq m] [DecidableEq n]
    {A : Matrix n n ℝ} (hA : A.PosSemidef) (S : Matrix m n ℝ) :
    (S * A * Sᵀ).PosSemidef := by
  simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using
    hA.mul_mul_conjTranspose_same S

/-- **The linear deformation has no slack.**  For real matrices, `A + t·B` is
positive semidefinite for every `t ≥ 0` if and only if both `A` and `B` are
positive semidefinite.  A linear "no-crossing" argument is therefore exactly
as hard as positivity at the endpoint: if `B` is indefinite, the path must
cross zero. -/
theorem linear_path_posSemidef_iff {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℝ} :
    (∀ t : ℝ, 0 ≤ t → (A + t • B).PosSemidef) ↔
      A.PosSemidef ∧ B.PosSemidef := by
  constructor
  · intro h
    have hA : A.PosSemidef := by simpa using h 0 le_rfl
    have h1 : (A + (1 : ℝ) • B).PosSemidef := h 1 zero_le_one
    have h2 : (A + (2 : ℝ) • B).PosSemidef := h 2 (by norm_num)
    have hBherm : B.IsHermitian := by
      have hsub : B = (A + (2 : ℝ) • B) - (A + (1 : ℝ) • B) := by
        ext i j
        simp
        ring
      rw [hsub]
      exact h2.isHermitian.sub h1.isHermitian
    refine ⟨hA, Matrix.PosSemidef.of_dotProduct_mulVec_nonneg hBherm ?_⟩
    intro x
    have hxs : star x = x := by
      funext i
      simp
    rw [hxs]
    by_contra hx
    push Not at hx
    set c : ℝ := x ⬝ᵥ (B *ᵥ x) with hc_def
    set d : ℝ := x ⬝ᵥ (A *ᵥ x) with hd_def
    have hc : c < 0 := hx
    have hcne : c ≠ 0 := ne_of_lt hc
    have hd : 0 ≤ d := hA.dotProduct_mulVec_nonneg x
    let t : ℝ := (d + 1) / (-c)
    have ht : 0 ≤ t := by
      apply div_nonneg
      · linarith
      · linarith
    have hkey : d + t * c = -1 := by
      dsimp [t]
      field_simp [hcne]
      ring
    have hsplit : x ⬝ᵥ ((A + t • B) *ᵥ x) = d + t * c := by
      simp [d, c, Matrix.add_mulVec, Matrix.smul_mulVec, smul_eq_mul]
    have hnonneg := (h t ht).dotProduct_mulVec_nonneg x
    rw [hxs] at hnonneg
    rw [hsplit, hkey] at hnonneg
    norm_num at hnonneg
  · rintro ⟨hA, hB⟩ t ht
    exact hA.add (hB.smul ht)


/-! ## 6.  O2 second round: the Gaussian-width flow is not monotone -/

/-- The on-line Gaussian weight `2πσ² exp(−σ²γ²)`. -/
def gaussianWeight (σ γ : ℝ) : ℝ :=
  2 * Real.pi * σ ^ 2 * Real.exp (-(σ ^ 2 * γ ^ 2))

/-- **The σ-derivative of the on-line weight.** -/
theorem hasDerivAt_gaussianWeight (γ σ : ℝ) :
    HasDerivAt (fun s : ℝ => gaussianWeight s γ)
      (4 * Real.pi * σ * Real.exp (-(σ ^ 2 * γ ^ 2)) * (1 - σ ^ 2 * γ ^ 2)) σ := by
  unfold gaussianWeight
  have h1 : HasDerivAt (fun s : ℝ => s ^ 2) (2 * σ) σ := by
    simpa using hasDerivAt_pow (𝕜 := ℝ) 2 σ
  have h2 : HasDerivAt (fun s : ℝ => s ^ 2 * (-(γ ^ 2))) (2 * σ * (-(γ ^ 2))) σ :=
    h1.mul_const (-(γ ^ 2))
  have h3 : HasDerivAt (fun s : ℝ => Real.exp (s ^ 2 * (-(γ ^ 2))))
      (Real.exp (σ ^ 2 * (-(γ ^ 2))) * (2 * σ * (-(γ ^ 2)))) σ :=
    h2.exp
  have h4 : HasDerivAt (fun s : ℝ => 2 * Real.pi * s ^ 2) (2 * Real.pi * (2 * σ)) σ := by
    simpa [mul_assoc] using h1.const_mul (2 * Real.pi)
  have h5 := h4.mul h3
  convert h5 using 1
  · ext s
    simp only [Pi.mul_apply]
    ring_nf
  · ring_nf

/-- The derivative is positive at `σ = 1/(2γ)`. -/
theorem gaussianWeight_deriv_pos (γ : ℝ) (hγ : 0 < γ) :
    0 < 4 * Real.pi * (1 / (2 * γ)) *
      Real.exp (-(((1 / (2 * γ)) ^ 2) * γ ^ 2)) *
      (1 - ((1 / (2 * γ)) ^ 2) * γ ^ 2) := by
  have h : ((1 / (2 * γ)) ^ 2) * γ ^ 2 = 1 / 4 := by
    field_simp
    ring
  rw [h]
  positivity

/-- The derivative is negative at `σ = 2/γ`. -/
theorem gaussianWeight_deriv_neg (γ : ℝ) (hγ : 0 < γ) :
    4 * Real.pi * (2 / γ) * Real.exp (-(((2 / γ) ^ 2) * γ ^ 2)) *
      (1 - ((2 / γ) ^ 2) * γ ^ 2) < 0 := by
  have h : ((2 / γ) ^ 2) * γ ^ 2 = 4 := by
    field_simp
    ring
  rw [h]
  have hpos : 0 < 4 * Real.pi * (2 / γ) * Real.exp (-4 * 1) := by positivity
  nlinarith [hpos]

/-- **The on-line Gaussian width flow is not monotone.**  For every `γ > 0`
the weight is neither monotone nor antitone in `σ`; hence no σ-flow can be a
monotonicity argument on the on-line part. -/
theorem gaussianWeight_not_monotone (γ : ℝ) (hγ : 0 < γ) :
    ¬ Monotone (fun σ => gaussianWeight σ γ) ∧
      ¬ Antitone (fun σ => gaussianWeight σ γ) := by
  constructor
  · intro hm
    have hd : deriv (fun σ => gaussianWeight σ γ) (2 / γ) =
        4 * Real.pi * (2 / γ) * Real.exp (-(((2 / γ) ^ 2) * γ ^ 2)) *
          (1 - ((2 / γ) ^ 2) * γ ^ 2) :=
      (hasDerivAt_gaussianWeight γ (2 / γ)).deriv
    have hnonneg := hm.deriv_nonneg (x := (2 / γ))
    rw [hd] at hnonneg
    linarith [gaussianWeight_deriv_neg γ hγ]
  · intro ha
    have hd : deriv (fun σ => gaussianWeight σ γ) (1 / (2 * γ)) =
        4 * Real.pi * (1 / (2 * γ)) * Real.exp (-(((1 / (2 * γ)) ^ 2) * γ ^ 2)) *
          (1 - ((1 / (2 * γ)) ^ 2) * γ ^ 2) :=
      (hasDerivAt_gaussianWeight γ (1 / (2 * γ))).deriv
    have hnonpos := ha.deriv_nonpos (x := (1 / (2 * γ)))
    rw [hd] at hnonpos
    linarith [gaussianWeight_deriv_pos γ hγ]


/-! ## 7.  The maximal-|δ| precondition of the full-block route -/

/-- **A single off-line quadruple defeats every uniform bound.**  If the
"other" block contains an off-line quadruple, its entries are unbounded in the
separation `c`, so no fixed `B` bounds the other-block contribution for all
`c`.  The full-block domination argument therefore requires that the chosen
quadruple has strictly larger `|δ|` than every other zero; no such strict
maximiser is known. -/
theorem no_uniform_bound_of_offLine_quadruple
    (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ¬ ∃ B : ℝ, ∀ c : ℝ, |(offLineQuad c σ δ γ).re| ≤ B := by
  rintro ⟨B, hB⟩
  obtain ⟨c, hc⟩ := offLine_growth σ δ γ hσ hδ (B + 1)
  have hle := hB c
  linarith


/-! ## 8.  Full Weil positivity: the finite-zero-set easy direction -/

/-- The real rank-one matrix `u uᵀ`. -/
def realRankOne {ι : Type*} (u : ι → ℝ) : Matrix ι ι ℝ := fun i j => u i * u j

/-- A real rank-one matrix `u uᵀ` is positive semidefinite. -/
theorem realRankOne_posSemidef {ι : Type*} [Fintype ι] (u : ι → ℝ) :
    (realRankOne u).PosSemidef := by
  refine Matrix.PosSemidef.of_dotProduct_mulVec_nonneg ?_ ?_
  · ext i j
    simp [realRankOne, mul_comm]
  · intro x
    have hxs : star x = x := by
      funext i
      simp
    rw [hxs]
    have h : x ⬝ᵥ ((realRankOne u) *ᵥ x) = (∑ i, x i * u i) ^ 2 := by
      simp [realRankOne, dotProduct, mulVec, Finset.mul_sum, Finset.sum_mul, sq]
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro j _
      ring
    rw [h]
    exact sq_nonneg _

/-- The real part of the finite zero-side Gram matrix over a finite set of zeros. -/
def finiteWeilGramReal {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (S : Finset ℂ) : Matrix ι ι ℝ :=
  fun i j => ∑ ρ ∈ S, (gaussianZeroTest (a i - a j) σ ρ).re

/-- **The easy direction of the full Weil criterion, finite form.**  If every
zero in `S` lies on the critical line, the real part of the finite zero-side
Gram matrix is positive semidefinite. -/
theorem finiteWeilGramReal_posSemidef_of_onLine {ι : Type*} [Fintype ι]
    [DecidableEq ι] (a : ι → ℝ) (σ : ℝ) (S : Finset ℂ)
    (hS : ∀ ρ ∈ S, ρ.re = 1 / 2) :
    (finiteWeilGramReal a σ S).PosSemidef := by
  classical
  let z : ℂ → ι → ℝ := fun ρ i => (gaussianMode (a i) σ ρ.im).re
  let w : ℂ → ι → ℝ := fun ρ i => (gaussianMode (a i) σ ρ.im).im
  have hdecomp : finiteWeilGramReal a σ S =
      ∑ ρ ∈ S, (realRankOne (z ρ) + realRankOne (w ρ)) := by
    ext i j
    simp only [finiteWeilGramReal, Matrix.sum_apply]
    apply Finset.sum_congr rfl
    intro ρ hρ
    rw [eq_half_add_im_mul_I_of_re_eq_half (hS ρ hρ), gaussianZeroTest_eq_mode_mul]
    simp [z, w, realRankOne, Matrix.add_apply, Complex.mul_re, Complex.conj_re,
      Complex.conj_im]
  rw [hdecomp]
  apply Matrix.posSemidef_sum
  intro ρ _
  exact (realRankOne_posSemidef (z ρ)).add (realRankOne_posSemidef (w ρ))

/-- Finite Weil positivity: the real part of the zero-side Gram matrix is PSD
for every finite set of nontrivial zeros and every finite Gaussian family. -/
def FiniteWeilPositivity : Prop :=
  ∀ (ι : Type) [Fintype ι] [DecidableEq ι] (a : ι → ℝ) (σ : ℝ) (S : Finset ℂ),
    (∀ ρ ∈ S, completedZeta ρ = 0) →
    (∀ ρ ∈ S, 0 < ρ.re) →
    (∀ ρ ∈ S, ρ.re < 1) →
    (finiteWeilGramReal a σ S).PosSemidef

/-- **RH implies finite Weil positivity** — the easy direction of the classical
Weil criterion, for finite zero sets. -/
theorem rh_implies_finiteWeilPositivity
    (h : AbsoluteHodgeSymbol.RiemannHypothesis) : FiniteWeilPositivity := by
  intro ι _ _ a σ S hZ h0 h1
  exact finiteWeilGramReal_posSemidef_of_onLine a σ S
    (fun ρ hρ => h ρ (hZ ρ hρ) (h0 ρ hρ) (h1 ρ hρ))

/-! ## 6.  The arithmetic side: exact pole cancellation -/

/-- The smooth-weight PNT main term of the Gaussian-window prime sum. -/
def primeMainTerm (c σ : ℝ) : ℝ :=
  2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.exp (c / 2)

/-- The pole contribution `H_c(0) + H_c(1)`. -/
def poleTerm (c σ : ℝ) : ℝ :=
  4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.cosh (c / 2)

/-- The pole term is exactly the sum of the two prime main terms. -/
theorem poleTerm_eq_primeMainTerm_add (c σ : ℝ) :
    poleTerm c σ = primeMainTerm c σ + primeMainTerm (-c) σ := by
  rw [poleTerm, primeMainTerm, Real.cosh_eq]
  simp only [primeMainTerm]
  ring

/-- The prime main term is the real part of `H_c(0)`. -/
theorem primeMainTerm_eq_re_gaussianZeroTest_zero (c σ : ℝ) :
    primeMainTerm c σ = (gaussianZeroTest c σ 0).re := by
  have hcast : gaussianZeroTest c σ 0 = ↑(primeMainTerm c σ) := by
    rw [gaussianZeroTest_zero, primeMainTerm]
    rw [show (↑(σ ^ 2) / 4 : ℂ) = ↑(σ ^ 2 / 4 : ℝ) by push_cast; ring,
        show (↑c / 2 : ℂ) = ↑(c / 2 : ℝ) by push_cast; ring]
    rw [← Complex.ofReal_exp, ← Complex.ofReal_exp]
    norm_num
  rw [hcast, Complex.ofReal_re]

/-- The reflected prime main term is the real part of `H_c(1)`. -/
theorem primeMainTerm_neg_eq_re_gaussianZeroTest_one (c σ : ℝ) :
    primeMainTerm (-c) σ = (gaussianZeroTest c σ 1).re := by
  have hcast : gaussianZeroTest c σ 1 = ↑(primeMainTerm (-c) σ) := by
    rw [gaussianZeroTest_one, primeMainTerm]
    rw [show (↑(σ ^ 2) / 4 : ℂ) = ↑(σ ^ 2 / 4 : ℝ) by push_cast; ring,
        show (-(↑c) / 2 : ℂ) = ↑(-c / 2 : ℝ) by push_cast; ring]
    rw [← Complex.ofReal_exp, ← Complex.ofReal_exp]
    norm_num
  rw [hcast, Complex.ofReal_re]

/-- The pole term is the real part of `H_c(0) + H_c(1)`. -/
theorem poleTerm_eq_re_gaussianZeroTest_pole_sum (c σ : ℝ) :
    poleTerm c σ = (gaussianZeroTest c σ 0 + gaussianZeroTest c σ 1).re := by
  rw [gaussianZeroTest_pole_sum, Complex.ofReal_re]
  simp [poleTerm]

/-- Exact cancellation: the symmetrised arithmetic Gram entry is the sum of
the two Gaussian-window PNT errors, with the pole term dropping out. -/
theorem poleTerm_sub_primeSums_eq (c σ Pc Pneg : ℝ) :
    poleTerm c σ - (Pc + Pneg)
      = (primeMainTerm c σ - Pc) + (primeMainTerm (-c) σ - Pneg) := by
  rw [poleTerm_eq_primeMainTerm_add]
  ring

/-- The full arithmetic residual `K(c)`, including the archimedean term. -/
def arithmeticResidual (c σ Pc Pneg arch : ℝ) : ℝ :=
  poleTerm c σ - (Pc + Pneg) + arch

/-- **The exact arithmetic decomposition.**  The pole cancels and the
residual is the sum of the two Gaussian-window PNT errors plus the
archimedean term. -/
theorem arithmeticResidual_eq (c σ Pc Pneg arch : ℝ) :
    arithmeticResidual c σ Pc Pneg arch
      = (primeMainTerm c σ - Pc) + (primeMainTerm (-c) σ - Pneg) + arch := by
  unfold arithmeticResidual
  rw [poleTerm_eq_primeMainTerm_add]
  ring

/-- The Gaussian window `h_c(u)` of the arithmetic prime side. -/
def primeWindow (c σ u : ℝ) : ℝ :=
  Real.sqrt Real.pi * σ * Real.exp (-(u - c) ^ 2 / (4 * σ ^ 2))

/-- The truncated prime side of the arithmetic explicit formula. -/
def gaussianPrimeSide (c σ : ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.range N,
    ArithmeticFunction.vonMangoldt (n + 1) * ((n + 1 : ℝ) ^ (-(1 / 2) : ℝ)) *
      primeWindow c σ (Real.log (n + 1))

/-- The Gaussian window is positive for positive width. -/
theorem primeWindow_pos (c σ u : ℝ) (hσ : 0 < σ) : 0 < primeWindow c σ u := by
  unfold primeWindow
  positivity

/-- Each summand of the truncated prime side is nonnegative. -/
theorem gaussianPrimeSide_term_nonneg (c σ : ℝ) (hσ : 0 ≤ σ) (n : ℕ) :
    0 ≤ ArithmeticFunction.vonMangoldt (n + 1) *
      ((n + 1 : ℝ) ^ (-(1 / 2) : ℝ)) * primeWindow c σ (Real.log (n + 1)) := by
  have h1 : 0 ≤ ArithmeticFunction.vonMangoldt (n + 1) :=
    ArithmeticFunction.vonMangoldt_nonneg
  have h2 : 0 ≤ ((n + 1 : ℝ) ^ (-(1 / 2) : ℝ)) :=
    Real.rpow_nonneg (by positivity) _
  have h3 : 0 ≤ primeWindow c σ (Real.log (n + 1)) := by
    unfold primeWindow
    positivity
  exact mul_nonneg (mul_nonneg h1 h2) h3

/-- **The prime side is a manifest sum of nonnegative terms.** -/
theorem gaussianPrimeSide_nonneg (c σ : ℝ) (hσ : 0 ≤ σ) (N : ℕ) :
    0 ≤ gaussianPrimeSide c σ N := by
  unfold gaussianPrimeSide
  exact Finset.sum_nonneg (fun n _ => gaussianPrimeSide_term_nonneg c σ hσ n)

/-- The truncated prime side is monotone in the truncation. -/
theorem gaussianPrimeSide_mono (c σ : ℝ) (hσ : 0 ≤ σ) :
    Monotone (gaussianPrimeSide c σ) := by
  intro N M hNM
  unfold gaussianPrimeSide
  exact Finset.sum_le_sum_of_subset_of_nonneg
    (Finset.range_subset_range.mpr hNM)
    (fun n _ _ => gaussianPrimeSide_term_nonneg c σ hσ n)

/-- The Gaussian window is symmetric under `(c, u) ↦ (−c, −u)`. -/
theorem primeWindow_neg_neg (c σ u : ℝ) :
    primeWindow (-c) σ (-u) = primeWindow c σ u := by
  unfold primeWindow
  congr 1
  ring_nf

/-- The prime main term is positive for positive width. -/
theorem primeMainTerm_pos (c σ : ℝ) (hσ : 0 < σ) : 0 < primeMainTerm c σ := by
  unfold primeMainTerm
  positivity

/-- The pole term is positive for positive width. -/
theorem poleTerm_pos (c σ : ℝ) (hσ : 0 < σ) : 0 < poleTerm c σ := by
  unfold poleTerm
  positivity

/-- The pole term is even in the centre. -/
theorem poleTerm_neg (c σ : ℝ) : poleTerm (-c) σ = poleTerm c σ := by
  unfold poleTerm
  rw [show (-c) / 2 = -(c / 2) by ring, Real.cosh_neg]

/-! ## 7.  The smooth main term as a Gaussian integral -/

open MeasureTheory

theorem exp_quadratic_re (c σ u : ℝ) (hσ : 0 < σ) :
    (Complex.exp ((-(1 / (4 * (σ : ℂ) ^ 2))) * (u : ℂ) ^ 2
        + (1 / 2 + (c : ℂ) / (2 * (σ : ℂ) ^ 2)) * (u : ℂ)
        + (-((c : ℂ) ^ 2 / (4 * (σ : ℂ) ^ 2))))).re
      = Real.exp (u / 2 - (u - c) ^ 2 / (4 * σ ^ 2)) := by
  have h : (-(1 / (4 * (σ : ℂ) ^ 2))) * (u : ℂ) ^ 2
        + (1 / 2 + (c : ℂ) / (2 * (σ : ℂ) ^ 2)) * (u : ℂ)
        + (-((c : ℂ) ^ 2 / (4 * (σ : ℂ) ^ 2)))
      = ((u / 2 - (u - c) ^ 2 / (4 * σ ^ 2) : ℝ) : ℂ) := by
    push_cast
    field_simp [hσ.ne']
    ring
  rw [h, ← Complex.ofReal_exp, Complex.ofReal_re]




theorem integral_exp_half_primeWindow (c σ : ℝ) (hσ : 0 < σ) :
    ∫ u : ℝ, Real.exp (u / 2) * primeWindow c σ u = primeMainTerm c σ := by
  set b : ℂ := -(1 / (4 * (σ : ℂ) ^ 2)) with hbdef
  set cc : ℂ := 1 / 2 + (c : ℂ) / (2 * (σ : ℂ) ^ 2) with hcdef
  set d : ℂ := -((c : ℂ) ^ 2 / (4 * (σ : ℂ) ^ 2)) with hddef
  have hb : b.re < 0 := by
    rw [hbdef]
    have h : (-(1 / (4 * (σ : ℂ) ^ 2))) = ((-(1 / (4 * σ ^ 2)) : ℝ) : ℂ) := by
      push_cast; ring
    rw [h, Complex.ofReal_re]
    have hpos : 0 < 1 / (4 * σ ^ 2) := by positivity
    linarith
  have hpoint : ∀ u : ℝ, (cexp (b * (u : ℂ) ^ 2 + cc * (u : ℂ) + d)).re
      = Real.exp (u / 2 - (u - c) ^ 2 / (4 * σ ^ 2)) := by
    intro u
    simpa [hbdef, hcdef, hddef] using exp_quadratic_re c σ u hσ
  have hreal : ∫ u : ℝ, Real.exp (u / 2 - (u - c) ^ 2 / (4 * σ ^ 2))
      = (∫ u : ℝ, cexp (b * (u : ℂ) ^ 2 + cc * (u : ℂ) + d)).re := by
    rw [show (∫ u : ℝ, Real.exp (u / 2 - (u - c) ^ 2 / (4 * σ ^ 2)))
        = ∫ u : ℝ, (cexp (b * (u : ℂ) ^ 2 + cc * (u : ℂ) + d)).re by
      congr 1; ext u; exact (hpoint u).symm]
    have hint : Integrable (fun u : ℝ => cexp (b * (u : ℂ) ^ 2 + cc * (u : ℂ) + d)) := by
      simpa [neg_neg] using integrable_cexp_quadratic (show 0 < (-b).re by simpa using hb) cc d
    exact integral_re hint
  have hwin : ∀ u, primeWindow c σ u = Real.sqrt Real.pi * σ * Real.exp (-(u - c) ^ 2 / (4 * σ ^ 2)) :=
    fun u => rfl
  simp_rw [hwin]
  rw [show (fun u => Real.exp (u / 2) * (Real.sqrt Real.pi * σ * Real.exp (-(u - c) ^ 2 / (4 * σ ^ 2))))
      = (fun u => (Real.sqrt Real.pi * σ) * (Real.exp (u / 2) * Real.exp (-(u - c) ^ 2 / (4 * σ ^ 2)))) by
    ext u; ring]
  rw [integral_const_mul]
  have hcomb : ∀ u, Real.exp (u / 2) * Real.exp (-(u - c) ^ 2 / (4 * σ ^ 2))
      = Real.exp (u / 2 - (u - c) ^ 2 / (4 * σ ^ 2)) := by
    intro u; rw [← Real.exp_add]; ring_nf
  simp_rw [hcomb]
  rw [hreal, integral_cexp_quadratic hb cc d]
  have hP : (↑Real.pi / -b : ℂ) = ↑(4 * Real.pi * σ ^ 2 : ℝ) := by
    rw [hbdef]; push_cast; field_simp [hσ.ne']
  have hPpos : 0 ≤ (4 * Real.pi * σ ^ 2 : ℝ) := by positivity
  have hsqrt : (↑(4 * Real.pi * σ ^ 2 : ℝ) : ℂ) ^ (1 / 2 : ℂ)
      = ↑(Real.sqrt (4 * Real.pi * σ ^ 2)) := by
    rw [show (1 / 2 : ℂ) = ((1 / 2 : ℝ) : ℂ) by norm_num]
    rw [← Complex.ofReal_cpow hPpos (1 / 2 : ℝ)]
    congr 1
    exact (Real.sqrt_eq_rpow _).symm
  have hexp : d - cc ^ 2 / (4 * b) = ↑(c / 2 + σ ^ 2 / 4 : ℝ) := by
    rw [hddef, hcdef, hbdef]; push_cast; field_simp [hσ.ne']; ring
  rw [hP, hsqrt, hexp, ← Complex.ofReal_exp, ← Complex.ofReal_mul, Complex.ofReal_re]
  have hsqrt4 : Real.sqrt (4 * Real.pi * σ ^ 2) = 2 * σ * Real.sqrt Real.pi := by
    rw [show (4 : ℝ) * Real.pi * σ ^ 2 = (2 * σ) ^ 2 * Real.pi by ring]
    rw [Real.sqrt_mul (by positivity), Real.sqrt_sq (by positivity)]
  rw [hsqrt4]
  unfold primeMainTerm
  have hpi : Real.sqrt Real.pi * Real.sqrt Real.pi = Real.pi := by
    rw [← Real.sqrt_mul Real.pi_pos.le, show Real.pi * Real.pi = Real.pi ^ 2 by ring,
      Real.sqrt_sq Real.pi_pos.le]
  calc Real.sqrt Real.pi * σ * ((2 * σ * Real.sqrt Real.pi) * Real.exp (c / 2 + σ ^ 2 / 4))
      = 2 * (Real.sqrt Real.pi * Real.sqrt Real.pi) * σ ^ 2 * Real.exp (c / 2 + σ ^ 2 / 4) := by ring
    _ = 2 * Real.pi * σ ^ 2 * Real.exp (c / 2 + σ ^ 2 / 4) := by rw [hpi]
    _ = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.exp (c / 2) := by
        rw [Real.exp_add]; ring

/-- The pole term is the sum of the two Gaussian main-term integrals. -/
theorem poleTerm_eq_integral_add (c σ : ℝ) (hσ : 0 < σ) :
    poleTerm c σ = (∫ u : ℝ, Real.exp (u / 2) * primeWindow c σ u)
      + (∫ u : ℝ, Real.exp (u / 2) * primeWindow (-c) σ u) := by
  rw [integral_exp_half_primeWindow c σ hσ, integral_exp_half_primeWindow (-c) σ hσ]
  exact poleTerm_eq_primeMainTerm_add c σ

/-- The arithmetic residual kernel over centres, with a general prime-side
function `P` and archimedean term `arch`. -/
def arithmeticResidualKernel (σ : ℝ) (P arch : ℝ → ℝ) (c : ℝ) : ℝ :=
  (primeMainTerm c σ - P c) + (primeMainTerm (-c) σ - P (-c)) + arch c

/-- The arithmetic residual kernel is even when the archimedean term is even,
so the associated Gram matrix is symmetric. -/
theorem arithmeticResidualKernel_neg (σ : ℝ) (P arch : ℝ → ℝ)
    (harch : ∀ c, arch (-c) = arch c) (c : ℝ) :
    arithmeticResidualKernel σ P arch (-c) = arithmeticResidualKernel σ P arch c := by
  unfold arithmeticResidualKernel
  rw [harch]
  simp only [neg_neg]
  ring

/-- The arithmetic Gram matrix over a finite family of centres. -/
def arithmeticGramMatrix {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (P arch : ℝ → ℝ) : Matrix ι ι ℝ :=
  fun i j => arithmeticResidualKernel σ P arch (a i - a j)

/-- The arithmetic Gram matrix is symmetric when the prime-side matrix is
symmetric and the archimedean term is even. -/
theorem arithmeticGramMatrix_isSymm {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (P arch : ℝ → ℝ) (harch : ∀ c, arch (-c) = arch c) :
    (arithmeticGramMatrix a σ P arch).IsSymm := by
  apply Matrix.IsSymm.ext
  intro i j
  unfold arithmeticGramMatrix
  rw [show a j - a i = -(a i - a j) by ring]
  rw [arithmeticResidualKernel_neg σ P arch harch (a i - a j)]

/-- **Total mass of the Gaussian prime window.**  The window `h_c(u)` has
integral `2πσ²`, independent of the centre `c`. -/
theorem integral_primeWindow (c σ : ℝ) (hσ : 0 < σ) :
    ∫ u : ℝ, primeWindow c σ u = 2 * Real.pi * σ ^ 2 := by
  unfold primeWindow
  have hb : 0 < 1 / (4 * σ ^ 2) := by positivity
  have hfun : (fun u : ℝ => Real.sqrt Real.pi * σ * Real.exp (-(u - c) ^ 2 / (4 * σ ^ 2)))
      = fun u : ℝ => Real.sqrt Real.pi * σ * Real.exp (-(1 / (4 * σ ^ 2)) * (u - c) ^ 2) := by
    ext u
    congr 2
    field_simp
  rw [hfun]
  rw [integral_const_mul]
  rw [integral_sub_right_eq_self (fun v : ℝ => Real.exp (-(1 / (4 * σ ^ 2)) * v ^ 2)) c]
  rw [integral_gaussian]
  have h1 : Real.sqrt (Real.pi / (1 / (4 * σ ^ 2))) = 2 * σ * Real.sqrt Real.pi := by
    rw [show Real.pi / (1 / (4 * σ ^ 2)) = 4 * σ ^ 2 * Real.pi by field_simp]
    rw [Real.sqrt_mul (by positivity)]
    rw [show (4 * σ ^ 2) = (2 * σ) ^ 2 by ring, Real.sqrt_sq (by positivity)]
  rw [h1]
  nlinarith [Real.sq_sqrt Real.pi_pos.le]

/-- **Crude prime-side bound.**  The Gaussian prime side is at most `√π σ` times
the total von Mangoldt mass of the truncation. -/
theorem gaussianPrimeSide_le_mul_sum_vonMangoldt (c σ : ℝ) (hσ : 0 ≤ σ) (N : ℕ) :
    gaussianPrimeSide c σ N
      ≤ Real.sqrt Real.pi * σ * ∑ n ∈ Finset.range N,
          ArithmeticFunction.vonMangoldt (n + 1) := by
  unfold gaussianPrimeSide
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro n _
  have hΛ : 0 ≤ ArithmeticFunction.vonMangoldt (n + 1) :=
    ArithmeticFunction.vonMangoldt_nonneg
  have hbase : (1 : ℝ) ≤ (n + 1 : ℝ) := by
    exact_mod_cast Nat.one_le_iff_ne_zero.mpr (by omega)
  have hrpow : ((n + 1 : ℝ) ^ (-(1 / 2) : ℝ)) ≤ 1 :=
    Real.rpow_le_one_of_one_le_of_nonpos hbase (by norm_num)
  have hroot : 0 ≤ Real.sqrt Real.pi * σ :=
    mul_nonneg (Real.sqrt_nonneg _) hσ
  have hexp : Real.exp (-(Real.log (n + 1) - c) ^ 2 / (4 * σ ^ 2)) ≤ 1 := by
    apply Real.exp_le_one_iff.mpr
    have hsq : 0 ≤ (Real.log (n + 1) - c) ^ 2 / (4 * σ ^ 2) := by positivity
    rw [neg_div]
    exact neg_nonpos.mpr hsq
  have hwindow : primeWindow c σ (Real.log (n + 1)) ≤ Real.sqrt Real.pi * σ := by
    unfold primeWindow
    calc Real.sqrt Real.pi * σ * Real.exp (-(Real.log (n + 1) - c) ^ 2 / (4 * σ ^ 2))
        ≤ Real.sqrt Real.pi * σ * 1 := by
          exact mul_le_mul_of_nonneg_left hexp hroot
      _ = Real.sqrt Real.pi * σ := by ring
  calc ArithmeticFunction.vonMangoldt (n + 1) * ((n + 1 : ℝ) ^ (-(1 / 2) : ℝ))
        * primeWindow c σ (Real.log (n + 1))
      ≤ ArithmeticFunction.vonMangoldt (n + 1) * 1 * (Real.sqrt Real.pi * σ) := by
        apply mul_le_mul
        · exact mul_le_mul_of_nonneg_left hrpow hΛ
        · exact hwindow
        · unfold primeWindow
          positivity
        · positivity
    _ = Real.sqrt Real.pi * σ * ArithmeticFunction.vonMangoldt (n + 1) := by ring

/-- **Prime-side `log N!` bound.**  The Gaussian prime side is at most
`√π σ · log(N!)`. -/
theorem gaussianPrimeSide_le_mul_log_factorial (c σ : ℝ) (hσ : 0 ≤ σ) (N : ℕ) :
    gaussianPrimeSide c σ N ≤ Real.sqrt Real.pi * σ * Real.log (N.factorial) := by
  calc gaussianPrimeSide c σ N
      ≤ Real.sqrt Real.pi * σ * ∑ n ∈ Finset.range N,
          ArithmeticFunction.vonMangoldt (n + 1) :=
        gaussianPrimeSide_le_mul_sum_vonMangoldt c σ hσ N
    _ ≤ Real.sqrt Real.pi * σ * ∑ n ∈ Finset.range N, Real.log (n + 1) := by
        gcongr
        simpa using (ArithmeticFunction.vonMangoldt_le_log (n := n + 1))
    _ = Real.sqrt Real.pi * σ * Real.log (N.factorial) := by
        rw [Real.sum_log_add_one_eq_log_factorial]

/-- **Arithmetic-residual error interface.**  If the two PNT errors are bounded
by `E₁`, `E₂` and the archimedean term by `A`, the residual is bounded by
`E₁ + E₂ + A`. -/
theorem arithmeticResidual_abs_le (c σ Pc Pneg arch E1 E2 A : ℝ)
    (hP : |primeMainTerm c σ - Pc| ≤ E1)
    (hPneg : |primeMainTerm (-c) σ - Pneg| ≤ E2)
    (harch : |arch| ≤ A) :
    |arithmeticResidual c σ Pc Pneg arch| ≤ E1 + E2 + A := by
  rw [arithmeticResidual_eq]
  calc |(primeMainTerm c σ - Pc) + (primeMainTerm (-c) σ - Pneg) + arch|
      ≤ |(primeMainTerm c σ - Pc) + (primeMainTerm (-c) σ - Pneg)| + |arch| :=
        abs_add_le _ _
    _ ≤ (|primeMainTerm c σ - Pc| + |primeMainTerm (-c) σ - Pneg|) + |arch| := by
        gcongr
        exact abs_add_le _ _
    _ ≤ (E1 + E2) + A := by linarith

/-- The named **smooth-window PNT error input**: a uniform bound `E` on the
difference between the prime main term and the truncated Gaussian prime side. -/
def SmoothWindowPNTError (E : ℝ) : Prop :=
  ∀ (c σ : ℝ) (N : ℕ), |primeMainTerm c σ - gaussianPrimeSide c σ N| ≤ E

/-- **Arithmetic residual under the named PNT input.** -/
theorem arithmeticResidual_abs_le_of_pnt (c σ : ℝ) (N : ℕ) (arch A E : ℝ)
    (hPNT : SmoothWindowPNTError E) (harch : |arch| ≤ A) :
    |arithmeticResidual c σ (gaussianPrimeSide c σ N) (gaussianPrimeSide (-c) σ N) arch|
      ≤ E + E + A := by
  apply arithmeticResidual_abs_le c σ (gaussianPrimeSide c σ N) (gaussianPrimeSide (-c) σ N)
    arch E E A
  · exact hPNT c σ N
  · exact hPNT (-c) σ N
  · exact harch

/-- **Single off-line zero real part.**  For `ρ = 1/2 + δ + iγ`,
`Re H_c(ρ) = 2πσ² e^{σ²(δ²−γ²)} e^{−cδ} cos(2σ²δγ − cγ)`. -/
lemma exp_add_real_mul_I (x y : ℝ) :
    Complex.exp ((x : ℂ) + (y : ℂ) * Complex.I)
      = (Real.exp x : ℂ) * (Real.cos y + Real.sin y * Complex.I) := by
  rw [Complex.exp_add, ← Complex.ofReal_exp, Complex.exp_ofReal_mul_I]

theorem gaussianZeroTest_re_offLine (c σ δ γ : ℝ) :
    (gaussianZeroTest c σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re
      = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2))
          * Real.exp (-c * δ) * Real.cos (2 * σ ^ 2 * δ * γ - c * γ) := by
  unfold gaussianZeroTest
  have hw : (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I) - 1 / 2) = (δ : ℂ) + (γ : ℂ) * Complex.I := by ring
  rw [hw, mul_assoc, ← Complex.exp_add]
  have hexp : ((σ ^ 2 : ℝ) : ℂ) * ((δ : ℂ) + (γ : ℂ) * Complex.I) ^ 2
        + (-(c : ℂ)) * ((δ : ℂ) + (γ : ℂ) * Complex.I)
      = (((σ ^ 2 * (δ ^ 2 - γ ^ 2) - c * δ) : ℝ) : ℂ)
        + (((2 * σ ^ 2 * δ * γ - c * γ) : ℝ) : ℂ) * Complex.I := by
    push_cast
    ring_nf
    rw [Complex.I_sq]
    ring
  rw [hexp, exp_add_real_mul_I]
  simp only [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im,
    Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
    mul_zero, mul_one, add_zero, zero_add, sub_zero]
  have hexp2 : Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2) - c * δ)
      = Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2)) * Real.exp (-(c * δ)) := by
    rw [show σ ^ 2 * (δ ^ 2 - γ ^ 2) - c * δ
        = σ ^ 2 * (δ ^ 2 - γ ^ 2) + (-(c * δ)) by ring]
    rw [Real.exp_add]
  rw [hexp2]
  ring

/-- **Off-line zero growth.**  For `δ ≠ 0`, some separation makes the real part
of the single-zero test function exceed its zero-separation value in modulus. -/
theorem exists_gaussianZeroTest_re_gt_offLine (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) :
    ∃ c : ℝ, (gaussianZeroTest 0 σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re
      < |(gaussianZeroTest c σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re| := by
  set A : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2)) with hA
  have hApos : 0 < A := by rw [hA]; positivity
  set θ : ℝ := 2 * σ ^ 2 * δ * γ with hθ
  have h0 : (gaussianZeroTest 0 σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re = A * Real.cos θ := by
    rw [gaussianZeroTest_re_offLine, hA, hθ]
    simp
  rcases eq_or_ne γ 0 with hγ | hγ
  · subst hγ
    refine ⟨-1 / δ, ?_⟩
    have hθ0 : θ = 0 := by rw [hθ]; simp
    rw [h0, gaussianZeroTest_re_offLine, hθ0]
    have hcδ : -(-1 / δ) * δ = 1 := by field_simp
    rw [hcδ]
    simp only [Real.cos_zero, mul_one, zero_mul, sub_zero]
    have hpos : 0 < A * Real.exp 1 := by positivity
    have hexp1 : (1 : ℝ) < Real.exp 1 := Real.one_lt_exp_iff.mpr zero_lt_one
    have hgoal : A < |A * Real.exp 1| := by
      rw [abs_of_pos hpos]
      nlinarith
    simpa [hA] using hgoal
  · set M : ℝ := Real.log (|Real.cos θ| + 1) with hM
    have hM1 : 0 ≤ M := by
      rw [hM]
      apply Real.log_nonneg
      linarith [abs_nonneg (Real.cos θ)]
    obtain ⟨c, hc, hcos⟩ := exists_cos_eq_one_large (-δ) (-γ) θ M
      (neg_ne_zero.mpr hγ) (neg_ne_zero.mpr hδ)
    refine ⟨c, ?_⟩
    rw [h0, gaussianZeroTest_re_offLine]
    have hphase : Real.cos (2 * σ ^ 2 * δ * γ - c * γ) = 1 := by
      have : c * (-γ) + θ = 2 * σ ^ 2 * δ * γ - c * γ := by rw [hθ]; ring
      rw [← this]
      exact hcos
    rw [hphase, mul_one]
    have hcδ : -(c * δ) > M := by nlinarith
    have hexpM : Real.exp M = |Real.cos θ| + 1 := by
      rw [hM]
      exact Real.exp_log (by positivity)
    have hexp_gt : Real.exp (-(c * δ)) > |Real.cos θ| + 1 := by
      have h1 : Real.exp M < Real.exp (-(c * δ)) := Real.exp_lt_exp.mpr hcδ
      rw [hexpM] at h1
      exact h1
    have hcos_le : Real.cos θ ≤ |Real.cos θ| := le_abs_self _
    have hφ : 0 < A * Real.exp (-(c * δ)) := by positivity
    have hlt : Real.cos θ < Real.exp (-(c * δ)) := by linarith
    have hgoal : A * Real.cos θ < |A * Real.exp (-(c * δ))| := by
      rw [abs_of_pos hφ]
      exact mul_lt_mul_of_pos_left hlt hApos
    simpa [hA, mul_assoc] using hgoal

/-- **Off-line zero asymmetry.**  For `δ ≠ 0` and `γ ≠ 0`, some separation makes
`Re H_{−c}(ρ) ≠ Re H_c(ρ)`, so the singleton Gram matrix is not symmetric. -/
theorem exists_gaussianZeroTest_re_ne_neg (σ δ γ : ℝ) (hσ : 0 < σ) (hδ : δ ≠ 0) (hγ : γ ≠ 0) :
    ∃ c : ℝ, (gaussianZeroTest (-c) σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re
      ≠ (gaussianZeroTest c σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re := by
  set A : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (δ ^ 2 - γ ^ 2)) with hA
  have hApos : 0 < A := by rw [hA]; positivity
  set θ : ℝ := 2 * σ ^ 2 * δ * γ with hθ
  have hneg : ∀ c : ℝ, (gaussianZeroTest (-c) σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re
      = A * Real.exp (c * δ) * Real.cos (θ + c * γ) := by
    intro c
    rw [gaussianZeroTest_re_offLine, hA, hθ]
    rw [show 2 * σ ^ 2 * δ * γ - -c * γ = 2 * σ ^ 2 * δ * γ + c * γ by ring]
    rw [show - -c * δ = c * δ by ring]
  have hpos : ∀ c : ℝ, (gaussianZeroTest c σ (1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I))).re
      = A * Real.exp (-(c * δ)) * Real.cos (θ - c * γ) := by
    intro c
    rw [gaussianZeroTest_re_offLine, hA, hθ]
    rw [show -c * δ = -(c * δ) by ring]
  obtain ⟨c, hc, hcos⟩ := exists_cos_eq_one_large δ γ θ 0 hγ hδ
  refine ⟨c, ?_⟩
  rw [hneg, hpos]
  have hphase : Real.cos (θ + c * γ) = 1 := by
    rw [add_comm]
    exact hcos
  rw [hphase, mul_one]
  have hcpos : 0 < c * δ := hc
  have hexp : Real.exp (-(c * δ)) < Real.exp (c * δ) :=
    Real.exp_lt_exp.mpr (by linarith)
  have hcos_le : Real.cos (θ - c * γ) ≤ 1 := Real.cos_le_one _
  have hstep : A * Real.exp (-(c * δ)) * Real.cos (θ - c * γ)
      ≤ A * Real.exp (-(c * δ)) := by
    have h0 : 0 ≤ A * Real.exp (-(c * δ)) := by positivity
    nlinarith [h0, hcos_le, Real.exp_pos (-(c * δ)), hApos]
  have hlt : A * Real.exp (-(c * δ)) < A * Real.exp (c * δ) :=
    mul_lt_mul_of_pos_left hexp hApos
  linarith

/-- **Singleton Gram matrix.**  On `S = {ρ}` the finite Weil Gram matrix has the
displayed 2×2 form. -/
theorem finiteWeilGramReal_singleton (c σ : ℝ) (ρ : ℂ) :
    finiteWeilGramReal ![0, c] σ {ρ} =
      !![(gaussianZeroTest 0 σ ρ).re, (gaussianZeroTest (-c) σ ρ).re;
         (gaussianZeroTest c σ ρ).re, (gaussianZeroTest 0 σ ρ).re] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [finiteWeilGramReal]

theorem not_posSemidef_singleton_of_ne (c σ : ℝ) (ρ : ℂ)
    (h : (gaussianZeroTest (-c) σ ρ).re ≠ (gaussianZeroTest c σ ρ).re) :
    ¬ (finiteWeilGramReal ![0, c] σ {ρ}).PosSemidef := by
  intro hPSD
  have hentry := hPSD.1.apply (0 : Fin 2) (1 : Fin 2)
  rw [star_trivial] at hentry
  rw [finiteWeilGramReal_singleton] at hentry
  simp at hentry
  exact h hentry.symm

/-- **O4 for zeros off the real axis.**  A nontrivial zero with `im ≠ 0` that is
off the critical line makes `FiniteWeilPositivity` fail. -/
theorem not_finiteWeilPositivity_of_offLine_im_ne_zero (ρ : ℂ) (hZ : completedZeta ρ = 0)
    (h0 : 0 < ρ.re) (h1 : ρ.re < 1) (hne : ρ.re ≠ 1 / 2) (him : ρ.im ≠ 0) :
    ¬ FiniteWeilPositivity := by
  intro hFWP
  set δ : ℝ := ρ.re - 1 / 2 with hδdef
  have hδ : δ ≠ 0 := by
    intro h
    apply hne
    have : ρ.re = δ + 1 / 2 := by rw [hδdef]; ring
    rw [this, h]; ring
  set γ : ℝ := ρ.im with hγdef
  have hρ : ρ = 1 / 2 + ((δ : ℂ) + (γ : ℂ) * Complex.I) := by
    apply Complex.ext
    · simp [δ, γ]
    · simp [δ, γ]
  have him' : γ ≠ 0 := by rwa [hγdef]
  obtain ⟨c, hc⟩ := exists_gaussianZeroTest_re_ne_neg 1 δ γ one_pos hδ him'
  have hc' : (gaussianZeroTest (-c) 1 ρ).re ≠ (gaussianZeroTest c 1 ρ).re := by
    simpa [hρ] using hc
  have hPSD := hFWP (ι := Fin 2) (![0, c]) 1 ({ρ} : Finset ℂ) ?_ ?_ ?_
  · exact not_posSemidef_singleton_of_ne c 1 ρ hc' hPSD
  · intro x hx
    rw [Finset.mem_singleton] at hx
    subst hx
    exact hZ
  · intro x hx
    rw [Finset.mem_singleton] at hx
    subst hx
    exact h0
  · intro x hx
    rw [Finset.mem_singleton] at hx
    subst hx
    exact h1

/-- **Real-line real part.**  For real `ρ`, `Re H_c(ρ)` has the displayed
closed form. -/
theorem gaussianZeroTest_re_ofReal (c σ ρ : ℝ) :
    (gaussianZeroTest c σ (ρ : ℂ)).re
      = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((ρ - 1 / 2) ^ 2))
          * Real.exp (-c * (ρ - 1 / 2)) := by
  have h := gaussianZeroTest_re_offLine c σ (ρ - 1 / 2) 0
  have hρ : (ρ : ℂ) = 1 / 2 + (((ρ - 1 / 2 : ℝ) : ℂ) + (0 : ℂ) * Complex.I) := by
    push_cast; ring
  rw [hρ]
  simpa using h

/-- **Real-line real part at `1 − ρ`.** -/
theorem gaussianZeroTest_re_one_sub_ofReal (c σ ρ : ℝ) :
    (gaussianZeroTest c σ (1 - (ρ : ℂ))).re
      = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((ρ - 1 / 2) ^ 2))
          * Real.exp (c * (ρ - 1 / 2)) := by
  have h := gaussianZeroTest_re_ofReal c σ (1 - ρ)
  convert h using 2
  · push_cast; ring
  · ring
  · ring

/-- **Real-zero pair block.**  The pair `{ρ, 1−ρ}` has the `cosh` Gram matrix,
which is non-PSD, and hence a real off-line zero refutes `FiniteWeilPositivity`. -/
theorem real_pair_distinct {ρ : ℝ} (hne : ρ ≠ 1 / 2) :
    (ρ : ℂ) ≠ 1 - (ρ : ℂ) := by
  intro h
  have hre := congrArg Complex.re h
  simp at hre
  have hρ : ρ = 1 / 2 := by linarith
  exact hne hρ

theorem finiteWeilGramReal_pair (σ ρ : ℝ) (hne : ρ ≠ 1 / 2) :
    finiteWeilGramReal ![0, 1] σ ({(ρ : ℂ), 1 - (ρ : ℂ)} : Finset ℂ)
      = !![2 * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((ρ - 1 / 2) ^ 2))),
           2 * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((ρ - 1 / 2) ^ 2)))
             * Real.cosh (ρ - 1 / 2);
           2 * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((ρ - 1 / 2) ^ 2)))
             * Real.cosh (ρ - 1 / 2),
           2 * (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((ρ - 1 / 2) ^ 2)))] := by
  have hd := real_pair_distinct hne
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [finiteWeilGramReal, Finset.sum_pair hd,
      gaussianZeroTest_re_ofReal, gaussianZeroTest_re_one_sub_ofReal,
      Real.cosh_eq] <;>
    ring




theorem not_posSemidef_real_pair (σ ρ : ℝ) (hσ : σ ≠ 0) (hne : ρ ≠ 1 / 2) :
    ¬ (finiteWeilGramReal ![0, 1] σ ({(ρ : ℂ), 1 - (ρ : ℂ)} : Finset ℂ)).PosSemidef := by
  rw [finiteWeilGramReal_pair σ ρ hne]
  set A : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((ρ - 1 / 2) ^ 2)) with hA
  have hApos : 0 < A := by
    rw [hA]
    have hσ2 : 0 < σ ^ 2 := sq_pos_of_ne_zero hσ
    positivity
  have hδ : ρ - 1 / 2 ≠ 0 := by
    intro h
    apply hne
    linarith
  have hcosh : 1 < Real.cosh (ρ - 1 / 2) := Real.one_lt_cosh.mpr hδ
  apply twoByTwo_not_posSemidef
  have htwoA : 0 < 2 * A := by linarith [hApos]
  have hcoshpos : 0 < Real.cosh (ρ - 1 / 2) := Real.cosh_pos _
  rw [abs_of_pos (mul_pos htwoA hcoshpos)]
  nlinarith [htwoA, hcosh, hcoshpos]




theorem not_finiteWeilPositivity_of_real_offLine (ρ : ℝ) (hρ0 : 0 < ρ) (hρ1 : ρ < 1)
    (hne : ρ ≠ 1 / 2) (hZ : completedZeta (ρ : ℂ) = 0) :
    ¬ FiniteWeilPositivity := by
  intro hFWP
  have hPSD := hFWP (ι := Fin 2) ![0, 1] (1 : ℝ) ({(ρ : ℂ), 1 - (ρ : ℂ)} : Finset ℂ) ?_ ?_ ?_
  · exact not_posSemidef_real_pair 1 ρ one_ne_zero hne hPSD
  · intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact hZ
    · have hρc0 : (ρ : ℂ) ≠ 0 := by
        intro h; have := congrArg Complex.re h; simp at this; linarith
      have hρc1 : (ρ : ℂ) ≠ 1 := by
        intro h; have := congrArg Complex.re h; simp at this; linarith
      have hΓ : (ρ : ℂ).Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos (by simpa using hρ0)
      have hΓ' : (1 - (ρ : ℂ)).Gammaℝ ≠ 0 := by
        apply Complex.Gammaℝ_ne_zero_of_re_pos
        simp
        linarith
      rw [completedZeta_one_sub hρc0 hρc1 hΓ hΓ']
      exact hZ
  · intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl <;> simp <;> linarith
  · intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl <;> simp <;> linarith

/-- **O4 capstone: `FiniteWeilPositivity → RH`.**  The hard direction of the
classical Weil criterion, for the finite zero-side Gram matrix. -/
theorem not_finiteWeilPositivity_of_offLine (ρ : ℂ) (hZ : completedZeta ρ = 0)
    (h0 : 0 < ρ.re) (h1 : ρ.re < 1) (hne : ρ.re ≠ 1 / 2) :
    ¬ FiniteWeilPositivity := by
  rcases eq_or_ne ρ.im 0 with him | him
  · have hρ : ρ = ((ρ.re : ℝ) : ℂ) := by
      apply Complex.ext
      · simp
      · simp [him]
    rw [hρ] at hZ
    exact not_finiteWeilPositivity_of_real_offLine ρ.re h0 h1 hne hZ
  · exact not_finiteWeilPositivity_of_offLine_im_ne_zero ρ hZ h0 h1 hne him

theorem finiteWeilPositivity_implies_RH (h : FiniteWeilPositivity) :
    AbsoluteHodgeSymbol.RiemannHypothesis := by
  intro ρ hZ h0 h1
  by_contra hne
  exact not_finiteWeilPositivity_of_offLine ρ hZ h0 h1 hne h

/-- **The arithmetic-side interface.**  `FiniteWeilPositivity` is exactly the
Hermitian-and-nonnegative-quadratic-form statement for the finite zero-side
Gram matrix.  This is the shape in which the explicit formula must identify the
zero-side form with the arithmetic one. -/
def weilQuadraticForm {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (S : Finset ℂ) (x : ι → ℝ) : ℝ :=
  star x ⬝ᵥ ((finiteWeilGramReal a σ S) *ᵥ x)

theorem finiteWeilPositivity_iff_quadraticForm :
    FiniteWeilPositivity ↔
      ∀ (ι : Type) [Fintype ι] [DecidableEq ι] (a : ι → ℝ) (σ : ℝ) (S : Finset ℂ),
        (∀ ρ ∈ S, completedZeta ρ = 0) →
        (∀ ρ ∈ S, 0 < ρ.re) →
        (∀ ρ ∈ S, ρ.re < 1) →
        (finiteWeilGramReal a σ S).IsHermitian ∧
          ∀ x : ι → ℝ, 0 ≤ weilQuadraticForm a σ S x := by
  simp only [FiniteWeilPositivity, weilQuadraticForm,
    Matrix.posSemidef_iff_dotProduct_mulVec]

/-- **Scalar zero side and the matrix assembly.**  The Weil quadratic form is a
finite bilinear combination of the scalar zero-side sums, and hence equals the
arithmetic quadratic form once the scalar explicit formula is known. -/
def scalarZeroSide (σ : ℝ) (S : Finset ℂ) (c : ℝ) : ℝ :=
  ∑ ρ ∈ S, (gaussianZeroTest c σ ρ).re

theorem weilQuadraticForm_eq_sum_scalar {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (S : Finset ℂ) (x : ι → ℝ) :
    weilQuadraticForm a σ S x
      = ∑ i, ∑ j, x i * x j * scalarZeroSide σ S (a i - a j) := by
  unfold weilQuadraticForm finiteWeilGramReal scalarZeroSide
  simp only [dotProduct, Matrix.mulVec, star_trivial, Finset.mul_sum, Finset.sum_mul]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  apply Finset.sum_congr rfl
  intro ρ _
  ring

theorem weilQuadraticForm_eq_arithmetic {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (S : Finset ℂ) (x : ι → ℝ) (g : ℝ → ℝ)
    (h : ∀ c, scalarZeroSide σ S c = g c) :
    weilQuadraticForm a σ S x = ∑ i, ∑ j, x i * x j * g (a i - a j) := by
  rw [weilQuadraticForm_eq_sum_scalar]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  rw [h]

/-- **Gaussian rectangle identity.**  The library's explicit formula specialised
to the Gaussian test function.  This discharges the `hcontour` hypothesis of the
assembled formula in terms of the standard explicit-formula hypotheses (notably
`hF_simple`, zero simplicity). -/
theorem gaussianRectangleIdentity (c σ : ℝ) (S : Finset ℂ) (x₁ x₂ y₁ y₂ : ℝ) (U : Set ℂ)
    (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc x₁ x₂) (Set.uIcc y₁ y₂) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1)
          * (2 * (Real.pi : ℂ) * Complex.I) := by
  exact test_function_explicit_formula (h := fun z => gaussianZeroTest c σ z) S x₁ x₂ y₁ y₂
    hU hsub hSU h0_notS h1_notS (differentiable_gaussianZeroTest c σ).differentiableOn
    hF hZ hZ_zero hF_simple hF_ne h0_in h1_in hS_in

/-- **The symmetrised arithmetic residual is even.**  With the prime sides
evaluated at `c` and `−c`, the residual `pole − (P(c) + P(−c)) + arch` is an even
function of `c`; hence the arithmetic Gram matrix is Hermitian. -/
theorem arithmeticResidual_symm (σ : ℝ) (P : ℝ → ℝ) (arch c : ℝ) :
    arithmeticResidual (-c) σ (P (-c)) (P c) arch
      = arithmeticResidual c σ (P c) (P (-c)) arch := by
  unfold arithmeticResidual poleTerm
  rw [show (-c) / 2 = -(c / 2) by ring, Real.cosh_neg]
  ring





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula MissingBridge

theorem arithmeticResidual_even (σ arch : ℝ) (P : ℝ → ℝ) :
    Function.Even (fun c => arithmeticResidual c σ (P c) (P (-c)) arch) := by
  intro c
  change arithmeticResidual (-c) σ (P (-c)) (P (-(-c))) arch
    = arithmeticResidual c σ (P c) (P (-c)) arch
  rw [neg_neg]
  exact arithmeticResidual_symm σ P arch c

/-- **The scalar Weil inequality.**  A necessary condition for
`FiniteWeilPositivity`: every finite zero-side sum at zero separation is
nonnegative. -/
theorem finiteWeilPositivity_scalar_nonneg (h : FiniteWeilPositivity)
    (σ : ℝ) (S : Finset ℂ)
    (hZ : ∀ ρ ∈ S, completedZeta ρ = 0)
    (h0 : ∀ ρ ∈ S, 0 < ρ.re) (h1 : ∀ ρ ∈ S, ρ.re < 1) :
    0 ≤ ∑ ρ ∈ S, (gaussianZeroTest 0 σ ρ).re := by
  have hq := (finiteWeilPositivity_iff_quadraticForm.mp h) PUnit
    (fun _ => (0 : ℝ)) σ S hZ h0 h1
  have hnn := hq.2 (fun _ => (1 : ℝ))
  rw [weilQuadraticForm_eq_sum_scalar] at hnn
  simpa [scalarZeroSide] using hnn

/-- **The exact 2×2 PSD criterion.**  `!![a, b; b, a]` is positive semidefinite
iff `0 ≤ a` and `|b| ≤ a`.  This is the criterion the arithmetic-side pair
conditions must satisfy. -/
theorem twoByTwo_posSemidef_iff {a b : ℝ} :
    (!![a, b; b, a]).PosSemidef ↔ 0 ≤ a ∧ |b| ≤ a := by
  constructor
  · intro h
    have hq := (Matrix.posSemidef_iff_dotProduct_mulVec.mp h).2
    have h10 := hq ![1, 0]
    have h11 := hq ![1, 1]
    have h1m := hq ![1, -1]
    simp [dotProduct, Matrix.mulVec, Fin.sum_univ_two, Matrix.cons_val] at h10 h11 h1m
    have ha : 0 ≤ a := by linarith
    refine ⟨ha, ?_⟩
    rw [abs_le]
    constructor <;> linarith
  · rintro ⟨ha, hb⟩
    refine Matrix.posSemidef_iff_dotProduct_mulVec.mpr ⟨?_, ?_⟩
    · ext i j
      fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose, Matrix.cons_val]
    · intro x
      have h_amgm : |2 * x 0 * x 1| ≤ (x 0)^2 + (x 1)^2 := by
        rw [abs_le]
        constructor <;> nlinarith [sq_nonneg (x 0 - x 1), sq_nonneg (x 0 + x 1)]
      have h1 : -(a * ((x 0)^2 + (x 1)^2)) ≤ b * (2 * x 0 * x 1) := by
        have h2 : -(|b| * |2 * x 0 * x 1|) ≤ b * (2 * x 0 * x 1) := by
          have := neg_abs_le (b * (2 * x 0 * x 1))
          rwa [abs_mul] at this
        have h3 : |b| * |2 * x 0 * x 1| ≤ a * ((x 0)^2 + (x 1)^2) :=
          mul_le_mul hb h_amgm (abs_nonneg _) ha
        linarith
      have hq : star x ⬝ᵥ (!![a, b; b, a] *ᵥ x)
          = a * ((x 0)^2 + (x 1)^2) + b * (2 * x 0 * x 1) := by
        simp [dotProduct, Matrix.mulVec, Fin.sum_univ_two, Matrix.cons_val, star_trivial]
        ring
      rw [hq]
      linarith

/-- **General 2×2 PSD criterion and the singleton characterisation.**  For
`!![a, b; c, a]` PSD is equivalent to `b = c`, `0 ≤ a`, `|b| ≤ a`; applied to the
singleton zero block this characterises exactly when it is PSD. -/
theorem twoByTwo_general_posSemidef_iff {a b c : ℝ} :
    (!![a, b; c, a]).PosSemidef ↔ b = c ∧ 0 ≤ a ∧ |b| ≤ a := by
  constructor
  · intro h
    have hHerm := h.1.apply (0 : Fin 2) (1 : Fin 2)
    simp [Matrix.cons_val, star_trivial] at hHerm
    have hbc : b = c := hHerm.symm
    subst hbc
    have h2 := (twoByTwo_posSemidef_iff (a := a) (b := b)).mp h
    exact ⟨rfl, h2.1, h2.2⟩
  · rintro ⟨rfl, ha, hb⟩
    exact (twoByTwo_posSemidef_iff (a := a) (b := b)).mpr ⟨ha, hb⟩





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula MissingBridge
open scoped Matrix

theorem singleton_block_posSemidef_iff (c σ : ℝ) (ρ : ℂ) :
    (finiteWeilGramReal ![0, c] σ {ρ}).PosSemidef ↔
      (gaussianZeroTest (-c) σ ρ).re = (gaussianZeroTest c σ ρ).re ∧
      0 ≤ (gaussianZeroTest 0 σ ρ).re ∧
      |(gaussianZeroTest c σ ρ).re| ≤ (gaussianZeroTest 0 σ ρ).re := by
  rw [finiteWeilGramReal_singleton, twoByTwo_general_posSemidef_iff]
  constructor
  · rintro ⟨h1, h2, h3⟩
    exact ⟨h1, h2, by simpa [h1] using h3⟩
  · rintro ⟨h1, h2, h3⟩
    exact ⟨h1, h2, by simpa [h1] using h3⟩

/-- **`FiniteWeilPositivity` forces the singleton criterion.**  Every nontrivial
zero satisfies the exact singleton 2×2 conditions, in particular the off-diagonal
symmetry `Re H_{−c}(ρ) = Re H_c(ρ)`. -/
theorem finiteWeilPositivity_singleton (h : FiniteWeilPositivity) (c σ : ℝ) (ρ : ℂ)
    (hZ : completedZeta ρ = 0) (h0 : 0 < ρ.re) (h1 : ρ.re < 1) :
    (gaussianZeroTest (-c) σ ρ).re = (gaussianZeroTest c σ ρ).re ∧
      0 ≤ (gaussianZeroTest 0 σ ρ).re ∧
      |(gaussianZeroTest c σ ρ).re| ≤ (gaussianZeroTest 0 σ ρ).re := by
  have hPSD := h (ι := Fin 2) (![0, c]) σ ({ρ} : Finset ℂ) ?_ ?_ ?_
  · exact (singleton_block_posSemidef_iff c σ ρ).mp hPSD
  · intro x hx
    rw [Finset.mem_singleton] at hx
    subst hx
    exact hZ
  · intro x hx
    rw [Finset.mem_singleton] at hx
    subst hx
    exact h0
  · intro x hx
    rw [Finset.mem_singleton] at hx
    subst hx
    exact h1

/-- **Gaussian rectangle identity with the zero set given as "all zeros in
`U`".**  Replaces the opaque `hF_ne` by the mathematically intended condition
that `S` contains every zero of `s(s−1)Λ(s)` in `U` (together with `hZ_zero`,
i.e. `S` consists of zeros). -/
theorem gaussianRectangleIdentity_of_allZeros (c σ : ℝ) (S : Finset ℂ) (x₁ x₂ y₁ y₂ : ℝ) (U : Set ℂ)
    (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc x₁ x₂) (Set.uIcc y₁ y₂) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hF : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hZ_zero : ∀ ρ ∈ S, completedZeta ρ = 0)
    (hS_all : ∀ z ∈ U, z * (z - 1) * completedZeta z = 0 → z ∈ S)
    (hF_simple : ∀ ρ ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) ρ ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * gaussianZeroTest c σ z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, gaussianZeroTest c σ ρ) - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1)
          * (2 * (Real.pi : ℂ) * Complex.I) := by
  apply gaussianRectangleIdentity c σ S x₁ x₂ y₁ y₂ U hU hsub hSU h0_notS h1_notS hF hZ hZ_zero
    hF_simple ?_ h0_in h1_in hS_in
  intro z hzU hzS hz0
  exact hzS (hS_all z hzU hz0)

/-- **The arithmetic Gram matrix is Hermitian.**  The symmetrised residual is
even (T63), so the matrix `g(aᵢ−aⱼ)` is symmetric; this is the Hermitian half of
the arithmetic-side interface (T58). -/
theorem arithmeticResidual_isHermitian {ι : Type*} [Fintype ι]
    (σ arch : ℝ) (P : ℝ → ℝ) (a : ι → ℝ) :
    (Matrix.of (fun i j => arithmeticResidual (a i - a j) σ (P (a i - a j)) (P (-(a i - a j))) arch)).IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  simp only [star_trivial]
  have h := arithmeticResidual_even σ arch P (a j - a i)
  rw [show -(a j - a i) = a i - a j by ring] at h
  exact h.symm

/-- **The arithmetic Weil quadratic form and its pole-cancelled decomposition.**
It splits exactly into the two PNT-error quadratic forms plus the archimedean
quadratic form. -/
def arithmeticQuadraticForm {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ arch : ℝ)
    (P : ℝ → ℝ) (x : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, x i * x j * arithmeticResidual (a i - a j) σ (P (a i - a j)) (P (-(a i - a j))) arch

theorem arithmeticQuadraticForm_eq_pnt_add_arch {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ arch : ℝ) (P : ℝ → ℝ) (x : ι → ℝ) :
    arithmeticQuadraticForm a σ arch P x
      = (∑ i, ∑ j, x i * x j * (primeMainTerm (a i - a j) σ - P (a i - a j)))
        + (∑ i, ∑ j, x i * x j * (primeMainTerm (-(a i - a j)) σ - P (-(a i - a j))))
        + (∑ i, ∑ j, x i * x j * arch) := by
  unfold arithmeticQuadraticForm
  have h : ∀ i j : ι, x i * x j * arithmeticResidual (a i - a j) σ (P (a i - a j)) (P (-(a i - a j))) arch
      = x i * x j * (primeMainTerm (a i - a j) σ - P (a i - a j))
        + x i * x j * (primeMainTerm (-(a i - a j)) σ - P (-(a i - a j)))
        + x i * x j * arch := by
    intro i j
    rw [arithmeticResidual_eq]
    ring
  simp only [h, Finset.sum_add_distrib]

/-- **The PNT-error quadratic form is small.**  Under the named PNT input, the
quadratic form of the Gaussian-window PNT error is bounded by `E` times the
square of the `ℓ¹` norm of the test vector. -/
theorem abs_pntQuadraticForm_le {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ : ℝ) (N : ℕ) (x : ι → ℝ) (E : ℝ) (hE : 0 ≤ E)
    (hPNT : SmoothWindowPNTError E) :
    |∑ i, ∑ j, x i * x j * (primeMainTerm (a i - a j) σ - gaussianPrimeSide (a i - a j) σ N)|
      ≤ E * (∑ i, |x i|) ^ 2 := by
  have hb : ∀ i j : ι, |primeMainTerm (a i - a j) σ - gaussianPrimeSide (a i - a j) σ N| ≤ E :=
    fun i j => hPNT (a i - a j) σ N
  calc |∑ i, ∑ j, x i * x j * (primeMainTerm (a i - a j) σ - gaussianPrimeSide (a i - a j) σ N)|
      ≤ ∑ i, |∑ j, x i * x j * (primeMainTerm (a i - a j) σ - gaussianPrimeSide (a i - a j) σ N)| :=
        Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ i, ∑ j, |x i * x j * (primeMainTerm (a i - a j) σ - gaussianPrimeSide (a i - a j) σ N)| := by
        apply Finset.sum_le_sum
        intro i _
        exact Finset.abs_sum_le_sum_abs _ _
    _ = ∑ i, ∑ j, |x i| * |x j| * |primeMainTerm (a i - a j) σ - gaussianPrimeSide (a i - a j) σ N| := by
        simp [abs_mul, mul_assoc]
    _ ≤ ∑ i, ∑ j, |x i| * |x j| * E := by
        apply Finset.sum_le_sum
        intro i _
        apply Finset.sum_le_sum
        intro j _
        gcongr
        exact hb i j
    _ = E * (∑ i, |x i|) ^ 2 := by
        rw [sq, Finset.sum_mul_sum, Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro i _
        rw [Finset.mul_sum]
        apply Finset.sum_congr rfl
        intro j _
        ring

/-- **Function-valued arithmetic residual and the classical positivity
reduction.**  The archimedean term must depend on the separation `c`, so the
residual is redefined with `arch : ℝ → ℝ`; the arithmetic quadratic form then
splits as `2·Q_PNT + Q_arch`, and it is nonnegative whenever the archimedean
form dominates twice the PNT-error bound. -/
def arithmeticResidualFun (σ : ℝ) (P arch : ℝ → ℝ) (c : ℝ) : ℝ :=
  poleTerm c σ - (P c + P (-c)) + arch c

def arithmeticQuadraticFormFun {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (P arch : ℝ → ℝ) (x : ι → ℝ) : ℝ :=
  ∑ i, ∑ j, x i * x j * arithmeticResidualFun σ P arch (a i - a j)

theorem arithmeticQuadraticFormFun_eq_pnt_add_arch {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ : ℝ) (P arch : ℝ → ℝ) (x : ι → ℝ) :
    arithmeticQuadraticFormFun a σ P arch x
      = (∑ i, ∑ j, x i * x j * (primeMainTerm (a i - a j) σ - P (a i - a j)))
        + (∑ i, ∑ j, x i * x j * (primeMainTerm (-(a i - a j)) σ - P (-(a i - a j))))
        + (∑ i, ∑ j, x i * x j * arch (a i - a j)) := by
  unfold arithmeticQuadraticFormFun
  have h : ∀ i j : ι, x i * x j * arithmeticResidualFun σ P arch (a i - a j)
      = x i * x j * (primeMainTerm (a i - a j) σ - P (a i - a j))
        + x i * x j * (primeMainTerm (-(a i - a j)) σ - P (-(a i - a j)))
        + x i * x j * arch (a i - a j) := by
    intro i j
    unfold arithmeticResidualFun
    rw [poleTerm_eq_primeMainTerm_add]
    ring
  simp only [h, Finset.sum_add_distrib]





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula MissingBridge

theorem arithmeticQuadraticFormFun_eq_two_pnt_add_arch {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ : ℝ) (P arch : ℝ → ℝ) (x : ι → ℝ) :
    arithmeticQuadraticFormFun a σ P arch x
      = 2 * (∑ i, ∑ j, x i * x j * (primeMainTerm (a i - a j) σ - P (a i - a j)))
        + (∑ i, ∑ j, x i * x j * arch (a i - a j)) := by
  rw [arithmeticQuadraticFormFun_eq_pnt_add_arch]
  have hswap : (∑ i, ∑ j, x i * x j * (primeMainTerm (-(a i - a j)) σ - P (-(a i - a j))))
      = (∑ i, ∑ j, x i * x j * (primeMainTerm (a i - a j) σ - P (a i - a j))) := by
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    rw [show -(a j - a i) = a i - a j by ring]
    ring
  rw [hswap]
  ring

theorem arithmeticQuadraticFormFun_nonneg_of_dominates {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ : ℝ) (arch : ℝ → ℝ) (x : ι → ℝ) (E : ℝ) (N : ℕ)
    (hE : 0 ≤ E) (hPNT : SmoothWindowPNTError E)
    (hDom : 2 * E * (∑ i, |x i|) ^ 2 ≤ ∑ i, ∑ j, x i * x j * arch (a i - a j)) :
    0 ≤ arithmeticQuadraticFormFun a σ (fun c => gaussianPrimeSide c σ N) arch x := by
  rw [arithmeticQuadraticFormFun_eq_two_pnt_add_arch]
  have hA := abs_pntQuadraticForm_le a σ N x E hE hPNT
  have hA' := (abs_le.mp hA).1
  linarith

/-- **Arithmetic matrix PSD under archimedean dominance.**  With an even
archimedean kernel and the dominance hypothesis
`Q_arch ≥ 2E(∑|xᵢ|)²`, the arithmetic Gram matrix is positive semidefinite. -/
theorem arithmeticResidualFun_even (σ : ℝ) (P arch : ℝ → ℝ)
    (harch : ∀ c, arch (-c) = arch c) (c : ℝ) :
    arithmeticResidualFun σ P arch (-c) = arithmeticResidualFun σ P arch c := by
  unfold arithmeticResidualFun
  rw [show poleTerm (-c) σ = poleTerm c σ by
    unfold poleTerm
    rw [show -c / 2 = -(c / 2) by ring, Real.cosh_neg]]
  rw [harch]
  ring

theorem arithmeticQuadraticFormFun_eq_dotProduct {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ : ℝ) (P arch : ℝ → ℝ) (x : ι → ℝ) :
    arithmeticQuadraticFormFun a σ P arch x
      = star x ⬝ᵥ ((Matrix.of (fun i j => arithmeticResidualFun σ P arch (a i - a j))) *ᵥ x) := by
  unfold arithmeticQuadraticFormFun
  simp only [dotProduct, Matrix.mulVec, Matrix.of_apply, star_trivial, Finset.sum_mul, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  ring





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula MissingBridge
open scoped Matrix

theorem arithmeticMatrix_posSemidef_of_dominates {ι : Type*} [Fintype ι]
    (a : ι → ℝ) (σ : ℝ) (arch : ℝ → ℝ) (E : ℝ) (N : ℕ)
    (harch : ∀ c, arch (-c) = arch c) (hE : 0 ≤ E) (hPNT : SmoothWindowPNTError E)
    (hDom : ∀ x : ι → ℝ,
      2 * E * (∑ i, |x i|) ^ 2 ≤ ∑ i, ∑ j, x i * x j * arch (a i - a j)) :
    (Matrix.of (fun i j =>
      arithmeticResidualFun σ (fun c => gaussianPrimeSide c σ N) arch (a i - a j))).PosSemidef := by
  apply Matrix.posSemidef_iff_dotProduct_mulVec.mpr
  constructor
  · apply Matrix.IsHermitian.ext
    intro i j
    simp only [Matrix.of_apply, star_trivial]
    have h := arithmeticResidualFun_even σ (fun c => gaussianPrimeSide c σ N) arch harch (a j - a i)
    rw [show -(a j - a i) = a i - a j by ring] at h
    exact h.symm
  · intro x
    rw [← arithmeticQuadraticFormFun_eq_dotProduct]
    exact arithmeticQuadraticFormFun_nonneg_of_dominates a σ arch x E N hE hPNT (hDom x)

/-- **Capstone reduction:** `FiniteWeilPositivity` follows from the scalar
explicit-formula identity plus positive semidefiniteness of the arithmetic Gram
matrix.  Combined with T78, this reduces the whole arithmetic-side programme to
the archimedean dominance inequality. -/
theorem finiteWeilPositivity_of_arithmetic
    (g : ℝ → ℝ → ℝ)
    (hformula : ∀ (σ : ℝ) (S : Finset ℂ) (c : ℝ),
      (∀ ρ ∈ S, completedZeta ρ = 0) → (∀ ρ ∈ S, 0 < ρ.re) → (∀ ρ ∈ S, ρ.re < 1) →
      scalarZeroSide σ S c = g σ c)
    (hPSD : ∀ (σ : ℝ) (ι : Type) [Fintype ι] (a : ι → ℝ),
      (Matrix.of (fun i j => g σ (a i - a j))).PosSemidef) :
    FiniteWeilPositivity := by
  intro ι _ _ a σ S hZ h0 h1
  have hM : finiteWeilGramReal a σ S = Matrix.of (fun i j => g σ (a i - a j)) := by
    ext i j
    change scalarZeroSide σ S (a i - a j) = g σ (a i - a j)
    exact hformula σ S (a i - a j) hZ h0 h1
  rw [hM]
  exact hPSD σ ι a

/-- **The concrete archimedean kernels are even on the real axis.**  This
supplies the `harch` hypothesis of the PSD assembly (T78) for the library's
`weilOmega` and `archSymbol`. -/
theorem weilOmega_real_even (x : ℝ) :
    AbsoluteHodgeArchimedean.weilOmega (-(x : ℂ)) = AbsoluteHodgeArchimedean.weilOmega ((x : ℂ)) := by
  rw [AbsoluteHodgeArchimedean.weilOmega_neg_conj]
  simp

theorem archSymbol_real_even (x : ℝ) :
    AbsoluteHodgeArchimedean.archSymbol (-x) = AbsoluteHodgeArchimedean.archSymbol x :=
  AbsoluteHodgeArchimedean.archSymbol_even x

/-- **End-to-end conditional chain.**  `FiniteWeilPositivity`, and hence RH, follows
from (i) an even archimedean kernel, (ii) the PNT bound `SmoothWindowPNTError E`,
(iii) the archimedean dominance `Q_arch ≥ 2E(∑|xᵢ|)²`, and (iv) the scalar
explicit-formula identity.  This is a conditional derivation of RH from those
inputs; it is **not** an unconditional proof. -/
theorem finiteWeilPositivity_of_pnt_archimedean
    (arch : ℝ → ℝ) (E : ℝ) (N : ℕ)
    (harch : ∀ c, arch (-c) = arch c) (hE : 0 ≤ E) (hPNT : SmoothWindowPNTError E)
    (hDom : ∀ (σ : ℝ) (ι : Type) [Fintype ι] (a : ι → ℝ) (x : ι → ℝ),
      2 * E * (∑ i, |x i|) ^ 2 ≤ ∑ i, ∑ j, x i * x j * arch (a i - a j))
    (hformula : ∀ (σ : ℝ) (S : Finset ℂ) (c : ℝ),
      (∀ ρ ∈ S, completedZeta ρ = 0) → (∀ ρ ∈ S, 0 < ρ.re) → (∀ ρ ∈ S, ρ.re < 1) →
      scalarZeroSide σ S c
        = arithmeticResidualFun σ (fun c => gaussianPrimeSide c σ N) arch c) :
    FiniteWeilPositivity := by
  refine finiteWeilPositivity_of_arithmetic
    (g := fun σ c => arithmeticResidualFun σ (fun c => gaussianPrimeSide c σ N) arch c) ?_ ?_
  · exact hformula
  · intro σ ι _ a
    exact arithmeticMatrix_posSemidef_of_dominates a σ arch E N harch hE hPNT (hDom σ ι a)





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula AbsoluteHodgeArchimedean MissingBridge
open scoped Matrix

theorem riemannHypothesis_of_pnt_archimedean
    (arch : ℝ → ℝ) (E : ℝ) (N : ℕ)
    (harch : ∀ c, arch (-c) = arch c) (hE : 0 ≤ E) (hPNT : SmoothWindowPNTError E)
    (hDom : ∀ (σ : ℝ) (ι : Type) [Fintype ι] (a : ι → ℝ) (x : ι → ℝ),
      2 * E * (∑ i, |x i|) ^ 2 ≤ ∑ i, ∑ j, x i * x j * arch (a i - a j))
    (hformula : ∀ (σ : ℝ) (S : Finset ℂ) (c : ℝ),
      (∀ ρ ∈ S, completedZeta ρ = 0) → (∀ ρ ∈ S, 0 < ρ.re) → (∀ ρ ∈ S, ρ.re < 1) →
      scalarZeroSide σ S c
        = arithmeticResidualFun σ (fun c => gaussianPrimeSide c σ N) arch c) :
    AbsoluteHodgeSymbol.RiemannHypothesis :=
  finiteWeilPositivity_implies_RH
    (finiteWeilPositivity_of_pnt_archimedean arch E N harch hE hPNT hDom hformula)

/-- **Bridge to the concrete Gaussian Weil Gram matrix.**  The exact entry
`gaussianGramEntry c 0 σ` of the `prime-spectrum-tensor` construction is exactly
the arithmetic residual with `P = −primeTerm/2` and archimedean kernel
`densityTerm c σ = σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt`. -/
theorem densityTerm_even (c σ : ℝ) :
    PrimeSpectrumTensor.densityTerm (-c) σ = PrimeSpectrumTensor.densityTerm c σ := by
  unfold PrimeSpectrumTensor.densityTerm
  congr 2
  ext t
  rw [show -c * t = -(c * t) by ring, Real.cos_neg]

theorem poleTerm_ps_even (c σ : ℝ) :
    PrimeSpectrumTensor.poleTerm (-c) σ = PrimeSpectrumTensor.poleTerm c σ := by
  unfold PrimeSpectrumTensor.poleTerm
  rw [show -c / 2 = -(c / 2) by ring, Real.cosh_neg]

theorem gaussianGramEntry_eq_residual (c σ : ℝ) :
    PrimeSpectrumTensor.gaussianGramEntry c 0 σ
      = arithmeticResidualFun σ
          (fun x => -PrimeSpectrumTensor.primeTerm x σ / 2)
          (fun x => PrimeSpectrumTensor.densityTerm x σ) c := by
  unfold PrimeSpectrumTensor.gaussianGramEntry PrimeSpectrumTensor.gaussianW
  simp only [sub_zero, zero_sub]
  rw [densityTerm_even, poleTerm_ps_even]
  unfold arithmeticResidualFun MissingBridge.poleTerm PrimeSpectrumTensor.poleTerm
  ring

/-- **The exact 4×4 Gaussian Gram matrix as the arithmetic residual matrix.**
`gaussianGram4 σ` is exactly the arithmetic Gram matrix of the `centre4`
separations, with `P = −primeTerm/2` and `arch = densityTerm`. -/
theorem gaussianGram4_eq_arithmetic (σ : ℝ) :
    PrimeSpectrumTensor.gaussianGram4 σ
      = Matrix.of (fun i j =>
          arithmeticResidualFun σ
            (fun x => -PrimeSpectrumTensor.primeTerm x σ / 2)
            (fun x => PrimeSpectrumTensor.densityTerm x σ)
            (PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j)) := by
  ext i j
  have h := gaussianGramEntry_eq_residual
    (PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j) σ
  simpa [PrimeSpectrumTensor.gaussianGram4, PrimeSpectrumTensor.gaussianGramEntry] using h

/-- **Signs and three-term split of the Gaussian Gram entry.**  The pole term is
positive, the prime term is non-positive, and the entry is the sum of the three
terms. -/
theorem primeTerm_nonpos (c σ : ℝ) (hσ : 0 ≤ σ) :
    PrimeSpectrumTensor.primeTerm c σ ≤ 0 := by
  unfold PrimeSpectrumTensor.primeTerm
  have hterm : ∀ n : ℕ, 0 ≤ ArithmeticFunction.vonMangoldt n / Real.sqrt n *
      PrimeSpectrumTensor.gaussianBump c σ (Real.log n) := by
    intro n
    have h1 : 0 ≤ (ArithmeticFunction.vonMangoldt n : ℝ) := ArithmeticFunction.vonMangoldt_nonneg
    have h2 : 0 ≤ Real.sqrt (n : ℝ) := Real.sqrt_nonneg _
    have h3 : 0 ≤ PrimeSpectrumTensor.gaussianBump c σ (Real.log n) := by
      unfold PrimeSpectrumTensor.gaussianBump
      positivity
    exact mul_nonneg (div_nonneg h1 h2) h3
  have hsum : 0 ≤ ∑' n : ℕ, ArithmeticFunction.vonMangoldt n / Real.sqrt n *
      PrimeSpectrumTensor.gaussianBump c σ (Real.log n) := tsum_nonneg hterm
  nlinarith

theorem poleTerm_ps_pos (c σ : ℝ) (hσ : 0 < σ) :
    0 < PrimeSpectrumTensor.poleTerm c σ := by
  unfold PrimeSpectrumTensor.poleTerm
  have : 0 < Real.cosh (c / 2) := Real.cosh_pos _
  positivity





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula AbsoluteHodgeArchimedean MissingBridge

theorem gaussianGramEntry_three_term (c σ : ℝ) :
    PrimeSpectrumTensor.gaussianGramEntry c 0 σ
      = PrimeSpectrumTensor.poleTerm c σ + PrimeSpectrumTensor.densityTerm c σ
        + (PrimeSpectrumTensor.primeTerm c σ + PrimeSpectrumTensor.primeTerm (-c) σ) / 2 := by
  unfold PrimeSpectrumTensor.gaussianGramEntry PrimeSpectrumTensor.gaussianW
  simp only [sub_zero, zero_sub]
  rw [densityTerm_even, poleTerm_ps_even]
  ring

/-- **Three-matrix decomposition of the Gaussian Gram matrix** and its
Hermitian property in the arithmetic framework. -/
theorem gaussianGram4_eq_pole_add_density_add_prime (σ : ℝ) :
    PrimeSpectrumTensor.gaussianGram4 σ
      = Matrix.of (fun i j => PrimeSpectrumTensor.poleTerm
          (PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j) σ)
        + Matrix.of (fun i j => PrimeSpectrumTensor.densityTerm
          (PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j) σ)
        + Matrix.of (fun i j =>
            (PrimeSpectrumTensor.primeTerm
                (PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j) σ
              + PrimeSpectrumTensor.primeTerm
                (PrimeSpectrumTensor.centre4 j - PrimeSpectrumTensor.centre4 i) σ) / 2) := by
  ext i j
  rw [Matrix.add_apply, Matrix.add_apply]
  have h := gaussianGramEntry_three_term
    (PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j) σ
  have hneg : -(PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j)
      = PrimeSpectrumTensor.centre4 j - PrimeSpectrumTensor.centre4 i := by ring
  rw [hneg] at h
  simpa [PrimeSpectrumTensor.gaussianGram4, PrimeSpectrumTensor.gaussianGramEntry] using h





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula AbsoluteHodgeArchimedean MissingBridge
open scoped Matrix

theorem gaussianGram4_isHermitian (σ : ℝ) :
    (PrimeSpectrumTensor.gaussianGram4 σ).IsHermitian := by
  rw [gaussianGram4_eq_arithmetic]
  apply Matrix.IsHermitian.ext
  intro i j
  simp only [Matrix.of_apply, star_trivial]
  have h := arithmeticResidualFun_even σ
    (fun x => -PrimeSpectrumTensor.primeTerm x σ / 2)
    (fun x => PrimeSpectrumTensor.densityTerm x σ)
    (fun c => densityTerm_even c σ)
    (PrimeSpectrumTensor.centre4 j - PrimeSpectrumTensor.centre4 i)
  rw [show -(PrimeSpectrumTensor.centre4 j - PrimeSpectrumTensor.centre4 i)
      = PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j by ring] at h
  exact h.symm

/-- **The certified 4×4 instance, integrated.**  The `prime-spectrum-tensor`
certificate `gaussianGram4_posDef` gives, in this framework, PSD of the exact
arithmetic residual matrix on the four centres at `σ = 1/20`. -/
theorem gaussianGram4_posSemidef :
    (PrimeSpectrumTensor.gaussianGram4 (1 / 20)).PosSemidef :=
  PrimeSpectrumTensor.gaussianGram4_posDef.posSemidef

theorem centre4Arithmetic_posSemidef :
    (Matrix.of (fun i j =>
      arithmeticResidualFun (1 / 20)
        (fun x => -PrimeSpectrumTensor.primeTerm x (1 / 20) / 2)
        (fun x => PrimeSpectrumTensor.densityTerm x (1 / 20))
        (PrimeSpectrumTensor.centre4 i - PrimeSpectrumTensor.centre4 j))).PosSemidef := by
  rw [← gaussianGram4_eq_arithmetic]
  exact gaussianGram4_posSemidef

/-- **The 5×5 rung integrated.**  `gaussianGram5` is the arithmetic residual
matrix on the five centres, and the `prime-spectrum-tensor` 5×5 certificate gives
its PSD. -/
theorem gaussianGram5_eq_arithmetic (σ : ℝ) :
    PrimeSpectrumTensor.gaussianGram5 σ
      = Matrix.of (fun i j =>
          arithmeticResidualFun σ
            (fun x => -PrimeSpectrumTensor.primeTerm x σ / 2)
            (fun x => PrimeSpectrumTensor.densityTerm x σ)
            (PrimeSpectrumTensor.centre5 i - PrimeSpectrumTensor.centre5 j)) := by
  ext i j
  have h := gaussianGramEntry_eq_residual
    (PrimeSpectrumTensor.centre5 i - PrimeSpectrumTensor.centre5 j) σ
  simpa [PrimeSpectrumTensor.gaussianGram5, PrimeSpectrumTensor.gaussianGramEntry] using h

theorem gaussianGram5_posSemidef :
    (PrimeSpectrumTensor.gaussianGram5 (1 / 20)).PosSemidef :=
  PrimeSpectrumTensor.gaussianGram5_posDef.posSemidef

theorem centre5Arithmetic_posSemidef :
    (Matrix.of (fun i j =>
      arithmeticResidualFun (1 / 20)
        (fun x => -PrimeSpectrumTensor.primeTerm x (1 / 20) / 2)
        (fun x => PrimeSpectrumTensor.densityTerm x (1 / 20))
        (PrimeSpectrumTensor.centre5 i - PrimeSpectrumTensor.centre5 j))).PosSemidef := by
  rw [← gaussianGram5_eq_arithmetic]
  exact gaussianGram5_posSemidef

/-- **General structure of the Gaussian Gram matrix.**  For any finite centre
family, the matrix is the sum of the pole, density and prime matrices, and it is
Hermitian.  This subsumes the 4×4 and 5×5 decompositions. -/
theorem gaussianGramMatrix_eq_pole_add_density_add_prime {ι : Type*} [Fintype ι]
    (c : ι → ℝ) (σ : ℝ) :
    Matrix.of (fun i j => PrimeSpectrumTensor.gaussianGramEntry (c i) (c j) σ)
      = Matrix.of (fun i j => PrimeSpectrumTensor.poleTerm (c i - c j) σ)
        + Matrix.of (fun i j => PrimeSpectrumTensor.densityTerm (c i - c j) σ)
        + Matrix.of (fun i j =>
            (PrimeSpectrumTensor.primeTerm (c i - c j) σ
              + PrimeSpectrumTensor.primeTerm (c j - c i) σ) / 2) := by
  ext i j
  rw [Matrix.add_apply, Matrix.add_apply]
  have h := gaussianGramEntry_three_term (c i - c j) σ
  have hneg : -(c i - c j) = c j - c i := by ring
  rw [hneg] at h
  simpa [PrimeSpectrumTensor.gaussianGramEntry] using h

theorem gaussianGramMatrix_isHermitian {ι : Type*} [Fintype ι]
    (c : ι → ℝ) (σ : ℝ) :
    (Matrix.of (fun i j => PrimeSpectrumTensor.gaussianGramEntry (c i) (c j) σ)).IsHermitian := by
  apply Matrix.IsHermitian.ext
  intro i j
  simp only [Matrix.of_apply, star_trivial]
  exact (PrimeSpectrumTensor.gaussianGramEntry_symm (c i) (c j) σ).symm

/-- **The explicit 5-centre quadratic form and its principal submatrices.**  The
three-term Gaussian quadratic form is non-negative at the five centres, and every
principal submatrix inherits PSD. -/
theorem gaussianGram5_quadraticForm_nonneg (x : Fin 5 → ℝ) :
    0 ≤ ∑ i, ∑ j, x i * x j *
      PrimeSpectrumTensor.gaussianGramEntry
        (PrimeSpectrumTensor.centre5 i) (PrimeSpectrumTensor.centre5 j) (1 / 20) := by
  have h := (Matrix.posSemidef_iff_dotProduct_mulVec.mp gaussianGram5_posSemidef).2 x
  have hq : star x ⬝ᵥ (PrimeSpectrumTensor.gaussianGram5 (1 / 20) *ᵥ x)
      = ∑ i, ∑ j, x i * x j *
          PrimeSpectrumTensor.gaussianGramEntry
            (PrimeSpectrumTensor.centre5 i) (PrimeSpectrumTensor.centre5 j) (1 / 20) := by
    simp only [dotProduct, Matrix.mulVec, PrimeSpectrumTensor.gaussianGram5,
      Matrix.of_apply, star_trivial, Finset.sum_mul, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    ring
  rwa [hq] at h

theorem gaussianGram5_submatrix_posSemidef {n : Type*} [Fintype n] [DecidableEq n]
    (e : n → Fin 5) :
    ((PrimeSpectrumTensor.gaussianGram5 (1 / 20)).submatrix e e).PosSemidef :=
  gaussianGram5_posSemidef.submatrix e

/-- **Translation and reflection invariance of the certified family.**  The
Gaussian Gram matrix depends only on the differences of the centres, so every
translate and every reflection of the certified 5-centre family is certified. -/
theorem gaussianGramMatrix_translate {ι : Type*} (c : ι → ℝ) (t σ : ℝ) :
    Matrix.of (fun i j => PrimeSpectrumTensor.gaussianGramEntry (c i + t) (c j + t) σ)
      = Matrix.of (fun i j => PrimeSpectrumTensor.gaussianGramEntry (c i) (c j) σ) := by
  ext i j
  simp only [Matrix.of_apply]
  unfold PrimeSpectrumTensor.gaussianGramEntry
  rw [show c i + t - (c j + t) = c i - c j by ring,
      show c j + t - (c i + t) = c j - c i by ring]

theorem gaussianGram5_translate_posSemidef (t : ℝ) :
    (Matrix.of (fun i j =>
      PrimeSpectrumTensor.gaussianGramEntry
        (PrimeSpectrumTensor.centre5 i + t) (PrimeSpectrumTensor.centre5 j + t) (1 / 20))).PosSemidef := by
  rw [gaussianGramMatrix_translate]
  exact gaussianGram5_posSemidef





open Complex AbsoluteHodgeSymbol AbsoluteHodgeExplicitFormula AbsoluteHodgeArchimedean MissingBridge
open scoped Matrix

theorem gaussianGramMatrix_reflect {ι : Type*} (c : ι → ℝ) (σ : ℝ) :
    Matrix.of (fun i j => PrimeSpectrumTensor.gaussianGramEntry (-(c i)) (-(c j)) σ)
      = Matrix.of (fun i j => PrimeSpectrumTensor.gaussianGramEntry (c i) (c j) σ) := by
  ext i j
  simp only [Matrix.of_apply]
  unfold PrimeSpectrumTensor.gaussianGramEntry
  rw [show -c i - -c j = c j - c i by ring,
      show -c j - -c i = c i - c j by ring]
  ring

theorem gaussianGram5_reflect_posSemidef :
    (Matrix.of (fun i j =>
      PrimeSpectrumTensor.gaussianGramEntry
        (-(PrimeSpectrumTensor.centre5 i)) (-(PrimeSpectrumTensor.centre5 j)) (1 / 20))).PosSemidef := by
  rw [gaussianGramMatrix_reflect]
  exact gaussianGram5_posSemidef

/-- **Translation and reflection of the 4-centre certificate.** -/
theorem gaussianGram4_translate_posSemidef (t : ℝ) :
    (Matrix.of (fun i j =>
      PrimeSpectrumTensor.gaussianGramEntry
        (PrimeSpectrumTensor.centre4 i + t) (PrimeSpectrumTensor.centre4 j + t) (1 / 20))).PosSemidef := by
  rw [gaussianGramMatrix_translate]
  exact gaussianGram4_posSemidef

theorem gaussianGram4_reflect_posSemidef :
    (Matrix.of (fun i j =>
      PrimeSpectrumTensor.gaussianGramEntry
        (-(PrimeSpectrumTensor.centre4 i)) (-(PrimeSpectrumTensor.centre4 j)) (1 / 20))).PosSemidef := by
  rw [gaussianGramMatrix_reflect]
  exact gaussianGram4_posSemidef

/-- **Concrete density-term signs at `σ = 1/20`.**  Positive at `c = 0`, negative
at `c = 1/5, 2/5, 3/5` (from the `prime-spectrum-tensor` enclosure bands). -/
theorem densityTerm_pos_at_zero : 0 < PrimeSpectrumTensor.densityTerm 0 (1 / 20) := by
  have h := PrimeSpectrumTensor.densityTerm_mem_c0
  rw [Set.mem_Icc] at h
  linarith [h.1]

theorem densityTerm_neg_at_fifth : PrimeSpectrumTensor.densityTerm (1 / 5) (1 / 20) < 0 := by
  have h := PrimeSpectrumTensor.densityTerm_mem_c1
  rw [Set.mem_Icc] at h
  linarith [h.2]

theorem densityTerm_neg_at_two_fifths : PrimeSpectrumTensor.densityTerm (2 / 5) (1 / 20) < 0 := by
  have h := PrimeSpectrumTensor.densityTerm_mem_c2
  rw [Set.mem_Icc] at h
  linarith [h.2]

theorem densityTerm_neg_at_three_fifths : PrimeSpectrumTensor.densityTerm (3 / 5) (1 / 20) < 0 := by
  have h := PrimeSpectrumTensor.densityTerm_mem_c3
  rw [Set.mem_Icc] at h
  linarith [h.2]

/-- **The explicit 4-centre quadratic form.** -/
theorem gaussianGram4_quadraticForm_nonneg (x : Fin 4 → ℝ) :
    0 ≤ ∑ i, ∑ j, x i * x j *
      PrimeSpectrumTensor.gaussianGramEntry
        (PrimeSpectrumTensor.centre4 i) (PrimeSpectrumTensor.centre4 j) (1 / 20) := by
  have h := (Matrix.posSemidef_iff_dotProduct_mulVec.mp gaussianGram4_posSemidef).2 x
  have hq : star x ⬝ᵥ (PrimeSpectrumTensor.gaussianGram4 (1 / 20) *ᵥ x)
      = ∑ i, ∑ j, x i * x j *
          PrimeSpectrumTensor.gaussianGramEntry
            (PrimeSpectrumTensor.centre4 i) (PrimeSpectrumTensor.centre4 j) (1 / 20) := by
    simp only [dotProduct, Matrix.mulVec, PrimeSpectrumTensor.gaussianGram4,
      Matrix.of_apply, star_trivial, Finset.sum_mul, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro i _
    apply Finset.sum_congr rfl
    intro j _
    ring
  rwa [hq] at h

/-- The density term at `c = 4/5` is negative. -/
theorem densityTerm_neg_at_four_fifths : PrimeSpectrumTensor.densityTerm (4 / 5) (1 / 20) < 0 := by
  have h := PrimeSpectrumTensor.densityTerm_mem_c4
  rw [Set.mem_Icc] at h
  linarith [h.2]

/-! ## The bridge, first-class

The following theorems package the Gaussian bridge: the zero-side quadratic
form equals the Gaussian-Gram quadratic form (under the Gaussian explicit
formula), and `FiniteWeilPositivity` / RH follow from that formula plus PSD of
the Gaussian Gram matrix.  The two hypotheses are the *only* inputs; neither is
archimedean dominance. -/

theorem weilQuadraticForm_eq_gaussianGram {ι : Type*} [Fintype ι] (a : ι → ℝ) (σ : ℝ)
    (S : Finset ℂ) (x : ι → ℝ)
    (hformula : ∀ c, scalarZeroSide σ S c = gaussianGramEntry c 0 σ) :
    weilQuadraticForm a σ S x
      = ∑ i, ∑ j, x i * x j * gaussianGramEntry (a i - a j) 0 σ :=
  weilQuadraticForm_eq_arithmetic a σ S x (fun c => gaussianGramEntry c 0 σ) hformula

theorem finiteWeilPositivity_iff_RH :
    FiniteWeilPositivity ↔ AbsoluteHodgeSymbol.RiemannHypothesis :=
  ⟨finiteWeilPositivity_implies_RH, rh_implies_finiteWeilPositivity⟩

theorem finiteWeilPositivity_of_gaussianGram
    (hformula : ∀ (σ : ℝ) (S : Finset ℂ) (c : ℝ),
      (∀ ρ ∈ S, completedZeta ρ = 0) → (∀ ρ ∈ S, 0 < ρ.re) → (∀ ρ ∈ S, ρ.re < 1) →
      scalarZeroSide σ S c = gaussianGramEntry c 0 σ)
    (hPSD : ∀ (σ : ℝ) (ι : Type) [Fintype ι] (a : ι → ℝ),
      (Matrix.of (fun i j => gaussianGramEntry (a i - a j) 0 σ)).PosSemidef) :
    FiniteWeilPositivity :=
  finiteWeilPositivity_of_arithmetic (fun σ c => gaussianGramEntry c 0 σ) hformula hPSD

theorem riemannHypothesis_of_gaussianGram
    (hformula : ∀ (σ : ℝ) (S : Finset ℂ) (c : ℝ),
      (∀ ρ ∈ S, completedZeta ρ = 0) → (∀ ρ ∈ S, 0 < ρ.re) → (∀ ρ ∈ S, ρ.re < 1) →
      scalarZeroSide σ S c = gaussianGramEntry c 0 σ)
    (hPSD : ∀ (σ : ℝ) (ι : Type) [Fintype ι] (a : ι → ℝ),
      (Matrix.of (fun i j => gaussianGramEntry (a i - a j) 0 σ)).PosSemidef) :
    AbsoluteHodgeSymbol.RiemannHypothesis :=
  finiteWeilPositivity_implies_RH (finiteWeilPositivity_of_gaussianGram hformula hPSD)

/-! ## T86 in three-term form, and the two named bridge inputs -/

/-- **T86, three-term form:** the Gaussian Gram entry is the pole term plus the
density term plus the symmetrised prime term. -/
theorem gaussianGramEntry_eq_pole_add_density_add_primeSym (a b σ : ℝ) :
    PrimeSpectrumTensor.gaussianGramEntry a b σ
      = PrimeSpectrumTensor.poleTerm (a - b) σ
        + PrimeSpectrumTensor.densityTerm (a - b) σ
        + PrimeSpectrumTensor.primeTermSym (a - b) σ :=
  PrimeSpectrumTensor.gaussianGramEntry_eq a b σ

/-- **Named input 1 — the Gaussian explicit formula.**  The zero-side scalar
sum equals the Gaussian Gram entry.  This is the only zero-side analytic input
of the bridge. -/
def GaussianExplicitFormula : Prop :=
  ∀ (σ : ℝ) (S : Finset ℂ) (c : ℝ),
    (∀ ρ ∈ S, completedZeta ρ = 0) → (∀ ρ ∈ S, 0 < ρ.re) → (∀ ρ ∈ S, ρ.re < 1) →
    scalarZeroSide σ S c = PrimeSpectrumTensor.gaussianGramEntry c 0 σ

/-- **Named input 2 — PSD of the Gaussian Gram matrix.**  Every finite Gaussian
family has a positive-semidefinite Gram matrix.  This is the only positivity
input of the bridge (and the genuinely open one). -/
def GaussianGramPSD : Prop :=
  ∀ (σ : ℝ) (ι : Type) [Fintype ι] (a : ι → ℝ),
    (Matrix.of (fun i j =>
      PrimeSpectrumTensor.gaussianGramEntry (a i - a j) 0 σ)).PosSemidef

/-- **The bridge, positivity form, with named inputs.** -/
theorem finiteWeilPositivity_of_gaussianInputs
    (h1 : GaussianExplicitFormula) (h2 : GaussianGramPSD) :
    FiniteWeilPositivity :=
  finiteWeilPositivity_of_arithmetic
    (fun σ c => PrimeSpectrumTensor.gaussianGramEntry c 0 σ) h1 h2

/-- **The bridge, RH form, with named inputs.**  Conditional: the two inputs
are not proved. -/
theorem riemannHypothesis_of_gaussianInputs
    (h1 : GaussianExplicitFormula) (h2 : GaussianGramPSD) :
    AbsoluteHodgeSymbol.RiemannHypothesis :=
  finiteWeilPositivity_implies_RH (finiteWeilPositivity_of_gaussianInputs h1 h2)

/-! ## Correctness of the bridge inputs: the finite formula is vacuous

The finite-`S` identity used by T79/T116 is **not** the explicit formula: at
`S = ∅` it forces the arithmetic side to vanish.  The genuine input is the
infinite-sum identity `GaussianExplicitFormulaInfinite`. -/

/-- **The finite-`S` formula is vacuous.**  If `scalarZeroSide σ S c = g c` is
assumed for *every* finite set `S` of zeros in the strip, then `S = ∅` forces
`g ≡ 0`.  Hence the finite formula cannot be the explicit formula; the genuine
input is the infinite-sum (tsum) identity. -/
theorem finiteFormula_forces_zero {σ : ℝ} (g : ℝ → ℝ)
    (hformula : ∀ (S : Finset ℂ) (c : ℝ),
      (∀ ρ ∈ S, completedZeta ρ = 0) → (∀ ρ ∈ S, 0 < ρ.re) → (∀ ρ ∈ S, ρ.re < 1) →
      scalarZeroSide σ S c = g c) :
    ∀ c, g c = 0 := by
  intro c
  have h := hformula ∅ c (by simp) (by simp) (by simp)
  simpa [scalarZeroSide] using h.symm

/-- The genuine explicit formula: the infinite sum over all nontrivial zeros in
the critical strip equals the Gaussian Gram entry. -/
def GaussianExplicitFormulaInfinite : Prop :=
  ∀ (σ c : ℝ),
    HasSum (fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
      (gaussianZeroTest c σ ρ).re) (gaussianGramEntry c 0 σ)

/-! ## PSD is closed under pointwise limits -/

variable {n : Type*} [Fintype n]

/-- The quadratic form of a real matrix is continuous in the matrix. -/
theorem continuous_matrix_quadraticForm (x : n → ℝ) :
    Continuous (fun M : Matrix n n ℝ => star x ⬝ᵥ (M *ᵥ x)) := by
  simp only [dotProduct, mulVec, star_trivial]
  fun_prop

/-- **Positive semidefiniteness is a closed condition.** -/
theorem isClosed_setOf_posSemidef :
    IsClosed {M : Matrix n n ℝ | M.PosSemidef} := by
  have hset : {M : Matrix n n ℝ | M.PosSemidef} =
      {M | M.IsHermitian} ∩ ⋂ x : n → ℝ, {M | 0 ≤ star x ⬝ᵥ (M *ᵥ x)} := by
    ext M
    simp only [Set.mem_setOf_eq, Set.mem_inter_iff, Set.mem_iInter,
      Matrix.posSemidef_iff_dotProduct_mulVec]
  rw [hset]
  refine IsClosed.inter ?_ (isClosed_iInter fun x =>
    isClosed_le continuous_const (continuous_matrix_quadraticForm x))
  have hHerm : {M : Matrix n n ℝ | M.IsHermitian} = {M | Mᴴ = M} := rfl
  rw [hHerm]
  exact isClosed_eq continuous_id.matrix_transpose continuous_id

/-- **PSD passes to limits.** -/
theorem posSemidef_of_tendsto {ι : Type*} {F : Filter ι} [F.NeBot]
    {f : ι → Matrix n n ℝ} {M : Matrix n n ℝ}
    (hf : Filter.Tendsto f F (nhds M)) (h : ∀ i, (f i).PosSemidef) :
    M.PosSemidef :=
  isClosed_setOf_posSemidef.mem_of_tendsto hf (Filter.Eventually.of_forall h)

/-! ## The corrected bridge, with the infinite explicit formula -/

/-- The corrected bridge: `FiniteWeilPositivity` plus the infinite explicit
formula imply PSD of the Gaussian Gram matrix. -/
theorem gaussianGramPSD_of_finiteWeilPositivity
    (hFWP : FiniteWeilPositivity) (hEF : GaussianExplicitFormulaInfinite) :
    GaussianGramPSD := by
  classical
  intro σ ι _ a
  let Z := {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}
  let M : Finset Z → Matrix ι ι ℝ := fun T =>
    Matrix.of (fun i j => ∑ ρ ∈ T, (gaussianZeroTest (a i - a j) σ ρ).re)
  have hM_psd : ∀ T, (M T).PosSemidef := by
    intro T
    have hS : ∀ ρ ∈ T.image (Subtype.val : Z → ℂ),
        completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1 := by
      intro ρ hρ
      obtain ⟨ρ', _, rfl⟩ := Finset.mem_image.mp hρ
      exact ρ'.2
    have h := hFWP ι a σ (T.image Subtype.val)
      (fun ρ hρ => (hS ρ hρ).1) (fun ρ hρ => (hS ρ hρ).2.1) (fun ρ hρ => (hS ρ hρ).2.2)
    convert h using 1
    ext i j
    simp only [M, finiteWeilGramReal, Matrix.of_apply]
    rw [Finset.sum_image]
    intro x _ y _ hxy
    exact Subtype.ext hxy
  have h_tendsto : Filter.Tendsto M (SummationFilter.unconditional Z).filter
      (nhds (Matrix.of (fun i j => gaussianGramEntry (a i - a j) 0 σ))) := by
    change Filter.Tendsto (fun T : Finset Z => fun i : ι => fun j : ι => M T i j)
      (SummationFilter.unconditional Z).filter
      (nhds (fun i : ι => fun j : ι => gaussianGramEntry (a i - a j) 0 σ))
    rw [tendsto_pi_nhds]
    intro i
    rw [tendsto_pi_nhds]
    intro j
    change Filter.Tendsto (fun T : Finset Z =>
      ∑ ρ ∈ T, (gaussianZeroTest (a i - a j) σ ρ).re)
      (SummationFilter.unconditional Z).filter
      (nhds (gaussianGramEntry (a i - a j) 0 σ))
    exact hEF σ (a i - a j)
  exact posSemidef_of_tendsto h_tendsto hM_psd

/-- Under the infinite explicit formula, RH implies PSD of the Gaussian Gram
matrix — the corrected necessary direction of the bridge. -/
theorem gaussianGramPSD_of_RH (hEF : GaussianExplicitFormulaInfinite)
    (h : AbsoluteHodgeSymbol.RiemannHypothesis) : GaussianGramPSD :=
  gaussianGramPSD_of_finiteWeilPositivity
    (rh_implies_finiteWeilPositivity h) hEF

/-! ## The packaged Gaussian bridge -/

/-- **The Gaussian bridge, packaged.**  Under the infinite explicit formula:
the zero-side equivalence holds, finite Weil positivity implies PSD of the
Gaussian Gram matrix, and RH implies PSD of the Gaussian Gram matrix. -/
theorem gaussianBridge_summary (hEF : GaussianExplicitFormulaInfinite) :
    (FiniteWeilPositivity ↔ AbsoluteHodgeSymbol.RiemannHypothesis) ∧
      (FiniteWeilPositivity → GaussianGramPSD) ∧
      (AbsoluteHodgeSymbol.RiemannHypothesis → GaussianGramPSD) :=
  ⟨finiteWeilPositivity_iff_RH,
   fun h => gaussianGramPSD_of_finiteWeilPositivity h hEF,
   fun h => gaussianGramPSD_of_RH hEF h⟩

/-! ## Assembling the Gaussian explicit formula

The algebraic assembly is formal: from the contour/rectangle identity in
archimedean/prime form, the zero sum is
`H_c(0) + H_c(1) − (ArchR+PrimeR+ArchL+PrimeL)/(2π)`, and its real part is the
Gaussian Gram entry once the vertical-limit identification is supplied.  The
analytic inputs (the identification itself, the four contour limits, and the
zero-sum convergence/enumeration) are named here and remain open. -/

/-- The vertical-limit identification: the real part of the right/left
archimedean-plus-prime limits is `−2π` times the density-plus-symmetrised-prime
terms.  This is the prime/archimedean evaluation that the contour file leaves
open. -/
def VerticalLimitIdentification (c σ : ℝ) (ArchR PrimeR ArchL PrimeL : ℂ) : Prop :=
  (ArchR + PrimeR + ArchL + PrimeL).re =
    -2 * Real.pi * (densityTerm c σ + primeTermSym c σ)

/-- **The assembly identity, algebraically.** -/
theorem gaussianZeroSum_eq {c σ : ℝ} {Zsum ArchR PrimeR ArchL PrimeL : ℂ}
    (hassemble : (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
        (2 * (Real.pi : ℂ) * I) =
      I * (-ArchR - PrimeR) - I * (ArchL + PrimeL)) :
    Zsum = gaussianZeroTest c σ 0 + gaussianZeroTest c σ 1 -
      (ArchR + PrimeR + ArchL + PrimeL) / (2 * (Real.pi : ℂ)) := by
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have h2pii : (2 * (Real.pi : ℂ) * I) ≠ 0 := by
    simp [hpi, Complex.I_ne_zero]
  have h' : (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
      (2 * (Real.pi : ℂ) * I) = -(I * (ArchR + PrimeR + ArchL + PrimeL)) := by
    rw [hassemble]
    ring
  have h2 : Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1 =
      -(I * (ArchR + PrimeR + ArchL + PrimeL)) * (2 * (Real.pi : ℂ) * I)⁻¹ := by
    calc Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1
        = ((Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
            (2 * (Real.pi : ℂ) * I)) * (2 * (Real.pi : ℂ) * I)⁻¹ := by
            rw [mul_assoc, mul_inv_cancel₀ h2pii, mul_one]
      _ = (-(I * (ArchR + PrimeR + ArchL + PrimeL))) *
            (2 * (Real.pi : ℂ) * I)⁻¹ := by rw [h']
  have hkey : (-(I * (ArchR + PrimeR + ArchL + PrimeL))) *
      (2 * (Real.pi : ℂ) * I)⁻¹ =
      -(ArchR + PrimeR + ArchL + PrimeL) / (2 * (Real.pi : ℂ)) := by
    field_simp
  rw [hkey] at h2
  linear_combination h2

/-- **Assembly, real form.**  Given the assembled explicit formula and the
vertical-limit identification, the real part of the zero sum is exactly the
Gaussian Gram entry. -/
theorem gaussianZeroSum_re_eq_gram {c σ : ℝ} {Zsum ArchR PrimeR ArchL PrimeL : ℂ}
    (hassemble : (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
        (2 * (Real.pi : ℂ) * I) =
      I * (-ArchR - PrimeR) - I * (ArchL + PrimeL))
    (hident : VerticalLimitIdentification c σ ArchR PrimeR ArchL PrimeL)
    (hpole : (gaussianZeroTest c σ 0 + gaussianZeroTest c σ 1).re =
      PrimeSpectrumTensor.poleTerm c σ) :
    Zsum.re = gaussianGramEntry c 0 σ := by
  have hZ := congrArg Complex.re (gaussianZeroSum_eq hassemble)
  have hdiv : ((ArchR + PrimeR + ArchL + PrimeL) / (2 * (Real.pi : ℂ))).re =
      (ArchR + PrimeR + ArchL + PrimeL).re / (2 * Real.pi) := by
    rw [Complex.div_re]
    simp [Complex.ofReal_re, Complex.ofReal_im, Complex.normSq]
    field_simp
  have hpole' : (gaussianZeroTest c σ 0).re + (gaussianZeroTest c σ 1).re =
      PrimeSpectrumTensor.poleTerm c σ := by
    rw [← Complex.add_re]
    exact hpole
  have hrhs : (gaussianZeroTest c σ 0 + gaussianZeroTest c σ 1 -
      (ArchR + PrimeR + ArchL + PrimeL) / (2 * (Real.pi : ℂ))).re =
      PrimeSpectrumTensor.poleTerm c σ + densityTerm c σ + primeTermSym c σ := by
    rw [Complex.sub_re, Complex.add_re, hdiv, hpole', hident]
    have hsimp : -2 * Real.pi * (densityTerm c σ + primeTermSym c σ) / (2 * Real.pi) =
        -(densityTerm c σ + primeTermSym c σ) := by
      field_simp
    rw [hsimp]
    ring
  rw [hZ, hrhs, gaussianGramEntry_eq_pole_add_density_add_primeSym]
  norm_num

/-! ## From the assembly data to the infinite explicit formula -/

/-- **The named assembly data.**  For every `σ, c` there are contour limit
values `ArchR, PrimeR, ArchL, PrimeL` and a zero-sum value `Zsum` such that the
assembled explicit formula holds, the vertical limits identify with the
arithmetic terms, and the zero sum is a `HasSum` over all nontrivial zeros in
the strip.  This bundles the three open analytic inputs. -/
def GaussianZeroSumAssembly : Prop :=
  ∀ (σ c : ℝ), ∃ (Zsum ArchR PrimeR ArchL PrimeL : ℂ),
    (Zsum - gaussianZeroTest c σ 0 - gaussianZeroTest c σ 1) *
        (2 * (Real.pi : ℂ) * I) =
      I * (-ArchR - PrimeR) - I * (ArchL + PrimeL) ∧
    VerticalLimitIdentification c σ ArchR PrimeR ArchL PrimeL ∧
    HasSum (fun ρ : {ρ : ℂ // completedZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
      (gaussianZeroTest c σ ρ).re) Zsum.re

/-- **Assembly gives the infinite explicit formula**, conditionally on the
named assembly data. -/
theorem gaussianExplicitFormulaInfinite_of_assembly
    (h : GaussianZeroSumAssembly) : GaussianExplicitFormulaInfinite := by
  intro σ c
  obtain ⟨Zsum, ArchR, PrimeR, ArchL, PrimeL, hassemble, hident, hsum⟩ := h σ c
  have hpole : (gaussianZeroTest c σ 0 + gaussianZeroTest c σ 1).re =
      PrimeSpectrumTensor.poleTerm c σ := by
    rw [show PrimeSpectrumTensor.poleTerm c σ = MissingBridge.poleTerm c σ from rfl]
    exact (poleTerm_eq_re_gaussianZeroTest_pole_sum c σ).symm
  have hval : Zsum.re = gaussianGramEntry c 0 σ :=
    gaussianZeroSum_re_eq_gram hassemble hident hpole
  rwa [hval] at hsum

/-! ## Concrete vertical limits

The four contour limit values of the assembled formula are reduced to the
archimedean and prime vertical integrals at `Re s = 2`: the right side is
`−(archRight + primeRight)`, and the left side is obtained from the reflected
test `H_{−c}` by the functional equation. -/

/-- The right-side archimedean vertical integral at `Re s = 2`. -/
def archRight (c σ : ℝ) (T : ℝ) : ℂ :=
  ∫ y : ℝ in (-T)..T,
    ((1 / 2) * log (Real.pi : ℂ) - (1 / 2) * digamma ((2 + y * I) / 2))
      * gaussianZeroTest c σ (2 + y * I)

/-- The right-side prime (von Mangoldt L-series) vertical integral at `Re s = 2`. -/
def primeRight (c σ : ℝ) (T : ℝ) : ℂ :=
  ∫ y : ℝ in (-T)..T,
    LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) (2 + y * I)
      * gaussianZeroTest c σ (2 + y * I)

/-- The right vertical integral (without the `I` factor) is minus the sum of the
archimedean and prime halves. -/
theorem right_integral_eq (c σ T : ℝ) :
    (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (2 + y * I) * gaussianZeroTest c σ (2 + y * I))
      = -(archRight c σ T + primeRight c σ T) := by
  set J : ℂ := ∫ y : ℝ in (-T)..T,
    logDeriv completedZeta (2 + y * I) * gaussianZeroTest c σ (2 + y * I)
  set A : ℂ := archRight c σ T
  set P : ℂ := primeRight c σ T
  have hmain : J * I = -(A * I) - (P * I) := by
    rw [← intervalIntegral.integral_mul_const]
    simpa [J, A, P, archRight, primeRight] using
      integral_logDeriv_gaussianZeroTest_right_side' c σ 2 (-T) T (by norm_num)
  have h1 : -(A * I) - (P * I) = (-(A + P)) * I := by ring
  rw [h1] at hmain
  have hcancel : J = -(A + P) := by
    exact mul_right_cancel₀ Complex.I_ne_zero hmain
  simpa [J, A, P] using hcancel

/-- Right vertical limit from the two concrete halves. -/
theorem tendsto_right {c σ : ℝ} {A P : ℂ}
    (hA : Filter.Tendsto (archRight c σ) atTop (nhds A))
    (hP : Filter.Tendsto (primeRight c σ) atTop (nhds P)) :
    Filter.Tendsto (fun T => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (2 + y * I) * gaussianZeroTest c σ (2 + y * I))
      atTop (nhds (-A - P)) := by
  have h : Filter.Tendsto (fun T => archRight c σ T + primeRight c σ T) atTop (nhds (A + P)) :=
    hA.add hP
  have hneg : Filter.Tendsto (fun T => -(archRight c σ T + primeRight c σ T)) atTop (nhds (-(A + P))) :=
    h.neg
  have h'A : (-(A + P) : ℂ) = -A - P := by ring
  rw [h'A] at hneg
  exact hneg.congr' (Filter.Eventually.of_forall fun T => (right_integral_eq c σ T).symm)

/-- Left vertical limit derived from the right limits of the reflected test
`H_{−c}` (via the functional equation). -/
theorem tendsto_left {c σ : ℝ} {A P : ℂ}
    (hA : Filter.Tendsto (archRight (-c) σ) atTop (nhds A))
    (hP : Filter.Tendsto (primeRight (-c) σ) atTop (nhds P)) :
    Filter.Tendsto (fun T => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((-1 : ℂ) + y * I) * gaussianZeroTest c σ ((-1 : ℂ) + y * I))
      atTop (nhds (A + P)) := by
  have hright := tendsto_right (c := -c) (σ := σ) hA hP
  have hAP : (-A - P : ℂ) = -(A + P) := by ring
  rw [hAP] at hright
  have hrightI : Filter.Tendsto (fun T => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (2 + y * I) * gaussianZeroTest (-c) σ (2 + y * I) * I)
      atTop (nhds ((-(A + P)) * I)) := by
    have hmul := hright.mul_const I
    refine hmul.congr' (Filter.Eventually.of_forall fun T => ?_)
    dsimp only
    rw [intervalIntegral.integral_mul_const]
  have hneg := hrightI.neg
  have hleftI : Filter.Tendsto (fun T => ∫ y : ℝ in (-T)..T,
      logDeriv completedZeta ((-1 : ℂ) + y * I) * gaussianZeroTest c σ ((-1 : ℂ) + y * I) * I)
      atTop (nhds ((A + P) * I)) := by
    have hval : -((-(A + P)) * I) = (A + P) * I := by ring
    rw [hval] at hneg
    refine hneg.congr' (Filter.Eventually.of_forall fun T => ?_)
    dsimp only
    exact (integral_logDeriv_gaussianZeroTest_left_eq_neg_right c σ T).symm
  have hII : (I : ℂ) * (-I) = 1 := by simp [Complex.I_mul_I]
  have hmul := hleftI.mul_const (-I)
  have hval : ((A + P) * I) * (-I) = A + P := by
    calc ((A + P) * I) * (-I) = (A + P) * (I * (-I)) := by ring
      _ = (A + P) * 1 := by rw [hII]
      _ = A + P := by ring
  rw [hval] at hmul
  refine hmul.congr' (Filter.Eventually.of_forall fun T => ?_)
  dsimp only
  rw [intervalIntegral.integral_mul_const, mul_assoc, hII, mul_one]

/-! ## Enumeration: cofinal chains and the unconditional sum -/

/-- **Cofinal-chain lemma.** -/
theorem hasSum_of_cofinal {ι : Type*} {α : Type*} [NormedAddCommGroup α] [CompleteSpace α]
    {f : ι → α} (S : ℕ → Finset ι)
    (hmono : Monotone S) (hcover : ∀ i, ∃ n, i ∈ S n) (hsum : Summable f) {z : α}
    (h : Filter.Tendsto (fun n => ∑ i ∈ S n, f i) Filter.atTop (nhds z)) :
    HasSum f z := by
  classical
  have hg : Filter.Tendsto (fun s : Finset ι => ∑ i ∈ s, f i) Filter.atTop (nhds (∑' i : ι, f i)) :=
    hsum.hasSum
  have hfinite : ∀ t : Finset ι, ∃ N, ∀ i ∈ t, i ∈ S N := by
    intro t
    induction t using Finset.induction_on with
    | empty => exact ⟨0, by simp⟩
    | insert a s _ ih =>
        obtain ⟨N1, h1⟩ := ih
        obtain ⟨N2, h2⟩ := hcover a
        refine ⟨max N1 N2, ?_⟩
        intro i hi
        rcases Finset.mem_insert.mp hi with rfl | hi'
        · exact hmono (le_max_right _ _) h2
        · exact hmono (le_max_left _ _) (h1 i hi')
  have hS : Filter.Tendsto S Filter.atTop Filter.atTop := by
    rw [Filter.tendsto_atTop]
    intro t
    obtain ⟨N, hN⟩ := hfinite t
    exact Filter.eventually_atTop.mpr ⟨N, fun m hm i hi => hmono hm (hN i hi)⟩
  have hcomp : Filter.Tendsto (fun n => ∑ i ∈ S n, f i) Filter.atTop (nhds (∑' i : ι, f i)) :=
    hg.comp hS
  have hz : z = ∑' i : ι, f i := tendsto_nhds_unique h hcomp
  rw [hz]
  exact hsum.hasSum

/-! ## Decomposing the vertical-limit identification -/

/-- **The vertical-limit identification, decomposed.**  It suffices to identify
the archimedean and prime limit values separately with `densityTerm` and
`primeTermSym`: then the combined identification holds. -/
theorem verticalLimitIdentification_of_limits {c σ : ℝ} {A P A' P' : ℂ}
    (hA : A.re + A'.re = -2 * Real.pi * densityTerm c σ)
    (hP : P.re + P'.re = -2 * Real.pi * primeTermSym c σ) :
    VerticalLimitIdentification c σ A P A' P' := by
  unfold VerticalLimitIdentification
  rw [Complex.add_re, Complex.add_re, Complex.add_re]
  linarith

end MissingBridge
