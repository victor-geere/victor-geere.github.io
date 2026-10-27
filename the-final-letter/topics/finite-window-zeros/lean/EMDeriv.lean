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

end FiniteWindowZeros
