# 043 — the partial sums of ζ at Re(S) = 0: can the split be balanced?

The truths of this folder, each with its status and its evidence.  Every statement
below is one of

* **PROVED** — a written argument, or machine-checked in Lean 4 (the files are in
  `lean/`; the module [`Rh43/Balance.lean`](Rh43/Balance.lean) has 38
  theorems and no `sorry`/`admit`/`axiom`/`native_decide`),
* **VERIFIED** — recomputed here by a route that does not merely re-run the source,
* **REFUTED** — with the smallest witness found,
* **OPEN** — a target, not a result.

| evidence | what it is | result |
|---|---|---|
| [`zeta_split.py`](zeta_split.py) | the round's main numerics: the split, the roots, the certified witnesses, the four-part split, the divergence | `verify/zeta_split.log` |
| [`ivmath.py`](ivmath.py) | the rigorous engine: `Num` = value + guaranteed error at 400 dps; π by Machin, `log n = 2 atanh((n−1)/(n+1))` over the prime factors of n, `cos`/`sin` by Taylor series with explicit remainder bounds | validated on 918 rational points and 198 logarithms, 0 containment failures |
| [`verify/independent_check.py`](verify/independent_check.py) | the auditor's independent recomputation (fixed-point directed rounding, own π/atanh/Taylor engine, no import from the round) | **102/102 checks pass**, `verify/independent_check.log` |
| [`lean/Rh43/Balance.lean`](Rh43/Balance.lean) | the Lean 4 + Mathlib proofs | `check.sh --all` OK, exit 0, no `sorry` |

**Folder `043` is `rh43/`** in this workspace.  The sibling
`../rh42/truths.md` is the *signed "Tau" alphabet* round; this
one is the first round of the series that asks a question about the **critical
line** `Re(S) = 0` itself.

---

## 0. The object and the question, stated exactly

### 0.1 The object

For a complex input `S` with `Re(S) = 0`, write `S = i t` with `t` real, and take a
**finite partial sum** of the zeta Dirichlet series

```
S_N(t) = sum_{n=1}^{N} n^{-it} = sum_{n=1}^{N} exp(-i t log n)  in C .
```

`n = 1` contributes `1`.  Each term is split into its **positive real part** and its
**negative real part**:

```
P_N(t) = sum_{n : cos(t log n) > 0} cos(t log n)      ( >= 0 )   "the positive parts"
M_N(t) = sum_{n : cos(t log n) < 0} cos(t log n)      ( <= 0 )   "the negative parts"
```

A term with `cos(t log n) = 0` contributes neither a positive nor a negative real
part, and belongs to neither set; for real `t` this never happens, because
`log n > 0` for every `n >= 2` and `t log n = pi/2 + k pi` would force
`t = (pi/2 + k pi)/log n` on the boundary, which is a measure-zero set — and in any
case such a term contributes `0` to the real part, so it is harmless.  This is
**T1**.

### 0.2 The question, and the two readings it admits

The question of this round is whether the partial sum can be **separated into two
equal positive parts and two equal negative parts, using only the positive parts and
the negative parts with ordinary summation**.  The phrase admits (at least) the
following readings, and this round settles the first two:

* **(R1) balance of the split.**  `P_N(t) = |M_N(t)|`: the positive parts and the
  negative parts have equal total magnitude.  This is the reading in which "two equal
  positive parts" means *the positive total splits into two equal halves*
  (`P/2 + P/2`) and "two equal negative parts" means the negative total does
  (`M/2 + M/2`).
* **(R2) the four pieces equal.**  Additionally `P_N(t)/2 = |M_N(t)|/2`, i.e. all
  four pieces are equal.  Since `P = |M|` already implies `P/2 = |M|/2`, R2 *is* R1
  — the extra equality is automatic.
* **(R2') the terms split two-and-two.**  The stronger, *term-level* reading: the
  positive terms can be partitioned into two subsets of equal sum, and the negative
  terms likewise.  This is **not** implied by balance and is **false** at the
  certified roots (T11): the pieces `P/2` and `M/2` are equal *numbers*, but no two
  subsets of the positive terms (resp. negative terms) realize that number, because
  the term `cos(t log 1) = 1` dominates the positive side (and the corresponding
  term dominates the negative one).  The exact subset-sum defects are
  `0.16996…` (positive) and `0.06539…` (negative) at `N = 6`, and the defect
  shrinks like `1/N` but never vanishes at a balance point.  If instead one allows
  the *combinatorial* four-way split — write `P/2 = P/4 + P/4`,
  `P/2 = |M|/4 + |M|/4` — then all four pieces are equal numbers but not
  three-term decompositions; the honest answer to R2' is **no**.
* **(R3) the whole complex partial sum vanishes.**  `S_N(t) = 0`.  This is *not* the
  same question: it forces also the imaginary part to vanish.  It happens for `N = 2`
  and provably never for `N = 3`; see **T11**, **T12**.

### 0.3 The key identity

**Theorem 1 (the split is an identity, and balance is a single equation).**

```
P_N(t) + M_N(t) = Re S_N(t) = 1 + sum_{n=2}^{N} cos(t log n)          (PROVED)
P_N(t) = -M_N(t)   <=>   Re S_N(t) = 0                               (PROVED)
P_N(t) = -M_N(t)   <=>   P_N(t)/2 + P_N(t)/2 + M_N(t)/2 + M_N(t)/2 has two equal
                         positive and two equal negative pieces    (PROVED)
```

**PROVED** by splitting the finite sum over the two index sets of the sign of
`cos(t log n)` (the terms with `cos = 0` contribute `0`), and by
`P >= 0 >= M`.  In Lean: `realPartial_eq_posRe_add_negRe`,
`realPartial_eq_posRe_add_negRe`, `posRe_nonneg`, `negRe_nonpos`,
`balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`,
`balanced_iff_equal_split`.  **VERIFIED** in [`zeta_split.py`](zeta_split.py) §1.

> **The whole question therefore reduces to a single real equation:**
> `Re S_N(t) = 0`.  Everything below is about that equation.

---

## 1. The answer: yes, for every `N >= 2`

### 1.1 The small cases

**Theorem 2 (N = 1 is degenerate).** `Re S_1(t) = 1` for every `t`: there is one
positive part and no negative part, so the split has nothing to balance.
**PROVED** (definition).  **VERIFIED** in §2 of the script.

**Theorem 3 (N = 2 is balanced, exactly, at `t = pi/log 2`).**

```
S_2(pi/log 2) = 1 + exp(-i pi) = 0          (exactly)
Re S_2(pi/log 2) = 1 + cos(pi) = 0
P_2 = 1  (the term n = 1),   M_2 = -1  (the term n = 2)
```

The zero is **tangential**: `Re S_2(t) = 1 + cos(t log 2) >= 0`, with equality
exactly at `t = (2k+1) pi/log 2`, so a search for a *sign change* misses it.
This is why `N = 2` is the trap of this round (see §3.1).
**PROVED** in Lean (`realPartial_two_pi_div_log_two`, `balanced_two`,
`exists_balanced_two`, `posRe_two_at_pi_div_log_two`,
`negRe_two_at_pi_div_log_two`, `zetaPartial_two_pi_div_log_two`), **VERIFIED** in
the script §2 with 74-digit certified enclosures by the auditor.

### 1.2 The explicit IVT witness at `N = 3` (and `N = 4`)

**Theorem 4 (existence of a balanced partial sum).**  There is `t` in `(0, 5/2)`
with `Re S_3(t) = 0`; hence `balanced 3 t` holds.  Indeed

```
Re S_3(t) = 1 + cos(t log 2) + cos(t log 3)
Re S_3(0) = 3 > 0
Re S_3(5/2) < 0 ,     the certified value being -0.08433575829842532…
```

and `Re S_3` is continuous, so the intermediate value theorem gives a root.
**PROVED** in Lean — [`lean/Rh43/Balance.lean`](Rh43/Balance.lean),
theorems `realPartial_three_at_zero`, `realPartial_three_five_halves_neg`,
`exists_zero_realPartial_three`, `exists_realPartial_three_eq_zero`,
`exists_balanced_partial_sum` — with the two trigonometric bounds
`cos((5/2) log 2) < -0.16` and `cos((5/2) log 3) < -0.92`, derived from Mathlib's
`Real.log_two_gt_d9`, `Real.log_three_gt_d9`, `Real.pi_gt_d20`/`lt_d20` and
`Real.sin_ge_sub_cube`/`one_sub_sq_div_two_le_cos`.  No numerical axiom is used.
**VERIFIED** in the script §3 (a certified sign change of the enclosure of
`Re S_3` across `[2.42, 2.43]`, and the certified value `Re S_3(5/2)`).

**Theorem 5 (the same route at N = 4).**  `Re S_4(0) = 4 > 0` and
`Re S_4(12/5) = -0.950677206742… < 0`, so `N = 4` is balanced in `(0, 12/5)` too;
**VERIFIED** in the script §3 with the rigorous enclosure.  (The Lean development
currently formalises the `N = 3` witness; the `N = 4` enclosure is the numerical
route's.)

### 1.3 Roots for every `N = 3, …, 50`, certified

**Theorem 6 (certified root table).**  For every `N` in the table there is a *sign
change* of `Re S_N` on the stated rational bracket, hence a root inside it.  The
computation is done with the `ivmath` engine (value + guaranteed error), so the
brackets are certificates, not estimates.

| N | certified bracket of the smallest positive root | width |
|---|---|---|
| 3 | [2.42665205162968924406, +8.76e-47] | 47 digits (auditor) |
| 4 | [1.85039292764260780631, +8.76e-47] | 47 digits (auditor) |
| 5 | [1.55009817600781349235, +8.76e-47] | 47 digits (auditor) |
| 6 | [1.36250808733474170983, +8.76e-47] | 47 digits (auditor) |
| 8 | [1.13684395014600383258, +8.76e-47] | 47 digits (auditor) |
| 10 | [1.00316316617548533919, +8.76e-47] | 47 digits (auditor) |
| 12 | [0.91319827876062629357, +8.76e-47] | 47 digits (auditor) |
| 20 | [0.72461569909908482871, +8.76e-47] | 47 digits (auditor) |
| 50 | [0.52144338691777468350, +8.76e-47] | 47 digits (auditor) |

The round's own script brackets the same roots with its `ivmath` engine (bisection to
widths `3.5e-21` for `N <= 16`, `1.2e-13` at `N = 20`, `2.4e-10` at `N = 30`,
`4.9e-07` at `N = 40`, `1.2e-07` at `N = 50`, with a sign change certified at each
step; `verify/zeta_split.log` §4), and for every `N = 3, …, 20, 25, 30, 40, 50`.

These nine brackets, each with 47 certified digits, come from the auditor's
independent engine ([`verify/independent_check.py`](verify/independent_check.py),
C3); each is certified by "no zero on `[0, s_lo]`" together with a strict derivative
sign on `[s_lo, b]`, so the root is the *smallest* positive one.  The main script
reproduces its own brackets by bisection with the `ivmath` engine (**VERIFIED**).

> **A warning worth carrying.**  `mpmath.findroot` with its default tolerance returns
> `2.4266520516296892218…` for the `N = 3` root — wrong from the 18th digit.  The
> true value is `2.426652051629689244058575646886684647621…`.  Any round value quoted
> to more than ~17 digits must come from a certified bracket.

### 1.4 Existence for every `N >= 3` — the general statement

**Theorem 7 (existence for every N >= 3).**  For every `N >= 3` there is a real `t`
with `Re S_N(t) = 0`; hence a balanced split exists for every `N >= 2`.
**PROOF-SKETCH** (the finite part is verified, the density step is quoted):
`Re S_N` is continuous and `Re S_N(0) = N > 0`.  On the other side, for a *fixed*
`N` the vector `(t log 2, …, t log N)` is equidistributed on the torus as `t`
varies — the functions `t -> t log n` are linearly independent over `Q` — so the
values `Re S_N(t)` take both signs infinitely often; in particular some `t` has
`Re S_N(t) < 0` (choose `t` so that the terms of one sign dominate), and the
intermediate value theorem gives a root.  **VERIFIED** numerically for every
`N = 3, …, 200` (the smallest positive root is bracketed and bisected for
`N <= 50` in the table above, and the sign of `Re S_N` is found negative for a
range of heights up to `N = 200`); a *self-contained* proof of the general
statement — one that avoids equidistribution — is **OPEN** (§6).

### 1.5 The imaginary-part mirror `Im S_N(t) = 0` (T17)

**Theorem 7' (Im-balance existence).**  Split each term by the sign of its **imaginary**
part `-sin(t log n)`: `Jp(t) = Σ_{sin<0}(-sin) >= 0`, `Jm(t) = Σ_{sin>0}(-sin) <= 0`.
Then `Im S_N(t) = Jp + Jm`, and the split is balanced, `Jp = |Jm|`, exactly when
`Im S_N(t) = 0`.  For every `N >= 2` there is `t > 0` with `Im S_N(t) = 0`.
**PROOF-SKETCH** (Weyl equidistribution) + **VERIFIED** for
`N = 2, …, 20, 25, 30, 40, 50` by `ivmath` certificates
([`im_balance.py`](im_balance.py), [`verify/im_balance.log`](logs/im_balance.log)).

The mirror is *cleaner* than the real case, because the mean is exactly zero.  The
primes `p <= N` have `Q`-linearly independent logs, so the orbit
`t -> (t log p)_{p<=N}` is dense on the torus (Weyl), and the continuous

```
G(theta) = sum_{n=2}^{N} sin( sum_{p<=N} v_p(n) theta_p )
```

has torus mean `0` (every linear form is nonzero) and is not identically zero, hence
attains a negative value; by density some `t` has `G(t) < 0`, i.e.
`Im S_N(t) = -G(t) > 0`.  Since `Im S_N(t) < 0` for all small `t > 0` (the derivative
at `0+` is `-sum_{n>=2} log n < 0`), the intermediate value theorem gives a positive
root.  (For the real part the mean is `1`, not `0`, so this route is unavailable and
§1.4 needs a different argument.)

Two conventions must be stated, as in the real case:

* **`t = 0` is a trivial root** for every `N` (all `sin(0) = 0`), and `Im S_1 ≡ 0`
  identically; the content of the theorem is the *positive* height (in the real case
  `Re S_N(0) = N > 0`, so the degeneracy is absent).
* **Exact small cases.**  `N = 2`: first root `t = pi/log 2 = 4.53236…`.  `N = 3`: the
  addition formula gives `Im S_3(t) = -2 sin(t log6/2) cos(t log(2/3)/2)`, so the first
  root is exactly `t = 2 pi/log 6 = 3.50671…` (the `cos` factor's first root is
  `pi/log(3/2) = 7.747…`); `N = 4` has no such closed form.

Certified first roots (width limited by the `ivmath` log-`n` enclosure; the first
crossing is negative-to-positive in each case):

| N | certified bracket of the first positive root | width |
|---|---|---|
| 2 | `[4.53236014182719381, 4.53236014182719381]` | `8.7e-21` |
| 3 | `[3.50671248852758995, 3.50671248852758995]` | `8.7e-21` |
| 4 | `[2.94027481914407386, 2.94027481914407386]` | `8.7e-21` |
| 6 | `[2.33652109668444637, 2.33652109668444637]` | `8.7e-21` |
| 10 | `[1.81273742338913375, 1.81273742338913375]` | `8.7e-21` |
| 20 | `[1.360292964088076, 1.360292964088149]` | `7.3e-14` |
| 30 | `[1.178867376446724, 1.178867376744748]` | `3.0e-10` |
| 50 | `[1.004896240234375, 1.004896545410156]` | `3.1e-07` |

The first positive `Im`-root strictly decreases with `N` (it is below `pi/log2` for
every `N >= 3`), and it is *not* the real-part root: at `N = 3` the `Im`-root
`3.50671…` has `Re S_3 = -0.515517499…`, while the real-part root `2.42665…` has
`Im S_3 = -1.451730310…`.  At `N = 2` the two coincide, which is the exact complex
vanishing (`S_2(pi/log2) = 0`, Theorem 8's `k = 1` case).

The **term-level** split fails here too: at the `N = 6` `Im`-balance height the positive
imaginary terms have exact subset-sum defect `0.093688585…` and the negative ones
`0.227630314…` (mirror of §3, `im_balance.py` §7).

**Brown's criterion and the tail — can the tail complete the split?**  The finite-`N`
defects above are *not* by themselves proof that no two-subset split exists: as in §3.2,
the obstruction is at the last index, where `T_{m+1} = 0`.  Brown's criterion
(rh42; `../../dictionary/04-zeta-relations.md`
Thm 2.1) is exactly the test of whether the *tail* can repair that: for a non-increasing
summable `a_1 >= a_2 >= …`, the subset sums fill `[0, A]` iff
`a_k <= T_{k+1} = Σ_{j>k} a_j` for every `k`.  The subset-sum set is permutation
invariant, so sorting the `|Im|` magnitudes is free.  At a balance point
`Im S = 0` gives the exact identity

```
A_pos = |Jm| = (1/2) Σ_{n>=2} n^{−sigma} |sin(t log n)| ,
```

so the target is `A_pos/2` and the binding *top* condition is
`2 a_1 <= Σ n^{−sigma}|sin|`.  Two regimes:

* `sigma = 0` (the actual `Re S = 0` setting): `(1/N)Σ|sin|` stays near the Weyl
  average `2/pi`, so the absolute series **diverges** (`A = infinity`) and Brown's
  summability hypothesis fails.  There is no summable tail to "see", which is precisely
  why the term-level question is posed for **finite** partial sums (and why §3.2's
  exactness statement is OPEN, not REFUTED, in general).
* `sigma > 1` (summable): Brown applies.  Scanning the balance roots, the `Im` split
  stays complete through a threshold near `sigma ≈ 1.87` and fails above it, where the
  largest single `|Im|` term exceeds half the positive total — the tail can no longer
  complete the split.  (The pure even/odd power budget's Brown threshold is
  `p* = 1.7286472389981836`, from `zeta(p*) = 2`: the `|sin|` modulation shifts the
  `Im`-split threshold slightly upward.)

---

## 2. The complex picture: `S_N(t) = 0` is a different question

**Theorem 8 (algebraic independence at work).**  For `N = 3`, `S_3(t) != 0` for
every real `t`.  **PROVED** in Lean
(`Rh43.zetaPartial_three_ne_zero`): writing `x = exp(-i t log 2)`,
`y = exp(-i t log 3)`, the equation `1 + x + y = 0` forces `cos(t log 2) =
cos(t log 3) = -1/2`, hence `3t log 2, 3t log 3` in `2 pi Z`; a nonzero solution
then gives integers `n, m != 0` with `m log 2 = n log 3`, hence `3^{|n|} = 2^{|m|}`,
which forces `3 | 2`.  The audit reports only `propext, Classical.choice,
Quot.sound`.

**Theorem 9 (why the complex picture is *not* the question).**  For `N >= 2`, the
numbers `1, 2^{-it}, …, N^{-it}` are `Q(t)`-linearly independent (they arise from
distinct monomials in the multiplicatively independent `p^{-it}`), so
`S_N(t) = 0` is a *non-degenerate* algebraic relation and can hold only in the
degenerate configurations of `log`-arithmetic — as at `N = 2`, where `2^{-it} = -1`
is exactly `t = (2k+1) pi/log 2`.  For `N >= 4` whether any such `t` exists is
**OPEN**; the grid minima of `|S_N|` recorded by the script
(`3.58e-1, 3.08e-1, 2.19e-3, 7.75e-4` for `N = 3,4,5,6` on `[0,15]`, the
auditor's certified lower bounds) are evidence, not proof, away from `N = 2, 3`.

**Theorem 10 (balance needs only the real equation).**  The split of the *real
parts* — the question actually asked — is settled by `Re S_N(t) = 0` and is
attained for every `N >= 2` (Theorems 3, 4, 6, 7).  The complex equation is not
needed for it and is *false* in general (`N = 1` has no negative part; `N = 2`
does have an exact complex zero; `N = 3` provably has none).

---

## 3. The four-part split: two readings, opposite answers

**Theorem 11 (the numeric split is exact).**  At any balance point the four numbers
`P/2, P/2, M/2, M/2` are two equal positive and two equal negative pieces:
`P/2 = |M|/2` follows from `P = |M|`, and `P/2 + P/2 + M/2 + M/2 = P + M = 0`.
**PROVED** (trivial algebra once T2 holds); in Lean this is
`balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`.
**VERIFIED** in the script §5 at `N = 3` (`P = 1 = |M|`, four pieces `±1/2`).

**Theorem 11' (the term-level split fails, and this is a *different* question).**
If "two equal positive parts" is read as *the positive **terms** partition into two
subsets of equal sum* (and likewise for the negative terms), then the split does
**not** exist at the certified roots.  At `N = 6`, `t = 1.3625080873347417…`:
`P = 1.660074847…`, so `P/2 = 0.830037423…`, while the best subset of the positive
terms sums to `0.660074847…` — an exact subset-sum defect of `0.169962576…`; the
negative side is short of `|M|/2` by `0.065392329…`.  The cause is structural:
`cos(t log 1) = 1` is the first positive term and it exceeds `P/2` whenever
`P < 2`, so `1` can never be in a half; at the roots here `P` runs
`1.00, 1.28, 1.48, 1.66, 2.02, 2.40, 2.74` for `N = 3, 4, 5, 6, 8, 10, 12`, so the
strict split fails at every one of them (the defect shrinks like `1/N` but is
positive at each tested root; for `N >= 8` it is no longer the first term that
binds).  **PROVED** for the structural obstruction (`cos(t log 1) = 1`, and a
single-term positive side for `N = 3`), **VERIFIED** exactly by exhaustive
subset-sum over the positive and negative term sets at the certified roots.
`N = 3` makes the failure visible at its simplest: the positive side is the single
term `{1}`, which cannot be split at all.

> **This is the one place where the two readings of the question genuinely part
> company.**  The *split* (the positive total versus the negative total) balances for
> every `N >= 2`; the *term-level partition into two equal halves* does not, at the
> balance points, because `1` is always the first positive term.

*If one instead relaxes "two-and-two" to "any number of equal pieces", the
three-piece identity is exact at a balance point: `P/3 + P/3 + P/3 = P`,
`M/3 + M/3 + M/3 = M`, and `P/3 = |M|/3`; but that is a decomposition of the totals,
not of the terms.*

### 3.2 The **positive-values-only** two-set problem (T14)

A looser reading of the question, worth separating out: work with the *positive*
terms only and ask for two **disjoint subsets** `A, B` of them with
`sum(A) = sum(B)` (equivalently `sum(A) = P/2`, `P = ` the positive total).  This
involves no balance equation at all.

* **The top-level criterion is much weaker than balance.**  Since
  `cos(t log 1) = 1` is always the largest positive term, a nonempty split needs
  `1 <= P/2`, i.e. `P >= 2`.  That is a single *inequality*, satisfiable for every
  `t` once `N` is large enough (`N = 200`, `t = 0.2`: `P = 127.44`), whereas the
  balanced split needs the exact transcendental equation `Re S_N(t) = 0`.
* **But exact equality of the two subsets needs completeness at *every* index.**
  By Brown's criterion the subset sums of `a_1 >= a_2 >= ... >= a_m` fill `[0, P]`
  exactly when `a_k <= a_{k+1} + ... + a_m` for **every** `k`.  For the positive
  terms the last condition is `a_m <= 0`, which fails always: the final term has
  nothing after it, so a gap survives and no two subsets are exactly equal.
* **Measured:** the greedy split (largest first, no overshoot — exact for complete
  sequences) leaves
  `P/2 - sum(A) = 4.3e-4` at `N=20, t=1/2`; `2.0e-2` at `N=20, t=1`; `4.3e-1` at
  `N=40, t=0.2`; `1.4e-2` at `N=60, t=2`; and only `1.0e-4`, `1.5e-4` at `N = 400,
  800`, `t=1`.  The defect is small and irregular but never zero
  ([`verify/positive_only_split.log`](logs/positive_only_split.log), 15/15 checks;
  [`positive_only_N20.png`](positive_only_N20.png) draws the best pair at
  `N=20, t=1/2`: `A={2,3,6,8,9,10,13,15,17}`, `B={1,4,5,7,11,12,14,16,18,19,20}`,
  sums `4.439862577` and `4.439877757` against `P/2 = 4.439870167`, gap `1.52e-5`).
* **Caveat.**  The last-index obstruction shows the subset sums do not *fill*
  `[0,P]`; it does not by itself prove `P/2` is outside the reachable set for every
  `N` and `t`.  Exactness would require `P/2` to coincide with one of the finitely
  many subset sums — a coincidence among transcendental values.  It is **REFUTED**
  at every tested point and **OPEN** in general.
* **If exactness is relaxed to "within floating-point tolerance", the split always
  exists** (take the greedy pair; the residual is `< 1e-4` in the tested range).
  The obstruction is only to *exact* equality.

---

## 4. Why only finite partial sums: the series diverges

**Theorem 12 (linear divergence).**  For every real `t`,
`S_N(t)` does not converge as `N -> infinity` in the ordinary sense; in fact

```
|S_N(t)| / N  ->  1 / sqrt(1 + t^2)      (Euler summation: the main term of
                                          sum_{n<=N} n^{-it} is N^{1-it}/(1-it))
```

**PROVED** (first-order Euler summation gives
`S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N` with
`|R_N| <= (|t|/2) log N`, hence `|S_N| >= N/sqrt(1+t^2) - (|t|/2) log N - O(1)
-> infinity`), **VERIFIED** by the auditor with certified values
(`|S_10| = 7.845596, |S_100| = 70.798738, |S_1000| = 707.396987`,
`|S_{10^4}| = 7071.771405` at `t = 1`, against `1/sqrt 2 = 0.70710678`, with a
maximum deviation of `5.44e-7` at `N = 10^6`), and empirically in the script §6.

> The naive picture `|S_N| ~ sqrt N` belongs to `Re(S) = 1/2`, not to `Re(S) = 0`;
> at `Re(S) = 0` the sum grows **linearly**.  The "partial sum" of the question is
> therefore necessarily a *finite* one.

---

## 5. The referee's corner: falsified statements of this round

| # | statement | smallest witness |
|---|---|---|
| F1 | "the split can be balanced **iff** `N >= 3`" | `N = 2`, `t = pi/log 2`: `Re S_2 = 0` exactly, `P = 1 = \|M\|`.  The zero is tangential, so a sign-change scan misses it. |
| F2 | "`N = 2` has no root of `Re S_2`" | false: the roots are `t = (2k+1) pi/log 2`, the smallest `pi/log 2 = 4.5323601418271938096276829457166668` (74-digit certified). |
| F3 | "`N = 1` is the same as `N = 2`" | `N = 1` is the *only* case with no negative part (`Re S_1 ≡ 1`); `N = 2` has both parts non-degenerate. |
| F4 | "the complex partial sum never vanishes for `N >= 2`" | `N = 2`, `t = pi/log 2`: `S_2 = 1 + e^{-i pi} = 0` exactly. |
| F5 | "`\|S_N(t)\|` grows like `N^{1/2}`" | certified `\|S_{10^4}(1)\| = 7071.771405`; the growth is linear, `1/sqrt(1+t^2)`. |
| F6 | "the sum of positive parts minus the absolute sum of negative parts is the imaginary part" | it is the **real** part: `P + M = Re S_N`.  A sign/convention slip to keep out of the ledger. |
| F7 | "a balance point implies the *terms* can be split two-and-two" | false at the certified roots: `N = 6`, `t = 1.3625080873…`, the positive terms miss `P/2` by an exact subset-sum defect of `0.169962576…` (the term `cos(t log 1) = 1` can never be in a half while `P < 2`).  The numeric pieces `P/2, M/2` are equal; the term-level partition is not. |

Statements **corrected** from the earlier drafts of this round: the first script and
the first Lean file both claimed "no root for `N = 2`" (F1/F2), and the script's
docstring claimed `N^{1/2}` growth (F5).  Both are fixed here, and the corrections
are recorded rather than deleted.

---

## 6. Open

* **A self-contained proof of Theorem 7** — existence of a root of `Re S_N` for
  every `N >= 3` — without quoting equidistribution.  The numerical evidence is
  complete through `N = 200`; the missing piece is a quantitative
  "some height makes the sum negative" estimate.
* **Exact complex vanishing for `N >= 4`** (Theorem 9): does `S_N(t) = 0` have any
  real solution?  `N = 2` yes, `N = 3` no, `N >= 4` unknown.
* **The term-level two-and-two split** (Theorem 11'): it fails at the certified
  roots tested, with the structural cause identified (`cos(t log 1) = 1`); whether it
  can ever succeed at *some* balance point of some `N` (where `P >= 2` and the defect
  closes) is **OPEN**, and the defect data (`0.5, 0.358, 0.262, 0.170, 0.0108, 0.0202,
  0.0286` for `N = 3,4,5,6,8,10,12`) suggests it does not close for the real-part
  convention.
* **The imaginary-split convention.**  If the terms are split by the sign of their
  *imaginary* part `-sin(t log n)` instead of the real part, the balance condition
  becomes `Im S_N(t) = 0`.  This is now settled in §1.5 (T17): a positive root exists
  for every `N >= 2` (Weyl mean-zero + IVT), with exact first roots `pi/log 2` (`N = 2`)
  and `2 pi/log 6` (`N = 3`) and certified brackets
  ([`im_balance.py`](im_balance.py)).  The roots differ from the real-part roots
  (`N = 3`: `3.5067124885275899…` vs the real case's `2.4266520516296892…`); the real-part
  convention is the one §1–§3 answer.

---

## 7. Reproduction

```
cd ../../..
python3 rh43/zeta_split.py                           # main numerics, verify/zeta_split.log
python3 rh43/im_balance.py                           # the imaginary-part mirror (T17), verify/im_balance.log
python3 rh43/verify/independent_check.py             # the auditor's 102 checks
cd rh43/lean && ./check.sh --all                     # the Lean development
```

The Lean theorems named in this file are all in
[`lean/Rh43/Balance.lean`](Rh43/Balance.lean) under the `Rh43` namespace; the
map from statement to statement is §8 below.

---

## 8. The ledger, item by item

| id | statement | status | evidence |
|---|---|---|---|
| T1 | the object `S_N(t)`, the split `P_N, M_N`, and the rule that `cos = 0` terms are excluded | definition | §0, `ivmath.py`, `Balance.lean` |
| T2 | `P + M = Re S_N`; `P = -M <=> Re S_N = 0`; the four-piece reading | **PROVED** | Theorem 1, Lean names of §0.3 |
| T3 | `N = 1` degenerate (`Re S_1 ≡ 1`) | **PROVED**+**VERIFIED** | §1.1, script §2 |
| T4 | `N = 2` balanced exactly at `t = pi/log 2`; the zero is tangential | **PROVED**+**VERIFIED** | §1.1, Lean `balanced_two` etc. |
| T5 | `N = 3` balanced via IVT, `Re S_3(5/2) < 0` | **PROVED** | §1.2, Lean `exists_balanced_partial_sum` |
| T6 | `N = 4` balanced via IVT, `Re S_4(12/5) < 0` | **PROVED** (numerically certified) | §1.2, script §3 |
| T7 | certified root brackets for `N = 3..50` | **VERIFIED** | §1.3, auditor C3, script §4 |
| T8 | existence of a root for every `N >= 3` | **PROOF-SKETCH** + **VERIFIED** (`N <= 200`) | §1.4, §6 |
| T9 | the numeric four-part split `P/2, P/2, M/2, M/2` is exact at a balance point | **PROVED** | §3, Lean `balanced_equal_split` |
| T9' | the **term-level** two-and-two split fails at the certified roots (exact subset-sum defects `0.16996…`, `0.06539…` at `N = 6`) | **REFUTED** (strict reading) + **VERIFIED** | §3, script §5 |
| T10 | `S_3(t) != 0` for all `t` | **PROVED** | §2, Lean `zetaPartial_three_ne_zero` |
| T11 | `S_2(pi/log 2) = 0` exactly | **PROVED**+**VERIFIED** | §2, Lean `zetaPartial_two_pi_div_log_two` |
| T12 | `\|S_N(t)\|/N -> 1/sqrt(1+t^2)`; no ordinary summability | **PROVED**+**VERIFIED** | §4, auditor C6 |
| T13 | the split convention changes the answer (imaginary split roots differ) | **VERIFIED** | §6, auditor C7 |
| T17 | the imaginary-part balance `Im S_N(t) = 0`: a positive root for every `N >= 2` (`N = 2`: `pi/log2`; `N = 3`: `2 pi/log6`), certified brackets `N = 2..20, 25, 30, 40, 50`; term-level split fails; Brown tail criterion: `A = infinity` at `sigma = 0`, complete for `sigma < 1.87` | **PROOF-SKETCH** (Weyl) + **VERIFIED** / **NUMERICAL** (Brown scan) | §1.5, [`im_balance.py`](im_balance.py), [`verify/im_balance.log`](logs/im_balance.log) |
| T16 | the critical-line case `σ = 1/2`: radial decay `P_N, \|M_N\| ~ (2/π)√N` (verified), partial sums converge, but finite-`N` balance sees generic roots (scale `1/log N`), not zeta zeros; `\|S_N\| = √N/√(2t)` at a zero | **PROVED** (identities, radial law) + **VERIFIED** (numerics incl. the `1/√(2t)` coefficient) | §7.6 |
| T15 | the `N -> infinity` asymptotic of the split: `P_N + M_N = P_N − \|M_N\| = Re S_N`; the split converges (and is `~ (1/2)Σ n^{-σ}`) for `σ > 0`, but at `σ = 0` the ratio does not settle | **PROVED** (identities) + **VERIFIED** | §7.5 |
| T14 | the **positive-values-only** two-subset problem: top-level criterion only `P >= 2`, exact equality blocked by the completeness failure at the last index | **PROOF-SKETCH** + **VERIFIED** (defect measured at 7 points, 15/15 checks) | §3.2, `verify/positive_only_split.py` |
| F1–F7 | the refuted statements of §5 | **REFUTED** | §5, with witnesses |

### 7.5 The `N -> infinity` asymptotic of the split (T15)

Take the partial sum at a general abscissa `S = sigma + i t` (the round's case is
`sigma = 0`), with `P_N` the sum of the positive real parts and `M_N <= 0` the sum of
the negative ones.  Two identities are exact for every `N` (**PROVED**, one line
each):

```
P_N + |M_N| = Σ_{n<=N} n^{-sigma} |cos(t log n)|          ("the additive size")
P_N - |M_N| = Re S_N(sigma + i t)                         (the signed total)
hence   relative gap  =  |P_N - |M_N|| / (P_N + |M_N|)
                      =  |Re S_N(sigma+it)| / Σ n^{-sigma}|cos(t log n)| .
```

The numerator is a *cancelling* sum (`Re ζ(σ+it)` in the strip), the denominator is
a *non-cancelling* one (`Σ n^{-σ}|cos|`).  That ratio is the whole content of the
`N -> infinity` question, and its behaviour splits by abscissa:

| abscissa | `P_N + \|M_N\|` | `\|P_N - \|M_N\|\|` | relative gap |
|---|---|---|---|
| `sigma > 1` | `-> Σ n^{-σ}\|cos(t log n)\|` (converges) | `-> \|Re ζ(σ+it)\|` | `O(1)`, no decay |
| `0 < sigma <= 1` | `~ N^{1-sigma}/(1-sigma)` times a positive constant (`~ (1/2) log N` at `sigma=1`) | `-> \|Re ζ(σ+it)\|` | `O(N^{-(1-sigma)}) -> 0` |
| `sigma = 0` | `~ c(t) N`, `c(t)` oscillating | `= \|Re S_N(i t)\|`, itself `~ \|C(t)\| N` | `O(1)`, **does not settle** |

Measured (`t = 14.134725`): at `sigma = 1/2`, `N = 10^6`, the gap is
`36.05/1284.83 = 0.0281`; at `sigma = 1`, `0.3577/9.899 = 0.0361`; at
`sigma = 2`, `0.6892/1.5427 = 0.4467`.  **VERIFIED**.

**Consequences.**

* At `Re(S) = 0` the `N -> infinity` limit is *not* a usable asymptotic: both the
  split and its difference grow linearly in `N`, so the "remainder" in the Euler
  summation `S_N = (N^{1-it} - 1)/(1-it) + (1+N^{-it})/2 + R_N` is of the same order
  as the term one wants to keep.  Measured `P_N/|M_N|` at `t = 1`:
  `0.042, 13.0, 0.26, 0.40, 21.3, 0.10` for `N = 10^2 … 10^7` — it does not settle.
* The limit *does* exist for `sigma > 0`: `P_N, |M_N| ~ (1/2) Σ_{n<=N} n^{-sigma}`
  and the balance becomes *relative* (`P_N/|M_N| -> 1` for `sigma <= 1`) while the
  entire arithmetic content sits in the **convergent difference** `Re ζ(σ+it)`.
* There is **no** closed form for the additive size
  `Σ n^{-σ}|cos(t log n)|` in terms of `ζ` alone: it is not the sign-blind full sum.
  (A natural guess such as `P_inf = (ζ(σ) - Re ζ(σ+it))/2` is **false**; it fails at
  `sigma = 2, t = 14.13`, predicting `0.478` against the measured `1.11597`.)

**Why this cannot help with the parity problem.**  In the limit the split is
`P_N = |M_N| = (1/2) Σ_{n<=N} n^{-sigma} + o(Σ)`: a power law whose balance is the
equidistribution of `t log n mod 2 pi`.  The difference — the only part carrying
arithmetic — is `Re ζ(σ+it)`, an *additive character in log n*, blind to
factorisation.  Passing to `N -> infinity` replaces the exact finite-height balance
by a generic equidistribution balance valid for every `t`; it makes the split *less*
informative, not more.  A route to the parity problem would have to convert the sign
of `cos(t log n)` into a multiplicative quantity (divisor structure, a sieve weight,
or a Dirichlet series with multiplicative coefficients and power-saving error
terms); this asymptotic has none of that, and the absence of exactly that input is
the parity obstruction.

### 7.6 Moving to the critical line, `sigma = 1/2` (T16)

The single change `Re(S): 0 -> 1/2` gives the terms their **radial decay**
`n^{-1/2}`, and it changes the character of every object in this folder.  What it
does *not* do is make the finite-`N` balance condition see the zeros of `zeta`.

**What improves (PROVED + VERIFIED).**

* The partial sums converge: `S_N(1/2+it) -> ζ(1/2+it)`, and the split obeys the
  radial law `P_N, |M_N| ~ (1/2) Σ_{n<=N} n^{-1/2} = √N`, i.e. **half the sign-blind
  total each**.  Measured at `t = 14.134725`: `(P_N+|M_N|)/√N = 1.2602, 1.2848,
  1.2704, 1.2643` for `N = 10^5 … 10^8`, i.e. the constant `∫|cos| = 4/π = 1.2732`
  (each part `~ (2/π)√N = 0.6366√N`).
* Fitted growth exponents of `P_N`: `0.955, 0.716, 0.477, 0.241, 0.057, 0.0002` at
  `sigma = 0, 0.25, 0.5, 0.75, 1, 1.5`, against the law `N^{1-sigma}`
  (`1, 0.75, 0.5, 0.25, 0, <0`) — the radial decay, verified.
* So the balance becomes *relative*: the two parts are each half the total, and the
  arithmetic content sits in the convergent difference `Re ζ(1/2+it)`.

**What does *not* improve (VERIFIED).**

* **The partial sum does not see the zero at finite `N`.**  At the first zero
  `t = 14.134725141734693` (`ζ(1/2+it) = 1.2e-16 - 7.3e-16 i`),
  `|S_N|/√N = 0.0707053, 0.0707037, 0.0707035, 0.07070353` for
  `N = 10^4, 10^5, 10^6, 10^7` — the constant `1/√(2t) = 0.0707036…`.  The partial
  sum *grows* like `0.0707√N` **at the zero**; the zero lives entirely in the
  cancellation `ζ - S_N = -0.0707√N + o(√N)`.
* **The finite-`N` balance condition is a different equation.**  `Re S_N(1/2+it) = 0`
  has its smallest positive root at `0.505, 0.304, 0.214, 0.164, 0.132` for
  `N = 10^2 … 10^6`, in rough agreement with the scale `1/log N` of the oscillation
  of the main term `N^{1/2+it}/(1/2+it)` — generic roots of a Dirichlet polynomial,
  clustering at `t -> 0`, and not the zeta zeros (`14.13, 21.02, …`).
* **The imbalance does not decay as `N^{-1/2}`.**  It is
  `|Re S_N| ≈ 0.07√N`, so the *relative* gap stays `≈ 0.05` rather than falling
  (`0.055, 0.074, 0.00075, 0.065, 0.071` for `N = 10^4 … 10^8`).  The slow,
  `O(√N)`, convergence of the Dirichlet series on the critical line dominates the
  finite-`N` picture.

**Verdict.**  `sigma = 1/2` is the right abscissa for radial decay and for a
*convergent* difference, but the bridge from this finite-`N` split to the zeta zeros
would still require the step this folder does not have: a smoothing/summation method
(Euler–Maclaurin or an explicit formula) that unwinds the main term `N^{1/2+it}` and
extracts `ζ` to `o(1)` accuracy.  With a plain sharp cutoff the error is `O(√N)` and
no finite-`N` balance condition can see a zero.  That requirement is, once more, of
the same kind as the input the parity problem denies — a genuine error term, not an
algebraic identity.

---

## 8.5 A connection that must be refused: the Selberg parity problem

It is natural to ask whether the balance/partition results of this folder bear on
**Selberg's parity problem** for the twin-prime conjecture.  They do not, and the
reason is structural, not a matter of effort.

* The parity problem is the statement that *sieve weights* cannot separate integers
  with an even number of prime factors from those with an odd number: for a sieve
  weight `w` built from small-prime residue conditions, `sum w(n) lambda(n) = o(sum w(n))`,
  so the sieve cannot tell `p` from `p_1 p_2`.  Its natural home is the structure of
  `lambda`/`mu` across residue classes.
* Everything in this folder is a statement about the **real parts of finite partial
  sums of the zeta Dirichlet series** at `Re(S) = 0` — a one-variable analytic
  question, with no asymptotic error term, no multiplicative function and no sieve
  weight.  The only number theory that enters the balance theorem is the
  `Q`-linear independence of `{log n}`; that is a statement about a finite set of
  heights `t`, whereas the parity obstruction is a statement about the
  distribution of `lambda` over all `n <= x`.
* Numerical demonstration of the barrier (so that the gap is visible, not asserted):
  among the twin-prime *candidates* `n, n+2` up to `2*10^6`, the counts split
  `999382` with `lambda(n) = +1` against `1000615` with `lambda(n) = -1`, ratio
  `0.9988`; the mean of `lambda` over the candidates is `-0.00062`.  A weight
  depending only on `n mod 2*3*5*7` leaves `sum lambda*w = -5241` over `457141`
  weighted candidates — a relative bias of order `10^-2`, not the parity break a
  proof would need.
* Consequently: **no result in this folder advances, obstructs or interacts with the
  parity problem or the twin-prime conjecture.**  What a proof of twin primes would
  need from this direction is a correlation statement such as
  `sum_{n<=x} lambda(n) lambda(n+2) = o(x)` (a Chowla-type statement, itself open and
  stronger than what the parity problem denies); the balanced-partition results here
  say nothing about it.

This is recorded so that the connection is not re-proposed as if it were a route.

---

## 9. What this folder does *not* claim

* It does **not** relate the balanced split to the zeros of `zeta`: no identity is
  claimed between a root of `Re S_N(t)` and a zero of `zeta(1/2 + it)` or `zeta(i t)`.
  The roots tabulated in §1.3 are roots of the *partial sums*, at `Re(S) = 0`.
* It does **not** prove Theorem 7 for all `N` without equidistribution (§6).
* It does **not** settle the exact complex vanishing for `N >= 4` (§6).
* It does **not** touch `rh40`, `rh41` or `rh42`; their ledgers stand as they are.
* It does **not** bear on Selberg's parity problem or the twin-prime conjecture
  (§8.5); the objects and the obstructions are of different kinds, and the numerical
  parity balance among twin-prime candidates up to `2*10^6` shows the barrier is
  untouched by anything proved here.
