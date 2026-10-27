# rh40 — K1 solved: the plateau value is `a_m + 2`

**Status: PROVED** (with an exhaustive machine-checked corroboration of
242 295 (support, L) cases over 36 424 supports, and 0 counterexamples).

This document closes register entry **K1** and, with it, sub-target **C2a** of
HANDOFF.md §4. It also yields the exact complexity function for all
`L ≥ max(span, a_m + 1)`, i.e. sub-target **C2b** (the right-edge decay).

---

## 1. Statement

**Setup.** Let `0 ≤ a_0 < a_1 < … < a_m < N` be the support of a word `w` of
length `N` (so `w` has `m+1` ones), let

```
span  := a_m − a_0        (0 if m = 0)
d_j   := a_j − a_{j−1}    (1 ≤ j ≤ m)
```

and for a window start `t ∈ [0, N−L]` let

```
F(t) := { a − t : a ∈ {a_0,…,a_m},  t ≤ a ≤ t + L − 1 }
```

be the offset tuple of the length-`L` factor at `t`. Then
`p(L) = #{ F(t) : 0 ≤ t ≤ N − L }` (register B1/B2).

### Theorem A (the large-`L` regime)

*For* `max(span, a_m + 1) ≤ L ≤ N − 1`*,*

```
p(L) = min(a_m + 1, N − L + 1) + [ L ≤ N − a_m − 1 ].
```

### Theorem B (the plateau, = C2a)

*For* `max(span, a_m + 1) ≤ L ≤ N − a_m − 1`*, in particular for every `L` in
the plateau range,*

```
p(L) = a_m + 2.
```

Hence `max_L p(L) ≥ a_m + 2`, and by Theorem A no larger value occurs in the
large-`L` regime. The plateau **value** is a function of `a_m` alone, which is
exactly the phenomenon register entry E3 recorded as an obstruction to any
`(m, span, N)` formula.

---

## 2. Proof

### Lemma 1 (a window has multiplicity one, and is recognised by its last offset)

Assume `L ≥ span`, so the window `[0, L−1]` reaches `a_m`. For any `t` with
`0 ≤ t ≤ N − L`:

**(i)** If `a_m ∈ [t, t+L−1]` then `a_m − t ∈ F(t)` and `a_m − t = max F(t)`:
every offset in `F(t)` is `a − t` with `a ≤ a_m`, and `a − t ≥ 0`.

**(ii)** Hence if `F(t) = F(t')` and both windows contain `a_m`, then
`a_m − t = max F(t) = max F(t') = a_m − t'`, so `t = t'`. So the map
`t ↦ F(t)` is **injective on the set of windows containing `a_m`**. ∎

*This is the whole content of K1. Everything below is bookkeeping.*

### Lemma 2 (how many windows contain `a_m`, and whether they are non-zero)

Assume `L ≥ a_m + 1`. The windows containing `a_m` are those with
`t ≤ a_m ≤ t + L − 1`, i.e.

```
max(0, a_m − L + 1) ≤ t ≤ min(a_m, N − L).
```

(i) Since `L ≥ a_m + 1` we have `a_m − L + 1 ≤ 0`, so the lower end is `0`.
(ii) Since `L ≤ N − 1`, we have `N − L ≥ 1 > 0`, so also `a_m ≤ N − L` would be
needed for the upper end to be `a_m`; but `a_m ≤ N − L` **iff** `L ≤ N − a_m`.
So the count is

```
# {t : a_m ∈ [t, t+L−1]} = min(a_m, N − L) + 1 = min(a_m + 1, N − L + 1).
```

(iii) Every such window contains a 1, so none of them gives the all-zero factor.
(iv) Conversely every window that does **not** contain `a_m` lies strictly to the
right of `a_m`, i.e. `t > a_m`; such a window exists iff `a_m + 1 ≤ N − L`, i.e.
iff

```
L ≤ N − a_m − 1.
```

A window to the right of `a_m` contains no 1 at all, so it contributes the
all-zero factor, and there is at most one such factor. Hence

```
p(L) = min(a_m + 1, N − L + 1) + [ L ≤ N − a_m − 1 ].        ∎
```

*Note that Lemma 2(ii) is not vacuous and not automatic: `L ≤ N − a_m` fails
whenever `L` is large, which is exactly the regime where the window counting
saturates at `N − L + 1` and the "decay" appears.*

### Lemma 3 (the earlier parameter range `span ≤ L ≤ a_m`)

For `L` in this range the same conclusion holds by the same argument: the
windows containing `a_m` number `min(a_m + 1, N − L + 1)` provided
`a_m − L + 1 ≤ 0` or the finitely many windows in `[a_m − L + 1, 0)` are also
non-zero — and they are, each containing `a_0` because `L ≥ span`. Lemma 1 gives
injectivity on all of them. This is why the theorem is stated with
`max(span, a_m + 1)`; the `span` term is the binding one for the dialogue words
(all of which have `span` near `a_m`), the `a_m + 1` term is binding only for
tiny words.

### Proof of Theorem B

Put `L ≤ N − a_m − 1`. Then the indicator in Theorem A is 1, and
`min(a_m + 1, N − L + 1) = a_m + 1` because `N − L + 1 ≥ a_m + 2`. Sum: `a_m + 2`.
For the **lower** end of the plateau range we need `max(span, a_m + 1)` to be
≤ `N − a_m − 1` for some `L`; the dialogue words all satisfy `a_m + 1 ≤
N − a_m − 1`, i.e. `N ≥ 2a_m + 2`, and `span ≤ a_m − 1` when `a_0 ≥ 1`. ∎

### Where the plateau really starts (honest boundary)

Theorem B proves `p(L) = a_m + 2` on `[max(span, a_m+1), N−a_m−1]`. The
*measured* plateau for the dialogue words starts slightly **earlier**:

| word | `a_m` | `span` | proven plateau | measured plateau |
|---|---|---|---|---|
| 1/π, (2,13,607), N=1400 | 607 | 605 | [608, 792] (185 values) | [605, 792] (188) |
| log 2, (0,4,36,6069), N=13000 | 6069 | 6069 | [6070, 6930] (861) | [6065, 6930] (866) |
| √2−1, (1,11,251), N=2000 | 251 | 250 | [252, 1748] (1497) | [250, 1748] (1499) |
| (10,20,40,80), N=500 | 80 | 70 | [81, 419] (339) | [60, 419] (360) |
| true e−2, (0,3,53), N=2000 | 53 | 53 | [54, 1946] (1893) | [53, 1946] (1894) |

So `p(L) = a_m + 2` also holds on a small interval of length `≤ span` below
`a_m + 1`. That is register **K2** (the plateau onset), which remains open; the
theorem above deliberately does not claim it.

---

## 3. Consequences

**(a) K1 and C2a are closed.** `max p = a_m + 2` on the plateau is now a theorem,
not a measurement. The proof is three short lemmas, and its crux is one line:
*the maximum offset of a factor containing `a_m` is `a_m − t`, which recovers
`t`*.

**(b) The decay law C2b follows from the same statement.** Theorem A with
`L ≥ N − a_m` gives `min(a_m+1, N−L+1) = N−L+1` and indicator `0`, i.e.
`p(L) = N − L + 1` — register E5, now also proved rather than measured.

**(c) The plateau end is proved.** `L = N − a_m − 1` is exactly where the
indicator in Theorem A flips, so the plateau **cannot** extend past it. The
measured value 792 for 1/π is now a theorem.

**(d) The `a_m`-only dependence is explained.** E1/E3 observed that the plateau
value depends on `a_m` alone and not on `(m, span, N)`; Theorem B shows why:
the `a_m + 1` factors are the *windows containing `a_m`*, one per position, and
`a_m + 1` is just how many such positions there are.

**(e) The formula is exactly `min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`, not
`min(a_m+2, N−L+1)`.** Register E7 recorded that the simpler form fails for
`L` below the plateau onset; Theorem A shows the correct split — the indicator
is present only while `L ≤ N − a_m − 1`, which is the same threshold that makes
`N − L + 1 ≥ a_m + 2`.

---

## 4. Machine corroboration

`rh40/verify/plateau_theorem.py` exhaustively checks Theorem A over **all**
supports with `0 ≤ a_0 < … < a_m < N`, `1 ≤ m+1 ≤ 4`, `3 ≤ N ≤ 31`, for every
`L` in `max(span, a_m+1) ≤ L ≤ N−1`:

```
supports: 36 424 ; (support, L) pairs: 242 295 ; counterexamples: 0
```

It also re-checks Theorem B (the `a_m + 2` corollary) and the decay law
`p(L) = N − L + 1` on the same corpus, and the four dialogue words at their
published truncations. Run it with:

```bash
python3 rh40/verify/plateau_theorem.py
```

The exhaustive search is also wired into the regression gate:
`test_plateau_theorem_exhaustive` runs the same check for all supports with
`m+1 ≤ 4`, `N ≤ 22` (fast, ~11 000 cases); `test_plateau_value_is_am_plus_2_dialogue`
and `test_decay_law_is_proved_by_theorem_a` lock the dialogue-word instances; and
`test_plateau_full_dialogue_words` (marked `slow`) does the full N = 13000 sweep.

---

## 5. What is *not* claimed

* **K2 is still open.** The exact plateau onset
  `L_onset = min{ L : p(L) = a_m + 2 }` is not determined by this proof. The
  theorem only gives `L_onset ≤ max(span, a_m + 1)`; the measured onsets are
  strictly smaller (table in §2). Four candidate formulas for it were already
  refuted (register E8/J11/J12).
* **K3, K4 are still open.** The C1 regime boundary and the general-`L`
  piecewise structure below `L_onset` are untouched. Theorem A says nothing for
  `L < max(span, a_m+1)`.
* **The proof is not formalised in Lean.** It is a paper proof corroborated
  exhaustively; the Tier-1 Lean targets in HANDOFF §8.3 are unchanged, and Lemma 1
  is now the natural first formalisation target (`Finset` injection on the
  windows containing the maximal support point).
* **`span` is inherited as an assumption.** The statement is conditional on
  `L ≥ max(span, a_m+1)`; nothing here constrains the word to be the greedy digit
  word, and indeed Theorems A and B hold for *any* finitely supported 0/1 word.
  That is worth stating plainly: **the plateau law is not arithmetic, it is
  combinatorial.** The greedy structure only determines *which* supports occur.

**Date:** this session. **Evidence:** `verify/plateau_theorem.py`, register
`truths.md` entries E1–E7 (now upgraded from `VERIFIED in value` to `PROVED`).
