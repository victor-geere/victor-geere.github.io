# `OP-01 / OP-04 / OP-16 / OP-17 / OP-18` — tractability reassessment (2026)

**Scope.** The five register rows that had been marked **out of reach** and were not
worked in the B.2-ranking pass: `OP-1` (un-averaged two-point Chowla), `OP-4`
(`k`-point Chowla and its Sarnak relation), `OP-16` (twin primes / Selberg parity),
`OP-17` (Sarnak's Möbius-disjointness), `OP-18` (positive sign-blind coupling to `Ω`).
`OP-3` is excluded as instructed (it was discharged into `OP-19` in the previous pass).

**Register:** [`07-open-problems.md`](07-open-problems.md) §B.3, §B.5 and the individual
Part A rows. **Survey date:** 2026-10-11.

**Method.** (i) A literature sweep with emphasis on 2020–2026, restricted to
peer-reviewed venues and arXiv preprints by established authors; self-published
"resolutions" are listed separately under *Claims to distrust* and are **not** treated
as progress. (ii) For `OP-18`, an internal definitional analysis plus a new exact
experiment, [`op18_coupling_equivalence.py`](op18_coupling_equivalence.py) / [`.log`](op18_coupling_equivalence.log).

**Bottom line.** **None of the five is now tractable.** `OP-1`, `OP-4`, `OP-16`, `OP-17`
remain **out of reach** with the reasons unchanged (updated with 2020–2026 evidence).
`OP-18` is **not well-posed as literally phrased**: once the sign-blind class is fixed,
its only well-posed content is the *existential dual of `OP-19`*, so it is neither
independent nor newly tractable; restricted to periodic sets and finite exponential sums
it is settled **negative** by theorems the programme already records.

---

## 0. The one structural fact behind all four arithmetic verdicts

Every general tool that currently breaks the parity barrier produces a **logarithmic**
average (or an average over shifts/scales), not a natural-density statement for a fixed
shift. Tao states the reason for the entropy-decrement method explicitly:

> *"It would also be nice to get rid of the pesky logarithmic averaging, but this seems
> to be an inherent requirement of the entropy decrement argument method."*
> — [Tao, blog, 16 May 2016](https://terrytao.wordpress.com/2016/05/16/equivalence-of-the-logarithmically-averaged-chowla-and-sarnak-conjectures/)

The sharpest dynamical form of the same gap is
[Frantzikinakis–Lemańczyk–de la Rue, arXiv:2304.03121](https://arxiv.org/abs/2304.03121)
(ETDS **45** (2025) 2765–2844): the structural property ("strong stationarity") that
makes the *logarithmically averaged* theory work **fails for Cesàro averages**. So the
gap is structural, not quantitative.

---

## 1. `OP-1` — un-averaged two-point Chowla `Σ_{n≤x} λ(n)λ(n+2) = o(x)`

**Verdict: still OUT OF REACH.** Mark unchanged: ⛔ in [`07-open-problems.md`](07-open-problems.md) §B.2 rank 14.

| result | URL | what it gives (and does not) |
|---|---|---|
| Tao, log-averaged two-point | [arXiv:1509.05422](https://arxiv.org/abs/1509.05422) | `Σ_{n≤x} λ(n)λ(n+2)/n = o(log x)`; the abstract itself calls this *"breaking the 'parity barrier' for this problem"* — but it is a **logarithmic** mean. |
| Matomäki–Radziwiłł–Tao, averaged Chowla | [arXiv:1503.05121](https://arxiv.org/abs/1503.05121) | average over shifts `h ≤ H`: the conjecture *"remains unproven for any `h₁,…,h_k` with `k ≥ 2`"*; gives almost-all shifts, not the fixed `h = 2`. |
| Helfgott–Radziwiłł, expansion | [arXiv:2103.06853](https://arxiv.org/abs/2103.06853) | a new route to parity; strongest un-averaged-type statement is `Σ_{N<n≤2N} λ(n)λ(n+1) = o(N)` **at almost all scales** `N`, not at a fixed scale. |
| Pilatte, two-point logarithmic bound | [arXiv:2310.19357](https://arxiv.org/abs/2310.19357) | best **log-averaged** bound `≪ (log x)^{1−c}`; *"appears to be best possible with current methods."* |
| Klurman–Mangerel–Teräväinen, Elliott | [arXiv:2304.05344](https://arxiv.org/abs/2304.05344) | fixed-shift correlation `→ 0` along a set of `x` of **full upper logarithmic density** — explicitly not natural density. |
| Jaskari–Sachpazis, Landau–Siegel | [arXiv:2409.10663](https://arxiv.org/abs/2409.10663) | non-trivial un-averaged `k`-point bounds **conditional on a Landau–Siegel zero**. |
| Guo (2026, **unrefereed**) | [arXiv:2608.23500](https://arxiv.org/abs/2608.23500) | fixed power-logarithmic saving for **log-weighted** two-point correlations across all shift scales, outside an exceptional shift set. |
| Hughes (2026, **unrefereed**) | [arXiv:2609.28526](https://arxiv.org/abs/2609.28526) | effective **log-average** two-point bounds; the abstract states outright: *"These results concern logarithmic averages, not natural-density two-point Chowla correlations."* |

**Why it is not "close".** Every 2020–2026 advance is one of: (a) logarithmic averaging;
(b) an average over shifts; (c) "almost all scales"; (d) conditional on Siegel zeros. No
method removes the averaging for a fixed shift, and the programme's own finite-prefix
theorem (Lean-certified, `Rh46`) shows no computation can decide it. The one genuinely
new 2026 input is a *quantitative* log-average saving, which does not touch the
natural-density statement. **No action that could close OP-1 within this programme was
identified.**

---

## 2. `OP-4` — un-averaged `k`-point Chowla and its Sarnak relation

**Verdict: still OUT OF REACH, with a precise (unchanged) logical picture.** Mark unchanged: ⛔.

* **Theorem (one direction).** Un-averaged Chowla for all `k` **implies** Sarnak's
  Möbius-disjointness conjecture — Sarnak's argument, expounded in
  [Tao, blog, 2012](https://terrytao.wordpress.com/2012/10/14/the-chowla-conjecture-and-the-sarnak-conjecture/).
* **Theorem (the only equivalence).** [Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628)
  (Thm 1.8) proves the **logarithmically averaged** Chowla, Sarnak and local-Gowers-uniformity
  statements equivalent. The full text's remark confirms the entropy-decrement step is
  *the only one* requiring the `1/n` weight, so the equivalence does **not** upgrade to
  the Cesàro/averaged-free statements. Un-averaged equivalence is **open**.
* **Even the log-averaged case is incomplete.** Log-averaged Chowla is known for `k = 2`
  ([Tao, arXiv:1509.05422](https://arxiv.org/abs/1509.05422)) and all **odd** `k`
  ([Tao–Teräväinen, arXiv:1710.02112](https://arxiv.org/abs/1710.02112)); the log-averaged
  **even** `k ≥ 4` case is open. So OP-4 is not blocked only by the log-vs-Cesàro gap.
* **2023–2026 context (all averaged or conditional).**
  [MRT–Teräväinen–Ziegler, arXiv:2007.15644](https://arxiv.org/abs/2007.15644)
  (*Ann. of Math.* **197** (2023)) proves higher uniformity of `λ` in short intervals
  **on average over x**; [Pilatte, arXiv:2604.26564](https://arxiv.org/abs/2604.26564)
  and [Menon, arXiv:2607.15574](https://arxiv.org/abs/2607.15574) (both 2026, unrefereed)
  improve averaged/Fourier-uniformity input, not the fixed-shift statement.

**Unchanged recommendation:** maintain the record; do not attack directly.

---

## 3. `OP-16` — twin primes and Selberg's parity barrier

**Verdict: still OUT OF REACH; the parity barrier has not moved for twins.** Mark unchanged: ⛔.

* **Bounded gaps are not twins.** [Polymath8, arXiv:1407.4897](https://arxiv.org/abs/1407.4897)
  proves unconditionally `H₁ = liminf(p_{n+1}−p_n) ≤ 246`, and its abstract states it
  *"modif[ies] the 'parity problem' argument of Selberg to show that this result is the
  best possible that one can obtain from purely sieve-theoretic considerations."* The
  retrospective [arXiv:1409.8361](https://arxiv.org/abs/1409.8361) notes *"the twin prime
  conjecture is equivalent to the assertion that H₁ is equal to two."* A 2026 **unrefereed**
  preprint ([Stadlmann, arXiv:2608.31126](https://arxiv.org/abs/2608.31126)) lowers the
  constant to `H₁ ≤ 240` and explicitly calls it *"a modest improvement"*; it does not
  touch parity or twins. [Maynard, arXiv:1311.4600](https://arxiv.org/abs/1311.4600)
  gives `liminf(p_{n+m}−p_n) < ∞` for every `m`, never a fixed gap `2`.
* **Where parity has been broken, and why it misses twins.**
  [Friedlander–Iwaniec, arXiv:math/9811186](https://arxiv.org/abs/math/9811186) breaks
  parity for a thin sequence only after adding an extra Type-II/bilinear axiom, verified
  for `a² + b⁴` ([arXiv:math/9811185](https://arxiv.org/abs/math/9811185)) — **not** for
  `n² + 1`, and there is no analogue for the pair `(n, n+2)`. Tao's entropy-decrement
  method breaks parity for the **log-averaged** Chowla correlation
  ([arXiv:1509.05422](https://arxiv.org/abs/1509.05422)); Tao–Teräväinen obtain
  Hardy–Littlewood/twin-prime asymptotics only **conditionally on a Siegel zero**
  ([arXiv:2109.06291](https://arxiv.org/abs/2109.06291)).
* **Real but unrelated progress:** Guth–Maynard, *New large value estimates for
  Dirichlet polynomials*, *Annals* **203** (2026) — primes in short intervals of length
  `x^{17/30+o(1)}`; no twin or parity consequence.

**Nothing in the 2020–2026 record changes OP-16's status.**

---

## 4. `OP-17` — Sarnak's Möbius-disjointness conjecture

**Verdict: still OUT OF REACH in full generality; the frontier moved only on the
logarithmic/averaged side and on special classes.** Mark unchanged: ⛔.

* **The equivalence is logarithmic.** [Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628)
  Thm 1.8 (scope verified in the full text: every one of Conjectures 1.3–1.7 carries the
  weight `1/n` and range `X/ω ≤ n ≤ X`).
* **Logarithmic Sarnak is now known for broad classes:**
  [Frantzikinakis–Host, arXiv:1708.00677](https://arxiv.org/abs/1708.00677) (*Ann. of
  Math.* **187** (2018)) — all uniquely ergodic zero-entropy systems;
  [Huang–Tan–Xu, arXiv:2511.04419](https://arxiv.org/abs/2511.04419) (2025) — almost
  countable spectrum (state of the art).
* **Un-averaged Sarnak is known for specific structural classes:** nilsystems
  ([Green–Tao, arXiv:0807.1736](https://arxiv.org/abs/0807.1736)); horocycle flows
  ([Bourgain–Sarnak–Ziegler, arXiv:1110.0992](https://arxiv.org/abs/1110.0992));
  homogeneous/unipotent ([Peckner, arXiv:1506.07778](https://arxiv.org/abs/1506.07778));
  rigidity/rank-one and a.e. IET
  ([Kanigowski–Lemańczyk–Radziwiłł, arXiv:1905.13256](https://arxiv.org/abs/1905.13256));
  a 2026 short-interval Furstenberg-flow case
  ([He–Liu–Ma, arXiv:2604.16840](https://arxiv.org/abs/2604.16840)).
* **The obstruction, sharpened.** [Frantzikinakis–Lemańczyk–de la Rue,
  arXiv:2304.03121](https://arxiv.org/abs/2304.03121) (ETDS 2025): strong stationarity
  *"fails when the systems are obtained using Cesàro averages."*
  [Pavlov, arXiv:2308.08013](https://arxiv.org/abs/2308.08013) (ETDS **45** (2025))
  shows minimal zero-entropy sequences can be **arbitrary on zero-Banach-density sets**
  (hence the *polynomial* Sarnak conjecture is false), so no purely entropy-based
  argument can suffice for the linear conjecture.
  [Algom–Wang, arXiv:2202.09491](https://arxiv.org/abs/2202.09491) show the `o(1)` can
  decay arbitrarily slowly, so no uniform rate exists.
* **Unverified, flagged:** [el Abdalaoui–Nerurkar, arXiv:2006.07646](https://arxiv.org/abs/2006.07646)
  (v2, 2026) claims Sarnak for systems whose every invariant measure has singular
  spectrum; it remains a long-lived preprint with no independent confirmation found.
  **Not treated as settled.**

**Unchanged recommendation:** the programme's `log n`-only objects cannot reach OP-17.

---

## 5. `OP-18` — the positive sign-blind-coupling question

**Verdict: OPEN as a heuristic, but NOT WELL-POSED as literally phrased; its only
well-posed restriction is the existential dual of `OP-19`.** Recommended mark: ⚠️ (a
statement-repair, like `OP-3`), not ⛔.

### 5.1 The coupling predicate collapses to the `λ`-correlation

**Lemma (elementary, verified).** For `A ⊆ ℕ` of positive natural density, with
`P_A(x) = #{n ≤ x : n ∈ A, λ(n) = +1}` and `N_A(x) = #{n ≤ x : n ∈ A, λ(n) = −1}`,
the following are equivalent:

1. `Σ_{n≤x} 1_A(n)λ(n) ≠ o(x)`;
2. the two parity classes do **not** have equal density inside `A`;
3. `1_A` is not asymptotically independent of `λ`.

*Proof.* `Σ_{n≤x}1_A λ = P_A − N_A`, and `P_A − N_A = o(x)` iff
`(P_A − N_A)/(P_A + N_A) = o(1)` (since `A` has positive density). ∎

So "positive-density coupling to the parity of `Ω`" **is** the non-vanishing of the
`λ`-correlation; there is no second yardstick. "Multiplicative coupling" is also loose:
the correlation is between a sign-blind rule and the multiplicative `λ` — no
multiplicativity is asserted of the coupling itself.

**Consequence.** For a fixed sign-blind class `C`, `OP-18|_C` is
`∃A ∈ C : Σ1_Aλ ≠ o(x)` = `¬(∀A ∈ C : Σ1_Aλ = o(x))`. For `C` = log-arc rules this is
**exactly `¬P1` of `OP-19`**. `OP-18` is therefore the *existential dual* of `OP-19` and
adds no independent content once `C` is fixed. A "yes" can be witnessed only by (α) an
arithmetic alphabet that imports `Ω` — the audit's `C3a`, `α_p = (−1)^{Ω(p+2)}/(p+2)`,
`z = +10.1` (`rh47/truths.md` §3; `checks/06-numerical-checks.md` C3a) — or (β) by
refuting the barrier itself. That is exactly the circularity already recorded.

### 5.2 Restricted classes are settled **negative**

* **Periodic sign-blind alphabets** (fixed modulus `q`, any characters): `Σ w λ = o(Σ w)`
  by the Dirichlet-character expansion and `L(1,χ) ≠ 0` — dictionary Thm 2.2. **Settled
  negative.**
* **Finite exponential sums** `w(n) = Σ_{|k|≤K} c_k n^{it_k}`: `Σ_{n≤x} w(n)λ(n) = o(x)`
  (`research/TODO.md` §A.1). **Settled negative.**
* **Log-arc rules:** open, but exactly `¬P1` of `OP-19`, hence falsifiable by one
  arc/window. The B.2 pass already ran this to `10⁹`: `|C_I(x)|/x ≈ 2.2–2.7·10⁻⁵`,
  fitted `α ≈ 0.50–0.55`, **consistent with `o(x)`** — no refutation
  (`op19_log_indicator.py`).

The gap to `P1` is precisely the passage from an absolutely convergent finite Fourier
sum to a discontinuous indicator (coefficients `≍ 1/k`, `Σ 1/k` divergent).

### 5.3 The new exact experiment

[`op18_coupling_equivalence.py`](op18_coupling_equivalence.py) / [`.log`](op18_coupling_equivalence.log)
sieves `λ` to `10⁸` in exact integer arithmetic (21.4 s, 6/6 checks PASS) and checks the
collapse concretely:

* `S1` periodic `A = {n ≡ r (mod q)}`, `q ∈ {3,4,5,7}`: `|S_A|/x ≤ 9.1·10⁻⁵` and the
  inside-`A` imbalance is `O(x^{−1/2})` (max `|D_A|√N < 8`) — no coupling; the restricted
  negative theorem, measured.
* `S2` finite exponential-sum weights `cos(t log n)`, `t ∈ {1, 2, 7.3}`:
  `|Σ w λ|/x ≤ 2.7·10⁻⁵`.
* `S3` arithmetic `A = {n : λ(n+2) = +1}`: `S_A = (Σλ + C)/2` **exactly**, where
  `C = Σ_{n≤N} λ(n)λ(n+2)` is the open OP-1 quantity; here
  `Σλ = −3884`, `C = +4632` (matching the register's recorded `S(10⁸) = 4632`),
  `S_A = +374 = (Σλ + C)/2`. Equivalently `C = 2S_A − Σλ`. So deciding whether this `A`
  "couples" **is** deciding OP-1 — the circularity, made algebraic.
* `S4` log-arc instance `A = {n : cos(log n) ≥ 0}`: `C_I(10⁸) = −449`,
  `|C_I|/x = 4.5·10⁻⁶`, consistent with `o(x)`.

### 5.4 Finite experiments cannot settle it

No finite computation decides an `o(x)` statement (the finite-prefix indeterminacy
theorem, Lean-certified `Rh46`, and register §B.4). The only decidable direction is
**falsification** by a single arc/window with a bounded-below `|C_I|/x`; the `10⁹` run
found none.

---

## 6. Claims to distrust (recorded so they are not re-imported)

The sweep found a large stock of **self-published or withdrawn "resolutions"**, none of
which is treated as progress. Representative examples:

* Zenodo/IACR PDFs titled "Resolution of the Twin Prime Conjecture …", "A fixed-profile
  proof for prime gaps of at most 182", multiple "twin primes resolved" items; and
  ResearchGate/Zenodo claims of an unconditional Chowla conjecture ("2-adic profile
  decomposition", "Amparo LC Conjecture").
* Withdrawn/errored arXiv items on twin primes: [arXiv:2511.12944](https://arxiv.org/abs/2511.12944)
  (author: *"An error in the final integral calculation …"*),
  [arXiv:2512.00071](https://arxiv.org/abs/2512.00071) (withdrawn),
  [arXiv:2604.09753](https://arxiv.org/abs/2604.09753) (author: *"this crosses Selberg's
  parity barrier; switching transfers no Type II information"*).
* A retracted *Studia Logica* article whose listing title begins "RETRACTED ARTICLE: The
  Twin Primes Conjecture is True …".
* Long-lived but unconfirmed preprints: [arXiv:2006.07646](https://arxiv.org/abs/2006.07646)
  (Sarnak, singular spectrum); [arXiv:1903.05410](https://arxiv.org/abs/1903.05410)
  ("Proof of the Twin Prime Conjecture", `math.GM`, never published).

**Rule kept:** a 2026 preprint by an established author is recorded as *unrefereed
context*; a self-published claim with no independent verification is not cited as a
result.

---

## 7. Disposition table

| id | mark | verdict | key evidence |
|---|---|---|---|
| **OP-1** | ⛔ out of reach | unchanged | log-averaged theorem only (Tao 2015; Pilatte 2023; Guo/Hughes 2026 unrefereed); no fixed-shift natural-density `o(x)` |
| **OP-4** | ⛔ out of reach | unchanged | un-averaged Chowla ⟹ Sarnak (theorem); equivalence only log-averaged (Tao 2016); log even `k ≥ 4` open |
| **OP-16** | ⛔ out of reach | unchanged | `H₁ ≤ 246` (Polymath8) / `240` (2026 unrefereed) ≠ twins; parity barrier unbroken; Friedlander–Iwaniec parity-breaking misses `(n, n+2)` |
| **OP-17** | ⛔ out of reach | unchanged | log-Sarnak for broad classes; un-averaged only for special classes; Cesàro gap (FLR 2025) |
| **OP-18** | ⚠️ not well-posed as phrased | **reclassified** | coupling = non-vanishing of `Σ1_Aλ`; `OP-18\|_{log-arcs} = ¬P1(OP-19)`; periodic + finite exponential sums settled **negative**; `op18_coupling_equivalence.py` |

**Tally effect.** `OP-1`, `OP-4`, `OP-16`, `OP-17` stay in the OPEN column as
out-of-reach; `OP-18` gains the ⚠️ statement-repair annotation while remaining OPEN as a
heuristic. No new theorem about `λ`, the twin primes, or Sarnak is claimed.
