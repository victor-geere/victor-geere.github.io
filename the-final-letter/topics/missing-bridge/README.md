# The missing bridge — what a positivity proof would have to supply

**Status:** **O4 proved (T57), scope-audited.**  The hard direction
`FiniteWeilPositivity → RH` is Lean-checked, and T20 gives the converse, so
`RH ↔ FiniteWeilPositivity` is formalised for the **finite zero-side Gram
matrix built from the Gaussian-window test family**.  This is a Gaussian-restricted,
zero-side form of the classical Weil criterion, not the full arbitrary-test-function
statement (no archimedean/prime terms are used in `FiniteWeilPositivity`); see
[the O4 audit](#o4-audit).  **RH itself is not claimed:** the remaining open
direction is to prove `FiniteWeilPositivity` (the arithmetic side).  The
elementary core (on-line sum of squares, off-line obstruction, PSD convexity,
entrywise margin transfer) is Lean-checked.  What is harvested is
the existing machinery that any attempt would reuse, not a solution.  The
[tractability scouting](#tractability-scouting) rates the three objectives at
1/5, 1/5 and 2/5 for available slack, and records that **all three would prove
RH if completed**.  The [O2 rounds](#o2-first-round--no-crossing-or-no-free-lunch)
close the linear, interpolation and width-flow versions as equivalent to
positivity or non-monotone; the [O3 first round](#o3-first-round--the-uniform-gap-collapses)
does not support the finite uniform-gap shape.  The
[exhaustion verdict](#exhaustion-verdict) records that what remains is
RH-strength (O4); that hard direction is now proved in
[T57](#o4-audit).
**Part of:** [weil-positivity](../weil-positivity/README.md) ·
[O2 dossier](../angular-partition-method/README.md) ·
[formal core](../absolute-polarized-hodge-index-realization/README.md) ·
[topic index](../README.md).

## What the programme is

The [weil-positivity](../weil-positivity/README.md) hub names the zero-side
positivity statement and proves the elementary equivalence with RH.  A review of
that hub (recorded in the provenance below) found that its advertised
`blocks ⇒ RH` theorem is vacuous as formalised: the hypothesis `OffLineBlockPSD`
for every separation is refuted by the hub's own
`not_offLineBlockPSD_of_offLine`, so the implication has a contradictory
antecedent.  The real content of a bridge is therefore not in the equivalence
but in one of three possible *mechanisms*.

This topic records those three mechanisms as research objectives, states
exactly what each would have to prove, and harvests from
[`index-lean`](../index-lean/index.md) the existing proofs that are useful for
each.  It does not assume any of them is reachable.

### Objective 1 — a manifest sum of squares for the prime side

> An identity that writes the prime side as a manifest sum of squares, i.e. an
> extension of the rank-one factorization off the critical line — which is
> exactly RH.

**What exists.**  On the critical line the factorization is complete:
`gaussianZeroTest_eq_mode_mul` gives
`H_{a−b}(1/2+it) = φ_a(t) conj φ_b(t)`, and `zeroSideGramReal_term` turns the
Gram entry into cosine and sine mode products.  The new theorem
`onLineQuad_eq_sum_sq` writes the resulting quadratic form as an explicit sum
of squares, and `onLineQuad_nonneg` is its corollary.

**What is missing.**  Off the critical line there is no factorization with a
nonnegative weight: `offLineBlock_not_psd` exhibits a separation whose isolated
block is indefiniteness, and `offLine_growth` shows the offending term is
unbounded.  On the arithmetic side, `vonMangoldt_nonneg` proves that every
coefficient of the prime sum is nonnegative, and `prime_side` in the Python
layer verifies the prime contribution is a sum of nonnegative terms.  That is
not enough: the archimedean density `Ω(t) = Re ψ(1/4+it/2) − log π` is signed
(it is negative at `t = 0`), and the assembled entry takes both signs.  A
manifest sum of squares would have to come from the *whole* prime/archimedean
assembly, not from the von Mangoldt coefficients alone.

**Why it is hard.**  The factorization at an off-line zero would have to be a
rank-one representation with a *positive* weight, but the off-line contribution
grows like `e^{|c||δ|}`.  Any such representation is therefore false as soon as
one off-line zero exists; proving it for all test functions is RH.

### Objective 2 — a positivity-preserving deformation

> A positivity-preserving deformation/continuation argument on the Weil form —
> an entirely new analytic mechanism.

**What exists.**  `posSemidef_convexCombination` proves the PSD cone is convex,
and `posSemidef_add_smul` proves it is closed under nonnegative one-parameter
deformations; `differentiable_paleyWiener`, `hasDerivAt_paleyWiener` and
`contour_shift_paleyWiener` supply the differentiability and contour-shift
machinery for moving the test function's parameter.  `paleyWiener_one_sub` and
`paleyWiener_conj` give the reflection symmetries.

**What is missing.**  Convexity of the PSD cone is not a deformation argument:
it says that *if* both ends are PSD, the path is PSD.  What is needed is a path
from a manifestly positive object (a sum of squares, or a finite certificate)
to the Weil form that stays PSD and is analytically controlled at every step.
No such path is known.  The contour shift moves the test function but does not
preserve a sign.

### Objective 3 — a weaker, satisfiable statement

> A genuinely weaker, satisfiable statement that implies positivity and is
> independently provable.

**What exists.**  `strict_margin_transfer` (harvested `posDef_of_entry_bound`)
proves that strict positivity with an entrywise margin is stable:
`C − t·I` positive definite, `|G − C| ≤ ε` entrywise, and `ε·n < t` imply
`G.PosDef`.  `centre_sub_margin_posDef` and `centre_certificate_satisfiable`
instantiate this at the rational 4×4 Gaussian centre, so the finite certificate
is genuine.  The generic Gram identities `gramQuad_eq_norm_sq` and
`gramMatrix_posSemidef` give the finite sum-of-squares shadow.

**What is missing.**  The margin scales as `t/n`, so it decays with dimension:
a finite certificate of size `n` needs an entrywise error below `t/n`.  For the
infinite Weil form there is no `n` and no uniform entrywise margin.  A weaker
statement that *implies* infinite positivity would have to be a uniform
statement about the whole cone, and no such statement is known.  The finite
certificates are satisfiable but, as the O2 dossier itself records, they
constrain nothing about the zeta zeros.

## Tractability scouting

The three objectives are not weaker than RH in the way that matters.  If any
is completed for the full cone of Gaussian test families, it yields Weil
positivity, and Weil positivity yields RH by the classical Weil criterion (the
`⇒` direction is the nontrivial half; in this repo the full-block domination
`FullBlockWithin` is the step that is not yet formalised, and the hub's
isolated-block version is vacuous).  So the question is not *whether* each
would prove RH — **all three would** — but how much slack each offers, and
what a first real step looks like.

| Objective | Would it prove RH? | Logical strength | Slack | Tractability (1–5) | First concrete step | Main obstruction |
|---|---|---|---|---|---|---|
| O1 | yes | **equivalent to RH** | none | 1 | an explicit positive-definite symbol, or diagonalisation, of the prime kernel | the prime kernel is indefinite (C7); the on-line factorization has no off-line analogue |
| O2 | yes, if the deformation preserves positivity on the full cone | equivalent in content; a proof strategy | none (linear/σ) | 1 | — (no surviving candidate) | positivity of the path is exactly the hard part; the σ-flow is not monotone (T13–T16, C10) |
| O3 | yes, by construction | sufficient condition; weaker only in hypothesis strength | narrow: finite route unsupported | 2 | a precise subcone with provable positivity plus a uniform continuity bound | any provable sufficient condition is RH-strength unless it uses new structure; the uniform gap fails (C11) |

The rating is a ranking of available slack, not a probability.  The three
scouting notes below say what would count as success, what would raise the
estimate, and the cheapest test that would kill the route.

### Scouting O1 — a manifest sum of squares

**What success looks like.**  An explicit identity
`P(c) = Σ_r ψ_r(c) conj ψ_r(c)` (or a positive-definite symbol) for the
prime-side kernel `P(c) = Σ_n Λ(n) n^{-1/2} h_c(log n)`, valid for every
separation `c`, together with the archimedean and pole terms.  The on-line
identity `onLineQuad_eq_sum_sq` is the prototype.

**What is already known.**  The factorization is complete on the critical line
and fails off it (T3, T5).  It is tempting to read `vonMangoldt_nonneg` as
"the prime side is manifestly nonnegative", but that is a statement about the
*scalar* entry, not the quadratic form.  C7 is the correction: every scalar
term of the prime kernel is nonnegative, and the symmetrised kernel still has
negative eigenvalues for the standard four-centre family at
`σ = 0.05, 0.1, 0.2`.  The sign of the kernel is therefore not termwise, and
a sum-of-squares identity has to mix primes (and probably the functional
equation) rather than group them term by term.

**What would raise the estimate.**  A theta-type identity pairing `n` with
`1/n` and turning the von Mangoldt sum into a square; a positivity-preserving
transform that diagonalises the prime kernel; or an arithmetic identity that
identifies the prime kernel with the zero-side kernel before positivity is
imposed.

**Cheapest falsification.**  Extend C7 to the assembled prime + archimedean +
pole kernel and test PSD on larger families.  Under RH the assembled kernel
must be PSD, so a numerical failure would indicate a sign or normalisation
error, not a disproof; the useful signal is the *size* of the negative
eigenvalue relative to the archimedean term.

**Estimate: 1/5.**  O1 is the goal restated, not an independent route.  It is
worth pursuing only if a concrete factorization candidate appears.

### Scouting O2 — a positivity-preserving deformation

**What success looks like.**  A family `W_t` of quadratic forms with `W_0` a
manifest sum of squares (or a finite certificate) and `W_1` the Weil form,
plus a theorem that `t ↦ λ_min(W_t)` does not cross zero.

**What is already known.**  The PSD cone is convex (T6) and closed under
nonnegative one-parameter deformations (T7), and the Paley–Wiener machinery is
differentiable and admits the contour shift.  But convexity says only: *if*
both endpoints are PSD, the path is PSD.  Eigenvalue continuity plus a sign at
both ends does not prevent two crossings; one needs monotonicity, a maximum
principle, or an interlacing argument.

**What would raise the estimate.**  An explicit flow whose semigroup is
positivity-preserving (Ornstein–Uhlenbeck, Mehler, or a completely positive
semigroup) and whose generator is the Weil form; a monotonicity formula for
`λ_min` under `σ` or `c`; or a Weyl-type inequality comparing the Weil form to
a known operator.

**Cheapest falsification.**  Interpolate numerically between the 4×4
certificate and a nearby kernel and track `λ_min`; if it crosses zero on the
natural path, that deformation is dead.  The test is cheap and discriminating.

**Estimate: 1/5 after the second round.**  The
[first round](#o2-first-round--no-crossing-or-no-free-lunch) closes the linear
and interpolation versions as equivalent to positivity, and the
[second round](#o2-second-round--the-width-flow-is-not-monotone) kills the
Gaussian-width flow.  No surviving candidate remains.

### Scouting O3 — a weaker, satisfiable statement

**What success looks like.**  A statement `S` such that (i) `S` is provable
without assuming RH and (ii) `S` implies positivity on the full cone.

**The logical trap.**  (i) and (ii) together are a proof of RH.  So `S` cannot
be "weaker" in the sense of "less than RH"; it can only be weaker in
*hypothesis strength* while still sufficient — a sufficient condition whose
proof uses structure that the full positivity statement does not expose.  The
finite certificate is the cautionary case: `centre_certificate_satisfiable` is
independently provable and the margin statement is stable, but it is not
sufficient for the infinite form, and its margin `t/n` decays with dimension
(C5).  A "satisfiable" `S` that is not also sufficient is worth nothing here.

**Two plausible shapes.**  (a) A dense subcone `C` of the admissible cone with
positivity on `C`, plus a uniform bound that lets positivity pass to the
closure.  (b) Approximate positivity with an explicitly dominated error, where
the archimedean and pole terms absorb the residual.  Both need uniform control
of the Weil form, which is the hard analysis.

**What would raise the estimate.**  A precise definition of the subcone and a
proof that the Weil form is continuous in a topology where the subcone is
dense; or a negative theorem showing that no checkable sufficient condition of
a given class exists, which would redirect effort.

**Cheapest falsification.**  Push the finite certificate to `n = 5, 6, ...`
and measure the margin decay; if the margin collapses faster than `1/n`, the
finite route is dead without a new idea.

**Estimate: 2/5.**  The most promising *logical* shape, because it permits
slack; the danger is that the slack is illusory and the sufficient condition
is RH again.  The [first round](#o3-first-round--the-uniform-gap-collapses)
below does not support the finite uniform-gap shape, so the `2/5` now refers only to the
dense-subcone/continuity shape.

### Bottom line

- **All three objectives would prove RH if completed.**  O1 is equivalent to
  RH; O2 and O3 are sufficient conditions that would prove it.
- None can yield more than RH: each is a sufficient condition for a statement
  equivalent to RH, so a completed objective is a proof of RH and nothing
  stronger.
- O1 has no slack and is not a stepping stone; O2 is the only place a new
  analytic mechanism can enter; O3 is a search for a genuine sufficient
  condition, and its first task is to define the subcone precisely.
- A completed objective is a proof of RH, not evidence for it.  Nothing in
  this folder changes that.

## O2 first round — no-crossing, or no free lunch?

The scouting note proposed three mechanisms: monotonicity, a maximum principle,
or interlacing.  The first round tests the first two on the finite model and
records what survives.

**T11 — positivity-preserving maps need not be eigenvalue-monotone.**
`posSemidef_sandwich` proves that the congruence `A ↦ S A Sᵀ` preserves
positive semidefiniteness for every real `S`.  C8 shows that it can *lower* the
least eigenvalue: for `A = [[2,1],[1,2]]` and `S = diag(1, 1/2)`, the least
eigenvalue drops from `1` to about `0.349`, and for `S = diag(1,0)` it drops to
`0`.  So a maximum principle that knows only "positivity is preserved" does
not give a monotonicity theorem for `λ_min`.  The gap is real, not a technical
nicety.

**T12 — the linear path has no slack.**
`linear_path_posSemidef_iff` proves the exact characterisation

`(∀ t ≥ 0, (A + t • B).PosSemidef) ↔ A.PosSemidef ∧ B.PosSemidef`.

So a linear interpolation from a known-PSD block to the Weil block is PSD for
all `t ≥ 0` exactly when the velocity block is already PSD.  If the Weil
endpoint is indefinite, the path crosses zero.  C9 is the two-dimensional
instance: with `A = I` and `B = [[0,1],[1,0]]`, `λ_min = 1 − t` crosses at
`t = 1`; with `B = I`, `λ_min = 1 + t` never crosses.

**The continuity obstruction.**  More generally, if `A` is PSD and `B` is not,
then *every* continuous path from `A` to `B` crosses `λ_min = 0`, because
`λ_min` is continuous and changes sign.  A no-crossing theorem for a path from
a known-PSD object to the Weil form is therefore equivalent to the Weil form
being PSD.  It cannot be a weaker statement: the "no-crossing" formulation has
the same content as positivity.

**The canonical flow is blocked.**  The de Bruijn–Newman heat flow is the
standard nonlinear deformation of the Riemann Ξ-function:
`H_t(z) = ∫_0^∞ e^{t u²} Φ(u) cos(zu) du` has only real zeros for
`t ≥ Λ`, and RH is equivalent to `Λ ≤ 0`.  Rodgers and Tao proved `Λ ≥ 0`
(*The de Bruijn–Newman constant is non-negative*, Forum Math. Pi 8 (2020)),
so the cooling direction `t < 0` has non-real zeros.  The heat flow therefore
cannot be used to propagate positivity backwards to `t = 0`; the most natural
maximum-principle candidate is known to fail in exactly the direction that
would help.  (This is a statement about the Ξ-flow, not about the Gaussian
Weil form directly, but it is the canonical instance of the mechanism.)

**What survives.**  A nonlinear flow `W_t` with all three of: a genuine
monotonicity theorem for `λ_min` (not merely positivity preservation), a
manifestly PSD limit, and a link from the limit back to the Weil form.  None
of the three is available, and the first round does not supply one.  What it
does supply is a clean closure of the naive readings.

**The logical reading.**  T12 and the continuity obstruction show that O2 is
not a weaker statement than positivity: it is a different *proof strategy* for
the same statement.  The PSD cone is closed, so a limit of PSD forms is PSD;
a continuous path, a discrete sequence, or a monotone flow all prove the same
endpoint.  The same is true of O1, which is an algebraic proof strategy for
the same statement.  Only O3 is formulated as a genuinely weaker *statement*.
So the scouting table's "would it prove RH?" is not the interesting question
for O1 and O2: both would, because both are the same theorem approached from a
different angle.  O2's value is methodological — a new mechanism — not logical
— a smaller target.

**Revised reading of the rating.**  The `2/5` in the scouting table now refers
only to the surviving nonlinear-flow version.  The interpolation and linear
versions are `1/5`: T12 shows they are equivalent to positivity, and the
continuity obstruction shows that no continuous path can do better.

## O2 second round — the width flow is not monotone

The surviving O2 candidate was a monotone flow in the Gaussian width σ.  This
round kills it.

**T13–T16 — the on-line weight is not monotone.**  The on-line kernel weight is
`gaussianWeight σ γ = 2πσ² exp(−σ²γ²)`, with derivative
`4πσ exp(−σ²γ²)(1 − σ²γ²)` (`hasDerivAt_gaussianWeight`).  The derivative is
positive at `σ = 1/(2γ)` and negative at `σ = 2/γ`
(`gaussianWeight_deriv_pos`, `gaussianWeight_deriv_neg`), so the weight is
neither monotone nor antitone in σ (`gaussianWeight_not_monotone`).  The
σ-flow therefore fails on the on-line part, before any arithmetic enters.

**C10 — the full Gram is not monotone either.**  For the 4×4 arithmetic Gram
on the centres `−0.3, −0.1, 0.1, 0.3`, the derivative of `λ_min` along the
minimising eigenvector is `+0.196` at `σ = 0.02` and `−0.258` at `σ = 0.03`.
The sign change confirms the failure for the full form, not just the on-line
weight.

**Verdict.**  O2 is parked at **1/5**.  The linear version is equivalent to
positivity (T12 and the continuity obstruction); the σ-flow is not monotone
(T13–T16, C10); the canonical heat flow is blocked by Rodgers–Tao.  The only
surviving version is a nonlinear flow with a genuine `λ_min` monotonicity
theorem, and there is no candidate.

## O3 first round — the uniform gap collapses

The scouting proposed two shapes for a weaker statement.  The first — uniform
positivity on a fixed interval — is directly testable.

**C11 — the finite gap is not uniform.**  Take `n` equally spaced centres in
`[−0.3, 0.3]`, form the Toeplitz arithmetic Gram `K(|i−j|h)`, and compute
`λ_min` for `n = 4, 8, 16, 32, 64` at `σ = 0.05`:

| `n` | 4 | 8 | 16 | 32 | 64 |
|---|---|---|---|---|---|
| `λ_min` | `2.27e−2` | `2.74e−5` | `2.38e−6` | `~0` | `~0` |

The diagonal `K(0) = 4.31e−2` is the same for every `n`, so the collapse is not
a scaling artefact of the entries: the discrete spectral gap decays.  If the
continuous kernel had a positive gap, the Toeplitz eigenvalues would grow like
`1/h` as `h → 0`, not vanish.  The observation is consistent with a continuous
kernel that is positive semidefinite but not positive definite on the interval,
or with a gap below the numerical resolution.

**Verdict.**  The uniform-gap shape of O3 is not supported at the tested resolution.  The only
surviving shape is the dense-subcone/continuity one, which needs a uniform
bound on the Weil form — the missing `FullBlockWithin`/`TailEntryBound`
estimate again.  O3 stays at **2/5**, but with less room than before.

## Where the programme stands

| Objective | Rating | State |
|---|---|---|
| O1 | 1/5 | RH restated; no slack |
| O2 | 1/5 | linear and σ versions closed; heat flow blocked; no surviving candidate |
| O3 | 2/5 | finite uniform-gap route unsupported; only dense-subcone/continuity remains |

None of the three has a next step that is both cheap and promising.  The
common obstruction behind O3 and the original hub is the same object: a
uniform entrywise/tail bound (`FullBlockWithin`, `TailEntryBound`).  The
APM was investigated as a candidate for retiring that bound; it does not
([below](#does-the-angular-partition-method-retire-the-tail-bound)).  The
`FullBlockWithin` route has in turn a maximal-`|δ|` precondition that is not
known ([below](#the-maximal-distance-precondition-of-the-full-block-route)), so the
next investment should be the arithmetic-side estimate, not the zero-side
domination.  The first arithmetic-side round
([below](#the-arithmetic-side--first-round)) shows that the smooth PNT main
term exactly cancels the growing half of the pole term; what remains is the
narrow-window PNT error plus the archimedean term.

## Does the angular partition method retire the tail bound?

The [angular partition method](../angular-partition-method/README.md) (APM) is
the natural candidate for making the `FullBlockWithin`/`TailEntryBound`
obstruction obsolete: its angular/radial axis is advertised as an exact
measure identity with no truncation.  The investigation below reads the APM's
own claims and applies them to the specific tail in this dossier.

**What the APM claims.**  For a summable nonnegative series, the annular
representation gives `Σ_n a_n = μ(X) = R_0²` with squared tail radii
`R_n² = Σ_{k≥n} a_k`; the finite sums are chords of the tail coil.  In the
summary table of APM §6 the angular/radial axis is described as "exact
algebraic/measure identity; no tail", against the depth axis's "needs a closed
tail or a bound".

**What it does not claim.**  The same table says the angular limit is "closed
forms only in special cases".  APM §7.4 is explicit: "A representation is not
automatically an evaluation... The method does not manufacture closed forms."
For `ζ(s)` in the convergence domain, the coil is exact "although evaluating
`Z_0` is still the original problem" (APM §2.3).  For the discrete zeta sum,
APM §5.7 is decisive: the even-Bernoulli sampling defect survives, "Nothing in
the angular construction removes it", and "Parity does not remove the tail."
The APM's exactness audit classifies the explicit-formula zero sum and Weil
positivity (row A15) as **O open**, and APM §7.10 lists `ZeroTailSummable` and
`FullBlockWithin` among the remaining named analytic inputs.

**Why the zero-side tail is not covered.**  The annular representation is for
a nonnegative series, or for an absolutely summable complex series via the
vector-area/signed-measure version (APM §7.3).  The zero-side Gram entry is
real but *signed*: the on-line weights `2πσ² exp(−σ²γ²)` are positive, but the
cosine factors change sign, and the off-line quadruple contribution is signed
as well.  C12 makes the point concretely: the total on-line weight is positive
(`0.0196` for the first four ordinates at σ = 0.05) while the Gram entry at
separation `c = 2` is negative (`−0.0088`).  The nonnegative annular area
represents the total weight, not the signed entry; applying the APM to the
entry requires a signed measure, and the sign is exactly the positivity
question.  Moreover, finiteness of the annular area is the summability input
`ZeroTailSummable`, not a consequence of the representation: the identity
`R_0² < ∞` restates the input.

**What the APM does contribute.**  The regularised Mellin kernel and the
finite-part continuation (APM §5.6, `mellinConvergent_regularizedKernel`, and
the two-strips-beyond continuation `regularizedKernel₂`) are genuine tail-subtraction results on
the *analytic* side: they make the vertical Mellin integral convergent by
subtracting exactly the pole terms.  That can reduce the
`VerticalLogDerivIntegrable`/contour-shift inputs of the explicit formula.  It
does not touch the zero-set tail: `FullBlockWithin` is a bound on the
contribution of *other zeros* to a Gram entry, not a vertical Mellin integral.

**Verdict.**  The APM restates a tail as a radius or a measure, and it does so
exactly; that is a change of bookkeeping, not an elimination.  It gives a
closed form only when the tail radius has one (geometric, p-series in the
convergence domain, the continuous integral `1/(σ−1)`).  For the discrete zeta
sum and the zero-side Gram entry, it explicitly does not: the even-Bernoulli
tail survives and the zero sum is open in the APM's own audit.  It therefore
does **not** make the missing-bridge tail bound obsolete.  The most it can do
for `ZeroTailSummable` is restate it as `R_0² < ∞`, which is the same input;
for `FullBlockWithin` it offers nothing new.  Its regularised continuation may
help the analytic assembly, not the zero-side obstruction.

## The maximal-distance precondition of the full-block route

The full-block obstruction needs a bound `B` on the "other" zeros for a fixed
off-line quadruple `Q`.  This section records a structural precondition that
the programme has not checked.

**The growth rate.**  The closed form `offLineQuad_re_exp` is
`S(c) = 2A(e^{cδ}cos(cγ+θ) + e^{−cδ}cos(cγ−θ))`, so a quadruple with distance
`|δ|` from the critical line grows like `e^{c|δ|}`.  The growing term comes
from the reflected zero `1−ρ`, which is present for every off-line zero.

**T17 — an off-line quadruple in the "other" block defeats every uniform
bound.**  `no_uniform_bound_of_offLine_quadruple` proves that for `δ ≠ 0` there
is no `B` with `|S(c)| ≤ B` for all `c`: for every `B` some separation has
`|S(c)| > B`.  So a fixed `B` cannot bound the other zeros for all separations.

**The precondition.**  If `B` is allowed to depend on `c`, the domination
inequality still requires the chosen `Q` to have strictly larger `|δ|` than
every other zero.  Otherwise a larger-`|δ|` quadruple grows faster and
eventually dominates `Q`.  C13 makes this concrete at `σ = 0.05`: the maximum
of `|S(c)|` over `c ∈ [0,40]` is `1.04` for `|δ| = 0.1` and `30.4` for
`|δ| = 0.2`, and the larger one exceeds any fixed bound as `c` grows.

**Is the precondition known?**  No.  The known zero-free line `Re s = 1` gives
`|δ| < 1/2`, but nothing in the programme (or in the standard zero-free
region) gives a zero whose `|δ|` is strictly maximal.  If the off-line zeros
have `|δ|` values with no strict maximum, the clean domination argument cannot
be completed.  The escape — choosing `c` so that the larger-`|δ|` contributions
cancel by phase — is an almost-periodic/Diophantine problem, and a uniform
bound would need control of the zero set far beyond what the programme has.

**The fork.**

1. **Prove a strict maximal-`|δ|` zero.**  This is a strong structural statement
   about ζ, not known; it is not implied by the zero-free line, and if RH fails
   it is plausible that the off-line zeros accumulate without a strict
   maximiser.
2. **Develop a phase-selection argument.**  Choose `c` so that the larger-`|δ|`
   contributions cancel.  This is hard and no such argument is in the
   programme.
3. **Return to the arithmetic side.**  The explicit formula turns the full
   zero-side entry into pole + prime + archimedean terms; the obstruction then
   becomes a prime-sum estimate in a Gaussian window, which is the classical
   route.  It does not need a maximal off-line zero.

The first is not affordable with the current programme, the second has no
candidate, and the third is the only route that does not rest on an unproved
structural assumption.  The next investment should be the arithmetic-side
estimate, not `FullBlockWithin`.

## The arithmetic side — first round

The classical route (Weil's criterion) evaluates the Weil form on the
arithmetic side: the explicit formula writes the zero-side entry as
pole + prime + archimedean.  This round checks the prime-sum structure that
the estimate has to control.

**The prime sum and its main term.**  For the Gaussian test, the prime
contribution is

`P(c,σ) = Σ_n Λ(n) n^{−1/2} h_c(log n)`,  `h_c(u) = √π σ exp(−(u−c)²/(4σ²))`.

A smooth-weight PNT (`dψ(x) ≈ dx`) gives the main term

`P_main(c,σ) = ∫ e^{u/2} h_c(u) du = 2πσ² exp(σ²/4) exp(c/2)`.

This is exactly the growing half of the pole term
`H_c(0) + H_c(1) = 4πσ² exp(σ²/4) cosh(c/2)`:

`pole(c) − P_main(c,σ) = 2πσ² exp(σ²/4) exp(−c/2)`.

So the exponential growth of the pole is matched by the prime main term; the
residual is the PNT error plus the `e^{−c/2}` half-pole and the archimedean
term.

**C14.**  For `σ = 0.2`, `P/P_main` at `c = 10` is `1.000004`; for
`σ = 0.05` it is `1.013`.  The narrow-window regime is much less accurate:
the Gaussian window in `n` has width `e^{8σ}`, so small `σ` is exactly where
the smooth-weight PNT error is significant.  This is the same `σ = 0.05`
regime as the O4 certificate.

**The exact Gram-entry identity.**  The main term identity is even stronger
than a leading-order statement: for every `c`,

`pole(c) = P_main(c) + P_main(−c)`,

because `P_main(±c) = 2πσ² exp(σ²/4) exp(±c/2)` and
`4πσ² exp(σ²/4) cosh(c/2)` is their sum.  Hence the symmetrised arithmetic
Gram entry is

`K(c) = [P_main(c) − P(c)] + [P_main(−c) − P(−c)] + arch(c)`.

The pole term cancels **exactly**, and the entry is the sum of the two
Gaussian-window PNT errors plus the archimedean term.  C15 checks this to
`1e−12`.  This is the precise form of "the arithmetic side is a prime-sum
estimate": the object to bound is the PNT error in the two windows `±c`, plus
`arch(c)`.

**The cancellation (C16).**  The two pieces are individually indefinite.  At
`σ = 0.05` on the four-centre family, the PNT-error Gram has
`λ_min ≈ −0.0097` and the archimedean Gram has `λ_min ≈ −0.0946`, while their
sum has `λ_min ≈ +0.0227`.  So the arithmetic-side positivity is a
**cancellation** between the prime-window error and the archimedean term, not
a termwise positivity.  The estimate must control the joint sum, not the PNT
error alone.

**What the estimate must deliver.**  A uniform smooth-weight PNT with an
explicit error term for the Gaussian window, plus a bound on the archimedean
term, such that the residual is controlled.  This is the "prime-sum estimate"
of the classical route.  It does not by itself prove positivity: the prime sum
is a signed quadratic form in the test function (the autocorrelation `g * g̃`
changes sign), and the archimedean term is signed.  The residual's sign is
Weil positivity.

**Verdict.**  The arithmetic side is a genuine route, and the main-term
cancellation is exact.  The identity `pole(c) = P_main(c) + P_main(−c)` and the
residual form `pole − (P_c + P_{−c}) = (P_main(c) − P_c) + (P_main(−c) − P_{−c})`
are now Lean-proved (T21–T22), together with their identification with the hub's
`Re H_c(0)`, `Re H_c(1)` and `Re (H_c(0)+H_c(1))` (T23–T25).  The hard part is the narrow-window PNT error at small
`σ`.  The full Gram-matrix criterion is stated in T18–T20, the residual is written
as a PNT error plus the archimedean term in T26, the smooth main term is
evaluated as a Gaussian integral in T36–T37, and the sign has been tested on a
family at `σ = 0.05` (C16–C17).  The next concrete step is the remaining
analytic one: a uniform smooth-window PNT error bound, jointly with the
archimedean term, at small `σ`.

## Full Weil positivity — the finite statement

The hub's `WeilPositivity` is the on-line kernel identity; the object of the
classical criterion is the **full zero-side Gram matrix** over all zeros.  The
finite version is now formalised.

**The definition.**  `FiniteWeilPositivity` says: for every finite set `S` of
nontrivial zeros, every finite family of centres `a`, and every width `σ`, the
real part of the Gram matrix

`G_{ij} = Σ_{ρ ∈ S} H_{a_i − a_j}(ρ)`

is positive semidefinite.

**T18–T20.**

- `realRankOne_posSemidef` — a real rank-one matrix `u uᵀ` is PSD.
- `finiteWeilGramReal_posSemidef_of_onLine` — if every `ρ ∈ S` has
  `Re ρ = 1/2`, the finite Gram matrix is PSD.  Each on-line zero contributes
  `Re(v_i conj v_j) = Re v_i Re v_j + Im v_i Im v_j`, a sum of two real
  rank-one matrices.
- `rh_implies_finiteWeilPositivity` — RH implies `FiniteWeilPositivity`.

This is the **easy direction of Weil's criterion**, and it is non-vacuous: the
hypothesis is satisfiable (RH is the intended case), unlike the hub's
`OffLineBlockPSD` antecedent, which is refuted by `not_offLineBlockPSD_of_offLine`.

**The hard direction.**  `FiniteWeilPositivity → RH` — and its infinite/cone
version — is the nontrivial half of the classical criterion.  It is open (O4).
The maximal-`|δ|` analysis shows that the zero-side domination route to it has
an unproven precondition; the classical route uses the arithmetic side and the
explicit formula, as recommended in the section above.

**What this fixes.**  The hub's `no_offLine_of_all_blocks_psd` was vacuous;
`rh_implies_finiteWeilPositivity` is the correct formal counterpart of the easy
direction.  The dossier now has both directions named, with the easy one proved
and the hard one open.

## Exhaustion verdict

At this point every non-RH-strength route in the dossier has been either
proved, reduced, or closed as unsupported.

**Closed or reduced.**

- **O1** (manifest sum of squares for the prime side): RH restated, no slack;
  the prime kernel is indefinite (C7).
- **O2** (positivity-preserving deformation): linear and interpolation versions
  are equivalent to positivity (T12); the σ-flow is not monotone (T13–T16,
  C10); the heat flow is blocked by Rodgers–Tao.
- **O3** (weaker satisfiable statement): the finite uniform-gap route is
  unsupported (C11); only the dense-subcone/continuity shape remains, which
  needs a uniform bound.
- **Zero-side domination** (`FullBlockWithin`): requires a strict
  maximal-`|δ|` zero (T17); no such zero is known.
- **APM**: restates tails as radii; does not retire the tail bound; the zero
  sum is open in its own audit.
- **Arithmetic side**: the pole cancels exactly against the two Gaussian-window
  prime main terms (C15); the PNT error and the archimedean term are
  individually indefinite and their sum is positive (C16).  The cancellation
  persists under refinement, but the gap collapses (C17), matching C11.
- **Full Weil positivity, easy direction**: RH ⇒ `FiniteWeilPositivity` is
  Lean-proved (T20).

**What remains is RH-strength.**

1. **O4 — the hard direction of Weil's criterion.**  `FiniteWeilPositivity → RH`
   (and its infinite/cone version) is the classical hard half; it is not
   provable by the elementary means in this dossier.
2. **A uniform arithmetic estimate.**  A bound on the joint PNT-error +
   archimedean sum that does not collapse as the family grows.  C17 shows the
   finite-family gap collapsing, so this is a genuine analytic input, not a
   bookkeeping gap.
3. **A strict maximal-`|δ|` zero** (or a phase-selection argument replacing it),
   if the zero-side route is to be revived.

**Verdict.**  The missing-bridge investigation is exhausted at the
non-RH-strength level: every cheap mechanism has been tested, and each either
fails or reduces to the original problem.  The dossier should be read as a
map of the wall, not as a proof of RH.  The O4 hard direction is now proved
(T57) for the finite Gaussian zero-side Gram matrix; the remaining open problem
is `FiniteWeilPositivity` itself, equivalently RH, on the arithmetic side.

## Objects and notation

| Object | Definition |
|---|---|
| `H_c` | the Gaussian zero-side test `H_c(s) = 2πσ² exp(σ²(s−1/2)²) exp(−c(s−1/2))` |
| `φ_a` | the critical-line mode `φ_a(t) = σ√(2π) exp(−σ²t²/2) exp(−iat)` |
| `onLineQuad a σ γ c` | `Σ_ij c_i c_j · 2πσ² exp(−σ²γ²) cos((a_i − a_j)γ)` |
| `offLineQuad c σ δ γ` | the symmetrised contribution of the quadruple `{ρ, 1−ρ, \bar ρ, 1−\bar ρ}`, `ρ = 1/2+δ+iγ` |
| `Ω(t)` | the archimedean density `Re ψ(1/4+it/2) − log π` |
| `Λ(n)` | the von Mangoldt function, `log p` on prime powers and `0` otherwise |
| `gramMargin`, `gramCentre4` | the rational O4 margin `227/10000` and 4×4 centre |

## Ledger

| ID | Kind | Statement | Lean / test |
|---|---|---|---|
| T1 | Theorem | The on-line Gaussian quadratic form is the squared cosine mode plus the squared sine mode. | `onLineQuad_eq_sum_sq` |
| T2 | Theorem | The on-line form is nonnegative. | `onLineQuad_nonneg` |
| T3 | Theorem | An off-line quadruple has a separation whose isolated block is not PSD. | `offLineBlock_not_psd` |
| T4 | Theorem | Uniform block positivity fails for every off-line quadruple. | `not_all_offLine_blocks_psd` |
| T5 | Theorem | The off-line contribution is unbounded in the separation. | `offLine_growth` |
| T6 | Theorem | The PSD cone is convex: `t•A + (1−t)•B` is PSD for `t ∈ [0,1]`. | `posSemidef_convexCombination` |
| T7 | Theorem | A nonnegative one-parameter deformation of a PSD matrix is PSD. | `posSemidef_add_smul` |
| T8 | Theorem | Entrywise margin transfer: `ε·n < t` plus `ε`-closeness to `C` and `C − t·I` positive definite implies `G` positive definite. | `strict_margin_transfer` |
| T9 | Theorem | The rational 4×4 Gaussian centre minus its margin is positive definite. | `centre_sub_margin_posDef` |
| T10 | Theorem | The rational 4×4 Gaussian centre is positive definite, so the margin statement is satisfiable. | `centre_certificate_satisfiable` |
| T11 | Theorem | Congruence `A ↦ S A Sᵀ` preserves positive semidefiniteness for every real `S`. | `posSemidef_sandwich` |
| T12 | Theorem | `A + t•B` is PSD for every `t ≥ 0` iff `A` and `B` are both PSD. | `linear_path_posSemidef_iff` |
| T13 | Theorem | The on-line Gaussian weight has derivative `4πσ exp(−σ²γ²)(1 − σ²γ²)`. | `hasDerivAt_gaussianWeight` |
| T14 | Theorem | That derivative is positive at `σ = 1/(2γ)`. | `gaussianWeight_deriv_pos` |
| T15 | Theorem | That derivative is negative at `σ = 2/γ`. | `gaussianWeight_deriv_neg` |
| T16 | Theorem | The on-line Gaussian weight is neither monotone nor antitone in σ. | `gaussianWeight_not_monotone` |
| T17 | Theorem | If the "other" block contains an off-line quadruple, no uniform `B` bounds its entries for all separations. | `no_uniform_bound_of_offLine_quadruple` |
| T18 | Theorem | A real rank-one matrix `u uᵀ` is PSD. | `realRankOne_posSemidef` |
| T19 | Theorem | If every zero in `S` is on the critical line, the real part of the finite zero-side Gram matrix is PSD. | `finiteWeilGramReal_posSemidef_of_onLine` |
| T20 | Theorem | RH implies `FiniteWeilPositivity`. | `rh_implies_finiteWeilPositivity` |
| T21 | Theorem | `pole(c) = P_main(c) + P_main(−c)` for the Gaussian prime main term. | `poleTerm_eq_primeMainTerm_add` |
| T22 | Theorem | The symmetrised arithmetic entry is exactly the sum of the two PNT errors. | `poleTerm_sub_primeSums_eq` |
| T23 | Theorem | `P_main(c)` is the real part of `H_c(0)`. | `primeMainTerm_eq_re_gaussianZeroTest_zero` |
| T24 | Theorem | `P_main(−c)` is the real part of `H_c(1)`. | `primeMainTerm_neg_eq_re_gaussianZeroTest_one` |
| T25 | Theorem | `pole(c)` is the real part of `H_c(0) + H_c(1)`. | `poleTerm_eq_re_gaussianZeroTest_pole_sum` |
| T26 | Theorem | The full arithmetic residual is the two PNT errors plus the archimedean term. | `arithmeticResidual_eq` |
| T27 | Theorem | The Gaussian window `h_c(u)` is positive for positive width. | `primeWindow_pos` |
| T28 | Theorem | The truncated prime side is a manifest sum of nonnegative terms. | `gaussianPrimeSide_nonneg` |
| T29 | Theorem | Each summand of the truncated prime side is nonnegative. | `gaussianPrimeSide_term_nonneg` |
| T30 | Theorem | The truncated prime side is monotone in the truncation. | `gaussianPrimeSide_mono` |
| T31 | Theorem | The Gaussian window is symmetric under `(c,u) ↦ (−c,−u)`. | `primeWindow_neg_neg` |
| T32 | Theorem | The prime main term is positive for `σ > 0`. | `primeMainTerm_pos` |
| T33 | Theorem | The pole term is positive for `σ > 0`. | `poleTerm_pos` |
| T34 | Theorem | The pole term is even in the centre: `pole(−c) = pole(c)`. | `poleTerm_neg` |
| T35 | Theorem | The completing-the-square identity for the Gaussian exponent. | `exp_quadratic_re` |
| T36 | Theorem | `∫ e^{u/2} h_c(u) du = P_main(c,σ)`: the smooth main term is the Gaussian integral. | `integral_exp_half_primeWindow` |
| T37 | Theorem | The pole term is the sum of the two Gaussian main-term integrals. | `poleTerm_eq_integral_add` |
| T38 | Theorem | The arithmetic residual kernel is even when the archimedean term is even. | `arithmeticResidualKernel_neg` |
| T39 | Theorem | The arithmetic Gram matrix is symmetric when the archimedean term is even. | `arithmeticGramMatrix_isSymm` |
| T40 | Theorem | The Gaussian prime window has total mass `2πσ²`, independent of `c`. | `integral_primeWindow` |
| T41 | Theorem | The Gaussian prime side is at most `√π σ` times the total von Mangoldt mass. | `gaussianPrimeSide_le_mul_sum_vonMangoldt` |
| T42 | Theorem | The Gaussian prime side is at most `√π σ · log(N!)`. | `gaussianPrimeSide_le_mul_log_factorial` |
| T43 | Theorem | The arithmetic residual is bounded by the two PNT errors plus the archimedean bound. | `arithmeticResidual_abs_le` |
| T44 | Theorem | Under the named `SmoothWindowPNTError` input, the arithmetic residual is bounded by `2E + A`. | `SmoothWindowPNTError`, `arithmeticResidual_abs_le_of_pnt` |
| T45 | Theorem | Single off-line zero real part: `Re H_c(ρ) = 2πσ² e^{σ²(δ²−γ²)} e^{−cδ} cos(2σ²δγ − cγ)`. | `gaussianZeroTest_re_offLine` |
| T46 | Theorem | For `δ ≠ 0`, some `c` makes `|Re H_c(ρ)| > Re H_0(ρ)`. | `exists_gaussianZeroTest_re_gt_offLine` |
| T47 | Theorem | For `δ ≠ 0`, `γ ≠ 0`, some `c` makes `Re H_{−c}(ρ) ≠ Re H_c(ρ)` (singleton Gram asymmetry). | `exists_gaussianZeroTest_re_ne_neg` |
| T48 | Theorem | Singleton Gram matrix `finiteWeilGramReal ![0,c] σ {ρ}` in explicit 2×2 form. | `finiteWeilGramReal_singleton` |
| T49 | Theorem | A non-symmetric singleton block is not PSD. | `not_posSemidef_singleton_of_ne` |
| T50 | Theorem | **O4 (nonzero imaginary part):** an off-line zero with `im ≠ 0` makes `FiniteWeilPositivity` fail. | `not_finiteWeilPositivity_of_offLine_im_ne_zero` |
| T51 | Theorem | Real-line real part: `Re H_c(ρ) = 2πσ² e^{σ²(ρ−1/2)²} e^{−c(ρ−1/2)}` for real `ρ`. | `gaussianZeroTest_re_ofReal` |
| T52 | Theorem | Real-line real part at `1−ρ`: `Re H_c(1−ρ) = 2πσ² e^{σ²(ρ−1/2)²} e^{c(ρ−1/2)}`. | `gaussianZeroTest_re_one_sub_ofReal` |
| T53 | Theorem | Real-zero pair block: `finiteWeilGramReal ![0,1] σ {ρ,1−ρ}` is the `cosh` matrix. | `finiteWeilGramReal_pair` |
| T54 | Theorem | The real-zero pair block is not PSD. | `not_posSemidef_real_pair` |
| T55 | Theorem | A real off-line zero (`im = 0`) makes `FiniteWeilPositivity` fail. | `not_finiteWeilPositivity_of_real_offLine` |
| T56 | Theorem | **O4:** any off-line nontrivial zero makes `FiniteWeilPositivity` fail. | `not_finiteWeilPositivity_of_offLine` |
| T57 | Theorem | **`FiniteWeilPositivity → RH`** — the hard direction of the classical Weil criterion. | `finiteWeilPositivity_implies_RH` |
| T58 | Theorem | **Arithmetic-side interface:** `FiniteWeilPositivity` is the Hermitian plus nonnegative-quadratic-form statement (`weilQuadraticForm`). | `weilQuadraticForm`, `finiteWeilPositivity_iff_quadraticForm` |
| T59 | Theorem | The Weil quadratic form is the finite bilinear combination of the scalar zero-side sums. | `weilQuadraticForm_eq_sum_scalar` |
| T60 | Theorem | **Matrix assembly:** given the scalar explicit formula, the Weil quadratic form equals the arithmetic quadratic form. | `weilQuadraticForm_eq_arithmetic` |
| T61 | Theorem | **Gaussian rectangle identity:** the library's explicit formula specialised to the Gaussian test, discharging T45's `hcontour` (under the standard hypotheses, including zero simplicity). | `gaussianRectangleIdentity` |
| T62 | Theorem | The symmetrised arithmetic residual is invariant under `c ↦ −c`. | `arithmeticResidual_symm` |
| T63 | Theorem | The symmetrised arithmetic residual is even in `c`, so the arithmetic Gram matrix is Hermitian. | `arithmeticResidual_even` |
| T64 | Theorem | **Scalar Weil inequality:** `FiniteWeilPositivity` implies `0 ≤ ∑_{ρ∈S} Re H_0(ρ)` for every finite zero set. | `finiteWeilPositivity_scalar_nonneg` |
| T65 | Theorem | **Exact 2×2 PSD criterion:** `!![a,b;b,a]` is PSD iff `0 ≤ a` and `|b| ≤ a`. | `twoByTwo_posSemidef_iff` |
| T66 | Theorem | General 2×2 criterion: `!![a,b;c,a]` is PSD iff `b = c`, `0 ≤ a`, `|b| ≤ a`. | `twoByTwo_general_posSemidef_iff` |
| T67 | Theorem | **Singleton characterisation:** the singleton zero block is PSD iff the off-diagonals agree and the scalar 2×2 criterion holds. | `singleton_block_posSemidef_iff` |
| T68 | Theorem | `FiniteWeilPositivity` forces the singleton criterion at every nontrivial zero, in particular `Re H_{−c}(ρ) = Re H_c(ρ)`. | `finiteWeilPositivity_singleton` |
| T69 | Theorem | Gaussian rectangle identity with the zero set specified as "all zeros in `U`" (no opaque `hF_ne`). | `gaussianRectangleIdentity_of_allZeros` |
| T70 | Theorem | **The arithmetic Gram matrix is Hermitian** (the symmetrised residual is even). | `arithmeticResidual_isHermitian` |
| T71 | Theorem | **Pole-cancelled decomposition of the arithmetic quadratic form**: it equals the two PNT-error quadratic forms plus the archimedean quadratic form. | `arithmeticQuadraticForm`, `arithmeticQuadraticForm_eq_pnt_add_arch` |
| T72 | Theorem | **PNT-error quadratic-form bound:** `‖Q_PNT‖ ≤ E·(∑|xᵢ|)²` under `SmoothWindowPNTError`. | `abs_pntQuadraticForm_le` |
| T73 | Theorem | Function-valued residual and quadratic form; pole-cancelled decomposition with `arch : ℝ → ℝ`. | `arithmeticResidualFun`, `arithmeticQuadraticFormFun`, `arithmeticQuadraticFormFun_eq_pnt_add_arch` |
| T74 | Theorem | The two PNT-error forms are equal, so `Q_arith = 2·Q_PNT + Q_arch`. | `arithmeticQuadraticFormFun_eq_two_pnt_add_arch` |
| T75 | Theorem | **Conditional nonnegativity:** if `Q_arch` dominates `2E(∑|xᵢ|)²`, the arithmetic quadratic form is nonnegative. | `arithmeticQuadraticFormFun_nonneg_of_dominates` |
| T76 | Theorem | The function-valued residual is even for an even archimedean kernel. | `arithmeticResidualFun_even` |
| T77 | Theorem | The arithmetic quadratic form is the matrix quadratic form of the arithmetic Gram matrix. | `arithmeticQuadraticFormFun_eq_dotProduct` |
| T78 | Theorem | **Arithmetic matrix PSD under archimedean dominance.** | `arithmeticMatrix_posSemidef_of_dominates` |
| T79 | Theorem | **Capstone reduction:** `FiniteWeilPositivity` follows from the scalar explicit formula plus PSD of the arithmetic Gram matrix. | `finiteWeilPositivity_of_arithmetic` |
| T80 | Theorem | `weilOmega` is even on the real axis. | `weilOmega_real_even` |
| T81 | Theorem | The archimedean symbol is even on the real axis. | `archSymbol_real_even` |
| T82 | Theorem | **End-to-end conditional:** `FiniteWeilPositivity` from even archimedean kernel + PNT bound + archimedean dominance + scalar explicit formula. | `finiteWeilPositivity_of_pnt_archimedean` |
| T83 | Theorem | **Conditional RH:** the same four inputs imply `RiemannHypothesis` (via T57). Not an unconditional proof. | `riemannHypothesis_of_pnt_archimedean` |
| T84 | Theorem | `densityTerm` (the archimedean density term of `prime-spectrum-tensor`) is even in `c`. | `densityTerm_even` |
| T85 | Theorem | The `prime-spectrum-tensor` pole term is even in `c`. | `poleTerm_ps_even` |
| T86 | Theorem | **Bridge:** `gaussianGramEntry c 0 σ` equals `arithmeticResidualFun` with `P = −primeTerm/2` and `arch = densityTerm`. | `gaussianGramEntry_eq_residual` |
| T87 | Theorem | **Exact 4×4 identification:** `gaussianGram4 σ` is the arithmetic residual matrix on the `centre4` separations. | `gaussianGram4_eq_arithmetic` |
| T88 | Theorem | The Gaussian prime term is non-positive for `σ ≥ 0`. | `primeTerm_nonpos` |
| T89 | Theorem | The Gaussian pole term is positive for `σ > 0`. | `poleTerm_ps_pos` |
| T90 | Theorem | **Three-term split** of the Gaussian Gram entry: `pole + density + (prime c + prime(−c))/2`. | `gaussianGramEntry_three_term` |
| T91 | Theorem | **Three-matrix decomposition:** `gaussianGram4 = poleMatrix + densityMatrix + primeMatrix`. | `gaussianGram4_eq_pole_add_density_add_prime` |
| T92 | Theorem | `gaussianGram4` is Hermitian in the arithmetic framework. | `gaussianGram4_isHermitian` |
| T93 | Theorem | The `prime-spectrum-tensor` 4×4 certificate as PSD: `(gaussianGram4 (1/20)).PosSemidef`. | `gaussianGram4_posSemidef` |
| T94 | Theorem | **Certified 4×4 instance in this framework:** the exact arithmetic residual matrix on `centre4` at `σ = 1/20` is PSD. | `centre4Arithmetic_posSemidef` |
| T95 | Theorem | `gaussianGram5` is the arithmetic residual matrix on the five centres. | `gaussianGram5_eq_arithmetic` |
| T96 | Theorem | The `prime-spectrum-tensor` 5×5 certificate as PSD. | `gaussianGram5_posSemidef` |
| T97 | Theorem | **Certified 5×5 instance:** the arithmetic residual matrix on `centre5` at `σ = 1/20` is PSD. | `centre5Arithmetic_posSemidef` |
| T98 | Theorem | **General Gaussian Gram structure:** for any finite centre family, the matrix is the sum of the pole, density and prime matrices. | `gaussianGramMatrix_eq_pole_add_density_add_prime` |
| T99 | Theorem | The general Gaussian Gram matrix is Hermitian. | `gaussianGramMatrix_isHermitian` |
| T100 | Theorem | The explicit three-term Gaussian quadratic form is non-negative at the five centres. | `gaussianGram5_quadraticForm_nonneg` |
| T101 | Theorem | Every principal submatrix of the 5×5 Gaussian Gram matrix is PSD. | `gaussianGram5_submatrix_posSemidef` |
| T102 | Theorem | **Translation invariance:** the Gaussian Gram matrix depends only on centre differences. | `gaussianGramMatrix_translate` |
| T103 | Theorem | Every translate of the certified 5-centre family is PSD. | `gaussianGram5_translate_posSemidef` |
| T104 | Theorem | **Reflection invariance** of the Gaussian Gram matrix. | `gaussianGramMatrix_reflect` |
| T105 | Theorem | Every reflection of the certified 5-centre family is PSD. | `gaussianGram5_reflect_posSemidef` |
| T106 | Theorem | Every translate of the certified 4-centre family is PSD. | `gaussianGram4_translate_posSemidef` |
| T107 | Theorem | Every reflection of the certified 4-centre family is PSD. | `gaussianGram4_reflect_posSemidef` |
| T108 | Theorem | The density term at `c = 0`, `σ = 1/20` is positive (concrete band). | `densityTerm_pos_at_zero` |
| T109 | Theorem | The density term at `c = 1/5` is negative. | `densityTerm_neg_at_fifth` |
| T110 | Theorem | The density term at `c = 2/5` is negative. | `densityTerm_neg_at_two_fifths` |
| T111 | Theorem | The density term at `c = 3/5` is negative. | `densityTerm_neg_at_three_fifths` |
| T112 | Theorem | The explicit three-term quadratic form is non-negative at the four centres. | `gaussianGram4_quadraticForm_nonneg` |
| T113 | Theorem | The density term at `c = 4/5` is negative. | `densityTerm_neg_at_four_fifths` |
| T114 | Theorem | **Bridge, quadratic-form form:** under the Gaussian explicit formula, the zero-side quadratic form equals the Gaussian-Gram quadratic form. | `weilQuadraticForm_eq_gaussianGram` |
| T115 | Theorem | **Packaged equivalence:** `FiniteWeilPositivity ↔ RH` (T20 + T57). | `finiteWeilPositivity_iff_RH` |
| T116 | Theorem | **Bridge, positivity form:** the Gaussian explicit formula plus PSD of the Gaussian Gram matrix imply `FiniteWeilPositivity`. | `finiteWeilPositivity_of_gaussianGram` |
| T117 | Theorem | **Bridge, RH form:** the same two inputs imply RH. Conditional; not an unconditional proof. | `riemannHypothesis_of_gaussianGram` |
| T118 | Theorem | **T86, three-term form:** `gaussianGramEntry a b σ = pole a−b + density a−b + primeTermSym a−b`. | `gaussianGramEntry_eq_pole_add_density_add_primeSym` |
| T119 | Theorem | **Bridge with named inputs:** `GaussianExplicitFormula` + `GaussianGramPSD` imply `FiniteWeilPositivity`. | `finiteWeilPositivity_of_gaussianInputs` |
| T120 | Theorem | **Bridge with named inputs, RH form:** the same two named inputs imply RH. Conditional. | `riemannHypothesis_of_gaussianInputs` |
| T121 | Theorem | **Correctness audit:** the finite-`S` formula (T79/T116 hypothesis) forces `g ≡ 0`, hence is **vacuous** as a bridge input. | `finiteFormula_forces_zero` |
| T122 | Theorem | The real-matrix quadratic form is continuous in the matrix. | `continuous_matrix_quadraticForm` |
| T123 | Theorem | **PSD is a closed condition** (a pointwise limit of PSD real matrices is PSD). | `isClosed_setOf_posSemidef` |
| T124 | Theorem | PSD passes to limits. | `posSemidef_of_tendsto` |
| T125 | Theorem | **Corrected bridge:** `FiniteWeilPositivity` + `GaussianExplicitFormulaInfinite` imply `GaussianGramPSD`. | `gaussianGramPSD_of_finiteWeilPositivity` |
| T126 | Theorem | Under the infinite explicit formula, RH implies `GaussianGramPSD` (corrected necessary direction). | `gaussianGramPSD_of_RH` |
| T127 | Theorem | **Packaged Gaussian bridge:** under the infinite formula, the equivalence plus both `GaussianGramPSD` implications. | `gaussianBridge_summary` |
| T128 | Theorem | **Assembly algebra:** from the assembled explicit formula, `Zsum = H_c(0) + H_c(1) − (ArchR+PrimeR+ArchL+PrimeL)/(2π)`. | `gaussianZeroSum_eq` |
| T129 | Theorem | **Assembly, real form:** with the vertical-limit identification, `Re Zsum = gaussianGramEntry c 0 σ`. | `gaussianZeroSum_re_eq_gram` |
| T130 | Theorem | **From assembly data to the infinite formula:** `GaussianZeroSumAssembly` implies `GaussianExplicitFormulaInfinite`. | `gaussianExplicitFormulaInfinite_of_assembly` |
| O4 | Open | **The zero-side `HasSum` is not proved in the repository.** `GaussianZeroSumAssembly` bundles three things: the contour identity, `VerticalLimitIdentification`, and `HasSum (fun ρ ↦ (H_c ρ).re) Zsum.re` over the nontrivial zeros. The third — the convergence of the zero sum — appears only inside the hypothesis; no theorem in the 60 topics establishes it. The second reduces to the archimedean evaluation (now proved in `archimedean-prime-evaluation`, T25) plus the prime evaluation (open, O3). The first is the contour algebra of T128. | — |
| T131 | Theorem | **Right vertical side:** the `Re s = 2` integral of `(ζ̂′/ζ̂)·H_c` equals `−(archRight + primeRight)`. | `right_integral_eq` |
| T132 | Theorem | **Right vertical limit** from convergence of the archimedean and prime halves. | `tendsto_right` |
| T133 | Theorem | **Left vertical limit** from the reflected test `H_{−c}` (functional equation). | `tendsto_left` |
| T134 | Theorem | **End-to-end assembly with concrete vertical limits:** contour identity + horizontal limits + zero-sum convergence + arch/prime convergence + identification imply `Re Zsum = gaussianGramEntry c 0 σ`. | `gaussianZeroSum_re_eq_gram_of_vertical` |
| T135 | Theorem | **Cofinal-chain lemma:** a summable family has unconditional sum `z` if its sums over a monotone cofinal chain converge to `z`. | `hasSum_of_cofinal` |
| T136 | Theorem | **Enumeration reduction:** `GaussianExplicitFormulaInfinite` follows from the enumeration data (cofinal sequence, absolute summability, chain limit, value). | `gaussianExplicitFormulaInfinite_of_enumeration` |
| T137 | Theorem | **Identification decomposition:** separate archimedean and prime identifications imply the combined vertical-limit identification. | `verticalLimitIdentification_of_limits` |
| T138 | Theorem | **Strip norm bound:** on `0 < Re ρ < 1`, `‖H_c(ρ)‖ ≤ (2πσ²e^{σ²/4}·M_c)·e^{−σ²(Im ρ)²}`. | `gaussianZeroTest_norm_le_strip` |
| T139 | Theorem | **Absolute summability from zero counting:** a zero enumeration with `|γ_n| ≥ c₀ n/log n` makes the Gaussian zero sum absolutely summable. | `summable_gaussianZeroSum_of_enumeration` |
| T140 | Theorem | **Evaluations imply the identification:** `ArchimedeanEvaluation` + `PrimeEvaluation` ⟹ `VerticalLimitIdentification`. | `verticalLimitIdentification_of_evaluations` |
| T141 | Theorem | **Exponential summability over the zeros** from the linear growth of `ξ₀` and an enumeration. | `summable_exp_im_sq_of_xi₀_growth` |
| T142 | Theorem | **Absolute summability of the Gaussian zero sum** from the linear growth of `ξ₀` and an enumeration. | `summable_gaussianZeroSum_of_xi₀_growth` |
| C1 | Computation | The on-line form equals its cosine/sine sum of squares and is nonnegative. | `tests/test_programme.py` |
| C2 | Computation | The rank-one factorization holds on the critical line and fails off it. | `tests/test_programme.py` |
| C3 | Computation | The prime contribution is a sum of nonnegative terms, while `Ω` and the assembled entry take both signs. | `tests/test_programme.py` |
| C4 | Computation | An off-line block acquires a negative eigenvalue at large separation. | `tests/test_programme.py` |
| C5 | Computation | The admissible entrywise margin decays like `margin/n`. | `tests/test_programme.py` |
| C6 | Computation | Convex combinations of PSD symmetric diagonal blocks stay PSD. | `tests/test_programme.py` |
| C7 | Computation | The symmetrised prime kernel has negative eigenvalues although every von Mangoldt coefficient is nonnegative. | `tests/test_programme.py` |
| C8 | Computation | A positivity-preserving congruence lowers the least eigenvalue (from 1 to about 0.349, and to 0 in the degenerate case). | `tests/test_programme.py` |
| C9 | Computation | A linear path with an indefinite velocity crosses zero (`λ_min = 1 − t`); with a PSD velocity it does not. | `tests/test_programme.py` |
| C10 | Computation | `dλ_min/dσ` for the 4×4 arithmetic Gram changes sign (`+0.196` at σ = 0.02, `−0.258` at σ = 0.03). | `tests/test_programme.py` |
| C11 | Computation | The Toeplitz gap on `[−0.3, 0.3]` collapses: `λ_min` falls from `2.27e−2` at n=4 to `2.38e−6` at n=16 and is at the noise floor by n=32. | `tests/test_programme.py` |
| C12 | Computation | The annular tail radius is closed-form for a geometric series and a Hurwitz zeta for a p-series; positive on-line weights give a signed Gram entry. | `tests/test_programme.py` |
| C13 | Computation | A larger-`|δ|` quadruple dominates: the maximum of `|S(c)|` over `c ∈ [0,40]` is `1.04` at `|δ| = 0.1` and `30.4` at `|δ| = 0.2`. | `tests/test_programme.py` |
| C14 | Computation | The smooth PNT main term `2πσ² exp(σ²/4) exp(c/2)` is the growing half of the pole; `pole − P_main = 2πσ² exp(σ²/4) exp(−c/2)`, and the narrow-window PNT error is the hard regime. | `tests/test_programme.py` |
| C15 | Computation | The exact Gram-entry identity: `pole = P_main(c) + P_main(−c)`, hence `K(c) = (P_main − P)(c) + (P_main − P)(−c) + arch(c)`. | `tests/test_programme.py` |
| C16 | Computation | The PNT-error Gram and the archimedean Gram are individually indefinite (`λ_min ≈ −0.0097` and `−0.0946`) while their sum is PSD (`λ_min ≈ +0.0227`) at σ = 0.05. | `tests/test_programme.py` |
| C17 | Computation | The cancellation persists under refinement (`n = 4, 8, 16`), but the total gap collapses (`2.27e−2`, `2.74e−5`, `2.38e−6`). | `tests/test_programme.py` |
| C18 | Computation | The pole/main identity holds numerically to `1e−10` across `σ` and `c`. | `tests/test_programme.py` |
| O1 | Open | **Objective 1**: a manifest sum of squares for the prime side extending the rank-one factorization off the critical line. | not proved |
| O2 | Open | **Objective 2**: a positivity-preserving deformation/continuation of the Weil form. | not proved |
| O3 | Open | **Objective 3**: a genuinely weaker, satisfiable statement implying positivity and independently provable. | not proved |
| O4 | Theorem | **The hard direction of Weil's criterion**: `FiniteWeilPositivity → RH` for the finite zero-side Gram matrix (Gaussian-window test family). | `finiteWeilPositivity_implies_RH` (T57) |

## O4 audit

The formal chain T57 was audited against the intended classical statement.

- **Statement match.**  `finiteWeilPositivity_implies_RH` has exactly the shape
  `FiniteWeilPositivity → RiemannHypothesis`, with `RiemannHypothesis` being
  `∀ s, completedZeta s = 0 → 0 < s.re → s.re < 1 → s.re = 1/2`.  No
  extra hypotheses, no `sorry`, no `axiom`.
- **Scope caveat.**  `FiniteWeilPositivity` is the **finite, zero-side,
  Gaussian-window** form: it quantifies over all finite sets of nontrivial zeros
  and all real Gaussian separations/widths, and uses only
  `finiteWeilGramReal`.  It does **not** quantify over arbitrary test functions
  and contains no archimedean or prime terms.  T57 is therefore the hard
  direction for a *restricted* (Gaussian) test family — a strengthening of the
  full criterion's implication, not the full arbitrary-test-function statement.
  The full classical criterion and the infinite/cone versions remain outside
  this formalisation.
- **Real-zero case (T53–T55).**  The pair is `{ρ, 1−ρ}` with `0 < ρ < 1`,
  `ρ ≠ 1/2`; `1−ρ` is a zero by `completedZeta_one_sub`, whose hypotheses
  (`ρ ≠ 0`, `ρ ≠ 1`, `Γℝ ρ ≠ 0`, `Γℝ (1−ρ) ≠ 0`) all follow from
  `0 < ρ < 1` via `Gammaℝ_ne_zero_of_re_pos`.  The Gram matrix is the
  `cosh` block and is non-PSD by `twoByTwo_not_posSemidef`.  The hypotheses are
  the intended ones.
- **Non-real case (T50).**  Uses the singleton `{ρ}` and the asymmetry
  `Re H_{−c}(ρ) ≠ Re H_c(ρ)` (T47), so the block is non-Hermitian and hence not
  PSD.  Sound.
- **Remaining open direction.**  Prove `FiniteWeilPositivity` itself
  (equivalently RH) on the arithmetic side; this is RH-strength and is not
  attempted here.

## Remaining inputs for the arithmetic side

The reduction chain is complete and mechanical; the open content is now exactly
the following four inputs.  None is proved.

1. **Zero simplicity (`hF_simple`).**  `test_function_explicit_formula` and its
   Gaussian specialisation `gaussianRectangleIdentity` (T61) require
   `deriv (s(s−1)Λ(s)) ρ ≠ 0` at every zero in the rectangle.  The divisor-based
   variants (`rectIntegral_logDeriv_completedZeta_eq_divisor_sum_derived`,
   `explicit_formula_h1_symmetric_divisor`) count zeros **with multiplicity**
   (`m w = divisor …`), whereas `FiniteWeilPositivity` sums over a Finset of
   distinct zeros; the residue of `Λ′/Λ` at a multiple zero is the multiplicity,
   so those variants give `∑ m_ρ h(ρ)`, not `∑ h(ρ)`.  Removing the hypothesis
   needs either simplicity (open) or a multiplicity-aware restatement of
   `FiniteWeilPositivity`.
2. **PNT** (`SmoothWindowPNTError`, T44).  `∀ c σ N, |primeMainTerm c σ −
   gaussianPrimeSide c σ N| ≤ E`.  Mathlib has Chebyshev-type `ψ` bounds but no
   PNT.
3. **The bridge is packaged (T114–T120), with named inputs.**  The two inputs are now first-class definitions:
   the **Gaussian explicit formula** `scalarZeroSide σ S c = gaussianGramEntry c 0 σ`
   (for nontrivial zeros in the critical strip), and **PSD of the Gaussian Gram
   matrix** `Matrix.of (fun i j => gaussianGramEntry (a i - a j) 0 σ)` for every
   finite family `a`, named `GaussianExplicitFormula` and `GaussianGramPSD`.
   T119 gives `FiniteWeilPositivity` from these; T120 gives RH; T115 is the
   packaged equivalence `FiniteWeilPositivity ↔ RH`; T118 is T86 in three-term
   form.  Neither input is archimedean dominance.  The finite-certificate ladder
   (`prime-spectrum-tensor` 4×4/5×5) is a *sample* of `GaussianGramPSD` and is
   not part of the bridge.

   **Correction (T121).**  The finite-`S` identity used by T79/T116 is vacuous:
   at `S = ∅` it forces the arithmetic side to be identically zero.  The
   genuine input is the infinite-sum identity
   `GaussianExplicitFormulaInfinite` (tsum over all nontrivial zeros in the
   strip).  T116/T119/T120 are therefore formally true but only conditional on
   a vacuous hypothesis; they are not usable bridge reductions.  Deriving
   `GaussianGramPSD` from `FiniteWeilPositivity` plus
   `GaussianExplicitFormulaInfinite` (now stated with `HasSum`, so it carries
   convergence) is the next formal task.  The analytic closure ingredient is
   now proved: T123/T124 show a pointwise limit of PSD real matrices is PSD, so
   only the entrywise `HasSum`-to-matrix-`Tendsto` step remained; it is now
   done (T125/T126): `FiniteWeilPositivity` + `GaussianExplicitFormulaInfinite`
   imply `GaussianGramPSD`, and RH implies `GaussianGramPSD` under the infinite
   formula.  The converse (`GaussianGramPSD` ⟹ `FiniteWeilPositivity`) needs a
   truncation-positivity input and is **not** available; the old finite-formula
   route (T116) is vacuous (T121).

   **Which direction is proved, which is open.**  Both implications between RH
   and `FiniteWeilPositivity` are Lean-proved (T20 and T57), so T115 is
   unconditional as an equivalence.  What is *not* proved is either input:
   `GaussianExplicitFormula` (open: needs the assembled explicit formula with
   zero simplicity / contour limits) and `GaussianGramPSD` (open: the genuine
   positivity, RH-strength).  Finite samples do not discharge
   `GaussianGramPSD`.

4. **The full three-term Gram positivity.**  The concrete archimedean kernel for
   the Gaussian family is `densityTerm c σ = σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt`
   with `Ω(t) = Re ψ(1/4+it/2) − log π` (`prime-spectrum-tensor`), and the bridge
   T86 identifies `gaussianGramEntry = arithmeticResidualFun` with
   `P = −primeTerm/2`, `arch = densityTerm`.  The density term is **negative**
   at small separations (`densityTerm 0 σ < 0` since Ω(0) ≈ −1.72), so the
   archimedean-dominance condition of T75/T78 is **not** the right final input;
   positivity is the full cancellation `Q_pole + Q_prime + Q_density ≥ 0`
   (matching `gaussianW = pole + density + prime`).  The existing
   `prime-spectrum-tensor` 4×4 certificate `gaussianGram4_posDef` is a verified
   instance.
4. **Contour limits.**  `HorizontalLogDerivBound` (weil-positivity T49) for the
   horizontal `logDeriv` growth, and the `hbottom`/`htop`/`hright`/`hleft` limits
   of the assembled formula.

With inputs 2–4 and the Hermitian half (T62/T63), the remaining obligation is
nonnegativity of the arithmetic quadratic form; with input 1 resolved, the
zero-side and arithmetic quadratic forms agree (T60/T61).

## Harvested proofs

From [`index-lean/index.md`](../index-lean/index.md).  The last column names
the objective the proof is useful for.

| Theorem | Where | Use | Objective |
|---|---|---|---|
| `paleyWiener_autocorrelation_nonneg` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | the autocorrelation transform is nonnegative: the prime-side template | 1 |
| `autocorrelation_exponential_eq_norm_sq` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | the autocorrelation transform is a squared modulus | 1 |
| `autocorrelation_transform_nonneg` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | packaged real form of the same nonnegativity | 1 |
| `paleyWiener_autocorrelation_eq_transform` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | identifies the critical-line value with the transform | 1 |
| `weil_zero_sum_nonneg_real_of_critical_line` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | the finite zero sum is nonnegative **under** the critical-line hypothesis | 1 |
| `vonMangoldt_nonneg` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | every von Mangoldt coefficient is nonnegative | 1 |
| `explicit_formula_gaussianZeroTest_arch_prime` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | the assembled explicit formula with prime and archimedean sides | 1 |
| `gaussianZeroTest_eq_mode_mul` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | the on-line rank-one factorization | 1 |
| `zeroSideGramReal_posSemidef` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | finite on-line PSD (harvested by the hub) | 1, 3 |
| `offLineQuad_obstruction_all` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | the off-line block obstruction | 1 |
| `exists_offLineQuad_gt_all` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | unbounded off-line growth | 1 |
| `paleyWiener_one_sub`, `paleyWiener_conj` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | reflection symmetries of the test function | 2 |
| `differentiable_paleyWiener`, `hasDerivAt_paleyWiener` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | differentiability needed for a deformation | 2 |
| `contour_shift_paleyWiener` | [`ExplicitFormula.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ExplicitFormula.lean.md) | contour shift of the test function | 2 |
| `gramQuad_eq_norm_sq`, `gramMatrix_posSemidef` | [`Gram.lean`](../index-lean/angular-partition-method__lean__Gram.lean.md) | the generic finite Gram sum-of-squares shadow | 2, 3 |
| `posDef_of_entry_bound` | [`Transfer.lean`](../index-lean/prime-spectrum-tensor__lean__Transfer.lean.md) | strict positivity is stable under an entrywise margin | 3 |
| `gramCentre4_sub_posDef`, `gaussianGram4_posDef_of_entry_bound` | [`Transfer.lean`](../index-lean/prime-spectrum-tensor__lean__Transfer.lean.md) | the rational finite certificate and its transfer | 3 |
| `gaussianGram4_posDef` | [`DensityCertificates.lean`](../index-lean/prime-spectrum-tensor__lean__DensityCertificates.lean.md) | the finite 4×4 Gaussian certificate is closed | 3 |

## Python layer

`python/programme.py` provides `gaussian_mode`, `gaussian_test`,
`rank_one_factor`, `gaussian_cos_mode`, `gaussian_sin_mode`, `on_line_quad`,
`on_line_quad_sos`, `von_mangoldt`, `gaussian_bump`, `prime_side`, `prime_side_mass_bound`,
`archimedean_omega`, `archimedean_term`, `pole_term`, `weil_entry`,
`prime_kernel`, `symmetric_eigenvalues`, `offline_quad`,
`diag_block_eigenvalues`, `diag_block_psd`, `admissible_epsilon`,
`convex_combination`, `convex_combination_psd`, `diag_block`,
`lambda_min_diag_block`, `diag_block_linear`, `linear_path_criterion`,
`linear_path_psd_by_sampling`, `sandwich_2x2`, `dpole_term`, `dprime_side`,
`darchimedean_term`, `dweil_entry`, `weil_kernel`, `dweil_kernel`,
`weil_gram`, `dweil_gram`, `min_eigenpair`, `lambda_min_derivative`,
`toeplitz_weil_gram`, `toeplitz_lambda_min`, `geometric_tail_radius`,
`pseries_tail_radius`, `on_line_weights`, `gram_entry_from_weights`,
`max_abs_offline_quad`, `prime_main_term`, `prime_main_ratio`,
`pole_minus_prime_main`, `prime_error`, `arithmetic_gram_entry`,
`prime_error_kernel`, `arch_kernel`, `kernel_gram` and
`toeplitz_kernel_gram`.

```bash
python3 -m pytest the-final-letter/topics/missing-bridge/tests -q
```

## Lean layer

`lean/Topic.lean` proves T1–T137, `lean/ZeroCounting.lean` proves T138–T140, and `lean/Summability.lean` proves T141–T142 `GaussianZeroSide` and
`Transfer` and adding the on-line sum-of-squares identity, the PSD convexity
lemmas, the σ-flow non-monotonicity, the maximal-|δ| obstruction, and the
finite-zero-set easy direction of Weil positivity.  It does **not** prove O1,
O2, O3 or O4, and it does not prove the infinite/cone Weil form.  The
`lean/README.md` records the boundary.

## Dependency note (I5)

The explicit formula's pole terms (`h(0) + h(1)`) and the `h ↔ ĥ` pairing consume
the functional equation.  With [`zeta-from-theta`](../zeta-from-theta/README.md)
that consumption no longer routes through the Hurwitz-zeta development:
`ZetaFromTheta.zetaTheta_one_sub` (D4) is a functional equation for the
theta-side object whose constant-level audit
([`AUDIT.md`](../zeta-from-theta/lean/AUDIT.md)) contains no `*_one_sub` lemma of
that development, and `ZetaFromTheta.riemannZeta_one_sub_from_theta` (M6)
assembles the `riemannZeta` form (with `Γℝ(1−s) ≠ 0` retained).

**This is a provenance note only.**  It changes no positivity statement in this
topic: every open item below stays open, including unconditional Weil
positivity.  Nothing here is evidence for RH.

## Open items and known gaps

1. **Objective 1 (O1).**  No manifest sum of squares for the prime side off the
   critical line is known.  The finite on-line identity is complete; the
   obstruction is the exponential off-line growth (T3, T5).  The scouting
   verdict is that O1 is RH restated and has no slack (1/5).
2. **Objective 2 (O2).**  The linear versions are equivalent to positivity
   (T12 and the continuity obstruction); the Gaussian-width flow is not
   monotone (T13–T16, C10); the heat flow is blocked.  No candidate remains
   (1/5).
3. **Objective 3 (O3).**  The finite uniform-gap route is dead (C11); only the
   dense-subcone/continuity shape remains, which needs the missing uniform
   bound (2/5).
4. **No-go for the existing hub.**  The `blocks ⇒ RH` implication in
   [`weil-positivity`](../weil-positivity/README.md) is vacuous as formalised
   because its antecedent is refutable.  This topic does not repair that
   statement; it records what a non-vacuous replacement would have to prove.
5. **Full-block step.**  Even a completed objective gives Weil positivity only
   for the full cone; the passage from full positivity to RH is the classical
   Weil criterion, and its formalisation here still needs the full-block
   domination `FullBlockWithin`.
6. **Hard direction of Weil's criterion (O4).**  `FiniteWeilPositivity → RH`
   is open; the maximal-`|δ|` analysis rules out the clean zero-side
   domination route, and the arithmetic side is the recommended one.
7. **Scope.**  Nothing here is evidence for RH, and no objective is claimed as
   partially solved.

## Provenance and source

- Review of [`weil-positivity`](../weil-positivity/README.md), 6 November 2026:
  the three objectives were recorded from that review.
- [O2 dossier](../angular-partition-method/README.md) §7.10 and
  [`WEIL-POSITIVITY.md`](../prime-spectrum-tensor/WEIL-POSITIVITY.md) — the
  reduction and its RH-equivalence.
- [Formal core](../absolute-polarized-hodge-index-realization/README.md) —
  `GaussianZeroSide.lean`, `ExplicitFormula.lean`, `ZeroTail.lean`.
- [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md) — the O4
  transfer certificate.
- [`index-lean/index.md`](../index-lean/index.md) — the harvested proof pages.
- [`scraps.html`](../../scraps.html) — the site's claim inventory.
- [`topics/README.md`](../README.md) — all topic folders.

## Build and test

```bash
the-final-letter/topics/missing-bridge/lean/check.sh
python3 -m pytest the-final-letter/topics/missing-bridge/tests -q
```

## The two remaining analytic inputs (T138–T140)

Both are now first-class named objects in
[`lean/ZeroCounting.lean`](lean/ZeroCounting.lean):

* **`ArchimedeanEvaluation c σ A A′`** — `A.re + A′.re = −2π·densityTerm c σ`.
* **`PrimeEvaluation c σ P P′`** — `P.re + P′.re = −2π·primeTermSym c σ`.

T140 shows their conjunction implies the vertical-limit identification.  Neither
is proved: evaluating the vertical integrals requires the digamma/contour-shift
and Dirichlet-series computations, which the existing contour file explicitly
does not contain.

**Absolute summability is reduced to the counting bound.**  T138 gives the strip
norm bound `‖H_c(ρ)‖ ≤ K·e^{−σ²(Im ρ)²}`, and T139 proves that a zero
enumeration `e : ℕ ≃ Z` with `|(e n).im| ≥ c₀ n/log n` makes the Gaussian zero
sum absolutely summable (via `zeroTailSummable_of_ge_div_log` and
`Summable.of_norm_bounded`, transferred along the equivalence).  The counting
bound itself — a Riemann–von Mangoldt-type estimate — is the named input; it is
not in Mathlib.  Nothing here asserts RH.
