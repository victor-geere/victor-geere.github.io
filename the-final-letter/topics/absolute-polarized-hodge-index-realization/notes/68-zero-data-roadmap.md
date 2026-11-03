# Note 68 — Zero data for the Hadamard factorisation: roadmap

**Status: No RH proof yet.** The Hadamard factorisation of the completed zeta
is now Lean-checked *conditionally on its zero data*:

`factorization_of_xi₀` and `logDeriv_completedZeta_eq_tsum_of_zeros`
(rounds 472–475) take, as hypotheses:

1. an enumeration `a : ℕ → ℂ` of the nontrivial zeros (all nonzero);
2. summability `Σ ‖aₙ‖^{-(p+1)}`;
3. the **divisor match** `meromorphicOrderAt ξ₀ u = meromorphicOrderAt P u`
   for all `u` (`P` the canonical product);
4. finiteness of the divisor (`meromorphicOrderAt ξ₀ u ≠ ⊤`);
5. the **log-growth-one** condition on `ξ₀ / P`.

This note records what is already Lean-checked toward these, and the exact
steps that remain.

## What is Lean-checked

- **The zeros are isolated** (`xi₀_zero_isolated`, round 477): at any zero
  `w`, `ξ₀ ≠ 0` on a punctured neighbourhood. Proof by the identity theorem.
- **The divisor is locally finite**: `MeromorphicOn.divisor ξ₀ Set.univ` is
  a `Function.locallyFinsuppWithin Set.univ ℤ` (Mathlib), and its value at `z`
  is `(meromorphicOrderAt ξ₀ z).untop₀`; the order is nonzero exactly at the
  zeros.
- **A Jensen-type divisor bound** (`sum_divisor_le_two_mul`): if `ξ₀` is
  analytic on the ball of radius `2r`, `ξ₀(0) ≠ 0` and `‖ξ₀‖ ≤ M` on the
  sphere of radius `2r`, then the divisor sum over the ball of radius `r` is
  at most `log(M/‖ξ₀(0)‖)/log 2`. With the log-growth of `ξ₀`
  (`HasLogGrowthOne`, i.e. `log ‖ξ₀ z‖ ≤ A‖z‖ + B`) this bounds the number of
  zeros in each ball by `O(r)`.
- **The Hadamard machinery**: the canonical products, their convergence
  (`multipliable_weierstrassFactor`, `hasProdUniformlyOn_weierstrassFactor`),
  and the factorisation theorem (`exists_affine_factorization_of_logGrowthOne`).

## A cleaner formulation of the divisor match: product over the divisor

Instead of enumerating the zeros by hand, the canonical product can be taken
**over the divisor itself**: for a locally finitely supported `D : ℂ → ℤ` with
support the zero set, define

`P_D(z) = ∏' w : {w // D w ≠ 0}, (E_p(z/w))`,

with the multiplicities `D w` inserted as powers when they exceed `1`. The
divisor match is then **by construction** (each factor contributes order `1`,
or `D w` with the power), and the convergence of the product is exactly the
summability lemma already Lean-checked (`xi₀_zeros_inv_sq_summable`, in
subtype form over `{z // ξ₀ z = 0}`). The remaining work is the
subtype-product bookkeeping (analogous to the enumerated `tprod` lemmas
already in the Hadamard layer), not new analysis.


### Correction on the growth hypothesis (round 487)

The counting bound `xi₀_zero_count_bound` and the summability
`xi₀_zeros_inv_sq_summable` were proved under the hypothesis
`log ‖ξ₀ z‖ ≤ A‖z‖ + B` (**log-growth one, finite type**). That hypothesis
is **false for `ξ`**: since the number of zeros satisfies
`N(T) ~ (T/2π)log T` (Riemann–von Mangoldt), Jensen's bound
`N(r) ≤ log M(2r)/log 2` would give `N(r) = O(r)`, a contradiction. Indeed
`ξ` has order `1` but infinite type: `log M(r) = O(r log r)` (the Gamma
factor decays like `e^{−π|t|/4}` on fixed lines, but the maximum over
`|z| ≤ r` is attained at `Re z ≈ −r`, where the functional equation gives
`e^{O(r log r)}`).

What is Lean-checked and correct:

- `xi₀_zero_count_bound_of_log_le` (**round 487**): if
  `log ‖ξ₀‖ ≤ L` on the sphere of radius `2r`, then `N(r) ≤ L/log 2`.
  With the true growth `L = A·(2r)·log(2r) + B` this yields
  `N(r) = O(r log r)` — consistent with Riemann–von Mangoldt.
- With `N(r) ≤ C·r·log r`, the shell sum is
  `Σ_k C·2^k·k·2^{-k(1+ε)} = C Σ_k k·2^{-kε} < ∞`, so the summability
  conclusion remains **true**; its Lean proof has now been redone from the
  `r log r` bound (round 488):
  `xi₀_zeros_inv_sq_summable_of_log_growth`.
- `xi₀_zero_count_bound` (linear hypothesis) and
  `xi₀_zeros_inv_sq_summable` remain valid **conditional implications**;
  what changes is that their hypothesis must be replaced by the `r log r`
  growth to apply to `ξ`.

## A second gap: the log-growth hypothesis is not derivable from the current theorem

The dossier's Hadamard theorem `exists_affine_factorization_of_logGrowthOne`
proves `f = P·e^{affine}` under the hypothesis `HasLogGrowthOne (f/P)`, i.e.
`log ‖f/P‖ ≤ A‖z‖ + B` — **order 1 with finite type**. For `ξ₀` the quotient
is `e^{a+bz}` (true, since `ξ₀` has order 1, so the exponential factor is
affine), and then `log ‖ξ₀/P‖ = Re(a+bz) ≤ |a| + |b|‖z‖` — so the hypothesis
**is true**. But it is not *derivable* from the theorem: the theorem assumes
it. Deriving it requires the **order-1 Hadamard theorem in infinite type**,
whose proof runs through Borel–Carathéodory / Phragmén–Lindelöf for functions
of order 1 (not through the linear majorant the dossier currently uses).

So the honest statement is: the divisor match, summability, countability and
the local order computations are in place, but the **exponential-factor step
for `ξ₀` needs the order-1 Hadamard theorem beyond the current Mathlib-level
machinery** (the dossier has the finite-type version only). This is a
formalisation gap, not an RH gap.

### The precise theorem needed

The classical statement is: a **zero-free entire function of finite order `ρ`
is `e^P` with `P` a polynomial of degree `≤ ρ`**. Equivalently: if `e^g` has
finite order `ρ`, then `g` is a polynomial of degree `≤ ρ`. (For `ρ = 1` this
is an affine exponential.) Note that `e^{cos z − 1}` is zero-free but has
**infinite** order (`log M(r) ~ e^r`), so finiteness of the order is essential;
`ξ₀` is order 1, so the theorem applies with `ρ = 1`.

Mathlib provides the two main analytic tools:

- `Complex.borelCaratheodory` (`Mathlib/Analysis/Complex/BorelCaratheodory.lean`);
- the Hadamard three-lines theorem (`Mathlib/Analysis/Complex/Hadamard.lean`).

A formalisation route: (i) `h` zero-free entire gives `h = e^g` (the dossier's
`exists_differentiable_cexp_univ`); (ii) `Re g = log ‖h‖ ≤ r^{ρ+ε}` by the
order hypothesis; (iii) Borel–Carathéodory bounds `‖g‖ ≲ r^{ρ+ε}`.

**Caveat on step (iv).** The naive continuation — Cauchy estimates on `g'`
then `ε → 0` — is **not** a valid proof: an `ε`-dependent bound
`‖g'‖ ≲ r^{ε}` does not become a uniform bound. The classical theorem is
genuinely deeper (it is part of Hadamard's theory): one argues that if `g`
were transcendental then `e^g` would have infinite order, using the zero
distribution of `g'` and the maximum principle. Formalising this requires a
careful case analysis (polynomial versus transcendental `g`), which is a
substantial project in its own right. Mathlib has the Borel–Carathéodory and
three-lines tools but **not** the zero-free finite-order theorem. Progress on
the ladder, all Lean-checked:

- **order 0**: `eq_const_of_bddAbove_re` (bounded `Re g` ⇒ `g` constant, round 519);
- **subquadratic (order `< 2`)**: `subquadratic_eq_affine_of_re_le_rpow`
  (`Re g ≤ A‖z‖^p + B` with `1 < p < 2` ⇒ `g` affine, round 520), proved by
  Borel–Carathéodory plus Cauchy estimates.

Since `r log r ≤ C r^{3/2}`, the subquadratic case **covers the order-1
`r log r` growth** (`p = 3/2`). So the zero-free theorem is now available for
every growth of the form `A r log r + B`. The **lower bounds on `|P|` are now Lean-checked** too: per factor
(`log_norm_weierstrassFactor_one_div_lower`), for finite products
(`log_norm_finiteCanonicalProduct_one_lower`) and for the **infinite product**
(`log_norm_tprod_weierstrassFactor_one_lower`, round 524). What remains for the
factorisation route is to combine these with the upper bound on `log|ξ₀|` and
the divisor match to obtain the quotient's growth bound, then apply
`subquadratic_eq_affine_of_re_le_rpow`.

## A third gap: the growth of `Γ_ℝ` (Stirling) is not in Mathlib

Combining the lower bounds just obtained with an **upper** bound on
`log|ξ₀|` requires bounding the completed zeta's archimedean factor
`Γ_ℝ(s) = π^{−s/2}Γ(s/2)`. The needed statement is of the form
`log‖Γ_ℝ(s)‖ ≤ A‖s‖log‖s‖ + B` (Stirling-type, sufficient for order 1).

Mathlib's Gamma development (`Mathlib/Analysis/SpecialFunctions/Gamma/`:
`Basic`, `Beta`, `BohrMollerup`, `Deligne`, `Deriv`, `Digamma`) has **no
Stirling growth estimate** for `‖Γ(s)‖` (the only mention of Stirling is in a
docstring in `BohrMollerup.lean`).

**Correction (round 526).** The growth bounds *are* now Lean-checked, and the
naive unrestricted form is **false**: as `σ → 0⁺`, `Γ(σ) ~ 1/σ` so
`log‖Γ σ‖ → +∞`. What holds (and is merged) is
`norm_Gamma_le_Gamma_re` (`‖Γ s‖ ≤ Γ(re s)` for `re s > 0`),
`exists_bound_log_norm_Gamma_right_of_one_le_re` (`re s ≥ 1`),
`..._of_half_le_re` (`re s ≥ 1/2`), and `..._corrected` (whole half-plane with
the necessary `−log(re s)` term), with the refutation
`not_exists_bound_log_norm_Gamma_right` machine-checked. For `ξ₀` the
archimedean factor is needed away from the pole, so the half-plane or corrected
forms are the right inputs. The **archimedean growth bound itself** is now
Lean-checked for `re s ≥ 1/2`:
`gammaR_growth_exists_bound_log_norm_half_le`
(`log ‖Γℝ(s)‖ ≤ A‖s‖log(‖s‖+2) + B`, round 527).

## A fourth gap: growth of `ζ` in the critical strip

The last input for the upper bound on `log|ξ₀|` is a bound for `‖ζ(s)‖` in the
critical strip `0 < re s < 1`. What is needed is only the *order-1* form
`log‖ζ(s)‖ ≤ A‖s‖log‖s‖ + B` (not the sharp convexity exponent).

Mathlib has the functional equation and the Euler product (so `‖ζ(s)‖ ≤
ζ(re s) ≤ 2` for `re s ≥ 2` — now Lean-checked, `norm_riemannZeta_le_two`,
round 531) and `‖ζ(s)‖ ≤ 3` on `re s ≥ 3/2`
(`norm_riemannZeta_le_three_of_three_halves`, round 532), but **no growth bound
in the strip**. Note that
the functional equation alone does *not* close the strip (it maps `σ ↦ 1−σ`,
staying inside), so the standard routes are:

- the **convexity bound** via Mathlib's three-lines theorem
  (`Mathlib/Analysis/Complex/Hadamard.lean`), using the boundary bounds at
  `re s = 2` (Euler product) and the Phragmén–Lindelöf principle, or
- the **approximate functional equation / partial summation**
  (`ζ(s) = Σ_{n≤N} n^{−s} + N^{1−s}/(s−1) + O(N^{−σ})`).

Either is a substantial formalisation; both are independent of RH. Numerically
the required order-1 form `log‖ζ(s)‖ ≤ ‖s‖log(‖s‖+2) + B` holds on a grid over
the strip (and `|ζ(1/2+it)| ≤ 0.5√t` there) — `test_zeta_strip_growth_numerical`,
round 529.

Note that the **lower** bounds on `|P|` are only linear (round 524), so an
order-1 upper bound on `log|ξ₀|` suffices: the subquadratic theorem
(round 520) then gives the quotient `ξ₀/P = e^{affine}`.

### Correction: the strip bound must exclude the pole at `s = 1`

The literal strip bound `∃ A B, ∀ s, 1/2 ≤ re s ≤ 2 → log‖ζ(s)‖ ≤ A‖s‖log(‖s‖+2)+B`
is **false**, and this is now Lean-checked
(`not_exists_bound_log_norm_zeta_strip`, round 533): the strip contains points
approaching the pole `s = 1`, where `‖ζ(s)‖ → ∞` while the right-hand side stays
bounded (`not_exists_uniform_bound_near_one`). The polynomial fallback
`‖ζ(s)‖ ≤ A(‖s‖+2)²` is likewise false on the unrestricted strip
(`not_exists_bound_norm_zeta_strip_poly`).

The correct statements carry either the pole subtraction or a lower bound on
`‖s‖`. What is now Lean-checked:

- `norm_riemannZeta_le_one_add_inv_sub_one`:
  `‖ζ(s)‖ ≤ 1 + 1/(re s − 1)` for `re s > 1` — explicit and elementary;
- `exists_bound_log_norm_zeta_right_corrected`: the order-1 log bound on
  `re s > 1` **with** the necessary `−log(re s − 1)` term.

**This gap is now closed** (round 536), and *without* the approximate
functional equation: the dossier imports the exact Euler--Maclaurin expansion
from the neighbouring `finite-window-zeros` topic (the new file
`lean/ZetaStrip.lean`, compiled by `check.sh` with `LEAN_EXTRA_PATH` pointing at
`../finite-window-zeros/lean`) and proves
`exists_bound_norm_zeta_strip_polefree : ∃ A ≥ 0, ∀ s, 1/2 ≤ re s → re s ≤ 1 →
2 ≤ ‖s‖ → ‖ζ(s)‖ ≤ A(‖s‖+2)²`, together with the identity
`ζ(s) = zetaEM N s` on the punctured half-plane. The order-1 log bound follows
immediately. So **all analytic inputs of the zero-data package are Lean-checked**. In
addition, round 537 adds the **functional equation** `xi₀ (1 − z) = xi₀ z` and
the **growth bound** `∃ A ≥ 0, ∀ z, log‖ξ₀ z‖ ≤ A‖z‖log(‖z‖+2) + B` for `ξ₀`
itself, so both growth inputs (of `ξ₀` and of the zero-free quotient) are now
available. The remaining gaps are the infinitude/enumeration assembly and the
Weil converse.

## A key discovery: Mathlib has Jensen's formula and Nevanlinna theory

The remaining assembly step needs a **lower** bound on `log|P|` in terms of the
zeros (not just the upper/lower bounds in `‖z‖` of rounds 524/538). Mathlib
provides exactly the right machinery:

- **Jensen's formula in divisor form**
  (`Mathlib/Analysis/Complex/JensenFormula.lean`):
  `MeromorphicOn.circleAverage_log_norm` states, for `meromorphicOn f (closedBall c |R|)`,
  `circleAverage (log ‖f ·‖) c R
     = ∑ᶠ u, divisor f (closedBall c |R|) u * log (R * ‖c - u‖⁻¹)
       + divisor f (closedBall c |R|) c * log R
       + log ‖meromorphicTrailingCoeffAt f c‖`,
  plus the factorisation lemmas `circleAverage_log_norm_factorizedRational` and
  `AnalyticOnNhd.circleAverage_log_norm_of_ne_zero`.
- **A full value-distribution (Nevanlinna) theory**
  (`Mathlib/Analysis/Complex/ValueDistribution/`): `CharacteristicFunction`,
  `FirstMainTheorem`, `SecondMainTheorem`, `Cartan`, `LogCounting`
  (`logCounting`, `sum_toClosedBall_le_logCounting`, `logCounting_le`,
  `logCounting_eventuallyLE`) and `Proximity`.

This is the machinery for the quotient-growth assembly: the divisor sum in
Jensen's formula is precisely the `N(r)` term that grows like `r log r`, so it
supplies the missing lower bound on `log|P|` and hence the cancellation of the
`r log r` terms in `log|ξ₀/P|`.

Mathlib also has the **Poisson kernel and the Poisson integral formula**
(`Mathlib/Analysis/Complex/Poisson.lean`): `Complex.poissonKernel`,
`DiffContOnCl.circleAverage_poissonKernel_smul` and `..._smul'`. For a zero-free
`h` the function `log‖h‖` is harmonic, so the Poisson formula expresses
`log‖h(z)‖` as a circle average against the Poisson kernel; combined with the
Jensen formula this yields the pointwise bounds of the classical Hadamard
argument.

**The remaining assembly, precisely.** For `h = ξ₀/P` (zero-free, entire):
1. `log‖h‖` is harmonic, so `log‖h(z)‖ = circleAverage (log‖h‖) z r` for every
   `r > ‖z‖` (mean value property);
2. hence `log‖h(z)‖ ≤ log M_h(r)` for every `r > ‖z‖`, and
   `log M_h(2‖z‖) ≤ log M_ξ₀(2‖z‖) − min_{|w|=2‖z‖} log‖P(w)‖`;
3. the last term is bounded below by the Jensen/divisor count
   (`N(r) log r − Σ log|a_n|`), and `log M_ξ₀(2‖z‖) ≤ A‖z‖log‖z‖ + B`;
   the two `r log r` terms cancel, leaving `log‖h(z)‖ ≤ A'‖z‖ + B'` —
   which is exactly `HasLogGrowthOne h`, the hypothesis of the dossier's
   Hadamard factorisation theorem.

This is a multi-step project; the pieces (Jensen, Poisson, the growth bound of
`ξ₀`, the divisor count `N(r) ≤ C r log r`) are all available.

### Retraction (round 544): the pointwise circle bound is FALSE

The "circle lower bound" sketched below was tested and **refuted** in Lean by
both workflow attempts: for `‖w‖ = 2r`, a zero with `‖a n‖` slightly larger
than `2r` makes `1 - w/a n` tiny, so `log‖E₁(w/a n)‖ → −∞` while the proposed
bound `−C r/‖a n‖` stays bounded. No constant `C` works; the machine-checked
counterexample family is `r = 500`, `a 0 = 1001`, `a (n+1) = 10⁴·2^{n+1}`, where
the claimed bound `−3000·(1/1001 + 1/10⁴) ≈ −3.297` fails against the actual
`log‖E₁(1000/1001)‖ ≈ −5.91`.

What *is* provable (and is already in the dossier) is the **separated** bound
`log_norm_tprod_weierstrassFactor_one_lower` (`‖z‖ ≤ ‖a n‖/2`), which the
refutation's "corrected version" restates. The lesson for the assembly: a
**pointwise** bound on a circle cannot work; the classical argument uses the
**circle average** (Jensen's formula, `MeromorphicOn.circleAverage_log_norm`) and
the Poisson representation, not a pointwise lower bound on `|P|`. The mean value
property needed here is now Lean-checked: `circleAverage_log_norm_of_forall_ne_zero`
(`∀ z, h z ≠ 0` ⇒ `Real.circleAverage (log‖h·‖) c R = log‖h c‖`, round 545), and
the **weighted divisor-sum bound** — the counting-function estimate
`Σ divisor·log(R/‖u‖) ≤ A·R·log(R+2) + B + const` — is Lean-checked too
(`divsum_log_le_of_growth_trailingCoeff`, round 549).

### A useful simplification: the linear bound is not needed

The classical argument aims for `HasLogGrowthOne h` (a **linear** bound), but
the dossier's `subquadratic_eq_affine_of_re_le_rpow` only needs
`Re log h(z) ≤ A‖z‖^{3/2} + B`, and `r log r ≤ C r^{3/2}`. So it suffices to get
the **`r log r` bound** on `log|h|`, and that follows from a much weaker
statement about the product: for `‖w‖ = 2r` one has
`log|P(w)| ≥ Σ_{|a_n| ≤ r} log(r/|a_n|) − 4r Σ 1/|a_n| ≥ −4r Σ 1/|a_n|`,
since `Σ_{|a_n| ≤ r} log(r/|a_n|) ≥ 0` (each term is `≥ 0` because
`|a_n| ≤ r`). This is a **linear** lower bound on the circle, and then
`log|h(z)| ≤ log M_ξ₀(2‖z‖) + 4‖z‖ Σ 1/|a_n| ≤ A'‖z‖ log(‖z‖+2) + B'`.

So the remaining formalisation is:

1. the maximum-modulus step `log‖h(z)‖ ≤ log M_h(2‖z‖)` (from harmonicity of
   `log‖h‖` / the mean value property, or the maximum modulus principle);
2. the circle lower bound `log|P(w)| ≥ −4r Σ 1/|a_n|` for `‖w‖ = 2r`
   (per-factor split by `|a_n| ≤ r` vs `|a_n| > r`, the tail using round 538's
   upper bound and the head using `log|1 − w/a_n| ≥ log(r/|a_n|)`);
3. feeding the resulting `r log r` bound into
   `subquadratic_eq_affine_of_re_le_rpow`.

**Step 1 is now Lean-checked**: `norm_le_of_forall_mem_sphere_le`
(`‖f z‖ ≤ M` for `‖z‖ ≤ R` whenever `‖f‖ ≤ M` on the sphere `‖w‖ = R`, from
Mathlib's `Complex.norm_le_of_forall_mem_frontier_norm_le`,
`Mathlib/Analysis/Complex/AbsMax.lean`, round 543). The maximum modulus
principle is available as that Mathlib lemma, and the harmonic-function library
(`Mathlib/Analysis/Complex/Harmonic/`: `Analytic`, `Liouville`, `MeanValue`,
`Poisson`) supplies the mean value property for `log‖h‖`. The canonical-factor
API (`Mathlib/Analysis/Complex/CanonicalDecomposition.lean`, finite Blaschke
products) is also available, should a disk-local decomposition be preferred.

## An obstruction: infinitude of the zero set

Constructing the multiplicity enumeration needs the zero set to be **infinite**
(if it were finite, the sigma type `Σ z, Fin (m z)` would be finite and could
not be bijective with `ℕ`; the finite case needs a separate treatment with a
finite product). Infinitude is numerically certain but not yet formalised.
A viable route:

1. If `ξ₀` had finitely many zeros, the Hadamard factorisation would give
   `ξ₀ = P·e^{a+bz}` with `P` a finite product;
2. then `ξ₀'/ξ₀ = P'/P + b` is **bounded** as `z → ∞` along `ℝ`;
3. but on the real axis
   `ξ₀'/ξ₀(σ) = 1/σ + 1/(σ−1) + (−(1/2)log π + (1/2)ψ(σ/2)) + ζ'/ζ(σ)`,
   and `ψ(σ/2) → ∞`, so `ξ₀'/ξ₀(σ) → ∞` — a contradiction.

There are two routes to infinitude, and it is worth recording both:

- **Factorisation route** (the one sketched here): if there were finitely many
  zeros, the finite canonical product `P` would be a polynomial-times-exponential
  and `ξ₀/P` would be `e^{affine}`, making `ξ₀'/ξ₀ = P'/P + b` bounded —
  contradicting the growth along the real axis, now **Lean-checked**
  (`tendsto_logDeriv_completedZeta_re_atTop`, round 518). The remaining input
  is the `P'/P` boundedness (rounds 514–516 give the finite-product bounds) and
  the **zero-free finite-order theorem** for the finite case.
- **Argument-principle route**: for a rectangle of height `2T` and width `4`,
  the divisor count equals `(2πi)⁻¹ ∮ Z'/Z`. The right-vertical integral is
  Lean-checked (`integral_logDeriv_mul_I_eq_neg_arch_prime'`), and its
  archimedean part grows like `T log T`; the horizontal contributions are
  controlled by the functional equation. This would give the Riemann–von
  Mangoldt lower bound `N(T) ≥ c T log T` directly, without any Hadamard
  factorisation — but it requires the horizontal estimates (Stirling) and the
  winding/count relation on the rectangle boundary.

Step 3 needs only the **unboundedness** of `ψ` along the naturals, which is now
Lean-checked (round 499): `tendsto_digamma_nat_re_atTop` gives
`Re ψ(n+1) = H_n − γ → ∞` from the Euler–Mascheroni asymptotics. What remains
for the contradiction is the boundedness of `ζ'/ζ` (or `L_Λ`) along the same
sequence — `L_Λ(σ) = Σ Λ(n)n^{−σ}` is bounded for `σ ≥ 2` — and the
finite-factorisation bound `P'/P + b`. This is recorded as the next sub-project; it is a
statement about the *existence* of many zeros, not about their location, so it
does not touch the RH-equivalent frontier.

## The exact remaining steps

1. ~~**Finiteness on compact balls**~~ — **DONE** (round 479):
   `xi₀_zeros_finite_in_closedBall` proves `{z | ξ₀ z = 0, ‖z‖ ≤ r}` finite
   from the local finiteness of the divisor.
2. ~~**Enumeration**~~ — **available in principle** (rounds 480, 497):
   `xi₀_zeros_countable` shows the zero set is countable (a countable union of
   the finite ball-intersections), so it admits a `ℕ`-indexing, packaged as
   `exists_enumeration_zeros` (with `Set.range a = {z | ξ₀ z = 0}` and all
   terms nonzero); the **multiplicity** variant (each zero repeated according
   to its order) remains to be constructed.
3. **Divisor match**: `meromorphicOrderAt ξ₀ u` equals the order of the
   canonical product at `u`. For `u` not a zero both sides are `0` —
   **Lean-checked** (round 481: `meromorphicOrderAt_xi₀_eq_zero_of_ne_zero`
   and the canonical-product order-zero lemmas), so only the zeros remain.
   The **simple case at a zero is already Lean-checked**:
   `meromorphicOrderAt_tprod_weierstrassFactor_at_zero` gives order `1` at
   `a k` under the separation `2R ≤ ‖a n‖` (n ≠ k) and distinctness, and
   round 489 adds the general local-factorisation step
   `meromorphicOrderAt_eq_one_of_local_factor`. What remains for the
   **general** case is removing the *finitely many* nearby zeros (a finite
   split of the infinite product, now Lean-checked as
   `tprod_eq_prod_mul_tprod_compl`, round 491), and the resulting
   finite-split order theorem is Lean-checked (round 493):
   `meromorphicOrderAt_tprod_weierstrassFactor_at_zero_of_finset` gives order
   `1` at `a k` whenever all zeros outside a finite set `s ∋ k` are separated
   — exactly the situation for the actual zeros — and its **multiplicity
   version** (round 494) gives order `= #{n ∈ s | a n = a k}`, so a repeated
   enumeration matches the order at every zero without assuming simple zeros;
   the actual nontrivial zeros (all `|ρ| ≥ 14`) violate `2R ≤ ‖a n‖` for
   close pairs, so this finite-split step is genuinely needed; for
   `u = aₙ` the product has a simple factor and the multiplicity from step 2
   supplies the order. (Needs `meromorphicOrderAt_finiteCanonicalProduct`,
   already in the Hadamard layer, plus the tail-product lemmas.)
4. **Summability**: from the Jensen bound one gets
   `Σ_{‖aₙ‖ ≤ R} 1/‖aₙ‖^{1+ε} = O(1)` (summation by parts over the counting
   function `N(R) = O(R)`), giving `Summable (fun n => ‖a n‖^{-(p+1)})` for
   `p ≥ 1`. **DONE** (rounds 483–484, 486): the counting bound
   `xi₀_zero_count_bound` (`N(r) ≤ (2Ar+B)/log 2`) plus the shell
   decomposition give `xi₀_zeros_inv_sq_summable`:
   `Σ_{ξ₀(z)=0} (1+‖z‖)^{-2} < ∞` (subtype form), and round 486 adds the
   transfer to any injective enumeration
   (`summable_inv_sq_of_injective_enumeration`), which is precisely the
   enumerated `hsum` hypothesis of `factorization_of_xi₀`.
5. ~~**Log-growth of `ξ₀ / P`**~~ — **automatic** (round 495):
   `hasLogGrowthOne_quotient_of_factorization` shows that once
   `ξ₀ = P·e^{a+bz}`, the quotient is `e^{a+bz}` and has order-1 log-growth.
   So this is *not* an independent analytic input: the only remaining
   non-automatic input is the **enumeration with the divisor match**, which
   reduces to the finite-split/multiplicity theorems (rounds 493–494).

Steps 1–5 are a self-contained complex-analysis project. The factorisation
*theorem* and the *partial fraction* are already Lean-checked; what remains is
supplying this zero data.

## What this does and does not give

Supplying the zero data yields the **Hadamard partial fraction** of `Z'/Z`
unconditionally, hence the zero-side explicit formula with the canonical
product. It does **not** prove the Riemann hypothesis: the zero data is a
theorem about the zeros (Riemann–von Mangoldt-type counting), not a statement
about their location. The location statement is Weil positivity's converse,
which remains RH-equivalent and open.

**No RH proof yet.**
