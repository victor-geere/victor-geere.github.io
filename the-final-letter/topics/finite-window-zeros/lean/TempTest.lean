import Mathlib
example (q g : ℚ) (hg : 0 < g) :
    q / g = ((q.num * g.den : ℤ) : ℚ) / ((q.den * g.num : ℤ) : ℚ) := by
  have hgnum : (0:ℚ) < (g.num : ℚ) := by exact_mod_cast (Rat.num_pos.mpr hg)
  have hD : ((q.den * g.num : ℤ) : ℚ) ≠ 0 := by
    have : (0:ℤ) < q.den * g.num := mul_pos (by exact_mod_cast q.den_pos) (Rat.num_pos.mpr hg)
    exact_mod_cast ne_of_gt this
  rw [div_eq_div_iff (ne_of_gt hg) (by simpa using hD)]
  have hqden0 : (q.den : ℚ) ≠ 0 := by exact_mod_cast (ne_of_gt q.den_pos)
  have hgden0 : (g.den : ℚ) ≠ 0 := by exact_mod_cast (ne_of_gt g.den_pos)
  have hq : q * (q.den : ℚ) = (q.num : ℚ) := by
    nth_rewrite 1 [← Rat.num_div_den q]
    rw [div_mul_cancel₀ _ hqden0]
  have hg' : g * (g.den : ℚ) = (g.num : ℚ) := by
    nth_rewrite 1 [← Rat.num_div_den g]
    rw [div_mul_cancel₀ _ hgden0]
  push_cast
  calc q * (↑q.den * ↑g.num) = (q * ↑q.den) * ↑g.num := by ring
    _ = ↑q.num * ↑g.num := by rw [hq]
    _ = ↑q.num * (g * ↑g.den) := by rw [hg']
    _ = ↑q.num * ↑g.den * g := by ring
