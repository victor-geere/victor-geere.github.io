# 011/lean — how far Routes A/B/C generalise

`Generic.lean` (namespace `RouteABC`) is a research artifact: it separates **what is
proved** from **what is assumed** for the three certification routes of the 010
development.  It builds against Lean v4.35.0-rc2 + Mathlib, importing
`Rh45.Routes` and `Rh45.RouteBGeneral` from `../../010/lean` (no file outside `011/` is
touched).

`DirichletConj.lean` is a **Mathlib-only, PR-shaped** module that closes one of the two
gaps named below: conjugation reality of the completed Dirichlet L-function.  It imports
nothing from the 010 development.

`RootNumber.lean` closes the **other** gap: `RootNumberSign χ` (`rootNumber χ = ±1`) for a
nontrivial quadratic primitive character.  It has no `hreal` input: the proof is the
functional equation applied twice, so no Gauss-sum squaring (and no prime-modulus restriction)
is needed.

`GaussSumComposite.lean` supplies the **missing composite-modulus Gauss-sum square**:
`gaussSum_sq_of_isPrimitive` proves `gaussSum χ stdAddChar ^ 2 = χ (-1) * N` for a primitive
quadratic `χ` of *arbitrary* modulus, which Mathlib's field-only `gaussSum_sq` cannot.  It also
gives the product form `gaussSum χ * gaussSum χ⁻¹ = χ (-1) * N`, proves
the new `IsPrimitive.inv`, compares the statement with Mathlib's `gaussSum_sq` at `N = 3, 5, 7`,
and re-derives `rootNumber χ = ±1` by this second, independent route
(`rootNumber_eq_one_or_neg_one'`; `RootNumber.lean` is untouched).

`DirichletAnalytic.lean` discharges the three **analytic** hypotheses that
`DirichletRouteB.routeB_for_dirichletL_unconditional` still carried (`han`, `hint₀`, `hint₁`):
`dirichletCompleted χ` is entire for every `χ ≠ 1`, its `logDeriv` is continuous — hence interval
integrable — on each horizontal edge off the zero set, and the repackaged
`routeB_for_dirichletL_of_zeros` has **only the numerical zero data** (`Z`, `m`, `hno`) left.

`DirichletL.lean` supplies the **concrete real primitive character** `chi3` mod 3 — the
Legendre symbol `(·/3)` cast to `ℂ` — and discharges every character-theoretic hypothesis of
Route B for it: `chi3_isQuadratic`, `chi3_ne_one` and `chi3_isPrimitive` are proved from
Mathlib's `quadraticChar`, `MulChar.IsQuadratic` and the conductor API.  The resulting
`routeB_for_chi3_of_zeros` is Route B for the completed `L`-function of `chi3`, conditional
only on the numerical zero data.  It requires the Mathlib libraries
`Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic` and
`Mathlib.NumberTheory.LSeries.DirichletContinuation` (plus the local 011 modules).

`CertifiedWindow.lean` names the **zero-data obligation** as one structure: `CertifiedWindow χ t0 t1`
bundles the finite set `Z`, the orders `m`, membership in the rectangle, the order equality and
zero-freeness off `Z`; `CertifiedWindow.routeB` consumes it, and `routeB_for_chi3_of_window` fixes
the concrete window `(1/2, 10)` for `chi3`.  Its header states what is **not** formalised —
producing a `CertifiedWindow` is the numerical certificate
(`../rigorous/certify_dirichlet_routeB.py`), and formalising it needs a verified numerical
evaluator for `dirichletCompleted chi3` and a formalised argument-principle count, neither in
Mathlib — so the computational certificate remains the substantive input.

`DirichletExplicit.lean` is the **Route C algebraic layer** for a Dirichlet L-function: the
Dirichlet–von Mangoldt weight `dirichletWeight χ n = Λ(n)χ(n)` (the Euler-product coefficient of
`−L'/L`, *not* the convolution `χ∗Λ`) with its prime-power values `dirichletWeight_pow_prime`, the
prime side and its split/evenness lemmas, the archimedean kernel
`dirichletPsi q a t = log(q/π)+Re ψ((1+a)/4+it/2)` (reducing to `Rh45.PsiBar` at `q=1,a=0`), and
the `DirichletExplicitData` structure with the validated truncation inequality
`|lhs−computed| ≤ |zeroTail|+|primeTail|+|archTail|`.

`DirichletArchimedean.lean` and `DirichletPrimeTail.lean` **prove two of the three tail
bounds**:
* `dirichletPsi_deriv_bound` — the archimedean derivative budget
  `‖(Ψ_χ)^{(k)}(t)‖ ≤ 2^{-k} k! ∑_j ((1+2a)/4+j)^{-k-1}` for `k ≥ 1`, by the chain rule on the
  parity line plus `Rh45RouteBAnalytic.norm_deriv_digamma_le`;
* `dirichletPrimeSideLog_remainder_le` / `..._decay` — Chebyshev bounds on the prime remainder,
  `≤ D(log4+4) nmax/√K` and, with `‖g(log n)‖ ≤ D/√n`, `≤ D(log4+4) nmax/K`, from
  `Chebyshev.psi_le_const_mul_self` and `DirichletCharacter.norm_le_one`.

`DirichletZeroTail.lean` proves the **zero/density tail mechanism**:
* `zeroTail_le_of_majorant` — if the zeros dominate a majorant `f` (`∀ n, f n ≤ γ n`) and `h ≥ 0`
  is antitone, then `∑' n, h (γ n) ≤ ∑' n, h (f n)`; `f` is the density (inverse-counting) input;
* `gaussian_zeroTail_le` — the Gaussian instance with a gap `g`,
  `∑' n, exp(−(T+(n+1)g)²/2) ≤ exp(−(T+g)²/2)/(1−exp(−(T+g)g))`.

`DirichletExplicitData.validated_le` wires externally proved tail bounds into the residual bound:
given `|primeTail| ≤ P` and `|archTail| ≤ A`, `|lhs − computed| ≤ |zeroTail| + P + A`.

`DirichletLogDeriv.lean` proves the **prime-coefficient half of the identity**:
`LSeries (fun n ↦ Λ n · χ n) s = − deriv (LSeries (fun n ↦ χ n)) s / LSeries (fun n ↦ χ n) s`
on `1 < re s`, i.e. `−logDeriv (LSeries χ) = LSeries (dirichletWeight χ)`.  It uses Mathlib's
`DirichletCharacter.LSeries_twist_vonMangoldt_eq` — whose `*` is the *pointwise* product of
coefficient functions (the Dirichlet convolution is `LSeries.convolution`), confirming that the
prime-side weight is `Λ(n)χ(n)`, not `(χ∗Λ)(n)`.

`DirichletGammaLogDeriv.lean` proves the **archimedean half of the identity**:
`logDeriv Complex.Gammaℝ s = −½ log π + ½ ψ(s/2)` for `0 < re s`, where
`Gammaℝ s = π^{−s/2}Γ(s/2)` and `ψ = Complex.digamma = logDeriv Γ` (via
`Complex.logDeriv_const_cpow` and the chain rule).

`DirichletCompletedLogDeriv.lean` **assembles the integrand**: for nontrivial `χ` and `1 < re s`,

* `logDeriv_dirichletCompleted_eq` — `logDeriv (dirichletCompleted χ) s = ½log N + logDeriv (gammaFactor χ) s − LSeries (Λ·χ) s`;
* `logDeriv_dirichletCompleted_eq_even` / `_odd` — fully evaluated,
  `= ½log N − ½log π + ½ψ((s+a)/2) − LSeries (Λ·χ) s`, `a = 0` even, `a = 1` odd.

This is the **complete Dirichlet explicit-formula integrand** `Λ_χ'/Λ_χ` on `re s > 1`
(archimedean + conductor minus the prime series).  Support lemmas:
`completedLFunction_eq_gammaFactor_mul_LFunction`, `completedLFunction_ne_zero_of_one_lt_re`,
`logDeriv_LFunction_eq`, `logDeriv_gammaFactor_even` / `_odd`.

The **contour step already exists** for `dirichletCompleted`: `Generic.lean`'s
`routeB_general_of_logDeriv` gives the argument-principle identity
`(rightPath (logDeriv F) t0 t1).im = π · ∑_{z∈Z} m z`, and
`continuousOn_logDeriv_dirichletCompleted` / `intervalIntegrable_logDeriv_dirichletCompleted`
supply its regularity hypotheses.  So every ingredient of the explicit formula is now in Lean;
the remaining work is the *weighted* contour assembly (`∫ F · Λ_χ'/Λ_χ`), not new analysis.

```
./check.sh --all           # Generic, DirichletConj, RootNumber, DirichletRouteB, GaussSumComposite, DirichletAnalytic, DirichletL, CertifiedWindow, DirichletExplicit, DirichletArchimedean, DirichletPrimeTail, Axioms, AxiomsConj, AxiomsL
./check.sh DirichletAnalytic.lean   # the analytic hypotheses (also imported, and audited, by AxiomsConj.lean)
./check.sh DirichletL.lean # the concrete real primitive character chi3 and its Route B theorem
./check.sh CertifiedWindow.lean # the named zero-data obligation and its consumer theorem
./check.sh DirichletExplicit.lean # the Route C algebraic layer
./check.sh DirichletArchimedean.lean # the proved archimedean derivative bound
./check.sh DirichletPrimeTail.lean    # the proved Chebyshev prime-tail bounds
./check.sh DirichletZeroTail.lean      # the proved zero/density tail mechanism
./check.sh DirichletLogDeriv.lean       # −L'/L = LSeries (Λ·χ), the prime half of the identity
./check.sh DirichletGammaLogDeriv.lean  # logDeriv Gammaℝ = −½log π + ½ψ(s/2), the archimedean half
./check.sh DirichletCompletedLogDeriv.lean # the assembled, evaluated explicit-formula integrand
./check.sh Axioms.lean     # prints #print axioms for every headline theorem of Generic.lean
./check.sh AxiomsConj.lean # … and of DirichletConj.lean / RootNumber.lean / GaussSumComposite.lean / DirichletAnalytic.lean
./check.sh AxiomsL.lean    # … and of DirichletL.lean / CertifiedWindow.lean / DirichletExplicit.lean
```

`check.sh` prepends this directory and `../../010/lean` to `LEAN_PATH` (lines 30–45),
which is what makes `import Rh45.RouteBGeneral` resolve.

There is **no `sorry`, no `axiom`, no `admit`, no `native_decide` and no
`set_option maxHeartbeats`**.  Every headline theorem below has
`#print axioms = [propext, Classical.choice, Quot.sound]`.

---

## 1. Route B: already general in the analytic function

```lean
structure SelfDualReal (F : ℂ → ℂ) : Prop where
  selfDual : ∀ s, F (1 - s) = F s
  conjSymm : ∀ s, F (conj s) = conj (F s)

theorem routeB_of_selfDualReal (F : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (h : SelfDualReal F) (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0:ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt F z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0:ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → F u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

**Proved, thin wrapper.**  The body is one application of the 010 theorem
`Rh45RouteBAnalytic.routeB_reduction_general`.  Nothing is re-proved: Route B was already
stated for an arbitrary `f : ℂ → ℂ`.

### 1a. The sign refinement (needed for `ε = -1`)

The 010 proof only uses `F(1-s)=F s` through `logDeriv F (1-s) = -logDeriv F s`.  That
identity survives a sign `ε = ±1`, which is exactly what a Dirichlet root number is:

```lean
theorem logDeriv_one_sub_of_const_mul (f : ℂ → ℂ) (ε : ℂ) (hε : ε ≠ 0)
    (h : ∀ s, f (1 - s) = ε * f s) (s : ℂ) :
    logDeriv f (1 - s) = -logDeriv f s

structure SelfDualRealUpToSign (F : ℂ → ℂ) (ε : ℂ) : Prop where
  unit : ε = 1 ∨ ε = -1
  selfDual : ∀ s, F (1 - s) = ε * F s
  conjSymm : ∀ s, F (conj s) = conj (F s)

theorem routeB_of_selfDualRealUpToSign (F : ℂ → ℂ) (ε : ℂ) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ) (h : SelfDualRealUpToSign F ε) (…same remaining hypotheses…) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

For `ε = 1` it is literally `routeB_of_selfDualReal`; for `ε = -1` it uses
`routeB_general_of_logDeriv`, which recombines the 010 argument principle
(`Rh45RouteBAnalytic.argument_principle_general`) with the 010 contour reduction
(`Rh45RouteBAnalytic.routeB_reduction`).  This is why a root number `-1` is not an
obstruction for Route B.

---

## 2. Routes A and C: already general

### Route A — `CertifiedZero`

```lean
structure CertifiedZero (f : ℝ → ℝ) (a b la ha lb hb m : ℝ) : Prop where
  hab : a < b
  cont : ContinuousOn f (Set.Icc a b)
  hfa_lo : la ≤ f a
  ha_neg : ha < 0
  hfa_hi : f a ≤ ha
  hfb_lo : lb ≤ f b
  lb_pos : 0 < lb
  hfb_hi : f b ≤ hb
  hderiv : ∀ x ∈ Set.Ioo a b, m ≤ deriv f x
  hm_pos : 0 < m

theorem CertifiedZero.exists_unique_root {f : ℝ → ℝ} {a b la ha lb hb m : ℝ}
    (h : CertifiedZero f a b la ha lb hb m) :
    ∃ x, x ∈ Set.Ioo a b ∧ f x = 0 ∧ 0 < deriv f x ∧
      ∀ y, y ∈ Set.Ioo a b → f y = 0 → y = x
```

**Proved.**  Direct call to `Rh45Routes.certified_root_of_enclosures`, which was already
stated for an arbitrary `f : ℝ → ℝ`.  The same is true of
`Rh45Routes.exists_unique_root_of_sign_change` and `…_neg`.

### Route C — arbitrary finite family of tails (new)

```lean
theorem validated_truncation_bound_finset {ι : Type*} [DecidableEq ι] (s : Finset ι)
    (tail : ι → ℝ) {lhs rhsComputed : ℝ}
    (hsplit : lhs = rhsComputed + ∑ i ∈ s, tail i) :
    |lhs - rhsComputed| ≤ ∑ i ∈ s, |tail i|
```

**Proved here by induction on the `Finset`** (triangle inequality, `abs_add_le`,
`Finset.sum_insert`).

```lean
theorem validated_truncation_bound_three
    {lhs rhsTrue rhsComputed zeroTail primeTail archTail : ℝ}
    (hlhs : lhs = rhsTrue)
    (hsplit : rhsTrue = rhsComputed + (zeroTail + primeTail + archTail)) :
    |lhs - rhsComputed| ≤ |zeroTail| + |primeTail| + |archTail|
```

This is the **010 instance**: `validated_truncation_bound_three` is the
`Finset (Fin 3)` case of the general statement (and is exactly
`Rh45Routes.validated_truncation_bound`, re-derived here from the general theorem).

---

## 3. Dirichlet L-functions — the functional equation, PROVED

```lean
noncomputable def dirichletCompleted (χ : DirichletCharacter ℂ N) (s : ℂ) : ℂ :=
  (N : ℂ) ^ (s / 2) * completedLFunction χ s

theorem dirichletL_normalised_one_sub (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (s : ℂ) :
    (N : ℂ) ^ ((1 - s) / 2) * completedLFunction χ (1 - s)
      = rootNumber χ * ((N : ℂ) ^ (s / 2) * completedLFunction χ s)

theorem dirichletCompleted_selfDual (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (s : ℂ) :
    dirichletCompleted χ (1 - s) = rootNumber χ * dirichletCompleted χ s
```

**Proved.**  With `h(s) = N^(s/2) · Λ_χ(s)`, the conclusion is `h(1-s) = ε · h(s)`,
`ε = rootNumber χ`.  It is the rearrangement of Mathlib's
`IsPrimitive.completedLFunction_one_sub`
(`Λ_χ(1-s) = N^(s-1/2) · ε · Λ_χ⁻¹(s)`) using `hχinv : χ⁻¹ = χ` and `Complex.cpow_add`
to combine `N^((1-s)/2) · N^(s-1/2) = N^(s/2)`.  `[NeZero N]` supplies `N ≠ 0`; it is
forced by the type `DirichletCharacter ℂ N`.

The companion reality lemma is **conditional**:

```lean
theorem dirichletCompleted_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ s, completedLFunction χ (conj s) = conj (completedLFunction χ s)) (s : ℂ) :
    dirichletCompleted χ (conj s) = conj (dirichletCompleted χ s)
```

The factor `N^(s/2)` is conjugation-equivariant by `Complex.cpow_conj`
(`arg N = 0 ≠ π`); the `hreal` input on `Λ_χ` is now **discharged** for every real character
by `DirichletConj.completedLFunction_conj` (Section 4).

---

## 4. Conjugation of the completed L-function — PROVED (new file `DirichletConj.lean`)

`DirichletConj.lean` supplies the second missing Mathlib lemma, and more:

```lean
theorem LSeries_conj (f : ℕ → ℂ) (s : ℂ) :
    conj (LSeries f (conj s)) = LSeries (fun n => conj (f n)) s

theorem Complex.Gammaℝ_conj (s : ℂ) : Gammaℝ (conj s) = conj (Gammaℝ s)

theorem DirichletCharacter.LFunction_conj_of_one_lt_re (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) {s : ℂ} (hs : 1 < s.re) :
    LFunction χ (conj s) = conj (LFunction χ s)

theorem DirichletCharacter.gammaFactor_conj (χ : DirichletCharacter ℂ N) (s : ℂ) :
    gammaFactor χ (conj s) = conj (gammaFactor χ s)

theorem DirichletCharacter.completedLFunction_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    completedLFunction χ (conj s) = conj (completedLFunction χ s)

theorem completedRiemannZeta_conj (s : ℂ) :
    completedRiemannZeta (conj s) = conj (completedRiemannZeta s)
```

**Proved, for every `N` and every `χ` with real values.**  This is exactly the hypothesis
Route B needs (`CompletedLFunctionConj` for a real character), and it is *unconditional* in
`N` and in the parity/primitivity of `χ`:

* `χ ≠ 1` (all nontrivial real characters, primitive or not): here `completedLFunction χ`
  is entire (`differentiable_completedLFunction`), the identity holds on `1 < re s`
  (`LFunction_conj_of_one_lt_re` + `gammaFactor_conj`), and the identity theorem extends
  it; the file treats all cases uniformly by the `completedLFunction₀` route below.
* `χ = 1`, `N = 1`: `completedLFunction = completedRiemannZeta`
  (`completedLFunction_modOne_eq`), so `completedRiemannZeta_conj` is the specialisation.
* `χ = 1`, `N > 1` (genuine pole at `s = 1`): the identity theorem cannot be applied
  directly, so it is applied to the *entire* normalisation `ZMod.completedLFunction₀ χ`
  (which differs from `completedLFunction χ` by the two pole terms of
  `ZMod.completedLFunction_eq`); conjugating those terms is elementary because `N` is
  nonnegative real and `χ` is real.  This closes the case with the pole.

No case is left open.  The `#print axioms` of all eleven headline lemmas is
`[propext, Classical.choice, Quot.sound]`.

*Note on `Generic.lean`:* its `CompletedLFunctionConj χ` definition is left unchanged; the
hypothesis `hreal : CompletedLFunctionConj χ` of `routeB_for_dirichletL` is now
dischargeable from `∀ n, conj (χ n) = χ n` via `completedLFunction_conj`, which is exactly
the situation of the 011 application (a real primitive character).

---

## 5-pre. Status of the two interfaces of goal `goal-e883bde9`

| interface | status |
|---|---|
| **`DigammaGrowthBound σ0`** | ✅ **THEOREM** for every `σ₀ > 0` — `digammaGrowthBound_of_pos` (`GammaBounds.lean`) |
| **`CriticalStripLogDerivBound χ`** | ❌ not proved; interface correct (§119), ingredients located, residual is genuine |

**`DigammaGrowthBound`** was expected to need complex Stirling.  It needed **none of it**.  The route
found instead (§§123–155): bound `‖logDeriv (GammaSeq · n) s‖` **uniformly in `n`** by `ℝ`-level
elementary analysis; identify `logDeriv (GammaSeq · n) s = log n − ∑_{j<n+1}(s+j)⁻¹`; realise `Γ_n` is
the **Mellin transform** of a compactly supported kernel (`mellin_gammaKernel`); get
`deriv Γ_n → deriv Γ` by dominated convergence (`tendsto_mellin_log_gammaKernel`); pass the uniform
bound through the limit (`tendsto_Lseq_digamma` → `digammaGrowthBound_of_one_le`), and extend from
`σ₀ ≥ 1` to all `σ₀ > 0` by the recurrence.  **36 named results in `GammaBounds.lean`** carry this.

**`CriticalStripLogDerivBound`** — see the separate section below, "Part (A): the precise remaining
specification".  In short: its ingredients are now largely located (Hadamard three-lines §158–159, the
archimedean half §162, Jensen's zero count §166), but the packaging needs the **complex Gamma
asymptotics** of the section "The precise Mathlib gap: complex Stirling", which remain genuinely
absent and are essential to the Gamma *ratio* in the functional equation.

## 5. The two named `Prop`s are now theorems

`Generic.lean` names two Mathlib gaps as `Prop`-valued definitions (never axioms):

```lean
def RootNumberSign (χ : DirichletCharacter ℂ N) : Prop :=
  rootNumber χ = 1 ∨ rootNumber χ = -1

def CompletedLFunctionConj (χ : DirichletCharacter ℂ N) : Prop :=
  ∀ s, completedLFunction χ (conj s) = conj (completedLFunction χ s)
```

Both are now **discharged**:

* `CompletedLFunctionConj χ` is `DirichletCharacter.completedLFunction_conj` (Section 4), for
  every character with real values `∀ n, conj (χ n) = χ n`.
* `RootNumberSign χ` is `RootNumber.lean`: `rootNumber_eq_one_or_neg_one` proves
  `rootNumber χ = 1 ∨ rootNumber χ = -1` for `χ` primitive, `χ ≠ 1`, `IsQuadratic χ`.  Since
  `IsQuadratic χ` already says the values are `0, ±1`, it also gives `∀ n, conj (χ n) = χ n`
  (`conj_eq_self_of_isQuadratic`), so the quadratic hypothesis feeds **both** gaps.

```lean
theorem rootNumber_eq_one_or_neg_one (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) :
    rootNumber χ = 1 ∨ rootNumber χ = -1

theorem rootNumberSign_of_isQuadratic (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) :
    RootNumberSign χ

theorem conj_eq_self_of_isQuadratic (hχ2 : χ.IsQuadratic) : ∀ n : ℕ, conj (χ n) = χ n

theorem isQuadratic_of_conj_eq_self (hreal : ∀ n : ℕ, conj (χ n) = χ n) : χ.IsQuadratic
```

**Why `IsPrimitive χ` appears in the signature (and `hχ1`).**  Mathlib documents `rootNumber`
as "for `χ` primitive; junk otherwise".  Without primitivity the statement is simply false:
the nontrivial quadratic character modulo `3`, extended to modulus `6` by `changeLevel`, takes
the values `0, 1, 0, 0, 0, -1`, has Gauss sum `ω - ω⁵ = I√3` (`ω = exp (2πI/6)`), is odd, and
so has `rootNumber χ = I√3 / I / √6 = 1/√2 ≠ ±1`.  Every application already assumes
`IsPrimitive χ` (see `routeB_for_dirichletL_of_real`/`_unconditional`).  `χ ≠ 1` is used only
to know `Λ_χ(1) ≠ 0` (nonvanishing of `L(χ,1)` plus the Gamma factor), which lets the
functional equation be divided by it.

The proof of `rootNumber_sq_eq_one_of_inv_eq_self` does **not** use `gaussSum_sq` (Mathlib has
it only for characters on a finite *field*, so only for prime modulus) but the functional
equation itself: for `χ⁻¹ = χ`, `Λ_χ(1-s) = N^(s-1/2)·ε·Λ_χ(s)` with `ε = rootNumber χ`.
Applying it at `1 - s`, substituting, and evaluating at `s = 1` gives `ε² = 1`.

### 5a. The `gaussSum_sq` route now works at composite moduli (`GaussSumComposite.lean`)

Mathlib's `MulChar.gaussSum_sq` sits in a `[Field R]` section and its proof divides by `b⁻¹`,
so it does not apply to `ZMod N` for composite `N`.  `GaussSumComposite.lean` removes exactly
that restriction via the discrete Fourier transform on `ZMod N`, which exists for every `N`
(`Mathlib/Analysis/Fourier/ZMod.lean`):

```lean
theorem gaussSum_mul_gaussSum_inv_eq_card (hχ : IsPrimitive χ) :
    gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar = χ (-1) * (N : ℂ)

theorem gaussSum_sq_of_isPrimitive (hχ : IsPrimitive χ) (hχ₁ : χ ≠ 1) (hχ₂ : IsQuadratic χ) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (N : ℂ)

theorem gaussSum_sq_of_isPrimitive_prime [Fact p.Prime] (…) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (p : ℂ) ∧
      gaussSum χ stdAddChar ^ 2 = χ (-1) * (Fintype.card (ZMod p) : ℂ)
```

The computation: for primitive `χ`, `𝓕 χ k = χ⁻¹ (-k) * τ`; Fourier inversion gives
`𝓕 (𝓕 χ) k = N * χ (-k)` on one side, while substituting and reindexing `j ↦ -j` gives
`𝓕 (𝓕 χ) k = τ * gaussSum χ⁻¹ (stdAddChar.mulShift k) = τ * χ k * gaussSum χ⁻¹ stdAddChar`
on the other (`gaussSum_mulShift_of_isPrimitive`).  Comparing at `k = 1` gives the product
identity, and `hχ₂.inv` (`χ⁻¹ = χ`) gives the square.  The hypothesis `hχ₁ : χ ≠ 1` is kept
only for parity with Mathlib's field-case statement; the Fourier proof does not use it.  The
file also proves the new `DirichletCharacter.IsPrimitive.inv`.

The same identity re-derives the root-number sign as a **second, independent** proof
(`RootNumber.lean` stays as the functional-equation proof):

```lean
theorem rootNumber_eq_one_or_neg_one' (hχ : IsPrimitive χ) (hχ₁ : χ ≠ 1) (hχ₂ : χ.IsQuadratic) :
    rootNumber χ = 1 ∨ rootNumber χ = -1
```

Indeed `rootNumber χ = τ / I^a / N^(1/2)` with `a = 0` for even and `a = 1` for odd `χ`, so
`rootNumber χ ^ 2 = χ(-1)·N / ((-1)^a · N) = 1` by `gaussSum_sq_of_isPrimitive`, `(I^a)² = (-1)^a`,
`(N^(1/2))² = N` and `χ(-1) = (-1)^a`; then `sq_eq_one_iff` gives `±1`.
`python/check_gausssum_sq.py` checks `τ² = χ(-1)·N` numerically for every primitive
quadratic character at `N = 8, 12, 20, 24`, and the failure at `N = 6` for the imprimitive lift
of `χ_3` (`τ² = -3 ≠ χ(-1)·N = -6`).

`Generic.lean` itself is unchanged (its `routeB_for_dirichletL` still takes `hε : RootNumberSign χ`
and `hreal : CompletedLFunctionConj χ` as hypotheses; both are now supplyable).

---

## What is assumed rather than proved — one-line audit

* **Proved:** Route B is general in `F` (`routeB_of_selfDualReal`) and even up to sign
  (`routeB_of_selfDualRealUpToSign`, via `logDeriv_one_sub_of_const_mul`); Route A
  certificates are general (`CertifiedZero.exists_unique_root`); the `n`-tail Route C
  bound is general (`validated_truncation_bound_finset`); the Dirichlet normalised
  functional equation is proved (`dirichletL_normalised_one_sub`); reality of the
  normalised function given reality of `Λ_χ` is proved (`dirichletCompleted_conj`); and
  reality of `Λ_χ` itself is now proved in `DirichletConj.lean` for every real character
  and every level (`DirichletCharacter.completedLFunction_conj`, plus
  `completedRiemannZeta_conj`; axiom audit in `AxiomsConj.lean`); `RootNumberSign χ` is
  proved in `RootNumber.lean` for every nontrivial quadratic primitive character
  (`rootNumber_eq_one_or_neg_one` / `rootNumberSign_of_isQuadratic`); and the composite-modulus
  Gauss-sum square `gaussSum_sq_of_isPrimitive` is proved in `GaussSumComposite.lean`, which
  also supplies the second, independent proof `rootNumber_eq_one_or_neg_one'` via that route.
* **Assumed (as explicitly named hypotheses, not axioms):** only the same
  zero-data/analyticity/integrability inputs every Route B statement needs
  (`han, hmem, hm, hno, hint₀, hint₁`).
  `CompletedLFunctionConj χ` is no longer an irreducible assumption: it follows from
  `∀ n, conj (χ n) = χ n`, which holds for every real character (and in particular for every
  quadratic one, via `conj_eq_self_of_isQuadratic`).  `RootNumberSign χ` likewise follows from
  `IsPrimitive χ`, `χ ≠ 1`, `IsQuadratic χ`.
* **Not instantiated at all:** the zero set `Z`, orders `m`, and the hypotheses `han`,
  `hmem`, `hm`, `hno`, `hint₀`, `hint₁` are not discharged for any concrete `χ`
  (no explicit Dirichlet `Z` is produced).

---

## `DirichletRouteB.lean` — both gaps discharged inside Route B

`Generic.lean` states `routeB_for_dirichletL` conditional on two `Prop`s Mathlib did not supply,
`RootNumberSign χ` and `CompletedLFunctionConj χ`.  Both are now **theorems**
(`DirichletCharacter.completedLFunction_conj` from `DirichletConj.lean`;
`rootNumberSign_of_isQuadratic` from `RootNumber.lean`), so this file discharges them:

```lean
theorem RouteABC.completedLFunctionConj_of_real (hreal : ∀ n : ℕ, conj (χ n) = χ n) :
    CompletedLFunctionConj χ

theorem RouteABC.routeB_for_dirichletL_of_real (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ)
    (hε : RootNumberSign χ) (hreal : ∀ n : ℕ, conj (χ n) = χ n) (… same analytic data …) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))

theorem RouteABC.routeB_for_dirichletL_unconditional (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ)
    (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) (… same analytic data …) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

**No named hypothesis remains** beyond the shared analytic data
(`han, hmem, hm, hno, hint₀, hint₁`, still undischarged for any concrete character).
`routeB_for_dirichletL_unconditional` is `routeB_for_dirichletL_of_real` with
`hε := rootNumberSign_of_isQuadratic χ hχ hχ1 hχ2` and `hreal := conj_eq_self_of_isQuadratic χ hχ2`.

---

## `DirichletAnalytic.lean` — the analytic hypotheses discharged

`DirichletRouteB.routeB_for_dirichletL_unconditional` still asks for three *analytic* inputs:
`han` (analyticity on the closed rectangle), `hint₀` and `hint₁` (interval integrability of
`logDeriv (dirichletCompleted χ)` on the two horizontal edges).  All three are now theorems, for
**every** nontrivial Dirichlet character — no primitivity, no reality, no quadraticity:

```lean
theorem RouteABC.analyticAt_dirichletCompleted (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (s : ℂ) :
    AnalyticAt ℂ (dirichletCompleted χ) s

theorem RouteABC.analyticAt_dirichletCompleted_of_mem (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {t0 t1 : ℝ} {s : ℂ} (hs : s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1)) :
    AnalyticAt ℂ (dirichletCompleted χ) s

theorem RouteABC.differentiable_dirichletCompleted (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    Differentiable ℂ (dirichletCompleted χ)

theorem RouteABC.continuousOn_logDeriv_dirichletCompleted (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (t : ℝ)
    (hne : ∀ x ∈ Set.uIcc (0 : ℝ) 1, dirichletCompleted χ (x + t * Complex.I) ≠ 0) :
    ContinuousOn (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t * Complex.I)) (Set.uIcc 0 1)

theorem RouteABC.intervalIntegrable_logDeriv_dirichletCompleted (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {t0 t1 : ℝ} (t : ℝ) (ht : t ∈ Set.uIcc t0 t1)
    (hne : ∀ x ∈ Set.uIcc (0 : ℝ) 1, dirichletCompleted χ (x + t * Complex.I) ≠ 0) :
    IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t * Complex.I)) volume 0 1
```

**How.**  `dirichletCompleted χ s = N^(s/2) · Λ_χ(s)`: the factor `s ↦ N^(s/2)` is entire
(`AnalyticAt.cpow` with the base `N ∈ slitPlane`, since `N ≥ 1` by `NeZero N`) and `Λ_χ` is
entire for `χ ≠ 1` (`differentiable_completedLFunction`); `AnalyticAt.mul` finishes it.  For the
log-derivative, `logDeriv h = deriv h / h`; `deriv h` is continuous (`h` analytic ⟹ `ContDiff ℂ 1`
⟹ `Continuous (deriv h)` by `ContDiff.continuous_deriv_one`), `h` is continuous, and `hne` keeps
the denominator away from `0`, so `ContinuousOn.div` applies; `ContinuousOn.intervalIntegrable`
on the compact `[0,1]` gives the integrability.  (The hypothesis `ht` in the last signature is
inert — only the single segment `im = t` matters — but kept for interface fidelity.)

**Packaging.**  The corollary `routeB_for_dirichletL_of_zeros` calls
`routeB_for_dirichletL_unconditional` with `han`/`hint₀`/`hint₁` supplied.  The edge
non-vanishing hypotheses of the intermediate statement are **not** needed: `hmem` puts every
`z ∈ Z` strictly between the two edges (`t0 < z.im < t1`), so no point with `im = t0` or `im = t1`
lies in `Z`, and `hno` gives non-vanishing there.  What remains is exactly the numerical zero
data.

```lean
theorem RouteABC.routeB_for_dirichletL_of_zeros (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ)
    (Z : Finset ℂ) (m : ℂ → ℕ)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → dirichletCompleted χ u ≠ 0) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

Every new theorem has `#print axioms = [propext, Classical.choice, Quot.sound]`
(`AxiomsConj.lean`).  There is no `sorry`, `axiom`, `admit`, `native_decide` or
`set_option maxHeartbeats` in the file.  It import-depends only on `Generic.lean` and
`DirichletRouteB.lean`; `AxiomsConj.lean` now also imports it, so when
`./check.sh --all` is extended the new file must be listed **before** `AxiomsConj.lean`
(`check.sh` itself is left to its owner).

## Explicit-formula chain (rounds 1–17)

The 23-file build now includes the three proved tail bounds and the explicit-formula
machinery: `DirichletLogDeriv` (prime half `−L'/L = LSeries(Λ·χ)`), `DirichletGammaLogDeriv`
(archimedean half `logDeriv Γ_ℝ`), `DirichletCompletedLogDeriv` (assembled integrand),
`DirichletWeightedResidue` + `DirichletWeightedArgumentPrinciple` (contour step),
`DirichletCompletedSymmetry` (reflection symmetries and the zero side `dirichletCompleted_zeroSum`),
`DirichletRightPathLinear`, and `DirichletExplicitWiring` (which discharges
`DirichletExplicitData.h_identity` and yields `routeC_residual_bound_of_zeroSum`).

---

## The Mellin contour shift and the explicit formula (`DirichletMellinPrereq.lean`)

`DirichletMellinPrereq.lean` formalises the **standard Dirichlet `L` explicit formula**
`archimedean − prime = zero sum` on the line `Re s = c > 1`, end to end:

* **domination and convergence** — `norm_dirichletWeight_mul_cpow_le`, `summable_vonMangoldt_rpow`,
  `summable_dirichletWeight_cpow`, `tsum_norm_dirichletWeight_le` (a bound *independent of `s`*),
  `norm_contour_integrand_le`/`_global`, `norm_horizontal_integrand_le`;
* **termwise integration** (both orientations) — `termwise_integral_of_dominated`,
  `contour_termwise_integral_measure`, `contour_termwise_integral` (vertical),
  `hLine_termwise_integral` (horizontal);
* **archimedean − prime on `Re > 1`** — `contour_cLine_eq_arch_sub_prime` (vertical),
  `contour_hLine_eq_arch_sub_prime` (horizontal, needs `c₀ > 1`);
* **the contour move** — `verticalLine_transport` (Cauchy–Goursat for a rectangle, from Mathlib's
  `Complex.integral_boundary_rect_eq_zero_of_differentiable_on_off_countable`),
  `rightPath_transport` (moves `rightPath`'s vertical edge from `Re = 1` out to `Re = c > 1`);
* **the assembled formula** — `dirichlet_explicit_formula_assembled`;
* **side-conditions** — `dirichletCompleted_ne_zero_of_one_lt_re`,
  `continuousOn_mul_logDeriv_dirichletCompleted`, `differentiableAt_mul_logDeriv_dirichletCompleted`,
  `continuous_digamma_halfLine`, `intervalIntegrable_arch`, `intervalIntegrable_LSeries`,
  `LSeriesSummable_dirichletWeight`, `abscissaOfAbsConv_dirichletWeight_le_one`;
* **tail bounds** — `abs_re_tsum_le`, `abs_primeTail_le`, `norm_integral_primeTerm_le`,
  `tsum_shift_le`, `shifted_vonMangoldt_tail_le`;
* **zero-counting strip input** — `norm_LSeries_dirichletWeight_le`
  (the `O(1)` half of `‖Λ_χ'/Λ_χ(c+it)‖ ≤ C·log(q(|t|+2))`).

The four integral hypotheses `hint₀/hint₁/hint0/hint1` are **not** discharged, and cannot be: they
require the horizontal segment to avoid the zeros of `dirichletCompleted χ`.  Everything else is
proved.

### The explicit formula, horizontal-edge form

`dirichlet_explicit_formula_assembled` states

    π·Re(∑_{z∈Z} m z·F z)
      = Re(∫_{t₀}^{t₁} F(c+it)·(½log N − ½log π + ½ψ((c+it)/2)) dt)
        − Re(∑' n, ∫_{t₀}^{t₁} F(c+it)·Λ(n)χ(n)n^{−(c+it)} dt)
        + Im(∫_{1/2}^{c} g(x+it₀) dx − ∫_{1/2}^{c} g(x+it₁) dx),     g = F·Λ_χ'/Λ_χ.

The horizontal edge terms are **correct and unavoidable** for a finite rectangle; the horizontal
run over `Re ∈ [1,c]` touches `Re = 1`, where `Σ Λ(n)/n` diverges (§60).  They cancel only in the
limit `t₀,t₁ → ∓∞` (for decaying `F`).

## Wiring into `DirichletExplicitData` (`DirichletExplicitWiring2.lean`)

* `assembledRhs`, `dirichletExplicitDataOfAssembled` — `h_identity` discharged from the assembled
  formula; `routeC_residual_bound_of_assembled`;
* `tsum_eq_finite_add_tail`, `dirichletExplicitDataOfTruncation`,
  `routeC_residual_bound_of_truncation` — `h_split` discharged by truncation;
* `dirichletExplicitDataOfAssembledTruncated` — **both** fields discharged (identity + split).

So `DirichletExplicitData` carries no analytic or truncation hypothesis beyond the unavoidable
zero-avoidance conditions.

## Zero counting (`DirichletZeroCounting.lean`)

* `dirichletLZeros`, `mem_dirichletLZeros`, `isClosed_dirichletLZeros`, `isDiscrete_dirichletLZeros`,
  `IsCompact.inter_dirichletLZeros_finite`, `dirichletCompleted_routeBCount`;
* `dirichletZeroCount`, `dirichletZeroCountIn`, `dirichletZeroCountUpTo`,
  `finite_dirichletZeroCount_set`, `finite_dirichletZeroCountUpTo_set`,
  `dirichletZeroCountUpTo_mono`, `dirichletZeroCountUpTo_eq_add`,
  `dirichletZeroCountUpTo_le_sum`, `sum_countIn_range_le`, `zeroCountUpTo_le_of_density`,
  `zeroCountUpTo_le_of_density_real`, `zeroCountUpTo_le_quadratic`, `densitySpacing_le_zero`,
  `zeroTail_le_of_density`;
* **`RiemannVonMangoldtDensity χ`** — the named interface
  `∃ C > 0, ∀ T ≥ 2, dirichletZeroCount χ T ≤ C·log(q(T+2))`.

Everything **downstream** of `RiemannVonMangoldtDensity` is proved:
`RiemannVonMangoldtDensity` → cumulative bound → quadratic bound → spacing `γₙ ≳ √n` → zero-tail
domination.  The **asymptotic itself** (the `log` main term, via the argument principle) is the one
open item, and is research-scale — Mathlib provides neither it nor the digamma-series growth input
it needs.

---

## Final state (goal `goal-0b76cf87`, rounds 24–48)

**Strand (1) — the Mellin contour shift — is complete.** Convergence, termwise integration (both
orientations), `archimedean − prime` on `Re > 1`, Cauchy transport, the `rightPath` move, the
assembled explicit formula, the `DirichletExplicitData` wiring, and every dischargeable
side-condition.  See `DirichletMellinPrereq.lean` and `DirichletExplicitWiring2.lean`.

**Strand (3) — the numerical truncation — is complete.** `h_split` is a theorem
(`dirichletExplicitDataOfTruncation`, `dirichletExplicitDataOfAssembledTruncated`), and the prime
tail is bounded by the explicit constant `(t₁ − t₀)·B·∑' n, Λ(n)·n^{−c}`
(`abs_primeTail_le`, `norm_integral_primeTerm_le`, `tsum_shift_le`, `shifted_vonMangoldt_tail_le`).

**Strand (2) — zero counting — is complete to its named interface.**  `RiemannVonMangoldtDensity`
(`DirichletZeroCounting.lean`) is the single named hypothesis, and everything downstream of it is
proved: cumulative and quadratic bounds, the spacing `γₙ ≳ √n`, and the zero-tail domination
(`zeroTail_le_of_density`), which discharges the density input `DirichletZeroTail.lean` previously
assumed.

### What is *not* proved, and why

1. **The Riemann–von Mangoldt `log` main term itself.**  It needs the **growth bound on `digamma`**
   `‖ψ(σ+it)‖ ≲ log(|t|+2)`.  Mathlib has exactly one digamma file and **no series representation,
   no bound, no asymptotic**; its Bohr–Mollerup development is *real* only.  The named interface
   `DigammaGrowthBound` (`DirichletMellinPrereq.lean`) records the gap.

2. ~~**The strip estimate `‖Λ_χ'/Λ_χ(c+it)‖ = O(1 + log(|t|+2))`.**~~  **NOW PROVED**
   (`norm_logDeriv_dirichletCompleted_le_of_digamma`).  The rounds-45/46/48 heartbeat timeouts were
   caused by `Complex.digamma` unfolding to `logDeriv Complex.Gamma`: *every* defeq check mentioning
   `Complex.digamma` had to reduce that tower.  Wrapping it in an `@[irreducible]` def `digammaC`
   (and stating `DigammaGrowthBound` through it) removes the unfolding and the proof elaborates
   immediately.  `norm_logDeriv_sub_arch_le` supplies the `O(1)` difference; the digamma bound
   supplies the growth.

3. **The argument-principle assembly** around the rectangle, which would turn the (now proved)
   strip estimate into the count `N(T+1) − N(T) = O(log qT)` and then into the main term.

### Verification

* `./check.sh --all` — **26/26 `[check] OK`**
* `python3 verify/check_claims.py` — **`ALL CHECKS PASSED`**
* No `sorry`, no `axiom`, no `admit`, no `native_decide`, no `set_option maxHeartbeats`.
* Every theorem added in rounds 24–48 footprint-checks to `[propext, Classical.choice, Quot.sound]`
  (see `AxiomsL.lean`).

---

## Riemann–von Mangoldt: state at goal `goal-0b76cf87`

**Discharged:** `RiemannVonMangoldtDensity χ` — proved in
[`DirichletZeroCount2.lean`](../lean/DirichletZeroCount2.lean) as
`riemannVonMangoldtDensity_of_criticalStrip`, from two named hypotheses.

**The chain (all machine-checked, footprints `[propext, Classical.choice, Quot.sound]`):**

| step | theorem | file |
|---|---|---|
| strip estimate on `Re s = c > 1` | `norm_logDeriv_dirichletCompleted_le_of_digamma` | `DirichletMellinPrereq` |
| segment log-derivative bound after transport | `norm_rightPath_le_of_transport` | `DirichletMellinPrereq` |
| argument-principle count bound | `dirichletCompleted_zeroCount_le_of_contour` | `DirichletZeroCounting` |
| `O(log qT)` weighted count | `dirichletCompleted_zeroCount_le_of_criticalStrip` | `DirichletZeroCounting` |
| `ncard ≤ Σ order` | `ncard_le_sum_analyticOrder`, `dirichletZeroCountIn_le_orderSum` | `DirichletZeroCounting` |
| finite order at every point | `analyticOrderAt_ne_top_dirichletCompleted` | `DirichletZeroCounting` |
| composition step | `dirichletZeroCount_le_of_sum_bound` | `DirichletZeroCounting` |
| the `Z` construction (four-sided `hno`) | `exists_Z_of_hbd` | `DirichletZeroCount2` |
| the two `hint` conjuncts | `zeroFreeSegment_of_hbd`, `logDerivIntegrable_of_zeroFreeSegment`, `logDerivIntegrable_of_hbd` | `DirichletZeroCount2` |
| **assembly** | `dirichletZeroCount_le_of_hbd`, `riemannVonMangoldtDensity_of_criticalStrip` | `DirichletZeroCount2` |

**Two named hypotheses remain, both Mathlib gaps rather than formalisation gaps:**

1. **`CriticalStripLogDerivBound χ`** — `‖Λ_χ'/Λ_χ(σ+it)‖ ≪ log(q(|t|+2))` for `1/2 ≤ σ ≤ 2`.  The
   branch `σ > 1` is **proved** unconditionally (`norm_logDeriv_dirichletCompleted_le_of_digamma`).
   The critical-strip range needs the functional equation plus a growth (convexity) bound on `L`;
   **Mathlib has no such bound**.
2. **`hbd`** — the rectangle's boundary is zero-free.  Two parts:
   * `Re = 1`: needs `L(1,χ) ≠ 0`, the classical non-vanishing of `L(1,χ)`.  **Not in Mathlib**
     (only `LSeries_ne_zero_of_one_lt_re` is).
   * `Im = T`, `Im = T + 2`: the zeros' imaginary parts are discrete, so these fail only for
     countably many exceptional `T`; the exceptional cases need a shift argument, which is
     formalisable from `isDiscrete_dirichletLZeros`.

**Part (C), `DigammaGrowthBound`** — the complex digamma series
`ψ(z) = −γ + Σ_{k≥0} (1/(k+1) − 1/(z+k))` and its `O(log|t|)` growth.  **Mathlib has no complex
digamma series or asymptotic** (its `Complex.digamma` is defined as `logDeriv Gamma` with essentially
no API), so this is a substantial development, not a cleanup.

**Methodology lessons recorded in the journal** (worth keeping):
* when a *statement* will not elaborate, wrap the expensive subterm in an `@[irreducible] def` (§80);
* when a *proof term* will not elaborate, **abstract the composition into a theorem whose statement
  forgets the expensive subterms**, then instantiate (§90);
* when a proof *still* will not elaborate, **cut the statement in half at the point where the two
  normalforms meet** (§93).

---

## CORRECTION (goal `goal-0b76cf87`, round 79) — `hbd` is gone

The section above ("Riemann–von Mangoldt: state at goal …") lists **two** remaining hypotheses:
`CriticalStripLogDerivBound` and `hbd`.  **`hbd` no longer exists.**

Two developments removed it:

1. **The horizontal sides** `Im = T`, `Im = T + 2` were discharged by the shift argument
   (`exists_hbd_shift`, `exists_Z_shift`, `dirichletZeroCount_le_countIn`) — they are now
   **hypothesis-free**.
2. **The vertical sides** `Re = 0, 1` were discharged by `verticalFree_of_ne_one`:
   `DirichletCharacter.LFunction_ne_zero_of_re_eq_one` from
   **`Mathlib/NumberTheory/LSeries/Nonvanishing.lean`** (a file the earlier audit missed) gives
   non-vanishing on `Re s = 1`, and `nonvanishing on Re s = 0` follows from the functional equation.

**Current state — the remaining hypotheses for the whole route are exactly two:**

| # | hypothesis | status |
|---|---|---|
| 1 | `CriticalStripLogDerivBound χ` on `1/2 ≤ σ ≤ 1` | branch `σ > 1` **proved** (§80); the critical strip needs a convexity/growth bound on `L`, absent from Mathlib |
| 2 | `DigammaGrowthBound σ0` | reduced to the fixed strip `1 ≤ σ ≤ 2` (§97); needs the digamma asymptotic, absent from Mathlib |

and the main theorem is

```lean
theorem riemannVonMangoldtDensity_of_interface
    (hcs : CriticalStripLogDerivBound χ) : RiemannVonMangoldtDensity χ
```

in `DirichletZeroCount2.lean`.  All of `hbd`, `hZ`, `htop` are discharged.

---

## Process guidance for this development (`goal-e883bde9`, part C)

These are not style preferences.  Each was earned by a specific failure in this session, and each
cost multiple rounds to learn.  They are recorded here so the next person does not pay again.

### 1. Elaboration techniques, in escalation order

When Lean will not elaborate something, the cause is almost always that a **large definition is being
reduced where it need not be** — not that the mathematics is hard.  Escalate in this order:

1. **Statement** will not elaborate → wrap the expensive subterm in an `@[irreducible] def` and state
   results through the wrapper.  *(`Complex.digamma` unfolds to `logDeriv Gamma`; wrapping it as
   `digammaC` turned three rounds of heartbeat timeouts into an immediate proof — §80.)*
2. **Proof term** will not elaborate → **abstract the composition** into a theorem whose statement
   forgets the expensive subterms, then instantiate.  *(`dirichletZeroCount_le_of_sum_bound` (§90):
   five monolithic attempts died; this one-line abstraction worked.)*
3. **Still** will not elaborate → **cut the statement in half** at the point where the two
   normalforms meet.  *(`zeroFreeSegment_of_hbd` / `logDerivIntegrable_of_zeroFreeSegment` (§93).)*
4. A **trivial packaging step** keeps failing → **split it into independently stated lemmas**.
   *(Two monolithic attempts at the shift packaging failed on `T ± δ` normalisation; three stated
   lemmas succeeded first time — §104.)*

Do **not** reach for `set_option maxHeartbeats`.  It was tried once (§89), at 10× the default, and
the timeout persisted — confirming the cause was reduction, not budget.

### 2. Check every named `Prop` for satisfiability

A hypothesis introduced to name a gap **must be checked for satisfiability** before anything is built
on it.  The proof term can be perfectly fine while the *statement* is false, and no `sorry`-check,
no axiom-check and no elaboration error will catch it.

This bit twice in this development:

| interface | was it satisfiable? |
|---|---|
| `RootNumberSign` | yes |
| `CompletedLFunctionConj` | yes |
| `DigammaGrowthBound` | **no** — it quantified over a half-plane; `t = 0, σ → ∞` refutes it (§96) |
| `CriticalStripLogDerivBound` | **no** — it bounded `logDeriv` across the whole strip, where `logDeriv` has poles at the zeros (§109) |

Both were fixed (line-based and zero-free-conditional respectively).  After fixing one such interface,
**sweep all the others** — §96 fixed `DigammaGrowthBound` and did not sweep, and the second false
hypothesis survived ten further rounds underneath an apparently complete development.

### 3. Audit a Mathlib directory file-by-file before declaring a gap

A targeted `grep` over the two files you expect is not an audit.  For ten rounds this development
recorded "`L(1+it,χ) ≠ 0` is not in Mathlib"; it *is* — in
`Mathlib/NumberTheory/LSeries/Nonvanishing.lean`, a third file of a three-file development that had
been searched in two files (§106).  That find deleted one of three named gaps outright.

**Rule:** to claim something is absent, `ls` the directory and read each file's theorem list.

### 4. A hypothesis must *control* the quantity being bounded

Satisfiability is not enough.  `Λ(σ+it) ≠ 0` is satisfiable *and* was supplied at every point of use —
and the interface was **still false**, because `Λ′/Λ = deriv Λ / Λ` is unbounded *near* a zero even
where it is defined (§117).  For every named hypothesis ask, in order:

1. Is it **satisfiable**?
2. Is it **supplied** at every point of use?  (Find the caller.)
3. Does it **control** the quantity being bounded — could that quantity blow up while the hypothesis
   still holds?

A `sorry`-check, an axiom-check and a successful elaboration catch **none** of these.

### 5. A hypothesis may be *redundant*, not a gap

`RootNumberSign` was carried as a named gap for many rounds; it is **derivable**
(`rootNumberSign_of_inv_eq_self`, §120) and was threaded out.  Before declaring a gap, try to prove it
from the hypotheses already present.  The opposite error is equally available: do **not** assume a gap
is shallow because a similarly-named lemma exists — `Complex.Gamma_conj` says nothing about the
Hurwitz-zeta layer under `completedLFunction` (§122).  *A gap is shallow only if its whole unfolding is
shallow.*

### 6. Check each reduction against its *use site*

Two rounds in a row found holes by asking **"who supplies this parameter?"** and **"does this cover the
range the consumer instantiates?"** (§115: the reduction missed `σ₀ ∈ (1/2,1)`; §116: the shift
parameter had no producer at all).  Both were invisible to elaboration, `sorry`-checking and reading
the theorem in isolation.

### 7. State `ℝ`-valued facts in `ℝ`, and get the index right

Rounds 19–23 produced **zero** lemmas while attacking a `ℂ`-valued identity containing `log n` under a
limit variable; the inequality that was actually needed is uniform in `n` and lives in `ℝ` (§131).
From §129 onward, with the order fixed, every round committed.  Related and separately earned: an
inequality's **shift direction and index** must be checked, not assumed — a harmonic sum bounded by
`1 + log(n+1)` is useless where `log n` is needed (§138), and a `⌈·⌉` bound needs **both** inequalities
(§133).  **Rule of thumb for this development: if a statement has failed twice, spend the next round
locating every lemma it needs before writing any proof.**

### 8. `rw` is all-or-nothing across a list

For four rounds, `rw [logDeriv_div …, logDeriv_mul_const …, logDeriv_const, sub_zero, hsum]` appeared
to do nothing.  The cause was that `logDeriv_mul_const` had *already* removed the constant factor, so
`logDeriv_const` had no occurrence — and that failure **silently discarded every earlier step in the
same `rw`** (§148).  **Never diagnose a `rw` failure from the final goal: split the list and
`trace_state` between steps.**

### 9. Choose the statement shape the library already handles

Repeatedly the "hard" step dissolved once the object was written differently:

| wrote | instead of | where |
|---|---|---|
| `if x ≤ n then … else 0` | `(1 − min x n / n)ⁿ` — continuity for `fun_prop` | §150 |
| the `f / g` normalform of functions | `HasDerivAt.div`'s pointwise form | §146 |
| integral comparison | **telescoping** (`1/(a+j)² ≤ 1/(a+j−1) − 1/(a+j)`) | §127 |
| a hand-rolled sum–integral estimate | `AntitoneOn.sum_le_integral` (exists!) | §128 |
| complex Stirling asymptotics | the identity `logDeriv (GammaSeq · n)`, no asymptotics | §144 |

### 10. Write the precise statement you need *before* auditing

Twice this session the decisive find (`hasDerivAt_Gamma_of_re_pos`, §144; `Hadamard.lean`, §157) came
in the round *after* the round that wrote down exactly which theorem was missing.  Vague gaps stay
unfound; a named target is one grep away.

### 11. An interface may be equivalent to the theorem

`CriticalStripLogDerivBound`, once restated in the correct (integral) form, turned out to bound the
very integral whose imaginary part *is* the zero count (§160) — so it is not a "cheap lemma" but a
quantitative form of the Riemann–von Mangoldt theorem.  When a named input is introduced, check
whether it is *equivalent* to the conclusion rather than a stepping stone to it.

---

## Part (A): the precise remaining specification

`CriticalStripLogDerivBound` is **not** a lemma short of completion.  §160 established why: by the
argument-principle identity already proved in `DirichletZeroCounting.lean:84`
(`Im (rightPath (logDeriv Λ) t₀ t₁) = π · ∑_{z∈Z} m z`) together with
`‖rightPath‖ ≤ ∫_{∂R}‖Λ′/Λ‖`, the interface **implies the multiplicity-weighted Riemann–von Mangoldt
count bound**, and the contour integral can be no smaller than the argument variation `2π·∑ m`.
It is a quantitative form of the theorem, not a stepping stone to it.

**What is already committed and reusable:**

| ingredient | where |
|---|---|
| `Λ′/Λ = (1/2)log N + γ′/γ + L′/L` decomposition | `DirichletCompletedLogDeriv.lean` |
| `γ′/γ = −(1/2)log π + (1/2)ψ(s/2)` | `Complex.logDeriv_Gammaℝ` |
| `γ′/γ = O(log)` on the strip — **uniform in σ** | `digamma_norm_le_quarter` (§162) |
| Hadamard three-lines, interpolation form | `norm_le_three_lines` (§158) |
| …with the `exp (δ z²)` regulariser | `norm_le_of_three_lines_regularised` (§159) |
| the `σ > 1` branch | `dirichletCompleted_logDeriv_bound_of_gt_one` |
| the correct (integral) interface | `CriticalStripLogDerivBound` (§119) |
| the reduction interface → count | `riemannVonMangoldtDensity_of_interface` (§121) |

**What is missing, in dependency order.**

1. ~~A non-circular zero count.~~  **DONE — `zeroCount_le_of_jensen` (§§164, 166).**  Mathlib's
   `AnalyticOnNhd.sum_divisor_le` (`Analysis/Complex/JensenFormula.lean:389`) is Jensen's inequality for
   the divisor, and it is now exposed for this development as
   `zeroCount_le_of_jensen`.  The development's own crude count `zeroCountUpTo_le_quadratic` remains
   *downstream* of `RiemannVonMangoldtDensity` and must **not** be used.  What is still needed is the
   *packaging*: choose the disc inside the strip (**Jensen degrades when `f` is exponentially small at
   the centre**, which `Λ` is on the real axis) and bound `M = sup_{|z−c|=R}‖Λ z‖`.
2. **The spacing `N(T+1) − N(T) = O(log T)`.**  This does **not** follow from `N(T) = O(T log T)`.
   The standard route is
   `N(T+1) − N(T) = (1/π)∫_T^{T+1} Im(Λ′/Λ(1/2 + it)) dt + O(log T)`,
   with `∫_T^{T+1}‖Λ′/Λ(1/2 + it)‖ dt = O(log T)` from a mean-square bound on `Λ′`.  *This is the
   genuine content of part (A).*
3. **The boundary margin** it implies: `dist(∂R, zeros) ≫ 1/log T`, hence `|Λ| ≥ e^{−O(log T)}` on
   `∂R`.  With (3), the convexity of `log|Λ|` along each edge (a consequence of §§158–159) bounds
   `∫|Re Λ′/Λ|` per segment, and the argument variation bounds `∫|Im Λ′/Λ|`.
4. **Segment assembly** into §119's `CriticalStripLogDerivBound`.

Steps (3)–(4) are in place or nearly so.  **Step (2) is the theorem**, and it is what part (A) is.

**One caution.**  Do *not* try to weaken the interface to "assume a zero-free margin": that is the
hypothesis the conclusion is *used* to supply, so it re-introduces the circularity of §118 rather than
removing it.

### FINAL STATE (2026-10-13, journals §§169–208): every analytic input for part (A) is committed

The `GammaBounds.lean` development stands at **76 declarations**, all clean-footprint
(`[propext, Classical.choice, Quot.sound]`), with `./check.sh --all` green over **28** files.

**Committed inputs for part (A):**

```lean
-- exponential decay of Gamma, and the archimedean factor, on the strip
norm_Gamma_le_decay_quarter {σ t} (h : 1/4 ≤ σ) (h : σ ≤ 1) :
    ‖Gamma (↑σ + ↑t * I)‖ ≤ 128 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4))
norm_Gammaℝ_le {σ t} (h : 1/2 ≤ σ) (h : σ ≤ 1) :
    ‖Gammaℝ (↑σ + ↑t * I)‖ ≤ 128 * (1 + |t| / 2) ^ (σ / 2) * Real.exp (-(|t| / 8))

-- bounded partial sums of a non-principal character (the partial-summation input)
norm_sum_range_chi_le {N} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (n) :
    ‖∑ k ∈ range n, χ (k : ZMod N)‖ ≤ (N : ℝ)

-- the Abel weight and its telescoping variation (four of step 3a's five sub-lemmas, §§212/215/216)
norm_natCast_cpow_neg (σ : ℝ) (k : ℕ) :
    ‖((k + 1 : ℕ) : ℂ) ^ (-(σ : ℂ))‖ = ((k + 1 : ℕ) : ℝ) ^ (-σ)
sum_Ico_rpow_sub_le {σ : ℝ} (hσ : 0 ≤ σ) {m n : ℕ} (hmn : m ≤ n) :
    ∑ i ∈ Ico m n, (((i + 1 : ℕ) : ℝ) ^ (-σ) - ((i + 2 : ℕ) : ℝ) ^ (-σ)) ≤ ((m + 1 : ℕ) : ℝ) ^ (-σ)
```

**Step 3a's capstone** — `norm_sum_Ico_chi_cpow_le`, the Abel estimate
`‖∑_{m ≤ i < n} χ i · (i+1)^{−σ}‖ ≤ 2·N·(m+1)^{−σ}` — is **fully specified** (§§211/217) with four of
its five sub-lemmas committed.  Its three remaining obstacles are all *statement-shape* bridges, not
mathematics: the `•`-vs-`*` form of `Finset.sum_Ico_by_parts`, the `Complex.ofReal_cpow` cast bridge, and
the `ℂ`/`ℝ` transfer in `‖f (i+1) − f i‖ = ‖f i‖ − ‖f (i+1)‖`.

**Remaining, in order, with the reason each is not done:**

1. **`sup_t ‖LFunction χ (1+it)‖ < ∞`.**  With `norm_sum_range_chi_le` this is a single partial-summation
   estimate: `L(σ+it) = Σ χ(n)n^{−σ−it}` for `σ > 1`, Abel with `N = ⌈|t|⌉` gives the head
   `≤ 1 + log N` and the tail `≤ C(1 + |t|^{1−σ})`, uniformly for `σ ∈ (1,2]`; continuity in `σ` at
   `1` transfers it.  **An afternoon's work, not a research problem.**
2. **`Λ` bounded on the closed strip** via `PhragmenLindelof.vertical_strip` (§157), whose growth
   hypothesis admits `exp(B exp(c|Im|))` for any `c < π` — so `Λ`'s *exponential* growth suffices and
   **no convexity bound on `L` is presupposed** (§203).  The two boundaries carry the *same* value by
   `Λ(s) = ε(s)Λ(1−s)`, so `Re = 0` is never evaluated.
3. **`Λ′/Λ` by Cauchy** on the strip.
4. **The contour assembly into `CriticalStripLogDerivBound`.**

**Do not mistake (4) for a formality.**  §160 established that the contour integral's imaginary part
*is* the zero count: `Im (rightPath (logDeriv Λ) t₀ t₁) = π · ∑_{z ∈ Z} m z`.  Step 4 **is the
Riemann–von Mangoldt theorem**, which is why part (A) remains open and why the interface must not be
weakened to assume a zero-free margin (§118).

---

### UPDATE (2026-10-15, journal §219): step 3a is **DONE**

The tree was **not** green at the start of this round: the 19:15 edit recorded above its final state was
never machine-checked (it added declarations that did not elaborate, one of them — the Abel identity
`sum_Ico_mul_chi_cpow_eq`, whose tail index set was `Ico m n` instead of `Ico m (n-1)` — **false**).
Those declarations are deleted and replaced.  `./check.sh --all` is green again: **29 files, EXIT 0,
0 failures, 0 non-clean footprints, no `sorry`/`admit`/`axiom`/`native_decide`**.
`GammaBounds.lean` now has **96** declarations and `AxiomsL.lean` **210** tracked footprints
(252 footprint lines in the build).

**Delivered (all `[propext, Classical.choice, Quot.sound]`):**

```lean
-- the complex Abel capstone (general coefficient sequence, partial sums ≤ B)
norm_sum_Ico_mul_cpow_le {g : ℕ → ℂ} {B : ℝ} (hB : 0 ≤ B)
    (hg : ∀ k, ‖∑ j ∈ range k, g j‖ ≤ B) {s : ℂ} (hs : 1 ≤ s.re) {m n : ℕ} (hm : 1 ≤ m) (hmn : m < n) :
    ‖∑ i ∈ Ico m n, g i * (i+1 : ℂ) ^ (-s)‖ ≤ (2 + ‖s‖) * B * m ^ (-s.re)

-- the character specialisations
norm_sum_Ico_chi_cpow_le_cmplx, norm_sum_Ico_chi_succ_cpow_le

-- the deliverable of step 3a
norm_LFunction_le {N} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    ∃ C > 0, ∀ σ t, 1 ≤ σ → σ ≤ 2 → ‖LFunction χ (σ + t*I)‖ ≤ C * (1 + Real.log (|t| + 2))
```

`σ = 1` is reached from `σ > 1` by continuity, not by new analysis.  The complex weight is essential:
factoring `n^{-s} = n^{-σ}·n^{-it}` and reusing a *real*-exponent Abel estimate fails because the
partial sums of `χ(n)n^{-it}` are `O(|t| log k)`, which eats the `log`.

### UPDATE (2026-10-15, journal §225): step 3b is **DONE**

`DirichletStripBound.lean` now contains

```lean
norm_mellin_le : f rapidly decaying at 0 and ∞ ⟹ ‖mellin f s‖ bounded on every vertical strip
norm_Lambda0_le, norm_Lambda_le : Λ₀ (weak FE-pair) / Λ (strong FE-pair) bounded on strips
norm_completedLFunction_strip_le : ∃ C > 0, ∀ σ ∈ [0,1], ∀ t, ‖completedLFunction χ (σ+it)‖ ≤ C
norm_dirichletCompleted_strip_le : ∃ C > 0, ∀ σ ∈ [0,1], ∀ t, ‖dirichletCompleted χ (σ+it)‖ ≤ C
```

The `PhragmenLindelof.vertical_strip` route of §203 was **not** used and is not needed: for
non-principal `χ` both correction terms in `ZMod.completedLFunction_eq` vanish, so `Λ_χ` is a finite
combination of `(hurwitzEvenFEPair a).Λ₀` and `(hurwitzOddFEPair a).Λ`; `Λ₀ = mellin f_modif` and
`f_modif` decays faster than every power at **both** `0` (Mathlib's `WeakFEPair.hf_zero`) and `∞`, so
`norm_mellin_le` bounds every vertical strip directly.

**Remaining for part (A):** 3c (`Λ′/Λ` by Cauchy) and 4 (the contour assembly — §160: this *is*
Riemann–von Mangoldt).

---

### UPDATE (2026-10-13, journals §§195–200): the Gamma input is **done**

The section below was written when `norm_Gamma_decay` was believed absent.  **It is now committed**, and
the route turned out to need **no complex Stirling and no lower bound on `Γ`**:

```lean
norm_Gamma_le_decay_quarter {σ t} (hσ0 : 1/4 ≤ σ) (hσ1 : σ ≤ 1) :
    ‖Complex.Gamma (↑σ + ↑t * I)‖ ≤ 128 * (1 + |t|) ^ σ * Real.exp (-(|t| / 4))
```

and `σ ∈ [1/4,1]` is **exactly** what both archimedean factors need: `γ(s) = Γ_ℝ s` (even `χ`) has
`Re(s/2) ∈ [1/4,1/2]`, and `γ(s) = Γ_ℝ (s+1)` (odd) has `Re((s+1)/2) ∈ [3/4,1]`.

**Three structural points settle the remaining doubts.**
1. **The `γ`-ratio is never bounded.**  Three-lines (`norm_le_three_lines`) consumes
   `sSupNormIm f 0` and `sSupNormIm f 1` — boundary **values**, not a ratio.  Bounding
   `γ(1−s)/γ(s)` would need the sharp `e^{−π|t|/4}` per `Γ` factor (the reflection `sin` carries
   `e^{+π|t|/2}`), and the `GammaSeq`/`sup` route caps at `c = 1 < π/2`; **that route is not taken.**
2. **`M₀ = M₁` by the functional equation.**  `Λ(it) = ε(it)·Λ(1−it)` gives `‖Λ(it)‖ = ‖Λ(1−it)‖`, so
   the two boundary sups are equal and both are controlled on `Re = 1`, where `Re((s+a)/2) = 1/2` — in
   range.  The argument `Re = 0` is never evaluated.
3. **`L` needs no growth bound.**  `logDeriv_completedLFunction_eq` gives `Λ′/Λ = γ′/γ + L′/L`
   **algebraically**, so `L′/L = Λ′/Λ − γ′/γ`.

**What actually remains for part (A)** is the assembly, not new analysis:
(a) `‖Λ‖` bounded on the closed strip from the above (the `L` factor by the Dirichlet series at `Re ≥ 1`
and the functional equation below `Re = 0`); (b) `Λ` differentiable on the strip (entire for primitive
`χ ≠ 1`), for `DiffContOnCl`; (c) `norm_le_three_lines` (§158) for the convexity bound;
(d) `Λ′/Λ` from `Λ` by Cauchy; (e) the segment estimates and the contour integral into §119.

---

### (superseded) The single blocking input, stated minimally

Everything above is now either committed or mechanical.  The **one** absent ingredient is an *upper*
bound for `Complex.Gamma` on a vertical line **with exponential decay**:

```lean
-- SUFFICES (any c > 0, any exponent ≥ σ − 1/2):
theorem norm_Gamma_decay : ∃ C c > 0, ∀ σ ∈ [1/2, 2], ∀ t,
    ‖Complex.Gamma (σ + t * I)‖ ≤ C * (1 + |t|) ^ (σ - 1/2) * Real.exp (-c * |t|)
```

**The bar is lower than "complex Stirling".**  The functional equation's Gamma *ratio*
`‖Γ(x+it)/Γ(x′+it)‖` is compared against `O(|t|^{x−x′})`; but any decay `e^{−c|t|}` applied to numerator
and denominator alike delivers `O(1)`, which is **stronger**.  So the sharp constant `π/2` is *not*
needed, and neither is a lower bound (`norm_Gamma_le_Gamma_re` plus a *single* decayed upper bound
suffices).  What *is* needed is *some* `c > 0`.

**Where such a bound can come from, in order of likely payoff:**
1. **Euler limit with a quantitative error term.**  `Γ_n(s) = n^s n!/∏_{j≤n}(s+j)` at `n ≍ |t|` gives
   `‖Γ_n(s)‖ ≲ |t|^σ e^{−|t|}` — the right shape.  The missing step is a *quantitative* bound on
   `Γ(s)/Γ_n(s) − 1`; Mathlib's `Γ_n → Γ` is pointwise only.  **The development's own §154 dominated
   convergence does not give a rate** and cannot be reused here.
2. **Contour rotation** of `Γ(s) = ∫_0^∞ x^{s−1}e^{−x}dx` towards the imaginary axis.
3. **Reflection formula** — gives the *lower* bound only (§169); the ratio stays unbounded with it
   alone, because the *upper* bound is the one lacking decay.

Mathlib has **no** `Binet`, **no** `Stirling`, **no** Weierstrass product for `Complex.Gamma`
(audited file-by-file, §170).

---

## The precise Mathlib gap: complex Stirling

Journal §111 established that both remaining interfaces reduce to one missing ingredient.  Here is
the exact specification, so it can be implemented (upstream or locally) without re-deriving the
analysis.  All four statements are absent from Mathlib as of the version pinned here; the audit is in
§§98, 111.

### 1. Upper and lower bounds for `Complex.Gamma` on a vertical line

```lean
theorem norm_Gamma_le : ∃ C > 0, ∀ σ ∈ [1/2, 2], ∀ t,
    ‖Complex.Gamma (σ + t * I)‖ ≤ C * (1 + |t|) ^ (σ - 1/2) * Real.exp (-(Real.pi * |t| / 2))

theorem norm_Gamma_ge : ∃ c > 0, ∀ σ ∈ [1/2, 2], ∀ t,
    c * (1 + |t|) ^ (σ - 1/2) * Real.exp (-(Real.pi * |t| / 2)) ≤ ‖Complex.Gamma (σ + t * I)‖
```

*What the development already has*: `norm_Gamma_le_Gamma_re` (`GammaBounds.lean`) —
`‖Γ s‖ ≤ Real.Gamma s.re` for `Re s > 0`.  That is a `t`-**uniform** constant, so it gives neither the
`|t|^{σ-1/2}` gain nor any lower bound.  The lower bound is the essential one: it is what makes the
Gamma **ratio** `‖Γ(x+it)/Γ(x′+it)‖ = O(|t|^{x−x′})` finite, and that ratio is what the functional
equation for `L` needs.

### 2. The Gamma ratio

```lean
theorem norm_Gamma_div_Gamma_le : ∃ C > 0, ∀ x x' ∈ [0, 2], ∀ t,
    ‖Complex.Gamma (x + t * I) / Complex.Gamma (x' + t * I)‖ ≤ C * (1 + |t|) ^ (x - x')
```

*Proof from 1*: the exponentials cancel; the powers add as `|t|^{x-1/2-(x'-1/2)} = |t|^{x-x'}`.

### 3. Digamma growth on a vertical line

```lean
theorem norm_digamma_le : ∃ C > 0, ∀ σ0 > 0, ∀ t,
    ‖Complex.digamma (σ0 + t * I)‖ ≤ C * (1 + Real.log (|t| + 2))
```

This is exactly `DigammaGrowthBound σ0` (whose statement was corrected in §96 — the original
half-plane form was **false**).  §97 already reduced it to the fixed strip `1 ≤ σ ≤ 2` using Mathlib's
`Complex.digamma_apply_add_nat`, so only the strip case is needed.  With the digamma series
(`ψ(z) = −γ + Σ_{k≥0} (1/(k+1) − 1/(z+k))`) it is immediate; the series is not in Mathlib.  A route
exists via `GammaSeq_tendsto_Gamma` (`Beta.lean`) plus `TendstoLocallyUniformlyOn.deriv`
(`Analysis/Complex/LocallyUniformLimit.lean`), but `GammaSeq_tendsto_Gamma` is **pointwise** — local
uniformity would have to be established first.

### 4. Convexity bound for `L` in the strip

```lean
theorem norm_LFunction_le : ∃ C > 0, ∀ σ ∈ [0, 1], ∀ t,
    ‖DirichletCharacter.LFunction χ (σ + t * I)‖ ≤ C * (1 + |t|) ^ ((1 - σ) / 2 + ε)
```

*Proof*: `L ≪ 1` for `σ > 1` (**already available**); `L(σ+it) = ε·γ(1−s)·L(1−s)/γ(s)` for `σ < 0` via
`IsPrimitive.completedLFunction_one_sub` plus **2**; then `PhragmenLindelof.horizontal_strip`
(**available**) interpolates.  Then `L′/L` on zero-free sets follows from Cauchy's estimate on a disk
of radius `~1/log|t|` around `s`, which is exactly the standard `|L′/L| ≪ log|t|` argument.

### What is *not* needed

`CriticalStripLogDerivBound` was restated in §109 with a **zero-free hypothesis**; the bound is
required only on segments disjoint from the zeros.  So no zero-free *region* theorem is needed — only
the pointwise non-vanishing the assembly already supplies.

### 4. A hypothesis must *control* the quantity being bounded

Two of the four `Prop` interfaces in this development turned out to be **unsatisfiable** (§96, §109),
and a third defect was subtler still (§117): the interface was satisfiable, and its zero-free
hypothesis was even *supplied* at every point of use, and it was **still false** — because
`Λ(σ+it) ≠ 0` does not control `Λ′/Λ(σ+it) = deriv Λ / Λ`, which is unbounded *near* a zero even
where it is defined.

Four instances of one lesson:

| § | defect |
|---|---|
| §96 | `DigammaGrowthBound` quantified over a half-plane — refuted by `t = 0, σ → ∞` |
| §109 | `CriticalStripLogDerivBound` bounded `logDeriv` across the whole strip, where it has poles |
| §115 | a reduction did not cover the range its consumer instantiates |
| §117 | a hypothesis was *satisfiable* and *supplied*, but did not control the bounded quantity |

**Rule.** For every named hypothesis, ask three questions in order:
1. Is it **satisfiable**?
2. Is it **supplied** at every point of use (find the caller)?
3. Does it **control** the quantity being bounded — could the bounded quantity blow up while the
   hypothesis still holds?

A `sorry`-check, an axiom-check and a successful elaboration catch **none** of these.  Only reading
the statement adversarially does.

### 5. The remaining target for `DigammaGrowthBound` — exact statement and plan

§§123/125/129/130 reduce part (B) to one `ℝ`-valued estimate, and the two sum bounds it needs are
**already proved** in `GammaBounds.lean`:

```lean
theorem sum_range_inv_le_log {b : ℝ} (hb : 1 ≤ b) (N : ℕ) :
    ∑ j ∈ Finset.range N, 1 / (b + j) ≤ 1 + Real.log N

theorem sum_range_inv_sq_le {b : ℝ} (hb : 1 ≤ b) (N : ℕ) :
    ∑ j ∈ Finset.range N, 1 / (b + j) ^ 2 ≤ 2 / b
```

**The target** (`σ₀ ≥ 1`, `n` arbitrary — the bound must be *uniform in `n`*, this is the whole point):

```lean
theorem Lseq_bound {σ0 t : ℝ} (hσ0 : 1 ≤ σ0) (n : ℕ) :
    |t| * ∑ j ∈ Finset.range (n + 1),
        1 / ((σ0 + j) * Real.sqrt ((σ0 + j) ^ 2 + t ^ 2))
      ≤ 5 * (1 + Real.log (|t| + 2))
```

**Proof plan.**  Put `A := |t|`.  For each `j` the summand `1/((σ₀+j)·√((σ₀+j)²+A²))` satisfies

* `σ₀+j ≤ A` ⟹ `√(…) ≥ A` ⟹ `A·summand ≤ 1/(σ₀+j)`;
* `σ₀+j > A` ⟹ `√(…) ≥ σ₀+j` ⟹ `A·summand ≤ A/(σ₀+j)²`.

Let `M := min (n+1) ⌈A−σ₀⌉₊` split the range.  Then
* head (`j < M`) ≤ `∑_{j<n+1} 1/(σ₀+j) ≤ 1 + log(n+1)`, and since `σ₀+M ≤ A+1` the `log` is `O(log A)`
  — **use `sum_range_inv_le_log`, but note the `log n` must be traded for `log A` via `M`, not `n`**;
* tail (`j ≥ M`) — reindex `∑_{j=M}^{n} 1/(σ₀+j)² = ∑_{i<n+1-M} 1/((σ₀+M)+i)²` and apply
  **`sum_range_inv_sq_le` with `b := σ₀+M`** (legal since `σ₀+M ≥ 1`), giving `≤ 2/(σ₀+M) ≤ 2/A`,
  so `A·(tail) ≤ 2`.

**The one subtlety** is the head: `sum_range_inv_le_log` bounds by `1 + log N` for the actual bound
`N = n+1`, but a uniform-in-`n` estimate needs `log(|t|+2)`.  The fix is to apply it to the
**truncated** range `min (n+1) (⌈A⌉₊+1)` and bound the remaining head terms by `1/(σ₀+j) ≥ 1/A` —
i.e. split the head once more at `A`.  Get this wrong and the bound is `O(log n)`, which is exactly
why rounds 19–23 could not state it.

**Then**: (3) the `ℂ` split identity (§125), (4) `ψ = lim L_n` via `GammaSeq_tendsto_Gamma` +
dominated convergence, (5) assemble `DigammaGrowthBound σ₀` — for *every* `σ₀ > 0` directly, with no
recursion needed (`Lseq_bound` has no `n`-dependence), which supersedes §§97/115/116 for this route.
