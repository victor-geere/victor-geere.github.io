/-
# Zeta from theta — the Dirichlet-series bridge

This is the seed of a **theta-first development of the Riemann zeta function**,
i.e. one that proves the functional equation without going through the
Hurwitz-zeta development that Mathlib's `completedRiemannZeta_one_sub` uses.

The bridge proved here is the linchpin of the whole proposal: the object built
from the theta side — the Dirichlet series `∑ n^{-s}` — is *definitionally*
the same function as Mathlib's `riemannZeta` on `Re s > 1`.  Nothing here uses
or reproves the functional equation.

The construction target is specified in `../HANDOFF.md`; the plan is:

1. `Λ_θ(s) = ∫_0^∞ t^{s/2-1}·ψ(t) dt` for `Re s > 1` (Mathlib: `mellin`);
2. `Λ_θ(s) = Γℝ(s)·∑ n^{-s}` there (`hasSum_mellin_pi_mul`, `Gammaℝ`);
3. the theta functional equation `θ(1/t) = √t·θ(t)` extends `Λ_θ` to a
   meromorphic function with `Λ_θ(1-s) = Λ_θ(s)` (the `ZetaTheta` layer);
4. `zetaSeries_eq_riemannZeta` (below) identifies `Λ_θ/Γℝ` with `riemannZeta`,
   so the functional equation transfers to `ζ` along a route whose dependency
   cone contains no `*_one_sub` lemma of the zeta development.
-/
import Mathlib
import ThetaLayer

noncomputable section
open Filter
open scoped BigOperators Topology

namespace ZetaFromTheta

/-- **D1. The theta-side zeta.**  The Dirichlet series, as an unconditional
function of `s` (it converges on `Re s > 1`; elsewhere it is the divergent
series, and the continuation is the subject of the handoff). -/
def zetaSeries (s : ℂ) : ℂ := ∑' n : ℕ, (1 : ℂ) / (n : ℂ) ^ s

/-- **T1. The series converges for `Re s > 1`.**  Proved by comparison of the
norm with the real p-series `∑ n^{-Re s}`; no zeta analysis is used. -/
theorem summable_zetaSeries {s : ℂ} (hs : 1 < s.re) :
    Summable (fun n : ℕ => (1 : ℂ) / (n : ℂ) ^ s) := by
  rw [← summable_norm_iff]
  have hbase : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ s.re) :=
    Real.summable_one_div_nat_rpow.mpr hs
  refine hbase.congr (fun n => ?_)
  rcases Nat.eq_zero_or_pos n with h | h
  · subst h
    have hsne : s ≠ 0 := by
      intro h
      rw [h] at hs
      norm_num at hs
    simp [Real.zero_rpow (ne_of_gt (lt_trans zero_lt_one hs)), Complex.zero_cpow hsne]
  · have hn : (0 : ℝ) < (n : ℝ) := by exact_mod_cast h
    have harg : ((n : ℂ)) = ((n : ℝ) : ℂ) := by push_cast; ring
    rw [harg, norm_div, norm_one, Complex.norm_cpow_eq_rpow_re_of_pos hn]

/-- **T2. The Dirichlet-series bridge.**  On `Re s > 1` the theta-side series is
exactly Mathlib's `riemannZeta`.  This is the identification step of the
proposal: it uses only `zeta_eq_tsum_one_div_nat_cpow`, which is a statement
about the Dirichlet series and does not involve the functional equation. -/
theorem zetaSeries_eq_riemannZeta {s : ℂ} (hs : 1 < s.re) :
    zetaSeries s = riemannZeta s := by
  rw [zetaSeries, zeta_eq_tsum_one_div_nat_cpow hs]

/-- **T3. The bridge in completed form.**  `Λ(s) = Γℝ(s)·ζ_θ(s)` on `Re s > 1`,
i.e. the Mellin representation read backwards. -/
theorem zetaSeries_eq_completed_div {s : ℂ} (hs : 1 < s.re) :
    zetaSeries s = completedRiemannZeta s / Complex.Gammaℝ s := by
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    norm_num at hs
  rw [zetaSeries_eq_riemannZeta hs, riemannZeta_def_of_ne_zero hs0]


/-! ## The theta-side object and its functional equation -/

/-- **D2. The completed theta integral, as a standalone definition.**

This is the split-and-substitute form of `Λ_θ`:
`∫_1^∞ ψ(t)(t^{s/2−1} + t^{(1−s)/2−1})dt + 1/(s−1) − 1/s`.
It is manifestly invariant under `s ↦ 1 − s` (see `LambdaTheta_one_sub`) and is
analytic off `{0, 1}` (see `differentiableAt_LambdaTheta`). -/
noncomputable def LambdaTheta (s : ℂ) : ℂ := ZetaTheta.LambdaTilde s

/-- **D2 (bridge).** On `Re s > 1` the definition agrees with the Mellin transform
of the theta kernel.  This is the only point where the standalone definition is
connected to the proved theta layer. -/
theorem LambdaTheta_eq_mellin {s : ℂ} (hs : 1 < s.re) :
    LambdaTheta s = mellin ZetaTheta.psi (s / 2) := by
  rw [LambdaTheta, ← ZetaTheta.completedRiemannZeta_eq_LambdaTilde s hs,
    ← ZetaTheta.mellin_psi_eq_completed s hs]

/-- **D2 (symmetry).** `Λ_θ(1 − s) = Λ_θ(s)`.  Immediate from the definition: the
two exponents are interchanged and `1/((1−s)−1) − 1/(1−s) = 1/(s−1) − 1/s`. -/
theorem LambdaTheta_one_sub (s : ℂ) : LambdaTheta (1 - s) = LambdaTheta s :=
  ZetaTheta.LambdaTilde_one_sub s

/-- **D2 (analyticity).** `Λ_θ` is differentiable off `{0, 1}`. -/
theorem differentiableAt_LambdaTheta (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ LambdaTheta s :=
  ZetaTheta.differentiableAt_LambdaTilde s hs0 hs1

/-- **D3. The theta-side zeta function.**  On the complement of the `Γℝ` zeros
this is `Λ_θ/Γℝ`; at the zeros Lean's division convention assigns `0`, which is
the value of the removable extension treated in D6. -/
noncomputable def zetaTheta (s : ℂ) : ℂ := LambdaTheta s / Complex.Gammaℝ s

/-- **D3 (agreement with the Dirichlet series).**  On `Re s > 1` the theta-side
object is exactly `Σ' n^{-s}`.  This is T3 read backwards, with `Λ` replaced by
the standalone definition. -/
theorem zetaTheta_eq_zetaSeries {s : ℂ} (hs : 1 < s.re) :
    zetaTheta s = zetaSeries s := by
  rw [zetaTheta, LambdaTheta, ← ZetaTheta.completedRiemannZeta_eq_LambdaTilde s hs,
    ← zetaSeries_eq_completed_div hs]

/-- **D4. The functional equation for `ζ_θ`.**

Derived only from the symmetry `LambdaTheta_one_sub` and the Gamma reflection
identity `Complex.Gammaℝ_div_Gammaℝ_one_sub`; no Mathlib `*_one_sub` lemma is
used.  The hypotheses avoid the `Γℝ` zeros (`s = −n`, including `s = 0`) and the
pole at `s = 1`. -/
theorem zetaTheta_one_sub {s : ℂ}
    (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (_hs' : s ≠ 1)
    (hG : Complex.Gammaℝ (1 - s) ≠ 0) :
    zetaTheta (1 - s) =
      2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s *
        Complex.cos (Real.pi * s / 2) * zetaTheta s := by
  have hs0 : s ≠ 0 := by
    intro h
    exact hs 0 (by simpa using h)
  have hGs : Complex.Gammaℝ s ≠ 0 := by
    intro h
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
    exact hs (2 * n) (by push_cast; linear_combination hn)
  have hodd : ∀ n : ℕ, s ≠ -(2 * (n : ℂ) + 1) := by
    intro n h
    exact hs (2 * n + 1) (by push_cast; linear_combination h)
  have hFE : LambdaTheta (1 - s) = LambdaTheta s := LambdaTheta_one_sub s
  have hrat : Complex.Gammaℝ s / Complex.Gammaℝ (1 - s) =
      Complex.Gammaℂ s * Complex.cos (Real.pi * s / 2) :=
    Complex.Gammaℝ_div_Gammaℝ_one_sub hodd
  have hGC : (2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s : ℂ) = Complex.Gammaℂ s := by
    rw [Complex.Gammaℂ_def]
  simp only [zetaTheta]
  rw [hFE, hGC, ← hrat]
  field_simp

/-- **D5. Identification with Mathlib's `ζ`.**  Off the `Γℝ` zeros and `s = 1`,
the theta-side object is `riemannZeta`.  The proof uses only the definitional
rewrite `riemannZeta_def_of_ne_zero` together with the already-proved identity
`completedRiemannZeta = Λ_θ` off `{0,1}`; it invokes no functional equation. -/
theorem zetaTheta_eq_riemannZeta {s : ℂ}
    (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1) :
    zetaTheta s = riemannZeta s := by
  have hs0 : s ≠ 0 := by
    intro h
    exact hs 0 (by simpa using h)
  simp only [zetaTheta, LambdaTheta]
  rw [← ZetaTheta.completedRiemannZeta_eq_LambdaTilde_all s hs0 hs',
    riemannZeta_def_of_ne_zero hs0]

/-- **D5 (strengthened form).**  The identification actually only needs
`s ≠ 0` and `s ≠ 1`: at the `Γℝ` zeros both `Λ_θ/Γℝ` and `completedRiemannZeta/Γℝ`
are `0/0`, and Lean's division convention assigns `0` to both, which is the
correct value of `ζ` at every trivial zero.  This stronger form is what makes the
removable-singularity statement below possible. -/
theorem zetaTheta_eq_riemannZeta_of_ne_zero_one {s : ℂ}
    (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    zetaTheta s = riemannZeta s := by
  simp only [zetaTheta, LambdaTheta]
  rw [← ZetaTheta.completedRiemannZeta_eq_LambdaTilde_all s hs0 hs1,
    riemannZeta_def_of_ne_zero hs0]

/-- **D6 (value).**  At the trivial zeros `s = −2(n+1)` the theta-side zeta
vanishes.  Lean's division convention makes this immediate; the substantive
content — that the assigned value is the removable extension of `Λ_θ/Γℝ` — is
recorded in `zetaTheta_removable_at_trivial_zero`. -/
theorem zetaTheta_trivial_zero (n : ℕ) :
    zetaTheta (-(2 * ((n + 1 : ℕ) : ℂ))) = 0 := by
  rw [zetaTheta, Complex.Gammaℝ_eq_zero_iff.mpr ⟨n + 1, by push_cast; ring⟩, div_zero]

/-- **D6 (removable singularity).**  At a trivial zero the punctured limit of
`ζ_θ` exists and equals the assigned value `0`.  Off `{0,1}` the two quotients
`Λ_θ/Γℝ` and `completedRiemannZeta/Γℝ` agree identically (D5), so near `−2(n+1)`
the function agrees with `riemannZeta`, which is continuous there and vanishes at
the trivial zero.  This pins the value of the extension without claiming an
independent multiplicity computation; see the README's limits paragraph. -/
theorem zetaTheta_removable_at_trivial_zero (n : ℕ) :
    Tendsto zetaTheta (𝓝[≠] (-(2 * ((n + 1 : ℕ) : ℂ)))) (𝓝 0) := by
  set x : ℂ := -(2 * ((n + 1 : ℕ) : ℂ)) with hxdef
  have hre : Complex.re x = -(2 * ((n : ℝ) + 1)) := by
    rw [hxdef]
    simp
  have hx0 : x ≠ 0 := by
    intro h
    rw [h] at hre
    norm_num at hre
    linarith
  have hx1 : x ≠ 1 := by
    intro h
    rw [h] at hre
    norm_num at hre
    linarith
  have hEq : zetaTheta =ᶠ[𝓝[≠] x] riemannZeta := by
    have h0 : ∀ᶠ s in 𝓝[≠] x, s ≠ 0 := eventually_ne_nhdsWithin hx0
    have h1 : ∀ᶠ s in 𝓝[≠] x, s ≠ 1 := eventually_ne_nhdsWithin hx1
    filter_upwards [h0, h1] with s hs0 hs1
    exact zetaTheta_eq_riemannZeta_of_ne_zero_one hs0 hs1
  have hcont : Tendsto riemannZeta (𝓝[≠] x) (𝓝 0) := by
    have hd : ContinuousAt riemannZeta x := (differentiableAt_riemannZeta hx1).continuousAt
    have hval : riemannZeta x = 0 := by
      rw [hxdef]
      have h := riemannZeta_neg_two_mul_nat_add_one n
      rw [show (-2 * ((n : ℂ) + 1)) = -(2 * ((n + 1 : ℕ) : ℂ)) by push_cast; ring] at h
      exact h
    have ht : Tendsto riemannZeta (𝓝 x) (𝓝 0) := by
      simpa [hval] using hd.tendsto
    exact ht.mono_left nhdsWithin_le_nhds
  exact hcont.congr' hEq.symm

/-- **M6. The functional equation for `riemannZeta`, assembled from the theta
side.**  Same statement as `riemannZeta_one_sub_theta'` but with the
`Γℝ (1−s) ≠ 0` hypothesis retained (so the trivial-zero branch is not entered);
the proof routes through `zetaTheta_one_sub` rather than the Hurwitz development.
The restriction is the documented D6 limitation; see the README. -/
theorem riemannZeta_one_sub_from_theta {s : ℂ}
    (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1)
    (hG : Complex.Gammaℝ (1 - s) ≠ 0) :
    riemannZeta (1 - s) =
      2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s *
        Complex.cos (Real.pi * s / 2) * riemannZeta s := by
  have hs0 : s ≠ 0 := by
    intro h
    exact hs 0 (by simpa using h)
  have h1s0 : (1 - s) ≠ 0 := by
    intro h
    exact hs' (by linear_combination -h)
  have h1s1 : (1 - s) ≠ 1 := by
    intro h
    exact hs0 (by linear_combination -h)
  rw [← zetaTheta_eq_riemannZeta_of_ne_zero_one h1s0 h1s1,
    ← zetaTheta_eq_riemannZeta_of_ne_zero_one hs0 hs',
    zetaTheta_one_sub hs hs' hG]


/-- **M6 (unconditional).**  The `Γℝ (1−s) = 0` branch, where `s = 1 + 2n`, is
handled by the vanishing of both sides: `riemannZeta (−2n) = 0` and
`cos (π(1+2n)/2) = 0`.  This is the same statement as
`riemannZeta_one_sub_theta'`, reached through `zetaTheta_one_sub` rather than the
Hurwitz development. -/
theorem riemannZeta_one_sub_from_theta' {s : ℂ}
    (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1) :
    riemannZeta (1 - s) =
      2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s *
        Complex.cos (Real.pi * s / 2) * riemannZeta s := by
  by_cases hG : Complex.Gammaℝ (1 - s) ≠ 0
  · exact riemannZeta_one_sub_from_theta hs hs' hG
  · have hG0 : Complex.Gammaℝ (1 - s) = 0 := not_ne_iff.mp hG
    obtain ⟨n, hn⟩ := Complex.Gammaℝ_eq_zero_iff.mp hG0
    have hs1 : s = 1 + 2 * (n : ℂ) := by linear_combination -hn
    rcases n with _ | m
    · rw [Nat.cast_zero] at hs1
      simp only [mul_zero, add_zero] at hs1
      exact absurd hs1 hs'
    · have hL : riemannZeta (1 - s) = 0 := by
        rw [hs1]
        have harg : (1 : ℂ) - (1 + 2 * (((m + 1 : ℕ)) : ℂ)) = -2 * (((m + 1 : ℕ)) : ℂ) := by ring
        rw [harg]
        have h := riemannZeta_neg_two_mul_nat_add_one m
        convert h using 2
        push_cast
        ring
      have hcos : Complex.cos ((Real.pi : ℂ) * s / 2) = 0 := by
        have harg : (Real.pi : ℂ) * s / 2
            = ((Real.pi / 2 + ((m : ℕ) + 1 : ℕ) * Real.pi : ℝ) : ℂ) := by
          rw [hs1]
          push_cast
          ring
        rw [harg, ← Complex.ofReal_cos, Real.cos_add_nat_mul_pi, Real.cos_pi_div_two, mul_zero]
        norm_cast
      rw [hL, hcos]
      ring

end ZetaFromTheta
