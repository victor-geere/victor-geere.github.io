# H — the two papers

Everything in this file is one arc: what happened when two published papers on
Jensen polynomials for ξ arrived in this directory, and were used as answer
keys, as sources of criteria, and finally as things to check. **H1 through H6
are all done.** This file is self-contained — it repeats the definitions it
needs rather than pointing elsewhere — and every number in it is produced by a
driver named beside it.

---

## The two papers

| | |
|---|---|
| **[GOR⁺]** | Michael J. Griffin, Ken Ono, Larry Rolen, Jesse Thorner, Zachary Tripp, Ian Wagner, *Jensen polynomials for the Riemann xi-function*, **Advances in Mathematics 397 (2022) 108186**. In this directory as `jensens-polynomials.pdf`. |
| **[O'S]** | Cormac O'Sullivan, *Zeros of Jensen polynomials and asymptotics for the Riemann xi function*, **arXiv:2007.13582v2**. In this directory as `zeros-jensens-polynomials.pdf`. |

Two further papers are cited but not held here: **[GORZ19]** = Griffin, Ono,
Rolen, Zagier, *Jensen polynomials for Riemann's zeta function and suitable
arithmetic sequences*, PNAS **116**(23) (2019) 11103–11110, which is [GOR⁺]'s
reference [11]; and **[Far]** =
Farmer, *Jensen polynomials are not a viable route to proving the Riemann
hypothesis*, arXiv:2008.07206, which is [GOR⁺]'s reference [10] and which both
papers cite approvingly. Read Farmer before reading anything here as a route to
RH; it is not one, and [GOR⁺]'s own Remark (3) says as much from the inside.

## What every H item shares: γ(n)

Both papers expand ξ about the critical point and both use **exactly this
directory's coefficient**, with no rescaling:

```text
ξ(½ + z) = Σ_{j≥0} γ(j)/j!·z^{2j}          [GOR⁺] (1.1)
γ(n)     = n!/(2n)!·ξ^{(2n)}(½)            [O'S] (1.2)
```

and in this directory's own notation, with Φ the horn's weight,

```text
Φ(u)      = Σ_{k≥1} ( 2π²k⁴e^{9u/2} − 3πk²e^{5u/2} )·e^{−πk²e^{2u}}
Γ_Φ(w)    = 4∫₀^∞ u^w Φ(u)du = 4∫_{−∞}^{∞} e^{(w+1)v}Φ(e^v)dv
a(n) = γ(n) = Γ_Φ(2n)·n!/(2n)!
```

That agreement is what makes every table in both papers usable as an answer
key, and it is the first thing H1 checked. ([GORZ19]'s γ is **8 times larger**;
that factor reappears in H4 and H5, in [GOR⁺]'s own text.)

The two polynomial families, both equivalent to RH over all (d, n):

```text
J^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j                [GOR⁺] (1.2)
P^{d,n}(X) := Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X)         [O'S] (1.4)
```

with H the Hermite polynomials. [O'S] Corollary 3.8: J^{d,n} hyperbolic ⟹
P^{d,n} hyperbolic, so P is a *strictly weaker* condition carrying the *same*
equivalence. Most of the H track is about what that weakening is worth.

---

## H1 — a(n) at n = 1000, against [O'S] Table 1

**Driver:** `rust/src/bin/h1_moment.rs`. **Modules:** `mellin`, `jensen`.

[O'S] Theorem 1.4's table prints γ(1000) = 4.8450426112725879772 × 10⁻²⁵⁶⁸.
The crate returns

```text
a(1000) = 4.8450426112725879772e-2568
```

— **every digit they print** — and the value is unchanged under h doubled, h
halved, V₁ raised, V₀ raised, and a 90-digit run. It is the first external
high-precision check this directory has ever had of its own a(n).

The comparison is saturated by *their* precision, not ours. The rule's actual
accuracy, measured by comparing rules against each other at 150 digits:

| h | nodes | correct digits vs the next halving |
|---|---|---|
| 0.008 | 426 | 10.72 |
| 0.004 | 851 | 40.58 |
| 0.002 | 1701 | **133.51** |
| 0.001 | 3401 | 169.80 (at the 173-digit floor) |

Each halving roughly **triples** the correct digits. At the standard h = 0.002
the quadrature error at n = 1000 is ~10⁻¹³³.

Also: a(0) = 0.49712077818831410991 = ξ(½), which is item A3 arriving from the
other end.

**Two corrections came out of H1 and are recorded below**: E10 (a retracted
feasibility claim) and E11 (what `prec_digits()` actually resolves).

---

## H2 — P^{d,n}, and what it is worth to a certificate

**Driver:** `rust/src/bin/h2_pjensen.rs`. **Modules:** `hermite`, `jensen`.

Both families are certified by *identical* arithmetic — the discriminant is
lc^{2d−2}·det H for the Hankel matrix of power sums, H positive definite ⟺ all
d roots real and simple, decided by an interval LDLᵀ — so their tolerances are
directly comparable. The measure is **`max width`**: the largest relative
enclosure *half*-width on each γ(n) at which the sign is still decided, found
by bisection with a ceiling of 1.

| d | J `max width`, n = 0 → 30 | P `max width`, n = 0 → 30 | P/J at n = 30 |
|---|---|---|---|
| 2 | 5.035e−3 → 9.443e−4 | 8.790e−1 → 9.281e−1 | 9.8e2 |
| 3 | 7.909e−6 → 3.729e−7 | 5.042e−2 → 5.060e−2 | 1.4e5 |
| 4 | 7.569e−9 → 1.105e−10 | 3.078e−3 → 3.093e−3 | 2.8e7 |
| 5 | 4.421e−12 → 2.323e−14 | 1.395e−4 → 1.403e−4 | 6.0e9 |
| 6 | 1.709e−15 | 5.383e−6 | — |

- Every P certifies wherever J does — Corollary 3.8, confirmed on all 35 cells.
- **The smallest advantage anywhere is 175×**, at (2, 0). At d = 2, P's sign
  survives every coefficient being wrong by a factor of two: `max width` 0.93
  against the scale's end at 1.0, where the leading coefficient reaches zero
  and the polynomial loses its degree.
- **P's cost of degree is ~1.3 decades per unit of d, against J's ~3.5.**
- **P's tolerance is flat in n — it even rises slightly — where J's falls by
  one to three decades over the same range.** This is the property that
  matters and it was not predicted: a bound on γ(n) good enough for P at n = 0
  is good enough for P at *every* n, whereas J's requirement keeps tightening.
- The d = 2 identities check exactly against [O'S] (1.5)/(1.6): at n = 30 the
  J margin is 1.33e−118 and the P margin 1.95e−112 — the 2γ(n)² term is six
  decades of free slack.

**This moved item G1's target by twelve orders of magnitude**, from 3.6e−18 at
(6, 30) to 5.4e−6 at d = 6, flat in n.

---

## H3 — where the Turán criteria actually start to hold

**Driver:** `rust/src/bin/h3_onset.rs`. **Module:** `turan`.

Both papers certify through the same theorem — Turán's Theorem III, [Tur59],
quoted as [GOR⁺] (2.10) and [O'S] (8.1): for G(z) = Σ_{j=0}^{N} c_j H_j(z),

```text
Σ_{j=0}^{N−2} 2^j·j!·c_j²  <  2^N·(N−1)!·c_N²                        (Tur)
```

implies every zero of G is real and simple. And both bound the onset only
asymptotically — **n ≥ c·e^d** for J ([GOR⁺] Theorem 1.1, with **c never
given**) and **n/log²n ≥ d^{3/4}/2** for P ([O'S] Theorem 1.3, "d large").
Where it actually starts is a finite computation.

For P, (Tur) applies with no transformation at all, because P is already a
combination of Hermite polynomials:

```text
Σ_{j=2}^{d}  d/(2^j·j!)·C(d,j)·γ(n+j)²/γ(n)²  <  1                   [O'S] (8.2)
```

For J it does not, so [GOR⁺] first renormalise, using the uniformizer

```text
Δ(M) := √( ½·(1 − γ(M−2)γ(M)/γ(M−1)²) )                              (2.3)
J̃^{d,n}(X) := γ(n+d)^{d−1}/(γ(n+d−1)^d·Δ(n+d)^d)
              · J^{d,n}( γ(n+d−1)/γ(n+d)·(Δ(n+d)X − 1) )             (2.6)
A_{d,k}(n) := [X^{d−k}] J̃                                            (2.7)
c_{d,n,j}  := Σ_{i=0}^{⌊j/2⌋} (d−j+2i)!/(i!(d−j)!)·A_{d,j−2i}(n)     (2.8)
Σ_{j=3}^{d} 2^{−j}·(d−j)!/(d−1)!·c_{d,n,j}²  <  1                     (2.9)
```

### The headline, and it is H2 again from the other side

> **[O'S]'s criterion for P holds at n = 0 for every d ≤ 400.
> [GOR⁺]'s for J holds at n = 0 only for d ≤ 7.**

A factor of **57 in the degree reachable at no cost in n at all**. H2 measured
the same asymmetry as 175× to 6.0e9× in tolerable enclosure width at fixed
(d, n); this is the same fact in the currency of the criteria themselves. The
crossing for P is sharp: (8.2) = **0.993195 at d = 400** and **1.000691 at
d = 401**.

| d | 2 | 8 | 90 | 303 | 400 | 401 | 454 | 681 | 1021 |
|---|---|---|---|---|---|---|---|---|---|
| **P**: n₀ | 0 | 0 | 0 | 0 | 0 | — | 2 | 10 | 24 |
| **P**: (8.2) at n = 0 | 6.2e−8 | 6.9e−6 | 1.1e−2 | 0.430 | 0.993 | 1.001 | — | — | — |

| d | 3–7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|---|---|---|---|---|---|---|---|---|---|---|
| **J**: n₀ | 0 | 51 | 129 | 251 | 434 | 693 | 1048 | 1518 | 2126 | 2897 |

Every J row is a genuine first crossing — (2.9) sits at 0.9983…0.9999 at n₀ and
above 1 at n₀ − 1.

- **Against the published bounds.** Where both are defined, [O'S] Theorem 1.3's
  sufficient bound overshoots the true onset by **296× to 1602×**. [GOR⁺]'s
  cannot be compared at all: no c is given. What can be said is that the
  measured J onset grows *more slowly* than e^d over 8 ≤ d ≤ 16 — the implied c
  falls from 0.0171 to 0.0003 — so the exponential regime their proof needs has
  not begun at these degrees.
- **The implementation is checked against the papers' own lemma.** [GOR⁺]
  Lemma 2.3 says A_{d,0} = 1, A_{d,1} = 0, A_{d,2} = −d(d−1), and that
  J̃^{2,n} = H₂(X/2) identically. All four hold to 40 digits across d = 2…12 and
  n = 0…40 — and they are what settles that the Δ^d of (2.6) belongs in the
  **denominator**, which the paper's typography leaves ambiguous and which the
  wrong choice gets wrong by a factor of Δ^{2d}.
- **The criterion is checked to be sufficient**: wherever either criterion
  holds, the discriminant route certifies the same polynomial.
- **Precision is not the obstacle, measured rather than assumed.** The J
  renormalisation is an alternating sum whose max-term-over-sum reaches 1e77,
  which looks fatal. It is not: recomputing γ(0) … γ(2914) at **120** digits
  moves (2.9) at every n₀ by at most **3.0e−54**. The huge ratios are
  coefficients genuinely near zero that contribute nothing; the naive
  cancellation metric overstates by seventy decades, and only the precision
  cross-check settles it.

**What it does not say.** These are onsets of a *sufficient* criterion, not of
hyperbolicity. The discriminant route decides every cell in the small-d table
at n = 0 — including the d = 8 where J's criterion needs 51 moments — and
Chasse settled d ≤ 2 × 10¹⁷ for all n in 2013. What H3 measures is the price of
a criterion that is *uniform in n and provable* against one that is a finite
check with no uniformity at all.

**And see E19**: H6 later showed that "d ≤ 400" is a property of [O'S]'s
particular normalisation rather than of Ω = e^{−z²}. It moves as σ^{−4/3} under
a rescaling, and to **10141** under a translation — both still legal choices of
Ω, both leaving the comparison with [GOR⁺]'s 7 intact as a statement about the
two *published* criteria and not about the two Ω.

---

## H4 — γ(n) from two representations that are not the horn

**Driver:** `rust/src/bin/h4_crosscheck.rs`. **Modules:** `crossref`, `quad`.

H1 compared one number against one number. A transcription error in Φ, in the
substitution, or in the n!/(2n)! prefactor would have to be shared by [O'S]'s
table to survive — but the *route* was never tested. H4 computes γ(n) three
more ways, with a quadrature the crate did not previously own.

```text
ξ^{(2n)}(½) = 2^{1−2n}∫₁^∞ (log t)^{2n}·ω(t)·t^{−3/4} dt                [O'S] (7.1)
γ(M)        = M!/(2M)!·[32·C(2M,2)·F(2M−2) − F(2M)]/2^{2M−1}           [GOR⁺] (3.1)
F(z)        = ∫₁^∞ (log t)^z·t^{−3/4}·Σ_{k≥1}e^{−πk²t} dt
ω(t)        = Σ_{k≥1}(2π²k⁴t² − 3πk²t)e^{−πk²t}                        [O'S] (6.1)
```

plus a control: `xi_2n_direct_u`, the horn's own integrand 4∫₀^∞u^{2n}Φ(u)du on
a **uniform** grid in u, where the horn's grid is geometric. The rule for the
two t-integrals is **composite Gauss–Legendre** at 48 nodes per panel
(`quad.rs`, new): an m-node Gauss rule is exact on degree 2m − 1 and converges
like ρ^{−2m} on a Bernstein ellipse, and nothing about the finite endpoint
t = 1 enters — which is exactly the defect the trapezoid has there.

Being honest about what is and is not independent: (7.1) is the horn's own
integral after t = e^{2u}, so it is not a different *identity*. What differs,
and what the check can therefore catch, is everything computational.

| | horn | (7.1) here | (3.1) here |
|---|---|---|---|
| variable | v, with u = e^v | t | t |
| nodes | geometric in u | Gauss–Legendre in t | Gauss–Legendre in t |
| weight | e^{(w+1)v} | (log t)^{2n}·t^{−3/4} | (log t)^z·t^{−3/4} |
| amplitude | Φ(u), shells in e^{2u} | ω(t), shells in t | ψ(t), shells in t |
| rule error | Euler–Maclaurin + A3 tail | ρ^{−2m} per panel | ρ^{−2m} |
| assembly | one integral | one integral | a **difference** of two |

### They agree to the arithmetic floor

At 60 digits requested (77 resolvable — see E11), agreeing decimal digits:

| n | γ(n) | uniform-u | (7.1) | (3.1)/8 | (7.1) vs uniform-u |
|---|---|---|---|---|---|
| 0 | 4.97120778188e−1 | 27.6 | 27.6 | — | 71.7 |
| 1 | 1.14859721576e−2 | 69.3 | 69.3 | 69.3 | 71.6 |
| 4 | 9.58134372323e−8 | 73.5 | 68.1 | 66.4 | 68.1 |
| 8 | 8.46627186646e−15 | 73.0 | 66.8 | 62.8 | 66.8 |
| 12 | 4.37967586840e−22 | 72.7 | 66.7 | 61.4 | 66.7 |

and at **n = 1000** all three agree to **72.9 digits** and reproduce [O'S]
Table 1's twenty printed digits, in 1.8 s.

### [GOR⁺] (3.1) as printed returns 8γ(M) — see E18

Integrating ω = 2t²ψ″ + 3tψ′ by parts twice against ψ (the derivation [GOR⁺]
omit) gives

```text
∫₁^∞(log t)^{2M}·ω(t)·t^{−3/4}dt = 4·C(2M,2)·F(2M−2) − F(2M)/8
```

so with (7.1) the denominator is 2^{2M+2}, not the printed 2^{2M−1}. The ratio
is **exactly 8.00000000000000000000000000000** at every M from 1 to 12, to
thirty digits. That is precisely the factor [GORZ19]'s γ carries over
[GOR⁺]'s own (1.1) — [O'S] says so in as many words under Table 1 — and (3.1)
is cited to [GORZ19, Eq. 13]. So it is a normalisation carried across without
conversion, not an error in [GOR⁺]'s proof: (3.1) is used only through the
asymptotic (3.2), where the same factor appears again (H5).

### The one place the horn is the one that is off

At n = 0 the three routes split, and the two new ones agree with each other to
71.7 digits while the horn differs by 2.31e−28. The cause is the horn's own
documented Euler–Maclaurin boundary term: `Mellin::standard` truncates at
V₀ = −50, where the integrand e^{(w+1)v}Φ(e^v) is still e^{V₀}Φ(0), so the
trapezoid leaves +4·(h²/12)·f′(V₀). For n ≥ 1 the weight is e^{(2n+1)V₀} and it
vanishes; at n = 0 it does not.

| V₀ | γ(0) − (7.1), relative | 4(h²/12)e^{V₀}Φ(0)/Γ_Φ(0) | ratio |
|---|---|---|---|
| −16 | 1.34827e−13 | 1.34827e−13 | 1.00000 |
| −30 | 1.12113e−19 | 1.12113e−19 | 1.00000 |
| −50 | 2.31082e−28 | 2.31082e−28 | 1.00000 |
| −70 | 4.76295e−37 | 4.76295e−37 | 1.00000 |
| −90 | 9.81717e−46 | 9.81717e−46 | 1.00000 |

Six significant figures at every V₀, over **thirty-three decades** — the
mechanism is identified, not merely observed. At V₀ = −110 the horn agrees with
(7.1) to 53.7 digits, so it is the horn that converges to the new routes and
not the other way about. **Nothing published in this directory is affected**:
the tightest tolerance ever asked of γ(0) is H2's 1.709e−15, thirteen decades
above the gap.

### The other correction: there is no cancellation here — see E17

ω(t) = Σ πk²t(2πk²t − 3)e^{−πk²t} is **positive for every t ≥ 1**, because
2πt > 3 already at t = 1; and ψ(t) = Σe^{−πk²t} is positive by inspection. So
(7.1) and F(z) integrate positive integrands, and (3.1)'s difference does not
cancel either — its first term beats the second by ~64M²/(log M)². Φ's famous
cancellation lives entirely on u < 0, i.e. t < 1, which neither representation
visits.

Two structural identities are checked as arithmetic rather than asserted:
**Φ(u) = e^{u/2}·ω(e^{2u})** to sixty digits on both sides of the throat (which
is the identification of this directory's construction with Romik's and
Jensen's, in one line), and **ω = 2t²ψ″ + 3tψ′**, which is what the integration
by parts behind (3.1) rests on.

---

## H5 — the Lambert-W asymptotic

**Driver:** `rust/src/bin/h5_asymptotic.rs`. **Module:** `lambert`.

[O'S] Theorem 1.4. With **w := W(2n/π)**, W the Lambert function,

```text
γ(n) = 4π²·e^{7w/4}·√(w/(w+1))·( e·w²/(16·n·e^{2/w}) )^n
       · ( 1 + Σ_{k=1}^{K−1} c_k(w)/n^k + O(log^K n / n^K) )
```

The paper prints c₁ and c₂ in closed form and describes **every** c_k through a
chain of five formulas. That chain is implemented here in full:

```text
B̂_{i,j}(p₁,p₂,…)  : (p₁x + p₂x² + ⋯)^j = Σ_{i≥j} B̂_{i,j}·x^i           (2.1)
ℓ_i(u)   = Σ_{j=1}^{i} B̂_{i,j}(1,−½,⅓,…)·(−1)^{j+1}/(j·u^j)            (2.6)
a_r(β;v) = Σ_{j=0}^{2r} (2j+2r−1)!!/j! · (v²/(v+1))^{j+r}
             · Σ_{i=j}^{2r} B̂_{i,j}(ℓ₃(v),ℓ₄(v),…)·C(β, 2r−i)           (7.4)
μ_r(w)   = 2^{−r−1}·( 2·a_r(5/4;w) − 3w·a_{r−1}(1/4;w) )               (7.7)
κ_m      = (2m−1)!!·Σ_{j=0}^{2m} C(−m−½,j)·B̂_{2m,j}(−⅔,½,−⅖,…)         (7.11)
κ*_k     = Σ_{j=0}^{k} (−2)^{−j}·κ_j·κ_{k−j}                           (7.13)
c_k(w)   = Σ_{j=0}^{k} μ_j(w)·κ*_{k−j}                                 (7.13)
```

with a_{−1} := 0 so μ₀ = 1. The κ_m are Stirling's own coefficients and κ*_k
those of n!/(2n)! = 2^{−½}(e/4n)^n(1 + Σκ*_k/n^k), [O'S] (7.14).

### Everything the paper prints is reproduced

- **μ₁(w)** against the rational function under (7.6);
- **c₁(w)** against (1.8), to 5.0e−76 relative;
- **c₂(w)** against the eight-degree rational function under (7.14);
- **κ_m** = 1, 1/12, 1/288, −139/51840, −571/2488320 — Stirling's classical
  coefficients, from (7.11) alone;
- **(7.14)** against the crate's own exact n!/(2n)!;
- **W** by Newton on w + log w = log x, checked against W(1) = the omega
  constant 0.5671432904097838730 and against W(x)e^{W(x)} = x to 50 digits.

### [O'S] Table 1, all four rows

At n = 1000, w = W(2000/π) = 4.87255428106479306986486:

| K | Theorem 1.4 | [O'S] Table 1 |
|---|---|---|
| 1 | 4.8460204243211378239e−2568 | 4.8460204243211378239e−2568 |
| 3 | 4.8450426111532216799e−2568 | 4.8450426111532216799e−2568 |
| 5 | 4.8450426112725884216e−2568 | 4.8450426112725884216e−2568 |
| 7 | 4.8450426112725879772e−2568 | 4.8450426112725879772e−2568 |
| | 4.8450426112725879772e−2568 | γ(1000), this crate (H1) |

Every row to all twenty digits printed. This is a single check on the whole
Bell chain **and** on H1's quadrature at once, from a direction that shares no
arithmetic with it.

### Where the asymptotic series turns around

An asymptotic series improves to a point and then diverges. Agreeing decimal
digits, as a function of the truncation K:

| n \ K | 1 | 3 | 5 | 7 | 10 | 15 | 20 | 24 | best |
|---|---|---|---|---|---|---|---|---|---|
| 3 | 2.1 | 4.0 | 5.4 | **7.0** | 6.5 | 6.5 | 6.5 | 6.5 | K = 7, 7.0 digits |
| 10 | 2.1 | 5.8 | 8.3 | 10.1 | **11.2** | 11.2 | 11.2 | 11.2 | K = 8, 11.2 digits |
| 50 | 2.6 | 7.7 | 10.9 | 14.5 | 19.7 | 23.8 | 29.4 | 29.6 | K = 22, 29.7 digits |
| 200 | 3.1 | 8.9 | 13.1 | 17.3 | 22.9 | 31.7 | 38.7 | **44.7** | K = 24 (still rising) |
| 1000 | 3.7 | 10.6 | 16.0 | 21.3 | 28.6 | 40.0 | 51.2 | **58.5** | K = 24 (still rising) |

So the expansion saturates at **7 digits at n = 3** and **11 at n = 10**, and
has not turned around by K = 24 for n ≥ 200. The bare leading factor (K = 1) is
worth 2.4e−2 at n = 1 falling to 2.0e−4 at n = 1000.

**It is not a cheaper route to γ(n).** Timed against the quadrature it might
replace, at 60 digits:

| n | quadrature | K = 7 | | K = 24 | | speedup |
|---|---|---|---|---|---|---|
| | time | time | digits | time | digits | |
| 50 | 0.0093 s | 0.0019 s | 14.5 | 0.0397 s | 29.6 | 0.23× |
| 200 | 0.0105 s | 0.0019 s | 17.3 | 0.0379 s | 44.7 | 0.28× |
| 1000 | 0.0091 s | 0.0019 s | 21.3 | 0.0385 s | 58.5 | 0.24× |

The Bell chain at K = 24 costs **four times more** than 25 700 trapezoid nodes
and delivers fewer digits. At K = 7 it is five times cheaper but stops at 21
digits, which is not enough for anything in this directory. The quadrature
stays.

### [GOR⁺]'s L_M parametrisation, and (3.2)

[GOR⁺] expand the same γ in a different parameter: **L_M**, the unique positive
root of M = L_M·(π·e^{L_M} + ¾), with K_M := (L_M^{−1} + L_M^{−2})M − ¾. It is
close to but not equal to [O'S]'s w, and the gap is predictable — eliminating n
between n = (π/2)we^w and 2n−2 = L(πe^L + ¾) gives w − L ≈ (3L/8 + 1)/((π/2)e^L(1+L)):

| n | w = W(2n/π) | L_(2n−2) | w − L | predicted |
|---|---|---|---|---|
| 10 | 1.467465574120981 | 1.371157825619482 | 9.630775e−2 | 1.031839e−1 |
| 50 | 2.531591961492383 | 2.503288582539781 | 2.830338e−2 | 2.882424e−2 |
| 200 | 3.573257122242202 | 3.564077876649422 | 9.179246e−3 | 9.230791e−3 |
| 1000 | 4.872554281064793 | 4.870206007334786 | 2.348274e−3 | 2.351504e−3 |
| 5000 | 6.235372211640914 | 6.234796683694698 | 5.755279e−4 | 5.757165e−4 |

Three to four figures at every n, so the two root-finders are checked against
each other through a derived relation rather than separately.

**(3.2) itself**, whose extracted text does not fix how its factors nest — in
particular whether K_(2M−2) sits under the same radical as 2π or beside it.
Both readings were evaluated rather than chosen:

```text
γ(M) "=" e^{M−2}·M^{M+½}·L^{2M−2} / [ 2^{2M−5}·(2M−2)^{(2M−2)+½} ] · ⟨root⟩
          · exp( L/4 − (2M−2)/L + ¾ ),      L = L_(2M−2),  K = K_(2M−2)
   (A) ⟨root⟩ = 1/√(2π·K)        (B) ⟨root⟩ = √(2π/K)
```

| M | (A)/γ(M) | (B)/γ(M) | (B)/(8γ) − 1 | [O'S] K=1 error |
|---|---|---|---|---|
| 10 | 1.252409828942 | 7.869123035775 | −1.6360e−2 | 7.4522e−3 |
| 100 | 1.270308472162 | 7.981583527872 | −2.3021e−3 | 1.5170e−3 |
| 1000 | 1.272848320867 | 7.997541867938 | −3.0727e−4 | 2.0182e−4 |
| 5000 | 1.273146749925 | 7.999416953014 | −7.2881e−5 | 4.5502e−5 |

(A) tends to **4/π = 1.273239545**, which is not a normalisation anyone would
write. (B) tends to **8** — the same factor H4 measures in (3.1), from the same
source [GORZ19]. √(2π/K) is also the factor a Laplace saddle produces, which
1/√(2πK) is not. So (B) is the reading, and **both formulas [GOR⁺] quote from
[11] carry [11]'s normalisation** (E18). The residual falls like the O_ε(M^{−1+ε})
they claim, at 1.5 to 2.2 times [O'S]'s own K = 1 error.

---

## H6 — searching Ω for the criterion with the earliest onset

**Driver:** `rust/src/bin/h6_omega.rs`. **Module:** `omega`.

This is the most interesting thing in either paper. [O'S] §3 defines, for a
formal power series Φ(z) = Σ c_j z^j/j!, the Jensen polynomial and its
reciprocal, and proves a product rule for them:

```text
g_d(Φ; x)  := Σ_{j=0}^{d} C(d,j)·c_j·x^j
g*_d(Φ; x) := x^d·g_d(Φ; 1/x) = Σ_{j=0}^{d} C(d,j)·c_j·x^{d−j}
g*_d(Φ·Ω; x) = Σ_{j=0}^{d} C(d,j)·c_j·g*_{d−j}(Ω; x)      Lemma 3.4, (3.3)
```

**Theorem 3.5.** For Φ real entire of genus 1\* and **any** Ω in the
Laguerre–Pólya class, Φ is hyperbolic ⟺ every g\*_d(Φ·Ω; x) is hyperbolic.

With Φ = Θ^{(n)} (coefficients γ(n+j)): **Ω = 1 gives J^{d,n}** and
**Ω = e^{−z²} gives P^{d,n}(x/2)**, because g\*_d(e^{−z²}; x) = H_d(x/2). So Ω
is a free parameter: every choice is equivalent to RH, and H3 measured that
those two are worth d ≤ 7 against d ≤ 400. **The free parameter in this
criterion is not the degree and not w — it is Ω, and H3 supplies the cost
function.**

### One formula for all of it

Turán III needs the polynomial in the Hermite basis. Converting bases would
manufacture cancellation exactly where [O'S]'s own criterion has none, so
instead apply Lemma 3.4 a second time with Ω replaced by e^{−z²}:

```text
g*_d(Ψ; x) = Σ_j C(d,j)·χ_j·H_{d−j}(x/2),        χ := Ψ·e^{+z²}
```

Writing **M := Ω(σz)·e^{z²}** and Ψ = Θ^{(n)}·Ω, the whole criterion is

```text
χ_j = Σ_{i=0}^{j} C(j,i)·γ(n+i)σ^i·M_{j−i}
c_k = C(d, d−k)·χ_{d−k}                        (the coefficient of H_k)
T   = Σ_{k=0}^{d−2} 2^k·k!·c_k²  /  ( 2^d·(d−1)!·c_d² )      < 1
```

Restricting Ω to the Gaussian-and-shift family makes M = exp(νz² − μz) with
ν = 1 − βσ², and then **M = 1 (ν = 0, μ = 0, σ = 1) is [O'S] (8.2) term for
term** and **M = e^{z²} (ν = 1) is Turán applied to J directly**.

**σ is not a third dial.** Turán III is not affine-invariant — it is a
statement about a basis — so an affine change of variable is a genuine extra
freedom, and [GOR⁺] (2.6) spends it. But the Laguerre–Pólya class already
contains it: translation is Ω = e^{−τz}, whose g\*_d(Ω; x) = (x − τ)^d, and
scaling x → x/σ is Ψ(z) → Ψ(σz), which is Ω → Ω(σ·) — still in LP — together
with γ(n+i) → γ(n+i)σ^i. **Searching Ω over LP therefore contains the affine
group.** The only part carried separately is the σ acting on Θ^{(n)}, which is
not an LP move.

### Both papers' criteria are points of this search

| point of the search | reproduces | worst relative gap over 50 cells |
|---|---|---|
| ν = 0, μ = 0, σ = 1, g\* form | [O'S] (8.2) | 6.05e−77 |
| Ω = 1, σ = Δ/ρ, τ = −1/Δ, g form | [GOR⁺] (2.9) | 8.39e−69 |

`turan.rs` implements both from the printed formulas and never touches Lemma
3.4, so this is two derivations meeting. ([GOR⁺]'s map is
x ↦ (Δ/ρ)x − 1/ρ with ρ = γ(n+d)/γ(n+d−1), which in a scale-then-shift
parametrisation is σ = Δ/ρ and a shift of −1/Δ.)

### Dial 1: ν — and [O'S]'s Ω is a razor-sharp optimum

ν = 1 − βσ² runs from Ω = 1 (ν = 1) through Ω = e^{−z²} (ν = 0) and past it.
The Turán value T depends on the whole Gaussian family only through ν:

| ν | T at (6,10) | T at (8,20) | T at (10,30) |
|---|---|---|---|
| 1.00 | 8.068e1 | 3.944e2 | 1.795e3 |
| 0.10 | 4.546e−1 | 1.143e0 | 2.333e0 |
| 0.01 | 4.599e−3 | 1.136e−2 | 2.275e−2 |
| **0.00** | **5.183e−7** | **5.412e−7** | **5.907e−7** |
| −0.01 | 4.406e−3 | 1.105e−2 | 2.229e−2 |
| −0.10 | 4.526e−1 | 1.140e0 | 2.328e0 |
| −1.00 | 8.063e1 | 3.942e2 | 1.794e3 |

A **1% move in ν costs four decades**, in either direction, nearly
symmetrically in |ν|. And the reason is structural rather than numerical:
Turán III is a statement in the Hermite basis, and ν = 0 is the one Ω for which
the criterion polynomial is *already* in that basis — M ≡ 1, so no conversion
happens and no extra term is added to any χ_j. **[O'S] chose the optimum, and
it is the only one.**

### Dial 2: μ — and here [O'S]'s choice is *not* optimal

Ω = e^{−z²−τz} is still in LP, and g\*_d(Φ·e^{−τz}; x) = g\*_d(Φ; x − τ), so a
translation is an Ω-move rather than an extra freedom. What it buys shows up in
the term that dominates T:

```text
χ₂(μ) = γ(n+2) − 2μ·γ(n+1) + μ²·γ(n)
```

an upward parabola whose **roots** are

```text
μ± = γ(n+1)/γ(n) · ( 1 ± √2·Δ(n+2) )
```

**with Δ the very uniformizer [GOR⁺] (2.3) introduce to renormalise J.** So the
quantity one paper needs for its own family is exactly the quantity that
locates the best translation for the other paper's — and at μ = μ± the dominant
term of Turán's sum is annihilated outright.

| μ / (γ(n+1)/γ(n)) | T at (8,20) | ratio to μ = 0 |
|---|---|---|
| 0.0000 (= [O'S]'s P) | 5.41205e−7 | 1 |
| 0.5000 | 3.03029e−8 | 5.60e−2 |
| **0.8677 ← μ−** | **2.66225e−16** | **4.92e−10** |
| 1.0000 | 1.71992e−10 | 3.18e−4 |
| **1.1323 ← μ+** | **9.83711e−16** | 1.82e−9 |
| 2.0000 | 5.41204e−7 | 1 |

γ(21)/γ(20) = 1.1895509e−2 and Δ(22) = 9.3581419e−2, so 1 − √2Δ = 0.86766 —
the printed 0.8677. At (10,30) the same construction gives 1.36e−16 against
5.91e−7, a factor of 2.3e−10.

### Dial 3: σ — and why d_max at n = 0 is not a scale-invariant number

Holding ν = 0 while scaling leaves the criterion equal to (8.2) with its j-th
term multiplied by σ^{2j}. The j = 2 term dominates and carries d³, so
d³σ⁴ ≈ const and **d_max ∝ σ^{−4/3}**:

| σ | d_max at n = 0 | ratio to σ = 1 | σ^{−4/3} |
|---|---|---|---|
| 2.00 | 159 | 0.398 | 0.397 |
| 1.50 | 233 | 0.583 | 0.582 |
| 1.00 | 400 | 1.000 | 1.000 |
| 0.75 | 588 | 1.470 | 1.468 |
| 0.50 | 1010 | 2.525 | 2.520 |

Three figures at four points. **So "d ≤ 400" is a property of [O'S]'s
normalisation, not of Ω = e^{−z²}** (E19). Nothing is *gained* by shrinking σ —
the criterion at scale σ is the criterion at effective degree dσ², with the
high-j terms, the ones carrying γ's moment ratios and hence RH, suppressed
geometrically. But it means d_max is comparable across Ω only at a pinned
scale, and everything below is pinned at σ = 1.

### The leaderboard

d_max at n = 0, σ = 1. The sweep is capped at d = 1400; the two rows that reach
the cap were bisected separately with the cap raised.

| criterion | d_max at n = 0 | T at d = 8, n = 0 |
|---|---|---|
| Ω = 1, raw, g form | < 2 | 3.017e21 |
| Ω = 1, raw, g\* form | < 2 | 3.950e2 |
| Ω = J_α, α = −0.5, 0, 2, 8 | < 2 | 5.6e3 … 4.1e2 |
| Ω = cos z | 2 | 3.483e1 |
| Ω = e^{−½z²}, Ω = e^{−2z²} | 2 | 4.2e1, 3.9e2 |
| **[GOR⁺] (2.9)**, Ω = 1 renormalised | **7** | 1.355e0 |
| **[O'S] (8.2)**, Ω = e^{−z²} | **400** | 6.908e−6 |
| Ω = e^{−z²−τz}, τ = γ(1)/γ(0) | > 1400 | 3.869e−8 |
| **Ω = e^{−z²−τz}, τ = μ− (χ₂ = 0)** | **10141** | **2.539e−13** |

Every Ω that is not e^{−z²} up to a translation fails at d = 2 or 3, where
[O'S]'s reaches 400. The Bessel family behind [O'S] Theorem 3.9 — the one
extended criterion the paper itself proposes — is among the worst of them.

### The shift changes the power of d, not just the constant

The j = 2 term of Turán's sum carries d·C(d,2)/(2²·2!) ~ d³. The shift
annihilates it exactly, so j = 3 takes over and the power becomes d⁴:

| d | [O'S] P (8.2) | shifted τ = μ− |
|---|---|---|
| 100 | 1.529731e−2 | 9.163714e−9 |
| 200 | 1.232765e−1 | 1.488650e−7 |
| 400 | 9.931947e−1 | 2.399932e−6 |
| 800 | 8.028185e0 | 3.854514e−5 |
| 1400 | 4.364039e1 | 3.621151e−4 |

Fitted exponents **d^3.015** and **d^4.011**. So the shift is not a constant
factor: it changes the exponent, which in this whole search only one other move
manages — and that move is Ω = 1 → Ω = e^{−z²} itself, the one [O'S] made.

Extrapolating T = 1 from the d⁴ law puts the shifted criterion's own crossing
near d = 10095; **located directly by bisection it is d = 10141**, with
T = 0.9996992 there and 1.0000937 at d = 10142. Against [O'S]'s 400 that is a
factor of **25.4**.

### The onset, which no scale can move

d_max at n = 0 moves with σ; the *growth* of n₀(d) does not, because σ only
shifts the effective degree by a constant. This is what [GOR⁺] Theorem 1.1 and
[O'S] Theorem 1.3 actually bound, and what H3 measured.

| d | 400 | 500 | 600 | 700 | 800 | 900 | 1000 |
|---|---|---|---|---|---|---|---|
| **n₀, [O'S] P** | 0 | 3 | 7 | 10 | 15 | 19 | 23 |
| **n₀, shifted τ = μ−** | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

(One fixed Ω throughout, as Theorem 3.5 requires: μ− is computed once at n = 0
and applied at every n, not retuned per row. Retuning would only help.)

**Whether the shift improves the *exponent* of n₀(d) is not settled here**: it
would need d beyond 10⁴, where the shifted criterion first fails at n = 0, and
that is a larger computation than this item. What is settled is that it holds
at n = 0 across the entire range where P does not.

### Precision is not the obstacle, measured rather than assumed

The shift is an exact cancellation by construction — χ₂(μ−) = 0 — so it is the
one place in this search where a naive argument predicts the arithmetic to
fail. It does not: recomputing γ and the whole criterion at and at 180 (the driver's second precision; corrected 2025-10-06)
digits leaves T **identical to f64 resolution at every d from 100 to 1400**.
The alternating sum χ_j = Σ_i C(j,i)γ(n+i)(−μ)^{j−i} is dominated by terms of
one sign, because γ(n+i)/μ^i collapses once i passes about 5. This is the same
lesson H3 had to learn from the other side: the cancellation a criterion
*looks* like it has is not the cancellation it *has*, and only a precision
cross-check settles it.

### The verdict

> **Ω is a free parameter, every choice is equivalent to RH, and they differ
> enormously in how cheaply they can be verified — but the Gaussian content of
> Ω has a unique optimum and [O'S] already found it. What is left on the table
> is the translation, and it is worth a change of exponent: d³ → d⁴, d_max at
> n = 0 from **400 to 10141**, and n₀(d) = 0 across the whole range where P's
> is not. The translation that does it is located by [GOR⁺]'s own Δ.**

Two caveats, stated plainly. First, none of this is closer to RH: these are
sufficient conditions on finitely many (d, n), and Chasse's d ≤ 2 × 10¹⁷ for
all n has been known since 2013. Second, the shifted criterion is a *legal*
choice of Ω for Theorem 3.5 — Ω = e^{−z²−μz} is in LP and is fixed across d, as
the theorem requires; μ depends on n only, which [GOR⁺]'s own renormalisation
(depending on both n and d) does not manage.


---

## What the H track adds up to

1. **The crate's γ(n) is right**, checked four ways: against [O'S] Table 1's
   twenty digits (H1); against two independently-derived integral
   representations, at 66–73 digits, with a quadrature family the crate did not
   previously own (H4); against the horn's own integrand on a different grid
   (H4 again); and against a fully-expanded asymptotic series (H5).
2. **The choice of criterion dominates everything else.** P over J is worth
   175× to 6.0e9× in tolerable enclosure width (H2) and 57× in reachable degree
   (H3). Exactly two moves in the whole Ω search change an *exponent* rather
   than a constant: the one [O'S] made (Ω = 1 → e^{−z²}, which took the
   published bound from e^{0.96d} to d^{3/4}log²n) and the one left behind
   (the translation, d³ → d⁴) — everything else, including the scale, moves
   only the constant (H6).
3. **Three published formulas needed correction or disambiguation**, all
   recorded and none affecting the papers' theorems: [GOR⁺] (3.1)'s and
   (3.2)'s normalisation, both off by 8 (E18); (3.2)'s radical, which the
   extracted text does not nest (H5); and (2.6)'s Δ^d, which the paper's
   typography leaves ambiguous and which the wrong reading gets wrong by
   Δ^{2d} (H3).
4. **None of it is a route to RH**, and this is not a hedge. The criteria are
   sufficient conditions on finitely many (d, n); Chasse 2013 has d ≤ 2 × 10¹⁷
   for all n and [GOR⁺] Corollary 1.3 reaches 9 × 10²⁴, so nothing here extends
   what is known about hyperbolicity. What the H track contributes is a
   measured account of *how expensive each criterion is to check*, which is a
   different question and the only one this directory can answer.

---

## Corrections made along the way

Numbered as in [TODO.md](TODO.md)'s correction register, and repeated here so
this file stands alone.

- **E10.** *"The binding constraint is node density"* (H1, as first written).
  Wrong, and by a hundred digits. It reasoned from the Laplace width — 4.6
  nodes across the peak at n = 1000 — and concluded the rule was at its limit.
  Measured: at h = 0.004, i.e. **2.3** nodes across the width, γ(1000) is still
  correct to 40 digits. Counting nodes across a peak estimates *algebraic*
  convergence; the trapezoid rule on an integrand analytic in a strip and
  doubly-exponentially decaying at both ends converges **geometrically**. Any
  future capacity estimate for this quadrature that counts nodes is repeating
  the error.
- **E11.** `prec_digits()` is not what the scalar resolves. astro-float rounds
  the requested precision up to whole 64-bit words, so `set_prec_digits(60)`
  asks for 216 bits and gets a 256-bit mantissa: two values can differ by
  10⁻⁷⁷ where the request implies 10⁻⁶⁵. `real::resolvable_digits()` now
  reports the true figure and every agreement column in the H drivers is capped
  at it. Nothing is affected in an unsafe direction — `ulp()` is computed from
  the *request*, so interval enclosures are wider than needed, never narrower.
- **E17.** *"Neither is the quadrature the crate uses, and both have
  cancellation in them — which is what 60 digits is for"* (H4's own
  specification, as first written). The second half is wrong. ω(t) =
  Σ πk²t(2πk²t − 3)e^{−πk²t} and ψ(t) = Σe^{−πk²t} are both **positive for
  every t ≥ 1**, so (7.1) and F(z) integrate positive integrands; and (3.1)'s
  difference does not cancel either, its first term beating its second by
  ~64M²/(log M)². Φ's cancellation lives entirely on u < 0 ⟺ t < 1, which
  neither representation visits. What 60 digits is actually for here is the
  *dynamic range* — (log t)^{2n}e^{−πt} spans 600 decades at n = 1000 — not
  cancellation.
- **E18.** **[GOR⁺] (3.1) and (3.2) as printed return 8γ(M), not γ(M).** Both
  are quoted from [GOR⁺]'s reference [11] = [GORZ19], whose γ is eight times
  larger — a fact [O'S] states under Table 1 and [GOR⁺] do not repeat.
  Measured: (3.1)/γ(M) = 8.00000000000000000000000000000 at every M from 1 to
  12, and (3.2)/γ(M) → 8 with the O_ε(M^{−1+ε}) residual the paper claims. The
  independent derivation, integrating ω = 2t²ψ″+3tψ′ by parts twice, puts the
  denominator of (3.1) at 2^{2M+2} rather than the printed 2^{2M−1}. Nothing in
  [GOR⁺]'s Theorem 2.2 depends on the constant — (3.1) is used only through the
  asymptotic — so this is a normalisation carried across without conversion,
  not a defect in the proof. **Anyone using (3.1) or (3.2) numerically must
  divide by 8.**
- **E19.** *(qualifying H3.)* **"d ≤ 400 at n = 0" is a property of a
  normalisation, not of the criterion's Ω.** H6 measures d_max ∝ σ^{−4/3} under
  the scale σ, to three figures, and a further factor of **25.4** — 400 to
  10141 — under a *translation* that is still a legal Ω. H3's comparison — 400 for [O'S] (8.2) against 7 for
  [GOR⁺] (2.9) — remains correct as a statement about *those two published
  criteria*; it is not a statement about Ω = e^{−z²} against Ω = 1. The
  scale-invariant reading is the growth of n₀(d), which no dial moves.

---

## Reproducing everything

From `rust/`:

```bash
cargo test --release                     # the whole suite
cargo run --release --bin h1_moment      # H1
cargo run --release --bin h2_pjensen     # H2
cargo run --release --bin h3_onset       # H3   (70 s)
cargo run --release --bin h4_crosscheck  # H4   (58 s)
cargo run --release --bin h5_asymptotic  # H5   (3 s)
cargo run --release --bin h6_omega       # H6   (64 s at 1600 1400 60)
```

Each driver takes optional arguments (ranges, precision) documented in its own
module header. Raw output for all six is in
[rust/RESULTS.md](rust/RESULTS.md).
