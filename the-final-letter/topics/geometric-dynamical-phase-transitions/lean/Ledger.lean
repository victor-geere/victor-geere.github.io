import Mathlib

/-!
# Source-claims and open/conjecture ledger

This file formalises the *shape* of the geometric-DQPT ledger: each source
claim and open item is an entry with an id, a status, and an informal statement.
Precise predicates for O1–O4 are provided; the conversion O2 ↔ O1 is recorded
as a structure, not proved from nothing.
-/

noncomputable section

namespace GeoDQPT

/-- Status labels used by the programme. -/
inductive ClaimStatus
  | proved
  | sourceClaim
  | openItem
  | refuted
  deriving DecidableEq, Repr

/-- One row of the source-claims or open-items table. -/
structure LedgerEntry where
  id : String
  statement : String
  status : ClaimStatus
  deriving Repr

/-- The source-claims table of `README.md` (S1–S14). -/
def sourceClaims : List LedgerEntry := [
  ⟨"S1", "Purification identity and meromorphic continuation", .sourceClaim⟩,
  ⟨"S2", "Filter form and mean-zero path", .sourceClaim⟩,
  ⟨"S3", "Euler–Maclaurin remainder", .sourceClaim⟩,
  ⟨"S4", "Geometric DQPT criterion", .sourceClaim⟩,
  ⟨"S5", "Tightness of the measure families", .sourceClaim⟩,
  ⟨"S6", "No spurious atoms; pure-point limits", .sourceClaim⟩,
  ⟨"S7", "Realisation of balanced and unrestricted limits", .sourceClaim⟩,
  ⟨"S8", "Conversion of RH (equivalence, not a proof)", .sourceClaim⟩,
  ⟨"S9", "Vanishing-aperture jet theorem", .sourceClaim⟩,
  ⟨"S10", "Davenport–Heilbronn transfer and sharpness", .sourceClaim⟩,
  ⟨"S11", "Saias–Weingartner dichotomy and (M)", .sourceClaim⟩,
  ⟨"S12", "Straightening field and holonomy", .sourceClaim⟩,
  ⟨"S13", "Withdrawn nested-spheres/continuous-cone proof", .refuted⟩,
  ⟨"S14", "Numerical companion scripts", .sourceClaim⟩
]

/-- The open/conjecture ledger O1–O4. -/
def openItems : List LedgerEntry := [
  ⟨"O1", "Every non-trivial zero of Xi has real part 1/2", .openItem⟩,
  ⟨"O2", "The balanced and unrestricted supports agree", .openItem⟩,
  ⟨"O3", "Hypothesis (M): no zeros in sigma > 1", .openItem⟩,
  ⟨"O4", "Uniform slow passage and isolation for eps <= 13/194", .openItem⟩
]

/-- O1: all zeros in a set lie on the critical line. -/
def O1 (zeros : Set ℂ) : Prop := ∀ z ∈ zeros, z.re = 1 / 2

/-- O2: equality of the two supports. -/
def O2 (balanced unrestricted : Set ℂ) : Prop := balanced = unrestricted

/-- O3: hypothesis (M) for a Dirichlet series. -/
def O3 (f : ℂ → ℂ) : Prop := ∀ s : ℂ, 1 < s.re → f s ≠ 0

/-- O4: the Bourgain threshold predicate. -/
def O4 (ε : ℝ) : Prop := (13 / 194 : ℝ) < ε

/-- The conversion data: O2 is equivalent to O1 for the constructed families. -/
structure ConversionData (zeros balanced unrestricted : Set ℂ) where
  conversion : O2 balanced unrestricted ↔ O1 zeros

/-- Under the conversion, O2 and O1 are equivalent. -/
theorem O2_iff_O1 {zeros balanced unrestricted : Set ℂ}
    (C : ConversionData zeros balanced unrestricted) :
    O2 balanced unrestricted ↔ O1 zeros :=
  C.conversion

/-- The exact threshold form of O4. -/
theorem O4_iff_bourgain {ε : ℝ} :
    O4 ε ↔ (1 / 2 - ε) * (13 / 84) < ε := by
  unfold O4
  constructor <;> intro h <;> nlinarith

end GeoDQPT
