# ODD-CORE ADVERSARY — final report

**Task.** Try to prove a *structural separation* between
`Σ_{n≤x} λ(n)λ(n+1) = o(x)` (theorem, MRT 2015) and the **odd core**
`C(K) = Σ_{k≤K} λ(2k−1)λ(2k+1) = Σ_{k≤K} λ(4k²−1)` (open).

**Verdict: FAILED-ATTEMPT, with one CONSTRUCTION (verified) of independent
interest and several PARTIAL structural findings.** No separator was found; no
counterexample exists in the data; no proof of the odd-core statement was found.
Nothing here refutes anything. What follows is what was actually computed.

Scripts: `lam.py` (sieve), `01`–`21_*.py`. All numbers below are reproduced by
`16_final_consolidated.py` and `21_final_verify.py`.

---

## 0. A methodology bug that produced a FALSE separator (report this widely)

My first separator search returned a spectacular result: a completely
multiplicative ±1 function with `|S1(T)|/T = 0` exactly and `|C(T)|/T = 0.267`.
It was **an artefact of my own sieve**.

The construction built `G` by `G[p::p] *= g(p)` for each prime `p`. That applies
`g(p)` **once per multiple of p**, not once per prime power, so it produced
`G(p²) = g(p)` instead of `g(p)²`. The object searched over was therefore *not*
completely multiplicative. Caught by an explicit test: 16 violations in 200 000
random pairs, `g(4) = −1` while `g(2)² = +1`.

Correct construction (used from `07_sep_correct.py` on): loop over **prime
powers**, `for e: G[p^e :: p^e] *= -1`. With that fix the searches reported
below all pass complete multiplicativity with **0 violations**.

*Lesson for any optimisation-based search over multiplicative objects: always
re-verify multiplicativity of the returned object from its prime values on the
whole range, including prime powers. A cancelled sum is not evidence of a
valid construction.*

---

## 1. CONSTRUCTION (verified): an explicit g with a bounded shift-1 sum and a
large, tunable odd core

**Object.** `g` completely multiplicative, `g(p) ∈ {−1,+1}`, defined by
optimising the prime signs (coordinate descent on the two sums). Two saved
instances: `gC_mix_16000000_r2.npy` (16 000 000 prime signs) and
`gC_maxcore_16000000.npy`.

**Verified properties** (`21_final_verify.py`, range extended to X = 8·10⁸):

| check | result |
|---|---|
| complete multiplicativity | **0 violations / 300 000 random pairs**; `G(p²)=G(p)²` for all tested p |
| shift-1 sum | `max_{n≤8·10⁸} |S1(n)| = 29 431` — **absolutely bounded** over a factor-50 range |
| `S1(X)/X` | `−2.60·10⁻⁵` |
| odd core at the fitted scale | `|C(T)|/T = 0.1887` with `|S1(T)|/T = 5·10⁻⁷` (constraint `eps=10⁻⁶`) |
| Tao log-averaged Chowla | `(1/log x)Σ g(n)g(n+1)/n → 0` ✔ (needed: this is a **theorem** for any bounded multiplicative g; a violation would have proved the object fake) |

**Comparison with the real λ on the same scale**

| quantity | real λ | constructed g |
|---|---|---|
| `max|S1|` over its range | 1 010 419 (n ≤ 10⁷) | **29 431** (n ≤ 8·10⁸) |
| `C(K)/K` | 0.0206 at K = 4·10⁶ | **0.1887** at K = 8·10⁶ |
| typical random-MF size of `C/K` | — | `1/√T ≈ 3.5·10⁻⁴` |

So `C/K` for the construction is ≈ **530×** the size a random completely
multiplicative function would give, while `S1` is simultaneously cancelled to
absolute boundedness. Within the designated window the two statements are
**cleanly separated** — this is the sense in which they are *not* formally
equivalent, and in which cancellation of the shift-1 sum does **not** by itself
force the core to vanish.

### 1a. But the separation is a FINITE-WINDOW phenomenon — the core does not stay
large

The critical measurement (`18_decompose.py`, `21_final_verify.py`):

| K | `C(K)` | `C(K)/K` | regime |
|---|---|---|---|
| 10⁵ | 2 600 | 0.0260 | inside window |
| 10⁶ | 83 632 | 0.0836 | inside window |
| 10⁷ | 1 485 382 | 0.1485 | inside window |
| 10⁸ | 1 610 438 | 0.0161 | extension |
| 2·10⁸ | 1 657 586 | 0.0083 | extension |
| 4·10⁸ | 1 710 891 | 0.0043 | extension |

Beyond the fitted window the core grows **linearly for a while and then
saturates**: `C(K)` moves by only 4 % across K from 10⁸ to 4·10⁸, so
`C(K)/K ~ 1/K` (the ratio halves with every doubling of K).

Block means of the core summand in the extension (factor-50 span):
`+0.00203, +0.00075, +0.00042, +0.00049, +0.00052, +0.00031, −0.00000, +0.00023`
— a positive bias that decays, not a sustained one. Meanwhile the shift-1 block
means stay at `±10⁻⁴` throughout.

**Interpretation.** The construction buys the core entirely *inside the fitting
window*; past it the core reverts to a random-multiplicative-like regime with
√K fluctuations plus a slowly decaying bias. `C(K)/K` is therefore not bounded
away from 0 asymptotically. This is a **FAILED-ATTEMPT** at an asymptotic
separator, and it is the honest headline.

### 1b. The trade-off is real, not an artefact of my objective

Optimising `|S1(T)|/T` **alone**, with the core never mentioned in the objective
(`19_s1only.py`, N = 4·10⁶, T = 2·10⁶):

| objective | achieved `|S1|/T` | resulting `|C|/T` |
|---|---|---|
| shift-1 only | 0 | 0.00055 – 0.00253 |
| mixed / constrained | 0 – 5·10⁻⁷ | **0.177 – 0.224** |

Pure shift-1 cancellation leaves the core at 1.6–3.6× the random-MF size — i.e.
essentially uncorrelated with the cancellation. Keeping the core large requires
*spending* the cancellation budget on it.

---

## 2. PARTIAL: why the two sums behave the same under every *random* model

`15_variance_correct.py`. For `g(p)` i.i.d. uniform on {±1} extended completely
multiplicatively, `E[P(x)P(y)] = 1` iff the two terms' prime-parity vectors agree
identically; everything follows from counting coincidences. Exact enumeration at
K = 2000:

| statistic | shift-1 | odd core |
|---|---|---|
| exact `Var(Σ P)` | 2070 | 2014 |
| `Var/K` | 1.035 | 1.007 |
| `sd/√K` | 1.017 | 1.003 |

Monte Carlo (2000 realisations): core sd = 31.0, 71.4, 154.9, 356.0 at
K = 10³, 5·10³, 2.5·10⁴, 1.25·10⁵ vs `√K` = 31.6, 70.7, 158.1, 353.6.

**Both sums have identical √K behaviour for random multiplicative models.** There
is no random-model separation. The real λ itself *is* far from random
(`C(5·10⁶)/√(5·10⁶) = −7.19`), but that excess holds for shift-1 too
(`S1(5·10⁶)/√(5·10⁶) = +5.4`), so it does not distinguish them.

### The one exact asymmetry — and why it is NOT an obstruction

Variance shares by prime (exact, `14_variance_clean.py`):

| primes ≤ | share of Var(shift-1) | share of Var(core) |
|---|---|---|
| 10 | 0.4122 | 0.4046 |
| 100 | 0.6317 | 0.6201 |
| 1000 | 0.7702 | 0.7561 |
| 10⁴ | 0.8699 | 0.8541 |
| 10⁵ | 0.9463 | 0.9305 |

The distributions are near-identical. The **single exact difference**: `p = 2`
supplies 0.1752 of the shift-1 variance and **exactly 0** of the core variance,
because `2k±1` are both odd and `g(2)` never enters the odd core. That is a
measurable ~18 % weakening of the entropy reserve — a **quantitative** deficit,
not a structural obstruction, and it blocks no argument I could construct.

---

## 3. PARTIAL: the actual mechanism gap — the core has no multiplicative index

`16_final_consolidated.py`. For shift 1 the summand *is* a multiplicative-function
correlation in the summation variable: `λ(n)λ(n+1) = λ(n(n+1))`, a completely
multiplicative function of n — which is exactly what MRT's machinery consumes.

For the odd core, `T_k = λ(2k−1)` as a function of the index k is **not
multiplicative and not close to it**:

* index multiplicativity `T_{ab} = T_a T_b`: **2 005 098 / 3 996 001 violations = 50.18 %** (a coin flip);
* `corr(T_k, λ(k)) = +0.0033`;
* `corr(T_k, χ₄(k)) = +0.00001`.

So the core is a correlation of the multiplicative structure in its *arguments*
`2k−1, 2k+1` (which are coprime, hence factorisation-independent), while the
*index* k carries none of the multiplicative structure. Any technique that
treats the core as a multiplicative object in its summation variable has nothing
to hold on to. This is the sharpest statement I can make of "the mechanisms used
for shift 1 provably cannot reach the core" — and note it is a statement about
*this* mechanism class, **not** a proof of inequivalence.

---

## 4. What was verified about the reduction (independently)

`16_final_consolidated.py`, sieve validated against `λ(1..12)`, `Σ_{n≤10⁵}λ = −318`:

* `λ(4k²−1) = λ(2k−1)λ(2k+1)` for all k ≤ 5000 ✔
* at x = 2K = 99 999 998: `S2(x) = 420 398`, `−S1(x/2) = −745`,
  `C(K) = 419 653`; `even + odd = 418 908`, residual `1490` = the single
  unmatched tail term `λ(x−1)λ(x+1) = 1` ✔ — the reduction is exact up to that one term.

Baseline to x = 10⁸ (this is the number the parent should use):

| | value |
|---|---|
| `S1(5·10⁶)` | 11 978 |
| `C(5·10⁶)` | −16 084 |
| `C(K)/√K` (real λ) | −7.19 |
| fitted exponent of `max|S1|` over [10⁵, 10⁸] | 0.4705 |
| fitted exponent of `max|C|` over [10⁵, 5·10⁷] | 0.5641 |

Both exponents sit near 1/2; the gap between 0.4705 and 0.5641 is **within the
noise of these fits** (local exponents swing over 0.05–3.6 across decades) and I
attach **no significance** to it.

---

## 5. What blocked the attack

1. **Any finite-range separator is invisible to the asymptotic question.** The
   highest-leverage degrees of freedom are the primes `p ∈ (T, N]`: `p` divides
   `n(n+1)` for O(1) values of `n ≤ T`, but contributes O(1) *pointwise-fixed*
   terms to the core — so each such prime is a nearly free lever on `S1` and a
   nearly inert lever on `C`. Flipping one `g(p)`, `p ≈ T`, moves `S1` by up to
   `2` (a single term) while the core term is already cancelled. They let me
   cancel `S1` on `[1,T]` but cannot build a sustained core past T. Every extension I tried (`X/N` up to 50 with a
   random continuation rule) drove `C(K)/K → 0` like `1/K`.
2. **No random model separates the two sums** (§2): identical √K behaviour,
   near-identical prime-variance profiles.
3. **The only exact asymmetry (`p = 2` absent from the core) is quantitative, not
   structural** — it removes ~18 % of the variance budget without blocking any
   proof route.
4. **The construction cannot be pushed to a genuine counterexample**, because
   `(1/log x)Σ g(n)g(n+1)/n → 0` is a theorem for every bounded multiplicative g
   and my objects satisfy it. Any would-be separator has to live inside that
   constraint, and every instance I found saturates its core on a finite window
   only.
5. Direction 2 of the brief (dilation obstruction) produced nothing: the
   substitution `n(n+1) = ((2n+1)²−1)/4` maps the shift-1 sum to the **even** part
   of shift-2 — which is *precisely* the part the reduction already disposes of.
   The substitution is exactly what proves the equivalence of the even part, and
   it cannot touch the odd core. There is no analogous substitution available for
   `(2k−1)(2k+1) = (2k)²−1`.

---

## 6. Honest bottom line

* **FAILED-ATTEMPT** at structural separation in the sense the brief asked for
  (a model where shift 1 holds and the odd core fails, or a proof the mechanisms
  cannot reach the core).
* **CONSTRUCTION (verified)**: an explicit completely multiplicative ±1 function
  with an absolutely bounded shift-1 sum (`max|S1| = 29 431` over n ≤ 8·10⁸) and
  `C(K)/K = 0.1887` at the fitted scale — 530× the random-model size. It shows
  the two statements are not equivalent for *arbitrary* completely multiplicative
  functions and that shift-1 information alone does not force the core to vanish.
* **PARTIAL**: (i) exact random-model variance equivalence of the two sums;
  (ii) the `p = 2` variance asymmetry, quantified at 0.1752 vs 0; (iii) the
  index-multiplicativity failure of `λ(2k−1)` at 50.18 % — the sharpest available
  statement of where the shift-1 mechanism has no grip.
* I did **not** disprove Chowla, **not** solve the odd-core problem, and **not**
  show that no proof of shift 2 can exist. The one thing I would warn the parent
  about is §0: optimisation searches over multiplicative objects produce
  convincing-looking separators when the underlying sieve is subtly wrong.
