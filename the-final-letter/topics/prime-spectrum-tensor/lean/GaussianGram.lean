import Mathlib
import Transfer

/-!
# W4 (assembly) — the exact Gaussian Weil Gram matrix and its reduction

This file fixes the **exact** objects of
[`../../WEIL-GRAM.md`](../../WEIL-GRAM.md) §0–2 in Lean and assembles them
against the W1 transfer certificate of [`Transfer.lean`](Transfer.lean).

## What is defined

For `σ > 0` and a centre `c = a − b`:

* `omega t = Re ψ(1/4 + it/2) − log π`, the archimedean density;
* `poleTerm c σ = 4πσ² exp(σ²/4) cosh(c/2)`, the pole term;
* `densityTerm c σ = σ² ∫ exp(−σ²t²) cos(ct) Ω(t) dt`, the archimedean term;
* `primeTerm c σ = −2 Σ_{p^m} (log p)/p^{m/2} h_c(log p^m)` with
  `h_c(v) = √π σ exp(−(v−c)²/(4σ²))`, the prime term;
* `gaussianGramEntry a b σ = (W(a−b) + W(b−a))/2` with `W = pole + density +
  prime`, and `gaussianGram4 σ` on the centres `−0.3, −0.1, 0.1, 0.3`.

## What is proved

Only the *structural* part:

* `gaussianGram4_symm`: the Gram matrix is symmetric (the symmetrisation
  `(W(c) + W(−c))/2` is exactly what makes this true);
* `gaussianGram4_posDef_of_entry_bound`: **if** every entry is within `ε` of
  the W1 rational centre `gramCentre4`, with `4ε < 0.0227`, **then** the exact
  Gram matrix is positive definite.

## What is *not* proved — and why the file exists

The hypothesis `∀ i j, |gaussianGram4 (1/20) i j − gramCentre4 i j| ≤ ε` is
**not** proved here, and it is the entire remaining content of O4.  It splits
into:

* **W2** — a rational-interval enclosure of `Ω(t) = Re ψ(1/4+it/2) − log π`
  on the `t`-range that carries the Gaussian;
* **W3** — rigorous quadrature of `densityTerm` (and the elementary enclosures
  of `poleTerm` and `primeTerm`), with a total entry error below `0.005675`.

The precise route for W2, the closed-form value of the constant part, the tail
bound, and the remaining Mathlib gap are recorded in
[`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md).  Nothing here asserts the Riemann
hypothesis, the infinite Weil cone, or positivity beyond the single 4×4
matrix.
-/

noncomputable section

open scoped BigOperators
open MeasureTheory

namespace PrimeSpectrumTensor

/-! ## The archimedean density -/

/-- `Ω(t) = Re ψ(1/4 + it/2) − log π`, the archimedean density of
`WEIL-GRAM.md` §2. -/
def omega (t : ℝ) : ℝ :=
  (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)).re - Real.log Real.pi

/-! ## The three terms of one Gram entry -/

/-- The pole/archimedean term `4πσ² exp(σ²/4) cosh(c/2)` for a Gaussian
centred at `c`. -/
def poleTerm (c σ : ℝ) : ℝ :=
  4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.cosh (c / 2)

/-- The archimedean density term `σ² ∫ exp(−σ²t²) cos(ct) Ω(t) dt`. -/
def densityTerm (c σ : ℝ) : ℝ :=
  σ ^ 2 * ∫ t : ℝ, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * omega t

/-- The Gaussian `h_c(v) = √π σ exp(−(v−c)²/(4σ²))` of `WEIL-GRAM.md` §1. -/
def gaussianBump (c σ v : ℝ) : ℝ :=
  Real.sqrt Real.pi * σ * Real.exp (-((v - c) ^ 2) / (4 * σ ^ 2))

/-- The prime term `−2 Σ_n Λ(n)/√n · h_c(log n)` of `WEIL-GRAM.md` §2. -/
def primeTerm (c σ : ℝ) : ℝ :=
  -2 * ∑' n : ℕ, ArithmeticFunction.vonMangoldt n / Real.sqrt n * gaussianBump c σ (Real.log n)

/-- `W(h_c) = pole + density + prime` for the Gaussian centred at `c`. -/
def gaussianW (c σ : ℝ) : ℝ :=
  poleTerm c σ + densityTerm c σ + primeTerm c σ

/-- One Gram entry, symmetrised over `±c`: `(W(c) + W(−c))/2`. -/
def gaussianGramEntry (a b σ : ℝ) : ℝ :=
  (gaussianW (a - b) σ + gaussianW (b - a) σ) / 2

/-! ## The 4×4 matrix -/

/-- The four centres `−0.3, −0.1, 0.1, 0.3`. -/
def centre4 : Fin 4 → ℝ := ![-3 / 10, -1 / 10, 1 / 10, 3 / 10]

/-- The exact `4 × 4` Gaussian Weil Gram matrix at width `σ`. -/
def gaussianGram4 (σ : ℝ) : Matrix (Fin 4) (Fin 4) ℝ :=
  Matrix.of fun i j => gaussianGramEntry (centre4 i) (centre4 j) σ

/-! ## Structure -/

theorem gaussianGramEntry_symm (a b σ : ℝ) :
    gaussianGramEntry a b σ = gaussianGramEntry b a σ := by
  unfold gaussianGramEntry
  rw [sub_eq_add_neg, sub_eq_add_neg]
  ring_nf

theorem gaussianGram4_symm (σ : ℝ) (i j : Fin 4) :
    gaussianGram4 σ i j = gaussianGram4 σ j i :=
  gaussianGramEntry_symm _ _ _

/-! ## The assembly: W4 given W2/W3 -/

/-- **The assembly step.**

If every entry of the exact Gram matrix is within `ε` of the W1 rational
centre, and `4ε < 0.0227`, then the exact matrix is positive definite.

The hypothesis is exactly the output required from W2 (the `Ω` enclosure) and
W3 (the quadrature); it is not proved here. -/
theorem gaussianGram4_posDef_of_enclosure {σ ε : ℝ}
    (hε : ∀ i j, |gaussianGram4 σ i j - gramCentre4 i j| ≤ ε)
    (hε0 : 0 ≤ ε)
    (hdim : ε * 4 < gramMargin) :
    (gaussianGram4 σ).PosDef :=
  gaussianGram4_posDef_of_entry_bound (gaussianGram4_symm σ) hε hε0 hdim

end PrimeSpectrumTensor
