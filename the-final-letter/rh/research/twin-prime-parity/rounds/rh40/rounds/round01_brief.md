# rh40 — round 01 brief

Consolidated round-1 brief for **Agent A** (the professor) and **Agent B** (the
auditor), following the mediator's protocol of HANDOFF.md §7.3.

Everything in §1 below was recomputed by the mediator in this session with exact
integer arithmetic (`rh40/code/digitword.py`, `rh40/verify/probes.py`); nothing
in it is inherited on trust from the previous dialogue.

---

## 0. Ground rules (both agents)

* **Ground truth** is the offset-tuple enumeration of HANDOFF.md §3.2, implemented
  as `factor_set` / `p_offset` in `rh40/code/digitword.py`:

  ```
  p(L) = # { { a - t : a in ones, t <= a <= t + L - 1 } : 0 <= t <= N - L }
  ```

  Every number you state must be reproducible by calling that function. If you
  cannot compute it this turn, write `[NOT RUN]`.
* **Report N with every p(L).** p depends on the truncation length.
* **Exact arithmetic only** for word construction: `Fraction` for rational x,
  mpmath at ≥ 120 dps for irrational x. Never a binary float (HANDOFF.md §8.1).
* The expression-based greedy word builder for irrational targets is
  `greedy_word_mpmath("1/pi", N, dps=120)`.
* **Already disproved — do not re-propose** (HANDOFF.md §5, all re-verified this
  session): pair-based laws, distinct-distance laws, `Σ(L−d_i)_+`,
  `min(L + span, N − L + 1)` (model D), and B's triple `(index, offset, count)`.
* The zeta bridge is closed (HANDOFF.md §10). Do not reopen it.

## 1. Mediator's own findings from this session (recomputed, standing)

These were established *before* either agent spoke, and both agents must treat
them as data. Two of them are corrections to the handoff itself.

**M1 — HANDOFF.md §3.1's closed forms are false.** The table of *measured*
values in §3.1 is correct (p = 16, 18, 19 at L = 13, 14, 15). The extrapolated
piecewise law printed beneath it is not:

| L | §3.1 says | exact |
|---|---|---|
| 15 | `2L−10 = 20` | 19 |
| 20 | `2L−10 = 30` | 24 |
| 100 | `2L−10 = 190` | 104 |
| 593 | `2L−10 = 1176` | 597 |

`p(L) = 2L − 10` is false from L = 15 onward. §5 already lists this law as
"partly true, over-extrapolated"; §3.1 nevertheless states it as the law.
**A and B must not quote §3.1's formula. Quote the table only.**

**M2 — the true slope structure for x = 1/π, N = 1400 is five-piece, and the
maximum is attained on a plateau, not at a point:**

```
p(L+1) - p(L) = 1   for 1 <= L <= 10      (p(L) = L + 1   on 1 <= L <= 11)
p(L+1) - p(L) = 2   for 11 <= L <= 13     (p(12) = 14, p(13) = 16, p(14) = 18)
p(L+1) - p(L) = 1   for 14 <= L <= 604    (p(15) = 19 ... p(605) = 609)
p(L+1) - p(L) = 0   for 605 <= L <= 791   (p(L) = 609, the saturation plateau)
p(L+1) - p(L) = -1  for 792 <= L <= 1399  (the right-edge decay)
```

Note the **non-monotone slope**: 1 → 2 → **back to 1** → 0 → −1. There is no
range where the slope is 3. The plateau runs over the 187 values
L ∈ [605, 791], and the decay begins at exactly L = N − a_m = 792.

**M3 — the saturation plateau boundary is exactly L = N − a_m.** For L ≥ N − a_m
every window start t satisfies t + L − 1 ≥ N − 1 ≥ a_m, so every window contains
the last 1, the first 1 in the window is some a_i with no further 1 after it
inside the window only if i = m — and the left-special/right-special balance
flips. Plateau start = N − a_m; decay start = N − a_m + 1 is where windows lose
the last 1 entirely. Verified for all four dialogue words (M2 plus
`probes.py` probe 1).

**M4 — the offset-tuple count and the bit-string factor count agree everywhere
they were compared**, including deep into the decay regime (L = 800, 900, 1000,
1200, 1390, 1397, 1398, 1399 at N = 1400). So §3.2 is safe to use as the
definition of record; the numbers in §3.3 are not distorted by it.

**M5 — Cassaigne's identity fails in the decay regime, and only there.** For
x = 1/π, N = 1400: `p(L+1) − p(L) = #right-special(L)` holds for **every**
L ≤ 604 and fails for all 608 values L ∈ [792, 1399] (the slope −1 region),
where the right-special count is 0 but the true difference is −1. The finite-word
form `p(L+1) − p(L) = RS(L) − LS(L+1)` was tested and **also fails** there
(0 of 608 matched). Something other than a left-special correction accounts for
the loss; the mediator's hypothesis is that the loss is exactly the factors
whose only occurrence has window start t = N − L (windows dropping off the right
edge), but this has **not** been verified. **This is the sharpest open item in
the round** and is put to B directly.

**M6 — C1 as stated in HANDOFF.md §4 is false.** The §4 claim
`p(L) = L + 1 + #{i : L > d_i}` for `0 < L ≤ min_j d_j` fails on the very first
L strictly greater than the smallest gap, for all four dialogue words:

| word | gaps | C1 holds for | first failure | C1 predicts | exact |
|---|---|---|---|---|---|
| 1/π | (11, 594) | L ≤ 12 | L = 13 | 15 | **16** |
| log 2 | (4, 32, 6033) | L ≤ 33 | L = 34 | 37 | **38** |
| √2−1 | (10, 240) | L ≤ 11 | L = 12 | 14 | **15** |
| e−2 | (10, 20, 40) | L ≤ 11 | L = 12 | 14 | **15** |

So C1 in the form §4 asserts it (`0 < L ≤ min_j d_j`) is true but badly
understates its validity: C1 actually holds all the way to the **second**
boundary, which is not the smallest gap. For 1/π that boundary is 13 = d_1 + 2;
for √2−1 and e−2 it is 12 = d_1 + 2; for log 2 it is 34 = d_2 + 2. In each case
the C1 regime ends at `(the first gap that is ≥ ... )` — the mediator does not
have the rule yet.

The critical structural fact is that the C1 regime ends **strictly below** the
next gap (13 < 594, 34 < 6033, 12 < 240, 12 < 20 and 40). So there is an entire
intermediate regime — call it the **saturation-onset regime**, between the end of
C1 and the start of the plateau — in which the handoff has no law at all, and it
is exactly where the slope does its unexplained 2 → 1 decrease (M2). **Locating
that boundary exactly is the concrete sub-target for A (a).**

**M7 — the §6.2 exhaustive dataset is built and available.** `probes.py` probe 2
enumerates all `C(20, m)` supports for m ∈ {1,2,3,4} at N = 20 (6 175 words) with
exact p(L) for L = 1..20, and scores candidate closed forms for the plateau value
against it. Any candidate law from either agent will be scored against this table
before it is discussed.

## 2. This round's question

Both agents answer the **same** question, independently, from the two sides of
the protocol.

### 2.1 Put to Agent A

> Given M1–M7, produce your best *structural* theory of p(L) for the
> finitely-supported greedy word. In particular:
> (a) state exactly the regime in which `p(L) = L + 1 + #{d_i < L}` holds, and
>     prove or refute the boundary;
> (b) explain the slope sequence 1 → 2 → 1 → 0 → −1 of M2 — why does the slope
>     **decrease** from 2 back to 1 in the middle, and what is the crossover at
>     L = N − a_m doing?
> (c) give a closed form for the plateau value (609 for {2,13,607} at N = 1400)
>     as a function of the full gap sequence and N — or argue it has none.
>
> Respect your known failure mode: every asymptotic or "for all large L" claim
> must be accompanied by the finite computation that would falsify it, or be
> tagged `[DREAM]`.

### 2.2 Put to Agent B

> Your task is the *repair* specified in HANDOFF.md §7.2: for each index i and
> offset x, specify precisely which window starts t realise (i, x) as the first
> 1 of the factor. Concretely, do all of the following and show exact numbers:
> (a) Fix `p(L+1) − p(L) = RS(L) − LS(L+1)` (M5) or refute it; the mediator
>     believes the correct finite-word statement involves the windows lost at
>     the right edge and that the left-special correction is **not** the answer.
>     State and test the exact corrected identity, for every L, on at least the
>     four dialogue words.
> (b) Using `rh40/code/digitword.py`, decide whether the plateau value at
>     N = 1400 for {2,13,607} is 609 on the *whole* interval L ∈ [605, 791] and
>     nowhere else outside it, and whether the decay for L > 792 is exactly
>     `N − L + 1` (the probe data suggest it is, for L ≥ 800; check L = 793..799).
> (c) Answer (c) of A's question above by computation on the §6.2 table: is the
>     plateau value a function of the gap sequence alone, of the gap sequence and
>     N, or never of `(m, span, N)`? Produce the counterexample that decides it.
>
> Your known failure mode: never assert an orthogonality, a normalisation, or a
> "by theorem X" step without writing the object out and computing one instance.

## 3. Mediator's protocol for this round

1. A and B are launched in parallel on the briefs above (neither sees the
   other's answer this round; the cross-audit is round 2).
2. The mediator recomputes **every** computable claim of both, independently,
   with `rh40/code/digitword.py`.
3. Verdicts use B's four-status vocabulary: STANDING / UNSUBSTANTIATED /
   DISPROVEN / RETRACTED-WORTH-KEEPING.
4. The round is appended to `rh40/rounds/round01.md` with the verdict table, and
   every mediator error is logged in the ledger (`rh40/rounds/ledger.md`).

## 4. File map for this round

| Path | Contents |
|---|---|
| `rh40/README.md` | programme objective, status, file map |
| `rh40/code/digitword.py` | ground truth: greedy word, offset-tuple complexity, Cassaigne, slopes |
| `rh40/verify/probes.py` | the §6 numerical targets, plus the §3.1 audit |
| `rh40/tests/test_complexity.py` | the §8.2 regression gate (`pytest -q`) |
| `rh40/rounds/bootup_agentA.md` | Agent A's persona + brief (this round's prompt) |
| `rh40/rounds/bootup_agentB.md` | Agent B's persona + brief (this round's prompt) |
| `rh40/rounds/round01_agentA.md` | A's answer (verbatim) |
| `rh40/rounds/round01_agentB.md` | B's audit (verbatim) |
| `rh40/rounds/round01.md` | mediator's adjudication, verdict table, ledger |
| `rh40/rounds/ledger.md` | cumulative error ledger, all three participants |
