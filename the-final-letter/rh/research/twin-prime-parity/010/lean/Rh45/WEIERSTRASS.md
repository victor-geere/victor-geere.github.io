# `Rh45/Weierstrass.lean` — dividing out the zeros, and the general argument principle

Follow-up to `ARGUMENT_PRINCIPLE.md` §5.  That module had to *assume* the
factorisation `f = C · ∏_{z∈Z} (s − z)^(m z)` as the hypothesis `hfac`; this
module produces the factorisation from the local order machinery of Mathlib and
uses it to prove the rectangle argument principle in its general form.

Everything below is proved in Lean 4 (v4.35.0-rc2) against Mathlib at
`$HOME/lean/mathlib4`, with **no `sorry`, no `axiom`, no `native_decide`**; the
only axioms used are `[propext, Classical.choice, Quot.sound]`.

Throughout, `R = [[0,1]] ×ℂ [[t₀,t₁]]` is the closed rectangle and
`∂R` is its boundary in the normal form `rectBoundary`
(`∮_{∂R} g = ∫₀¹ g(x+it₀) − ∫₀¹ g(x+it₁) + i∫_{t₀}^{t₁} g(1+iy) − i∫_{t₀}^{t₁} g(iy)`).

## 1. The zero-division factorisation

```lean
theorem exists_factorization (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hf : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ f s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt f z = m z)
    (hno : ∀ u ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], u ∉ Z → f u ≠ 0) :
    ∃ g : ℂ → ℂ,
      (∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ g s) ∧
      (∀ u ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], g u ≠ 0) ∧
      (∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], f s = g s * ∏ z ∈ Z, (s - z) ^ (m z))
```

### Construction

Write `P s = ∏_{z∈Z} (s − z)^(m z)` and, for `z ∈ Z`,
`Q z s = ∏_{z'∈Z.erase z} (s − z')^(m z')`, so that `P s = (s − z)^(m z) · Q z s`
(`Finset.mul_prod_erase`).

* **Finiteness of the order at each zero.**  For `z ∈ Z` the order
  `analyticOrderAt f z` is not `⊤`.  If it were, `f` would vanish on a
  neighbourhood of `z` (`analyticOrderAt_eq_top`); since `z` is an interior
  point of the rectangle and only finitely many points of `Z` are near it, such a
  neighbourhood contains a point `u ∈ R \ Z`, contradicting `hno`.
* **The local factors.**  Hence
  `AnalyticAt.analyticOrderAt_ne_top` produces `h z`, analytic at `z` with
  `h z z ≠ 0` and `f =ᶠ[𝓝 z] (· − z)^(analyticOrderNatAt f z) • h z`; using
  `hm z hz` this is `f =ᶠ[𝓝 z] (· − z)^(m z) · h z`.
* **Gluing.**  The candidates are glued by the single definition
  ```lean
  g s := if s ∈ Z then h s s / Q s s else f s / P s
  ```
  and the three claims are checked pointwise:
  + for `s ∉ Z`, `g =ᶠ[𝓝 s] f / P` is the quotient of two analytic functions with
    nonvanishing denominator, hence analytic and nonzero;
  + for `z ∈ Z`, `g =ᶠ[𝓝 z] h z / Q z` (the local identity, restricted to a
    punctured neighbourhood; the finitely many other points of `Z` are eventually
    avoided), which is analytic with value `h z z / Q z z ≠ 0` at `z`;
  + the product identity is immediate off `Z`; at `z ∈ Z` both `f z` and
    `g z · P z` reduce to `0^(m z) · h z z`, with the two cases `m z = 0` and
    `m z > 0` handled separately.

The only `Classical.choice` in the construction is the choice of the local
factors `h z`; the resulting `g` is a genuine function (its value at a zero is the
removable-singularity value `h z z / Q z z`).

## 2. Additivity and the vanishing of `∮ g′/g`

```lean
theorem rectBoundary_add (f g : ℂ → ℂ) (t0 t1 : ℝ) (eight integrability hypotheses) :
    rectBoundary (fun s => f s + g s) t0 t1 = rectBoundary f t0 t1 + rectBoundary g t0 t1

theorem rectBoundary_logDeriv_eq_zero (g : ℂ → ℂ) (t0 t1 : ℝ)
    (hg : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ g s)
    (hgne : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], g s ≠ 0) :
    rectBoundary (logDeriv g) t0 t1 = 0
```

`rectBoundary_logDeriv_eq_zero` is one line from Cauchy–Goursat for a rectangle:
on `R` the function `logDeriv g = (deriv g)/g` is differentiable
(`AnalyticAt.deriv` and `AnalyticAt.div`), so
`Complex.integral_boundary_rect_eq_zero_of_differentiableOn` at the corners
`t₀·i`, `1 + t₁·i` applies.  `rectBoundary_add` is the corresponding linearity of
the four interval integrals (`intervalIntegral.integral_add`).

## 3. The argument principle with an explicit factor

```lean
theorem argument_principle_of_factorization (f g : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hf : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ f s)
    (hg : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ g s)
    (hgne : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], g s ≠ 0)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hfac : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]],
      f s = g s * ∏ z ∈ Z, (s - z) ^ (m z)) :
    rectBoundary (logDeriv f) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ))
```

**Two hypotheses are added relative to the sketch in the task statement, and both
are necessary.**

* `hf` (analyticity of `f` on `R`) is **not** redundant.  `logDeriv f` involves
  `deriv f`, which is a germ condition, while `hfac` only constrains `f` on the
  closed rectangle.  Concretely, define `f` on `R` by `f s = g s · P s` and
  outside by `f(z) = (1 + min(0, Re z)) · g(z) · P(z)`: then `hfac` holds, but at
  every boundary point `f` is non-differentiable, so `deriv f = 0` and
  `logDeriv f = 0` there, whereas `logDeriv (g·P) ≠ 0`; the boundary integral of
  `logDeriv f` is then `0`, not `2πi · ∑ m z`.  The point is exactly that the
  identity theorem must be available to upgrade agreement on `R` to agreement of
  germs.  (The earlier `argument_principle_factorized` avoided the issue by taking
  `hfac` as *eventual* equality on `𝓝 s`.)
* `ht : t₀ < t₁` is used so that `interior R` accumulates at every boundary point,
  which is how the pointwise factorisation is upgraded: on the open interior,
  `f =ᶠ[𝓝 x] g·P`, so `logDeriv f = logDeriv (g·P)` there; a boundary point is in
  `closure (interior R)`, and both `logDeriv f` and `logDeriv (g·P)` are
  continuous at it, so the equality extends to the boundary
  (`tendsto_nhds_unique_of_eventuallyEq` along `𝓝[interior R] s`).

Proof outline: on the four edges (which avoid `Z`),
`logDeriv f = logDeriv (g·P) = logDeriv g + logDeriv P`, the first equality by the
continuity argument above and the second by `logDeriv_mul` (both factors are
nonzero there).  Then `logDeriv P = ∑_{z∈Z} m z · (· − z)⁻¹` by
`logDeriv_prod_pow`; additivity separates the two pieces; the `logDeriv g` piece
vanishes by §2; and the finite sum is evaluated with
`rectBoundary_finsetSum`, `rectBoundary_const_mul` and `rectBoundary_inv_of_mem`
(the already-proved winding number `∮ (s − a)⁻¹ = 2πi` for `a` strictly inside).

## 4. The general argument principle

```lean
theorem argument_principle_general (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hf : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ f s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt f z = m z)
    (hno : ∀ u ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], u ∉ Z → f u ≠ 0) :
    rectBoundary (logDeriv f) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ))
```

This matches the requested signature exactly.  It is `exists_factorization`
followed by `argument_principle_of_factorization`: the zero set and the
multiplicities are now *defined* (`Z` and `analyticOrderNatAt f`), not assumed.

## 5. What is *not* landed

* **Finiteness of the zero set is still an input.**  `Z` is a `Finset` given in
  the statement, with `hno` saying that there are no other zeros.  Deriving
  finiteness of `{s ∈ R | f s = 0}` from analyticity (isolated zeros + compactness)
  is a separate step, not attempted here.
* **The `ξ` instance.**  Instantiating `argument_principle_general` at
  `ξ(s) = ½ s(s−1) π^{−s/2} Γ(s/2) ζ(s)` still needs (a) an entire/analytic `xi`
  on the rectangle (Mathlib has no `riemannXi`, and the definition in
  `Rh45/RouteBAnalytic.lean` has removable singularities at `0, 1`), (b) the
  reality `ξ(conj s) = conj (ξ s)`, and (c) the identification of the zero set and
  its finiteness.  None of these is an argument-principle or factorisation issue.
* **Points on the boundary.**  No statement is made for `Z` meeting `∂R`; the
  hypotheses place every zero strictly inside, exactly the case needed by Route B.
* **`argument_principle_of_factorization` as literally stated** (pointwise `hfac`
  but neither `ht` nor `hf`) is false; see §3.  The delivered version adds those
  two hypotheses. `argument_principle_general` is unaffected.

## 6. Axiom check

```
#print axioms Rh45RouteBAnalytic.exists_factorization
#print axioms Rh45RouteBAnalytic.rectBoundary_logDeriv_eq_zero
#print axioms Rh45RouteBAnalytic.argument_principle_of_factorization
#print axioms Rh45RouteBAnalytic.argument_principle_general
```

All four print `[propext, Classical.choice, Quot.sound]`.

## 7. Reproduce

```bash
cd /Users/victor/workspace/rh/research/twin-prime-parity/010/lean
./check.sh --all          # all modules OK
./check.sh Rh45/Weierstrass.lean
```
