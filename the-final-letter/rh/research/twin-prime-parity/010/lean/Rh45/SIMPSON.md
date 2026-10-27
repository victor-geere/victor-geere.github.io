# `Rh45/SimpsonPanel.lean` — the single-panel Simpson estimate, proved

## The statement that was there, and why it was wrong

`Rh45/Archimedean.lean` used to *assume*, as an unproved `Prop`,

```lean
def SimpsonPanelEstimate (H : ℝ) : Prop :=
  ∀ (G : ℝ → ℝ) (c B : ℝ), 0 ≤ B →
    (∀ x ∈ Set.Icc c (c + 2 * H), |iteratedDeriv 4 G x| ≤ B) →
    |simpsonPanel G c H - ∫ x in c..(c + 2 * H), G x| ≤ (2 * H) ^ 5 / 2880 * B
```

and the module docstrings advertised it as "the one quadrature input Mathlib does
not contain".  As written it was **false**, for two independent reasons.

**(1) No regularity of `G`.**  Lean defines `deriv` to be `0` where a function is
not differentiable, so `iteratedDeriv 4` can vanish on a function that is not
`C⁴`.  Take `G x = |x|` on `[-1, 1]`, `c = -1`, `H = 1`, `B = 0`.  Then
`iteratedDeriv 4 G = 0` everywhere, so the hypothesis holds, yet

* `simpsonPanel G (-1) 1 = (2/6)·(|-1| + 4|0| + |1|) = 2/3`,
* `∫_{-1}^{1} |x| = 1`,

so the conclusion reads `|2/3 - 1| ≤ 0`, i.e. `1/3 ≤ 0`.  The estimate needs
`ContDiffOn ℝ 4 G` on the panel.

**(2) It was asserted for all real `H`.**  For `H < 0` the interval
`Set.Icc c (c + 2H)` is *empty*, so the derivative hypothesis is vacuous while
the right-hand side `(2H)⁵/2880 · B` is **negative**.  With `c = 0`, `H = -1`,
`G x = x⁴`, `B = 24` (the vacuous bound): `simpsonPanel G 0 (-1) = -20/3`,
`∫_0^{-2} x⁴ = -32/5`, so the left side is `|4/15| = 4/15`, while the right side
is `(-2)⁵/2880 · 24 = -4/15`.  Hence `4/15 ≤ -4/15`, false.

## The corrected statement and its proof

`Rh45/SimpsonPanel.lean` now defines

```lean
def SimpsonPanelEstimate (H : ℝ) : Prop :=
  ∀ (G : ℝ → ℝ) (c B : ℝ), 0 ≤ B →
    ContDiffOn ℝ 4 G (Set.Icc c (c + 2 * H)) →
    (∀ x ∈ Set.Icc c (c + 2 * H), |iteratedDeriv 4 G x| ≤ B) →
    |simpsonPanel G c H - ∫ x in c..(c + 2 * H), G x| ≤ (2 * H) ^ 5 / 2880 * B
```

— the same name and shape as before with the missing `C⁴` hypothesis added — and
proves

```lean
theorem simpsonPanelEstimate (H : ℝ) (hH : 0 ≤ H) : SimpsonPanelEstimate H
```

The hypothesis `0 ≤ H` is not a convenience: without it the proposition is the
false statement (2) above.  The round only ever uses `H ≥ 0`
(`simpsonSum_mul_error_le` already carries `hH : 0 ≤ H`).  The definition itself
is kept verbatim as originally written, so the only deviation from the
statement in the task is the necessary `hH` on the theorem.

## Proof route

Throughout, `0 < H`, `b = c + 2H`, `m = c + H`, `I = Icc c b`,
`P = taylorWithinEval G 3 I c`, `psi = G - P`, `f4 = iteratedDerivWithin 4 G I`.

1. **Simpson is exact on cubics.**
   `simpsonPanel_pow_exact` proves
   `simpsonPanel (fun x => (x-c)^k) c H = ∫_c^{c+2H} (x-c)^k` for `k ≤ 3` (direct
   `ring` after `integral_sub_pow`), and `simpsonPanel_taylorWithinEval` extends
   this by linearity to the cubic Taylor polynomial:
   `simpsonPanel (taylorWithinEval G 3 s c) c H = ∫_c^{c+2H} taylorWithinEval G 3 s c`.
   Consequently the error functional `E(F) = simpsonPanel F c H - ∫_c^{c+2H} F`
   satisfies `E(G) = E(psi)`.

2. **Taylor's theorem with integral remainder, at the left endpoint.**
   `taylor_integral_remainder` gives
   `G x - taylorWithinEval G 3 (uIcc c x) c x
    = ∫_t in c..x, ((x-t)^3/3!) • iteratedDerivWithin 4 G (uIcc c x) t`.
   Two congruences turn this into an identity with the *fixed* set `I`:
   `taylorWithinEval_Icc_congr` (the sets `uIcc c x` and `I` have the same germ
   at `c` when `c < x ≤ b`, via `iteratedFDerivWithin_congr_set`), and, on the
   open interval, both `iteratedDerivWithin`'s equal the global
   `iteratedDeriv` (`iteratedDerivWithin_eq_iteratedDeriv`, `ContDiffAt` at
   interior points).  This yields
   `psi x = ∫_t in c..x, ((x-t)^3/6) * f4 t` for every `x ∈ I`
   (`hrepr` in the proof).

3. **The triangular swap (the Peano-kernel decomposition).**
   `integral_integral_triangle` proves
   `∫_x in c..b, ∫_t in c..x, ((x-t)^3/6) f t
    = ∫_t in c..b, ((b-t)^4/24) f t`
   for continuous `f` on `[c,b]`.  It is a Fubini argument on the triangle:
   the integrand is written with the indicator of `{t ≤ x}`
   (`Set.Ioc`/`Set.Iic`), the rectangle Fubini theorem
   `intervalIntegral_intervalIntegral_swap` is applied, and the two indicator
   evaluations are `intervalIntegral.integral_indicator` (for `{t ≤ x}`) and the
   companion `integral_indicator_Ici` (for `{t ≤ x}` read as a condition on `x`,
   proved by reflection `x ↦ -x`).

   Applying this to `f4` gives `∫_c^b psi = ∫_c^b ((b-t)^4/24) f4`.

4. **Assembling the kernel.**  Since `psi c = 0`,
   `simpsonPanel psi c H = (2H)/6 · (4 psi m + psi b)`, and step 2 gives
   `psi m`, `psi b` as single integrals.  Splitting `∫_c^b` at `m` and using the
   polynomial identity (valid because `b = c+2H`, `m = c+H`)
   * on `[c,m]`: `(2H)/6·4·(m-t)³/6 + (2H)/6·(b-t)³/6 - (b-t)⁴/24
                   = H(t-c)³/18 - (t-c)⁴/24`,
   * on `[m,b]`: `(2H)/6·(b-t)³/6 - (b-t)⁴/24 = H(b-t)³/18 - (b-t)⁴/24`,
   gives the exact identity
   ```
   simpsonPanel psi c H - ∫_c^b psi
     = ∫_c^m (H(t-c)³/18 - (t-c)⁴/24) f4
       + ∫_m^b (H(b-t)³/18 - (b-t)⁴/24) f4 .
   ```
   (The pure integral-linearity step is `combine_integrals`.)

5. **Sign and size of the kernel.**  On `[c,m]`, with `s = t-c ∈ [0,H]`,
   `H s³/18 - s⁴/24 = s³(4H - 3s)/72 ≥ 0`; similarly on `[m,b]` with `u = b-t`.
   Moreover `∫_c^m (H(t-c)³/18 - (t-c)⁴/24) = H⁵/180` and likewise
   `∫_m^b (…) = H⁵/180`.  On the interior of the panel `f4 = iteratedDeriv 4 G`,
   which is bounded by `B`, so `|∫ w f4| ≤ ∫ w·|f4| ≤ B ∫ w`.  Adding the halves,
   ```
   |simpsonPanel psi c H - ∫ psi| ≤ B·(H⁵/180 + H⁵/180)
     = B·H⁵/90 = (2H)⁵/2880·B .
   ```

6. **The `H = 0` case** is trivial (both sides are `0`).

The only arithmetic lemmas used are `ring`, `positivity` and explicit
hypothesis lists; there is no `linarith`/`nlinarith` in the proof and no
`maxHeartbeats` anywhere in the module.

## What was landed, and what was not

* **Landed:** the corrected `SimpsonPanelEstimate`; its proof
  `simpsonPanelEstimate` for `0 ≤ H`; exactness on cubics
  (`simpsonPanel_pow_exact`, `simpsonPanel_const_mul_pow_exact`,
  `simpsonPanel_taylorWithinEval`); the Taylor remainder with fixed set
  (`taylorWithinEval_Icc_congr` + the `hrepr` step); the triangular-swap /
  Peano-kernel decomposition (`integral_integral_triangle`); the integral
  combination (`combine_integrals`); and the kernel sign/integral bound.
  `Rh45/Archimedean.lean` imports the module, and
  `simpsonSum_mul_error_le` no longer takes `hS : SimpsonPanelEstimate H` — it
  supplies the panel estimate from `simpsonPanelEstimate H hH`, deriving the
  panel `ContDiffOn` from `hφc`, `hΨc`.

* **Not landed (and impossible as stated):** the literal
  `theorem simpsonPanelEstimate (H : ℝ) : SimpsonPanelEstimate H` for *all* real
  `H`.  It is refuted by the `G x = x⁴`, `c = 0`, `H = -1`, `B = 24`
  computation in defect (2) above.  Instead the theorem carries the necessary
  hypothesis `hH : 0 ≤ H`; the definition is unchanged from the requested one.

* **Axioms.**  `#print axioms Rh45.simpsonPanelEstimate` and
  `#print axioms Rh45.simpsonSum_mul_error_le` both report exactly
  `[propext, Classical.choice, Quot.sound]`.  There is no `sorry`, `axiom`,
  `admit`, `native_decide` or `set_option maxHeartbeats` in the development.

## Exact signatures

```lean
def SimpsonPanelEstimate : ℝ → Prop
theorem simpsonPanelEstimate : ∀ (H : ℝ), 0 ≤ H → SimpsonPanelEstimate H

theorem simpsonPanel_taylorWithinEval (G : ℝ → ℝ) (s : Set ℝ) (c H : ℝ) :
    simpsonPanel (fun x => taylorWithinEval G 3 s c x) c H
      = ∫ x in c..(c + 2 * H), taylorWithinEval G 3 s c x

lemma integral_integral_triangle {f : ℝ → ℝ} {c b : ℝ}
    (hf : ContinuousOn f (Set.Icc c b)) (hcb : c ≤ b) :
    ∫ x in c..b, ∫ t in c..x, ((x - t) ^ 3 / 6) * f t
      = ∫ t in c..b, ((b - t) ^ 4 / 24) * f t
```
