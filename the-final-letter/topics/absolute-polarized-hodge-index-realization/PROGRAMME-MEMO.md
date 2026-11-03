# Research programme memo — roadmap to the Riemann hypothesis

| | |
|---|---|
| **To** | Programme sponsor, collaborators, and successor sessions |
| **From** | Programme record — absolute polarized Hodge-index realization |
| **Date** | 2 November 2026 |
| **Baseline** | Research journal round 543; ten checked Lean files; 676 declarations; 197 Python tests; 69 notes |
| **Version** | 1.1 — status refresh after rounds 504–543 |
| **Subject** | Strategy, workstreams, decision gates and claim discipline for the RH programme |
| **Status** | **No RH proof yet.** |

## Executive summary

- The programme has a substantial **Lean-checked analytic chain**: the
  argument principle for \(Z'/Z\), the zero and prime sides of the explicit
  formula, the finite-\(T\) contour shift, unconditional Fourier inversion, the
  Paley–Wiener assembly, and the easy direction **RH \(\Rightarrow\) Weil
  positivity** for the autocorrelation cone.
- Since the last memo, the **analytic inputs of the zero-data package have been
  essentially closed**: the zero-free finite-order theorem for subquadratic
  growth (which covers the \(r\log r\) case), the Gamma and archimedean growth
  bounds, the pole-free zeta strip bound via an exact Euler–Maclaurin
  expansion, the functional equation and growth bound for \(\xi_0\), and
  two-sided bounds on the canonical product are all Lean-checked.
- The remaining zero-data work is now **assembly and enumeration**, not new
  analysis: the quotient-growth estimate, the infinitude of the zeros, and the
  multiplicity enumeration. A working-note counterexample has also shown that
  the proposed unrestricted \(2r\)-sphere lower bound is false; the assembly
  must use a finite split or a repaired bound.
- The RH-equivalent gap is still the **converse**: cone positivity
  \(\Rightarrow\) every nontrivial zero lies on the critical line. This is a
  research problem, not a missing formalisation lemma.
- The critical path remains **WP1 (zero-data assembly) and WP2 (the classical
  explicit formula), converging on WP3 (the converse)**. The programme is
  managed to a decision — proof, reduction, or obstruction — and finite
  certificates cannot substitute for the infinite-level theorem.
- The most consequential new discovery is that **Mathlib already contains
  Jensen's formula, a Nevanlinna value-distribution library, the Poisson
  formula and the maximum-modulus principle**. This gives a concrete route to
  the remaining quotient-growth assembly that does not require rebuilding
  classical Hadamard theory from scratch.

## 0. Decision requested

The sponsor and collaborators are invited to approve:

1. the **critical path** in §7: zero-data assembly (WP1) and the classical
   critical-line explicit formula (WP2), converging on the Weil-positivity
   converse (WP3);
2. the **gate criteria** in §6, including a formal go/no-go gate for WP3 once
   its prerequisites are satisfied;
3. the **claim discipline** in §10, including the standing requirement that
   every status statement say exactly “No RH proof yet.” until a Lean-checked
   proof exists;
4. a **bounded exploratory review** of the geometric absolute-realization
   route (WP5), off the critical path.

This memo is a roadmap to a **decision** on RH. It is not a claim that the
decision will be positive. The programme’s honest position is that the
remaining step is RH-equivalent; a rigorously documented reduction or
obstruction is a legitimate terminal outcome.

---

## 1. Purpose, scope and definition of success

### 1.1 Purpose

The dossier has accumulated a long sequence of verified lemmas, conditional
theorems, numerical certificates and corrections. This memo converts that
record into a managed research programme: it identifies the proof
architecture, isolates the genuinely open step, assigns workstreams and
dependencies, and fixes the evidence standard at each gate.

It is a strategy document, not a replacement for the operational entry point.
[`HANDOFF.md`](HANDOFF.md) remains the session-level source of truth for build
commands, goal state and the theorem inventory. [`research-journal.md`](research-journal.md)
remains the round-by-round record. The numbered notes remain the detailed
arguments.

### 1.2 Scope

**In scope**

- the analytic route from the argument principle to the explicit formula, and
  from the explicit formula to Weil positivity;
- the formalisation of that route in Lean 4 with Mathlib;
- the zero data required for the unconditional Hadamard factorisation and
  partial fraction of the completed zeta;
- the normalisation dictionary connecting the dossier’s conventions to the
  classical Weil / Iwaniec–Kowalski form;
- numerical certification and falsification tests that guard the formal
  statements;
- the finite-level cone certificates and their limits.

**Out of scope**

- claims of an RH proof before a Lean-checked theorem exists;
- replacing peer review with numerical evidence;
- an unrestricted attack on the geometric absolute-realization route; that
  route is retained only as a bounded exploratory workstream;
- any use of `sorry`, `axiom` or `admit` in Lean, or any unlabelled
  “text-proof” assertion presented as verified.

### 1.3 Definition of success

The programme recognises three terminal states:

| State | Criterion | Consequence |
|---|---|---|
| **Proof** | A Lean-checked `RiemannHypothesis` with no forbidden tokens, built from the programme’s definitions and Mathlib. | RH is proved; all weaker claims are superseded. |
| **Reduction** | A Lean-checked equivalence of RH to one explicitly stated open lemma, with the lemma isolated and independently reviewed. | The programme has reduced, not solved, RH; the reduction is publishable and inheritable. |
| **Obstruction** | A theorem or rigorous argument that a named route cannot succeed, e.g. that finite positive-definite certificates cannot reach the cone. | The negative result is recorded; the route is closed or re-scoped. |

Intermediate success is measured by the elimination of hypotheses: a theorem
that was conditional on zero data, normalisation or a finite truncation becomes
unconditional, with the same mathematical content.

---

## 2. Baseline: what is actually established

The programme began with a geometric objective: construct a polarized object
whose intersection pairing is the CCM scaling pairing
\(Z(f)\cdot Z(f)=s(f,f)\), negative definite on degree-zero classes, so that
Yuan–Zhang yields Weil positivity. Rounds 1–44 pursued that realization. The
local rank-three model succeeded; the global/absolute functional did not, and
the recorded normalisation was shown to be sign-indefinite on exact tests. The
programme was rescued and reopened in rounds 45–48, then formalised from round
49 onward around the analytic chain.

The present baseline is therefore best read as a **verified analytic
prelude**, not as a geometric realization. At round 543 the checked core is
**ten Lean files, 676 declarations and 197 Python tests**, with no
`sorry`/`axiom`/`admit`; the newest file, `lean/ZetaStrip.lean`, imports the
exact Euler–Maclaurin development from the neighbouring `finite-window-zeros`
topic. A fresh verification for this memo passed: `./lean/check.sh` reports
all ten files OK, and `python3 -m pytest -q tests` reports **197 passed**.

| Layer | Lean-checked | Numerical / text-proof | Open |
|---|---|---|---|
| **Finite algebra and Hodge index** | Finite KMS forms and compatibility; rank-three intersection model; Hodge defect identity and equality case; finite Gram positivity; finite cone rungs at \(2\times2\) and \(4\times4\). | Interval certificates for Gaussian Gram matrices up to \(8\times8\); compact-support diagonal entry certified positive. | Infinite-level cone positivity. The finite margin collapses; finite PD certificates cannot reach the cone. |
| **Argument principle and contours** | Circle and rectangle argument principles, including simple-pole, multi-zero, multiplicity-weighted and divisor-derived forms; rectangle Cauchy and derivative-Cauchy formulas. | Winding integrals and contour counts checked to \(10^{-18}\)–\(10^{-25}\). | None material for the stated chain. |
| **Completed zeta and symbol** | Symbol identity; conjugation and anti-symmetry; critical-line reality and pure-imaginary log-derivative; pole residues at \(0,1\); zero symmetries; three equivalent RH formulations. | High-precision checks of the identities and residues. | None material for the stated chain. |
| **Explicit formula** | Zero side with a general test function; prime side in closed Fourier form; \(h\equiv1\) assembly; finite-\(T\) contour shift; unconditional Fourier inversion; Paley–Wiener assembled chain. | Extensive contour checks; horizontal-term growth witness; Paley–Wiener and Gaussian instances. | The classical critical-line formula in fixed Weil normalisation; the \(T\to\infty\) limit of the holomorphic shift does not exist. |
| **Hadamard and zero data** | Conditional factorisation of \(\xi_0\); conditional Hadamard partial fraction of \(Z'/Z\); zeros isolated, finite on compact balls and countable; divisor match at non-zeros and at zeros with multiplicities; counting and summability from the correct \(r\log r\) growth; **zero-free finite-order theorem for subquadratic growth**; Gamma, archimedean, zeta-strip and \(\xi_0\) growth bounds; two-sided canonical-product bounds. | Zero-weight partial sums converge; partial-fraction sum nearly real but slowly convergent; numerical checks of the product bounds. | The quotient-growth assembly; infinitude of the zero set; the multiplicity enumeration. |
| **Weil positivity** | **RH \(\Rightarrow\) Weil positivity** for the autocorrelation cone; termwise positivity; reality and real-part reduction of the zero sum; critical line as the fixed locus of \(\rho\mapsto\overline{1-\rho}\). | Negative values outside the cone; finite-level certificates. | **Weil positivity \(\Rightarrow\) RH** — the RH-equivalent converse. |
| **Geometric absolute realization** | Local rank-three Hodge-index model. | Finite Bost–Connes quotient checks for \(N=3,4,5\) (Python suite, not Lean); finite-level state checks. | Global absolute realization; infinite Bost–Connes algebra and \(\beta=1\) state; scaling-site Riemann–Roch/Hodge index. |

### 2.1 What the baseline does not establish

- It does **not** establish the Riemann hypothesis.
- It does **not** establish the full classical critical-line explicit formula.
  Only the zero side, the prime side, the finite-\(T\) contour shift and the
  Fourier/Paley–Wiener assembly are Lean-checked.
- It does **not** establish infinite-level cone positivity. Only the \(2\times2\)
  and \(4\times4\) rungs are Lean-certified; the \(6\times6\) and \(8\times8\)
  Gaussian certificates are numerical, and the \(6\times6\) margin is
  \(\sim4\cdot10^{-10}\).
- It does **not** establish the unconditional Hadamard factorisation of
  \(\xi\). The analytic inputs are now essentially complete, but the
  quotient-growth assembly and the zero enumeration are not.
- It does **not** establish infinite-level Bost–Connes compatibility.
- It does **not** identify the absolute scaling-site geometry. The global
  functional remains unrealised.

---

## 3. The proof architecture

The programme has two logically distinct routes. Only the analytic route is on
the current critical path.

### 3.1 Analytic route

```
argument principle for Z'/Z
        │
        ▼
explicit formula: zero sum = pole terms + archimedean term + prime sum
        │
        ▼
critical-line Weil formula in fixed normalisation
        │
        ▼
Weil criterion: W(h) ≥ 0 on the autocorrelation cone
        │
        ▼
Riemann hypothesis
```

The implications that matter are:

1. **Argument principle \(\Rightarrow\) explicit formula.** The **zero side** is
   Lean-checked in the rectangle form, including the divisor-derived zero count
   and the test-function zero side; the prime side is Lean-checked separately.
2. **Explicit formula \(\Rightarrow\) Weil form.** Partly Lean-checked. The
   finite-\(T\) contour-shift identity and the Paley–Wiener assembly are
   verified; the classical critical-line statement with fixed constants is the
   remaining assembly gap.
3. **Weil criterion \(\Rightarrow\) RH.** This is the open converse. It is not a
   formalisation gap: it is the RH-equivalent mathematical statement.
4. **RH \(\Rightarrow\) Weil positivity.** Lean-checked for the autocorrelation
   cone. This is the easy direction and must not be mistaken for the criterion.

Here \(W\) denotes the Weil functional; its precise normalisation — zero sum,
archimedean term, prime term and pole terms — is fixed by the WP2 dictionary
before the criterion is stated. The programme does not assume a normalisation
in advance.

The crucial logical point is that the explicit formula is an **identity**, not
a sign statement. Knowing that the zero sum equals the archimedean/prime side
does not prove positivity. Positivity on the cone is an additional theorem,
and its converse is where RH lives.

### 3.2 Geometric route

```
scaling site / Bost–Connes system
        │
        ▼
absolute polarized Hodge-index realization
        │
        ▼
cone positivity
        │
        ▼
RH
```

This was the original objective. The local model and the finite-level algebra
are verified; the global absolute functional is not. The route is retained
because a successful geometric realization would give a structural reason for
cone positivity, but it is not currently a dependency of the analytic route.

### 3.3 Why finite certificates cannot close the programme

The finite cone rungs are real evidence, but they are structurally unable to
reach the infinite-level cone. The journal records the margin collapse: the
smallest eigenvalues of the compact-support Gram matrices fall to
\(1.28\cdot10^{-9}\), then to the numerical floor, as the basis grows; the
Gaussian margins fall from \(0.0227\) at \(n=4\) to \(0.0040\) at \(n=8\). The
Lean theorem `margin_nonincrease` shows that enlarging the test set cannot
increase the margin, and `hodge_index_equality_kernel` identifies a zero margin
with a zero direction. The correct conclusion is not “certify a larger matrix”
but “prove a kernel/rank theorem for the limit form”. That theorem is part of
WP3, not WP4.

---

## 4. The four gaps

| Gap | Type | Current position | Consequence |
|---|---|---|---|
| **G1. Zero-data assembly and enumeration** | Formalisation / assembly | All analytic inputs are Lean-checked; the quotient-growth assembly, infinitude and multiplicity enumeration remain. | Blocks an unconditional Hadamard partial fraction of \(Z'/Z\), hence the cleanest route to the classical explicit formula’s constants. |
| **G2. Critical-line explicit formula in classical normalisation** | Assembly / normalisation | Zero side, prime side, finite-\(T\) contour shift, Fourier inversion and Paley–Wiener chain are Lean-checked. | Blocks a Lean statement of the classical Weil formula that can be compared symbol-for-symbol with the literature. |
| **G3. The converse of Weil positivity** | Research | RH \(\Rightarrow\) positivity is Lean-checked; the converse is open. | This is the RH-equivalent gap. No amount of finite certification closes it. |
| **G4. Absolute geometric realization** | Strategic / research | Local rank-three model Lean-backed; global functional indefinite; finite Bost–Connes quotients checked. | The original geometric objective is unrealised; it is not on the critical path. |

### 4.1 G1 in detail

The conditional factorisation `factorization_of_xi₀` and the conditional
partial fraction `logDeriv_completedZeta_eq_tsum_of_zeros` require:

1. an enumeration \(a:\mathbb{N}\to\mathbb{C}\) of the nontrivial zeros;
2. summability \(\sum \|a_n\|^{-(p+1)}\);
3. the divisor match, with multiplicities;
4. finiteness of the divisor;
5. log-growth of \(\xi_0/P\).

Rounds 477–543 have changed the character of this gap decisively. The
**analytic inputs are now Lean-checked**:

- the zeros are isolated, finite on compact balls, and countable;
- the divisor match holds away from zeros and at zeros in the
  finite-split/multiplicity form;
- the counting bound and the summability from the correct \(r\log r\) growth
  are formalised;
- the zero-free finite-order theorem is Lean-checked in the **subquadratic**
  form `subquadratic_eq_affine_of_re_le_rpow`: if `Re g(z) ≤ A‖z‖^p + B` with
  `1 < p < 2`, then `g` is affine. Since \(r\log r\le C r^{3/2}\), this covers
  the order-1 \(r\log r\) growth and removes the earlier "Hadamard-theory gap";
- the Gamma growth bounds, the archimedean factor growth on `re s ≥ 1/2`, the
  pole-free zeta strip bound (`exists_bound_norm_zeta_strip_polefree`, via the
  exact Euler–Maclaurin expansion, with explicit constant \(A=5\)), and the
  functional equation and \(r\log r\) growth of \(\xi_0\)
  (`xi₀_one_sub`, `exists_bound_log_norm_xi₀`) are Lean-checked;
- the canonical product is controlled **from both sides**, under the
  separation \(\|z\|\le \|a_n\|/2\), in terms of \(\|z\|\) and
  \(\sum 1/\|a_n\|\)
  (`log_norm_tprod_weierstrassFactor_one_lower`,
  `upper_log_norm_tprod_weierstrassFactor_one`).

The earlier "infinite-type exponential step" is therefore **no longer the
gap**. What remains is the assembly and the enumeration:

- **Quotient-growth assembly.** The plan is to bound
  \(h=\xi_0/P\) by a maximum-modulus step, a circle lower bound for \(P\),
  and the subquadratic theorem. The maximum-modulus step is Lean-checked
  (`norm_le_of_forall_mem_sphere_le`, round 543). The proposed unrestricted
  circle lower bound
  \(\log|P(w)|\ge -4r\sum 1/|a_n|\) for \(\|w\|=2r\) is **false as stated**:
  a zero just outside the circle makes one factor arbitrarily small. Current
  working notes (not yet in `check.sh` or the journal) contain a
  machine-checked counterexample and a separated version that is true when
  every zero satisfies `4r ≤ ‖a_n‖`. The assembly must therefore use a finite
  split around the circle, or a repaired bound; this is the immediate
  technical obstacle.
- **Infinitude of the zero set.** The mechanism is recorded: a finite zero set
  would make \(Z'/Z=P'/P+b\) bounded along the real axis, contradicting the
  Lean-checked growth `tendsto_logDeriv_completedZeta_re_atTop`. The remaining
  inputs are the finite-product \(P'/P\) bound and the finite-case Hadamard
  step.
- **The multiplicity enumeration** itself, repeating each zero according to its
  analytic order.

G1 remains a **formalisation gap**, not an RH gap: it concerns the existence
and counting of zeros, not their location. Supplying it yields the
unconditional partial fraction, which is valuable even if RH remains open.

### 4.2 G2 in detail

The finite-\(T\) contour-shift identity is Lean-checked. The step to the
classical critical-line formula is not its \(T\to\infty\) limit: holomorphic
test functions cannot decay in both horizontal directions, the Gaussian
instance grows, and the Paley–Wiener functions grow like \(e^{a|\operatorname{Im}s|}\).
The numerical witness `test_horizontal_term_grows` shows the horizontal term
growing \(8.24, 227.1, 5968.0\) at \(T=5,10,15\).

The classical formula must therefore be derived on the critical line, with the
Fourier transform of the prime measure and the correct archimedean
normalisation. The recorded subtleties are:

- the prime-side exchange is distributional, not a straightforward Fubini
  application;
- the expected constant is \(2\pi n^{-1/2}g(\log n)\) up to normalisation;
- the archimedean term must be matched to the Gamma-factor convention;
- the pole terms must be consistent with \(h(0)\) and \(h(1)\), and for even
  test functions they coincide.

The deliverable is a normalisation dictionary and a Lean statement that can be
checked against Iwaniec–Kowalski Theorem 5.12 (or an equivalent classical
source) without reinterpretation. Rounds 504–543 produced no new result on this
gap; it remains as recorded in notes 65–66.

### 4.3 G3 in detail

The precise target is:

> For every test function in the autocorrelation cone, the Weil functional is
> nonnegative; equivalently, every nontrivial zero lies on the critical line.

The dossier has the easy direction:

- `autocorrelation_exponential_eq_norm_sq_of_compactSupport`;
- `paleyWiener_autocorrelation_nonneg`;
- `sum_paleyWiener_autocorrelation_nonneg_of_critical_line`;
- `weil_zero_sum_nonneg_real_of_critical_line`.

Schematically, with \(C\) the autocorrelation cone and
\(W_g=W(h_g)\), the target is

```
(∀ g ∈ C, 0 ≤ W_g)  →  RiemannHypothesis,
```

while the Lean-checked direction is

```
RiemannHypothesis  →  (∀ g ∈ C, 0 ≤ W_g).
```

The converse is not a missing lemma in an otherwise complete proof. It is the
RH-equivalent statement. The programme must therefore treat WP3 as a research
workstream with a real possibility of failure, not as an engineering task. No
progress on this gap was recorded in rounds 504–543; the new work was on the
zero-data side.

### 4.4 G4 in detail

The original objective — an absolute polarized Hodge-index realization — is
not achieved. The global functional is indefinite on exact tests; the
finite-level Bost–Connes checks do not extend to the infinite level. This is
recorded honestly in the README and notes 37–55. WP5 exists to decide whether
the geometric route can be reformulated, not to pretend that it is already a
proof route. No new geometric result was recorded in rounds 504–543.

---

## 5. Workstreams

### WP1 — Zero-data assembly and enumeration

**Objective.** Make the Hadamard factorisation and partial fraction of
\(\xi_0\) unconditional.

**Current position.** The analytic inputs are Lean-checked, including the
zero-free subquadratic theorem, the Gamma/zeta/\(\xi_0\) growth bounds and the
two-sided canonical-product estimates. Conditional factorisation and partial
fraction are Lean-checked. What remains is the quotient-growth assembly, the
infinitude of the zeros, and the multiplicity enumeration.

**Deliverables.**

1. Complete the quotient-growth assembly: combine the Lean-checked
   maximum-modulus step with a repaired circle lower bound (finite split, or a
   separated bound) and the subquadratic theorem to obtain the growth bound for
   \(\xi_0/P\).
2. `xi₀_zeros_infinite`: the zero set is infinite, via the real-axis
   log-derivative growth and the finite-product \(P'/P\) bound.
3. `exists_multiplicity_enumeration`: a sequence listing each zero with its
   analytic order, with the correct fibres.
4. Unconditional `factorization_of_xi₀` and
   `logDeriv_completedZeta_eq_tsum_of_zeros`.

**Acceptance test.** The theorems have no zero-data hypotheses; the Lean build
is clean; the partial fraction is stated for the dossier’s `Z` and agrees
numerically with the existing partial-fraction checks.

**Dependencies.** None on WP2 or WP3. This is the most self-contained route to
a durable result.

**Principal risk.** The circle lower bound and the finite-split bookkeeping are
the delicate points; the working-note counterexample shows that the naive
unrestricted form cannot be used. If the assembly exceeds its scope, the
fallback is to keep the conditional version clearly labelled and proceed to
WP2 without it.

### WP2 — Classical critical-line explicit formula

**Objective.** State and prove the classical Weil explicit formula on the
critical line in a fixed normalisation, with all constants explicit.

**Current position.** The zero side, prime side, finite-\(T\) contour shift,
Fourier inversion and Paley–Wiener assembly are Lean-checked. The
normalisation and the distributional prime-side step are not.

**Deliverables.**

1. A normalisation dictionary note fixing the relation between the dossier’s
   \(Z\), the classical \(\xi\), the Weil functional and the
   Iwaniec–Kowalski form.
2. A Lean statement of the critical-line formula for a compactly supported
   test function, with the archimedean integral and prime sum in the same
   convention.
3. A proof of the distributional prime-side identity via the contour/residue
   argument, not an unjustified Fubini exchange.
4. An independent numerical check on a compactly supported test function,
   with truncation and tail bounds stated.

**Acceptance test.** The Lean statement matches the literature
symbol-for-symbol; the numerical check agrees within a certified tolerance;
no normalisation hypothesis remains hidden in the statement.

**Dependencies.** Can proceed in parallel with WP1. WP1 de-risks the constants
by supplying the Hadamard partial fraction.

**Principal risk.** A normalisation error would invalidate the comparison and
could waste substantial effort. Mitigation: two independent derivations
(contour and Fourier), a written dictionary, and a numerical check before
formalisation.

### WP3 — The converse of Weil positivity

**Objective.** Prove that cone positivity forces every nontrivial zero onto the
critical line, or isolate the precise open statement that prevents it.

**Current position.** RH \(\Rightarrow\) positivity is Lean-checked for the
autocorrelation cone. The converse is open and RH-equivalent.

**Deliverables.**

1. A Lean definition of the cone, the Weil functional and the criterion, with
   the equivalence statement clearly distinguished from its proof.
2. A route survey: positivity via Gram/Bochner methods, de Branges spaces,
   Hilbert–Pólya, explicit-formula sign arguments, and any reduction to a
   kernel/rank theorem for the limit form.
3. At least one of:
   - a complete Lean proof of `RiemannHypothesis`;
   - a Lean-checked reduction of RH to a single explicit lemma, with the lemma
     stated precisely and reviewed;
   - a rigorous obstruction theorem for a named route.
4. A written assessment of whether the finite angular/Bochner calculus can
   reach the infinite cone. Note 61 already argues that it cannot do so by
   itself; this should be either formalised or recorded as a boundary result.

**Acceptance test.** External review of the reduction or obstruction; no
circular use of RH-equivalent statements; every analytic hypothesis explicit.

**Dependencies.** WP2 supplies the explicit formula in the correct
normalisation; WP1 supplies the partial fraction. WP4 supplies numerical
guardrails but cannot prove the converse.

**Principal risk.** This is the programme’s central research risk. The
probability that a complete proof emerges from the current route is low; the
probability of a useful reduction is moderate. The workstream must be managed
as exploratory research, with a go/no-go gate.

### WP4 — Finite certificates and numerical guardrails

**Objective.** Maintain the numerical layer as a falsification and consistency
tool, not as a substitute for proof.

**Current position.** Interval certificates exist for Gaussian Gram matrices
up to \(8\times8\); the compact-support diagonal is certified positive; the
\(6\times6\) margin is thin; the margin collapse is documented.

**Deliverables.**

1. Keep the existing certificates reproducible and clearly labelled.
2. Extend interval certification only where it tests a specific analytic
   statement, not merely to add a larger matrix.
3. Maintain falsification tests for every major identity: symbol, residues,
   argument-principle counts, contour shift, Fourier inversion, autocorrelation
   positivity.
4. Record negative results, including negative directions outside the cone and
   the growth of the horizontal term.

**Acceptance test.** Every numerical claim has a bound and a tail estimate; no
truncated series is presented as a certificate; the test suite passes within
its documented runtime.

**Dependencies.** Supports WP2 and WP3. Does not block them.

**Principal risk.** Over-investment in larger finite certificates. Mitigation:
the margin-collapse theorem is the standing answer; new certificates require a
written justification of what they would test.

### WP5 — Geometric absolute realization (exploratory, bounded)

**Objective.** Decide whether the original scaling-site / Bost–Connes route can
be reformulated into a viable proof strategy.

**Current position.** Local rank-three model Lean-backed; global functional
indefinite; finite Bost–Connes quotients checked; infinite-level compatibility
open.

**Deliverables.**

1. A short assessment of whether a scaling-site Riemann–Roch/Hodge-index
   statement can be formulated precisely enough to attack.
2. A decision on the infinite Bost–Connes compatibility: pursue, reformulate,
   or archive.
3. If archived, a note explaining the obstruction and preserving the verified
   finite-level results.

**Acceptance test.** A written go/no-go recommendation at the close of the
bounded review, with no claim of an absolute realization unless the global
object is constructed.

**Dependencies.** None on the critical path. This workstream must not consume
WP1–WP3 capacity.

### WP6 — Formalisation infrastructure

**Objective.** Keep the Lean development buildable, reviewable and reusable.

**Current position.** Ten checked Lean files; 676 declarations; no
`sorry`/`axiom`/`admit`; shared checker `topics/tools/check-lean.sh`; Python
suite of 197 tests. `lean/ZetaStrip.lean` imports the neighbouring
`finite-window-zeros` Euler–Maclaurin development, so the checker now uses
`LEAN_EXTRA_PATH`.

**Deliverables.**

1. Maintain `lean/check.sh` and the pinned Lean/Mathlib environment, including
   the cross-topic `LEAN_EXTRA_PATH`.
2. Isolate general-purpose lemmas that Mathlib lacks — argument principle,
   rectangle Cauchy formulas, Hadamard products, the subquadratic zero-free
   theorem — for possible upstreaming.
3. Keep the theorem inventory and declaration counts synchronised with the
   journal, README and this memo.

**Acceptance test.** Full build clean; no forbidden tokens; declared counts
match an independent audit.

### WP7 — Integrity, documentation and reproducibility

**Objective.** Ensure that every claim is labelled, every count is current and
every result can be reproduced.

**Current position.** The journal is round-by-round; the handoff is the entry
point; several historical counts have drifted.

**Deliverables.**

1. A single claim-labelling convention: **Lean-checked**, **numerical**,
   **text-proof**, **conditional**, **open**.
2. An event-based reconciliation of Lean declarations, test counts and note
   references.
3. A dependency audit to prevent circular use of RH-equivalent statements.
4. Archived certificate data with exact centre/error boxes.

**Acceptance test.** README, HANDOFF, notes and journal agree at each gate.

---

## 6. Workstream sequencing and decision gates

The programme is sequenced by **dependencies and evidence**, not by dates. A
stage is entered only when its prerequisites are Lean-checked or explicitly
isolated as hypotheses.

| Stage | Workstream | Outcome | Entry condition | Gate |
|---|---|---|---|---|
| **S0** | WP6/WP7 | Baseline audit and current-state reconciliation | Repository available | Ten checked files build; no forbidden tokens; counts reconciled. |
| **S1** | WP1 | Zero-data analytic inputs | S0 | All analytic inputs Lean-checked (achieved: rounds 518–538). |
| **S2** | WP1 | Quotient-growth assembly | S1; repaired circle lower bound | Growth bound for \(\xi_0/P\) Lean-checked. |
| **S3** | WP1 | Infinitude and multiplicity enumeration | S1; finite-product \(P'/P\) bound | `xi₀_zeros_infinite` and `exists_multiplicity_enumeration` Lean-checked. |
| **S4** | WP2 | Normalisation dictionary | S0 | Dictionary written; formula matches Iwaniec–Kowalski Thm 5.12; numerical check. |
| **S5** | WP2 | Lean critical-line explicit formula | S4 | Theorem with explicit constants; no hidden normalisation; numerical agreement. |
| **S6** | WP3 | Weil-positivity proof, reduction or obstruction | S2/S3 and S5 | Complete proof, or a reduction to one explicit lemma, or a rigorous obstruction. |
| **S7** | Board | Programme decision | S6 | Outcome recorded; next phase approved, re-scoped, or programme closed. |
| **S8** | WP5 | Geometric route review | S0; independent capacity | Go/no-go note; no claim of absolute realization without a constructed global object. |

### 6.1 Gate definitions

**G0 — Baseline.** Build and test green; counts reconciled; claim labels
consistent. This gate is satisfied by the current record, subject to the
reconciliation in Appendix C.

**G1 — Zero data.** WP1’s theorems are unconditional. If the quotient-growth
assembly is not complete, the programme may pass a **conditional G1** by
isolating the missing growth lemma as a named hypothesis and proceeding to
WP2; the conditional status must appear in every downstream statement.

**G2 — Normalisation.** The dictionary and the numerical comparison agree. A
failure here sends the programme back to WP2; it must not proceed to S5 with an
unresolved convention.

**G3 — Explicit formula.** The Lean statement is accepted by an independent
reviewer and matches the classical formula. This is the last fully
engineering-controlled gate.

**G4 — Positivity.** The programme’s real decision point. A complete proof
passes; a reduction passes with a revised programme aimed at the isolated
lemma; an obstruction closes the route and triggers a strategic review.

---

## 7. Dependencies and critical path

```
WP1: analytic inputs ──► quotient assembly ──► enumeration ──┐
                                                             ├──► WP3 (G4) ──► decision
WP2: normalisation dictionary ──► explicit formula ──────────┘
WP4 ──────────────────────────► guardrails (no gate)
WP5 ──────────────────────────► geometric review (parallel)
WP6/WP7 ──────────────────────► continuous
```

- **Critical path:** WP1 (assembly and enumeration) and WP2 (normalisation and
  explicit formula) converge at WP3.
- **Parallelisable:** WP1’s analytic-input work with WP2’s dictionary; WP4;
  WP5; WP6/WP7.
- **Slack:** WP2 can proceed while WP1 repairs the circle bound; WP3 cannot
  start without the correct normalisation.
- **No-go condition:** if G4 produces neither a proof, nor a reduction, nor a
  rigorous obstruction, the programme must not continue on the same route
  without a new written strategy.

---

## 8. Risks and mitigations

| Risk | Likelihood | Impact | Early warning | Mitigation |
|---|---|---|---|---|
| **R1. The Weil-positivity converse is not tractable with current tools** | High | Critical | No candidate reduction; repeated reformulations without a new lemma | Stage-gated WP3; multiple route survey; external review; accept a reduction or obstruction as a valid outcome. |
| **R2. Normalisation error invalidates the explicit formula** | Medium | Critical | Numerical mismatch; formula disagrees with literature by a constant factor | Two independent derivations; written dictionary; numerical check before formalisation; independent reviewer. |
| **R3. The quotient-growth assembly or finite-split bound proves harder than expected** | Medium–High | High | The repaired circle bound expands into case analysis; no new verified lemma | Isolate the bound; use a finite split or a separated version; record the unrestricted counterexample; fallback to a clearly labelled conditional. |
| **R4. Finite certificates are mistaken for cone positivity** | Medium | High | Public or internal language sliding from “certified rung” to “cone” | Margin-collapse theorem as standing correction; claim policy; require the word “finite” in every certificate statement. |
| **R5. Mathlib/version drift breaks the build** | Medium | Medium | New Mathlib release; lemma renames | Pin toolchain; `check.sh`; record versions; avoid unnecessary dependencies. |
| **R6. Counts and status drift across documents** | High | Medium | README/HANDOFF/journal disagree | Event-based reconciliation at each gate; single source of truth; automated count checks. |
| **R7. Circularity: a proof depends on an RH-equivalent statement** | Low–Medium | Critical | A hypothesis is equivalent to RH without being labelled | Dependency audit; every open hypothesis named and classified; reviewer sign-off. |
| **R8. Single-investigator continuity** | Medium | Medium | Context loss between sessions; stale handoff | Maintain HANDOFF and journal; write each note to be self-contained; record goal state. |
| **R9. Scope creep into the geometric route** | Medium | Medium | WP5 consumes WP1–WP3 capacity | Keep WP5 bounded and separate; no critical-path dependency. |

---

## 9. Governance, roles and review triggers

Where the programme is a single-investigator effort, the following are
**responsibilities**, not separate posts.

| Role | Responsibility |
|---|---|
| **Principal investigator** | Direction, gate decisions, external communication, final claim approval. |
| **Formalisation lead** | Lean architecture, build health, theorem inventory, Mathlib gaps. |
| **Analysis lead** | Normalisation, Hadamard/zero data, complex-analytic arguments. |
| **Numerical lead** | Interval certificates, falsification tests, reproducibility. |
| **Independent reviewer** | Gate review, dependency audit, claim check; must not be the author of the theorem under review. |

**Review triggers.**

- **At each closed workstream:** record the round entry, build and test status,
  and the concrete deliverable or documented correction.
- **On a refutation:** update the target, note the corrected statement, and
  check every downstream theorem that used the refuted form.
- **At each gate:** count reconciliation, claim-label audit, risk review and a
  written evidence pack, followed by independent review and an explicit
  decision in the journal.
- **Before public communication:** gate review and claim audit.

**Definition of done for a theorem.** It is Lean-checked with no forbidden
tokens; its hypotheses are stated explicitly; it has a docstring; it is listed
in the theorem inventory; it has a numerical check where a numerical statement
is meaningful; and its claim label is correct.

---

## 10. Claim discipline and communication

The programme’s credibility depends on saying exactly what has been proved.

### 10.1 Required status phrase

Every status statement must say exactly:

> **No RH proof yet.**

until a Lean-checked proof exists. This includes README, HANDOFF, notes,
journal entries, public posts and talks.

### 10.2 Claim labels

- **Lean-checked** — a theorem in the repository, no `sorry`/`axiom`/`admit`.
- **Numerical** — a computation with stated precision, interval bounds and
  tail control where applicable.
- **Text-proof** — a complete informal argument, not formalised; must be
  marked as such.
- **Conditional** — a Lean theorem with explicit hypotheses that are not yet
  discharged.
- **Open** — no proof.

### 10.3 Prohibited claims while they remain untrue

- “The Riemann hypothesis is proved.”
- “The explicit formula is formalised” without qualification; only the named
  layers are.
- “Weil positivity is proved” without specifying the direction and the cone.
- “Infinite cone positivity” or “the global Hodge index” on the basis of
  finite rungs.
- “A \(6\times6\) Lean certificate”; the \(6\times6\) certificate is numerical.
- “Unconditional Hadamard factorisation”; it is conditional on the remaining
  zero-data assembly and enumeration.
- “The zero-data package is complete”; the analytic inputs are complete, but
  the quotient-growth assembly and enumeration are not.
- “Bost–Connes infinite-level compatibility”; only finite levels are checked.
- “The absolute polarized Hodge-index realization is achieved.”

### 10.4 Public communication

Any public claim must pass the gate review and the claim-label audit. The
preferred public framing is: “a formally verified fragment of the explicit
formula and one direction of Weil’s criterion”, not “a route to proving RH”.

---

## 11. Recommendations

1. **Approve WP1 and WP2 as the critical path.** They are the workstreams that
   can produce durable unconditional theorems.
2. **Treat WP3 as a research programme, not a sprint.** Fund it to a gate, not
   to an output quota; require a reduction or obstruction as a valid
   deliverable.
3. **Do not expand the finite certificates by default.** The margin collapse is
   a proved structural limit; larger matrices do not address it.
4. **Complete the normalisation dictionary before formalising the classical
   formula.** This is the cheapest way to avoid a costly false start.
5. **Keep WP5 bounded.** The geometric route remains part of the programme’s
   identity, but it is not the route to RH on current evidence.
6. **Use event-based reconciliation.** The programme’s value depends on the
   trustworthiness of its labels and counts; reconcile whenever a gate is
   approached or a refutation changes a target.
7. **Exploit the Jensen/Nevanlinna discovery.** Mathlib already contains the
   value-distribution machinery needed for the quotient-growth assembly; the
   next technical move is to repair the circle lower bound (finite split or
   separated version) and connect it to the Lean-checked maximum-modulus step.
8. **Prepare the negative-result path now.** If G4 yields an obstruction, the
   programme should be able to publish a precise boundary theorem rather than
   an ambiguous failure.

---

## 12. Noteworthy observations, new discoveries and novel work

This section records the results and turns of method that changed the
programme’s position since the previous memo (round 503). Claims are labelled
as in §10.

### 12.1 The zero-free finite-order theorem is now available in the needed range

The earlier notes described the order-1 Hadamard exponential step as a missing
classical theorem requiring a polynomial-versus-transcendental case analysis.
That is no longer the operative gap. The Lean-checked theorem
`subquadratic_eq_affine_of_re_le_rpow` proves that an entire `g` with
`Re g(z) ≤ A‖z‖^p + B` for `1 < p < 2` is affine. Since
\(r\log r \le C r^{3/2}\), this covers the \(r\log r\) growth of the quotient
\(\xi_0/P\) and therefore supplies the exponential step for the order-1 case.

This is a genuine simplification of the classical route: the programme does not
need the full zero-free finite-order theorem, only the subquadratic case, and
that case is reachable from Borel–Carathéodory plus Cauchy estimates. The
earlier `ε → 0` objection is bypassed by choosing `p = 3/2` uniformly rather
than taking an order-1 limit.

### 12.2 The zeta strip bound closed through an exact Euler–Maclaurin import

The last analytic input for the growth of \(\xi_0\) was a pole-free bound for
\(\zeta\) in the critical strip. The programme did not use the approximate
functional equation. Instead, `lean/ZetaStrip.lean` imports the exact
Euler–Maclaurin expansion from the neighbouring `finite-window-zeros` topic
(through `LEAN_EXTRA_PATH`) and proves
`exists_bound_norm_zeta_strip_polefree`: on \(1/2 \le \Re s \le 1\) with
\(\|s\| \ge 2\), \(\|\zeta(s)\| \le A(\|s\|+2)^2\) with explicit \(A = 5\).

This is a novel cross-topic formalisation move and a stronger result than the
order-1 logarithmic bound that the assembly needs. It also demonstrates a
reusable pattern: a neighbouring topic’s exact expansion can be imported rather
than re-derived.

### 12.3 Mathlib already contains Jensen, Nevanlinna, Poisson and maximum modulus

The most consequential discovery is that the remaining quotient-growth
assembly does not require building classical Hadamard theory from scratch.
Mathlib contains:

- **Jensen’s formula in divisor form**
  (`MeromorphicOn.circleAverage_log_norm`,
  `Mathlib/Analysis/Complex/JensenFormula.lean`);
- a full **Nevanlinna value-distribution library**
  (`ValueDistribution/CharacteristicFunction`, `FirstMainTheorem`,
  `SecondMainTheorem`, `Cartan`, `LogCounting`, `Proximity`);
- the **Poisson kernel and Poisson integral formula**
  (`Complex.poissonKernel`,
  `DiffContOnCl.circleAverage_poissonKernel_smul`);
- the **maximum-modulus principle**
  (`Complex.norm_le_of_forall_mem_frontier_norm_le`) and a harmonic-function
  library.

This changes the assembly strategy. The divisor sum in Jensen’s formula is the
\(N(r)\) term growing like \(r\log r\); it supplies the lower bound on
\(\log|P|\) that cancels the \(r\log r\) growth of \(\log|\xi_0|\). The
programme has already Lean-checked the maximum-modulus step
(`norm_le_of_forall_mem_sphere_le`), so the remaining work is the circle lower
bound and the final assembly, not a new value-distribution theory.

### 12.4 Refutations of the programme’s own targets

Three unrestricted targets were found to be false. The first two refutations
are part of the checked build; the third is a machine-checked working note that
has not yet been integrated:

1. **Unrestricted Gamma growth** fails at the pole \(s=0\):
   \(\Gamma(\sigma) \sim 1/\sigma\), so \(\log\|\Gamma(\sigma)\| \to +\infty\)
   while any bound of the form \(A\|s\|\log\|s\|+B\) stays finite. The correct
   statements restrict to a half-plane or carry a \(-\log(\Re s)\) term.
2. **The literal zeta strip bound** fails at the pole \(s=1\): the strip
   contains points approaching \(1\), where \(\|\zeta\| \to \infty\). The
   pole-free version on \(\|s\| \ge 2\) is the correct target.
3. **The unrestricted \(2r\)-sphere lower bound** for the canonical product is
   false: a zero just outside the circle \(\|w\|=2r\) makes one factor
   arbitrarily small while its reciprocal contribution stays bounded. Current
   working notes contain a machine-checked counterexample; the separated
   version (`4r ≤ ‖a_n‖`) is true. This is not yet in `check.sh` or the
   journal, but it is the immediate technical constraint on WP1.

These are not setbacks in the ordinary sense: they prevent the programme from
building on false estimates and they sharpen the hypotheses that the assembly
must carry.

### 12.5 Two-sided control of the canonical product

The canonical product is now bounded above and below, under the separation
condition \(\|z\|\le \|a_n\|/2\), in terms of \(\|z\|\) and
\(\sum 1/\|a_n\|\): the lower bound
`log_norm_tprod_weierstrassFactor_one_lower` and the upper bound
`upper_log_norm_tprod_weierstrassFactor_one` are both Lean-checked. This is the
quantitative core of the quotient-growth estimate; it replaces the earlier
one-sided estimates and makes the Jensen lower bound a refinement rather than a
missing ingredient.

### 12.6 The entire model of \(\xi_0\) and its functional equation

The programme uses the entire function
\(\xi_0(s)=s(s-1)\Lambda_0(s)+1\), not the literal \(s(s-1)\Lambda(s)\). The
latter is not entire in Lean because its junk values at the poles are `0` while
the limit is `1`. This junk-value correction is a formalisation insight with
mathematical content: it identifies the correct entire representative of the
completed zeta on which the Hadamard theory can operate. Round 537 adds
`xi₀_one_sub` (the functional equation) and the \(r\log r\) growth bound for
\(\xi_0\), so the object now has the three properties the assembly needs:
entirety, the correct zero set, and order-1 growth.

### 12.7 The external “zeta cone” visualisation does not upgrade any claim

Note 69 assesses the supplied `zeta_cone_concepts.html`. Its one mathematical
claim — the untwisted `sinc`/Fejér kernel is of positive type by Bochner — is
correct but is the classical **untwisted** positivity. The file itself concedes
that arithmetic twists re-introduce open problems. The dossier’s Lean-checked
untwisted transforms (`fourierG_one_eq`, the autocorrelation identity) already
cover the concrete untwisted part; the arithmetic cone positivity remains the
RH-equivalent statement. No claim was upgraded.

### 12.8 Negative and structural results that remain load-bearing

- **The holomorphic contour shift has no \(T\to\infty\) limit.** The horizontal
  term grows numerically (\(8.24, 227.1, 5968.0\) at \(T=5,10,15\)); the
  classical formula must be derived on the critical line, not as a limit of
  the finite-\(T\) identity.
- **Finite cone certificates cannot reach the infinite cone.** The margin
  collapse is Lean-backed (`margin_nonincrease`,
  `hodge_index_equality_kernel`), and the \(6\times6\) certificate has margin
  \(\sim4\cdot10^{-10}\) and is numerical only. This remains the structural
  reason WP4 cannot substitute for WP3.
- **The explicit-formula normalisation is unchanged.** The zero side, prime
  side and finite-\(T\) chain are verified, but the classical critical-line
  formula in a fixed Weil/Iwaniec–Kowalski normalisation is still the G2
  assembly gap.

### 12.9 Methodological observations

- **Parallel proof attempts are now part of the workflow.** Several results
  (the subquadratic theorem, the Gamma and zeta corrections, the strip bound,
  the \(\xi_0\) growth bound) were developed through independent workflow
  attempts. On the refutations, independent attempts agreed, which increases
  confidence that the targets are genuinely false rather than mis-formalised.
- **Cross-topic reuse is productive.** `ZetaStrip.lean` is the first checked
  file in this dossier to import another topic’s Lean development. This
  suggests a general pattern for future analytic inputs: search neighbouring
  topics before rebuilding.
- **The working-note counterexample changed the plan before it entered the
  build.** The unrestricted \(2r\)-sphere bound was refuted in scratch work
  before being used in the main assembly. This is the intended function of
  bounded exploratory work: fail cheaply, then repair the statement.
- **A new angular/radial-axis method is being explored.** The companion topic
  [`angular-partition-method`](../angular-partition-method/README.md) proposes
  replacing depth truncation (partial sum plus tail) by exact annular and
  sectorial partitions of a compact carrier, including an arbitrary-weight
  radius transform. Its exact annular and measure-theoretic core, including
  the infinite annular representation, the phase-carrying tail coil and the
  Mellin/Laplace layer with its functional equation, growth bound and
  critical-strip finite-part regularization, is Lean-proved; its application to
the zeros and Weil positivity is open, with the remaining convergence and phase
obstructions stated explicitly.

---

## Appendix A — Workstream-to-theorem map

| Stage | Key existing theorems | New theorems required |
|---|---|---|
| S1 | `xi₀_zero_isolated`, `xi₀_zeros_finite_in_closedBall`, `xi₀_zeros_countable`, `exists_enumeration_zeros`, `xi₀_zeros_inv_sq_summable_of_log_growth`, `subquadratic_eq_affine_of_re_le_rpow`, `exists_bound_norm_zeta_strip_polefree`, `exists_bound_log_norm_xi₀`, `log_norm_tprod_weierstrassFactor_one_lower`, `upper_log_norm_tprod_weierstrassFactor_one` | — (analytic inputs complete) |
| S2 | `norm_le_of_forall_mem_sphere_le`, `subquadratic_eq_affine_of_re_le_rpow` | repaired circle lower bound; quotient-growth assembly |
| S3 | `tendsto_logDeriv_completedZeta_re_atTop`, `norm_logDeriv_finiteCanonicalProduct_one_le`, `xi₀_zero_isolated` | `xi₀_zeros_infinite`, `exists_multiplicity_enumeration` |
| S4 | `test_function_explicit_formula`, `contour_shift_paleyWiener`, `integral_logDeriv_paleyWiener_u_superposition`, `fourier_inversion` | normalisation dictionary; critical-line statement |
| S5 | prime-side Fourier identities, archimedean critical-line reality, Paley–Wiener assembly | distributional prime-side identity; assembled classical formula |
| S6 | `weil_zero_sum_nonneg_real_of_critical_line`, `sum_paleyWiener_autocorrelation_nonneg_of_critical_line`, `margin_nonincrease`, `hodge_index_equality_kernel` | converse of Weil positivity, or reduction/obstruction |
| S8 | local rank-three Hodge model; finite Bost–Connes quotient checks (numerical) | scaling-site formulation; infinite-level compatibility or obstruction |

## Appendix B — Reading order for a successor

1. [`HANDOFF.md`](HANDOFF.md) — build, goal state, repository map, exact next
   steps; note that its build line and §5 frontier are behind the journal.
2. [`notes/68-zero-data-roadmap.md`](notes/68-zero-data-roadmap.md) — the
   zero-data gap in detail, including the growth corrections, the subquadratic
   theorem, the Euler–Maclaurin strip bound, and the Jensen/Poisson assembly
   plan. Read through the correction sections; the early “second gap” framing
   predates rounds 520–543.
3. [`notes/67-programme-status-formalisation-complete.md`](notes/67-programme-status-formalisation-complete.md)
   — the formalisation inventory; several snapshots are historical, and its
   latest §3d (round 533) predates the closing of the strip gap in round 536.
4. [`notes/66-weil-positivity-frontier.md`](notes/66-weil-positivity-frontier.md)
   — the positivity frontier and the converse.
5. [`notes/65-explicit-formula-assembly-roadmap.md`](notes/65-explicit-formula-assembly-roadmap.md)
   — the classical assembly and its normalisation subtleties.
6. [`notes/69-zeta-cone-concepts-assessment.md`](notes/69-zeta-cone-concepts-assessment.md)
   — why the external zeta-cone visualisation does not prove arithmetic cone
   positivity.
7. [`notes/60-critical-line-route.md`](notes/60-critical-line-route.md) — why
   the critical-line route replaces the \(T\to\infty\) holomorphic limit.
8. [`notes/59-programme-status.md`](notes/59-programme-status.md) — the
   verified chain at a glance.
9. [`notes/56-explicit-formula-chain.md`](notes/56-explicit-formula-chain.md)
   and [`notes/54-final-assessment.md`](notes/54-final-assessment.md) —
   historical consolidation.
10. [`research-journal.md`](research-journal.md), rounds 504–543 — the current
    frontier, including the new `ZetaStrip.lean` results and the refutations.

## Appendix C — Baseline reconciliation

The following discrepancies were found while preparing this memo. They are
bookkeeping issues, not mathematical ones, but they should be corrected at the
next audit.

1. **Test count.** `HANDOFF.md` says “190 test cases” in §2, while its
   repository map records “113 test functions / 197 cases”; the journal and
   note 59 use 197, and the README current-state block still says 184.
   `python3 -m pytest -q tests` both collects and passes **197 tests** over 30
   test files. The HANDOFF build line and the README block are stale; use 197.
2. **Lean file count.** `HANDOFF.md` says “all nine files”, but the checked
   development now has **ten** files: the nine previous files plus
   `lean/ZetaStrip.lean`, compiled by `check.sh` with `LEAN_EXTRA_PATH`
   pointing at `../finite-window-zeros/lean`. The journal records 10 files and
   676 declarations. The HANDOFF repository map also omits `ZetaStrip.lean`.
3. **Lean declaration count.** The journal records **676 declarations**. A
   broad grep of the ten checked files gives 679; the difference is a counting
   convention (private helpers), not a missing theorem. The two untracked
   scratch files add 31 further declarations but are not in `check.sh`; they
   should be either integrated or removed.
4. **Note 67’s snapshots.** Its round-200 table still says the zero-free
   finite-order theorem is open and the strip bound unresolved. The
   subquadratic theorem (round 520) and the Euler–Maclaurin strip bound (round
   536) supersede those rows. Its “four gaps” list (round 533) also predates
   the closing of the strip gap.
5. **HANDOFF §5, item 2.** It still says the remaining work is the zeta strip
   growth and the multiplicity enumeration. The strip growth is closed; the
   actual frontier is the quotient-growth assembly, infinitude, and the
   enumeration. The heading “updated after round 495” is stale.
6. **README current state.** It contains two stale blocks: “round 273” and
   “round 469” (the latter says 9 files and 184 tests). The current state
   should point to this memo and the journal’s latest round; retain the old
   blocks as dated snapshots.
7. **Scratch files.** `lean/ScratchCirc1.lean` and `lean/ScratchCirc2.lean`
   are untracked working notes. They contain the machine-checked counterexample
   to the unrestricted \(2r\)-sphere bound and a separated version. They are
   not part of the checked build and must not be cited as such until
   integrated.

---

**No RH proof yet.**
