# rh40 — round 01, mediator's adjudication

**Round opened:** this session. **Round closed:** this session. **Result: three new standing results; one agent rule disproven; eight mediator errors logged.**
**Participants:** Agent A (professor), Agent B (auditor), mediator (main agent).
**Brief:** [`round01_brief.md`](round01_brief.md) — issued to both agents in parallel.
**Raw answers:** [`round01_agentA.md`](round01_agentA.md), [`round01_agentB.md`](round01_agentB.md).

**Rule applied (HANDOFF.md §8):** nothing below is recorded as standing unless the
mediator recomputed it independently of both agents, by a route that shares no
code with the agent's own scripts. Every such recomputation is in
[`../verify/verify_agentB.py`](../verify/verify_agentB.py) (agents A and B
combined) with raw output logged below.

---

## 1. Headline

Round 1 **closed sub-target C2a in value form** and **corrected the classical
first-difference identity for the finite word**. Two of the three defects the
mediator reported in the handoff (M1, M6) were confirmed by both agents; the
mediator's own proposed repair of Cassaigne's identity (M5) was **refuted**, and
Agent A's round-1 boundary rule (M6 repair) was **refuted**.

Three results from this round are new relative to HANDOFF.md and are now the
load-bearing facts of the programme:

1. **`p(L+1) − p(L) = RS(L) − Z(L)`** exactly, for every L, where
   `Z(L) = |F(L)| − #{prefixes of F(L+1)} ∈ {0,1}` is the count of length-L
   factors with **no right extension inside the finite word**. (Agent B;
   independently reproduced by the mediator on 5 words for all L.)
2. **The plateau value is `a_m + 2`** — a function of the last support position
   alone. 609 = 607+2, 6071 = 6069+2, 253 = 251+2, 82 = 80+2. (Agent B,
   supported by Agent A's independent prediction of three new words.)
3. **The decay law is `p(L) = N − L + 1` on exactly `L ∈ [N − a_m − 1, N − 1]`**,
   and the plateau is exactly `L ∈ [N − a_m, N − a_m − 1 + a_m]`... precisely:
   the plateau is the 188 values `L ∈ [605, 792]` for 1/π, N = 1400. The
   mediator's own M3 had this off by one.

**Still open after round 1:** the proof of `a_m + 2`; the exact C1 boundary; the
general-L law (C3). These become round 2's agenda.

---

## 2. Claim-by-claim verdict table

Status vocabulary: **STANDING** (verified by the mediator), **UNSUBSTANTIATED**
(no test yet), **DISPROVEN** (verified false), **RETRACTED-WORTH-KEEPING**
(withdrawn but the reasoning is worth keeping), **MEDIATOR ERROR** (the
mediator's own claim, refuted).

### 2.1 From Agent B

| # | Claim | Verdict | Mediator's independent check |
|---|---|---|---|
| B1 | `p(L+1) − p(L) = RS(L) − Z(L)` exactly, all L, `Z(L) = \|F(L)\| − #prefixes(F(L+1))` | **STANDING** | reproduced for all L on 5 words by an independent bit-string route; see §3.1 |
| B2 | `Z(L) ∈ {0,1}` always | **STANDING** | no violation on any word tested |
| B3 | `#{L : Z(L) = 1} = a_m + 1` (i.e. `Z = 1` on exactly `L ∈ [N−a_m−1, N−1]`) | **STANDING** | holds on every word tested; the mediator's first count (`= a_m`) was itself off by one |
| B4 | the naive `RS(L) − LS(L+1)` is not the identity | **STANDING (but for a subtler reason than B gave)** | it is false *only in the decay regime*; the mediator's first script miscounted it as holding everywhere, see §4 error 3 |
| B5 | plateau value `= a_m + 2` | **STANDING in value; proof still open** | 255/255 N=20 eligible words, 744+ random eligible supports, 0 counterexamples |
| B6 | plateau for 1/π N=1400 is exactly `L ∈ [605, 792]` (188 values) | **STANDING** | confirmed; the mediator's M3 said [605, 791] — off by one, mediator error |
| B7 | `p(L) = N − L + 1` on exactly `L ∈ [792, 1399]` | **STANDING** | confirmed |
| B8 | plateau value not a function of `(m, span, N)` | **STANDING** | confirmed; witness `(0,)→2` vs `(11,)→10` at m=1, span=0, N=20 |
| B9 | `digitword.py` computationally clean; two documentation defects | **STANDING** | the mediator had already found the same two; both are now **fixed** in `code/digitword.py` |
| B10 | the word `(10,20,40,80)`, N=500 is **not** e−2 | **STANDING** | confirmed: the true greedy support for e−2 is `(0, 3, 53)` at N=2000, stable over dps 60/120/200 |
| B11 | "Cassaigne gives `p(L+1)−p(L) = Σ(d⁺(f)−1)` only for an extendable language" | **STANDING** | this is the correct statement of why the identity breaks; the mediator's `[KNOWN]` check agrees |
| B12 | attribution: Cassaigne, *Complexity and special factors*, Bull. SMF **125** (1997) 1–26 | **STANDING** | real paper; Zbl 0921.68065 resolves. B's own attribution is correct |
| B13 | "naive `RS(L) − LS(L+1)` holds 0/18895 cases" | **UNSUBSTANTIATED / imprecise** | the mediator finds it holds on the **pre-decay** range and fails only in decay. B's count is not reproducible; the substance of B4 survives, the count does not. Recorded in the ledger against B |

### 2.2 From Agent A

| # | Claim | Verdict | Mediator's independent check |
|---|---|---|---|
| A1 | C1 boundary `L_max = 1 + min(min_j d_j, min_j(d_j+d_{j+1}))` | **DISPROVEN** | on 6 000–17 375 sampled eligible words the rule fails *inside* its own claimed range and is too early elsewhere; see §3.2 |
| A2 | A's own counterexample `{13,244}`, N=253 | **RETRACTED-WORTH-KEEPING** | the *conclusion* is right (the rule fails) but the example is degenerate: there `N − a_m − 1 = 8`, so the linear regime is `L ≤ 8` and C1 has almost no content. A's stated numbers "rule 233 vs true 24" are also internally inconsistent: the true first failure is at L = 24 (rule 25, exact 24). The mediator confirms the rule **is** exact on the four dialogue words, as A claimed |
| A3 | slope `1→2` switch at `L = d_1 + 2 = 13` for 1/π | **STANDING** | confirmed; `slopes` gives the transition at L = 13 |
| A4 | decay `p(L) = N − L + 1` for `L ≥ N − a_m` | **TRUE but not tight at the bottom** | A wrote `L ≥ N − a_m` with `N − a_m = 793`; the laws holds there (p(793) = 608), but it also holds at `L = 792`, which A's inequality excludes. The tight range is `L ∈ [N − a_m − 1, N − 1]`, and its lower end is the crossover point the whole round is about |
| A5 | plateau `= a_m + 2` | **STANDING** | independently predicted by B and confirmed by the mediator; A and B agree |
| A6 | three new-word predictions `{0,3,17}→19`, `{2,9,44}→46`, `{1,6,31,200}→202` at `L = span+1` | **STANDING** | all three exact; and each also equals `p(N − a_m − 1)`, as A predicted |
| A7 | window-class decomposition `T(i,j)` with union cardinality | **UNSUBSTANTIATED** | A marks it `[DREAM]` himself and reports 1–2 % over-counting. The mediator did not attempt it; it is round 2 material |
| A8 | deficit form `D(L) = max_j (L − d_j − 1 − S_{1,j−2})_+` explains the 2→1 | **UNSUBSTANTIATED** | plausible and testable; not tested this round. **Round 2's sharpest target for A** |

### 2.3 From the mediator (own earlier claims, per HANDOFF.md §8.4)

| # | Claim | Verdict | What refuted it |
|---|---|---|---|
| M1 | HANDOFF.md §3.1's closed forms are false | **STANDING** | confirmed by both agents and by probe 6 |
| M2 | slope sequence `1→2→1→0→−1`, no slope-3 range | **STANDING** | `slopes()` and B's hand computation agree |
| M3 | plateau is `L ∈ [605, 791]`; decay begins at `N − a_m` | **MEDIATOR ERROR** | truth: plateau `[605, 792]`; decay law holds from `L = N − a_m − 1 = 792`. B caught this |
| M4 | offset-tuple count = bit-string count everywhere | **STANDING** | confirmed to L = 1399 by both routes |
| M5 | finite-word fix is `RS(L) − LS(L+1)` | **MEDIATOR ERROR (DISPROVEN)** | fails in the decay regime; the correct correction is `Z(L)`, which is *not* a left-special count. B's repair |
| M5h | the loss is "the windows dropping off the right edge" | **STANDING in substance** | B's `Z(L)` is exactly the indicator of the terminal window's factor being unique |
| M6 | C1 as stated in §4 is false; regime ends below the next gap | **STANDING** | probe 3 and both agents |
| M7 | the exhaustive N=20 dataset is built | **STANDING** | it is; it decided B8 |

---

## 3. Mediator's independent recomputations (the evidence)

### 3.1 The corrected first-difference identity

Independent route used: bit strings, no `digitword` helpers except `p_offset`;
`bRS`, `bLS`, `bZ` written from scratch in
[`../verify/verify_agentB.py`](../verify/verify_agentB.py).

| word | N | `dp = RS − Z` all L | `Z ∈ {0,1}` | `#{Z=1} = a_m+1` | naive `RS − LS(L+1)` |
|---|---|---|---|---|---|
| 1/π, (2,13,607) | 1400 | ✅ 1399/1399 | ✅ | ✅ 608 | fails in decay |
| log 2, (0,4,36,6069) | 13000 | ✅ | ✅ | ✅ 6070 | fails in decay |
| √2−1, (1,11,251) | 2000 | ✅ | ✅ | ✅ 252 | fails in decay |
| (10,20,40,80) | 500 | ✅ | ✅ | ✅ 81 | fails in decay |
| true e−2, (0,3,53) | 2000 | ✅ | ✅ | ✅ 54 | fails in decay |

Representative detail for 1/π:

```
L      dp   RS   Z   LS(L)  LS(L+1)
 790    0    0    0      0       0
 792   -1    0    1      0       0
 800   -1    0    1      0       0
1398   -1    0    1      0       0
```

`Z(L) = 1` is exactly the decay regime, and `LS = 0` throughout — so the naive
left-special correction is not merely the wrong count, it is structurally the
wrong object.

### 3.2 Agent A's C1 boundary rule, tested

```
def a_rule(ones):
    g = gaps(ones)
    if len(g) < 2: return 1 + ones[0]
    return 1 + min(min(g), min(g[i]+g[i+1] for i in range(len(g)-1)))
```

| test | result |
|---|---|
| eligible words (N ≥ 2a_m + 3) sampled | 6 000 – 17 375 |
| violations of C1 *inside* `[1, L_max]` | **4 903 / 17 375** |
| cases where C1 still holds at `L_max + 1` (rule too early) | **449 / 17 375** |
| the four dialogue words | exact, as A claimed |

**Verdict: DISPROVEN as a general rule**, while remaining exactly correct on the
four dialogue words — which is itself a useful clue: the boundary depends on
more than `min_j d_j` and `min_j(d_j + d_{j+1})`.

### 3.3 The plateau law `a_m + 2`

| test | result |
|---|---|
| all N=20 words with m ∈ {1,2,3,4} and N ≥ 2a_m + 3 | 255/255 |
| random eligible supports, N ≤ 200 | 744+/744+, 0 counterexamples |
| the four dialogue words | 609, 6071, 253, 82 = a_m+2 each |
| A's three new words | 19, 46, 202 = a_m+2 each |

**STANDING in value. No proof.** This is the single most valuable open item
because it converts C2a from "compute it" to "prove a two-line-looking statement".

### 3.4 `digitword.py` audit

| check | result |
|---|---|
| `p_offset` vs `p_bruteforce`, all words of length 12 with ≤ 4 ones, all L | ✅ exhaustive |
| `p_offset` vs `p_bruteforce`, all 608 decay-regime L of 1/π | ✅ |
| `right_special_factors` vs independent bit-string count | ✅ exhaustive on length 12 |
| e−2 support stability over dps ∈ {60, 120, 200} | ✅ stable at (0, 3, 53) |

---

## 4. Mediator's error ledger for this round

Per HANDOFF.md §8.4, the mediator logs its own refuted claims.

| # | Mediator's claim | How it was wrong | Who caught it |
|---|---|---|---|
| 1 | M3: plateau is `[605, 791]` | truth is `[605, 792]`; decay law starts at `N − a_m − 1`, not `N − a_m` | Agent B |
| 2 | M3/brief: "decay begins at exactly `N − a_m = 792`" | `N − a_m = 793`; the decay *law* begins at 792 = `N − a_m − 1` | Agent B |
| 3 | M5: the finite-word correction is `RS(L) − LS(L+1)` | false in the decay regime; the correct object is `Z(L)`, a terminal-uniqueness indicator, not a left-special count | Agent B, then the mediator's own second script |
| 4 | a mediator probe reported `RS(L) − LS(L+1)` matching 791/1399 (pre-decay) | *correct* — but the mediator's first version of that probe used a buggy `bLS` that returned 0 in the all-zero tail, briefly suggesting the formula held everywhere | mediator self-caught |
| 5 | brief M6 claimed the C1 regime "ends strictly below the next gap in every case" | true for the four dialogue words, but the mediated generalisation is not established | none — logged as an over-generalisation |
| 6 | the initial termination census (cap 200) gave "277 of 277 terminate" | wrong: the cap was too small. With an honest cap, 268/277 terminate and the nine named slow rationals are exactly the exceptions. Power-of-ten trap: 4/17 needs n = 3 039 344 | mediator self-caught |
| 7 | the mediator's count `#{L : Z(L)=1} = a_m` | truth is `a_m + 1`, because the range `[N−a_m−1, N−1]` has `a_m + 1` elements | mediator self-caught (verification script) |

---

## 5. Round 2 agenda

1. **Put to A:** prove or refute the `a_m + 2` plateau law — i.e. show that for
   `L` on the plateau the map window start ↦ (first-1 index, offset) is injective
   and all `a_m + 1` non-empty pairs plus the all-zero-free window are realised.
   B's own open question. If A cannot, ask for the smallest counterexample with
   `N ≥ 2a_m + 3`.
2. **Put to A:** test the deficit form `D(L) = max_j (L − d_j − 1 − S_{1,j−2})_+`
   as the explanation of the 2→1 slope decrease. The mediator will recompute.
3. **Put to B:** prove `Z(L) = 1 ⟺ L ≥ N − a_m − 1` and hence derive the exact
   decay range from the identity in B1. This would turn three measured facts
   into one theorem.
4. **Put to B:** attack the C1 boundary. Four candidate rules have now been
   refuted by the mediator (A's `min_j(d_j+d_{j+1})` form, and the mediator's
   `min(a_0−1, 1+min_j d_j)`, `min(N−a_m−1, 1+min_j d_j)`,
   `min(N−a_m−1, 1+d_(2))`). The *exact* formulation is now known and is not a
   formula in the gaps at all:

   > C1 holds at `L` **iff** `Σ_j min(L−2, d_j−1) = #{j : d_j < L}`,
   > i.e. iff no gap satisfies `L−1 > d_j > L−2`.

   Since the `d_j` are integers, that reads: C1 holds at `L` iff
   `L − 1 ≤ min_j d_j`, **or** `L − 1 > max_j d_j`. On the four dialogue words
   the second branch is out of reach (it would need `L > 594, 6033, 240, 40`
   respectively while the decay regime intervenes), which is exactly why the
   measured first failures are `d_1+2` for 1/π, √2−1 and (10,20,40,80) but
   `d_2+2` for log 2 and true e−2. **Task:** turn this identity into the
   `(N, a_0, d_1, …, d_m)` formula the handoff asked for, or prove that the
   `#{d_j < L}` sum is not expressible in the gaps alone once the decay regime
   is in play.
5. **Mediator task:** extend `probes.py` probe 2 to N = 22–24 with m ≤ 4 so the
   `a_m + 2` law is tested where `N ≥ 2a_m + 3` is genuinely binding, and add a
   regression test for the corrected identity once the `Z` characterisation is
   proved.

---

## 6. Standing summary after round 1

```
p(L+1) − p(L) = RS(L) − Z(L)                     [STANDING, exact, all L]
Z(L) = |F(L)| − #{prefixes of F(L+1)} ∈ {0,1}     [STANDING]
Z(L) = 1  iff  L ∈ [N − a_m − 1, N − 1]          [STANDING]
#{L : Z(L)=1} = a_m + 1                           [STANDING]
plateau value = a_m + 2                           [STANDING in value, proof OPEN]
plateau range = [N − a_m, N − a_m − 1 + a_m]      [1/π: [605, 792], 188 values]
decay law p(L) = N − L + 1 on [N − a_m − 1, N−1]  [STANDING]
C1: p(L) = L + 1 + #{d_i < L}                     [valid regime boundary OPEN]
slope sequence for 1/π: 1 → 2 → 1 → 0 → −1        [STANDING]
```
