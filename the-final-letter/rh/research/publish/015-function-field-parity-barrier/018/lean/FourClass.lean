import Mathlib

namespace FourClass

/-- The quartic-character orthogonality: over the four classes `χ₄ = 1, i, −1, −i`
with `T` constant `T₀,T₁,T₂,T₃`, the twisted sum is
`(T₀ − T₂) + i(T₃ − T₁)`. -/
theorem four_class_sum (T0 T1 T2 T3 : ℤ) :
    (T0 : ℂ) + (-Complex.I) * (T1 : ℂ) + (-1) * (T2 : ℂ) + Complex.I * (T3 : ℂ)
      = ((T0 : ℂ) - (T2 : ℂ)) + Complex.I * ((T3 : ℂ) - (T1 : ℂ)) := by
  ring

/-- Hence `4 c₄ = (T₀ − T₂) − i(T₁ − T₃)`. -/
theorem c4_from_four (T0 T1 T2 T3 : ℤ) :
    (4 : ℂ) * (((T0 : ℂ) - (T2 : ℂ)) + Complex.I * ((T3 : ℂ) - (T1 : ℂ))) / 4
      = ((T0 : ℂ) - (T2 : ℂ)) + Complex.I * ((T3 : ℂ) - (T1 : ℂ)) := by
  ring

end FourClass
