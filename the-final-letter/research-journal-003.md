# Research journal 003 — live journal

**Purpose.** `research-journal-002.md` reached 430 lines and is now dated history
(I.282–I.292). This file is the *only* thing a fresh session needs to read to
continue the `finite-window-zeros` Krawczyk programme: live state, exact next
steps, pre-computed constants, and the traps already paid for. Append entries to
§7; when this file passes ~500 lines, split again into 004.

Referenced from `research-journal-002.md` (pointer added there).

---

## 0. One-paragraph state

Goal: a Lean-certified zero of `ζ` at `1/2 + 14i` via Krawczyk. **Step 3 is
done** (`‖ζ(1/2+14i)‖ ≤ 23/200`) and **step 5 is done but conditional**
(`zeta_zero_14_of_bounds`, T329). Step 4 (`hC`) is reduced to two numerical
hypotheses `h1`, `h2` (T328–T329), which are the only outstanding obligations:

```lean
h1 : ‖1 - Yk * deriv riemannZeta s14‖ ≤ 1/200
h2 : ∀ z ∈ closedBall s14 (1/5), ‖deriv riemannZeta z - deriv riemannZeta s14‖ ≤ 47/250
```

**`h1` is complete** — `h1(a)` (T351, `mem_Vbox`), `h1(b)` (`norm_deriv_zetaResid_le`,
T385) and `h1(c)` (T391, `h1_deriv`) are all proved. **`h2` is the only
remaining obligation**; it is designed (§2b) but not started.

**`c_k` is done** (T418–T442, T443–T456): the boxes enclose `gen₃^{(k)}(s14)`
(`k ≤ 6`), the `ζ = gen₃ + R₃` split is proved for every derivative order, and
Cauchy's estimate gives `|c_k| ≤ 0.351, 0.103, 0.025, 0.007, 0.006`.  What is
left of `h2` is exactly two things: `sup|ζ^{(7)}| ≤ 25000` on the closed
`1/5`-ball, and the downward Taylor induction (design in §2b.3).

Counts: **T1–T456 · 914 ledger theorems · 48/48 topics · 15 Lean files green ·
audit 48/48 · links 0 broken**.

*File size note:* this journal is now ~830 lines, well past the ~500-line split
threshold of the header.  Split into `research-journal-004.md` (live state = §0–§6,
entries I.293–I.31x stay here) at the start of the next session.

## 1. What is proved (chain, in order)

| range | content | file |
|---|---|---|
| T293–T305 | Euler–Maclaurin remainder bound at `0 < Re s` for **every** `K` | `EMCritical.lean` |
| T306–T321 | 21-atom box: `‖ζ(s14)‖ ≤ 23/200`, `hmap` | `EMBox14.lean` |
| T322–T326 | `r = 1/5` Krawczyk data; `zeta_zero_fifth_ball` (conditional on `hC`) | `EMBox14.lean` |
| T327–T329 | `hC_of_bounds`, `zeta_zero_14_of_bounds h1 h2` | `EMBox14.lean` |
| T330–T351 | derivative layer, `ζ′` enclosure `Vbox`, `h1(a)` membership | `EMDeriv.lean` |
| T352–T358 | `rpow` bounds + Pochhammer ball bounds (`P₃`, `P₅`, `P₆`) at `ρ = 0.35` | `EMDeriv.lean` |
| T359–T391 | `h1(b)` at `ρ = 1/2` + `h1(c)` assembly: **`h1_deriv`** | `EMDeriv.lean` |

Key named results:

```lean
zeta_norm_le_eighth   : ‖riemannZeta s14‖ ≤ 1/8
hmap_zeta_fifth      : ‖Yk * ζ s14‖ + (1/4)*(1/5) ≤ 1/5
mem_Vbox             : Cx.mem (deriv (zetaEMGen 1 20) s14) Vbox
zeta_zero_14_of_bounds (h1 : …) (h2 : …) : ∃ z ∈ closedBall s14 (1/5), ζ z = 0
```

`Yk = 12436403768/10^10 − (3397942771/10^10)i`, `‖Yk‖ ≤ 1.29` (T323), `Yk ≠ 0`
(T327). `s14 = 1/2 + 14i`.

## 2. The ONLY remaining obligations

Budget: `1/200 + 1.29·(47/250) = 0.24752 ≤ 1/4` ✔.

### 2a. `h1` — three pieces — **ALL DONE (T351, T385, T391)**

1. **Membership** — **DONE** (T351, `mem_Vbox`).
2. **Ball for the rest** — **DONE** (T385, `norm_deriv_zetaResid_le`).
   `ζ′ = (zetaEMGen 1 20)′ + H′` where
   `H = ζ − zetaEMGen 1 20 = B₄ + B₆ + R₃` on the `1/2`-ball around `s14`.
   `|H′|` comes from **one** Cauchy application
   `norm_deriv_le_of_norm_le_on_ball` with `‖H‖ ≤ M`:
   * `|B₄| ≤ (1/720)·4080·21^{-3} = 6.119·10⁻⁴` — `emCoef_two`, `norm_P3_ball_half`.
   * `|B₆| ≤ (1/30240)·1395360·21^{-5} = 1.130·10⁻⁵` — `emCoef_three`,
     `norm_P5_ball_half`.
   * `|R₃| ≤ 6·10⁻⁵` — T305 with `σ ≥ 0` plus `emConst_six`, `norm_P6_ball_half`.
   * Sum `≤ 7·10⁻⁴`, so `|H′| ≤ 2M/ρ = 28·10⁻⁴`.  One application is equivalent
     to three (same `M/ρ`), and strictly less plumbing: no `B₄′`, `B₆′`, `R₃′`
     split is needed.
3. **Assembly** `h1` — **DONE** (T391, `h1_deriv`):
   `1 − Yk·ζ′ = (1 − Yk·(gen₁)′) − Yk·H′`, so
   `‖1 − Yk·ζ′‖ ≤ ‖1 − Yk·(gen₁)′‖ + 1.29·|H′|`.
   The first term is a box computation (`Wbox = ptBox 1 0 − Yk·Vbox`,
   `native_decide` corner `≤ 1/2000`), the true value is
   `|1 − Yk·V| = 3.62·10⁻⁴`.  Total `5·10⁻⁴ + 1.29·28·10⁻⁴ = 4.11·10⁻³ ≤ 5·10⁻³`.

**Radius choice (round I.293).** Use `ρ = 1/2`, not `0.35`. Reason: at `ρ ≤ 1/2`
we have `Re z ≥ 0` on the ball, so every `21`-power is dominated by an **integer**
exponent (`21^{-Re z - 3} ≤ 21^{-3}`, `21^{-Re z - 6} ≤ 21^{-6}`, …) and no new
`rpow`-at-a-rational-exponent lemma is needed. `2/ρ` grows only by `0.5/0.35`,
which the integer domination more than pays for:

```
M₄ ≤ (1/720)·4080·21^{-3}   = 6.119·10⁻⁴
M₆ ≤ (1/30240)·1395360·21^{-5} = 1.130·10⁻⁵
M_R ≤ 6.0·10⁻⁵
M  ≤ 7·10⁻⁴  →  |H′| ≤ 2M/ρ = 28·10⁻⁴
h1 ≤ 1/2000 + 1.29·28·10⁻⁴ = 4.11·10⁻³ ≤ 5·10⁻³   ✔  (18% margin)
```

The `0.35`-ball lemmas (T354–T358) are kept; the `1/2`-ball versions (T365–T373)
are new lemmas with the same proof shape and the exact consecutive products as
constants.

### 2b. `h2` — Taylor model (design settled; numbers re-probed in I.294)

```
‖ζ′(z) − ζ′(s14)‖ ≤ Σ_{k=2..K} k·|c_k|·r^{k−1} + 2·sup|G^{(K+1)}|·r^K/K!
```

The true sup over the closed `1/5`-ball is `0.1392795`, and the Taylor partial
sums converge to it almost immediately (probe I.294):

| `k` | `|c_k|` | `k|c_k|` |
|---|---|---|
| 1 | 0.7756596937 | 0.7756596937 |
| 2 | 0.3189210388 | 0.6378420776 |
| 3 | 0.0917586240 | 0.2752758719 |
| 4 | 0.0208557606 | 0.0834230423 |
| 5 | 0.0039905438 | 0.0199527188 |
| 6 | 0.0006668628 | 0.0040011768 |
| 7 | 9.9619·10⁻⁵ | 6.9733·10⁻⁴ |

`Σ_{k=2..4} = 0.1392468`, `Σ_{k=2..6} = 0.1392800`. **`K = 6` is the right
choice**: with the crude `sup|ζ^{(7)}| ≲ 6400` (see below) the remainder is
`2·6400·(1/5)^6/6! = 1.14·10⁻³`, so the total is `≤ 0.1404 ≤ 0.188` — 25%
margin. `K = 5` (remainder `1.1·10⁻²`, total `0.151`) also passes; `K = 6` is
safer for one extra coefficient.

Pieces:
1. point enclosures of `c_k = ζ^{(k)}(s14)/k!`, `k = 2..6`.  Only *upper bounds*
   on `|c_k|` are needed (no `Cx.inv`): factor the generator as
   `zetaEMGen 3 20 s = Σ_{n≤20} n^{-s} + 21^{-s}·Ψ(s)` with
   `Ψ(s) = 21/(s−1) + 1/2 + s/252 + P₃(−s)/(720·9261) − P₅(−s)/(30240·4084101)`
   a *rational* function of `s`.  Then
   `ζ^{(k)}(s14) = −Σ log^k n·n^{-s14} + 21^{-s14}·Σ_{j≤k} binom(k,j) Ψ^{(j)}(s14)(−log21)^{k−j}`,
   and the second factor is a Gaussian-rational polynomial in `log21` (T344–T347
   is the `k = 1` case).  A single induction gives `d^k[21^{-s}Ψ(s)]`.
2. modulus bound on `ζ^{(K+1)}` over the `1/2`-ball (the *larger* ball is fine):
   `Σ_{n≤20} (log n)^7 n^{-0.3} = 6400`-ish, the `21`-part is `≲ 1`, and the
   `R₃` derivative by repeated Cauchy on the `0.35`-ball,
   `|R₃^{(m)}(z)| ≤ m!·6·10⁻⁵/0.15^m`, which is harmless because it is multiplied
   by `r^K/K!` with `r = 1/5 < 0.15`.  (Probe: the *true* `sup|ζ^{(6)}|` on the
   ball is `0.592`; the crude `2134`/`6400` numbers are what Lean will use.)
3. Taylor inequality via `norm_sub_le_of_deriv_bound` (in `Krawczyk.lean`) plus
   `AnalyticAt.fderiv` / `AnalyticOnNhd.iteratedFDeriv` to get that every
   `deriv^[k] ζ` is differentiable.

**Remainder, two routes (decide when starting `h2`):**

* (A) *Taylor integral remainder*: `G(w) = (1/K!)∫₀¹ (1-t)^K ζ^{(K+1)}(s14+tw) w^{K+1} dt`,
  bound `≤ sup|ζ^{(K+1)}| r^{K+1}/(K+1)!`, then `|G'| ≤ 2 max|G|/r`.  Needs the
  integral identity (~150–250 lines, induction with `intervalIntegral.integral_deriv_eq_sub`)
  and the crude `sup|ζ^{(7)}|` bound, which itself needs the 7th-derivative formula
  of `gen₃` (available once `c_k` is).
* (B) *Power-series tail*: Mathlib's `hasSum_taylorSeries_on_ball`
  (`Mathlib/Analysis/Complex/TaylorSeries.lean`) gives `ζ(s14+w) = Σ c_k w^k` on
  the ball of convergence, so
  `|tail of ζ′| ≤ Σ_{k>K} k|c_k| r^{k-1}` with `|c_k| ≤ M/R^k` from Cauchy on a
  radius-`R` ball: bound `= (M/r)·Σ_{k>K} k (r/R)^k`.  With `R = 1/2`, `r = 1/5`,
  `c = 0.4`, `K = 7`: `Σ_{k>7} k c^k = c^8(8-7c)/(1-c)^2 = 9.4·10⁻⁴`; with a
  crude `M ≤ 0.6` this is `1.6·10⁻³` — enough, and it needs **no high derivative
  formula**, only `sup|ζ|` on the `1/2`-ball (which the `h1` machinery almost
  gives).  This may well be the cheaper route; note the series in Mathlib is
  phrased with `iteratedFDeriv`, so term-by-term differentiation of the power
  series and the coefficient identification `c_k = ζ^{(k)}(s14)/k!` still need
  a bridge.

### 2c. Why `K = 3`, not `K = 2`

A *value* certificate works at `K = 2` (T306). A *derivative* certificate does
not: Cauchy on the remainder divides by `ρ` only, not `ρ^k`.

| `K` | `M_R` (ρ=0.45) | `1.29·2M_R/ρ` | vs `h1` budget |
|---|---|---|---|
| 2 | `3.12·10⁻³` | `1.79·10⁻²` | ✗ 2.4× over |
| **3** | `3.97·10⁻⁵` | `2.28·10⁻⁴` | ✓ |

## 3. Exact constants (pre-computed; do not re-derive)

```
s14 = 1/2 + 14i            ζ(s14)  = 0.0222411426 − 0.1032581233i
                           ζ′(s14) = 0.7482336961 + 0.2044365338i    |ζ′| = 0.77560
Yk = 1.2436403768 − 0.3397942771i          |Yk| = 1.2892251695
1/(s14−1)   = (−2 − 56i)/785
1/(s14−1)²  = (−3132 + 224i)/616225
V(s14) = 0.7479828710 + 0.2045629481i      (V = (gen₁)′(s14))
V − ζ′ = −0.0002508251 + 0.0001264143i     |V − ζ′| = 0.0002808804
1 − Yk·V = 3.6211814·10⁻⁴                  |1 − Yk·ζ′| = 3.5342·10⁻¹¹
value-box scalar = 177437/395640 − (20383/14130)i
Vbox scalar  A0 = 17190769/155288700 − (4704/616225)i
             A1 = −177437/395640 + (20383/14130)i
emCoef 2 = −1/720, emCoef 3 = 1/30240 = B₆/6!
2·Re ζ(6)/(2π)^6 = 1/30240
21^{-3} = 1/9261, 21^{-4} = 1/194481, 21^{-5} = 1/4084101, 21^{-6} = 1/85766121
21^{-0.15} = 0.63342   (three times these exponents; ρ = 1/2 avoids needing it)
```

Box parameters (all atoms): `cpowBox 20 16 48 24 b S` with box `S`; the
`Krawczyk` rectangle probe used `N_log = 20`, `k = 16`, `kI = 48`, `n = 24`.
Atom widths measured `≤ 10⁻⁹` at a point — precision is *never* the binding
constraint.

## 4. Traps already paid for — read before writing code

1. **Probe arithmetic before building.** Three plans were wrong (region box,
   `K=2` for derivatives, the `Cx.inv` detour) and each was caught by checking
   the inequality numerically *first*.
2. **An existential probe only gives the bound you asked for.** Bisect until it
   fails.
3. **A box enclosure over a 2D region is impossible.** A single atom
   `20^{-S}` over the ball's rectangle is already `≥ 0.1` wide. Never quantify
   over a region with `CpowBox`. Points only — or a Taylor model.
4. **`Nat.cast` vs `OfNat`.** Terms render as `↑(↑20 + 1)` and `21^(-(s + ↑0))`;
   rewrite lemmas must be stated `((↑(20:ℕ) : ℝ) + 1 : ℝ)` and
   `-(s + (↑(0:ℕ) : ℂ))`, never with bare numerals.
5. **Read the lemma, don't guess its shape.** `Complex.cpow_def` is *piecewise*;
   `Complex.cpow_add` is not. `HasDerivAt.inv` yields `-1/(s-1)^2`.
6. **`HasDerivAt.comp` leaves a syntactic `Function.comp`** — needs a `rfl`
   rewrite before `convert`.
7. **`convert h using 1` may leave only the value goal.** A redundant `ring`
   then errors with "No goals".
8. **Rewrite order.** When two rewrites interact, put the one that *creates* the
   pattern last (T351: `ofReal_log_natCast` before the cast bridge).
9. **Polymorphic shifts want `ℂ`, not `ℕ`.** `ball_add_le` with a `ℕ` shift
   failed to match `norm_s14_add_one_le` (whose `1` is `OfNat`). State the shift
   as `t : ℂ`.
10. **`Cx`/`Iv` live in namespace `PartialTail`.** `open PartialTail` in any file
    that mentions `Cx` explicitly; inside `namespace FiniteWindowZeros` a bare
    `: Cx` in a `#eval` probe resolved to a *different* `Cx` and failed.
11. **A derivative bound at a point from Cauchy needs the norm bound on the
    *open* ball**, so `Metric.ball` (not `closedBall`) hypotheses; `Re > 0` then
    holds strictly, which is what T305 needs.
12. **`bernoulli`/factorial shapes in `riemannZeta_two_mul_nat`.** The theorem's
    LHS is `riemannZeta (2 * ↑k)` — the `2 * k` is computed **in `ℂ`** (with
    `↑k` the `Nat.cast`), not `↑(2 * k)` with a Nat product. So rewriting
    `(6 : ℂ)` must land on `2 * ↑3`, i.e. use
    `show (6 : ℂ) = 2 * ((3 : ℕ) : ℂ)`, not `2 * (3 : ℂ)`. Two compiles were
    spent on this.
13. **Check for an existing lemma before adding one.** `emCoef_three` already
    exists in `EulerMaclaurin.lean` (same namespace); a duplicate declaration is
    an error, not a shadow. `grep` the whole `lean/` directory, not just the file.
14. **Factorial notation in an ascription-heavy term.** `((((2 * 3)! : ℕ)) : ℂ)`
    failed to parse ("unexpected token `!`"). Write
    `(((Nat.factorial (2 * 3)) : ℕ) : ℂ)` instead.
15. **`positivity` does not consult local hypotheses** such as `0 < s.re`. For a
    nonnegativity side goal involving `21 ^ (-s.re - 6) / (s.re + 6 - 1)`, prove
    it explicitly: `Real.rpow_pos_of_pos (by norm_num) _` plus `div_pos` and
    `linarith`.
16. **Do not rewrite a bound before using it.** `rw [pow21_neg_five] at h1`
    turned `h1 : A ≤ 21^(-5)` into `A ≤ 1/4084101`, which then no longer matched
    `div_le_div_of_nonneg_right`'s expected type. Keep the symbolic form and put
    the numeric evaluation in the final `calc` step.
17. **`rw` can close the goal** (definitional equality); a trailing `ring` then
    errors "No goals to be solved" (trap #7 in a new place — `zetaEMGen_three_expand`).
18. **Never print huge rationals with `Nat.toFloat`.** `#eval` of
    `(maxAbsIv Vbox.re).num.toFloat` spent **27 minutes** in decimal conversion
    of a few-thousand-digit rational. Probe with `#eval decide (corner ≤ q^2)`
    (a `Bool`) instead; the box evaluation itself is ~45 s.

## 5. Conventions / hard rules

* No `sorry`, `axiom`, `admit` anywhere.
* Do not weaken P3; no RH, twin-prime, Chowla or infinite Weil-positivity claim.
* P5 stays finite-shadow-only.
* Every new theorem: row in `topics/finite-window-zeros/README.md` **and**
  `index.html`, counts in `topics/STATUS.md`, entry in this journal.
* Keep `./lean/check.sh` green (13 files) and
  `python3 topics/tools/audit_topics.py` / `tools/check-links.py` at 0 failures.
* Commit after each verified increment; do not leave a non-compiling file.
* `HANDOFF.md` in the topic carries the same plan in more detail.

## 6. Commands

```bash
cd the-final-letter/topics/finite-window-zeros
./lean/check.sh                 # 13 files (EMDeriv last: dominated by Mathlib import)
./lean/check.sh EMDeriv.lean    # single file
cd /Users/victor/workspace/victor-geere.github.io
python3 the-final-letter/topics/tools/audit_topics.py
python3 the-final-letter/tools/check-links.py
```

Compile budget: a single `EMDeriv.lean` check is ~5 min wall (Mathlib import
dominates), so batch edits per compile and keep a scratch `Probe.lean` only while
a measurement is needed (delete it before committing).

## 7. Entries

### 2026-10-27 — I.293: journal split; `h1(b)` radius changed to `1/2`

Split 002 into 003 (002 = dated history I.282–I.292). Before writing `h1(b)` I
re-derived the numbers and found a **radius trap**: the `ρ = 0.35` plan of I.289
needs `21^{-3.15} ≤ ~7.5·10⁻⁵`, i.e. a genuine `rpow` bound at a rational
exponent, and the crude integer domination `21^{-3.15} ≤ 21^{-3} = 1.08·10⁻⁴`
blows the budget (total `5.5·10⁻³`+). Two fixes were on the table:

1. prove `21^{-0.15} ≤ 3/4` by hand (plus sharper `P₃ ≤ 4080`, `P₅ ≤ 1.34·10⁶`),
   keeping `ρ = 0.35`;
2. move the ball out to `ρ = 1/2`, where `Re z ≥ 0` makes every exponent an
   integer domination.

Chose (2): same total (`4.6·10⁻³ ≤ 5·10⁻³`), no new transcendence input, and the
Pochhammer constants become the exact consecutive products. Also collapsed the
planned **three** Cauchy applications into **one**: bound `H = ζ − zetaEMGen 1 20`
directly on the ball, since `H = B₄ + B₆ + R₃` there and Cauchy is linear in
`M`. `|H′| ≤ 2M/ρ` with `M ≤ 7·10⁻⁴` gives `2.8·10⁻³`, versus `3.5·10⁻³` from
summing the pieces of I.289.

Numerics re-probed with `mpmath` (30 dps):

```
|1 − Yk·V|          = 3.6211814497·10⁻⁴     (this is the box target `R`)
|1 − Yk·ζ′|         = 3.5342197916·10⁻¹¹
|V − ζ′|            = 2.8088042505·10⁻⁴
```

`|1 − Yk·V|` is `3.6·10⁻⁴`, so a box corner `≤ 10⁻³` (even `≤ 2·10⁻³`) is
available with a huge margin.

### 2026-10-27 — I.294: `h1` is DONE — `h1(b)` and `h1(c)` (T359–T391)

`h1_deriv : ‖1 − Yk·ζ′(s14)‖ ≤ 1/200` is proved.  The whole `h1` chain is now
closed: T351 (`mem_Vbox`) → T359–T391 in `EMDeriv.lean` → `h1_deriv`.

What was built (33 theorems, all `EMDeriv.lean`):

* **`h1(b)` at `ρ = 1/2`** — the integer-exponent route of I.293.
  Ball geometry: `mem_ball_half`, `re_pos_of_ball_half` (`Re > 0`),
  `im_bounds_of_ball_half` (`1 < Im < 20`), `ne_one_of_ball_half`;
  shift bounds `norm_s_add_{one..five}_ball_half` (`‖s+k‖ ≤ 15+k`) and
  `norm_s14_add_{four,five}_le`; Pochhammer products `norm_P{3,5,6}_ball_half`
  with the exact constants `15·16·17 = 4080`, `15·…·19 = 1395360`,
  `15·…·20 = 27907200`.
  Constants: `pow21_neg_five`, `pow21_neg_six`, `riemannZeta_six`
  (`ζ(6) = π⁶/945`), `emConst_six` (`2·Re ζ(6)/(2π)⁶ = 1/30240`).
  Pieces: `norm_b4_ball_half ≤ 62/100000`, `norm_b6_ball_half ≤ 12/1000000`,
  `norm_remainder_three_ball_le ≤ 6/100000` (`M_R(K = 3)` with `σ ≥ 0`).
  Sum: `norm_zetaResid_le : ‖H‖ ≤ 7·10⁻⁴`, then **one** Cauchy application
  `norm_deriv_zetaResid_le : ‖H′(s14)‖ ≤ 28·10⁻⁴`.
  Bridge: `deriv_zeta_eq_gen_one_add`, `zetaEMGen_three_expand`,
  `differentiableOn_zetaResid`.
* **`h1(c)`** — `mem_Ybox`/`mem_Wbox`, `corner_Wbox` (native_decide:
  corner² ≤ (1/2000)²; true `|1 − Yk·V| = 3.62·10⁻⁴`, and the corner is
  **not** ≤ (1/5000)²), `norm_Wbox_le ≤ 1/2000`, and the assembly
  `h1_deriv`:
  `1/2000 + 1.29·28·10⁻⁴ = 4.11·10⁻³ ≤ 1/200`.

Compile: `EMDeriv.lean` now ~85 s (Mathlib import 30 s, `corner_Wbox`
`native_decide` ~45 s, elaboration the rest).  Full 13-file check green; audit
48/48; links 0 broken.  Ledger rows T359–T391 in the topic README + `index.html`;
`topics/STATUS.md` now 849 ledger theorems / 391 for this topic.

**Next: `h2`.** Nothing blocking, but it is the largest remaining piece.
Suggested decomposition (see §2b for the design):

1. **The `(gen₁)′`-part is reusable.** For `h2` we need `ζ′` on the `1/5`-ball,
   not just at `s14`.  A direct EM box over the region is impossible (trap #3),
   so the Taylor model stands.  But note the *point* machinery of T330–T351
   ( `Vbox`, `dsPow`, `mem_Vbox` ) already gives `c₁ = ζ′(s14)/1!`; `h2` needs
   the same at the **ball**, so plan for the Taylor route, not a box.
2. Point enclosures `c_k = ζ^{(k)}(s14)/k!`, `k = 1..5`, by differentiating
   `zetaEMGen 3 20` term by term (T339 is `k = 1`); the `21`-part is
   `21^{-s14}` times a scalar box in the *ring* `ℚ[log 21]`, so build
   `scalarBox` analogues with `Cx.mul` powers of `logIvRat 20 21` (widths are
   tiny at a point — trap #3 does not bite).
3. `sup|ζ^(K+1)|` over the ball from `Σ_{n≤20} (log n)^{K+1} n^{-0.3}` plus
   the `21`-part and a repeated-Cauchy bound on `R₃`; only moduli, no
   cancellation.  For `K = 6`: crude sup `≲ 10⁴` gives remainder `≤ 2·10⁴·(1/5)^6/6! = 3.6·10⁻³`.
4. Taylor inequality via `norm_sub_le_of_deriv_bound` + `AnalyticAt.fderiv`
   (iteration), as in §2b.3.
5. `h2`, then `zeta_zero_14_of_bounds h1_deriv h2`, then the unconditional
   `∃ z ∈ closedBall s14 (1/5), ζ z = 0`.

Numbers probed this round (30 dps): the true sup of `|ζ′(z) − ζ′(s14)|` over the
closed `1/5`-ball is **`0.1392795`**, and `Σ_{k=2..K} k|c_k| r^{k−1}` is already
`0.1392468` at `K = 4` and `0.1392800` at `K = 6` — the triangle inequality is
essentially *tight* (`|c_k|` falls off like `k!`), so no circle subdivision is
needed and even a crude `sup|ζ^(7)|` leaves ≥25% margin.  Use **`K = 6`**.
The individual coefficients are tabulated in §2b; the key design simplification
is the factorization `zetaEMGen 3 20 s = Σ n^{-s} + 21^{-s}·Ψ(s)` with `Ψ`
rational, which reduces every `c_k` to Gaussian rationals times powers of
`log 21`, i.e. one induction plus point-box arithmetic.

### 2026-10-27 — I.295: `h2` setup — the `Ψ₃` factorization (T392–T397)

Opened `lean/EMTaylor.lean` (now the 14th file in `check.sh`, 16 s) with the
structural fact on which the whole `h2` computation rests:

```lean
Psi3 (s : ℂ) := 21/(s-1) + 1/2 + s/252
                  + P₃(-s)/(720·9261) - P₅(-s)/(30240·4084101)
gen3_eq_sum_psi :
  zetaEMGen 3 20 s = Σ_{n≤20} n^{-s} + 21^{-s} * Psi3 s
```

with the supporting folds `pow21_neg_add_three` (`21^(-(s+3)) = 21^(-s)/9261`),
`pow21_neg_add_five`, and the `ℂ`-versions of `21^{-3}`, `21^{-5}`.  The
explicit six-piece expansion is `zetaEMGen_three_explicit`.

**Why this matters.** `Ψ₃` is *rational*, so with
`dᵏ[21^{-s}Ψ₃(s)] = 21^{-s} Σ_{j≤k} C(k,j) Ψ₃^{(j)}(s) (-log21)^{k-j}`
every Taylor coefficient of the `K = 3` generator at `s14` is a Gaussian
rational (from `(s14-1)^{-m}`, `P₃(-s14)`, `P₅(-s14)`) times a polynomial in
`log 21` — exactly the point-box arithmetic that `Vbox` already does.  The only
remaining piece for `c_k` is therefore the Leibniz induction plus the
`Ψ₃^{(j)}(s14)` values, and `ζ = gen₃ + R₃` adds only the small `R₃`
correction `≤ 6·10⁻⁵/ρ^k` (Cauchy).

Two Lean frictions, both from unfolding `descPochhammer`: `simp [descPochhammer]`
turns `(descPochhammer ℂ 3).eval (-s)` into a nested `Polynomial.comp` which no
longer matches the hand-written product; and `norm_num` alone leaves a
cast-vs-literal mismatch (`↑(-1/720) * 2` against `-1/360`).  The recipe that
worked: prove the product forms `hP3`, `hP5` separately, do **not** put
`descPochhammer` in the `simp only` set (only `descPochhammer_zero`), then
`rw [emCoef_two, emCoef_three]; push_cast; ring`.

**Next:** the Taylor remainder.  `Mathlib.Analysis.Calculus.Taylor` has exactly
what is needed — `taylor_mean_remainder_bound` for `f : ℝ → E` (so `E = ℂ`):

```
‖f x - taylorWithinEval f n (Icc a b) a x‖ ≤ C * (x - a)^(n+1) / n!
```

Apply with `a = 0`, `b = 1`, `f t = deriv ζ (s14 + t·w)`, `n = K-1`, and
`C = sup|ζ^{(K+1)}| · r^K`; the remainder is then `≤ sup·r^K/(K-1)!`.  For
`K = 6`: `sup·1.067·10⁻⁷`, so even a crude `sup|ζ^{(7)}| ≤ 3000` gives
`3.2·10⁻⁴`.  Bookkeeping to prove: `iteratedDeriv k (t ↦ ζ(s14+t·w)) t =
iteratedDeriv k ζ (s14+t·w) · w^k` for `k ≤ K+1` (induction with the chain
rule), `ContDiffOn ℝ (K+1)` of the parametrised function from analyticity of
`ζ` on the ball, and `iteratedDerivWithin_eq_iteratedDeriv` on the interior of
`[0,1]`.

**API shortcut found while writing I.295.** For complex functions one can avoid
the `ContDiffOn`/`iteratedDerivWithin` bookkeeping entirely:
`Complex.hasSum_taylorSeries_on_ball`
(`Mathlib/Analysis/Complex/TaylorSeries.lean`) needs only
`DifferentiableOn ℂ f (Metric.ball c r)` and gives the exact series
`ζ(s14+w) = Σ (n!)⁻¹ (iteratedDeriv n ζ s14) w^n`; the derivative series follows
from `HasFPowerSeriesOnBall.fderiv`.  For the *remainder* the `ℝ`-side theorem
`taylor_mean_remainder_bound` is still the most convenient, but its
`hf : ContDiffOn ℝ (n+1) …` can be fed from `AnalyticOn.contDiffOn` once
analyticity of `ζ` on the ball is extracted via
`DifferentiableOn.hasFPowerSeriesOnBall` (the same lemma used inside
`hasSum_taylorSeries_on_ball`).

### 2026-10-27 — I.296: the exponential factor of the Taylor coefficients (T398)

`iteratedDeriv_cpow_neg : iteratedDeriv k (fun s => b^(-s)) = fun s => (-log b)^k * b^(-s)`
for `b ≠ 0` (induction on `k`, using `hasDerivAt_cpow_neg` and
`HasDerivAt.const_mul`).  This is one of the two factors of every Taylor
coefficient: with `b = 21` it gives the powers of `log 21` in
`Σ_{j≤k} C(k,j) Ψ₃^{(j)}(s14) (-log21)^{k-j}`, and with `b = n` it gives the
moments `(log n)^k` of the base sum.

Remaining for `c_k`: (i) `iteratedDeriv_sum` over the 20 base atoms (needs
`ContDiffAt` of `s ↦ n^{-s}`, which must be assembled by hand — Mathlib has no
`ContDiffAt` lemma for `Complex.cpow`, so go through
`fun s => Complex.exp (-s * Complex.log b)`); (ii) the Leibniz formula for
`21^{-s}·Ψ₃(s)` (or the packaged `iteratedDeriv (fun s => 21^{-s} * g s)`);
(iii) `Ψ₃^{(j)}(s14)` for `j ≤ 6` as boxes from `1/(s14-1) = (-2-56i)/785`
and the polynomial derivatives of `P₃`, `P₅`.

**Update (I.298).** The explicit-implicit form
`rw [iteratedDeriv_sum (I := Finset.range 20) (f := fun n z => …) (x := s) hf]`
also fails (application type mismatch on `hf`, same metavariable issue).  The
robust fallback, not yet tried, is `Finset.induction` on the sum with
`iteratedDeriv_add` (`ContDiffAt` of each term is `contDiffAt_cpow_neg`, T399),
or state the result as an equality of *functions*
(`iteratedDeriv k (∑ n ∈ range 20, fun z => …) = …`) so the expected type fixes
all implicits.  `EMTaylor.lean` is green at T399; nothing is left uncommitted.

### 2026-10-27 — I.299: the derivative toolkit for `c_k` (T400–T402)

Three of the four derivative formulas needed for the Taylor coefficients now
compile in `EMTaylor.lean`:

* `iteratedDeriv_sum_cpow` — `iteratedDeriv k (Σ_{n≤20} n^{-s}) s =
  Σ (log n)^k n^{-s}`.  **The `iteratedDeriv_sum` friction of I.297/I.298 is
  solved**: (i) bridge the lambda to a sum of *functions* first
  (`hfun : (fun z => ∑ n, g n z) = ∑ n, fun z => g n z`, by
  `funext; simp [Finset.sum_apply]`), (ii) pass **every** implicit explicitly —
  `iteratedDeriv_sum (n := k) (x := s) (I := Finset.range 20)
  (f := fun (n : ℕ) => fun z => …)` — the `(n : ℕ)` annotation is essential
  or Lean infers the index type `ℝ`.
* `iteratedDeriv_mul_pow21` — Leibniz with the exponential factor.
* `iteratedDeriv_inv_sub_one` — `d^j (s−1)⁻¹ = (−1)^j j! ((s−1)^{j+1})⁻¹`,
  state:d pointwise with `s ≠ 1`; the induction uses
  `Filter.EventuallyEq.deriv_eq` on the punctured neighbourhood (add
  `open Filter Topology` for `𝓝`).

Still needed: the polynomial factor `iteratedDeriv j (fun s => p.eval (-s)) s =
(-1)^j (p.derivative^[j]).eval (-s)` for `p = descPochhammer ℂ 3, 5`.  There is
**no** `Polynomial.hasDerivAt` in this Mathlib; the next step is to locate the
derivative-of-polynomial-eval lemma (candidates: `Polynomial.deriv_eval`,
`Polynomial.derivative_eval`, or the `HasDerivAt` instance in
`Mathlib/Analysis/Calculus/Deriv/Polynomial.lean` — not yet found), or to prove
it from `Polynomial.derivative` by induction on the polynomial.

After that: evaluate `Ψ₃^{(j)}(s14)` (`j ≤ 6`) as Gaussian rationals in the ring
`ℚ(i)[log 21]`, box them with the `Vbox`-style arithmetic, and bound
`|c_k|`.  The numerical targets are in §2b.

### 2026-10-27 — I.300: polynomial factor too (T403); the `c_k` toolkit is complete

`iteratedDeriv_polynomial_neg : iteratedDeriv j (fun s => p.eval (-s)) =
fun s => (-1)^j * (p^{(j)}(-s))`.  All four derivative formulas needed for the
Taylor coefficients now compile (T400–T403).

**Notation traps paid for here** (both cost a compile each):
* `p.derivative` is fine, but `Polynomial.derivative^[j]` does **not** parse —
  `^[` falls back to `GetElem` indexing.  Workaround: a plain wrapper
  `def PolyD : Polynomial ℂ → Polynomial ℂ := fun p => Polynomial.derivative p`
  and a *recursive* `def polyIter : ℕ → Polynomial ℂ → Polynomial ℂ
  | 0, p => p | (j+1), p => PolyD (polyIter j p)`.  With the successor peeling
  from the right, `polyIter (j+1) p = (polyIter j p).derivative` is definitional,
  so no commutation lemma is needed (peeling from the left does need one, and
  the naive `rfl` fails).
* `ℂ[X]` was not in scope in this file — write `Polynomial ℂ` (the `[X]`
  notation is scoped).  This was the source of a misleading
  "failed to prove index is valid" error.

**Next:** `iteratedDeriv j Psi3 s14` for `j ≤ 6` from the four formulas via the
linearity of `iteratedDeriv` (`iteratedDeriv_add`, `iteratedDeriv_const_mul`,
both needing `ContDiffAt` of each summand — obtainable from
`ContDiffAt.inv`/`ContDiffAt.add`/`fun_prop`), then the boxes for
`c_k = (gen3^{(k)}(s14) + R3^{(k)}(s14))/k!`.

### 2026-10-27 — I.301: linearity over finite sums (T404)

`iteratedDeriv_finset_sum` — general `ι`, `Finset ι`, same `Finset.sum_apply`
bridge as T400; this is what lets `Ψ₃` be split into its five terms and
differentiated term by term.

**Recipe for `Ψ₃^{(j)}(s14)`** (next):
```lean
def psiTerm : Fin 5 → ℂ → ℂ
  | 0 => fun s => 21 * (s - 1)⁻¹
  | 1 => fun s => (1/2 : ℂ)
  | 2 => fun s => s / 252
  | 3 => fun s => (descPochhammer ℂ 3).eval (-s) / (720 * 9261)
  | 4 => fun s => -((descPochhammer ℂ 5).eval (-s) / (30240 * 4084101))
theorem Psi3_eq_sum : Psi3 = fun s => ∑ i : Fin 5, psiTerm i s
theorem iteratedDeriv_Psi3 (j) (s) (hs : s ≠ 1) :
  iteratedDeriv j Psi3 s
    = 21 * (-1)^j * j! * ((s-1)^(j+1))⁻¹
      + (if j = 1 then (1/252:ℂ) else 0)
      + (1/(720*9261)) * ((-1)^j * ((polyIter j (P3Poly)).eval (-s)))
      - (1/(30240*4084101)) * ((-1)^j * ((polyIter j (P5Poly)).eval (-s)))
```
using `iteratedDeriv_finset_sum` (T404), `iteratedDeriv_inv_sub_one` (T402),
`iteratedDeriv_polynomial_neg` (T403), `iteratedDeriv_const_mul`
(`Lemmas.lean:368`) and `iteratedDeriv_fun_id`-style facts for `s/252`.  The
`ContDiffAt` obligations: `ContDiffAt.inv` (`Operations.lean:800`) for term 0,
constants for 1–2, and for `fun s => p.eval (-s)` one still needs a
`ContDiffAt` fact for polynomial evaluation — check `Polynomial.contDiff`
(`Mathlib/Analysis/Calculus/Deriv/Polynomial.lean` has only `hasDerivAt`;
look in `Mathlib/Analysis/Polynomial/*` or use `fun_prop`).

### 2026-10-27 — I.302: smoothness of polynomial evaluation and the `Ψ₃` split (T405–T406)

`contDiff_polynomial_eval : ContDiff ℂ n (fun s => p.eval s)` — from Mathlib's
`Polynomial.contDiff_aeval` (`Mathlib/Analysis/Calculus/ContDiff/Polynomial.lean`,
the *only* lemma in that file) with a `simpa` (`aeval` = `eval` under the
identity algebra).  Then `contDiffAt_polynomial_eval_neg` by composition, which
supplies the last `ContDiffAt` obligation for the `Ψ₃` derivative.

`Psi3_eq_sum : Psi3 = fun s => ∑ i : Fin 5, psiTerm i s` with
`def psiTerm : Fin 5 → ℂ → ℂ` (five explicit terms), by
`simp only [Psi3, psiTerm, Fin.sum_univ_five]; rw [div_eq_mul_inv]; ring`.

**So the only missing piece for `Ψ₃^{(j)}(s14)` is the term-by-term
computation** (`iteratedDeriv_Psi3`), for which every ingredient now exists:
`iteratedDeriv_finset_sum` (T404), `iteratedDeriv_inv_sub_one` (T402),
`iteratedDeriv_polynomial_neg` (T403), `iteratedDeriv_const_mul`
(`Lemmas.lean:368`), `iteratedDeriv_const`, `iteratedDeriv_fun_id`
(`Lemmas.lean:410`), and the `ContDiffAt` facts (incl. T405).  Watch the shape of
`iteratedDeriv_const_mul` (`c * f x` vs `f x * c`) and rewrite `… / C` to
`… * C⁻¹` before applying it.

### 2026-10-27 — I.303: exact `Ψ₃^{(j)}(s14)` and the `c_k` targets

Computed in `sympy` (exact rationals, `s14 = 1/2 + 14i`,
`Ψ₃ = 21/(s−1) + 1/2 + s/252 + P₃(−s)/(720·9261) − P₅(−s)/(30240·4084101)`):

| j | `Ψ₃^{(j)}(s14)` |
|---|---|
| 0 | `39765388134947/88640021191680 − (31957632314371/22160005297920)i` |
| 1 | `26981771701667341/243538458224140800 − (1849142049389/241605613317600)i` |
| 2 | `38985956058659131/23897211213243816000 + (12952590191792761/853471829044422000)i` |
| 3 | `−10127609715859404893/3126551800399399260000 + (25995669568631621/55831282149989272500)i` |
| 4 | `−101763989839147157867/613585790828382104775000 − (20144741568085642927/21913778243870789456250)i` |
| 5 | `15691992412343226121901/48166484580027995224837500 − (3316669526016/46800224473278125)i` |
| 6 | `1297363014162432/36738176211523328125 + (5083137461477376/36738176211523328125)i` |

These are the coefficients of the `21^{-s}` scalar box
`S_k = Σ_{j≤k} C(k,j) Ψ₃^{(j)}(s14)(−log21)^{k−j}`; numerically

```
S₁ = −1.25503281554 + 4.38294686730i
S₂ =  3.48530250391 − 13.3055023049i
S₃ = −9.59732356944 + 40.3460147226i
S₄ = 26.1675372490 − 122.201521268i
S₅ = −70.5108666751 + 369.711616564i
S₆ = 187.286523146 − 1117.28922378i
```

and the resulting Taylor coefficients (sanity check against §2b):

```
|c₁| = 0.7756597116   |c₂| = 0.3189210681   |c₃| = 0.0917586578
|c₄| = 0.0208557904   |c₅| = 0.0039905647   |c₆| = 0.0006668747
```

**How to build the `c_k` enclosure (next session).**
`c_k = ( gen3^{(k)}(s14) + R₃^{(k)}(s14) ) / k!` with
`gen3^{(k)}(s14) = −Σ_{n≤20}(log n)^k n^{-s14} + 21^{-s14}·S_k`
(`iteratedDeriv_sum_cpow` T400 + `iteratedDeriv_mul_pow21` T401 + `iteratedDeriv_Psi3`
still to prove).  The box is
`(dsPowPow k).neg.add ((cpowBox 20 16 48 24 21 S14).mul scalarBox k)`
where `scalarBox k` is the point box chain `logIvRat`-powers (T342/T344-style),
exactly as `Vbox` does for `k = 1`.  `R₃^{(k)}(s14)` is bounded by repeated
Cauchy on the `1/2`-ball: `|R₃^{(k)}| ≤ k!·6·10⁻⁵/0.5^k`, i.e. `/k!` gives
`≤ 6·10⁻⁵/0.5^k` — for `k = 2` that is `2.4·10⁻⁴`, only `0.075%` of
`|c₂| = 0.3189`, and it grows to `0.0038` for `k = 6` where the term
`k|c_k|r^{k−1}` is only `1.3·10⁻⁶`, so the crude Cauchy correction is harmless.

`|c_k|` bounds only need ~30% accuracy for the sum `Σ_{k=2..6} k|c_k|r^{k−1}`
to stay below `0.14`, so the boxes can be coarse.

### 2026-10-27 — I.304: the five `Ψ₃` term derivatives (T407–T412)

Each `psiTerm` is differentiated by the `@[simp]` field lemmas
`iteratedDeriv_const_mul_field`, `iteratedDeriv_mul_const_field`,
`iteratedDeriv_const`, `iteratedDeriv_id` — so **no `ContDiffAt` obligations**
for the term derivatives:

```
d^j (21(s−1)⁻¹)            = 21 · d^j (s−1)⁻¹
d^j (1/2)                  = if j = 0 then 1/2 else 0
d^j (s/252)                = if j = 0 then s/252 else if j = 1 then 1/252 else 0
d^j (P₃(−s)/(720·9261))    = (1/(720·9261)) · d^j P₃(−s)
d^j (−P₅(−s)/(30240·4084101)) = −(1/(30240·4084101)) · d^j P₅(−s)
```

Frictions: `iteratedDeriv_id` is stated for `id`, not for `fun x => x`, so it
does not fire syntactically — added `iteratedDeriv_fun_id'` (same statement with
the lambda) and used `obtain (_|_|j) := j` case splits.  The `/(720*9261)`
shape needs `simp` then `ring` (the goal becomes `A / C = C⁻¹ * A`).

**Only step left for `Ψ₃^{(j)}`:** combine T404 (`iteratedDeriv_finset_sum`),
`Psi3_eq_sum` (T406) and T407–T412.  T404 needs a `ContDiffAt ℂ j` proof for
each `psiTerm i`; the only non-obvious ones are
`ContDiffAt.inv` for term 0 (`sub_ne_zero.mpr hs`) and
`contDiffAt_polynomial_eval_neg` (T405) for terms 3–4.  Then
`d^j Ψ₃(s14)` follows from T402/T403.

### 2026-10-27 — I.305: `Ψ₃^{(j)}` is done (T413)

`iteratedDeriv_Psi3` now compiles — the closed form of `d^j Ψ₃` for `s ≠ 1`,
combining T404 + T406 + T407–T412 + T402 + T403.  The assembly needed only two
non-`fun_prop` `ContDiffAt` goals (the polynomial terms 3 and 4), supplied by
`ContDiffAt.div_const`/`ContDiffAt.neg` of `contDiffAt_polynomial_eval_neg`
(T405); `fun_prop` handles the pole, constant and `s/252` terms.

**So the whole `c_k` input chain is now proved.**  For `k = 1..6`:
`gen3^{(k)}(s14) = −Σ_{n≤20}(log n)^k n^{-s14} + 21^{-s14}·S_k` with
`S_k = Σ_{j≤k} C(k,j) Ψ₃^{(j)}(s14)(−log21)^{k−j}` (exact values in I.303).
The remaining work is the box construction
(`dsPowPow k` + `cpowBox 21 S14 · scalarBox k` + the `R₃` Cauchy correction),
the `sup|ζ^{(6)}|` bound, the Taylor remainder (`taylor_mean_remainder_bound`,
`K = 6`), and the `h2` / `zeta_zero_14_of_bounds` assembly.

### 2026-10-27 — I.306: smoothness of `Ψ₃` (T414)

`contDiffAt_Psi3 : ContDiffAt ℂ n Ψ₃ s` for `s ≠ 1`, via `Psi3_eq_sum` (T406),
`ContDiffAt.sum` and `fin_cases` on the five terms.  `fun_prop` solves the pole
(`21(s−1)⁻¹`, using `s−1 ≠ 0` from the context), the constant and `s/252`;
the polynomial terms need `contDiffAt_polynomial_eval_neg` (T405) with
`ContDiffAt.div_const`/`.neg`.  **Trap:** `ContDiffAt.const_mul` does not exist
as a dotted name in this Mathlib (dot notation resolves to `Function.const_mul`
and fails) — use `fun_prop` instead.

This was the last missing `ContDiffAt`, so `iteratedDeriv k (zetaEMGen 3 20) s`
now follows from `gen3_eq_sum_psi`, `iteratedDeriv_add` (both sides smooth:
T399-sum and `ContDiffAt.mul` of T399 with T414), T400 and T401 — the next step.

### 2026-10-27 — I.307: state of the `gen3^{(k)}` corollary

Attempted (in a throwaway probe, not committed) the corollary

```lean
iteratedDeriv k (zetaEMGen 3 20) s
  = Σ_{n≤20} (−log n)^k n^{−s}
    + Σ_{i≤k} C(k,i) (−log21)^i 21^{−s} · iteratedDeriv (k−i) Ψ₃ s
```

from `gen3_eq_sum_psi` (T397) + `iteratedDeriv_add` + T400 + T401.  Two Lean
obstacles, both in supplying the `ContDiffAt` hypotheses:

1. `ContDiffAt.sum` would not unify after the `Finset.sum_apply` bridge — likely
   the same implicit-shape problem as `iteratedDeriv_sum` (needs every implicit
   `(I := …) (f := …)`, and the index type annotated).
2. `rw [gen3_eq_sum_psi]` left the goal in a shape where `iteratedDeriv_add`'s
   LHS `iteratedDeriv n (f + g) x` did not match syntactically — rewrite with an
   explicit `show (fun z => A z + B z) = A + B from rfl` first.

The main file is green and committed at T414; the probe was deleted.  **Next
session**: supply the sum's `ContDiffAt` by *induction over `Finset.range 20`*
(or `ContDiffAt.sum` with all implicits), then the corollary.

### 2026-10-27 — I.308: the `gen3^{(k)}` corollary (T415)

`iteratedDeriv_gen3` compiles — the closed form of the `k`-th derivative of the
`K = 3` generator, i.e. **the input to the `c_k` boxes**:

```lean
iteratedDeriv k (zetaEMGen 3 20) s
  = Σ_{n≤20} (−log n)^k n^{−s}
    + Σ_{i≤k} C(k,i)(−log21)^i 21^{−s} · iteratedDeriv (k−i) Ψ₃ s     (s ≠ 1)
```

Both obstacles of I.307 solved:
1. `ContDiffAt.sum`'s conclusion is *already* `ContDiffAt _ _ (fun x => ∑ i, f i x)`
   — so do **not** apply the `Finset.sum_apply` bridge first (it moves the goal
   away from the lemma); just `apply ContDiffAt.sum`.
2. `gen3_eq_sum_psi` is a *pointwise* equality, so `rw` cannot rewrite under
   `iteratedDeriv`; build the function equality first
   (`funext z; exact gen3_eq_sum_psi z`), then `rw`, then the
   `(fun z => A z + B z) = A + B` `rfl`-bridge for `iteratedDeriv_add`.

**Next:** evaluate at `s = s14`, build the boxes
`(dsPowPow k) + cpowBox 21 S14 · scalarBox k` (exact `Ψ₃^{(j)}(s14)` and `S_k` in
I.303), add the `R₃` Cauchy correction, and bound `|c_k|`.

### 2026-10-27 — I.309: box powers of `log b` (T416)

`logBoxPow N b k` = the `k`-th power of the `log b` point box (`ptBox 1 0` at
`k = 0`, then `Cx.mul` with `⟨logIvRat N b, 0⟩`), with
`mem_logBoxPow : (logBoxPow N b k).mem ((Complex.log ↑b)^k)`.  This is the first
piece of the `c_k` box: the base-sum term is `(log n)^k n^{-s14}`, i.e.
`logBoxPow 20 n k × cpowBox 20 16 48 24 n S14` (the same `derivAtom` pattern as
`Vbox`, with the plain log box replaced by its `k`-th power).

**Remaining box work:** `dsPowPow k` (fold of those atoms), the `21^{-s14}`-side
`scalarBox k` (a `ℂ`-box from the exact `S_k` values of I.303), the `R₃`
correction, and `corner`/`native_decide` tests for the six `c_k`.

### 2026-10-27 — I.310: the base-sum box for `c_k` (T417)

`derivAtomPow k n = cpowBox 20 16 48 24 n S14 × logBoxPow 20 n k`, its fold
`dsPowPow k`, and `dsPowPow_mem : (dsPowPow k M).mem (Σ_{n<M} n^{-s14}(log n)^k)`
— the exact analogue of `dsPow`/`dsPow_mem` (T341) with the log box raised to
the `k`-th power.  **Trap:** do *not* `rw [mul_comm]` before `Cx.mem_mul`; the
box product's factor order must match the sum term's order, otherwise
`Cx.mem_mul` expects the log membership against the `cpowBox`.

So the `c_k` enclosure is now:

```
c_k ≈ ( (dsPowPow k 20) + (cpowBox 21 S14) × (scalarBox k) + R₃-ball ) / k!
```

with only the `21^{-s14}`-side `scalarBox k` (from the exact `S_k`, I.303) and
the numeric `R₃` correction left.  Suggestion for the `scalarBox`:
`S_k = Σ_{j≤k} C(k,j) Ψ₃^{(j)}(s14) (−log21)^{k−j}`; build it as
`ptBox (Re S_k) (Im S_k)` for each `k = 1..6` (the exact rationals are in I.303)
times `logBoxPow`-powers of `log21`, or — simpler — use `native_decide` on the
final corner as `Vbox` did.

### 2026-10-27 — I.311: the `c_k` box layer is done (T418–T442)

`gen3Box k` now encloses `gen₃^{(k)}(s14)` for every `k ≤ 6`, with **native_decide**
corner certificates, so the Taylor coefficients `c_k = ζ^{(k)}(s14)/k!` are
within reach.  25 new theorems in `EMTaylor.lean`:

* **exact `Ψ₃^{(j)}(s14)`** (`j ≤ 6`) as Gaussian rationals — the values of I.303
  are now *proved*, digit for digit, from the closed form T413;
* the scalar box `sBox k` = `Σ_i C(k,i)(−log21)^i 21^{-s14} Ψ₃^{(k−i)}` (i.e.
  `21^{-s14}·S_k`, the I.303 table), the base-sum box reused via `dsPowPow k`;
* `gen3Box k` membership and `|gen₃^{(k)}(s14)| ≤ q_k` with

  ```
  k     2      3      4      5      6
  q_k   0.70   0.61   0.55   0.53   0.53      (true 0.6378 0.5506 0.5005 0.4789 0.4802)
  ```

**What made the polynomial derivatives tractable.**  `Polynomial.derivative` is a
`Finsupp` sum, so `simp [polyIter]` alone leaves a `p.sum` it cannot evaluate
(the trap of I.296 is still there).  The fix is to *first* put the Pochhammer
symbols in monomial form (`P3_mono`, `P5_mono`: `simp [descPochhammer]; ring_nf`)
and then `simp [polyIter, PolyD]` computes the iterated derivatives by the
ordinary `derivative_X_pow`/`derivative_mul` simp set.  Never put
`Polynomial.derivative` in a `simp` list — unfolding it re-introduces `.sum`.

Other frictions paid for:

1. **`(-1 : ℂ)^i` needs its re/im computed by induction.**  Coercion
   manipulations (`← Complex.ofReal_pow`, `push_cast`) do not unify the `ℚ`-cast
   and `ℝ`-cast occurrences; `neg_one_pow_re`/`neg_one_pow_im` by induction on
   `i` are two lines each and always fire.
2. **`Cx` has no `AddCommMonoid` instance**, so `∑ i in range, …` over `Cx`
   does not elaborate.  Use a fold (`sBox k : ℕ → Cx`), exactly as `dsPowPow`
   does, and keep the *value* sum a `Finset.sum` over `ℂ`.
3. **`convert h using 2` on a `Cx.mem` goal produces three subgoals** (value,
   box, and sometimes a split sum); the box goal is `rfl`, and the sum goal
   needs `Finset.sum_congr` + `ring` because the box's factor order is
   `C·((−1)^i·(log^i·(21^s·Ψ)))` while the target is `C·(−log)^i·21^s·Ψ`.
4. **State the `q` of a norm bound as `((q : ℚ) : ℝ)`**, not `(q / 100 : ℝ)`:
   `norm_gen3_deriv_le` produces the coerced ℚ form and the ℝ literal does not
   unify (two compiles).
5. **`interval_cases j` on `hj : j ≤ 6`** handles all seven `Ψ₃` values in one
   theorem; each case is `rw [iteratedDeriv_Psi3, P3_mono, P5_mono,
   inv_pow_s14_sub_one]; simp [polyIter, PolyD, psiRe, psiIm]; Complex.ext;
   simp [...]; norm_num` (23 s for the whole file).

Compile: `EMTaylor.lean` is now **192 s** — the five corner `native_decide`s
dominate (~30 s each); the structural proofs are seconds.  Batch edits to this
file or move the corner tests to a trailing certificate file if that becomes
painful.

**Numbers.**  `|gen₃^{(k)}/k!|` gives `Σ_{k=2..6} k|c_k|r^{k−1} = 0.13928`
(unchanged), and with `|R₃^{(k)}|/k! ≤ 6·10⁻⁵·2^k` (Cauchy on the `1/2`-ball)
the budget is

```
0.13928 + 1.5·10⁻³ (R₃ corrections) + 2·C·r⁶/6!  ≤  0.188
```

with `C = sup|ζ^{(7)}|` on the ball; the crude termwise bound gives
`C ≤ 6400`, so the remainder is `≤ 1.14·10⁻³` and the total `≈ 0.142` — 24%
margin.  **Next: `h2` proper:** (i) the `ζ = gen₃ + R₃` derivative split,
(ii) the Cauchy bound on `R₃` (use
`Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le` in
`Mathlib/Analysis/Complex/Liouville.lean`, radius `49/100`), (iii) the
`sup|ζ^{(7)}|` bound, (iv) the downward Taylor induction via
`norm_sub_le_of_deriv_bound`, with `AnalyticAt.deriv` supplying the
differentiability of every `iteratedDeriv k ζ` (`iteratedDeriv_succ`).

### 2026-10-27 — I.312: the `c_k` bounds — `ζ = gen₃ + R₃` split, Cauchy for `R₃` (T443–T456)

New file `lean/EMTaylorCert.lean` (15th in `check.sh`, 20 s), 14 theorems:

* **Analyticity chain.** `AnalyticAt ℂ riemannZeta s14` (from `DifferentiableOn` on
  the `1/2`-ball + `DifferentiableOn.analyticOnNhd`), then
  `AnalyticAt.deriv` iterated → `AnalyticAt ℂ (iteratedDeriv m ζ) s14` for every
  `m`.  This is the differentiability input the Taylor induction needs.
* **`ContDiffAt ℂ n (zetaEMGen 3 20) s`** for `s ≠ 1`, any `n` (the same
  `gen3_eq_sum_psi` decomposition as T415, with `ContDiffAt.sum`/`.mul`).
* **The derivative split** `iteratedDeriv_zeta_eq_gen3_add`:
  `ζ =ᶠ[𝓝 s14] gen₃ + R₃` on the `1/2`-ball (via `zeta_eq_zetaEM_of_im` and
  `zetaEMRemainder = zetaEM − gen`), then
  `Filter.EventuallyEq.iteratedDeriv_eq` + `iteratedDeriv_add`.
* **Cauchy for `R₃`:** `Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le`
  (`Mathlib/Analysis/Complex/Liouville.lean`) with radius `49/100`:
  `‖R₃^{(k)}(s14)‖ ≤ k!·6·10⁻⁵/(49/100)^k`.  Radius `49/100` (not `1/2`) because
  `norm_remainder_three_ball_le` is stated with a **strict** inequality.
* **The `c_k` bounds:** `‖c_k‖ ≤ q_k/k! + 6·10⁻⁵·(100/49)^k`, giving

  ```
  |c₂| ≤ 0.351    |c₃| ≤ 0.103    |c₄| ≤ 0.025    |c₅| ≤ 0.007    |c₆| ≤ 0.006
  ```

  so `Σ_{k=2..6} k|c_k|r^{k−1} ≤ 2·0.351·0.2 + 3·0.103·0.04 + 4·0.025·0.008
  + 5·0.007·0.0016 + 6·0.006·0.00032 = 0.15363`.

Traps: `differentiableOn_zetaEM` is stated on `{0 < re ∧ s ≠ 1}`, so the ball
bound needs an explicit `.mono`; `ContDiffAt.differentiableAt` needs `1 ≠ 0`;
`Complex.norm_natCast` already closes `‖(n:ℂ)‖ = n` (a trailing `simp` then
errors with "no goals"); and the Cauchy estimate's `C` must be given for the
**sphere**, not the ball, so every bound `‖z − s14‖ ≤ 49/100` on a sphere is
converted to `< 1/2` first.

Remaining for `h2`: `sup|ζ^{(7)}| ≤ 25000` on the closed `1/5`-ball, then the
downward Taylor induction.  Budget with `K = 6`:
`0.15363 + 2·25000·(1/5)^6/6! = 0.15363 + 0.00889 = 0.1625 ≤ 47/250` ✔ (14%).
The sup bound decomposes as
`Σ_{n≤20}(log n)^7 ≤ 13189` (using `logIvRat 20 n` upper endpoints, no `rpow`
evaluation needed — `n^{-z} ≤ 1` on `Re z ≥ 0`) + `21`-part `≤ 6500`
(`log 21 ≤ 61/20` from `logIvRat`, and `Ψ₃^{(j)}` bounds from the T413 closed
form with polynomial derivatives by Cauchy on a radius-`10` ball) + `R₃^{(7)}`
`≤ 1800` (Cauchy, radius `29/100` around each point).
