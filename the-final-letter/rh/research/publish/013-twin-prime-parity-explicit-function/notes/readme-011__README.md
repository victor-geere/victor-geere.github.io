# 011 — Can Routes A, B, C be generalised?

An audit-and-answer round. The question is
[`010/routes-abc-primer.html`](../../../twin-prime-parity/010/routes-abc-primer.html) §6's natural follow-up: the three
certification routes were built for `ζ`; how far do they extend?

**Answer, in four parts.**

| reading | verdict |
|---|---|
| **L1** generalise the *statements* | **already general** — `exists_unique_root_of_sign_change` is `∀ f : ℝ → ℝ`; `turing_reduction` is `∀ Finset α`; `routeB_reduction_general` is `∀ f : ℂ → ℂ` with only a functional equation, conjugation reality, analyticity and zero data; `validated_truncation_bound` is any decomposition |
| **L2** generalise the *instantiation* | **analytic part complete for Dirichlet `L`** — this round proves the normalisation `h(s) = N^{s/2}Λ(s)` with `h(1−s) = ε·h(s)` (any `ε ≠ 0`), shows Route B needs only the `logDeriv` reflection rather than bare self-duality (so the root number is **not** an obstruction), and **closes both Mathlib gaps**: conjugation reality `Λ_χ(conj s) = conj(Λ_χ s)` is now proved for *every* character with real values (all cases, `completedRiemannZeta_conj` as a corollary), and the root number `ε = rootNumber χ` is proved to be `±1` for every nontrivial quadratic primitive character.  Two independent proofs of the sign are provided (functional equation, and the composite-modulus Gauss-sum square `gaussSum_sq_of_isPrimitive`).  The remaining *analytic* hypotheses are discharged too (`DirichletAnalytic.lean`): `h = N^{s/2}Λ_χ` is entire and `logDeriv h` is interval integrable on each horizontal edge, so `routeB_for_dirichletL_of_zeros` leaves only the *numerical* zero data `Z`, `m`, `hno`; and the **missing numerical interval engine** for `Λ'_χ/Λ_χ` is now built ([`rigorous/dirichlet_interval.py`](../../../twin-prime-parity/011/rigorous/dirichlet_interval.py), verified by [`verify/check_dirichlet_engine.py`](../../../twin-prime-parity/011/verify/check_dirichlet_engine.py)) |
| **L3** generalise the *method* | **transferable** — enclosure ⇒ sign ⇒ root; the cardinality squeeze; pointwise ⇒ locally uniform ⇒ Weierstrass differentiation |
| **L4** generalise to *all* zeros | **impossible** — the hypotheses are finitely many enclosures; the all-zeros statement is RH (resp. GRH) and is not reached |

**Read in this order.** [`index.html`](index.html) → [`notes/generalisation-analysis.md`](generalisation-analysis.md)
→ [`notes/generality-lean.md`](generality-lean.md) → [`lean/README.md`](lean/README.md).

## What is new here

* `notes/generalisation-analysis.md` — the prose audit: the core/instantiation split (with a figure),
  the four-rung ladder, the Dirichlet `L` reduction, the target catalogue, and the four hard limits.
* `lean/Generic.lean` — the machine-checked part:
  * `SelfDualReal` / `SelfDualRealUpToSign` and `routeB_of_selfDualReal` /
    `routeB_general_of_logDeriv`, showing the 010 theorem is already general and that only the
    `logDeriv` reflection is consumed (so `ε = rootNumber χ` need not be `±1`);
  * `logDeriv_one_sub_of_const_mul`, the reflection `logDeriv F(1−s) = −logDeriv F(s)` from
    `F(1−s) = ε·F(s)`, any `ε ≠ 0`;
  * an `n`-tail generalisation of Route C's triangle inequality (the 010 three-tail statement is its
    instance);
  * `dirichletL_normalised_one_sub`, the Dirichlet `L` functional equation in Route B's normalisation;
  * `routeB_for_dirichletL`, the Dirichlet instantiation with its remaining hypotheses explicit.
* `lean/DirichletConj.lean` — **the first closed gap** (Mathlib-only, PR-shaped):
  `DirichletCharacter.completedLFunction_conj`
  (`Λ_χ(conj s) = conj(Λ_χ s)` for every real character, all cases, no primitivity or parity needed),
  plus the helpers `LSeries_conj` (unconditional), `Complex.Gammaℝ_conj`,
  `Complex.conj_cpow_ofReal`, `LFunction_conj_of_one_lt_re`, `gammaFactor_conj`,
  `completedLFunction₀_conj`, and the corollary `completedRiemannZeta_conj`.
* `lean/RootNumber.lean` — **the second closed gap** (Mathlib-only): `RootNumberSign χ` is now a
  theorem for every nontrivial quadratic primitive character,
  `rootNumber χ = 1 ∨ rootNumber χ = -1` (`rootNumber_eq_one_or_neg_one`,
  `rootNumberSign_of_isQuadratic`), together with the `hreal` ⇄ `IsQuadratic` bridge
  (`isQuadratic_of_conj_eq_self`, `conj_eq_self_of_isQuadratic`) and
  `rootNumber_sq_eq_one_of_inv_eq_self`.  The proof applies the functional equation twice (no
  Gauss-sum squaring, no prime-modulus restriction).  The `IsPrimitive` hypothesis is necessary:
  `rootNumber` is junk for imprimitive characters.
* `lean/GaussSumComposite.lean` — the **missing Mathlib lemma** that makes the `gaussSum_sq` route
  work at composite moduli: `gaussSum_sq_of_isPrimitive` proves
  `gaussSum χ stdAddChar ^ 2 = χ(-1) · N` for a primitive quadratic `χ` of arbitrary modulus
  (Mathlib's `gaussSum_sq` is field-only and does not apply to `ZMod N` for composite `N`), with
  the product form `gaussSum_mul_gaussSum_inv_eq_card`, the new `IsPrimitive.inv`, comparison
  examples with Mathlib's `gaussSum_sq` at `N = 3, 5, 7`, and the **second, independent**
  root-number proof `rootNumber_eq_one_or_neg_one'` via this route (`RootNumber.lean` untouched).
  The proof uses the discrete Fourier transform on `ZMod N` (`dft_dft`, Fourier inversion) and
  `gaussSum_mulShift_of_isPrimitive`; it never divides in `ZMod N`.
* `lean/DirichletRouteB.lean` — `routeB_for_dirichletL_of_real`: Route B for Dirichlet `L` with the
  conjugation `Prop` **discharged** from the reality of the character; and
  `routeB_for_dirichletL_unconditional`, in which **both** named gaps are discharged (the root
  number sign from `IsQuadratic`, conjugation from reality).
* `lean/DirichletAnalytic.lean` — the **analytic hypotheses discharged**: `dirichletCompleted χ` is
  entire for every `χ ≠ 1` (`analyticAt_dirichletCompleted`, box form
  `analyticAt_dirichletCompleted_of_mem`, `differentiable_dirichletCompleted`), and its
  log-derivative is continuous — hence interval integrable — on each horizontal edge away from the
  zeros (`continuousOn_logDeriv_dirichletCompleted`,
  `intervalIntegrable_logDeriv_dirichletCompleted`).  The corollary
  `routeB_for_dirichletL_of_zeros` therefore needs **no analytic hypothesis at all**: `han`,
  `hint₀`, `hint₁` are supplied, and the edge non-vanishing hypotheses are derived from the zero
  data `hmem`/`hno` (every `z ∈ Z` has `t0 < z.im < t1`, so no edge point is in `Z`).  Only the
  numerical zero set `Z`, its orders `m` and zero-freeness `hno` remain.
* `rigorous/zeta_routeB.py` — the **curvature-free re-run of the `ζ` Route-B counts**.  The
  `010` counts use a midpoint rule whose curvature bound `Lf` comes from a box enclosure; with
  the fixed primitives (see `010/rigorous/EXP_NUM_ERRATUM.md`) the `T = 33`, `steps/unit = 40`
  re-run gives `N ∈ [3.304, 6.696]` and is **undecided** (the archived `N(33)=5` does not
  survive), while `T = 15` gives `N ∈ [0.569, 1.433]` (`N = 1`).  This module removes the
  curvature bound: `Im(I₃) = Δ arg ξ`, so tracking `arg ξ` from a rigorous enclosure of
  `ξ(s) = ½s(s−1)π^{−s/2}Γ(s/2)ζ(s)` gives `N(15) ∈ [0.999999909, 1.000000091]` and
  `N(33) ∈ [4.999999675, 5.000000325]` in minutes, with no `1/8`-vs-`1/4` constant.  Logs:
  `verify/zeta_routeB_arg_T15.log`, `..._T33.log`; verified by `verify/check_zeta_routeB.py`.
* `verify/check_zeta_routeB.py` — independent verification of the above (`ξ` containment vs
  mpmath; the counts against direct complex quadrature and the known `N = 1, 5`).
* `rigorous/dirichlet_interval.py` — the **Dirichlet interval engine** (the last numerical
  piece of the L2 reduction).  On top of `../010/rigorous/` it encloses, rigorously and on
  boxes, `zeta(s,a)` (Euler–Maclaurin + periodic-Bernoulli remainder), `L(chi,s)`,
  `L'/L`, `(L'/L)'` and finally `Lambda'_chi/Lambda_chi` and `(log Lambda_chi)''` for
  `Lambda_chi(s) = (N/pi)^((s+a)/2) Gamma((s+a)/2) L(chi,s)`.  No mpmath in the rigorous
  path.  It also provides rigorous replacements for three 010 primitives that are unsound or
  too coarse here (`ndef` division, `exp_num`, `log_hi` at large primes) — see
  [`rigorous/README.md`](../../../twin-prime-parity/011/rigorous/README.md) for the API, the remainder bound and the
  measured widths/timings.
* `rigorous/dirichlet_routeB.py` — **the numerical zero data of Route B for a Dirichlet `L`**.
  It encloses the completed `H(s) = (N/pi)^((s+a)/2)Gamma((s+a)/2)L(chi,s)` at arbitrary `s`
  (with a rigorous `log Gamma` built from the shifted Stirling series and an Euler–Maclaurin
  remainder), computes the Turing count `N_chi(T) = Im(I3)/pi` by **rigorous argument
  tracking** along the `I3` path (no curvature bound — the count is the continuous change of
  `arg H`, so the loose box enclosure of `L` never enters), and locates the on-line zeros by
  certified sign changes of the real function `Xi`.  When `#(sign changes) = N_chi(T)`, the
  total multiplicity is exhausted and every zero in the window is simple and on the line.
* `rigorous/certify_dirichlet_routeB.py` — the driver; for **chi_3, T = 10** it certifies
  `N_chi3(10) in [0.9999999979, 1.000000002]`, finds the single on-line zero at
  `Im s = 8.039737156...` (bracket width `1.1e-10`), and concludes that *every zero of
  `L(chi_3, .)` with `1/2 < Im s < 10` is simple and on the critical line*.  The machine-readable
  zero data `(Z, m, hno)` is written to `rigorous/certify_dirichlet_routeB_chi_3_T10.json`.
* `lean/CertifiedWindow.lean` — the Route-B zero-data obligation as **one named structure**.
  `CertifiedWindow χ t0 t1` bundles `Z`, `m`, `hmem`, `hm`, `hno`; `CertifiedWindow.routeB`
  consumes it (all analytic hypotheses discharged by `DirichletAnalytic.lean`), and
  `routeB_for_chi3_of_window` fixes the concrete window `(1/2, 10)` for `chi3`.  The file header
  states plainly what is **not** formalised: producing a `CertifiedWindow` is the numerical
  certificate (`rigorous/certify_dirichlet_routeB.py`), and formalising it would require a
  verified numerical evaluator for `dirichletCompleted chi3` plus a formalised argument-principle
  count — neither exists in Mathlib.  So the computational certificate is the substantive input,
  and this is its precise interface.
* `rigorous/dirichlet_explicit.py` — **Route C for a Dirichlet `L`**: the validated
  explicit-formula assembly.  For a real primitive `χ` mod `q` of parity `a`,
  `2∑_{γ>0}h(γ) = (1/2π)∫ h(t)Ψ_χ(t)dt − ∑_{n≥2}(Λ(n)χ(n)/√n)(g(log n)+g(−log n))`,
  with `Ψ_χ(t)=log(q/π)+Re ψ((1/2+a+it)/2)` and **no pole term** (`L(χ,·)` is entire for
  non-trivial `χ`).  The prime-side weight is the *pointwise* product `Λ(n)χ(n)` — the Euler
  product coefficient of `−L'/L` — **not** the convolution `(χ∗Λ)(n)`; both the identity and
  this distinction were verified for `χ_3` (odd) and `χ_5` (even) at several modulations to
  ~`1e-11`.  The script encloses the zero side (certified brackets + density tail), the prime
  side (sieve + Chebyshev tail) and the archimedean side (Simpson + fourth-derivative bound),
  and checks `|residual| ≤ budget`.
* `lean/DirichletExplicit.lean` — the algebraic skeleton of the above: the
  Dirichlet–von Mangoldt weight `dirichletWeight χ n = Λ(n)χ(n)` with its prime-power values
  `dirichletWeight_pow_prime` (the Euler-product coefficient), the prime side and its
  split/evenness lemmas, the archimedean kernel `dirichletPsi q a t = log(q/π)+Re ψ((1+a)/4+it/2)`
  (reducing to `Rh45.PsiBar` at `q=1,a=0`), and `DirichletExplicitData` with the validated
  truncation inequality `|lhs−computed| ≤ |zeroTail|+|primeTail|+|archTail|`.  Builds green,
  no `sorry`/axiom; the analytic identity itself is the numerical certificate, not formalised.
* `verify/check_dirichlet_routeB.py` — independent verification of the above: containment of
  `Gamma`, `H` and `Xi` against mpmath for `chi_3, chi_4, chi_5, chi_8`, the rigorous count
  against direct complex quadrature, and that each certified bracket really contains a zero.
* `lean/DirichletL.lean` — the **concrete real primitive character** `chi3` mod 3 (the Legendre
  symbol `(·/3)` cast to `ℂ`), with `chi3_isQuadratic`, `chi3_ne_one` and `chi3_isPrimitive`
  proved from Mathlib, and `routeB_for_chi3_of_zeros` — Route B for its completed `L`-function
  conditional only on the numerical zero data produced above.  Requires
  `Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic` and
  `Mathlib.NumberTheory.LSeries.DirichletContinuation`; builds green, no `sorry`/axiom.
* `notes/midpoint-constant.md` — an addendum to `010/rigorous/EXP_NUM_ERRATUM.md`: the
  Route-B midpoint budget uses `(1/8)|ds|^2 sup|f'|` where the elementary sharp constant is
  `1/4`; the engine's `Lf` overestimates `sup|f'|` by many orders of magnitude, so the
  archived numbers are not threatened, but the `1/8` is not a proved bound.  The Dirichlet
  count avoids the issue entirely (argument tracking).
* `verify/check_dirichlet_engine.py` — the engine's verifier: containment against mpmath
  for `zeta(s,a)`, `zeta'`, `zeta''`, `L`, `L'/L`, `(L'/L)'`, `Lambda'/Lambda` and
  `(log Lambda)''` over `chi_3, chi_4, chi_5, chi_8` at `Re s in {1/2, 3/4, 1}` and
  `t in {0.5, 1, 5, 14.1347, 20, 33, 50}`, plus box-correctness on positive-area boxes, the
  EM remainder-domination test, pole handling, widths and timings.  Run:
  `python3 verify/check_dirichlet_engine.py` — `RESULT: PASS`, exit 0.
* `verify/check_dirichlet_conj.py` — numerical cross-check of the conjugation identity for six real
  quadratic characters (mod 3, 4, 5, 7, 8, 13) at six complex points, in both normalisations, plus the
  root number as a unit, both functional-equation conventions, and the zeta case — `ALL CHECKS PASSED`.
* `verify/check_gausssum_sq.py` — numerical cross-check of `gaussSum_sq_of_isPrimitive`: for every
  primitive quadratic character at `N = 8, 12, 20, 24` it verifies `τ² = χ(−1)·N`, and it confirms
  the failure at `N = 6` for the imprimitive lift of `χ_3` (`τ² = −3 ≠ χ(−1)·N = −6`), showing
  `IsPrimitive` is necessary.  Run: `python3 verify/check_gausssum_sq.py` — `PASS (all checks passed)`,
  exit 0.
* `verify/check_claims.py` — independent checks: the conductor exponent identity
  `(1−s)/2 + (s−½) = s/2` (sympy), the `ε`-cancellation in the `logDeriv` reflection, that no
  constant rescaling can restore bare self-duality when `ε ≠ 1`, the mod-1 completed-zeta symmetry
  (mpmath, `|diff| ≈ 2·10⁻³²`), and that every local link/figure of `index.html` resolves.
  Run: `python3 verify/check_claims.py` — `ALL CHECKS PASSED`, exit 0.
* `figures/` — generated by [`../../lib/generality_figs.py`](../../../../lib/generality_figs.py).

## Honest scope

The certified windows are now `T = 3, 15, 33` for `ζ` (see [`../010/`](../010/) and
[`../010/rigorous/`](../010/rigorous/)) **and**, new here, `(1/2, 10)` for the Dirichlet
`L`-function of `chi_3` (`rigorous/certify_dirichlet_routeB.py`): the count
`N_chi3(10) in [0.9999999979, 1.000000002]` equals the number of certified on-line simple
zeros, so every zero of `L(chi_3, .)` with `1/2 < Im s < 10` is simple and on the critical
line.  Everything else in `011/` is either a general theorem, a conditional reduction, or
explicit analytic data.  The two `Prop`s named in `Generic.lean`
(`RootNumberSign`, `CompletedLFunctionConj`) are both now theorems; Route B for Dirichlet `L`
is conditional only on the **numerical zero data** `Z`, `m`, `hno` — the analytic hypotheses
`han`, `hint₀`, `hint₁` are theorems (`DirichletAnalytic.lean`,
`routeB_for_dirichletL_of_zeros`), the edge non-vanishing is derived from `hmem`/`hno`, and
`lean/DirichletL.lean` fixes a concrete real primitive character `chi3` for which every
character-theoretic hypothesis is discharged.

The scope caveats that remain are honest ones: the `chi_3` window is certified only up to
`T = 10`; the *Lean* Route-B statement still takes `Z`, `m`, `hno` as hypotheses (the numerical
certificate is not formalised); the **Route C** explicit formula is validated numerically for
`chi_3` (residual `−4.3e-10` ≤ budget `2.0e-7`) and `chi_5`, but its Lean layer is algebraic
only — the identity and the three tail bounds are the numerical certificate; and the addendum
[`notes/midpoint-constant.md`](midpoint-constant.md) records that the `010` Route-B
midpoint budget uses an unproved `1/8` constant (sharp value `1/4`), absorbed in practice by the
engine's very conservative `Lf` but not by any proof.

**Build:** `cd lean && ./check.sh --all` — green, `0 sorry`, `0 axiom`.
