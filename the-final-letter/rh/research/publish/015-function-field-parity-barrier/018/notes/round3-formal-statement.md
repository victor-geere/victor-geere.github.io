# Round 3 — the 2-D Chebotarev / 1-D zeros separation, as a formal statement

This note turns the informal claim of rounds 1–2

> the zeta (and its zeros) encodes **linear** statistics only; the twin-qrime
> count is a **bilinear** statistic, supplied by 2-D Chebotarev, not by the zeros

into a precise statement with named hypotheses. It separates three things that
were previously mixed together:

| | statement | status |
|---|---|---|
| **§1–2** | the zeta is *exactly* the degree-count sequence `Z` (Euler product + Möbius) | **proved** (and in Lean) |
| **§3** | no **uniform** `Φ` with `B(S) = Φ(Z(S))` over admissible worlds | **proved** (finite witness; Lean + Python) |
| **§4** | `B` is instead governed by 2-D Chebotarev, `T(n) ~ S(q) qⁿ/n²` | **cited** (Pollack; not reproved) |
| **§5** | for `ℙ¹` the zero multiset is empty, yet `B > 0` | **proved** (elementary) |

Nothing here proves or refutes the twin prime conjecture or the parity barrier
over `ℚ`.

---

## 0. Setting

Fix a prime power `q` with `q` odd (so that `2 ≠ 0` and `f ↦ f + 2` is not the
identity). Let `M_q` be the set of monic polynomials over `𝔽_q`, and
`Irr_q ⊆ M_q` the monic irreducibles (**qrimes**).

**Definition 0.1 (world).** A *world* is a subset `S ⊆ M_q`, together with its
degree function. A world is *admissible* if `S ⊆ Irr_q` (every member really is
a qrime). The *true world* is `S = Irr_q`.

The point of quantifying over all worlds, rather than only over `Irr_q`, is that
the zeta is a function of the world only through its degree counts (§1); the
separation theorem must therefore be a statement about all worlds that share a
degree-count sequence.

**Definition 0.2 (zeta of a world).** For a world `S` with `Z_S(d) := #{f ∈ S :
deg f = d}` finite for all `d`, put

```
ζ_S(T) := ∏_{d ≥ 1} (1 − T^d)^{−Z_S(d)}   ∈ ℂ[[T]] .
```

For `S = Irr_q` this is `ζ_{𝔸¹}(T) = 1/(1 − qT)`, the zeta of `𝔽_q[x]`; for
`ℙ¹` one multiplies by the point at infinity, `ζ_{ℙ¹}(T) = 1/((1−T)(1−qT))`.

**Definition 0.3 (zeta datum).** The *zeta datum* of `S` is the sequence

```
Z(S) : ℕ → ℕ ,     Z(S)(n) := #{f ∈ S : deg f = n} .
```

For the true world, `Z(Irr_q)(n) = I(n)`, the qrime count.

**Definition 0.4 (twin / pair statistic).** The *twin count* of a finite world
`S` is

```
B(S) := #{f ∈ S : f + 2 ∈ S}        (directed count) ,
```

and its degree-`n` part is `B_n(S) := #{f ∈ S : deg f = n, f + 2 ∈ S}`. For the
true world `B_n(Irr_q) = T(n)`, the number of degree-`n` `f` with `f` and `f+2`
both irreducible.

`Z` is **linear** data (a sum of one-point indicators); `B` is **bilinear** data
(a sum of products of two one-point indicators at the related pair `(f, f+2)`).

---

## 1. The zeta sees exactly the degree counts

**Lemma 1.1 (Euler–Möbius).** *For every world `S` with finite `Z(S)`,*

```
log ζ_S(T) = Σ_{n ≥ 1} ( 1/n · Σ_{d|n} d · Z(S)(d) ) T^n .
```

*Consequently `ζ_S` and `Z(S)` determine each other, and `ζ_S = ζ_{S'}` iff
`Z(S) = Z(S')`.*

*Proof.* Expand each factor:
`−log(1−T^d) = Σ_{k≥1} T^{dk}/k`. Summing over `f ∈ S` and grouping by `n = dk`
gives coefficient `Σ_{d|n} Z(S)(d)·(1/(n/d)) = (1/n) Σ_{d|n} d Z(S)(d)`.
The map `Z ↦ ζ_S` is by definition a function of `Z`; conversely the log
coefficients are `C_n = Σ_{d|n} d Z(d)`, and Möbius inversion gives
`n Z(n) = Σ_{d|n} μ(d) C_{n/d}`. ∎

For the true world, `C_n = q^n`, so Lemma 1.1 is the familiar identity
`q^n = Σ_{d|n} d I(d)` and its inverse
`I(n) = (1/n) Σ_{d|n} μ(d) q^{n/d}`. This is formalised in Lean:

* `ZetaMobius.mobius_inversion` (`n · I(n) = Σ_{d|n} μ(d) q^{n/d}`, over `ℤ`),
* `ZetaMobius.mobius_inversion_rat` and `ZetaMobius.qrime_count` (over `ℚ`),
* `checks/round3.py` §[A] checks the full Euler product with exact rational
  power series, both directions.

**Lemma 1.1 is the precise sense in which "1-D" = "linear".** The logarithm of
the Euler product is an *additive* functional of the prime indicator,
`log ζ_S = Σ_{℘} h(℘)`, one prime at a time. The zeta cannot see anything that
is not a function of the multiset of degrees.

**Proposition 1.2 (zeros ↔ linear data, for a curve).** *Let `C/𝔽_q` be a curve
with `ζ_C(T) = P(T)/((1−T)(1−qT))`, `P(T) = ∏_{i=1}^{2g}(1 − α_i T)`. Then the
multiset `{α_i}` of Frobenius eigenvalues (the "zeros" of `ζ_C`) determines, and
is determined by, the sequence `(#C(𝔽_{q^n}))_{n≥1}` of point counts, via
Newton's identities and*

```
#C(𝔽_{q^n}) = q^n + 1 − Σ_i α_i^n = Σ_{d|n} d · Z_C(d) ,
```

*where `Z_C(d)` is the number of degree-`d` primes of `𝔽_q(C)`. Hence the zeros
are exactly a re-encoding of `Z_C`: they are linear data, no more.*

Thus "the zeros", "the point counts", and "the degree counts" are three
interchangeable presentations of the same 1-D information. Whatever the zeros can
do, `Z` can do, and vice versa.

---

## 2. The separation theorem

**Theorem 2.1 (linear data does not determine the pair statistic).** *There is no
function `Φ : (ℕ → ℕ) → ℕ` such that*

```
B(S) = Φ(Z(S))      for every finite admissible world S .
```

*Equivalently, the map `S ↦ (Z(S), B(S))` does not factor through `Z`; some
fibre of `Z` contains admissible worlds with different twin counts.*

*Proof.* Exhibit two worlds `S, T` with `Z(S) = Z(T)` and `B(S) ≠ B(T)`; then any
`Φ` would force `B(S) = Φ(Z(S)) = Φ(Z(T)) = B(T)`, contradiction. ∎

**Theorem 2.2 (explicit witness over `𝔽₇`, degree 2).** *In `𝔽₇[x]`, the two sets
of monic quadratics*

```
S = { x² + 1 ,  x² + 3x + 1 ,  x² + 4x + 1 ,  x² + 3x + 6 }
T = { x² + 1 ,  x² + 3x + 1 ,  x² + 4x + 1 ,  x² + 2      }
```

*are both contained in `Irr_7` (all eight polynomials are irreducible), have the
same zeta datum*

```
Z(S) = Z(T) = (0, 4, 0, 0, …) ,      so ζ_S = ζ_T ,
```

*and have twin counts `B(S) = 1`, `B(T) = 0`. The single difference is the swap
`x² + 3x + 6 ↦ x² + 2`; the former is `(x² + 3x + 1) − 2`, which is why `S` has a
twin.*

*Verification.* `checks/round3.py` §[B] enumerates the 21 monic irreducible
quadratics over `𝔽₇`, confirms `S, T ⊆ Irr_7`, and computes `B(S) = 1, B(T) = 0`.
In Lean, `Separation.separation_F7` proves the non-factorisation and
`Separation.witness_irreducible` proves all witness polynomials are irreducible
(via the general lemma `Separation.irreducible_quad_of_noRoot`: a monic quadratic
with no root is irreducible). ∎

**Corollary 2.3 (the zeta datum cannot certify the twin count).** *Since `ζ_S` is
a function of `Z(S)` (Lemma 1.1), Theorem 2.1 says there is no `Φ` with
`B(S) = Φ(ζ_S)` valid for all admissible worlds. So a zeta datum does not
distinguish the true world from an admissible world with the same degree counts
and no twins: given only the zeta, the twin count is left undetermined.*

**Remark 2.4 (the fibre is large).** `checks/round3.py` §[C] enumerates all
`k`-element worlds inside the 21 degree-2 qrimes: `Z` is constant on each such
fibre, while `B` ranges over `0 … max` with several distinct values
(`k = 4`: 5985 worlds, `B ∈ {0,1,2}`). The witness of Theorem 2.2 is the
`k = 4` case; the separation is not an isolated coincidence.

**Remark 2.5 (why the quantifier over worlds is essential — the uniformity
caveat).** For the *single* true world `S = Irr_q`, the datum `Z(Irr_q)` does
determine `q` (since `I(1) = q`), and `q` in turn determines the integer `T(n)`.
So there trivially exists a function `Φ_true` with `T(n) = Φ_true(Z(Irr_q))`:
namely, first recover `q`, then evaluate the definite integer `T(n;q)`. Theorem
2.1 is **not** that statement, and must not be read as one. It says no `Φ` works
*uniformly over admissible worlds*: the zeta datum is compatible both with a
twin-free world and with the true world, so it cannot by itself tell you that any
twin exists. The extra information “`S` is the set of qrimes” is not encoded in
`Z(S)`; supplying it is precisely what the 2-D theorem of §3 does. In the
language of statistics, `Z` is not a sufficient statistic for `B`.

This distinction is the honest content of “the zeros only see linear data”. It
does not say the integer `T(n)` is unknowable; it says that what the zeta
records (the degree counts) does not *force* `B`, and that a separate, 2-D input
is needed to go from the counts to the pair statistic.

---

## 3. The other side: what actually produces `B` — 2-D Chebotarev

The following is **cited, not proved here**. It is included so that the
separation has a named counterpart on the "bilinear" side.

**Theorem 3.1 (function-field Bateman–Horn for a tuple; Pollack, Conjecture 2).**
*Let `f_1, …, f_r` be non-associate irreducible polynomials over `𝔽_q` with
`deg(f_1 ⋯ f_r) ≤ B`, and suppose no prime `P` of `𝔽_q[T]` makes
`f_1(g)⋯f_r(g) ≡ 0 (mod P)` identically. Then as `q^n → ∞`,*

```
#{ g monic, deg g = n : f_1(g), …, f_r(g) all prime }
    = (1 + o_B(1)) · S(f_1,…,f_r) · (∏_{i=1}^r deg f_i) · q^n / n^r ,
```

*where*

```
S(f_1,…,f_r) = ∏_{P monic prime} (1 − ω(P)/q^{deg P}) / (1 − 1/q^{deg P})^r ,
ω(P)         = #{ A mod P : f_1(A) ⋯ f_r(A) ≡ 0 (mod P) } .
```

*(Pollack, "An explicit approach to Hypothesis H for polynomials over a finite
field", Anatomy of Integers, CRM Proc. Lecture Notes 46 (2008); Conjecture 2,
eq. (6).)*

**Specialisation to the twin case.** Take `r = 2`, `f_1(T) = T`, `f_2(T) = T + 2`
(so `∏ deg f_i = 1`). For `q` odd, `ω(P) = #{A mod P : A(A+2) ≡ 0}`. The roots
`0` and `−2` are distinct elements of `𝔽_q ⊆ 𝔽_q[T]/P`, so `ω(P) = 2` for
**every** prime `P`. Hence

```
S(T, T+2) = ∏_{P} (1 − 2/q^{deg P}) / (1 − 1/q^{deg P})²  =:  S(q) ,
```

and Theorem 3.1 reads

```
T(n) = (1 + o(1)) · S(q) · q^n / n² .                                  (3.1)
```

**This pins the normalisation.** The constant is exactly `S(q)`, with no extra
factor: the general prefactor `∏ deg f_i` equals `1` for `(T, T+2)`, and the
local numerator uses `ω(P) = 2`, which coincides with the `(1 − 2/Q)` local
factor used in round 2. `checks/round3.py` §[D] verifies `ω(P) = 2` for every
monic prime of degree `≤ 3` over `𝔽₃, 𝔽₅, 𝔽₇` (and for `q = 11, 13` notes the
structural argument), and reproduces the round-2 table

| `q` | 3 | 5 | 7 | 11 | 13 |
|---|---|---|---|---|---|
| `S(q)` | 0.396104 | 0.709544 | 0.812706 | 0.891687 | 0.910723 |

> **Erratum (round 4).** The values originally printed here were
> `0.461350, 0.709170, 0.831729, 0.897079, 0.887689`. They came from
> evaluating `(1−2/Q)/(1−1/Q)²` in double precision, which rounds to `1±1e-16`
> for large `Q`; multiplied by `I(d)~q^d/d` this corrupts the product. The
> stable form `∏(1−1/(Q−1)²)` gives the corrected values above. See
> [`round4.md`](round4.md) §2 and [`lib/singular_series.py`](../lib/singular_series.py).
> The **normalisation** argument (`ω(P)=2`, `∏ deg f_i = 1`) is unaffected.

**Status of (3.1).** Theorem 3.1 is a conjecture in general (it is the
function-field analogue of Bateman–Horn). The same paper's **Theorem A** proves
the count `q^n/n^r + O_{n,B}(q^{n−1/2})` when `q` is large compared to `n` and
`gcd(q, 2n) = 1`, using "an explicit version of the Chebotarev density theorem
for function fields (resting on Weil's Riemann Hypothesis)". The fixed-`q`,
`n → ∞` case quoted in this project is the function-field Bateman–Horn theorem;
it is **not reproved here**, and the numerical agreement below is evidence, not
proof. Round 4's step 1 searched the literature and found no proof of the
fixed-`q` case; Bary-Soroker (2010) explicitly calls the `qⁿ → ∞` formula
conjectural, and Pollack's `O(q^{n−1/2})` error is useless as `n → ∞`. The
conjecture label therefore stands. See [`round4.md`](round4.md) §1.

**Why this is "2-D".** The Euler product of §1 is a product over single primes;
its logarithm is `Σ_{℘} h(℘)`. The twin count is instead
`Σ_f 1_℘(f) 1_℘(f+2)`, a product of *two* prime indicators at the pair
`(f, f+2)`. The theorem that controls it is Chebotarev for the **generic pair**:
the joint factorization of `g` and `g+2` is governed by the Galois group of the
compositum of the splitting fields of `g` and `g+2` over `𝔽_q(u)` — a fiber
product of two copies of `S_n` — and `T(n)` is the density of the joint event
“both splits with an `n`-cycle”. That is a genuinely 2-dimensional (product)
equidistribution statement. (It is *not* the splitting field of the degree-2
polynomial `X(X+2)`, which is trivial; the point is the pair of factorization
types of the generic degree-`n` polynomial and its shift.) The 1-D Frobenius of
§1 sees one prime at a time; it cannot see the correlation.

**Numerical check (round 4, with the corrected `S(q)`).** `T(n)n²/qⁿ`
approaches `S(q)` with a *small* oscillating remainder. Data from
`checks/round4_step2.py` and [`round4.md`](round4.md) §2:

| `q` | `n` | `T(n)` | `T(n)n²/qⁿ` | `S(q)` | diff |
|---|---|---|---|---|---|
| 7 | 6 | 2667 | 0.816089 | 0.812706 | +3.4e−3 |
| 7 | 9 | 401051 | 0.805012 | 0.812706 | −7.7e−3 |
| 5 | 10 | 69260 | 0.709222 | 0.709544 | −3.2e−4 |
| 3 | 12 | 1506 | 0.408068 | 0.396104 | +1.2e−2 |
| 3 | 16 | 66606 | 0.396108 | 0.396104 | **+3.4e−6** |

The earlier claim that the approach is "slow, `O(1/n)`" was an artefact of the
wrong constant: `n·D(n)` does not converge, and the envelope of `|D|` shrinks
rapidly (for `q=3`, `max|D|` falls `9.98e−2 → 3.03e−2 → 6.40e−3` over
`n ∈ [6,9], [10,13], [14,17]`). The residual oscillation is arithmetic; the
exact degree-3 formula `T(3) = q(q−2)(q+1)/9` for `q ≡ 2 (mod 3)` is the clean
illustration ([`round4.md`](round4.md) §2.4). The cleanest check is now
`q=3, n=16`: `0.396108` versus `S(3) = 0.396104`.

---

## 4. The decisive case: a zeta with no zeros

**Proposition 4.1.** *For `𝔸¹ = Spec 𝔽_q[x]`, `ζ_{𝔸¹}(T) = 1/(1 − qT)`; for
`ℙ¹`, `ζ_{ℙ¹}(T) = 1/((1−T)(1−qT))`. In both cases the numerator `P(T)` is `1`,
so the zero multiset of the zeta is empty. Yet `B_n(Irr_q) = T(n) > 0` for
infinitely many `n` (e.g. `T(3) = 1` for `q = 3`, `T(3) = 10` for `q = 5`,
`T(2) = 7` for `q = 7`).*

*Consequently no function of the zero multiset alone can equal the twin count
`T(n; q)` as a function of `q` and `n`: the multiset is empty for every `q`, so
every function of it is constant, while `T(n; q)` is not.*

This is the sharpest form of the separation: it is not merely that the zeros
*happen* not to determine `B`; for `ℙ¹` there are no zeros at all to carry it.
For a higher-genus curve the zeros encode `Z_C` (Proposition 1.2), which by
Theorem 2.1 still does not determine `B` uniformly across worlds.

**Round 4 makes this a standalone theorem.** Instead of varying the world, one
fixes the curve `C` and varies the map `π : C → ℙ¹`. On `ℙ¹/𝔽₅`, the maps
`π₁(x)=x` and `π₂(x)=2x` give pair counts `0` and `5` while `ζ_{ℙ¹}` is
unchanged. Hence the pair statistic is not a function of `Z_C` even on a single
curve; the zeros (which only encode `Z_C`) cannot supply it. See
[`round4.md`](round4.md) §3 and `CurveLift.curve_separation`.

---

## 5. The separation as a diagram

```
   1-D (zeros)                                   2-D (Chebotarev)
   ───────────                                   ───────────────
   {α_i}  ←Newton→  {#C(F_{q^n})}  ←Möbius→  Z_C        Gal(generic pair (g,g+2)) ⊂ S_n×S_n
     │                                          │                    │
     │  Proposition 1.2                         │  Theorem 2.1       │  Theorem 3.1
     ▼                                          ▼                    ▼
   linear data  ──────────────────────────✗──  B  ◀────────────────  B
                                         (no uniform Φ)     (T(n) ~ S(q) q^n/n^2)
```

* The upper-left chain is an **equivalence** of data: zeros, point counts and
  degree counts are the same thing.
* The horizontal arrow `Z ⇸ B` is **broken** (Theorem 2.1): no *uniform* function
  recovers the pair statistic from the degree counts. (See Remark 2.5: for the
  one true world `q` is recoverable, but that uses the extra fact that the world
  is `Irr_q`, not zeta data.)
* The lower-right arrow is the **2-D input** that does produce `B`
  (Theorem 3.1), and it does not pass through the zeros.

Over `ℚ` the right-hand mechanism is unavailable: there is no Frobenius and no
Chebotarev, the two-point equidistribution is the open twin prime conjecture, and
Selberg's parity theorem says the 1-D (linear-sieve / explicit-formula) methods
cannot supply it. That is the same gap, transported.

---

## 6. What is where

| claim | where | status |
|---|---|---|
| Euler product `⇔` degree counts (Lemma 1.1) | `ZetaMobius.mobius_inversion*`; `checks/round3.py` §[A] | proved / checked |
| zeros `⇔` linear data (Prop. 1.2) | this note (Newton + Möbius) | standard |
| no uniform `Φ` with `B = Φ(Z)` (Thm 2.1) | `Separation.no_zeta_observable` | proved |
| uniformity caveat (Rem. 2.5) | this note | — |
| explicit witness over `𝔽₇` (Thm 2.2) | `Separation.separation_F7`, `Separation.witness_irreducible`; `checks/round3.py` §[B] | proved / checked |
| fibre is large (Rem. 2.4) | `checks/round3.py` §[C] | checked |
| `T(n) ~ S(q) qⁿ/n²`, exact constant (Thm 3.1) | this note (Pollack, Conj. 2); `checks/round3.py` §[D] | **cited**, not proved |
| no zeros for `𝔸¹`, `ℙ¹` (Prop. 4.1) | this note; `checks/round2.py` §[C] | proved |
| corrected convergence data | `checks/round4_step2.py`; `checks/round3.py` §[E] | empirical; `S(q)` corrected in round 4 |

**Not claimed:** any proof of the twin prime conjecture; any proof of the parity
barrier over `ℚ`; any transfer of the function-field mechanism to `ℤ`; any proof
of the function-field Bateman–Horn theorem in the fixed-`q` regime. The
separation proved here is an *information-theoretic* statement about the zeta; it
is not a statement that twin qrimes do not exist (they do, and `T(n) > 0`).

---

## 7. Next steps — status after round 4

1. **Pin the fixed-`q` theorem.** *Done (step 1 of [`round4.md`](round4.md)).*
   No proof of the fixed-`q`, `n→∞` case was located; Bary-Soroker (2010)
   explicitly calls the `qⁿ→∞` formula conjectural, and Pollack's
   `O(q^{n−1/2})` error with constant `(n!)^B` is useless as `n→∞`. The label
   "Conjecture 2 of Pollack" stands.
2. **Quantify the error.** *Done (step 2 of [`round4.md`](round4.md)).* The
   oscillation is **not** a second-order main term: `n·D(n)` does not converge.
   The "slow `O(1/n)`" diagnosis was caused by a floating-point bug in `S(q)`;
   the corrected constants and the fast approach are in `round4.md` §2.
3. **Lift the separation to a curve.** *Done (step 3 of
   [`round4.md`](round4.md)).* On a fixed curve the pair statistic depends on
   the map `π : C → ℙ¹`; the `ℙ¹/𝔽₅` witness gives pair counts `0` and `5` on
   the same curve. Lean: `CurveLift.curve_separation`.
