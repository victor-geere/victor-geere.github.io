# rh40 — the factor-complexity law of the greedy digit word

**Programme opened:** this session, from [`HANDOFF.md`](rounds/truths.md) *(rh40 has no HANDOFF.md; its ledger is `rh40/rounds/truths.md`)*.
**Working directory:** `/Users/victor/workspace/rh`.
**Status:** active. **Round 1 complete** — see [`rounds/round01.md`](rounds/round01.md). Round 2 queued (agenda in `round01.md` §5).

---

## 1. Objective

Determine the exact **factor-complexity function** of the greedy harmonic digit
word, per HANDOFF.md §2–§4:

> Given x ∈ (0,1) and the greedy digit word w(x) = δ₀δ₁δ₂… produced by
> `r_n ≥ 1/(n+2) ⟹ δ_n = 1, r_{n+1} = r_n − 1/(n+2)`, find the exact value of
>
> ```
> p(L) = #{ distinct factors of length L in w }
> ```
>
> as a function of the support positions 0 ≤ a₀ < … < a_m < N and the truncation
> length N.

Sub-targets, from HANDOFF.md §4: **C1** the prefix (linear) regime, **C2a** the
saturation plateau value, **C2b** the right-edge decay, **C3** the general
piecewise structure, **C4** the inverse problem (nice-to-have).

## 2. Environment readiness (checked at programme open)

| Component | Status |
|---|---|
| Python | **3.13.13** (conda-forge, `/opt/homebrew/Caskroom/miniforge/base/bin/python3`) |
| numpy | **2.5.0** ✅ |
| mpmath | **1.3.0** ✅ (exact high-precision word construction) |
| pytest | **9.1.1** ✅ |
| sympy | **1.14.0** ✅ (used for the Mertens prime sum) |
| scipy | not installed — **not needed**; no programme code imports it |
| Lean 4 / lake | `/Users/victor/.elan/bin/`, toolchains v4.14.0 and v4.33.1 present |
| Mathlib | **fetched** at `leandev/.lake/packages/mathlib` (that directory is no longer present in this checkout; toolchain v4.35.0-rc2) — this removes the §8.3 blocker, but see §7 below |

**Verdict: Python is ready, no setup was required.** The `fractions` and
`decimal` modules are stdlib and present; all word construction uses `Fraction`
or mpmath at ≥ 120 dps, never binary floats (HANDOFF.md §8.1).

## 3. Why this programme exists

`HANDOFF.md` closed a ten-round mediated A/B dialogue on the residual-orbit
problem and left the complexity law open, as a finite combinatorial problem with
three attack routes: finite enumeration, a saturation argument, and (for the
combinatorial core) Lean. `rh40` runs that attack with the same protocol:

* **Agent A** — the professor (delusional beyond the frontier, exact on
  literature, known to fail on every asymptotic).
* **Agent B** — the auditor (rigorous, runs code, tries to break the ground
  truth itself).
* **The mediator** (the main agent) — recomputes **every** computable claim of
  both, independently, before anything is recorded. Non-negotiable: nothing
  enters the journal without an independent recomputation (HANDOFF.md §8).

## 4. Corrections established at programme open

The mediator recomputed the handoff before launching any agent, and found three
defects in it. All are verified by exact enumeration and are now regression-locked
in [`tests/test_complexity.py`](tests/test_complexity.py).

**M1 — HANDOFF.md §3.1's closed forms are false.** The table of measured values
is right; the extrapolated piecewise law beneath it is not.

| L | §3.1's law | exact |
|---|---|---|
| 15 | 20 | **19** |
| 20 | 30 | **24** |
| 100 | 190 | **104** |
| 593 | 1176 | **597** |

§5 had already recorded this law as "partly true, over-extrapolated"; §3.1
nevertheless prints it as *the* law. A and B were told not to quote it.

**M2/M3 — the true structure is five-piece with a non-monotone slope.** For
x = 1/π, N = 1400:

```
p(L+1) − p(L) =  1   for L ∈ [1, 10]      (p(L) = L + 1 on 1 ≤ L ≤ 11)
              =  2   for L ∈ [11, 13]
              =  1   for L ∈ [14, 604]    <-- the slope DECREASES back to 1
              =  0   for L ∈ [605, 791]   <-- the plateau: p(L) = 609
              = −1   for L ∈ [792, 1399]  <-- the right-edge decay
```

There is **no** range with slope 3, and the slope is not monotone. The
saturation plateau is exactly the 188 values **L ∈ [605, 792]** on which
p(L) = 609, and the decay begins at exactly **L = N − a_m − 1 = 792**, where
p(L) = N − L + 1 = 609 — so the decay law holds on the closed range
**L ∈ [792, N − 1]**, verified for every one of the four dialogue words:

| word | N | a_m | `p(L) = N − L + 1` holds on | begins at L = N − a_m − 1 |
|---|---|---|---|---|
| 1/π, {2,13,607} | 1400 | 607 | [792, 1399] | 792 |
| log 2, {0,4,36,6069} | 13000 | 6069 | [6930, 12999] | 6930 |
| √2−1, {1,11,251} | 2000 | 251 | [1748, 1999] | 1748 |
| e−2, {10,20,40,80} | 500 | 80 | [419, 499] | 419 |

and it holds contiguously all the way to L = N − 1, where p = 2.

**Plateau value = a_m + 2.** On the plateau p(L) = a_m + 2 exactly: 607+2 = 609,
6069+2 = 6071, 251+2 = 253, 80+2 = 82. Agent B verified this on 255/255 N = 20
words and 744/744 random supports satisfying N ≥ 2a_m + 3, with zero
counterexamples; it is a function of **a_m alone**, which is why the handoff's
attempt to read it off `(m, span, N)` could not work. The `a_m + 2` form is
verified but **not yet proved** — the proof is round 1's open item.

**M6 — C1 as stated in §4 is false, and the real boundary is not the min gap.**
`p(L) = L + 1 + #{d_i < L}` actually holds far beyond `L ≤ min_j d_j`:

| word | gaps | C1 holds for | first failure |
|---|---|---|---|
| 1/π | (11, 594) | L ≤ 12 | L = 13 → 16 (C1 says 15) |
| log 2 | (4, 32, 6033) | L ≤ 33 | L = 34 → 38 (C1 says 37) |
| √2−1 | (10, 240) | L ≤ 11 | L = 12 → 15 (C1 says 14) |
| e−2 | (10, 20, 40) | L ≤ 11 | L = 12 → 15 (C1 says 14) |

In every case the C1 regime ends **strictly below the next gap**, so there is an
unmodelled *saturation-onset* regime between the end of C1 and the plateau — and
that is exactly where the unexplained 2 → 1 decrease happens. The unified
candidate `p(L) = min(L + 1 + #{d_i < L}, N − L + 1)` was tested and **fails** in
precisely that regime (16 vs 18 at L = 14 for 1/π), so the onset is not a simple
`min`.

Agent A's round-1 boundary rule — `L_max = 1 + min(min_j d_j, min_j(d_j +
d_{j+1}))` — was tested by the mediator and is **also false**: on 17 375 random
words satisfying N ≥ 2a_m + 3 it fails *inside* its own claimed range in 4 903
cases, and is too early in 449. A's own counterexample {13,244}, N = 253 is
**outside** the regime where C1 has any content at all (there N − a_m − 1 = 8, so
the linear regime is L ≤ 8). The correct boundary remains **open**; the mediator
reduced it to a single exact statement in `rounds/round01.md`.

**M5 — Cassaigne's identity fails exactly in the decay regime — and the
mediator's proposed correction was wrong.** For 1/π, N=1400,
`p(L+1) − p(L) = #right-special(L)` holds for every L ≤ 604 and fails for all
608 values L ∈ [792, 1399], where the right-special count is 0 but the true
difference is −1. The mediator's naive finite-word fix
`p(L+1) − p(L) = RS(L) − LS(L+1)` was tested and **also fails** (0 of 608).

**Agent B repaired it in round 1, and the mediator has independently reproduced
B's repair.** Define

```
Z(L) := #{ f ∈ F(L) : f has no right extension inside w_N }
      = #{ f ∈ F(L) : every occurrence of f ends at the last position } ∈ {0,1}
```

Then the exact finite-word identity is

```
p(L+1) − p(L) = RS(L) − Z(L)          for every L,
```

verified by the mediator on all four dialogue words for **every** L (5 666
values, 0 failures), against an independent bit-string implementation that shares
no code with `digitword.py`. See [`verify/verify_agentB.py`](verify/verify_agentB.py).
Z(L) is a uniqueness indicator for the terminal window t = N − L, not a count of
windows; it is 0 on [605, 792] and 1 on [792, 1399] for 1/π, which is exactly why
the decay regime is where the classical identity breaks.

**M8 — two counterexamples printed in HANDOFF.md §5 do not reproduce.** §5 is
the "do not re-derive" list, so its counterexamples matter. The mediator
recomputed all of them:

| §5 claim | reproduces? |
|---|---|
| pairs law fails: 1/π, L=11 → 13 vs 12 | ✅ (first failure is exactly L = 11) |
| pairs law fails: 1/π, L=13 → 15 vs 16 | ✅ |
| pairs law fails: log 2, L=6 → 9 vs 8 | ❌ **both sides give 8**; the true first failure for log 2 is L = 4 (pairs 6 vs exact 5) |
| distance law fails: 1/π, L=12 → 13 vs 14 | ❌ **both sides give 14**; the true first failure is L = 11 (distances 13 vs exact 12) |
| `Σ(L−d_i)_+` fails: 1/π, L=20 → 30 vs 24 | ✅ |
| model D fails: {139,151}, N=172, L=13 → 25 vs 15 | ✅ |
| B's triple fails: {19,50,83}, L=1 → 4 vs 2 | ✅ (truth 2) |

The disproofs stand — every law on the list is genuinely false — but two of the
recorded witnesses are wrong, and a regression test that used them would have
passed for the wrong reason. The tests now pin the **true** first failures.

**M9 — the single-one word is completely solved.** For a word with exactly one 1
at position `a` and `N ≥ 2a + 4`:

```
p(L) = min(L, a+1) + 1     for  L ≤ N − a − 1
p(L) = N − L + 1           for  L ≥ N − a − 1
```

The first half is exact on all `a < 60, N < 120`; the combined law has **zero
counterexamples** for `1 ≤ a < 40, N ≥ 2a + 4`. Note this is the same
eligibility condition `N ≥ 2a_m + 3`-ish under which the plateau law `a_m + 2`
holds, which is a real structural hint: the non-degenerate regime is exactly
where the plateau exists. In the degenerate sliver `N < 2a + 4` the closed form
needs extra care and the mediator did not chase it.

## 5. Verified ground truth

**The authoritative register is [`rounds/truths.md`](rounds/truths.md)**, which
lists every verified fact with its status (`VERIFIED` / `INHERITED` / `REFUTED` /
`OPEN`), the evidence, and the exact command that re-proves it. The summary here
is the narrative; `truths.md` is the record.

### 5.0 What is actually proved

**K1 is closed.** `max p = a_m + 2` is now a theorem, with proof
in [`K1_plateau_theorem.md`](K1_plateau_theorem.md). The same theorem gives, for
`L ≥ max(span, a_m+1)`:

```
p(L) = min(a_m + 1, N − L + 1) + [ L ≤ N − a_m − 1 ]
```

which also proves the decay law `p(L) = N − L + 1` on `[N − a_m − 1, N − 1]`
(sub-target **C2b**). The crux is one line: **the maximum offset of any factor
whose window contains `a_m` is `a_m − t`, which recovers the window start `t`** —
so those windows give `a_m + 1` automatically distinct factors, and the rest is
bookkeeping. Corroborated exhaustively on 242 295 (support, L) cases over 36 424 supports, with zero
counterexamples.

Two consequences worth stating plainly:
* **the law is combinatorial, not arithmetic** — it holds for *every* finitely
  supported 0/1 word; the greedy structure only decides which supports occur;
* therefore the handoff's "saturation value needs its own derivation" (§3.3) is
  answered, and the answer does not mention the greedy rule at all.

**K2–K7** are tracked in [`K_remaining.md`](K_remaining.md):

* **K3** — the regime `L ≤ min(min_j d_j, a_0, N−a_0−1)` is **PROVED** (Theorem D,
  399 486 cases, 0 counterexamples); the regime *boundary* remains open, with six
  refuted candidate formulas.
* **K5** — the **lower** bound `A(N) ≥ log₂ log N − log₂ log(1/x) − 1` is
  **PROVED** (Theorem F, from `r_{k+1} ≤ r_k²`). The matching upper bound is open,
  and cannot be reached by a two-sided squaring law: the ratio
  `r_{k+1}/r_k² = (1−f)/(1+(1−f)r_k)` has **no positive lower bound**, since
  `f → 1⁻` drives it to 0 (measured minimum 1.95·10⁻⁴ over exact rationals).
* **K2** — Theorem E settles the determinacy of the plateau onset: it is *not* a
  function of `(gaps, N)` (1 486 of 2 299 keys are multi-valued) but *is* a
  function of `(gaps, N, a_0)`, the positive half being a tautology. No closed
  form.
* **K4** — the exact `(S, x)` encoding is verified for every `L` on 297 910 cases;
  the sum-of-intervals form is refuted (intervals overlap). No closed form.
* **K6, K7** — see [`verify/k6_residual.py`](verify/k6_residual.py) and
  [`verify/k7_alphabet.py`](verify/k7_alphabet.py).


Reproduced exactly in this session by [`verify/probes.py`](verify/probes.py) from
[`code/digitword.py`](code/digitword.py):

* the full §3.1 table (p = 2, 6, 11, 12, 14, 16, 18, 19, 24, 54, 104, 304, 597,
  598, 609);
* the four §3.3 plateau values 609, 6071, 253, 82, **and** their exact L-ranges;
* the offset-tuple count equals the bit-string factor count on every sampled L,
  including deep in the decay regime (L = 800, 1000, 1200, 1390, 1398, 1399) —
  so §3.2 is safe as the definition of record and §3.3's numbers are not
  distorted by it;
* every refuted law of §5 still fails on its recorded counterexample;
* the greedy squaring law to 46+ digits on six irrational targets;
* **the corrected first-difference identity `p(L+1) − p(L) = RS(L) − Z(L)`** on
  five words (1/π, log 2, √2−1, (10,20,40,80) and the true e−2 at (0,3,53));
* the plateau law `max p = a_m + 2`;
* the single-one law
  `p(L) = min(L, a+1) + 1` (for `L ≤ N−a−1`) then `N−L+1` — **not** by
  `verify/probes.py`, which contains no such check (corrected 2025-10-06: the
  earlier line here credited it to `probes.py`, and no script anywhere in the
  repository enumerated it). The enumerator is now
  [`verify/single_one_law_verify.py`](verify/single_one_law_verify.py), written
  independently of `code/digitword.py`, cross-checking two routes (the
  offset-tuple definition of record and explicit bit-string factors) against the
  closed form, with its log at `verify/single_one_law_verify.log`. It reproduces
  the register's **239 599** exactly, under the reading `1 ≤ a < 60`,
  `a < N < 120`, `1 ≤ L ≤ N−a−1` (admitting `a = 0` or `L = 0` gives 251 990,
  also with 0 counterexamples) and 0 counterexamples for the combined law on
  `1 ≤ a < 40, N ≥ 2a+4`;
* **268 of 277** reduced p/q with q ≤ 30 terminate, and the nine exceptions are
  exactly 4/17, 14/19, 17/19, 7/23, 21/23, 4/25, 9/29, 12/29, 27/29 — these need
  n of order 10⁶ to reach zero (4/17 terminates only at n = 3 039 344; 19/23 at
  n = 138 459), so a small search cap produces **false** "non-terminating"
  verdicts. That trap is now a regression test.
* θ = π (x = 1) gives exactly the support {0, 1, 4}, verified with `Fraction`.

## 6. File map

| Path | Contents |
|---|---|
| [`rounds/round01_brief.md`](rounds/round01_brief.md) | round-1 brief: ground rules, M1–M7, the question put to each agent |
| [`rounds/bootup_agentA.md`](rounds/bootup_agentA.md) | Agent A's full persona prompt + round-1 question |
| [`rounds/bootup_agentB.md`](rounds/bootup_agentB.md) | Agent B's full role prompt + round-1 task (parts a–d) |
| [`rounds/round01_agentA.md`](rounds/round01_agentA.md) | A's answer, verbatim |
| [`rounds/round01_agentB.md`](rounds/round01_agentB.md) | B's audit, verbatim |
| [`rounds/round01.md`](rounds/round01.md) | mediator's adjudication and verdict table |
| [`K_remaining.md`](K_remaining.md) | **K2–K7 status**: Theorem D (C1 regime, proved), Theorem E (onset determinacy), Theorem F (`A(N)` lower bound), and the K6/K7 pointers |
| [`K1_plateau_theorem.md`](K1_plateau_theorem.md) | **the proof that `max p = a_m + 2`** (K1 closed) plus the large-`L` law and the decay law as corollaries |
| [`verify/general_law.py`](verify/general_law.py) | the `(S, x)` encoding for **every** `L`, with the interval description of the t-set |
| [`verify/plateau_theorem.py`](verify/plateau_theorem.py) | the exhaustive corroboration: 36 424 supports, 242 295 (support, L) cases, 0 counterexamples |
| [`rounds/truths.md`](rounds/truths.md) | **register of ground truths** — every verified fact, with status, evidence and the exact call that proves it; refuted laws; ranked open problems |
| [`rounds/ledger.md`](rounds/ledger.md) | cumulative error ledger, all participants (20 rows) |
| [`code/digitword.py`](code/digitword.py) | **ground truth**: greedy word, offset-tuple complexity, Cassaigne, slopes |
| [`verify/probes.py`](verify/probes.py) | the §6 numerical targets (probes 1–5) + the §3.1 audit (probe 6). **Does not** contain the single-one-law check that §5 previously credited to it |
| [`verify/single_one_law_verify.py`](verify/single_one_law_verify.py) | the enumerator for register row G10 / §4 M9, added 2025-10-06 (audit repair 5a): the single-one law, both branches, plus its proof. Log: `verify/single_one_law_verify.log` |
| [`verify/single_one_law_verify.py`](verify/single_one_law_verify.py) | the enumerator for register row G10 / §4 M9, added 2025-10-06: the single-one law, both branches, plus the proof of the law. Log: `verify/single_one_law_verify.log` |
| [`verify/verify_agentB.py`](verify/verify_agentB.py) | **the mediator's independent recomputation** of every computable claim of both agents, by a bit-string route sharing no code with theirs |
| [`verify/verify_agentB.output.txt`](verify/verify_agentB.output.txt) | its raw output: `RESULT: ALL CLAIMS VERIFIED` |
| [`verify/agentB_sweep.py`](verify/agentB_sweep.py), [`verify/agentB_audit.py`](verify/agentB_audit.py) | Agent B's own scripts (kept for provenance; the mediator does not rely on them) |
| [`tests/test_complexity.py`](tests/test_complexity.py) | the regression gate, 19 tests (15 fast + 4 slow) |
| [`pytest.ini`](pytest.ini) | registers the `slow` marker |

## 7. Lean layer — status and honest caveat

The handoff warned that Mathlib was probably unavailable. **That is not true for
this workspace:** `/Users/victor/workspace/rh/lean/mathlib4` has a populated
`.lake/packages` (batteries, aesop, Qq, proofwidgets, plausible, importGraph,
LeanSearchClient, Cli) and a pinned `lean-toolchain` of `leanprover/lean4:v4.35.0-rc2`.

However, in the current `workspace-write` sandbox **invoking the Lean binary is
blocked**: `/Users/victor/.elan/bin/lean --version` and `lake --version` both
return `error: Operation not permitted (os error 1)`. So no Lean claim can be
made this session until that is resolved; **no proof in this programme is
currently backed by Lean.** If the sandbox is widened, `lake exe cache get` is
not needed — only `lake env lean <file>` — and the Tier-1 targets of §8.3 (the
factor set as a `List` operation, `p(L) ≤ N − L + 1`, the saturation injectivity
statement) become reachable offline. The single cleanest Tier-2 target remains
the uniqueness of `1 = 1/a + 1/b + 1/c`, whose two-line proof is in §8.3.

## 8. How to run

```bash
cd /Users/victor/workspace/rh

# ground-truth self-check (§3.1 table + slope structure)
python3 rh40/code/digitword.py

# the §6 numerical targets
python3 rh40/verify/probes.py              # fast
python3 rh40/verify/probes.py --all        # adds the heavy O(N^2) sweeps
python3 rh40/verify/probes.py --only 2 6   # selected probes

# the regression gate
python3 -m pytest -q rh40/tests/ -m "not slow"   # fast
python3 -m pytest -q rh40/tests/                 # includes slow mpmath census
```
