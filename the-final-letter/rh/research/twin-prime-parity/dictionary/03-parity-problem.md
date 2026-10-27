# 03 — The parity problem, the Chowla correlation, and the literature status

Part of the **twin-prime parity programme** dictionary (workspace
`/Users/victor/workspace/rh`, rounds rh40–rh47).

See also: [`00-dictionary.md`](00-dictionary.md) (master index),
[`01-preliminaries.md`](01-preliminaries.md) (notation, `λ`, `μ`, `Λ`),
[`02-greedy-harmonic-sine.md`](02-greedy-harmonic-sine.md) (the greedy word and the
Tau alphabet), [`04-zeta-relations.md`](04-zeta-relations.md) (budgets, balance,
smoothing, explicit formula),
[`06-numerical-checks.md`](../checks/06-numerical-checks.md) (the register of
finite checks — and what each does **not** establish),
[`07-open-problems.md`](../open/07-open-problems.md) (the open-problems register).

Programme-internal sources for this file: `rh46/README.md` (the two-point Chowla
round), `rh46/chowla_two_point.py` + `rh46/lean/Rh46/Chowla.lean`,
`rh47/HANDOFF.md`, `rh47/truths.md` §1–§5, `rh42/truths.md` §2–§3 and §7.

> **Scope warning, stated first.** This file is a *reference*, not a result. It
> records what is a theorem, what is a heuristic, and what is open. Nothing here
> claims progress on the twin-prime conjecture or on the parity problem, and no
> numerical check of the programme is presented as a proof of an asymptotic
> statement. Every item carries one of the labels **THEOREM / HEURISTIC / OPEN /
> UNVERIFIED / NUMERICAL / REFUTED**; where a label is disputed in the literature or
> in the programme's own record, the dispute is written out.

---

## 0. This file's index tags

The master index ([`00-dictionary.md`](00-dictionary.md)) assigns this file the
analytic entries `A4`, `A5`, `A6` and the barrier entries `F1`–`F9`. They are located
as follows.

| id | term | where |
|---|---|---|
| `A3` | `λ`, `μ`, `Λ`, `Ω`, `ω` | [`01`](01-preliminaries.md) §1–§2; restated here §1.1 |
| `A4` | logarithmic two-point Chowla | §3.4, §4.1 (row T6) |
| `A5` | un-averaged two-point Chowla `Σ_{n≤x}λ(n)λ(n+2) = o(x)` | §3.3, §4.2 — **OPEN** |
| `A6` | the parity phenomenon of sieve weights | §2 — **THEOREM as a no-go / UNVERIFIED as a literal identity** |
| `F1`–`F5` | the rh46 facts (trivial bound, `λ ≡ 1`, non-multiplicativity, finite-prefix indeterminacy, corrected sparse bound) | §6 |
| `F6`–`F8` | the rh47 bridges B1–B3 | §5.3, §6 |
| `F9` | the corrected barrier (*sign-blind alphabet, no arithmetic input*) | §5.3, §7 — **HEURISTIC / OPEN** |

---

## 1. Definitions

### 1.1 The arithmetic functions

**Definition 1.1 (`Ω`, `ω`).** For `n ≥ 1`, `Ω(n)` is the number of prime factors of
`n` **with multiplicity** (`Ω(12) = Ω(2²·3) = 3`), and `ω(n)` is the number of
**distinct** prime factors (`ω(12) = 2`). Both are completely additive:
`Ω(mn) = Ω(m) + Ω(n)`, `ω(mn) = ω(m) + ω(n)` only for coprime `m, n`.
*Status:* DEFINITION.

**Definition 1.2 (Liouville).** `λ(n) = (−1)^{Ω(n)}` for `n ≥ 1`.
*Status:* DEFINITION.
**THEOREM (basic).** `λ` is **completely** multiplicative (`λ(mn) = λ(m)λ(n)` for all
`m, n ≥ 1`, with no coprimality restriction), `λ(n) ∈ {±1}`, `λ(n)² = 1`,
`λ(1) = 1`. Its Dirichlet series is
```
Σ_{n≥1} λ(n) n^{−s} = ζ(2s)/ζ(s)     (σ > 1) ,
```
equivalently `λ = 1_□ * μ`: `Σ_{d|n} λ(d) = 1` if `n` is a square and `0` otherwise.
*Source:* [`01`](01-preliminaries.md) §2, Lemmas 2.1–2.3; `rh46/lean/Rh46/Chowla.lean`
(`liouville_mul`, `liouville_sq`, `liouville_abs_le_one`).

> **Convention warning.** `λ(0)` is *not* defined by `(−1)^{Ω(0)}`. The rounds adopt
> `λ(0) = 1`, which destroys complete multiplicativity at `0`; the Lean file records
> this as `liouville_mul_zero_false`. All statements below use `n ≥ 1`.

**Definition 1.3 (Möbius).** `μ(n) = (−1)^{ω(n)}` if `n` is squarefree and `μ(n) = 0`
otherwise; `μ(1) = 1`. *Status:* DEFINITION.
**THEOREM (basic).** `μ` is multiplicative but **not** completely multiplicative;
`μ * 1 = ε` (the unit of Dirichlet convolution), i.e. `Σ_{d|n} μ(d) = [n = 1]`; and
`Σ_{n≥1} μ(n)n^{−s} = 1/ζ(s)`.

**Definition 1.4 (von Mangoldt).** `Λ(n) = log p` if `n = p^k` for a prime `p` and
`k ≥ 1`, and `Λ(n) = 0` otherwise. *Status:* DEFINITION.
**THEOREM (basic).** `Λ = μ * log`, i.e. `Λ(n) = Σ_{d|n} μ(d) log(n/d)`, and
`ψ(x) := Σ_{n≤x} Λ(n) = x + o(x)` **is** the prime number theorem (PNT).

**Definition 1.5 (parity classes).** Write
```
E = {n ≥ 1 : Ω(n) even} = {n : λ(n) = +1} ,      O = {n ≥ 1 : Ω(n) odd} = {n : λ(n) = −1} .
```
`E` and `O` are the **parity classes**; `λ = 1_E − 1_O` is their signed indicator.
Primes lie in `O`; squares and `p²` lie in `E`; `2^k` alternates.
*Status:* DEFINITION.

**THEOREM (Landau; the parity classes have equal density 1/2).** The one-point average
`Σ_{n≤x} λ(n) = o(x)`, hence `#{n ≤ x : n ∈ E} = x/2 + o(x)` and likewise for `O`.
This is *equivalent* to PNT (see §4.1, row T1). So the parity classes are **known** to
be balanced *on average* — this is not the parity problem.

### 1.2 Admissible tuples and the singular series

**Definition 1.6 (admissible `k`-tuple).** A tuple `h = (h_1, …, h_k)` of distinct
integers with `h_1 < … < h_k` is **admissible** if for every prime `p` the residues
`h_1, …, h_k mod p` do **not** cover all of `{0, …, p−1}`. Equivalently, with
`ν_p(h) = #{h_i mod p}` (the number of distinct residues), `ν_p(h) < p` for every `p`.
Equivalently again, the product below converges to a non-zero limit.
*Status:* DEFINITION. Example: `{0, 2}` is admissible (`ν_2 = 1`); `{0, h}` with `h`
odd is **not** (`ν_2 = 2 = p`), because one of `n, n+h` is always even.

**Definition 1.7 (singular series).** For an admissible `h`,
```
𝔖(h_1, …, h_k) = Π_p (1 − 1/p)^{−k} (1 − ν_p(h)/p) .
```
The product converges absolutely and `𝔖(h) > 0`; with this normalisation `𝔖(0) = 1`
(k = 1) and
```
𝔖(0, 2) = 2 Π_{p>2} (1 − 1/(p−1)²) = 1.3203236316… = 2C₂ ,
```
the twin-prime constant. *Status:* DEFINITION (the convergence and positivity are
THEOREM, classical).

**Conjecture 1.8 (Hardy–Littlewood / Dickson prime `k`-tuples).** For an admissible
`h`, `#{n ≤ x : n+h_1, …, n+h_k all prime} ~ 𝔖(h) x/(log x)^k`.
The case `h = (0,2)` is the **twin prime conjecture** in quantitative form:
`π₂(x) := #{p ≤ x : p+2 prime} ~ 2C₂ x/(log x)²`; in particular `π₂(x) → ∞`.
*Status:* **OPEN** for every `k ≥ 2` (for `k = 1` it *is* PNT, a theorem). The value
`𝔖(0,2) = 1.3203236316…` is *verified numerically* in the sense of the finite product
converging; the asymptotic itself is **HEURISTIC** (a conjecture, with no proof).

### 1.3 Sieves: dimension, weights, level of distribution

**Definition 1.9 (sieve problem and dimension).** Let `𝒜` be a finite set of integers,
`𝒫` a set of primes, `P(z) = Π_{p ≤ z, p ∈ 𝒫} p`, and `A_d = #{n ∈ 𝒜 : d | n}`.
Suppose that for a multiplicative `ω` with `0 ≤ ω(p) < p` and some `X`,
```
A_d = (ω(d)/d) X + R_d      for all squarefree d | P(z) .
```
The **dimension** (sifting density) `κ` of the sieve is defined by the asymptotic
`Σ_{p ≤ z} (ω(p) log p)/p = κ log z + O(1)`. For a `k`-tuple of **distinct linear
forms** (`n + h_1, …, n + h_k`) one has `ω(p) = ν_p(h)` and dimension `κ = k`.
*Status:* DEFINITION (the standard classification of sieve theory; see
Friedlander–Iwaniec, *Opera de cribro*, Ch. 6 and Ch. 16, and §4.1 row T10).

**Definition 1.10 (Brun / Selberg weights; level of distribution).** A **Brun weight**
is `w(n) = Σ_{d | (n, P(z))} μ(d) g(d)` with `g` a bounded multiplicative function; a
**Selberg weight** is `w(n) = (Σ_{d | (n, P(z)), d ≤ D} λ_d)² ≥ 0` for real `λ_d` with
`λ_1 = 1`. Both depend on `n` only through the *small-prime residues*
`n mod P(z)`, plus — for Selberg — a truncation at the **level of distribution**
`D = x^θ`. The truncation `d ≤ D` is what makes the weight non-periodic.
*Status:* DEFINITION.

**Definition 1.11 (bounded-depth sieve / parity-blind weight).** Call a weight
`w ≥ 0` **parity-blind** if it is a finite non-negative combination of expressions of
the form `1_{n ≡ a (mod q)}` with `q | P(z)` (i.e. `w` is periodic mod `P(z)`), or a
Selberg weight truncated at a level `D = x^θ`, `θ < 1`. A *rule* (as opposed to a
weight) is parity-blind if it is determined by the small-prime divisibility pattern of
`n` alone. This is the class to which the parity phenomenon applies (§2). The greedy
harmonic sine's take rule is parity-blind *and* arithmetic-free (rh47 §3).
*Status:* DEFINITION (programme's own vocabulary; see
[`07-open-problems.md`](../open/07-open-problems.md) OP-3, OP-18).

---

## 2. The parity phenomenon, stated exactly

This section is written to separate four different things that the phrase "the parity
problem" is used for in the programme's rounds: (i) a **no-go theorem for a method**,
(ii) a **literal identity** about sieve weights, (iii) the **Brun/Selberg asymmetry**
(upper bound yes, lower bound no), and (iv) a **heuristic expectation**. They have
different epistemic statuses and must not be blurred.

### 2.1 The no-go theorem (this part is a THEOREM)

**THEOREM 2.1 (Selberg's parity principle, as sharpened by Polymath8b).**
Consider the class of bounded-depth sieve weights of Definition 1.11. Then:
**(a)** the *only* arithmetic input a weight of this class can use is the collection of
local densities `A_d = (ω(d)/d)X + R_d` for squarefree `d | P(z)`, `d ≤ D`;
**(b)** there is a non-negative model sequence `b` — with the *same* local densities
`A_d` at every such `d`, and supported entirely on `O` (or entirely on a set of
`Ω`-parity opposite to the target) — for which the count of `h`-primes is zero;
**(c)** consequently no positive lower bound for `#{n ≤ x : n+h_1, …, n+h_k all prime}`
can be deduced from the class. In particular the sieve cannot certify primality for
*any* admissible tuple with `k ≥ 2`.
**(d) (explicit published instance.)** Polymath8b prove that, even under the
**generalised Elliott–Halberstam conjecture**, the best a purely sieve-theoretic
argument can reach for an admissible triple is
*"at least two of `n+h_1, n+h_2, n+h_3` are prime"*, and that this is **optimal** for
sieve-theoretic considerations.
*Status:* THEOREM. *Source:* [D. H. J. Polymath, *Variants of the Selberg sieve, and
bounded intervals containing many primes*, arXiv:1407.4897, Res. Math. Sci. **1**:12
(2014)](https://arxiv.org/abs/1407.4897) — abstract, verbatim: *"We modify the
'parity problem' argument of Selberg to show that this result is the best possible
that one can obtain from purely sieve-theoretic considerations."* The general
principle is also the subject of Ch. 16 ("the parity problem") of
[J. Friedlander, H. Iwaniec, *Opera de cribro*, AMS Colloq. Publ. **57** (2010)](https://www.ams.org/books/coll/057/coll057-endmatter.pdf).

*Reading.* 2.1 is a statement about a **method**, not about the integers. There is
**no theorem** saying that the twin prime conjecture is unprovable, or that `E` and `O`
cannot be separated by *some* argument. What is excluded is a specific, well-defined
class of arguments.

### 2.2 The literal identity `Σ w(n)λ(n) = o(Σ w(n))` — what is and is not proved

The programme's record (rh43 §8.5, quoted in
[`07-open-problems.md`](../open/07-open-problems.md) OP-2) states the parity problem as:

> no sieve weight `w` built from small-prime residue conditions can give
> `Σ w(n)λ(n) = o(Σ w(n))`.

Read as *"no such argument can derive it"*, this is exactly §2.1 and is a **THEOREM**
(class (i)). Read as a *literal identity for every non-negative bounded-depth weight*,
the status is different and must be recorded carefully.

**THEOREM 2.2 (the periodic case — the honest small-prime statement).** Let `w ≥ 0` be
periodic modulo `q` (so `w` depends only on `n mod q`), with `q ≤ (log x)^A` for a
fixed `A`, and suppose `Σ_{n≤x} w(n) ≫ x` (positive density). Then
```
Σ_{n≤x} w(n) λ(n) = o( Σ_{n≤x} w(n) )        as x → ∞ .
```
*Proof.* Write `Σ_{n≤x}w(n)λ(n) = Σ_{a mod q} w(a) Σ_{n≤x, n≡a (q)} λ(n)`, and expand
the inner sum over Dirichlet characters `χ mod q` using
`Σ_n λ(n)χ(n)n^{−s} = L(2s, χ²)/L(s, χ)` (a consequence of `λ = 1_□ * μ`, §1.1). For
`q ≤ (log x)^A` the Siegel–Walfisz theorem gives a zero-free region for `L(s, χ)`, and
the quotient is analytic and non-vanishing at `s = 1` (for `χ` principal the quotient
has a *zero* at `s = 1`; for `χ²` principal it is finite and non-zero). Wiener–Ikehara
/ Perron then gives `Σ_{n≤x, n≡a(q)} λ(n) = o(x/q)` uniformly. ∎
*Status:* THEOREM (classical; the programme uses the special cases `q = 2, 210` in
rh43 §8.5 and rh47 §2). This is the precise sense in which "small-prime residue
conditions cannot see the parity of `Ω`".

**UNVERIFIED 2.3 (the truncated case — the slogan cannot be taken literally).** The
extension of 2.2 to Selberg weights *truncated at a level* `D = x^θ` with `θ < 1` is
**not** derived by the argument of 2.2, because the truncation destroys periodicity.
Concretely, for `w(n) = (Σ_{d | (n,P(z)), d ≤ D} λ_d)²` one has the exact expansion
```
Σ_{n≤x} w(n) λ(n) = Σ_{d,e ≤ D} λ_d λ_e λ([d,e]) Σ_{m ≤ x/[d,e]} λ(m) ,
```
using complete multiplicativity of `λ` and `Σ_{n≤x, q|n} λ(n) = λ(q) Σ_{m≤x/q} λ(m)`.
Since `Σ_{m≤y} λ(m) = o(y)` is a *theorem* (PNT), one is tempted to conclude that the
right side is `o(x · Σ_{d,e ≤ D} |λ_d λ_e|/[d,e])`. But the object that must be
compared against is the *sieve's own* main term, whose size is
`x · Σ_{d,e≤D} λ_d λ_e/[d,e] ≈ x Π_{p≤z}(1 − 1/p) ≈ x e^{−γ}/log z`
(the Selberg weights are chosen to make this small), whereas the absolute-value sum
`Σ_{d,e≤D} |λ_d λ_e|/[d,e]` can be of size `≈ (log D)²` for admissible `λ_d`. So the
PNT input alone loses a factor `(log D)² log z`; genuine cancellation in
`Σ_{n≤x}w(n)λ(n)` is required, and that cancellation is **precisely of parity
difficulty**.
*Status:* **UNVERIFIED.** The literal identity is *not* a theorem of the standard
theory for truncated weights with `z → ∞`; the present file could not confirm it in
the literature, and it does not follow from PNT + Siegel–Walfisz alone. **Any use of
the slogan as a literal identity should be replaced by 2.1 (the no-go theorem) or by
2.2 (the small-prime theorem).** *Programme note:* `rh43/truths.md` §8.5 states the
slogan in the methodological reading; this file records the distinction so that the
slogan is not re-proposed as a literal identity.

**HEURISTIC 2.4 (why the slogan is nevertheless the right picture).** `λ` has mean
`0` in every complete residue system mod `q` and `λ` does not "pretend to be" a
Dirichlet character `n ↦ χ(n)n^{it}` in the sense of the structure theorems
(§4.1 rows T7–T8); this is the modern reason to expect
`Σ w(n)λ(n) = o(Σ w(n))` for the whole bounded-depth class.
*Status:* HEURISTIC (structurally compelling; not a proof). The corresponding
*theorem* is the logarithmic/almost-all structure theory of §4, which is strictly
weaker than the un-truncated statement.

### 2.3 The Brun/Selberg asymmetry: why the upper bound is available and the lower is not

**THEOREM 2.5 (Brun; the upper bound).** `π₂(x) ≪ x/(log x)²`. More generally for an
admissible `h = (h_1, …, h_k)`,
`#{n ≤ x : n+h_i prime for all i} ≪_h x/(log x)^k`.
*Status:* THEOREM (Brun 1919/1920; also Selberg's `Λ²` sieve). *Source:* classical;
bibliographic details are marked **unverified citation** in Appendix A (Br1).

*Why the upper bound is unaffected by parity.* An upper bound only needs a
non-negative majorant of the indicator of the primes; the parity phenomenon is a
statement about the **main term of the lower-bound problem**, i.e. about whether the
sifted count can be attributed to primes rather than to higher-`Ω` integers. Brun's
and Selberg's weights supply the majorant; the sieve main term
`X Π_{p≤z}(1 − ω(p)/p)` is an upper bound of the right order for `z = x^{1/k}`,
and the parity obstruction simply does not enter an inequality in that direction.

**THEOREM 2.6 (the lower bound stops at `P₂`: Chen).** There are infinitely many
primes `p` such that `p + 2` has at most **two** prime factors (`p+2 ∈ P₂`), and
quantitatively `#{p ≤ x : p+2 ∈ P₂} ≫ x/(log x)²`.
*Status:* THEOREM (Chen Jingrun 1973). *Source:* [J. R. Chen, *On the representation
of a larger even integer as the sum of a prime and the product of at most two primes*,
Sci. Sinica **16** (1973) 157–176](https://www.sciengine.com/doi/10.1360/ya1973-16-2-157)
(verified: title/journal/volume/pages).

**OPEN 2.7.** `π₂(x) ≫ x/(log x)²`, equivalently `π₂(x) → ∞`, equivalently the twin
prime conjecture. The gap between `P₂` (theorem, 2.6) and `P₁ = prime` (open) is
*exactly* the parity barrier: the sieve-with-an-extra-condition technique ("Chen's
switch") moves the obstruction up by one prime factor and no further. In general,
sieve methods give lower bounds for `P_r` for `r ≥ 2` and never for `r = 1`.
*Status:* **OPEN**.

**HEURISTIC 2.8 (the "switching" reading).** Chen's theorem works because the two
linear forms `n` and `n+2` can be given asymmetric roles: one is sieved to be prime
and the other is allowed an extra factor, and the resulting bilinear structure supplies
the missing parity input. Recorded here as **HEURISTIC** — the proof of 2.6 is a
theorem, but the sentence "the switch is what supplies the parity input" is an
interpretation, not a theorem.

---

## 3. The modern correlation form: Chowla's conjecture

### 3.1 The conjecture

**Conjecture 3.1 (Chowla, 1965; `k`-point form).** For any `k ≥ 1` and any distinct
non-negative integers `h_1, …, h_k`,
```
Σ_{n≤x} λ(n+h_1) λ(n+h_2) ⋯ λ(n+h_k) = o(x)      (x → ∞) .
```
Equivalently (see 3.4), for every sign pattern `ε ∈ {±1}^k`,
`#{n ≤ x : (λ(n+h_1), …, λ(n+h_k)) = ε} = x/2^k + o(x)`.
*Status:* **OPEN** for every `k ≥ 2`. The general `k = 1` case is PNT. The stronger
statement with **affine** forms `a_i n + b_i`, `a_i b_j ≠ a_j b_i` is the standard
formulation (verified in the abstracts of
[Tao, arXiv:1509.05422](https://arxiv.org/abs/1509.05422) and
[Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628)).

**HEURISTIC 3.2 (the random-sign model).** If `(λ(n))_n` were a sequence of
independent random signs, every correlation in 3.1 would be `O(x^{1/2+ε})` with
probability `1`, and 3.1 would follow. The model ignores complete multiplicativity
(which is what makes `λ` interesting) and is therefore **only** a heuristic; it does
*not* explain why the correlations should vanish, only why `o(x)` is the "expected"
size.
*Status:* HEURISTIC. *Programme note:* rh46's prefix-maximum fit
`α = 0.5200 ± 0.0249` is *consistent with* `O(x^{1/2+ε})` on a finite range and proves
nothing about the asymptotic — see [`06-numerical-checks.md`](../checks/06-numerical-checks.md).

### 3.2 The `k = 1` case: equivalent to PNT (a THEOREM)

**THEOREM 3.3.** `Σ_{n≤x} λ(n) = o(x)` **if and only if** PNT holds; since PNT is
proved, the one-point Chowla statement is a **theorem**.
*Source:* verified verbatim in
[Matomäki–Radziwiłł–Tao, arXiv:1509.01545](https://arxiv.org/abs/1509.01545) §1:
*"For `k = 1`, this claim is equivalent to the prime number theorem, but for `k > 1`
Chowla's conjecture remains open."* Also
[Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628) §1.
*Proof route.* `Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²)` with `M(y) = Σ_{n≤y}μ(n)` (from
`λ = 1_□ * μ`), and conversely `M(x) = Σ_{d≤√x} μ(d) L(x/d²)`; splitting the `d`-sum at
a large fixed `D` shows `Σ λ(n) = o(x) ⟺ M(x) = o(x)`, and `M(x) = o(x) ⟺` PNT
(classical, Landau).
*Record correction.* `rh46/README.md` §1.3 states that one-point Chowla *"is itself
OPEN"*. **That is an error**, repeated in `rh47/HANDOFF.md` §5.1 and `rh47/README.md`.
The register [`07-open-problems.md`](../open/07-open-problems.md) §0.1 and OP-2 already
corrects it; the correction is repeated here because this file is the dictionary
entry for the statement. The *obstruction* to the one-point case is methodological
(Selberg's parity principle, §2.1), not a lack of truth.

### 3.3 The two-point case: the target statement, and its exact equivalent form

**OPEN 3.4 (the target).** With
```
S(x) := Σ_{n≤x} λ(n) λ(n+2) ,        (★)   S(x) = o(x) .
```
*Status:* **OPEN.** This is the `k = 2`, `h = (0,2)` case of Chowla 3.1. It is the
statement rh46 was asked to establish; rh46 established that it is open, and no
progress on it is claimed here.

**THEOREM 3.5 (the exact equivalent form; a sharpening of the rounds' phrasing).**
`S(x) = o(x)` holds **iff** the pair `(λ(n), λ(n+2))` is asymptotically
**equidistributed** with each of the four sign patterns having density `1/4`. In
particular:
```
S(x) = 2·#{n ≤ x : λ(n) = λ(n+2)} − (x − 2)
```
so `S(x) = o(x)` is **equivalent** to `#{n ≤ x : λ(n) = λ(n+2)} = x/2 + o(x)`, and —
given the one-point theorem 3.3 — to each of the four densities being `1/4`.
*Proof.* For signs `u, v ∈ {±1}`, `1_{u=ε_1, v=ε_2} = (1 + ε_1 u)(1 + ε_2 v)/4`;
average over `n ≤ x` and use 3.3 for the two one-point averages. ∎
*Status:* THEOREM (elementary, given 3.3). **Machine-checked**: the module
[`lean/ConeLean/ChowlaEquiv.lean`](../../../lean/ConeLean/ChowlaEquiv.lean) proves both
identities verbatim — `chowlaSum_eq` for `S(N) = 2·#{n ≤ N−2 : λ(n) = λ(n+2)} − (N−2)`
and `patCount_mul_four` for the four-pattern decomposition
`4·#{λ(n)=ε₁, λ(n+2)=ε₂} = (N−2) + ε₁Σλ(n) + ε₂Σλ(n+2) + ε₁ε₂S(N)` — together with the
equivalence itself,
`chowlaSum_tendsto_iff_patCount_tendsto`, which is stated **conditionally on the two
one-point inputs** `Σ_{n≤x}λ(n) = o(x)` and `Σ_{n≤x}λ(n+2) = o(x)` (both consequences of
PNT, i.e. of 3.3).  The module proves nothing about `o(x)` itself: the open content is
3.4, exactly as before.
*Record correction — important.* `rh46/README.md` §3 writes that `o(x)` "is
*necessary* for a positive proportion of `n` to have `λ(n) = λ(n+2)`". Taken literally
that is **too weak to be true as stated**: the identity above shows that `o(x)` is
*incompatible* with the equal-class density being any fixed positive number other
than `1/2`. The correct assertion is the equivalence of 3.5. The programme's
conclusion for twin primes is *not* affected (see §5.1), but the dictionary records
the corrected form.

**THEOREM 3.6 (a non-trivial unconditional bound; the best elementary shape known to
the programme).** There is an absolute `δ > 0` with
```
Σ_{n≤x} λ(n) λ(n+1) ≪ (1 − δ) x .
```
*Status:* THEOREM. *Source:* [Matomäki–Radziwiłł, *Multiplicative functions in short
intervals*, arXiv:1501.04585](https://arxiv.org/abs/1501.04585), abstract, third
consequence: *"we show that the mean-value of `λ(n)λ(n+1)` … is non-trivially bounded
in absolute value by `1 − δ` for some `δ > 0`. This settles an old folklore conjecture
and constitutes progress towards Chowla's conjecture."* (Quantitative improvements
over 3.6 exist in the literature; this file cites only the form it verified.) Note
that 3.6 is *far* from `o(x)`: it gives no decay.

### 3.4 The logarithmic version, and what is a theorem there

**Definition 3.7 (logarithmic correlation).** For admissible data and a parameter
`ω = ω(x) → ∞` with `ω(x) ≤ x`, define the **logarithmically averaged** correlation
```
Σ_{x/ω < n ≤ x} λ(a_1 n + b_1) ⋯ λ(a_k n + b_k) / n  =  o( log ω )      (x → ∞) .
```
The case `ω(x) = x` gives the plain log-average over `[1,x]`.
*Status:* DEFINITION.

**THEOREM 3.8 (log-averaged two-point Chowla; Tao 2015/2016).** Definition 3.7 holds
for `k = 2` and every fixed affine pair with `a_1 b_2 − a_2 b_1 ≠ 0`. In particular
```
(1/log x) Σ_{n≤x} λ(n) λ(n+2)/n = o(1) .
```
*Status:* THEOREM. *Source:* [T. Tao, *The logarithmically averaged Chowla and Elliott
conjectures for two-point correlations*, arXiv:1509.05422](https://arxiv.org/abs/1509.05422)
(Forum of Mathematics, Pi; abstract: *"we establish the logarithmically averaged
version … thus breaking the 'parity barrier' for this problem"*). The method is the
**entropy decrement argument**, resting on
[Matomäki–Radziwiłł, arXiv:1501.04585](https://arxiv.org/abs/1501.04585) on short
intervals. *Note the phrase*: Tao's theorem breaks the parity barrier **for the
logarithmically averaged problem**, not for the un-averaged one.

**THEOREM 3.9 (log-averaged Chowla for odd orders and for `k = 2` — Tao–Teräväinen, Tao).** Definition 3.7 holds for every fixed **odd** `k` and every fixed admissible affine data (Tao–Teräväinen), and for `k = 2` (Tao, arXiv:1509.05422). For even `k ≥ 4` it is **open**.
*Status:* THEOREM. *Sources:* [Tao–Teräväinen, arXiv:1708.02610, Duke Math. J. **168**
(2019) 1977–2027](https://arxiv.org/abs/1708.02610) (structural theorem for
log-averaged correlations plus the **odd**-order cases of log-Chowla; also see
[arXiv:1710.02112, J. Théor. Nombres Bordeaux **30** (2018) 997–1015](https://arxiv.org/abs/1710.02112)
for the odd-order paper) and [Tao–Teräväinen, arXiv:1809.02518, Alg. Number Th. **13**
(2019) 2103–2150](https://arxiv.org/abs/1809.02518) (unweighted Chowla at almost all scales, for `k` odd or `k = 2`; it proves no log-averaged statement).

**THEOREM 3.10 (log-Chowla ⟺ log-Sarnak).** The logarithmically averaged Chowla
conjecture (all `k`) and the logarithmically averaged Sarnak conjecture are
**logically equivalent**, and both are equivalent to the "local Gowers uniformity" of
`λ`. Also, the **un-averaged** Chowla conjecture implies the Sarnak conjecture.
*Status:* THEOREM. *Source:* [T. Tao, *Equivalence of the logarithmically averaged
Chowla and Sarnak conjectures*, arXiv:1605.04628](https://arxiv.org/abs/1605.04628),
abstract: *"Our main result is that these latter two conjectures are logically
equivalent to each other, as well as to the 'local Gowers uniformity' of the Liouville
function"*, and *"As is well known, this conjecture implies the conjecture of
Sarnak"*.

### 3.5 Almost-all shifts and almost-all scales

**THEOREM 3.11 (Chowla for almost all shifts — Matomäki–Radziwiłł–Tao "MRTT").** For
fixed `k` and `H = H(x) ≤ x` with `H(x) → ∞`,
```
Σ_{h_1,…,h_k ≤ H} | Σ_{n≤x} λ(n+h_1) ⋯ λ(n+h_k) | = o(H^k x) .
```
In particular the two-point correlation `Σ_{n≤x} λ(n)λ(n+h)` is `o(x)` for **almost
every** shift `h ≤ H(x)`, for any `H(x) → ∞`. The same paper gives
`∫_0^X |Σ_{x≤n≤x+H} λ(n) e(αn)| dx = o(HX)` uniformly in `α`.
*Status:* THEOREM. *Source:* [K. Matomäki, M. Radziwiłł, T. Tao, *An averaged form of
Chowla's conjecture*, arXiv:1503.05121, Algebra Number Theory **9** (2015)
2167–2196](https://arxiv.org/abs/1503.05121) (abstract verified verbatim).
*This is the "MRTT almost-all-shifts result".* It says **nothing** about the single
shift `h = 2`: an average over `H` shifts can vanish while every individual shift
contributes a non-vanishing amount, and the statement is *about the average*.

**THEOREM 3.12 (Chowla for almost all scales / exceptional shifts — Tao–Teräväinen).**
The `k`-point un-averaged Chowla statement
`E_{n≤X} λ(n+h_1)⋯λ(n+h_k) = o(1)` holds for **`k` odd or `k = 2`**, for all scales
`X` outside a set of **zero logarithmic density**; and (separately) the logarithmic
correlations of bounded multiplicative functions vanish at **almost all scales**
`X`, with an explicit structure theorem: they vanish unless `g_1⋯g_k` weakly pretends
to be a twisted Dirichlet character `n ↦ χ(n)n^{it}`.
*Status:* THEOREM. *Source:* [Tao–Teräväinen, arXiv:1809.02518, Alg. Number Th. **13**
(2019) 2103–2150](https://arxiv.org/abs/1809.02518) (abstract verified verbatim,
including the sentence *"we establish the `k`-point Chowla conjecture
`E_{n≤X} λ(n+h_1)⋯λ(n+h_k) = o(1)` for `k` odd or equal to `2` for all scales `X`
outside of a set of zero logarithmic density"*).
*Reading.* This is an **almost-all-scales** statement, not an almost-all-shifts one,
and it does not give the statement at a **prescribed** scale `X`. It therefore does
not give `S(x) = o(x)` for the given `x`.

**THEOREM 3.13 (the structure theorem for correlations; the modern "why").** For
`1`-bounded multiplicative `g_0, …, g_k`, the correlation sequence
`a ↦ lim (1/log ω_m) Σ_{x_m/ω_m ≤ n ≤ x_m} g_0(n+ah_0)⋯g_k(n+ah_k)/n` is a uniform
limit of periodic sequences; if `g_0⋯g_k` does **not** weakly pretend to be a Dirichlet
character, it vanishes identically and the periodic approximants are `χ`-isotypic
otherwise.
*Status:* THEOREM. *Source:* [Tao–Teräväinen, arXiv:1708.02610](https://arxiv.org/abs/1708.02610)
(abstract verified verbatim); almost-all-scales version in
[arXiv:1809.02518](https://arxiv.org/abs/1809.02518).
*Why this matters for `λ`.* `λ` weakly pretends to be nothing (its Dirichlet series
`ζ(2s)/ζ(s)` has no `L`-function pole structure of the pretentious type at `s = 1`),
which is the structural reason the *log-averaged* correlations vanish. The same
structure theorem is what is **not** available for the un-averaged sum.

---

## 4. The literature status, with citations

### 4.1 What is proved

| id | statement | status | citation | verification of the citation |
|---|---|---|---|---|
| **T1** | `Σ_{n≤x}λ(n) = o(x) ⟺` PNT | THEOREM | classical (Landau); stated in [1509.01545](https://arxiv.org/abs/1509.01545) §1, [1605.04628](https://arxiv.org/abs/1605.04628) §1 | **verified** (abstracts read verbatim) |
| **T2** | log-averaged two-point Chowla `(1/log x)Σ_{n≤x}λ(n)λ(n+2)/n = o(1)` | THEOREM | [Tao, arXiv:1509.05422](https://arxiv.org/abs/1509.05422), Forum Math. Pi (2016) | **verified** (arXiv abs: title, author, 2015 submission, v4 29 Jul 2016, abstract including the "parity barrier" claim); *venue from the arXiv comment field; volume/article number not independently confirmed* |
| **T3** | log-Chowla ⟺ log-Sarnak ⟺ local Gowers uniformity; Chowla ⟹ Sarnak | THEOREM | [Tao, arXiv:1605.04628](https://arxiv.org/abs/1605.04628) | **verified** (arXiv abs: title, author, 16 May 2016, abstract) |
| **T4** | averaged Chowla: `Σ_{h_1,…,h_k≤H}\|Σ_{n≤x}λ(n+h_1)⋯λ(n+h_k)\| = o(H^k x)` (almost all shifts) | THEOREM | [Matomäki–Radziwiłł–Tao, arXiv:1503.05121](https://arxiv.org/abs/1503.05121), Algebra Number Theory **9** (2015) 2167–2196 | **verified** (arXiv API: title, authors, journal ref, abstract) |
| **T5** | `Σ_{n≤x}λ(n)λ(n+1) ≪ (1−δ)x` for some `δ > 0`; `μ` cancels in almost all short intervals `[x, x+ψ(x)]`, `ψ → ∞` | THEOREM | [Matomäki–Radziwiłł, arXiv:1501.04585](https://arxiv.org/abs/1501.04585) | **verified** (arXiv API: title, authors, abstract) |
| **T6** | log-averaged Chowla for **all** `k`; structural theorem for log correlations | THEOREM | [Tao–Teräväinen, arXiv:1708.02610](https://arxiv.org/abs/1708.02610), Duke Math. J. **168** (2019) 1977–2027; odd-order case [arXiv:1710.02112](https://arxiv.org/abs/1710.02112), J. Théor. Nombres Bordeaux **30** (2018) 997–1015 | **verified** (arXiv API: titles, authors, journal refs, abstracts) |
| **T7** | un-averaged `k`-point Chowla for `k` odd or `k = 2`, for all scales outside a set of zero logarithmic density; structure at almost all scales | THEOREM | [Tao–Teräväinen, arXiv:1809.02518](https://arxiv.org/abs/1809.02518), Alg. Number Th. **13** (2019) 2103–2150 | **verified** (arXiv abs: title, authors, journal ref, abstract verbatim) |
| **T8** | `H_1 = liminf(p_{n+1}−p_n) ≤ 246`; `≤ 6` under the generalised Elliott–Halberstam conjecture; "at least two of three" is optimal for purely sieve-theoretic considerations | THEOREM | [D. H. J. Polymath, arXiv:1407.4897](https://arxiv.org/abs/1407.4897), Res. Math. Sci. **1**:12 (2014) | **verified** (arXiv API: title, journal ref, full abstract) |
| **T9** | `liminf_n (p_{n+m}−p_n) < ∞` for every `m`; `H_1 ≤ 600`; `≤ 12` under Elliott–Halberstam; prime `k`-tuples conjecture for a positive proportion of admissible `k`-tuples | THEOREM | [J. Maynard, arXiv:1311.4600](https://arxiv.org/abs/1311.4600), Ann. of Math. (2015) | **verified** (arXiv abs: title, author, v1 19 Nov 2013, abstract); *journal volume/pages not independently confirmed* |
| **T10** | `liminf (p_{n+1}−p_n)/log p_n = 0`; `H_1 ≤ 16` under Elliott–Halberstam | THEOREM | [Goldston–Pintz–Yıldırım, arXiv:math/0508185](https://arxiv.org/abs/math/0508185), *Primes in Tuples I* | **verified** (arXiv abs: title, authors, 10 Aug 2005, abstract); *journal volume/pages not independently confirmed* |
| **T11** | `H_1 ≤ 7·10⁷` | THEOREM | Y. Zhang, *Bounded gaps between primes*, Ann. of Math. **179** (2014), no. 3 | **verified** (Annals of Mathematics article page `annals.math.princeton.edu/2014/179-3/p07`); no arXiv version |
| **T12** | infinitely many primes `p` with `p+2 ∈ P₂` | THEOREM | J. R. Chen, Sci. Sinica **16** (1973) 157–176 | **verified** (publisher DOI page + independent bibliographic record) |
| **T13** | `π₂(x) ≪ x/(log x)²` (upper bound only) | THEOREM | V. Brun (1919/1920) | **unverified citation** (see Appendix A, Br1) |
| **T14** | infinitely many primes of the form `x²+y⁴` — a **parity-breaking** asymptotic-sieve theorem | THEOREM | [Friedlander–Iwaniec, *The polynomial `X²+Y⁴` captures its primes*, Ann. of Math. **148** (1998) 945–1040](http://www.emis.mi.sanu.ac.rs/emis/journals/Annals/148_3/4.html) | **verified** (journal listing: title, authors, volume, pages, 1998; MSC keywords include *"parity; bilinear form hypothesis; asymptotic sieve"*) |
| **T15** | the asymptotic sieve: a bilinear (Type-II) hypothesis yields asymptotic formulae for primes in a sieve | THEOREM | [Friedlander–Iwaniec, *Asymptotic sieve for primes*, arXiv:math/9811186](https://arxiv.org/abs/math/9811186), Ann. of Math. (2) **148** (1998) 1041–1065 | **verified** (arXiv API: title, journal ref) |
| **T16** | equidistribution of primes in arithmetic progressions to large moduli (a Type-II input) | THEOREM | E. Bombieri, J. Friedlander, H. Iwaniec, *Primes in arithmetic progressions to large moduli*, Acta Math. **156** (1986) | **partially verified** (title/journal/year via the Rutgers publication record; **volume/pages not independently confirmed**) |
| **T17** | Selberg's parity principle (the no-go statement of §2.1) | THEOREM | A. Selberg (1950); Friedlander–Iwaniec, *Opera de cribro*, Ch. 16; explicit use in [arXiv:1407.4897](https://arxiv.org/abs/1407.4897) | **verified via the modern use** (Polymath8b abstract, verbatim) and via the [AMS *Opera de cribro* endmatter](https://www.ams.org/books/coll/057/coll057-endmatter.pdf) (*"Chapter 16 … the parity problem"*); the **original 1950 attribution is unverified** (Appendix A, Se1) |
| **T18** | the greedy support is **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1`, so `A(N) = O(log log N)` | THEOREM (+ NUMERICAL) | programme-internal: `rh47/truths.md` §1, [`02`](02-greedy-harmonic-sine.md) Thm 4.1 | **verified internally** (prose proof + 0 violations in 53 159 consecutive pairs) |

### 4.2 What is open — stated prominently

**OPEN 4.1 (the central statement).**
```
Σ_{n≤x} λ(n) λ(n+2) = o(x)      is OPEN.
```
No proof is known, unconditionally or conditionally on RH in the elementary
Dirichlet-series sense. It is **not** implied by any averaged statement in the
literature (§4.3), and it is **not** decided by any finite computation
(§6, `F4`).

**OPEN 4.2.** The full `k`-point Chowla conjecture for every `k ≥ 2`; the twin-prime
conjecture (Conjecture 1.8 with `h = (0,2)`); Sarnak's Möbius-disjointness conjecture;
the Elliott conjecture for general bounded multiplicative functions in the
un-averaged form.

**OPEN 4.3 (a genuinely open "intermediate" statement, for calibration).** It is not
known whether `Σ_{n≤x} λ(n)λ(n+2) = O(x/(log x)^A)` for any `A > 0`; the only
unconditional decay-free bound of this shape known to the programme is 3.6
(`≪ (1−δ)x`).

### 4.3 Log-averaged results do **not** imply the un-averaged statement

**THEOREM 4.4 (no such implication is available).** The implication
"log-averaged two-point Chowla ⟹ un-averaged two-point Chowla" is **not** known, and
cannot be a theorem of the current literature: the hypothesis is a theorem (T2, T6)
while the conclusion is open (4.1). Any proof of the implication would immediately
prove 4.1.
*Status:* THEOREM about the state of knowledge (an immediate consequence of T2 + 4.1).

**HEURISTIC 4.5 (why log-averaging is genuinely weaker).** The logarithmic average
weights `n ≤ x` by `1/n`, and is therefore dominated by the top of the range
`[1, x]`; a bound on it constrains the *renormalised* partial sums
`Σ_{n≤y}λ(n)λ(n+h)` only along a set of scales `y` of full logarithmic density, and
gives no bound at a **prescribed** `y`, hence no bound on `S(y)/y` for any fixed `y`.
There is no known Tauberian device that recovers an unweighted Cesàro mean from a
`1/n`-weighted mean for a sequence such as `n ↦ λ(n)λ(n+h)` (which is neither
non-negative nor monotone nor multiplicative).
*Status:* HEURISTIC (a structural explanation; the rigorous content is 4.4).

**THEOREM 4.6 (the almost-all statements are also insufficient).** T4 (almost all
*shifts*) and T7 (almost all *scales*, outside a set of zero logarithmic density) are
averaged statements. Neither yields `S(x) = o(x)` at the single shift `h = 2` and the
prescribed scale `x`. In T4 the average over `H` shifts can vanish while individual
shifts do not; in T7 the exceptional set of scales is not excluded at a prescribed
scale.
*Status:* THEOREM (immediate from the quantifier structure of T4 and T7), and stated
explicitly because the rounds' phrasing of "almost all shifts" invites the opposite
reading.

**UNVERIFIED 4.7 (a recent frontier development; preprint, single author, not
peer-reviewed).** [J. Guo,
*Logarithmic Chowla correlations across all shift scales*, arXiv:2608.23500v4
(Aug/Sep 2026)](https://arxiv.org/abs/2608.23500) proves a *fixed power-logarithmic*
bound for the **log-weighted** two-point correlation across the full shift range:
there is `c > 0` and, for every sufficiently large `x`, a set `ℰ_x` with
`|ℰ_x ∩ [1,H]| ≪_A H (log x)^{−A}` for every fixed `A > 0` and every `1 ≤ H ≤ x`, such
that `max_{1≤h≤x, h∉ℰ_x} sup_{1≤y≤x} |Σ_{n≤y} λ(n)λ(n+h)/n| ≪ (log x)^{1−c}`; plus a
GRH-conditional bound uniform in `h` with no exceptional shifts.
*Status:* **UNVERIFIED citation** in the sense required by this file: the arXiv
abstract page was read (title, author, submission dates, abstract) but the paper is a
2026 preprint that is **not peer-reviewed** and was **not** independently checked by
this file. Crucially, **it is a logarithmic statement with an exceptional set of
shifts**; it does **not** give `Σ_{n≤x}λ(n)λ(n+2) = o(x)`, and OPEN 4.1 is
unaffected. Recorded here only so that the dictionary's "logarithmic" column is not
read as frozen at 2019.

---

## 5. What a twin-prime lower bound would need

### 5.1 The relation between `S(x) = o(x)` and the twin-prime problem

**THEOREM 5.1 (the exact relation; no implication in either direction is known).**
**(a)** By 3.5, `S(x) = o(x)` is *equivalent* to the equal-class density of
`{n : λ(n) = λ(n+2)}` being `1/2`, and (given PNT) to each of the four pairs
`(λ(n), λ(n+2))` having density `1/4`. It is therefore **incompatible** with the
equal-class density being any other fixed positive number; equivalently it is
*necessary and sufficient* for equidistribution of the pair.
**(b)** `S(x) = o(x)` does **not** imply the twin prime conjecture: `λ` says nothing
about primality, and under the Hardy–Littlewood heuristic the twin primes have
density `~ 2C₂/log²x = o(1)` inside the class `{λ(n) = λ(n+2) = −1}`, which itself has
density `1/4`.
**(c)** The twin prime conjecture does **not** imply `S(x) = o(x)`: it constrains only
the primes, and the parity of `Ω(n)` on the composites — which dominates `S(x)` — is
untouched.
*Status of (a):* THEOREM. *Status of (b), (c):* the *non-implications* are **not**
theorems in the literature — they are statements about absence of a known proof,
labelled **OPEN** as formal questions, with the heuristic reading marked **HEURISTIC**.
*(Programme correction.* `rh46/README.md` §2 asserts that "Chowla for `k`-point
correlations … contradicts the twin prime conjecture's failure mode and implies the
Sarnak conjecture". The Sarnak half is a THEOREM (T3). The "contradicts the twin prime
conjecture's failure mode" half is **withdrawn as unverified** — it is already so
marked in [`07-open-problems.md`](../open/07-open-problems.md) OP-4, and this file
confirms the withdrawal.)*
**(d)** The two-point Chowla statement `S(x) = o(x)` is a **special case of the
programme's target** and is itself OPEN (4.1); it is a *prerequisite-shaped*
statement, not a route to twin primes.

### 5.2 Why breaking parity needs an input beyond bounded-depth sieves

**THEOREM 5.2 (what is excluded).** By §2.1, no argument in the class of
bounded-depth sieves (Definition 1.11) can produce a positive lower bound for the
number of `n` with `n+h_1, …, n+h_k` prime, for any `k ≥ 2`. In particular, no pure
sieve argument can prove `π₂(x) → ∞`, and — the sharpest published form — even under
the generalised Elliott–Halberstam conjecture a sieve cannot improve on "at least two
of any three admissible forms are prime" (T8).
*Status:* THEOREM.

**THEOREM 5.3 (what is *not* excluded).** Nothing in the literature states that the
twin prime conjecture is unprovable, or that the parity classes are inseparable by
*every* method. The parity phenomenon is a limitation of a **method class**.
*Status:* THEOREM (trivially: no such impossibility theorem is known; the statement is
recorded to prevent the parity phenomenon from being over-read as an impossibility
result).

**HEURISTIC 5.4 (the shape of the missing input).** Three kinds of input are known to
be able to cross a parity barrier, none of them currently available for the twin
primes:
1. **Type-II / bilinear (Friedlander–Iwaniec asymptotic sieve, T15).** A hypothesis of
   the form "the sequence has a bilinear decomposition whose cross-terms are
   equidistributed" can yield an *asymptotic formula* (not merely an upper bound) for
   primes in a sieve. Prototype, and the classical demonstration that parity *can* be
   broken: T14 (`X² + Y⁴` captures its primes), where the factorisation
   `x² + y⁴ = (x + iy²)(x − iy²)` in `ℤ[i]` supplies exactly the bilinear structure.
2. **Equidistribution to large moduli (Bombieri–Friedlander–Iwaniec, T16).** Supplies
   the Type-II information at moduli beyond `x^{1/2}`, and is the engine behind 1.
3. **Automorphic / spectral input.** The `X²+Y⁴` proof uses Hecke `L`-functions and a
   spectral (harmonic-analysis) input on the lattice; equivalently, it uses the
   arithmetic of a number field in which the polynomial *factors*. This is the sense in
   which the phrase "automorphic input" is used in the rounds' summaries.
For the twin primes the two linear forms `n` and `n+2` are *linear* and admit no such
factorisation, and their Type-II data is exactly what the parity obstruction denies.
*Status:* HEURISTIC (the three routes are theorems *in their own problems*; the claim
that some input of this kind is *necessary* for twin primes is not a theorem and is
marked HEURISTIC).

### 5.3 The GPY / FH / Maynard landscape — the current frontier, and its ceiling

| year | result | how it is limited by parity |
|---|---|---|
| 2005 | **GPY** (T10): `liminf (p_{n+1}−p_n)/log p_n = 0`; `H_1 ≤ 16` under EH | produces *a* bounded gap, not two specified primes in a fixed tuple |
| 2013 | **Zhang** (T11): `H_1 ≤ 7·10⁷` | same; uses BFI-type equidistribution (T16) beyond `x^{1/2}` in a restricted form |
| 2014 | **Polymath8** / **Maynard** (T9): `H_1 ≤ 600`, `H_m < ∞` for every `m` | detects "at least one prime among many forms", never a specified pair |
| 2014 | **Polymath8b** (T8): `H_1 ≤ 246`; `≤ 6` under GEH | **and the ceiling**: "at least two of three" is *optimal* for purely sieve-theoretic reasoning |
| 2015 | **Banks–Freiberg–Turnage-Butterbaugh**: consecutive primes in tuples, arXiv:1311.7003 | same parity ceiling (arXiv id verified via the arXiv API; journal data `Acta Arith.` per the DOI record — *volume/pages not independently confirmed*) |

**Reading.** The GPY/FH/Maynard technology is the best available use of *bounded-depth
sieve* information; its ceiling is documented by T8. The frontier results do **not**
touch the parity problem for a *fixed* admissible tuple, and none of them implies, or
is implied by, `S(x) = o(x)`.

### 5.4 The programme's own bridges, and why none of them supplies the missing input

The programme tested three candidate bridges from the greedy harmonic sine to the
parity of `Ω` (`rh47/truths.md` §2, `rh47/HANDOFF.md` §2); all three fail **as
routes**, and the failure is a theorem-level fact in two of the three cases:

| bridge | claim | status | evidence |
|---|---|---|---|
| **B1** (`F6`) | the greedy **support** carries `λ`-parity signal | REFUTED (no signal) | nominal `z = −47.9` on 8 820 targets, killed by positional sign-permutation (`z = +0.43`, `p = 0.66`) and rank-matched (`z = +1.55`, `p = 0.12`) controls; the nominal signal was an artefact of repeated positions (`m = 2` in 70.5 % of supports). The take rule reads the target alone — no arithmetic input. |
| **B2** (`F7`) | the ζ budgets `P(p) = 2^{−p}ζ(p)`, `N(p) = (1−2^{−p})ζ(p) − 1` carry `Ω`-parity information | REFUTED | the budgets are sign-blind combinations of `ζ(p)` (`P+N = ζ−1`, `P−N = 1−η`) and separate **index** parity, not `Ω`-parity; measured independence `χ²(1) = 2.944` (`z = 0.99`) at `N = 10⁷`; decisive strengthening: index parity is **invisible to the correlation itself**, `Σ λ(n)(−1)^n·λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)` exactly (0/10⁶ mismatches) — by Theorem 5.5 below. |
| **B3** (`F8`) | the `ζ`-machinery applies to the correlation `f(n) = λ(n)λ(n+2)` | REFUTED | `f` is **not multiplicative** (`f(1) = −1 ≠ 1`; `f(2)f(11) = −1 ≠ f(22) = 1`; 11 942 failing coprime pairs below 200), so there is **no Euler product**: `D(2) = Σ_{n≤10⁶} f(n)/n² = −1.12681304` (tail `≤ 1.0·10⁻⁶`) against the naive multiplicative model `0.88757352`, discrepancy `2.01438655 > 1.84·10⁻⁵`. |
| **F9** | the corrected barrier: **no sign-blind alphabet with no arithmetic input** can supply a positive-density multiplicative coupling to `Ω` | HEURISTIC / **OPEN** | `rh47/truths.md` §3; the audit forced two corrections: the phrase "additive character in `log n`" is too wide (`n^{−it}` *is* multiplicative on `(ℝ₊,×)`, and the budgets are constants in `p`), and the audit's `C3a` exhibits a greedy object with an **arithmetic** alphabet (`α_p = (−1)^{Ω(p+2)}/(p+2)`, `z = +10.1`) whose signal lives in the alphabet and is **circular**. The impossibility claim is therefore **not** a theorem. |

**THEOREM 5.5 (the twist-invariance identity, `F7`; why index parity is irrelevant).**
For every `x`,
```
Σ_{n≤x} λ(n)(−1)^n · λ(n+2)(−1)^{n+2} = Σ_{n≤x} λ(n) λ(n+2) ,
```
because `(−1)^n (−1)^{n+2} = 1`. Hence multiplying `λ` by the index-parity character
leaves the two-point correlation **identically** unchanged: knowledge of index parity
would say nothing about `S(x)`.
*Status:* THEOREM (elementary); VERIFIED numerically (0 mismatches in `10⁶` terms),
`rh47/truths.md` §2 (B2).

---

## 6. Barriers and pitfalls (the barrier table)

| id | barrier / pitfall | exact statement | status | source |
|---|---|---|---|---|
| **F1** | the trivial bound | `\|S(x,h)\| ≤ x` for every `h, x`; `S(x,0) = x` | THEOREM (Lean: `corr_abs_le`, `corr_zero`) | rh46 `Rh46/Chowla.lean` |
| **F2** | the "`λ ≡ 1`" triviality — **`o(x)` is not formal** | the completely multiplicative, bounded function `λ ≡ 1` has correlation exactly `x`; so `o(x)` is **not** a consequence of complete multiplicativity plus boundedness — it is a genuine arithmetic statement about `λ` | THEOREM (Lean: `corrAsymptotic_zero_false`) | rh46 §1.1 |
| **F3** | no Euler product | `n ↦ λ(n)λ(n+2)` is **not multiplicative**, so the associated Dirichlet series has no Euler product and the `ζ`/Perron route does not apply; Lean carries a concrete non-multiplicativity witness | THEOREM (Lean) + NUMERICAL (discrepancy `2.0144` vs tail `1.84·10⁻⁵`) | rh46 §1.5; rh47 §2 (B3) |
| **F4** | **finite-prefix indeterminacy** | define `λ''` to agree with `λ` on all of `[1, 10⁸]` and to equal `1` beyond. Then `S''(x) = S(x)` **exactly for every `x ≤ 10⁸ − 2`** (0 of 99 999 998 prefixes differ), yet `S''(x)/x → 1`. So the entire computed dataset is equally consistent with `S(x) = o(x)` and with `S(x) = Θ(x)`. **A finite check can refute, never prove.** More generally, flipping a single index `a` leaves every prefix shorter than `a` untouched (`λ^{(a)}` vs `λ`) | THEOREM (Lean slice layer: `slice_agree`, `corrSlice_eq_corr_of_lt`) + NUMERICAL (auditor A1, all `10⁸` prefixes) | rh46 §1.4 |
| **F5** | the **corrected** sparse-modification bound | for a modification set `A ⊆ ℕ` (flip the sign of `λ` at every `a ∈ A`), `\|S_A(x) − S(x)\| ≤ 2·#{n ≤ x : n ∈ A or n+2 ∈ A} ≤ 4·#{m ≤ x+2 : m ∈ A}`. `rh46`'s quoted `≤ 2·#{n ≤ x+2 : n ∈ A}` is **false** (witness `A = {5}`, `x = 5`: the affected terms `n = 3, 5` each change `+1 → −1`, so `\|ΔS\| = 4 > 2`). Consequence: a **sparse** modification moves `S(x)` by `o(x)` only; a witness against `o(x)` needs **positive density** | **THEOREM, machine-checked** ([`../rounds/rh47/lean/Rh47/Sparse.lean`](../rounds/rh47/lean/Rh47/Sparse.lean): `corrSparse_sub_corr_abs_le`, `corrSparse_sub_corr_abs_le_four`, `rh46_sparse_bound_false`, `corrSparse_bound_sharp`; item OP-12) | rh47 `truths.md` §3 |
| **F6** | no signal in the greedy support | see §5.4 (B1) | REFUTED (numerically, with controls) | rh47 §2 |
| **F7** | index parity ≠ `Ω` parity; index parity invisible to the correlation | §5.4 (B2) + Theorem 5.5 | REFUTED + THEOREM (5.5) | rh47 §2; rh42 §2 |
| **F8** | no Euler product (same content as F3, stated as a bridge) | §5.4 (B3) | REFUTED | rh47 §2 |
| **F9** | the corrected barrier | *sign-blind alphabet with no arithmetic input* cannot supply a positive-density multiplicative coupling to `Ω`; and `S(x) = o(x)` is OPEN | HEURISTIC / **OPEN** | rh47 `truths.md` §3 |

**Corollary 6.1 (why the greedy support is quantitatively useless here).** By T18 the
greedy support satisfies `m_{i+1} ≥ m_i(m_i−1)+1`, hence
`#{m ≤ x+2 : m ∈ A} = O(log log x)`. By F5 the support therefore moves `S(x)` by at
most `4·O(log log x) = O(log log x) = o(x)`. The greedy support **cannot** be the
positive-density witness that F5 shows is necessary.
*Status:* THEOREM (combining T18 and F5); *source:* `rh47/HANDOFF.md` §3 (H4),
`rh47/truths.md` §4.

**Remark 6.2 (the parity lock is a rigidity, not a bridge).** The signed greedy
support of [`02`](02-greedy-harmonic-sine.md) Theorem 2.3 is *parity-locked*: all gaps
are even and `≥ 2`. This is a genuine proved structural fact, but it constrains the
*word*, and the involution `n ↦ n/2` that relates it to the classical Egyptian greedy
is an index map; it says nothing about `Ω`. In particular the parity of the support's
*indices* is not the parity of `Ω(n)` (F7).
*Status:* THEOREM (parity lock) + HEURISTIC (the "says nothing about `Ω`" reading, which
is F9).

---

## 7. Ledger of this file's own statements

| # | statement | label |
|---|---|---|
| 1.1–1.7 | definitions (`Ω`, `λ`, `μ`, `Λ`, parity classes, admissible tuple, singular series, sieve dimension/weights, parity-blind weight) | DEFINITION |
| 1.1 (basic) | complete multiplicativity of `λ`; `ζ(2s)/ζ(s)`; `λ = 1_□ * μ` | THEOREM |
| 1.5 | `Σ_{n≤x}λ(n) = o(x)`; the parity classes have equal density `1/2` | THEOREM |
| 1.8 | Hardy–Littlewood `k`-tuples, incl. twin primes | **OPEN** (HEURISTIC as a prediction) |
| 2.1 | Selberg's parity principle / Polymath8b no-go, incl. "at least two of three" optimal under GEH | THEOREM |
| 2.2 | `Σ w(n)λ(n) = o(Σ w(n))` for `w ≥ 0` periodic mod `q`, `q ≤ (log x)^A` | THEOREM |
| 2.3 | the literal slogan for **truncated** weights (`D = x^θ`, `θ < 1`) | **UNVERIFIED** |
| 2.4 | the slogan as the right picture | HEURISTIC |
| 2.5 | `π₂(x) ≪ x/(log x)²` | THEOREM (citation unverified, Br1) |
| 2.6 | infinitely many `p` with `p+2 ∈ P₂` | THEOREM (Chen) |
| 2.7 | `π₂(x) ≫ x/(log x)²` | **OPEN** |
| 2.8 | "Chen's switch supplies the parity input" | HEURISTIC |
| 3.1 | Chowla's conjecture | **OPEN** for `k ≥ 2` |
| 3.2 | random-sign model | HEURISTIC |
| 3.3 | `Σ_{n≤x}λ(n) = o(x) ⟺` PNT; `k=1` Chowla is a **theorem** (corrects rh46 §1.3) | THEOREM |
| 3.4 | `S(x) = Σ_{n≤x}λ(n)λ(n+2) = o(x)` | **OPEN** |
| 3.5 | `S(x) = o(x) ⟺` equal-class density `1/2`; `⟺` four densities `1/4` (corrects rh46 §3's "positive proportion") | THEOREM |
| 3.6 | `Σ_{n≤x}λ(n)λ(n+1) ≪ (1−δ)x` | THEOREM |
| 3.7–3.9 | log-averaged Chowla, two-point and all-order | THEOREM |
| 3.10 | log-Chowla ⟺ log-Sarnak; Chowla ⟹ Sarnak | THEOREM |
| 3.11 | averaged Chowla / almost all **shifts** (MRTT) | THEOREM |
| 3.12 | un-averaged `k`-point Chowla for `k` odd or `k=2` at almost all **scales** | THEOREM |
| 3.13 | structure theorem for correlations (pretentiousness dichotomy) | THEOREM |
| 4.1 | `Σ_{n≤x}λ(n)λ(n+2) = o(x)` | **OPEN** |
| 4.3 | no `O(x/(log x)^A)` bound known | **OPEN** |
| 4.4–4.6 | log-averaged / almost-all results do not imply the un-averaged statement | THEOREM (meta) + HEURISTIC 4.5 |
| 4.7 | arXiv:2608.23500 (log-weighted, exceptional shifts, preprint) | **UNVERIFIED** (arXiv page read; not peer-reviewed) |
| 5.1(a) | the exact relation of `S(x) = o(x)` to equidistribution | THEOREM |
| 5.1(b),(c) | no implication between `S(x) = o(x)` and twin primes | **OPEN** (HEURISTIC as expectation) |
| 5.2 | no bounded-depth sieve gives a lower bound for a `k ≥ 2` tuple | THEOREM |
| 5.3 | no impossibility theorem for twin primes exists | THEOREM |
| 5.4 | Type-II / BFI / automorphic input as the missing ingredient | HEURISTIC |
| 5.5 | twist invariance: index parity is invisible to `S(x)` | THEOREM |
| 6 (F1–F5) | trivial bound; `λ ≡ 1`; no Euler product; finite-prefix indeterminacy; corrected sparse bound `≤ 4·#{m ≤ x+2 : m ∈ A}` | THEOREM (+ NUMERICAL) |
| 6 (F6–F8) | bridges B1, B2, B3 fail | REFUTED |
| 6 (F9) | the corrected barrier | HEURISTIC / **OPEN** |
| 6.1 | the greedy support moves `S(x)` by `O(log log x)` | THEOREM |

**What this file does not claim.** No progress on the twin prime conjecture; no
progress on the parity problem; no proof of `S(x) = o(x)`; no asymptotic conclusion
from any finite computation; no resolution of F9. The programme's numerical
reconnaissance (`S(10⁸)/10⁸ = 4.4·10⁻⁵`, prefix-max exponent fit
`α = 0.5200 ± 0.0249`, logarithmic-average decay tables) is **NUMERICAL** evidence
only — by F4 it can never decide `o(x)`, and by 4.4 it cannot be upgraded by any
averaged theorem. See [`06-numerical-checks.md`](../checks/06-numerical-checks.md) for
what each check does and does not establish.

---

## Appendix A — External references, with verification status

The **status** column records exactly what this file checked. "Verified" always means
the *title, authors and year* were read from the source named in the fourth column;
where a journal volume/page is given and not confirmed, that is said explicitly.

| key | full citation | status | what was checked / where |
|---|---|---|---|
| Ta1 | T. Tao, *The logarithmically averaged Chowla and Elliott conjectures for two-point correlations*, arXiv:1509.05422; Forum of Mathematics, Pi (2016) | **verified** | [arXiv:1509.05422](https://arxiv.org/abs/1509.05422) — title, author, v1 17 Sep 2015, v4 29 Jul 2016, abstract (incl. the "parity barrier" sentence); venue from the arXiv comment field. *Volume/article number not confirmed.* |
| Ta2 | T. Tao, *Equivalence of the logarithmically averaged Chowla and Sarnak conjectures*, arXiv:1605.04628 | **verified** | [arXiv:1605.04628](https://arxiv.org/abs/1605.04628) — title, author, 16 May 2016, abstract. Journal reference: the arXiv comment field names the Tichy Festschrift; *not independently confirmed.* |
| Ta3 | T. Tao, *The Erdős discrepancy problem*, arXiv:1509.05363 (2015) | **verified (id/title/date only)** | arXiv API query for the title (v6, 17 Sep 2015). Cited only as the "subsequent paper" mentioned in Ta1's abstract; not used for any statement here. |
| TT1 | T. Tao, J. Teräväinen, *The structure of logarithmically averaged correlations of multiplicative functions, with applications to the Chowla and Elliott conjectures*, arXiv:1708.02610; Duke Math. J. **168** (2019) 1977–2027 | **verified** | [arXiv:1708.02610](https://arxiv.org/abs/1708.02610) — title, authors, dates, abstract, journal ref. |
| TT2 | T. Tao, J. Teräväinen, *Odd order cases of the logarithmically averaged Chowla conjecture*, arXiv:1710.02112; J. Théor. Nombres Bordeaux **30** (2018) 997–1015 | **verified** | arXiv API by title — id, title, date, journal ref. |
| TT3 | T. Tao, J. Teräväinen, *The structure of correlations of multiplicative functions at almost all scales, with applications to the Chowla and Elliott conjectures*, arXiv:1809.02518; Alg. Number Th. **13** (2019) 2103–2150 | **verified** | [arXiv:1809.02518](https://arxiv.org/abs/1809.02518) — title, authors, dates, abstract verbatim, journal ref. |
| MRT1 | K. Matomäki, M. Radziwiłł, T. Tao, *An averaged form of Chowla's conjecture*, arXiv:1503.05121; Algebra Number Theory **9** (2015) 2167–2196 | **verified** | [arXiv:1503.05121](https://arxiv.org/abs/1503.05121) — title, authors, dates, abstract verbatim, journal ref. **This is the "MRTT almost-all-shifts result".** |
| MRT2 | K. Matomäki, M. Radziwiłł, T. Tao, *Sign patterns of the Liouville and Möbius functions*, arXiv:1509.01545, Forum Math. Sigma **4** (2016) | **verified (arXiv)** | [arXiv:1509.01545](https://arxiv.org/abs/1509.01545) + full text at ar5iv — title, authors, dates, abstract, and the sentence "For `k = 1`, this claim is equivalent to the prime number theorem". *Forum Math. Sigma venue/volume not independently confirmed.* |
| MR1 | K. Matomäki, M. Radziwiłł, *Multiplicative functions in short intervals*, arXiv:1501.04585; Ann. of Math. **183** (2016) 1015–1056 | **verified (arXiv)** | arXiv API — title, authors, abstract verbatim (including the `λ(n)λ(n+1)` result quoted as T5). *Annals volume/pages not independently confirmed.* |
| P8b | D. H. J. Polymath, *Variants of the Selberg sieve, and bounded intervals containing many primes*, arXiv:1407.4897; Res. Math. Sci. **1**:12 (2014) | **verified** | arXiv API — title, journal ref, and the **full abstract**, including `H_1 ≤ 246`, `≤ 6` under GEH, and the parity-optimality sentence. |
| May | J. Maynard, *Small gaps between primes*, arXiv:1311.4600; Ann. of Math. **181** (2015) 383–413 | **verified (arXiv)** | [arXiv:1311.4600](https://arxiv.org/abs/1311.4600) — title, author, dates, abstract (`H_1 ≤ 600`, `≤ 12` under EH, `H_m < ∞`). *Annals volume/pages not independently confirmed.* |
| GPY | D. A. Goldston, J. Pintz, C. Y. Yıldırım, *Primes in Tuples I*, arXiv:math/0508185; Ann. of Math. **170** (2009) 819–862 | **verified (arXiv)** | [arXiv:math/0508185](https://arxiv.org/abs/math/0508185) — title, authors, 10 Aug 2005, abstract. *Annals volume/pages not independently confirmed.* |
| Zha | Y. Zhang, *Bounded gaps between primes*, Ann. of Math. **179** (2014), no. 3, 1121–1174 | **verified (journal page)** | Annals article page `annals.math.princeton.edu/2014/179-3/p07`. No arXiv version exists to check. |
| BFT | W. D. Banks, T. Freiberg, C. L. Turnage-Butterbaugh, *Consecutive primes in tuples*, arXiv:1311.7003; Acta Arith. | **verified (arXiv id/title/date); journal volume/pages UNVERIFIED** | arXiv API — id, title, 27 Nov 2013, DOI `10.4064/aa167-3-4`. |
| Che | J. R. Chen, *On the representation of a larger even integer as the sum of a prime and the product of at most two primes*, Sci. Sinica **16** (1973) 157–176 | **verified** | Publisher record `sciengine.com/doi/10.1360/ya1973-16-2-157` (live page; the `cdn.` hostname and the doi.org route both 404) (title, journal, volume, pages) plus an independent bibliographic record. |
| FI1 | J. Friedlander, H. Iwaniec, *The polynomial `X²+Y⁴` captures its primes*, Ann. of Math. **148** (1998) 945–1040 | **verified** | EMIS journal listing (title, authors, volume, pages, year; MSC keywords include "parity; bilinear form hypothesis; asymptotic sieve"). |
| FI2 | J. Friedlander, H. Iwaniec, *Asymptotic sieve for primes*, arXiv:math/9811186; Ann. of Math. (2) **148** (1998) 1041–1065 | **verified** | arXiv API — id, title, journal ref. |
| FI3 | J. Friedlander, H. Iwaniec, *Opera de cribro*, AMS Colloquium Publications **57** (2010), Chapter 16 ("the parity problem") | **verified (chapter attribution)** | [AMS endmatter PDF](https://www.ams.org/books/coll/057/coll057-endmatter.pdf) — the sentence "In the next Chapter 16 we switch from practical aspects to a question of great theoretical importance, the parity problem of the …". |
| BFI | E. Bombieri, J. Friedlander, H. Iwaniec, *Primes in arithmetic progressions to large moduli*, Acta Math. **156** (1986) 203–251 | **partially verified** | Title/journal/year via a university publication record; **volume and page range not independently confirmed**. |
| Br1 | V. Brun, *La série `1/5 + 1/7 + 1/11 + 1/13 + …` est convergente ou finie*, Bull. Sci. Math. **43** (1919) 100–104, 124–128 | **UNVERIFIED CITATION** | This file could not verify the bibliographic details. The *mathematical content* (`π₂(x) ≪ x/(log x)²`, i.e. Theorem 2.5) is standard and is treated as a theorem. |
| Se1 | A. Selberg, *The general sieve method and its place in prime number theory*, Proc. Int. Congr. Math. 1950, vol. 1, 286–292 | **UNVERIFIED CITATION** | This file could not verify the bibliographic details (commonly cited form given). The parity principle itself is verified **through its modern use** in P8b and FI3 (row T17). |
| Gu1 | J. Guo, *Logarithmic Chowla correlations across all shift scales*, arXiv:2608.23500v4 (2026) | **UNVERIFIED (preprint, not peer-reviewed)** | [arXiv:2608.23500](https://arxiv.org/abs/2608.23500) — title, author, v1 24 Aug 2026, v4 1 Sep 2026, abstract verbatim. Not independently checked; used only in §4.7 with the explicit warning that it does **not** give OPEN 4.1. |

## Appendix B — Programme-internal sources

| source | used for |
|---|---|
| `rh46/README.md` | the target `(★)`; trivial bound; `λ ≡ 1`; finite-prefix indeterminacy; log-average checks; non-multiplicativity; §3's twin-prime paragraph (corrected here in 3.5 and 5.1) |
| `rh46/lean/Rh46/Chowla.lean` | `corr_abs_le`, `corr_zero`, `liouville_mul`, `liouville_sq`, `liouville_abs_le_one`, `corrAsymptotic_zero_false`, `slice_agree`, `corrSlice_eq_corr_of_lt` (456 lines, 38 theorems, `./check.sh --all` exit 0, no `sorry`/`axiom`/`native_decide`) |
| `rh46/chowla_two_point.py`, `rh46/verify/independent_check.py` | the numerics of §6 (F1, F4) and the `10⁸`-prefix construction |
| `rh47/HANDOFF.md` §2–§3, §5 | bridges B1–B3; the barrier; H1–H4; the "do not re-propose" list |
| `rh47/truths.md` §1–§5 | Sylvester-sparsity (T18); the corrected sparse bound (F5); the two audit corrections to the barrier (F9) |
| `rh42/truths.md` §2–§3, §7 | budgets `P(p)`, `N(p)`; Brown's criterion; the parity lock; the completeness threshold `p* = 1.7286472389981836…` |
| `rh43/truths.md` §8.5 | the programme's original statement of the parity problem (the slogan) — read here through the correction of §2.2 |
| [`07-open-problems.md`](../open/07-open-problems.md) §0.1, A.2 | the record corrections carried into this file: one-point Chowla is a theorem (OP-2); the sparse-bound error (OP-12); the barrier downgrade (OP-3/OP-18) |

## Appendix C — Reproduction of the finite checks referred to here

```
cd /Users/victor/workspace/rh
python3 rh46/chowla_two_point.py          # 30/30 checks, sieve to 10^9
python3 rh46/verify/independent_check.py  # the auditor's independent recomputation
python3 rh47/greedy_parity_probe.py       # 23/23 checks (bridges B1-B3)
python3 rh47/verify/independent_check.py  # 31/31 checks (the audit of the barrier claim)
cd rh46/lean && ./check.sh --all          # the certified Lean layer
cd lean && ./check.sh ConeLean/Cone.lean ConeLean/PairThreshold.lean \
    ConeLean/PairCensus.lean ConeLean/ChowlaEquiv.lean ConeLean.lean   # the cone layer
```
None of these outputs is a proof of an asymptotic statement; F4 is the theorem that
says so.

---

*Status legend — **THEOREM**: proved (Lean where noted); **NUMERICAL**: finite
computation only, never a proof of an asymptotic; **HEURISTIC**: plausible but
unproved; **OPEN**: no proof known; **UNVERIFIED**: asserted or cited here but not
confirmed to the standard this dictionary requires; **REFUTED**: with a witness.*
