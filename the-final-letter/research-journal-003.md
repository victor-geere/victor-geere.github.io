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

Counts: **T1–T391 · 849 ledger theorems · 48/48 topics · 13 Lean files green ·
audit 48/48 · links 0 broken**.

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
