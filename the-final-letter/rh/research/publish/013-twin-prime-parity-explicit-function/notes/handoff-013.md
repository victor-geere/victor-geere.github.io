# HANDOFF — Part (A): `CriticalStripLogDerivBound χ` from the contour interface

**Directory** `research/twin-prime-parity/013/`
**Continues** `research/lean/` (read-only upstream)
**Sibling** `012` supplies the *numerical* checked-certificate engine; this handoff is the *analytic* Lean side
**Toolchain** Lean 4 `leanprover/lean4:v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`, elan at `$HOME/lean/elan`
**Status** **OPEN** — every analytic *input* to part (A) is committed and machine-checked; the **assembly** is not. 0 `sorry`, 0 `axiom`, all footprints `[propext, Classical.choice, Quot.sound]`.

> **UPDATE (2026-10-15, journal §§219–220) — read this before the rest.**
> 1. **The tree was not green when this brief was frozen.** The `GammaBounds.lean` edit of 19:15
>    (after this file) added six declarations that never elaborated; one of them, the Abel identity
>    `sum_Ico_mul_chi_cpow_eq`, was *false* (tail index `Ico m n` instead of `Ico m (n-1)`).  It is
>    deleted.  The "28 × OK" claim above was an artifact of piping `check.sh` into `tail`, which
>    masks the exit code.
> 2. **Step 3a is now DONE** (§219): the complex Abel capstone (`norm_sum_Ico_mul_cpow_le`,
>    `norm_sum_Ico_chi_cpow_le_cmplx`, `norm_sum_Ico_chi_succ_cpow_le`) and
>    **`norm_LFunction_le : ∃ C > 0, ∀ σ ∈ [1,2], ‖L(σ+it)‖ ≤ C(1 + log(|t|+2))`**.  The real-σ
>    capstone named in §6 of this brief no longer exists: its stated constant `2·N·(m+1)^{−σ}` is not
>    what the true Abel identity yields, and the complex form is what step 3b actually needs.

> ### UPDATE (2026-10-15, journal §256): steps 3a, 3b AND the convexity substitute are DONE
>
> | item | status |
> |---|---|
> | 3a, `sup_t ‖L(1+it)‖ < ∞` | ✅ §219 |
> | 3b, `Λ` bounded on the closed strip | ✅ §225 |
> | step-2 route, range-Cauchy → limit → holomorphy | ✅ §230–§250 |
> | **identification `LFunction χ s = dirichletSuccRangeLimit χ hχ s` on `0 < Re s`** | ✅ §252 |
> | **convexity substitute `∃ C, ‖LFunction χ (σ+it)‖ ≤ C(1+|t|)` on `1/2 ≤ σ ≤ 2`** | ✅ §256 |
>
> The route used **no Phragmén–Lindelöf, no complex Stirling, and no gamma ratio**: the `σ > 0` Abel
> capstone (§223) gives a lower-index difference bound (§246), hence uniform Cauchy on strips (§247),
> hence a limit function with local uniform convergence (§248–§250) that is holomorphic (§250) and
> equals `LFunction` on `0 < Re s` by the identity theorem (§252) — and the majorant then gives the
> polynomial strip bound (§256).
>
> Two mid-course corrections were needed and are recorded: the committed `norm_sum_Ico_chi_cpow_le`
> pairs `χ(i)` with `(i+1)^{−s}`, which is **not** the Dirichlet series (the first attempt targeted the
> wrong object — §242); the correct sequence uses `χ(i+1)` and
> `norm_sum_Ico_chi_succ_cpow_le_of_pos`, and shifting the sequence rather than paying the endpoint
> constant made the repaired chain simpler than the original (§245).
>
> **What remains of part (A)** is exactly §226's edge bounds (H)/(V) and the contour assembly into
> `CriticalStripLogDerivBound`.  §160's warning stands unchanged: the interface's contour integral has
> the zero count as its imaginary part, so discharging it *is* the Riemann–von Mangoldt theorem.  The
> (H)/(V) inputs are now all available; what they lack is the argument-principle count itself.
>
> 3. ~~**Step 3b is blocked on `Λ`'s growth in the strip**~~ — **STEP 3b IS DONE (journal §225)**.
>    `norm_dirichletCompleted_strip_le : ∃ C > 0, ∀ σ ∈ [0,1], ∀ t, ‖dirichletCompleted χ (σ+it)‖ ≤ C`
>    is committed in `DirichletStripBound.lean`.  The `PhragmenLindelof`/growth route of §203 was *not*
>    used and is not needed: for non-principal `χ` both correction terms in `ZMod.completedLFunction_eq`
>    vanish, so `Λ_χ` is a finite combination of `(hurwitzEvenFEPair a).Λ₀` and
>    `(hurwitzOddFEPair a).Λ`; `Λ₀ = mellin f_modif` and `f_modif` decays faster than every power at
>    **both** `0` (Mathlib's `WeakFEPair.hf_zero`) and `∞`, so `norm_mellin_le` bounds every vertical
>    strip directly.  What remains of part (A) is 3c and 4, which §160 says **is** Riemann–von Mangoldt.
> 4. `norm_Gammaℝ_le` was strengthened to `σ ∈ [1/2,2]`, so both parities of `γ(1+it)` are covered.
> 5. `./check.sh --all` is green again: **29** files, EXIT 0, 0 non-clean footprints.  The new
>    `DirichletStripBound.lean` (§221) commits the `Re s = 1` boundary bound `∃ C, ∀ t, ‖Λ(1+it)‖ ≤ C`
>    and `DiffContOnCl ℂ Λ (re ⁻¹'Ioo 0 1)`; only the growth hypothesis for `PhragmenLindelof.vertical_strip`
>    is missing.

> Read `../lean/README.md` (part (A) section) and journal §§169–218 first.  This file is the
> continuation brief; it does not restate the mathematics.

---

## 1. The objective, stated minimally

Make the 011/lean development close **without an analytic hypothesis**:

```lean
-- lean/DirichletZeroCounting.lean:480
def CriticalStripLogDerivBound {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
    (∫ x in (1/2 : ℝ)..1, ‖completedLogDeriv χ (x + t0 * I)‖)
    + (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * I)‖)
    + (∫ x in (1/2 : ℝ)..1, ‖completedLogDeriv χ (x + t1 * I)‖)
      ≤ C * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|)
```

so that `riemannVonMangoldtDensity_of_interface` (`DirichletZeroCount2.lean:468`) becomes callable with
`hcs` discharged, and the whole development stays green with **no `sorry`, no `axiom`, and footprints
within `[propext, Classical.choice, Quot.sound]`**.

**Note the object is the integral, not the integrand.**  A pointwise bound on `‖Λ′/Λ‖` over the strip is
**false** (journal §117): `deriv Λ / Λ` is unbounded *near* a zero while defined there.  The integral
bound is the correct statement and is exactly what the argument-principle count consumes (§81).

---

## 2. TL;DR

| item | status |
|---|---|
| **(B)** `digammaGrowthBound_of_pos : ∀ σ₀ > 0, DigammaGrowthBound σ₀` | **THEOREM** — `GammaBounds.lean:796`, **no complex Stirling** |
| **(C)** process institutionalisation (eleven rules, spec, seam) | **COMPLETE** — `lean/README.md` |
| **(A) step 1** `factorial_div_pow_le` and its chain | **DONE** — §§179–192 |
| **(A) step 2** `norm_Gamma_decay` on `[1/4,1]` + extensions + archimedean form | **DONE** — §§193–197, 202 |
| **(A) step 3a** `sup_t‖L(1+it)‖ < ∞` | **4 of 5 sub-lemmas done**; capstone fully specified (§§211, 217) |
| **(A) step 3b** `Λ` bounded on the closed strip via Phragmén–Lindelöf | **route fixed** (§203), not started |
| **(A) step 3c** `Λ′/Λ` by Cauchy | not started |
| **(A) step 4** the contour assembly | not started — **this *is* the Riemann–von Mangoldt theorem** (§160) |
| `riemannVonMangoldtDensity_of_interface` with `hcs` discharged | **OPEN** |

**TL;DR.** The hard analytic work is finished.  What remains is assembly, plus one genuine
session-scale theorem at the end.  Do **not** re-derive the `Γ` bounds and do **not** reach for complex
Stirling: it is not needed, and §199 (withdrawn) and §200 (restored) record why.

---

## 3. Build and verify

```bash
cd research/lean
./check.sh --all          # expects: 28 x "[check] OK", EXIT=0
```

| metric | value |
|---|---|
| files | **28**, all OK |
| failures | 0 |
| `GammaBounds.lean` declarations | **76** |
| tracked footprints (`AxiomsL.lean`) | **195** entries |
| footprint lines in the build | **237** |
| non-clean footprints | **0** |
| real `sorry` / `admit` / `axiom` / `native_decide` | **none** |

`check.sh` **does not reject `sorry`** — enforce it by grep, excluding the doc-comment headers:

```bash
grep -n "sorry\|axiom\|admit\|native_decide" *.lean \
  | grep -v 'No `sorry`\|no `sorry`\|no `axiom`\|and no `' 
```

`check.sh` takes one file for a quick loop (`./check.sh GammaBounds.lean`) or `--all`.  Elaboration is
in place; `.olean` files are written next to sources.

---

## 4. What is committed, and where

All in `../lean/GammaBounds.lean` unless stated.

**The `Γ` input — built from `n!/n^n ≤ exp(−(n−1)/2)`, with no Stirling, no lower bound on `Γ`, no
Weierstrass product, no Binet:**

| declaration | line | content |
|---|---|---|
| `norm_Gamma_le_decay_quarter` | 1472 | `‖Γ(↑σ + ↑t·I)‖ ≤ 128·(1+\|t\|)^σ·e^{−\|t\|/4}` for `1/4 ≤ σ ≤ 1` |
| `norm_Gamma_le_decay_upper` | — | same on `3/2 ≤ σ ≤ 2`, by `Γ(s) = (s−1)Γ(s−1)` |
| `norm_Gamma_le_decay_half` | — | the `[1/2,1]` form (§193) |
| `norm_Gammaℝ_le` | 1584 | archimedean form, `Re(s/2)` and `Re((s+1)/2)` both covered |
| `factorial_div_pow_ceil_le` | — | `⌈\|t\|⌉!/\|t\|^⌈\|t\|⌉ ≤ 8·e^{−\|t\|/4}` |

**The character-sum and Abel bricks (step 3a):**

| declaration | line | content |
|---|---|---|
| `norm_sum_range_chi_le` | 1651 | `‖∑_{k<n} χ k‖ ≤ N` — bounded partial sums |
| `sum_range_mul_chi_eq_zero` | 1634 | complete blocks vanish |
| `norm_natCast_cpow_neg` / `_anti` | 1674 / 1682 | Abel weight modulus and monotonicity |
| `sum_Ico_sub_telescope` | 1690 | `∑_{Ico m n}(g i − g (i+1)) = g m − g n` |
| `sum_Ico_rpow_sub_le` | 1700 | the variation telescopes to one weight value |

**Convexity / counting machinery already in place (do not rebuild):**

| declaration | file:line |
|---|---|
| `norm_le_three_lines` | `GammaBounds.lean:807` |
| `norm_le_of_three_lines_regularised` | `GammaBounds.lean:831` |
| `zeroCount_le_of_jensen` | `GammaBounds.lean:916` |
| `zeroDivisor` (`@[irreducible]`) | `GammaBounds.lean` — see §7 |
| `digammaGrowthBound_of_pos` | `GammaBounds.lean:796` |

---

## 5. What is NOT done

**3a — `sup_t ‖LFunction χ (1+it)‖ < ∞`.**  Four of five sub-lemmas are committed (§§212/215/216 and
`GammaBounds.lean:339`).  **The capstone is fully specified** (see §6).  The fifth sub-lemma, the
`HasSum` / `LFunction_eq_LSeries` assembly, is untouched.

**3b — `Λ` bounded on the closed strip.**  Route fixed in §203: run `Phragmén–Lindelöf` on **`Λ`
directly**, not on `L`.  Because `Λ(s) = ε(s)Λ(1−s)` has **no `γ`-ratio**, and
`PhragmenLindelof.vertical_strip` (§157) admits growth `exp(B exp(c|Im|))` for any `c < π`:

* boundary `Re = 1`: `Λ(1+it) = N^{(1+it)/2}·γ(1+it)·L(1+it)`, with `γ` bounded **with decay** by §202;
* boundary `Re = 0`: **`Λ(it) = ε(it)·Λ(1−it)`** — equal to a `Re = 1` value, so `Re = 0` is never
  evaluated and no `Γ` lower bound and no `γ`-ratio is ever needed;
* growth: `Λ`'s strip growth is `L`'s (the `Γ` factor *decays*), and crude `≪ exp(A|t|)` suffices.
  **No convexity bound on `L` is presupposed** — the naïve order (bound `L`, then `Λ = N^{s/2}γL`) is
  circular and must be avoided.

**3c — `Λ′/Λ` by Cauchy** on the strip.

**4 — the contour assembly into `CriticalStripLogDerivBound`.**

> **Do not mistake (4) for a formality.**  Journal §160 established that the contour integral's imaginary
> part *is* the zero count:
> `Im (rightPath (logDeriv Λ) t₀ t₁) = π · ∑_{z ∈ Z} m z`.
> **Step 4 is the Riemann–von Mangoldt theorem.**  That is why part (A) is still open and why this
> handoff is a brief rather than a completion note.

---

## 6. Step 3a's recipe — complete to the lemma

**The capstone to prove** (sketched and reverted in §217; the sketch located the obstacles and is *not*
in the tree, because its scaffolding used `sorry`):

```lean
theorem norm_sum_Ico_chi_cpow_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {σ : ℝ} (hσ : 0 ≤ σ) {m n : ℕ} (hmn : m < n) :
    ‖∑ i ∈ Finset.Ico m n, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-(σ : ℂ)))‖
      ≤ 2 * (N : ℝ) * ((m + 1 : ℕ) : ℝ) ^ (-σ)
```

**Tool:** `Finset.sum_Ico_by_parts` — **Abel's lemma** — at
`Mathlib/Algebra/BigOperators/Module.lean:25` (the name is **not** `summation_by_parts`):

```lean
theorem sum_Ico_by_parts (f : ℕ → R) (g : ℕ → M) (hmn : m < n) :
    ∑ i ∈ Ico m n, f i • g i =
      f (n - 1) • G n - f m • G m - ∑ i ∈ Ico m (n - 1), (f (i + 1) - f i) • G (i + 1)
-- where G n = ∑ i ∈ range n, g i
```

Take `g i = χ (i : ZMod N)` and `f i = ((i+1 : ℕ) : ℂ) ^ (-(σ : ℂ))`.  Then **`G n` is exactly what
`norm_sum_range_chi_le` bounds** (`≤ N`), and

```
‖∑_{i ∈ Ico m n} f i · χ i‖ ≤ ‖f (n−1)‖·N + ‖f m‖·N + ∑_{i ∈ Ico m (n−1)} ‖f (i+1) − f i‖·N
```

`f` is decreasing for `σ ≥ 0`, so the variation telescopes (`sum_Ico_rpow_sub_le`):
`∑‖f (i+1) − f i‖ ≤ f m`, giving the stated `2·N·(m+1)^{−σ}`.

**Then, with `M = ⌈|t|⌉`, uniformly for `σ ∈ (1,2]`:**

```
‖L(σ + it)‖ ≤ (1 + log(⌈|t|⌉ + 1)) + 2·N·(⌈|t|⌉ + 1)^{−σ} ≤ C·(1 + log(|t| + 2))
```

splitting `∑_{i<n} = ∑_{i<M} + ∑_{i ∈ Ico M n}`, the head by the harmonic bound
`GammaBounds.lean:339` (`sum_range_inv_succ_le_log`), the tail by the above.  Use
`LFunction_eq_LSeries` (`DirichletContinuation.lean:75`) for `σ > 1` and continuity
(`differentiableAt_LFunction`, `:92`) to transfer to `σ = 1`.

### The three obstacles, exactly (from §217)

All three are **statement-shape problems, not mathematics**.  Ninth through eleventh instances of the
session's dominant lesson.

1. **`sum_Ico_by_parts` is a `•`-statement**, the target a `*`-statement.  Bridge with
   `Finset.sum_congr` + `smul_eq_mul` + `mul_comm`, supplying `R := ℂ`, `M := ℂ` **explicitly**.
2. **`Complex.ofReal_cpow`** is needed to move `((k+1 : ℕ) : ℂ) ^ (-(σ:ℂ))` onto the positive real axis
   where `norm_natCast_cpow_neg` (§212) applies — a *second* equal-but-not-defeq cast bridge, same
   species as §212's.
3. **The `ℂ`/`ℝ` transfer**: `‖f (i+1) − f i‖ = ‖f i‖ − ‖f (i+1)‖` needs both terms recognised as
   positive reals before `abs_of_nonneg` can fire.

---

## 7. Hazards — established, do not re-derive

* **Do NOT weaken the interface** to assume a zero-free margin.  That is the hypothesis the *conclusion*
  is used to supply, and it reintroduces the circularity of journal §118.
* **§160.**  `CriticalStripLogDerivBound` is essentially *equivalent* to the Riemann–von Mangoldt count
  bound.  It is the theorem, not a cheap lemma.  Budget accordingly.
* **§199 is WITHDRAWN; §200 restores §195.**  The `γ`-ratio is **never bounded** by the correct route.
  Three-lines consumes boundary **values**; `Λ(s) = ε(s)Λ(1−s)` makes the two boundary values equal, so
  `Re = 0` is never evaluated.  A route that bounds `γ(1−s)/γ(s)` as a ratio *does* need the sharp
  `e^{−π|t|/4}` per `Γ` factor (the reflection `sin` carries `e^{+π|t|/2}`), and the `GammaSeq`/`sup`
  route caps at `c = 1 < π/2` — **that route is not taken, and must not be.**  If you find yourself
  needing a sharper constant, you have chosen the wrong route.
* **Jensen.**  `zeroCount_le_of_jensen` (§166) and the `@[irreducible] zeroDivisor` wrapper are
  committed.  Place the disc centre **inside** the strip — Jensen degrades when `f` is exponentially
  small at the centre.  The wrapper exists because `MeromorphicOn.divisor` in a *statement* blows the
  200000-heartbeat cap; keep it irreducible.
* **Circularity.**  The development's own `zeroCountUpTo_le_quadratic` is **downstream** of
  `RiemannVonMangoldtDensity` (`zeroCountUpTo_le_of_density`) — it is circular and unusable.
* **README rule 3.**  Read a Mathlib directory file-by-file before declaring anything absent.  See §9.

---

## 8. Process lessons — the highest-value part of this handoff

**1. The library is richer in content and narrower in naming than intuition suggests.**
**Seventeen** believed Mathlib gaps turned out not to be gaps — four were whole files never opened, and
the seventeenth found the missing ingredient **inside the development's own file** under a *more
general* statement.  Three went the other way: lemmas *assumed* to exist that do not —
`Finset.sum_Ico_sub`, `le_or_lt` (as a usable identifier), `Real.one_le_pi`.

**2. Six verdicts of impossibility were reversed** (§§163/167/175/195/199/200).  Every one traced to a
**one-line check deferred too long**: a range endpoint (`[2,9/4] ⊄ [3/2,2]`, decided by `9 > 8`), a
lemma's hypothesis shape, or a use-site reading.  **Before building on a "gap", check the exponent, the
endpoint and the shape.**

**3. Ten bricks were unblocked by *stating the obligation explicitly*** — `calc`, `Finset.sum_congr`,
`show … by ring`, and explicit `have` bridges between equal-but-not-defeq casts — never by adding
tactics.  **When a Lean goal resists, the cause is the shape of an available lemma.**  Concrete instances
worth copying:
* `rw` is **all-or-nothing** across a list (§148): one non-matching lemma silently discards the rest.
* `simp` does not reach under `χ`'s argument when the index is a compound `ℕ → ZMod` cast — use
  `Finset.sum_congr` (§208).
* `rw [h]` cannot fire under a different association; insert `_ = _ := by ring` first (§196).
* Equal-but-not-defeq casts (`((k+1 : ℕ) : ℂ)` vs `(((k+1 : ℕ) : ℝ) : ℂ)`) need an explicit `have` (§§212, 214, 217).
* `π ^ (-s/2)` parses as `π ^ ((-s)/2)` — **not** defeq to `π ^ (-(s/2))` (§202).
* `simp at h` can **close** a goal; a following `linarith` then errors "no goals" (§§190, 194, 216).
* `rpow_add_one` wants `x ≠ 0`, not `0 ≤ x`; `norm_cpow_eq_rpow_re_of_pos` wants the real cast (§§196, 202).
* `le_or_lt` is unavailable; use `by_cases` + `not_le.mp` (§§193, 215).

**4. Strengthening a hypothesis deletes a branch** (§216: carrying `m ≤ n` instead of proving the
degenerate case), and **a committed partial result beats a scaffolded near-miss** (§217: a `sorry`-using
sketch was deleted and the tree re-verified green).

**5. Read the goal in the *error report*, not the line number** (§188): `set N := …` reports errors
attributed to the *statement* line while the fault is in the trailing `calc`.

---

## 9. Where to look

| what | where |
|---|---|
| the paper | `../html/dirichlet-011.html` |
| part (A) spec, final state, the residual | `../lean/README.md` |
| the full session record | `../../../research-journal.md` §§169–218 (369 sections) |
| the sealed interfaces | `../lean/DirichletZeroCount2.lean:409/454/468` |
| the contour interface | `../lean/DirichletZeroCounting.lean:480` |
| the argument principle | `../lean/DirichletZeroCounting.lean:84` |
| numerical checked certificates | `../012/` (independent; imports nothing from 011 at runtime) |
| Mathlib | `$HOME/lean/mathlib4` |

**Journal sections that matter most:** §160 (the equivalence), §195 (the `Γ` decay),
§§199–200 (the withdrawn/restored verdict — read both), §203 (the step-3b route), §208 (bounded partial
sums), §211 (the Abel recipe), §217 (the three bridges).

---

## 10. Suggested first moves

1. Prove **`norm_sum_Ico_chi_cpow_le`** (§6).  Three bridges, all mechanical.  Then the `L(1+it)`
   estimate follows from `LFunction_eq_LSeries` + the harmonic bound at `GammaBounds.lean:339`.
2. **3b**: assemble `DiffContOnCl`, the growth hypothesis and the two boundary bounds for `Λ`, then
   `PhragmenLindelof.vertical_strip`.  Keep the `Re = 0` boundary *unvisited* (§7).
3. **3c**: `Λ′/Λ` by Cauchy.
4. **4**: the contour assembly.  Before starting, re-read §160 and decide whether this is a session or a
   project.  If it is a project, say so in the record rather than leaving a `sorry`.

**Do not** reopen (B) or (C).  **Do not** weaken the interface.  **Do not** introduce complex Stirling —
the `Γ` input is done and any need for a sharper constant indicates a wrong route (§7).
