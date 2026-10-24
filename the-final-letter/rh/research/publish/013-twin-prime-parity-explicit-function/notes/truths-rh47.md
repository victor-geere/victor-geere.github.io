# 047 — the greedy harmonic sine against the TPC parity problem: the ledger

**Round goal:** *use the greedy harmonic sine to solve the parity problem for the twin
prime conjecture.*  **Verdict: not achievable by this programme as it stands**, and the
round's reconnaissance shows *why* — with one strong new structural fact about the
greedy word itself.

Statuses: **PROVED** (Lean), **VERIFIED** (independent recomputation), **REFUTED**
(with witness), **OPEN**.

| evidence | result |
|---|---|
| [`greedy_parity_probe.py`](../python/greedy_parity_probe.py) → [`verify/greedy_parity_probe.log`](../../../twin-prime-parity/rounds/rh47/verify/greedy_parity_probe.log) | **23/23 checks**, exit 0 |
| [`verify/independent_check.py`](../../../twin-prime-parity/010/verify/independent_check.py) → [`verify/independent_check.log`](../../../twin-prime-parity/010/verify/independent_check.log) | **31/31 checks**, exit 0 — an audit *of the barrier claim itself*, which found 2 defects (recorded below) and no hole |
| `lean/Rh47/` | **no longer empty** — [`Rh47/Sparse.lean`](../../../twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean) machine-checks the corrected sparse bound (item OP-12); the inherited rh46 layer is **CERTIFIED** and now has **no** unproved statement (item OP-11). The full barrier formalisation (Brown, the parity lock, R2) remains open |

---

## 1. The new structural fact: the greedy support is Sylvester-sparse (PROVED/VERIFIED)

**Theorem.**  Let `A(x) ⊂ {2,3,4,…}` be the support of the greedy word
(take `1/m` iff `r ≥ 1/m`).  Listing `A = {m₁ < m₂ < …}`,

```
m_{i+1} ≥ m_i (m_i − 1) + 1 .
```

*Proof sketch.*  After taking `1/m_i` the residual is `r < 1/(m_i(m_i−1))`, so no
index below `m_i(m_i−1)+1` can be taken.  ∎

**Consequences (both VERIFIED numerically, 0 violations in 53 159 consecutive pairs):**

* `|A| ≥ 20` forces `max A ≥ s₂₀` (the Sylvester sequence), a number with
  **106 721 digits** — so a target whose support is large enough for a parity
  statistic has its largest index far beyond any computable `λ`.  (The class is
  non-empty: the ladder `x_k = (s_{k+1}−2)/(s_{k+1}−1)` has support exactly
  `{s₁,…,s_k}`.)
* the support **density** is `≈ 3.9·10⁻⁵` (sizes `2.95 → 3.90` for `N = 10² → 10⁵`).

This is why the round's *specified* test (`|A| ≥ 20`) has an **empty domain**: of
19 900 rational targets with denominators `≤ 200` and 400 random ones with
denominators up to `10¹²`, **none** has `|A| ≥ 20` (max sizes 11 and 18).

## 2. The three bridges, tested

### B1 — does the greedy support carry `λ`-parity signal?  **REFUTED (no signal)**

Relaxed diagnostic (`|A| ≥ 4`, elements `≤ 10¹³`, 8 820 targets): the observed mean of
`λ` over the support is `−0.3006`, giving a **nominal** `z = −47.9` against a
size-matched range control — a large apparent signal, which the controls kill:

| control | result |
|---|---|
| positional sign-permutation pool (38 816 occurrences) | `z = +0.43` (p = 0.66) |
| rank-matched slot pools | `z = +1.55` (p = 0.12); per-target 5 % rejection `0.024` |

The nominal signal is an artefact of **repeated positions**: 8 820 supports use only
7 033 distinct indices, with `m = 2` appearing in 70.5 % of them — the statistic is
really a statement about `λ(2) = λ(3) = λ(7) = λ(8) = −1`, `λ(4) = +1`.  The
auditor's independent attempt (C3b) also found only nulls (pooled `z = −1.68, −0.72,
+1.37, −0.74`), and the parity-lock route (C3c) gives match `0.4938` against chance
`0.5009` at **zero** density.  **No signal survives.**

### B2 — do the zeta budgets carry `Ω`-parity information?  **REFUTED**

Index parity and `Ω`-parity are independent: at `N = 10⁷` the four cells give
`χ²(1) = 2.944` (`z = 0.99`), and the residual coupling after conditioning on the
margins has permutation `z = 1.47, 1.30`.  **The strengthening the auditor found is
the decisive one: index parity is invisible to the correlation itself** —
`Σ λ(n)·(−1)ⁿ · λ(n+2)·(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly (`0/10⁶` mismatches), so
even perfect knowledge of index parity would say nothing about `(★)`.

### B3 — does the `ζ`-machinery apply to the correlation?  **REFUTED**

`f(n) = λ(n)λ(n+2)` is not multiplicative (`f(1) = −1 ≠ 1`; coprime witnesses
`f(2)f(11) = −1 ≠ f(22) = 1`, `f(2)f(13) = 1 ≠ f(26) = −1`; 11 942 failing coprime
pairs below 200), so there is no Euler product:

```
D(2) = Σ_{n≤10⁶} f(n)/n² = −1.12681304      (tail ≤ 1.0·10⁻⁶)
naive multiplicative model = 0.88757352
|difference| = 2.01438655 > rigorous tail 1.84·10⁻⁵   (by ~10⁵)
```

## 3. The barrier, stated correctly (with the audit's corrections)

**Corrected statement.**  For a **sign-blind alphabet with no arithmetic input**, no
object of the greedy-sine programme supplies a positive-density coupling to `Ω`; and
`(★)`, the two-point Chowla statement, is **OPEN**.

Two corrections the audit forced, both now recorded:

1. **My "every greedy-sine object is an additive character in `log n`" was too wide
   and imprecise.**  `n^{−it}` is a *multiplicative* character on `(ℝ₊,×)`, and the
   budgets are *constants* in `p`, not characters.  The barrier must be read as
   *sign-blind alphabet, no arithmetic input* — because the audit exhibited a greedy
   object of the *same take rule* whose alphabet is arithmetic
   (`α_p = (−1)^{Ω(p+2)}/(p+2)`, `z = +10.1`) and which of course mixes: the signal
   lives in the **alphabet**, not in the greedy selection, and using it is circular.
2. **The impossibility is a heuristic and must stay OPEN.**  What is *proved* is the
   budget sign-blindness (strengthened by twist invariance) and the Euler-product
   failure; "the two do not mix" is not a theorem.

**A defect in rh46 that this round found:** the quoted sparse-modification bound
`|S_A(x) − S(x)| ≤ 2·#{n ≤ x+2 : n ∈ A}` is **false** (witness `A = {5}`, `x = 5`:
the two affected terms `n = 3` and `n = 5` each change `+1 → −1`, so `|ΔS| = 4 > 2`).
The correct bound is `2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`.  The
`o(x)` conclusion is unaffected, and rh46's stated product tail (`1.808988`) is also
mis-derived (it bounds the *retained* primes, not the omitted ones); the conclusion
survives on the correct tail `1.84·10⁻⁵`.

## 4. What the goal would need

A map from a rule that is **determined by the target alone** and **sign-blind** to
**positive-density multiplicative information about `Ω`** — and the greedy support is
Sylvester-sparse (density `3.9·10⁻⁵`), so the programme has no object that can even be
placed in the regime where such information could live.  By the corrected sparse
bound, the greedy support moves `S(x)` by `O(log log x) = o(x)`: it cannot be the
positive-density witness that `(★)` requires.

## 5. Open

* **R2** — prove (or refute) that no sign-blind deterministic rule seeing `n` only
  through `log n` can force a multiplicative correlation.  This is the round's real
  ambition; it is **OPEN**.
* **R4** — the Lean formalisation of the barriers (Brown, the parity lock,
  the corrected sparse bound, rh46's finite-prefix theorem).  **Partially done:**
  [`Rh47/Sparse.lean`](../../../twin-prime-parity/rounds/rh47/lean/Rh47/Sparse.lean) proves the corrected sparse bound
  `≤ 2·#{n ≤ x : n ∈ A ∨ n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`, its sharpness witness, and
  the falsity of the inherited `2·#{n ≤ x+2 : n ∈ A}` form (item OP-12); the inherited
  [`rh46/lean/Rh46/Chowla.lean`](../../../twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) layer **is certified**
  (530 lines, 42 theorems, 0 `sorry`, 0 `axiom`, `./check.sh --all` exit 0) and its last
  commented statement `corrSlice_sub_corr_self_eq` is now **proved** (item OP-11).
  Still open in the Lean layer: Brown's criterion/parity-lock port as a *rh47* module,
  and the negative statement R2.  *(Corrected: earlier revisions of this file called
  `lean/Rh47/` "empty" and said the inherited `rh46/lean` file "still does not
  compile"; both described the pre-certification state and are stale.)*
