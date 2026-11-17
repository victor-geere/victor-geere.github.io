# Handoff — building `ζ` from theta

**Status:** **complete**, with one documented residual. D0–D5 and D7 are done;
D6 is done at the level of the value and the removable limit, but the
independent multiplicity proof described in §4 M5 was not carried out (the
removable-singularity statement is proved through the D5 identification). M6 is
assembled unconditionally, with the same statement as
`riemannZeta_one_sub_theta'`. See the [completion record](#11-completion-record)
below.
**Effort:** 2–3 focused sessions. Most of the analysis already existed as the
`ZetaTheta` layer; the work was the assembly of a standalone object, the
`Γℝ`-zero bookkeeping, and the migration/import plumbing.
**Depends on:** Lean `v4.35.0-rc2`, the `ZetaTheta` layer in
[`../zeta-functional-equation/lean`](../zeta-functional-equation/lean)
(V1–V40), and Mathlib's Mellin-transform library.
**Blocks:** nothing. It is an architectural improvement, not a prerequisite for
any open problem in the repository.

---

## 1. Objective

Define the Riemann zeta function **from the theta side** — Dirichlet series →
theta Mellin transform → theta functional equation → meromorphic continuation —
so that the functional equation for `ζ` is available with a dependency cone that
contains **no** `*_one_sub` lemma of Mathlib's zeta/Hurwitz development, and only
afterwards identify the object with Mathlib's `riemannZeta` through the shared
Dirichlet series.

Why this is worth doing (and what it is not) is argued in the topic
[README](README.md) §1: Mathlib defines `riemannZeta := hurwitzZetaEven 0` and
proves the functional equation through Hurwitz zeta, so any argument that needs
the functional equation *while developing the Hurwitz development* is stuck.
The theta route grounds the functional equation in Poisson summation and Gamma
reflection instead, and this handoff removes the remaining dependency, which is
**definitional**: `ζ` itself.

In a formal system this cannot create new reach — a cycle is simply an absent
proof. The deliverable is a **proof-architecture** result: a functional equation
whose provenance is auditable to four named, functional-equation-free
ingredients.

---

## 2. Current state

### 2.1 The theta layer (exists, proved)

`../zeta-functional-equation/lean/Theta.lean`, `Mellin.lean`, `Zeta.lean`,
namespace `ZetaTheta`. Relevant milestones:

| step | lemma | location |
|---|---|---|
| theta series, summability, positivity | `summable_theta`, `theta_pos` | `Theta.lean` |
| **theta functional equation** | `theta_one_div` | `Theta.lean:69` |
| Mellin transform of the kernel | `hasSum_mellin_psi` | `Mellin.lean:42` |
| Dirichlet form | `hasSum_mellin_psi_dirichlet` | `Zeta.lean:45` |
| **Mellin representation of `Λ`** | `mellin_psi_eq_completed` | `Zeta.lean:164` |
| substitution `t ↦ 1/t` | `integral_Ioc_psi_eq` | `Zeta.lean:248` |
| split at `1` | `mellin_psi_split` | `Zeta.lean:573` |
| **symmetric integral form** | `completedRiemannZeta_eq_symmetric_integral` | `Zeta.lean:749` |
| **continuation `Λ = Λ̃` everywhere** | `completedRiemannZeta_eq_LambdaTilde_all` | `Zeta.lean:1025` |
| **`Λ(1−s) = Λ(s)`** | `completedRiemannZeta_one_sub_theta` | `Zeta.lean:1060` |
| **classical form** | `riemannZeta_one_sub_theta'` | `Zeta.lean:1104` |

### 2.2 The bridge (exists, proved here)

`lean/Topic.lean`: `zetaSeries` (D), `summable_zetaSeries` (T1),
`zetaSeries_eq_riemannZeta` (T2), `zetaSeries_eq_completed_div` (T3).

### 2.3 What is missing

1. The theta layer is **not an object**: there is no `zetaTheta : ℂ → ℂ`.
2. The layer lives in another topic's folder; the import plumbing is per-file
   `LEAN_EXTRA_PATH`, not a stable library boundary.
3. The `Γℝ` zeros are not handled: `Λ/Γℝ` is `0/0` at `s = −2n`.
4. No provenance audit; independence is currently a claim in prose.

---

## 3. Deliverables

| id | deliverable | acceptance |
|---|---|---|
| **D0** | canonical home for the theta layer under `lean/` of this topic, namespace unchanged (`ZetaTheta`) | `./check.sh Topic.lean Theta.lean Mellin.lean Zeta.lean` green; `../zeta-functional-equation` still builds |
| **D1** | `zetaThetaSeries : ℂ → ℂ` (the Dirichlet series) — **done** (`zetaSeries`) | build |
| **D2** | `LambdaTheta s := ∫_1^∞ ψ(t)(t^{s/2−1}+t^{(1−s)/2−1})dt + 1/(s−1) − 1/s` as a *definition*, with `LambdaTheta_eq_mellin : LambdaTheta s = mellin ψ (s/2)` on `Re s > 1` | build + statement |
| **D3** | `zetaTheta s := LambdaTheta s / Gammaℝ s` for `Gammaℝ s ≠ 0`, with a proof it agrees with the Dirichlet series on `Re s > 1` | build |
| **D4** | **functional equation:** `zetaTheta (1 - s) = 2*(2π)^{-s}*Γ(s)*cos(π s/2) * zetaTheta s` under `s ∉ {1} ∪ {−2n}`, derived from the symmetry of `LambdaTheta` — **no** Mathlib `*_one_sub` | build + provenance audit |
| **D5** | **identification:** `zetaTheta s = riemannZeta s` for `s ∉ {1} ∪ {−2n}` (agreement on `Re s > 1` + analyticity) | build |
| **D6** | the trivial zeros: `zetaTheta (−2n) = 0` and the removable singularity of `LambdaTheta/Gammaℝ` there | build |
| **D7** | **provenance audit** (§7) | script + recorded output |

D4/D5 as stated **exclude** the `Γℝ` zeros; D6 removes the restriction. Do not
attempt D6 first — it is the only genuinely new analysis in the list.

---

## 4. Lean work breakdown

### M0 — library boundary (D0)

Files move from `../zeta-functional-equation/lean/` to `lean/` here, unchanged
except for import lines. `check.sh` already delegates to
`../../tools/check-lean.sh`, which puts the file's own directory on `LEAN_PATH`,
so intra-directory imports keep working.

Then update `../zeta-functional-equation/lean/check.sh` to point
`LEAN_EXTRA_PATH` at `../zeta-from-theta/lean` (the pattern already used there
for `absolute-polarized-hodge-index-realization/lean`), and change its
`Topic.lean` to `import` this topic's `Topic`. **Check both topics build** —
this is the step most likely to break something.

Alternative if a move is undesirable: copy the three files and let the two
copies diverge, with a comment in both READMEs. Not recommended; the point is a
single audited object.

### M1 — the continuation as a definition (D2)

```lean
noncomputable def LambdaTheta (s : ℂ) : ℂ :=
  (∫ t in Set.Ioi (1:ℝ),
      psi t * ((t : ℂ) ^ (s / 2 - 1) + (t : ℂ) ^ ((1 - s) / 2 - 1))) + (1 / (s - 1) - 1 / s)
```

The equality with `mellin ψ (s/2)` on `Re s > 1` is
`completedRiemannZeta_eq_symmetric_integral` with `LambdaTilde` unfolded — pure
bookkeeping, but it is the bridge between the definition and the proved layer.
`LambdaTilde` already exists in the layer; either rename it or define
`LambdaTheta := LambdaTilde`.

Analyticity: `differentiableAt_LambdaTilde` is already proved
(`s ∉ {0,1}`), via `mellin_differentiableAt_of_isBigO_rpow_exp`.

### M2 — the theta-side zeta (D3)

```lean
noncomputable def zetaTheta (s : ℂ) : ℂ := LambdaTheta s / Complex.Gammaℝ s
```

* agreement with the series: `hs : 1 < s.re` gives `Gammaℝ s ≠ 0`
  (`Complex.Gammaℝ_ne_zero_of_re_pos`) and `LambdaTheta s = Γℝ(s)·Σ n^{−s}`
  (T3 backwards, i.e. `zetaSeries_eq_completed_div`);
* statement to prove:
  `zetaTheta_eq_zetaSeries : 1 < s.re → zetaTheta s = zetaSeries s`.

### M3 — the functional equation (D4)

From `LambdaTheta (1-s) = LambdaTheta s` (immediate from the definition: the
two exponents swap and `1/((1−s)−1) − 1/(1−s) = 1/(s−1) − 1/s`; cf.
`LambdaTilde_one_sub`), divide by `Gammaℝ (1-s)`:

```lean
theorem zetaTheta_one_sub {s : ℂ}
    (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1) (hG : Complex.Gammaℝ (1 - s) ≠ 0) :
    zetaTheta (1 - s) = 2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s *
      Complex.cos (Real.pi * s / 2) * zetaTheta s
```

This mirrors `riemannZeta_one_sub_theta` (already proved for `riemannZeta`)
line-for-line, with `zetaTheta` in place of `riemannZeta` and **no** use of
`riemannZeta_def_of_ne_zero` or any Hurwitz lemma.

### M4 — identification (D5)

```lean
theorem zetaTheta_eq_riemannZeta {s : ℂ}
    (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1) : zetaTheta s = riemannZeta s
```

Route: both sides are analytic off `{0,1}` (for `zetaTheta`: `LambdaTheta`
analytic and `Gammaℝ` nonvanishing off `{−2n}`; handle those points via D6 or
keep the hypothesis), and they agree on `Re s > 1` by M2/T2. Use
`AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq` exactly as
`completedRiemannZeta_eq_LambdaTilde_all` does — the preconnectedness of a
co-countable complement is
`Set.Countable.isConnected_compl_of_one_lt_rank` with
`Complex.rank_real_complex`.

### M5 — trivial zeros (D6, the only new analysis)

At `s = −2n`, `Gammaℝ s = 0` (`Complex.Gammaℝ_eq_zero_iff`), so `Λ_θ/Γℝ` is
`0/0`. Two candidate routes, in order of preference:

1. **Multiplicity bookkeeping.** Show `LambdaTheta` has a simple zero at `−2n`
   and `Gammaℝ` a simple zero there, so the ratio extends with value
   `LambdaTheta'(−2n)/Gammaℝ'(−2n)`. Concretely, from the symmetric integral at
   `s = −2n` the two exponents are `−n−1` and `n−1/2`; the integral is the
   difference of two Beta-type integrals, and the vanishing is the
   `1/(s−1) − 1/s` cancellation at a point where `1/(s−1)` and `1/s` are both
   finite. This needs the explicit evaluation
   `∫_1^∞ ψ(t)t^{−n−1}dt` or an integration-by-parts recursion from
   `LambdaTheta(s+2) = ...`; the `Γℝ(s+2) = Γℝ(s)·s/(2π)` recurrence
   (`Complex.Gammaℝ_add_two`) suggests a downward recursion for `zetaTheta`
   instead, which is circular unless anchored. **Estimate: 1 session.**
2. **Hadamard/Weierstrass factorisation.** Define `zetaTheta` by its Weierstrass
   product and show the product satisfies the same functional equation. Cleaner
   mathematically, but a new chunk of formalisation (the product is not in the
   repo). **Estimate: 2+ sessions.**

If D6 stalls, publish D4/D5 with the `Gammaℝ`-nonvanishing hypothesis and say
so: this is exactly the shape of `riemannZeta_one_sub_theta'` (which handles
`s = 1+2n` by the trivial-zero theorem on the *other* side, and has no such
problem because `riemannZeta` is already defined everywhere).

> **Execution note (2026-11-09): the premise of route 1 is wrong.**  Analytically
> `Γℝ(s) = π^{−s/2}Γ(s/2)` has a *pole* at `s = −2n`, not a zero, and `Λ_θ(s)` is
> finite and non-zero there (`ξ(s) = ½s(s−1)Λ(s)` is entire with no zero at a
> negative even integer).  Lean's `Complex.Gamma` assigns `0` at its poles, so
> `Complex.Gammaℝ_eq_zero_iff` is a statement about that convention, and `Γℝ` is
> discontinuous at `−2n`.  The quotient `Λ_θ/Γℝ` therefore tends to `0` because
> the denominator blows up, which is the correct value `ζ(−2n) = 0`.  D6 was
> completed by proving that punctured limit (through D5), not by a multiplicity
> count; a purely theta-side proof of the same limit remains the only residual.

### M6 — assemble

`zetaTheta_eq_riemannZeta` + `zetaTheta_one_sub` gives
`riemannZeta_one_sub_from_theta` with the identical statement to
`riemannZeta_one_sub_theta'` but a different proof and a different dependency
cone. Replacing the latter in `../zeta-functional-equation` is the point of the
exercise; keep both and record the comparison.

---

## 5. Integration tasks

Each is a small, independent edit; do them after M3 at the earliest, since the
benefit only exists once the functional equation is available from the theta
side.

| id | topic | task |
|---|---|---|
| **I1** | `zeta-functional-equation` | point `check.sh` at this topic (M0); add a "provenance" paragraph to its README recording that T1–T3 now have an in-repo construction behind them; keep its V-ledger where it is and cross-link |
| **I2** | `angular-partition-method` | in its README §7.9/§13 add a cross-reference: T57 (`completedMellinPart_one_sub`) is the annular-integral form of the same symmetry that `completedRiemannZeta_eq_symmetric_integral` proves from theta, and O7's continuation to `−3 < Re s` is a third route. Nothing to prove; one paragraph + link |
| **I3** | `digamma-contour-shift` | cite `zetaTheta_one_sub` as the functional-equation source for its archimedean evaluation, removing any dependence on the Hurwitz route; check whether it imports `*_one_sub` and, if so, swap |
| **I4** | `archimedean-prime-evaluation` | same as I3 for the archimedean factor `Γℝ`; note in its README that the pole/archimedean bookkeeping is now available function-equation-free |
| **I5** | `weil-positivity`, `missing-bridge` | add a short "dependency note": the explicit formula's pole terms and the `h ↔ ĥ` pairing consume the functional equation; with D4 that consumption no longer routes through Hurwitz zeta. **Do not change any positivity status** — the open statement stays open |
| **I6** | `absolute-polarized-hodge-index-realization` | cross-link from `notes/61-angular-bochner-framework.md` (which already mentions the angular partition) and record `zetaTheta` as the base object for index-theoretic arguments |
| **I7** | `zero-sum-convergence` | cross-link: the `ζ ↔ Λ` zero correspondence (T5 there) can be cross-checked against the theta-side object once D5 is in place |

**Do not** edit generated files by hand: `topics/index.html`,
`topics/index-lean.md`, `topics/lean-graph.html`,
`topics/lean-conjecture-graph.html` are rebuilt by
`topics/tools/build_*.py`. `topics/README.md`, `topics/STATUS.md` and
`the-final-letter/research-journal.md` are maintained by hand.

---

## 6. Acceptance criteria

The handoff is complete when all of the following hold:

1. `cd topics/zeta-from-theta/lean && ./check.sh Topic.lean` is green, and the
   topic's `Topic.lean` re-exports the whole theta layer.
2. `topics/zeta-functional-equation` still builds after M0.
3. No `sorry`/`axiom`/`admit` anywhere (the structural audit enforces this).
4. `python3 tools/audit_topics.py` prints 62/62 (63/63 after this topic is
   registered).
5. `python3 the-final-letter/tools/check-links.py` is clean.
6. `python3 -m pytest -q zeta-from-theta/tests` passes.
7. The provenance audit (D7) is recorded, including its limits.
8. `STATUS.md` and `topics/README.md` carry the new row; the journal has an
   entry.

---

## 7. Provenance audit (D7)

Independence is not a Lean notion, so it must be *audited*, and the audit's
limits stated.

**Method A (file-level, already done once).** For each lemma in the dependency
cone that is not generic analysis, record the file it lives in and check that
file for the forbidden names:

```bash
grep -c "riemannZeta\|completedRiemannZeta" ~/lean/mathlib4/Mathlib/Analysis/SpecialFunctions/Gaussian/PoissonSummation.lean   # 0
grep -n "one_sub" ~/lean/mathlib4/Mathlib/NumberTheory/LSeries/MellinEqDirichlet.lean                                        # none
```

**Method B (constant-level).** `#print axioms` only lists axioms, not
dependencies. To walk the constants of a declaration, write a custom command in
`lean/Audit.lean` using `Lean.Elab.Command` and the environment's declaration
data, collect every `ConstantInfo` reachable from
`riemannZeta_one_sub_from_theta`, and assert that none is named
`riemannZeta_one_sub`, `completedRiemannZeta_one_sub`, or
`completedHurwitzZetaEven_one_sub`. This is the only rigorous form of the claim.

**Method C (negative build, strongest but disruptive).** Build the topic against
a Mathlib clone in which the `*_one_sub` theorems are replaced by
`theorem ... : False := by sorry`-free stubs of a *different name*, so that any
accidental use fails to resolve. Expensive; do it once, at the end, and record
the commit used.

Record in `README.md` exactly which method was used. **Until Method B or C is
run, describe the result as "spot-checked", not "proved independent".**

---

## 8. Risks and mitigations

| id | risk | mitigation |
|---|---|---|
| **R1** | the `Γℝ` zeros make `Λ/Γℝ` `0/0` at `s = −2n`; D6 is genuinely new analysis | ship D4/D5 with the nonvanishing hypothesis first (the shape of `riemannZeta_one_sub_theta'`); treat D6 as a separate deliverable; say so in the README |
| **R2** | moving the layer breaks `zeta-functional-equation` | do M0 as its own commit, build both topics, keep the namespace |
| **R3** | a transitive import silently reintroduces the functional equation | D7 audit; and keep the layer's imports to `Mathlib` + nothing from the zeta development |
| **R4** | `complex.Gamma`'s definitional quirks at nonpositive integers (Lean's division conventions) | the layer already handles `0/0` by hypothesis-guarding; keep that style |
| **R5** | scope creep into an RH attempt | the topic's README "What this does and does not give" is binding: no positivity, no zero location, no simplicity |
| **R6** | numerical tests flaky in CI | tolerances are tail bounds (`N^{1−σ}/(σ−1)`), not machine precision; C2/C3 use quadrature with `mp.dps = 15` and `1e-8` |
| **R7** | the value of the exercise is overstated | state plainly: no new theorem, no new reach; the benefit is (i) breaking the Hurwitz ↔ functional-equation loop, (ii) a second auditable route, (iii) an object usable where Hurwitz zeta is not developed |

---

## 9. Non-claims

* **No Riemann hypothesis content.** Nothing here locates, counts, or bounds a
  zero, and nothing here is positive-definite.
* **No new theorem.** Every statement in D1–D6 is classical. The deliverable is
  a construction and its provenance.
* **"Independent" means the proof, and after D3 the construction — not the
  value.** The function is the same function; only the route to it changes.
* **D5's equality is not a claim that Mathlib's `ζ` was wrong**; it is the
  check that the two constructions agree.

---

## 10. Provenance

* The theta layer (V1–V40) was written in this repository on 2026-11-09; the
  curve of work is recorded in [`../../research-journal.md`](../../research-journal.md)
  under "Theta programme, stage 1–23". Key milestones and their line numbers are
  in §2.1 above.
* The dependency spot-check in README §1 was run on 2026-11-09 against
  Mathlib at toolchain `leanprover/lean4:v4.35.0-rc2`.
* The bridge `zetaSeries_eq_riemannZeta` uses only
  `zeta_eq_tsum_one_div_nat_cpow` and `Real.summable_one_div_nat_rpow`.
* The recommendation "build `ζ` from theta rather than Hurwitz" is the answer
  given to the circularity question posed at the end of that work; this handoff
  is its implementation plan.

[Topic README](README.md) · [Topic index](../index.html) · [Ledger](../STATUS.md)

---

## 11. Completion record

Worked on 2026-11-09 in one pass. What landed:

* **M0** — `Theta.lean`, `Mellin.lean`, `Zeta.lean` moved to
  [`lean/`](lean), namespace `ZetaTheta` unchanged, plus a new
  [`ThetaLayer.lean`](lean/ThetaLayer.lean) aggregate. `zeta-functional-equation`
  now imports `ThetaLayer` and points its `LEAN_EXTRA_PATH` here; both topics
  build.
* **D2–D5** — `LambdaTheta`, `zetaTheta`, `LambdaTheta_eq_mellin`,
  `LambdaTheta_one_sub`, `differentiableAt_LambdaTheta`,
  `zetaTheta_eq_zetaSeries`, `zetaTheta_one_sub`, `zetaTheta_eq_riemannZeta`.
  D4 was proved without any Mathlib `*_one_sub`.
* **D5 strengthened** — `zetaTheta_eq_riemannZeta_of_ne_zero_one`: the
  identification needs only `s ≠ 0` and `s ≠ 1`, which is what makes D6 work.
* **D6** — `zetaTheta_trivial_zero` and
  `zetaTheta_removable_at_trivial_zero`. The second proves the punctured limit
  is `0` by agreeing with `riemannZeta` near `−2(n+1)`.  The multiplicity route
  of §4 M5 is not available as stated (see the execution note there); a purely
  theta-side proof of the same limit remains open.
* **M6** — `riemannZeta_one_sub_from_theta`, and the unconditional
  `riemannZeta_one_sub_from_theta'` with the *same statement* as
  `riemannZeta_one_sub_theta'` (the `s = 1 + 2n` branch is handled by both sides
  vanishing). Both pass the audit.
* **D7** — [`lean/Audit.lean`](lean/Audit.lean) (Method B, constant-level walk)
  and [`lean/AUDIT.md`](lean/AUDIT.md). All five targets pass: none of the seven
  forbidden names is in the 51k–55k-declaration cone. Two negative controls
  (direct and transitive) confirm the walker flags a forbidden constant. Method C
  was not run.
* **I1–I7** — integration notes added in the seven dependent topics; no
  positivity status changed.
* Counts: no `sorry`/`axiom`/`admit`; `audit_topics.py` 63/63; pytest 6/6;
  `check-links.py` clean after regenerating the Lean index.

Residual work, in one line: prove independently that `Λ_θ` has the required
vanishing order at `−2n` (or run Method C). The functional-equation statement
itself is now complete and audited; the residual is the *route* used for D6's
removable limit, not the theorem's statement.
