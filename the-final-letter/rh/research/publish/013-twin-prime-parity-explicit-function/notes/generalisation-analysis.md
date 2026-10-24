# Can Routes A, B, C be generalised? — the prose audit

Technical companion to [`../index.html`](../index.html). Everything below is either (i) read off the
010 Lean sources, (ii) proved in `../lean/Generic.lean`, or (iii) explicitly flagged as missing.

---

## 1. The audit: what the 010 theorems quantify over

The first, and decisive, observation is that the three routes were written at the right level of
abstraction the first time. Reading the sources:

| route | theorem | statement is about | arithmetic content |
|---|---|---|---|
| A | `Rh45Routes.exists_unique_root_of_sign_change` | `f : ℝ → ℝ` | **none** |
| A | `Rh45Routes.certified_root_of_enclosures` | `f : ℝ → ℝ` + enclosures | none |
| B | `Rh45Routes.turing_reduction` | `Finset α`, `α` arbitrary | **none** |
| B | `Rh45RouteBAnalytic.routeB_reduction_general` | `f : ℂ → ℂ` | none (`ζ` never appears) |
| B | `Rh45RouteBAnalytic.xi_routeB_general` | `ξ` | the instance, not the theorem |
| C | `Rh45Routes.validated_truncation_bound` | three reals | none |

So "can they be generalised?" at the level of statements has the answer **"they are"**. What follows
is a careful statement of *exactly which* hypotheses remain, because those are the instantiation cost.

### 1.1 Route B's exact hypothesis list

From `routeB_reduction_general (f) (t0 t1) (Z) (m)`:

1. `ht : t0 < t1` — geometry.
2. `han` — `AnalyticAt ℂ f s` for `s` in the rectangle `[0,1] × [t0,t1]`.
3. `hmem`, `hm` — the finite set `Z` is inside the rectangle and `analyticOrderNatAt f z = m z`:
   the zeros *and their orders* are data.
4. `hno` — no other zeros in the rectangle.
5. `h1 : ∀ s, f (1 - s) = f s` — self-duality (functional equation).
6. `h2 : ∀ s, f (conj s) = conj (f s)` — conjugation reality.
7. `hint₀`, `hint₁` — interval integrability of `logDeriv f` on the two horizontal edges.

Items 1, 3, 4, 7 are bookkeeping supplied per object. Items 2, 5, 6 are the three real analytic
inputs. **The entire class of completed `L`-functions with real coefficients satisfies 2, 5, 6** —
that is the generalisation.

For the Dirichlet `L`-function instantiation, items 2 and 7 are no longer *hypotheses* at all:
`lean/DirichletAnalytic.lean` proves them for `dirichletCompleted χ` for every `χ ≠ 1`
(`analyticAt_dirichletCompleted`, `intervalIntegrable_logDeriv_dirichletCompleted`), and derives the
edge non-vanishing consumed by 7 from items 3–4; see §4.4.  Items 3, 4 (the finite zero set, its
orders, and zero-freeness off it) are what remains — genuinely numerical data.

---

## 2. The four readings, and where each stops

See `../figures/general-ladder.svg`.

* **L1 (statements)** — done, see §1. Repackaged in `../lean/Generic.lean` as `SelfDualReal` +
  `routeB_of_selfDualReal`, so that the instantiation target is a *structure*, not a paragraph.
* **L2 (instantiation)** — the real work. §4 below.
* **L3 (method)** — the transferable patterns:
  1. *enclosure ⇒ sign ⇒ root*: a sign of an interval decides a sign of a value;
  2. *cardinality squeeze*: an upper bound on a set's size plus a matching certified subset forces
     equality;
  3. *pointwise ⇒ locally uniform ⇒ differentiable*: the technique used in 010's `GammaProduct.lean`
     to get the polygamma series out of Mathlib's pointwise Gauss product.
* **L4 (all zeros)** — impossible: see §6.

---

## 3. Route C, generalised in the one way that is free

`validated_truncation_bound` has exactly three tails because the explicit formula has three pieces.
The general statement is a finite sum:

```lean
theorem validated_truncation_bound_finset
    {ι : Type*} (s : Finset ι) {lhs rhsTrue rhsComputed : ℝ} (tail : ι → ℝ)
    (hlhs : lhs = rhsTrue) (hsplit : rhsTrue = rhsComputed + ∑ i ∈ s, tail i) :
    |lhs - rhsComputed| ≤ ∑ i ∈ s, |tail i|
```

proved in `../lean/Generic.lean` by induction on the finset (the 010 theorem is the `ι = Fin 3`
instance). What does *not* generalise is the content of the tails: for `ζ` they are the zero sum, the
prime sum (Chebyshev-tailed), and the archimedean integral. Per object one needs

* the explicit formula for that object (the Weil form with its conductor and archimedean factor),
* a bound for each tail.

The archimedean tail is the pleasant part: for every class member whose gamma factor is built from
`Γ`, the 010 polygamma machinery (Gauss product → Weierstrass → polygamma series → `psiSeriesBound`)
reapplies with shifted arguments. That is a genuine generalisation dividend of the 010 work.

---

## 4. Dirichlet `L`-functions: the closest concrete instantiation

### 4.1 Available in Mathlib

`Mathlib/NumberTheory/LSeries/DirichletContinuation.lean`:

* `completedLFunction (χ : DirichletCharacter ℂ N) (s : ℂ)`;
* `differentiableAt_completedLFunction χ s (hs₀ : s ≠ 0 ∨ N ≠ 1) (hs₁ : s ≠ 1 ∨ χ ≠ 1)`;
* `rootNumber χ`;
* `IsPrimitive.completedLFunction_one_sub (hχ : IsPrimitive χ) (s) :
     completedLFunction χ (1 - s) = N ^ (s - 1 / 2) * rootNumber χ * completedLFunction χ⁻¹ s`;
* `completedLFunction_modOne_eq : completedLFunction χ = completedRiemannZeta` for `χ` mod 1.

### 4.2 The normalisation (proved here)

Route B's `h1` wants self-duality. Mathlib's functional equation carries
`N ^ (s - 1/2)` and relates `χ` to `χ⁻¹`. For a character with `χ⁻¹ = χ` (real/quadratic), setting

```
h s = (N : ℂ) ^ (s / 2) * completedLFunction χ s
```

gives, substituting the functional equation,

```
h (1 - s) = N^((1-s)/2) * N^(s - 1/2) * rootNumber χ * completedLFunction χ s
          = N^(s/2) * rootNumber χ * completedLFunction χ s
          = rootNumber χ * h s
```

because `(1-s)/2 + (s-1/2) = s/2`. The middle step is `cpow` bookkeeping; the Lean proof is
`dirichletL_normalised_one_sub` in `../lean/Generic.lean`.

Since `ε := rootNumber χ` does not depend on `s`, differentiating `h(1-s) = ε h(s)` gives

```
logDeriv h (1 - s) = - logDeriv h s
```

which is precisely the reflection 010's `logDeriv_one_sub` establishes for `ξ`, and which Route B's
contour reduction consumes.

### 4.3 The remaining gaps, named

**First, a subtlety that changes the accounting.** Route B does *not* actually need the bare
self-duality `F(1-s) = F s`; it needs only the reflection of the logarithmic derivative,

```
logDeriv F (1 - s) = - logDeriv F s,
```

and that survives `h(1-s) = ε·h(s)` for **every** nonzero `ε`: differentiating gives
`-h′(1-s) = ε h′(s)`, so `logDeriv h (1-s) = (-ε h′(s))/(ε h(s)) = -logDeriv h s`, the `ε` cancelling.
The bare identity `F(1-s) = F s` is *not* recoverable when `ε ≠ 1` (no constant rescaling can fix it,
since `logDeriv (c·F) = logDeriv F`) — so the root number is not an obstruction to Route B, only to the
cosmetic rewriting. The Lean encodes both interfaces: `SelfDualReal` and the more general
`SelfDualRealUpToSign` / `routeB_general_of_logDeriv` (which takes the reflection directly).

**The gaps that remain.**

1. **Conjugation reality — CLOSED (this round).** `∀ s, Λ_χ(conj s) = conj(Λ_χ s)` for a character
   with real values is now **proved**, in `lean/DirichletConj.lean`:
   `DirichletCharacter.completedLFunction_conj`. All cases are covered — nontrivial, trivial, any
   modulus `N` — with no primitivity or parity hypothesis; `N = 1` gives `completedRiemannZeta_conj`
   as a corollary (also a genuine Mathlib gap). The proof goes: `LSeries_conj` (unconditional), then
   `LFunction_conj_of_one_lt_re` and `gammaFactor_conj` on `1 < re s`, then the identity theorem
   applied to the *entire* `ZMod.completedLFunction₀ χ` (the pole terms of
   `ZMod.completedLFunction_eq` commute with conjugation because `N` is nonnegative real and `χ` is
   real), which conjugates the algebraic identity back at every `s`. In `lean/DirichletRouteB.lean`
   the `CompletedLFunctionConj` hypothesis of `routeB_for_dirichletL` is then **discharged** from
   `hreal : ∀ n, conj (χ n) = χ n` (`routeB_for_dirichletL_of_real`).

2. **The root-number sign — CLOSED (this round), by two independent routes.** The landed
   `routeB_for_dirichletL` takes
   `RootNumberSign χ : rootNumber χ = 1 ∨ rootNumber χ = -1` to split into the `ε = 1` and `ε = -1`
   branches. By the point above, only `ε ≠ 0` is needed mathematically; the hypothesis was an artifact
   of the case split. It is now a **theorem** for every nontrivial quadratic primitive character.
   * `lean/RootNumber.lean`: `rootNumber_eq_one_or_neg_one` / `rootNumberSign_of_isQuadratic`, i.e.
     `rootNumber χ ∈ {±1}`. The proof applies the functional equation twice (`Λ_χ(s) = ε² Λ_χ(s)`) and
     evaluates at `s = 1` where `Λ_χ(1) ≠ 0`; it does *not* need `gaussSum_sq`.
   * `lean/GaussSumComposite.lean`: `rootNumber_eq_one_or_neg_one'`, the **`gaussSum_sq` route**,
     which Mathlib's field-only `gaussSum_sq` could not support at composite modulus. The missing
     ingredient is supplied there as `gaussSum_sq_of_isPrimitive`
     (`gaussSum χ stdAddChar ^ 2 = χ(-1) · N` for primitive quadratic `χ` and **arbitrary** `N`),
     proved by the discrete Fourier transform on `ZMod N` (`dft_dft` / Fourier inversion +
     `gaussSum_mulShift_of_isPrimitive`) without ever dividing in `ZMod N`; the product form
     `gaussSum χ stdAddChar * gaussSum χ⁻¹ stdAddChar = χ(-1) · N` is recorded as well. The identity
     specialises to Mathlib's `gaussSum_sq` at prime `N` (examples at `N = 3, 5, 7`).
   `IsPrimitive χ` is essential in both routes: for imprimitive `χ` the root number can be, e.g.,
   `1/√2` (the `changeLevel` image of the mod-3 quadratic character at modulus 6, where
   `τ² = -3 ≠ χ(-1)·N = -6`; verified by `verify/check_gausssum_sq.py`).  In
   `lean/DirichletRouteB.lean`, `routeB_for_dirichletL_unconditional` discharges both this and the
   conjugation hypothesis.  The three *analytic* hypotheses it still carried are discharged in
   `lean/DirichletAnalytic.lean` (see §4.4 below).

3. Route B's own zero data (`hmem, hm, hno`) are not discharged for any concrete `χ`.  The analytic
   hypotheses (`han, hint₀, hint₁`) are **no longer** part of this list: they are theorems for
   every nontrivial `χ` — see §4.4.  The **numerical interval engine now exists**:
   [`../rigorous/dirichlet_interval.py`](../../../twin-prime-parity/011/rigorous/dirichlet_interval.py) encloses
   `Λ'_χ/Λ_χ` and `(log Λ_χ)''` rigorously on boxes (Euler–Maclaurin Hurwitz zeta with the
   periodic-Bernoulli remainder bound; see §6.2), so the only remaining inputs are the
   *numerical* zero data.

### 4.4 The analytic hypotheses of Dirichlet Route B are theorems

`routeB_for_dirichletL_unconditional` took `han` (analyticity on the rectangle) and `hint₀`,
`hint₁` (interval integrability of `logDeriv h` on the two horizontal edges).  All three are
proved in `lean/DirichletAnalytic.lean`, for every `χ ≠ 1`, with no primitivity/reality/quadraticity
input:

* `analyticAt_dirichletCompleted` — `h(s) = N^{s/2} Λ_χ(s)` is entire: `s ↦ N^{s/2}` by
  `AnalyticAt.cpow` at the real base `N ∈ slitPlane` (`NeZero N`), and `Λ_χ` by
  `differentiable_completedLFunction`; box form `analyticAt_dirichletCompleted_of_mem`,
  `Differentiable` form `differentiable_dirichletCompleted`.
* `continuousOn_logDeriv_dirichletCompleted` / `intervalIntegrable_logDeriv_dirichletCompleted` —
  `logDeriv h = deriv h / h` with `deriv h` continuous (`ContDiff.continuous_deriv_one`, from
  analyticity of `h`), `h` continuous, and `h` nonvanishing on the segment; `ContinuousOn.div`
  then `ContinuousOn.intervalIntegrable` on `[0,1]`.
* `routeB_for_dirichletL_of_zeros` — the repackaged Route B.  The edge non-vanishing hypotheses
  are *derived*: `hmem` gives `t0 < z.im < t1` for every `z ∈ Z`, so an edge point `x + t₀I` (or
  `x + t₁I`) never lies in `Z`, and `hno` supplies non-vanishing there.  Hence the statement's
  only hypotheses are the numerical zero data `Z`, `m`, `hno`.

---

## 5. Target catalogue

| object | FE | reality | engine | explicit formula | verdict |
|---|---|---|---|---|---|
| Riemann `ζ` | done (010) | done (010) | done | done (010) | 3 windows certified |
| Dirichlet `L` (real primitive) | normalisation proved here | **proved here** | **built here** (Euler–Maclaurin Hurwitz zeta) | standard | closest |
| Dedekind `ζ_K` | partly in Mathlib | plausible | missing | standard | needs class-number side |
| Hecke / Maass `L` | absent | absent | missing | absent | out of reach |
| elliptic-curve `L` | absent | absent | missing | absent | out of reach |
| Selberg class | axiom of the class | axiom | per object | Weil form | the right *formal* home |

**The natural formal target is a `structure SelbergClass`** carrying exactly Route B's hypotheses
(analyticity, functional equation with conductor and root number, Euler product, Ramanujan growth),
together with `routeB_reduction_general`. The `Euler product` field is needed only for Route C's prime
tail; the growth field only for tail bounds.

---

## 6. Four things that do not generalise

1. **L4.** Routes A–C conclude from finitely many enclosures, so they can only ever certify finite
   windows. The all-zeros statement for an `L`-function is (G)RH and is untouched.
2. **The interval engine.** `010/rigorous/` is engineered for `ζ`: the Euler-accelerated `η`, the
   removable-singularity routing at `t_k = 2πk/log 2`, the `K ≳ 0.25 t` rule, the per-step `Lf`
   enclosure. Each new object needs its own evaluator — the dominant L2 cost.  For a Dirichlet `L`
   that evaluator now exists ([`../rigorous/dirichlet_interval.py`](../../../twin-prime-parity/011/rigorous/dirichlet_interval.py)):
   `L(χ,s) = N^(-s) Σ_{a<N} χ(a) ζ(s,a/N)` with the Hurwitz zeta by Euler–Maclaurin plus the
   periodic-Bernoulli remainder bound
   `|R_K| ≤ |(s)_{2K+1}|/(2K+1)! · sup|B~_{2K+1}| · b^{-σ-2K}/(σ+2K)`,
   `sup|B~_{2K+1}| ≤ 2(2K+1)!ζ(2K+1)/(2π)^{2K+1}` (differentiated for `L'`, `L''`), then
   `Λ'_χ/Λ_χ = ½log(N/π) + ½ψ((s+a)/2) + L'/L` and `(log Λ_χ)'' = ¼ψ'((s+a)/2) + (L'/L)'`.  The
   verifier [`../verify/check_dirichlet_engine.py`](../../../twin-prime-parity/011/verify/check_dirichlet_engine.py) confirms
   containment against mpmath on the Route-B path with point-box widths `≲10^-9`.  It is *not* a
   certified window: the zero data `Z`, `m`, `hno` for a concrete `χ` are still the remaining input
   (and near-zero / wide-box / large-`t` degradation is documented in
   [`../rigorous/README.md`](../../../twin-prime-parity/011/rigorous/README.md)).
3. **Route A's simplicity conclusion.** The certificate concludes `0 < deriv f x`, so it certifies
   simple transversal zeros only. A `k`-th order certificate is a genuine extension.
4. **The archimedean budget outside the `Γ` family.** The polygamma series bounds `ψ^(k)`, hence any
   `L` whose archimedean factor is a product of `Γ`'s; a different archimedean factor is a different
   problem.

---

## 7. Ledger

| claim | status | evidence |
|---|---|---|
| Route A is `∀ f`; Route B's squeeze is `∀ Finset α`; Route B's core is `∀ f` | AUDITED | the 010 sources, quoted in `../index.html` §2 |
| `SelfDualReal` interface + Route-B packaging | PROVED (new) | `../lean/Generic.lean` |
| `n`-tail Route C | PROVED (new) | `../lean/Generic.lean` |
| `h(1−s) = ε·h(s)` for real `χ` | PROVED (new) | `../lean/Generic.lean` |
| Dirichlet Route B | **PROVED** (both named gaps discharged) | `routeB_for_dirichletL_unconditional`; only the shared analytic data `han…hint₁` remains |
| analyticity of `dirichletCompleted χ` on the rectangle (`han`) | **PROVED (new)** — entire for `χ ≠ 1` | `lean/DirichletAnalytic.lean` (`analyticAt_dirichletCompleted`, `…_of_mem`, `differentiable_dirichletCompleted`) |
| interval integrability of `logDeriv (dirichletCompleted χ)` on the edges (`hint₀`, `hint₁`) | **PROVED (new)** — from `ContinuousOn` off the zero set | `lean/DirichletAnalytic.lean` (`continuousOn_logDeriv_dirichletCompleted`, `intervalIntegrable_logDeriv_dirichletCompleted`) |
| Dirichlet Route B with all analytic hypotheses discharged | **PROVED (new)** — only the numerical zero data `Z`, `m`, `hno` remain | `lean/DirichletAnalytic.lean` (`routeB_for_dirichletL_of_zeros`) |
| conjugation reality of `completedLFunction` | **PROVED (new)** — `DirichletCharacter.completedLFunction_conj`, all cases | `lean/DirichletConj.lean` |
| conjugation reality of `completedRiemannZeta` | **PROVED (new)** — corollary at `N = 1` | `lean/DirichletConj.lean` |
| `rootNumber χ ∈ {±1}` for quadratic primitive `χ` | **PROVED (new)** — functional equation twice | `lean/RootNumber.lean`; §4.3 |
| `gaussSum χ stdAddChar ^ 2 = χ(-1)·N` (primitive quadratic, **composite** `N`) | **PROVED (new)** — discrete Fourier transform on `ZMod N` | `lean/GaussSumComposite.lean` (`gaussSum_sq_of_isPrimitive`); §4.3 |
| `rootNumber χ ∈ {±1}` by the `gaussSum_sq` route | **PROVED (new)** — second, independent proof | `lean/GaussSumComposite.lean` (`rootNumber_eq_one_or_neg_one'`); §4.3 |
| interval engine for a Dirichlet `L` and its `Λ'_χ/Λ_χ` | **BUILT (new)** — Euler–Maclaurin Hurwitz zeta, differentiated remainders, `Λ'_χ/Λ_χ` and `(log Λ_χ)''` on boxes; verified | `rigorous/dirichlet_interval.py`; `verify/check_dirichlet_engine.py`; §6.2 |
| certified zero window for a Dirichlet `L` (i.e. `Z`, `m`, `hno`) | NOT DONE — the engine supplies the enclosures, the zero data are still to be produced | §6.1, §6.2 |
| GRH-strength generalisation | IMPOSSIBLE | §6.1 |
