# Decomposition-lab §2–§3 and the zeta series: what the harmonic tier can and cannot do

**Scope.** Read [`decomposition_lab.html`](decomposition_lab.html) §2–§3 (greedy
Egyptian decomposition of integers / rationals, then promotion to 1/2) as a proposed
way to *decompose the terms of ζ into a second-tier harmonic series*, and ask whether
that simplifies `ζ(s) = Σ n^{−s}` and whether a partition of the terms into positive /
negative `Im`, positive / negative `Re`, or positive / negative vectors can "shed light
on the location of the zeros".  Read in the light of
[`007/handoff.md`](007/handoff.md).

**Statuses** follow the programme legend: **PROVED** (argument or Lean), **VERIFIED**
(independent recomputation), **NUMERICAL** (finite computation only), **HEURISTIC**,
**OPEN**, **REFUTED** (with witness).

Reproduce everything below with
`python3 decomposition_lab_zeta_probe.py` (all output quoted is from that script).

---

## 0. Verdict, stated first

The lab's §2–§3 operation is a **representation-theoretic** identity whose only
invariant is the **sum** of the represented numbers.  Applying it to the *indices* of
the zeta series is exact but gives a series with **≥ e^{n−γ}** terms per index and
denominators that are **doubly exponential** in `n`, partitioned by an indicator that
is a **step, not periodic** in `n`.  So it does **not** simplify `ζ`, and it carries no
phase information, hence cannot partition `Re`/`Im`/vectors in a new way.

There is exactly one class of term-partitions under which a zeta-type series
**does** collapse to a finite "second tier": the **periodic (residue-class / character)
partitions**, via

```
Σ_{n≥1} c(n) n^{−s}  =  q^{−s} Σ_{r=1}^{q} c(r) ζ(s, r/q)          (c q-periodic).
```

That is a finite combination of **Hurwitz zetas**, and for a Dirichlet character it is
`L(s,χ)`.  This is the only reading in which "simplify the zeta function by a harmonic
tier" is literally true — and it is **exactly the setup of 007**, where `F_r(x) =
f_r(x)/(1−x^q)` is the boundary shadow of that same regrouping.

The positive/negative partition idea is not lost, but it is a *different* object from
the harmonic tier, and its sharp form is already in the programme: rh43's **balance
split** for `Re`, and the classical `Z(t)` sign-change route for `Im`.  The decisive
obstruction is `rh43` Thm 4.1: **no finite partial sum of ζ vanishes at a zero**
(`|S_N(1/2+iγ₁)| ≈ 0.0707·√N`, probe P6), so no partition of finitely many *terms*
can locate a zero — the cancellation lives in the tail/completion, not in the terms.

| reading of "second-tier harmonic decomposition of ζ" | outcome | status |
|---|---|---|
| **R1** decompose each index `n` (greedy Egyptian), substitute | exact, but `≥ e^{n−γ}` terms per `n`, doubly-exponential denominators; no collapse | **PROVED** (probe P1–P4) |
| **R2** decompose each magnitude `n^{−σ}` and regroup by denominator | exact rearrangement; groups are interval sums ⇒ Euler–Maclaurin, no new cancellation | **HEURISTIC** (structural) |
| **R3** periodic / residue-class partition | collapses to `q^{−s}Σ_r c(r)ζ(s,r/q)`; `= L(s,χ)` for characters | **PROVED** (classical) + **VERIFIED** (1e−30) |
| **R4** prime-power (Euler) tier | `log ζ = Σ_{p,k} p^{−ks}/k`, `−ζ'/ζ = Σ Λ(n)n^{−s}`; the tier that carries zero data | **PROVED** (classical) + **VERIFIED** |
| **R5** sign / vector partition of the terms | `Re` balance is rh43 Thm 3.1; term-level split fails (Thm 3.5); `Im` is the `Z(t)` route; partial sums cannot vanish (Thm 4.1) | **PROVED** + **NUMERICAL** |

---

## 1. What §2–§3 actually prove

**(R1) Greedy Egyptian lemma** (lab §2/§3).  Every positive rational `x` has a finite
expansion `x = Σ_{d∈D(x)} 1/d` into **distinct** unit fractions, produced greedily;
integers are the special case of §2.  *(Classical; the lab's `greedyQ`/`greedyHalf`
implement it with exact rational arithmetic.)*

**Grouping.**  For a finite multiset `X = {x₁,…,x_m}`, pooling the `D(x_i)` gives a
multiplicity function `c_d ∈ ℤ_{≥0}` with the single invariant

```
Σ_i x_i  =  Σ_d c_d / d .
```

**Promotion** (lab §2/§3) is a rewriting system on the lattice of such representations,
using `k·(1/d) = j·(1/e)` when `ke = jd`.  It preserves the value and nothing else:

* on a **single** greedy expansion the denominators are distinct, so promotion does
  **nothing** (probe P3: `moves = 0` for `n = 1,2,3,4`);
* once several numbers are **pooled**, promotion moves copies around
  (probe P3: `A = {1,…,5}`, `15 = 15` after 21 moves, 104 → 91 groups) — and in doing so
  it **destroys the attribution** of which `x_i` contributed which unit fraction.

So the "second tier" is a nonnegative integer multiplicity vector whose only invariant
is the total sum.  That is the whole content of §2–§3, and it is why the operation is
"magnitude-level".

---

## 2. Reading R1 — decompose the index `n` (does not work)

Writing `D(n)` for the greedy expansion of the integer `n`, the identity

```
ζ(s) = Σ_{n≥1} ( Σ_{d∈D(n)} 1/d )^{−s}
```

is **exact** — and useless.  Probe P1 (matching the lab's own "denominators explode
doubly-exponentially"):

| `n` | terms of `D(n)` | `⌈e^{n−γ}⌉ ≈ k(n)` | largest denominator |
|---|---|---|---|
| 1 | 1 | 1 | 1 digit |
| 2 | 4 | 3 | 1 digit |
| 3 | 13 | 10 | 5 digits |
| 4 | 35 | 30 | 44 digits |
| 5 | 99 | 82 | 142,548 digits |
| 6 | ≥ 226 | 226 | ≥ 308,599 digits |

where `k(n) = max{k : H_k ≤ n}` and `H_k = Σ_{i≤k} 1/i`; the greedy expansion of `n`
contains the whole initial block `1,2,…,k(n)` and then a Sylvester-type tail with
`d_{m+1} ≥ d_m²−d_m+1`, i.e. `log d_m` doubles.  Hence `|D(n)| ≥ e^{n−γ}` and a single
term of `D(6)` already needs a 300,000-digit denominator that cannot conveniently be
written down.

Pooling the indices `n ≤ N` and regrouping by denominator gives the "second-tier
Dirichlet series" `Z_N(s) = Σ_d c_d d^{−s}`.  By construction `Z_N(1) = N(N+1)/2`,
it is supported on `~e^N` distinct denominators, and its values bear no relation to
`ζ` (probe P4; `Z_4(1/2+iγ₁) = 1.322363 − 0.300877i` while `ζ(1/2+iγ₁) = 0`).

**Why it is structurally hopeless, not merely inelegant** (probe P2): the membership
indicator `a_d(n) = 1[d∈D(n)]` is a **threshold** in `n` (`d∈D(n)` once `d ≤ k(n)`,
i.e. eventually constant `1`).  It is therefore *not* `q`-periodic for any `q>1`, so it
admits **no finite Fourier/character expansion**.  Periodicity in `n` is exactly the
hypothesis that makes 007 work (§4 below); without it there is no collapse.

---

## 3. Reading R2 — decompose the magnitude `n^{−σ}` (rearrangement only)

For `s = σ+it`, `n^{−s} = n^{−σ} e^{−it log n}`: the decomposition of the *magnitude*
`n^{−σ}` is independent of the *phase* `e^{−it log n}`.  Regrouping by denominator `d`
gives

```
ζ(σ+it) = Σ_d (1/d) Σ_{n : d ∈ E(n,σ)} e^{−it log n} ,
```

and for each fixed `d` the set `{n : d ∈ E(n,σ)}` is a union of intervals in `n`
(the greedy recursion depends monotonically on `n^{−σ}`).  Each inner sum is therefore
a difference of truncated Dirichlet series over intervals, i.e. exactly what **Abel
summation / Euler–Maclaurin** already gives.  The rearrangement buys no cancellation
beyond the classical tail estimate — this is why 006/007's `O(1/n)` limit laws are
proved by Euler–Maclaurin, not by a harmonic regrouping.  *(Status: HEURISTIC /
structural; the identities are exact, the "no new cancellation" claim is the standard
partial-summation observation.)*

---

## 4. Reading R3 — the periodic partition, the only one that simplifies

This is the genuine "second tier".  If `c : ℕ → ℂ` is `q`-periodic,

```
Σ_{n≥1} c(n) n^{−s}  =  Σ_{r=1}^{q} c(r) Σ_{m≥0} (mq+r)^{−s}
                     =  q^{−s} Σ_{r=1}^{q} c(r) ζ(s, r/q) ,        (HURWITZ)
```

a **finite** combination of Hurwitz zetas.  For a Dirichlet character `χ mod q` the
left side is `L(s,χ)`; for the principal character it is
`Π_{p|q}(1−p^{−s})·ζ(s)`.  Verified independently (grouped summation, 30 dps):
`L(2,χ₃) = 3^{−2}(ζ(2,1/3) − ζ(2,2/3)) = 0.781302412896486296867…`, agreement `9.9e−32`.

This is the precise sense in which a partition of ζ's terms into classes "simplifies"
the series: the classes must be a **finite periodic partition**, and then the
"second tier" is a finite Hurwitz/L combination.  A partition by *Egyptian
decomposition* is a threshold (R1), not periodic, so (HURWITZ) has no analogue.

**007 is the boundary shadow of (HURWITZ).**  For the *tail*
`n^p Σ_{j≥1} c(n+j)(n+j)^{−p}` with `x = e^{−p/n}`, the same periodic regrouping gives

```
F_r(x) = Σ_{j≥1} c(r+j) x^j = f_r(x)/(1 − x^q) ,   f_r(x) = Σ_{s=1}^{q} c(r+s) x^s ,
```

the finite analogue of summing the geometric series per residue class.  What 007 then
shows (see [`007/notes/generalisation-06.md`](007/notes/generalisation-06.md)) is that
the **second-order expansion survives in full shape**,
`p(n) = a n + g + c/n + O(1/n²)`, with character-twisted moments — but the **leading
threshold equation** `F_r(x)=1` exists or not depending on `(χ,r)`: it fails
(**proved**, `Op57.chi3_F_lt_one`, `Op57.chi4_F_lt_one`) for `χ₃, χ₄`, and holds for
29.7 % of the 4537 pairs with real `χ`, `q ≤ 60`.  Crucially, `F_r = 1` is a
**boundary/threshold equation**, *not* a zero of the underlying `L`-function; the
handoff is explicit that 007 "bears on no RH".

---

## 5. Reading R4 — the tier that carries zero information

The harmonic tier that actually governs the zeros is the **multiplicative
(prime-power) tier**, not a unit-fraction tier:

```
log ζ(s) = Σ_p Σ_{k≥1} (1/k) p^{−ks} ,      −ζ'/ζ(s) = Σ_{n≥2} Λ(n) n^{−s} ,   1/ζ(s) = Σ μ(n) n^{−s} .
```

Verified against `log ζ(s)` at `s = 2, 1.5, 1+0.5i` (probe P5; residuals `3.8e−7`,
`3.2e−4`, `1.6e−1`, the last being truncation-limited at `N = 2·10⁵`).  This is the
tier whose coefficients `Λ(n)`, `μ(n)` are multiplicative — the same structural fact
the programme keeps meeting: the useful `ζ`-objects are *multiplicative* or
*additive in `log n`*, whereas a unit-fraction decomposition of the integer `n` is
neither (`dictionary/04-zeta-relations.md` §6).

---

## 6. Reading R5 — positive / negative partitions, made precise

For `s = σ+it` split each term as `n^{−s} = n^{−σ}cos(t log n) − i n^{−σ}sin(t log n)`
and define

```
R_±(t) = Σ_{n: ±cos(t log n)>0} n^{−σ}|cos(t log n)| ,   I_±(t) = Σ_{n: ±sin(t log n)>0} n^{−σ}|sin(t log n)| .
```

Then `Re ζ(s) = R_+ − R_-`, `Im ζ(s) = I_+ − I_-`, and the "vector" version is
`|ζ|² = (R_+−R_-)² + (I_+−I_-)²`.  On the critical line a zero needs **both** balances.

* **Re.** This is exactly rh43.  `P_N = |M_N| ⟺ Re S_N(t) = 0` (**PROVED**:
  `balanced_iff_realPartial_eq_zero`).  But the *term-level* partition fails: at `N=6`
  the exact subset-sum defect is `0.169963…` (**NUMERICAL**,
  `dictionary/04-zeta-relations.md` Thm 3.5), because `cos(t log 1)=1` alone exceeds
  `P/2` whenever `P<2`.
* **Im.** Positive/negative `Im` is the sign of `Σ_{n≤N} sin(t log n)`; on the critical
  line it is (up to the theta phase) the sign of `Z(t)`, i.e. the classical zero
  locator.  The essential ingredient is the **completion**: `Z(t) = e^{iθ(t)}ζ(1/2+it)`
  with `θ(t) = arg Γ(1/4+it/2) − (t/2)log π`, which comes from the functional
  equation, not from the terms.
* **Vectors.** "Positive/negative vectors" is the same information as the pair
  `(sign Re, sign Im)`, i.e. quadrant counting; it is not an independent invariant.

**The decisive caveat for any term-level partition** (`dictionary/04` Thm 4.1, probe
P6): at the first zero, `|S_N(1/2+iγ₁)| ≈ 0.0707·√N` and grows without bound
(`0.709, 2.236, 7.071, 22.36, 70.70` at `N = 10²…10⁶`).  No finite partial sum vanishes
at a zero; the cancellation is in the Euler–Maclaurin tail.  A partition of the
*terms* therefore cannot locate the zero.  The harmonic tier acts on the moduli
`n^{−σ}`, which commute with the phases, so it leaves `R_±, I_±` unchanged term by
term — R1/R2 cannot help R5.

---

## 7. Status table (per claim)

| # | claim | status |
|---|---|---|
| 1 | greedy Egyptian expansion of `n` has `≥ e^{n−γ}` terms; tail log-denominators double | **PROVED** (Sylvester estimate) + **NUMERICAL** (P1) |
| 2 | `a_d(n) = 1[d∈D(n)]` is a step in `n`, not `q`-periodic for `q>1` | **PROVED** (P2 reasoning) + **NUMERICAL** (P2) |
| 3 | promotion preserves the value only; vacuous on one integer | **PROVED** (P3) |
| 4 | `Σ c(n)n^{−s} = q^{−s}Σ_r c(r)ζ(s,r/q)`; `=L(s,χ)` | **PROVED** (classical) + **VERIFIED** `9.9e−32` |
| 5 | the prime-power tier reproduces `log ζ` | **PROVED** (classical) + **VERIFIED** (P5) |
| 6 | Re-balance criterion; term-level split fails | rh43 **PROVED** / **NUMERICAL** |
| 7 | `\|S_N(1/2+iγ₁)\| ~ 0.0707√N` (partial sums cannot see zeros) | rh43 **PROVED** + **NUMERICAL** (P6) |
| 8 | 007: `F_r = f_r/(1−x^q)`; threshold existence is character-dependent; `χ₃,χ₄` fail | 007 **PROVED** (Lean) / **NUMERICAL** |

---

## 8. What is actually open / worth doing

1. **An `Im`-balance theorem — DONE.** rh43 settles attainability for `Re S_N(t)=0` for
   every `N ≥ 2`.  The mirror for `Im S_N(t)=0` is now implemented and certified:
   [`rounds/rh43/im_balance.py`](rounds/rh43/im_balance.py) (54 checks,
   [`verify/im_balance.log`](rounds/rh43/verify/im_balance.log)), recorded as T17 in
   [`rounds/rh43/truths.md`](rounds/rh43/truths.md) §1.5.  It proves existence of a
   **positive** root for every `N ≥ 2` from Weyl equidistribution (the relevant torus
   function has mean exactly `0`, unlike the real part's mean `1`) plus IVT, gives
   exact first roots `π/log 2` (`N=2`) and `2π/log 6` (`N=3`), and certifies brackets
   for `N = 2..20, 25, 30, 40, 50`.  It also shows the term-level `Im` split fails,
   exactly as the real one does, and applies **Brown's criterion** to the tail
   question: at `σ=0` the absolute `Im` series diverges (`A = ∞`) so no summable tail
   can repair the finite-`N` defect, while for `σ > 1` the split is Brown-complete up
   to `σ ≈ 1.87` (vs the pure-budget threshold `p* = 1.7286472389981836`).
2. **Complex characters in 007** (handoff §8, item 3): push the periodic partition
   (HURWITZ) to `χ` with `|χ|=1`, and decide whether `Re Φ_χ` or `|Φ_χ|` is the right
   threshold functional.  This is the honest home of "partition into positive/negative
   real parts" on the `L`-side.  **OPEN.**
3. **Say the zero criterion correctly.** Zeros on the critical line are the two-balance
   condition `R_+=R_-` **and** `I_+=I_-` for the *completed* function; stated for
   partial sums it is false by Thm 4.1.  A precise "two-balance" statement with the
   completion could be formalised.  **OPEN.**
4. **Do not** pursue R1/R2 as a route to zeros: P1–P4 show the replacement is
   astronomically larger, aperiodic, and phase-blind.  Recorded here so the idea is
   not re-tried in this form.

---

*Cross-references:* [`decomposition_lab.html`](decomposition_lab.html) §1–§3 ·
[`007/handoff.md`](007/handoff.md) · [`007/notes/generalisation-06.md`](007/notes/generalisation-06.md) ·
[`dictionary/04-zeta-relations.md`](dictionary/04-zeta-relations.md) ·
[`open/07-open-problems.md`](open/07-open-problems.md) ·
[`decomposition_lab_zeta_probe.py`](decomposition_lab_zeta_probe.py) ·
[`rounds/rh43/im_balance.py`](rounds/rh43/im_balance.py) ·
[`rounds/rh43/truths.md`](rounds/rh43/truths.md) §1.5.
