# Tractability survey — OP-20 … OP-38 (and the still-open OP-1 … OP-19)

**Date:** 2026-10-11 · **Scope:** light-touch survey, not a proof attempt.
**Method:** read `research/open.md` §4–§5, `research/TODO.md` (ledger O12–O15, the
B.2 dispositions, the 2026 out-of-reach reassessment), `research-journal.md` §3.4
(J4), then the **linked theorem file for each of OP-20 … OP-38** under
`theorems/tpp/`, plus the rh40 ground-truth sources
(`rounds/rh40/{K_remaining.md,rounds/truths.md,rounds/round01*.md}`) and the
ground-truth code `rounds/rh40/code/digitword.py`. Quantitative claims that were
cheap to check were re-run with
`/opt/homebrew/Caskroom/miniforge/base/bin/python3`; the reusable checks are saved
as `lib/tpp_greedy_orbit.py` and `lib/tpp_window_class.py` (both self-test green).

**Status vocabulary:** OPEN · CONJECTURED · PROVED/REFUTED · STALE (a status that
the J4 reconciliation or this survey has superseded but that has not been
back-propagated to every file).

**Scoring:** value to the programme **High=3 / Medium=2 / Low=1**; tractability
**High=3 / Medium=2 / Low=1 / Out of reach=0**. The rank key is the product.

---

## 0. Headline findings

1. **Two §5 statuses in `research/open.md` are STALE.** The `OP-26` and `OP-27`
   rows of `open.md` §5.3 still read `OPEN`; the linked theorem files **and** the
   matching `theorems/INDEX.md` rows were re-statused to `PROVED` by J4
   (2026-10-11). `open.md` was not part of J4's edit set, so the register §5 table
   and the harvest now disagree. (§4 of `open.md` is correct — it lists `OP-13` as
   SETTLED.)
2. **One harvest row is inconsistent with its own theorem file.** `theorems/INDEX.md`
   lists the OP-37 `(i,x)` repair as `PROVED (paper argument; plateau injectivity
   left [OPEN])`, while
   `theorems/tpp/tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md`
   was **demoted to OPEN** on 2025-10-06 (audit repair 1/5). The INDEX row is
   STALE in the optimistic direction.
3. **OP-20's citation is now verified.** `arXiv:2608.23500`
   (J. Guo, *Logarithmic Chowla Correlations Across All Shift Scales*) resolves,
   the title/author match, and the version history and abstract match the harvest
   file (v1 24 Aug 2026, v4 1 Sep 2026, "84 pages"), so the *bibliographic*
   qualifier "UNVERIFIED citation" is stale — the **mathematical content** remains
   unrefereed and log-averaged, so it still gives nothing toward OP-1.
4. **OP-37 is half-correct and half-false.** Its realisability conditions are
   **exactly right** (0 mismatches in 95 826 exhaustive cases); its **all-zero
   criterion is false** (support `(0,4)`, `N=6`, `L=3`); its **injectivity claim
   is false as stated** (support `(12,20)`, `N=26`, `L=12`: `(0,7)` and `(1,7)`
   both give factor `(7,)`), but **true on the plateau under `N ≥ 2a_m+3`**
   (15 087 exhaustive plateau cases, 0 violations).
5. **OP-36/OP-34's class-sum formula is refuted, and not by 1–2 %.** For the
   `1/π` word the claimed sum over-counts `p(L)` on **604 of 1399** values of `L`;
   the missing step is class-disjointness, which fails exactly where two windows
   with different `(i,j)` produce the same offset tuple.
6. **OP-28/OP-30 (the "family with no limit") is constructible.** The digit
   sequence is essentially freely prescribable: taking
   `q_{k+1} ≈ q_k²/α_k` with any `α_k ∈ (0,1]` gives
   `s_k = α_k + O(1/q_k)` from the exact backward relation, and the error is
   doubly-exponentially small. A geometrically-blocked `α` pattern (`α=1/2` for
   `10^0` steps, `1/4` for `10^1`, …) therefore produces an orbit average with no
   limit. This is a **proof sketch, verified numerically**, for a claim the
   harvest marks "not reproduced by the mediator".
7. **OP-33's "7–13 steps before underflow" is not a precision bug but a
   fundamental limit.** The digit `q_k` grows double-exponentially, so a forward
   orbit at `D` decimal digits supports only `≈ log₂ D` steps: measured
   `50→6, 150→8, 300→9, 600→10, 1200→11, 3000→12`. Raising precision buys
   logarithmically many steps. The tractable route is the prescribed-digit
   backward recursion, not brute force.
8. **OP-35 is not testable as stated.** `S_{1,k}` is never defined anywhere in the
   corpus (grep finds only the two prose mentions). Under the natural reading
   `S_{1,j-2} = Σ_{i≤j-2} d_i`, the deficit form gives `D(L) = (L−12)₊` on the
   `1/π` word: it turns on at `L=13`, but the measured `2→1` drop is at `L=14`,
   so the natural reading is off by one and is *not* exact.

---

## 1. `OP-20 … OP-38` — one row per item

`STALE?` records whether the status carried in `open.md` §5 / `theorems/INDEX.md`
contradicts the linked theorem file.

### 1.1 Chowla, twin primes, parity (OP-20 … OP-25)

| id | one-line statement | status (linked file) | STALE? | value | tractability | concrete next artefact |
|---|---|---|---|---|---|---|
| **OP-20** | Guo arXiv:2608.23500 gives a fixed power-log bound for the **log-weighted** two-point Liouville correlation across all shift scales, outside an exceptional set of shifts | OPEN — citation **unverified** (preprint) | **YES**: the arXiv record now resolves and matches (title/author/v1 24 Aug 2026/v4 1 Sep 2026/abstract/84 pp.) | Low — log-averaged with exceptional shifts; does **not** give `Σ_{n≤x}λ(n)λ(n+2)=o(x)`, so OP-1 is untouched | High (literature check, already done here) | Update the file's citation qualifier to "bibliographically verified, content unrefereed"; re-check the v4 title drift (a v2 title variant "…Uniformly over Fixed Polylogarithmic Shift Ranges" appears in search indexes) |
| **OP-21** | "Chen's switch" (asymmetric roles of `n`, `n+2`) is what supplies the missing parity input | CONJECTURED (interpretation of THEOREM 2.6) | no | Low — interpretive, not a mathematical proposition | Out of reach as phrased (no truth value) | None as mathematics; a calibration note only |
| **OP-22** | The `1/n` weight gives bounds only along scales of full logarithmic density, so no Tauberian device recovers a prescribed-scale Cesàro mean | CONJECTURED (structural; rigorous content is THEOREM 4.4) | no | Low–Medium (methodological framing of the whole barrier) | Medium (`python`): the *toy* non-implication is easy; the λ-specific claim is OP-1 | A sympy/python pair: a sequence with vanishing `1/n`-mean and non-vanishing Cesàro mean, plus a note that `n ↦ λ(n)λ(n+2)` is neither non-negative, monotone, nor multiplicative |
| **OP-23** | Three inputs can cross a parity barrier (Type-II/bilinear, BFI large moduli, automorphic/spectral); none is available for `(n,n+2)` | CONJECTURED (existence of routes is theorem-level; necessity is not) | no | Low — survey framing | Out of reach (necessity claim) | None; keep as calibration |
| **OP-24** | If `(λ(n))` were independent random signs every correlation would be `O(x^{1/2+ε})` | CONJECTURED (heuristic model) | no | Low (picture, ignores complete multiplicativity) | High (`python`) but no proof value | A `python`/sympy random-sign simulation reproducing `α ≈ 0.52` and `|S|/√x = O(1)` in the model, to document that the finite fit is a *model* prediction and not evidence |
| **OP-25** | `λ` has mean 0 mod every `q` and is never `χ(n)n^{it}`, so `Σw(n)λ(n)=o(Σw(n))` is expected for all bounded-depth `w` | CONJECTURED (structurally compelling) | no | Low | Out of reach (the un-truncated statement is OP-17-adjacent) | None; the nearest theorems (T7/T8) are already harvested |

### 1.2 The `rh40` residual-orbit items (OP-26 … OP-33)

| id | one-line statement | status (linked file) | STALE? | value | tractability | concrete next artefact |
|---|---|---|---|---|---|---|
| **OP-26** | Theorem G: `A(N) ≤ log₂ log N + O(1)` "would follow from a two-sided squaring law `r_{k+1} ≥ c r_k²`" and is therefore OPEN | **PROVED (paper; components Lean)** — corrected 2026-10-11; the one-sided `r_{k+1} ≤ r_k²` + take rule give `n_k ≥ x^{−2^k} − 2`, hence `A(N)=O_x(log log N)`; the no-two-sided-law obstruction kills the **lower** bound | **YES in `open.md` §5.3** (still says OPEN, and repeats the wrong direction) | Medium — closes register OP-13 | High (done; only bookkeeping remains) | Patch `open.md` §5.3 rows OP-26/OP-27 to PROVED with the direction note (this survey is not permitted to edit existing files) |
| **OP-27** | A4b: the matching upper bound `A(N) ≤ log₂ log N + O(1)` | **PROVED** — same correction, same reasoning | **YES in `open.md` §5.3** | Medium (duplicate of OP-26) | High (done) | Same patch as OP-26; consider marking OP-27 as a duplicate of OP-26 |
| **OP-28** | A family of `x` for which `(1/K)Σ_{k<K} log c_k` has no limit at all (prescribed digit blocks) | CONJECTURED — "not reproduced by the mediator" | no | Medium — determines that the `rh40` orbit average is genuinely non-convergent on a positive-complexity set, which is the sharp form of the K6 refutation | **High** — see §0(6): prescribe `α_k`, use the exact backward recursion; error `O(1/q_k)` is doubly-exponentially small | Rigorous write-up: `q_{k+1}=⌊q_k²/α_k⌋`, blocked `α ∈ {1/2,1/4}`, prove `s_k = α_k + O(1/q_k)`, `Σ log c_k = Σ log s_k + O(1)`, and the blocked Cesàro mean oscillates. `lib/tpp_greedy_orbit.py` already carries the machinery |
| **OP-29** | The same limit `−1` for Lebesgue-a.e. `x` | CONJECTURED (key correlation lemma stated, not proved) | no | Medium — the probabilistic completion of the K6 picture | Low–Medium — needs the expanding-map correlation lemma; the explicit no-limit family of OP-28 shows the statement is non-trivial (the exception set must be null) | Proof sketch of the correlation lemma for the skew product `s ↦ 1−{q²/s}`; a `python` Monte-Carlo on truncated digit sequences checking `E[log s_k|q_k] = −1 + 1/(2q_k)` matches the `L¹` theorem |
| **OP-30** | K6h: a family with no limit at all (prescribed blocks) | CONJECTURED — "not reproduced by the mediator" | no — but **duplicate of OP-28** | Medium | **High** (same attack as OP-28) | Merge with OP-28; one construction closes both |
| **OP-31** | K6j: a.e. convergence to `−1` | CONJECTURED — modulo the unwritten expanding-map correlation lemma | no — but **duplicate of OP-29** | Medium | Low–Medium | Merge with OP-29 |
| **OP-32** | E8: the plateau onset `min{L : p(L)=a_m+2}` has no formula found; four candidates (`a_{m−1}+1`, `N−2a_m−2`, `a_m+2−#distinct gaps`, `N−a_m`) are refuted | OPEN | no | Low–Medium — round-local, but it is the last gap in the `p(L)` description | Low–Medium — the onset is a function of `(gaps,N,a_0)` (Theorem E) with no evident closed form; exhaustive search is cheap but the formula space is open | `python` exhaustive onset table for all supports `m+1 ≤ 4`, `N ≤ 31`, then a systematic search over ring/register expressions of `(a_0, gaps, N)`; report failure counts as a *falsification log* rather than a formula |
| **OP-33** | I8: the finite-`r` means are not `−1`, but measured on only 7–13 steps before underflow, so no convergence claim follows | OPEN | no | Low–Medium — but this is the precision floor under OP-29/OP-31 | **High** — this survey shows the floor is fundamental (`≈ log₂ D` steps at `D` digits) and that the backward/prescribed-digit route removes it | `python`: (a) prove/\[state\] the step bound `q_k ≥ 2^{2^{k−c}}` ⟹ `steps ≤ log₂ D + O(1)`; (b) recompute the means for ≥ `10^4` prescribed steps via `lib/tpp_greedy_orbit.py` |

### 1.3 The `rh40` round-01 `p(L)` items (OP-34 … OP-38)

| id | one-line statement | status (linked file) | STALE? | value | tractability | concrete next artefact |
|---|---|---|---|---|---|---|
| **OP-34** | A7: window-class decomposition `T(i,j)` with **union** cardinality | OPEN (UNSUBSTANTIATED; author's own `[DREAM]`) | no | Medium — an exact `p(L)` from the support alone is the `[LEAP]` the round wanted | **High** — the class decomposition is mechanical; the missing step (class-disjointness) is exactly testable | `python` criterion for when two windows with different `(i,j)` give the same offset tuple (local periodicity of the support); state `p(L)=1+[empty]+Σ_classes |distinct factors|` and validate exhaustively. `lib/tpp_window_class.py` implements `class_disjoint` / `class_sum_formula` |
| **OP-35** | A8: `D(L)=max_j (L−d_j−1−S_{1,j−2})₊` explains the `2→1` slope drop | OPEN (UNSUBSTANTIATED; source calls it "round 2's sharpest target") | no | Low–Medium — would close the `2→1` mechanism | **Medium**, but **not testable as stated**: `S_{1,k}` is undefined corpus-wide | Disambiguate `S_{1,k}` against the slope runs (`1/π`: `1,2,1,0,−1`); the natural reading `Σ_{i≤j−2} d_i` gives `D(L)=(L−12)₊`, which turns on at `L=13` while the drop is at `L=14` — repair the formula or refute it with this witness |
| **OP-36** | `[DREAM]`: `T(i,j)=max(0,min(a_i,a_{j+1}−L)−max(0,a_{i−1}+1,a_i−L+1)+1)`, `p(L)=1+#{}(L>span)+Σ_{i≤j}|T(i,j)|` | CONJECTURED (`[DREAM]`; author reports 1–2 % over-count) | no | Medium (same content as OP-34) | **High** — same attack as OP-34; this survey already shows the failure is 604/1399 on `1/π`, i.e. far larger than 1–2 % | Exact collision criterion + corrected formula; the `python` check is in `lib/tpp_window_class.py`. If the criterion is "no two windows have equal offset tuples", state it as a theorem about the support's local periods |
| **OP-37** | The `(i,x)` repair: realisable pairs are `0≤x≤min(d_{i−1}−1,a_i,L−1)`, `a_i−x≤N−L`; all-zero iff `L≤N−a_m−1`; on the plateau the tails are distinct, hence `p=a_m+2` | OPEN (demoted 2025-10-06; source's `[VERDICT]`: "the `a_m+2` form still lacks a proof") | **YES in `theorems/INDEX.md`** (row says PROVED) | Medium — it is the injectivity half of the `p=a_m+2` plateau theorem | **High** — this survey settles 2 of its 3 clauses | (i) Realisability: elementary proof (already exact in 95 826 cases). (ii) All-zero: **refute** with `(0,4),N=6,L=3` and state the correct max-run criterion. (iii) Injectivity: **refute** with `(12,20),N=26,L=12`; **prove** the corrected version on the plateau under `N≥2a_m+3` (0/15 087 violations). Artefacts: `lib/tpp_window_class.py`, then a Lean lemma `plateau_injective_of_large_N` |
| **OP-38** | B13: "the naive `RS(L)−LS(L+1)` holds 0/18895 cases" | OPEN (UNSUBSTANTIATED / imprecise; the count is not reproducible, the substance of B4 survives) | no | Low (bookkeeping) | **High** (`python`) — but the corpus never pins the `LS` definition or the 18 895-case corpus | Define `RS`, `LS` and the corpus explicitly, recompute the count, replace the unverifiable `0/18895` with a reproducible range split (pre-decay vs decay) |

---

## 2. Still-open items of `OP-1 … OP-19` (brief)

Settled items are omitted: OP-2, OP-5, OP-6, OP-7, OP-10, OP-11, OP-12, OP-13,
OP-14, OP-15 (see `open.md` §4 and the B.2 dispositions; no action).

| id | statement | status | stale? | value | tractability | next artefact |
|---|---|---|---|---|---|---|
| **OP-1** | `Σ_{n≤x} λ(n)λ(n+2) = o(x)` | OPEN — out of reach (2026 survey) | no — §4 and the two harvest files are correctly OPEN | High (the programme target) | Out of reach — every 2015–2026 advance is log-/shift-averaged | None; the finite-prefix-indeterminacy theorem already shows no computation decides it |
| **OP-3** | "no sign-blind `log n`-rule forces a multiplicative correlation" | IMPOSSIBLE-AS-INHERITED; replaced by OP-19 | no | Low as stated | Out of reach as stated (undefined terms; literal reading false) | None — work on OP-19 instead |
| **OP-4** | `k`-point Chowla, distinct shifts | OPEN for every `k ≥ 2` | no | High | Out of reach — even log-averaged **even `k ≥ 4`** is open | None |
| **OP-8** | the term-level two-and-two split at a balance point | REFUTED at every certified root (`N=3…76`); OPEN in general | no — the `N=60 → 76` extension is recorded in `research-journal.md` §3.2, not back-edited into the harvest file | Medium | Low — no method; only certified finite ranges | Extend the certified range (cheap, `op08_subset_defect.py`) or state the obstruction as a theorem |
| **OP-9** | exact complex vanishing `S_N(t)=0`, `N ≥ 4` | OPEN; zero-free certified on `[0,10^4]` for `N=4..10` (`N=2` yes, `N=3` no) | no | Medium | Low for the theorem; High for numerics | Extend the zero-free interval (`op09_complex_zero.py`) — pure compute, no new idea |
| **OP-16** | twin primes / the parity barrier | OPEN — out of reach | no | High | Out of reach — `H₁≤246`/`240` say nothing about gap 2 | None |
| **OP-17** | Sarnak's Möbius-disjointness conjecture | OPEN — out of reach in general | no | High | Out of reach — the Cesàro gap blocks the general case | None |
| **OP-18** | positive existence of a sign-blind positive-density coupling to `Ω` | OPEN (heuristic) — **not well-posed as phrased** | no | Medium | Low — collapses to the non-vanishing of `Σ1_Aλ`, i.e. the existential dual of OP-19 | Re-phrase as an existence question over the countable log-arc class of OP-19; the periodic/finite-exponential-sum classes are settled negative |
| **OP-19** | the log-indicator barrier: is `C_I(x)=Σ_{n≤x}1_{A_I}(n)λ(n)=o(x)` for every log-arc rule `I`? (P1/P2) | OPEN — well-posed; `10^{10}` data consistent with `o(x)` (`α ≈ 0.50–0.53`) | no — §4 and `TODO.md` §A.1 agree | High (the programme's well-posed replacement target) | Low — no known method; finite prefixes cannot decide `o(x)` | Extend the sieve (pure compute, `op19_log_indicator.py`) or an analytic attempt on the single arc `I=[0,π)` |

---

## 3. Stale statuses found (J4 reconciliation gaps)

| # | where | says | correct status | why |
|---|---|---|---|---|
| 1 | `research/open.md` §5.3, **OP-26** row | `OPEN`; "needs `r_{k+1} ≥ c r_k²`" | `PROVED (paper; components Lean)`; the one-sided law gives the **upper** bound, the two-sided obstruction kills the **lower** bound | J4 re-statused the theorem file and the INDEX row only |
| 2 | `research/open.md` §5.3, **OP-27** row | `OPEN` | `PROVED` (same) | same |
| 3 | `theorems/INDEX.md`, **OP-37** row | `PROVED (paper argument; plateau injectivity left [OPEN])` | `OPEN` | the theorem file was demoted on 2025-10-06 (audit repair 1/5) and the INDEX copy was not updated |
| 4 | `theorems/tpp/tpp-dict-03-guo-preprint-unverified.md` and its INDEX row, **OP-20** | citation `UNVERIFIED` | citation **verified** (arXiv:2608.23500 resolves; title/author/versions/abstract match); the *content* remains unrefereed | verified this survey by direct fetch |
| 5 | `research/open.md` §5.3, **OP-28/OP-30** and **OP-29/OP-31** | listed as four separate items | two duplicate pairs | OP-30 repeats OP-28 (`K6h` = the `K_remaining.md` §4.5 conjecture); OP-31 repeats OP-29 (`K6j` = the a.e. conjecture) |
| 6 | `research/open.md` §5.3, **OP-34/OP-36** | listed as two separate items | one item, two harvest sites (A7 in `round01.md`, `[DREAM]` in `round01_agentA.md`) | the formula is the same |

Items **not** stale: OP-21…OP-25 and OP-32/OP-33/OP-35/OP-38 are consistent with
their files; OP-9's and OP-14's harvest entries were audited by J4 and describe the
proved smoothing law / the `N=2,3` vanishings, which remain correct.

---

## 4. Ranking by value × tractability

| rank | id | value | tractability | product | note |
|---|---|---|---|---|---|
| 1 | **OP-28 = OP-30** | 2 | 3 | **6** | constructive proof available |
| 1 | **OP-33** | 2 | 3 | **6** | negative clarification + backward route |
| 1 | **OP-34 + OP-36** | 2 | 3 | **6** | one merged attack |
| 1 | **OP-37** | 2 | 3 | **6** | 2 clauses already settled here |
| 1 | **OP-26** | 2 | 3 | **6** | settled; bookkeeping only |
| 1 | **OP-27** | 2 | 3 | **6** | duplicate of OP-26 |
| 7 | OP-35 | 2 | 2 | 4 | needs `S_{1,k}` disambiguation first |
| 8 | OP-20 | 1 | 3 | 3 | citation verified here |
| 8 | OP-24 | 1 | 3 | 3 | simulation only |
| 8 | OP-38 | 1 | 3 | 3 | bookkeeping |
| 11 | OP-22 | 1 | 2 | 2 | toy non-implication |
| 11 | OP-29 | 2 | 1 | 2 | needs the correlation lemma |
| 11 | OP-31 | 2 | 1 | 2 | duplicate of OP-29 |
| 14 | OP-32 | 1 | 1 | 1 | no formula found; unclear search space |
| 15 | OP-21, OP-23, OP-25 | 1 | 0 | 0 | interpretations / state-of-knowledge claims |

For the still-open register items (all High-value targets are out of reach):
OP-19 (High × Low), OP-9 (Medium × Low + High numerics), OP-8 (Medium × Low +
High numerics), OP-18 (Medium × Low), OP-1/4/16/17 (High × Out of reach).

---

## 5. Top-5 shortlist — genuinely attackable in one focused round

### 1. OP-37 — the `(i,x)` repair, corrected
* **Attack.** (a) Prove the realisability conditions by the translation
  `t = a_i − x` (already exact in 95 826 cases, 0 mismatches). (b) **Refute** the
  all-zero criterion with `(0,4)`, `N=6`, `L=3`, and replace it by
  `L ≤ max(a_0, max_j(d_j−1), N−1−a_m)`. (c) **Refute** the injectivity claim
  with `(12,20)`, `N=26`, `L=12` and prove the corrected version on the plateau
  under `N ≥ 2a_m+3`.
* **Tooling.** `lib/tpp_window_class.py` (`realised_pairs`, `claimed_pairs`,
  `all_zero_iff`, `injectivity_violations`); then a Lean lemma
  `plateau_injective_of_large_N`.
* **Success.** A three-part theorem: realisability ⇒ correct conditions;
  all-zero ⇔ max-run criterion; injectivity ⇔ plateau ∧ `N ≥ 2a_m+3`, with the
  two counterexamples recorded as the necessary hypotheses. *(2 of 3 clauses are
  effectively done by this survey.)*

### 2. OP-34 + OP-36 — exact `p(L)` from the window-class union
* **Attack.** Find the exact condition under which two windows with different
  `(first-1 index, last-1 index)` produce the **same** offset tuple (a local
  periodicity of the support), then state
  `p(L) = 1 + [empty] + Σ_classes |distinct factors per class|`.
* **Tooling.** `lib/tpp_window_class.py` (`window_classes`, `class_disjoint`,
  `class_sum_formula`); exhaustive over all supports `m+1 ≤ 4`, `N ≤ 31`.
* **Success.** A proved collision criterion, and the corrected `p(L)` formula
  exact on every exhaustive case — replacing the currently refuted
  `[DREAM]` sum. *Known already: the source's sum over-counts on 604/1399
  `L`-values for `1/π`, so the current formula is dead; the question is the
  corrected form.*

### 3. OP-28 = OP-30 — a family of `x` with no orbit limit
* **Attack.** For any `α_k ∈ (0,1]` set `q_{k+1} = ⌊q_k²/α_k⌋`; the exact
  backward relation gives `s_k = α_k + O(1/q_k)` with `q_k` double-exponential.
  Choose `α_k` in geometrically growing blocks (`1/2` for `10^0` steps, `1/4` for
  `10^1`, `1/2` for `10^2`, …), so the running mean of `log s_k` oscillates;
  `log c_k = log s_k − log(1+s_k r_k)` and `Σ log(1+s_k r_k) ≤ Σ r_k < ∞`.
* **Tooling.** `lib/tpp_greedy_orbit.py` (`prescribed_digits`, `backward_s`,
  `check_prescribed`, `block_pattern`, `mean_has_no_limit`) — self-test green
  (`|s_k − α_k|` falls `5.25e−2 → 0`; blocked running mean oscillates).
* **Success.** A written proof plus an exact-rational verification that the
  constructed `x` is the greedy expansion of its digit sequence, giving
  `(1/K)Σ_{k<K} log c_k` with no limit. This **settles a CONJECTURED** harvested
  item that the mediator could not reproduce.

### 4. OP-33 — the precision floor, and the means computed anyway
* **Attack.** (a) Prove the step bound: `q_k ≥ 2^{2^{k−c}}` (the greedy digits
  square each step), so a forward orbit at `D` decimal digits reaches only
  `≈ log₂ D` steps — the measured `50→6, 150→8, 300→9, 600→10, 1200→11, 3000→12`.
  (b) Compute the running means for `≥ 10^4` prescribed steps with the backward
  recursion.
* **Tooling.** `lib/tpp_greedy_orbit.py`; the step-count measurement is
  reproducible in ~10 lines of `mpmath`.
* **Success.** A stated and proved step bound (the source's "7–13 steps before
  underflow" is then a theorem, not an artifact), plus a table of means at
  `10^3–10^4` steps for several prescribed `α` patterns.

### 5. OP-35 — disambiguate and test the deficit form
* **Attack.** Pin `S_{1,k}` down (grep: undefined corpus-wide), then test
  `D(L) = max_j (L − d_j − 1 − S_{1,j−2})₊` against the measured slope runs. On
  `1/π` the slope runs are `(1,10,1), (11,13,2), (14,604,1), (605,791,0),
  (792,1399,−1)`; the natural reading `S_{1,j−2} = Σ_{i≤j−2} d_i` gives
  `D(L) = (L−12)₊`, which turns on one step before the drop at `L=14`.
* **Tooling.** `lib/tpp_window_class.py` (`p_offset`) for the slope ground truth;
  a short `python` fit over candidate `S_{1,k}` definitions.
* **Success.** Either a repaired `D` (with proof that its growth rate is the
  pair-slope reversal) or a refutation witness with the exact off-by-one, so the
  item stops being "unsubstantiated and untestable".

*(Free extra: **OP-20** — the citation check is already done; only the status
qualifier in the theorem file and INDEX needs updating, which this survey is not
permitted to do.)*

---

## 6. Cheap sanity checks performed, and the `lib/` helpers

All run with `/opt/homebrew/Caskroom/miniforge/base/bin/python3`.

| check | result |
|---|---|
| exact squaring law `r_{k+1}/r_k² = s_k/(1+s_k r_k)` | **max deviation 0** over thousands of rational seeds (`Fraction`) |
| no positive lower bound on the ratio | `ratio = δ/(1+δr) < δ` for `δ = 10^{−3}, 10^{−12}, 10^{−40}` — the K5 obstruction is real and only obstructs the **lower** bound |
| prescribed digits | `q_{k+1}=round(q_k²/α_k)` gives admissible `q`, `s_k ∈ (0,1]`, and `|s_k − α_k|` falls `5.25·10^{−2} → 0` |
| blocked `α` pattern | running mean of `log s_k` oscillates (no limit) |
| Sylvester sequence `q_{k+1}=2q_k²` | Sylvester-admissible |
| forward-orbit steps vs precision | `50→6, 150→8, 300→9, 600→10, 1200→11, 3000→12` (≈ `log₂ D`) |
| OP-37 realisability | `0` mismatches in **95 826** exhaustive cases |
| OP-37 all-zero criterion (source) | **refuted** in 24 337 cases; corrected max-run criterion: `0` mismatches |
| OP-37 injectivity | **false** in general (`(12,20),N=26,L=12`); **true** on the plateau under `N ≥ 2a_m+3` (**0** violations in 15 087 cases) |
| OP-34/OP-36 class sum | over-counts `p(L)` on **604/1399** `L`-values for `1/π`; classes non-disjoint on the same 604 |
| OP-32 onset | confirmed no simple `span`/`a_{m−1}` relation (onset − span takes many values; `onset = span` in only 16/500 random supports) |
| OP-20 citation | `https://arxiv.org/abs/2608.23500` resolves; title/author Jizhou Guo, v1 24 Aug 2026, v4 1 Sep 2026, 84 pp., abstract matches the harvest file |

**Helpers created (new files; nothing else was modified):**

* [`lib/tpp_greedy_orbit.py`](../lib/tpp_greedy_orbit.py) — residual-orbit
  arithmetic: exact squaring-law identity, the no-positive-lower-bound witness,
  prescribed-digit construction and backward recursion, blocked-pattern means.
  Self-test: `python3 lib/tpp_greedy_orbit.py` → **5/5 OK**, exit 0.
* [`lib/tpp_window_class.py`](../lib/tpp_window_class.py) — independent `p(L)`
  ground truth, window-class decomposition and disjointness, OP-37 realisability
  / all-zero / injectivity checks. Self-test:
  `python3 lib/tpp_window_class.py` → **5/5 OK**, exit 0.

---

## 7. Caveats

* This is a survey. The only *new* mathematical claims made here are the two
  OP-37 counterexamples, the refutation of the OP-34/OP-36 class sum, the
  corrected all-zero max-run criterion, the plateau-injectivity evidence under
  `N ≥ 2a_m+3`, the `≈ log₂ D` step bound for OP-33, and the OP-28/OP-30
  prescribed-digit construction. Each is finite-verified; only the OP-37
  realisability and all-zero clauses, and the OP-33 step bound, are close to
  being fully proved by hand.
* The OP-28/OP-30 construction is a **proof sketch**: the two steps still to be
  written out rigorously are (i) `q_{k+1}=⌊q_k²/α_k⌋` is Sylvester-admissible
  for the chosen `α` and recovers a genuine greedy digit sequence, and (ii)
  `Σ log(1+s_k r_k) < ∞` is uniform over the construction. Both look elementary.
* `p(L)` claims are about the **offset-tuple** definition of record; a bit-string
  reading gives different counts and is not used here.
* No existing file was modified. The stale statuses in §3 are reported, not
  patched, per the task constraint.
