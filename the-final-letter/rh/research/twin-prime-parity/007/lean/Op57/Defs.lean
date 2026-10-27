/-
  Op57/Defs.lean — the objects of structural generalisation #6.

  Handoff `research/twin-prime-parity/006/handoff.md` §11, item 6:

      "Dirichlet L-functions.  Replace the parity sieve by a character sum,
       a_k = χ(k) k^{−p}, and study the twisted threshold function
       Φ_χ(p,n) = n^p Σ_{j≥0} χ(n+j+1)(n+j+1)^{−p}.  The interesting question
       is how much of the OP-5 second-order expansion survives when χ is
       non-principal."

  The programme's "parity sieve" is the alphabet `a_k = (2k)^{-p}`, i.e. the
  coefficient sequence `c m = 1_{2 | m}`.  Replacing it by a character sum means
  replacing `c` by a periodic coefficient (a Dirichlet character, a residue-class
  indicator, or the principal character), which is what this file sets up.

  ## The replacement, in one line

  For any coefficient sequence `c : ℕ → ℝ` the fundamental identity is

      n^p Σ_{m>n} c(m) m^{−p}  =  Σ_{j≥1} c(n+j) (1 + j/n)^{−p} ,

  so the boundary functional is a *character-weighted geometric sum* in the
  variable `x = e^{−a}`, `a = p/n`:

      Φ_c(p,n)  ⟶  F_{n mod q}(x),      F_r(x) = Σ_{j≥1} c(r+j) x^j .

  In OP-5 (`c ≡ 1`, `q = 1`) the leading equation `F_0(x) = x/(1−x) = 1` is
  forced to have the unique root `x = 1/2`, i.e. `a = log 2`; that is
  `Op56.leadingCoeff_forced`.  The theorems in `Op57/Leading.lean` are the
  analogues of that anchor for a residue-class sieve.
-/

import Mathlib

namespace Op57

noncomputable section

open scoped BigOperators Topology

open Filter

/-- `c` is periodic with period `q` (and `q` is positive). -/
def IsPeriodic (c : ℕ → ℝ) (q : ℕ) : Prop := 0 < q ∧ ∀ m : ℕ, c (m + q) = c m

/-- The **twisted boundary functional** of generalisation #6:
`Φ_c(p,n) = Σ' j, c (n+j+1) (1 + (j+1)/n)^{−p}`. -/
def PhiChi (c : ℕ → ℝ) (p : ℝ) (n : ℕ) : ℝ :=
  ∑' j : ℕ, c (n + j + 1) * (1 + (((j : ℝ) + 1) / (n : ℝ))) ^ (-p)

/-- The **twisted generating function** `F_r(x) = Σ' j, c (r+j+1) x^{j+1}`.
Its value at `x = e^{−p/n}` is the leading-order limit of `PhiChi`. -/
def F (c : ℕ → ℝ) (r : ℕ) (x : ℝ) : ℝ :=
  ∑' j : ℕ, c (r + j + 1) * x ^ (j + 1)

/-- The **block polynomial** `fblock c q r x = Σ_{s<q} c (r+s+1) x^{s+1}`, the
numerator of `F_r` in the regrouped form `F_r(x) = fblock/(1−x^q)`. -/
def fblock (c : ℕ → ℝ) (q r : ℕ) (x : ℝ) : ℝ :=
  ∑ s ∈ Finset.range q, c (r + s + 1) * x ^ (s + 1)

/-- OP-5's threshold equation is the case `c ≡ 1`, `q = 1`. -/
theorem fblock_one (r : ℕ) (x : ℝ) : fblock (fun _ => 1) 1 r x = x := by
  simp [fblock]

/-- A term of the regrouped geometric series: `x^(qk+s) = x^s (x^q)^k`. -/
theorem geom_term (x : ℝ) (q s k : ℕ) : x ^ (q * k + s) = x ^ s * (x ^ q) ^ k := by
  rw [pow_add, pow_mul]
  ring

/-- The regrouping radius: `‖x^q‖ < 1` for `0 ≤ x < 1`, `q > 0`. -/
theorem geom_norm_lt_one {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) {q : ℕ} (hq : 0 < q) :
    ‖x ^ q‖ < 1 := by
  rw [Real.norm_eq_abs, abs_of_nonneg (pow_nonneg hx0 q)]
  exact pow_lt_one₀ hx0 hx1 (by omega)

/-- The value `−q⁻¹ Σ_s s·c(r+s)` that `F_r(x)` tends to as `x → 1⁻` when the
coefficient has zero mean over its period.  Recorded for the notes; the scan in
`../verify/03_character_scan.py` uses it as the endpoint criterion. -/
def endpointValue (c : ℕ → ℝ) (q r : ℕ) : ℝ :=
  -((∑ s ∈ Finset.range q, (s : ℝ) * c (r + s + 1)) / (q : ℝ))

end

end Op57
