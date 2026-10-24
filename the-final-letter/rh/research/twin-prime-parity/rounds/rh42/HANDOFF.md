# RH42 — HANDOFF: the helix reading of the greedy digit word

**Created:** 2026-10-03, end of the rh41 round (the round that closed the factor-complexity
law and produced the Lean development in [`../rh41/lean`](../rh41/lean)).
**Working directory:** `/Users/victor/workspace/rh`.
**Status:** rh42 open. The round's object is the *signed* ("Tau") alphabet of the public
Note 041 pages and the zeta budgets that govern it; the investigation in
[`helix_zeta.py`](helix_zeta.py) is complete and reproducible
([`verify/helix_zeta.log`](verify/helix_zeta.log), 80/80 checks pass). Everything below is
either `PROVED` (a written argument), `VERIFIED` (recomputed in this round by a route that
does not merely re-run the source), `PROOF-SKETCH` (argument outlined, to be written out), or
`OPEN` (target).

**The one-paragraph version.** Note 041's pages read the same greedy word a second way: the
alphabet is alternating, `+1/2 − 1/3 + 1/4 − …`, the target is a *signed* height
`sin(2πθ)`, and the rule spends a term only when its sign matches the residual. The pages
then say that zeta, read through eta, is "the budget of each sign" — the even denominators
totalling `2^{−p}ζ(p)` and the odd ones from 3 on totalling `(1−2^{−p})ζ(p) − 1`. Both
formulas are correct and are proved here; the pole of `ζ` at `p = 1` is exactly why *every*
sine is writable there. But the budget is only an **outer bound**. The exact reachable set is
the recursive set of signed sub-sums of the two half-series, and it fills the budget interval
`[−N(p), P(p)]` **iff both halves are complete — and the positive half is complete exactly
when `ζ(p) ≥ 2`, i.e. for `p ≤ p*`, rh41's own threshold**. For `p > p*` the sines acquire
gaps: at `p = 2` the positive half reaches `[0, 0.16123] ∪ [0.25, 0.41123]` and misses
`(0.16123, 0.25)`, so the rational target `x = 1/5` is *not* writable at `p = 2` even though
it is inside both the budget and the sine range. The number of reachable intervals doubles
as `p` grows (1, 2, 4, 16, 128 at `p = 1.5, 1.8, 2.5, 4, 6`) and the reachable fraction of
the positive budget falls from `1` to `0.001`. The helix itself — the lift
`(cos 2πθ, sin 2πθ, θ)` — carries the turn count, and the digit word provably cannot see it:
`w` factors through the height `sin(2πθ)`, so `θ`, `θ+1` and `1/2−θ` share a word while
`1−θ` flips its sign.

---

## 0. What this document is for

rh41 closed with a proved complexity law, a Lean development, and a public exposition
(Note 041, <https://harmonic-sine.grok.me/>). That exposition contains a *second reading* of
the same word — signed alphabet, sine target, turn count, zeta budgets — that rh41 never
touched: `TRUTHS.md` is entirely about the unsigned rule with a positive target.

This handoff:

1. records the state of the programme so rh42 does not re-derive rh41 (§1–§3);
2. states the helix reading exactly, and adjudicates every claim of the source pages
   (§4, with a verdict table);
3. **investigates the ζ relationship from that perspective** (§5) — this is the requested
   part, and it is where the new mathematics of this handoff lives;
4. fixes the rh42 ledger, the round plan and the agent prompts (§6–§8).

The house rules of rh40/rh41 apply unchanged: exact arithmetic for the object (`Fraction`
for rational targets, mpmath at ≥ 60 dps otherwise, never binary floats); every reported
number carries its truncation; nothing enters the ledger without an independent
recomputation; refuted statements are kept so they are not re-proposed.

---

## 1. Where rh42 sits

| round | object | outcome |
|---|---|---|
| `rh40` | the factor-complexity law `p(L)` of the *unsigned* greedy word | K1 plateau + C1 regime proved by computation; register in [`../rh40/rounds/truths.md`](../rh40/rounds/truths.md) |
| `rh41` | the same law, closed | [`../rh41/TRUTHS.md`](../rh41/TRUTHS.md) — Theorems 1–12, ledger of refuted formulas, and the Lean development [`../rh41/lean`](../rh41/lean) (7 modules, 144 declarations, no `sorry`) |
| **`rh42`** | **the signed (Tau) alphabet and the helix** | this document + [`helix_zeta.py`](helix_zeta.py) |

The public pages of Note 041 are the exposition of rh41 with one addition, the helix/Tau
material: <https://harmonic-sine.grok.me/> (the bench), `/theory` (why the fractions are a
sine), `/helix` (the helix, cosine and zeta). The pages' "Ledger" agrees with rh41's Lean
development, including the *corrected* onset values — see §4.5.

---

## 2. The two readings of the same word

**Unsigned (rh41).** `x ∈ (0,1)`; `r_0 = x`; at step `n` take `1/(n+2)` iff
`r_n ≥ 1/(n+2)`, and subtract. The word is `w(x) = δ_0δ_1…`; `p(L)` counts distinct
length-`L` factors of a length-`N` truncation.

**Signed / Tau (the helix pages).** The alphabet is

```
α_n = (−1)^n / (n+2)^p ,   n = 0, 1, 2, …      (p = 1 on the helix page)
     = +1/2, −1/3, +1/4, −1/5, …
```

and the target is a signed height `x = sin(2πθ)` (or `cos(2πθ) = 0`) with `θ` in **turns**.
The rule: at step `n` take `α_n` iff it has the same sign as the residual and its size does
not overshoot (`sign(α_n) = sign(r_n)` and `|α_n| ≤ |r_n|`), then spend it
(`r_{n+1} = r_n − α_n`); otherwise skip it, forever. A term is used at most once.

**Two conventions for θ — keep them apart.**

* the **bench** coordinate used by the rh41 pages is `θ_bench = πx`, so the target `x = 1`
  is "a half-turn" and represents `sin(π/2) = 1`;
* the **helix** coordinate is `θ` in turns, so the target is `sin(2πθ)`, one turn is `360°`,
  and `450°` is *not* folded back to `90°`.

Every statement below names which one it uses. The digit word depends only on the height — a
fact §5.8 makes precise — so the two conventions only change which `θ` writes which number.

---

## 3. What rh41 left (the inherited state)

### 3.1 The proved law (all of it formalised in Lean)

`p(L)` for a finite support `0 ≤ a_0 < … < a_m < N`:

* **Theorem 1.** For `L ≥ a_m + 1` (the printed hypothesis `L ≥ max(span, a_m+1)` has a
  redundant part),
  `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`.
* **Corollary 2/3/4.** plateau `a_m+2` on `max(span,a_m+1) ≤ L ≤ N−a_m−1`; decay
  `N−L+1` after that; `p(N) = 1`, `p(N−1) = 2`; `max_L p(L) = a_m+2` once `N ≥ 2a_m+2`;
  and in general `p(L) ≤ a_m + 2` for every `L`.
* **Theorem 5 (C1).** `p(L) = L+1` for `L ≤ min(min gap, a_0, N−a_0−1)`, each bound sharp.
* **Theorem 6.** the onset is not a function of (gaps, N).
* **Theorem 7/8.** `u' = q²/s − q`, `s' = 1 − {q²/s}`; every rational target terminates;
  `x = 1` has support `{0,1,4}`.
* **Theorem 9/10/11.** halting criterion (corrected, see §3.3), power-alphabet structure,
  dyadic counterexample to the claimed dichotomy.
* **Theorem 12.** no terminating alphabet gives `p(L) = cL`.

### 3.2 The Lean development

[`../rh41/lean`](../rh41/lean): `Rh41/DigitWord.lean`, `AllZero.lean`, `WindowCount.lean`,
`Impossibility.lean`, `GreedyResidual.lean` (sub-namespace `Rh41.Harmonic`),
`Alphabet.lean`, plus a root module and `check.sh`. Build:
`cd rh41/lean && ./check.sh --all` (≈ 4m30s from clean, Lean 4.35.0-rc2 + Mathlib at
`$HOME/lean`). `crosscheck.py` re-validates the statement shapes against the Python ground
truth over 1 969 905 cases. No `sorry`; seven concrete numeric facts use `native_decide`
(listed in [`../rh41/lean/README.md`](../rh41/lean/README.md)).

### 3.3 Corrections already banked (do not re-propose the old forms)

1. the onset example of `TRUTHS.md` §5 has its two values interchanged: with `N = 6` the
   onsets are `3` for `{0,2}` and `2` for `{1,3}` (`rigorous_check.py::onset`, the Lean
   theorem `onset_not_determined_by_gaps`, and the public bench all agree);
2. Theorem 9's printed `iff` is false (`Σα_n ≥ x` does not imply finite halting); the two
   true directions are formalised in `Alphabet.lean`;
3. Theorem 10 row 3 needs "no finite sub-sum equals `x`";
4. Theorem 1's span hypothesis is redundant;
5. Theorem 12's `c·L` phrasing needs `N` to grow with `L`;
6. Theorem 7's identities need strict hypotheses (`1/(n+2) < r`, `{q²/s} ≠ 0`).

### 3.4 Open after rh41

* `A(N) = O(log log N)` (only `Ω` is proved, via `r_{k+1} ≤ r_k²`).
* the orbit-average limit independent of `x` (the original dialogue's question).
* non-monotone alphabets in the inverse problem.
* the asymptotic constants (the decimal values of `p*`, the `ζ(p) = 3/2` root).

---

## 4. The helix reading, claim by claim

Definitions used below (all recomputed in [`helix_zeta.py`](helix_zeta.py)):

```
P(p) = Σ_{k≥1} (2k)^{−p}      = 2^{−p} ζ(p)                 "positive budget"
N(p) = Σ_{k≥1} (2k+1)^{−p}    = (1 − 2^{−p}) ζ(p) − 1       "negative budget"
η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p} = (1 − 2^{1−p}) ζ(p)       (p ≠ 1),   η(1) = ln 2
```

| # | claim of the source pages | verdict | evidence |
|---|---|---|---|
| H1 | alphabet `(−1)^n/(n+2)`, `n ≥ 0` | **VERIFIED** | definition; script §0 |
| H2 | take a term iff its sign matches the residual and its size does not overshoot; never reuse | **VERIFIED** | the rule implemented and used throughout |
| H3 | positive terms (even denominators) sum to `2^{−p}ζ(p)`; negative terms (odd from 3) to `(1−2^{−p})ζ(p) − 1` | **PROVED** (identities) + **VERIFIED** (direct even/odd partial sums) | script §1 |
| H4 | at `p = 1` both series diverge — "the pole of zeta, once on each side" | **PROVED** (`P(p), N(p) ~ ζ(p)/2 ~ 1/(2(p−1))`) + **VERIFIED** | `P(p)(p−1) → 1/2`; exact harmonic partial sums; script §2 |
| H5 | "past exponent 1 both budgets are finite, and a sine past the budget of its sign cannot be met" | **PROVED** (necessity) — but **incomplete**: the budget is not sufficient, see §5.5 | script §3, §10 |
| H6 | "adding every term of this page's alphabet, which starts at 1/2, gives `ln 2 − 1 ≈ −0.307`" | **REFUTED (sign)** | the alphabet sums to `1 − η(1) = 1 − ln 2 = +0.30685281944005469058`; `ln 2 − 1` is the negative of the *alternating tail* `Σ_{n≥2}(−1)^{n−1}/n`. The magnitude is right, the sign is not. Script §1 |
| H7 | cosine spends the same budgets; at 45° the two words agree | **VERIFIED** | the rule depends on the target only; at `θ = 1/8` (45°) `sin = cos` and the words coincide; at `θ = 3/4` (270°) `sin = −1`, `cos = 0` (empty word). Script §5 |
| H8 | the helix keeps the turn count; the digit word does not | **VERIFIED** with a caveat | `w` factors through `x = sin(2πθ)`; `θ`, `θ+1`, `1/2−θ` give the same word (at 200 dps, prefixes above the `1e−100` precision floor), and `1−θ` flips the sign; the *lift* is not periodic. Script §6 |

### 4.5 Cross-check worth recording

The public bench prints the onset pair as **`{0,2}` at `L = 3`, `{1,3}` at `L = 2`** — the
corrected values. `TRUTHS.md` §5 prints them interchanged. So the source pages, the Lean
theorem `onset_not_determined_by_gaps`, and `rigorous_check.py` all agree with each other,
and the only outlier is the §5 table of `TRUTHS.md`.

---

## 5. The ζ relationship (the investigation)

### 5.1 The even/odd split is the η factor

`ζ(s) = Σ n^{−s}`; splitting into even and odd denominators gives the identity that the
helix page uses as its definition of "budget":

```
ζ(p) = Σ_{k≥1} (2k)^{−p} + Σ_{k≥0} (2k+1)^{−p}
     = P(p) + (N(p) + 1)
so   P(p) + N(p) = ζ(p) − 1                                    (all terms from n = 2 on)
```

and, subtracting instead of adding,

```
P(p) − N(p) = Σ_{n≥2} (−1)^n n^{−p} = 1 − η(p),     η(p) = (1 − 2^{1−p}) ζ(p).
```

Hence the budgets are the `ζ`/`η` combinations

```
P(p) = (ζ(p) − η(p)) / 2 ,      N(p) = (ζ(p) + η(p) − 2) / 2 ,
```

and their difference is governed by η alone: `P(p) − N(p) = 1 − η(p) > 0` for every `p > 0`
(η is the alternating series, strictly between `1 − 2^{−p}` and `1`). **The positive side is
always the cheaper one**; the asymmetry is `1 − η(p)`, i.e. exactly the "half-turn" deficit
of the alternating series.

All of this is recomputed: `P + N = ζ − 1` and `P − N = 1 − η` to 1e−81 at
`p = 1.25, 1.5, 2, 3, 4`; direct even/odd partial sums agree within the truncation tail; the
factored `η` matches its series at `p = 1.5, 2`; `η(1) = ln 2`.

| `p` | `ζ(p)` | `P(p)` | `N(p)` | `P+N` |
|---|---|---|---|---|
| 1.1 | 10.584448 | 4.937820 | 4.646629 | 9.584448 |
| 1.25 | 4.595112 | 1.932007 | 1.663105 | 3.595112 |
| 1.37 | 3.306181 | 1.279133 | 1.027049 | 2.306181 |
| 1.5 | 2.612375 | 0.923614 | 0.688761 | 1.612375 |
| **p\*** = 1.7286472390 | 2.000000 | **0.603469** | **0.396531** | **1.000000** |
| 2 | 1.644934 | 0.411234 | 0.233701 | 0.644934 |
| 3 | 1.202057 | 0.150257 | 0.051800 | 0.202057 |

Closed forms at even integers: `P(2) = π²/24`, `N(2) = π²/8 − 1` (so
`P(2)+N(2) = π²/6 − 1`), `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`.

### 5.2 The pole at `p = 1`: why *every* sine is writable there

As `p ↓ 1`, `ζ(p) ~ 1/(p−1) + γ`, so

```
P(p) = 2^{−p} ζ(p)  ~  1/(2(p−1)),      N(p) = (1−2^{−p}) ζ(p) − 1  ~  1/(2(p−1)),
```

i.e. the pole of `ζ` appears once on each side with half the residue: `P(p)(p−1) → 1/2`
(measured 0.49999994 at `p = 1 + 10^{−6}`; `P` and `N` both exceed `4.9·10^3` by
`p = 1 + 10^{−4}`). Since both budgets are infinite at `p = 1`, **no** target fails the
budget test, which is exactly the page's reason that a sine anywhere in `[−1,1]` can be
written. This is the one place where the pole of `ζ` is *used* rather than avoided.

### 5.3 Three thresholds, three zeta equations

| threshold | equation | value | meaning |
|---|---|---|---|
| `p*` | `ζ(p) = 2` | 1.7286472389981836181 | rh41's threshold: the **combined** budget `P+N = ζ−1` reaches 1; equivalently (below) the positive half becomes **complete** |
| `pP` | `2^{−p} ζ(p) = 1` | 1.4649845878051603837 | the positive budget reaches 1, i.e. `sin = +1` becomes writable |
| `pN` | `(1−2^{−p}) ζ(p) = 2` | 1.3777851698375411838 | the negative budget reaches 1, i.e. `sin = −1` becomes writable |
| `q` | `N(p) = 2·3^{−p}` | 2.07677517921069 | the **negative** half becomes complete (see §5.5) |

Ordering: `pN < pP < p* < q`. The whole sine range `[−1,1]` is inside budget iff
`p ≤ pN`; for `pN < p ≤ pP` only positive sines are all in budget; beyond `pP` even `sin = 1`
is out of budget. At `p*` the budget interval is
`[−0.3965305007, +0.6034694993]`, of length exactly `ζ(p*) − 1 = 1` — the combined budget is
exactly the sine range's length, but it is split unevenly, so `sin = ±1` is *not* writable at
`p*` (it needs `p ≤ pP` or `p ≤ pN` respectively).

### 5.4 The budget is necessary

**Proposition (PROVED).** If the signed rule ever reaches residual `0` on target `x`, then
`0 < x ≤ P(p)` (for `x > 0`) or `x < 0` and `−x ≤ N(p)` (for `x < 0`); and the sum of the
taken terms always satisfies the same bound.

*Proof.* The taken terms with the sign of `x` are distinct terms of one half-series, whose
total is that half's budget; the residual is `x` minus their sum, so `|x|` can only be met if
`|x|` does not exceed the budget. At `p ≤ 1` the budget is infinite (5.2) and the bound is
vacuous. ∎

Verified at `p = 2`: `x = 3/5` takes terms summing to `0.411108547957 ≤ P(2) = 0.4112335`,
`x = −1/2` to `0.233575612608 ≤ N(2) = 0.2337006`.

**Sharpening (VERIFIED).** "Cannot be met" means the residual has a *non-zero limit*, not
that the process stops taking terms: above the budget the rule keeps taking the smaller and
smaller terms of that sign forever, and `r_n → x − P(p)` (for `x > P(p)`), from above and
with the gap halving when the cap doubles — measured `0.188891452 → 0.1887977313` (caps 4k →
16k) against `x − P(2) = 0.1887664833`. Below the budget the residual falls to `0` in the
limit (measured to `e−10` or exactly `0` when the target is a finite sub-sum, e.g. `x = 1/4`
at `p = 2` terminates in one take).

### 5.5 The budget is *not* sufficient: the reachable set and its gaps

The exact reachable set is the set of signed sub-sums of the two half-series. Write
`a_k = (2k)^{−p}` for the positive half. A non-increasing positive sequence whose first term
is at most the sum of the rest is **complete** — its subset sums fill `[0, total]` (Brown's
criterion; the greedy achieves every value). Otherwise

```
S(subset sums) = S(tail)  ∪  (a_1 + S(tail)),      S(tail) ⊆ [0, total − a_1],
```

so incompleteness produces a gap `(total − a_1, a_1)` whenever `a_1 > total − a_1`, and the
construction recurses on the tail. For the positive half the *first* completeness condition is

```
2^{−p} ≤ P(p) − 2^{−p}   ⟺   2 ≤ ζ(p)   ⟺   p ≤ p* .
```

**So rh41's threshold `p*` is exactly the exponent at which the signed sine set stops being
an interval.** Verified in both directions at `p* ± 10^{−6}`, and by reaching all 11 tested
targets in `[0, P(1.5)]` at `p = 1.5` but not at `p = 1.8`.

**`p = 2` (VERIFIED, exactly predicted).** `P(2) = 0.411233516712`, `a_1 = 1/4`, so the
positive reachable set is

```
[0, 0.161233516712]  ∪  [0.25, 0.411233516712],   the gap is (0.161233516712, 0.25).
```

The greedy confirms the exact stall residuals `x − 0.16123352` for
`x = 0.18, 0.2, 0.24` and `x − P(2)` for `x = 0.42`, and convergence to `0` at
`x = 0.15, 0.25, 0.28, 0.3` (and `1.3e−14` at `x = 0.15`).

**`p = 3` (VERIFIED).** The recursion runs twice more; the reachable set is the four
intervals

```
[0, 0.00963211] ∪ [0.015625, 0.0252571] ∪ [0.125, 0.134632] ∪ [0.140625, 0.1502571],
```

and every tested target lands where predicted: `0.02` and `0.15` reach `0`; `0.05`, `0.1`
stall at `x − 0.0252571`; `0.14` stalls at `x − 0.134632`; `0.2` at `x − P(3)`.

**The gap structure with `p`** (`#intervals` = reachable intervals in the positive half,
`measure` their total length; `helix_zeta.py` §10):

| `p` | `P(p)` | `#intervals` | `measure/P` |
|---|---|---|---|
| 1.2 … 1.7286 (= p\*) | 2.434 … 0.603 | 1 | 1.000 |
| 1.8 | 0.540529 | 2 | 0.937 |
| 2 | 0.411234 | 2 | 0.784 |
| 2.2 | 0.324398 | 2 | 0.658 |
| 2.5 | 0.237144 | 4 | 0.491 |
| 3 | 0.150257 | 4 | 0.256 |
| 4 | 0.067645 | 16 | 0.053 |
| 6 | 0.015896 | 128 | 0.001 |

The reachable fraction of the budget collapses to zero as `p → ∞`: at high exponent almost
no sine is writable even though the budget is positive. The negative half behaves the same
way but stays complete longer — its first term is `3^{−p}`, so its completeness threshold is
`q = 2.07677517921069` (root of `N(p) = 2·3^{−p}`), larger than `p*`.

### 5.6 Consequences for rh41

1. **"Every rational target terminates" is a `p = 1` statement.** With the signed alphabet
   at `p = 2`, the rational target `x = 1/5` is *not* writable: it lies inside the budget
   `P(2) = 0.41123` and inside the sine range, yet inside the gap
   `(0.16123, 0.25)`, so the residual stalls in the limit at
`1/5 − 0.161233516712 = 0.038766483288` (measured `0.03876898328` at a cap of `2·10^5`). The harmonic case `p = 1` is
   special because the classical Egyptian greedy is complete (its first term `1/2` is at most
   the sum of the rest, `+∞`).
2. **The positive half is the classical Egyptian greedy in disguise (**VERIFIED**).** Term
   index `n = 2(k−1)` has value `(2k)^{−p} = 2^{−p} k^{−p}`, so for `x > 0` the signed rule
   is exactly the greedy on `{1/k^p : k ≥ 1}` at target `2^p x`. Checked at `p = 1` for
   `x = 1/2, 1/3, 2/5, 1, 7/9` (supports `{0}`, `{2,10}`, `{2,6,38}`, `{0,2,4,10}`,
   `{0,2,34}` versus the Egyptian supports `{1}`, `{2,6}`, `{2,4,20}`, `{1,2,3,6}`,
   `{1,2,18}`) and at `p = 2`. So rh41's Theorem 8 (rational termination) and the
   Sylvester/Fibonacci theory transfer to the *positive half at `p = 1`*, and the negative
   half is the same statement for the odd unit fractions `1/3, 1/5, …`.
3. **The signed word's support is parity-locked.** Every take of a positive target sits at an
   even index, every take of a negative target at an odd index; hence **all gaps are even and
   at least 2**. rh41's complexity law applies verbatim (the Lean `complexity_main` is
   generic in the support — re-checked on the Tau supports `{0,2,4,10}`, `{2,6,38}`,
   `{0,8}`), but the *C1 regime and the plateau onset* of a signed word are governed by this
   parity constraint, which the unsigned word does not have.
4. **The dictionary.**

   | rh41 (unsigned) | helix (signed) |
   |---|---|
   | alphabet `1/(n+2)^p`, total `ζ(p) − 1` | the same terms with alternating signs |
   | the total meets the target `x = 1`: `ζ(p) = 2`, i.e. `p*` | the combined budget `P+N = ζ−1` meets the *sine range length* `1` |
   | `p*` = start of the "never halts but the budget is met" regime | `p*` = last exponent at which the signed sine set is the whole interval `[−N, P]` |
   | `A(N) = Ω(log log N)`, plateau `a_m+2` | the same, on a support with even gaps |

### 5.7 The helix and the turn count

The rule reads one real number, the height `x = sin(2πθ)`. Therefore the word is a function
of `x` alone, and the *lift* `(cos 2πθ, sin 2πθ, θ)` carries information the word cannot see:

* `θ`, `θ+1` (one more turn) and `1/2 − θ` (the mirror `sin(π − a) = sin a`) give the **same
  word** — verified at 200 dps for `θ = 0.1, 0.3, 0.42`, comparing only the prefixes whose
  residuals stay above the `1e−100` precision floor (the word is numerically unstable past
  that floor because the greedy residual falls doubly exponentially);
* `1 − θ` gives the **sign-flipped** height `−sin(2πθ)`, hence a different word (odd-index
  support);
* the lift itself is not periodic in `θ`: `(cos, sin, θ) ≠ (cos, sin, θ+1)`.

So "the circle forgets the turns" is a statement about the *rule*, not a theorem about the
helix: the helix remembers, the digit word projects it away. rh41's onset question
(Theorem 6: what the word does *not* determine) is the same kind of question one level down.

### 5.8 Two helices — what relates them and what does not

The workspace already has a different "helix" (`xi-horn/horn-helix.md` (external — the xi-horn material is not part of this archive; it lives at `/Users/victor/workspace/rh/xi-horn/`)):
the ζ-train `r_n = n^{−σ}`, `ρ_n = −t log n`, `z_n = n`, whose Mellin transform is the horn
and whose value is `ζ(s)`. The harmonic-sine helix of Note 041 is
`(cos 2πθ, sin 2πθ, θ)`, a lift of the unit circle whose height is the greedy target.

What they share is real but limited:

* both are "a radius, a phase, a depth" and both terminate in `ζ`;
* the even/odd alternation that defines the Tau alphabet is exactly the factor
  `η(s) = (1 − 2^{1−s})ζ(s)` — the same "half-turns off" device that the xi-horn notes use
  to pass between the alternated and un-alternated ζ trains;
* the divergent odd/even harmonic series at `p = 1` are the pole of `ζ`, split by parity.

What is *not* known, and should not be asserted: no identity relating the greedy digit word
to the Mellin/horn construction is claimed here. The honest formulation is a question for
rh42 (§7, R3): is there an explicit transform taking the digit word's support to a ζ-train
observable?

### 5.9 Corrections to the source pages

* **H6 sign** (§4): the alphabet `(−1)^n/(n+2)` sums to `+0.30685281944005469058 = 1 − ln 2`,
  not to `ln 2 − 1 = −0.30685281944005469058`. The page's `η(1) = ln 2` and its
  `η(s) = (1−2^{1−s})ζ(s)` are both correct; only the extraction of the alphabet's total has
  the sign flipped.
* Everything else on the three pages that was tested (H1–H5, H7, H8, the budgets, the pole
  reading, the 45° expansion `sin(π/4) = 1/2 + 1/5 + 1/141 + 1/68575` with tail `3.1163e−11`
  and support `{0, 3, 139, 68573}`, and `x = 1 ↔ {0,1,4}`) reproduces.
* The pages' implicit reading of H5 as "the budget is the criterion" is the one substantive
  gap; §5.5 supplies the exact criterion.

---

## 6. The rh42 ledger

**Entry rule** (rh40 §HANDOFF 8.4, unchanged): `VERIFIED` requires a recomputation in this
round by an independent route; `PROVED` requires a written argument; `OPEN` is a target;
`REFUTED` is kept.

| id | statement | status | evidence |
|---|---|---|---|
| T1 | `α_n = (−1)^n/(n+2)^p`; sign-matched, no-overshoot, never-reuse rule | — | definition (source pages), script §0 |
| T2 | `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1` | **PROVED** | even/odd split of ζ; direct partial sums to 200k terms |
| T3 | `P+N = ζ−1`, `P−N = 1−η`, `P = (ζ−η)/2`, `N = (ζ+η−2)/2` | **PROVED** | algebra; verified to 1e−81 |
| T4 | `P(p) > N(p)` for all `p > 0`; the asymmetry is `1−η(p)` | **PROVED** | `η(p) < 1` |
| T5 | `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1` (the pole, halved) | **PROVED** + **VERIFIED** | `P(p)(p−1) = 0.49999994` at `p = 1+10^{−6}` |
| T6 | at `p = 1` every target passes the budget test and the residual falls to `0` | **VERIFIED** | max residual `2.29e−6` over six sines (200k terms, 80 dps) |
| T7 | reachable ⊆ `[−N(p), P(p)]`; above the budget the residual tends to `x − P(p)` | **PROVED** + **VERIFIED** | exact stall values at `p = 2` |
| T8 | the positive half is the classical Egyptian greedy at `2^p x` | **PROVED** + **VERIFIED** | support correspondence at `p = 1, 2` |
| T9 | the signed support has only even/odd indices (all gaps even, ≥ 2) | **VERIFIED** | parity of every take for four `θ` |
| T10 | the positive half is complete (reachable = `[0, P]`) **iff** `p ≤ p*`, `ζ(p*) = 2` | **PROOF-SKETCH** + **VERIFIED** | Brown's criterion; both directions at `p* ± 10^{−6}`; 11/11 targets at `p = 1.5` |
| T11 | at `p = 2` the reachable set is `[0, P−1/4] ∪ [1/4, P]` (one gap) | **PROOF-SKETCH** + **VERIFIED** | predicted intervals and exact stall residuals |
| T12 | at `p = 3` the reachable set is the four intervals listed in §5.5 | **VERIFIED** | same method, exact stall residuals |
| T13 | the negative half is complete iff `p ≤ q = 2.07677517921069` | **PROOF-SKETCH** + **VERIFIED** | root of `N(p) = 2·3^{−p}` with sign change at `q ± 10^{−6}` |
| T14 | the three thresholds `pN < pP < p*` with the values in §5.3 | **VERIFIED** | `findroot` at 80 dps; each residual `< 1e−30` |
| T15 | at `p*` the budget interval is `[−0.39653, +0.60347]`, length `1` | **VERIFIED** | `P(p*) = 2^{1−p*}` |
| T16 | `w` factors through `sin(2πθ)`; `θ, θ+1, 1/2−θ` share a word, `1−θ` flips it | **PROVED** (factorisation) + **VERIFIED** | 200-dps prefixes above the `1e−100` floor |
| T17 | the alphabet's total is `1 − ln 2`, not `ln 2 − 1` | **VERIFIED** | `nsum` to 25 digits both ways |
| R1 | the source pages' ledger has the corrected onsets (`{0,2}→3`, `{1,3}→2`) | **VERIFIED** | agrees with `rigorous_check.py::onset` and the Lean theorem; only `TRUTHS.md` §5 disagrees |

---

## 7. Round plan and targets

**R1 — write out the reachable-set theory (highest value, all ingredients present).**
(a) the budget identities T2–T4; (b) Brown's completeness criterion and the greedy's
optimality on complete sequences; (c) the recursion
`S = S(tail) ∪ (a_1 + S(tail))` and the exact interval structure as a function of `p`;
(d) the exactness of the stall residual `x − max{s ∈ S : s ≤ x}` (verified here; needs the
statement that the greedy is optimal, not just feasible); (e) the negative half with its own
threshold `q`. Deliverable: a `reachable.py` with the interval computation and a written
note; optionally a Lean file (the recursion is finite combinatorics, well within the rh41
toolchain).

**R2 — transfer rh41's machinery to the signed word.** The Lean `complexity_main` is generic
in the support, so what is new is the *support law*: parity-locked gaps, the C1 regime
`p(L) = L+1` (does a signed word ever satisfy it? `a_0` is even and gaps are ≥ 2),
the plateau onset, and the Theorem 6 analogue (is the onset determined by `(gaps, N, a_0)`
for signed words, and how does the parity shift it?). Deliverable: a census over the Tau
words for `x = sin(2πθ)` at high precision plus the Lean reuse.

**R3 — the helix proper.** The word cannot see the turn count (§5.7). Find the minimal
modification that can: a complex residual with phased terms
`α_n = (−1)^n e^{2πiθ}/(n+2)^p`, or a rule whose target is `θ mod 1`; and decide whether any
such variant still terminates/converges with a ζ budget. Also: is there an explicit transform
from the digit word's support to a ζ-train observable (the honest open question of §5.8)?

**R4 — quantitative ζ.** Monotonicity and convexity of `P`, `N`, the threshold equations as
functions of `p`; closed forms at even `p`; the behaviour of the interval count
(`1, 1, 2, 2, 4, 4, 16, 128` at `p = 1.5, 1.7, 1.8, 2, 2.5, 3, 4, 6`); and the measure of the
reachable set as `p → ∞`.

**R5 — the 45° and rational cases as fixtures.** `sin(π/4) = 1/2 + 1/5 + 1/141 + 1/68575`
(tail `3.1e−11`), `x = 1 ↔ {0,1,4}`, the parity supports, and the `p = 2` unreachable
rational `1/5` are the fixed test points every future script must reproduce.

**Agent prompts (rh40/rh41 protocol).** Agent A: the professor — literature-exact, allowed
to be wrong, must state a falsifiable claim and its witness for every assertion. Agent B: the
auditor — recomputes everything with exact arithmetic, tries to break the ground truth
itself, and reports the smallest counterexample. Mediator (main agent): recomputes every
computable claim independently before it enters §6; non-negotiable.

---

## 8. Reproduce

```
cd /Users/victor/workspace/rh
python3 rh42/helix_zeta.py                    # 80/80 checks, ~4 min, exit 0
python3 rh41/lean/crosscheck.py               # rh41 statement shapes, exit 0
cd rh41/lean && ./check.sh --all              # the Lean development, ~4m30s
```

The recorded run is [`rh42/verify/helix_zeta.log`](verify/helix_zeta.log). The script's
sections map to this document as: §1 budgets (5.1), §2 pole (5.2), §3 criterion (5.4),
§4 parity/Egyptian (5.6), §5 cosine (4 H7), §6 helix (5.7), §7 the 45° fixture (4, R5),
§8 thresholds (5.3), §9 complexity reuse (5.6), §10 reachable set (5.5).

---

## 9. Do not re-propose

Inherited from rh41 (`TRUTHS.md` §5, all with witnesses): the unrestricted Theorem 1, the
pair-count / distance-count / gap-deficit / slope-`2L−10` / `min(L+span, N−L+1)` complexity
formulas, the bounded-gap claim for `α_n = (n+2)^{−3/2}`, the "bounded gaps OR termination,
never both" dichotomy, the onset-as-a-function-of-gaps claim (with the corrected values), and
the two-sided squaring law `c·r_k² ≤ r_{k+1} ≤ r_k²`.

Newly refuted here:

* the sign of the source page's alphabet total (§5.9): `+0.30685… = 1 − ln 2`, not
  `−0.30685…`;
* "inside the budget ⟹ writable" (§5.5): false for `p > p*`; the first gap at `p = 2` is
  `(0.1612335167, 0.25)` and it contains the rational target `1/5`;
* "every rational target terminates" as a statement about the *signed* word at general `p`
  (§5.6.1): it is a `p = 1` theorem (via the Egyptian correspondence);
* "the word sees the turns" (§5.7): the word factors through `sin(2πθ)`; the reflection with
  the same height is `θ ↦ 1/2 − θ`, **not** `θ ↦ 1 − θ` (which flips the sign).

---

## Appendix A — formulas

```
P(p) = 2^{−p} ζ(p) = (ζ(p) − η(p))/2            positive budget
N(p) = (1 − 2^{−p}) ζ(p) − 1 = (ζ(p) + η(p) − 2)/2   negative budget
η(p) = (1 − 2^{1−p}) ζ(p)   (p ≠ 1),   η(1) = ln 2
P + N = ζ(p) − 1            P − N = 1 − η(p) > 0
P(2) = π²/24,  N(2) = π²/8 − 1,  P(4) = π⁴/1440,  N(4) = π⁴/96 − 1
P(p) ~ N(p) ~ 1/(2(p−1))   as p ↓ 1
pN = 1.3777851698375411838   (N(p) = 1)
pP = 1.4649845878051603837   (P(p) = 1)
p* = 1.7286472389981836181   (ζ(p) = 2)
q  = 2.07677517921069        (N(p) = 2·3^{−p})
positive half complete  ⟺  2^{−p} ≤ P(p) − 2^{−p}  ⟺  ζ(p) ≥ 2  ⟺  p ≤ p*
"x > 0 written by the signed rule"  ⟺  x ∈ S_p ,  S_p ⊆ [0, P(p)] the subset-sum set
p = 2:  S_2 ∩ [0, P(2)] = [0, 0.161233516712] ∪ [0.25, 0.411233516712]
```

## Appendix B — where rh41 keeps its evidence

| what | where |
|---|---|
| the 31-check ground truth | [`../rh41/rigorous_check.py`](../rh41/rigorous_check.py) |
| the object and the exact-complexity layer | [`../rh41/digitword.py`](../rh41/digitword.py) |
| the truths ledger | [`../rh41/TRUTHS.md`](../rh41/TRUTHS.md) |
| the Lean development + its map | [`../rh41/lean/README.md`](../rh41/lean/README.md) |
| the public exposition (Note 041) | <https://harmonic-sine.grok.me/>, `/theory`, `/helix` |
| the other helix (ζ-train, horn) | `xi-horn/horn-helix.md` (external — the xi-horn material is not part of this archive; it lives at `/Users/victor/workspace/rh/xi-horn/`) |
