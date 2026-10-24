# `research/twin-prime-parity/open/` — current status

Everything in `open/`: the 19-item open-problems register, the two resolved problem
notes (OP-05, OP-06), the OP-5/OP-6 Lean development, the numerical scripts, the
rendered results pages, and the 18 706-line development log.

**Bottom line.** The directory's original objective — the Lean formalisation of
OP-5 and OP-6 — is **achieved**: the development builds **9/9 green**, all three
headline theorems are proved, there is **no `axiom` declaration** and **no `sorry`
anywhere** (the last one was discharged by repairing its hypothesis and proving it).
The register itself now carries 19 items: **10 open**, **7 settled** (OP-2, OP-5, OP-6,
OP-10, and — after the B.2-ranking pass — OP-11, OP-12, OP-14), **1 refuted as stated**
(OP-8) and **1 impossible-as-inherited** (OP-3, whose well-posed replacement is the new
OP-19).  OP-5, OP-6, OP-11, OP-12 and OP-14 are **SETTLED** (not open); see §4.
The B.2-ranking pass (the ranking table of `07-open-problems.md` §B.2) closed ranks 1
(OP-12), 2 (OP-11), 7 (OP-7), 9 (OP-14), 10 (OP-13, with a direction correction),
11 (OP-15) and 13 (OP-2), re-verified ranks 3–5 (OP-10, OP-5, OP-6), certified new bounds
for ranks 8 and 12 (OP-8, OP-9), discharged rank 6 numerically (OP-19, remaining OPEN),
and left the out-of-reach rank 14 recorded; the finite experiments for ranks 6–12 live in
`open/op07_*.py … op19_*.py`.  A 2026 literature reassessment of the out-of-reach rows
(`OP-1`, `OP-4`, `OP-16`, `OP-17`, `OP-18`; `OP-3` excluded) found **none newly
tractable** and reclassified `OP-18` as ⚠️ not well-posed as phrased — see
[`open/OP-01-04-16-17-18-tractability.md`](twin-prime-parity/open/OP-01-04-16-17-18-tractability.md).

> Verified in this harvest by running `open/lean/check.sh --all` (exit 0, 9/9
> `[check] OK`) and by source + `#print axioms` inspection. See
> [`TODO.md`](TODO.md) §B for the remaining polish items and
> [`truths.md`](truths.md) §9 for the proved statements.

**Scope note.** §§1–4, 6–8 cover the `open/` directory itself. **§5 is wider**: it lists
every item graded `OPEN` or `CONJECTURED` in the twin-prime-parity harvest
([`theorems/tpp/INDEX.md`](../theorems/tpp/INDEX.md)), which is where the programme's
individual open claims are recorded one file per claim. The register of §4
(`OP-1…OP-19`) and the §5 inventory overlap but neither contains the other.

---

## 1. File inventory

| file | what it is | status |
|---|---|---|
| [`07-open-problems.md`](twin-prime-parity/open/07-open-problems.md) | the open-problems **register** and research plan: Part A register (OP-1…OP-19) + Part B per-problem plan and ranking | reference; summary tally corrected (§4) |
| [`OP-05-nmin-asymptotic.md`](twin-prime-parity/open/OP-05-nmin-asymptotic.md) | OP-5 write-up: `n_min(p) = p/ln 2 − 3/2 + O(1)` (error term corrected from a false `O(1/p)`), `P_n = (n+3/2)ln 2 + c/n + O(1/n²)` | **RESOLVED** |
| [`OP-05-nmin-exposition.html`](twin-prime-parity/open/OP-05-nmin-exposition.html) | rendered exposition of OP-5 (abstract, main theorem, proof, verification) | current |
| [`OP-06-reachable-fraction.md`](twin-prime-parity/open/OP-06-reachable-fraction.md) | OP-6 write-up: `L(p) = p log p − (1 + ln ln 2)p − 0.5405…/p + O(1/p²)` | **RESOLVED** |
| [`OP-06-reachable-fraction.html`](twin-prime-parity/open/OP-06-reachable-fraction.html) | rendered exposition of OP-6 | current |
| [`RESULTS.html`](twin-prime-parity/open/RESULTS.html) | rendered results page: *"Threshold asymptotics and the reachable-fraction decay"* — problem, preliminaries, main theorems, lemmas by layer, proof architecture, applicability, further work, build-status appendix | current |
| [`op05_nmin.py`](twin-prime-parity/open/op05_nmin.py) | OP-5 numerics: slope refutation, threshold law, `O(1/n²)` bracket, exceptional-set width, the `n = 1` boundary | reproduces the write-up |
| [`op06_reachable_fraction.py`](twin-prime-parity/open/op06_reachable_fraction.py) | OP-6 numerics: exact census values, leading constant `1`, linear coefficient `−(1+ln ln 2)` | reproduces the write-up |
| [`op06_ceiling_coefficient.py`](twin-prime-parity/open/op06_ceiling_coefficient.py) | **O4**: the exact `1/p` coefficient `c(e) = −((ln 2)²/2)(e²−e+9/4)` as a function of the ceiling error (closed form, not a constant) | `0 fail(s)`; verified to `3.5·10⁻¹⁴` at `p = 10¹³` |
| [`HANDOFF.md`](twin-prime-parity/open/HANDOFF.md) | the **canonical** OP-5/OP-6 development log (18 706 lines, 744 headings); the former duplicates at `../HANDOFF.md` and `../006/notes/HANDOFF.md` are now pointers; carries a **status banner** at the top marking the objective achieved, and a correction at `13.681` | historical (§6) |
| [`lean/`](twin-prime-parity/open/lean) | the Lean 4 + Mathlib formalisation of OP-5/OP-6 (+ `Op56/FloorAsymptotic.lean`, `Op56/PhiFourth.lean`) | **9/9 green** |

**Added by the B.2-ranking pass** (all with matching `.log`, run with
`/opt/homebrew/Caskroom/miniforge/base/bin/python3`):

| script | item | what it does |
|---|---|---|
| [`op07_root_existence.py`](twin-prime-parity/open/op07_root_existence.py) | OP-7 | explicit certified heights `t_N` with `Re S_N(t_N) < 0`, `N ≤ 300` |
| [`op08_subset_defect.py`](twin-prime-parity/open/op08_subset_defect.py) | OP-8 | meet-in-the-middle subset-sum defects at certified balance points, beyond `N = 12` |
| [`op09_complex_zero.py`](twin-prime-parity/open/op09_complex_zero.py) | OP-9 | certified zero-free lower bounds for `S_N` on `[0,1000]`, `N = 4..10` |
| [`op13_almost_everywhere.py`](twin-prime-parity/open/op13_almost_everywhere.py) | OP-13 | exact-rational orbit samples, `A(N)` vs `log log N`, small-ratio frequencies |
| [`op14_complex_weights.py`](twin-prime-parity/open/op14_complex_weights.py) | OP-14 | `M_φ = e^{iθ}B(a+1−s,b+1)`, the `10⁻⁶` window witness, decay exponent, `N`–`t` trade-off |
| [`op15_nonmonotone.py`](twin-prime-parity/open/op15_nonmonotone.py) | OP-15 | 135 648-case search over non-monotone alphabets; complexity profiles |
| [`op19_log_indicator.py`](twin-prime-parity/open/op19_log_indicator.py) | OP-19 | `C_I(x)` for `θ ∈ {π/2, π, 3π/2}`, sieve to `10^{10}` (J3, 2026-10-11), prefix-max exponent fit; `int64` index fix past `2^{31}` |

**Added by the 2026 out-of-reach reassessment (excl. OP-3):**

| file | item | what it does |
|---|---|---|
| [`OP-01-04-16-17-18-tractability.md`](twin-prime-parity/open/OP-01-04-16-17-18-tractability.md) | OP-1, OP-4, OP-16, OP-17, OP-18 | the 2026 literature survey with citations and the OP-18 definitional analysis; verdict: none newly tractable, OP-18 reclassified ⚠️ |
| [`op18_coupling_equivalence.py`](twin-prime-parity/open/op18_coupling_equivalence.py) | OP-18 | exact sieve to `10⁸` (6/6 PASS): periodic/finite-exponential-sum classes decay; the arithmetic witness satisfies `S_A = (Σλ + C)/2` with `C` the open two-point correlation |

---

## 2. The Lean development (`open/lean/`)

### 2.1 Modules and build

```
cd research/twin-prime-parity/open/lean
./check.sh --all
# [check] OK Op56/Defs.lean, Op56/Exact.lean, Op56/Census.lean,
#            Op56/PhiAsymptotic.lean, Op56/PhiThird.lean,
#            Op56/Asymptotic.lean, Op56/FloorAsymptotic.lean,
#            Op56/PhiFourth.lean, Op56.lean      → 9/9, exit 0
```

Lean `v4.35.0-rc2`, Mathlib at `$HOME/lean/mathlib4`; no `lake` project file —
`check.sh` reconstructs `LEAN_PATH` from `lake env`.

| module | contents | `sorry` |
|---|---|---|
| [`Op56/Defs.lean`](twin-prime-parity/open/lean/Op56/Defs.lean) | the alphabet `term p n = (2(n+1))^{−p}`, `budget`, `tailSum`, `IsComplete`, `nmin`, `Phi`, `IsThreshold`, `reachableMeasure`, `reachableFraction`, `L`, the asymptotic expressions | 0 |
| [`Op56/Exact.lean`](twin-prime-parity/open/lean/Op56/Exact.lean) | exact layer: positivity/monotonicity, summability, budget split, `exists_isComplete` (witness `N = 4p`), `nmin_spec`, `nmin_minimal`; `integral_two_mul_rpow` and the (unused) `tailSum_integral_lower`, proved under `N + 2 ≤ M` | **0** |
| [`Op56/Census.lean`](twin-prime-parity/open/lean/Op56/Census.lean) | `reachableSum`, `census_measure_eq`, `census_ratio` | 0 |
| [`Op56/PhiAsymptotic.lean`](twin-prime-parity/open/lean/Op56/PhiAsymptotic.lean) | geometric asymptotics of `Φ`: tail via integral comparison, finite part, `Phi_asymptotic`, `threshold_scaling` | 0 |
| [`Op56/PhiThird.lean`](twin-prime-parity/open/lean/Op56/PhiThird.lean) | third-order layer and the OP-6 estimate chain (≥ 231 declarations) | 0 |
| [`Op56/Asymptotic.lean`](twin-prime-parity/open/lean/Op56/Asymptotic.lean) | the three headline theorems | **0** |
| [`Op56/FloorAsymptotic.lean`](twin-prime-parity/open/lean/Op56/FloorAsymptotic.lean) | **O11 meta-theorem**: an `O(1/p)` error is impossible for an irrational linear threshold (`no_index_asymptotic_error`, `irrational_not_eventually_error_inv`, `nmin_error_not_bigO_inv`) | **0** |
| [`Op56/PhiFourth.lean`](twin-prime-parity/open/lean/Op56/PhiFourth.lean) | the fourth-order expansion (`O10`): **`Phi_fourth_order` is proved** — `Φ(un,n) = (eᵘ−1)⁻¹ + (u/2n)ΦS u + D(u)/n² + E(u)/n³ + O(n⁻⁴)` with `C = 11·10¹²+2·10¹²+7`, via `phi_term_sharp4` (the former sole blocker), `tsum_pow8_exp_neg_half_le`, `tsum_shift_pow_exp_le8` (`m ≤ 8`), `phi_tail_sum_le4`, `phi_finite_part_le4` and `PhiMainS4_eq` | **0** |
| [`Op56.lean`](twin-prime-parity/open/lean/Op56.lean) | root module | — |

### 2.2 The headline theorems (all PROVED)

| theorem | statement | line |
|---|---|---|
| `Op56.leadingCoeff_forced` | the leading rate is forced: `Σ_{j≥1} x^j = 1` has the unique root `x = 1/2` | [`Asymptotic.lean#L69`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L69) |
| `Op56.op5_threshold_leading` | `P_n = n·log 2 + O(1)` | [`Asymptotic.lean#L87`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L87) |
| `Op56.op5_threshold_second_order` | `P_n = (n+3/2)log 2 + O(1)` | [`Asymptotic.lean#L124`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L124) |
| `Op56.op5_threshold_asymptotic` | `P_n = (n+3/2)log 2 + c/n + O(1/n²)`, `c = 3(log 2)² − (25/12)log 2` | [`Asymptotic.lean#L189`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L189) |
| `Op56.op5_nmin_asymptotic` | `n_min(p) = p/log 2 − 3/2 + O(1)` — **restated** from a false `O(1/p)` | [`Asymptotic.lean#L239`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L239) |
| `Op56.op6_reachable_fraction` | `L(p) = p log p − (1 + log log 2)p + O(1)` | [`Asymptotic.lean#L294`](twin-prime-parity/open/lean/Op56/Asymptotic.lean#L294) |

`op5_nmin_asymptotic`'s original `O(1/p)` statement was **false** (an integer index
cannot beat the Diophantine gap against an irrational linear threshold); it was
corrected to `O(1)` and then proved. The *exact ceiling law*
`nmin p = ⌈p/log 2 − 5/2⌉` — which this document previously listed as an open
formalisation target (`O3`) — was **falsified** in this pass at a 451-digit `p`
(`nmin p = ⌈p/log 2 − 5/2⌉ + 1`); the sharpest true uniform statement is the
disjunction `nmin p ∈ {⌈p/log 2 − 5/2⌉, ⌈p/log 2 − 5/2⌉ + 1}`. See
[`TODO.md`](TODO.md) `O3` and [`../twin-prime-parity/006/handoff.md`](twin-prime-parity/006/handoff.md) §6.4.

**Items closed for this directory.** Beyond `O1`–`O4` and `O8` (above), three further
`open/` items were completed:

| item | outcome |
|---|---|
| `O2` | `native_decide` removed — every probed `Op56` theorem is now `[propext, Classical.choice, Quot.sound]`; the layer is **axiom-clean** |
| `O9` | the "leading constant becomes `1/log q`-type data" claim is **FALSE**: with `term(p,q,r,n) = (q(n+1)+r)^{−p}` the criterion depends only on `N + 1 + r/q`, so `r = 0` is *exactly* `q`-independent and the slope is `1/log 2` for every `q, r` (`nmin(p;q,r) = p/log 2 − 1 − r/q + O(1)`). See [`OP-09-other-moduli.md`](twin-prime-parity/open/OP-09-other-moduli.md) |
| `O10` | **`Phi_fourth_order` proved** in [`Op56/PhiFourth.lean`](twin-prime-parity/open/lean/Op56/PhiFourth.lean) — the fourth-order expansion of `Φ` with explicit constant `C = 11·10¹²+2·10¹²+7`; the former sole blocker `phi_term_sharp4` and the whole `k⁸` tail machinery are in place. The *threshold-form* fourth order (`SFourth`, `threshold_fourth_order_uniform`) is scoped separately as new analytic content |
| `O11` | the floor-asymptotic meta-theorem is formalised in [`Op56/FloorAsymptotic.lean`](twin-prime-parity/open/lean/Op56/FloorAsymptotic.lean) |

### 2.3 Sorry / axiom audit

* **`axiom` declarations: none** anywhere in `open/lean`.
* **`sorry`: none** — the last one, `Op56.tailSum_integral_lower`
  ([`Op56/Exact.lean`](twin-prime-parity/open/lean/Op56/Exact.lean)), was **discharged** by
  repairing its hypothesis to `N + 2 ≤ M` and proving it (the as-written `N + 1 ≤ M` form is
  **false**: witness `p=2, N=0, M=1`). It remains a documented, **unused** negative result —
  the antitone integral test is too lossy to prove completeness (existence was proved
  discretely via `exists_isComplete`, witness `N = 4p`) — and the supporting helper
  `integral_two_mul_rpow` was added.
* **`native_decide` footprint: removed (TODO item O2).** The two
  `interval_cases j <;> native_decide` steps in `Op56.tsum_pow6_exp_neg_half_le` were
  replaced by `interval_cases j <;> norm_num [Nat.stirlingSecond]` / `[Nat.factorial]`.
  Every probed `Op56` theorem — including the three headline theorems, `Phi_third_order`
  and `threshold_third_order_uniform` — now reports `#print axioms` =
  `[propext, Classical.choice, Quot.sound]`, and no `native_decide` token occurs anywhere
  in the development. The whole OP-5/OP-6 layer is now **axiom-clean**.

### 2.4 Stale text: corrected

An earlier revision of this document listed six stale docstrings in `open/lean`. **All
have now been corrected at the source** in this pass:

| location | was | now |
|---|---|---|
| `Op56.lean` header | claimed the three asymptotic theorems were "left as documented `sorry`s"; claimed `exists_isComplete_all` had a `p < 2` `sorry` | states the build is 9/9, all three proved, `exists_isComplete_all` proved, and **no `sorry` anywhere** |
| `Op56/Asymptotic.lean` header | "What is proved, and what is not" — main theorems "left as `sorry`s" | "What is proved" — all three proved, with the `O(1)` correction noted |
| `Op56/Asymptotic.lean`, `op6_reachable_fraction` docstring | "**PROOF OBSTRUCTION** … needs the same Hurwitz-tail input" | "**OP-6 (proved)**" with the proof sketch |
| `Op56/Asymptotic.lean` header | threshold equivalently `n_min(p) = p/log 2 − 3/2 + O(1/p)` | `O(1)`, with a pointer to the correction |
| `Op56/PhiThird.lean` header | `phi_term_sharp3`/`D(u)`/`Phi_third_order`/threshold inversion "still to land" | "Complete and proved; 0 `sorry`" |
| `README.md` | "what is *stated* but not proved (documented `sorry`s)" table; "Why the asymptotics are not proved here" | "The former `sorry` — now proved"; "How the asymptotics are proved here" |

The `O(1/p)` error term was also a **false mathematical statement**, since fixed in the
write-ups: `OP-05-nmin-asymptotic.md`, `OP-06-reachable-fraction.md`,
`07-open-problems.md`, `rounds/rh42/truths.md`, the two HTML expositions, `RESULTS.html`
and the two Python scripts now all state `O(1)`, each with a correction note. The
`006` round's own paper (`006/index.html`) and `006/lean`'s *root* module already carried
the corrected text; `006/lean`'s `Asymptotic.lean` and `PhiThird.lean` module headers did
not, and have now been synced with the corrected `open/lean` copies (the six shared
module sources are again byte-identical between `open/lean` and `006/lean`). `006`'s
`notes/` and `verify/` copies of the OP-05/OP-06 write-ups and scripts have been patched
the same way.

**The `open/lean` build was re-run after these edits and is 9/9 `[check] OK`, exit 0.**

---

## 3. The resolved problems, in one paragraph each

**OP-5 — the asymptotic of `n_min(p)`.** `n_min(p) = p/ln 2 − 3/2 + O(1)`. (The write-up
originally stated `O(1/p)`; that is **false**, since an integer index cannot beat the
Diophantine gap against an irrational linear threshold — the exact law is
`nmin(p) = ⌈p/ln 2 − 5/2⌉`. The error term is corrected to `O(1)` throughout the
`open/` sources, and the Lean theorem states the `O(1)` index form.) The recorded guess
`n_min ≈ p + O(1)` is **refuted**: the slope is `1/ln 2 = 1.4426950…` (measured
`1.4424` at `p = 5000`) and `n_min − p` grows (21, 88, 442, 2212 at
`p = 50, 200, 1000, 5000`). Thresholds satisfy
`P_n = (n + 3/2)ln 2 + c/n + O(1/n²)` with the closed-form
`c = 3(ln 2)² − (25/12)ln 2 = −0.002697584411948…`, verified to `1·10⁻¹⁰` by
Richardson extrapolation; `P_1 = p* = 1.7286472389981836` (`ζ(p*) = 2`). The `1/n²`
remainder coefficient is `≈ 0.00323`, stable over six decades.

**OP-6 — the order of the reachable fraction.** Composing the census law
(`measure(S_1) = 2^{n_min−1} T_{n_min}`) with OP-5 gives
`L(p) = p log p − (1 + ln ln 2)p − c(e(p))/p + O(1/p²)` with the closed-form ceiling-error coefficient `c(e) = −((ln 2)²/2)(e² − e + 9/4) ∈ [−0.540510, −0.480453]`, i.e.
`measure(S_1)/P(p) = p^{−p} e^{(1+ln ln 2)p}(1+o(1)) → 0`. The recorded leading
constant in `c·p log p` is **`c = 1`** (not `1/ln 2`, not `2/ln 2`); the linear
coefficient `−(1 + ln ln 2) = −0.6334870794…` is exact (verified to ten figures at
`p = 10⁶`). The `1/p` coefficient is **closed form but not a constant** — the constant `−0.540509640658…` quoted in the original write-up is the smooth-index (`e = 0`) value; see the correction in [`OP-06-reachable-fraction.md`](twin-prime-parity/open/OP-06-reachable-fraction.md) §2.4 and [`op06_ceiling_coefficient.py`](twin-prime-parity/open/op06_ceiling_coefficient.py).
In the Lean statement, `L` and `LAsym` are the relevant functions and the theorem
bounds the residual `L p − LAsym p = O(1)`.

> **Census caveat (recorded, not stale).** `census_measure_eq` holds *by construction*:
> `reachableMeasure` is *defined* as `2^{nmin p}·tailSum p (nmin p)`. The geometric
> statement that the `2^{nmin}` translates are pairwise disjoint with union the sub-sum
> set is **not** formalised — `Op56/Census.lean` records it as the remaining "census
> counting" gap.

---

## 4. The register: current status of OP-1 … OP-19

Statuses as written in [`07-open-problems.md`](twin-prime-parity/open/07-open-problems.md) Part A, with the
corrections noted.

| id | statement (short) | status |
|---|---|---|
| **OP-1** | un-averaged two-point Chowla `Σ_{n≤x} λ(n)λ(n+2) = o(x)` | **OPEN — out of reach (2026 survey)**; finite-prefix indeterminacy proved in Lean; all 2020–2026 progress is log-averaged/conditional |
| **OP-2** | one-point `Σ_{n≤x} λ(n) = o(x)` | **SETTLED (theorem)** — equivalent to PNT; `rh46` §1.3 and `rh47` §5.1 mislabel it OPEN |
| **OP-3** | "R2": no sign-blind `log n`-rule forces a multiplicative correlation | **OPEN → IMPOSSIBLE-AS-STATEMENT as inherited**; the precise version is OPEN |
| **OP-4** | `k`-point Chowla and Sarnak | **OPEN** for `k ≥ 2`; `k = 1` settled — **out of reach (2026 survey)**: equivalence only log-averaged, and log even `k ≥ 4` open |
| **OP-5** | asymptotic of `n_min(p)` | **SETTLED** — [`OP-05-nmin-asymptotic.md`](twin-prime-parity/open/OP-05-nmin-asymptotic.md), Lean `op5_nmin_asymptotic` |
| **OP-6** | order of `measure(S_1)/P(p) → 0` | **SETTLED** — [`OP-06-reachable-fraction.md`](twin-prime-parity/open/OP-06-reachable-fraction.md), Lean `op6_reachable_fraction` |
| **OP-7** | self-contained root existence for `Re S_N`, all `N ≥ 3` | **SETTLED (B.2 pass)** — uniform height `t_N = π/log N`, elementary proof for `N ≥ 20`, certified explicit rational heights for `N = 3..19`; no equidistribution (`op07_root_existence.py`) |
| **OP-8** | the term-level two-and-two split at a balance point | **REFUTED at every certified root (`N = 3…76`, extended 2026-10-11); OPEN in general** |
| **OP-9** | exact complex vanishing `S_N(t) = 0`, `N ≥ 4` | **OPEN**, but zero-free certified on `[0,10^4]` for `N = 4..10` (extended 2026-10-11; `N = 2` yes, `N = 3` provably no) |
| **OP-10** | an explicit-formula kernel with `O(1)` LHS and fast zero sum | **SETTLED (T6)** — see [`KERNEL_FINDINGS.md`](publish/006-explicit-formula-routes-abc/rigorous/KERNEL_FINDINGS.md) |
| **OP-11** | `corrSlice_sub_corr_self_eq` (Finset perturbation identity) | **SETTLED (B.2 pass)** — proved in [`rh46/lean/Rh46/Chowla.lean`](twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) (`corrSlice_sub_corr_self_eq`, `slice_term_sub`, `exists_corrSlice_ne_corr`); the register's hypothesis needed the correction `0 < h < a` |
| **OP-12** | `rh47`'s empty Lean layer + corrected sparse bound | **SETTLED (B.2 pass)** — machine-checked in [`rh47/lean/Rh47/Sparse.lean`](twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean); the `rh46` form is **REFUTED** (witness `A={5}`, `x=5`) |
| **OP-13** | matching upper bound `A(N) = O(log log N)` | **SETTLED (B.2 pass), direction corrected**: the take rule + the proved squaring law give `n_k ≥ x^{−2^k} − 2`, hence `A(N) ≤ log₂(log(N+2)/log(1/x)) = O_x(log log N)`; the `Ω` lower bound is the side that fails (`op13_almost_everywhere.py`) |
| **OP-14** | residue of the `rh44` smoothing barrier; `M_φ ≡ 0`? | **SETTLED (B.2 pass)** — identically-zero is IMPOSSIBLE (analyticity/Mellin injectivity); explicit `φ = u(1−u)³` has `inf_{[0,50]}\|M_φ\| = 9.52·10⁻⁷`; see [`op14_complex_weights.py`](twin-prime-parity/open/op14_complex_weights.py) |
| **OP-15** | non-monotone alphabets realising `p(L) = cL` | **SETTLED — impossibility direction (B.2 pass)**: no halting alphabet of any kind realises `p(L) = cL` (finite support + rh41 Thm 1/Cor 4); the `L < 20` sub-claim is refuted by `[1/6,1,1/3,1/6]`, `x=1` |
| **OP-16** | twin primes and Selberg's parity barrier | **OPEN — out of reach (2026 survey, unchanged)**; `H₁ ≤ 246`/`240` are bounded-gap statements, not twins; parity unbroken for `(n,n+2)` |
| **OP-17** | Sarnak's Möbius-disjointness conjecture | **OPEN — out of reach in general (2026 survey)**: log-Sarnak holds for broad classes, un-averaged only for special classes; the Cesàro gap blocks the general case |
| **OP-18** | positive existence of a sign-blind positive-density coupling to `Ω` | **OPEN (heuristic) — ⚠️ not well-posed as phrased (2026 reassessment)**: "coupling" collapses to non-vanishing of `Σ1_Aλ`, so on a fixed class it is the existential dual of `OP-19`; periodic and finite-exponential-sum classes are settled **negative**; verified by [`op18_coupling_equivalence.py`](twin-prime-parity/open/op18_coupling_equivalence.py) |
| **OP-19** | **the log-indicator barrier** — the well-posed replacement for OP-3: is `C_I(x) = Σ_{n≤x} 1_{A_I}(n)λ(n) = o(x)` for every *log-arc rule* `A_I = {n ≥ 1 : log n mod 2π ∈ I}` (`I` a finite union of intervals with endpoints in a fixed countable field, `0 < \|I\| < 2π`)? | **OPEN** — and now **well-posed** (definite truth value; countable class; falsifiable by one arc and one window). The single arc `I = [0,π)` is the `rh43` set `{n : cos(log n) ≥ 0}`. Full definitions, the refutation of the unrestricted reading, and the known finite-exponential-sum sub-case: [`TODO.md`](TODO.md) §A.1 |

**Tally (as the table now stands, after the B.2-ranking pass):** 19 items — 10 SETTLED
(OP-2, OP-5, OP-6, **OP-10** as of item `T6`, and OP-7, OP-11, OP-12, OP-13, OP-14,
OP-15 as of the pass) · 1 IMPOSSIBLE-AS-STATEMENT as inherited (OP-3, whose well-posed
replacement is the new **OP-19**) · 1 REFUTED as stated (OP-8; the inherited sparse form
inside OP-12 is separately refuted) · 7 OPEN (OP-1, OP-4, OP-9, OP-16, OP-17, OP-18,
**OP-19**).

> **Summary tally (corrected at the source).** The "Summary" line of
> `07-open-problems.md` read *"18 items — 1 SETTLED, 1 IMPOSSIBLE-AS-STATEMENT,
> 1 PARTIAL, 2 REFUTED (as stated), 13 OPEN"* — a count predating the resolution of
> OP-5 and OP-6 (both marked SETTLED in the same file's own table). It now reads the
> tally above, which the B.2-ranking pass has updated to 10 SETTLED.

Known internal corrections the register already records (§0.1): `X1` one-point
Chowla is a theorem, not open; `X2` the `2·#{n≤x+2}` sparse bound is false; `X3`
the `1.808988` product tail is mis-derived; `X4` `rh47`'s barrier is over-wide and
stays heuristic.

---

## 5. Open and conjectured items in the twin-prime-parity harvest

> **2026-10-11 tractability pass.** A per-item value × tractability survey of every row
> below (and of the still-open OP-1…OP-19) lives at
> [`open-tractability.md`](open-tractability.md); the rows it settled or corrected are
> recorded there. The `OP-26`/`OP-27` rows of §5.3 are **settled** (OP-13, with the
> direction correction); see §3.4 of the journal and the corrected rows below.

[`theorems/tpp/INDEX.md`](../theorems/tpp/INDEX.md) indexes **582** harvested items from
the twin-prime-parity programme. **36** of them are graded `OPEN` or `CONJECTURED`, and
all 36 are listed below.

The relationship to §4 is a refinement, not a duplication: the register in §4 lists the
programme's **registered** problems `OP-1…OP-19`, while the items below are the individual
open claims the harvest extracted from the source documents — finer-grained, and partly
local to one round. Where an item corresponds to a registered problem, the last column
says so; where it does not, the item is a round-local question or a heuristic recorded for
calibration rather than a programme target.

**Caveat on `CONJECTURED`.** Eleven of the 36 are heuristic models that the harvester
graded `CONJECTURED` (`HEURISTIC` rows of the parity chapter, or the `K6h`/`K6j`
conjectures of `rh40`). They are **not** proposals the programme is committed to proving;
they are recorded expectations, and several are explicitly labelled as interpretations
that may never be theorems.

**The `id` column.** Every row carries an `OP-xx` id. Rows that refine a problem already
registered in §4 keep that problem's number (`OP-1`, `OP-16`, …; several share one, since
they are the same problem harvested from different documents) — **no existing number was
changed**. Items that refine no registered problem are assigned **OP-20 … OP-38** here, in
reading order (contiguous, each used once). Those nineteen are *harvest-level* ids defined
by this inventory — thirteen round-local `rh40` questions (§5.3), five recorded heuristics
(§5.1) and one unverified citation. They are deliberately **not** promoted into
[`07-open-problems.md`](twin-prime-parity/open/07-open-problems.md): that register holds
the **programme-level** problems, and its `OP-1 … OP-19` are unchanged. Its Part A carries
a pointer back to this section so the two numberings can be read together.

### 5.1 Chowla, twin primes and the parity problem (15)

| id | item | source | status | what it says |
|---|---|---|---|---|
| **OP-1, OP-16** | [un-averaged two-point Chowla](../theorems/tpp/tpp-dict-00-un-averaged-two-point-chowla-open.md) | (dictionary A5) | OPEN | The target: `Σ_{n≤x} λ(n)λ(n+2) = o(x)`. |
| **OP-1, OP-16** | [two-point Chowla — the target](../theorems/tpp/tpp-dict-03-two-point-chowla-open.md) | (parity chapter, OPEN 3.4) | OPEN | The same statement as the `k = 2`, `h = (0,2)` case of Chowla; rh46 established only that it is open. |
| **OP-4** | [the `k`-point Chowla conjecture](../theorems/tpp/tpp-dict-03-chowla-conjecture.md) | (Conjecture 3.1, Chowla 1965) | OPEN for every `k ≥ 2` | `Σ λ(n+h_1)⋯λ(n+h_k) = o(x)` for distinct `h_i`; equivalently every sign pattern has density `2^{−k}`. `k = 1` is PNT, a theorem. |
| **OP-4, OP-16, OP-17** | [the register of open statements](../theorems/tpp/tpp-dict-03-open-chowla-twin-sarnak-elliott.md) | (OPEN 4.2) | OPEN | Full `k`-point Chowla for `k ≥ 2`; the twin prime conjecture; Sarnak's Möbius-disjointness; Elliott for bounded multiplicative functions, un-averaged. |
| **OP-16** | [the twin prime lower bound](../theorems/tpp/tpp-dict-03-twin-prime-open.md) | (OPEN 2.7) | OPEN | `π₂(x) ≫ x/(log x)²`; the gap from `P₂` (Chen, theorem) to `P₁` is exactly the parity barrier. |
| **OP-16** | [Hardy–Littlewood / Dickson `k`-tuples](../theorems/tpp/tpp-dict-03-hardy-littlewood-dickson-k-tuples.md) | (Conjecture 1.8) | OPEN for every `k ≥ 2` | The quantitative prime-tuple asymptotics; `h = (0,2)` is the twin prime conjecture. HEURISTIC as a prediction. |
| **OP-1, OP-16** | [the exact relation with twin primes](../theorems/tpp/tpp-dict-03-exact-relation-twin-primes.md) | (THEOREM 5.1) | OPEN for parts (b), (c) | `S(x) = o(x)` is equivalent to the equal-class density being `1/2`; part (a) is proved, but no implication to twin primes is known in either direction. |
| **OP-1** | [an intermediate decay statement](../theorems/tpp/tpp-dict-03-open-intermediate-decay.md) | (OPEN 4.3) | OPEN | Whether `Σ_{n≤x} λ(n)λ(n+2) = O(x/(log x)^A)` for any `A > 0`. Recorded for calibration: it is strictly between trivial and `o(x)`. |
| **OP-20** | [a frontier preprint on log-Chowla](../theorems/tpp/tpp-dict-03-guo-preprint-unverified.md) | (UNVERIFIED 4.7) | OPEN — citation unverified | A fixed power-logarithmic bound for the log-weighted correlations, from a single-author preprint that is **not peer-reviewed**; the archive marks it UNVERIFIED. |
| **OP-17** | [truncated Selberg weights](../theorems/tpp/tpp-dict-03-truncated-weights-unverified.md) | (UNVERIFIED 2.3) | OPEN | The `λ`-mean-zero slogan cannot be taken literally once weights are truncated at level `D = x^θ`, `θ < 1`: truncation destroys periodicity and the 2.2 argument does not apply. |
| **OP-21** | [the \"switching\" reading of Chen](../theorems/tpp/tpp-dict-03-chen-switch-heuristic.md) | (HEURISTIC 2.8) | CONJECTURED | Interpretation, not a theorem: the two linear forms `n`, `n+2` are given asymmetric roles and the bilinear structure supplies the missing parity input. |
| **OP-22** | [why log-averaging is weaker](../theorems/tpp/tpp-dict-03-log-averaging-weaker-heuristic.md) | (HEURISTIC 4.5) | CONJECTURED | Structural explanation of why the logarithmic average constrains only a full-density set of scales. The rigorous content is THEOREM 4.4. |
| **OP-23** | [the shape of the missing input](../theorems/tpp/tpp-dict-03-missing-input-heuristic.md) | (HEURISTIC 5.4) | CONJECTURED | Three kinds of input known to cross a parity barrier — Type-II/bilinear, spectral, and entropy-decrement — none available for the twin primes. |
| **OP-24** | [the random-sign model](../theorems/tpp/tpp-dict-03-random-sign-heuristic.md) | (HEURISTIC 3.2) | CONJECTURED | If `(λ(n))` were independent random signs every correlation would be `O(x^{1/2+ε})`. The model ignores complete multiplicativity, so it is only a picture. |
| **OP-25** | [why the slogan is the right picture](../theorems/tpp/tpp-dict-03-slogan-heuristic.md) | (HEURISTIC 2.4) | CONJECTURED | `λ` has mean `0` mod `q` and does not pretend to be `χ(n)n^{it}`, which is the modern reason to expect cancellation. |

### 5.2 The barrier (`rh47` and its corrections) (8)

| id | item | source | status | what it says |
|---|---|---|---|---|
| **OP-3, OP-18** | [the corrected barrier](../theorems/tpp/tpp-dict-00-corrected-barrier-open.md) | (dictionary F9) | OPEN (heuristic) | No **sign-blind alphabet with no arithmetic input** supplies a positive-density multiplicative coupling to `Ω`. |
| **OP-3, OP-18** | [the corrected barrier](../theorems/tpp/tpp-dict-03-f9-corrected-barrier.md) | (parity chapter F9) | OPEN (heuristic) | The same barrier from the parity chapter, with the reasons the impossibility is not a theorem. |
| **OP-3 → OP-19** | [OP-3 downgraded to a heuristic](../theorems/tpp/tpp-open-07-barrier-downgraded-to-heuristic.md) | (open register) | CONJECTURED | The register's own `OP-3`: the over-wide \"every greedy-sine object is an additive character in `log n`\" form is **withdrawn**; the corrected claim is a heuristic, not a proposition. |
| **OP-3, OP-18** | [the corrected barrier](../theorems/tpp/tpp-rh47-truths-corrected-barrier-open.md) | (`rh47/truths.md`) | OPEN (heuristic) | The barrier as rh47 finally states it, subject to that round's correction 2: the impossibility must stay OPEN. |
| **OP-3** | [the barrier in one sentence](../theorems/tpp/tpp-rh47-handoff-barrier-additive-character-open.md) | (`rh47/HANDOFF.md`) | OPEN (heuristic) | The withdrawn one-sentence form, kept because the record correction is part of the round's result. |
| **OP-3** | [the barrier in one sentence](../theorems/tpp/tpp-rh47-readme-barrier-additive-character-open.md) | (`rh47/README.md`) | OPEN (heuristic) | The same sentence in the round README's wording, likewise superseded by the record correction. |
| **OP-18** | [bridge B1 — no mechanism known](../theorems/tpp/tpp-rh47-handoff-bridge-b1-no-mechanism-known.md) | (`rh47/HANDOFF.md`) | OPEN | No mechanism is known by which the greedy *support* could correlate with `λ`'s parity class; the signed support's parity lock is a rigidity, not a bridge. |
| **OP-18** | [H4 — the goal is unreachable as it stands](../theorems/tpp/tpp-rh47-handoff-h4-goal-unreachable-open.md) | (`rh47/HANDOFF.md`) | OPEN | The honest conclusion: the goal cannot be reached by the greedy-sine programme as it stands, because the missing ingredient is a sign-blind positive-density coupling and the greedy support is Sylvester-sparse. |

### 5.3 The `rh40` greedy-word open questions (13)

| id | item | source | status | what it says |
|---|---|---|---|---|
| **OP-26** | [Theorem G — the upper bound is open](../theorems/tpp/tpp-rh40-k-remaining-theorem-g-upper-bound-open.md) | (`rh40/K_remaining.md`) | **SETTLED (OP-13, 2026-10-11; direction corrected)** | The harvested title is wrong about the direction: `A(N) ≤ log₂ log N + O(1)` is **proved** from the take rule + the one-sided squaring law `r_{k+1} ≤ r_k²`. The no-positive-lower-bound obstruction `r_{k+1}/r_k² ≤ 1` is real, but it kills the `Ω` **lower** bound, not the upper bound. |
| **OP-27** | [A4b — the matching upper bound](../theorems/tpp/tpp-rh40-rounds-truths-a4b-upper-bound-open.md) | (`rh40/rounds/truths.md`) | **SETTLED (OP-13, 2026-10-11)** | Same: the matching upper bound does *not* need a two-sided squaring law and is proved; the unproven `r_{k+1} ≥ c·r_k²` (measured ratios as low as `0.028`) is what the **lower** bound would need. |
| **OP-28** | [conjecture: a family with no limit](../theorems/tpp/tpp-rh40-k-remaining-conjecture-family-without-limit.md) | (`rh40/K_remaining.md`) | **PROVED (2026-10-11 attack, constructive)** | There exist `x ∈ (0,1)` and a greedy orbit with `limsup (1/K)Σ log c_k ≥ −0.76`, `liminf ≤ −1.21`: prescribe `α_k` alternating `1/2,1/4` in `3^j` blocks, build `q_k` backwards via `u_k = n_k u_{k+1}/(n_k+u_{k+1})`, `x = Σ 1/(q_k+2)`. Exact-rational witness + error budget `≤ 1.6·10⁻³` vs block gap `≥ 0.35`; `lib/tpp_no_limit_orbit.py` (self-test 5/5). |
| **OP-29** | [conjecture: a.e. convergence to `−1`](../theorems/tpp/tpp-rh40-k-remaining-conjecture-lebesgue-a-e-limit.md) | (`rh40/K_remaining.md`) | CONJECTURED | The same limit `−1` for Lebesgue-a.e. `x`; the reduction is written out but its key correlation lemma is stated, not proved. |
| **OP-30** | [K6h — a family with no limit](../theorems/tpp/tpp-rh40-rounds-truths-k6h-no-limit-family-conjectured.md) | (`rh40/rounds/truths.md`) | **PROVED (2026-10-11 attack, ≡ OP-28)** | Same construction; the block-end running means of `log α_k` form an exact 2-cycle (`{−0.8664, −1.2130}` for `3^j`), far beyond the `O(10⁻³)` correction. |
| **OP-31** | [K6j — a.e. convergence to `−1`](../theorems/tpp/tpp-rh40-rounds-truths-k6j-a-e-convergence-conjectured.md) | (`rh40/rounds/truths.md`) | CONJECTURED | Modulo the stated expanding-map correlation lemma, which is not written out. |
| **OP-32** | [E8 — the plateau onset has no formula](../theorems/tpp/tpp-rh40-rounds-truths-e8-plateau-onset-no-formula.md) | (`rh40/rounds/truths.md`) | OPEN | No formula found; four candidates were tested and **refuted** (on 375 random eligible supports, `a_{m−1}+1` fails in 284). |
| **OP-33** | [I8 — the finite-`r` means](../theorems/tpp/tpp-rh40-rounds-truths-i8-finite-r-means-open.md) | (`rh40/rounds/truths.md`) | **SETTLED (2026-10-11 attack)** | (a) **PROVED** (Lean `Rh42.step_bound`, axiom-clean): `r_0 ≤ 1/10`, `r_{k+1} ≤ r_k²`, `10^{−D} < r_{K−1}` ⟹ `2^{K−1} ≤ D`, so `D` digits reach only `K ≤ log₂ D + 1` steps — the `7–13 steps before underflow` is a theorem, not a bug. (b) Means of `log c_k` over `10⁴` prescribed steps are `−0.6931, −1.3863, −2.3026, …` for `α = 1/2,1/4,1/10`: **none is `−1`** (claim confirmed, re-attributed). |
| **OP-34** | [A7 — window-class decomposition](../theorems/tpp/tpp-rh40-round01-a7-window-class-decomposition-unsubstantiated.md) | (`rh40/rounds/round01.md`) | **SETTLED with corrections (2026-10-11 attack)** | **REFUTED as stated** — the class sum over-counts `p(L)` on **604/1399** `L` for `1/π` (classes not disjoint). Corrected criterion `factor(t)=factor(t') ⟺ x(t)=x(t') ∧ shape(t)=shape(t')` and exact shape-union formula `p(L) = [∃all-zero] + Σ_shapes |⋃_{C:shape} X(C)|` **PROVED** (6 378 064 exhaustive cases, 0 mismatches; `lib/tpp_window_collision.py`). |
| **OP-35** | [A8 — the deficit form](../theorems/tpp/tpp-rh40-round01-a8-deficit-form-unsubstantiated.md) | (`rh40/rounds/round01.md`) | **REFUTED / ill-posed (2026-10-11 attack)** | `S_{1,k}` is **undefined corpus-wide**. The natural reading `S_{1,k} = Σ_{i≤k} d_i` gives `D(L) = (L−12)_+`, switching on at `L = 13`, whereas the measured `2→1` slope drop is at `L = 14` (`p(13)=16, p(14)=18, p(15)=19`). No partial-sum convention repairs it; the natural `D` is unbounded while a cancelled-pair deficit must be bounded. |
| **OP-36** | [the window-class sum for `p(L)`](../theorems/tpp/tpp-rh40-round01-agenta-window-class-sum-conjecture.md) | (`rh40/rounds/round01.md`) | **REFUTED as stated (2026-10-11 attack)** | The `[DREAM]` sum `p(L) = 1 + #{}(L>span) + Σ_{i≤j}|T(i,j)|` over-counts on **all 1399** `L` for `1/π`; replaced by the corrected shape-union formula (see OP-34). |
| **OP-37** | [the `(i,x)` repair](../theorems/tpp/tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md) | (`rh40/rounds/round01_agentB.md`) | **SETTLED with corrections (2026-10-11 attack)** | Realisability **PROVED** (`max(0,a_i−(N−L)) ≤ x ≤ min(d_{i−1}−1,a_i,L−1)`); the source's all-zero criterion **REFUTED** by `((0,4),N=6,L=3)`, corrected `L ≤ max(a_0,max_j(d_j−1),N−1−a_m)` **PROVED**; the source's injectivity claim **REFUTED** by `((12,20),N=26,L=12)`, corrected `p(L) ≥ a_m+2 ⟹ injective` **PROVED with no `N`-hypothesis** and machine-checked (`Rh40.injOn_of_card_ge`, `rounds/rh40/lean`, 2/2 green). The plateau value `max p = a_m+2` stays unproved. |
| **OP-38** | [B13 — the naive-formula count](../theorems/tpp/tpp-rh40-round01-b13-naive-formula-count-unsubstantiated.md) | (`rh40/rounds/round01_agentB.md`) | OPEN (imprecise) | The count \"the naive `RS(L) − LS(L+1)` holds 0/18895 cases\" is not reproducible. The substance of B4 survives; the count does not. |

---
## 6. The development log and its end state

[`HANDOFF.md`](twin-prime-parity/open/HANDOFF.md) is an 18 706-line session log with 744
headings, structured as `§1–§13` followed by round entries `13.1 … 13.681`. It is now the
**single canonical copy** (deduplicated — the former `../HANDOFF.md` and
`../006/notes/HANDOFF.md` duplicates are short pointer files).

* A **status banner** was added at the top: *the objective is achieved; all three
  `Asymptotic.lean` theorems are proved; `check.sh --all` is 9/9 green; no `axiom`
  declaration; **no `sorry` anywhere** (the last one, `tailSum_integral_lower`, was
  discharged by repairing its hypothesis to `N + 2 ≤ M` and proving it); the three main
  theorems inherit no `native_decide` footprint (removed by O2).*
* Its **§6** ("what is NOT proved") and **§7** (the ordered plan: third-order `Φ`,
  the `nmin` ↔ threshold bridge, the OP-6 composition) describe the *historical*
  obstruction. All three steps are now **discharged**; its **§8** "definition of
  done" is **met**. The banner marks §6–§8 as superseded history.
* Its **final round `13.680`** states: *"OBJECTIVE ACHIEVED: all three
  `Asymptotic.lean` theorems PROVED — 7/7 green"* (the build is now **9/9** with
  `FloorAsymptotic.lean` and `PhiFourth.lean`), and records the evidence
  (no `axiom`, 7 `[check] OK`, `native_decide` inherited). The `sorry` recorded there
  has since been discharged as well.
* **`13.681` "Immediate next action"** was stale — it read *"Still `phi_term_sharp3`
  as 3–4 sub-lemmas"*, which `13.680` supersedes. A **correction note** has been added
  immediately under that heading, and the paragraph is kept as the historical record.

The cleaned, authoritative statement of current state is
[`006/handoff.md`](twin-prime-parity/006/handoff.md); use that in preference to the log's tail.

---

## 7. Reproduce

```bash
cd research/twin-prime-parity/open
python3 op05_nmin.py                 # threshold law, constant c, O(1/n²) bracket
python3 op06_reachable_fraction.py   # reachable fraction, the (1 + ln ln 2) coefficient

cd lean && ./check.sh --all          # 9/9 [check] OK
```

The numeric content of both asymptotic theorems is verified independently to ten
significant figures by the two scripts; the Lean statements are cross-checked
against them in [`lean/README.md`](twin-prime-parity/open/lean/README.md).

---

## 8. Anomalies

**None outstanding in this directory.** The former `HANDOFF.md` triplicate has been
deduplicated to the single canonical [`HANDOFF.md`](twin-prime-parity/open/HANDOFF.md)
(§6), with the other two paths reduced to pointers.

*Corrected at the source in an earlier pass (kept here only as a record):* the six stale
docstrings in `open/lean` that denied proved theorems (§2.4), and the two matching
`006/lean` module headers, now synced; the `O(1/p)` error term
in the OP-5 write-up, the OP-6 write-up, the register, `rh42/truths.md`, the HTML
expositions, `RESULTS.html`, the two Python scripts and their `006/` mirrors (§2.4, §3);
the register summary
tally (§4); the stale `13.681` log tail (§6); the `07-open-problems.md` placeholder note
about empty sub-directories; and the empty `open/lean/Op56Lean/` directory, which has
been removed.
