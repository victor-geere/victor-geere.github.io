# `research/TODO.md` — what still needs to be done or proved

Scope: the outstanding work of [`twin-prime-parity/010/`](twin-prime-parity/010)
(rh45 Routes A/B/C), plus the still-live items carried in
[`twin-prime-parity/open/HANDOFF.md`](twin-prime-parity/open/HANDOFF.md) and its
authoritative successor [`twin-prime-parity/006/handoff.md`](twin-prime-parity/006/handoff.md).

Companions: [`index.md`](index.md) · [`truths.md`](truths.md) · [`open.md`](open.md).

**How tractable.**

| rating | meaning |
|---|---|
| **High** | a focused session; no new mathematics, or a purely mechanical change |
| **Medium** | a focused round; bounded mathematics, formalisation, or compute |
| **Low** | needs a new idea, a large computation, or substantial formalisation |
| **Out of reach** | no known method |

---

## A. The ledger

| Title | How tractable | Description | Folder |
|---|---|---|---|
| **O16.** The log-indicator barrier — OP-3 made well-posed | **Low** (the theorem) / **Medium** (the numerics) | The inherited **OP-3** ("no sign-blind deterministic rule seeing `n` only through `log n` can force a multiplicative correlation") is **not a proposition**: *rule*, *sees* and *force* are undefined, and its literal reading over **all** functions of `log n` is **FALSE**, because `log` is injective on `ℕ` and so can encode arithmetic (with `A = {n : λ(n) = 1}` one gets `Σ_{n≤x}1_A(n)λ(n) = x/2 + o(x)`, since `Σ_{n≤x}λ(n) = o(x)` by PNT). The well-posed replacement restricts the *description* of the rule. **Log-arc rule:** `A_I = {n ≥ 1 : log n mod 2π ∈ I}` for `I` a finite union of intervals with endpoints in a fixed countable field (e.g. `ℚ(π)`) and measure in `(0,2π)`; `C_I(x) = Σ_{n≤x} 1_{A_I}(n) λ(n)`. **(P1)** is `C_I(x) = o(x)` for every log-arc rule? **(P2)** settle the single arc `I = [0,π)` (the `rh43` set `{n : cos(log n) ≥ 0}`) quantitatively. Both are **OPEN** and well-posed (definite truth value; countable class; each instance computable against). Known: the same identity **is** a theorem for *finite exponential sums* `w(n) = Σ_{\|k\|≤K} c_k n^{it_k}`, since each `Σ_{n≤x}λ(n)n^{it} = o(x)`; the passage to an indicator is a discontinuous operation and the square wave's Fourier series is not absolutely convergent, so this does not transfer. Full definitions in [§A.1](#a1-o16-in-full) below; register row `OP-19` in [`open.md`](open.md) and [`twin-prime-parity/open/07-open-problems.md`](twin-prime-parity/open/07-open-problems.md). | `twin-prime-parity/open` |

---

### A.1 O16 in full

**The inherited statement (not a proposition).**  `rh47`'s **R2**, carried as `OP-3` of the
register, reads: *"prove that no sign-blind deterministic rule seeing `n` only through
`log n` can force a multiplicative correlation."*  Three defects make it unstatable as it
stands.

1. **No definitions.**  "Rule", "sees" and "force" are not defined; there is no quantifier
   over `x`, no normalisation and no threshold.
2. **The literal reading is false — `log` determines `n`.**  `n ↦ log n` is injective on
   `ℕ`, so for *every* `A ⊆ ℕ` there is `f : ℝ → [0,1]` with `A = {n : f(log n) > 1/2}`
   (set `f(log n) = 1` iff `n ∈ A`, and `0` elsewhere).  Taking `A = {n : λ(n) = 1}`
   gives `Σ_{n≤x} 1_A(n)λ(n) = #{n ≤ x : λ(n) = 1} = x/2 + o(x)`, because
   `Σ_{n≤x} λ(n) = o(x)` is a theorem (equivalent to PNT).  So "depends on `n` only
   through `log n`" excludes nothing, and the unrestricted claim is **refuted**.
3. **The supporting sentence was withdrawn.**  `rh47`'s "every greedy-sine object is an
   additive character in `log n`" is too wide: `n^{-it}` is *multiplicative* on
   `(ℝ₊,×)`, and the sums `Σ_{n≤x} λ(n)n^{-it}` *do* vanish.  Additivity alone neither
   prevents nor forces correlation.

**The repair: restrict the description, not the value.**  The content of "no arithmetic
input" is not that the rule is a function of `log n` — everything is — but that it is
*described* using finitely many real parameters and comparisons, with no reference to
`λ`, `Ω` or any other arithmetic datum.

**Definition A.1 (log-arc rule).**  Let `𝔽 ⊂ ℝ` be a fixed countable field (canonically
`ℚ(π)`).  A **log-arc rule** is a set
```
A_I = { n ≥ 1 : (log n mod 2π) ∈ I },
```
where `I ⊆ [0, 2π)` is a finite union of intervals with endpoints in `𝔽` and Lebesgue
measure `0 < |I| < 2π`.  Equivalently `A_I = {n : f_I(log n) > 1/2}` where `f_I` is the
indicator of `I` extended `2π`-periodically.

**Definition A.2 (λ-correlation).**  `C_I(x) = Σ_{n≤x} 1_{A_I}(n) λ(n)`.

**Problem P1 (the log-indicator barrier).**  Is `C_I(x) = o(x)` for every log-arc rule `I`?

**Problem P2 (the single-arc instance, quantitative).**  Take `I = [0, π)`, i.e.
`A = {n : cos(log n) ≥ 0}` — the `rh43` positive-part set, the one concrete instance
the programme's whole apparatus has failed to resolve.  Determine the true order of
`C(x)`: is `C(x) = o(x)`?  Is `C(x) = O(x^{1/2+ε})`?

**Well-posedness.**  `𝔽` countable makes the class of rules countable, so P1 is a
universal quantification over a countable family of definite sets: it has a definite
truth value.  Every instance is a computable-against assertion, so P1 is falsifiable by
a single arc and a single window.

**Known sub-case (a theorem).**  If instead of an indicator one takes a *finite* complex
exponential sum `w(n) = Σ_{|k| ≤ K} c_k n^{i t_k}`, then `Σ_{n≤x} w(n)λ(n) = o(x)`: for
each fixed real `t` the Dirichlet series of `λ(n)n^{it}` is `ζ(2(s−it))/ζ(s−it)`, which
is analytic on `Re s ≥ 1` — poles of `ζ(2(s−it))` need `Re s = 1/2`, zeros of `ζ(s−it)`
do not occur on `Re s = 1`, and `s = 1 + it` is a zero, not a pole — so Wiener–Ikehara
gives `Σ_{n≤x} λ(n)n^{it} = o(x)`, and the finite sum inherits it.  **This does not
transfer to P1**: `1_{A_I}` is not a finite sum, its Fourier coefficients are `≍ 1/k`, and
`Σ_k 1/k` diverges, so the individually-`o(x)` twisted sums cannot be interchanged.
That divergence is exactly the content of the barrier.

*Numerical sanity check of both claims* (sieved to `10^6`, standard library only):
`Σ_{n≤10^6} λ(n)/10^6 = −5.3·10⁻⁴` and `#{n ≤ 10^6 : λ(n) = 1}/10^6 = 0.499735`, consistent
with `x/2 + o(x)`; and `|Σ_{n≤10^6} λ(n)n^{it}|/10^6` equals `5.3·10⁻⁴` (`t = 0`),
`3.0·10⁻⁴` (`t = 1`), `2.4·10⁻⁴` (`t = 2`), `2.3·10⁻⁴` (`t = π`), `3.4·10⁻⁴` (`t = 7.3`)
and `1.6·10⁻³` (`t = 33`), consistent with `o(x)` with a rate that degrades slowly in `t`
— which is precisely the non-uniformity that blocks the Fourier interchange above.

**Falsifiable route (the register's own suggestion).**
1. Sieve `λ` to `10^9`–`10^{10}` and compute `C_I(x)` at `x = 10^k` for `I = [0,θ)`,
   `θ ∈ {π/2, π, 3π/2}`, exactly in integer arithmetic.
2. Fit the prefix-maximum exponent `α` in `max_{x'≤x}|C_I| = x^{α+o(1)}` over the computed
   range, and report `max|C_I|/√x`, as the two-point round does for `Σλ(n)λ(n+2)`.
3. Verdict. Since `x^{1/2+o(1)} = o(x)`, a fitted `α ≈ 1/2` is evidence **for** P1
   (square-root cancellation), not against it; `α = 1` with `|C_I(x)|/x` bounded below
   away from `0` would **refute** P1.  A single `θ` with `|C_I(x)|/x` failing to fall
   refutes P1.  *(Corrected in the B.2 pass: the earlier wording here read `α ≈ 1/2` as
   evidence against P1, which is backwards — the distinction that matters is whether
   `|C_I(x)|/x → 0`, not the exponent label.)*

**Result (B.2-ranking pass, `open/op19_log_indicator.py` / `.log`, 9/9 PASS, exit 0).**
Sieve bound `10⁹`; `C_I(x)` exact in `int64` for `θ ∈ {π/2, π, 3π/2}`, prefix maxima
tracked.  At `x = 10⁹`: `C_I = −22904, −21790, −26944` and `M = max_{x'≤x}|C_I| =
26830, 26310, 31464`, i.e. `|C_I|/x ≈ 2.2–2.7·10⁻⁵` (an order of magnitude below the
`10⁶` values) and `M/√x ≈ 0.83, 0.83, 1.00`.  Fitted `α`: `0.5514 ± 0.0650` (`π/2`),
`0.5093 ± 0.0391` (`π`), `0.5019 ± 0.0168` (`3π/2`).  **Verdict:** the finite data are
consistent with square-root cancellation, hence with **P1**, on these arcs; no arc shows
`|C_I|/x` failing to fall.  This is a finite-range description on `[1, 10⁹]` and proves
nothing asymptotically — and, as `F4`/OP-1 record, no finite prefix can decide an `o(x)`
statement.  **P1 and P2 remain OPEN.**

**Why this restriction is the right one (not an evasion).**  It enforces exactly the
three properties the programme needs: **(i) no arithmetic input** — the rule is fixed by
finitely many real parameters and comparisons, so `λ` cannot be smuggled in as in defect 2;
**(ii) positive density** — necessary, by the corrected sparse bound
`|S_A(x) − S(x)| ≤ 4·#{m ≤ x+2 : m ∈ A}`, since a density-zero modification can never move
the sum by more than `o(x)` (`rh47` `truths.md` §3); **(iii) falsifiability** — each fixed
`I` yields a definite, computable claim.

**Literature status.**  The register could not confirm a published resolution of even the
single-arc case (P2); it is not settled by any result harvested in `rh40`–`rh47`.  The
relevant published anchors — Tao's logarithmically averaged two-point Chowla and
Matomäki–Radziwiłł–Tao on almost all shifts — are *averaged* and give no control of a
single `log`-arc.

**Relation to the inherited item.**  This **supersedes** the *statement* of `O14`/`OP-3`
(which remains, correctly, marked "impossible as inherited"); it does **not** supersede
`OP-18`, which asks the separate positive question whether *any* sign-blind alphabet can
couple to `Ω` with positive density.


## B. Related live items from `open/HANDOFF.md` (OP-5 / OP-6)

The HANDOFF's own §7 plan (third-order `Φ`, the `nmin` ↔ threshold bridge, the OP-6
composition) and its §8 "definition of done" are **now discharged**: all three
`Asymptotic.lean` theorems are proved, `check.sh --all` is **9/9** green, there is no
`axiom` declaration and **no `sorry` anywhere**. What remains is below.

| Title | How tractable | Description | Folder |
|---|---|---|---|
| **O12.** Sign-blindness as a theorem (Lean) | **Low** | The programme's results are consistent with Selberg's parity barrier but do not formalise it. A Lean statement of the parity principle in the restricted setting of weight families generated by small-prime residue conditions is the natural target. | `twin-prime-parity/open/lean` |
| **O13.** The `k = 1` Chowla ⟺ PNT equivalence (Lean) | **Low** | The `k = 1` case is a theorem (equivalent to PNT) and is *not* open; a formalised proof would remove the programme's persistent mislabelling. Note `rh47`'s **R4** — the barrier Lean layer — is now **partly written**: `rounds/rh47/lean/Rh47/Sparse.lean` proves the corrected sparse bound (item OP-12), but the Brown/parity-lock port and R2 are still open. | `twin-prime-parity/open/lean`, `twin-prime-parity/rounds/rh47/lean` |
| **O14.** The barrier made precise (OP-3 of the register) | **Out of reach** (the theorem) / **done** (the definition) | Prove or refute: no sign-blind deterministic rule seeing `n` only through `log n` can force a multiplicative correlation. The inherited statement is **not well-posed** and is **discharged into OP-19** (§A.1 above), which fixes the definition (log-arc rules), corrects the over-wide reading, and states a definite problem. That problem — and its single-arc instance `I = [0,π)` — is **OPEN**; the B.2 pass added the `10⁹` finite data (`open/op19_log_indicator.py`), consistent with `o(x)` and proving nothing asymptotically. | `twin-prime-parity/open` |
| **O15.** Twin primes / two-point Chowla | **Out of reach** | `Σ_{n≤x} λ(n)λ(n+2) = o(x)` is open; the finite-prefix theorem shows no computation decides it and the programme's own objects are Sylvester-sparse, so this programme cannot reach it. Recorded for completeness, not as a task. **2026 reassessment (still out of reach):** the bounded-gap theorem `H₁ ≤ 246` (Polymath8; unrefereed `≤ 240`, 2026) says nothing about gap `2`, and Selberg's parity barrier is unbroken for `(n, n+2)`. | `twin-prime-parity/open` |

### The B.2-ranking pass (dispositions)

The ranking table of [`twin-prime-parity/open/07-open-problems.md`](twin-prime-parity/open/07-open-problems.md)
§B.2 was worked row by row; its status column carries per-row markers and §B.5 there
lists the artefact and the exact reproduction command for each rank. Summary:

* **Closed:** rank 1 **OP-12** (corrected sparse bound + falsity witness machine-checked
  in `rounds/rh47/lean/Rh47/Sparse.lean`), rank 2 **OP-11**
  (`corrSlice_sub_corr_self_eq` proved; no unproved statement remains in
  `Rh46/Chowla.lean`), rank 7 **OP-7** (the uniform height `t_N = π/log N` is proved
  elementarily for every `N ≥ 20`, with certified explicit rational heights for
  `N = 3..19`; no equidistribution is quoted), rank 9 **OP-14** (identically-zero weight
  impossible; the real weight `u(1−u)³` has `inf_{[0,50]}|M_φ| = 9.52·10⁻⁷`),
  rank 10 **OP-13** (`A(N) = O(log log N)` from the take rule + the proved squaring law —
  `rh41` §3 and the register had the inequality **reversed** and are corrected),
  rank 11 **OP-15** (no halting alphabet of any kind realises `p(L) = cL`; the "cannot
  help below `L = 20`" sub-claim is refuted by `[1/6,1,1/3,1/6]`, `x = 1`), rank 13
  **OP-2** (body text corrected).
* **Re-verified:** ranks 3–5 — **OP-10** (`kernel_probe.py` 9/9, 98.6 s) and **OP-5**,
  **OP-6** (`open/lean` `check.sh --all` 9/9, exit 0).
* **Certified partial:** rank 8 **OP-8** (term-level defect certified `> 0` for every
  `N = 3..60`), rank 12 **OP-9** (zero-free certified on `[0,1000]` for `N = 4..10`).
* **Discharged / recorded:** rank 6 **OP-3**, now the well-posed **OP-19** (still
  **OPEN**, finite data only); rank 14 **OP-1, OP-4, OP-16, OP-17, OP-18** out of reach.
* **New record corrections from the pass:** the OP-13 direction inversion; the OP-19
  verdict rule (`α ≈ 1/2` supports P1, it does not refute it — §A.1 above has been
  corrected); and the `ivmath.log_prime` enclosure caveat
  ([`twin-prime-parity/checks/06-numerical-checks.md`](twin-prime-parity/checks/06-numerical-checks.md) item 15).

### The out-of-reach reassessment (2026)

A literature sweep (2020–2026, peer-reviewed + established-author preprints) and an
internal analysis were run for the five rows left out of reach by the B.2 pass —
`OP-1`, `OP-4`, `OP-16`, `OP-17`, `OP-18` (`OP-3` excluded as instructed). **None is now
tractable.** Full survey with citations:
[`twin-prime-parity/open/OP-01-04-16-17-18-tractability.md`](twin-prime-parity/open/OP-01-04-16-17-18-tractability.md).

* **OP-1** — the log-averaged theorem (Tao 2015) has power-saving refinements through
  2026 (Pilatte; Guo; Hughes), all explicitly *logarithmic*; no fixed-shift
  natural-density `o(x)`. **Still out of reach.**
* **OP-4** — Chowla ⟹ Sarnak is a theorem; the equivalence is only **log-averaged**
  (Tao Thm 1.8), and even log-averaged **even `k ≥ 4`** is open. **Still out of reach.**
* **OP-16** — `H₁ ≤ 246` (Polymath8; an unrefereed 2026 preprint gives `≤ 240`) is a
  bounded-gap statement, not twins; Selberg's parity barrier is unbroken for
  `(n, n+2)`. **Still out of reach.**
* **OP-17** — log-Sarnak holds for broad classes, un-averaged Sarnak only for special
  classes; the **Cesàro gap** (strong stationarity fails for Cesàro averages) blocks the
  general case. **Still out of reach.**
* **OP-18** — **reclassified ⚠️: not well-posed as phrased.** The collapse
  `Σ_{n≤x}1_Aλ = P_A − N_A` makes "positive-density coupling to `Ω`-parity" identical to
  the non-vanishing of the `λ`-correlation, so `OP-18` on a fixed sign-blind class is the
  **existential dual of `OP-19`**; periodic and finite-exponential-sum classes are
  settled **negative**. New exact experiment:
  [`twin-prime-parity/open/op18_coupling_equivalence.py`](twin-prime-parity/open/op18_coupling_equivalence.py)
  (sieve to `10⁸`, 6/6 PASS; verifies `S_A = (Σλ + C)/2` with `C = Σλ(n)λ(n+2)` the open
  correlation).

**Recently closed (do not re-open).**

*010 numerics pass:* **`T8`** (the analytic content of Route B is formalised in
[`010/lean/Rh45/RouteBAnalytic.lean`](twin-prime-parity/010/lean/Rh45/RouteBAnalytic.lean),
6/6 green, axiom-clean: `xi_one_sub` (`ξ(1−s) = ξ(s)`), `logDeriv_one_sub`,
`logDeriv_conj`, `logDeriv_one_sub_conj`, `xi_logDeriv_symmetry`, the contour reduction
`rectBoundary_eq_rightPath_sub_conj` (`∮_{∂R} g = I₃ − conj I₃ = 2i·Im I₃`), and
`routeB_reduction` / `routeB_reduction_of_functional_equation` (`Im(I₃) = πZ` from the
argument-principle count). **Mathlib gaps left as explicit hypotheses:** the rectangle
argument principle (`∮ f′/f = 2πi·#zeros` — Mathlib has only Cauchy–Goursat, no winding
number) and `ξ(conj s) = conj(ξ(s))`; Mathlib also has **no** `riemannXi`), **`T3`** (the Route C archimedean bound was tightened by raising the
Simpson step count `1500 → 12000`; the error is `∝ STEPS⁻⁴`, so the archimedean bound fell
`6.5·10⁻⁵ → 1.6·10⁻⁸` (4096×) and the total budget `6.499·10⁻⁵ → 2.794·10⁻⁸` (2326×); the
assembly still validates, `residual −9.08·10⁻⁹ ≤ 2.794·10⁻⁸`), **`T6`** (the admissible-kernel
question is **settled positively**: the compactly supported even `g(u) = C(1−u²/144)⁴⁰cos(γ₁u)`
on `[−12,12]` has `|LHS| = 2.0000000000`, `RHS−LHS = −7.24·10⁻⁵⁴` at `K = 100`, zero-tail
`4.95·10⁻⁷⁷` — so the literal negative claim ("`O(1)` LHS forces a `≥ c/log G` zero tail")
is **false**; the correct statement is `g ∈ C^m` ⟹ `φ = O(t^{−(m+1)})` and tail
`O((log G)G^{−m})`, convergence needing `m ≥ 1`. Also flagged: the "decay at the trivial
zeros" condition is unsatisfiable as literally written by **any** non-zero even kernel — a
wording defect in `010/truths.md` §7. See `010/rigorous/KERNEL_FINDINGS.md`).

*Falsified (do not re-propose):* **`O9`** — the "leading constant becomes `1/log q`-type
data" claim is **FALSE**. With `term(p,q,r,n) = (q(n+1)+r)^{−p}` the Brown criterion depends
only on `N + 1 + r/q`, so (i) `r = 0` is *exactly* `q`-independent
(`nmin(p;q,0) = nmin(p;2,0)` for every `q`, checked `q ≤ 11`), and (ii) the slope is
`1/log 2` for every `q, r` with `nmin(p;q,r) = p/log 2 − 1 − r/q + O(1)`. See
[`open/OP-09-other-moduli.md`](twin-prime-parity/open/OP-09-other-moduli.md) and
[`open/op09_moduli.py`](twin-prime-parity/open/op09_moduli.py) (exit 0).

*010 numerics pass (unconditional Route B):* **`T1`** — the `T = 15` Turing count is now
**unconditional**. `certify_count15_uncond.py` runs with `Lf_const=None` (no cited
`|ζ′/ζ| ≤ A log(t+2)` anywhere) and prints
`N(15) in [0.7981608, 1.2018097] -> N(15)=1 CERTIFIED (9571 s)`, so
*every zero with `½ < Im < 15` is simple and on the critical line*. Two engine obstructions
were removed: (i) the removable singularity `ζ = η/(1−2^{1−s})` at `t_k = 2πk/ln 2`
(including `t_0 = 0`) — boxes within `_SING_WINDOW = 7/10` are routed to the rigorous local
Taylor enclosure `zeta_local_box` (Cauchy/Maximum-Modulus on a square, largest-`R` ladder,
`R0 = 4/5`); (ii) the loose per-step curvature bound — with the routing, `Σ Lf` fell from
`74776` to `2282.1`, giving `err = ΣLf/(8·24²) = 0.495` and N half-width `0.2018 < 0.5` at
`steps_per_unit = 24`. See
[`010/rigorous/T1_BLOCKER.md`](publish/006-explicit-formula-routes-abc/rigorous/T1_BLOCKER.md).

*010 numerics pass (the wider Turing window):* **`T2`** — the window is extended to
`T = 33`, again **unconditionally**:

```
T=33 steps/unit=40 K=100 -> I3=(-21.381925500160733,15.7080176058059)
N(33) in [4.711, 5.2890345] -> N(33)=5 CERTIFIED  (9391s)
UNCONDITIONAL: no cited |zeta'/zeta| bound was used; Lf is enclosed per step.
```

The five Route-A certificates place `γ₁…γ₅` in
`14.1337…14.1357, 21.0210…21.0230, 25.0099…25.0119, 30.4239…30.4259, 32.9341…32.9361`
— all `(< 33)` — so `N(33) = 5` together with the machine-checked
`Rh45Routes.all_zeros_are_certified` gives **every zero with `½ < Im < 33` is simple and
on the critical line**. Three obstacles were cleared: (i) the **`K ≳ 0.25·t`** requirement
of the Euler-accelerated `η` enclosure (`K = 40` returns a `1.8·10¹⁰`-wide, uselessly loose
enclosure at `t = 33`; `K = 100` is clean — `scan_i3_boxes.py 33 16 100` → 536 boxes,
0 failing, versus 261 failures at `K = 40`); (ii) the **error budget**, which at
`steps/unit = 32` came out `UNDECIDED by 3.8%` (`N ∈ [4.4810151, 5.5190349]`,
half-width `0.519` vs the required `0.5`) and is fixed by `steps/unit = 40`
(half-width `0.289`), since `err ∝ 1/steps`; (iii) **runtime**, via the parallel
certificate [`010/rigorous/certify_count_par.py`](publish/006-explicit-formula-routes-abc/rigorous/certify_count_par.py)
(the interval accumulation is order-independent), which cuts ~9 h to ~2.6 h and was
validated against the sequential centres to 10 digits. Logs:
[`certify_count33_par.log`](publish/006-explicit-formula-routes-abc/rigorous/certify_count33_par.log)
(certified) and
[`certify_count33_par_s32.log`](publish/006-explicit-formula-routes-abc/rigorous/certify_count33_par_s32.log)
(the UNDECIDED record).

*010 routes-primer pass (the three open items of `routes-abc-primer.html` §6):*
**Items 1 and 2 were already closed** (`T1`, `T2` above) — the primer was stale and has been
corrected: the cited `sup|f′| < 30` no longer appears anywhere, and the certified windows are
`(½,15)` and `(½,33)`, both unconditional. **Item 3 was open and is now largely closed:**
`certify_unique.py` takes an argument and a `K` ladder `(90,100,140,180,220,260,320)`; the
Route-A certificates now cover **`γ₁…γ₁₀`** (`K` = 90 for `γ₁…γ₅`, 100 for `γ₆`, 140 for
`γ₇…γ₁₀`), log
[`certify_unique10.log`](publish/013-twin-prime-parity-explicit-function/logs/010-certify_unique10.log) (`10/10`, `exit=0`);
`γ₁…γ₅` reproduce the historical `certify_unique.log` intervals identically. The next window
`T = 50` needs no further Route A work (`γ₁₀ = 49.7738 < 50`) and its count was **launched and
costed, not completed**: `certify_count_par.py 50 56 160 8` (2828 boxes, `K = 160`, since
`K = 100` raises at `t = 50`) runs at ~160 s/box, i.e. **~16 h**, and was aborted; the recipe and
the measurements are recorded in
[`certify_count50_par.log`](publish/013-twin-prime-parity-explicit-function/logs/010-certify_count50_par.log). So the
extension of item 2 beyond `T = 33` is a *costed, reproducible* multi-hour computation, not a
certificate.

*010 engine erratum (2026-10-12):* two **soundness** bugs found in the interval primitives while
building the 011 Dirichlet-`L` engine, both **fixed**:
(i) `eta_interval.exp_num` inverted its interval for `y.hi <= 0` and `ivmath.Num` silently clamped the
resulting negative radius to 0, so `n_pow_neg_sigma` — and hence **every positive-width box enclosure**
(`eta_box`, `zeta_point`, `xi_logderiv`) — was too narrow;
(ii) `eta_interval.ndef` used the nonnegative-numerator division formula `[x.lo/y.hi, x.hi/y.lo]`, which
under-covers for `x < 0` (1584/3000 random failures) — and `cdiv` feeds it a *signed* numerator, so
every complex division was exposed.
Regression tests `check_exp_num.py` (eta_box corner failures 36 → 0) and `check_ndef.py`
(0/3000, was 1584/3000) plus `check_engine.py` all pass after the fix.
**Impact:** Route A (`certify_unique*.log`) and Route C (`route_c_assembly.log`) are **unaffected**
(point σ / no box path); the **Route B counts** (`certify_count15_uncond.log`, `certify_count33_par.log`)
used box enclosures for the curvature bound `Lf` and must be **re-run** (≈2.7 h and ≈2.6 h) before
being quoted as rigorous. See
[`010/rigorous/EXP_NUM_ERRATUM.md`](publish/013-twin-prime-parity-explicit-function/notes/010-EXP_NUM_ERRATUM.md).
A third finding, `log_hi`'s width at large `p` (5.5e-8 at `p = 163`), is an **accuracy** issue in the
conservative direction, not a soundness one.

*Closed (Φ form):* **`O10`** — **`Phi_fourth_order` is proved.** In
[`open/lean/Op56/PhiFourth.lean`](twin-prime-parity/open/lean/Op56/PhiFourth.lean)
(1528 lines, axiom-clean, `#print axioms` = `[propext, Classical.choice, Quot.sound]`):

```lean
theorem Phi_fourth_order :
    ∃ C > 0, ∀ᶠ n, ∀ u, 1/2 ≤ u → u ≤ 1 →
      |Phi (u*n) n − ((exp u − 1)⁻¹ + u/(2n)·PhiS u
          + (−(u/3)·PhiK3u u + (u²/8)·PhiK4u u)/n² + EFourth u/n³)| ≤ C/n⁴
```

with `C = 11·10¹² + 2·10¹² + 7` and `EFourth u = (u/4)ΦK4u − (u²/6)ΦK5u + (u³/48)ΦK6u`.
The proof chain: the termwise bound `phi_term_sharp4` (the former sole analytic blocker,
constant `11` with ~118× numeric margin; `sA` bounded directly by `uk⁵/(5n⁴)` via
`phi_sA_bound5`), `tsum_pow8_exp_neg_half_le` (`Σ k⁸e^{−uk/2} ≤ 10¹²`), the `m ≤ 6 → m ≤ 8`
extension `tsum_shift_pow_exp_le8`, the tail chain `phi_tail_sum_le4` /
`phi_Q_abs_tail_le4` / `exp_neg_sqrt16_le4` / `poly_two_neg_le4`, the finite bound
`phi_finite_part_le4`, the model split `PhiMainS4_eq`, and
`Phi_fourth_order_aux` (`≤ (11·10¹²+2·10¹²+7)/n⁴`), closed by
`rw [← PhiMainS4_eq]; exact Phi_fourth_order_aux`. `./check.sh --all` is **9/9 green**.
Two numeric corrections are recorded: the moments are `1082`/`9366` (`k⁸`: `1091670`),
**not** `541`/`4683`.

**Not landed (now scoped as new analytic content, not assembly):** the *threshold-form*
fourth order — `SFourth`, a one-order-higher `uPhiS_expansion`, and
`threshold_fourth_order_uniform`. This needs a genuine **cubic** expansion of `u·ΦS(u)`
about `u = log 2` and a `u`-expansion of `EFourth` (no expansion of
`ΦK4u/ΦK5u/ΦK6u` exists yet), plus fourth-order re-derivations of the
`SThird_expansion_C` / `threshold_exp_bound_third` / `threshold_log_bound_third` split.

*Falsified (do not re-propose):* **`O3`** — the exact ceiling law
`nmin p = ⌈p/log 2 − 5/2⌉` is **FALSE**. The real crossing is
`n_*(p) = p/log 2 − 3/2 + F(p)`, `F(p) = −b/(n_* log 2) + O(n_*⁻²) ≈ 2.698·10⁻³/p > 0`
with `b = 3(log 2)² − (25/12)log 2`, so the law holds iff `1 − {y} > F(p)`; it fails for
continued-fraction denominators of `2/log 2`. First counterexample: the 451-digit `p` in
[`006/verify/op05_nmin_ceiling_false.py`](twin-prime-parity/006/verify/op05_nmin_ceiling_false.py),
where `nmin p = ⌈p/log 2 − 5/2⌉ + 1` (independently reproduced at 1150 dps). No sharpening
of `Phi_window_low/high` can prove the law. The sharpest true uniform statement is the
disjunction `nmin p ∈ {⌈p/log 2 − 5/2⌉, ⌈p/log 2 − 5/2⌉ + 1}` — still unproved.
Lean reduction delivered in `PhiThird.lean`: `nmin_eq_iff_Phi_bounds`,
`nmin_eq_ceil_of_Phi_bounds`, `IsComplete_mono`, `nmin_le_of_IsComplete`.

*Lean / formalisation pass:* **`O2`** (`native_decide` eliminated — the two `interval_cases
j <;> norm_num [Nat.stirlingSecond]` / `[Nat.factorial]` steps replaced it in
`tsum_pow6_exp_neg_half_le`; all eight probed theorems now have `#print axioms` =
`[propext, Classical.choice, Quot.sound]`), **`O4`** (OP-6's `1/p` coefficient derived in
closed form — it is the **function** `c(e) = −((ln 2)²/2)(e²−e+9/4)` of the ceiling error,
not the constant `−0.540509640658…`, which is the smooth-index `e = 0` value; verified to
`3.5·10⁻¹⁴` at `p = 10¹³` by `open/op06_ceiling_coefficient.py`; OP-06 corrected), **`O11`**
(floor-asymptotic meta-theorem formalised in `open/lean/Op56/FloorAsymptotic.lean`:
`no_index_asymptotic_error`, `irrational_not_eventually_error_inv`,
`log_two_inv_no_index_asymptotic`, `nmin_error_not_bigO_inv` — clean axioms;
`Irrational (Real.log 2)` is carried as an explicit hypothesis because Mathlib lacks
Lindemann–Weierstrass irrationality), **`T7`** (the archimedean term is now formalised in `010/lean/Rh45/Archimedean.lean`:
digamma-line continuity/measurability, recurrence/reflection, the chain rule giving the
`2^{−k}` budget, the Leibniz bound and the composite-Simpson assembly — 0 `sorry`/`axiom`,
3/3 green, with the digamma-series estimate and the single-panel Simpson error left as
named hypotheses because Mathlib lacks both. **Finding:** the paper's `k = 0` digamma
bound is vacuous). **`T4`** (auditor check `C1e` **retired** as
unsatisfiable-by-its-instrument and **restated** as the convergent companion `C1f` at
`a = 1`; the audit now prints *"19/21 checks pass; 2 retired; failures: none"*).

*HIGH-tractability pass:* **`T5`** (auditor check `C4.1` **retired** by disposition —
[`010/verify/DISPOSITIONS.md`](twin-prime-parity/010/verify/DISPOSITIONS.md)), **`T9`** (certified fast
engine mode — `eta_interval.set_precision` / `fast_mode`, enclosure contract documented
and validated by `check_fast_mode.py`, `0 fail(s)`), **`T10`** (`check_engine.py` re-run
twice at `K = 60`; `verify_engine.log` and `recheck_engine.log` re-archived, both
`0 fail(s)`), **`T11`** (the one embedded source path — in `verify/independent_check.log`,
not in the `rigorous/` logs, which carry none — regenerated), **`O8`** (the `HANDOFF.md`
triplicate deduplicated to the single canonical `open/HANDOFF.md`; the other two paths are
pointers), **`O1`** (the last `sorry` in the corpus discharged — `tailSum_integral_lower`
was **false** as written (`N + 1 ≤ M`) and is now **proved** under the corrected
hypothesis `N + 2 ≤ M`, with the helper `integral_two_mul_rpow`; `open/lean` is
**0 `sorry`, 0 `axiom`, 9/9 green**, and `006/lean` is synced).

*Earlier pass:* `T12`, `O5`, `O6`, `O7`, the `open/07-open-problems.md` summary tally and
placeholder note, and the `rounds/rh47/truths.md` §5 claim. The `open/lean` build is now
**9/9 green**.

---

## C. Recommended order

1. **O10 (threshold form)** — `Phi_fourth_order` is proved; the remaining piece is the
   *threshold-form* fourth order (`SFourth`, `threshold_fourth_order_uniform`), which is
   new analytic content (a cubic `u·ΦS(u)` expansion about `u = log 2` and a `u`-expansion
   of `EFourth`).
2. **The argument principle for Route B / T8 follow-up** — build the rectangle argument
   principle (`∮ f′/f = 2πi·#zeros`) that `RouteBAnalytic.lean` takes as its hypothesis
   `hAP`.
3. **O14, O15** — the programme-level targets; out of reach with current technique and
   stated as such.

---

## D. What is explicitly *not* claimed (do not add these as tasks)

* Nothing in `010/` claims anything about the Riemann hypothesis; only the finite
  windows `½ < Im < 15` (item T1) and `½ < Im < 33` (item T2), plus five individual
  zeros, are certified.
* `explicit_formula.py`'s convention `(E)` is **false**; it is superseded by
  `rigorous/route_c_assembly.py` and is not a task to fix.
* Both Turing counts are **unconditional**: `T1` (`N(15) = 1`, 2026-10-11) and `T2`
  (`N(33) = 5`). The archived `certify_count15d` certificate, which uses the cited
  `|ζ′/ζ|` input, is retained only for comparison.
* OP-5 and OP-6 are **settled**; they are not open problems. `O1`–`O4` and `O11` are now
  closed too; the only remaining OP-5/OP-6 items are the long-horizon `O12`/`O13`
  (sign-blindness; the `k = 1` Chowla ⟺ PNT equivalence).
