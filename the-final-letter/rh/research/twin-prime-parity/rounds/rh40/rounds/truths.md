# rh40 — register of ground truths

**Purpose.** The single place that records what is *actually known* in this
programme, as opposed to what any participant has claimed or what a given round
happened to find. Every entry carries the evidence that establishes it, so that
nothing has to be re-derived and nothing can be quietly promoted.

**Rule for admission (HANDOFF.md §8.4).** An entry is admitted as `VERIFIED`
only if the **mediator** recomputed it independently of both agents, by a route
that does not merely re-run the agent's own script. Every `VERIFIED` entry below
was recomputed in this session with `rh40/code/digitword.py`,
`rh40/verify/probes.py` and `rh40/verify/verify_agentB.py`. A claim with no such
recomputation is marked `INHERITED` (taken from HANDOFF.md on trust) or `OPEN`,
never `VERIFIED`.

**Status vocabulary**

| status | meaning |
|---|---|
| `PROVED` | a written proof exists in this programme, corroborated by exhaustive computation |
| `VERIFIED` | recomputed in this session by the mediator; exact evidence attached |
| `INHERITED` | asserted in HANDOFF.md; **not** rechecked in this session |
| `REFUTED` | verified false; kept so it is not re-proposed |
| `OPEN` | target; no proof and no counterexample |

**Notation.** `N` = truncation length. All arithmetic is exact (`Fraction` for
rationals, mpmath at ≥ 120 dps for irrationals) — never binary floats. `a_0 < … <
a_m` are support positions, `d_j = a_j − a_{j−1}` the consecutive gaps,
`span = a_m − a_0`. "all L" means every `1 ≤ L ≤ N − 1`. `F(L)` is the set of
length-`L` factors, `RS(L)` the count of right-special factors of length `L`.

---

## A. The object

| id | statement | status | evidence |
|---|---|---|---|
| A1 | `p(L) = #{ distinct length-L factors of w }` | — | definition (HANDOFF §2) |
| A2 | `p(L)` is finite for every `L` even though the word is infinite, because the word is finitely supported in every prefix | `VERIFIED` (elementary) | direct |
| A3 | For `x` irrational the process never terminates and `n_{k+1} = ⌈1/r_k⌉ − 2` | `INHERITED` | HANDOFF §2, verified there to index 128 541 453; not recomputed this session |
| A4 | `A(N) = #{n ≤ N : δ_n = 1}`: the **lower** bound `A(N) ≥ log₂ log N − log₂ log(1/x) − 1` | **`PROVED`** (Theorem F: `r_{k+1} ≤ r_k²`) | see K5 in `K_remaining.md` |
| A4b | The matching **upper** bound `A(N) ≤ log₂ log N + O(1)` | `OPEN` — needs `r_{k+1} ≥ c·r_k²` with `c > 0`, unproven; measured ratios as low as 0.028 | K5 in `K_remaining.md` |
| A4c | `⌊log₂ log₂ n_k⌋ = k + O(1)`, i.e. `A(N) = log₂ log N + O(1)` empirically tight | `VERIFIED` | six targets, first 10 indices |
| A5 | For rational `x` the process always terminates | `VERIFIED` | H-section census |

## B. The definition of record, and its equivalence

| id | statement | status | evidence |
|---|---|---|---|
| B1 | **Definition of record.** The factor at window start `t` of length `L` is the offset tuple `{a − t : a ∈ ones, t ≤ a ≤ t+L−1}`; two windows give the same factor **iff** these tuples agree. Hence `p(L) = #{ {a−t : …} : 0 ≤ t ≤ N−L}` | `VERIFIED` | exhaustive, B2 |
| B2 | `p_offset == p_bruteforce` (offset-tuple count equals bit-string factor count) for **every** word of length 12 with 0–4 ones and every `L` | `VERIFIED` | `verify_agentB.py` B-d: 9 528 exhaustive cases, 0 divergences |
| B3 | The same equivalence holds deep in the right-edge decay regime, where a lossy sparse encoding might have diverged: all `L ∈ [792, 1399]` at `N = 1400` | `VERIFIED` | `verify_agentB.py` B-d: 608 cases, 0 divergences |
| B4 | `factor_set` and `p_offset` **raise** on `L > N` instead of silently returning an empty set (defect found by Agent B, fixed) | `VERIFIED` | `code/digitword.py` |

## C. The greedy word itself

| id | statement | status | evidence |
|---|---|---|---|
| C1 | `p(L) = L + 1` for `1 ≤ L ≤ min gap` | `VERIFIED` | `probes.py` probe 3: 2 000/2 000 random trials |
| C2 | `p(L+1) − p(L) = RS(L)` holds for every `L ≤ N − a_m − 2` | `VERIFIED` | `verify_agentB.py` B-a; `probes.py` probe 4 |
| C3 | `Z(L) := \|F(L)\| − #{prefixes of F(L+1)} = #{f ∈ F(L) : f has no right extension inside w}` | `VERIFIED` | `verify_agentB.py` B-a |
| C4 | **Corrected finite-word identity:** `p(L+1) − p(L) = RS(L) − Z(L)` for **every** `L` | `VERIFIED` | `verify_agentB.py` B-a: all L on `(10,20,40,80)` N=500 (499/499) and 400+ sampled L on each of 1/π N=1400, log 2 N=13000, √2−1 N=2000, true e−2 N=2000. **0 failures** |
| C5 | `Z(L) ∈ {0,1}` always | `VERIFIED` | same run, 0 violations |
| C6 | `Z(L) = 1` **iff** `L ∈ [N − a_m − 1, N − 1]`; equivalently `#{L : Z(L)=1} = a_m + 1` | `VERIFIED` | `verify_agentB.py` B-a/B-b: exact profile on 1/π (792…1399) and exact count on `(10,20,40,80)` (81 = 80+1) |
| C7 | `LS(L) = 0` for all `L`: **the standard left-special count is identically zero** on these words, so a left-special correction to C2 is structurally the wrong object | `VERIFIED` | `verify_agentB.py` B-a, independent bit-string `bLS` |
| C8 | The word is finitely supported and eventually zero, hence **non-recurrent**, hence not Sturmian; `p(L) = L + 1` for all `L` is therefore impossible (Morse–Hedlund) | `VERIFIED` (elementary) | `tests/...::test_disproven_formulas_fail` |
| C9 | The offset-tuple encoding is *lossy* in principle for long `L` (many windows share a sparse offset set) but never actually diverges from the bit-string count on any case tested | `VERIFIED` | B3 |

## D. Coordinate laws and window counts

The elementary bookkeeping every other entry reduces to. These are also the
Tier-1 Lean targets of HANDOFF §8.3.

| id | statement | status | evidence |
|---|---|---|---|
| D1 | **Window count.** `p(L)` counts over `N − L + 1` window starts, so `p(L) ≤ N − L + 1`; and `p(N) = 1`, `p(N−1) = 2` for any finitely supported word | `VERIFIED` | direct; `probes.py` probe 1 |
| D2 | The bound D1 is **never binding** until `L ≥ N − a_m − 1`, where it becomes an equality (E5) | `VERIFIED` | E5, E6 |
| D3 | **Ceiling regime.** For `L ≥ N − a_m − 1` every window meets the support and exactly one factor is lost per unit increase of `L` | **`PROVED`** | K1 Theorem A (Corollary); G2, E5 |
| D4 | **Terminal-window lemma.** `Z(L) = 1` **iff** the terminal window `t = N − L` realises a factor occurring at no other window start | `VERIFIED` | `verify_agentB.py` B-a |
| D5 | **Crossover.** `(a_m + 2) − (N − L + 1) > 0` iff `L > N − a_m − 1`; this is exactly why the plateau ends and the decay begins at `N − a_m − 1` | **`PROVED`** | K1 Theorem A; E1, E5, E7 |
| D6 | **Squaring law.** `r_{k+1} = (1−f)r_k²/(1+(1−f)r_k)` with `f = {1/r_k}` | `VERIFIED` to `\|dev\| < 1e-45` at dps 60 over 60 steps, six irrational targets | `tests/...::test_greedy_squaring_law` |
| D7 | **Rational termination.** Every rational `x` terminates; `θ = π` gives the support `{0,1,4}`; the termination index can be astronomically deep (`4/17` needs `n = 3 039 344`) | `VERIFIED` | H-section |

> **Note on D1.** HANDOFF §8.3 lists `p(L) ≤ N − L + 1` as a Tier-1 Lean target.
> Formalising it is easy and nearly useless; the load-bearing lemma is the
> injectivity statement behind E1.

## E. Saturation: value and range

| id | statement | status | evidence |
|---|---|---|---|
| E1 | **Plateau value `max_L p(L) = a_m + 2`** — a function of the last support position alone | **`PROVED`** — see K1 note below and [`K1_plateau_theorem.md`](../K1_plateau_theorem.md) | `verify_agentB.py` B-c: 255/255 eligible N=20 words, 765 random eligible supports, 0 counterexamples; and 609 = 607+2, 6071 = 6069+2, 253 = 251+2, 82 = 80+2, 55 = 53+2 |
| E2 | The plateau is non-empty when `a_m + 1 ≤ N − a_m − 1`, i.e. `N ≥ 2a_m + 2`; all four dialogue words satisfy it | **`PROVED`** (and E1 is proved) | |
| E3 | The plateau value is **not** a function of `(m, span, N)` | `VERIFIED` | 45/55 keys multi-valued at N=20; witness `(0,)→2` vs `(11,)→10` at `m=1, span=0, N=20` |
| E4 | `max_L p(L) > a_m + 2` is possible **outside** the eligibility condition, so E2 is not decorative | `VERIFIED` | `(30,)`, `N = 34`: max `p = 5` while `a_m + 2 = 32` |
| E5 | **Decay law.** `p(L) = N − L + 1` for exactly `L ∈ [N − a_m − 1, N − 1]` | **`PROVED`** (Corollary of Theorem A) | `verify_agentB.py` B-b; holds contiguously to `p(N−1) = 2` on all four dialogue words |
| E6 | The `p(L) = a_m + 2` plateau **ends** at exactly `L = N − a_m − 1` | **`PROVED`** (the indicator in Theorem A flips there) | 1/π hi=792, log 2 hi=6930, √2−1 hi=1748, (10,20,40,80) hi=419, true e−2 hi=1946 |
| E7 | **The large-`L` law (Theorem A).** For `max(span, a_m+1) ≤ L ≤ N−1`, `p(L) = min(a_m + 1, N − L + 1) + [L ≤ N − a_m − 1]`; the simpler `min(a_m + 2, N − L + 1)` fails exactly on `1 ≤ L ≤ plateau-onset − 1` | **`PROVED`** | `probes.py`; mismatch sets are precisely the prefix `[1, onset−1]` on all seven words tested (1/π, log 2, √2−1, (10,20,40,80), true e−2, (9,25), (5,10)) |
| E8a | **Theorem E (determinacy).** The plateau onset is NOT a function of `(gaps, N)` alone (1 486 of 2 299 keys carry >1 onset at `m+1 ≤ 4`, `6 ≤ N ≤ 24`) but IS a function of `(gaps, N, a_0)` (positive half is a tautology) | **`PROVED`** (the negative half by counterexample, the positive half by construction) | `K_remaining.md` §2.1 |
| E8 | **The plateau onset has no formula found so far.** Measured onsets 605, 6065, 250, 60, 53. Candidates tested and **refuted**: `a_{m−1}+1`, `N − 2a_m − 2`, `a_m + 2 − #distinct gaps`, `N − a_m` | `OPEN` | all four fail on ≥3 of 5 words; on 375 random eligible supports `a_{m−1}+1` fails in 284 |

## F. The C1 / prefix regime

| id | statement | status | evidence |
|---|---|---|---|
| F1 | **Theorem D.** `p(L) = L + 1` for `L ≤ min(min_j d_j, a_0, N − a_0 − 1)`, i.e. the C1 law in the regime where `#{j : d_j < L} = 0` | **`PROVED`** — verified unconditionally on 399 486 cases, 0 counterexamples | `probes.py` probe 3: 2 000/2 000 random trials |
| F2 | The C1 regime extends **strictly below the next gap**, so HANDOFF §4's statement (`0 < L ≤ min_j d_j`) badly understates it. Measured first failures: `L = 13` (1/π, gap 11), `34` (log 2, gaps 4,32,6033), `12` (√2−1 and (10,20,40,80)), `51` (true e−2, support (0,3,53), N = 2000) | `VERIFIED` | `verify/c1_first_failure.py` (added 2025-10-06: probe 3 tests random supports, not these words, and the regression test's "e-2" entry is the dialogue word (10,20,40,80)); `tests/...::test_c1_holds_beyond_min_gap_and_ends_below_next_gap` |
| F3 | **Exact formulation.** C1 holds at `L` **iff** `Σ_j min(L−2, d_j−1) = #{j : d_j < L}`, i.e. iff no gap satisfies `L−1 > d_j > L−2`; as the `d_j` are integers this reads *`L − 1 ≤ min_j d_j` or `L − 1 > max_j d_j`* | `VERIFIED` (derivation + spot checks) | from the class decomposition: for `L ≤ a_0+1` the count of non-all-zero offset classes is `min(L, a_0) + 1 + Σ_j min(L−2, d_j−1)` |
| F4 | **No closed form in the gaps alone has been found.** Refuted candidates: A's `1 + min(min_j d_j, min_j(d_j+d_{j+1}))` (4 903 violations *inside* its own claimed range and 449 too early over 17 375 sampled eligible words); `min(a_0−1, 1+min_j d_j)`; `min(N−a_m−1, 1+min_j d_j)`; `min(N−a_m−1, 1+d_(2))` | `REFUTED` (all four) | `verify_agentB.py` A-a1; sweeps |
| F5 | For 1/π the first failure is at `L = d_1 + 2 = 13`; for log 2 it is at `L = d_2 + 2 = 34`; for true e−2 (support (0,3,53)) it is at `L = 51 = d_2 + 1`, **not** `d_2 + 2`. **Which gap governs is not determined by the gaps alone** | `VERIFIED` as measurement, rule `OPEN` | `verify/c1_first_failure.py` (added 2025-10-06; `probes.py` probe 3 tests random supports) |

## G. Exact numbers for named words

### G.1 x = 1/π — support `(2, 13, 607)`, `N = 1400`

| id | statement | status | evidence |
|---|---|---|---|
| G1 | The HANDOFF §3.1 table: `p = 2, 6, 11, 12, 14, 16, 18, 19, 24, 54, 104, 304, 597, 598, 609` at `L = 1, 5, 10, 11, 12, 13, 14, 15, 20, 50, 100, 300, 593, 594, 605` | `VERIFIED` | `code/digitword.py` self-check; `probes.py` probe 6 |
| G2 | Slope runs `(L_start, L_end, p(L+1)−p(L))` = `(1,10,1)`, `(11,13,2)`, `(14,604,1)`, `(605,791,0)`, `(792,1399,−1)` | `VERIFIED` | `slopes()`; `probes.py` probe 6 |
| G3 | `RS(L)` for `L ≤ 699` runs `1` on `[1,10]`, `2` on `[11,13]`, `1` on `[14,604]`, `0` on `[605,699]` — i.e. `RS(L)` equals the slope wherever `Z(L) = 0`, exactly as C4 requires | `VERIFIED` | `probes.py` probe 4 |
| G4 | Plateau is exactly `L ∈ [605, 792]`, `p = 609 = a_m + 2`, 188 values | `VERIFIED` | `verify_agentB.py` B-b |
| G5 | `p(L) = N − L + 1` on exactly `L ∈ [792, 1399]`; `p(1398) = 3`, `p(1399) = 2` | `VERIFIED` | `verify_agentB.py` B-b |

### G.2 The other dialogue words

| id | word | `N` | `a_m` | max `p` | plateau `L`-range | decay from |
|---|---|---|---|---|---|---|
| G6 | log 2, `(0, 4, 36, 6069)` | 13000 | 6069 | 6071 | [6065, 6930] | 6930 |
| G7 | √2−1, `(1, 11, 251)` | 2000 | 251 | 253 | [250, 1748] | 1748 |
| G8 | `(10, 20, 40, 80)` | 500 | 80 | 82 | [60, 419] | 419 |
| G9 | **true e−2 is `(0, 3, 53)` at `N = 2000`** (stable at dps 60/120/200); `(10, 20, 40, 80)` is **not** e−2 | 2000 | 53 | 55 | [53, 1946] | 1946 |

All rows `VERIFIED` by `probes.py` probe 1 and `verify_agentB.py` B-b/B-e.

### G.3 Single-one words

| id | statement | status | evidence |
|---|---|---|---|
| G10 | For one 1 at position `a` with `N ≥ 2a + 4`: `p(L) = min(L, a+1) + 1` for `L ≤ N − a − 1`, and `p(L) = N − L + 1` for `L ≥ N − a − 1` | `VERIFIED` | first half exact on **all** `1 ≤ a < 60, N < 120` (239 599/239 599); combined law has **zero** counterexamples for `1 ≤ a < 40, N ≥ 2a + 4` |
| G11 | In the degenerate sliver `N < 2a + 4` the halves do **not** simply patch together | `VERIFIED` | e.g. `a=1, N=3, L=1`; recorded, not chased |

## H. Rational termination

| id | statement | status | evidence |
|---|---|---|---|
| H1 | **All 277** reduced `p/q` with `q ≤ 30` terminate. At cap `5·10⁶`, 275 of 277 are reached; the two that need more are `4/25` (index **53 307 974**) and `27/29` (index **1 003 066 151**), both now resolved exactly | `VERIFIED` | census at cap 5·10⁶ (20 s) plus targeted runs for the two stragglers |
| H2 | Deepest termination indices below 5·10⁶: `4/17 = 3 039 344`, `14/19 = 2 359 419`, `7/23 = 1 019 083`, `9/29 = 648 787`, `21/23 = 644 045`, `17/19 = 375 971`, `12/29 = 320 072`, `19/23 = 138 459`; and the two extremes `4/25 = 53 307 974`, `27/29 = 1 003 066 151` | `VERIFIED` | censuses + targeted runs (the 27/29 run took 1130 s) |
| H3 | **The count is a cap artefact, not a fact about the rationals.** At cap 200 000 all 277 "terminate"; at cap 5·10⁶, 275 do; at cap 2·10⁹, all 277 do with deepest index `27/29 = 1 003 066 151`. HANDOFF §8.2's "268 of 277" reproduces at cap ≈2·10⁶ and nowhere else — it is a statement about the search budget, not about termination | `VERIFIED` | censuses at caps 2·10⁵, 2·10⁶, 5·10⁶, 2·10⁹ |
| H4 | `θ = π` (i.e. `x = 1`) terminates with exactly the support `{0, 1, 4}`; `1/2 + 1/3 + 1/6 = 1` | `VERIFIED` | exact `Fraction` loop |
| H5 | A float run gives the spurious support `[0,1,5,41,1805]` for `θ = π`; exact rationals are mandatory | `INHERITED` | HANDOFF §8.1; not reproduced this session |

## I. Verified constants

| id | statement | status | evidence |
|---|---|---|---|
| I1 | `ζ(3)/ζ(6) = 1.18156494901…` | `VERIFIED` | mpmath at dps 25 |
| I2 | `p* = 1.728647239…` where `ζ(p*) = 2` | `VERIFIED` | `mp.findroot` at dps 25 |
| I3 | Mertens `= γ + Σ_{p ≤ 10⁶}[log(1−1/p) + 1/p] = 0.261497246736…` (78 498 primes) | `VERIFIED` | sympy `primerange` + mpmath at dps 25 |
| I4 | `∫₀¹ log(1−f) df = −1` exactly — A's scaling-limit value is correct **as an integral** | `VERIFIED` | `probes.py` probe 5 |
| I5 | **The number of usable residual-orbit steps is logarithmic in the working precision.** For `x = 1/π`: dps 60→7 steps, 120→8, 200→9, 400→10, 800→11, 1600→12, 3200→13, i.e. `steps ≈ 2 + log₂(dps)`. Step `k` squares the residual, so it needs `~2^k` digits | `VERIFIED` | 7 precisions |
| I6 | **HANDOFF §6.5's protocol is unachievable.** It asks for "~40–50 steps" per target. By I5 that needs `2^38`–`2^48` **decimal digits** (≈10¹²); at 3200 dps only 13 steps survive. `A(N) = log₂ log N` is consistent with this squaring growth | `VERIFIED` | I5 + arithmetic |
| I7 | Consequently the residual-orbit limit question (K6) **cannot** be settled by directly iterating a fixed-precision `x`: the iteration runs out of digits long before any average can stabilise. Any treatment must work with the exact squaring map symbolically | `VERIFIED` as an obstruction | follows from I5/I6 |
| I8 | The finite-`r` means are **not** `−1`; but this was measured on runs of only 7–13 steps before underflow, so no convergence claim follows either way | `OPEN` | `probes.py` probe 5; limited by I6 |

## J. Refuted laws — do not re-propose

Each was refuted by exact enumeration. The **true first failure** is given where
the handoff's recorded witness does not reproduce — those two are starred.

| id | law | verdict | true first failure / counterexample |
|---|---|---|---|
| J1 | `p(L) = L + 1 + #{pairs of 1s at distance ≤ L}` | `REFUTED` | 1/π `L = 11` (law 13, truth 12); log 2 **`L = 4`** (6 vs 5) — ★HANDOFF §5 wrongly records log 2 at `L = 6` (both sides give 8) |
| J2 | `p(L) = L + 1 + #{distinct distances ≤ L}` | `REFUTED` | 1/π **`L = 11`** (13 vs 12) — ★HANDOFF §5 wrongly records `L = 12` (both sides give 14) |
| J3 | `p(L) = L + 1 + Σ_i (L − d_i)_+` | `REFUTED` | 1/π `L = 20` (30 vs 24) |
| J4 | `p(L) = 2L − 10` on `12 ≤ L ≤ 593`, `3L − 603` on `594 ≤ L ≤ 604` (HANDOFF §3.1) | `REFUTED` | 1/π `L = 15` (20 vs 19); `L = 100` (190 vs 104); `L = 593` (1176 vs 597) |
| J5 | B's triple `(index of first 1, its offset, number of further 1s)` classifies factors | `REFUTED` | `{19,50,83}`, `L = 1`: triple gives 4, truth 2 |
| J6 | `p(L) = min(L + span, N − L + 1)` (model D) | `REFUTED` | `{139,151}`, `N = 172`, `L = 13`: 25 vs 15 |
| J7 | `p(L) = L + 1` for all `L` (Sturmian-like) | `REFUTED` | impossible — the word is finitely supported, so non-recurrent; Morse–Hedlund forbids it |
| J8 | The finite-word fix is `p(L+1) − p(L) = RS(L) − LS(L+1)` | `REFUTED` | fails for every `L` with `Z(L) = 1`, i.e. all of `[N − a_m − 1, N − 1]`; `LS ≡ 0` (C7) so the term does nothing |
| J9 | `p(L) = min(L + 1 + #{d_i < L}, N − L + 1)` | `REFUTED` | 1/π `L = 13` (15 vs 16) — fails across the whole saturation-onset range `L = 13 … 604` |
| J10 | `p(L) = min(a_m + 2, N − L + 1)` for **all** `L` | `REFUTED` | fails exactly on `L = 1 … onset − 1` (604 values for 1/π), per E7 |
| J11 | Plateau onset `= a_{m−1} + 1` | `REFUTED` | `(9,25)`, `N = 70`: onset 26 vs 10; 284/375 random eligible supports fail |
| J12 | Plateau onset `= a_m + 2 − #distinct gaps` | `REFUTED` | 1/π 605 vs 607; (10,20,40,80) 60 vs 79 |
| J13 | C1 boundary `= 1 + min(min_j d_j, min_j(d_j + d_{j+1}))` (Agent A, round 1) | `REFUTED` | 4 903 violations inside its own claimed range, 449 too early, over 17 375 sampled eligible words; exact on the four dialogue words only |
| J14 | "`p(L)` saturates on `[span, N]`" (HANDOFF §3.3) | `REFUTED` | only true on the plateau `[onset, N − a_m − 1]`; outside it `p` is not constant, and past it `p` strictly decreases |
| J15 | The A(N) asymptotic, the `p*` threshold, the zeta bridge | see HANDOFF §10 | not to be reopened; four independent obstructions established with numbers |

## K. Open problems, ranked

| id | problem | state | evidence |
|---|---|---|---|
| ~~K1~~ | ~~Prove `max p = a_m + 2` on the plateau~~ | **CLOSED** — `PROVED` this session, [`K1_plateau_theorem.md`](../K1_plateau_theorem.md). Crux: the maximum offset of a factor containing `a_m` is `a_m − t`, which recovers `t`, so the windows containing `a_m` give `a_m+1` distinct factors; bookkeeping then gives `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` | |
| K2 | **The plateau onset** | **PARTIAL**: **Theorem E** — the onset is *not* a function of `(gaps, N)` (1 467 counterexamples) but *is* a function of `(gaps, N, a_0)`; no closed form, and E8/J11/J12 now have retro-explanations | |
| K3 | **The C1 boundary** | **PARTIAL**: the regime `L ≤ min(min_j d_j, a_0, N−a_0−1)` is **PROVED** (Theorem D); the *boundary* remains open and now has **six** refuted candidates (J13 + five of mine) | |
| K4 | **The general-`L` law** | **PARTIAL**: the exact `(S, x)` encoding is verified on 297 910 cases; the sum-of-intervals form is **refuted** (overcounts up to 14 / 41); no closed form | |
| K5 | **The exact growth of `A(N)`** | **PARTIAL**: `Ω(log log N)` **PROVED** (Theorem F); `O(log log N)` open (needs a two-sided squaring law). Empirically tight (A4c) | |
| K6a | **The `u`-map.** With `u = 1/r_k`, `q = ⌈u⌉`, `s = q − u`: `u_{k+1} = q²/s − q` exactly | **`PROVED`** (algebra) + verified on 8 rational seeds × 25 steps, 0 mismatches | `verify/verify_agentK6.py` |
| K6b | **The induced map** on `s = 1−f`: `s_{k+1} = 1 − {q²/s}` | **`VERIFIED`** exactly on rationals; and it is **not** the Gauss map `s ↦ 1−{1/s}` (max deviation 0.91) | same |
| K6c | **The density.** Given the digit `q`, `s` has density `μ_q(s) = q(q−1)/(q−s)² → 1` (Lebesgue), **not** Gauss–Kuzmin (`L¹` distance 0.172 at `q = 10⁶`) | **`VERIFIED`** (normalisation exact; `L¹` distance computed) | same |
| K6d | `E[log s_k \| q_k] = −1 + 1/(2q_k) + O(1/q_k²)` | **`VERIFIED`** to 12+ digits for `q ≤ 10⁶` | same |
| K6e | **Correction term.** `log c_k − log s_k = −log(1+s_k r_k)`, and `Σ r_k ≤ Σ 1/(q_k−1) < ∞`, so `Σ[log c_k − log s_k]` converges absolutely | **`PROVED`** + verified | same |
| K6f | **REFUTATION of x-independence.** `q_0 = 4`, `q_{k+1} = 2q_k²` is Sylvester-admissible and gives `s_k → 1/2`, hence `(1/K)Σ_{k<K} log c_k → log(1/2) = −0.693147… ≠ −1` | **`PROVED`** — reproduced by the mediator both backward (exact relation) and by the **forward** greedy map from `x = Σ1/q_k` | same |
| K6g | The achieved limits are exactly `(−∞, 0]` (so `Σ log c_k` is bounded for some `x` and unbounded for others) | **`PARTIAL`** — `s* = 1/2` and `s* = 0.1` reproduced; `s* = 0.9, 0.99` did **not** reproduce under `q_{k+1} = ⌊q_k²/s*⌋`. The *weaker* conclusion (limits are not unique) is proved by K6f | same |
| K6h | A family with no limit at all (prescribed blocks) | `[CONJECTURE]` — not reproduced by the mediator | — |
| K6i | For `x` uniform on `(0,1)`: `E[(1/K)Σ log c_k] = −1 + O(1/K)` (`L¹`) | **`PROVED`** (Agent B; mediator verified the density input K6c/K6d) | same |
| ~~K6~~ | ~~the limit is independent of `x`~~ | **`REFUTED`** (K6f) | same |
| K6j | a.e. convergence to `−1` | `CONJECTURE` (modulo the stated expanding-map correlation lemma, which is not written out) | — |
| K7a | Termination threshold for `α_n = (n+2)^{−p}`, unit target: terminates iff `ζ(p) ≥ 2`, `p* = 1.72864723899818362` | **`VERIFIED`** (mediator) — and **target-dependent**: for `x = 1/2` the threshold is the root of `ζ(p) = 3/2`, `p = 2.18528545178748223` | `K_remaining.md` §5.1 |
| K7b | ~~the family's word is `1^{N(p)}0^∞`, so every gap is 1 for every `p`; `α_n=(n+2)^{−3/2}` is a witness with max gap 1~~ | **`REFUTED`** — for `p = 3/2` the orbit is `{0..8, 34, 954, 77716, …}` with gaps 25, 919, 76 761, … **unbounded**. `N(p)` ends the *initial segment*, not the orbit: since `α_k → 0`, the residual keeps selecting a tail | §5.2 |
| K7f | **Corrected structure theorem** for `α_n=(n+2)^{−p}`, `x=1`, `p>1`, `S=ζ(p)−1`: `S<1` → `1^∞`, all gaps 1, never halts; `S=1` → `1^∞`; `S>1` (`1<p≤p*`) → **never halts**, unbounded gaps | **`PROVED`** — the third case because `r>0` is fixed while `α_k → 0`, so `{k : α_k ≤ r}` is an infinite tail and the residual never reaches 0 | §5.3 |
| K7c | **"bounded gaps OR exact termination, never both"** | **`REFUTED`** — `α_n = 2^{−(n+1)}`, `x = 1`, verified in exact `Fraction`s: taken `{0,1,2,…}` with max gap 1, residual `2^{−(n+1)} → 0` exactly | §5.4 |
| K7d | Within the power family: `p ≤ 1` no termination / `1 < p ≤ p*` **no termination either, with unbounded gaps** / `p > p*` no termination, gaps 1 | **`VERIFIED`** (max gaps 76 762 at `p=1.5`; 795 962 at `p=1.7`) | §5.3 |
| K7e | **Any terminating alphabet has finite support, hence `max_L p(L) = a_m + 2`; so no terminating alphabet can realise `p(L) = cL`** | **`PROVED`** — direct from K1's Theorem A, and alphabet-independent | §5.4 |
| K7 | **C4, the inverse problem** | **PARTIAL/CLOSED NEGATIVELY** — the non-existence half is proved (K7e); the constructive half (which `p` *are* realisable) is open | — |

**Honest summary.** **K1 is closed** (see [`K1_plateau_theorem.md`](../K1_plateau_theorem.md)):
`max p = a_m + 2` is now proved, together with the full large-`L` law
`p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]` for `L ≥ max(span, a_m+1)` and the decay
law as a corollary. K2–K7 remain open. Of the remaining entries, the `PROVED` ones
are E1, E5, E6, E7 and D3, D5; everything else is a finite computation, with the
single numerical exception D6 (the squaring law), verified to 45 digits but not
proved symbolically. Note that Theorem A is **combinatorial, not arithmetic**: it
holds for every finitely supported 0/1 word, so it explains the plateau without
using the greedy structure at all.

## L. How to re-verify this file

```bash
cd /Users/victor/workspace/rh
python3 rh40/code/digitword.py                  # G1 table, G2 slope runs
python3 rh40/verify/probes.py --only 1 3 4 6    # D1/D3, F1/F2, C2/G3, J4
python3 rh40/verify/verify_agentB.py            # C2–C7, E1–E3, B2–B3, G9, J13  (~2 min)
python3 -m pytest -q rh40/tests/ -m "not slow"  # the fast gate, 15 tests (~55 s)
```

Anything in this file that cannot be reproduced by one of those four commands is
mis-filed and should be moved to `OPEN` or `INHERITED`. The I5–I7 entries came
from a one-off harness; they are re-derivable from `probes.py` probe 5 by
sweeping `dps`.
