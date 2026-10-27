# Research journal 002 — continuation bootstrap

**Purpose.** `research-journal.md` (001) has reached 3000+ lines. This file is
the *only* thing a fresh session needs to read in order to continue the
`finite-window-zeros` Krawczyk programme. It holds live state, the exact next
steps, and the traps already paid for. Append new entries here; do not
re-derive 001.

Referenced from `research-journal.md` (entry I.282).

---

## 0. One-paragraph state

Goal: a Lean-certified zero of `ζ` at `1/2 + 14i` via Krawczyk. **Step 3 is
done** (`‖ζ(1/2+14i)‖ ≤ 1/8`, sharpened to `23/200`, and `hmap` discharged).
**Step 5 is done but conditional** (`zeta_zero_14_of_bounds`, T329). **Step 4
(`hC`) is reduced to two numerical hypotheses `h1`, `h2`** (T328–T329), and
those are the only outstanding obligations. Steps 1–2 of the original handoff
were *substituted*, not completed (the Euler-acceleration route for `η` is
asymptotic, not convergent). The Krawczyk radius is **`1/5`, not `1/4`** (at
`1/4` the mean-value bound fails by 2%; `1/5` is a *stronger* statement).

Counts: **T1–T343 · 801 theorems · 48/48 topics · 13 Lean files green ·
audit 48/48 · links 0 broken**.

## 1. What is proved (chain, in order)

| range | content | file |
|---|---|---|
| T293–T305 | Euler–Maclaurin remainder bound at `0 < Re s` for **every** `K` (previously only `1 < Re s`) | `EMCritical.lean` |
| T306–T321 | 21-atom box: `‖ζ(s14)‖ ≤ 23/200` (T320/T322), `hmap` (T321) | `EMBox14.lean` |
| T322–T326 | `r = 1/5` Krawczyk data; `zeta_zero_fifth_ball` (conditional on `hC` only) | `EMBox14.lean` |
| T327–T329 | `hC_of_bounds`, `zeta_zero_14_of_bounds h1 h2` | `EMBox14.lean` |
| T330–T343 | derivative layer + `ζ′` enclosure + `21`-power folding | `EMDeriv.lean` |

Key named results:

```lean
zeta_norm_le_eighth   : ‖riemannZeta s14‖ ≤ 1/8
hmap_zeta_fifth      : ‖Yk * ζ s14‖ + (1/4)*(1/5) ≤ 1/5
zeta_zero_14_of_bounds
  (h1 : ‖1 - Yk * deriv ζ s14‖ ≤ 1/200)
  (h2 : ∀ z ∈ closedBall s14 (1/5), ‖deriv ζ z - deriv ζ s14‖ ≤ 47/250) :
  ∃ z ∈ closedBall s14 (1/5), ζ z = 0
```

`Yk = 12436403768/10^10 − (3397942771/10^10)i`, `‖Yk‖ ≤ 1.29` (T323),
`Yk ≠ 0` (T327). `s14 = 1/2 + 14i`, `S14` its point box.

## 2. The ONLY remaining obligations

`h1 : ‖1 − Yk·ζ′(s14)‖ ≤ 1/200` and
`h2 : ∀ z ∈ closedBall s14 (1/5), ‖ζ′(z) − ζ′(s14)‖ ≤ 47/250`.

Budget check: `1/200 + 1.29·(47/250) = 0.24752 ≤ 1/4` ✔ (do not tighten `h1`
below `1/200` without re-checking this; `1/1000` is *unachievable*).

### 2a. `h1` — three pieces

1. **Membership** `Cx.mem (V_expr at s14) Vbox`.
   `Vbox` is already defined in `EMDeriv.lean` and its corner is verified
   `≤ 4/5` by `native_decide` (true `|ζ′(s14)| = 0.77560`). What is missing is
   the proof that T339's expression evaluated at `s14` lies inside it.
   Ingredients, all available:
   * `hasDerivAt_zetaEMGen_one` (T339) — the closed-form `d/ds zetaEMGen 1 20`;
   * `pow21_one_sub` (T342), `pow21_neg_succ` (T343) — fold `21^{1−s}` and
     `21^{−(s+1)}` onto `21^{−s}`;
   * `dsPow_mem` (T341) — the `−Σ n^{-s} log n` part (`dsPow 20`, negated);
   * `mem_ptBox`, `Cx.mem_mul`, `Cx.mem_add`, `Cx.mem_neg`.
2. **Ball for the rest.** `ζ′ = (zetaEMGen 1 20)′ + B₄′ + B₆′ + R₃′`, where
   `|B₄′ + B₆′| ≲ 3.5·10⁻⁴` (bound `P₃, P₅` and their derivatives by moduli;
   **do not** compute `P₅′` symbolically) and
   `|R₃′| ≤ 2·M_R/0.45 = 1.77·10⁻⁴` (`M_R(K=3) = 3.97·10⁻⁵`) via
   `norm_deriv_le_of_norm_le_on_ball` (already in `EulerMaclaurin.lean`).
   Needs `Real.rpow` bounds on `21^{−3.5}` and `21^{−5.5}`.
3. **Assembly**: `h1` from `‖1 − Yk·V‖ ≤ |Yk|·(|V − ζ′| + ball)`; `V − ζ′ ≈ 2.8·10⁻⁴`.

### 2b. `h2` — Taylor model (design settled, round 17)

```
‖ζ′(z) − ζ′(s14)‖ ≤ Σ_{k=2..K} k·|c_k|·r^{k−1} + 2·sup|G^{(K+1)}|·r^K/K!
```

Measured (`mpmath`, 30 digits): `Σ k|c_k| r^{k−1} = 0.13928` for `K = 8`, which
is **exactly** the true sup — the triangle inequality is tight, so **no circle
subdivision is needed**. `r = 1/5`, budget `0.188`, 26% margin.
Taylor remainders: `K=5 → 0.0114`, `K=6 → 0.0010`.

Pieces:
1. point enclosures of `c_k = ζ^{(k)}(s14)/k!`, `k = 1..5` — differentiate
   `zetaEMGen 3 20` (see §2c), **no `Cx.inv` needed**: `(s14−1)^{−k}` is exactly
   rational at a point;
2. modulus bounds `sup|G^{(6)}| ≤ 2134` over the ball
   (`Σ_{n≤20} (log n)^m n^{−0.3}`, no cancellation needed);
3. Taylor inequality via `norm_sub_le_of_deriv_bound` (in `Krawczyk.lean`) plus
   `AnalyticAt.fderiv` / `AnalyticOnNhd.iteratedFDeriv`
   (`Mathlib/Analysis/Calculus/FDeriv/Analytic.lean`) to get that every
   `deriv^[k] ζ` is differentiable.

### 2c. Why `K = 3`, not `K = 2`

A *value* certificate works at `K = 2` (T306). A *derivative* certificate does
not: Cauchy on the remainder divides by `ρ` only, not `ρ^k`.

| `K` | `M_R` (ρ=0.45) | `1.29·2M_R/ρ` | vs `h1` budget `7.5·10⁻³` |
|---|---|---|---|
| 2 | `3.12·10⁻³` | `1.79·10⁻²` | ✗ 2.4× over |
| **3** | `3.97·10⁻⁵` | `2.28·10⁻⁴` | ✓ 33× margin |

Consequence: the assembly needs `zetaEMGen 3 20`, i.e. also the `B₆` term
`−(1/30240)·P₅(s)·21^{−(s+5)}` and its derivative.

## 3. Exact constants (pre-computed; do not re-derive)

```
s14 = 1/2 + 14i            ζ(s14)  ≈ 0.02224114261 − 0.10325812327i
                           ζ′(s14) ≈ 0.74823369612 + 0.20443653378i
                           |ζ′(s14)| = 0.77560
1/(s14−1)   = (−2 − 56i)/785
1/(s14−1)²  = (−3132 + 224i)/616225
value-box scalar  = 177437/395640 − (20383/14130)i
Vbox  scalar  A0 = 17190769/155288700 − (4704/616225)i
              A1 = −177437/395640 + (20383/14130)i       (= −value scalar)
V(s14) ≈ 0.747983 + 0.204563i    (V − ζ′ ≈ 2.8·10⁻⁴)
P₃(s14) = 7041/8 + (5327/2)i     |P₃| ≈ 2804
```

Box parameters (all atoms): `cpowBox 20 16 48 24 b S` with box `S`; the
`Krawczyk` rectangle probe used `N_log = 20`, `k = 16`, `kI = 48`, `n = 24`.
Atom widths measured `≤ 10⁻⁹` at a point — precision is *never* the binding
constraint.

## 4. Traps already paid for — read before writing code

1. **Probe arithmetic before building.** Three plans were wrong (region box,
   `K=2` for derivatives, the `Cx.inv` detour) and each was caught by checking
   the inequality numerically *first*. This has saved more time than any tactic.
2. **An existential probe only gives the bound you asked for.** `width ≤ 1e-3`
   passing tells you nothing about the true width; bisect until it fails.
3. **A box enclosure over a 2D region is impossible.** A single atom
   `20^{-S}` over the ball's rectangle is already `≥ 0.1` wide (probed in Lean);
   interval arithmetic captures no cancellation over a region. Never quantify
   over a region with `CpowBox`. Points only — or a Taylor model.
4. **`Nat.cast` vs `OfNat`.** Terms render as `↑(↑20 + 1)` and `21^(-(s + ↑0))`;
   rewrite lemmas must be stated `((↑(20:ℕ) : ℝ) + 1 : ℝ)` and
   `-(s + (↑(0:ℕ) : ℂ))`, never with bare numerals. Four compiles lost to this.
5. **Read the lemma, don't guess its shape.** `Complex.cpow_def` is *piecewise*
   (`if b = 0`), needing `if_neg hb`; `Complex.cpow_add` is not.
   `HasDerivAt.inv` yields `-1/(s-1)^2`, not `-(s-1)⁻¹^2`.
6. **`HasDerivAt.comp` leaves a syntactic `Function.comp`** — needs a `rfl`
   rewrite before `convert`. But pointwise *function addition* unifies
   directly: after `convert`, check which goal is left rather than assuming.
7. **`convert h using 1` may leave only the value goal** (functions unify
   definitionally). A redundant `ring` then errors with "No goals".

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
./lean/check.sh                 # 13 files, ~6 min
./lean/check.sh EMDeriv.lean    # single file, ~1 min
cd /Users/victor/workspace/victor-geere.github.io
python3 the-final-letter/topics/tools/audit_topics.py
python3 the-final-letter/tools/check-links.py
```

## 7. Entries

### 2026-10-27 — I.282: journal split

Split the journal. 001 is at 3033 lines and dominated by the step-1–3 history;
reading it costs more context than it saves. From here, append to 002 only.
State, next steps, exact constants and traps are all above; nothing else is
needed to continue.

### 2026-10-27 — I.283: `h1(a)` scalar identities done (T344–T347)

Started `h1(a)` and finished its algebraic heart.  The `21`-part of T339 at `s14`
is `21^{1-s}·(-log21/(s-1) - 1/(s-1)²) - log21·21^{-s}/2 + (1/12)(21^{-(s+1)} -
s·log21·21^{-(s+1)})`; folding with T342/T343 turns it into `21^{-s14}` times

    21·(-log21/(s14-1) - 1/(s14-1)²) - log21/2 + (1/12)(1/21 - s14·log21/21)

which is `log21·A1c + A0c` with the exact Gaussian rationals

    A0c = 17190769/155288700 - (4704/616225)i
    A1c = -177437/395640 + (20383/14130)i

(T344–T347, `EMDeriv.lean`).  Split into two rational identities `A1_eq`, `A0_eq`
(each by `Complex.ext` + `norm_num` after `inv_s14_sub_one`), then recombined by
`linear_combination log21 * A1_eq + A0_eq`.

Two frictions: `A0_eq` needed `pow_two` in the simp set, because `simp` renders
`((…)^2).re` without expanding the square; and `scalar_eq` collided with the
`EMBox14` name of the same shape, so it is `scalar_eq_deriv` here.  Worth
checking for name clashes before appending to a file in the same namespace.

**Next**: the membership `Cx.mem (V at s14) Vbox`.  The scalar side is now a
single object (`log21·A1c + A0c`, matching `scalarBox` via `mem_ptBox` +
`mem_logBox`), so what remains is the `dsPow_mem`/`mem_neg`/`mem_add` wiring and
the `Complex.ofReal_log` bridge from `↑(Real.log b)` to `Complex.log ↑b`.

### 2026-10-27 — I.284: the `log` bridge (T348); journal policy updated

`ofReal_log_natCast` (T348): `↑(Real.log b) = Complex.log ↑b` for `b ≥ 1`,
one line from `Complex.ofReal_log`.  This is the rewrite that lets
`dsPow_mem`'s value (phrased with `Real.log`) meet T339's expression (phrased
with `Complex.log`); it is the last trap in `h1(a)`.

**Journal policy (new).**  This file is the live journal.  Append every
increment here.  When it passes ~500 lines, split the same way 001 was split:
create `research-journal-003.md` carrying live state + exact constants + traps +
next steps, leave dated history in 002, and add a pointer at the top of 002.
Currently 218 lines, so no split yet.

**Next**: the `h1(a)` membership wiring — `dsPow_mem` + `mem_neg` + `Cx.mem_add`
on the sum side, `cpowBox_mem` × `scalarBox` (`mem_ptBox`, `mem_logBox`,
`Cx.mem_mul`) on the `21^{-s14}` side, then `scalar_eq_deriv` to match the
scalar and `ofReal_log_natCast` to match the logs.
