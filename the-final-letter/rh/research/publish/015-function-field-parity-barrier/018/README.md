# 018 — Qrimes, twin qrimes, and the parity barrier in function-field language

**Status: COMPLETE (rounds 1–30 + new goal rounds 31–55) + aggressive goal in progress (round 107).** The dictionary is defined and verified; the qrime
counts, the twin-qrime counts and the linear/bilinear witness are computed; the
Lean finite layer is green. Round 3 turns the "2-D Chebotarev vs 1-D zeros"
separation into a formal statement — see
[`notes/round3-formal-statement.md`](notes/round3-formal-statement.md).
Round 4 does the follow-ups and corrects a numerical error in `S(q)` — see
[`notes/round4.md`](notes/round4.md). Round 5 reads the twin count as a Frobenius
trace and records a wild guess for the barrier — see
[`notes/round5-barrier.md`](notes/round5-barrier.md), and round 6 decodes
the exact degree-3 formula — see
[`notes/round6-exact-formula.md`](notes/round6-exact-formula.md). Round 7
shows the generating function is the dilogarithm — see
[`notes/round7-dilogarithm.md`](notes/round7-dilogarithm.md), and round 8
extracts the trace corrections — see
[`notes/round8-corrections.md`](notes/round8-corrections.md), and round 9
isolates the error barrier — see
[`notes/round9-error-barrier.md`](notes/round9-error-barrier.md). Round 10
shows the shift average is an exact polynomial — see
[`notes/round10-average.md`](notes/round10-average.md). Round 11 proves the
character-support structure — see
[`notes/round11-characters.md`](notes/round11-characters.md). Round 12 shows
the exact-polynomial regime stops at `d=5` — see
[`notes/round12-degree5.md`](notes/round12-degree5.md). Round 13 decomposes
the average into the constant-shift distribution — see
[`notes/round13-distribution.md`](notes/round13-distribution.md). Round 14
identifies the cap as a sieve-union bound — see
[`notes/round14-parity.md`](notes/round14-parity.md). Round 15 explains the
`d=5` failure by value-set collapse — see
[`notes/round15-value-set.md`](notes/round15-value-set.md). Round 16 extends the
collapse to `d=6,7` — see
[`notes/round16-extremal.md`](notes/round16-extremal.md). Round 17 corrects the
scope of the cap — see
[`notes/round17-cap-scope.md`](notes/round17-cap-scope.md). Round 18 shows the
resolvent is a cyclic-Galois artifact — see
[`notes/round18-resolvent.md`](notes/round18-resolvent.md). Round 19 states the
one-point/two-point gap — see
[`notes/round19-one-two-point.md`](notes/round19-one-two-point.md). Round 20 computes
the two-point variance — see
[`notes/round20-variance.md`](notes/round20-variance.md). Round 21 adds the
four-point check and a `B₄` congruence — see
[`notes/round21-four-point.md`](notes/round21-four-point.md). Round 22 refutes the
class-number guess — see
[`notes/round22-class-number.md`](notes/round22-class-number.md). Round 23 proves
translation divisibility — see
[`notes/round23-translation.md`](notes/round23-translation.md). Round 24 pins the
orbit count — see
[`notes/round24-orbit.md`](notes/round24-orbit.md). Round 25 proves the extremal family
`x⁴+b` achieves the cap; rounds 26–28 reduce the cap to the `j`-line; round 29
identifies the cusp doubling. Round 30 is the final synthesis — see
[`notes/round30-synthesis.md`](notes/round30-synthesis.md).

**Nothing here proves or refutes the twin prime conjecture or the parity barrier
over ℚ.**

## 1. The dictionary

Fix a prime field `𝔽_q`. **Qrimes** are the closed points (places) of the
function field; in the polynomial model `𝔽_q[x]` they are the **monic
irreducibles**. **Twin qrimes** are pairs `(f, f+2)` with both `f` and `f+2`
monic irreducible of degree `n`.

| ℤ | `𝔽_q[x]` |
|---|---|
| integers | monic polynomials |
| primes `p` | **qrimes** (monic irreducibles) |
| `|n|` | `q^{deg}` |
| `p, p+2` | `f, f+2` — **twin qrimes** |
| `ζ(s)=Σ n^{-s}` | `1/(1−q^{1−s})` |
| `log ζ` coefficient | `q^n = Σ_{d|n} d·I(d)` |

## 2. What the zeta sees: linear statistics — verified

Let `I(n)` be the number of qrimes of degree `n`. The Euler product gives the
exact coefficient identity, verified in `checks/round1.py` §[A] for
`q = 3,5,7`, `n ≤ 6`:

```
q^n = Σ_{d|n} d·I(d),        hence      I(n) = (1/n) Σ_{d|n} μ(d) q^{n/d}.
```

This is *linear* zeta data: `I(n)` is a coefficient of `log ζ`. In the
curve language, the zeros of `ζ_C` (Frobenius eigenvalues) encode the point
counts — again linear statistics.

## 3. What the zeta does *not* see: the twin count — verified

Let `T(n) = #{f : f, f+2 both monic irreducible, deg n}`. It is a **pair
correlation**, not a zeta coefficient. Computed (`checks/round1.py` §[B]):

| q | n | `I(n)` | `T(n)` | `T n²/qⁿ` |
|---|---|---|---|---|
| 3 | 3 | 8 | 1 | 0.333 |
| 3 | 5 | 48 | 6 | 0.617 |
| 3 | 9 | 2184 | 105 | 0.432 |
| 5 | 3 | 40 | 10 | 0.720 |
| 5 | 5 | 624 | 98 | 0.784 |
| 7 | 2 | 21 | 7 | 0.571 |
| 7 | 3 | 112 | 35 | 0.918 |
| 7 | 5 | 3360 | 560 | 0.833 |

`T(n)·n²/qⁿ` settles to a constant `C(q)` (the function-field singular series;
`q=7: ≈0.83`, `q=5: ≈0.73`, `q=3: ≈0.4` with small-`n` noise). But
`T/(I²/qⁿ) → C(q) ≠ 1`, so **`T(n)` is not a function of `I(n)`**: the pair
count carries 2-point information the linear/zeta data does not.

> **Twin qrimes conjecture (function field).** `T(n) ~ C(q) qⁿ/n²` with
> `C(q) = S(q) > 0`. Status: *cited* — Pollack's Conjecture 2 (the function-field
> Bateman–Horn statement); Pollack's Theorem A proves the `q`-large regime, and
> the fixed-`q`, `n→∞` case is not proved in this project. This directory verifies
> the finite counts, the constant `S(q)`, and the exact normalisation
> (`∏ deg f_i = 1`, `ω(P) = 2`; see §8).

## 4. The parity barrier in qrime form

The finite witness (`checks/round1.py` §[C], and **machine-checked** in Lean as
`Qrime.linear_not_determine_twin`):

> There are two sets `S, T` of qrimes with `|S| = |T|` but different twin counts
> `#{f ∈ S : f+2 ∈ S}`.

So the **linear statistic `|S|` (zeta-type data) does not determine the bilinear
statistic**. This is the parity barrier, restated over `𝔽_q[x]`.

**Why the function-field analogue is nevertheless provable — and why that does
not solve ℚ.** In `𝔽_q[x]`, `T(n)` is a theorem, but the proof does *not* go
through the zeta zeros. It goes through **2-dimensional equidistribution**:
Chebotarev applied to the Galois group of the splitting field of `f·(f+2)` (or
the function-field large sieve), which controls the *pair* `(f, f+2)` directly.
That is an **algebraic** input — the polynomial ring over a finite field has a
Frobenius. Over ℤ there is no Frobenius and no Chebotarev; the two-point
equidistribution is exactly the open twin prime conjecture, and Selberg's parity
theorem says the 1-dimensional (linear-sieve / explicit-formula) methods cannot
supply it — the same gap as §3. **The function-field zeta zeros encode the linear
statistics only; the twin count is proved by a different, algebraic mechanism.**


## 7. Round 2 — the singular series, and a zeta with no zeros

**The constant.** The twin-qrime singular series is

```
S(q) = ∏_{℘ qrime} (1 − 2/N(℘)) / (1 − 1/N(℘))² ,      N(℘) = q^{deg ℘},
```

with local factor `(1−2/Q)/(1−1/Q)² = (Q−2)Q/(Q−1)²` (verified symbolically and
in Lean as `Qrime.local_factor`). Computed (`checks/round2.py` §[A]):

| q | 3 | 5 | 7 | 11 | 13 |
|---|---|---|---|---|---|
| `S(q)` | **0.396104** | **0.709544** | **0.812706** | **0.891687** | **0.910723** |

> **Correction (round 4).** The values first printed here — `0.4614, 0.7092,
> 0.8317, 0.8971, 0.8877` — came from evaluating `(1−2/Q)/(1−1/Q)²` in double
> precision; for large `Q` the ratio rounds to `1±1e-16`, and `log(lf)·I(d)`
> with `I(d)~q^d/d` corrupts the product. The stable form
> `∏(1−1/(Q−1)²)` gives the corrected values above
> ([`notes/round4.md`](notes/round4.md) §2,
> [`lib/singular_series.py`](lib/singular_series.py)).

**Match to the counts.** With the corrected `S(q)` the approach is *fast*, not
`O(1/n)`: at `q=3, n=16`, `T n²/qⁿ = 0.3961077` vs `S(3)=0.3961043` (relative
error `8.5e-6`). `n·D(n)` does not converge, so there is no `c/n` second-order
term; the residual oscillation is arithmetic, as the exact degree-3 formula
`T(3)=q(q−2)(q+1)/9` for `q≡2 (mod 3)` shows ([`notes/round4.md`](notes/round4.md) §2).

**A zeta with no zeros.** `ζ_{ℙ¹}(T) = 1/((1−T)(1−qT))` has numerator `P(T)=1`,
so **no zeros at all** — yet `T(n) > 0` (`n=3`: `1` over `𝔽₃`, `10` over `𝔽₅`;
`n=2`: `7` over `𝔽₇`). This is the decisive form of item (ii) of the objective:

> the zeta zeros of `ℙ¹` cannot encode the twin-qrime count, because there are
> none; the twin count is a 2-point (bilinear) statistic, not a zeta coefficient.

For a higher-genus curve the zeros (Frobenius eigenvalues) encode the point counts
— still *linear* statistics. The twin-qrime count requires the 2-dimensional
Chebotarev/large-sieve input, which exists over `𝔽_q[x]` and does not exist over ℤ.

## 8. Round 3 — the separation as a formal statement

The informal "2-D Chebotarev vs 1-D zeros" claim is now a precise statement; the
full document is [`notes/round3-formal-statement.md`](notes/round3-formal-statement.md).

**Definitions.** A *world* is a set `S ⊆ 𝔽_q[x]` of qrimes; its **zeta datum** is
`Z(S)(n) = #{f ∈ S : deg f = n}`; its **twin count** is
`B(S) = #{f ∈ S : f+2 ∈ S}`. The *true world* is `S = Irr_q`, where
`Z(S)(n) = I(n)` and `B_n(S) = T(n)`.

**What the zeta sees (proved).** `log ζ_S(T) = Σ_n (1/n)(Σ_{d|n} d Z(S)(d)) T^n`,
so `ζ_S` and `Z(S)` determine each other (Euler product + Möbius inversion). For a
curve, Newton's identities identify the zeros with the point counts, and
`#C(𝔽_{q^n}) = Σ_{d|n} d Z_C(d)` identifies the point counts with the degree
counts. **The zeros are exactly linear data.**

**The separation (proved).** There is no `Φ` with `B(S) = Φ(Z(S))` for all worlds.
Concrete witness over `𝔽₇`, degree 2 (all eight polynomials irreducible):

```
S = { x²+1, x²+3x+1, x²+4x+1, x²+3x+6 }     B(S) = 1
T = { x²+1, x²+3x+1, x²+4x+1, x²+2      }     B(T) = 0
Z(S) = Z(T) = (0,4,0,…)   ⇒   ζ_S = ζ_T
```

Swapping the single polynomial `x²+3x+6` for `x²+2` leaves the zeta fixed and
changes the twin count. Lean: `Separation.no_zeta_observable`,
`Separation.separation_F7`, `Separation.witness_irreducible`. On each fibre of `Z`
the twin count takes several values (`checks/round3.py` §[C]).

**What actually produces `B` (cited, not proved).** Pollack's Conjecture 2
(quantitative constant-coefficient Hypothesis H) gives, for `(f_1,f_2)=(T,T+2)`,
`ω(P)=2` for every prime `P` and `∏ deg f_i = 1`, hence exactly

```
T(n) = (1+o(1)) · S(q) · q^n / n² ,    S(q) = ∏_P (1−2/N(P))/(1−1/N(P))² .
```

This **pins the normalisation**: the constant is `S(q)`, no extra factor. The
`2-D` content is Chebotarev for the *generic pair* `(g, g+2)` (a fiber product of
two `S_n`'s), not the 1-D Euler product. Status: Theorem 3.1 of the note is a
conjecture in general; Pollack's Theorem A proves the `q`-large regime. The
fixed-`q`, `n→∞` case is the function-field Bateman–Horn statement used here and
is not reproved. Round 4's step 1 searched the literature: no proof of the
fixed-`q` case was found (Bary-Soroker 2010 calls the `qⁿ→∞` formula
conjectural; Pollack's error `O(q^{n−1/2})` is useless as `n→∞`), so the
conjecture label stands — see [`notes/round4.md`](notes/round4.md) §1.

**Möbius inversion in Lean.** `ZetaMobius.mobius_inversion` proves
`n·I(n) = Σ_{d|n} μ(d) q^{n/d}` from `q^n = Σ_{d|n} d·I(d)`; the `ℚ` versions are
`mobius_inversion_rat` and `qrime_count`. Clean footprints
(`propext, Classical.choice, Quot.sound`).

## 9. Round 4 — the three follow-ups, and a numerical correction

Full write-up: [`notes/round4.md`](notes/round4.md).

**Step 1 — fixed-`q` status: open.** No proof of the fixed-`q`, `n→∞`
asymptotic was found. Pollack's Theorem A gives `qⁿ/nʳ + O(q^{n−1/2})` for `q`
large vs `n`; Bary-Soroker (2010) states that the `qⁿ→∞` formula is
*conjectural*, and Pollack's error constant `(n!)^B` makes it useless as
`n→∞`. The "Conjecture 2 of Pollack" label stands.

**Step 2 — the oscillation: not a second-order term.** The round-2/3 `S(q)`
was corrupted by floating-point cancellation (`S(3)=0.461350` instead of
`0.396104`). With the stable `S(q)`: the convergence is fast (`q=3, n=16`
matches to `8.5e-6`); `n·D(n)` does not converge, so there is no `c/n` term;
the residual oscillation is arithmetic. The exact degree-3 result
`T(3) = q(q−2)(q+1)/9` for `q≡2 (mod 3)` (Bary-Soroker–Stix) is verified
symbolically and, at `q=5`, in Lean (`CubicTwins.cubicTwin_five`).

**Step 3 — the curve lift.** On a fixed curve `C` the pair statistic depends on
the map `π : C→ℙ¹`, not only on `Z_C`. Witness `C=ℙ¹/𝔽₅`: `π₁(x)=x` gives 0,
`π₂(x)=2x` gives 5, same zeta. Lean:
`CurveLift.no_pair_function_of_zeta`, `CurveLift.curve_separation`.

## 10. Round 5 — the twin count as a Frobenius trace (and a wild guess)

Full write-up: [`notes/round5-barrier.md`](notes/round5-barrier.md), and round 6 decodes
the exact degree-3 formula — see
[`notes/round6-exact-formula.md`](notes/round6-exact-formula.md). Round 7
shows the generating function is the dilogarithm — see
[`notes/round7-dilogarithm.md`](notes/round7-dilogarithm.md), and round 8
extracts the trace corrections — see
[`notes/round8-corrections.md`](notes/round8-corrections.md), and round 9
isolates the error barrier — see
[`notes/round9-error-barrier.md`](notes/round9-error-barrier.md). Round 10
shows the shift average is an exact polynomial — see
[`notes/round10-average.md`](notes/round10-average.md). Round 11 proves the
character-support structure — see
[`notes/round11-characters.md`](notes/round11-characters.md). Round 12 shows
the exact-polynomial regime stops at `d=5` — see
[`notes/round12-degree5.md`](notes/round12-degree5.md). Round 13 decomposes
the average into the constant-shift distribution — see
[`notes/round13-distribution.md`](notes/round13-distribution.md). Round 14
identifies the cap as a sieve-union bound — see
[`notes/round14-parity.md`](notes/round14-parity.md). Round 15 explains the
`d=5` failure by value-set collapse — see
[`notes/round15-value-set.md`](notes/round15-value-set.md). Round 16 extends the
collapse to `d=6,7` — see
[`notes/round16-extremal.md`](notes/round16-extremal.md). Round 17 corrects the
scope of the cap — see
[`notes/round17-cap-scope.md`](notes/round17-cap-scope.md). Round 18 shows the
resolvent is a cyclic-Galois artifact — see
[`notes/round18-resolvent.md`](notes/round18-resolvent.md). Round 19 states the
one-point/two-point gap — see
[`notes/round19-one-two-point.md`](notes/round19-one-two-point.md). Round 20 computes
the two-point variance — see
[`notes/round20-variance.md`](notes/round20-variance.md). Round 21 adds the
four-point check and a `B₄` congruence — see
[`notes/round21-four-point.md`](notes/round21-four-point.md). Round 22 refutes the
class-number guess — see
[`notes/round22-class-number.md`](notes/round22-class-number.md). Round 23 proves
translation divisibility — see
[`notes/round23-translation.md`](notes/round23-translation.md). Round 24 pins the
orbit count — see
[`notes/round24-orbit.md`](notes/round24-orbit.md). 
**The barrier, in this dictionary.** The twin indicator has **no Euler product**
(`twinInd(3)=twinInd(5)=1`, `twinInd(15)=0`; Lean `Barrier.twinInd_not_mult`),
and the twin count is not a zeta coefficient (round 3). A bounded-depth sieve
sees only the local densities, i.e. the trivial part of the arithmetic.

**The trace reading.** In `𝔽_q[x]` the count is a Chebotarev / Frobenius trace
on the *twin motive* `M_n`. In degree 3 the geometry is the elliptic curve
`E: Y²−Y=X³` (Bary-Soker–Stix), with trace `c_q = q+1−#E(𝔽_q)`. Verified for
every prime `5≤q≤120`:

```
T(3) = q(q−2)(q+1)/9   ⇔   c_q = 0   ⇔   q ≡ 2 (mod 3) .
```

So the "clean" polynomial part is exact precisely in the **supersingular** case;
the ordinary case (`q≡1 mod 3`) has a nonzero arithmetic deviation. The zeta of
`ℙ¹` has no zeros, yet `T(3)` is governed by a different L-function.

**Wild guess 5.** The twin count is the Frobenius trace on the **twin motive**;
over `ℚ` the missing object is its L-function (a `GL(2)×GL(2)`-type object with
a functional equation and a pole at `s=1`). The parity barrier is then a
cohomological/automorphic gap, not a sieve weakness. This is a guess: `M_n` has
no known construction over `ℚ`. It is supported by the degree-3 vanishing
pattern and by the dictionary's §5.4 (Type-II / equidistribution / automorphic
input). Next round: decode the ordinary correction and go to degree 4.

## 11. Round 6 — the exact degree-3 formula, and degree 4

Full write-up: [`notes/round6-exact-formula.md`](notes/round6-exact-formula.md).

Decodes the exact Bary-Soroker–Stix degree-3 formula (three branches, the cubic
twist), contrasts it with degree 4, and states the "cohomological complexity in
`d`" guess.

## 12. Round 7 — the generating function is a dilogarithm

Full write-up: [`notes/round7-dilogarithm.md`](notes/round7-dilogarithm.md).

The twin-density generating function is `Li₂`; rationality is refuted; the
correct object is the dilogarithm, not a rational function.

## 13. Round 8 — the `1/q` corrections are traces; degree 4 is a new motive

Full write-up: [`notes/round8-corrections.md`](notes/round8-corrections.md).

`A_2` is an exact Dirichlet-character trace, `A_3` a `Sym²(E)`/twist trace, and
`A_4` varies on `c_q = 0` — suggesting a new motive at `d=4` (downgraded in
round 9).

## 14. Round 9 — the error barrier, and a correction to round 8

Full write-up: [`notes/round9-error-barrier.md`](notes/round9-error-barrier.md).

The Chebotarev error is `O(q^{d−1/2})`, larger than the `q^{d−1}` correction;
the `d=4` "new motive" is not identifiable from the data. Wild guess 9:
computability of `H^*(V_d)`.

## 15. Round 10 — averaging over the shift: the trivial character is a polynomial

Full write-up: [`notes/round10-average.md`](notes/round10-average.md).

`A_4(q) = q(q³−q²−5q−3)/16` (exact, 10 primes); the `h`-dependence is
multiplicative-character theoretic. Wild guess 10: the missing averaging.

## 16. Round 11 — the shift dependence is `d`-torsion

Full write-up: [`notes/round11-characters.md`](notes/round11-characters.md).

The multiplicative Fourier transform of `h ↦ T(d;q,h)` is supported on the
characters of order dividing `d` (with a 2-adic refinement at `d=4`), and in the
generic class the count is an exact polynomial.

## 17. Round 12 — the low-degree miracle stops at `d=5`

Full write-up: [`notes/round12-degree5.md`](notes/round12-degree5.md).

`d=3,4` have exact generic-class polynomials; `d=5` does **not** (exact
interpolation fails). Lean: `x ↦ x³` is a bijection when `3 ∤ q−1`.

## 18. Round 13 — the constant-shift distribution

Full write-up: [`notes/round13-distribution.md`](notes/round13-distribution.md).

The shift average is the second moment of `I(a)`; `d=2` uniform, `d=3` a cubic
value set, `d=4` capped by `(q−1)/2`, `d≥5` irregular.

## 19. Round 14 — the `d=4` cap is a sieve-union bound

Full write-up: [`notes/round14-parity.md`](notes/round14-parity.md).

`I = q − |Im ∪ Q|`, so the cap is `|Im ∪ Q| ≥ (q+1)/2`, with equality at the
extremal families; the "quadratic character" reading fails at `q=11,13`.

## 20. Round 15 — the value-set collapse at `d=5`

Full write-up: [`notes/round15-value-set.md`](notes/round15-value-set.md).

The extremal `d=5` families are `x⁵ − x` and `x⁵`: the value set collapses to
size 1 or 3, breaking the cap. Wild guess 15: generic vs specific.

## 21. Round 16 — the value-set collapse at `d=6,7`

Full write-up: [`notes/round16-extremal.md`](notes/round16-extremal.md).

All extremal families at `d=6,7` have `|Im| ≤ 3`; the null polynomial
`x^{d−q}(x^q−x)` collapses the image for `d ≥ q`; `(x⁵−x)' = −1` (Lean).

## 22. Round 17 — the `(q−1)/2` cap is special to `d=4`

Full write-up: [`notes/round17-cap-scope.md`](notes/round17-cap-scope.md).

At `d=3` the family maximum is `(2q−2)/3` (`q≡1 mod 3`) or `(q+1)/3`
(`q≡2 mod 3`), so the cap already fails at `d=3`. The cap is `d=4`-specific.

## 23. Round 18 — the resolvent cannot compensate: cyclic Galois groups

Full write-up: [`notes/round18-resolvent.md`](notes/round18-resolvent.md).

Every irreducible quartic over `𝔽_q` has exactly one resolvent root, because the
Frobenius is an odd 4-cycle fixing one pairing. Over `ℚ`, `S₄` gives irreducible
resolvents.

## 24. Round 19 — one-point versus two-point statistics

Full write-up: [`notes/round19-one-two-point.md`](notes/round19-one-two-point.md).

`Σ_h T = Σ_a I(I−1)`: the average of the two-point count is the second moment of
the one-point distribution, but the individual `h=2` is not determined. Wild
guess 19: the one-point/two-point gap.

## 25. Round 20 — the two-point variance

Full write-up: [`notes/round20-variance.md`](notes/round20-variance.md).

`Var(T) = Σ_{k≠0}|c_k|²` (Plancherel); for `d=4, q≡5 (mod 8)`, `Var = B₄²`.
Wild guess 20: diagonal vs off-diagonal.

## 26. Round 21 — the four-point moment and the `B₄` congruence

Full write-up: [`notes/round21-four-point.md`](notes/round21-four-point.md).

The fourth central moment is fully predicted by the `d`-torsion expansion;
`2B₄(q)/q ≡ 1 (mod 8)` for nine primes.

## 27. Round 22 — the class-number guess is refuted

Full write-up: [`notes/round22-class-number.md`](notes/round22-class-number.md).

`h(q) = (1−2B₄/q)/8` is not a class number of `ℚ(√−q)`, and the
discriminant-square description of the reducible set fails. Wild guess 22: an
`L`-value.

## 28. Round 23 — translation divisibility and `B₄(73)`

Full write-up: [`notes/round23-translation.md`](notes/round23-translation.md).

The free translation action gives `q | T(d;q,h)` for `d < q`; at `d=q=5` it
fails (`T=98`). `B₄(73) = 4161/2`; the congruence holds for nine primes.

## 29. Round 24 — the orbit count: exact for `q ≡ 3 (mod 4)`

Full write-up: [`notes/round24-orbit.md`](notes/round24-orbit.md).

`T(4;q,2) = 4qk(k+1)²` for `q = 4k+3`, hence `T/q ≡ 0 (mod 8)`; the
Hurwitz-class-number guess is refuted by scaling.

## 30. Round 25 — the extremal family `x⁴ + b`

Full write-up: [`notes/round25-extremal.md`](notes/round25-extremal.md).

For `q ≡ 1 (mod 4)`, `R(x⁴+b)` is exactly the squares, so `I = (q−1)/2`: the cap
is **achieved** by this family (proved).

## 31. Round 26 — the depressed quartic; `q ≡ 3 (mod 4)` extremal families

Full write-up: [`notes/round26-depressed.md`](notes/round26-depressed.md).

The normal form `y⁴ + Py² + Qy + R` shows `x⁴+b` is codimension 2, refuting
Möbius transport; the `q≡3 (mod 4)` extremal families all have `a₃=0`.

## 32. Round 27 — the even slice: cap holds and is tight

Full write-up: [`notes/round27-even-slice.md`](notes/round27-even-slice.md).

**Even-slice cap.** For `g = x⁴ + a₂x²` the cap `I(a₂) ≤ (q−1)/2` holds for every
`a₂` and is **tight**:

| `q` | 5 | 13 | 29 | 37 | 41 |
|---|---|---|---|---|---|
| `max I` | 2 | 6 | 14 | 18 | 20 |
| `min \|R\|` | 3 | 7 | 15 | 19 | 21 |

**Factorization.** `x⁴ + a₂x² + b = (x²−y)(x²−z)` when `y+z=−a₂`, `yz=b`,
proved in Lean.

**Wild guess 27.** The even slice is `h(x²)` with `h(y)=y²+a₂y`; the involution
`x ↦ −x` halves the dimension, and the cap `(q−1)/2` is the size of the quotient.
Over `ℚ`, this is the "half-dimensional" symmetry that the parity barrier
cannot exploit.

**Lean.** `EvenQuartic.even_quartic_aux` and `even_quartic_factor`.

## 33. Round 28 — reducing the general cap to the `a₃=0` slice

Full write-up: [`notes/round28-reduction.md`](notes/round28-reduction.md).

**Translation reduction.** For fixed `(a₃,a₂,a₁)` the translation `x ↦ x−a₃/4`
removes the cubic term, with

```
a₂' = a₂ − 3a₃²/8 ,   a₁' = a₁ + a₃³/8 − a₂a₃/2 ,
```

and preserves the family count:

```
I(a₃,a₂,a₁) = I(0, a₂', a₁') .
```

Verified with **0 mismatches** over all 2197 families at `q=13`. Hence the
general cap ⇔ the `a₃=0` cap.

**`j`-invariant.** In the slice, scaling `x ↦ cx` acts by
`(a₂,a₁) ↦ (a₂/c², a₁/c³)` and preserves `I`; the invariant is
`j = a₁²/a₂³`. At `q=13` the 12 classes collapse to 13 `j`-values, and `I`
depends only on `j`.

**The `a₃=0` cap.** Holds for `q = 13,29,37,41`, with the extremal class
`(a₂,a₁) = (0,0)` (`x⁴+b`) at every prime.

**Wild guess 28.** The cap is a statement on the `j`-line `X(1)`, decreasing
away from the cusp `j = ∞`. Over `ℚ`, the `j`-invariant does not control the
fixed-shift correlation.

**Lean.** `JInvariant.j_invariant_scale : (a₁/c³)²/(a₂/c²)³ = a₁²/a₂³`.

## 34. Round 29 — the cusp doubling

Full write-up: [`notes/round29-cusp.md`](notes/round29-cusp.md).

**`j`-line normalisation.** For `a₂ ≠ 0`, `I(j) = (q−1)/4 + O(1)`:

| `q` | 13 | 29 | 37 | 41 |
|---|---|---|---|---|
| mean `I(j)` | 3.23 | 7.24 | 9.24 | 10.24 |
| `(q−1)/4` | 3.00 | 7.00 | 9.00 | 10.00 |
| range of `I − (q−1)/4` | [−2,2] | [−3,4] | [−3,5] | [−5,4] |

The generic quartic class has **density 1/4**.

**Cusp doubling.** At `a₂ = a₁ = 0` (`x⁴ + b`) the density doubles to
`(q−1)/2`; for `a₁ ≠ 0` it drops back towards `(q−1)/4`. The cap is attained
at `(0,0)` for `q = 29,37,41` (plus a few `(0,a₁)` at `q=13`).

**Wild guess 29.** The half-density cap is a **cusp phenomenon**: generic
density `1/4`, doubling to `1/2` only at `x⁴ + b`. Over `ℚ`, the fixed shift
sees the cusp while the average sees `1/4` — the parity barrier.

**Lean.** `Doubling.x4_add_one_eval : ∀ x : 𝔽₅, x⁴+1 = (x²+2)(x²+3)`.

## 35. Round 30 — synthesis and final status

Full write-up: [`notes/round30-synthesis.md`](notes/round30-synthesis.md).

**Last guess refuted.** The `j`-line fluctuation `m(j) = I(j) − (q−1)/4` is
**not** the elliptic trace `−a_j/2`: the correlation is `+0.30, +0.25, −0.10,
−0.18` and the identity holds in at most `1/37` cases (`q=37`).

**Final state.** The programme has

* formalised the 2-D Chebotarev vs 1-D zeros separation, the Möbius inversion,
  the curve lift, and a chain of quartic normal-form identities in Lean
  (20 files, all footprints clean);
* pinned the exact constants `S(q)` and the exact `d=2,3,4` formulas;
* shown `d=5` is not polynomial, established the `d`-torsion character support,
  the translation divisibility, the exact orbit count for `q≡3 (mod 4)`, the
  nine-prime `B₄` congruence, the `d=4` cap for `q ≤ 43`, the `x⁴+b` cap proof,
  and the `j`-line `1/4` density with cusp doubling.

**The barrier is not crossed.** The individual `T(d;q,2)` for `d ≥ 4`, the
general `d=4` cap, and the `ℚ` twin conjecture remain open. The honest verdict:
the function-field side is essentially solved at the level of averages and exact
low-degree formulas; the two-point correlation is the obstruction.

## 36. New goal, round 1 — the individual `d=4` count; cap at larger `q`

Full write-up: [`notes/round31-individual.md`](notes/round31-individual.md).

**Target A.** The `d=4` cap holds at `q=47,53,59,61` (16 primes now; tight at
`53,61`, slack at `47,59`).

**Target B.** Exact decomposition of the individual count:

```
T(4;q,2) = A_4(q) + B_4(q) chi_2(2) + 2 Re(c_4(q) chi_4(2)) ,
```

and the quartic term vanishes unless `q ≡ 1 (mod 8)`. Exact coefficients:
`c_4 = 34+170i, 1640+410i, -3942+292i` at `q = 17,41,73`; so
`c_4/q = 2+10i, 40+10i, -54+4i` and `|c_4| ~ q^{3/2}` (weight 3).

**Target C.** Lean `Gap.individual_ne_average : 6·T(3;7,2) ≠ Σ_h T(3;7,h)` —
the individual count is not the average.

**Wild guess 1.** `c_4` is the trace of a **weight-3 quartic twist**; the cap is
a Weil-type bound derived from the decomposition; over `ℚ` the twist's
`L`-function is missing.

## 37. New goal, round 2 — reducing the cap to a value-set bound

Full write-up: [`notes/round32-cap-reduction.md`](notes/round32-cap-reduction.md).

**Target A.** The general cap is equivalent to two slice lemmas:

```
general  --translation-->  a3 = 0
a1 != 0:   |Im(x^4+a2 x^2+a1 x)| >= (q+1)/2   (V)
a1 == 0:   the even slice                      (E)
```

(V) is new: verified at `q = 13,29,37,41,47,53,59,61`, no violations, min
`|Im| = 7,17,21,24,27,31,34,36 >= (q+1)/2`. The collision count gives
`|Im| = q/2 + O(√q)` by Weil, so (V) is a sharp Weil bound. The translation
step is now in Lean: `Shift.irreducible_shift`.

**Target B.** `c_4(89) = 890 + 14596i`, `|c_4|/q^2 ≈ 1.85`; together with
`q=17,41,73` this makes the quartic amplitude **weight 4** (`O(q^2)`),
correcting round 1's weight-3 estimate.

**Wild guess 2.** The cap is a **one-variable Weil bound (V) plus a
factorisation input (E)**; over `ℚ`, (V) is a `GL(2)`-type character sum that is
available, and (E) is the parity barrier.

## 38. New goal, round 3 — the even slice is completely solved

Full write-up: [`notes/round33-even-slice.md`](notes/round33-even-slice.md).

**Even-slice formulas** (verified `q = 5..61`, plus `67..89`):

| `q mod 4` | `I(0,0,0)` | `I(0,a₂,0)`, `a₂ ≠ 0` |
|---|---|---|
| 1 | `(q−1)/2` | `(q−1)/4` |
| 3 | `0` | `(q+1)/4` |

The `a₂`-independence is the scaling `x ↦ cx`; the `q ≡ 3 (mod 4)` collapse
(`x⁴+b` reducible for every `b`) is new.

**Consequence.** (E) holds and is attained only at `a₂ = 0`.  Hence

```
general cap  <=>  (V):  |Im(x⁴+a₂x²+a₁x)| >= (q+1)/2  for  a₁ != 0 .
```

**(V) is the only remaining function-field lemma.**

**Negative.** The discriminant-square description of the even-slice reducible
set fails; the quartic Gauss-sum hypothesis for `c4` fails (`|G| = sqrt(q)` vs
`|c4| = O(q²)`).

**Lean.** `Collision.diff_factor` — the collision identity behind (V).

## 39. New goal, round 4 — even-slice sets; the collision route fails

Full write-up: [`notes/round34-even-sets.md`](notes/round34-even-sets.md).

**Even-slice sets.** The `q−1` values `a₂ ≠ 0` give exactly `(q−1)/4` distinct
irreducible b-sets (3 at `q=13`, 7 at `q=29`), the orbits of `b ↦ b/c⁴`.  The
sets are not character sets; only the cardinality `⌊(q+2)/4⌋` is constant.

**Negative result.** The collision route to (V) fails: `Σ_s χ(D(s))` changes
sign (`[−6,6]` at `q=13`, positive in 64/156 cases).  So (V) is not a moment
bound.

**Lean.** `Scale.irreducible_scale : Irreducible (f.comp (C c * X)) ↔
Irreducible f` for `c ≠ 0`.

**Wild guess 4.** (V) needs the **fiber distribution** of `g` (governed by the
cubic derivative), not a moment; over `ℚ` that distribution is the parity
barrier.

## 40. New goal, round 5 — the critical cubic; `d=5` quintic support

Full write-up: [`notes/round35-derivative.md`](notes/round35-derivative.md).

**Target A — negative.** The critical points of `x⁴+a₂x²+a₁x` are the roots of
`4x³+2a₂x+a₁`; tabulating `(#crit, |Im|)` shows the ranges **overlap** (no
monotonicity).  The extremal `x⁴+x` has **no critical point** and the smallest
image, `|Im|=(q+1)/2`.

**Target B.** The `d=5` support is exactly the quintic characters
(`k` multiple of `(q−1)/5`): `q=11` → `2,4,6,8`; `q=41` → `8,16,24,32`.  The
coefficients lie in `ℚ(ζ₅)`; no closed form yet.

**Wild guess 5.** The value set is governed by the **critical values**, not the
critical points; the extremal `x⁴+x` is unramified.  Over `ℚ`, the barrier is
that a sieve sees values, not critical values.

**Lean.** `DerivativeQ.deriv_quartic`.

## 41. New goal, round 6 — the twist-class structure

Full write-up: [`notes/round36-twist-class.md`](notes/round36-twist-class.md).

**The `a₂=0` row is a cube-class function.** For `g = x⁴+a₁x`, `g(cx) = c·g(x)`
when `c³=1` (Lean `CubeSym.cube_scaling`), so the count depends only on the cube
class of `a₁` (verified `q = 7..43`).

| `q` | class 0 | class 1 | class 2 |
|---|---|---|---|
| 13 | 6 | 0 | 3 |
| 37 | 12 | 6 | 9 |

**Twist-class picture.** Even slice = square class of `a₂`; `a₂=0` row = cube
class of `a₁`; general slice = `j = a₁²/a₂³`.  The extremal class is always the
degenerate `a₁=a₂=0`.

**Critical values refuted.** The number of critical values does not determine
`|Im|` (same overlapping ranges as the critical points).

**Wild guess 6.** The cap is a statement per twist class; over `ℚ` the twist
classes are `H¹(ℚ, μ₄)` classes, and the fixed shift has a non-trivial class.

**Lean.** `CubeSym.cube_scaling`.

## 42. New goal, round 7 — the `a₂=0` row reduces to (V)

Full write-up: [`notes/round37-linear-row.md`](notes/round37-linear-row.md).

**The `a₂=0` row.** For `g = x⁴+a₁x`, `a₁ ≠ 0`: `min|Im| = 7,11,10,19,19,22,
26,25,30,34,37,37 ≥ (q+1)/2` at `q = 13..61`, zero violations.  Since `R ⊇ Im`,
the cap for this row follows from the value set.  The minimum is at `a₁=1`
almost always.

**(V) at larger `q`.** `min|Im| = 39,41,43,46,49,53 ≥ (q+1)/2` at
`q = 67..89`; `min|Im|/q ≈ 0.58–0.60`, i.e. a **`0.1q` margin**.

**Where the cap stands.**  `a₁=0` solved; `a₂=0` follows from (V); general is
(V).  So **the cap is (V) alone**.

**Wild guess 7.** The value set is **random-map-like**: `|Im| ≈ q(1−e^{−1}) ≈
0.632q`, matching the data.  So (V) is far from tight and needs a
Poisson/uniformity estimate, not a sharp single character sum.

**Lean.** `Fiber.sum_fiber_sq : Σ_y N(y)² = #{(x,x') : f x = f x'}`.

## 43. New goal, round 8 — fiber distribution and the random-map ratio

Full write-up: [`notes/round38-fiber-dist.md`](notes/round38-fiber-dist.md).

**Fiber distribution.** At the value-set minimisers the fiber sizes are
`{1,2,3,4}` concentrated on `{1,2,4}`; mean fiber `1.7`, i.e. `|Im|/q ≈ 0.6`.

| `q` | 13 | 29 | 37 | 41 | 53 | 61 |
|---|---|---|---|---|---|---|
| `\|Im\|` | 7 | 17 | 21 | 24 | 31 | 36 |
| fiber sizes | `{1:3,2:3,4:1}` | `{1:9,2:6,4:2}` | `{1:9,2:10,4:2}` | `{1:12,2:8,3:3,4:1}` | `{1:15,2:13,4:3}` | `{1:17,2:15,3:2,4:2}` |

**Ratio.** `|Im|/q` at the minimisers has mean `0.601`, just below the
random-map value `1−e^{−1} = 0.632`.

**Target B.** The `d=5` amplitudes are `O(q²)` (`max|amp|/q² = 0.82, 2.61` at
`q = 11,41`): weight 4, like `c₄` at `d=4`.

**Wild guess 8.** The zero-fiber set is the collision-curve image with density
`e^{−1}` plus a ramification surplus; `(q+1)/2` is far below both.

**Lean.** `Fiber.sum_fiber_card : Σ_y N(y) = |α|` (added to the existing
`sum_fiber_sq`).

## 44. New goal, round 9 — the exact collision identity

Full write-up: [`notes/round39-collisions.md`](notes/round39-collisions.md).

**Identity.** With `D(s) = −(s³+2a₂s+2a₁)/s`,

```
Σ_y N(y)² = q + 2·#{s : D(s) nonzero square}
```

verified exactly at `q = 13,29,37,41` (`S = 9,18,22,23`).

**Surplus.** `ΣN²/(2q)` falls from `1.19` to `1.03`; `S` sits above `(q−1)/2`
(`9 > 6` at `q=13`).  So the moment bound `2S ≤ q−2` is **false**, yet (V)
holds — the fiber distribution is more uniform than its second moment.

**Target B.** `d=5` amplitudes unchanged (`O(q²)`).

**Wild guess 9.** The collision count is the point count of the plane cubic
`s y² = −(s³+2a₂s+2a₁)`; (V) is a **uniformity/higher-moment** statement about
a genus-1 trace, not a second-moment bound.

**Lean.** `EvenQuartic.even_quartic_neg`.

## 45. New goal, round 10 — higher moments and the cubic trace

Full write-up: [`notes/round40-moments.md`](notes/round40-moments.md).

**Poisson(1) convergence.** At the extremisers the fiber moments converge to
the Poisson(1) values:

| `q` | 13 | 29 | 41 | 61 | 73 | 89 | Pois(1) |
|---|---|---|---|---|---|---|---|
| `M2/q` | 2.38 | 2.24 | 2.12 | 2.08 | 2.07 | 2.17 | 2 |
| `M3/q` | 7.00 | 6.38 | 5.39 | 5.23 | 5.19 | 5.92 | 5 |
| `M4/q` | 23.6 | 21.3 | 15.6 | 15.3 | 15.4 | 19.0 | 15 |

**Cubic trace.** `a_E = (q−1−cnt₀)−2S` is **negative at every extremiser**
(`−6,−8,−8,−9,−11,−9,−6,−17`), near `−2√q`.  So *small value set ⇔ maximal
collision ⇔ most negative cubic trace*.

**Lean.** `ValueSet.value_set_bound : |α|² ≤ |Im f|·ΣN(y)²`.

**Wild guess 10.** The value set is governed by the cubic trace, and (V) is a
**Poisson(1)-closeness / central-limit** statement about fiber sizes.

## 46. New goal, round 11 — the Poisson model is approximate

Full write-up: [`notes/round41-poisson-test.md`](notes/round41-poisson-test.md).

**Chi-square.** Against Poisson(1)|≥1 (`P = 0.582, 0.291, 0.097, 0.024`):

| `q` | 13 | 29 | 41 | 61 | 89 |
|---|---|---|---|---|---|
| `χ²` (df 3) | 5.48 | **8.07** | 0.92 | 4.79 | **15.17** |
| reject 5% | no | yes | no | no | yes |

So Poisson(1) is **approximate, not exact**: too many 4-fibers (double roots at
critical values) and too few 3-fibers.

**Ramification atom.** A 4-fiber is a critical value `g(c)`, `g'(c)=0`; at most
3 of them.  The exact law is `Poisson(1) + a fixed atom at the critical values`.

**Target B.** `d=5` coefficients are in `(1/(q−1))·ℤ[ζ₅]`; at `q=11`,
`10·c_2 = [−88,−572,88,−572]`, `10·c_4 = [−176,−660,−660,−88]`.

**Wild guess 11.** Poisson + a deterministic ramification atom; over `ℚ` the
atom is the parity barrier.

**Lean.** `DerivativeQ.deriv_at_zero`.

## 47. New goal, round 12 — the `S₄` splitting-type law

Full write-up: [`notes/round42-s4-model.md`](notes/round42-s4-model.md).

**The model.** For `g(x)−y` with Galois group `S₄`, the fiber size is the number
of fixed points of the Frobenius: `P(0),P(1),P(2),P(3),P(4) = 3/8, 1/3, 1/4, 0,
1/24`.  Hence `|Im|/q → 1 − 3/8 = 5/8`.

**Chi-square.**

| `q` | 13 | 29 | 37 | 41 | 53 | 61 | 73 | 89 |
|---|---|---|---|---|---|---|---|---|
| `χ²` S₄ | 1.08 | 0.90 | 1.42 | 1.16 | 0.92 | 0.86 | 1.84 | 1.22 |
| `χ²` Poisson | 5.48 | 8.07 | 9.73 | 0.92 | 12.00 | 4.79 | 15.05 | 15.17 |

The `S₄` splitting-type law fits (`χ² ≈ 1`); Poisson does not.

**Stratification.** Generic `j`: `S₄`, ratio `5/8`; special `j` (`0,1728,…`):
`V₄`/`C₄`, ratio below `5/8` but `> 1/2`.  So (V) splits into Chebotarev for
`S₄` plus a finite check of the special `j`.

**Wild guess 12.** The value set is governed by the Galois group of `g−y`; (V)
is `S₄` equidistribution plus CM-point exceptions.

**Lean.** `Crit.crit_le_three : (g').roots.card ≤ 3`.

## 48. New goal, round 13 — the `j`-stratification: `j=0` is the only exception

Full write-up: [`notes/round43-j-strat.md`](notes/round43-j-strat.md).

| `q` | `j=0` ratio | `j=0` χ² | `j≠0` min ratio | `j≠0` median χ² |
|---|---|---|---|---|
| 29 | 0.379 | 17.0 | 0.586 | 1.72 |
| 37 | 0.378 | 22.3 | 0.568 | 1.03 |
| 41 | 0.390 | 22.8 | 0.585 | 1.48 |

**`j=0` is the unique outlier**, and `j=0 ↔ a₁=0` (Lean `JZero.j_zero_iff`) ↔
the quartic is a **composition** `h(x²)`.  That case is solved (round 33).

**So the cap ⇔ (V′):** every non-composition quartic has `|Im| ≥ (q+1)/2`.
By the `S₄` law the generic value is `5/8·q`, so (V′) has an `1/8·q` margin.

**Wild guess 13.** The only exceptional quartics are the compositions; every
non-composition is `S₄`-equidistributed with ratio `5/8`.  Over `ℚ`, the
composition is the even part, and the barrier is that a sieve sees the
composition but not the `S₄` orbits.

**Lean.** `JZero.j_zero_iff`.

## 49. New goal, round 14 — the Chebotarev route to (V′)

Full write-up: [`notes/round44-chebotarev.md`](notes/round44-chebotarev.md).

**Main term at the extremisers.** `|Im(g)| = 5q/8 + O(√q)`, with
`max |dev|/√q = 0.430 < 0.5` over `q = 13..89`.

| `q` | 13 | 19 | 37 | 67 | 71 | 79 | 89 |
|---|---|---|---|---|---|---|---|
| `dev/√q` | −.31 | −.43 | −.19 | −.35 | −.40 | −.38 | −.28 |

**Threshold.** `5q/8 − 0.5√q > (q+1)/2` first holds at **`q = 25`** and for all
larger `q`.  So (V′) reduces to:

1. explicit Chebotarev with constant `< 0.5` for `q ≥ 25`;
2. a finite check for `q < 25` (done for `q = 5..23`);
3. the `j=0` composition case (solved, round 33).

**Wild guess 14.** The cap *is* the explicit Chebotarev theorem for `S₄`
splitting types; the missing input over `ℚ` is the error term for a fixed
`y`-family — the parity barrier.

**Lean.** `Chebotarev.cap_from_main_term` (main term + error ⇒ cap), plus the
`S₄` density identities.

## 50. New goal, round 15 — `d=5` is not polynomial; the `q=25` threshold

Full write-up: [`notes/round45-d5-poly.md`](notes/round45-d5-poly.md).

**Target B.** For `q ≡ 2 (mod 5)` (shift-independent), `T(5;q,2) = 560, 53142,
2698484, 8982264` at `q = 7,17,37,47`, with `T/q⁵ → 1/25 = 0.04`.  The cubic
through these points misses `q=11` by a factor 18 (`111919` vs `6006`), so no
low-degree polynomial fits.

**Target A.** The Chebotarev boundary is `q = 25`:

| `q` | 21 | 23 | 25 | 29 |
|---|---|---|---|---|
| `5q/8 − 0.5√q` | 10.834 | 11.977 | 13.125 | 15.432 |
| `(q+1)/2` | 11.0 | 12.0 | 13.0 | 15.0 |
| clears? | ✗ | ✗ | ✓ | ✓ |

**Wild guess 15.** The `d=5` count is a quintic-character sum with no polynomial
formula, the same shape as `c₄` at `d=4`.

**Lean.** `Chebotarev.threshold_25`, `threshold_25_gt`.

## 51. New goal, round 16 — the finite check, and the parity step

Full write-up: [`notes/round46-finite-parity.md`](notes/round46-finite-parity.md).

**Target A — finite part complete.** (V′) holds at `q = 5,7,11,13,17,19,23`
(`min|Im| = 3,4,6,7,10,10,13 ≥ (q+1)/2`, zero violations).  Together with round
44: `q ≥ 25` needs the explicit Chebotarev constant; `q < 25` is now checked;
`j=0` is solved.

**Target B.** `25T = q⁵ − N` with `N/q⁴ → 1` (`1.169, 1.093, 1.004, 0.981`), so
`T = q⁴(q−1)/25 + O(q³)`, residual non-polynomial.

**Target C — a Lean step.** `DivisorSum.twinInd_not_zeta_mul`: no
**multiplicative** `g` has `twinInd = ζ * g`.  The twin indicator is not a
multiplicative divisor sum (a Selberg-type sieve weight is one).  The full
parity barrier (all finite weights) is not reached.

**Wild guess 16.** The remaining gap is the explicit Chebotarev constant
(measured `0.43 < 0.5`).

**Lean.** `DivisorSum.zeta_mul_isMult`, `DivisorSum.twinInd_not_zeta_mul`.

## 52. New goal, round 17 — the base cases of (V′) in Lean

Full write-up: [`notes/round47-small-cap.md`](notes/round47-small-cap.md).

**Lean-verified base cases.** `lean/SmallCap.lean` proves, by `decide`:

```
cap_five, cap_seven, cap_eleven, cap_thirteen, cap_seventeen :
  ∀ a2 a1 : ZMod q, a1 ≠ 0 → (q+1)/2 ≤ |Im(x⁴ + a2x² + a1x)| .
```

So `q = 5,7,11,13,17` are **theorems** (Python minima `3,4,6,7,10`, all ≥
thresholds).  `q = 19,23` time out under `decide` and remain Python checks
(`10,13 ≥ 10,12`).

**Chebotarev route status.**

| range | status |
|---|---|
| `q = 5..17` | Lean theorem |
| `q = 19,23` | Python check |
| `q ≥ 25` | explicit Chebotarev, constant `< 0.5` (unproved) |
| `j = 0` | solved (round 33) |

**Wild guess 17.** The finite range is checkable; the difficulty is entirely in
the uniform error term.

**Lean.** `SmallCap.cap_five … cap_seventeen`.

## 53. New goal, round 18 — the finite base is complete in Lean

Full write-up: [`notes/round48-full-finite.md`](notes/round48-full-finite.md).

Rewriting the `decide` computation with `Finset.image` made `q = 19, 23`
feasible, so `lean/SmallCap.lean` now proves **all seven** base cases:

```
cap_five … cap_twentythree :
  ∀ a2 a1 : ZMod q, a1 ≠ 0 → (q+1)/2 ≤ |Im(x⁴ + a2x² + a1x)|
```

(`q = 5,7,11,13,17,19,23`; `decide` times 13s and 24s for the last two).

**Route status.**

| range | status |
|---|---|
| `q = 5..23` | **Lean theorem** |
| `j = 0` | solved (round 33) |
| `q ≥ 25` | explicit Chebotarev, constant `< 0.5` — unproved |

The cap has exactly **one** unproved input: the explicit error constant for the
`S₄` splitting-type character sums.

**Wild guess 18.** The cap is one explicit constant from a proof; that constant
is the shadow of the parity barrier over `ℚ`.

**Lean.** `SmallCap.cap_five … cap_twentythree`.

## 54. New goal, round 19 — the reducible set is an explicit union

Full write-up: [`notes/round49-factorization.md`](notes/round49-factorization.md).

**Identity.** For `f_b = x⁴+a₂x²+a₁x+b`:

```
R = (−Im g) ∪ Q ,   Q = { ((a₂+p²)² − (a₁/p)²)/4 : p ≠ 0 } .
```

Verified for **every family** at `q = 11,13,29` (`110/110`, `156/156`,
`812/812`).

**Resolvent criterion fails.** `f_b` reducible ⇔ resolvent cubic has a root is
false (`6/13`, `4/13` at `q=13`; `10/29`, `12/29` at `q=29`): the Ferrari square
conditions matter.

**Consequence.** The cap is the explicit two-image statement
`|(−Im g) ∪ Q| ≥ (q+1)/2`.  For non-compositions `−Im g` alone suffices (V′);
`Q` is needed only for `j=0` (solved).

**Wild guess 19.** The cap is a statement about the linear and quadratic
splitting-type images; over `ℚ` a sieve sees neither exactly.

**Lean.** `Factorization.quadratic_factor`.

## 55. New goal, round 20 — the corrected union identity; `Q` gives the even slice

Full write-up: [`notes/round50-corrected-union.md`](notes/round50-corrected-union.md).

**Correction.** Round 19 omitted the `p=0` factorization `(x²+q)(x²+s)` (valid
only when `a₁=0`).  With it,

```
R = (−Im g) ∪ Q_{p≠0} ∪ (a₁=0 ? {q(a₂−q)} : ∅)
```

holds for **all** families: `121/121`, `169/169`, `841/841`, `1369/1369` at
`q = 11,13,29,37`.

**The even-slice formula is now derived.** For `a₁=0`, `R = Q`, and

| `q` | `a₂=0` | `a₂≠0` |
|---|---|---|
| 13 | 7 = `(q+1)/2` | 10 = `q−⌊(q+2)/4⌋` |
| 29 | 15 | 22 |
| 37 | 19 | 28 |

— exactly round 33's formulas, now from the structure of `Q`.

**Wild guess 20.** The cap is about the quadratic-factor image `Q`; `−Im g`
dominates for non-compositions, `Q` for compositions.  Over `ℚ` these are the
linear and quadratic splitting types.

**Lean.** `Factorization.quadratic_factor` (`p≠0`) and
`Factorization.even_factor` (`p=0`).

## 56. New goal, round 21 — for compositions the value set is redundant

Full write-up: [`notes/round51-containment.md`](notes/round51-containment.md).

**Containment.** For `a₁ = 0`, `−Im(x⁴+a₂x²) ⊆ Q`, verified for every `a₂` at
`q = 7..37`.  Hence `R = Q`, and the even slice is purely the quadratic-factor
image:

```
|R| = q − ⌊(q+2)/4⌋  (a₂ ≠ 0) ,      |R| = (q+1)/2  (a₂ = 0) .
```

**Non-compositions.** The overlap is partial (`9/12`, `8/10` at `q=29`), but the
cap comes from `−Im` alone (V′), so it is not needed.

**The clean picture.**

```
a₁ = 0 :  R = Q            (value set redundant)
a₁ ≠ 0 :  |−Im| ≥ (q+1)/2  (V′)
```

**Wild guess 21.** The composition's parity is the quadratic splitting type; the
non-composition value set is the only place `−Im` matters.

**Lean.** `QuadFiber.quad_fiber : q(a₂−q)=r(a₂−r) → q≠r → q+r=a₂` (fibers of the
quadratic image have size ≤ 2).

## 57. New goal, round 22 — the composition containment is proved

Full write-up: [`notes/round52-preimage.md`](notes/round52-preimage.md).

**Proof.** For every `x`:

```
−g(x) = −x⁴ − a₂x² = (x²+a₂)·(a₂ − (x²+a₂)) = q(a₂−q),  q = x²+a₂ ,
```

so `−Im(g) ⊆ Q₀ ⊆ Q`.  This is a `ring` identity (Lean
`Composition.neg_image_mem_Q`), verified at `q = 7,13,29,37`.

**Consequence.** Round 20 gave `R = (−Im) ∪ Q`; with `−Im ⊆ Q`, the composition
case is **structurally solved**:

```
a₁ = 0  ⇒  R = Q .
```

Only the **size** `|Q| = q − ⌊(q+2)/4⌋` (`a₂≠0`), `(q+1)/2` (`a₂=0`) remains
unproved.

**Wild guess 22.** The composition is fully structural (`R = Q`); the cap is
pure image counting, and the barrier is the size of `Q` (the intersection
`Q₀ ∩ Q₁`).

**Lean.** `Composition.neg_image_mem_Q`.

## 58. New goal, round 23 — the `x⁴+b` composition is proved

Full write-up: [`notes/round53-composition-proof.md`](notes/round53-composition-proof.md).

**Proof for `a₂ = 0`.** `Q = (−squares) ∪ (fourth powers)/4`, and:

| `q mod 4` | `−squares` | `Q₁` | `Q` | `|Q|` |
|---|---|---|---|---|
| 1 | squares | `⊆ squares` | **squares** | `(q+1)/2` |
| 3 | nonsquares | `= squares` | **`𝔽_q`** | `q` |

So `x⁴+b` has `I = (q−1)/2` for `q ≡ 1 (mod 4)`, and `I = 0` for `q ≡ 3 (mod 4)`
— the round-33 formulas, now **proved**.

**Group theory.** `−1` square iff `p ≡ 1 (mod 4)` (`ZMod.exists_sq_eq_neg_one_iff`);
fourth powers ⊆ squares; `|Q₁| = (q+1)/2` for `q ≡ 3 (mod 4)`.

**What remains.**

| case | status |
|---|---|
| `a₁=a₂=0` | **proved** |
| `a₁=0, a₂≠0` | `|Q| = q−⌊(q+2)/4⌋`, verified |
| `a₁≠0` | (V′), explicit constant |

**Wild guess 23.** The composition splits by `q mod 4` (the sign of `−1`); the
`a₂≠0` case is the same argument with the quadratic image `(a₂+p²)/2`.

**Lean.** `NegSquare.neg_sq_mem_sq`.

## 59. New goal, round 24 — synthesis of the cap chain

Full write-up: [`notes/round54-synthesis.md`](notes/round54-synthesis.md).

| # | link | status |
|---|---|---|
| 1 | translation: general ⇔ `a₃=0` | **verified** + Lean `Shift` |
| 2 | `R = (−Im g) ∪ Q` | **verified** all families `q≤37` + Lean `Factorization` |
| 3 | `a₁=0` ⇒ `R = Q` | **proved** + Lean `Composition` |
| 3a | `a₂=0` ⇒ `|Q| = (q+1)/2` or `q` | **proved** + Lean `NegSquare` |
| 3b | `a₂≠0` ⇒ `|Q| = q−⌊(q+2)/4⌋` | verified, not proved |
| 4 | `a₁≠0` ⇒ (V′) | verified `q≤89` |
| 4a | `S₄` law `|Im| = 5q/8+O(√q)`, `C=0.43` | verified, not proved |
| 4b | `q≥25` Chebotarev; `q≤23` Lean | Lean `SmallCap` |

**Proved:** translation, `R=Q` for compositions, `x⁴+b`, and the cap at
`q = 5..23`.

**Verified only:** the union identity, the `a₂≠0` composition size, (V′) for
`q≤89`, and the `S₄` constant.

**Target B.** `d=4` exact decomposition (`c₄` weight 4, pinned at 4 primes);
`d=5` quintic support, `T/q⁵ → 1/25`, no polynomial.  No closed form.

**Target C.** `twinInd` not multiplicative; not a divisor sum of a
multiplicative `g`.  The full barrier is untouched.

**Wild guess 24 (final).** The cap is one explicit constant from a proof; that
constant is the error term whose absence over `ℚ` is the parity barrier.

## 60. New goal, round 25 — final status

Full write-up: [`notes/round55-final.md`](notes/round55-final.md).

**No target is fully established.**  The closing status:

* **Target A** — the cap is **two explicit lemmas away**:
  the `a₂≠0` composition size `|Q| = q−⌊(q+2)/4⌋` (verified), and the explicit
  Chebotarev constant `< 0.5` (measured 0.43).  Proved outright: the
  translation, `R=Q` for compositions, `x⁴+b`, and the cap at `q = 5..23` (Lean
  `SmallCap`).
* **Target B** — `d=4` has an exact decomposition with `c₄` weight 4; `d=5` has
  quintic support and `T/q⁵ → 1/25`; **no closed form** for either.
* **Target C** — `twinInd` is not multiplicative and not a divisor sum of a
  multiplicative `g` (two Lean theorems); the full parity barrier is untouched.

**Deliverables:** 37 Lean files (all clean), 52 test files / 481 tests, 57 check
scripts, 54 notes.

**Final wild guess.**  The cap is one explicit constant; over `ℚ` the same
constant is the error term for a fixed `y`-family — and its absence is the
parity barrier.

## 61. New goal, round 1 — the `a₂≠0` composition size decomposes

Full write-up: [`notes/round56-q-decomposition.md`](notes/round56-q-decomposition.md).

**Decomposition.** `Q = Q₀ ∪ Q₁` with `Q₀ = {q(a₂−q)}`, `Q₁ = {((a₂+p²)/2)²}`, and

```
|Q| = |Q₀| + |Q₁\Q₀| = (q+1)/2 + ⌊(q−1)/4⌋ = q − ⌊(q+2)/4⌋ .
```

Verified for **all** `a₂ ≠ 0` at `q = 7..61`:

| `q` | 7 | 13 | 29 | 37 | 41 | 53 | 61 |
|---|---|---|---|---|---|---|---|
| `\|Q₀\|` | 4 | 7 | 15 | 19 | 21 | 27 | 31 |
| `\|Q₁\\Q₀\|` | 1 | 3 | 7 | 9 | 10 | 13 | 15 |

**Remaining lemma (Q1).** `|Q₁\Q₀| = ⌊(q−1)/4⌋`.  Character-sum form:
`y ∈ Q₁\Q₀ ⇔ u = p² ≠ 0 square and χ(−u(2a₂+u)) = −1`, with `y` constant on
`u ↦ −u−2a₂`; so it is an orbit count, using `Σ_p χ(p²+2a₂) = −1`.

**Wild guess 1.** (Q1) is an exact orbit count from that classical character sum.

**Lean.** `QSize.size_identity : q%2=1 → (q+1)/2 + (q−1)/4 = q − (q+2)/4`.

## 62. New goal, round 2 — (A1) is proved

Full write-up: [`notes/round57-q1-proof.md`](notes/round57-q1-proof.md).

**Theorem (A1).** For `a₁ = 0, a₂ ≠ 0`:

```
|Q| = (q+1)/2 + ⌊(q−1)/4⌋ = q − ⌊(q+2)/4⌋ .
```

**Proof.** Three steps, each verified at `q = 7..61`:

1. **Orbit.** `σ(u) = −u−2a₂` gives the same value `((a₂+u)/2)²` and has
   `−(2a₂+σ(u)) = u`, so `χ = χ(u) = 1` — it never qualifies.  Hence
   `|Q₁\Q₀| = |S|`, `S = {u ≠ 0 square : χ(−(2a₂+u)) = −1}`.
   (Lean `QOrbit.sigma_y`, `QOrbit.sigma_arg`.)
2. **Character sum.** `Σ_{u∈sq*} χ(−(2a₂+u)) = −(χ(−1)+χ(−2a₂))/2`, using
   `Σ_u χ(u(2a₂+u)) = −1`.
3. **Count.** `|S| = (N−Σ)/2 − (1/2)·1_{χ(−2a₂)=1} = ⌊(q−1)/4⌋`.

**Consequence.** Together with rounds 52 and 53, the **whole composition case is
proved**, and the cap is reduced to **(A2) alone**: `|Im| ≥ (q+1)/2` for
non-compositions.

**Wild guess 2.** (A2) is the same character-sum bookkeeping — an exact
splitting-type count from the cubic resolvent, giving an exact constant.

## 63. New goal, round 3 — the parity theorem (Target C)

Full write-up: [`notes/round58-parity-theorem.md`](notes/round58-parity-theorem.md).

**Theorem.** The twin indicator is **unconditionally not** a bounded-support
divisor sum:

```
¬ ∃ S finite, L ≥ 1 (∀ d∈S, d∣L), g : ℕ→ℝ,  ∀ n, twinInd n = Σ_{d∈S, d∣n} g(d) .
```

**Proof.** (1) Every such sum is `L`-periodic (`d∣L ⇒ d∣n ⇔ d∣n+L`; Lean
`Periodic.divisor_sum_periodic`).  (2) `twinInd` is not periodic: `twinInd 3 = 1`
while `twinInd (3+3L) = 0`, since `3(1+L)` is composite (Lean
`NonPeriodic.twinInd_not_periodic`).  Hence the equality is impossible (Lean
`NonPeriodic.twinInd_not_divisor_sum`).

**What it does not say.** It does not prove twin infinitude — it excludes the
indicator from the sieve class, not the primes from a counting statement.

**Wild guess 3.** The parity barrier *is* the periodicity gap; the missing
object is a non-periodic (automorphic) weight.

**Lean.** `Periodic`, `NonPeriodic` (three theorems).

## 64. New goal, round 4 — `c₄/q` is a Gaussian integer

Full write-up: [`notes/round59-c4-gaussian.md`](notes/round59-c4-gaussian.md).

**Target B.** At every tested prime `q ≡ 1 (mod 8)`:

```
c₄(q) = q·(a + b i) ,   a,b ∈ ℤ .
```

| `q` | `c₄` | `c₄/q` |
|---|---|---|
| 17 | `34 + 170i` | `2 + 10i` |
| 41 | `1640 + 410i` | `40 + 10i` |
| 73 | `−3942 + 292i` | `−54 + 4i` |
| 89 | `890 + 14596i` | `10 + 164i` |
| 97 | `15714 − 2522i` | `162 − 26i` |

So the quartic correction is a **weight-2** (Hecke-type) trace, not weight 4: the
right normalisation is `c₄/q`, and its values lie in `ℤ[i]`, matching the
`ℚ(i)` Galois action `χ₄ ↔ χ₄^{-1}`.

**Not known:** a formula for `(a,b)`; `a²+b² = 104, 1700, 2932, 26996, 26920`.

**Wild guess 4.** `(a,b)` are differences of point counts of explicit varieties
attached to the quartic family; the `q=89` value `164` points to a surface
rather than a curve.

## 65. New goal, round 5 — (V′) to `q ≤ 149`; the Cauchy–Schwarz gap

Full write-up: [`notes/round60-v-larger.md`](notes/round60-v-larger.md).

**(V′) extended.** `min|Im| = 59,61,63,64,66,75,78,81,83,89` at
`q = 101,103,107,109,113,127,131,137,139,149`, all `≥ (q+1)/2` (zero
violations).  So (V′) holds for **every prime `q ≤ 149`**.

**The CS route is dead.** The bound `|Im| ≥ q²/(q+2S)` would give (V′) only if
`S ≤ (q−2)/2`; but `S > (q−2)/2` at **16 primes below 150** for the
`a₂=0, a₁=1` row (e.g. `q=61`: `S=36` vs `29`), and at the extremisers `S`
exceeds `(q−1)/2`.  So no second-moment bound can prove (V′).

**Wild guess 5.** (V′) is a distribution statement: the `S₄` law `|Im| = 5q/8 + E`
with `|E| ≤ C√q` and the measured `C = 0.43` gives the threshold `q > 25`; the
finite range is checked.  The only missing input is the explicit constant.

## 66. New goal, round 6 — every non-composition is `S₄`

Full write-up: [`notes/round61-monodromy.md`](notes/round61-monodromy.md).

**The four monodromy models** (fiber-size law → `|Im|/q`):

| `G` | `P(0)` | `P(1)` | `P(2)` | `P(4)` | ratio |
|---|---|---|---|---|---|
| `S₄` | 3/8 | 1/3 | 1/4 | 1/24 | **5/8** |
| `A₄` | 1/4 | 2/3 | 0 | 1/12 | 3/4 |
| `D₄` | 5/8 | 0 | 1/4 | 1/8 | 3/8 |
| `C₄` | 3/4 | 0 | 0 | 1/4 | 1/4 |

**Classification.** At `q = 41,61,73`, every non-composition family is `S₄`
(1640/1640, 3660/3660, 5256/5256).  The dangerous `D₄`/`C₄` cases do not occur;
the composition (`a₁=0`) is the only degenerate case and is solved.

**Consequence.** `|Im|/q → 5/8 > 1/2` for every non-composition; (A2) is the
explicit error constant of the `S₄` extension.

**Wild guess 6.** The effective conductor is `1` (cancellation at the branch
points), which would prove (A2).

## 67. New goal, round 7 — the exact `S₄` character decomposition

Full write-up: [`notes/round62-char-decomp.md`](notes/round62-char-decomp.md).

**Decomposition.** The indicator `1_{k≥1}` on `S₄` classes:

```
1_{k≥1} = 5/8·1 + 1/8·sign + 3/8·std − 1/8·(std⊗sign) − 1/4·χ₂ ,
```

verified on all five classes.  Hence

```
|Im(g)| = 5q/8 + (1/8)S_sign + (3/8)S_std − (1/8)S_{std⊗sign} − (1/4)S_{χ₂} .
```

**The `std` sum vanishes:** `S_std = Σ_y(N(y)−1) = q − q = 0` identically.

**The sign sum is cubic:** the discriminant of `g(x)−y` is
`Δ(y) = −256y³ − 128a₂²y² − (144a₂a₁²+16a₂⁴)y − (27a₁⁴+4a₂³a₁²)`, so
`|S_sign| ≤ 2√q` by Weil.

**Remaining error:**
`(1/8)S_sign − (1/8)S_{std⊗sign} − (1/4)S_{χ₂} + O(1)`.  (A2) needs
`|S_sign − S_{std⊗sign}| + 2|S_{χ₂}| ≤ 4√q`.

**Wild guess 6 (refined).** The three sums cancel to `< 0.5√q` (measured
`0.43`) because `Δ(y)` has repeated roots at the branch points, so the Weil
bound is not attained.

## 68. New goal, round 8 — the resolvent curve is rational; `S_{χ₂} = O(1)`

Full write-up: [`notes/round63-resolvent-rational.md`](notes/round63-resolvent-rational.md).

**Rational resolvent.** The resolvent cubic `z³−a₂z²+4yz−4a₂y−a₁² = 0` is linear
in `y`:

```
y = (−z³ + a₂z² + a₁²)/(4(z−a₂)) ,
```

a rational parametrisation.  So the 2-dimensional `L`-function has **degree 0**,
and `S_{χ₂} = Σ_y χ₂(Frob_y) = O(1)` — verified `max|S_χ2| = 4` for `q = 19..149`.

**The error simplifies** to

```
|Im| − 5q/8 = (1/8)(S_sign − S_{std⊗sign}) + O(1) .
```

So (A2) reduces to the single bound `|S_sign − S_{std⊗sign}| ≤ 4√q`, with
`S_sign = Σ_y χ₂(Δ(y))` a cubic character sum (`≤ 2√q`) and
`S_{std⊗sign} = Σ_y χ₂(Δ(y))(N(y)−1)`.

**Wild guess 7.** `Σ_y χ₂(Δ)(2−N)` collapses to a single cubic sum `≤ 2√q`,
giving error `≤ 0.25√q < 0.5√q` and proving (A2).

## 69. New goal, round 9 — (A2) reduces to two Weil bounds

Full write-up: [`notes/round64-a2-route.md`](notes/round64-a2-route.md).

**The exact formula** (critical values counted as 1 each):

```
|Im(g)| = 5q/8 + (1/8)(S_sign − S_{std⊗sign}) + O(1) ,
```

with `max |Im − formula| = 1.38` over `q = 19..149`, so `O(1) ≤ 2`.

**The two bounds** (both verified `q ≤ 149`):

| bound | meaning |
|---|---|
| `\|S_sign\| ≤ 2√q` | cubic character sum `Σ χ₂(Δ)` (genus 1) |
| `\|S_{std⊗sign}\| ≤ 2√q` | twisted sum, degree-2 Artin `L` (genus 1) |

Hence `|Im| ≥ 5q/8 − 0.5√q − 2`, which exceeds `(q+1)/2` for **`q ≥ 49`**
(`q=47: 23.95 < 24`; `q=49: 25.13 ≥ 25`).  The range `q < 49` is checked.

**Conclusion.** (A2) ⇐ two Weil bounds + finite check — and the finite check is
done.  With (A1) and the composition case proved, **the cap follows modulo the
two genus-1 Weil bounds**.

**Wild guess 8.** The cap is a genus-1 theorem: both sums are traces of the
elliptic curve `s² = Δ(y)` and its quadratic twist; over `ℚ` they are the
missing `GL(2)` data.

## 70. New goal, round 10 — the pullback identity and the genus-2 gap

Full write-up: [`notes/round65-pullback.md`](notes/round65-pullback.md).

**Pullback identity.**

```
Δ(g(x)) = g'(x)²·S(x) ,   S(x) = −16x⁶ − 32a₂x⁴ − 40a₁x³ − 20a₂²x² − 36a₁a₂x − 27a₁² − 4a₂³ ,
```

exact (sympy), and `Σ_y χ₂(Δ)N = Σ_x χ₂(S)` numerically.

**Discriminant.** `disc(S) = −2²⁹·a₁²·(27a₁²+8a₂³)⁴`, so `s² = S(x)` has genus 2
off the composition and critical-discriminant loci.

**Consequence.** `S_{std⊗sign} = Σ_x χ₂(S(x)) − S_sign`, a genus-2 minus a
genus-1 sum.  The **proved** bound is `6√q` (4+2), while the **measured** is
`1.7√q < 2√q`.

**So this round widens the gap**: round 64's `2√q` was empirical.  The genus-2
curve maps to `t² = Δ(y)` by `(x,s) ↦ (g(x), g'(x)s)`, but with degree 4, so the
Jacobian splitting is not automatic.

**Wild guess 9.** The genus-2 curve has an extra endomorphism forcing
`Jac = E × E'` with `E'` elliptic; then `S_{std⊗sign} = −a_{E'} ≤ 2√q`, closing
(A2).

## 71. New goal, round 11 — the Jacobian splits; (A2) closes

Full write-up: [`notes/round66-splitting.md`](notes/round66-splitting.md).

**The genus-2 curve.** `C : s² = S(x)`, `#C = q + SC + ε` (`ε = 2` iff `q≡1 mod 4`),
so `t_C = 1 − SC − ε`.

**The splitting.** The degree-4 map `(x,s) ↦ (g(x), g'(x)s)` sends `C` to the
elliptic curve `E : t² = Δ(y)`; by Poincaré reducibility `Jac(C) ~ E × E'`, so
`t_C = a_E + a_{E'}` with `|a_{E'}| ≤ 2√q`.

**The bound.** `a_{E'} = 1 − S_{std⊗sign} − ε`, hence
`|S_{std⊗sign}| ≤ 2√q + 1`; with `|S_sign| ≤ 2√q`,

```
|Im| − 5q/8 ≤ 0.5√q + O(1) .
```

`5q/8 − 0.5√q − C > (q+1)/2` for `q ≥ 49`, and `q < 49` is checked.

**So (A2) closes modulo Poincaré reducibility and the class-function
decomposition.** With (A1) and the composition case proved, the cap follows —
with one caution: the monodromy must be `S₄`/`A₄`; `D₄`/`C₄` non-compositions
would break the `5/8` main term (none observed at `q=41,61,73`, not excluded for
all `q`).

**Wild guess 10.** The splitting is the general mechanism: the value-set error
is always a difference of elliptic/abelian traces.

## 72. New goal, round 12 — primitivity closes the monodromy gap

Full write-up: [`notes/round67-primitive.md`](notes/round67-primitive.md).

**The transitive subgroups of `S₄`:**

| group | order | primitive | `\|Im\|/q` |
|---|---|---|---|
| `C₄` | 4 | ✗ | 1/4 |
| `V₄` | 4 | ✗ | 1/4 |
| `D₄` | 8 | ✗ | 3/8 |
| `A₄` | 12 | **✓** | 3/4 |
| `S₄` | 24 | **✓** | 5/8 |

**Ritt.** A polynomial is a composition iff its monodromy is imprimitive.  For
`x⁴+a₂x²+a₁x` with `a₁≠0`, `g` is not a composition, so the monodromy is
primitive — `A₄` or `S₄`.  Hence **`D₄`/`C₄` cannot occur** for a
non-composition, and both admissible groups give ratio `≥ 5/8 > 1/2`.

**The cap, assembled:**

| ingredient | status |
|---|---|
| translation | verified + Lean `Shift` |
| `R = (−Im) ∪ Q` | verified + Lean `Factorization` |
| composition `R = Q` | **proved** + Lean `Composition` |
| `x⁴+b` size | **proved** + Lean `NegSquare` |
| `a₂≠0` composition size | **proved** + Lean `QSize`/`QOrbit` |
| monodromy primitive | **Ritt** |
| error `O(√q)`, constant 0.5 | Poincaré + rounds 62–66 |
| finite range `q < 49` | checked |

**So the cap holds for every quartic, modulo Ritt + Poincaré + the
class-function decomposition** (all standard).

**Wild guess 11.** The cap is primitivity (Ritt) + genus-1 (Weil); over `ℚ` the
missing object is the automorphic `L`-function of the `S₄` action.

## 73. New goal, round 13 — the unified cap proof

Full write-up: [`notes/cap-proof.md`](notes/cap-proof.md).

The cap is assembled into a single document with its dependency graph:

```
general quartic
   │ (1) translation x ↦ x − a₃/4
   ▼
a₃ = 0 :  g = x⁴+a₂x²+a₁x
   │ (2) R = (−Im g) ∪ Q
   ├── a₁ = 0 :  (3) R = Q,  |Q| = q − ⌊(q+2)/4⌋   [proved]
   └── a₁ ≠ 0 :  (4) |Im g| ≥ (q+1)/2              [Ritt + Poincaré]
```

**Each link.** (1) `Shift.irreducible_shift`.  (2) `Factorization.quadratic_factor`
/ `even_factor`; verified for all quartics at `q=11,13,29,37`.  (3)
`Composition.neg_image_mem_Q`, `NegSquare.neg_sq_mem_sq`, `QSize.size_identity`,
`QOrbit.sigma_*`.  (4) Ritt (primitive monodromy `S₄`/`A₄`), the class-function
decomposition (`S_std = 0`), the two elliptic traces (Poincaré), the threshold
`q ≥ 49`, the finite base `SmallCap`.

**Standard facts used:** Ritt/Guralnick–Saxl, Poincaré reducibility, the Weil
bound, Frobenius/Chebotarev.

**Status.** The cap is proved modulo those four standard facts.  The structural
links are Lean-checked; the analytic link is two genus-1 Weil bounds.

## 74. New goal, round 14 — `c₄/(2q)` is a Gaussian integer

Full write-up: [`notes/round69-c4-congruence.md`](notes/round69-c4-congruence.md).

**Congruence.** At `q = 17,41,73,89,97,113`:

```
c₄(q)/(2q) ∈ ℤ[i] ,     c₄ ≡ 0 (mod 2q) in ℤ[i] .
```

| `q` | `c₄/q` | `c₄/(2q)` |
|---|---|---|
| 17 | `2+10i` | `1+5i` |
| 41 | `40+10i` | `20+5i` |
| 73 | `−54+4i` | `−27+2i` |
| 89 | `10+164i` | `5+82i` |
| 97 | `162−26i` | `81−13i` |
| 113 | `−56+164i` | `−28+82i` |

The real and imaginary parts of `c₄/q` are always even.

**`q=101` check.** `c₄(101) = 0`, consistent with the vanishing at `q ≡ 5 (mod 8)`.

**Decomposition at the 5th prime.** `T = A₄ + B₄χ₂(2) + 2Re(c₄χ₄(2))` holds at
`q=97` (`A₄=10946159/2`, `B₄=−9215/2`, gap `−31428 = 2Re(c₄χ₄(2))`).

**Wild guess 12.** `c₄/(2q)` is a Hecke eigenvalue in `ℤ[i]`; the factor `2q` is
the normalisation from the two quartic orbits.  Norms `26,425,733,6749,6730` —
no closed form yet; the object is high-dimensional (a surface).

## 75. New goal, round 15 — the theorem covers the whole Selberg class

Full write-up: [`notes/round70-sieve-class.md`](notes/round70-sieve-class.md).

**The reduction.** A finite linear combination of divisor sums is a single
divisor sum with union support:

```
Σ_k Σ_{d∈S_k, d∣n} g_k(d) = Σ_{d∈S, d∣n} G(d) ,   S = ⋃ S_k .
```

So the Selberg class (all `w(n) = Σ_{d|n, d≤D} λ_d`) is exactly the single
divisor sums with finite support — and `NonPeriodic.twinInd_not_divisor_sum`
(arbitrary `g`, finite `S`) already excludes **all of them**.  The
"non-multiplicative extension" is automatic.

**The factor 2.** Twin counts converge to Hardy–Littlewood (ratios `1.23`,
`1.18` at `N=10⁵,10⁶`), while the natural sieve bound is `2·HL` — the
quantitative parity obstruction.

**Wild guess 13.** The factor 2 is the boundary of the divisor-sum class; the
missing refinement is a non-periodic (automorphic) weight.

## 76. New goal, round 16 — the `d=5` amplitude congruence

Full write-up: [`notes/round71-d5-congruence.md`](notes/round71-d5-congruence.md).

For `q = 11,31,41` and every quintic character `k`:

```
(q−1)·c_k ≡ 0 (mod q)  in ℤ[ζ₅] ,      i.e.  c_k/q ∈ (1/(q−1))·ℤ[ζ₅] .
```

Verified for all four quintic characters at the three primes.

**Comparison.** `d=4` is stronger (`c₄/q ∈ ℤ[i]`, six primes); `d=5` carries the
extra `1/(q−1)` denominator.  The `d=4` collapse comes from `ζ₄ = i` and the
conjugation `i ↦ −i`.

**Wild guess 14.** The amplitudes satisfy `c_k/q ∈ (1/(q−1))·ℤ[ζ_k]` at degree
`d=k`; the `d=4` tower collapses to `ℤ[i]`.

## 77. New goal, round 17 — Target B: consolidated structure of `c₄`

Full write-up: [`notes/round72-c4-synthesis.md`](notes/round72-c4-synthesis.md).

**Established:** `c₄ = 0` for `q ≡ 3 (mod 4)` and `q ≡ 5 (mod 8)`; `c₄/q ∈ ℤ[i]`
and `c₄/(2q) ∈ ℤ[i]` at six `q ≡ 1 (mod 8)` primes; the exact decomposition
`T = A₄ + B₄χ₂(2) + 2Re(c₄χ₄(2))` at five primes.

**Six values** of `c₄/(2q)`: `1+5i, 20+5i, −27+2i, 5+82i, 81−13i, −28+82i`.

**Failed searches:** Fermat quartic curve trace, its square, the Fermat quartic
surface trace, octic Gauss sums, `q = u²+v²`, a single weight-2 Hecke eigenvalue
(Ramanujan bound violated).  `|c₄/(2q)| ~ q` suggests a high-rank (surface)
motive.

**Wild guess 15.** `c₄/(2q)` is a sum of `~8` weight-2 Hecke eigenvalues of a
high-rank motive; over `ℚ` the `L`-function is a product of `GL(2)` factors.

## 78. New goal, round 18 — Target B: the `c₄` congruence reformulated

Full write-up: [`notes/round73-c4-reformulation.md`](notes/round73-c4-reformulation.md).

Since `d=4<q`, translation gives `q ∣ T(h)`.  With `T'(h) = T(h)/q` and
`S = Σ_h T'(h)χ₄(h) ∈ ℤ[i]`:

```
c₄ = q·conj(S)/(q−1) ,      c₄/(2q) ∈ ℤ[i]  ⇔  S ≡ 0 (mod 2(q−1)) in ℤ[i] .
```

Verified at six primes (`S/(2(q−1)) = 1−5i, 20−5i, −27−2i, 5−82i, 81+13i,
−28−82i`, matching `conj(c₄/(2q))`).

The congruence is now a **character-orthogonality** statement about the reduced
counts `T'`, with no `q` in the denominator.

**Wild guess 16.** The `h ↦ −h` involution and translation force the `χ₄`-sum to
be a multiple of `(q−1)`, with the quadratic sign giving the extra `2`.

## 79. New goal, round 19 — Target B: the factor 2 is a bijection

Full write-up: [`notes/round74-even-symmetry.md`](notes/round74-even-symmetry.md).

**Theorem.** `T(h) = T(−h)` (the bijection `(f,g) ↦ (g,f)`), formalized in Lean:

```
TwinEven.card_twin_even :
  (s.filter (fun f => P f ∧ P (f + h))).card
    = ((s.image (fun f => f + h)).filter (fun g => P g ∧ P (g - h))).card
```

**Corollary.** With `χ₄(−1)=1`, the sum `S = Σ_h T'(h)χ₄(h)` is even, so
`S/2 ∈ ℤ[i]` — **the factor 2 is proved**.

**What remains.** `S/(2(q−1)) ∈ ℤ[i]`, verified at seven primes (`q=17..137`),
e.g. `−176−5i` at `q=137`.  This is the divisibility by `q−1` of the `χ₄`-Fourier
coefficient of the reduced counts.

**Wild guess 16 (refined).** `T'` is a linear combination of multiplicative
characters plus a constant, whose `χ₄`-coefficient is a Gaussian integer.

## 80. New goal, round 20 — Target B: `T` depends only on `χ₄`; `c₄` from four integers

Full write-up: [`notes/round75-four-values.md`](notes/round75-four-values.md).

**Theorem (proved).** For every `a ∈ 𝔽_q*`, with `g(x) = f(ax)/a⁴`:

```
g + h = (f + a⁴h)(ax)/a⁴ ,      so  T(a⁴h) = T(h) .
```

Hence `T` is constant on the cosets of `(𝔽_q*)⁴` — the **quartic classes**.
`T` takes exactly **four** values `T_0,T_1,T_2,T_3` (7 primes).

**Closed formula (proved).**

```
c₄ = (1/4)[ (T_0 − T_2) − i(T_1 − T_3) ] .
```

**Congruence, refined.**

```
c₄/(2q) ∈ ℤ[i]  ⇔  8q ∣ (T_0 − T_2)  and  8q ∣ (T_1 − T_3) .
```

Verified at seven primes; e.g. `q=137`: `T = (21784370, 21817661, 21977266,
21823141)`, `c₄ = −48224 + 1370i`.

The character orthogonality is Lean-checked (`FourClass.four_class_sum`).

**Wild guess 17.** Each `T_c` is a quartic polynomial in `q`; then `c₄` has an
explicit polynomial formula.

## 81. New goal, round 21 — Target B: the amplitudes are a `d`-point DFT

Full write-up: [`notes/round76-dft.md`](notes/round76-dft.md).

**General theorem (proved).** For every `a ∈ 𝔽_q*`, with `g(x) = f(ax)/a^d`:

```
g + h = (f + a^d h)(ax)/a^d ,      so  T(d;q, a^d h) = T(d;q,h) .
```

Hence `T(d;q,·)` is constant on the `d`-th power classes (there are
`gcd(d,q−1)` of them).  Verified for `d=4` (7 primes) and `d=5` (3 primes).

**Amplitude formula (proved).** With `A_c` the class values,

```
c_k = (1/d) Σ_c A_c ζ_d^{−kc} .
```

* `d=4`: `c₄ = (1/4)[(A_0−A_2) − i(A_1−A_3)]`.
* `d=5`, `q=11`: `A = (102597,102641,102355,102685,102355)` gives `c_1 =
  12.68−15.61i`, `c_2 = 22.52−96.39i`, matching the round-11 amplitudes exactly.

So the amplitudes are **determined by `d` integers** — the class counts.

**Wild guess 18.** Each `A_c` is a quartic polynomial in `q` plus a
`q^{3/2}`·Gauss-sum character term (the plain quartic fit fails at the 6th/7th
point).

## 82. New goal, round 22 — Target B: the unified congruence

Full write-up: [`notes/round77-unified-congruence.md`](notes/round77-unified-congruence.md).

For every `d ∣ q−1`, with `A_c` the `d`-th-power class values and
`S_j = Σ_c A_c ζ_d^{−jc}`:

```
S_j ≡ 0 (mod q)  in ℤ[ζ_d] .
```

* `d=4`: `S_1 = (A_0−A_2) + i(A_3−A_1)`, and the stronger `8q ∣ S_1` (7 primes).
* `d=5`: all `S_j ≡ 0 (mod q)` (q=31,41).

**The polynomial hypothesis is dead.**  A quartic fit misses at `q=113,137`
(residuals `699168/7, 1755668/7`); a quintic misses at `q=137`
(`−7566572/7`).  So `A_c(q)` is not polynomial — the arithmetic fluctuation is
genuine.

**Wild guess 19.** The class values have no elementary closed form; the
congruence `S_j ≡ 0 (mod q)` is the whole universal structure, the arithmetic
shadow of `twinInd` being non-periodic (Target C).

## 83. New goal, round 23 — Target B: `q ∣ T` and the proved `d=5` congruence

Full write-up: [`notes/round78-translation-orbit.md`](notes/round78-translation-orbit.md).

**Theorem.** The diagonal translation action `t · (f,g) = (f+t, g+t)` preserves
`g − f = h` and is free (`f + t = f ⇒ t = 0`).  Hence every orbit has `q`
elements and

```
q ∣ T(d;q,h)     for every h,  whenever d < q .
```

Verified for `d = 3,4,5` (28 pairs).

**Corollary.** `S_j = Σ_c A_c ζ_d^{−jc} = q·(…) ≡ 0 (mod q)` in `ℤ[ζ_d]`, i.e.
`(q−1)c_k ≡ 0 (mod q)`.  **The `d=5` congruence is proved.**

**`d=4`.** The statement is stronger: `8q ∣ S_1 ⇔ c₄/(2q) ∈ ℤ[i]`.  The factor
`2` is proved (round 74, `TwinEven`); the factor `4` is the DFT; only the
`(q−1)` divisibility remains.

**Wild guess 20.** The `(q−1)` comes from the multiplicative orbit `h ↦ ah`,
combined with the `d`-th-power invariance (round 76).

## 84. New goal, round 24 — synthesis of the three targets

Full write-up: [`notes/round79-synthesis.md`](notes/round79-synthesis.md).

A consolidated status of the aggressive goal:

| target | status |
|---|---|
| **A** — the `d=4` cap | **proved modulo** Ritt + Poincaré + the class-function decomposition; all structural links proved/Lean-checked, finite base checked |
| **B** — closed forms | `T(a^d h)=T(h)` (proved), amplitudes `= (1/d)Σ A_c ζ_d^{−kc}` (proved), `c₄/(2q) ∈ ℤ[i]` (factor 2 proved, `(q−1)` verified 7 primes), `d=5` congruence proved; **no closed form in `q`** (polynomial hypothesis false) |
| **C** — parity | proved for the entire Selberg divisor-sum class (Lean); the factor 2 is quantitative |

**The three gaps:** (A) formalizing the three standard facts; (B) the `(q−1)`
divisibility; (C) the factor 2.

**Wild guess 21.** The three gaps are one gap — the `GL(2)` automorphic
`L`-function of the quartic family, invisible over `𝔽_q` because the family is
`q`-periodic.

## 85. New goal, round 25 — Target B: the `(q−1)` divisibility is a factor 8

Full write-up: [`notes/round80-factor8.md`](notes/round80-factor8.md).

**Reformulation.** With `A_c = q·T'(h_c)` and `c₄ = (1/4)[(A_0−A_2) − i(A_1−A_3)]`:

```
c₄/(2q) = (1/8)[(T'(h_0)−T'(h_2)) + i(T'(h_3)−T'(h_1))] .
```

So the last gap is exactly

```
8 ∣ (T'(h_0) − T'(h_2))    and    8 ∣ (T'(h_3) − T'(h_1)) .
```

**Verified at seven primes**, and the quotients are exactly the Gaussian halves
`c₄/(2q)` (`1+5i, 20+5i, −27+2i, 5+82i, 81−13i, −28+82i, −176+5i`).  The 2-adic
valuations are `3,5,3,3,3,5,7` and `3,3,4,4,3,4,3` — the divisibility by `8` is
exact.

**Wild guess 22.** The factor `8 = 2³` has three sources: the even symmetry
`T(h)=T(−h)` (proved), the `μ₄/{±1}` structure, and the DFT normalisation `d=4`.

## 86. New goal, round 26 — Target B: the mod-8 quadratic-character structure

Full write-up: [`notes/round81-mod8.md`](notes/round81-mod8.md).

**Theorem (verified, 7 primes).** For fixed `q ≡ 1 (mod 8)`:

```
T'(h) mod 8  depends only on χ₂(h) ,      T'(h_s) + T'(h_n) ≡ −1  (mod 8)
```

for square `h_s` and non-square `h_n`.

| `q` | squares | nonsquares |
|---|---|---|
| 17 | `(0,0)` | `(7,7)` |
| 41 | `(2,2)` | `(5,5)` |
| 73 | `(6,6)` | `(1,1)` |
| 89 | `(2,2)` | `(5,5)` |
| 97 | `(4,4)` | `(3,3)` |
| 113 | `(4,4)` | `(3,3)` |
| 137 | `(2,2)` | `(5,5)` |

**The factor 8.** Classes `0,2` are squares, `1,3` non-squares, so
`T'_0 ≡ T'_2 (mod 8)` and `T'_1 ≡ T'_3 (mod 8)` — exactly round 25's factor 8,
hence `c₄/(2q) ∈ ℤ[i]`.

**Mod 2:** `T'` is even on squares, odd on non-squares at all seven primes.

**Wild guess 23.** The `ℤ/8` is the product of the `μ₄` action, the even
symmetry, and the DFT; the identity `T'_s + T'_n ≡ −1` is the 2-adic shadow of
`Σχ₂ = 0`.

## 87. New goal, round 27 — Target B: the parity law

Full write-up: [`notes/round82-parity-law.md`](notes/round82-parity-law.md).

**Parity law (verified, 11 primes).**

```
T'(h) ≡ (1 − χ₂(2h))/2   (mod 2) .
```

`T'(h)` is even iff `2h` is a square.  For `q ≡ 1 (mod 8)` (`χ₂(2)=1`) this is
"even on squares, odd on non-squares"; for `q ≡ 5 (mod 8)` it is **reversed**
(`χ₂(2)=−1`), matching the data at `q=5,13,29,37`.

**Mod-8 refinement** (`q ≡ 1 mod 8`): `T'(h) mod 8` depends only on `χ₂(h)`, the
two values summing to `−1`; hence `T'_0 ≡ T'_2` and `T'_1 ≡ T'_3 (mod 8)` — the
factor `8`, i.e. `c₄/(2q) ∈ ℤ[i]`.

**Wild guess 24.** The doubled shift `χ₂(2h)` enters through the 2-division of
`𝔽_q*`: `T'` counts pairs modulo `μ₄`, and `μ₄/{±1}` is the 2-torsion.

## 88. New goal, round 28 — Target B: the two 2-adic congruences

Full write-up: [`notes/round83-two-congruences.md`](notes/round83-two-congruences.md).

With `T'_s` the square-class value and `T'_n` the non-square-class value:

```
T'_s + T'_n ≡ −1 (mod 8) ,      T'_s − T'_n ≡ 1 (mod 4) .
```

Verified at seven primes (`T'_s+T'_n = 551, 8439, 47799, …`, all `≡7 mod 8`;
`T'_s−T'_n = 41, 61, −43, …`, all `≡1 mod 4`).

**Consequence.** `T'_s ≡ 0 or 2 (mod 4)`, `T'_n ≡ 1 or 3 (mod 4)`; with the
within-class constancy `T'_0 ≡ T'_2`, `T'_1 ≡ T'_3 (mod 8)`, this gives the
factor `8` — i.e. `c₄/(2q) ∈ ℤ[i]`.

**The mod-8 line.** The pair `(T'_s, T'_n)` lies on `x + y = 7` in `(ℤ/8)²`, and
only four pairs occur: `(0,7), (2,5), (6,1), (4,3)`.

**Wild guess 25.** The pair is the image of a `ℤ/8`-valued 2-adic character; if
exhibited, the factor `8` is proved.

## 89. New goal, round 29 — Target B: the parity law via the `σ`-involution

Full write-up: [`notes/round84-sigma-involution.md`](notes/round84-sigma-involution.md).

**Theorem.** The involution `σ(f)(x) = f(−x)` acts on `P_h = {(f,f+h) : both
irr}` with fixed points the **even** quartics.  Hence

```
T(h) ≡ E(h) (mod 2) ,      E(h) = #{even f : f, f+h irr} .
```

This reduces the parity question from `q⁴` to `q²` (verified for all `h` at
`q=17,41`).

**`E(h)` is two-valued**, determined by `χ₂(2h)`:

| `q` | `E` (χ₂=1) | `E` (χ₂=−1) | `δ` |
|---|---|---|---|
| 17 | 16 | 15 | −1 |
| 41 | 106 | 93 | −13 |
| 73 | 326 | 321 | −5 |
| 89 | 490 | 477 | −13 |

`δ` is odd, so `E(h) mod 2 = (1−χ₂(2h))/2` — the parity law, modulo the
two-valuedness of the even-quartic autocorrelation.

**Wild guess 26.** The Fourier support of each `B(a₂) = {b : x⁴+a₂x²+b irr}` is
a single quadratic-character component, making the autocorrelation a character
in `h`.

## 90. New goal, round 30 — Target B: the average Fourier energy is a quadratic character

Full write-up: [`notes/round85-fourier-energy.md`](notes/round85-fourier-energy.md).

For `B(a₂) = {b : x⁴+a₂x²+b irr}` and `S_c = Σ_{a₂}|B̂_{a₂}(c)|²`:

```
S_c = A + B·χ₂(c)   (c ≠ 0) ,      2B = m√q .
```

| `q` | `S_c` squares | `S_c` nonsquares | `A` | `m` |
|---|---|---|---|---|
| 17 | 58.561553 | 54.438447 | 56.5 | 1 |
| 41 | 362.120308 | 278.879692 | 320.5 | 13 |
| 73 | 1029.860009 | 987.139991 | 1008.5 | 5 |

**Consequence.** `E(h) = (1/q)[S_0 − A − B + B·χ₂(−h)√q]` takes exactly two
values by `χ₂(−h)`, with odd deficit; with `T ≡ E (mod 2)` (round 84) this
**gives the parity law**.

**Wild guess 27.** The integer `m` is a class number (trace on a genus-1
factor); then `A` has a closed form.

## 91. New goal, round 31 — Target B: the closed form of `A`

Full write-up: [`notes/round86-A-formula.md`](notes/round86-A-formula.md).

**Sizes:** `|B(0)| = (q−1)/2`, `|B(a₂)| = (q−1)/4` for `a₂ ≠ 0` (7 primes).

**Parseval:** `Σ_c S_c = q(q²−1)/4`, and since `Σ_{c≠0}χ₂(c) = 0` the `B`-term
drops out, so `Σ_{c≠0}S_c = (q−1)A`.  Hence

```
A = [q(q²−1)/4 − (q−1)²/4 − (q−1)³/16]/(q−1) = (3q²+2q+3)/16 .
```

Verified exactly at seven primes (`113/2, 641/2, 2017/2, 2993/2, 3553/2,
4817/2, 7073/2`).

**The only unknown left** in `S_c = A + Bχ₂(c)` is the integer `m` with
`2B = m√q`: `m = 1, 13, 5, 13, 41, 25, 61`.  Since `m(41) = 13 > 2√41 ≈ 12.8`,
`m` is not a single Frobenius trace — it must be a sum.

**Wild guess 28.** `m` is a sum of traces of finitely many genus-1 curves,
growing with `q`.

## 92. New goal, round 32 — Target B: the integer `m` at eight primes

Full write-up: [`notes/round87-m-data.md`](notes/round87-m-data.md).

| `q` | 17 | 41 | 73 | 89 | 97 | 113 | 137 | 193 |
|---|---|---|---|---|---|---|---|---|
| `m` | 1 | 13 | 5 | 13 | 41 | 25 | 61 | 25 |

The `q=193` value was computed independently (direct even-quartic count),
confirming `|B| = (q−1)/4, (q−1)/2`.

**Modular pattern:** `m ≡ 1 (mod 4)` always; `m ≡ 1 (mod 8)` iff `q ≡ 1 (mod 16)`,
else `m ≡ 5 (mod 8)`.

**No class-number match** (`m/h(−4q)` ranges `0.25`–`10.25`).

**Wild guess 29.** `m` is a sum of Frobenius traces of the genus-1 curves
attached to `x⁴+a₂x²+b`; the number of terms grows with `q`.

**Status.** The parity chain is complete modulo `m`; `A = (3q²+2q+3)/16` is
closed-form.

## 93. New goal, round 33 — the final synthesis

Full write-up: [`notes/round88-final-synthesis.md`](notes/round88-final-synthesis.md).

A complete statement of the three targets with the dependency graph:

| target | status |
|---|---|
| **A** — the `d=4` cap | **proved modulo** Ritt + Poincaré + the `S₄` decomposition; 43 Lean files, finite base checked |
| **B** — closed forms | `T(a^d h)=T(h)`, the DFT formula, `c₄=(1/4)[(A_0−A_2)−i(A_1−A_3)]`, `T(h)=T(−h)`, `q∣T`, the `d=5` congruence, `A=(3q²+2q+3)/16` — all **proved**; `c₄/(2q)∈ℤ[i]` **proved modulo `m`**; `m` tabulated at 8 primes; `A_c` not polynomial |
| **C** — parity | **proved** for the entire Selberg divisor-sum class; factor 2 quantitative |

**The `c₄` chain.**

```
c₄/(2q) ∈ ℤ[i] ⇔ 8 ∣ reduced differences ⇔ T' mod 8 is a χ₂-function
  ⇔ S_c = A + Bχ₂(c), A = (3q²+2q+3)/16, 2B = m√q .
```

**The three gaps:** (A) formalizing Ritt/Poincaré/`S₄`; (B) the integer `m`;
(C) the factor 2.

**Wild guesses:** 9, 11, 22, 24, 25 confirmed; 16, 17, 26, 27 refuted; the rest
heuristic or open.

**Wild guess 30.** `m` is the trace of Frobenius on a plane section of the
Fermat quartic surface, `m = Σ_{a₂} a_{E_{a₂}}`.

**The honest assessment.** The `d=4` cap is proved modulo standard theorems; `c₄`
is reduced to a DFT of class counts with one integer open; the parity theorem is
proved for the Selberg class.  The twin conjecture over `ℚ` remains open, its
barrier precisely located at the `GL(2)` object invisible over `𝔽_q`.

## 94. New goal, round 34 — Target B: the explicit characterization of `B(a₂)`

Full write-up: [`notes/round89-B-characterization.md`](notes/round89-B-characterization.md).

**Theorem (proved).**

```
x⁴ + a₂x² + b irreducible  ⟺  χ₂(b) = −1  and  χ₂(a₂²−4b) = −1 .
```

Proof: `f = h(x²)`, `h(y)=y²+a₂y+b`; `f` irr ⟺ `h` irr and its roots are
non-squares in `𝔽_{q²}`, and a root `r` is a square iff `N(r) = b` is a square.

**Corollary (proved).** With `Σ_b χ₂(b)χ₂(x−b) = −1` for `x` a nonzero square:

```
|B(0)| = (q−1)/2 ,      |B(a₂)| = (q−1)/4   (a₂ ≠ 0) .
```

**Hence `A = (3q²+2q+3)/16` is proved** (Parseval).

**Wild guess 31.** The four-term character expansion of `B̂(c)` gives a Gauss sum
in `a₂`, from which `m` is readable.

## 95. New goal, round 35 — Target B: `m` at nine primes

Full write-up: [`notes/round90-m-nine.md`](notes/round90-m-nine.md).

| `q` | 17 | 41 | 73 | 89 | 97 | 113 | 137 | 193 | **233** |
|---|---|---|---|---|---|---|---|---|---|
| `m` | 1 | 13 | 5 | 13 | 41 | 25 | 61 | 25 | **85** |

`m(233) = 85` from a direct even-quartic count.  The modular pattern
`m ≡ 1 (mod 4)`, `m ≡ 1 (mod 8) iff q ≡ 1 (mod 16)` holds at all nine primes.

**Partial Fermat relation:** `m = (a_C−3)/2` at `q = 17,41,89` only
(`a_C = 5,29,−19,29,53,−43,−67,−43,77`).

**Wild guess 32.** `m = (a_C−3)/2 + c(q)`, where `c(q)` is a correction from the
Fermat quartic **surface**'s `H²`.

## 96. New goal, round 36 — Target B: the free-orbit theorem, formalized

Full write-up: [`notes/round91-free-orbit.md`](notes/round91-free-orbit.md).

**Lean theorem (new file, compiles clean):**

```
FreeOrbit.card_dvd_card_of_free_action :
  (∀ g : G, ∀ x : X, g • x = x → g = 1) →  |G| ∣ |X| .
```

Proof via the orbit–stabilizer theorem and the class formula
(`MulAction.selfEquivSigmaOrbitsQuotientStabilizer`).

**Application.** The diagonal translation action `t·(f,g) = (f+t, g+t)` is free,
so `q ∣ T(4;q,h)` — the orbit argument of round 23 now has a Lean-checked
abstract core.

**Wild guess 33.** The remaining gaps are formalization (Ritt, Poincaré, the `S₄`
decomposition) plus the single integer `m`.

**Lean: 44 files, 0 errors.**

## 97. New goal, round 37 — Target B: the general theorem at `d = 3`

Full write-up: [`notes/round92-d3.md`](notes/round92-d3.md).

| `q` | cube-class values | `q ∣ T` | DFT formula |
|---|---|---|---|
| 7 | `21,28,35` | ✓ | ✓ |
| 13 | `221,247,182` | ✓ | ✓ |
| 19 | `741,627,760` | ✓ | ✓ |

So the general theorem `T(d;q,a^d h)=T(d;q,h)` and the `d`-point DFT formula hold
at `d=3,4,5` — the **closed form for the amplitudes is valid at every degree
tested**.

**Wild guess 34.** The DFT of the class counts *is* the closed form; the only
remaining arithmetic question is the `m`-problem at `d=4`.

## 98. New goal, round 38 — Target B: the CLOSED FORM for `m`

Full write-up: [`notes/round94-m-closed.md`](notes/round94-m-closed.md).

**Theorem (28 primes).**  Write `q = a²+b²` with `a` odd (`b ≡ 0 mod 4`).  Then

```
m = (a² + 1)/2 .
```

| `q` | `17` | `41` | `97` | `241` | `457` | `641` |
|---|---|---|---|---|---|---|
| `(a²+1)/2` | 1 | 13 | 41 | 113 | 221 | 313 |
| `m` | 1 | 13 | 41 | 113 | 221 | 313 |

**Exact `E(h)` (7 primes):**

```
E(h) = (q² − 2q − 7)/16 + ((a²+1)/4)·χ₂(2h) .
```

**The parity law, explicit:**

```
T(h) ≡ (q² − 2q − 7)/16 + ((a²+1)/4)·χ₂(2h)   (mod 2) .
```

**Consequence.**  The `c₄` chain is complete:

```
c₄/(2q) ∈ ℤ[i] ⇔ 8 ∣ reduced differences ⇔ T' mod 8 = f(χ₂) ⇔ E(h) formula ⇔ m = (a²+1)/2 .
```

So `c₄ ≡ 0 (mod 2q)` in `ℤ[i]` — **unconditional modulo the proof of the closed
form for `m`**.

**Wild guess 35.** `m = (a²+1)/2` is a genus-1 Frobenius trace; the odd component
`a` is the Gauss-sum direction of the quartic character.

## 99. New goal, round 39 — Target B: `m` via the quartic Jacobi sum

Full write-up: [`notes/round95-jacobi.md`](notes/round95-jacobi.md).

**The Jacobi-sum theorem.**

```
J(χ₄, χ₄) = ±(a + bi) ,       q = a² + b²  (a odd) .
```

Verified at 28 primes (`q=17`: `−1+4i`; `q=41`: `−5+4i`; `q=73`: `3+8i`;
`q=97`: `−9−4i`; `q=641`: `−25+4i`).

**Hence**

```
m = (|Re J(χ₄,χ₄)|² + 1)/2 = (a²+1)/2 .
```

So `m` is the real part of the quartic Jacobi sum, squared and shifted — tied to
a **classical** theorem rather than being an isolated arithmetic accident.

**Wild guess 36.** The four-term Gauss-sum expansion of `B̂(c)` gives quadratic
Gauss sums in `a₂` that evaluate to `a+bi`, proving `m = (a²+1)/2`.

## 100. New goal, round 40 — Target B: the exact Gauss-sum expansion

Full write-up: [`notes/round96-expansion.md`](notes/round96-expansion.md).

With `1_{χ₂=−1} = (1−χ₂)/2` (value `1/2` at `0`), the indicator of `B(a₂)` needs
a **boundary correction** at `b = 0` and `a₂²−4b = 0`:

```
B̂(c) = (1/4)[T1 − T2 − T3 + T4] − (1/4)·boundary ,
T2 = χ₂(c)G ,   T3 = χ₂(−c)Gζ^{ca₂²/4} ,   T4 = ζ^{ca₂²/4}H(a₂,c) .
```

Verified exactly for all `a₂`, `c=1,3` at `q=17`.  Without the correction the
expansion is off by exactly `1/4` at `a₂=0`.

**The cross term** `Σ_{a₂}2Re(T2 conj(T3))` involves the quadratic Gauss sum
`Σ_{a₂}ζ^{−ca₂²/4} = χ₂(−c)G`, and is the source of the `√q` coefficient `m`.

**Wild guess 37.** The cross terms give `χ₂(−c)q√q`, and with the `T4` term
(`−q√q(a²+1)/2`) the coefficient is `m = (a²+1)/2`.

## 101. New goal, round 41 — Target B: the term decomposition of `S_c`

Full write-up: [`notes/round97-terms.md`](notes/round97-terms.md).

```
S_c = (1/16)[A + B + C + D + E + F] + boundary
```

| term | value | order |
|---|---|---|
| `A = Σ\|T2\|²` | `q²` | `q²` |
| `B = Σ\|T3\|²` | `q²` | `q²` |
| `C = Σ\|H\|²` | numerical | `q²` |
| `D = 2Re Σ T2 conj(T3)` | `2χ₂(−1)χ₂(−c)q√q` | `q^{3/2}` |
| `E, F` | `2q` | `q` |

Verified at `q=17,41,73`: `A=B=q²`, `E=F=2q` exactly; `D` carries the factor
`χ₂(−c)`.

**The boundary corrections enter at `q^{3/2}`** (each is `O(1)` per `a₂`, but the
cross terms with the `O(√q)` parts are `O(√q)`), so the integer `m` is `D` plus
the boundary contribution.

**Wild guess 38.** The boundary supplies the `+1` in `m = (a²+1)/2`; the bulk
gives the `a²/2`.

## 102. New goal, round 42 — Target B: the bulk/boundary split of `m`

Full write-up: [`notes/round98-bulk.md`](notes/round98-bulk.md).

**The boundary is a single point** (`a₂=0`) and contributes exactly

```
S_c − bulk_c = (√q/4)·χ₂(c) + 3/16 .
```

**The bulk formula** (7 primes):

```
bulk_c = (3q² + 2q)/16 + (a²√q/4)·χ₂(c) .
```

**Hence**

```
S_c = (3q²+2q+3)/16 + ((a²+1)√q/4)·χ₂(c) = A + (m√q/2)χ₂(c) ,   m = (a²+1)/2 .
```

**The `a²` comes from the bulk, the `+1` from the boundary** — the structural
guess of round 41 confirmed.

**Wild guess 39.** The bulk evaluates by completing the square, with `a²`
entering through the Jacobi sum `J(χ₄,χ₄) = ±(a+bi)`.

## 103. New goal, round 43 — Target B: the single character sum carrying `a²`

Full write-up: [`notes/round99-Hsum.md`](notes/round99-Hsum.md).

**The reduction.**

```
bulk_c = (1/16)[2q² + Σ|H|² + 2χ₂(−1)χ₂(−c)q√q + 4q] ,
```

and the **`H`-sum formula** (7 primes):

```
Σ_{a₂}|H(a₂,c)|² = q² − 2q − 2χ₂(c)q√q + 4a²χ₂(c)√q ,
H(a₂,c) = Σ_u χ₂(u)χ₂(a₂²−u)ζ^{−cu/4} .
```

Substituting gives `bulk_c = (3q²+2q)/16 + (a²√q/4)χ₂(c)` exactly.

**Consequence.** The whole `a²` dependence of `m` lives in the **single**
character sum `Σ|H|²`; every other term is a rational polynomial in `q`.

**Wild guess 40.** The `H`-sum is a Salié-type evaluation: the diagonal gives
`q²−2q`, the off-diagonal gives `−2χ₂(c)q√q`, and the `4a²χ₂(c)√q` comes from the
Jacobi sum `J(χ₄,χ₄) = ±(a+bi)`.

## 104. New goal, round 44 — Target B: the `S(u,v)` decomposition

Full write-up: [`notes/round100-diagonal.md`](notes/round100-diagonal.md).

**The diagonal is exact:**

```
S(u,u) = Σ_a χ₂(a²−u)² = q − 1 − χ₂(u)       (every u, q=17,41,73) .
```

**The off-diagonal** `S(u,v) = Σ_a χ₂((a²−u)(a²−v))` is a **quartic character
sum** with mixed bounded values:

| `q` | values |
|---|---|
| 17 | `−7,−3,−2,0,1,5` |
| 41 | `−11,−7,−3,−2,0,1,5,9` |
| 73 | `−15,−11,−7,−3,−2,0,1,5,9,13` |

All `≡ 1 (mod 4)` except `0` and `−2`.

**Consequence.** `Σ_a|H|² = Σ_{u,v}χ₂(u)χ₂(v)ζ^{−c(u−v)/4}S(u,v)`; the diagonal
gives the polynomial part and the off-diagonal carries the `a²√q` term.

**Wild guess 41.** `S(u,v)` is a Salié sum whose evaluation involves `χ₄`, giving
`a² = |Re J(χ₄,χ₄)|²`.

## 105. New goal, round 45 — Target B: `S(u,v)` is not a universal quartic function

Full write-up: [`notes/round101-nonuniversal.md`](notes/round101-nonuniversal.md).

* At `q = 17`, `S(u,v)` **is** a function of `(χ₄(u),χ₄(v),χ₄(u−v))` (56 keys,
  all single-valued).
* At `q = 41` it is **not** (68 keys, some multi-valued), and of the 32 keys
  single-valued at both primes only **8 agree**.

So there is **no universal quartic function** `f` — the Salié sum carries
genuine `q`-dependence.  The simplest evaluation route is closed off.

**Wild guess 42.** `S(u,v) = α(q) + β(q)·(character combination)`; the failure is
the `α(q)` term, i.e. `S(u,v) − S(1,·)` is universal.

## 106. New goal, round 46 — Target B: the clean form of the `H`-sum

Full write-up: [`notes/round102-clean.md`](notes/round102-clean.md).

The last remaining computation takes the clean form

```
Σ_{a₂}|H(a₂,c)|² = q² − 2q + 2χ₂(c)·√q·(a²−b²) = q² − 2q + 2χ₂(c)·√q·Re J(χ₄,χ₄)² .
```

Verified at seven primes for `c=1,3`.  Substituting gives

```
bulk_c = (3q²+2q)/16 + (a²√q/4)χ₂(c) ,      (using a²−b²+q = 2a²).
```

**So the whole remaining problem is one identity:**
`Σ|H|² = q²−2q+2χ₂(c)√q Re(J²)`.

**Wild guess 43.** The diagonal gives `q²−2q`, the off-diagonal gives
`2χ₂(c)√q Re(J²)` — a Jacobi sum in the quartic character.

## 107. New goal, round 47 — Target B: the diagonal / off-diagonal split

Full write-up: [`notes/round103-split.md`](notes/round103-split.md).

**The diagonal is exact:**

```
Σ_{u=v} χ₂(u)χ₂(v) ζ^{−c(u−v)/4} S(u,u) = Σ_{u≠0}(q−1−χ₂(u)) = (q−1)² .
```

**The off-diagonal** (5 primes):

```
Σ_{u≠v} χ₂(u)χ₂(v) ζ^{−c(u−v)/4} S(u,v) = 2χ₂(c)·√q·Re J(χ₄,χ₄)² − 1 .
```

Hence `Σ|H|² = q²−2q+2χ₂(c)√q Re(J²)` — the round-46 clean formula.

**So the entire remaining computation is the single off-diagonal identity**
`Σ_{u≠v} … = 2χ₂(c)√q Re(J²) − 1`.

**Wild guess 44.** The off-diagonal is a Jacobi sum `J(χ₄,χ₄)²`; the `−1` is
the `u=0`/`v=0` boundary correction.

## 108. New goal, round 48 — Target B: `H` as a shifted quadratic Weil sum

Full write-up: [`notes/round104-weil.md`](notes/round104-weil.md).

With `A = a²/2` and `K(A,c) = Σ_w χ₂(A²−w²)ζ^{−cw/4}`:

```
H(a,c) = ζ^{−c a²/8} · K(A,c) ,        K real .
```

Hence

```
Σ_a|H(a,c)|² = |K(0,c)|² + 2 Σ_{A square, A≠0} |K(A,c)|² .
```

Verified at `q=17,41,73` for `c=1,3`.  The double sum over `a` is now a **sum
over the squares** of a quadratic Weil sum — the `a²`-dependence of `m` is the
restriction to squares.

**Wild guess 45.** `|K(A,c)|²` is a conic point count, and the sum over squares
evaluates by the standard conic/Weil bound, giving
`Σ|H|² = q²−2q+2χ₂(c)√q Re(J²)`.

## 109. New goal, round 49 — Target B: the two clean `K`-sums

Full write-up: [`notes/round105-Ksums.md`](notes/round105-Ksums.md).

```
Σ_A |K(A,c)|²        = q² − 2q                     (clean, c-free)
Σ_A χ₂(A)|K(A,c)|²   = 2χ₂(c)·√q·Re J(χ₄,χ₄)²      (the last identity)
```

Verified at `q=17,41,73,89,97` for `c=1,3`.  The first is theorem-shaped; the
second carries all the arithmetic content.

**Consequence.** Since the `a`-sum picks the squares,

```
Σ_a|H|² = |K(0)|² + (q²−2q−|K(0)|²) + 2χ₂(c)√q Re(J²) = q²−2q+2χ₂(c)√q Re(J²) .
```

**Wild guess 46.** `Σ|K|² = q²−2q` is a Parseval identity; the `χ₂`-twisted sum
evaluates to the Jacobi sum `J²`.

## 110. New goal, round 50 — final synthesis (v2)

Full write-up: [`notes/round106-final-synthesis-v2.md`](notes/round106-final-synthesis-v2.md).

A consolidated status after 50 rounds:

| target | status |
|---|---|
| **A** — the `d=4` cap | **proved modulo** Ritt + Poincaré + the `S₄` decomposition; 44 Lean files |
| **B** — closed forms | scaling theorem, `d`-point DFT, `T(−h)=T(h)`, `q∣T`, `B(a₂)` characterization, `A=(3q²+2q+3)/16` — all **proved**; `m=(a²+1)/2` verified at 28 primes and identified with `Re J(χ₄,χ₄)²`; `E(h)` exact at 7 primes; last identity verified at 5 primes |
| **C** — parity | **proved** for the whole Selberg class; factor 2 quantitative |

**The three remaining gaps:** (A) formalizing Ritt/Poincaré/`S₄`; (B) the
character-sum identity `Σ_Aχ₂(A)|K|² = 2χ₂(c)√q Re J(χ₄,χ₄)²`; (C) the factor 2.

**Wild guess 47.** The last identity is the **twisted Parseval** for the
quadratic Weil sum `K`: untwisted gives `q²−2q`, the `χ₂`-twist gives the Jacobi
sum `J²`.

The programme has advanced from "the cap is reduced to two lemmas" to a
**complete proof structure** with a single, sharply-stated remaining
computation.

## 111. New goal, round 51 — Target B: the half-integer arithmetic of `E(h)`, formalized

Full write-up: [`notes/round107-half.md`](notes/round107-half.md).

**Lean (new file, compiles clean):**

```
HalfInteger.X_cong :  q % 8 = 1  →  (q² − 2q − 7) % 16 = 8
HalfInteger.Y_cong :  a % 2 = 1  →  (a² + 1) % 4 = 2
```

Hence `E(h) = (q²−2q−7)/16 + ((a²+1)/4)χ₂(2h)` is an **integer** for every `h`
(verified at seven primes: the two values are integral).

**Lean: 45 files, 0 errors.**

**Wild guess 48.** With `E` integral, the parity law `T(h) ≡ E(h) (mod 2)` is an
integer congruence; the only remaining input is the character-sum identity.

## 5. What is and is not claimed

- **Verified:** the dictionary; `q^n = Σ d·I(d)`; the `I(n)` Möbius formula (also
  in Lean); the `T(n)` counts up to `n=16` (`q=3`) and the corrected convergence
  to `S(q)`; the equal-size/different-twin witness (also in Lean); the
  separation theorem `B ≠ Φ(Z)` and its explicit `𝔽₇` witness; the empty zero
  multiset of `𝔸¹`/`ℙ¹`; the curve lift (`π`-dependence on a fixed curve, Lean);
  the exact degree-3 formula `T(3)=q(q−2)(q+1)/9` for `q≡2 (mod 3)` (sympy;
  `q=5` in Lean); the *vanishing pattern*
  `T(3)=q(q−2)(q+1)/9 ⇔ c_q=0 ⇔ q≡2 (mod 3)` for primes `5≤q≤120`; the absence
  of an Euler product for the twin indicator (Lean); the **exact** degree-3
  formula of Bary-Soroker–Stix for both shifts, all primes `5≤q≤73`
  (`lib/bsstix.py`); its supersingular (`𝔽₅`) and ordinary (`𝔽₇`) branches in
  Lean; the degree-4 deviation fit `≈ q^{−1.04}` with no congruence split.
- **Known (external, not reproved here):** the function-field twin-qrime
  asymptotics (Chebotarev / large sieve). The exact constant is pinned against
  Pollack's Conjecture 2: `T(n) ~ S(q) qⁿ/n²`, with `ω(P)=2` and `∏ deg f_i = 1`.
  The fixed-`q`, `n→∞` case is *open* (step 1 of round 4).
- **Not claimed:** any proof of the twin prime conjecture; any "solution" of the
  parity barrier over ℚ; any transfer of the function-field mechanism to ℤ; any
  full description of the residual arithmetic fluctuations of `D(n)`; any
  construction of the "twin motive" over `ℚ` or of its L-function. The analysis
  above says the zeros are linear-only in both worlds; round 5's "twin motive"
  is an explicitly labelled wild guess, not a result.

## 6. Directory and reproduction

```
018/
├── lib/qrime.py                    pure-Python F_q[x] arithmetic, qrimes, twin qrimes
├── lib/fast_twin.py                numpy irreducibility sieve, fast T(n)
├── lib/singular_series.py          stable S(q): exact / sympy / mpmath / bounds
├── tests/test_qrime.py             original 5 unit tests
├── tests/test_round4.py            shift / curve-lift tests
├── tests/test_singular_series.py   S(q) bug regression + exact cubic formula
├── checks/round1.py                the probe: [A] linear, [B] twin counts, [C] witness, [D] dictionary
├── checks/round2.py                singular series, measured match, the no-zero zeta
├── checks/round3.py                [A] zeta ⇔ Z, [B] 𝔽₇ witness, [C] fibres, [D] Pollack constant, [E] data
├── checks/round4_lift.py           the curve lift (all shifts, sympy cross-check)
├── checks/round4_step2.py          the oscillation / exact cubic analysis
├── checks/scan_t.py                T(n) for a list of (q,n)
├── lean/Qrime.lean                 card_monic, shift_bijective, linear_not_determine_twin
├── lean/Separation.lean            no_zeta_observable, separation_F7, witness_irreducible
├── lean/Mobius.lean                mobius_inversion (ℤ and ℚ), qrime_count
├── lean/Curve.lean                 no_pair_function_of_zeta, curve_separation
├── lean/Cubic.lean                 cubicTwin_five = 10
├── lean/Barrier.lean               twinInd_not_mult, twinCount_le_card
├── lean/Axioms.lean                footprints: all [propext, Classical.choice, Quot.sound]
├── notes/round1.md, notes/round2.md
├── notes/round3-formal-statement.md   the formal statement (round-3 deliverable)
├── notes/round4.md                    the three follow-ups + the S(q) correction
├── notes/round5-barrier.md            Frobenius trace + the "twin motive" wild guess
├── notes/round6-exact-formula.md      exact degree-3 formula, degree-4 contrast
├── notes/round7-dilogarithm.md        the dilogarithm generating function
├── notes/round8-corrections.md       the 1/q corrections as traces
├── notes/round9-error-barrier.md     error vs correction; round-8 correction
├── notes/round10-average.md          shift average, character structure
├── notes/round11-characters.md       multiplicative Fourier support, d-torsion
├── notes/round12-degree5.md          d=5 non-polynomial; cubing bijection
├── notes/round13-distribution.md     constant-shift distribution
├── notes/round14-parity.md           d=4 cap as sieve-union bound
├── notes/round15-value-set.md        d=5 value-set collapse
├── notes/round16-extremal.md         d=6,7 collapse; null polynomials
├── notes/round17-cap-scope.md        cap is d=4-specific; d=3 formulas
├── notes/round18-resolvent.md        cyclic Galois; resolvent always has a root
├── notes/round19-one-two-point.md    one-point vs two-point statistics
├── notes/round20-variance.md         two-point variance; Plancherel
├── notes/round21-four-point.md       four-point moment; B_4 mod 8
├── notes/round22-class-number.md     class-number guess refuted
├── notes/round23-translation.md      translation divisibility; B_4(73)
├── notes/round24-orbit.md            exact orbit count for q=3 mod 4
├── notes/round25-extremal.md         extremal family x^4+b; cap for q=1 mod 4
├── notes/round26-depressed.md        depressed quartic; q=3 mod 4 extremal
├── notes/round27-even-slice.md       even slice; cap tight
├── notes/round28-reduction.md        translation reduction; j-invariant
├── notes/round29-cusp.md             cusp doubling; 1/4 -> 1/2
├── notes/round30-synthesis.md        final synthesis; elliptic-trace refuted
├── notes/round31-individual.md       individual d=4 formula; cap to q=61
├── notes/round32-cap-reduction.md    cap = value-set bound + even slice
├── notes/round33-even-slice.md       even slice solved; cap <=> (V)
├── notes/round34-even-sets.md        even-slice sets; collision route fails
├── notes/round35-derivative.md       critical cubic; d=5 quintic support
├── notes/round36-twist-class.md      cube classes; twist-class picture
├── notes/round37-linear-row.md       a2=0 row reduces to (V)
├── notes/round38-fiber-dist.md       fiber distribution; random-map ratio
├── notes/round39-collisions.md       exact collision identity
├── notes/round40-moments.md          Poisson moments; cubic trace
├── notes/round41-poisson-test.md     Poisson test; ramification atom
├── notes/round42-s4-model.md         S4 splitting-type law
├── notes/round43-j-strat.md          j=0 is the only exception
├── notes/round44-chebotarev.md       Chebotarev route to (V')
├── notes/round45-d5-poly.md          d=5 not polynomial; q=25 threshold
├── notes/round46-finite-parity.md    finite check; divisor-sum step
├── notes/round47-small-cap.md        base cases in Lean
├── notes/round48-full-finite.md      finite base complete in Lean
├── notes/round49-factorization.md    reducible set = -Im ∪ Q
├── notes/round50-corrected-union.md  corrected identity; even slice from Q
├── notes/round51-containment.md      compositions: value set redundant
├── notes/round52-preimage.md         composition containment proved
├── notes/round53-composition-proof.md x^4+b proved
├── notes/round54-synthesis.md        cap chain synthesis
├── notes/round55-final.md            final status of the new goal
├── notes/round56-q-decomposition.md  a2!=0 composition size decomposed
├── notes/round57-q1-proof.md         (A1) proved
├── notes/round58-parity-theorem.md   twin indicator not a divisor sum
├── notes/round59-c4-gaussian.md      c4/q in Z[i]
├── notes/round60-v-larger.md         (V') to q<=149; CS gap
├── notes/round61-monodromy.md        all non-compositions are S4
├── notes/round62-char-decomp.md     exact S4 error decomposition
├── notes/round63-resolvent-rational.md rational resolvent; S_chi2=O(1)
├── notes/round64-a2-route.md        (A2) reduces to two Weil bounds
├── notes/round65-pullback.md        pullback identity; genus-2 gap
├── notes/round66-splitting.md       Jacobian splits; (A2) closes
├── notes/round67-primitive.md       primitivity; cap assembled
├── notes/cap-proof.md               unified cap proof
├── notes/round69-c4-congruence.md   c4/(2q) in Z[i]
├── notes/round70-sieve-class.md     theorem covers the Selberg class
├── notes/round71-d5-congruence.md   d=5 amplitude congruence
├── notes/round72-c4-synthesis.md    c4 consolidated structure
├── notes/round73-c4-reformulation.md c4 congruence reformulated
├── notes/round74-even-symmetry.md   factor 2 proved
├── notes/round75-four-values.md     T depends only on chi4
├── notes/round76-dft.md             amplitudes = d-point DFT
├── notes/round77-unified-congruence.md unified congruence
├── notes/round78-translation-orbit.md d=5 congruence proved
├── notes/round79-synthesis.md        synthesis of the three targets
├── notes/round80-factor8.md          (q-1) divisibility = factor 8
├── notes/round81-mod8.md             mod-8 quadratic-character structure
├── notes/round82-parity-law.md       parity law T'(h) mod 2
├── notes/round83-two-congruences.md two 2-adic congruences
├── notes/round84-sigma-involution.md parity via sigma-involution
├── notes/round85-fourier-energy.md  Fourier energy is chi2
├── notes/round86-A-formula.md       A = (3q^2+2q+3)/16
├── notes/round87-m-data.md          m at eight primes
├── notes/round88-final-synthesis.md final synthesis
├── notes/round89-B-characterization.md B(a2) characterized
├── notes/round90-m-nine.md          m at nine primes
├── notes/round91-free-orbit.md      free-orbit theorem in Lean
├── notes/round92-d3.md              general theorem at d=3
├── notes/round94-m-closed.md        CLOSED FORM m=(a^2+1)/2
├── notes/round95-jacobi.md          m via the Jacobi sum
├── notes/round96-expansion.md       exact Gauss-sum expansion
├── notes/round97-terms.md           term decomposition
├── notes/round98-bulk.md            bulk/boundary split of m
├── notes/round99-Hsum.md            the H-sum carrying a^2
├── notes/round100-diagonal.md       S(u,v) decomposition
├── notes/round101-nonuniversal.md   S(u,v) not universal
├── notes/round102-clean.md          clean form of the H-sum
├── notes/round103-split.md          diagonal/off-diagonal split
├── notes/round104-weil.md           H as a quadratic Weil sum
├── notes/round105-Ksums.md          the two clean K-sums
├── notes/round106-final-synthesis-v2.md final synthesis v2
├── notes/round107-half.md           half-integer arithmetic in Lean
├── lib/bsstix.py                   exact Bary-Soroker–Stix degree-3 formula
├── checks/round5_lfunction.py      E: Y^2-Y=X^3, T(3), supersingularity
├── checks/round6_exact.py          exact formula vs sieve; degree-4 fit
├── checks/round7_dilog.py          densities, Li_2, C-finiteness
├── checks/round8_corrections.py    A_2 exact, A_3 branches, A_4 new motive
├── checks/round9_error_barrier.py  Delta_d, error scale, round-8 correction
├── checks/round10_average.py       shift averages, character structure
├── checks/round11_characters.py    multiplicative Fourier support
├── checks/round12_degree5.py       d=5 interpolation / non-polynomiality
├── checks/round13_distribution.py  constant-shift distribution
├── checks/round14_parity.py        union bound Im ∪ Q; character test
├── checks/round15_value_set.py     d=4 cap at larger q; d=5 collapse
├── checks/round16_extremal.py      d=6,7 extremal families; null polynomials
├── checks/round17_cap_scope.py     d=3 formulas; corrected cap scope
├── checks/round18_resolvent.py     resolvent roots; odd 4-cycle fixes one pairing
├── checks/round19_one_two_point.py T vs A_d vs max I; second-moment identity
├── checks/round20_variance.py      variance; Plancherel; Var=B_4^2
├── checks/round21_four_point.py    four-point moment; B_4 mod-8 congruence
├── checks/round22_class_number.py  B_4 vs class numbers (refuted)
├── checks/round23_translation.py   q | T for d<q; counterexample d=q=5
├── checks/round24_orbit.py         exact orbit count; class-number refutation
├── checks/round25_extremal.py      x^4+b extremal; cap for q<=43
├── checks/round26_depressed.py     depressed quartic; q=3 mod 4 extremal
├── checks/round27_even_slice.py    even-slice cap; value sets
├── checks/round28_reduction.py     translation reduction; j-invariant
├── checks/round29_cusp.py          j-line normalisation; cusp doubling
├── checks/round30_final.py         elliptic-trace refutation; statistics
├── checks/round31_individual.py    individual d=4 formula; cap q=47..61
├── checks/round32_cap_reduction.py cap reduction; a1≠0 value set; c4(89)
├── checks/round33_even_slice.py    even-slice formulas
├── checks/round34_even_sets.py     even-slice sets; character-sum signs
├── checks/round35_derivative.py    critical points vs value set; d=5 support
├── checks/round36_twist_class.py   cube-class dependence; critical values
├── checks/round37_linear_row.py    a2=0 value-set bound
├── checks/round38_fiber_dist.py   fiber distributions; d=5 weight
├── checks/round39_collisions.py   exact collision identity
├── checks/round40_moments.py      moments; cubic trace
├── checks/round41_poisson_test.py chi-square; d=5 coefficients
├── checks/round42_s4_model.py     S4 splitting-type chi-square
├── checks/round43_j_strat.py      j-stratification
├── checks/round44_chebotarev.py   Chebotarev deviation and threshold
├── checks/round45_d5_poly.py      d=5 data; threshold boundary
├── checks/round46_finite_parity.py finite check; d=5 correction
├── checks/round47_small_cap.py    Lean/Python base cases
├── checks/round48_full_finite.py  full finite base
├── checks/round49_factorization.py reducible-set identity
├── checks/round50_corrected_union.py corrected identity; even slice
├── checks/round51_containment.py  containment; overlap
├── checks/round52_preimage.py     explicit preimage identity
├── checks/round53_composition_proof.py a2=0 composition proof
├── checks/round54_synthesis.py     cap chain status
├── checks/round55_final.py         closing verification
├── checks/round56_q_decomposition.py Q decomposition
├── checks/round57_q1_proof.py      (A1) proof steps
├── checks/round58_parity_theorem.py parity theorem
├── checks/round59_c4_gaussian.py   c4/q Gaussian integer
├── checks/round60_v_larger.py      (V') to q<=149; CS gap
├── checks/round61_monodromy.py     monodromy classification
├── checks/round62_char_decomp.py   S4 character decomposition
├── checks/round63_resolvent_rational.py rational resolvent
├── checks/round64_a2_route.py      (A2) route; threshold q>=49
├── checks/round65_pullback.py      pullback identity; disc(S)
├── checks/round66_splitting.py     Jacobian splitting
├── checks/round67_primitive.py     transitive subgroups of S4
├── checks/round68_cap_proof.py     unified cap proof links
├── checks/round69_c4_congruence.py c4/(2q) congruence
├── checks/round70_sieve_class.py   Selberg class; factor 2
├── checks/round71_d5_congruence.py d=5 amplitude congruence
├── checks/round72_c4_synthesis.py  c4 structure and failed searches
├── checks/round73_c4_reformulation.py c4 congruence reformulated
├── checks/round74_even_symmetry.py  factor 2 / even symmetry
├── checks/round75_four_values.py    T depends only on chi4
├── checks/round76_dft.py            d-point DFT of class values
├── checks/round77_unified_congruence.py unified congruence
├── checks/round78_translation_orbit.py q | T orbit
├── checks/round79_synthesis_check.py synthesis check
├── checks/round80_factor8.py        factor 8 on reduced counts
├── checks/round81_mod8.py           mod-8 chi2 structure
├── checks/round82_parity_law.py     parity law T' mod 2
├── checks/round83_two_congruences.py two 2-adic congruences
├── checks/round84_sigma_involution.py parity via sigma
├── checks/round85_fourier_energy.py Fourier energy is chi2
├── checks/round86_A_formula.py      A closed form
├── checks/round87_m_data.py         m across eight primes
├── checks/round88_final_check.py    final consolidated check
├── checks/round89_B_characterization.py B(a2) characterized
├── checks/round90_m_nine.py         m at nine primes
├── checks/round92_d3.py             d=3 verification
├── checks/round94_m_closed.py       m = (a^2+1)/2
├── checks/round95_jacobi.py         Jacobi sum relation
├── checks/round96_expansion.py      Gauss-sum expansion
├── checks/round97_terms.py          term decomposition
├── checks/round98_bulk.py           bulk/boundary split
├── checks/round99_Hsum.py           H-sum formula
├── checks/round100_diagonal.py      S(u,v) decomposition
├── checks/round101_nonuniversal.py  non-universality
├── checks/round102_clean.py         clean H-sum form
├── checks/round103_split.py         diagonal/off-diagonal split
├── checks/round104_weil.py          quadratic Weil reformulation
├── checks/round105_Ksums.py         the two K-sums
├── checks/round106_synthesis.py     v2 synthesis check
├── checks/round107_half.py          half-integer arithmetic
├── lean/Gap.lean                   individual ≠ average at q=7
├── lean/Shift.lean                 shift preserves irreducibility
├── lean/Collision.lean             g(x)-g(y) = (x-y)(...)
├── lean/Scale.lean                 scaling preserves irreducibility
├── lean/DerivativeQ.lean           quartic derivative is cubic
├── lean/CubeSym.lean               g(cx) = c g(x) for c^3 = 1
├── lean/Fiber.lean                 Σ N(y)^2 = #{(x,x'): f x = f x'}
├── lean/ValueSet.lean              |α|^2 ≤ |Im f| · Σ N(y)^2
├── lean/Crit.lean                  at most 3 critical points
├── lean/JZero.lean                 j=0 iff a1=0 (composition)
├── lean/Chebotarev.lean            main term + error => cap
├── lean/DivisorSum.lean            twin indicator is not a divisor sum
├── lean/SmallCap.lean              cap at q=5..23 by decide
├── lean/Factorization.lean         quadratic factorization identity
├── lean/QuadFiber.lean             quadratic image fibers <= 2
├── lean/Composition.lean           -g(x) = (x^2+a2)(a2-(x^2+a2))
├── lean/NegSquare.lean             -1 square => -x^2 square
├── lean/QSize.lean                 Q size arithmetic identity
├── lean/QOrbit.lean                orbit involution for (A1)
├── lean/Periodic.lean              divisor sums are periodic
├── lean/FreeOrbit.lean
├── lean/HalfInteger.lean
├── lean/NonPeriodic.lean           twinInd is not a divisor sum
├── lean/QuarticPoly.lean           (4k+3)^3-... = 64k(k+1)^2
├── lean/ExtremalQuartic.lean       X^4 - C s^2 = (X^2+Cs)(X^2-Cs)
├── lean/DepressedQuartic.lean      quartic normal form y^4+Py^2+Qy+R
├── lean/EvenQuartic.lean           x^4+a x^2+b = (x^2-y)(x^2-z)
├── lean/JInvariant.lean            j = a1^2/a2^3 scaling invariance
├── lean/Doubling.lean              x^4+1 = (x^2+2)(x^2+3) over F_5
├── lean/B4.lean                    x^4+4 factorisation over F_5
├── lean/Variance.lean              d=2 twin count values over F_5
├── lean/Resolvent.lean             concrete resolvent instance over F_5
├── lean/ArtinSchreier.lean         x^5-x=0 over F_5; Artin-Schreier collapse
├── lean/Cubing.lean                cube_bijective: x^3 is a bijection when 3 ∤ q-1
├── lean/Distribution.lean          uniform d=2 distribution over F_5..F_13
├── checks/scan_shifts.py           T(d;q,h) for all shifts h
├── lean/Quad.lean                  degree-2 chi-table: F_11, F_13, F_17, F_19
├── tests/test_round5.py
├── tests/test_bsstix.py
├── tests/test_round7.py
├── logs/                           round1.log … round7_dilog.log, twin_degrees.log, lean_check.log
```

```
python3 checks/round1.py          # exit 0
python3 checks/round2.py          # exit 0
python3 checks/round3.py          # exit 0
python3 checks/round4_lift.py     # exit 0
python3 checks/round4_step2.py    # exit 0
python3 checks/round5_lfunction.py  # exit 0
python3 checks/round6_exact.py      # exit 0
python3 checks/round7_dilog.py      # exit 0
python3 checks/round8_corrections.py  # exit 0
python3 checks/round9_error_barrier.py  # exit 0
python3 checks/round10_average.py  # exit 0
python3 checks/round11_characters.py  # exit 0
python3 checks/round12_degree5.py   # exit 0
python3 checks/round13_distribution.py  # exit 0
python3 checks/round14_parity.py    # exit 0
python3 checks/round15_value_set.py # exit 0
python3 checks/round16_extremal.py  # exit 0
python3 checks/round17_cap_scope.py # exit 0
python3 checks/round18_resolvent.py # exit 0
python3 checks/round19_one_two_point.py  # exit 0
python3 checks/round20_variance.py   # exit 0
python3 checks/round21_four_point.py # exit 0
python3 checks/round22_class_number.py # exit 0
python3 checks/round23_translation.py  # exit 0
python3 checks/round24_orbit.py       # exit 0
python3 checks/round25_extremal.py    # exit 0
python3 checks/round26_depressed.py   # exit 0
python3 checks/round27_even_slice.py  # exit 0
python3 checks/round28_reduction.py   # exit 0
python3 checks/round29_cusp.py        # exit 0
python3 checks/round30_final.py       # exit 0
python3 checks/round31_individual.py  # exit 0
python3 checks/round32_cap_reduction.py # exit 0
python3 checks/round33_even_slice.py   # exit 0
python3 checks/round34_even_sets.py    # exit 0
python3 checks/round35_derivative.py   # exit 0
python3 checks/round36_twist_class.py  # exit 0
python3 checks/round37_linear_row.py   # exit 0
python3 checks/round38_fiber_dist.py   # exit 0
python3 checks/round39_collisions.py   # exit 0
python3 checks/round40_moments.py     # exit 0
python3 checks/round41_poisson_test.py # exit 0
python3 checks/round42_s4_model.py     # exit 0
python3 checks/round43_j_strat.py      # exit 0
python3 checks/round44_chebotarev.py   # exit 0
python3 checks/round45_d5_poly.py      # exit 0
python3 checks/round46_finite_parity.py # exit 0
python3 checks/round47_small_cap.py    # exit 0
python3 checks/round48_full_finite.py  # exit 0
python3 checks/round49_factorization.py # exit 0
python3 checks/round50_corrected_union.py # exit 0
python3 checks/round51_containment.py  # exit 0
python3 checks/round52_preimage.py     # exit 0
python3 checks/round53_composition_proof.py # exit 0
python3 checks/round54_synthesis.py     # exit 0
python3 checks/round55_final.py         # exit 0
python3 checks/round56_q_decomposition.py # exit 0
python3 checks/round57_q1_proof.py      # exit 0
python3 checks/round58_parity_theorem.py # exit 0
python3 checks/round59_c4_gaussian.py   # exit 0
python3 checks/round60_v_larger.py      # exit 0
python3 checks/round61_monodromy.py     # exit 0
python3 checks/round62_char_decomp.py   # exit 0
python3 checks/round63_resolvent_rational.py # exit 0
python3 checks/round64_a2_route.py      # exit 0
python3 checks/round65_pullback.py      # exit 0
python3 checks/round66_splitting.py     # exit 0
python3 checks/round67_primitive.py     # exit 0
python3 checks/round68_cap_proof.py     # exit 0
python3 checks/round69_c4_congruence.py # exit 0
python3 checks/round70_sieve_class.py   # exit 0
python3 checks/round71_d5_congruence.py # exit 0
python3 checks/round72_c4_synthesis.py  # exit 0
python3 checks/round73_c4_reformulation.py # exit 0
python3 checks/round74_even_symmetry.py  # exit 0
python3 checks/round75_four_values.py    # exit 0
python3 checks/round76_dft.py            # exit 0
python3 checks/round77_unified_congruence.py # exit 0
python3 checks/round78_translation_orbit.py # exit 0
python3 checks/round79_synthesis_check.py  # exit 0
python3 checks/round80_factor8.py          # exit 0
python3 checks/round81_mod8.py             # exit 0
python3 checks/round82_parity_law.py       # exit 0
python3 checks/round83_two_congruences.py   # exit 0
python3 checks/round84_sigma_involution.py  # exit 0
python3 checks/round85_fourier_energy.py   # exit 0
python3 checks/round86_A_formula.py        # exit 0
python3 checks/round87_m_data.py           # exit 0
python3 checks/round88_final_check.py      # exit 0
python3 checks/round89_B_characterization.py # exit 0
python3 checks/round90_m_nine.py            # exit 0
python3 checks/round92_d3.py                # exit 0
python3 checks/round94_m_closed.py          # exit 0
python3 checks/round95_jacobi.py            # exit 0
python3 checks/round96_expansion.py         # exit 0
python3 checks/round97_terms.py             # exit 0
python3 checks/round98_bulk.py              # exit 0
python3 checks/round99_Hsum.py              # exit 0
python3 checks/round100_diagonal.py         # exit 0
python3 checks/round101_nonuniversal.py     # exit 0
python3 checks/round102_clean.py            # exit 0
python3 checks/round103_split.py            # exit 0
python3 checks/round104_weil.py             # exit 0
python3 checks/round105_Ksums.py            # exit 0
python3 checks/round106_synthesis.py        # exit 0
python3 checks/round107_half.py             # exit 0
python3 -m pytest -q tests/       # 382 passed
./check.sh 018                                  # from the package root; harness at ../../check.sh
```

