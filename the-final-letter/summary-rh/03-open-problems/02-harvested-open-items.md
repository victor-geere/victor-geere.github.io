# Harvested open and conjectured items

> Source: [`research/open.md`](../../rh/research/open.md) §5. Thirty-six items graded OPEN or CONJECTURED by the programme harvest, with the source’s caveat that eleven are heuristic models, not committed targets.

## 5. Open and conjectured items in the twin-prime-parity harvest

> **2026-10-11 tractability pass.** A per-item value × tractability survey of every row
> below (and of the still-open OP-1…OP-19) lives at
> [`open-tractability.md`](../../rh/research/open-tractability.md); the rows it settled or corrected are
> recorded there. The `OP-26`/`OP-27` rows of §5.3 are **settled** (OP-13, with the
> direction correction); see §3.4 of the journal and the corrected rows below.

[`theorems/tpp/INDEX.md`](../../rh/theorems/tpp/INDEX.md) indexes **582** harvested items from
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
[`07-open-problems.md`](../../rh/research/twin-prime-parity/open/07-open-problems.md): that register holds
the **programme-level** problems, and its `OP-1 … OP-19` are unchanged. Its Part A carries
a pointer back to this section so the two numberings can be read together.

### 5.1 Chowla, twin primes and the parity problem (15)

| id | item | source | status | what it says |
|---|---|---|---|---|
| **OP-1, OP-16** | [un-averaged two-point Chowla](../../rh/theorems/tpp/tpp-dict-00-un-averaged-two-point-chowla-open.md) | (dictionary A5) | OPEN | The target: `Σ_{n≤x} λ(n)λ(n+2) = o(x)`. |
| **OP-1, OP-16** | [two-point Chowla — the target](../../rh/theorems/tpp/tpp-dict-03-two-point-chowla-open.md) | (parity chapter, OPEN 3.4) | OPEN | The same statement as the `k = 2`, `h = (0,2)` case of Chowla; rh46 established only that it is open. |
| **OP-4** | [the `k`-point Chowla conjecture](../../rh/theorems/tpp/tpp-dict-03-chowla-conjecture.md) | (Conjecture 3.1, Chowla 1965) | OPEN for every `k ≥ 2` | `Σ λ(n+h_1)⋯λ(n+h_k) = o(x)` for distinct `h_i`; equivalently every sign pattern has density `2^{−k}`. `k = 1` is PNT, a theorem. |
| **OP-4, OP-16, OP-17** | [the register of open statements](../../rh/theorems/tpp/tpp-dict-03-open-chowla-twin-sarnak-elliott.md) | (OPEN 4.2) | OPEN | Full `k`-point Chowla for `k ≥ 2`; the twin prime conjecture; Sarnak's Möbius-disjointness; Elliott for bounded multiplicative functions, un-averaged. |
| **OP-16** | [the twin prime lower bound](../../rh/theorems/tpp/tpp-dict-03-twin-prime-open.md) | (OPEN 2.7) | OPEN | `π₂(x) ≫ x/(log x)²`; the gap from `P₂` (Chen, theorem) to `P₁` is exactly the parity barrier. |
| **OP-16** | [Hardy–Littlewood / Dickson `k`-tuples](../../rh/theorems/tpp/tpp-dict-03-hardy-littlewood-dickson-k-tuples.md) | (Conjecture 1.8) | OPEN for every `k ≥ 2` | The quantitative prime-tuple asymptotics; `h = (0,2)` is the twin prime conjecture. HEURISTIC as a prediction. |
| **OP-1, OP-16** | [the exact relation with twin primes](../../rh/theorems/tpp/tpp-dict-03-exact-relation-twin-primes.md) | (THEOREM 5.1) | OPEN for parts (b), (c) | `S(x) = o(x)` is equivalent to the equal-class density being `1/2`; part (a) is proved, but no implication to twin primes is known in either direction. |
| **OP-1** | [an intermediate decay statement](../../rh/theorems/tpp/tpp-dict-03-open-intermediate-decay.md) | (OPEN 4.3) | OPEN | Whether `Σ_{n≤x} λ(n)λ(n+2) = O(x/(log x)^A)` for any `A > 0`. Recorded for calibration: it is strictly between trivial and `o(x)`. |
| **OP-20** | [a frontier preprint on log-Chowla](../../rh/theorems/tpp/tpp-dict-03-guo-preprint-unverified.md) | (UNVERIFIED 4.7) | OPEN — citation unverified | A fixed power-logarithmic bound for the log-weighted correlations, from a single-author preprint that is **not peer-reviewed**; the archive marks it UNVERIFIED. |
| **OP-17** | [truncated Selberg weights](../../rh/theorems/tpp/tpp-dict-03-truncated-weights-unverified.md) | (UNVERIFIED 2.3) | OPEN | The `λ`-mean-zero slogan cannot be taken literally once weights are truncated at level `D = x^θ`, `θ < 1`: truncation destroys periodicity and the 2.2 argument does not apply. |
| **OP-21** | [the \"switching\" reading of Chen](../../rh/theorems/tpp/tpp-dict-03-chen-switch-heuristic.md) | (HEURISTIC 2.8) | CONJECTURED | Interpretation, not a theorem: the two linear forms `n`, `n+2` are given asymmetric roles and the bilinear structure supplies the missing parity input. |
| **OP-22** | [why log-averaging is weaker](../../rh/theorems/tpp/tpp-dict-03-log-averaging-weaker-heuristic.md) | (HEURISTIC 4.5) | CONJECTURED | Structural explanation of why the logarithmic average constrains only a full-density set of scales. The rigorous content is THEOREM 4.4. |
| **OP-23** | [the shape of the missing input](../../rh/theorems/tpp/tpp-dict-03-missing-input-heuristic.md) | (HEURISTIC 5.4) | CONJECTURED | Three kinds of input known to cross a parity barrier — Type-II/bilinear, spectral, and entropy-decrement — none available for the twin primes. |
| **OP-24** | [the random-sign model](../../rh/theorems/tpp/tpp-dict-03-random-sign-heuristic.md) | (HEURISTIC 3.2) | CONJECTURED | If `(λ(n))` were independent random signs every correlation would be `O(x^{1/2+ε})`. The model ignores complete multiplicativity, so it is only a picture. |
| **OP-25** | [why the slogan is the right picture](../../rh/theorems/tpp/tpp-dict-03-slogan-heuristic.md) | (HEURISTIC 2.4) | CONJECTURED | `λ` has mean `0` mod `q` and does not pretend to be `χ(n)n^{it}`, which is the modern reason to expect cancellation. |

### 5.2 The barrier (`rh47` and its corrections) (8)

| id | item | source | status | what it says |
|---|---|---|---|---|
| **OP-3, OP-18** | [the corrected barrier](../../rh/theorems/tpp/tpp-dict-00-corrected-barrier-open.md) | (dictionary F9) | OPEN (heuristic) | No **sign-blind alphabet with no arithmetic input** supplies a positive-density multiplicative coupling to `Ω`. |
| **OP-3, OP-18** | [the corrected barrier](../../rh/theorems/tpp/tpp-dict-03-f9-corrected-barrier.md) | (parity chapter F9) | OPEN (heuristic) | The same barrier from the parity chapter, with the reasons the impossibility is not a theorem. |
| **OP-3 → OP-19** | [OP-3 downgraded to a heuristic](../../rh/theorems/tpp/tpp-open-07-barrier-downgraded-to-heuristic.md) | (open register) | CONJECTURED | The register's own `OP-3`: the over-wide \"every greedy-sine object is an additive character in `log n`\" form is **withdrawn**; the corrected claim is a heuristic, not a proposition. |
| **OP-3, OP-18** | [the corrected barrier](../../rh/theorems/tpp/tpp-rh47-truths-corrected-barrier-open.md) | (`rh47/truths.md`) | OPEN (heuristic) | The barrier as rh47 finally states it, subject to that round's correction 2: the impossibility must stay OPEN. |
| **OP-3** | [the barrier in one sentence](../../rh/theorems/tpp/tpp-rh47-handoff-barrier-additive-character-open.md) | (`rh47/HANDOFF.md`) | OPEN (heuristic) | The withdrawn one-sentence form, kept because the record correction is part of the round's result. |
| **OP-3** | [the barrier in one sentence](../../rh/theorems/tpp/tpp-rh47-readme-barrier-additive-character-open.md) | (`rh47/README.md`) | OPEN (heuristic) | The same sentence in the round README's wording, likewise superseded by the record correction. |
| **OP-18** | [bridge B1 — no mechanism known](../../rh/theorems/tpp/tpp-rh47-handoff-bridge-b1-no-mechanism-known.md) | (`rh47/HANDOFF.md`) | OPEN | No mechanism is known by which the greedy *support* could correlate with `λ`'s parity class; the signed support's parity lock is a rigidity, not a bridge. |
| **OP-18** | [H4 — the goal is unreachable as it stands](../../rh/theorems/tpp/tpp-rh47-handoff-h4-goal-unreachable-open.md) | (`rh47/HANDOFF.md`) | OPEN | The honest conclusion: the goal cannot be reached by the greedy-sine programme as it stands, because the missing ingredient is a sign-blind positive-density coupling and the greedy support is Sylvester-sparse. |

### 5.3 The `rh40` greedy-word open questions (13)

| id | item | source | status | what it says |
|---|---|---|---|---|
| **OP-26** | [Theorem G — the upper bound is open](../../rh/theorems/tpp/tpp-rh40-k-remaining-theorem-g-upper-bound-open.md) | (`rh40/K_remaining.md`) | **SETTLED (OP-13, 2026-10-11; direction corrected)** | The harvested title is wrong about the direction: `A(N) ≤ log₂ log N + O(1)` is **proved** from the take rule + the one-sided squaring law `r_{k+1} ≤ r_k²`. The no-positive-lower-bound obstruction `r_{k+1}/r_k² ≤ 1` is real, but it kills the `Ω` **lower** bound, not the upper bound. |
| **OP-27** | [A4b — the matching upper bound](../../rh/theorems/tpp/tpp-rh40-rounds-truths-a4b-upper-bound-open.md) | (`rh40/rounds/truths.md`) | **SETTLED (OP-13, 2026-10-11)** | Same: the matching upper bound does *not* need a two-sided squaring law and is proved; the unproven `r_{k+1} ≥ c·r_k²` (measured ratios as low as `0.028`) is what the **lower** bound would need. |
| **OP-28** | [conjecture: a family with no limit](../../rh/theorems/tpp/tpp-rh40-k-remaining-conjecture-family-without-limit.md) | (`rh40/K_remaining.md`) | **PROVED (2026-10-11 attack, constructive)** | There exist `x ∈ (0,1)` and a greedy orbit with `limsup (1/K)Σ log c_k ≥ −0.76`, `liminf ≤ −1.21`: prescribe `α_k` alternating `1/2,1/4` in `3^j` blocks, build `q_k` backwards via `u_k = n_k u_{k+1}/(n_k+u_{k+1})`, `x = Σ 1/(q_k+2)`. Exact-rational witness + error budget `≤ 1.6·10⁻³` vs block gap `≥ 0.35`; `lib/tpp_no_limit_orbit.py` (self-test 5/5). |
| **OP-29** | [conjecture: a.e. convergence to `−1`](../../rh/theorems/tpp/tpp-rh40-k-remaining-conjecture-lebesgue-a-e-limit.md) | (`rh40/K_remaining.md`) | CONJECTURED | The same limit `−1` for Lebesgue-a.e. `x`; the reduction is written out but its key correlation lemma is stated, not proved. |
| **OP-30** | [K6h — a family with no limit](../../rh/theorems/tpp/tpp-rh40-rounds-truths-k6h-no-limit-family-conjectured.md) | (`rh40/rounds/truths.md`) | **PROVED (2026-10-11 attack, ≡ OP-28)** | Same construction; the block-end running means of `log α_k` form an exact 2-cycle (`{−0.8664, −1.2130}` for `3^j`), far beyond the `O(10⁻³)` correction. |
| **OP-31** | [K6j — a.e. convergence to `−1`](../../rh/theorems/tpp/tpp-rh40-rounds-truths-k6j-a-e-convergence-conjectured.md) | (`rh40/rounds/truths.md`) | CONJECTURED | Modulo the stated expanding-map correlation lemma, which is not written out. |
| **OP-32** | [E8 — the plateau onset has no formula](../../rh/theorems/tpp/tpp-rh40-rounds-truths-e8-plateau-onset-no-formula.md) | (`rh40/rounds/truths.md`) | OPEN | No formula found; four candidates were tested and **refuted** (on 375 random eligible supports, `a_{m−1}+1` fails in 284). |
| **OP-33** | [I8 — the finite-`r` means](../../rh/theorems/tpp/tpp-rh40-rounds-truths-i8-finite-r-means-open.md) | (`rh40/rounds/truths.md`) | **SETTLED (2026-10-11 attack)** | (a) **PROVED** (Lean `Rh42.step_bound`, axiom-clean): `r_0 ≤ 1/10`, `r_{k+1} ≤ r_k²`, `10^{−D} < r_{K−1}` ⟹ `2^{K−1} ≤ D`, so `D` digits reach only `K ≤ log₂ D + 1` steps — the `7–13 steps before underflow` is a theorem, not a bug. (b) Means of `log c_k` over `10⁴` prescribed steps are `−0.6931, −1.3863, −2.3026, …` for `α = 1/2,1/4,1/10`: **none is `−1`** (claim confirmed, re-attributed). |
| **OP-34** | [A7 — window-class decomposition](../../rh/theorems/tpp/tpp-rh40-round01-a7-window-class-decomposition-unsubstantiated.md) | (`rh40/rounds/round01.md`) | **SETTLED with corrections (2026-10-11 attack)** | **REFUTED as stated** — the class sum over-counts `p(L)` on **604/1399** `L` for `1/π` (classes not disjoint). Corrected criterion `factor(t)=factor(t') ⟺ x(t)=x(t') ∧ shape(t)=shape(t')` and exact shape-union formula `p(L) = [∃all-zero] + Σ_shapes |⋃_{C:shape} X(C)|` **PROVED** (6 378 064 exhaustive cases, 0 mismatches; `lib/tpp_window_collision.py`). |
| **OP-35** | [A8 — the deficit form](../../rh/theorems/tpp/tpp-rh40-round01-a8-deficit-form-unsubstantiated.md) | (`rh40/rounds/round01.md`) | **REFUTED / ill-posed (2026-10-11 attack)** | `S_{1,k}` is **undefined corpus-wide**. The natural reading `S_{1,k} = Σ_{i≤k} d_i` gives `D(L) = (L−12)_+`, switching on at `L = 13`, whereas the measured `2→1` slope drop is at `L = 14` (`p(13)=16, p(14)=18, p(15)=19`). No partial-sum convention repairs it; the natural `D` is unbounded while a cancelled-pair deficit must be bounded. |
| **OP-36** | [the window-class sum for `p(L)`](../../rh/theorems/tpp/tpp-rh40-round01-agenta-window-class-sum-conjecture.md) | (`rh40/rounds/round01.md`) | **REFUTED as stated (2026-10-11 attack)** | The `[DREAM]` sum `p(L) = 1 + #{}(L>span) + Σ_{i≤j}|T(i,j)|` over-counts on **all 1399** `L` for `1/π`; replaced by the corrected shape-union formula (see OP-34). |
| **OP-37** | [the `(i,x)` repair](../../rh/theorems/tpp/tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md) | (`rh40/rounds/round01_agentB.md`) | **SETTLED with corrections (2026-10-11 attack)** | Realisability **PROVED** (`max(0,a_i−(N−L)) ≤ x ≤ min(d_{i−1}−1,a_i,L−1)`); the source's all-zero criterion **REFUTED** by `((0,4),N=6,L=3)`, corrected `L ≤ max(a_0,max_j(d_j−1),N−1−a_m)` **PROVED**; the source's injectivity claim **REFUTED** by `((12,20),N=26,L=12)`, corrected `p(L) ≥ a_m+2 ⟹ injective` **PROVED with no `N`-hypothesis** and machine-checked (`Rh40.injOn_of_card_ge`, `rounds/rh40/lean`, 2/2 green). The plateau value `max p = a_m+2` stays unproved. |
| **OP-38** | [B13 — the naive-formula count](../../rh/theorems/tpp/tpp-rh40-round01-b13-naive-formula-count-unsubstantiated.md) | (`rh40/rounds/round01_agentB.md`) | OPEN (imprecise) | The count \"the naive `RS(L) − LS(L+1)` holds 0/18895 cases\" is not reproducible. The substance of B4 survives; the count does not. |

---
