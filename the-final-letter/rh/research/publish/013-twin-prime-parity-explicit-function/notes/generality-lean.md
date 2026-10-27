# 011 — `lean/Generic.lean`: what is proved, what is assumed, and which Mathlib lemmas exist

Companion to [`../lean/README.md`](../lean/README.md) and
[`generalisation-analysis.md`](generalisation-analysis.md).  This note records, for the
research artifact `../lean/Generic.lean` (namespace `RouteABC`):

1. the exact signatures that landed,
2. the proof strategy / derivation chain for each,
3. the exact Mathlib and 010 lemmas used,
4. the two Mathlib lemmas that were **missing** and were therefore named hypotheses — both
   now proved (`CompletedLFunctionConj` in `DirichletConj.lean`, `RootNumberSign` in
   `RootNumber.lean`),
5. an honest audit of what is *not* proved.

Build: `cd lean && ./check.sh --all` (green) and `./check.sh Axioms.lean`, which prints
`#print axioms` for every headline theorem.

---

## 0. Environment / dependency facts

* Toolchain `leanprover/lean4:v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`.
* `check.sh` prepends (lines 30–45) this directory, `../../010/lean`, and Mathlib to
  `LEAN_PATH`; hence `import Rh45.Routes` and `import Rh45.RouteBGeneral` resolve.
* `Generic.lean` imports `Rh45.Routes`, `Rh45.RouteBGeneral` and
  `Mathlib.NumberTheory.LSeries.DirichletContinuation`.
* `DirichletConj.lean` (new, Mathlib-only, no 010 import) closes the second named gap; see
  Section 7 below, which supersedes the "assumed" status of `CompletedLFunctionConj` in
  Sections 4–6.
* `RootNumber.lean` (new, imports only Mathlib and `Generic.lean`) closes the **first**
  named gap; see Section 8 below, which supersedes the "assumed" status of `RootNumberSign`
  in Sections 4–6.
* `GaussSumComposite.lean` (new, Mathlib-only) supplies the **composite-modulus** Gauss-sum
  square (`gaussSum_sq_of_isPrimitive`) that Mathlib's field-case `gaussSum_sq` cannot, and a
  second, independent proof of the root-number sign (`rootNumber_eq_one_or_neg_one'`); see
  Section 9 below.
* `DirichletAnalytic.lean` (new, imports only `Generic.lean` and `DirichletRouteB.lean`)
  discharges the three **analytic** hypotheses `han`, `hint₀`, `hint₁` of
  `routeB_for_dirichletL_unconditional`, for every nontrivial `χ`, and repackages Route B with
  only the numerical zero data (`routeB_for_dirichletL_of_zeros`); see Section 10 below.
* Axiom audit: `Axioms.lean` (eleven headline theorems of `Generic.lean`) and
  `AxiomsConj.lean` (eleven headline lemmas of `DirichletConj.lean`, seven of
  `RootNumber.lean` / `DirichletRouteB.lean`, five new ones from
  `GaussSumComposite.lean`, and six from `DirichletAnalytic.lean`), all
  `[propext, Classical.choice, Quot.sound]`.  No `sorry`, `axiom`, `admit`,
  `native_decide`, or `set_option maxHeartbeats` anywhere in `011/lean`.

---

## 1. The verification interface (Route B)

### Signatures

```lean
structure SelfDualReal (F : ℂ → ℂ) : Prop where
  selfDual : ∀ s, F (1 - s) = F s
  conjSymm : ∀ s, F (conj s) = conj (F s)

theorem routeB_of_selfDualReal (F : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (h : SelfDualReal F) (ht : t0 < t1)
    (han : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ F s)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt F z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → F u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv F (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

### Derivation

`routeB_of_selfDualReal` is a one-line application of
`Rh45RouteBAnalytic.routeB_reduction_general` with `h.selfDual`, `h.conjSymm`.  This is
the packaging theorem: Route B is already general in `F`, and no analysis is re-proved.

### The sign refinement

Because the 010 argument only uses `F(1-s)=F s` through the reflection of `logDeriv`,
Route B survives self-duality **up to sign**:

```lean
theorem logDeriv_one_sub_of_const_mul (f : ℂ → ℂ) (ε : ℂ) (hε : ε ≠ 0)
    (h : ∀ s, f (1 - s) = ε * f s) (s : ℂ) :
    logDeriv f (1 - s) = -logDeriv f s

structure SelfDualRealUpToSign (F : ℂ → ℂ) (ε : ℂ) : Prop where
  unit : ε = 1 ∨ ε = -1
  selfDual : ∀ s, F (1 - s) = ε * F s
  conjSymm : ∀ s, F (conj s) = conj (F s)

theorem routeB_general_of_logDeriv (F : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1) (han …) (hmem …) (hm …) (hno …)
    (hrefl : ∀ s, logDeriv F (1 - conj s) = -conj (logDeriv F s))
    (hint₀ …) (hint₁ …) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))

theorem routeB_of_selfDualRealUpToSign (F : ℂ → ℂ) (ε : ℂ) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ) (h : SelfDualRealUpToSign F ε) (ht : t0 < t1) (han …) (hmem …) (hm …)
    (hno …) (hint₀ …) (hint₁ …) :
    (rightPath (logDeriv F) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

* `logDeriv_one_sub_of_const_mul` is proved by comparing the two functions
  `fun t => f (1 - t)` and `fun t => ε * f t` (equal by `h`), differentiating with
  `deriv_comp_const_sub`, and using `logDeriv_const_mul`.
* `routeB_general_of_logDeriv` recombines the 010 **argument principle**
  (`Rh45RouteBAnalytic.argument_principle_general`, giving `rectBoundary (logDeriv F) t0 t1
  = 2πi ∑ m z`) with the 010 **contour reduction**
  (`Rh45RouteBAnalytic.routeB_reduction`).  The only new ingredient compared with 010 is
  that the pointwise symmetry hypothesis is on `logDeriv F`, not on `F`.
* `routeB_of_selfDualRealUpToSign` case-splits on `ε = 1 ∨ ε = -1`: the `ε = 1` branch is
  literally `routeB_of_selfDualReal`; the `ε = -1` branch uses
  `routeB_general_of_logDeriv` after `logDeriv_one_sub_of_const_mul` + the 010
  `Rh45RouteBAnalytic.logDeriv_conj`.

Mathematical point worth recording: `h(1-s) = -h(s)` does **not** give `h(1-s) = h(s)`
and cannot be repaired by rescaling (`logDeriv (c·h) = logDeriv h` for constant `c ≠ 0`).
But it *does* give the reflection of the logarithmic derivative, which is all Route B
consumes.  So `ε = -1` is genuinely not an obstruction; the honest interface is the
`logDeriv` one.

---

## 2. Route A and Route C

### Route A

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

A direct call to `Rh45Routes.certified_root_of_enclosures` (already `∀ f : ℝ → ℝ`).
`Rh45Routes.exists_unique_root_of_sign_change` and its `_neg` mirror are likewise already
fully general; no wrapper is needed for them.

### Route C — the genuinely new generalisation

```lean
theorem validated_truncation_bound_finset {ι : Type*} [DecidableEq ι] (s : Finset ι)
    (tail : ι → ℝ) {lhs rhsComputed : ℝ}
    (hsplit : lhs = rhsComputed + ∑ i ∈ s, tail i) :
    |lhs - rhsComputed| ≤ ∑ i ∈ s, |tail i|

theorem validated_truncation_bound_three
    {lhs rhsTrue rhsComputed zeroTail primeTail archTail : ℝ}
    (hlhs : lhs = rhsTrue)
    (hsplit : rhsTrue = rhsComputed + (zeroTail + primeTail + archTail)) :
    |lhs - rhsComputed| ≤ |zeroTail| + |primeTail| + |archTail|
```

`validated_truncation_bound_finset` is proved here by `Finset.induction_on` using
`abs_add_le` and `Finset.sum_insert` (the 010 proof only handled three named tails).
`validated_truncation_bound_three` is obtained as the `Finset (Fin 3)` instance of the
general theorem (`Fin.sum_univ_three` + `![zeroTail, primeTail, archTail]`), so the 3-tail
case is literally the 010 instance
(`Rh45Routes.validated_truncation_bound` is the same statement).

---

## 3. Dirichlet L-functions: the functional equation is PROVED

### Signatures

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

theorem dirichletCompleted_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ s, completedLFunction χ (conj s) = conj (completedLFunction χ s)) (s : ℂ) :
    dirichletCompleted χ (conj s) = conj (dirichletCompleted χ s)
```

### Derivation of `dirichletL_normalised_one_sub`

1. `hN : (N : ℂ) ≠ 0` from `NeZero.ne N` (`[NeZero N]` is forced by
   `DirichletCharacter ℂ N`; this is the `N ≠ 0` hypothesis of the task).
2. `hpow : N^((1-s)/2) · N^(s-1/2) = N^(s/2)`, from `Complex.cpow_add` (used backwards)
   and `ring` on the exponent `(1-s)/2 + (s - 1/2) = s/2`.
3. Rewrite `Λ_χ(1-s)` by `IsPrimitive.completedLFunction_one_sub` and `χ⁻¹` by `hχinv`.
4. Reassociate (`ring`) and apply `hpow`.

(Arithmetic check: `N^((1-s)/2) · N^(s-1/2) = N^((1-s)/2 + s - 1/2) = N^(s/2)`; this is
exactly the factor that converts `Λ_χ(1-s) = N^(s-1/2) ε Λ_χ(s)` into the stated
normalised form.)

### Derivation of `dirichletCompleted_conj`

`N^(conj s / 2) = N^(conj (s/2)) = conj (N^(s/2))` by `Complex.cpow_conj` with
`arg N = 0 ≠ π` (`Complex.arg_ofReal_of_nonneg`, `Nat.cast_nonneg`), then
`hreal s` for `Λ_χ` and `map_mul` for the conjugation.  The only mathematical input is
`hreal`; everything else is proved.

---

## 4. Route B for Dirichlet L-functions (both named `Prop`s now theorems)

```lean
def RootNumberSign (χ : DirichletCharacter ℂ N) : Prop :=
  rootNumber χ = 1 ∨ rootNumber χ = -1

def CompletedLFunctionConj (χ : DirichletCharacter ℂ N) : Prop :=
  ∀ s, completedLFunction χ (conj s) = conj (completedLFunction χ s)

theorem routeB_for_dirichletL (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ)
    (hε : RootNumberSign χ) (hreal : CompletedLFunctionConj χ)
    (ht : t0 < t1) (han …) (hmem …) (hm …) (hno …) (hint₀ …) (hint₁ …) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

`routeB_for_dirichletL` is derived by feeding
`dirichletCompleted_selfDual` and `dirichletCompleted_conj` into
`routeB_of_selfDualRealUpToSign` at `ε = rootNumber χ`.  The remaining hypotheses `han`,
`hmem`, `hm`, `hno`, `hint₀`, `hint₁` are literally the same remaining hypotheses as
`Rh45RouteBAnalytic.routeB_reduction_general`, specialised to `dirichletCompleted χ`.

**Both `Prop` hypotheses are now theorems**, so `Generic.lean`'s conditional signature is
instantiated unconditionally (up to the shared analytic data) in `DirichletRouteB.lean`:

```lean
theorem routeB_for_dirichletL_unconditional (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ)
    (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) (ht …) (han …) (hmem …) (hm …) (hno …) (hint₀ …) (hint₁ …) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

* `hε : RootNumberSign χ` is `rootNumberSign_of_isQuadratic χ hχ hχ1 hχ2`
  (`RootNumber.lean`, Section 8).
* `hreal : CompletedLFunctionConj χ` is `DirichletCharacter.completedLFunction_conj`
  applied to `conj_eq_self_of_isQuadratic χ hχ2` (`DirichletConj.lean`, Section 7).

---

## 5. Exact Mathlib / 010 lemma inventory

### Used from Mathlib

| lemma | role |
|---|---|
| `DirichletCharacter.completedLFunction` | `Λ_χ` |
| `DirichletCharacter.rootNumber` | the root number `ε` |
| `DirichletCharacter.IsPrimitive.completedLFunction_one_sub` | primitive functional equation `Λ_χ(1-s) = N^(s-1/2) ε Λ_χ⁻¹(s)` |
| `Complex.cpow_add` | combine `N^((1-s)/2) · N^(s-1/2)` (base `N ≠ 0`) |
| `Complex.cpow_conj` | `N^(conj s/2) = conj (N^(s/2))` for the real base `N` |
| `Complex.arg_ofReal_of_nonneg`, `Complex.ofReal_natCast` | `arg N = 0 ≠ π` |
| `Complex.ofReal_sum`, `Finset.sum_congr` | cast of the real zero count `∑ m z` into `ℂ` |
| `logDeriv_apply`, `logDeriv_const_mul` | the sign-cancellation lemma |
| `deriv_comp_const_sub` | derivative of `t ↦ f (1 - t)` |
| `map_mul`, `map_div₀`, `map_ofNat`, `Complex.conj_conj` | conjugation bookkeeping |
| `abs_add_le`, `Finset.induction_on`, `Finset.sum_insert`, `Fin.sum_univ_three` | Route C induction + 3-tail instance |
| `NeZero.ne` | `N ≠ 0` |

### Used from the 010 development

| lemma | role |
|---|---|
| `Rh45RouteBAnalytic.routeB_reduction_general` | Route B, general `f` (Part 1 wrapper body) |
| `Rh45RouteBAnalytic.argument_principle_general` | zero count via the argument principle (Route B, logDeriv form) |
| `Rh45RouteBAnalytic.routeB_reduction` | symmetric contour reduction (Route B, logDeriv form) |
| `Rh45RouteBAnalytic.logDeriv_conj` | reality of `logDeriv` under `conjSymm` |
| `Rh45RouteBAnalytic.rectBoundary`, `rightPath` | the contour integrals |
| `Rh45RouteBAnalytic.routeB_reduction_of_functional_equation` | (indirectly, inside `routeB_reduction_general`) |
| `Rh45Routes.certified_root_of_enclosures` | Route A wrapper body |
| `Rh45Routes.validated_truncation_bound` | the 3-tail statement recovered as an instance |
| `Rh45Routes.exists_unique_root_of_sign_change`, `…_neg` | already general (documented, unchanged) |

### **Missing from Mathlib** (named here, never assumed as axioms)

1. **`RootNumberSign χ`** — `rootNumber χ ∈ {1, -1}` for a nontrivial quadratic primitive `χ`.
   Mathlib defines `rootNumber` as a Gauss sum (`gaussSum χ stdAddChar / I^a / N^(1/2)`)
   and proves the FE with it, but not this sign statement.
   **Now proved** in `RootNumber.lean` (`rootNumber_eq_one_or_neg_one` /
   `rootNumberSign_of_isQuadratic`, see Section 8), via the functional equation applied
   twice.  The `def RootNumberSign` in `Generic.lean` is retained unchanged only because
   `Generic.lean` is frozen.
2. **`CompletedLFunctionConj χ`** — `completedLFunction χ (conj s) = conj (completedLFunction χ s)`.
   Mathlib had no `completedLFunction_conj` (it also lacked `completedRiemannZeta_conj`).
   **Now proved** in `DirichletConj.lean` for every `χ` with real values (see Section 7);
   the `def CompletedLFunctionConj` in `Generic.lean` is retained unchanged only because
   `Generic.lean` is frozen, not because the statement is still open.

There is a third, structural, gap that is *not* Dirichlet-specific but is relevant to the
Route B route as a whole: the rectangle argument principle itself is not in Mathlib.  It is
supplied by 010's `Rh45/Weierstrass.lean` (`argument_principle_general`), so this artifact
does not have to assume it.

---

## 6. Honest audit: proved vs assumed vs not attempted

**Fully proved in `Generic.lean`**

* Route B is general in the analytic function: `routeB_of_selfDualReal`.
* Route B survives a root number `ε = ±1`: `logDeriv_one_sub_of_const_mul`,
  `routeB_general_of_logDeriv`, `routeB_of_selfDualRealUpToSign`.
* Route A certificates are general: `CertifiedZero.exists_unique_root`.
* Route C for an arbitrary finite family of tails: `validated_truncation_bound_finset`,
  with the 3-tail 010 case as `validated_truncation_bound_three`.
* Dirichlet normalised functional equation: `dirichletL_normalised_one_sub` /
  `dirichletCompleted_selfDual`.
* Reality of the normalised function from reality of `Λ_χ`: `dirichletCompleted_conj`.

**Assumed (explicit hypotheses, `Prop`-valued defs, not axioms)**

* `RootNumberSign χ` was formerly in this list; it is now **proved** for every nontrivial
  quadratic primitive character (`rootNumber_eq_one_or_neg_one`,
  `rootNumberSign_of_isQuadratic`, `RootNumber.lean`).  It remains a *hypothesis* of the
  frozen `Generic.lean` signature, but it is no longer an irreducible assumption.
* `CompletedLFunctionConj χ` was formerly in this list; it is now **proved** for every
  character with real values (`DirichletCharacter.completedLFunction_conj`,
  `DirichletConj.lean`).  It remains a *hypothesis* of the frozen `Generic.lean`
  signature, but it is no longer an irreducible assumption.
* The Route-B zero data and the **former** analytic hypotheses.  `hmem`, `hm`, `hno` (the finite
  zero set and its orders on the rectangle) remain genuine inputs of every Route B statement.
  The analytic triple `han`, `hint₀`, `hint₁` is **no longer assumed**: it is proved
  unconditionally for `dirichletCompleted χ` in `DirichletAnalytic.lean` (Section 10), and the
  edge non-vanishing that `hint₀`, `hint₁` consume is itself derived from `hmem` + `hno`.  So the
  *only* hypotheses left in `routeB_for_dirichletL_of_zeros` are the numerical zero data.

**Not attempted**

* Discharging the zero data `hmem`/`hm`/`hno` for any concrete Dirichlet character, i.e.
  producing an actual finite zero set `Z` and its orders.  No certified window for any
  object other than `ζ` is claimed.
* ~~Proving `RootNumberSign`.~~  Done in `RootNumber.lean` (see Section 8); the other named
  gap, `CompletedLFunctionConj`, is proved in `DirichletConj.lean` (Section 7).
* ~~Discharging `han`/`hint₀`/`hint₁`.~~  Done in `DirichletAnalytic.lean` (see Section 10).

---

## 7. Addendum — the `CompletedLFunctionConj` gap is closed (`DirichletConj.lean`)

`DirichletConj.lean` is a self-contained, Mathlib-only module (it imports only
`Mathlib.Analysis.Calculus.Deriv.Star` and
`Mathlib.NumberTheory.LSeries.DirichletContinuation`; no `Rh45` import) that proves the
conjugation reality of every layer of Mathlib's Dirichlet L-function API.

### Signatures that landed

```lean
theorem LSeries_conj (f : ℕ → ℂ) (s : ℂ) :
    conj (LSeries f (conj s)) = LSeries (fun n => conj (f n)) s

theorem Complex.Gammaℝ_conj (s : ℂ) : Gammaℝ (conj s) = conj (Gammaℝ s)
theorem Complex.Gammaℝ_ne_zero_of_pos_re {s : ℂ} (hs : 0 < s.re) : Gammaℝ s ≠ 0
theorem Complex.conj_cpow_ofReal (r : ℝ) (hr : 0 ≤ r) (z : ℂ) :
    conj ((r : ℂ) ^ z) = (r : ℂ) ^ conj z

theorem DirichletCharacter.LFunction_conj_of_one_lt_re (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) {s : ℂ} (hs : 1 < s.re) :
    LFunction χ (conj s) = conj (LFunction χ s)

theorem DirichletCharacter.gammaFactor_conj (χ : DirichletCharacter ℂ N) (s : ℂ) :
    gammaFactor χ (conj s) = conj (gammaFactor χ s)

theorem DirichletCharacter.gammaFactor_ne_zero_of_one_lt_re (χ : DirichletCharacter ℂ N)
    {s : ℂ} (hs : 1 < s.re) : gammaFactor χ s ≠ 0

theorem DirichletCharacter.completedLFunction_conj_of_one_lt_re (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) {s : ℂ} (hs : 1 < s.re) :
    completedLFunction χ (conj s) = conj (completedLFunction χ s)

theorem DirichletCharacter.completedLFunction₀_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    ZMod.completedLFunction₀ (⇑χ) (conj s) = conj (ZMod.completedLFunction₀ (⇑χ) s)

theorem DirichletCharacter.completedLFunction_conj (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) (s : ℂ) :
    completedLFunction χ (conj s) = conj (completedLFunction χ s)

theorem completedRiemannZeta_conj (s : ℂ) :
    completedRiemannZeta (conj s) = conj (completedRiemannZeta s)
```

### Strategy (this file's own, not the 010 route)

1. **`LSeries_conj`** is unconditional: `Complex.conj_tsum` moves `conj` through the
   `tsum`, and termwise `conj (f n / n^(conj s)) = conj (f n) / n^s` by
   `Complex.cpow_conj` at the real nonnegative base `n` (where `arg n = 0 ≠ π`).
2. **`LFunction_conj_of_one_lt_re`** rewrites both sides by `LFunction_eq_LSeries`
   (`1 < re s` and `re (conj s) = re s`), then applies `LSeries_conj` and `hreal`.
3. **`gammaFactor_conj`** is unconditional: split on `χ.even_or_odd`, rewrite by
   `Even.gammaFactor_def`/`Odd.gammaFactor_def`, and use `Complex.Gammaℝ_conj` (with
   `conj s + 1 = conj (s + 1)` in the odd case).
4. **`completedLFunction_conj_of_one_lt_re`** solves
   `LFunction_eq_completed_div_gammaFactor` for
   `completedLFunction = LFunction * gammaFactor` (the gamma factor is nonzero on
   `0 < re s`, by `Complex.Gammaℝ_ne_zero_of_pos_re` from `Gammaℝ = π^{-s/2} Γ(s/2)` and
   `Complex.Gamma_ne_zero_of_re_pos`), then conjugates with steps 2–3.
5. **Identity theorem (`completedLFunction₀_conj`).**  `completedLFunction χ` is *not*
   entire for the trivial character (pole at `s = 1`), so the identity theorem is applied
   to the entire `ZMod.completedLFunction₀ χ` instead:
   `ZMod.differentiable_completedLFunction₀` gives analyticity, and on `1 < re z` the
   `completedLFunction₀ ↔ completedLFunction` dictionary is
   `ZMod.completedLFunction_eq` plus its two correction terms
   `N^{-z} Φ 0 / z` and `N^{-z} (∑ Φ j) / (1 - z)`, which commute with conjugation
   because `N` is nonnegative real (`Complex.conj_cpow_ofReal`) and `Φ` is real
   (`ZMod.natCast_zmod_val` converts `j : ZMod N` to `j.val : ℕ`).  Agreement on the
   neighbourhood `{1 < re z}` of `2` then gives agreement on all of `ℂ`.
6. **`completedLFunction_conj`** conjugates `ZMod.completedLFunction_eq` once more to
   transfer the identity from `completedLFunction₀` back to `completedLFunction` — now
   valid at *every* `s`, including the poles `s = 0, 1`, because the transfer is a purely
   algebraic rearrangement of `ZMod.completedLFunction_eq` rather than a limit statement.

### Cases closed

* `χ ≠ 1` (all nontrivial real characters, primitive or not, any `N`): here
  `completedLFunction χ` is entire (`differentiable_completedLFunction`), so the identity
  theorem could be applied to it directly; the proof treats all cases uniformly through
  `completedLFunction₀` anyway.
* `χ = 1`, `N = 1`: `completedLFunction_modOne_eq` turns the statement into
  `completedRiemannZeta_conj`.
* `χ = 1`, `N > 1` (the pole case): closed by the `completedLFunction₀` route above.

**No case remains open.**  `IsPrimitive` and any parity hypothesis are not required; the
reality hypothesis is `∀ n : ℕ, conj (χ n) = χ n` (Mathlib has no real-character
predicate, and this is the direct form).

### Axiom audit

`AxiomsConj.lean` prints `#print axioms` for all eleven headline lemmas above;
each is exactly `[propext, Classical.choice, Quot.sound]`.
There is no `sorry`, `axiom`, `admit`, `native_decide`, or
`set_option maxHeartbeats` in `DirichletConj.lean`.

---

## 8. Addendum — the `RootNumberSign` gap is closed (`RootNumber.lean`)

`RootNumber.lean` is a Mathlib-only module (it imports
`Mathlib.NumberTheory.LSeries.DirichletContinuation`,
`Mathlib.NumberTheory.LSeries.Nonvanishing`, `Mathlib.NumberTheory.MulChar.Lemmas`, and
`Generic.lean`; no 010 import) that proves `rootNumber χ = ±1` for nontrivial quadratic
primitive characters, and also proves both directions of the `hreal` ⇄ `IsQuadratic`
bridge.

### Signatures that landed

```lean
theorem RouteABC.rootNumber_sq_eq_one_of_inv_eq_self (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχinv : χ⁻¹ = χ) : rootNumber χ ^ 2 = 1

theorem RouteABC.rootNumber_eq_one_or_neg_one (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) :
    rootNumber χ = 1 ∨ rootNumber χ = -1

theorem RouteABC.rootNumberSign_of_isQuadratic (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) : RootNumberSign χ

theorem RouteABC.conj_eq_self_of_isQuadratic (χ : DirichletCharacter ℂ N)
    (hχ2 : χ.IsQuadratic) : ∀ n : ℕ, conj (χ n) = χ n

theorem RouteABC.isQuadratic_of_conj_eq_self (χ : DirichletCharacter ℂ N)
    (hreal : ∀ n : ℕ, conj (χ n) = χ n) : χ.IsQuadratic

theorem RouteABC.rootNumberSign_of_conj_eq_self (χ : DirichletCharacter ℂ N)
    (hχ : IsPrimitive χ) (hχ1 : χ ≠ 1) (hreal : ∀ n : ℕ, conj (χ n) = χ n) :
    RootNumberSign χ
```

plus, in `DirichletRouteB.lean`:

```lean
theorem RouteABC.routeB_for_dirichletL_unconditional … (hχ2 : χ.IsQuadratic) (…) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

### Strategy

1. **Functional equation applied twice.**  For `χ` primitive with `χ⁻¹ = χ`,
   `IsPrimitive.completedLFunction_one_sub` reads
   `Λ_χ(1 - s) = N^(s - 1/2) · ε · Λ_χ(s)` with `ε = rootNumber χ`.  Applying it at `1 - s`,
   substituting, and combining `N^((1-s)-1/2) · N^(s-1/2) = 1` (`Complex.cpow_add`,
   `N ≠ 0` from `NeZero N`) gives `Λ_χ(s) = ε² · Λ_χ(s)`.
2. **Evaluate at `s = 1`.**  `Λ_χ(1) ≠ 0`: `LFunction_apply_one_ne_zero χ hχ1` gives
   `L(χ,1) ≠ 0`, and `LFunction_eq_completed_div_gammaFactor` at `s = 1` (valid for
   `N ≠ 1`) gives `Λ_χ(1) = L(χ,1) · gammaFactor χ 1` with `gammaFactor χ 1 ≠ 0`
   (`even_or_odd`, `Complex.Gammaℝ_ne_zero_of_re_pos`).  Hence `(ε² - 1) · Λ_χ(1) = 0` and
   `ε² = 1`.
3. **`ε² = 1 ⟹ ε = ±1`** by `sq_eq_one_iff` in the domain `ℂ`.
4. **Modulus `N = 1`** is handled separately: `rootNumber_modOne` gives `rootNumber = 1`
   directly (and `χ ≠ 1` is vacuous there).
5. **The `hreal` ⇄ `IsQuadratic` bridge.**  `conj_eq_self_of_isQuadratic` is immediate
   (values `0, ±1` are fixed by `conj`).  Conversely, for `a : (ZMod N)ˣ`,
   `MulChar.star_apply'` gives `conj (χ a) = χ⁻¹ a` (values of a multiplicative character
   are roots of unity), so `hreal` forces `χ⁻¹ a = χ a`; hence `χ² = 1` and
   `MulChar.isQuadratic_iff_sq_eq_one` gives `IsQuadratic χ`.

### Why `IsPrimitive` is necessary (the requested signature without it is false)

Mathlib's own docstring says `rootNumber` is "for `χ` primitive; junk otherwise".  The
statement `rootNumber χ = 1 ∨ rootNumber χ = -1` for `χ ≠ 1` and `χ.IsQuadratic` **without**
primitivity is refuted by the `changeLevel` image of the nontrivial quadratic character
modulo `3` at modulus `6`: it takes the values `0, 1, 0, 0, 0, -1`, so

```
gaussSum = ω - ω⁵ = I√3        (ω = exp (2πI/6)),
```

it is odd (`χ (-1) = χ 5 = -1`), hence
`rootNumber = I√3 / I / √6 = 1/√2 ≠ ±1`.  The functional-equation argument cannot run
without primitivity (the FE is only stated for primitive `χ`), which is exactly why the
hypothesis is needed.  `rootNumber_sq_eq_one_of_inv_eq_self` is stated with `IsPrimitive`;
the only other use of `hχ1 : χ ≠ 1` is the nonvanishing step 2.

### Axiom audit

`AxiomsConj.lean` prints `#print axioms` for
`rootNumber_sq_eq_one_of_inv_eq_self`, `rootNumber_eq_one_or_neg_one`,
`rootNumberSign_of_isQuadratic`, `conj_eq_self_of_isQuadratic`,
`isQuadratic_of_conj_eq_self`, `rootNumberSign_of_conj_eq_self` and
`routeB_for_dirichletL_unconditional`; each is exactly
`[propext, Classical.choice, Quot.sound]`.  There is no `sorry`, `axiom`, `admit`,
`native_decide`, or `set_option maxHeartbeats` in `RootNumber.lean` or
`DirichletRouteB.lean`.

---

## 9. Addendum — the composite-modulus Gauss-sum square (`GaussSumComposite.lean`)

`GaussSumComposite.lean` is a Mathlib-only module (imports
`Mathlib.Analysis.Fourier.ZMod` and
`Mathlib.NumberTheory.LSeries.DirichletContinuation`; no 010 import, no import of
`RootNumber.lean`).  It fills the gap left by Mathlib's `MulChar.gaussSum_sq`, which is proved
in a `[Field R]` section (its helper `gaussSum_mul_aux` divides by `b⁻¹` and uses
`mulLeft_bijective₀`) and therefore does **not** apply to `ZMod N` for composite `N` — exactly
the case needed for Dirichlet characters of composite conductor.

### Signatures that landed

```lean
theorem DirichletCharacter.IsPrimitive.inv {R : Type*} [CommMonoidWithZero R]
    (hχ : IsPrimitive χ) : IsPrimitive χ⁻¹

theorem RouteABC.gaussSum_mul_gaussSum_inv_eq_card (hχ : IsPrimitive χ) :
    gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar = χ (-1) * (N : ℂ)

theorem RouteABC.gaussSum_sq_of_isPrimitive (hχ : IsPrimitive χ) (hχ₁ : χ ≠ 1)
    (hχ₂ : IsQuadratic χ) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (N : ℂ)

theorem RouteABC.gaussSum_sq_of_isPrimitive_prime [Fact p.Prime] (…) :
    gaussSum χ stdAddChar ^ 2 = χ (-1) * (p : ℂ) ∧
      gaussSum χ stdAddChar ^ 2 = χ (-1) * (Fintype.card (ZMod p) : ℂ)

theorem RouteABC.rootNumber_eq_one_or_neg_one' (hχ : IsPrimitive χ) (hχ₁ : χ ≠ 1)
    (hχ₂ : χ.IsQuadratic) : rootNumber χ = 1 ∨ rootNumber χ = -1
```

`gaussSum_sq_of_isPrimitive` is the requested missing lemma
(`hχ₁ : χ ≠ 1` is kept only for parity with the field-case statement: the Fourier proof does
not use it, since for `N > 1` primitivity already forces `χ ≠ 1`).  The examples after
`gaussSum_sq_of_isPrimitive_prime` instantiate it at `N = 3, 5, 7`, where `ZMod p` is a field
and Mathlib's `gaussSum_sq` applies, and the conjunction records that the two statements agree.

### Strategy

The proof never divides by an element of `ZMod N`; it uses the discrete Fourier transform on
`ZMod N`, available for every `N` (`Mathlib/Analysis/Fourier/ZMod.lean`):

1. **Fourier transform of a primitive character.**  Mathlib's
   `IsPrimitive.fourierTransform_eq_inv_mul_gaussSum` gives, for every `k : ZMod N`,
   `𝓕 χ k = χ⁻¹ (-k) * τ` with `τ = gaussSum χ stdAddChar`.
2. **The double transform, two ways.**  Fourier inversion `ZMod.dft_dft` gives
   `𝓕 (𝓕 χ) k = N • χ (-k) = N * χ (-1) * χ k`.  Substituting step 1, reindexing the sum by
   `j ↦ -j` (an `Equiv.neg`, `Fintype.sum_equiv`) and using
   `gaussSum_mulShift_of_isPrimitive` on `χ⁻¹` gives
   `𝓕 (𝓕 χ) k = τ * gaussSum χ⁻¹ (stdAddChar.mulShift k) = τ * χ k * gaussSum χ⁻¹ stdAddChar`.
3. **Compare at `k = 1`** (where `χ 1 = 1`): `N * χ (-1) = τ * gaussSum χ⁻¹ stdAddChar`, i.e.
   the product form `gaussSum_mul_gaussSum_inv_eq_card`.
4. **Square form.**  `hχ₂.inv : χ⁻¹ = χ` (Mathlib's `MulChar.IsQuadratic.inv`) turns the
   product into `τ² = χ (-1) * N`.

Auxiliary fact: `DirichletCharacter.IsPrimitive.inv` is proved from the conductor
(`conductor_inv`); Mathlib has the conductor statement but not this `IsPrimitive` wrapper.

### The root-number sign by the Gauss-sum route

`rootNumber_eq_one_or_neg_one'` re-derives `RootNumberSign χ` from the Gauss-sum square:
`rootNumber χ = τ / I^a / N^(1/2)` with `a = if χ.Even then 0 else 1`, so by
`rootNumber χ ^ 2 = τ^2 / (I^a)^2 / (N^(1/2))^2 = χ(-1)·N / ((-1)^a · N) = 1`, using
`gaussSum_sq_of_isPrimitive`, `(I^a)^2 = (-1)^a` (`χ.even_or_odd`), `(N^(1/2))^2 = N`
(`Complex.cpow_nat_inv_pow`) and `χ(-1) = (-1)^a` (the content of `χ.Even`/`χ.Odd`); then
`sq_eq_one_iff` gives `±1`.  This is a deliberate **second, independent** proof:
`RootNumber.lean` (Section 8) keeps the functional-equation proof and is untouched.

### Numerical cross-check

`python/check_gausssum_sq.py` brute-forces every quadratic character mod `N` (as a
homomorphism `(ℤ/Nℤ)* → {±1}` extended by zero), computes its conductor as the least divisor
through which it factors, and checks `τ² = χ(-1)·N` for every **primitive** quadratic character
at `N = 8, 12, 20, 24` (two, one, one and two primitive characters respectively).  It also
confirms that the nontrivial quadratic character mod `6` (conductor `3`) violates the identity
(`τ² = -3 ≠ χ(-1)·N = -6`), showing `IsPrimitive` is necessary.  The script prints PASS/FAIL
and exits non-zero on failure.

### Axiom audit

`AxiomsConj.lean` prints `#print axioms` for `DirichletCharacter.IsPrimitive.inv`,
`gaussSum_mul_gaussSum_inv_eq_card`, `gaussSum_sq_of_isPrimitive`,
`gaussSum_sq_of_isPrimitive_prime` and `rootNumber_eq_one_or_neg_one'`; each is exactly
`[propext, Classical.choice, Quot.sound]`.  There is no `sorry`, `axiom`, `admit`,
`native_decide`, or `set_option maxHeartbeats` in `GaussSumComposite.lean`, and no
`set_option maxHeartbeats` was introduced in place of the (removed) prime-only restriction.

---

## 10. Addendum — the analytic hypotheses are discharged (`DirichletAnalytic.lean`)

`routeB_for_dirichletL_unconditional` (`DirichletRouteB.lean`) still took three *analytic*
hypotheses on the closed rectangle `[0,1] × [t₀,t₁]`:

```lean
(han   : ∀ s ∈ …, AnalyticAt ℂ (dirichletCompleted χ) s)
(hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t0 * I)) volume 0 1)
(hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t1 * I)) volume 0 1)
```

`DirichletAnalytic.lean` proves all three — unconditionally in the character, for **every**
`χ ≠ 1` (no primitivity, reality or quadraticity is used) — and repackages Route B so that only
the numerical zero data remains.

### Signatures that landed

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

theorem RouteABC.routeB_for_dirichletL_of_zeros (χ : DirichletCharacter ℂ N) (t0 t1 : ℝ)
    (Z : Finset ℂ) (m : ℂ → ℕ)
    (hχ : IsPrimitive χ) (hχinv : χ⁻¹ = χ) (hχ1 : χ ≠ 1) (hχ2 : χ.IsQuadratic) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → dirichletCompleted χ u ≠ 0) :
    (rightPath (logDeriv (dirichletCompleted χ)) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ))
```

### Strategy

1. **Entireness.**  `dirichletCompleted χ s = (N : ℂ) ^ (s / 2) * completedLFunction χ s`.  The
   base `N : ℂ` is a nonnegative real, so `N ∈ Complex.slitPlane` (`0 < re N` because
   `NeZero N`), and `AnalyticAt.cpow` gives analyticity of `s ↦ N ^ (s / 2)` from analyticity of
   `s ↦ s / 2` (`AnalyticAt.div_const`).  For `χ ≠ 1`, Mathlib's
   `differentiable_completedLFunction` gives entireness of `Λ_χ`, hence `AnalyticAt` at every
   point; `AnalyticAt.mul` finishes.  The box form is the same theorem (membership is unused).
2. **Continuity of `logDeriv` on a segment.**  `logDeriv h = deriv h / h`.  Since `h` is
   analytic it is `ContDiff ℂ 1` (`Complex.analyticOn_univ_iff_differentiable` +
   `AnalyticOn.contDiff`), so `deriv h` is continuous (`ContDiff.continuous_deriv_one`); `h` is
   continuous because it is differentiable.  Composing with the continuous path
   `x ↦ ↑x + ↑t * I` and using `ContinuousOn.div` with the non-vanishing hypothesis `hne` gives
   `ContinuousOn` on `Set.uIcc 0 1`.
3. **Interval integrability.**  `ContinuousOn.intervalIntegrable` on the compact interval
   `[0,1]`.  (`hne` is genuinely needed: a zero of `h` on the edge would produce a
   non-integrable pole of `logDeriv h`, so this hypothesis cannot simply be dropped — it is
   instead *derived* in the packaging theorem below.)
4. **Packaging.**  `hmem` gives `t0 < z.im < t1` for every `z ∈ Z`, so a point `x + t0 * I` (resp.
   `x + t1 * I`) of an edge can never lie in `Z`; `hno` therefore yields the edge non-vanishing
   needed by step 3, with no extra hypothesis.  `routeB_for_dirichletL_of_zeros` is then
   `routeB_for_dirichletL_unconditional` with `han`, `hint₀`, `hint₁` filled in from steps 1–3.

The `ht : t ∈ Set.uIcc t0 t1` binder of `intervalIntegrable_logDeriv_dirichletCompleted` is
inert (the conclusion mentions only the single segment at height `t`); it is kept so the
signature reads as "an edge of the rectangle".

### Mathlib facts used

`differentiable_completedLFunction`, `AnalyticAt.mul`, `AnalyticAt.cpow`, `AnalyticAt.div_const`,
`AnalyticAt.differentiableAt`, `Complex.analyticOn_univ_iff_differentiable`,
`AnalyticOn.contDiff`, `ContDiff.continuous_deriv_one`, `ContinuousOn.div`,
`ContinuousOn.intervalIntegrable`, `Complex.mem_reProdIm`, `logDeriv_apply`, `Set.left_mem_uIcc`,
`Set.right_mem_uIcc`, `NeZero.ne`.

### Axiom audit

`AxiomsConj.lean` prints `#print axioms` for all six theorems above; each is exactly
`[propext, Classical.choice, Quot.sound]`.  There is no `sorry`, `axiom`, `admit`,
`native_decide`, or `set_option maxHeartbeats` in `DirichletAnalytic.lean`.
