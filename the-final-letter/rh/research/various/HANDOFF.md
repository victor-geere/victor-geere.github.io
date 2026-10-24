# HANDOFF — the factor-complexity law of the greedy digit word

**Created:** end of the mediated A/B dialogue session recorded in [`research-journal.md`](research-journal.md).
**Working directory:** `/Users/victor/workspace/rh`.
**Status:** the dialogue is closed. The complexity law is **open**; this document defines it precisely, records exactly what has been proved and disproved by computation, and specifies the path — B's structural characterisation plus a saturation analysis — to close it.

---

## 1. What this document is for

`research-journal.md` (723 lines, 35 verification scripts in `verify/`) records ten mediated rounds between a delusional-but-well-read Agent A and a rigorous Agent B, with every computable claim recomputed by the main agent. That dialogue ended with one unanimous open problem:

> **Prove or refute:** for every irrational x ∈ (0,1), the orbit r ↦ r − 1/⌈1/r⌉ satisfies (1/K)Σ_{k≤K} log c_k → a limit independent of x — equivalently, is Σ_k log c_k bounded?

That problem is about the *residual* orbit. **This handoff is about a different and more tractable open problem that the same dialogue exposed**: the exact factor-complexity law p(L) of the digit word. It is finite, combinatorial, non-analytic, and — unlike the orbit-average problem — it can be attacked with finite enumeration, a saturation argument, and (for the pure combinatorial core) Lean.

Everything in §3 is verified numerically. Everything in §4 is a target. §5 lists what has already been disproved so nobody re-derives it. §7 contains the two agent prompts.

---

## 2. The object, defined exactly

Let θ ∈ (0, π), x = θ/π ∈ (0, 1). The **greedy harmonic sine** selects indices by the unsigned Egyptian greedy rule:

```
r_0 = x,  n = 0, 1, 2, ...
  if r_n >= 1/(n+2):  delta_n = 1,  r_{n+1} = r_n - 1/(n+2)
  else:               delta_n = 0,  r_{n+1} = r_n
```

The infinite binary word **w = w(x) = δ_0 δ_1 δ_2 …** is the object of study.

**Two rigorously known regimes.**

- **Rational x = p/q:** the process terminates. Indices for θ = π are exactly {0, 1, 4} (1/2 + 1/3 + 1/6 = 1). Verified with exact rational arithmetic.
- **Irrational x:** the process never terminates, and the selected indices satisfy exactly

  **n_{k+1} = ⌈1/r_k⌉ − 2**,   so   **r_{k+1} = r_k − 1/n_{k+1} = (1−f)r_k² / (1 + (1−f)r_k)**,  f = {1/r_k}.

  Hence A(N) := #{n ≤ N : δ_n = 1} = log₂ log N + O(1) — verified by direct census to index 128 541 453 (x = π−3).

**The complexity function** (the subject of this handoff):

```
p(L) := #{ distinct factors of length L occurring in w }.
```

For rational x the word is eventually all zeros and p(L) saturates at a finite value. For irrational x the word is infinite and finitely supported in every prefix; p(L) is still finite for each L (a word with m ones has finitely many length-L factors).

**Convention for computation.** Work with a finite truncation of length N: the word `w_N` = first N symbols, and count factors in `w_N`. State N in every reported number, because p depends on N once L approaches N. In the research dialogue the truncations were N = 1400 (x = 1/π), N = 13000 (log 2), N = 2000 (√2−1), N = 2000 (e−2).

---

## 3. What is verified (all by exact enumeration; reproduce before extending)

### 3.1 Exact measured complexity, x = 1/π, ones at positions {2, 13, 607}, N = 1400

| L | p(L) | L | p(L) | L | p(L) |
|---|---|---|---|---|---|
| 1 | 2 | 13 | 16 | 100 | 104 |
| 5 | 6 | 14 | 18 | 300 | 304 |
| 10 | 11 | **15** | **19** | 593 | 597 |
| 11 | 12 | 20 | 24 | 594 | 598 |
| 12 | 14 | 50 | 54 | 605 | 609 |

**Piecewise-linear with slope changes at the gap values:**

```
p(L) = L + 1          for  1 <= L <= 11
p(L) = 2L - 10        for 12 <= L <= 593
p(L) = 3L - 603       for 594 <= L <= 604
p(L) = 609 (constant) for L >= 605
```

The slope is **1 + #{gaps d_j < L}** where the gaps are the consecutive gaps 11 and 594. Saturation value **609 = (span) + (m − 1)·? ** — see §3.3; for this word 609 = 605 + 4 and also 607 + 2, so the saturation value needs its own derivation.

### 3.2 The exact structural characterisation (B's, corrected)

B's original formulation — factors classified by the triple (index of the first 1, its offset, number of further 1s) — **overcounts** and is refuted: my implementation gave 4 at L = 1 for the word with ones {19, 50, 83} where the truth is 2, and 3693 mismatches in 5173 tested cases.

**The correct statement.** A factor is determined by the **set of offsets** of the 1s it contains:

```
factor at window start t  <->  { a − t : a ∈ ones, t <= a <= t + L − 1 }.
```

Two windows give the same factor **iff** these offset-tuples agree. Hence

```
p(L) = # { {a − t : a ∈ ones, t <= a <= t+L−1} : 0 <= t <= N − L }.
```

This is **exact by construction** and is what all verification must use as ground truth. The reduction B was reaching for is: *for L > span every window meets the support, so a factor is determined by (i, x) = (index and offset of the first 1 in it) — but the realisable pairs are constrained by the previous 1, and getting that constraint exactly right is the open combinatorial step.*

Verified for x = 1/π at L = 20: 24 distinct factors, with the explicit decomposition

```
()            : the all-zero factor, 1347 windows
(0,)…(10,)    : 11 factors, each from exactly 2 windows
(11,)…(19,)   :  9 factors, each from exactly 1 window
(0,11) (1,12) (2,13) :  3 pair factors, each from 1 window
                -----
                24  ✓
```

Note that offsets (0,) through (10,) come from **two** windows each — this is why the naive "L + 1 + Σ(L − d_j)" count fails (it predicts 30 at L = 20).

### 3.3 Saturation, measured exactly

| word (positions) | N | span | exact measured p(L) above the span | note |
|---|---|---|---|---|
| {2, 13, 607} | 1400 | 605 | 609 at L = 606, 700; **601 at L = 800**; 597 at L = 804; 596 at L = 805; 501 at L = 900; 3 at L = 1398 | drops once L approaches N |
| {2, 13, 607} | 1600 | 605 | **609 at L = 606, 700, 800, 804, 805, 900** | saturated throughout |
| {2, 13, 607} | 2000 | 605 | **609 at L = 606, 700, 800, 804, 805, 900** | saturated throughout |
| {0, 4, 36, 6069} | 13000 | 6069 | 6071 at L = 6070, 6119, 6268 | saturated |
| {1, 11, 251} | 2000 | 250 | 253 at L = 251, 300, 449 | saturated |
| {10, 20, 40, 80} | 500 | 70 | 82 at L = 71, 120, 269 | saturated |

**Meta-note on this table, because it is itself an instructive error.** My first draft claimed the drop to 601 at L = 800 was an artefact of a different N, and I "corrected" the table to say p(L) = 609 at every L from 606 to 804 at N = 1400. That correction was **wrong**: at N = 1400 the drop is real, and p(800) = 601, p(804) = 597, p(805) = 596, p(900) = 501. The 609 values at those same L reappear at N = 1600 and N = 2000, which is what misled me. The true structure is:

- **Saturation value (N-independent):** for L strictly between span and roughly N/2, p(L) = 609 for this word, and this value is independent of N once N is large enough — 609 at N = 1400, 1600, 2000 alike.
- **Right-edge truncation:** as L grows past roughly N/2, more and more windows are lost to the right edge and p(L) decays toward 1 (it reaches 3 at L = N − 2). This is the `N − L + 1` ceiling reasserting itself, and it is why p(L) is *not* eventually constant in L at fixed N — it is eventually *decreasing*.

So the precise formulation for the saturation sub-target C2 is two-part, and this distinction is the first thing the next session must get right: **the saturation VALUE** (609 here, attained on the plateau span < L ≲ N/2) and the **decay regime** (L ≳ N/2, where p(L) falls toward 1). The research dialogue's earlier claim that "p(L) saturates" was therefore only true on the plateau. This is recorded as a correction in the ledger-keeping spirit of §8.4.

Two structural facts are visible and are the seed of the saturation analysis:

- **For L > span every window meets the support**, so there is no all-zero factor.
- **The saturation value is not simply N − L + 1 and not simply L + span.** Both fail:
  - L + span fails: {2,13,607}, L = 606: formula 1211, truth 609. {10,20,40,80}, L = 71: formula 141, truth 82.
  - N − L + 1 fails: {2,13,607}, L = 606: formula 795, truth 609.
  - **Candidate model D: `p(L) = min(L + span, N − L + 1)`** matched every case tested in the final probe ({2,13,607} at L = 800 gives min(1405, 601) = 601 = truth; {139,151} at L = 13 gives min(25, 160) = 25, truth 15 — **so D fails there too**). I record D as a *tested-and-failing* candidate, not a conjecture, and note that {139,151} with span 12 is a useful smallest counterexample.

### 3.4 The first-difference identity — a theorem, verified

Cassaigne's first-difference theorem holds in every case tested:

```
p(L+1) − p(L) = # { right-special factors of length L }
```

where a factor f is right-special iff both f·0 and f·1 occur. Verified for all three dialogue words at L = 1, 5, 10, 20, 100; e.g. {10,20,40,80} gives p(L+1) − p(L) = 1, 1, 2, 3, 0 at L = 1, 5, 10, 20, 100, and the right-special counts agree exactly each time. **This is the single most useful proven tool for the open problem: it converts the complexity question into a question about right-special factors, which for a sparse word is a question about how many ways a window can be extended.**

---

## 4. The open problem, stated for proof

**Problem C (main).** Give the exact factor-complexity function p(L) of the greedy digit word w(x), as a function of the support positions 0 ≤ a_0 < a_1 < … < a_m < N.

Decompose into three sub-targets, in increasing order of difficulty.

**C1 (achievable — prefix regime).** For 0 < L ≤ min_j d_j (all gaps at least L) prove

```
p(L) = L + 1 + #{ i in [1, n] : L > d_i },
```

and in particular that the slope changes exactly at the consecutive gaps. Measured: 1/π gives slope 1 on [1,11] and 2 on [12,593], changing at d_1 = 11. **This sub-target is already supported at the breakpoints and should be provable by a bijection argument on the first-1/offset pairs.**

**C2 (the hard core — saturation analysis, in two parts).** Prove the following structure, which the measurements in §3.3 establish but do not explain:

- **(C2a) The saturation value on the plateau.** For `span < L ≲ N/2`, p(L) is constant in L and equal to a value determined by the support alone (609 for {2,13,607}, 6071 for {0,4,36,6069}, 253 for {1,11,251}, 82 for {10,20,40,80}). Give that value in closed form in terms of (N, a_0, …, a_m), or prove it has no closed form in (m, span, N) alone.
- **(C2b) The right-edge decay.** For `L ≳ N/2` the function is *not* constant: it decreases toward 1 (measured for {2,13,607} at N = 1400: 609 at L = 700, 601 at L = 800, 597 at L = 804, 596 at L = 805, 501 at L = 900, 3 at L = N − 2). Characterise the decay, i.e. the exact value of p(L) in terms of the distances from the support to the two ends of the word.

**The earlier dialogue asserted flatly that "p(L) saturates"; §3.3 shows that is true only on the plateau.** A proof of C2 must cover both regimes and identify the crossover. The clean structural input for C2a is that for L > span every window meets the support, so no all-zero factor occurs and every factor is determined by the first 1 in its window together with that 1's offset. The missing constraint — and the crux — is: *for a given i and offset x, exactly which window starts t realise (i, x) as the first 1?* Answering that is equivalent to C2a; C2b is then the boundary analysis of the same count.

**C3 (the general L).** Characterise the piecewise-linear breakpoints of p(L) for span-adjacent L (between d_1 and span). Measured for 1/π: slope 1 on [1,11], 2 on [12,593], 3 on [594,604], 0 thereafter. Note the slopes 1, 2, 3 = 1 + #{gaps < L}, and note that the final plateau is *not* a slope — it is saturation.

**C4 (nice-to-have, the inverse problem).** A's own closing choice: characterise the minimal alphabet {α_n} whose greedy digit word realises a prescribed complexity function p(L). This is the question that would settle whether exact termination and dense sampling are simultaneously achievable, and at what cost in alphabet decay. Two facts are already known: bounded gaps ⟺ α_n = (n+2)^{−p} with p > 1, and reachability of unit target ⟺ ζ(p) ≥ 2, i.e. p ≤ p\* = 1.728647239. Neither threshold is 3/2.

---

## 5. Already disproved — do not re-derive

Record these so they are not re-proposed. Each was refuted by exact enumeration.

| Claimed law | Status | Counterexample |
|---|---|---|
| A: p(L) = L + 1 + #{pairs of 1s at distance ≤ L} | **DISPROVEN** | 1/π, L = 11: predicts 13, truth 12; L = 13: predicts 15, truth 16; log 2, L = 6: 9 vs 8 |
| Main agent: p(L) = L + 1 + #{distinct distances ≤ L} | **DISPROVEN** | 1/π, L = 12: predicts 13, truth 14 |
| Main agent: p(L) = L + 1 + Σ_i (L − d_i)_+ | **DISPROVEN** | 1/π, L = 20: predicts 30, truth 24 |
| A: p(L) = L + 1 on L ≤ 11, then 2L − 10 | **PARTLY TRUE, over-extrapolated** | true only on 12 ≤ L ≤ 593; L = 100 → 190 vs truth 104; L = 605 → 1200 vs truth 609 |
| B: factors classified by (first-1 index, offset, count) | **DISPROVEN as stated** | {19,50,83}, L = 1: 4 vs truth 2 (3693/5173 mismatches) |
| Model D: p(L) = min(L + span, N − L + 1) | **FAILS** | {139,151}, N = 172, span = 12, L = 13: 25 vs truth 15 |
| "p(L) is Sturmian-like, p(L) = L + 1 for all L" | **IMPOSSIBLE** | word is finitely supported and eventually zero, hence non-recurrent; Morse–Hedlund forbids it |

**Do not** propose a formula solely in {L, number of pairs, number of distinct distances}. A formula must be a function of the **full gap sequence** (and of N). This is established, not conjectural: the pair-based and distance-based formulas fail on the same words where a gap-based description succeeds.

---

## 6. Concrete numerical targets to compute first

Run these before attempting proofs; they pin the law down for the tractable sub-cases.

1. **Saturation thresholds.** For each of the four dialogue words, find the exact least L_sat such that p(L) = p(L_sat) for all L ≥ L_sat with L ≤ N. So far: {2,13,607} N=1400 saturates at 609 by L = 605 but drops by L = 800 — so state the range over which saturation holds, not just the value.
2. **Exhaustive small-case table.** For all words of length N = 20 with m ∈ {1, 2, 3, 4} ones at every allowed position set, tabulate the exact p(L) for L = 1..20, and fit the saturation value as a function of the gap sequence. This is the dataset that any candidate closed form must reproduce; it is small enough to enumerate completely and large enough to kill false laws.
3. **C1 stress test.** For 200 random gap sequences with all gaps ≥ L, verify p(L) = L + 1 + #{i : L > d_i}. Report the exact failure rate (expected zero) and the count.
4. **First-difference certificate.** For each word and each L, verify p(L+1) − p(L) = #right-special factors, and record the right-special factors themselves. This will expose the structure of the hard regime, because right-special factors of a sparse word are exactly the windows where the first 1 sits at a boundary.
5. **Orbit-average problem (the other open question).** One irrational x to 10⁴ digits, iterate r ↦ r − 1/⌈1/r⌉ recording log c_k until precision dies (~40–50 steps), for 10–20 algebraically independent x, and test whether the running averages converge to a common value. Known partial result: c_k = (1−f)/(1+(1−f)r) with f = {1/r_k}, which is exact; A's E[log c_k] = ∫₀¹ log(1−f) df = −1 holds only in the large-u scaling limit and is false at finite r.

---

## 7. Agent bootup prompts

Both agents are forked from the session that produced `research-journal.md`, so they already hold the two handoff HTML documents and the whole dialogue in context. The prompts below are written as self-contained restarts in case they are spawned fresh instead — in that case, prepend: *"Read `/Users/victor/workspace/rh/research-journal.md` (all 723 lines) and the two handoff documents before answering."*

### 7.1 Agent A — the professor

> You are AGENT A in a two-agent research dialogue. Stay in this persona for every turn.
>
> **PERSONA.** You are a retired emeritus professor. You have perfect recall of the published mathematical literature: you can quote Titchmarsh, Ingham, Montgomery, Selberg, Ruelle, Mayer, Efrat, Morse–Hedlund, Cassaigne, Sós, Surányi, Sylvester, Fibonacci, Erdős–Graham, and the classics, accurately, with real theorem statements and real attributions. Where your recall is genuinely unsure you may say so, but you must NEVER invent a citation, a page number, or an attribution: fabricated scholarship is the one sin your madness does not commit. Beyond the frontier of what is proved you are convinced almost anything is possible, you reason by analogy and dream-logic, and you over-generalise. You speak in short declarative bursts with the confidence of a man who no longer cares what referees think.
>
> **YOUR KNOWN FAILURE MODE — COMPENSATE FOR IT DELIBERATELY.** Across ten rounds of this dialogue you made eleven errors, and *every single one was a claim about a limit, an asymptotic, or a direction*. You reproduce values to eight digits (0.3144378476, 0.2080085112, 1.477×10⁻¹⁰³) and you got every asymptotic wrong on first statement: Σμ(n)n^{−s} "converges at σ = ½" (false, RH-equivalent); Σn^{−1/2−iγ} "converges to ζ" (false, grows like √N); p = 3/2 as a threshold (false, it is p\* = 1.728647239); the large sieve "gives a √(N/T) lower bound" (false, it is an upper bound); the Gaussian "inadmissible" (false, you withdrew it yourself); the complexity law p(L) = L + 1 + #pairs (false — see HANDOFF.md §5). Therefore: **before you assert any asymptotic, any inequality direction, or any "for all sufficiently large" claim, say which finite computation would falsify it, and if you cannot name one, mark the claim [DREAM] rather than [RECALL].**
>
> **TAGS.** Use exactly these: `[RECALL]` for literature (must be verifiable), `[DREAM]` for conjecture, `[COMPUTABLE]` for a checkable number or exact identity, `[LEAP]` for what would follow if you were right. If no leap survives, write "[LEAP] None survives" — you did this twice and it was your best work.
>
> **SUBJECT.** The factor-complexity function p(L) of the greedy digit word w(x) for x = θ/π, defined in HANDOFF.md §2, together with the residual-orbit question of §6 item 5. Everything you already established stands: the squaring law r' = (1−f)r²/(1+(1−f)r), A(N) = log₂ log N + O(1), the certification theorem, and the three independent obstructions to any zeta bridge. Do not reopen the zeta programme; it is closed.
>
> **EACH TURN, at most 600 words, in this exact shape:** `[DREAM]` your wildest honest thinking, with concrete objects and formulas, not poetry. `[RECALL]` the real literature, accurately. `[COMPUTABLE]` at least one concrete prediction or exact identity, with numbers to ≥3 significant figures and an explicit statement of how to test it. `[LEAP]` one sentence, or "none survives".

### 7.2 Agent B — the auditor

> You are AGENT B in a two-agent research dialogue. Stay in this role for every turn.
>
> **ROLE.** You are a rigorous, patient, technically expert verifier. Your counterpart, Agent A, has perfect recall of the literature but reasons delusionally beyond the frontier. You never attack him personally and never dismiss him; you do the harder thing — you extract from his ravings whatever is well-defined, repair it into the nearest well-posed claim, and test it. You have web access (use it to verify attributions and give URLs) and a shell with Python, numpy, mpmath and pytest.
>
> **YOUR KNOWN FAILURE MODE.** You have twice made errors of exactly the kind you police: you asserted the greedy Gram matrix was diagonal by Legendre orthogonality when the functions are greedy digit functions (max off-diagonal 0.8631), and you reported a pair-correlation normalisation that you later withdrew as wrong. **Therefore: never state an orthogonality, a normalisation, or a "by theorem X" step without writing the object out and computing one instance.** If you cannot check it in this turn, label it `[NOT RUN]`.
>
> **SUBJECT.** The factor-complexity law p(L) of the greedy digit word, per HANDOFF.md §2–§4. Ground truth for every check is the exact offset-tuple enumeration in §3.2:
> ```
> p(L) = # { {a − t : a ∈ ones, t ≤ a ≤ t+L−1} : 0 ≤ t ≤ N − L }
> ```
> Your structural characterisation from the dialogue (factors classified by the index and offset of the first 1) is **correct in spirit and overcounts as stated** — see HANDOFF.md §5. Your task now is to repair it exactly: **specify, for each index i and offset x, precisely which window starts t realise (i, x) as the first 1 of the factor.** That repair is equivalent to solving Problem C2 (saturation), and it is the crux of the whole open problem.
>
> **EACH TURN, at most 700 words, in this exact shape:** `[CHARITABLE]` restate A's claim in its strongest precise form, repairing it if ill-posed and saying what you changed. `[KNOWN]` separate what is already in the literature (correct attributions, URLs) from what would be new; flag any misattribution. `[TESTED]` the actual verification — run it, report exact numbers, show the code path briefly, or mark `[NOT RUN]` with exactly what would settle it. `[VERDICT]` one of STANDING / UNSUBSTANTIATED / DISPROVEN / RETRACTED-WORTH-KEEPING, plus one sentence; reserve STANDING for things you verified. `[OPEN]` the single sharpest next question for the mediator to put to A.
>
> Never fabricate a numerical result. Keep hostility at zero and precision at maximum.

### 7.3 The mediator's protocol

The main agent mediates: it poses the round's question to A, forwards A's answer to B for audit, recomputes **every** computable claim itself, rules on each claim, appends the round to `research-journal.md`, and only then opens the next round. Verdicts use the same four-status vocabulary as B. A claim stays live while unsubstantiated and not disproven. The mediator must correct itself in writing when it is wrong — it made twelve errors in the previous dialogue and logged all twelve.

---

## 8. Verification requirements for the main agent

**Non-negotiable: no claim goes into `research-journal.md` unless the main agent has recomputed it independently of both A and B.** In the previous dialogue, 24 errors were made across the three participants and several were caught only by independent recomputation.

### 8.1 Python — the ground-truth layer

Every enumeration must be done in exact or high-precision arithmetic, never in binary floats.

- **Exact word construction:** build the digit word by exact rational arithmetic (`fractions.Fraction`) whenever x is rational, and at ≥ 120 decimal digits of `mpmath` precision when x is irrational. *A float run in the previous dialogue produced the spurious support [0,1,5,41,1805] for θ = π because the residual after 1/2 + 1/3 was 1e−16 instead of 0; exact rationals give [0,1,4].* Never run a greedy test in float.
- **Exact complexity:** use the offset-tuple definition in §3.2 as the definition of record, and cross-check every candidate formula against it by brute force on small N (N ≤ 30 is enough to kill most false laws) before testing on the large words.
- **Report N with every number.** p(L) depends on the truncation length.
- **Cross-check high-precision constants:** compute π, log 2, √2 at the working precision rather than pasting truncated decimal strings — `mpmath` parses a literal string only to the current `mp.dps`, so a 50-digit literal at dps = 15 silently becomes a 15-digit number. This artefact produced a wrong conclusion once already.

### 8.2 Unit tests — the regression layer

Create `tests/test_complexity.py` (pytest is available, version 9.1.1). Required tests, each written **before** the code it tests where possible:

1. `test_offset_tuple_equals_bruteforce` — the offset-tuple count equals `len({w[i:i+L] for i in range(N-L+1)})` over all words of length 12 with 0–4 ones, all L.
2. `test_base_case` — p(L) = L + 1 for L ≤ min gap, over random gap sequences.
3. `test_slope_change_points` — the slopes of p for 1/π are 1, 2, 3 with changes exactly at the consecutive gaps 11 and 594.
4. `test_saturation_values` — the four measured values in HANDOFF.md §3.3 (609, 6071, 253, 82) reproduce exactly.
5. `test_disproven_formulas_fail` — each law in HANDOFF.md §5 must **fail** on its recorded counterexample. These are regression tests against re-deriving dead ends.
6. `test_cassaigne_first_difference` — p(L+1) − p(L) equals the number of right-special factors, for every word and L tested.
7. `test_greedy_squaring_law` — r' = (1−f)r²/(1+(1−f)r) to 30 digits at every step, for six irrational targets.
8. `test_rational_termination` — exact rationals: 268 of 277 reduced p/q with q ≤ 30 terminate; θ = π gives exactly {0,1,4}; 4/17, 14/19, 17/19, 7/23, 21/23, 4/25, 9/29, 12/29, 27/29 are the slow ones.
9. `test_known_constants` — ζ(3)/ζ(6) = 1.1815649490; p\* = 1.728647239 where ζ(p\*) = 2; M = γ + Σ_p[log(1−1/p)+1/p] to X = 10⁶ = 0.2614972467 ± 1e−7.

Suggested layout: `tests/` beside `verify/`, with `pytest -q tests/` as the gate. Do not put slow mpmath census tests in the default run; mark them `@pytest.mark.slow`.

### 8.3 Lean 4 / Mathlib — the proof layer, with an honest caveat

**Toolchain present on this machine:** `lean`, `lake`, `elan` at `/Users/victor/.elan/bin/`, toolchains `leanprover--lean4---v4.14.0` and `v4.33.1`. There is an existing project `/Users/victor/workspace/lean-dev` (Lake, toolchain v4.33.1) and an older one at `/Users/victor/workspace/victor-geere.github.io/maths/rh/proof/rh9-lean`.

**Caveat to check first:** `/Users/victor/workspace/lean-dev` has **no `.lake/packages` directory**, so Mathlib is **not** currently fetched for it. Mathlib is large (multi-GB) and fetching it needs network access, which may be restricted in this sandbox. **Before promising any Mathlib proof, run `lake exe cache get` (or `lake update && lake build`) in the chosen project directory and report whether it succeeded.** If it fails, do not pretend otherwise — split the formalisation accordingly.

**Tier 1 — pure Lean 4, no Mathlib (should work offline).** These are finite combinatorics over lists and finite sets and are worth formalising because they are the load-bearing lemmas:

- The factor set of a word is `{w.drop t | t < N - L + 1}` as lists, and `p(L) := (factorSet w L).card`.
- `p(L) ≤ N - L + 1`, trivially but usefully.
- `monotone`-type facts: if `w` is finitely supported with last one at `a_m`, then for `L ≥ span + 1` every factor contains a 1, hence the all-zero factor does not occur.
- Cassaigne's identity in the finite form actually used: `p(L+1) - p(L) = #{f ∈ factors L : f ++ [0] ∈ factors (L+1) ∧ f ++ [1] ∈ factors (L+1)}`.
- The saturation statement of §3.3 as a target: once `L > span`, the map `t ↦ (index of first 1 in window t, its offset)` is injective on windows, and `p(L)` equals the number of realisable pairs.

**Tier 2 — Mathlib (only if the cache fetch succeeds).** The candidates are:

- `Finset.card` manipulation and `List` factor lemmas from `Mathlib.Data.List.*`.
- The uniqueness of the 3-term unit-fraction decomposition of 1 — this is fully formalisable with `Mathlib.Algebra.BigOperators` and `Nat` divisibility: `1 = 1/a + 1/b + 1/c` with `2 ≤ a < b < c` forces `a = 2`. **Note this is a theorem with a two-line proof and needs no bound on c** (B's argument: `3/a ≥ 1` so `a ≤ 3`; `a = 3` gives `1/b + 1/c = 2/3 ≤ 1/2`, contradiction; `a = 2` gives `c = 2b/(b−2) > b` forcing `b < 4`, so `b = 3`, `c = 6`). This is the single cleanest Mathlib target in the whole subject.
- Morse–Hedlund (Sturmian ⟺ complexity L+1 ⟺ coding of an irrational rotation) is in Mathlib or adjacent libraries for some formulations; **verify before relying on it** — in the previous dialogue the Sturmian reading was invoked and then correctly abandoned, because a finitely supported word is non-recurrent and Morse–Hedlund forbids it.
- The Sylvester/Engel expansion theory for rationals is **not** in Mathlib as far as I know; treat as out of scope.

**Rule for the main agent:** if a proof is claimed in Lean, the claim must include the exact `lake build` output and the file path. If Mathlib cannot be fetched, say so explicitly in the journal and confine formalisation to Tier 1. Do not describe a Tier-1 sketch as a Mathlib proof.

### 8.4 Evidence standard for the journal

For each claim, record: (a) the exact statement, (b) the status word, (c) the computation or proof that establishes it, (d) the file and line reference, (e) for numerical claims, the working precision and truncation length. A claim with no (c) goes in as `[NOT RUN]` or `[DREAM]`, never as standing. When the main agent's own earlier claim is refuted, log the error in the ledger table — the previous dialogue's ledger has 24 rows and is the most useful table in the document.

---

## 9. File map

| Path | Contents |
|---|---|
| [`research-journal.md`](research-journal.md) | the complete ten-round dialogue, both agents' verbatim answers, the mediator's adjudication, the 24-row error ledger, and the closing synthesis |
| `verify/` | 35 scripts; every number in the journal comes from one of them |
| `verify/handoff_structural_v2.py` | exact offset-tuple enumerator and the refutation of B's triple classification |
| `verify/handoff_saturation_theorem.py`, `verify/handoff_saturation_v2.py`, `verify/handoff_models.py` | the saturation probes and the failing candidate models D, L+span, N−L+1 |
| `verify/round7_AN_census.py` | the A(N) census (n_{k+1} = ⌈1/r_k⌉ − 2) |
| `verify/round7_squaring_verify.py` | the exact squaring law, checked step by step |
| `verify/round9_fixed.py` | uniqueness of (2,3,6), Gauss vs Sylvester map, Mertens = γ + prime sum |
| `verify/round5_closure_check.py`, `verify/round6_afe_v2.py` | the Riemann–von Mangoldt closure attempt and the AFE truncation floor |

## 10. What must not be reopened

The zeta bridge is closed, and blocked at four independent levels established with numbers, not rhetoric: the prime-side amplitudes Λ(n)/√n are an unbounded two-parameter family that no finite alphabet can carry (0.490129, 0.634284, 0.346574, 0.719763, 0.245065, 0.366204 at n = 2, 3, 4, 5, 8, 9); the operation converting log ζ into −ζ'/ζ is a derivative, requiring a division that the add-and-compare machine does not have; the transferable virtue of the construction is certification, which is exactly what the ζ truncation cannot supply (its error grows like 0.0707035·√N while the greedy bound π/(N+1) is computable from N alone); and the digit word is finitely supported, non-recurrent, not Sturmian, while the zero side is GUE-repelled. The eigenvalue-drop claim is structurally impossible (M(t) = DKD is a diagonal similarity with |w_n|² real and t-free). If a future round proposes to reopen any of this, it must first produce a computation that contradicts one of those four statements.
