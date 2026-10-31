# An intersection form for ζ — the function-field template and the arithmetic obstruction

**Status:** exploratory. **No intersection form for `ζ` is constructed.** The
finite Hodge-index core is Lean-proved (T1–T100, no `sorry`, `axiom` or
`admit`); the function-field template and the Arakelov segment are recorded as
source claims S1–S19; the certified `4 × 4` shadow is recorded with an enclosed
`Ω` integral (C11–C24) and a Rust-generated rational certificate whose box
theorems are kernel-checked (T91–T100, C25–C39); the obstruction is this
dossier's interpretation. The Python suite has 60 passing tests covering
C1–C49.

**Objective:** the brief allowed a Lee–Yang measure or an intersection form for
`ζ`. This folder takes the intersection-form arm and asks the prior question:
*what exactly would an intersection form have to be, and which part of it can
be built now?*

The answer is a sharp split. The positivity can be built: the finite
Hodge-index inequality is a theorem, and its arithmetic analogue is also a
theorem in the literature (S3: Faltings–Hriljac plus Northcott). The object it should act on cannot:
there is no Frobenius correspondence over `Q`. So the intersection-form route
converts the arithmetic-positivity wall into a **correspondence wall**.

[`notes/05-frobenius-alternative.md`](notes/05-frobenius-alternative.md)
proposes a replacement and is careful about what it buys. A single algebraic
Frobenius over `Q` is impossible (a fixed correspondence has a fixed trace,
while Frobenius traces vary; a finite determinant has only `O(T)` zeros up to
height `T`, while `ξ` has `T log T`). Two replacements survive: the **Hecke
correspondence**, which is algebraic over `Q` and carries Frobenius through
Eichler–Shimura, but degenerates to the identity for `ζ`; and the **scaling
correspondence** on the adele class space, which is a measured relation whose
trace formula is the explicit formula and whose absorption spectrum is the
zeros. The second reaches `ζ`, but its polarization is exactly the Weil
positivity. The wall therefore moves from a missing *object* to a missing
*positivity*.

## What this dossier is

The function-field proof of RH for a curve `C/F_q` has three ingredients: the
surface `C × C`, the graph of Frobenius, and the Hodge index theorem. The last
is a positivity. For `ζ`, an arithmetic surface whose zeta involves `ζ` exists
(`P¹_Z`, whose zeta is `ζ(s)ζ(s-1)`) and the arithmetic analogue of the Hodge
index exists (the Néron–Tate height is positive definite). What has no
number-field analogue is the Frobenius correspondence.

This folder therefore does four things:

1. **Builds and proves the finite core.** The rank-three intersection form on
   `E × E`, the ample class, the Hodge index inequality and its exact
   sum-of-squares defect are formalised in [`lean/Topic.lean`](lean/Topic.lean).
2. **Records the template.** [`notes/01-function-field-template.md`](notes/01-function-field-template.md)
   states Weil's theorem, the intersection numbers, and what the proof
   structure would demand of a `ζ` analogue.
3. **Records the obstruction.** [`notes/02-arithmetic-obstruction.md`](notes/02-arithmetic-obstruction.md)
   sets out the arithmetic intersection form (Arakelov; Faltings–Hriljac) and
   the missing correspondence.
4. **Proposes an alternative.** [`notes/05-frobenius-alternative.md`](notes/05-frobenius-alternative.md)
   replaces the missing algebraic Frobenius by a Hecke shadow and a scaling
   correspondence, and isolates the residual polarization.

A third note, [`notes/03-lee-yang-closure.md`](notes/03-lee-yang-closure.md),
records why the Lee–Yang arm was not taken: the programme's polygon has
certified zeros with disjoint real parts, so it is not confined to any single
vertical line.

A fourth note, [`notes/04-certified-shadow.md`](notes/04-certified-shadow.md),
wires the `4 × 4` Gaussian Weil Gram matrix of
`prime-spectrum-tensor` into this dossier and certifies it with an enclosed
`Ω` integral (C11–C24). It is the finite intersection form on a
four-dimensional test subspace: a rung, not a bridge.

A fifth note, [`notes/05-frobenius-alternative.md`](notes/05-frobenius-alternative.md),
develops the alternative to the Frobenius correspondence, proves the
elementary no-go for a single algebraic Frobenius, and records the Hecke
shadow and the scaling correspondence with their finite demonstrations
(C40–C42).

A sixth note, [`notes/06-angular-bochner-attack.md`](notes/06-angular-bochner-attack.md),
tests the alternative against the angular Bochner framework of the
accompanying PDF. The framework supplies the finite-level polarization
(S10–S11) but its uniform undamped limit is exactly the missing Weil
positivity (S12); the note proves the no-closure corollary and records the
finite sector model (C43–C45).

A seventh note, [`notes/07-riemann-roch-square.md`](notes/07-riemann-roch-square.md),
follows the 2018 Riemann–Roch strategy. It proves the local HRR on the
periodic-orbit tori and reduces the whole alternative to a longitudinal HRR
on the square of the complex lift (S15–S18, C46–C48). The three technical
obstructions — Todd class, logarithmic divergence, Witt lift — are stated
exactly.

An eighth note, [`notes/08-three-attacks-and-the-wall.md`](notes/08-three-attacks-and-the-wall.md),
consolidates the three parallel attacks: the Riemann–Roch square, the
arithmetic Hodge index, and the Sonin/prolate gap. Each reduces to the same
absolute/off-diagonal positivity, and each is equivalent to Weil positivity.
The note proves the reduction: the known legs do not force the fourth, and a
proof of the fourth would be a proof of RH. It is an open construction
problem, not a no-go (S17–S19, C49).

This is an instrument-shaped result, not a bridge. It does not prove RH, and it
does not claim that no intersection-form proof can exist. It identifies the
precise missing object on this route.

## The finite model: what is proved

Work on the rank-three lattice spanned by `H = {pt} × E`, `V = E × {pt}` and
the diagonal `Δ` of `E × E`, with intersection numbers

\[
H^2=V^2=\Delta^2=0,\qquad H\cdot V=H\cdot\Delta=V\cdot\Delta=1 .
\]

The pairing `B` has Gram matrix

\[
\begin{pmatrix}
0&1&1\\
1&0&1\\
1&1&0
\end{pmatrix},
\]

and the ample class `A = H + V + Δ` satisfies `A² = 6`. The Hodge index
inequality in this model is

\[
6\,D^2 \le (A\cdot D)^2,
\]

with defect `2((a-b)² + (b-c)² + (c-a)²)` and equality only when `D` is a
multiple of `A`. On `A^⊥` the form is negative definite. The Lean core proves
every step (T1–T11).

The model is indefinite, not positive definite: `H + V` has square `2` and
`H - V` has square `-2`. That is the point. The positivity lives on the
quotient by the ample direction, exactly as in the Hodge index theorem.

## The certified finite shadow

The function-field template is the model; the number-field candidate is the
Weil form `W`. On the four Gaussians

\[
\phi_a(u)=\exp\!\left(-\frac{(u-a)^2}{2\sigma^2}\right),
\qquad \sigma=0.05,\quad a\in\{-0.3,-0.1,0.1,0.3\},
\]

the Gram matrix `G_ab = (W(h_ab) + W(h_ba))/2` is a `4 × 4` matrix whose
entries are a closed-form pole, a density integral against
`Ω(t) = Re ψ(1/4+it/2) - log π`, and a finite prime sum.

`python/certify_shadow.py` wires the certified `Ω`/density layer of
`prime-spectrum-tensor` into this dossier and records
[`python/weil_certificate.json`](python/weil_certificate.json). The certificate:

1. encloses the density integral on Taylor panels using an interval `Ω` jet;
2. adds the pole and the finite prime sum, and a `10⁻⁴` margin for the
   provisional jet remainder;
3. records the `4 × 4` interval Gram matrix;
4. proves every symmetric matrix in the interval box positive definite by an
   exact centre/error check: `t` is the maximum row sum of half-widths, and
   the rational matrix `G₀ − tI` has positive leading minors and an exact
   `L d Lᵀ` factorisation with `d > 0` and `L` unit lower triangular.

The recorded `L` and `d` are in the JSON, and the same rationals are
embedded in [`lean/Topic.lean`](lean/Topic.lean). The verifier checks
`L diag(d) Lᵀ = G₀ − tI` exactly; Lean T15 turns the factorisation into
positive definiteness; T16 checks the embedded identity and T17 closes the
concrete instance. No `native_decide` is used, so the concrete theorems
depend only on the standard axioms.

The interval step is also Lean. T18 is the row-sum bound
`|xᵀDx| ≤ t‖x‖²` for a symmetric `D` with `Σ_j |D_ij| ≤ t`; T19 proves the
box inequality `xᵀPx ≤ xᵀAx`, i.e. `A ⪰ G₀ − tI`, for any Hermitian `A` in
the box; T20 adds `P` positive definite to conclude `A` positive definite.
The Python certificate checks the hypotheses on the recorded box (C24); the
analytic content is the enclosure that the true matrix satisfies them.
The recorded numerical instance is embedded too: T21–T24 prove symmetry,
containment, the row-sum bound and positive definiteness for `shadowA`.

**Rational alternative.** The project's [`L4Shadow`](../prime-spectrum-tensor/lean/Topic.lean)
(T12 of `prime-spectrum-tensor`) is a rational PSD shadow of `G`, but its `4·10⁻¹³`
proximity is numerical, not a rigorous bound, and a PSD matrix has no positive
margin to absorb a perturbation. The rational object used here is the box
`(P, E, t)`: `P` is rational and positive definite, and T19 proves
`G ⪰ P` from rational entrywise bounds. The transcendental matrix is absent
from the Lean statement; only the enclosure `G ∈ G₀ ± E` remains
computational.

### The enclosure layer

That enclosure is now the only formal obligation. It decomposes into:

1. sharp rational bounds for `γ` (Mathlib has only `1/2 < γ < 2/3`), `π` and
   `log 2`;
2. a pointwise enclosure of `Ω(t)` — **base point done** (T34–T37):
   `ψ(1/4)` (T25), rational `π` and `log π` bounds, and
   `Ω(0) ∈ [-5.3721937737…, -5.3721813358…]`, width `1.24·10⁻⁵`; the
   extension to the panels remains;
3. an interval quadrature of the density integral with explicit panel
   remainders;
4. a finite enclosure of the prime sum (2328 prime powers);
5. the rational assembly into the box.

The project has the analytic skeleton — `PsiBar`, `archimedean_deriv_bound`,
`simpsonSum_sub_integral_le` in the `Rh45` bundle, and `π`/`log`/`exp`
enclosures in `partial-sum-plus-tail` — but not the assembled layer. It is a
multi-thousand-line formalisation, not a rational check.

The fourth minor of the Python certificate is `≈ 10⁻⁸`, so this is a
near-boundary certificate, not a vacuous one. The recorded interval matrix and
the `Ω` samples are in the JSON; the verification is in
[`tests/test_weil_shadow.py`](tests/test_weil_shadow.py).
Details: [`notes/04-certified-shadow.md`](notes/04-certified-shadow.md).

The Rust assembly (`rust/weil-assembly`, C25–C39) re-derives the same box with
exact rational intervals: the density half-width is `2.1·10⁻⁵`, the pole and
prime intervals have width `10⁻¹⁵`, and the fourth leading minor of
`G₀ − tI` is `≈ 2.0·10⁻⁶`.  Its generated `lean/Certificate.lean` embeds the
matrices and kernel-checks `certP_posDef` (via an exact rational `LDLᵀ`) and
`certA_posDef` (via `posDef_of_box_rat`).

What it proves is finite: the four-dimensional Gram matrix is positive
definite. What it does not prove is the infinite Weil cone — a finite subspace
can be positive while an off-line zero drives a different test function
negative. The `Ω` enclosure is `mpmath.iv` plus explicit panel bounds, not a
Lean proof; the finite algebra a rational shadow would use is T12–T19.

## The function-field template

For `C/F_q` of genus `g`, with `P_1(T) = Π(1 - α_i T)`,

\[
Z(C,T)=\frac{P_1(T)}{(1-T)(1-qT)},
\qquad
\text{RH: } |\alpha_i|=\sqrt q .
\]

The standard Castelnuovo–Weil argument uses the intersection numbers of the
Frobenius graph, `Γ·H = 1`, `Γ·V = q`, `Γ·Δ = q+1-a`, together with the Hodge
index and the functional equation pairing `α` with `q/α`. For an elliptic
curve the same positivity appears as the positive-definite Rosati involution
and `ππ̄ = q`. The full statement and references are in
[`notes/01-function-field-template.md`](notes/01-function-field-template.md).

## The arithmetic obstruction

Arakelov intersection theory gives a real-valued intersection pairing on an
arithmetic surface. Faltings–Hriljac identifies it with the negative
Néron–Tate height on degree-zero divisors, and the height pairing is positive
definite. **The positivity is therefore available.**

What is not available is a correspondence. Over `F_q`, Frobenius is one
morphism whose trace is the zeta function. Over `Q`, Frobenius at `p` is a
conjugacy class, the Euler product is a product of local factors, and the
functional equation is a symmetry rather than a correspondence. The
archimedean place contributes a Green's function, not a finite matrix.

The refined statement, argued in
[`notes/02-arithmetic-obstruction.md`](notes/02-arithmetic-obstruction.md):

> an intersection form without a correspondence cannot see the zeros.

This refines W1 ([`../../categories/10-walls/walls.md`](../../categories/10-walls/walls.md)): the missing input is still an
arithmetic positivity/multiplicativity input, but on this route the missing
conjunct is the arithmetic object, not the positivity.

## Why not the Lee–Yang arm

The alternative was a positive measure whose Stieltjes transform is `ξ'/ξ`.
That construction is circular: the measure is defined from the zeros, so its
positivity is RH. Independently, the programme's finite polygon has certified
zeros with real parts around `0.57802` and `0.80014`, in disjoint intervals, so
F.4's single-line confinement is impossible for that object (`C46`/`C47` of the
polygon dossier, `B26`/`B28`). The survey [`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md)
§6 records the closure. Details: [`notes/03-lee-yang-closure.md`](notes/03-lee-yang-closure.md).

## Reconstructed objects and notation

| Object | Definition | Status in this folder |
|---|---|---|
| Intersection form `B` | Gram matrix `[[0,1,1],[1,0,1],[1,1,0]]` on `⟨H,V,Δ⟩` | Lean `IntersectionForm.B`; Python `programme.dot` |
| Self-intersection `D²` | `2(ab + ac + bc)` | Lean `B_self`; Python `self_sq` |
| Ample class `A` | `H + V + Δ`, `A² = 6` | Lean `A_sq`; Python `ample` |
| Hodge defect | `(A·D)² - 6D² = 2Σ(a-b)²` | Lean `hodge_defect`; Python `hodge_defect` |
| Hodge index | on `A^⊥`, `D² ≤ 0`, equality iff `D = 0` | Lean `hodge_index_nonpos`, `hodge_index_eq_zero` |
| Signature | `(1, 2)` | Python `signature` (sympy, exact) |
| Frobenius trace | `a_p = p + 1 - #E(F_p)` | Python `frobenius_trace` |
| Hasse check | `a_p² ≤ 4p`, exact integers | Python `hasse_bound_ok` |
| Arakelov form | `D·D = -ĥ(D)` on degree zero | Source claim S3 |
| Function-field RH | `|α_i| = √q` | Source claim S1 |
| Gaussian basis | `φ_a(u) = exp(−(u−a)²/(2σ²))`, `σ = 0.05` | Python `weil_shadow.gaussian_convolution` |
| `Ω` enclosure | interval containing `Re ψ(1/4+it/2) − log π` | Python `weil_shadow.omega_enclosure` |
| Finite shadow | `4 × 4` interval Weil Gram matrix | `python/weil_certificate.json`; Python `certificate_ok` |

## Theorem and computation ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean).
Every row marked **Computation** is tested in
[`tests/test_programme.py`](tests/test_programme.py). Nothing in this table
asserts RH or constructs an intersection form for `ζ`.

| # | Kind | Statement | Lean / test name |
|---|---|---|---|
| T1 | Theorem | The pairing is symmetric. | `IntersectionForm.B_comm` |
| T2 | Theorem | `D² = 2(ab + ac + bc)` for `D = aH + bV + cΔ`. | `IntersectionForm.B_self` |
| T3 | Theorem | The ample class has square `6`. | `IntersectionForm.A_sq` |
| T4 | Theorem | `A · D = 2(a+b+c)`. | `IntersectionForm.A_dot` |
| T5 | Theorem | Hodge index inequality: `6D² ≤ (A·D)²`. | `IntersectionForm.hodge_inequality` |
| T6 | Theorem | The defect is exactly `2((a-b)² + (b-c)² + (c-a)²)`. | `IntersectionForm.hodge_defect` |
| T7 | Theorem | On `A^⊥`, `D² = -(a² + b² + c²)`. | `IntersectionForm.hodge_index` |
| T8 | Theorem | On `A^⊥`, `D² ≤ 0`. | `IntersectionForm.hodge_index_nonpos` |
| T9 | Theorem | On `A^⊥`, `D² = 0` iff `D = 0`. | `IntersectionForm.hodge_index_eq_zero` |
| T10 | Theorem | The form is indefinite: positive on `H+V`, negative on `H-V`. | `IntersectionForm.indefinite` |
| T11 | Theorem | The ample class is positive. | `IntersectionForm.A_pos` |
| T12 | Theorem | A rational shadow `L * Lᴴ` is positive semidefinite. | `IntersectionForm.shadow_posSemidef` |
| T13 | Theorem | The quadratic form of the shadow is non-negative on every vector. | `IntersectionForm.shadow_quadratic_nonneg` |
| T14 | Theorem | An exact LDL factorisation with invertible `L` and positive diagonal `d` gives a positive definite `L d Lᴴ` over `ℝ`. | `IntersectionForm.ldl_posDef` |
| T15 | Theorem | The same implication over `ℚ`. | `IntersectionForm.ldl_posDef_rat` |
| T16 | Theorem | The embedded concrete factorisation `L d Lᵀ = P` holds exactly over `ℚ`. | `IntersectionForm.shadow_factor` |
| T17 | Theorem | The embedded concrete matrix `P` is positive definite, with all hypotheses discharged. | `IntersectionForm.shadowP_posDef` |
| T18 | Theorem | Row-sum bound: if `D` is symmetric and `Σ_j |D_ij| ≤ t`, then `|xᵀDx| ≤ t‖x‖²`. | `IntersectionForm.abs_quad_le_row_sum` |
| T19 | Theorem | Box inequality: if `A` is Hermitian and `|A_ij − (P+tI)_ij| ≤ E_ij` with row sums of `E` at most `t`, then `xᵀPx ≤ xᵀAx` — that is, `A ⪰ G₀ − tI`. | `IntersectionForm.box_ge` |
| T20 | Theorem | With `P` positive definite in addition, `A` is positive definite. | `IntersectionForm.posDef_of_box` |
| T21 | Theorem | The recorded numerical matrix `shadowA` is Hermitian. | `IntersectionForm.shadowA_herm` |
| T22 | Theorem | Every entry of `shadowA` lies in the recorded box `(P + tI) ± E`. | `IntersectionForm.shadowA_mem_box` |
| T23 | Theorem | The row sums of the half-width matrix `E` are at most `t`. | `IntersectionForm.shadowE_row` |
| T24 | Theorem | The recorded numerical matrix `shadowA` is positive definite. | `IntersectionForm.shadowA_posDef` |
| T25 | Theorem | `ψ(1/4) = -γ - π/2 - 3 log 2`, the starting value for `Ω(0)`; first leaf of the enclosure layer. | `IntersectionForm.digamma_quarter` |
| T26 | Theorem | Quadratic lower log bound: `x - x²/2 ≤ log(1+x)` for `x ≥ 0`. | `IntersectionForm.log_one_add_ge` |
| T27 | Theorem | Cubic upper log bound: `log(1+x) ≤ x - x²/2 + x³/3` for `x ≥ 0`. | `IntersectionForm.log_one_add_le` |
| T28 | Theorem | The lower γ sequence `aₙ = Hₙ - log n - 1/(2n)` strictly increases for `n ≥ 3`. | `IntersectionForm.gammaLower_strictMono_step` |
| T29 | Theorem | The upper γ sequence `bₙ = Hₙ - log n - 1/(2(n+1))` strictly decreases for `n ≥ 3`. | `IntersectionForm.gammaUpper_strictAnti_step` |
| T30 | Theorem | The lower squeeze: `aₙ < γ` for every `n ≥ 3`. | `IntersectionForm.gammaLower_lt_gamma` |
| T31 | Theorem | The upper squeeze: `γ < bₙ` for every `n ≥ 3`. | `IntersectionForm.gammaUpper_gt_gamma` |
| T32 | Theorem | `log 200` is enclosed by the rational interval `log200Lo 200 ≤ log 200 ≤ log200Hi 200`. | `IntersectionForm.log200_mem` |
| T33 | Theorem | Rational `γ` interval: `0.5772135815… < γ < 0.5772260193…`, width `1.24·10⁻⁵`. | `IntersectionForm.gamma_mem` |
| T34 | Theorem | `Ω(0) = -log π - γ - π/2 - 3 log 2`. | `IntersectionForm.Omega_zero` |
| T35 | Theorem | Rational `π` bounds: `3.14159265358979323846 < π < …847`. | `IntersectionForm.pi_mem` |
| T36 | Theorem | Rational `log π` enclosure from the `π` bounds and the log series. | `IntersectionForm.log_pi_mem` |
| T37 | Theorem | `Ω(0) ∈ [-5.3721937737…, -5.3721813358…]`, width `1.24·10⁻⁵`. | `IntersectionForm.omegaZero_mem` |
| T38 | Theorem | Digamma conjugation: `ψ(conj z) = conj ψ(z)` away from the poles. | `IntersectionForm.digamma_conj` |
| T39 | Theorem | `Ω` is even: `Ω(-t) = Ω(t)`. | `IntersectionForm.Omega_even` |
| T40 | Theorem | Explicit log-derivative of the Euler product term `GammaSeq`. | `IntersectionForm.logDeriv_GammaSeq_of_ne` |
| T41 | Theorem | Gauss partial-sum limit: `ψ(s) = lim (log n - Σ_{j≤n} 1/(s+j))` for `Re s > 0`. | `IntersectionForm.tendsto_digamma_partial` |
| T42 | Theorem | Finite Euler–Maclaurin identity for `f(x) = 1/(x+w)` with `Im w ≠ 0`. | `IntersectionForm.em_digamma_finite` |
| T43 | Theorem | `∫_0^n dx/(x+w) = log(n+w) - log w` for `Re w > 0`. | `IntersectionForm.integral_inv_add` |
| T44 | Theorem | `f^{(k)}(x) = (-1)^k k! (x+w)^{-(k+1)}` for `f(x) = 1/(x+w)`. | `IntersectionForm.iteratedDeriv_inv_add` |
| T45 | Theorem | The same at the origin: `f^{(k)}(0) = (-1)^k k! w^{-(k+1)}`. | `IntersectionForm.iteratedDeriv_inv_add_zero` |
| T46 | Theorem | The endpoint derivatives vanish as `n → ∞`. | `IntersectionForm.tendsto_iteratedDeriv_inv_add_atTop` |
| T47 | Theorem | Pointwise remainder bound: `‖f^{(m)}(x)‖ ≤ m!/(x+Re w)^{m+1}`. | `IntersectionForm.norm_iteratedDeriv_inv_add_le` |
| T48 | Theorem | The p-series tail bound `Σ 1/n^p ≤ 2` for `p ≥ 2`. | `IntersectionForm.tsum_inv_pow_le_two` |
| T49 | Theorem | Concrete Bernoulli bound: `‖P₅(x)‖ ≤ 5/81`. | `IntersectionForm.norm_periodicBernoulli_five_le` |
| T50 | Theorem | `∫₀ⁿ (x+c)^{-(m+1)} dx = (1/m)(c^{-m} - (n+c)^{-m})`. | `IntersectionForm.integral_inv_pow_add` |
| T51 | Theorem | The same integral is bounded by `1/(m c^m)`. | `IntersectionForm.integral_inv_pow_add_le` |
| T52 | Theorem | `∫₀ⁿ ‖f^{(m)}(x)‖ dx ≤ m!/(m (Re w)^m)`. | `IntersectionForm.integral_norm_iteratedDeriv_le` |
| T53 | Theorem | `‖f^{(m)}‖` is integrable on `(0, ∞)`. | `IntersectionForm.integrableOn_norm_iteratedDeriv` |
| T54 | Theorem | `P₅ · f^{(5)}` is integrable on `(0, ∞)`. | `IntersectionForm.integrableOn_periodicBernoulli_five_mul` |
| T55 | Theorem | `∫_{(0,∞)} ‖f^{(m)}‖ ≤ m!/(m (Re w)^m)`. | `IntersectionForm.integral_Ioi_norm_iteratedDeriv_le` |
| T56 | Theorem | `‖∫ P₅ f^{(5)}‖ ≤ (5/81) · 5!/(5 (Re w)^5)`. | `IntersectionForm.norm_integral_periodicBernoulli_five_mul_le` |
| T57 | Theorem | **Remainder bound:** `‖R₂(w)‖ ≤ 1/(81 (Re w)^5)`. | `IntersectionForm.norm_remainder_five_le` |
| T58 | Theorem | The Euler–Maclaurin derivative sum tends to `0` at infinity. | `IntersectionForm.tendsto_em_deriv_sum` |
| T59 | Theorem | The finite remainder integral converges to the improper one. | `IntersectionForm.tendsto_remainder_five` |
| T60 | Theorem | `arg(n + w) → 0` as `n → ∞`. | `IntersectionForm.tendsto_arg_add` |
| T61 | Theorem | The real part of the log difference tends to `0`. | `IntersectionForm.tendsto_log_norm_sub_log_nat` |
| T62 | Theorem | **Log limit:** `log n - log(n+w) → 0`. | `IntersectionForm.tendsto_log_sub_log_add` |
| T63 | Theorem | Finite rearranged identity: `log n - Σ f(k)` in terms of `log w`, the endpoint terms and the remainder. | `IntersectionForm.em_digamma_rearranged` |
| T64 | Theorem | The two Bernoulli terms sum to `-1/(12w²) + 1/(120w⁴)`. | `IntersectionForm.em_sum_two` |
| T65 | Theorem | **Digamma expansion:** `ψ(w) = log w - 1/(2w) - 1/(12w²) + 1/(120w⁴) - R₂(w)` for `Re w > 0`, `Im w ≠ 0`. | `IntersectionForm.digamma_expansion` |
| T66 | Theorem | **Shifted expansion:** `ψ(s) = log(s+N) - ... - R₂(s+N) - Σ_{k<N} 1/(s+k)`, placing the remainder at `Re(s+N) = N + 1/4`. | `IntersectionForm.digamma_shifted_expansion` |
| T67 | Theorem | `Re log w = ½ log(normSq w)`, reducing the log term to a rational log. | `IntersectionForm.log_re_eq_half_log_normSq` |
| T68 | Theorem | The panel point `(N+1/4) + i(t/2)` has rational norm square `(N+1/4)² + (t/2)²`. | `IntersectionForm.normSq_panelPoint` |
| T69 | Theorem | Its log real part is `½ log((N+1/4)² + (t/2)²)`. | `IntersectionForm.panel_log_re_eq` |
| T70 | Theorem | Rational enclosure of the panel log term. | `IntersectionForm.panel_log_re_mem` |
| T71 | Theorem | The panel norm square `q` is positive. | `IntersectionForm.panelQ_pos` |
| T72 | Theorem | `Re(1/(2w)) = reW/(2q)`, rational. | `IntersectionForm.panel_term1` |
| T73 | Theorem | `Re(1/(12w²)) = (reW² - imW²)/(12q²)`, rational. | `IntersectionForm.panel_term2` |
| T74 | Theorem | `Re(1/(120w⁴))` as an explicit rational function of `reW, imW, q`. | `IntersectionForm.panel_term4` |
| T75 | Theorem | `Re(1/panelPoint) = reW/q`, rational. | `IntersectionForm.panel_inv_re` |
| T76 | Theorem | The finite gamma sum is the rational sum `Σ (k+1/4)/q_k`. | `IntersectionForm.panel_sum_re` |
| T77 | Theorem | Real-part bridge: `Re ψ(s)` equals the real part of the T66 shifted expansion. | `IntersectionForm.re_digamma_shifted` |
| T78 | Theorem | `Ω(t) = Re ψ(sPoint t) - log π`, together with the rational endpoint definitions `omegaLo/omegaHi`. | `IntersectionForm.Omega_eq_digamma` |
| T79 | Theorem | **Pointwise panel enclosure:** `omegaLo(t,N,M) ≤ Ω(t) ≤ omegaHi(t,N,M)` for rational `t ≠ 0`, `N ≥ 1`. | `IntersectionForm.omega_mem` |
| T80 | Theorem | Sign-aware interval product: `min(w·lo,w·hi) ≤ w·x ≤ max(w·lo,w·hi)` for `lo ≤ x ≤ hi`. | `IntersectionForm.mul_between` |
| T81 | Theorem | **Density transfer:** pointwise `lo ≤ Ω ≤ hi` gives a rational interval for `σ² ∫ e^{-σ²t²} cos(ct) Ω(t) dt`. | `IntersectionForm.density_mem` |
| T82 | Theorem | Mean-value Lipschitz transfer: `|f'| ≤ L` on a panel gives `|f y - f x| ≤ L(y-x)`. | `IntersectionForm.abs_sub_le_of_abs_deriv_le` |
| T83 | Theorem | `Ω(t) = -log π + Re Ψ(t)` and `Ω` is continuous. | `IntersectionForm.continuous_Omega` |
| T84 | Theorem | `Ω'(t) = Re Ψ'(t)`. | `IntersectionForm.deriv_Omega_eq` |
| T85 | Theorem | Global derivative bound `|Ω'(t)| ≤ psiSeriesBound 1`. | `IntersectionForm.abs_deriv_Omega_le` |
| T86 | Theorem | `Ω` is differentiable. | `IntersectionForm.differentiableAt_Omega` |
| T87 | Theorem | All-`t` panel enclosure: `Ω(t) ∈ Ω(a) ± psiSeriesBound 1 · (t-a)`. | `IntersectionForm.Omega_panel_global` |
| T88 | Theorem | `t`-dependent term norm: `‖(1/4 + it/2 + j)^{-2}‖ = ((j+1/4)² + (t/2)²)⁻¹`. | `IntersectionForm.norm_polygamma_term_sq` |
| T89 | Theorem | Polygamma series at the panel point: `ψ'(s) = Σ (s+j)^{-2}`. | `IntersectionForm.hasSum_polygamma_sq` |
| T90 | Theorem | `t`-dependent derivative bound: `‖ψ'(s)‖ ≤ Σ ((j+1/4)²+(t/2)²)^{-1}`. | `IntersectionForm.norm_deriv_digamma_le_tsum` |
| T91 | Theorem | The generated diagonal `certD` is positive. | `IntersectionForm.certD_pos` |
| T92 | Theorem | The generated `certL` is lower triangular. | `IntersectionForm.certL_lower` |
| T93 | Theorem | `certL.det = 1`. | `IntersectionForm.certL_det` |
| T94 | Theorem | `certL` is a unit. | `IntersectionForm.certL_unit` |
| T95 | Theorem | `certL * diagonal certD * certLᴴ = certP`, exactly over `ℚ`. | `IntersectionForm.cert_factor` |
| T96 | Theorem | `certP = certG0 − certT • 1` is positive definite. | `IntersectionForm.certP_posDef` |
| T97 | Theorem | The generated numerical matrix `certA` is Hermitian. | `IntersectionForm.certA_herm` |
| T98 | Theorem | `certA` lies in the box `certG0 ± certE` with slack `certT`. | `IntersectionForm.certA_mem_box` |
| T99 | Theorem | Every row sum of `certE` is at most `certT`. | `IntersectionForm.certE_row` |
| T100 | Theorem | The box theorem instantiates: `certA` is positive definite. | `IntersectionForm.certA_posDef` |
| C1 | Computation | The Gram entries and the three isotropic basis vectors are exact. | `test_gram_matrix_entries` |
| C2 | Computation | `(1,1,0)² = 2`, `(1,-1,0)² = -2`, `A² = 6`, `Δ² = 0`. | `test_self_intersection_examples` |
| C3 | Computation | The form is indefinite. | `test_form_is_indefinite` |
| C4 | Computation | The Hodge defect equals the sum of squares on a `7×7×7` grid. | `test_hodge_defect_identity` |
| C5 | Computation | On `A^⊥`, `D² ≤ 0` with equality only at zero, on a `9×9` grid. | `test_hodge_index_negative_on_complement` |
| C6 | Computation | The signature is `(1, 2)`, computed exactly by sympy. | `test_signature_is_one_two` |
| C7 | Computation | `y² = x³ - x` over `F_5` has `8` points, so `a_5 = -2`. | `test_elliptic_point_count_known_value` |
| C8 | Computation | Six elliptic curves satisfy `a_p² ≤ 4p` and `disc ≤ 0`. | `test_hasse_bound_examples` |
| C9 | Computation | Non-prime `p` and singular curves are rejected. | `test_invalid_domain_is_rejected` |
| C10 | Computation | A class of the wrong length is rejected. | `test_vector_shape_is_rejected` |
| C11 | Computation | The recorded shadow loads, is symmetric, has a `10⁻⁴` margin, and passes the centre/error certificate with positive minors and pivots. | `test_certificate_is_recorded_and_certified` |
| C12 | Computation | The certificate is near the boundary: the fourth minor is positive and below `10⁻⁵`. | `test_certificate_is_near_the_boundary` |
| C13 | Computation | The recomputed operator slack matches the recorded `t` to `10⁻¹²`. | `test_operator_slack_matches_recorded` |
| C14 | Computation | Every Gram interval contains the recorded numerical Gram entry. | `test_gram_intervals_contain_recorded_numerical_gram` |
| C15 | Computation | Every enclosed density interval (the `Ω` integral) contains its numerical value. | `test_density_intervals_contain_recorded_numerical_density` |
| C16 | Computation | The diagonal interval encloses `W(σ)`, and the recomputed `W(0)` matches the recorded value to `10⁻²⁰`. | `test_diagonal_encloses_W_sigma` |
| C17 | Computation | The prime term at separation `0.6` is active (`−0.03648…`). | `test_prime_term_is_active` |
| C18 | Computation | The vendored `Ω` enclosure contains the digamma reference at `t = 0, 0.5, 1, 10` with finite width. | `test_omega_enclosure_contains_digamma` |
| C19 | Computation | The vendored `Ω` enclosures reproduce the recorded sample intervals. | `test_omega_enclosure_matches_recorded_samples` |
| C20 | Computation | A certificate shifted by `0.03` on the diagonal is rejected. | `test_perturbed_certificate_is_rejected` |
| C21 | Computation | The recorded rational `L`, `d` satisfy `L diag(d) Lᵀ = G₀ − tI` exactly, with `L` unit lower triangular and `d > 0`. | `test_ldl_factorization_is_exact` |
| C22 | Computation | A zero pivot or a corrupted `L` fails the factorisation check. | `test_tampered_ldl_is_rejected` |
| C23 | Computation | The rational constants in `lean/Topic.lean` match the certificate's `L`, `d`, `P`. | `test_lean_embedding_matches_certificate` |
| C24 | Computation | The numerical matrix lies in the recorded box, is symmetric, the centre is `P + tI`, and the row sums of `E` are at most `t` (formalised as T21–T24). | `test_box_hypotheses` |
| C25 | Computation | The Rust JSON has every required key, `status = certified`, `σ = 1/20`, margin `10⁻⁴` and conversion slack `10⁻⁹`. | `test_schema_and_status` |
| C26 | Computation | The Rust Gram intervals are ordered and exactly symmetric. | `test_interval_matrix_is_symmetric` |
| C27 | Computation | The Rust centre/error certificate is positive definite with positive minors and pivots; the fourth minor is below `10⁻⁵`. | `test_certificate_is_positive_definite` |
| C28 | Computation | The recorded rational `L`, `d`, `P` satisfy `L diag(d) Lᵀ = P = G₀ − tI` exactly. | `test_ldl_factorisation_is_exact` |
| C29 | Computation | The Rust numerical matrix is symmetric, lies in the Rust box, and the row sums of `E` are at most `t`. | `test_box_contains_numerical_matrix` |
| C30 | Computation | Every Rust Gram interval contains an independently recomputed mpmath Gram entry. | `test_gram_contains_independent_numerical_gram` |
| C31 | Computation | The Rust and Python interval matrices overlap entrywise. | `test_gram_overlaps_python_certificate` |
| C32 | Computation | Every Rust density interval contains an independently recomputed density value and is narrower than `10⁻³`. | `test_density_intervals` |
| C33 | Computation | Every Rust density interval overlaps the Python density enclosure. | `test_density_overlaps_python_certificate` |
| C34 | Computation | Every Rust pole interval contains the mpmath pole value and is narrower than `10⁻¹²`. | `test_pole_intervals` |
| C35 | Computation | Every Rust prime interval contains the mpmath prime sum and is narrower than `10⁻⁸`. | `test_prime_intervals` |
| C36 | Computation | The prime term is active at `c = 3/5` (`≈ −3.65·10⁻²`). | `test_prime_term_is_active` |
| C37 | Computation | Every recorded `Ω` sample contains the mpmath digamma value and has width below `10⁻⁴`. | `test_omega_samples_contain_digamma` |
| C38 | Computation | The Rust diagonal interval contains `W(0)`. | `test_diagonal_contains_W_sigma` |
| C39 | Computation | The generated Lean file contains no placeholder or floating-point token and declares the two positivity theorems. | `test_lean_file_is_sorry_free` |
| C40 | Computation | The Ramanujan tau values `τ(1)…τ(12)` are correct, `τ` is multiplicative, and the Hecke recurrence holds at prime powers up to 500. | `test_tau_known_values`, `test_tau_is_multiplicative`, `test_hecke_recurrence_at_prime_powers` |
| C41 | Computation | The Ramanujan–Petersson bound `abs(τ(p)) ≤ 2p^{11/2}` holds for every prime `p ≤ 500`; worst ratio `0.9594…` at `p = 103`. | `test_ramanujan_petersson_bound` |
| C42 | Computation | For `E: y²=x³+x+1`, the traces `a_p` take at least ten distinct values for `p ≤ 120`; no fixed trace fits, illustrating the no-go for one algebraic Frobenius. | `test_elliptic_traces_are_not_a_fixed_trace` |
| C43 | Computation | The equal-sector Fourier coefficients are orthogonal across sectors and satisfy the conjugate symmetry `c_{k,-j} = conj(c_{k,j})`. | `test_sector_fourier_orthogonality` |
| C44 | Computation | The finite zeta-weighted Bochner matrix is Hermitian and positive semidefinite for `m = 4, 8, 16`. | `test_gram_is_hermitian_psd` |
| C45 | Computation | The smallest eigenvalue of the sector model decays roughly like `c/m`; the model exhibits no uniform gap. | `test_min_eigenvalue_decays_with_sectors` |
| C46 | Computation | The curve-level dimension formula of the 2023 Riemann–Roch theorem gives `dim H⁰ = 1,2,3,4` at `a = 0,1,2,3`, and the exceptional-set indicator is correct at `a = 0, 0.5, 1`. | `test_curve_level_dimension`, `test_exceptional_set` |
| C47 | Computation | The local HRR on a complex torus gives `χ = D²/2` and is integral for `D² = 2,4,6`. | `test_local_torus_hrr` |
| C48 | Computation | The periodic-orbit local term of the explicit formula is finite and decreasing in `p` for a Gaussian test function. | `test_periodic_local_term_is_finite_and_decaying` |
| C49 | Computation | The curve-level dimension is subadditive on a grid; submodularity and log-concavity fail at explicit divisors. | `test_dimension_inequalities` |

## Source claims (recorded, not adopted as Lean theorems)

| # | Claim | Status |
|---|---|---|
| S1 | Weil (1948) / Deligne (1974): RH for curves and varieties over finite fields, via the Frobenius correspondence and a positivity. | Standard; not formalised |
| S2 | Hodge index theorem: the intersection form on `NS(S) ⊗ R` has signature `(1, ρ-1)`. | Standard; only the rank-three model is formalised (T5–T9) |
| S3 | Arakelov (1974) intersection theory; Faltings–Hriljac (1985): `D·D = -ĥ(D)` on degree zero, with `ĥ` positive definite. | Standard; not formalised |
| S4 | Weil's explicit formula as the arithmetic analogue of the Lefschetz trace formula. | Standard; not formalised |
| S5 | The certified `Ω` enclosure and Taylor-panel density bound of `prime-spectrum-tensor` (C9–C21), inherited as the analytic input of the shadow. | Computational; recorded as provenance, not re-proved here |
| S6 | Connes' trace formula and spectral realization of the zeros by the scaling action on the adele class space. | Standard; not formalised |
| S7 | Eichler–Shimura: `T_p = F_p + p F_p^{-1}` on `H¹` of a modular curve. | Standard; not formalised |
| S8 | Deligne's proof of the Ramanujan–Petersson bound via the Weil conjectures. | Standard; not formalised |
| S9 | The trichotomy of note 05 §2.4 and the polarization reading of §5. | This dossier's interpretation, not a theorem |
| S10 | The angular Bochner finite-level matrices are positive semidefinite (ABF §3). | Standard (Bochner); not formalised |
| S11 | The angular Bochner projective system is logically coextensive with the classical mean-value toolbox (ABF §5). | Standard; recorded as a source claim |
| S12 | Uniform undamped positivity of the angular Bochner system is equivalent to Weil positivity and hence to RH (ABF §6). | Standard; not formalised |
| S13 | Connes–Consani, the Riemann–Roch strategy and the complex lift of the Scaling Site (2018). | Standard; not formalised |
| S14 | Connes–Skandalis longitudinal index theorem for foliations. | Standard; not formalised |
| S15 | Connes–Consani, Riemann–Roch for `Spec Z` (2023): the curve-level theorem and Serre duality. | Standard; not formalised |
| S16 | Hirzebruch–Riemann–Roch on a complex torus (Proposition 1 of note 07). | Standard; proved here |
| S17 | Yuan–Zhang, *The arithmetic Hodge index theorem for adelic line bundles I* (Thm. 1.3). | Standard; not formalised |
| S18 | Connes–Consani, *Weil positivity and trace formula: the archimedean place* (2020), Thm. 1 and Thm. 6.11; the Sonin gap and its best constant. | Standard; not formalised |
| S19 | The synthesis of note 08 §3–§5: the three attacks and the common wall. | This dossier's interpretation, not a theorem |

## Open items

1. **The correspondence and its polarization.** The missing object is a
   Frobenius for `Spec Z`: a correspondence whose Lefschetz trace is `ξ`, with
   a polarization. No algebraic construction is known.
   [`notes/05-frobenius-alternative.md`](notes/05-frobenius-alternative.md)
   replaces the algebraic cycle by the scaling correspondence on the adele
   class space, whose trace formula is the explicit formula; the open part is
   then the polarization (the Weil positivity), not the correspondence.
2. **The infinite positivity.** Finite Weil Gram matrices are numerically
   positive definite; the infinite positivity is RH
   ([`../prime-spectrum-tensor/WEIL-POSITIVITY.md`](../prime-spectrum-tensor/WEIL-POSITIVITY.md)).
3. **The archimedean place.** A regularised intersection pairing at infinity
   with a finite-dimensional quotient is not constructed here; the Green's
   function is the standard substitute.
4. **The general Hodge index.** Only the rank-three `E × E` instance is
   formalised. The general theorem is not in Mathlib.
5. **The residual jet-tail audit.** The `10⁻⁴` entry margin dominates the
   conservative `10⁻⁶` jet-tail allowance of the density enclosure. A
   term-by-term derivative-tail proof would remove that allowance, but it does
   not affect the recorded positive margin.
6. **From the finite shadow to the cone.** The `4 × 4` certificate is a finite
   rung. Passing it to the infinite Weil cone is the positivity problem
   itself, and is not addressed by widening the basis.

## What not to claim

- Do not claim that an intersection form for `ζ` is built here. It is not.
- Do not claim that the function-field argument transplants. It does not; the
  correspondence is missing.
- Do not claim that the positivity is the obstruction on this route. The
  positivity is a theorem (S3); the correspondence is the obstruction.
- Do not claim that the Hasse checks prove RH. They verify the
  function-field conclusion on examples; they are not a proof of anything
  about `ζ`.
- Do not reopen F.4 for the polygon. The off-critical zeros are certified.
- Do not claim the certified shadow proves Weil positivity. It certifies one
  four-dimensional subspace; the infinite cone remains open.
- Do not claim the true shadow matrix is Lean-proved.  The interval
  `Ω`/density/prime layer is a Rust computation; `Certificate.lean` proves the
  rational box data and a 12-digit representative `certA`, not the containment
  of the true matrix.  The kernel-checked finite algebra is T12–T19 and
  T91–T100.
- Do not claim the alternative in
  [`notes/05-frobenius-alternative.md`](notes/05-frobenius-alternative.md)
  constructs a Frobenius or proves RH.  It replaces a missing algebraic cycle
  by a measured scaling relation and moves the open problem to the Weil
  polarization.
- Do not claim the Hecke shadow applies to `ζ`.  Its Hecke eigenvalue at every
  prime is `1`; it sees the pole at `s = 1`, not the zeros.
- Do not claim the trichotomy of note 05 §2.4 is a formal theorem.  The
  variation and finite-determinant obstructions are standard; the packaging is
  this dossier's interpretation.
- Do not claim the angular Bochner framework closes the alternative.  Its
  finite-level matrices are positive, but its uniform undamped limit is
  precisely the open Weil positivity; note 06 proves the no-closure
  corollary, not RH.
- Do not claim the Riemann–Roch square closes the alternative.  The local HRR
  is proved; the global longitudinal HRR on the square of the complex lift is
  the open leg.  Note 07 proves the conditional theorem, not RH.
- Do not claim the three attacks solve the alternative.  They reduce it to one
  absolute/off-diagonal positivity, which is equivalent to RH; note 08 proves
  the reduction, not RH.  A realization remains an open construction problem.

## The alternative to Frobenius

[`notes/05-frobenius-alternative.md`](notes/05-frobenius-alternative.md)
replaces the missing global Frobenius by two objects at different levels:

- the **Hecke correspondence** `T_p ⊂ X_0(N) × X_0(N)`, an algebraic cycle over
  `Q` satisfying `T_p = F_p + p F_p^{-1}` on `H¹`; its Ramanujan–Petersson
  bound is RH for the associated `L`-function, but its eigenvalue for `ζ`
  itself is `1`, so it cannot see the zeros;
- the **scaling correspondence** `S = {(λx, x)}` on the adele class space
  `A_Q^×/Q^×`, whose trace formula is the explicit formula. Its periodic
  orbits are the prime powers and its absorption spectrum is the zeros.

The second object reaches `ζ` but leaves the polarization open: the missing
Hodge-index positivity becomes the Weil positivity, which is equivalent to RH.
The finite `4 × 4` Gram matrix is the compression of that polarization to four
Gaussians.

```bash
python3 python/frobenius_alternative.py
python3 -m pytest -q tests/test_frobenius_alternative.py
```

The script computes the Hecke eigenvalues `τ(p)` of the weight-12 form `Δ`
exactly from the eta product, verifies `|τ(p)| ≤ 2p^{11/2}` for `p ≤ 500`, and
tabulates `a_p` for `y² = x³ + x + 1` to show that no fixed trace matches the
Frobenius data.

## The angular Bochner attack

[`notes/06-angular-bochner-attack.md`](notes/06-angular-bochner-attack.md)
takes the alternative of note 05 and tests it against the angular Bochner
framework of the accompanying PDF. The framework gives finite-level positive
matrices and a damping filtration; its undamped projective limit is the Weil
functional. The note's theorem is an equivalence:

> the alternative's polarization is the angular Bochner uniform positivity;
> the finite-level matrices are positive unconditionally; the passage to the
> uniform statement is exactly the classical mean-value closure and cannot be
> made from inside it.

The no-closure corollary says that the finite-level Bochner positivity,
projective refinement and classical mean-value estimates do not imply the
polarization; a proof needs a new uniformity or a new positivity outside that
closure. The finite sector model (C43–C45) illustrates the absence of a
uniform gap:

```bash
python3 python/angular_bochner.py
python3 -m pytest -q tests/test_angular_bochner.py
```

## The Riemann–Roch square

[`notes/07-riemann-roch-square.md`](notes/07-riemann-roch-square.md) follows
the 2018 Riemann–Roch strategy: RH is equivalent to
`Re s(f,f) ≤ 0`, and `s(f,f)` is the self-intersection of the divisor
`D(f) = ∫ f(λ)Ψ_λ d*λ` on the square of the Scaling Site. If `s(f,f) > 0`,
a Riemann–Roch theorem on the square would make `D(f)` or `−D(f)` effective,
contradicting degree/codegree zero.

The local HRR on the periodic-orbit tori is proved: for a complex torus `A`
and a divisor `D`, `χ(A,O(D)) = D²/2`, and `D² > 0` makes `D` or `−D`
effective. The global step is a **longitudinal HRR** on the square of the
complex lift. The note isolates the three technical obstructions: the Todd
class of the foliation, the `log Λ` divergence, and the Witt lift of the
correspondences. This is the precise missing leg.

```bash
python3 python/riemann_roch_square.py
python3 -m pytest -q tests/test_riemann_roch_square.py
```

## Three attacks and the wall

[`notes/08-three-attacks-and-the-wall.md`](notes/08-three-attacks-and-the-wall.md)
consolidates the three routes:

- **Riemann–Roch square:** the local HRR is proved; the global longitudinal
  HRR/Castelnuovo bound is open and equivalent to RH.
- **Arithmetic Hodge index:** Yuan–Zhang does not apply to
  `Spec Z`; a proper polarized realization would prove RH, so none is known.
- **Sonin/prolate:** the gap `c|ĝ(0)|²` is the central value, not a pole; it
  is off-diagonal and cannot be absorbed by de Branges, pole, or Riemann–Roch
  moves; `c = 0` is false, and even `c = 0` is only archimedean positivity.

The common wall is an absolute/off-diagonal positivity. The known legs are
consistent with it but do not imply it; a proof of the fourth leg would be a
proof of RH. This is the precise answer to the “the structure demands the
legs” hypothesis.

## Python layer

```
cd the-final-letter/topics/intersection-form-zeta
python3 -m pytest -q tests
```

`python/programme.py` is the exact rational intersection-form engine plus an
exact Legendre-symbol point count for elliptic curves over prime fields.
`python/weil_shadow.py` verifies the finite shadow (including the exact LDL
factorisation) and supplies the vendored `Ω` enclosure. `python/certify_shadow.py` is the regeneration script that
writes `python/weil_certificate.json`; its long density run is cached in
`python/density_cache.json`, so a rerun without `--recompute` takes seconds.

```python
import programme as P

P.signature()                # (1, 2)
P.self_sq((1, 1, 0))         # 2
P.hodge_defect((1, 1, 1))    # 0
P.hasse_bound_ok(5, -1, 0)   # True
P.reciprocal_root_data(5, -1, 0)
# {'p': 5, 'a_p': -2, 'discriminant': -16, 'reciprocal_root_product': 5,
#  'roots_are_conjugate': True}

import weil_shadow as S
cert = S.load_certificate()
ok, t, minors, pivots = S.certificate_ok(S.interval_matrix(cert))
# ok is True; the fourth minor is about 9.98e-9
S.omega_enclosure(0.5)   # a finite interval containing -3.332...
```

Regenerating the certificate:

```
python3 python/certify_shadow.py     # long: 2000 Taylor panels with Ω jets
```

## Rust layer

```
cd the-final-letter/topics/intersection-form-zeta
cargo test --release --manifest-path rust/weil-assembly/Cargo.toml
./rust/weil-assembly/target/release/weil-assembly \
  --out-lean lean/Certificate.lean \
  --out-json python/rust_certificate.json
```

`rust/weil-assembly` encloses `pole`, `density`, and the finite prime sum in
exact rational intervals, using MPFR at 256 bits with directed rounding for
the elementary functions.  A full run takes about three minutes; the
certificate can also be regenerated with a coarser panel step for a quick
check.  See [`rust/weil-assembly/README.md`](rust/weil-assembly/README.md) for
the rigour argument, the test layout, and the output schema.

## Lean layer

```
cd the-final-letter/topics/intersection-form-zeta
./lean/check.sh
```

The recorded build is `[check] OK Topic.lean`. T12–T19 are the finite algebra
of the shadow: `L * Lᴴ` is positive semidefinite, an exact `L d Lᵀ` with
`d > 0` is positive definite, and the concrete `L`, `d`, `P` are embedded
with the identity and positive definiteness kernel-checked. See
[`lean/README.md`](lean/README.md) for what is and is not formalised.

## Provenance and links

- Standard references: Weil, *Numbers of solutions of equations in finite
  fields* (1948); Deligne, *La conjecture de Weil I* (1974); Arakelov,
  *Intersection theory of divisors on an arithmetic surface* (1974);
  Faltings (1985) and Hriljac (1985) on the arithmetic Hodge index;
  Northcott on the height pairing.
- The bridge survey that locates this route:
  [`../../bridge-to-weil-positivity.md`](../../bridge-to-weil-positivity.md).
- The finite form and its positivity:
  [`../prime-spectrum-tensor/WEIL-GRAM.md`](../prime-spectrum-tensor/WEIL-GRAM.md),
  [`../prime-spectrum-tensor/WEIL-POSITIVITY.md`](../prime-spectrum-tensor/WEIL-POSITIVITY.md).
- The certified shadow and its `Ω` enclosure:
  [`notes/04-certified-shadow.md`](notes/04-certified-shadow.md),
  [`python/weil_certificate.json`](python/weil_certificate.json).
- The polygon zeros that close the Lee–Yang arm:
  [`../geometric-dynamical-phase-transitions/BRIDGES.md`](../geometric-dynamical-phase-transitions/BRIDGES.md)
  (`B26`, `B28`) and `C46`/`C47` of that dossier.
- The wall this route refines:
  [`../../categories/10-walls/walls.md`](../../categories/10-walls/walls.md) (W1).
- Programme standard: [`../PROGRAMME-STANDARD.md`](../PROGRAMME-STANDARD.md).
- Topic index: [`../README.md`](../README.md).

[Back to the topic index](../README.md) · [The Final Letter](../../index.html)


## Handoff

The Rust `4 × 4` assembly specified in [`HANDOFF-RUST.md`](HANDOFF-RUST.md) is
implemented in [`rust/weil-assembly`](rust/weil-assembly); the generated
certificate is [`lean/Certificate.lean`](lean/Certificate.lean) with data in
[`python/rust_certificate.json`](python/rust_certificate.json).


## See also

- [`../absolute-polarized-hodge-index-realization/`](../absolute-polarized-hodge-index-realization/README.md)
  — the fibered construction of the absolute polarized Hodge-index
  realization: the local rank-three model is Lean-backed, the global assembly
  is open.
