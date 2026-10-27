# 042 — the signed (Tau) alphabet: proven results

The truths of this folder, each with its status and its evidence.  Every statement
below is one of

* **PROVED** — a written argument (some of them machine-checked in Lean 4; the
  files are in `lean/`),
* **VERIFIED** — recomputed in this round by a route that does not merely re-run
  the source,
* **CHECKED** — exhaustively verified over all objects of a stated finite class,
* **REFUTED** — with the smallest witness found,
* **OPEN** — a target, not a result.

Nothing else is listed.  The evidence is two scripts and a Lean development:

| evidence | what it is | result |
|---|---|---|
| [`reachable.py`](reachable.py) | the exact reachable-set theory, exact `Fraction` arithmetic and rigorous rational enclosures | **70/70 checks pass**, [`verify/reachable.log`](logs/reachable.log) |
| [`helix_zeta.py`](helix_zeta.py) | rh42's original budget/criterion investigation (unchanged, re-run) | **80/80 checks pass**, [`verify/helix_zeta_rerun.log`](logs/helix_zeta_rerun.log) |
| `lean/` | Lean 4 + Mathlib proofs; `./check.sh --all` | **4/4 modules OK, exit 0**, no `sorry`, no new axiom — [`verify/lean_check.log`](logs/lean_check.log) |

**Folder `042` is `rh42/`** in this workspace; the sibling
[`../rh41/TRUTHS.md`](TRUTHS.md) is the *unsigned* round.  This file is the
*signed* round's ledger, and it carries the **sign correction** of §1 in the
title, the formulas and the refuted list: the source pages' `ln 2 − 1` is the
negative of the truth.

---

## 0. The object, and the two readings

**Unsigned (rh41).** `x ∈ (0,1)`; `r_0 = x`; at step `n` take `1/(n+2)` iff
`r_n ≥ 1/(n+2)`, and subtract.  The word is `w(x) = δ_0δ_1…`; `p(L)` counts the
distinct length-`L` factors of a length-`N` truncation.  The full truth for it is
[`../rh41/TRUTHS.md`](TRUTHS.md) and its Lean development
`../rh41/lean`, which this round reuses and does not touch.

**Signed / Tau (this folder).** The alphabet is

```
α_n = (−1)^n / (n+2)^p ,   n = 0, 1, 2, …      (p = 1 on the helix pages)
    = +1/2, −1/3, +1/4, −1/5, …
```

and the target is a signed height `x = sin(2πθ)` with `θ` in **turns**.  The rule:
at step `n` take `α_n` iff `sign(α_n) = sign(r_n)` and `|α_n| ≤ |r_n|`, then spend
it (`r_{n+1} = r_n − α_n`); otherwise skip it, forever.  A term is used at most
once.  **T1.**

The two conventions for `θ` stay apart: the rh41 *bench* coordinate is
`θ_bench = πx`, while the *helix* coordinate is `θ` in turns, so the target is
`sin(2πθ)` and `450°` is not folded back to `90°`.  The digit word depends only on
the height — §8 makes this precise — so the conventions only change which `θ`
writes which number.

---

## 1. The sign of the ledger — the one correction the source pages need

**Theorem 1 (sign).** `Σ_{n≥0} (−1)^n / (n+2)^p` at `p = 1` equals

```
1 − ln 2 = +0.30685281944005469058…
```

and the source page's `ln 2 − 1 = −0.30685281944005469058…` is its **negative**.
**PROVED** (the alternating harmonic series: with `m = n+2`,
`Σ_{m≥2}(−1)^m/m = −(ln 2 − 1) = 1 − ln 2`), **VERIFIED** with exact rational
enclosures: `ln 2` is bracketed by `2 artanh(1/3) = 2Σ_k (1/3)^{2k+1}/(2k+1)`
with a geometric tail bound, giving an interval of width `6.3·10⁻⁴¹`, and
`1 − ln 2 ∈ [0.3068528194400546…, 0.3068528194400547…]`.  The magnitude was always
right on the pages; only the extraction of the alphabet's total had the sign
flipped.  `η(1) = ln 2` and `η(p) = (1 − 2^{1−p})ζ(p)` are both correct and are
used below.

Everything else that carries a sign in this folder is stated with its sign
explicit: `P(p) > N(p)` (§2), the pole appears **once on each side** (§2), `x < 0`
spends the negative half (§3), and the sine is written at `sin(2πθ)`, not at
`−sin(2πθ)` (§8).

---

## 2. The budgets and their algebra

**Definitions.**

```
P(p) = Σ_{k≥1} (2k)^{−p}    = 2^{−p} ζ(p)                 "positive budget"
N(p) = Σ_{k≥1} (2k+1)^{−p}  = (1 − 2^{−p}) ζ(p) − 1        "negative budget"
η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p} = (1 − 2^{1−p}) ζ(p)  (p ≠ 1),   η(1) = ln 2
```

**Theorem 2 (T2, T3).** For every `p > 1`,

```
P(p) + N(p) = ζ(p) − 1 ,      P(p) − N(p) = 1 − η(p) ,
P(p) = (ζ − η)/2 ,            N(p) = (ζ + η − 2)/2 .
```

**PROVED** (split `ζ(p) = Σ_{k≥1}(2k)^{−p} + Σ_{k≥0}(2k+1)^{−p}` and subtract),
**VERIFIED** to `1e−50` at `p = 1.5, 2, 3, 4` and against direct even/odd partial
sums to 200 000 terms in [`helix_zeta.py`](helix_zeta.py) §1.

**Theorem 3 (T4).** `P(p) > N(p)` for **every** `p > 0`; the asymmetry is exactly
`1 − η(p)`, and `0 < η(p) < 1` because the alternating series has strictly
decreasing terms.  **PROVED**; **VERIFIED** at `p = 1.01, 1.5, 2, 3, 5` (the asymmetry check's grid, `helix_zeta.py` §8; corrected 2025-10-06 — `p = 8` was listed but never computed).  *The
positive side is always the cheaper one — a sine is easier to write than its
negative.*

**Theorem 4 (T5, H4).** `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1`: the pole of `ζ`
appears **once on each side, halved**.  **PROVED** (`2^{−p} → 1/2`,
`1 − 2^{−p} → 1/2`) and **VERIFIED**: `P(1.001) = 499.942…`,
`N(1.001) = 499.635…`.  Since both budgets are infinite at `p = 1`, no target
fails the budget test there — this is the page's reason that every sine is
writable at `p = 1`.

**Theorem 5 (closed forms).** `P(2) = π²/24`, `N(2) = π²/8 − 1`,
`P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`, and `P(2) + N(2) = π²/6 − 1`.
**PROVED in Lean** — [`lean/Rh42/Budget.lean`](Rh42/Budget.lean) proves all
nine statements from Mathlib's `hasSum_zeta_two` and `hasSum_zeta_four` by
splitting the `ζ` series into its even and odd parts
(`tsum_even_add_odd`, `Summable.comp_injective`), with no `sorry`.  Numerically
verified to `1e−40`.

| `p` | `ζ(p)` | `P(p)` | `N(p)` | `P+N` |
|---|---|---|---|---|
| 1.1 | 10.584448 | 4.937820 | 4.646629 | 9.584448 |
| 1.25 | 4.595112 | 1.932007 | 1.663105 | 3.595112 |
| 1.5 | 2.612375 | 0.923614 | 0.688761 | 1.612375 |
| **p\*** = 1.7286472390 | 2.000000 | **0.603469** | **0.396531** | **1.000000** |
| 2 | 1.644934 | 0.411234 | 0.233701 | 0.644934 |
| 3 | 1.202057 | 0.150257 | 0.051800 | 0.202057 |

---

## 3. The exact reachable set: Brown's criterion

The budgets are only an **outer** bound.  The exact reachable set is the set of
sub-sums of the two half-series, over *arbitrary* subsets of `ℕ` — infinite
subsets included, which is exactly what a greedy that never stops taking terms
produces.

**Theorem 6 (Brown's criterion, T10/T13 core).** Let `a_1 ≥ a_2 ≥ … > 0` with
`A = Σ a_n < ∞`, `T_n = Σ_{k≥n} a_k`, and let `S` be the set of sub-sums.  Then

```
S = [0, A]   ⟺   a_n ≤ T_{n+1}   for every n.
```

**PROVED.**  *(⟸)* Run the greedy at `y ∈ [0,A]`; its residual `r_k` decreases to
`r ≥ 0`.  If `r > 0`, choose `m` with `a_k < r` for all `k ≥ m` (possible since
`a_k → 0`); then `a_k < r ≤ r_k`, so every term from `m` on is taken.  Let `k₁` be
the largest skipped index below `m` — one exists, since otherwise the taken sum
would already be `A ≥ y` and `r ≤ 0`.  All indices above `k₁` are taken, so
`r_{k₁} = r + T_{k₁+1} > T_{k₁+1}`, while the skip at `k₁` says
`a_{k₁} > r_{k₁}`; hence `a_{k₁} > T_{k₁+1}`, contradicting the hypothesis.
*(⟹)* If `a_k > T_{k+1}`, any sub-sum `s < a_k` avoids `a_k` and all earlier
indices (they are `≥ a_k`), so `s ≤ T_{k+1}`: the interval `(T_{k+1}, a_k)` is a
gap. ∎

**Correction to the handoff.**  The handoff's §5.5 attributes Brown's criterion in
the form "*a non-increasing positive sequence whose first term is at most the sum
of the rest is complete*".  That single condition is **not** sufficient — see
**Theorem 12 (REFUTED)** below — and the correct statement needs **every** `n`,
which is what makes the `p`-series work.  The two one-step lemmas are
machine-checked in [`lean/Rh42/Reachable.lean`](Rh42/Reachable.lean)
(`Icc_subset_union_shift`, `gap_of_subset_Icc`), together with the finite
sub-sum operator and its gap lemma (`gap_lemma`).

**Theorem 7 (unimodality).** For the positive half put
`h(n) = Σ_{k>n} k^{−p} − n^{−p}`.  Then

```
h(n+1) − h(n) = n^{−p} − 2(n+1)^{−p},
```

which is `> 0` iff `(1 + 1/n)^p < 2`, i.e. iff `n` is below the single value
`1/(2^{1/p} − 1)`; and `h(n) → 0⁺` with `h(n) ~ n^{−p}(n/(p−1) − 1) > 0` for
`n > p − 1`.  So `h` rises then falls to `0`, and

```
{n : h(n) < 0} = {1, 2, …, n_min(p) − 1}
```

is an **initial segment**, with `n_min(p)` the first complete tail.  **PROVED**
(the difference formula and the `n → ∞` asymptotics are elementary; the sign
change count is one), **VERIFIED** over nine exponents in
[`reachable.py`](reachable.py) §1.

**Theorem 8 (completeness thresholds, T10, T13).** At `p > 1`,

```
positive half complete (S = [0, P(p)])   ⟺   n_min(p) = 1   ⟺   ζ(p) ≥ 2   ⟺   p ≤ p*
negative half complete (S = [0, N(p)])   ⟺   n_min^odd(p) = 1 ⟺ N(p) ≥ 2·3^{−p} ⟺ p ≤ q
```

with `p* = 1.7286472389981836181…` (the rh41 threshold, `ζ(p*) = 2`) and
`q = 2.07677517921069…`.  **PROVED**: Theorem 7 makes the condition at `n = 1` the binding one, since `h`
is unimodal (increasing, then decreasing to `0⁺`), so `{n : h(n) < 0}` is an
initial segment — if `h(1) ≥ 0` every condition holds, and if `h(1) < 0` the first
already fails.  **VERIFIED** in both directions at `p* ± 10⁻⁹` and `q ± 10⁻⁶`.  **The
rh41 threshold `p*` is exactly the exponent at which the signed sine set stops
being an interval.**

**Corollary 9.** Every `x ∈ [0,P(p)]` is writable for `p ≤ p*`, and every
`x ∈ [−N(p),0]` for `p ≤ q`.  Since `p* ≈ 1.73 < q ≈ 2.08`, the *negative* half
stays complete longer: its first term is `3^{−p}`, not `2^{−p}`.

---

## 4. The census theorem: exactly which targets are writable

**Theorem 10 (census, new).** With `a_k = (2k)^{−p}`, `S_n` the sub-sum set of
`a_n, a_{n+1}, …`, and `T_n = Σ_{k≥n} a_k`,

```
S_n = [0, T_n]                              for every n ≥ n_min(p),
S_n = S_{n+1} ∪ (a_n + S_{n+1})             with the two pieces DISJOINT for n < n_min(p),
```

hence

```
S_1  is a union of exactly  2^{n_min(p) − 1}  disjoint intervals,
measure(S_1) = 2^{n_min(p) − 1} · T_{n_min(p)},
S_1 = ⋃_{A ⊆ {1,…,n_min−1}} ( Σ_{k∈A} a_k + [0, T_{n_min}] ).
```

**PROVED** (Brown's criterion gives the complete tails; for `n < n_min` one has
`h(n) < 0`, i.e. `a_n > T_{n+1} = T_n − a_n`, so `S_{n+1} ⊆ [0,T_{n+1}]` and
`a_n + S_{n+1} ⊆ [a_n, T_n]` cannot meet, and each level doubles the count;
machine-checked in the finite form `subSums_cons_disjoint`).  **VERIFIED** in [`reachable.py`](reachable.py) §2 by
two independent routes — the census formula and the plain recursion
`S_k = S_{k+1} ∪ (a_k + S_{k+1})` — agreeing to `3.9·10⁻⁶²` on every endpoint, for
thirteen exponents from `p = 1.2` to `p = 12`.

| `p` | `P(p)` | `n_min` | #intervals | measure | measure/P |
|---|---|---|---|---|---|
| 1.2 … 1.7 | 2.434 … 0.632 | 1 | 1 | `P` | **1.000** |
| 1.8 | 0.540529 | 2 | 2 | 0.506708 | 0.937430 |
| 2 | 0.411234 | 2 | 2 | 0.322467 | 0.784146 |
| 2.2 | 0.324398 | 2 | 2 | 0.213521 | 0.658207 |
| 2.5 | 0.237144 | 3 | 4 | 0.116468 | 0.491128 |
| 3 | 0.150257 | 3 | 4 | 0.0385285 | 0.256417 |
| 4 | 0.0676452 | 5 | 16 | 0.00357130 | 0.0527946 |
| 6 | 0.0158960 | 8 | 128 | 1.64918·10⁻⁵ | 0.00103748 |
| 8 | 0.00392218 | 11 | 1 024 | 3.97707·10⁻⁸ | 1.013996·10⁻⁵ |
| 10 | 0.000977534 | 13 | 4 096 | 5.82549·10⁻¹¹ | 5.959375·10⁻⁸ |
| 12 | 0.000244201 | 16 | 32 768 | 5.73073·10⁻¹⁴ | 2.346729·10⁻¹⁰ |

The negative half obeys the same census with its own `n_min^odd` (1, 1, 2, 2, 3, 4,
7 at `p = 1.5, 2, 2.2, 2.5, 3, 4, 6`) and thresholds `q`.  **The reachable fraction
of the budget collapses to zero as `p → ∞`**: at high exponent almost no sine is
writable even though the budget is positive.

**Theorem 11 (greedy optimality, new).** For these sequences the greedy's limit
is exactly

```
s_G(x) = max { s ∈ S : s ≤ x },
```

so the stall residual is `x − max{s ∈ S : s ≤ x}`.  **PROVED.**  At every index
`n` one of the two cases holds: if `h(n) ≤ 0` then `T_{n+1} ≤ a_n`, so taking
`a_n` is optimal (`V_{n+1}(x) ≤ T_{n+1} ≤ a_n ≤ a_n + V_{n+1}(x − a_n)`); if
`h(n) > 0` then by Theorem 7 every `h(j)` with `j > n` is positive, so the tail
from `n+1` is complete by Theorem 8 and taking `a_n` is again optimal
(`Icc_subset_union_shift`).  The two cases cover every `n`, so descending
induction from `n_min` proves optimality everywhere. ∎

**Correction (REFUTED).**  Greedy optimality is *not* a general fact: on the
decreasing sequence `(1/2, 3/10, 3/10)` at `x = 3/5` the greedy takes `1/2`,
while `3/10 + 3/10 = 3/5` is the maximum sub-sum `≤ x`.  It is Theorem 7 that
rescues the `p`-series.  **VERIFIED** exactly, [`reachable.py`](reachable.py) §1.

---

## 5. The exact structure at `p = 2` and `p = 3`

**Theorem 12 (p = 2).** At `p = 2`,

```
S_2 = [0, π²/24 − 1/4] ∪ [1/4, π²/24],   the single gap being (0.161233516712…, 0.25).
```

`π²` is enclosed by exact rationals (Machin: `π = 16 atan(1/5) − 4 atan(1/239)`,
width `5.6·10⁻⁸⁴`), so reachability of a *rational* target is decidable in exact
arithmetic.  **VERIFIED**: ten rational targets decided exactly, including
`1/5 → not reachable`, `3/20 → reachable`, `1/4 → reachable`, `0.41 → reachable`,
`0.42 → not reachable`.  The unreachable rational `x = 1/5` stalls at
`1/5 − (π²/24 − 1/4) = 0.038766483287…`; the exact `Fraction` run takes **every**
even index `2, 4, …, 2K` and nothing else, and the deficit from the stall value is
the missing tail, rigorously in `(0, 1/(4K))`.

**Theorem 13 (p = 3).** At `p = 3`, `n_min = 3` and

```
S_3 = [0, 0.009632112895] ∪ [0.015625, 0.025257112895]
    ∪ [0.125, 0.134632112895] ∪ [0.140625, 0.150257112895].
```

**VERIFIED** exactly: `ζ(3)` is enclosed by exact rationals (Euler–Maclaurin,
outward-rounded, width `3.1·10⁻¹⁸`) and seven rational targets land exactly where
the intervals predict (`1/50`, `13/100`, `1/8`, `3/20` reach `0`; `1/20`, `7/50`,
`1/5` stall at `x − 0.024742887…`, `x − 0.005367887…`, `x − 0.049742887…`).

**The first gap of each exponent.** At `p = 2` it is `(P − a_1, a_1)`; at `p = 3`
the recursion runs twice, at `p = 4` four times (16 intervals), at `p = 12`
fifteen times (32 768 intervals) — the census theorem's `2^{n_min−1}`.

---

## 6. The four thresholds, rigorously enclosed

| name | equation | value | meaning |
|---|---|---|---|
| `pN` | `N(p) = 1` | `1.3777851698375411838…` | `sin = −1` becomes writable |
| `pP` | `P(p) = 1` | `1.4649845878051603837…` | `sin = +1` becomes writable |
| `p*` | `ζ(p) = 2` | `1.7286472389981836181…` | the positive half becomes complete (rh41's threshold) |
| `q` | `N(p) = 2·3^{−p}` | `2.07677517921069…` | the negative half becomes complete |

**Ordering:** `pN < pP < p* < q`.  The whole sine range `[−1,1]` is inside budget
iff `p ≤ pN`; for `pN < p ≤ pP` only the positive sines are all in budget; beyond
`pP` even `sin = 1` is out of budget.  At `p*` the budget interval is
`[−0.3965305007, +0.6034694993]` — length exactly `ζ(p*) − 1 = 1`, the sine range's
length — yet `sin = ±1` is *not* writable at `p*` because the budget is split
unevenly (`P(p*) = 0.6035 < 1`).

**PROVED** (the equations and the ordering follow from Theorem 8 and the
monotonicity of `ζ` on `(1,∞)`, whose derivative `−Σ log k · k^{−p}` is negative
termwise), **VERIFIED** by rigorous bisection: `ζ` is enclosed at every dyadic test
point by Euler–Maclaurin at order 1,
`Σ_{k>N} k^{−p} = N^{1−p}/(p−1) − N^{−p}/2 + p N^{−p−1}/12 ± (p/12)N^{−p−1}`,
with a conservative sign test, and the endpoints are re-certified with `N = 4·10⁵`.
The certified brackets (width `≤ 2.2·10⁻¹²`) all contain the published values:

```
p* ∈ [1.72864723899810998, 1.72864723899824641]
pP ∈ [1.46498458780406505, 1.46498458780624784]
pN ∈ [1.37778516983707959, 1.37778516983817098]
q  ∈ [2.07677517921067642, 2.07677517921071053]
```

---

## 7. Parity lock, and the transfer of rh41's complexity law

**Theorem 14 (parity lock, T9).** At a positive target the residual stays
non-negative (it can hit `0` exactly, when a term is taken with `α = r`), and a
term is taken only when the residual is *positive*; odd-index terms are negative,
so the sign test rejects them at every positive residual.  Hence

```
every take of a positive target sits at an EVEN index,
every take of a negative target sits at an ODD index,
so every gap of the signed support is EVEN and at least 2.
```

**PROVED** by induction on the step (and machine-checked in
[`lean/Rh42/Tau.lean`](Rh42/Tau.lean): `tauStep_nonneg`, `take_parity`,
`support_subset_even`, `support_gap_even_and_two_le`), **VERIFIED** for `p = 1, 2`
and four targets.  The strict form "*the residual stays `> 0`*" is **false** at
the boundary (`x = 1/2`, `p = 1`: the first term is taken with equality and the
residual becomes `0`), which is why the machine-checked statements are the
non-strict ones; the parity conclusion is unaffected.

**Corollary 15 (T8).** For `x > 0` the signed rule *is* the classical Egyptian
greedy on `{k^{−p}}` at target `2^p x`: term `n = 2(k−1)` has value `2^{−p}k^{−p}`.
**PROVED + VERIFIED** at `p = 1` for `x = 1/2, 1/3, 2/5, 7/9`, matching support for
support (`{0} ↔ {1}`, `{2,10} ↔ {2,6}`, `{2,6,38} ↔ {2,4,20}`, `{0,2,34} ↔ {1,2,18}`).
So rh41's Theorem 8 (*every rational target terminates*) transfers to the positive
half at `p = 1` and **only** there: at `p = 2` the rational `1/5` is not writable.

**Statements about the signed word's factors.**  Since the support of a signed
word is just a finite set, rh41's proved law applies verbatim (its Lean
`complexity_main` is generic in the support):

* **Plateau and decay (rh41's Theorem 1).** For `L ≥ a_m + 1`,
  `p(L) = min(a_m+1, N−L+1) + [L ≤ N−a_m−1]`; **VERIFIED** on the signed supports
  `{0,2,4,10}`, `{2,6,38}`, `{0,8}`, `{0,2,4}`.
* **Corollary 4.** `max_L p(L) = a_m + 2` once `N ≥ 2a_m + 2`; **VERIFIED** on
  `{0,2,4}` and `{2,6,38}`.
* **The C1 regime of a signed word (new, corrected).** C1 says `p(L) = L+1` for
  `L ≤ min(min gap, a_0, N−a_0−1)`.  By Theorem 14 every gap of a signed word is
  even and `≥ 2`, so the C1 range is `L ≤ min gap`, and it sits inside `L ≤ 2`
  exactly when the support has a gap of length `2`.  The full range is
  `min(min gap, a_0, N−a_0−1)`: for `{4,8,12}`, `N = 20` it is `L ≤ 4` and
  `p(1..4) = 2, 3, 4, 5`; for `{2,6,38}`, `N = 22` the min gap is `4` but
  `a_0 = 2`, so the range is `L ≤ 2`; and for `{0,2,4,10}`, `N = 22` the min gap is
  `2` but `a_0 = 0` **empties** the C1 range, even though `p(1) = 2` and
  `p(2) = 3` still hold by hand and `L = 3` already violates `L ≤ min gap`.  **VERIFIED.**  *(A previous
  formulation of this bullet claimed the C1 range is always `L ≤ 2`; that is
  false — an even gap can be larger — and the corrected statement is the one
  above.)*
* **The onset is still not determined by `(gaps, N)`.**  **CHECKED** over the
  parity-locked supports: **210 of 402** keys `(gaps, N)` are multi-valued.  The
  parity constraint does not repair rh41's Theorem 6.

---

## 8. The helix: the word sees the height, never the turn count

**Theorem 16 (T16).** The rule reads exactly one real number, the height
`x = sin(2πθ)`.  Hence the word is a function of `x` alone:

```
θ,  θ+1,  θ+2,  1/2 − θ      give the SAME word,
1 − θ                        gives the sign-flipped height, hence the other word,
the lift (cos 2πθ, sin 2πθ, θ) is not periodic — the word simply cannot see it.
```

**PROVED** (the rule's input is the target; `sin(2π(θ+1)) = sin(2πθ)` and
`sin(2π(1/2 − θ)) = sin(2πθ)`, while `sin(2π(1 − θ)) = −sin(2πθ)`), **VERIFIED** at
200 dps for `θ = 0.1, 0.3, 0.42, 0.77`, comparing only the prefixes whose residuals
stay above the `10⁻¹⁰⁰` precision floor.

**Consequences.**  (a) `cos` spends the same two budgets, and at 45° (`θ = 1/8`)
`sin = cos` so the two words coincide; at 270° `sin = −1`, `cos = 0` (the empty
word).  (b) No rule that reads a *periodic* function of `θ` — in particular not
`θ mod 1` — can see the turn count; to see it the rule must be fed a non-periodic
function of `θ`, which is the honest statement of the handoff's §5.7.

**Fixtures.**  `sin(π/4) = 1/2 + 1/5 + 1/141 + 1/68575` (tail `3.1·10⁻¹¹`, support
`{0, 3, 139, 68573}`), `x = 1 ↔ {0,1,4}`, and the `p = 2` unreachable rational
`1/5` of Theorem 12 are the fixed test points; all three reproduce.

---

## 9. Refuted — do not re-propose

| # | statement | smallest witness |
|---|---|---|
| R1 | the alphabet `(−1)^n/(n+2)` totals `ln 2 − 1 = −0.30685…` | it totals `1 − ln 2 = +0.30685…` (Theorem 1) |
| R2 | "inside the budget ⟹ writable" | `p = 2`, `x = 1/5`: inside `P(2) = 0.4112`, inside the sine range, inside the gap `(0.16123, 0.25)` |
| R3 | "`a_1 ≤ A − a_1` ⟹ the sub-sums fill `[0,A]`" | `(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1 = 1/2` and misses `1/5`; machine-checked (`single_condition_not_sufficient`) |
| R4 | "the greedy is optimal for a decreasing sequence" | `(1/2, 3/10, 3/10)`, `x = 3/5`: greedy `1/2`, optimum `3/5` |
| R5 | "every rational target terminates" as a signed statement at general `p` | `p = 2`, `x = 1/5` (R2); it is a `p = 1` theorem |
| R6 | "the word sees the turns" | the word factors through `sin(2πθ)`; the height-preserving reflection is `θ ↦ 1/2 − θ`, **not** `θ ↦ 1 − θ` (which flips the sign) |
| R7 | the reachable set has measure `P(p)` for every `p` | false for every `p > p*`; measure `= 2^{n_min−1} T_{n_min}` (Theorem 10) |
| R8 | the interval count grows like `2^{#{gaps}}` in any `p`-free way | the count is `2^{n_min(p)−1}`, i.e. `1, 2, 4, 16, 128, 1024, 4096, 32768` at `p = 1.5, 2, 2.5, 4, 6, 8, 10, 12` |

Inherited from rh41 and not re-proposed here: the unrestricted Theorem 1, the
pair-count / distance-count / gap-deficit / slope-`2L−10` / `min(L+span, N−L+1)`
complexity formulas, the bounded-gap claim for `α_n = (n+2)^{−3/2}`, the
"bounded gaps OR termination, never both" dichotomy, the onset-as-a-function-of-
gaps claim (corrected values `{0,2} → 3`, `{1,3} → 2`), and the two-sided squaring
law `c·r_k² ≤ r_{k+1} ≤ r_k²`.

---

## 10. Open

* ~~the asymptotic of `n_min(p)` as `p → ∞` (the data suggests `n_min ≈ p + O(1)`)~~ —
  **RESOLVED, and the parenthetical guess was WRONG.** The slope is `1/ln 2`, not 1:
  `n_min(p) = p/ln 2 − 3/2 + O(1)` (error term corrected from `O(1/p)`, which is false — an
  integer index cannot beat the Diophantine gap), with thresholds `P_n = (n + 3/2)ln 2 + c/n + O(1/n²)` and
  `c = 3(ln 2)² − (25/12)ln 2 = −0.0026975844…`. See
  `../../open/OP-05-nmin-asymptotic.md` and `op05_nmin.py`;
  `n = 1` reproduces this file's own `p*` to 18 digits. **The exponent in the census law of §6 is
  therefore known**, which is the input OP-6 was missing;
  (the interval count still grows at least exponentially and the reachable fraction falls faster);
* ~~the exact order of `measure(S_1)/P(p) → 0`~~ — **RESOLVED (OP-6).** Composing the
  census law of §4 with OP-5's `n_min(p) = p/ln 2 − 3/2 + O(1)`, and using that the
  threshold sits in the regime `p ≫ n` (so `ζ(p,n) = z(p)n^{−p}` with `z(p) → 2`),
  ```
  −log( measure(S_1)/P(p) )  =  p log p − (1 + ln ln 2)p − 0.540509640658…/p + O(1/p²) ,
  ```
  i.e. `measure(S_1)/P(p) = p^{−p} e^{(1+ln ln 2)p}(1+o(1)) → 0`. The leading constant of
  `p log p` is `1`; the linear coefficient `−(1 + ln ln 2) = −0.6334870794…` is exact and
  matches the exact census data to 10 figures at `p = 10⁶`. See
  `../../open/OP-06-reachable-fraction.md` and
  `op06_reachable_fraction.py`. The census identity was re-derived there and reproduces the
  §4 table's `measure/P` column for `p = 2 … 12`;
* non-monotone alphabets in the inverse problem (rh41's §4 open item, untouched);
* non-monotone targets and a complex/phased residual that *can* see the turn
  count (§8(b)) — `α_n = (−1)^n e^{2πiθ}/(n+2)^p` is the natural candidate, and
  whether it keeps a ζ budget is not known;
* an explicit transform from the digit word's support to the ζ-train
  (`../xi-horn/horn-helix.md`) observable — no identity is claimed here.

---

## 11. The handoff ledger, item by item

Status of every item of `HANDOFF.md` §6 after this round.

| id | statement | was | now | where |
|---|---|---|---|---|
| T1 | the signed alphabet and rule | def | **PROVED** (definition) | §0, `Tau.lean` |
| T2 | `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ − 1` | PROVED | **PROVED** (+ Lean at `p = 2,4`) | §2, `Budget.lean` |
| T3 | `P+N = ζ−1`, `P−N = 1−η` | PROVED | **PROVED** | §2 |
| T4 | `P > N` for all `p > 0` | PROVED | **PROVED** | §2, Theorem 3 |
| T5 | `P ~ N ~ 1/(2(p−1))` at the pole | PROVED+VERIFIED | **PROVED+VERIFIED** | §2, Theorem 4 |
| T6 | at `p = 1` every target passes the budget test | VERIFIED | **VERIFIED** (unchanged) | `helix_zeta.py` §3 |
| T7 | reachable ⊆ budget; above it, residual → `x − P(p)` | PROVED+VERIFIED | **PROVED** (Theorem 6 + 11) | §3, §4 |
| T8 | the positive half is the Egyptian greedy at `2^p x` | PROVED+VERIFIED | **PROVED+VERIFIED** | §7, Corollary 15 |
| T9 | the signed support has all gaps even `≥ 2` | VERIFIED | **PROVED** + Lean | §7, `Tau.lean` |
| T10 | the positive half is complete iff `p ≤ p*` | PROOF-SKETCH | **PROVED** | §3, Theorem 8 |
| T11 | at `p = 2` the reachable set is one-gap | PROOF-SKETCH | **PROVED** (Theorem 10) + **VERIFIED** exactly | §4, §5 |
| T12 | at `p = 3` the reachable set is the four intervals | VERIFIED | **PROVED** (Theorem 10) + **VERIFIED** exactly | §4, §5 |
| T13 | the negative half is complete iff `p ≤ q` | PROOF-SKETCH | **PROVED** | §3, Theorem 8 |
| T14 | the three thresholds `pN < pP < p*` | VERIFIED | **VERIFIED** rigorously, + `q` | §6 |
| T15 | at `p*` the budget interval has length `1` | VERIFIED | **PROVED** + **VERIFIED** | §6 |
| T16 | `w` factors through `sin(2πθ)` | PROVED+VERIFIED | **PROVED+VERIFIED** | §8 |
| T17 | the alphabet total is `1 − ln 2`, not `ln 2 − 1` | VERIFIED | **PROVED** + rigorously enclosed | §1 |
| R1 | write out the reachable-set theory | target | **DONE** — `reachable.py`, `Reachable.lean`, Theorem 6–11 | §3–§5 |

New in this round: **Theorem 10** (census), **Theorem 11** (greedy optimality),
**Corollary 15 / §7** (the C1 regime of a signed word), the rigorous
threshold enclosures of §6, the rigorous sign ledger of §1, and the refutations
R3, R4, R7, R8.

---

## 12. Reproduce

```
cd ../../..
python3 rh42/reachable.py                 # 70/70 checks  (verify/reachable.log)
python3 rh42/helix_zeta.py                # 80/80 checks  (verify/helix_zeta_rerun.log)
cd rh42/lean && ./check.sh --all          # 4/4 modules OK (verify/lean_check.log), no sorry
cd ../.. && python3 rh41/lean/crosscheck.py   # rh41's shapes: 1 969 905 cases, all pass
```

Sections of [`reachable.py`](reachable.py) map to this file as: §1 Brown's
criterion (this file §3), §2 the census (this §4), §3 the exact `p = 2, 3`
structure (this §5), §4 greedy optimality (§4), §5 thresholds (§6), §6 the sign
ledger (§1–§2), §7 parity and the complexity transfer (§7), §8 the helix (§8).

The Lean files:

| file | contents |
|---|---|
| [`lean/Rh42/Budget.lean`](Rh42/Budget.lean) | the budget closed forms `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`, `P(2)+N(2) = π²/6 − 1`, from Mathlib's `hasSum_zeta_two/four` by even/odd splitting |
| [`lean/Rh42/Reachable.lean`](Rh42/Reachable.lean) | Brown's two one-step lemmas, the interval merge, the finite sub-sum operator with its gap lemma, the greedy on a list, and the machine-checked refutation `single_condition_not_sufficient` |
| [`lean/Rh42/Tau.lean`](Rh42/Tau.lean) | the signed greedy on `ℚ`: sign invariance of the residual, parity lock, even gaps `≥ 2` |
| `lean/README.md` | the map from theorems to statements |
