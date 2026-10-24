# `research/twin-prime-parity` — 07 · Open-problems register and research plan

**Programme:** *the greedy harmonic sine vs the twin-prime parity problem.*
**Rounds covered:** `rh40`–`rh47`, harvest at `rh47/HANDOFF.md`.
**Status of this document:** a reference register, not a result. It contains no new
theorem and claims none. Every row is a statement about what the programme has
established, collided with, or failed to establish.

**See also**

* `../dictionary/03-parity-problem.md` — the
  dictionary entry for the parity problem.
* `../checks/06-numerical-checks.md` — the register
  of numerical checks and what each does *not* establish.

> **Note (corrected).** An earlier revision of this file carried a "placeholder note"
> saying that the `dictionary/`, `checks/`, `open/` and `archive/` sub-directories were
> empty and that the two "see also" targets were forward pointers. That is **no longer
> true**: all four sub-directories are populated, and both targets — `dictionary/03`
> and `checks/06` — now exist in full.

---

## 0. How to read this register

**Vocabulary.** For every problem:

| status | meaning |
|---|---|
| **OPEN** | no proof and no refutation is known to the programme or (where checked) in the literature |
| **PARTIAL** | a strictly weaker or strictly special-case result is proved |
| **REFUTED** | a counterexample or a disproof exists, with a witness |
| **IMPOSSIBLE-AS-STATEMENT** | the problem as phrased is not a well-formed mathematical proposition, or is settled in the negative by a general obstruction |
| **SETTLED (theorem)** | not an open problem — included because the programme's own record mislabels it |

"Smallest known obstruction" means the *first concrete object in the programme's own
files that blocks the obvious next step* — not a claim that the obstruction is optimal.

**Evidence grades** used in the citations, inherited from the rounds:

* **PROVED** — written argument, or machine-checked in Lean 4 (no `sorry`).
* **VERIFIED** — independently recomputed by a route that does not re-run the source.
* **CHECKED** — exhaustively verified over a stated finite class.
* **HEURISTIC** — structural argument with numerical support, not a theorem.

---

## 0.1 Corrections to the record carried into this register

These are errors or overreaches found in the harvested rounds. They are stated *before*
the register because two of them change the status of a registered item.

1. **`rh46/README.md` §1.3 states that one-point Chowla `Σ_{n≤x} λ(n) = o(x)` is
   "itself OPEN". That is false.** The `k = 1` case of the Chowla conjecture *is*
   equivalent to the prime number theorem, and is therefore a theorem — see
   [Tao, *Equivalence of the logarithmically averaged Chowla and Sarnak conjectures*,
   arXiv:1605.04628](https://arxiv.org/abs/1605.04628) §1: *"The `k=1` case of the
   Chowla conjecture is equivalent to the prime number theorem. The higher `k` cases
   are open."* The elementary transfer is the identity
   `λ = 1_□ * μ` (`Σ_n λ(n)n^{−s} = ζ(2s)/ζ(s)`), from which
   `Σ_{n≤x} λ(n) = Σ_{d≤√x} M(x/d²)` and conversely
   `M(x) = Σ_{d≤√x} μ(d) L(x/d²)`; splitting the `d`-sum at a large fixed `D` gives the
   equivalence with `M(x) = o(x)`, i.e. PNT (classical, Landau). **`rh47/HANDOFF.md`
   §5.1 and `rh47/README.md` repeat the `rh46` wording; both inherit the error.** The
   register row OP-2 is therefore **SETTLED (theorem)**, not OPEN.
2. **`rh46`'s sparse-modification bound is false.** The quoted
   `|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}` fails at the witness `A = {5}`, `x = 5`:
   the two affected terms `n = 3` and `n = 5` each change `+1 → −1`, so `\|ΔS\| = 4 > 2`.
   The correct bound (`rh47`, `truths.md` §3) is
   `|S_A(x) − S(x)| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`.
   The `o(x)` conclusion is unaffected. Registered as OP-12.
3. **`rh46`'s stated product tail `1.808988` is mis-derived** (it bounds the *retained*
   primes, not the omitted ones). The no-Euler-product conclusion survives on the
   correct tail `1.84·10⁻⁵` against the discrepancy `2.0144` (`rh47` `truths.md` §2, B3).
4. **`rh47`'s own barrier was over-wide and is downgraded to a heuristic.** "Every
   greedy-sine object is an additive character in `log n`" is too wide: `n^{−it}` is a
   *multiplicative* character on `(ℝ₊,×)`, and the budgets are constants in `p`. The
   audit's `C3a` even exhibits a greedy object of the *same take rule* with an
   *arithmetic* alphabet (`α_p = (−1)^{Ω(p+2)}/(p+2)`, `z = +10.1`) — which mixes, but
   is circular. The barrier must read **sign-blind alphabet, no arithmetic input**, and
   "the two do not mix" stays **HEURISTIC** (`rh47/truths.md` §3).

---

# Part A — the register

**Summary (current):** 19 items — **4 SETTLED** (`OP-2`, `OP-5`, `OP-6`, and `OP-10`
as of item `T6`), **1 IMPOSSIBLE-AS-STATEMENT as inherited** (`OP-3`; its well-posed
replacement is the new **`OP-19`**), **1 PARTIAL** (`OP-14`), **2 REFUTED as stated /
in part** (`OP-8`, `OP-12`), **11 OPEN** (`OP-1`, `OP-4`, `OP-7`, `OP-9`, `OP-11`,
`OP-13`, `OP-15`, `OP-16`, `OP-17`, `OP-18`, **`OP-19`**).

> *Corrected.* An earlier revision read *"1 SETTLED, 1 IMPOSSIBLE-AS-STATEMENT,
> 1 PARTIAL, 2 REFUTED, 13 OPEN"* — a count predating the resolution of `OP-5` and
> `OP-6`, which the same file's table already marks **SETTLED (this round)**.

> **Numbering pointer.** This register's `OP-1 … OP-19` are the **programme-level**
> problems. The harvest inventory in `../../open.md` §5 lists the
> 36 individual `OPEN`/`CONJECTURED` items extracted from the twin-prime-parity
> documents and assigns **`OP-20 … OP-38`** to the nineteen that refine none of the
> problems above (round-local `rh40` questions and recorded heuristics). Those ids are
> defined there, not here; they are not rows of this register.

## A.1 The register table

| id | statement (one line) | status | best known partial result | smallest known obstruction |
|---|---|---|---|---|
| **OP-1** | Un-averaged two-point Chowla: `Σ_{n≤x} λ(n)λ(n+2) = o(x)`. | **OPEN** | trivial bound `\|S(x,h)\| ≤ x`, PROVED in Lean (`corr_abs_le`, `rh46/lean/Rh46/Chowla.lean`); sharpness `corr 0 N = N` (`corr_zero`) so `o(x)` is not formal; logarithmic average is a theorem (Tao 2016; MRT 2015); `o(x)` for almost all shifts (MRT); numerics `S(10⁸)/10⁸ = 4.4·10⁻⁵`, prefix-max exponent fit `α = 0.5200 ± 0.0249`, unresolved (`rh46/README.md` §1.2). | **Finite-prefix indeterminacy** (PROVED in Lean: `slice_agree`, `corrSlice_eq_corr_of_lt`; VERIFIED to the strongest form on `10⁸` prefixes): a `λ''` agreeing with `λ` on all of `[1,10⁸]` has `S''(x)/x → 1`, so no finite computation decides (★); a witness needs **positive density** (corrected sparse bound, `rh47` §3). |
| **OP-2** | One-point case `Σ_{n≤x} λ(n) = o(x)`. | **SETTLED (theorem)** — *not open* | Equivalent to PNT; `k = 1` Chowla ([Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628)); the transfer is the classical `λ = 1_□ * μ` identity. Recorded in this register because `rh46` §1.3 and `rh47` §5.1 mislabel it OPEN. | None to the statement. The obstruction is to **method**: Selberg's parity problem says no sieve weight `w` built from small-prime residue conditions can give `Σ w(n)λ(n) = o(Σ w(n))`, even though the theorem is true (`rh43/truths.md` §8.5). |
| **OP-3** | **R2 of `rh47`** — no sign-blind deterministic rule that sees `n` only through `log n` can force a multiplicative correlation with `Ω`. | **OPEN → IMPOSSIBLE-AS-STATEMENT** as inherited; the well-posed replacement is **`OP-19`** (see below) | `rh47`'s barrier package: budget sign-blindness (`P+N = ζ−1`, `P−N = 1−η`, separating *index* parity only), the twist invariance `Σ λ(n)(−1)ⁿλ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly (`0/10⁶` mismatches), and the Euler-product failure `\|D(2) − model\| = 2.0144 > 1.84·10⁻⁵` (`rh47/truths.md` §2). | R2 is **not a well-formed proposition** as inherited ("rule", "seeing", "force" are undefined) — see A.2, OP-3. The first concrete instance that resists everything the programme has: the `rh43` positive-part set `A = {n : cos(t log n) > 0}` is sign-blind and depends on `n` only through `log n`, yet `Σ_{n≤x} 1_A(n)λ(n) = o(x)` is **not known** — the Fourier expansion reduces it to a *divergent* sum of individually-`o(x)` twisted sums `Σ λ(n)n^{−ikt}`. |
| **OP-4** | `k`-point Chowla (un-averaged) and its relation to Sarnak. | **OPEN** for `k ≥ 2`; `k = 1` settled | `k=1` ⟺ PNT ([Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628)); un-averaged Chowla **implies** Sarnak's Möbius-disjointness conjecture (Sarnak 2010; classical); the *logarithmically averaged* Chowla for all `k` is **equivalent** to the logarithmically averaged Sarnak conjecture (Tao, arXiv:1605.04628, Thm 1.8); the `k=2` logarithmically averaged case is a theorem of Tao (*Forum Math. Pi* **4** (2016)), after Matomäki–Radziwiłł–Tao. | Entropy decrement yields only **logarithmic / almost-all** averaging; for a *fixed* shift no unconditional `o(x)` bound is known. The `rh46` sentence that `k`-point Chowla "contradicts the twin prime conjecture's failure mode" is **withdrawn here as unverified** — the correct, citable relations are the `k=1` ⟺ PNT equivalence and Chowla ⟹ Sarnak. |
| **OP-5** | Asymptotic of `n_min(p)` as `p → ∞` (`n_min(p)` = first index at which the positive half-tail becomes complete). | **SETTLED (this round)** — see [`OP-05-nmin-asymptotic.md`](OP-05-nmin-asymptotic.md) | `n_min(p) = 1 ⟺ p ≤ p*`, `p* = 1.7286472389981836181…` (`ζ(p*) = 2`), PROVED via unimodality of `h(n) = Σ_{k>n}k^{−p} − n^{−p}` (rh42 §3, Thm 7–8); exact table `n_min = 1,2,3,5,8,11,13,16` at `p = 1.5,2,2.5,4,6,8,10,12` (rh42 §4); **`n_min(p) = p/ln 2 − 3/2 + O(1)`**, refuting the recorded `p + O(1)`: the slope is `1/ln 2 = 1.4426950…` (measured 1.4424 at `p = 5000`) and `n_min − p` grows without bound. Thresholds satisfy `P_n = (n + 3/2)ln 2 + c/n + O(1/n²)` with the closed-form constant `c = 3(ln 2)² − (25/12)ln 2 = −0.00269758441194845395…`, verified to 1·10⁻¹⁰ by Richardson extrapolation of exact thresholds (`n ≤ 20000`) and to 18 digits at `n = 1`, where `P_1 = p* = 1.7286472389981836` (`ζ(p*) = 2`) | RESOLVED via the Euler–Maclaurin/dual expansion of `Φ_p(n) = Σ_j(1+j/n)^{−p}` (PERMISSION 114's license): `a = ln 2` from `Σx^j = 1`; `g = 3a/2` from vanishing of the `1/n` coefficient `a S₂/2 − g S₁`; `c = D₀/2` from the `1/n²` coefficient. Remainder exhibited as `O(1/n²)` with coefficient `0.00323` stable over `n = 10³…10⁶`. |
| **OP-6** | Exact order of `measure(S_1)/P(p) → 0` (the reachable fraction of the budget). | **SETTLED (this round)** — see [`OP-06-reachable-fraction.md`](OP-06-reachable-fraction.md) | Exact census: `S_1` is a union of `2^{n_min(p)−1}` disjoint intervals of common length `T_{n_min}`, so `measure(S_1) = 2^{n_min−1} T_{n_min}` (PROVED, rh42 Thm 10; VERIFIED two ways to `3.9·10⁻⁶²` for 13 exponents); measured fraction `1.000, 0.9374, 0.7841, 0.4911, 0.2564, 0.0528, 1.04·10⁻³, 1.01·10⁻⁵, 5.96·10⁻⁸, 2.35·10⁻¹⁰` at `p = 1.5 … 12`. **With OP-5's `n_min(p) = p/ln 2 − 3/2 + O(1)` and `ζ(p,n) = z(p)n^{−p}`, `z(p) → 2` (the regime is `p ≫ n`): `L(p) := −log(measure(S_1)/P(p)) = p log p − (1 + ln ln 2)p − c(e(p))/p + O(1/p²)` with the **closed-form, e-dependent** `c(e) = −((ln 2)²/2)(e² − e + 9/4)`, `e(p) = ⌈p/ln 2 − 5/2⌉ − (p/ln 2 − 5/2)`, i.e. `measure(S_1)/P(p) = p^{−p} e^{(1+ln ln 2)p}(1+o(1)) → 0`**; the recorded `c` in `−log(measure/P) ~ c·p log p` is **`c = 1`** (not `1/ln 2` or `2/ln 2`), and the linear coefficient is the exact `−(1 + ln ln 2) = −0.6334870794…` (verified to 10 figures: exact census values give `(L − p log p)/p = −0.6334870794` at `p = 10⁶`). The census identity was re-derived here and reproduces rh42 §4's table for `p = 2…12`. | RESOLVED by composing rh42 Thm 10 with OP-5: `2^{n_min−1}T_{n_min}/P(p) = 2^{n_min−1}ζ(p,n_min)/ζ(p)`, so `L = −(n−1)ln 2 − log ζ(p,n) + log ζ(p)`; the `p ≫ n` branch turns the Hurwitz tail into `n^{−p}·z(p)` with `z(p) → 2`, giving `L = p log p − (1 + ln ln 2)p + O(1)`. The `1/p` coefficient is **closed form but not constant**: `c(e(p))`, ranging over `[−(ln 2)², −(9/8)(ln 2)²] = [−0.480453, −0.540510]`; the earlier single constant `−0.540509640658…` was the `e = 0` (smooth-index) value (correction O4, `op06_ceiling_coefficient.py`). |
| **OP-7** | Self-contained proof that `Re S_N(t) = Σ_{n≤N} cos(t log n)` has a root for every `N ≥ 3`, without quoting equidistribution. | **OPEN** (proof-sketch + verified `N ≤ 200`) | Exact Lean witness at `N = 3` (`exists_balanced_partial_sum`, from `Re S_3(0) = 3 > 0`, `Re S_3(5/2) < 0`, no numerical axiom); `N = 4` via IVT; certified 47-digit root brackets for `N = 3..50` (auditor C3); `N = 3, …, 200` verified (`rh43/truths.md` §1.4, §6). | The only known existence engine is equidistribution of `(t log 2, …, t log N)` on the torus plus IVT; nothing in the folder gives a **quantitative** "some height makes the sum negative" estimate, and the tangent zero at `N = 2` shows a sign-change scan alone can miss a root. |
| **OP-8** | The term-level two-and-two split: can the positive terms (resp. negative terms) be partitioned into two subsets of equal sum at a balance point? | **REFUTED at every certified root; OPEN in general** | Structural cause PROVED: `cos(t log 1) = 1` is the first positive term and exceeds `P/2` whenever `P < 2`, so `1` can never sit in a half; exact subset-sum defects at `N = 6` are `0.16996…` (positive) and `0.06539…` (negative); defects `0.5, 0.358, 0.262, 0.170, 0.0108, 0.0202, 0.0286` for `N = 3,4,5,6,8,10,12` (VERIFIED by exhaustive subset-sum). | Whether the defect closes at some balance point of some `N` with `P ≥ 2` is untested beyond `N = 12`; the positive-only variant is separately blocked by the failure of the completeness condition at the **last index** (Brown's criterion, `a_m ≤ 0` fails). |
| **OP-9** | Exact complex vanishing `S_N(t) = Σ_{n≤N} n^{−it} = 0` for `N ≥ 4`. | **OPEN** | `N = 2` yes, exactly at `t = π/log 2` (PROVED + VERIFIED); `N = 3` **provably no** (PROVED in Lean: `zetaPartial_three_ne_zero`, via `3^{\|n\|} = 2^{\|m\|}`); `N = 4,5,6` grid minima `3.08·10⁻¹, 2.19·10⁻³, 7.75·10⁻⁴` on `[0,15]` (certified lower bounds — evidence, not proof) (rh43 §2, §6). | `1, 2^{−it}, …, N^{−it}` are `ℚ(t)`-linearly independent (rh43 Thm 9), so any zero is a degenerate coincidence of `log`-arithmetic; there is no mechanism that either produces or excludes one. |
| **OP-10** | An admissible explicit-formula kernel with an `O(1)` left side and a rapidly convergent zero sum. | **SETTLED (item T6)** — see `../010/rigorous/KERNEL_FINDINGS.md` | The corrected Weil form (with the archimedean term and pole arguments `2φ(i/2)`) holds to `≥ 20` digits on four kernels: Gaussian residual `1.6·10⁻⁴⁴`, modulated Gaussian `9.6·10⁻⁴⁶` (but LHS `~10⁻⁴⁴`), narrow Gaussian `−1.1·10⁻⁶³`, Cauchy companion `a = 1` (`~2` digits, limited by its `log G/G` zero-side tail); counting formula `N(T) = θ(T)/π + 1 + S(T)` verified, zeros to 32–33 digits (`rh45/truths.md` §7). | **Resolved (T6).** The compactly supported even `g(u) = C(1 − u²/144)⁴⁰ cos(γ₁u)` on `[−12,12]` has `\|LHS\| = 2.0000000000` and `RHS − LHS = −7.24·10⁻⁵⁴` at `K = 100` (zero tail `4.95·10⁻⁷⁷`), so an `O(1)`-LHS kernel with a rapidly convergent zero side **does** exist. Two corrections accompany it: the literal "decay at the trivial zeros" condition is unsatisfiable by *any* non-zero even kernel (for even `g`, `Φ(s) = Φ(1−s)`, and the archimedean term regularises the mirrored trivial zeros — a wording defect), and the literal negative claim ("`O(1)` LHS forces a zero tail `≥ c/log G`") is **false**: compact support forbids only *exponential* decay of `φ`, and the correct law is `g ∈ C^m` ⟹ `φ = O(t^{−(m+1)})`, tail `O((log G)G^{−m})` (so convergence needs `m ≥ 1`). |
| **OP-11** | The `Finset`-level perturbation identity `corrSlice_sub_corr_self_eq`: `corrSlice h a a − corr h a = −2λ(a)λ(a+h) − 2λ(a−h)λ(a)`. | **OPEN (recorded, not elaborated)** | Statement recorded in `rh46/lean/Rh46/Chowla.lean` lines 57–60 and 410–418; rigorously proved companions `corrSlice_eq_corr_of_lt` (prefix agreement) and `corrSliceSqSub` (`ℓ²`-mass of the perturbation is exactly `4`); `slice_agree`, `slice_self`. The whole file is otherwise **CERTIFIED**: 456 lines, 38 theorems, `./check.sh --all` exit 0, no `sorry`/`axiom`/`native_decide`, independently rebuilt. | It is the one lemma of the file left as a statement; the identity is a finite reindexing of the two summands containing `a`, so the obstruction is bookkeeping, not mathematics. |
| **OP-12** | `rh47`'s empty Lean layer and the **corrected** sparse bound `\|S_A(x) − S(x)\| ≤ 4·#{m ≤ x+2 : m ∈ A}` (not the `2·#{n ≤ x+2 : n ∈ A}` of `rh46`). | **OPEN (not formalised)**; the `rh46` version is **REFUTED** | Correct bound PROVED in prose (`rh47/truths.md` §3, via `≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A}`); the `o(x)` conclusion unaffected; the `rh47` Lean layer is **empty** (`rh47/lean/Rh47/` contains no files) and the inherited `rh46` layer is certified. | Witness to the wrong bound: `A = {5}`, `x = 5`, `\|ΔS\| = 4 > 2`. The correct statement is not yet machine-checked; the `rh47` round ran its 23/23 probe and 31/31 audit but wrote no Lean. |
| **OP-13** | The matching upper bound `A(N) = O(log log N)` for the number of greedy support indices `≤ N`. | **OPEN** | Lower bound `A(N) = Ω_x(log log N)` CHECKED via `r_{k+1} ≤ r_k²` (max observed ratio `0.993905`); all `277` reduced rationals with denominator `≤ 30` terminate, `275` within `n ≤ 5·10⁶` (rh41 §3). | The sharp half fails: `r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k)` with `f = {1/r_k}` has **no positive lower bound** (min `1.58·10⁻⁴` over 4 000 exact rational orbits, tending to `0` as `f → 1`), so no two-sided law `c·r_k² ≤ r_{k+1} ≤ r_k²` with `c > 0` exists ([`rh41/TRUTHS.md`](../TRUTHS.md) §3, §4). |
| **OP-14** | Residue of the `rh44` smoothing barrier: is there a non-positive/oscillating weight with `M_φ(1/2+it) ≡ 0` in `t`, and what is the explicit `N`–`t` trade-off? | **OPEN / PARTIAL** | The smoothing law PROVED + VERIFIED to 5–7 digits: `\|S_N^φ(1/2+it) − ζ(1/2+it)\|/√N → \|M_φ(s)\|`, `M_φ(s) = ∫_0^1 φ(u)u^{−s}du`; every one-sided weight keeps the `√N` (last-decade exponent `0.5000`); best tested weight `(u(1−u))³` buys a factor `600`; `o(1)` accuracy needs the functional equation (`e^{−πX}`) (`rh044/README.md`). Lean layer: weight-defect identity, triangle-inequality bound, radial decay `‖zetaTerm (σ+tI) n‖ = n^{−σ}` (383 lines, no `sorry`). | A **real** weight cannot have `M_φ ≡ 0` (positivity on `[0,1]`), so a complex-valued weight would be needed and is not excluded; and the `√N` is the Euler–Maclaurin main term `N^{1−s}/(1−s)`, not an artefact of the cutoff. |
| **OP-15** | Non-monotone alphabets in the inverse complexity problem: can a halting alphabet realise `p(L) = cL`? | **OPEN** | For non-increasing positive alphabets the impossibility is PROVED (rh41 Thm 12): halting ⟹ finitely many ones ⟹ `max_L p(L) = a_m + 2`, a constant, so no halting alphabet realises `p(L) = cL`, in particular not the Sturmian profile `p(L) = L+1`; the full complexity law `p(L) = L+1 + #{j : d_j < L}` on the `C1` range is PROVED for the unsigned word (rh41 Thm 1, 5) and transferred to the signed support (rh42 §7). | The impossibility proof uses monotonicity at the single step "the taken set is an initial segment then a tail"; for a non-monotone alphabet the taken set can be arbitrary and the greedy need not halt, so the argument does not start. |
| **OP-16** | The twin prime conjecture and Selberg's parity barrier (the programme's nominal target). | **OPEN — out of reach with current technique** | Parity balance among twin-prime candidates stays at ratio `0.9942` at `10⁵`, `0.9989` at `10⁶` (rh46 H2); sieve weights from `n mod 2·3·5·7` leave relative bias `~10⁻²`, not a parity break (rh43 §8.5); the greedy route is closed *as it stands* by `rh47` H4 (support dense `3.9·10⁻⁵`, Sylvester-sparse, moves `S(x)` by `O(log log x)`). | A map from a rule determined by the target alone and sign-blind to positive-density multiplicative information about `Ω` — precisely the missing ingredient `rh47` names, and precisely what the parity obstruction denies. |
| **OP-17** | Sarnak's Möbius-disjointness conjecture: `Σ_{n≤x} λ(n)f(n) = o(x)` for every deterministic (zero topological entropy) `f`. | **OPEN** | Implied by un-averaged Chowla (classical); **equivalent** to logarithmically averaged Chowla in the logarithmic-average form (Tao, arXiv:1605.04628, Thm 1.8); verified for many zero-entropy systems (nilsystems, rotations, …). | Same as OP-4: only averaged/entropy-decrement technology is available; the conjecture is strictly stronger than anything the programme's `log n`-only objects can reach. |
| **OP-18** | The **positive** existence question behind `rh47`'s barrier: is there *any* sign-blind alphabet with a positive-density multiplicative coupling to `Ω`? | **OPEN — heuristic answer is no** | `rh47` H4: no object in rh41–rh45 supplies it; the arithmetic-alphabet counterexample `α_p = (−1)^{Ω(p+2)}/(p+2)` does couple (`z = +10.1`, audit C3a) but imports `Ω` by construction and is **circular** for the twin-prime purpose (only a consistency check). | "Coupling" is not defined independently of the correlation being studied; every exhibited coupling is either arithmetic-by-construction or a repeat of the open correlation itself. |
| **OP-19** | **The log-indicator barrier** — the well-posed replacement for `OP-3`. A **log-arc rule** is `A_I = {n ≥ 1 : log n mod 2π ∈ I}`, where `I` is a finite union of intervals in `0,2π)` with endpoints in a fixed countable field (canonically `ℚ(π)`) and measure `0 < \|I\| < 2π`; put `C_I(x) = Σ_{n≤x} 1_{A_I}(n)λ(n)`. **(P1)** Is `C_I(x) = o(x)` for every log-arc rule? **(P2)** settle the single arc `I = [0,π)`, i.e. the `rh43` set `{n : cos(log n) ≥ 0}`. | **OPEN** — and now **well-posed**: the class is countable, so the statement has a definite truth value, and every instance is computable against. | The same identity **is** a theorem for *finite exponential sums* `w(n) = Σ_{\|k\|≤K} c_k n^{it_k}`: each `Σ_{n≤x}λ(n)n^{it} = o(x)` because `ζ(2(s−it))/ζ(s−it)` is analytic on `Re s ≥ 1` (poles need `Re s = 1/2`; `ζ(1+ir) ≠ 0`; `s = 1+it` is a zero, not a pole). Also: the *literal* reading over all functions of `log n` is **false** — `log` is injective on `ℕ`, and `A = {n : λ(n) = 1}` gives `C(x) = x/2 + o(x)`. | The square wave's Fourier series is not absolutely convergent (coefficients `≍ 1/k`), so the finite-sum theorem does not transfer to an indicator; positive density is necessary by the corrected sparse bound `≤ 4·#{m ≤ x+2 : m ∈ A}` (`rh47` §3). The programme's apparatus resolves neither **(P2)** nor any single arc, and a published resolution was not confirmed. Full definitions: [`../../../TODO.md` §A.1 |

## A.2 Notes on the two rows whose status is unusual

**OP-2 (one-point Chowla).** This is the register's only row whose residue is
*methodological*. `Σ_{n≤x}λ(n) = o(x)` is a theorem (⟺ PNT). What is *not* available is
a proof by sieve: Selberg's parity problem states that for a sieve weight `w` built from
small-prime residue conditions, `Σ w(n)λ(n) = o(Σ w(n))` is unobtainable. So the
programme's genuine collision with the one-point case is with the *barrier*, not with
the truth of the statement. `rh46` §1.3 conflates the two; this register separates them.

**OP-3 (R2).** As inherited from `rh47/HANDOFF.md` §4 R2 and
`rh47/truths.md` §5, R2 is: *"prove that no sign-blind
deterministic rule seeing `n` only through `log n` can force a multiplicative
correlation."* Three things must be said.

1. **It is not yet a proposition.** "Rule", "sees", and "force" have no definitions in
   the harvest; R2 is a research direction, not a theorem statement. *Making R2 precise
   is itself the first open sub-problem.* **Discharged by `OP-19`** (`TODO.md` §A.1):
   the repair is to restrict the *description* of the rule — a log-arc rule
   `A_I = {n : log n mod 2π ∈ I}` with `I` a finite union of intervals with endpoints in a
   fixed countable field — and then to ask whether `Σ_{n≤x} 1_{A_I}(n)λ(n) = o(x)`.
   Note also that the *literal* reading over all functions of `log n` is **false**: `log`
   is injective on `ℕ`, and `A = {n : λ(n) = 1}` yields `x/2 + o(x)`.
2. **The over-wide reading is false.** The `rh47` HANDOFF's supporting sentence —
   "every greedy-sine object is an additive character in `log n`" — was withdrawn after
   audit (`truths.md` §3): `n^{−it}` is multiplicative on `(ℝ₊,×)`, and the sums
   `Σ λ(n)n^{−it}` *do* vanish (`= o(x)` for each fixed real `t`; classical, from
   `ζ(2s)/ζ(s)` analytic on `Re s ≥ 1` because `ζ(1+ir) ≠ 0`). So additivity alone
   neither prevents nor forces correlation.
3. **The concrete instance that resists.** The `rh43` positive-part set
   `A_t = {n : cos(t log n) > 0}` is exactly a sign-blind rule depending on `n` only
   through `log n`; `Σ_{n≤x} 1_{A_t}(n)λ(n) = o(x)` is **not known**. The Fourier
   series `1_{cos θ>0} = 1/2 + (2/π)Σ_{k≥0}(−1)^k cos((2k+1)θ)/(2k+1)` expresses the sum
   as a *divergent* series of individually-`o(x)` twisted sums, so no available
   technique truncates it. *(Literature status of this one instance: marked
   **unverified** in this register — it is not settled by any result harvested in
   rh40–rh47, and the register could not confirm a published resolution.)*

The register therefore records R2 as the highest-**value** target and as **not yet
well-posed**; see Part B rank 6.

---

# Part B — the research plan

Each entry gives **next step**, **falsifiable claim / experiment**, **resources**,
**difficulty** (one line). Difficulty is one of `L` (a week's careful work),
`M` (a focused round), `H` (a programme-level effort), `X` (out of reach with current
technique).

## B.1 Per-problem plan

### OP-12 — Lean: corrected sparse bound and the empty `rh47` layer
* **Next step.** Create `rh47/lean/Rh47/Sparse.lean` with `corrSubset_abs_sub_le`:
  for `A ⊆ ℕ` a finite perturbation of `λ`'s support, the two-point correlation differs
  by at most `2·#{n ≤ x : n ∈ A ∨ n+2 ∈ A}`; derive the `≤ 4·#{m ≤ x+2 : m ∈ A}`
  corollary. Port the `rh46` slice layer.
* **Falsifiable claim.** `lake build` succeeds with no `sorry`; the witness
  `A = {5}`, `x = 5` is an instance of the *correct* bound and a `decide`-checkable
  counterexample to the `rh46` form.
* **Resources.** The existing `rh46/lean` toolchain and `check.sh`; one agent-round.
* **Difficulty — `L`.** It is a finite reindexing plus `Finset` monotonicity; the only
  work is bookkeeping, as OP-11's recorded status already shows.

### OP-11 — Lean: elaborate `corrSlice_sub_corr_self_eq`
* **Next step.** Turn the commented statement (Chowla.lean, lines 410–418) into a
  theorem; prove it by splitting `Finset.Icc 1 a` at `a` and `a−h` and using
  `slice_self`/`slice_agree`. Then upgrade `corrSlice_ne_corr_self_statement` to use it.
* **Falsifiable claim.** The file's header note "the single exception" can be deleted;
  `#print axioms corrSlice_sub_corr_self_eq` reports only `propext`,
  `Classical.choice`, `Quot.sound`.
* **Resources.** The `rh46/lean` checkout; one agent-day.
* **Difficulty — `L`.** Finite-sum manipulation; the mathematics is already fixed by
  the two proved companions.

### OP-10 — an `O(1)`-LHS, rapidly convergent explicit-formula kernel
* **Next step.** Search the modulated-Gaussian family
  `g(u) = cos(au)e^{−u²/2σ²}` for a parameter regime where the pole term `2φ(i/2)` is
  `Θ(1)` while the zero side decays like `e^{−γ²/2}`; quantify the truncation by the
  Cauchy-companion bound of `rh45/truths.md` §7.
* **Falsifiable claim.** A table of kernels with (i) `|LHS| ≥ 0.1`, (ii) residual
  `≤ 10⁻²⁰` at `10³` zero terms, (iii) `g` compactly supported up to the stated
  truncation; **or** a proof that `O(1)` LHS forces a zero-side tail
  `≥ c/log G` for every compactly supported even `g`.
* **Resources.** The `rh45/explicit_formula.py` engine, certified `ζ` and zero data,
  a high-precision arithmetic layer (`rh43/ivmath.py`).
* **Difficulty — `M`.** The formula is already correct and verified; the question is a
  finite-dimensional optimisation with a tail estimate, and the negative branch is
  plausible because compact support and pole mass are in tension.

### OP-5 — asymptotic of `n_min(p)` — **SETTLED** ([`OP-05-nmin-asymptotic.md`](OP-05-nmin-asymptotic.md))
* **Result.** `n_min(p) = p/ln 2 − 3/2 + O(1)`; thresholds `P_n = (n + 3/2)ln 2 + c/n + O(1/n²)`,
  `c = 3(ln 2)² − (25/12)ln 2 = −0.00269758441194845395…`. The recorded `n_min ≈ p + O(1)` is refuted.
  Reproduce: `op05_nmin.py`. The earlier "next step" below is superseded and kept for the record.
* **Falsifiable claim.** A certified table showing `|n_min(p) − p| ≤ C` for all
  computed `p`, **or** a single `p` with `|n_min(p) − p| > C` for the candidate `C`
  (the data cannot yet distinguish `C = 2` from a slowly growing `o(p)`).
* **Resources.** `rh42/reachable.py`'s exact `Fraction` machinery plus outward-rounded
  `ζ(p)` (Euler–Maclaurin as in `rh42` §6).
* **Difficulty — `M`.** The boundary equation is one-dimensional and the sign change
  is unique (PROVED); only the transcendental control at large `p` is new.

### OP-6 — order of the reachable fraction — **SETTLED** ([`OP-06-reachable-fraction.md`](OP-06-reachable-fraction.md))
* **Result.** `−log( measure(S_1)/P(p) ) = p log p − (1 + ln ln 2)p − c(e(p))/p + O(1/p²)` with the closed-form `c(e) = −((ln 2)²/2)(e²−e+9/4)`,
  i.e. `measure(S_1)/P(p) = p^{−p} e^{(1+ln ln 2)p}(1+o(1)) → 0`. The recorded `c` is `c = 1`
  (not `1/ln 2`, not `2/ln 2`); the linear coefficient `−(1 + ln ln 2) = −0.6334870794…` is exact.
  Reproduce: `op06_reachable_fraction.py`.
* **Falsifiable claim (discharged).** The recorded form predicted a leading constant `c` in
  `−log(measure/P) ~ c·p log p`. It is `c = 1`, checked against the exact census data at
  `p = 10³…10⁶` and against the independent large-`p` branch to `p = 10^{13}`.
* **Resources.** As OP-5; no new engine. rh42 Thm 10 (census) plus OP-5's `n_min`.
* **Difficulty — L–M.** It is a corollary of OP-5 and the PROVED census theorem; the only
  care needed is the regime identification (`p ≫ n`, so `ζ(p,n) ≈ n^{−p}`) and keeping the
  two coefficients of the same order apart.

### OP-7 — self-contained root existence for `Re S_N`, all `N ≥ 3`
* **Next step.** Replace the torus-equidistribution step by a quantitative
  lower bound: exhibit an explicit `t_N` with `Σ_{n=2}^N cos(t_N log n) < −1`,
  constructed from a rational approximation to `(log 2, …, log N)` (a Dirichlet/Baker
  box argument), and certify the inequality.
* **Falsifiable claim.** For each `N ≤ 10³`, an explicit rational `p_N/q_N` with a
  certified `Re S_N(2π p_N/q_N) < 0`, together with a uniform-in-`N` construction rule.
* **Resources.** `rh43/ivmath.py` (certified `cos`, `log`), a Diophantine-approximation
  layer; one focused round.
* **Difficulty — `M`.** Equidistribution is overkill; what is needed is one good height
  per `N`, and simultaneous approximation of `log 2, …, log N` is quantitative and
  classical, though the box size grows with `N`.

### OP-8 — term-level split beyond `N = 12`
* **Next step.** At balance points with `P ≥ 2` (i.e. larger `N`), solve the exact
  subset-sum question by meet-in-the-middle with certified interval arithmetic, and
  record the defect against `P/2` as a function of `N`.
* **Falsifiable claim.** The defect `δ(N) = P/2 − max{Σ_A : Σ_A ≤ P/2}` is
  `> 0` for all certified roots up to `N = 40`, **or** a first `N` with `δ(N) = 0`
  (an exact transcendental coincidence, checkable to 47+ digits).
* **Resources.** Certified root brackets (auditor C3), `ivmath.py`, subset-sum
  enumeration with pruning; a compute-bound task.
* **Difficulty — `M`.** Certification is already solved; the only obstacle is
  combinatorial growth, and the structural `cos(t log 1) = 1` obstruction weakens as
  `P` grows, so a positive answer cannot be excluded by inspection.

### OP-3 / OP-18 — the barrier, made precise

> **`OP-3` is now discharged into `OP-19`** (log-indicator barrier). The step below is
> retained because it is the route that produced `OP-19`; `OP-19` fixes the definitional
> step, corrects the over-wide reading, and states the resulting problem so that it has a
> definite truth value. See `../../../TODO.md` §A.1.
* **Next step.** (i) Fix a definition of "log-arithmetic rule" (the least
  over-reaching candidate: `A = {n : F(log n) ≥ 0}` for `F` in a stated class);
  (ii) settle the concrete instance `A_t = {n : cos(t log n) > 0}` *at least
  numerically to `10¹⁰`* and state the exponent; (iii) either prove the `O(1)`-LHS
  statement for the resulting correlation or exhibit a `t` and a window where
  `|Σ_{n≤x}1_{A_t}λ(n)|/x` fails to fall.
* **Falsifiable claim.** A definition under which the claim is a theorem (with a
  proof), **or** a numerical/published counterexample at some `t`.
* **Resources.** Large sieves for `λ` (`rh46/chowla_two_point.py` reaches `10⁹`),
  plus a literature check on Liouville correlation with sign-of-cosine sequences.
* **Difficulty — `X` for the theorem, `M` for the experiment.** The
  `k = 1` twisted Chowla facts show that vanishing correlations with `log n`-data
  *exist*, so any negative theorem must isolate a genuinely additional property
  (roughness / positive density); the concrete instance is untested and is the honest
  route to a **new obstruction** rather than a theorem.

### OP-1 / OP-4 / OP-16 / OP-17 — the arithmetic core
* **Next step (all four).** Do not attack directly; instead maintain the *record*:
  re-derive the corrected sparse bound, keep the finite-prefix indeterminacy Lean-
  certified, and add the two missing literature anchors (`k=1` ⟺ PNT; Chowla ⟹ Sarnak)
  to the dictionary entry. The only technically live sub-target is OP-10's kernel,
  which reduces the analytic input to a finite optimisation but does not touch parity.
* **Falsifiable claim.** No claim is made here; any `o(x)` claim for `h = 2` would be a
  solution of two-point Chowla.
* **Resources.** Negative.
* **Difficulty — `X`.** Un-averaged two-point Chowla is open; the programme's own
  finite-prefix theorem shows a computational route is impossible in principle, and the
  no-Euler-product fact (`rh46` §1.5) shows the `ζ`-machinery route is impossible
  as stated. *This is the honest assessment: twin primes are out of reach with current
  technique, from this programme and from the field.*

### OP-13 — `A(N) = O(log log N)`
* **Next step.** Find a lower bound for `r_{k+1}/r_k²` along the *measure-theoretic*
  typical orbit rather than uniformly: prove that the set of `x` where
  `r_{k+1}/r_k² ≤ ε` for a run of `k` has small measure (a Borel–Cantelli /
  Gauss-like estimate on the induced map `s ↦ 1 − {q²/s}`).
* **Falsifiable claim.** Either `A(N) = O(log log N)` with an explicit constant, or a
  one-parameter family `x_ε` with `A(N) ≥ c log log N / log(1/ε)` exhibiting the
  divergence.
* **Resources.** Exact rational orbit data (4 000 orbits exist), a measure-theory
  argument on the induced map of `rh41` Thm 7.
* **Difficulty — `H`.** The uniform bound is provably false (`rh41` §3), so this is a
  genuinely almost-everywhere statement and needs an ergodic input the programme has
  not built.

### OP-9, OP-14, OP-15
* **OP-9 next step.** Search `[0, T]` for `S_N(t) = 0` with certified interval
  arithmetic for `N = 4..10`, `T` up to `10³`, and prove a lower bound on `|S_N|` away
  from the resonance lattices. *Claim:* a certified zero for some `N ≥ 4`, or a
  certified positive lower bound on `[0,T]`. *Difficulty — `H`*: no mechanism is known
  in either direction, and the `N = 3` proof is a one-off `log`-arithmetic accident.
* **OP-14 next step.** Test complex weights `φ(u) = e^{iθ}u^{a}(1−u)^{b}` and measure
  `inf_t |M_φ(1/2+it)|`. *Claim:* a positive lower bound `|M_φ| ≥ c > 0` for all such
  weights, or an explicit `φ` with `|M_φ| ≤ 10⁻⁶` on `[0,50]`. *Difficulty — `L`*: it
  is a finite numerical question about an explicit integral, already isolated in
  `rh044/truths.md` §7.
* **OP-15 next step.** Enumerate small non-monotone alphabets and compute their
  complexity profiles; look for a first `p(L)` growing linearly while halting.
  *Claim:* a halting non-monotone alphabet with `sup_L p(L)/L = ∞`, or a proof that
  non-monotonicity cannot help below `L = 20`. *Difficulty — `M`*: finite search, but
  the profile depends on the truncation length `N`, so the search space is large.

### OP-2 — one-point Chowla (record maintenance only)
* **Next step.** Correct `rh46/README.md` §1.3 and `rh47/HANDOFF.md` §5.1 /
  `rh47/README.md` to say *equivalent to PNT, hence a theorem*; add the `λ = 1_□ * μ`
  transfer to the dictionary entry; keep the parity-barrier statement (no sieve proof)
  separate from the truth of the statement.
* **Falsifiable claim.** A grep of the rounds finds no surviving sentence calling
  one-point Chowla open.
* **Resources.** Editorial.
* **Difficulty — `L`.** It is a documentation fix; the mathematics is classical.

## B.2 Ranking by value × tractability

Value is the programme's own objective (closing a gap, removing a defect, or moving the
parity target); tractability is the probability of a *certified* result within one or
two focused rounds. **R2 is the highest-*value* item but not the highest-value-×-
tractability item**, because it is not yet a well-formed statement.

| rank | id | value | tractability | product | comment |
|---|---|---|---|---|---|
| 1 | **OP-12** | M | H | **highest** | removes a known false bound from the record and fills the empty `rh47` Lean layer; purely bookkeeping. |
| 2 | **OP-11** | M | H | very high | one commented lemma stands between the certified `rh46` layer and "no exception". |
| 3 | **OP-10** | M | M | high | concrete analytic kernel; already verified infrastructure; double-edged (a negative result is also publishable here). |
| 4 | **OP-5** | M | M | high | **DONE this round** — `n_min(p) = p/ln2 − 3/2 + O(1)` and `P_n = (n+3/2)ln2 + c/n + O(1/n²)`, `c = 3(ln2)² − (25/12)ln2`; opens OP-6 (substitute `n_min` into `measure(S_1) = 2^{n_min−1}T_{n_min}`). |
| 5 | **OP-6** | L–M | M | good | **DONE this round** — `measure(S_1)/P(p) = p^{−p} e^{(1+ln ln 2)p}(1+o(1))`; the recorded `c` in `c·p log p` is 1, linear coefficient `−(1 + ln ln 2)`. |
| 6 | **OP-3** | **H (highest)** | L (not yet well-posed) | medium | the real ambition; but step 1 is definitional, and the one concrete instance is open-hard. |
| 7 | **OP-7** | M | M | good | existence is already verified to `N = 200`; only self-containedness is missing. |
| 8 | **OP-8** | L | M | fair | certification infrastructure exists; combinatorial cost grows. |
| 9 | **OP-14** | L | H | fair | an explicit integral question; low stakes for parity. |
| 10 | **OP-13** | M | L | low | a genuine almost-everywhere ergodic problem. |
| 11 | **OP-15** | L | L | low | inverse-problem curiosity; large search space. |
| 12 | **OP-9** | L | L | low | no mechanism in either direction. |
| 13 | **OP-2** | M (record) | H (editorial) | — | correctness, not research; do it regardless of ranking. |
| 14 | **OP-1, OP-4, OP-16, OP-17, OP-18** | H | X | — | see below. |

## B.3 Out of reach with current technique (stated plainly)

The following are **not** going to be settled by this programme, and the register says
so rather than pretending otherwise:

* **OP-1** un-averaged two-point Chowla, **OP-4** `k`-point Chowla, **OP-17** Sarnak's
  conjecture, **OP-16** twin primes / Selberg's parity barrier. Reasons: (i) the
  finite-prefix theorem (`rh46` §1.4, Lean-certified) shows no computation decides
  (★); (ii) the no-Euler-product fact (`rh46` §1.5, `rh47` B3) kills the
  Dirichlet-series/Perron route; (iii) the only known averaging technology
  (entropy decrement; Matomäki–Radziwiłł–Tao) delivers logarithmic and almost-all-`h`
  statements, not a fixed un-averaged shift; (iv) the programme's own objects are
  Sylvester-sparse (`rh47` H1, density `3.9·10⁻⁵`) and by the corrected sparse bound
  move `S(x)` by `O(log log x)`, so they cannot be positive-density witnesses.
* **OP-18** (positive existence of a sign-blind positive-density coupling). It is
  defined relative to the correlation under study, so a "yes" would be circular and a
  "no" is a heuristic, not a theorem.
* **OP-3** in its strong form. Not because it is false, but because it is not yet a
  proposition, and because the one concrete instance (`1_{cos(t log n)>0}`) is itself
  open; cf. A.2.

A useful test of honesty: **no item in this register, if proved, would prove the twin
prime conjecture.** The best a success in OP-3/OP-18 could do is *close the greedy-sine
route in principle* — which is stated as `rh47`'s real ambition and is not the same
thing.

## B.4 What would count as progress

Three different kinds of output, worth distinguishing because the programme has
produced them in very different proportions:

**(i) A new theorem.** A statement with a proof (ideally machine-checked) that was not
previously available, not a restatement of a known result. *Examples in the programme:*
the `k=1` ⟺ PNT transfer (classical; recorded, not new), Brown's criterion applied to
the `p`-series with the exact census and thresholds `p*`, `q` (rh42, new as a package),
the parity lock (rh42/`Tau.lean`), the smoothing law `|S_N^φ − ζ|/√N → |M_φ(s)|`
(rh044), and the **certified finite-prefix theorem** (`rh46/lean/Rh46/Chowla.lean`,
456 lines, 38 theorems, `./check.sh --all` exit 0, no `sorry`, independently rebuilt) —
**this last is the programme's one clean (i).** It is a theorem *about* two-point
Chowla, not a proof of it: it proves that the conjecture is undecidable by finite prefix
data, and that the shifted product is not multiplicative. Exactly one certified theorem
of the "new mathematics" kind, and it is a *logical* theorem about the problem rather
than a step toward it.

**(ii) A new obstruction.** A *negative* result: a proof or certified witness that a
proposed route cannot work. This is what the programme actually excels at. *Examples:*
Brown's criterion refuting the single-condition completeness claim (rh42 R3); the
refutation of "inside the budget ⟹ writable" (`p = 2`, `x = 1/5`); the refutations of
"greedy is optimal in general" and "measure(reachable) = `P(p)`"; the falsification of
"`Σ_{n≤x}λ(n)` is open" (this register, OP-2); the falsified `2·#{n ≤ x+2}` sparse bound
(rh47 §3, and this is a *published-in-programme* false statement corrected); the
refutation of the greedy-support-as-signal bridge by size-matched controls
(`z = −47.9` → `+0.43`, `+1.55`); the no-Euler-product discrepancy `2.0144`; the
refutation of the `1/√(2t)` constant and of "smoothing removes `√N`" (rh044). **The
programme's output is overwhelmingly of this kind, and that is its main substantive
contribution.**

**(iii) A numerical observation.** A finite-range computation with certified
intervals, reported as a description and *not* as an asymptotic. *Examples:* the
prefix-max exponent `α = 0.5200 ± 0.0249` (explicitly "a finite-range fit; no asymptotic
claim"), the certified root brackets for `N = 3..50`, the zero localisation to 32–33
digits, the support-density measurements `3.90·10⁻⁵`, the reachable-fraction table. The
programme is honest about these, and this register keeps that discipline: no numerical
observation in the harvest is promoted to a theorem, and the two `rh46` sentences that
came closest to doing so (the "open" label on one-point Chowla, and the `2·#{…}` bound)
are corrected in §0.1.

**The one-line accounting.** Of the three currencies, the programme has produced
**one clean (i)** — the certified finite-prefix/undecidability theorem — a large stock
of **(ii)**, and a well-disciplined set of **(iii)**. Its stated goal (the greedy
harmonic sine solving the parity problem for twin primes) is **not achieved**, and the
harvest's own conclusion (`rh47` H4) is that it cannot be achieved by the programme as
it stands. The most valuable *defensible* next output is a **precise negative theorem
for OP-3**; the most valuable *achievable* next output is the pair OP-11 + OP-12, which
converts the last two prose-only statements in the barrier chain into machine-checked
theorems.

---

## Appendix — one-line index of sources

| round | file | what it contributes to this register |
|---|---|---|
| rh40 | `rh40/` | the unsigned factor-complexity law (context) |
| rh41 | [`rh41/TRUTHS.md`](../TRUTHS.md) | OP-13, OP-15; the complexity law `p(L)` |
| rh42 | `rh42/truths.md` | OP-5, OP-6; budgets, Brown's criterion, census, thresholds, parity lock |
| rh43 | `rh43/truths.md` | OP-7, OP-8, OP-9; the balance reduction and the parity refusal (§8.5) |
| rh044 | `rh044/README.md` | OP-14; the smoothing barrier |
| rh45 | `rh45/truths.md` | OP-10; the explicit formula and its open kernel |
| rh46 | `rh46/README.md`, `rh46/lean/Rh46/Chowla.lean` | OP-1, OP-2 (corrected), OP-11; the certified finite-prefix theorem |
| rh47 | `rh47/HANDOFF.md`, `rh47/truths.md`, `rh47/README.md` | OP-3, OP-12, OP-16, OP-18; the harvest, the barrier, the corrected sparse bound |
