# Results

Produced by the seventeen drivers in `src/bin/`. Every number below is reproducible
with `cargo run --release --bin <name>`; the library's 116 tests check these
against the tables in [../README.md](../README.md),
[../POSITIVITY.md](../POSITIVITY.md), [../INTEGERS.md](../INTEGERS.md),
[../CONTINUATION.md](../CONTINUATION.md), and — for H1 and H2 — against
[GOR⁺] and [O'S] themselves.

## Summary

**A3 — done, and the diagnosis was exactly right.** The dropped tail is
`4·Φ(0)·e^(V₀)` in closed form. At V₀ = −16 that is **2.0108e−07**, which is
the −2.010e−07 TODO A3 reports F(0, −γ_k²) returning instead of 0. Restoring
it analytically removes **4.045e−07** of relative error and gives
Γ_Φ(0) = 0.49712077818831 against ξ(½) = 0.4971207782.

Two things beyond the TODO's diagnosis, both found by testing:

* the tail is not the only V₀ error — the trapezoid also leaves an
  Euler–Maclaurin **boundary** term, because at V₀ = −16 the integrand is
  still 5e−8 rather than negligible. It scales as h² (1.3e−13 relative at
  w = 0) and no tail correction repairs it; V₀ = −50 does.
* the same closed form *is* CONTINUATION (22)'s pole string, so the corrected
  evaluator continues Γ_Φ meromorphically to Re w ≤ −1 for free.

**B1 — done. All 35 Jensen polynomials certified**, d = 2…6 and n = 0…30,
from enclosures rather than floating-point signs, by positive-definiteness of
the Hermite–Hankel form under interval LDLᵀ. The discriminants reproduce
INTEGERS §5 exactly (3.6746e−5, 9.8744e−41, 5.3285e−118, 2.0170e−13,
7.6910e−123, 2.4317e−240, 1.5931e−25, 8.4217e−191, 1.2401e−367) and so do its
normalised margins. The new column is `max width`: the largest **relative**
enclosure width on the coefficients at which the sign is still decided. It is
the honest bridge, because the propagation is rigorous but the enclosure of
γ(n) itself is measured, not proved — so a fully rigorous certificate needs a
bound on γ(n) tighter than 9.4e−4 at (d,n) = (2,30), and than 3.6e−18 at
(6,30). That number falls twelve decades from d = 2 to d = 6 at n = 0 and
fourteen at n = 30 — three per unit of d, widening to nearly four — which is a
sharper statement of the cost of degree than any discriminant column.

**C3 — the phrasing does outrun the evidence, and now by a measured amount.**
CONTINUATION §4 infers "R(w) − 1 ~ 4/|w|" from a creep through 2.13 … 3.19.
Extended sixteen-fold to w = 9600, |w|(R−1) reaches only **3.445** — still 14%
short of 4. Worse for the inference, `(4 − a)·ln w` is *not* flat: it rises to
5.204 near w = 300–600 and then falls to 5.091 by w = 9600. So the data are
consistent with a → 4 but establish neither that limit nor the c/ln w model,
and TODO C3's own suspicion is upheld. **The wording should be downgraded.**

**An honest failure, reproducing CONTINUATION §5.** On the ray Re w = 5 the
same quantity reads 2.33, 2.84, 3.05 at Im w = 10, 50, 150 — and then
**426.07 at 400i and 100.32 at 1000i**. That is not structure. |Γ_Φ| has
fallen to ~1e−80 and ~1e−200 there, below what 50 digits can form a ratio
from: it is precisely the failure mode §5 records, met again. Anything above
|Im w| ≈ 200 in these tables is noise, and B3's scan is bounded accordingly.

**H1 — a(1000) matches [O'S] Table 1 to every digit it prints, and the rule
has 113 digits of headroom.** O'Sullivan's γ(m) := m!/(2m)!·ξ^(2m)(½) is this
directory's a(m) with no rescaling, so his

```
γ(1000) = 4.8450426112725879772e−2568
```

is the first external high-precision value of a(n) the directory has had.
This crate returns it exactly, and returns it unchanged under h doubled, h
halved, V₁ raised, V₀ raised, and a 90-digit run.

Because [O'S] prints twenty digits the comparison saturates there, so the
rules were compared **against each other** at 150 digits, with V₀ = −2 (the
integrand below it is e^{−4002}, and the saddle sits 300 widths clear):

| h | nodes | digits vs the next halving |
|---|---|---|
| 0.008 | 426 | 10.72 |
| 0.004 | 851 | 40.58 |
| 0.002 | 1701 | **133.51** |
| 0.001 | 3401 | 169.80 (at the 173-digit floor) |

**Each halving roughly triples the correct digits** — the trapezoid rule on
this integrand converges geometrically, not algebraically. So at the standard
h = 0.002 the quadrature error at n = 1000 is ~1e−133 against a published
2e−20: **the node-count heuristic understated the rule's reach by more than a
hundred digits**, and TODO H1's "right at the edge" was wrong. See the
correction in TODO E10.

Two things worth keeping from the diagnostic anyway: the saddle of the n-th
moment integrand sits at v\* = 0.891 for n = 1000 and reaches V₁ = 1.4 only at
n ≈ 42 000; and a(0) = 0.49712077818831410991 is ξ(½), which is A3 again from
the other end.

**H2 — P^{d,n} tolerates enclosures between 175× and 6.0e9× wider than
J^{d,n}, and unlike J its tolerance does not decay in n.** [O'S] (1.4)'s
family carries the same equivalence to RH ([O'S] Theorem 1.2) under a strictly
weaker condition ([O'S] Corollary 3.8), and this measures what the weakening
is worth to a certificate. Same interval LDLᵀ, same Hermite–Hankel form, same
enclosures — only the coefficients differ.

| d | J `max width` at n = 0 → 30 | P `max width` at n = 0 → 30 | P/J at n = 30 |
|---|---|---|---|
| 2 | 5.035e−3 → 9.443e−4 | 8.790e−1 → 9.281e−1 | 9.8e2 |
| 3 | 7.909e−6 → 3.729e−7 | 5.042e−2 → 5.060e−2 | 1.4e5 |
| 4 | 7.569e−9 → 1.105e−10 | 3.078e−3 → 3.093e−3 | 2.8e7 |
| 5 | 4.421e−12 → 2.323e−14 | 1.395e−4 → 1.403e−4 | 6.0e9 |
| 6 | 1.709e−15 | 5.383e−6 | — |

Three readings, in rising order of importance:

* **the smallest advantage anywhere is 175×**, at (2, 0). At d = 2, P is
  decided even when every coefficient is known only to within a factor of
  two — which is what a `max width` of 0.93 means, 1.0 being the point where
  the leading coefficient reaches zero and the polynomial loses its degree;
* **P's cost of degree is ~1.3 decades per unit of d against J's ~3.5**;
* **P's tolerance is flat in n — it even rises slightly — where J's falls by
  one to three decades over the same range.** That is the property that
  matters for G1: a bound on γ(n) good enough for P at n = 0 is good enough
  for P at every n, while for J the requirement keeps tightening.

The d = 2 case is checked against [O'S] (1.5)/(1.6) exactly: J²ⁿ is hyperbolic
iff a(n+1)² ≥ a(n)a(n+2), P²ⁿ iff a(n+1)² + 2a(n)² ≥ a(n)a(n+2), and at
n = 30 the two margins are 1.33e−118 and 1.95e−112 — the 2a(n)² term is six
decades of free slack.

**G1 — done. B1 without its conditional.** `bounds.rs` bounds γ(n) instead of
measuring it, so the certificate no longer rests on "the quadrature has
converged". Four inequalities replace four estimates: (G1a) the shell
truncation, (G1b) the composite-trapezoid remainder, (G1c) the piece below V₀,
(G1d) the piece above V₁. At V₀ = −14, h = 2⁻¹⁴, V₁ ≈ 1.4 — 252,317 nodes,
63,079 interval jet blocks, 60 digits, four minutes:

| | required | achieved, certified |
|---|---|---|
| P at d = 6, n = 30 | 5.427e−6 (half-width) | **3.283e−7** full — 33.1× slack |
| J at d = 6, n = 30 | 3.621e−18 | short by eleven decades |

**35 of 35 P^{d,n} certified; 15 of 35 J^{d,n}.** J holds to d = 3 and dies at
(4, 5). H2's table, re-derived from the opposite direction: the same proved
enclosure certifies every P and fewer than half the J.

What binds is not what the item expected. (G1b) dominates at every n, by
between one and four hundred decades — the two tails are not merely small,
they are irrelevant:

```
    n     rel width     G1b quad      G1c low     G1d high
    0     1.3028e-9     6.30e-10     4.28e-11   6.65e-4542
   36     3.2834e-7      1.64e-7    3.31e-445   1.34e-4492
```

Three findings from building it:

* **V₀ = −50 is the wrong limit for a certified rule.** `mellin.rs` needs it
  because the Euler–Maclaurin *boundary* term survives at −16. The certified
  rule has no separate boundary term — (G1b) bounds the remainder over the
  whole range at once and (G1c) is exact — so V₀ = −14 suffices, 3.6× fewer
  nodes;
* **f″'s cancellation must be kept inside the interval arithmetic.**
  f″ = e^{av}(a²g + 2a·g′ + g″) and those three nearly cancel at the saddle,
  where |f″| is f/σ² and not a²f. Bounding them separately inflates (G1b) by
  ~40× at n = 36 — worth more than a factor of four in h;
* **the block width has its own scale.** The enclosure of g over a block of
  width ω is relatively e^{Lω} − 1 too wide, L ≈ 350 near the peak, so blocks
  past ~10⁻³ cost more than the jet evaluations they save. Both h and ω were
  tuned by measurement, and the h² law checks out across the scan: 8× in h and
  4× in ω moved (G1b) at n = 36 by 169×, against 64 × 2.6 predicted.

And the price of a proof, stated plainly: the *measured* rule converges
spectrally (H1 — each halving of h roughly triples the correct digits), and
this bound sees only h². The certified enclosure is 3.3e−7 wide where the same
quadrature is in fact correct to far more. That gap is the whole reason G1
targets P rather than J.

Two claims in G1's own recipe did not survive being executed — **E12** (the
Poisson route has no strip to work in) and **E13** (sup\|Φ′\| gives one power
less than the sentence it appears in claims).

**H3 — done. A table neither paper has.** Both certify through Turán's
Theorem III and both bound the onset only asymptotically — n ≥ c·e^d for J
([GOR⁺] Thm 1.1, **c never given**) and n/log²n ≥ d^{3/4}/2 for P ([O'S]
Thm 1.3, "d large"). Where each *actually* starts:

> **[O'S]'s criterion for P holds at n = 0 for every d ≤ 400.
> [GOR⁺]'s for J holds at n = 0 only for d ≤ 7.**

A factor of **57 in the degree reachable at no cost in n**. That is H2's
asymmetry — measured there as 175× to 6.0e9× in tolerable enclosure width at
fixed (d, n) — arriving from the criterion side instead. The P crossing is
sharp: (8.2) = **0.993195 at d = 400**, **1.000691 at d = 401**.

| d | 2 | 8 | 90 | 303 | 400 | 401 | 454 | 681 | 1021 |
|---|---|---|---|---|---|---|---|---|---|
| **P**: n₀ | 0 | 0 | 0 | 0 | 0 | — | 2 | 10 | 24 |
| **P**: (8.2) at n = 0 | 6.2e−8 | 6.9e−6 | 1.1e−2 | 0.430 | 0.993 | 1.001 | — | — | — |

| d | 3–7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|---|---|---|---|---|---|---|---|---|---|---|
| **J**: n₀ | 0 | 51 | 129 | 251 | 434 | 693 | 1048 | 1518 | 2126 | 2897 |

Every J row is a genuine first crossing: (2.9) sits at 0.9983…0.9999 at n₀ and
above 1 at n₀ − 1.

Against the published bounds: [O'S] Thm 1.3 overshoots the true onset by
**296× to 1602×** where both are defined. [GOR⁺]'s cannot be compared —
no c is given — but the measured J onset grows *more slowly* than e^d over
8 ≤ d ≤ 16, the implied c falling from 0.0171 to 0.0003, so the exponential
regime their proof needs has not begun at these degrees.

Three things the implementation had to get right:

* **[GOR⁺] Lemma 2.3 is an exact test, and it settles an ambiguity.** A_{d,0} = 1,
  A_{d,1} = 0, A_{d,2} = −d(d−1), and J̃^{2,n} = H₂(X/2) identically — all four
  hold to 40 digits across d = 2…12, n = 0…40. They are also what decides that
  the Δ^d of (2.6) belongs in the **denominator**, which the paper's typography
  leaves open and which the wrong choice gets wrong by Δ^{2d};
* **the criterion is checked to be sufficient** — wherever either holds, the
  discriminant route certifies the same polynomial;
* **precision is not the obstacle, and the naive metric says it is.** The J
  renormalisation is an alternating sum whose max-term-over-sum reaches 1e77,
  which looks fatal. Recomputing a(0) … a(2914) at **120** digits moves (2.9)
  at every n₀ by at most **3.0e−54**. Those huge ratios are coefficients
  genuinely near zero, contributing nothing. The metric overstates by seventy
  decades; only the precision cross-check settles it.

These are onsets of a *sufficient* criterion, not of hyperbolicity. The
discriminant route decides every small-d cell at n = 0 — including the d = 8
where J's criterion needs 51 moments — and Chasse settled d ≤ 2 × 10¹⁷ for all
n in 2013 (**E8**). H3 measures the price of a criterion that is uniform in n
and provable, against one that is a finite check with no uniformity at all.

**G2 — done. The frontier is a staircase, not a number.** G1 made both sides
of the question numbers: demand is how tight an enclosure each criterion needs,
supply is how tight one the certified quadrature delivers.

**Demand**, extended from H2's d ≤ 6, n ≤ 30 to **d ≤ 10, n ≤ 140**:

| | at n = 0 | at n = 140 | cost of degree |
|---|---|---|---|
| **P** at d = 10 | 2.042e−12 | **2.085e−12** | 1.45 decades/d |
| **J** at d = 6 | 1.709e−15 | 1.115e−20 | 3.45 decades/d |

P's demand is **flat in n over the whole range, and rising slightly** — H2 saw
that to n = 30 and called it the property that decides G1; it holds to n = 140
at every degree to 10. J's falls five decades over the same span at d = 6.

Four cells are `prec` rather than a number: at d = 10, n ≥ 80, J's discriminant
is undecidable at 60 digits **even from a zero-width enclosure**. The
arithmetic's floor, not the criterion's demand, and labelled so —
`max_tolerable_width_in` returning 0 means "cannot be decided here", not
"needs nothing".

**Supply** at V₀ = −14, h = 2⁻¹⁴, 252,317 nodes: 1.3028e−9 at n = 0 to
**8.7396e−6 at n = 140**, rising like **n^2.23**. Pure h²/σ² would give n¹; the
excess is the block term's extra a² = (2n+1)². The h² half is measured, not
assumed: against a rule with h four times coarser at the same block width the
ratio is 15.51, 16.00, 16.00, 16.00 — mean 15.88, **99% of 16**.

**The crossing**, with every failure diagnosed rather than counted (each is
re-certified from the tightest enclosure the scalar allows, to separate the
bound from the precision; all of these are the bound):

```
    d  P to n  J to n   P needs @top      supplied
    2     120     140       1.906e0      5.992e-6
    4     120       0      6.190e-3      6.263e-6
    6     120       —      1.087e-5      6.542e-6
    7      20       —      3.269e-7      1.918e-7
    8       0       —      8.775e-9      3.268e-8
    9       —       —     1.979e-10      3.782e-8
```

So at one h: **P to d = 6 across n ≤ 120**, d = 7 to n = 20, d = 8 at n = 0
alone, nothing at d ≥ 9. J reaches d = 2 across the range, d = 3 to n = 40,
d = 4 at n = 0 only. B1 published d ≤ 6, n ≤ 30 — conditionally.

**The trade law.** Demand flat in n and falling 1.45 decades/d; supply costing
h² and rising like n^2.23:

```
d_max(n, h)  =  const  −  (2/1.45)·log₁₀h  −  (2.23/1.45)·log₁₀n
```

**0.41 degrees per halving of h**, **1.54 degrees lost per decade of n**. n is
as expensive as d, which is why the frontier is a staircase.

**What the next degrees cost** — h shrinks 5.3× per degree and nodes rise by
the same factor, from four minutes at d = 6: d = 7 in 23 min, d = 8 in 2.0 h,
d = 9 in 10.8 h, d = 10 in 2.4 days, d = 11 in 12.9 days.

That is the practical frontier of an integral-to-certified-sign route, and not
the frontier of hyperbolicity — Chasse settled d ≤ 2 × 10¹⁷ in 2013 (**E8**).
The gap between d ≈ 8 and 2 × 10¹⁷ is the honest measure of what this pipeline
is: a route demonstrated end to end, not an extension of what is known.

G2 also turned up **E16** — `certify_iv` stored a full relative width where
`certify_in` stores a half, so every slack figure the directory printed read
half its true value. No verdict changes; G1's slack is **33.1×**, not the 16.5×
first published.

**G3 — done. Every claim CONTINUATION (22) makes is true; the derivation that
produced them is not.** (22) asserts Γ_Φ meromorphic with simple poles at
w = −1, −3, −5, … only, residue 4c_{2k} at w = −(2k+1), and (23) that
C(w) = Γ_Φ(w)/Γ(w+1) is entire. Nothing had ever computed a c_{2k}.
`series.rs` computes them exactly — truncated power series over intervals, two
recurrences, no quadrature — with the shell truncation majorised by a Cauchy
estimate on |u| = 3/10:

```
c_0 =  0.4466969004671234440870      c_4 =  16.92005903032133932308
c_2 = -4.182625193675814216698       c_6 = -35.23314299039473379539
```

Every odd coefficient encloses zero: Φ's evenness — the theta functional
equation — arriving through arithmetic rather than being imposed.

| claim | predicted | measured |
|---|---|---|
| Res at w = −1 | (22) prints 1.7867876 | 1.786787601868493776 — agrees to all nine |
| C(−1) = 4·0!·c₀ | 1.78678760186849378e0 | same, rel 8.6e−26 |
| C(−3) = 4·2!·c₂ | −3.34610015494065137e1 | same, rel 1.8e−25 |
| C(−5) = 4·4!·c₄ | 1.62432566691084858e3 | same, rel 2.0e−25 |
| C(−2), C(−4), C(−6) | 0 (simple zeros) | 3e−77, 4e−75, 8e−73 |

**But (22)'s derivation splits at u = 1 and integrates Φ's Taylor series over
[0, 1], and the radius of convergence is π/4 = 0.785.** Φ = 2e^{u/2}ω(e^{2u})
with ω built from θ, and θ has Re t = 0 as a natural boundary, so Φ is analytic
exactly on |Im u| < π/4; at u = iπ/4 the shell terms are (…)(−1)^k and do not
decay. Measured, with the coefficients enclosed to 1e−118 relative so the
structure is Φ's and not roundoff:

```
    m            |c_m|      |c_m|^(1/m)
   20        6.29951e3         1.548693
   60        1.32282e8         1.365710
  100       4.34227e12         1.337757
  158       3.07147e19         1.328427      → 4/π = 1.27324
```

|c_m|^{1/m} ∈ [1.25, 1.45] over 30 ≤ m ≤ 158, settling toward 4/π from above.
The series in (22) **diverges**. The conclusion survives — split anywhere
inside the disc and the same argument gives the same poles and residues — but
the displayed identity is false as written, and §7's "For Re w ≤ −1 use the
split (22)" with it. **E14.**

The replacement evaluator (split at V₀ = −2, whole Taylor series below,
Romberg above) agrees with `mellin::eval` to **8.8e−43** at w = 2, 4, 10 — two
independent routes to the same number.

**And `mellin::eval` is not a continuation below w = −1**, which its doc
comment claimed. At w = −1.5 it returns 2.14e4 for −7.74. The cause is
identified rather than observed: below −1 the integrand *grows* as v → −∞, so
V₀ = −50 — chosen to make it negligible for Re w > −1 — makes it enormous, and
Euler–Maclaurin's boundary term is amplified by e^{(w+1)V₀}. Measured against
(h²/12)·|w+1|·e^{(w+1)V₀}·Φ(0):

```
      w   measured   predicted
   -0.5   2.27e-18    2.27e-18
   -1.5     2.77e3      2.77e3
   -2.0    3.14e14     3.14e14
   -2.9    1.33e33     1.33e33
```

Three significant figures across **fifty-one decades**. Independently, the A3
tail approximates Φ(e^v) by Φ(0) and so carries the pole at w = −1 and no
other. **E15.**

Three things had to be right that were not obvious: Romberg rather than
trapezoid (the integrand has not decayed at U₀ = 0.135, costing 1.3e−7); the
split point specified as V₀ and not U₀ (letting the quadrature take log(1/8)
through f64 leaves 7e−17 that no number of Romberg levels removes); and the
w = 0 residual attributed correctly — it is `Mellin::standard`'s own boundary
term at V₀ = −50, and halving h quarters it, measured ratio 4.00.

**B2 — three zeros resolved where CONTINUATION §8.3 resolved two, and its z₄
call was wrong.** At K = 48 and 60 digits, w = 0 gives z₁, z₂, z₃ =
−199.7905, −441.9262, −625.5430, all correct to the digits printed against
−γ₁², −γ₂², −γ₃² — so z₃, "still drifting at K = 40" in §8.3, is resolved. And
z₄ = **−925.6828** against −γ₄² = −925.67309, a relative 1.0e−05: it is not
"a pure truncation artifact", it is the fourth zero under-resolved. Two
further findings: §8.3's z₂ row is **wrong** at w = 0 (it prints −442.41 where
the exact answer is −441.9262), at w = 8 and at w = 12; and the truncation
requirement **grows with w** — at w = 12, K = 40 and K = 48 still disagree on
z₃ by 9%. So "z₂ stabilises from K = 28" is a small-w statement.

**B3 — the widest scan yet, and it argues for downgrading §4, not upgrading
it.** 425 points at 50 digits over Re w ∈ [0,40] × Im w ∈ [0,150], against
§4's float64 scan valid only to |Im w| ≤ 50. No zero; smallest |R − 1| =
**1.9526e−2 at w = 40 + 150i**, unmoved by halving the quadrature step (the §5
diagnostic). But the infimum sat on the *boundary* in both runs (40 + 120i at
the coarser grid, 40 + 150i here), and there |w|·|R − 1| = 3.031 — exactly
C3's real-axis value at |w| ≈ 155. The box holds no zero and no anomaly; the
minimum is just the ~3/|w| decay at the farthest point tried. A bounded scan
of a quantity decaying to zero cannot establish absence at any precision.

**H4 — done. Two more representations, agreeing to the arithmetic floor, and
a factor of 8 in [GOR⁺] (3.1).** γ(n) computed three further ways — [O'S]
(7.1)'s ∫₁^∞(log t)^{2n}ω(t)t^{−3/4}dt, [GOR⁺] (3.1)'s difference of two
F-moments, and the horn's own integrand on a *uniform* grid in u — with
composite Gauss–Legendre (`quad.rs`, the crate's first non-trapezoid rule).
Against the horn at 60 digits requested: uniform-u **69–73** digits, (7.1)
**66–69**, (3.1)/8 **61–69**, and the two new routes against each other
**66–72**. At n = 1000 all three agree to **72.9** digits and reproduce [O'S]
Table 1. **(3.1) as printed returns exactly 8γ(M)** —
8.00000000000000000000000000000 at every M from 1 to 12 — the [GORZ19]
normalisation carried across without conversion (**E18**). And the one place
the three routes split is n = 0, where **the horn is the one that is off**, by
2.31e−28: `Mellin::standard`'s Euler–Maclaurin boundary term at V₀ = −50,
predicted against measured to 1.00000 over **thirty-three decades** of V₀.

**H5 — done. [O'S] Table 1 reproduced from its own coefficient chain, and the
asymptotic is not a shortcut.** Theorem 1.4's c_k are described through five
formulas resting on partial ordinary Bell polynomials; all of it is
implemented, and it reproduces μ₁, c₁ (to 5.0e−76), c₂, Stirling's κ_m =
1, 1/12, 1/288, −139/51840, −571/2488320, and **all four rows of Table 1** at
n = 1000 to every digit printed. Where the series turns around: **7 digits at
n = 3, 11 at n = 10**, still rising at K = 24 for n ≥ 200 (58.5 digits at
n = 1000). It costs **four times more** than the quadrature at K = 24 and stops
at 21 digits at K = 7, so the quadrature stays. [GOR⁺]'s L_M is checked against
W(2n/π) through the derived gap w − L ≈ (3L/8+1)/((π/2)e^L(1+L)), three to four
figures at every n; and (3.2)'s ambiguous radical is settled by the same factor
of 8 — √(2π/K) tends to 8, 1/√(2πK) to 4/π.

**H6 — done. [O'S] picked the optimal Gaussian; the translation was left on the
table, and it is worth a change of exponent.** One formula contains both
papers' criteria (validated to 6.05e−77 against (8.2) and 8.39e−69 against
(2.9)), and the search has two dials because the Laguerre–Pólya class already
contains the affine group. **ν** — the Hermite content of Ω — has a
razor-sharp optimum exactly at [O'S]'s Ω = e^{−z²}: a 1% move costs four
decades either way. **μ** — the translation — does not: χ₂(μ) = γ(n+2) −
2μγ(n+1) + μ²γ(n) has roots **μ± = γ(n+1)/γ(n)·(1 ± √2·Δ(n+2))**, with Δ the
uniformizer [GOR⁺] introduce for J, and at μ± the dominant term of Turán's sum
vanishes: T at (8,20) falls from 5.412e−7 to **2.662e−16**. That changes the
power of d from **d^3.015** to **d^4.011**, takes d_max at n = 0 from **400 to
10141**, and gives n₀(d) = 0 for every d ≤ 1000 where [O'S]'s P needs up to
23. Every other Ω tried is worse: the Bessel family of [O'S] Theorem 3.9,
cos z, Ω = 1 in either form and every non-unit Gaussian all fail at d = 2 or 3.
And d_max is **not** scale-invariant — measured d_max ∝ σ^{−4/3} to three
figures (**E19**).

**G6 — done. One law, and it was predicted before it was measured.** K_req(w,k)
is the fewest terms at which the k-th root of F(w, ·) reaches its converged
place to a relative 10⁻⁶ **and stays there**. At w = 0 it runs **20, 32, 40,
50, 56, 66, 74, 78, 90, 94** for k = 1 … 10, and 20, 22, 22, 24, 26, 28, 30,
34, 40 for k = 1 across w = 0 … 24. **Forty-one measurements from nine values
of w and ten root indices collapse onto one curve**: K_req/√|z| rises smoothly
from **1.415 to 1.889** while √|z| runs 14.1 → 49.8, fitted exponent 1.229 in
√|z|. That is what the coefficient decay predicts — A(w+2j) falls like (C/j)^j,
so the largest term of Σ A(w+2j)y^j/j! sits at j\* = √(C|y|/e), giving K_req a
function of |z| alone plus the logarithmic drift C carries. The anchor is
**external**: at w = 0 the roots are −γ_k², matched to 6.5e−20 … 3.0e−16 at
K = 170 — the twenty-digit γ_k table's own rounding. And **precision does not
bind**: identical K_req at 30, 45, 60 and 90 digits (**E21**).

**B2 — done. Ten roots, and the root-finder changed.** Bisection inside a
one-root bracket instead of a global solve: it needs only the sign of F, cannot
converge to a neighbour, and cannot report a root outside the bracket. Ten
roots at w = 0 against −γ_k², five columns (z₁ … z₅) across w = 0 … 12, every
entry stable between K = 128 and K = 140. This is the table **A4** pastes into
CONTINUATION §8.3 in place of one whose z₂ column was wrong at w = 0, 8 and 12.

**G4 — done. Non-integer w adds no content.** The computable half of **C2**,
and it needed G6 first. The method is a **count**: the argument principle gives
the number of zeros of the truncation inside |y| ≤ Y as an integer, bisection
gives the number of sign changes on [−Y, 0), and if the two agree every zero in
the disc is real and negative with no room for a conjugate pair. Over
w ∈ [0, 12] in 24 steps, at K = 110 and K = 130, inside the disc |y| ≤ 3352
that G6's law licenses: **the two counts agree at all 25 sample points, at both
truncations** — twelve real zeros at w = 0, ten by w = 12 as the flow carries
them past the boundary. So §8.2's "for every w" is the same condition as "for
every even integer", and §8 is a repackaging — which §8.4 now says. What it
does not establish is anything outside the disc or at complex w: a zero beyond
the boundary is unseen, not absent.

**G5 — done, and the answer is 4.** C3 measured the creep and could not settle
it. The derivation: with L = log Γ_Φ, (24) is R = exp(−Δ²L)·R_f, and both
derivatives of L are **moments of the tilted density** ρ_w ∝ e^{(w+1)v}Φ(e^v)
— L′ = ⟨v⟩_w and **L″ = Var_w(v)**, exactly, with L″ > 0 being the
Cauchy–Schwarz defect itself. Laplace on the saddle gives
−P″ = (w+1)(1+2U) + 9U² with 2πU·e^{2U} = w+1+(9/2)U, and **that is solved by
U = ½·W(w/π)** — Lambert's function, from **H5**. So

```text
w·(R(w) − 1)  =  4  −  4/(1 + W(w/π))  +  O(1/w)
```

**The limit is 4**, approached like 4/log w. Checked: L′ = ⟨v⟩ to 5.3e−19 …
2.3e−26; L″ = Var to **1.4e−15 at w = 1000**; Laplace's residual falling like
1/w over five decades (5.49e−2 → 2.22e−6 at w = 30 … 3×10⁶); and the whole
prediction against measured R **three and a half decades past where C3
stopped** — 3.7031210446 against 3.7031208350 at w = 1.024×10⁷, a relative
5.66e−8, the residual falling 4× per 4× in w. C3's fitted 4 − 5.09/ln w was a
local snapshot of 4·ln w/(1+W(w/π)), which falls from 5.23 to 5.09 across C3's
own range and keeps falling. **Reaching 3.9 needs w ≈ 10¹⁹ and 3.99 needs
10¹⁷⁶** — no computation was ever going to read this off.

**And a by-product worth more than the item (E22).** The same saddle gives
σ = 1/√(−P″), so Poisson summation puts the trapezoid's relative error at
**exp(−2π²(σ/h)²)** — the node count across the peak *is* the diagnostic,
squared in the exponent. `Mellin::standard` therefore has a formula for its own
reach: σ/h = 1.90 at w = 9600 but **0.86 at 4×10⁴** and 0.24 at 4×10⁵, and it
returns −19.7 at w = 6.4×10⁶ where the truth is 3.693. `watson::adapted_rule`
replaces it above w ≈ 4×10⁴, which is what let the G5 check run to 10⁷ at all.

## Raw output

```
A3 — Γ_Φ near w = 0

  the tail CONTINUATION §7 drops below V₀ = −16:
    4·Φ(0)·e^(V₀)      = 2.010764550e-7
    TODO A3 reports      -2.010e-07 for F(0, −γ_k²)

  Γ_Φ(0), the old rule (no tail)  = 4.971205771117921e-1
  Γ_Φ(0), corrected               = 4.971207781883141e-1
  ξ(½) published                  = 0.4971207782
  relative error removed          = 4.045e-7

  the moment table, CONTINUATION §3:
       n                    Γ_Φ(2n)              published         rel
       0     4.97120778188314110e-1       4.9712077820e-01    2.35e-11
       1     2.29719443151454375e-2       2.2971944315e-02    6.33e-12
       2     2.96284843368763217e-3       2.9628484337e-03    4.17e-12
      10     1.36798615158887615e-6       1.3679861516e-06    8.13e-12
      20     1.21357309230349261e-7       1.2135730923e-07    2.88e-12

B1 — hyperbolicity of J^(d,n), certified from enclosures
  d ≤ 6, n ≤ 30 step 5, at 60 digits

    d    n    verdict             disc     norm. margin    max width
    2    0  CERTIFIED        3.6746e-5        1.3572e-4     5.035e-3
    2    5  CERTIFIED       1.4343e-22        4.3492e-5     2.722e-3
    2   10  CERTIFIED       9.8744e-41        2.2360e-5     1.929e-3
    2   15  CERTIFIED       1.8873e-59        1.3825e-5     1.514e-3
    2   20  CERTIFIED       1.2982e-78        9.4557e-6     1.255e-3
    2   25  CERTIFIED       3.8006e-98        6.8968e-6     1.076e-3
    2   30  CERTIFIED      5.3285e-118        5.2612e-6     9.443e-4
    3    0  CERTIFIED       2.0170e-13       2.5118e-12     7.909e-6
    3    5  CERTIFIED       1.2561e-48       1.0775e-13     2.741e-6
    3   10  CERTIFIED       3.2907e-85       1.5907e-14     1.456e-6
    3   15  CERTIFIED      7.6910e-123       3.9176e-15     9.232e-7
    3   20  CERTIFIED      2.5384e-161       1.2846e-15     6.452e-7
    3   25  CERTIFIED      1.6074e-200       5.0675e-16     4.800e-7
    3   30  CERTIFIED      2.4317e-240       2.2765e-16     3.729e-7
    4    0  CERTIFIED       1.5931e-25       6.1085e-24     7.569e-9
    4    5  CERTIFIED       7.5754e-79       1.7148e-26     1.882e-9
    4   10  CERTIFIED      4.4493e-134       4.3291e-28    7.819e-10
    4   15  CERTIFIED      8.4217e-191       2.8314e-29    4.094e-10
    4   20  CERTIFIED      9.5075e-249       3.1884e-30    2.447e-10
    4   25  CERTIFIED      9.7635e-308       5.1199e-31    1.595e-10
    4   30  CERTIFIED      1.2401e-367       1.0570e-31    1.105e-10
    5    0  CERTIFIED       1.7272e-41       1.8624e-39    4.421e-12
    5    5  CERTIFIED      3.3354e-113       1.8589e-43    8.466e-13
    5   10  CERTIFIED      2.7230e-187       5.0278e-46    2.843e-13
    5   15  CERTIFIED      2.8469e-263       5.9964e-48    1.253e-13
    5   20  CERTIFIED      7.9880e-341       1.6933e-49    6.486e-14
    5   25  CERTIFIED      1.0111e-419       8.4436e-51    3.736e-14
    5   30  CERTIFIED      8.4746e-500       6.3153e-52    2.323e-14
    6    0  CERTIFIED       2.4461e-61       6.7753e-59    1.709e-15
    6    5  CERTIFIED      1.1016e-151       1.4105e-64    2.640e-16
    6   10  CERTIFIED      8.0784e-245       2.6690e-68    7.359e-17
    6   15  CERTIFIED      3.2637e-340       4.0882e-71    2.775e-17
    6   20  CERTIFIED      1.6823e-437       2.1502e-73    1.257e-17
    6   25  CERTIFIED      2.0195e-536       2.5713e-75    6.452e-18
    6   30  CERTIFIED      8.8602e-637       5.5435e-77    3.621e-18

  every polynomial certified: yes
  `max width` is the largest RELATIVE enclosure width on the
  coefficients at which the sign is still decided — i.e. how good
  a bound on γ(n) a fully rigorous certificate would need.

C3 — |w|·(R(w) − 1)

           w           |w|(R−1)    vs 4 − c/ln w
          10           2.125693
          40           2.651807
          80           2.833837
         150           2.967209
         300           3.087680
         600           3.186532
        1200           3.268518
        2400           3.337191
        4800           3.395253
        9600           3.444787

  (4 − a)·ln w — flat means a = 4 − c/ln w, falling means a → 4 faster:
          10           4.315752
          40           4.973322
          80           5.110158
         150           5.174940
         300           5.203676
         600           5.203697
        1200           5.186260
        2400           5.158792
        4800           5.126059
        9600           5.091036

  and the same on a complex ray, Re w = 5:
          10i          2.334629
          50i          2.837126
         150i          3.046529
         400i        426.070899
        1000i        100.324358

B2 — the Jensen flow, F(w, ·) = Σ A(w+2j) y^j/j!

  w = 0 should give y = −γ_k²: −199.7904, −441.9262, −625.5430

     w   K               z1               z2               z3               z4
     0  24        -199.7905                —                —                —
     0  32        -199.7905        -441.9262        -610.5700                —
     0  40        -199.7905        -441.9262        -625.5430                —
     0  48        -199.7905        -441.9262        -625.5430        -925.6828

     1  24        -221.2555                —                —                —
     1  32        -221.2555        -464.8060        -626.3375                —
     1  40        -221.2555        -464.8058        -658.1142                —
     1  48        -221.2555        -464.8058        -658.1144        -949.5787

     2  24        -242.9143                —                —                —
     2  32        -242.9143        -488.3215        -638.0174                —
     2  40        -242.9143        -488.3206        -690.2298                —
     2  48        -242.9143        -488.3206        -690.2310        -975.5206

     4  24        -286.8340                —                —                —
     4  32        -286.8341        -536.9372        -654.6800                —
     4  40        -286.8341        -536.9185        -753.5200                —
     4  48        -286.8341        -536.9185        -753.5670       -1032.6365

     8  24        -377.1449                —                —                —
     8  32        -377.1699                —                —                —
     8  40        -377.1699        -638.9887        -865.5642                —
     8  48        -377.1699        -638.9887        -878.7527                —

    12  24        -465.8284                —                —                —
    12  32        -470.9035                —                —                —
    12  40        -470.9035        -746.1087        -919.1845                —
    12  48        -470.9035        -746.1074       -1004.2493                —

  A root is trustworthy where it stops moving as K rises. Compare
  CONTINUATION §8.3, which resolved two.

  checked against the ordinates (w = 0 row, K = 48):
     k    −γ_k²          B2          relative
     1  -199.79045   -199.7905      2.26e-7   (print precision)
     2  -441.92615   -441.9262      1.12e-7   (print precision)
     3  -625.54300   -625.5430      4.97e-9   (print precision)
     4  -925.67309   -925.6828      1.05e-5   ← identified, not resolved

B3 — scanning |R(w) − 1| at 50 digits

  grid: Re w ∈ [0, 40] × 9,  Im w ∈ [0, 120] × 13
  smallest |R − 1| found: 2.364495e-2 at w = 40 + 120i
  points with |R − 1| < 0.02: 0

  grid: Re w ∈ [0, 40] × 17,  Im w ∈ [0, 150] × 25
  smallest |R − 1| found: 1.952611e-2 at w = 40 + 150i
  points with |R − 1| < 0.02: 7
  re-tested at h = 0.004: 1.952611e-2  (moved by 0.00e0)

  the infimum is on the boundary in both runs, and at 40 + 150i
  |w|·|R−1| = 3.031 against C3's 2.967 at |w| = 150 — the minimum is
  the ~3/|w| decay evaluated at the farthest point tried, not a feature.

H1 — a(n) against [O'S] Theorem 1.4, Table 1

  [O'S] γ(m) := m!/(2m)!·ξ^(2m)(½)  =  a(m) = Γ_Φ(2m)·m!/(2m)! here,
  with no rescaling. [GORZ19]'s γ is 8× larger; [GOR⁺] agrees with [O'S].

  target   a(1000) = 4.8450426112725879772e-2568

  rule                                          a(1000)   digits
  V₀=−50 V₁=1.4 h=0.002      4.8450426112725879772e-2568    20.36
    h doubled  (0.004)       4.8450426112725879772e-2568    20.36
    h halved   (0.001)       4.8450426112725879772e-2568    20.36
    V₁ raised  (1.8)         4.8450426112725879772e-2568    20.36
    V₀ raised  (−30)         4.8450426112725879772e-2568    20.36
  same rule, 90 digits       4.8450426112725879772e-2568    20.36

  convergence in the step, at 150 digits (floor 173 digits),
  V₀ = −2 — irrelevant at n = 1000, and 30× cheaper:

           h     nodes   digits vs the next halving
       0.008       426                        10.72
       0.004       851                        40.58
       0.002      1701                       133.51
       0.001      3401                       169.80

  and the finest of them against [O'S]: 20.36 digits
  Each halving roughly doubles the correct digits — the trapezoid
  rule on this integrand is spectrally accurate, so counting nodes
  across the peak understates its reach by a wide margin.

  where the mass sits, and whether the rule resolves it:

        n    saddle v*     width in v        nodes   v* < V₁?
        0   -1.49530e0     6.87551e-1        343.8        yes
       30   1.13603e-1     6.90847e-2         34.5        yes
      100   4.28783e-1     3.45059e-2         17.3        yes
     1000   8.91489e-1     9.20005e-3          4.6        yes
    10000    1.22923e0     2.52492e-3          1.3        yes
    42000    1.39896e0     1.14353e-3          0.6        yes

  the neighbouring moments, for the record:

        n                       a(n)
        0   4.9712077818831410991e-1
        1   1.1485972157572718768e-2
       10  2.0404225612876774481e-18
      100 8.2221579732275889268e-206
      999 3.2592951431234361963e-2565
     1000 4.8450426112725879772e-2568
     1001 7.1975469064650436536e-2571

H2 — P^(d,n) against J^(d,n), certified from the same enclosures
  d ≤ 6, n ≤ 30 step 5, at 60 digits

  [O'S] (1.5)/(1.6) — the two criteria at d = 2:

     n a(n+1)²/a(n)a(n+2)           J margin           P margin
     0    1.07484394250e0       9.1864298e-6       4.9426732e-1
    10    1.02762415486e0      2.4686021e-41      8.3266731e-36
    20    1.01782720689e0      3.2453855e-79      2.6189156e-73
    30    1.01336625375e0     1.3321181e-118     1.9450918e-112

  J needs a(n+1)² ≥ a(n)a(n+2) — a 1.3% margin at n = 30.
  P needs a(n+1)² + 2a(n)² ≥ a(n)a(n+2), and 2a(n)² dwarfs both
  other terms because a decays superexponentially. That is the
  whole of the difference, and the table below is its size.

    d    n   J verdict  J max width   P verdict  P max width          P/J
    2    0   CERTIFIED     5.035e-3   CERTIFIED     8.790e-1       1.75e2
    2    5   CERTIFIED     2.722e-3   CERTIFIED     8.983e-1       3.30e2
    2   10   CERTIFIED     1.929e-3   CERTIFIED     9.085e-1       4.71e2
    2   15   CERTIFIED     1.514e-3   CERTIFIED     9.154e-1       6.05e2
    2   20   CERTIFIED     1.255e-3   CERTIFIED     9.206e-1       7.34e2
    2   25   CERTIFIED     1.076e-3   CERTIFIED     9.247e-1       8.59e2
    2   30   CERTIFIED     9.443e-4   CERTIFIED     9.281e-1       9.83e2
    3    0   CERTIFIED     7.909e-6   CERTIFIED     5.042e-2       6.37e3
    3    5   CERTIFIED     2.741e-6   CERTIFIED     5.051e-2       1.84e4
    3   10   CERTIFIED     1.456e-6   CERTIFIED     5.055e-2       3.47e4
    3   15   CERTIFIED     9.232e-7   CERTIFIED     5.057e-2       5.48e4
    3   20   CERTIFIED     6.452e-7   CERTIFIED     5.058e-2       7.84e4
    3   25   CERTIFIED     4.800e-7   CERTIFIED     5.059e-2       1.05e5
    3   30   CERTIFIED     3.729e-7   CERTIFIED     5.060e-2       1.36e5
    4    0   CERTIFIED     7.569e-9   CERTIFIED     3.078e-3       4.07e5
    4    5   CERTIFIED     1.882e-9   CERTIFIED     3.086e-3       1.64e6
    4   10   CERTIFIED    7.819e-10   CERTIFIED     3.089e-3       3.95e6
    4   15   CERTIFIED    4.094e-10   CERTIFIED     3.090e-3       7.55e6
    4   20   CERTIFIED    2.447e-10   CERTIFIED     3.091e-3       1.26e7
    4   25   CERTIFIED    1.595e-10   CERTIFIED     3.092e-3       1.94e7
    4   30   CERTIFIED    1.105e-10   CERTIFIED     3.093e-3       2.80e7
    5    0   CERTIFIED    4.421e-12   CERTIFIED     1.395e-4       3.16e7
    5    5   CERTIFIED    8.466e-13   CERTIFIED     1.399e-4       1.65e8
    5   10   CERTIFIED    2.843e-13   CERTIFIED     1.401e-4       4.93e8
    5   15   CERTIFIED    1.253e-13   CERTIFIED     1.402e-4       1.12e9
    5   20   CERTIFIED    6.486e-14   CERTIFIED     1.403e-4       2.16e9
    5   25   CERTIFIED    3.736e-14   CERTIFIED     1.403e-4       3.75e9
    5   30   CERTIFIED    2.323e-14   CERTIFIED     1.403e-4       6.04e9
    6    0   CERTIFIED    1.709e-15   CERTIFIED     5.383e-6       3.15e9
    6    5   CERTIFIED    2.640e-16   CERTIFIED     5.406e-6      2.05e10
    6   10   CERTIFIED    7.359e-17   CERTIFIED     5.415e-6      7.36e10
    6   15   CERTIFIED    2.775e-17   CERTIFIED     5.420e-6      1.95e11
    6   20   CERTIFIED    1.257e-17   CERTIFIED     5.423e-6      4.31e11
    6   25   CERTIFIED    6.452e-18   CERTIFIED     5.425e-6      8.41e11
    6   30   CERTIFIED    3.621e-18   CERTIFIED     5.427e-6      1.50e12

  every J certified: yes
  every P certified: yes
  smallest P/J advantage anywhere in the table: 1.746e2

  A `max width` at the ceiling 1.0 means the sign survives every
  coefficient being wrong by a factor of two either way — at which
  point the leading coefficient reaches zero and the polynomial
  stops having a degree, so 1.0 is the end of the scale, not a cap
  chosen for convenience.
```

```
G1 — γ(n) bounded, and P^{d,n} certified from the bound

  rule   V₀ = -1.40e1   V₁ = 1.40015e0   h = 2^−14 = 6.104e-5
         252317 nodes, 63079 jet blocks of 4, 60 digits — built in 113.0 s
         Φ over u ∈ [0, e^{V₀}] = [4.466937045e-1, 4.467000964e-1]  (G1c)

  where the width comes from — the four bounded pieces, relative to γ(n):

     n     rel width     G1b quad      G1c low     G1d high   binds
     0     1.3028e-9     6.30e-10     4.28e-11   6.65e-4542   G1b quadrature
     1     4.2029e-9      2.10e-9     2.13e-22   2.37e-4539   G1b quadrature
     5     1.8906e-8      9.45e-9     5.76e-69   7.51e-4532   G1b quadrature
    12     5.5006e-8      2.75e-8    1.79e-152   2.29e-4521   G1b quadrature
    24     1.5642e-7      7.82e-8    4.73e-298   3.90e-4506   G1b quadrature
    36     3.2834e-7      1.64e-7    3.31e-445   1.34e-4492   G1b quadrature

  the certified moments, and the measured value they must contain:

     n  a(n) (enclosure midpoint)     rel width    holds
     0     4.97120778188313675e-1     1.3028e-9      yes
     1     1.14859721575727188e-2     4.2029e-9      yes
     9    1.33472384073531948e-16     3.7820e-8      yes
    18    2.41910787264874920e-33     9.8453e-8      yes
    27    8.57610513395058878e-51     1.9180e-7      yes
    36    9.10466131094080529e-69     3.2834e-7      yes
  every one of a(0) … a(36) encloses the measured value and is certified positive: yes

  certified from the bound — P^{d,n} against J^{d,n}:

    d     n      P needs      J needs       P       J
    2     0     8.790e-1     5.035e-3     yes     yes
    2     5     8.983e-1     2.722e-3     yes     yes
    2    10     9.085e-1     1.929e-3     yes     yes
    2    15     9.154e-1     1.514e-3     yes     yes
    2    20     9.206e-1     1.255e-3     yes     yes
    2    25     9.247e-1     1.076e-3     yes     yes
    2    30     9.281e-1     9.443e-4     yes     yes
    3     0     5.042e-2     7.909e-6     yes     yes
    3     5     5.051e-2     2.741e-6     yes     yes
    3    10     5.055e-2     1.456e-6     yes     yes
    3    15     5.057e-2     9.232e-7     yes     yes
    3    20     5.058e-2     6.452e-7     yes     yes
    3    25     5.059e-2     4.800e-7     yes     yes
    3    30     5.060e-2     3.729e-7     yes     yes
    4     0     3.078e-3     7.569e-9     yes     yes
    4     5     3.086e-3     1.882e-9     yes       —
    4    10     3.089e-3    7.819e-10     yes       —
    4    15     3.090e-3    4.094e-10     yes       —
    4    20     3.091e-3    2.447e-10     yes       —
    4    25     3.092e-3    1.595e-10     yes       —
    4    30     3.093e-3    1.105e-10     yes       —
    5     0     1.395e-4    4.421e-12     yes       —
    5     5     1.399e-4    8.466e-13     yes       —
    5    10     1.401e-4    2.843e-13     yes       —
    5    15     1.402e-4    1.253e-13     yes       —
    5    20     1.403e-4    6.486e-14     yes       —
    5    25     1.403e-4    3.736e-14     yes       —
    5    30     1.403e-4    2.323e-14     yes       —
    6     0     5.383e-6    1.709e-15     yes       —
    6     5     5.406e-6    2.640e-16     yes       —
    6    10     5.415e-6    7.359e-17     yes       —
    6    15     5.420e-6    2.775e-17     yes       —
    6    20     5.423e-6    1.257e-17     yes       —
    6    25     5.425e-6    6.452e-18     yes       —
    6    30     5.427e-6    3.621e-18     yes       —

  35/35 P certified, 15/35 J certified, from one enclosure of relative width ≤ 3.283e-7.
  Slack against the tightest P demands: 33.1×.

  Total: 159.6 s.
```

```
G3 — CONTINUATION (22)'s pole string, checked

  Φ's Taylor coefficients at u = 0 — from two exact recurrences,
  with the shell truncation bounded by (G3a). No quadrature.

     m                            c_m        width
     0     4.466969004671234440870e-1     2.45e-63
     1   -1.609477174460697368396e-64     2.87e-62
     2     -4.182625193675814216698e0     2.19e-61
     3    9.639026108798323546485e-64     1.01e-60
     4      1.692005903032133932308e1     3.96e-60
     5   -3.357392224276391903667e-63     1.41e-59
     6     -3.523314299039473379539e1     5.15e-59
     7    5.706811189293819543028e-63     1.98e-58
  every odd coefficient encloses 0 (Φ is even — the theta functional equation): yes

  the radius of convergence. (22) integrates this series over [0, 1]:

      m            |c_m|      |c_m|^(1/m)
     20        6.29951e3         1.548693
     40        2.00878e6         1.437386
     60        1.32282e8         1.365710
     80       9.05815e10         1.370765
    100       4.34227e12         1.337757
    120       2.52957e15         1.343875
    140       2.40722e17         1.330925
    158       3.07147e19         1.328427

  over 30 ≤ m ≤ 158: |c_m|^(1/m) ∈ [1.2480, 1.4524], falling toward 4/π = 1.27324
  so R ≈ 0.7528 — and decisively **below 1**.
  The shell sum's terms stop decaying at Im u = ±π/4, where e^{2u} = ±i
  and e^{−πk²e^{2u}} = (±1)^k; π/4 = 0.78540 is the distance to it.
  ⟹ (22)'s Σ c_2k/(w+2k+1) DIVERGES. The split at u = 1 is illegal. (E14)

  the series against the shell sum, with both truncations bounded (G3b):

       u          Φ from the series          Φ from the shells   encloses
    0.05   4.3634553822598710349e-1   4.3634553822598710349e-1        yes
     0.1   4.0652765608361304312e-1   4.0652765608361304312e-1        yes
     0.2   3.0427485266695750899e-1   3.0427485266695750899e-1        yes
    0.25   2.4318741036708709385e-1   2.4318741036708709385e-1        yes

  the continuation, split at V₀ = −2, i.e. U₀ = 1.353e-1 (inside the disc),
  Romberg over 6 trapezoid levels:

      w                  continued               mellin::eval   rel diff
      0     4.97120778188314110e-1     4.97120778188314110e-1   2.31e-28
      2     2.29719443151454375e-2     2.29719443151454375e-2   8.76e-43
      4     2.96284843368763217e-3     2.96284843368763217e-3   5.43e-43
     10     5.30386342782906548e-5     5.30386342782906548e-5   7.95e-43

  the w = 0 row is `mellin::standard`'s boundary term, not this route's:
               h = 0.002 → 2.311e-28,  h = 0.001 → 5.777e-29,  ratio 4.00 (h² says 4)

  the residues (22) predicts — Res = 4c_{2k}, independent of U₀:

      w               residue = 4·c_2k      (22) prints
     -1      1.786787601868493776348e0        1.7867876
     -3     -1.673050077470325686679e1                —
     -5      6.768023612128535729232e1                —
     -7     -1.409325719615789351816e2                —
  residue at w = −1 against (22)'s printed 1.7867876: rel 1.05e-9

  and where `mellin::eval` stops being the continuation — which is not
  where the missing poles are. Below w = −1 the integrand e^{(w+1)v}Φ(e^v)
  *grows* as v → −∞, so the Euler–Maclaurin boundary term at V₀ that
  `mellin.rs` documents at ~1e−28 is amplified by e^{(w+1)V₀}:

        w              continued           mellin::eval   rel diff  predicted
     -0.5     1.82023894037718e0     1.82023894037718e0   2.27e-18   2.27e-18
     -1.5    -7.74350143746437e0     2.14351663761524e4     2.77e3     2.77e3
     -2.0    -9.83545243856001e0    3.08798898007354e15    3.14e14    3.14e14
     -2.5    -2.33831393714734e1    3.33525475703944e26    1.43e25    1.43e25
     -2.9    -1.53758794109580e2    2.04965588035586e35    1.33e33    1.33e33

  Measured and predicted track over twenty-two decades, so the failure is
  identified and not merely observed. Two consequences:

   * `mellin.rs`'s "for Re w < −1 it is the meromorphic continuation" is
     false, and not marginally — at w = −1.5 it returns 2.1e4 for −7.74.
     V₀ = −50 is chosen for Re w > −1, where it makes the integrand
     negligible at the lower limit; below −1 it makes it enormous. (E15)
   * even with a perfect quadrature the single-term A3 tail carries only
     the pole at w = −1, so the poles at −3, −5, … would still be absent.
     Both are fixed by the same move: split inside the disc and use the
     whole Taylor series, which is what this driver's evaluator does.

  (23): C(w) = Γ_Φ(w)/Γ(w+1) is entire. At w = −(2k+1) the pole of Γ_Φ
  meets the zero of 1/Γ(w+1), and the finite value is 4·(2k)!·c_2k:

      w              C(w) measured               4·(2k)!·c_2k        rel
  -1.00e0      1.78678760186849378e0      1.78678760186849378e0   8.58e-26
  -3.00e0     -3.34610015494065137e1     -3.34610015494065137e1   1.80e-25
  -5.00e0      1.62432566691084858e3      1.62432566691084858e3   2.04e-25

  and simple zeros at the even negative integers, where 1/Γ vanishes
  and Γ_Φ does not:

      w                       C(w)
  -2.00e0    3.43414328635238830e-77
  -4.00e0    3.97435306912609827e-75
  -6.00e0    7.92503305519151357e-73

  Every claim (22) and (23) make about the pole structure holds.
  The derivation that produced them does not — see E14.
```

```
G2 — where the pipeline runs out

  DEMAND — `max width`, the enclosure of a(n) each criterion needs.
  H2's table, extended from d ≤ 6, n ≤ 30 to d ≤ 10, n ≤ 140.

    d         n=0        n=20        n=40        n=60        n=80       n=100       n=120       n=140   dec/d
  P 2    8.790e-1    9.206e-1    9.334e-1    9.409e-1    9.460e-1    9.498e-1    9.528e-1    9.553e-1
  P 3    5.042e-2    5.058e-2    5.061e-2    5.062e-2    5.062e-2    5.063e-2    5.063e-2    5.063e-2
  P 4    3.078e-3    3.091e-3    3.093e-3    3.094e-3    3.095e-3    3.095e-3    3.095e-3    3.095e-3
  P 5    1.395e-4    1.403e-4    1.404e-4    1.404e-4    1.404e-4    1.405e-4    1.405e-4    1.405e-4
  P 6    5.383e-6    5.423e-6    5.429e-6    5.432e-6    5.433e-6    5.434e-6    5.435e-6    5.435e-6
  P 7    1.620e-7    1.634e-7    1.637e-7    1.638e-7    1.638e-7    1.638e-7    1.639e-7    1.639e-7
  P 8    4.388e-9    4.438e-9    4.446e-9    4.449e-9    4.451e-9    4.452e-9    4.453e-9    4.453e-9
  P 9   9.893e-11   1.003e-10   1.005e-10   1.006e-10   1.006e-10   1.006e-10   1.007e-10   1.007e-10
  P10   2.042e-12   2.075e-12   2.080e-12   2.082e-12   2.083e-12   2.084e-12   2.084e-12   2.085e-12

  J 2    5.035e-3    1.255e-3    7.625e-4    5.560e-4    4.406e-4    3.662e-4    3.141e-4    2.755e-4
  J 3    7.909e-6    6.452e-7    2.460e-7    1.326e-7    8.383e-8    5.819e-8    4.295e-8    3.311e-8
  J 4    7.569e-9   2.447e-10   6.015e-11   2.422e-11   1.230e-11   7.157e-12   4.558e-12   3.095e-12
  J 5   4.421e-12   6.486e-14   1.053e-14   3.201e-15   1.313e-15   6.431e-16   3.543e-16   2.123e-16
  J 6   1.709e-15   1.257e-17   1.378e-18   3.195e-19   1.065e-19   4.405e-20   2.105e-20   1.115e-20
  J 7   4.666e-19   1.865e-21   1.410e-22   2.514e-23   6.843e-24   2.400e-24   9.973e-25   4.681e-25
  J 8   9.463e-23   2.195e-25   1.165e-26   1.614e-27   3.607e-28   1.076e-28   3.898e-29   1.623e-29
  J 9   1.480e-26   2.107e-29   7.999e-31   8.678e-32   1.600e-32   4.074e-33   1.289e-33   4.770e-34
  J10   1.841e-30   1.686e-33   4.589e-35   3.762e-36        prec        prec        prec        prec

  `prec` = J's discriminant is undecidable at 60 digits even from a
               zero-width enclosure — the arithmetic's floor, not the criterion's demand.
               4 cells, all at the largest d and n, where J needs below 1e−35.

  cost of degree at n = 0: P 1.45 decades/d, J 3.45 decades/d

  SUPPLY — the certified enclosure, V₀ = -14, h = 2^−14, blocks of 4.
  252317 nodes, built in 109 s.

      n     rel width      vs n = 0
      0     1.3028e-9           1.0
     20     1.1601e-7          89.0
     40     4.0572e-7         311.4
     60     9.8704e-7         757.6
     80     1.9835e-6        1522.4
    100     3.5214e-6        2702.9
    120     5.7296e-6        4397.9
    140     8.7396e-6        6708.3

  the enclosure widens like n^2.23 — h²/σ² alone would give n^1,
  and the excess is the block term, which carries an extra a² = (2n+1)².
  every one of a(0) … a(150) still encloses the measured value.

  THE CROSSING — certified from the bound, and why each failure fails.

    d  P to n  J to n  P needs @top      supplied   P's first failure
    2     120     140       1.906e0      5.992e-6   n=140: the bound
    3     120      40      1.013e-1      6.127e-6   n=140: the bound
    4     120       0      6.190e-3      6.263e-6   n=140: the bound
    5     120       —      2.810e-4      6.402e-6   n=140: the bound
    6     120       —      1.087e-5      6.542e-6   n=140: the bound
    7      20       —      3.269e-7      1.918e-7   n=40: the bound
    8       0       —      8.775e-9      3.268e-8   n=20: the bound
    9       —       —     1.979e-10      3.782e-8   n=0: the bound
   10       —       —     4.083e-12      4.325e-8   n=0: the bound

  The frontier is a **staircase**, not a number: at h = 2^−14 the pipeline
  certifies P to d = 6 across most of n ≤ 140, and progressively fewer n
  at each higher degree. B1's published grid was d ≤ 6, n ≤ 30 — and
  conditional. The columns above are both full relative widths, so they
  compare directly; the certification itself is the truth, since the two
  differ in *shape* (one enclosure per n, against one uniform widening).

  and what the next degrees cost. Demand falls 1.45 decades per unit of d
  and supply costs h², so h must shrink by 10^(1.45/2) = 5.3× per degree —
  and the node count rises by the same factor:

    d       h needed          nodes          build
    6        2^−14.0        2.523e5          4 min
    7        2^−16.4        1.347e6         23 min
    8        2^−18.8        7.189e6          2.0 h
    9        2^−21.2        3.838e7         10.8 h
   10        2^−23.7        2.049e8       2.4 days
   11        2^−26.1        1.094e9      12.9 days

  THE TRADE LAW. Demand is flat in n for P and falls 1.45 decades per d;
  supply costs h² and rises like n^2.23. So the frontier is a curve,
  not a number:

      d_max(n, h)  =  const  −  (2/1.45)·log₁₀h  −  (2.23/1.45)·log₁₀n

  which is **0.41 degrees per halving of h** and
  **1.54 degrees lost per decade of n**.

  and the h² half, measured against h/4 at the same block width 2.4414e-4:

      n h = 2^−{h_exp}    four times    ratio
      0     1.3028e-9     2.0204e-8    15.51
     40     4.0572e-7     6.4915e-6    16.00
     80     1.9835e-6     3.1735e-5    16.00
    120     5.7296e-6     9.1674e-5    16.00

  mean 15.88 against the 16 that h² predicts — 99% of it.

  Total: 322 s.
```

```
H3 — where Turán's criterion actually starts to hold

  a(0) … a(3000) at 60 digits, 30 s. a(3000) = 1.10781e-8605

  [GOR⁺] Lemma 2.3 — an exact test of (2.6)/(2.7), and what settles
  that the Δ^d of (2.6) belongs in the denominator:

    d     n      A_d,0 (must be 1)      A_d,1 (0)        A_d,2 (−d(d−1))
    2     0  1.00000000000000000e0              0 -2.00000000000000000e0
    4     0  1.00000000000000000e0              0 -1.20000000000000000e1
    6    17  1.00000000000000000e0              0 -3.00000000000000000e1
   10    40  1.00000000000000000e0              0 -9.00000000000000000e1
   12   100  1.00000000000000000e0              0 -1.32000000000000000e2

  P^{d,n} — [O'S] (8.2). Every term positive, so no cancellation:

       d       n₀    (8.2) at n₀        at n₀−1   [O'S] Thm 1.3 bound
       2        0      6.1670e-8              —              —
       3        0      2.7752e-7              —              —
       4        0      7.4007e-7              —              —
       5        0      1.5419e-6              —              —
       6        0      2.7754e-6              —              —
       7        0      4.5332e-6              —              —
       8        0      6.9080e-6              —              —
      12        0      2.4427e-5              —              —
      18        0      8.4950e-5              —              —
      27        0      2.9239e-4              —              —
      40        0      9.6288e-4              —            239
      60        0      3.2790e-3              —            381
      90        0      1.1137e-2              —            597
     135        0      3.7766e-2              —            924
     202        0      1.2702e-1              —           1409
     303        0      4.3040e-1              —           2134
     454        2      8.8622e-1       1.1135e0           3205
     681       10      9.1491e-1       1.0240e0           4786
    1021       24      9.9166e-1       1.0566e0           7103

  **(8.2) holds at n = 0 for every d ≤ 400, and fails from d = 401.**
  At the crossing: (8.2) = 0.993195 at d = 400, 1.000691 at d = 401.

  J^{d,n} — [GOR⁺] (2.9), through the renormalisation (2.6). The
  alternating sum's worst cancellation is reported, not assumed:

    d       n₀    (2.9) at n₀        at n₀−1       cancel   implied c in n ≥ c·e^d
    3        0      1.8473e-3              —       3.44e3       0.0000
    4        0      2.2165e-2              —       2.87e3       0.0000
    5        0      9.9438e-2              —       1.84e4       0.0000
    6        0      2.9274e-1              —      4.34e76       0.0000
    7        0      6.7949e-1              —       2.16e5       0.0000
    8       51      9.9835e-1       1.0076e0       1.57e8       0.0171
    9      129      9.9707e-1       1.0021e0      7.30e10       0.0159
   10      251      9.9979e-1       1.0027e0      7.24e76       0.0114
   11      434      9.9904e-1       1.0009e0      2.38e15       0.0072
   12      693      9.9961e-1       1.0008e0      8.68e76       0.0043
   13     1048      9.9924e-1       1.0000e0      1.06e20       0.0024
   14     1518      9.9952e-1       1.0001e0      7.69e21       0.0013
   15     2126      9.9980e-1       1.0002e0      6.86e24       0.0007
   16     2897      9.9990e-1       1.0002e0      1.16e77       0.0003

  Where both are defined, [O'S] Theorem 1.3's sufficient bound overshoots
  the true onset by **296× to 1602×**.
  Over the 3 degrees where n₀ > 0 it fits n₀ ~ d^3.07. That is
  **not** a test of Thm 1.3's d^0.75: those degrees run only to 2.5× past
  the onset, where n₀ is still single- or double-digit and quantised, and
  the asymptotic regime has not begun. The figure is what the accessible
  range says, not a measured exponent for the theorem.

  J's onset is **0 up to d = 7**, and positive from d = 8. Over the
  positive range it fits n₀ ~ e^(0.484·d) and n₀ ~ d^5.69, and the
  local exponent **falls** in both — 7.9 down to 5.2 in the power fit — so
  neither is the asymptotic law and this range does not identify one.
  What is solid: [GOR⁺] Theorem 1.1's n ≥ c·e^d is an upper bound on the
  onset, the measured onset grows more slowly than e^d here, and their c
  is never given, so the two cannot be compared numerically at all.

  The `cancel` column is max-term over |sum| across all A_{d,k}, and it
  overstates: it blows up wherever a coefficient is genuinely near zero.
  The real test is whether the answer moves with precision. Recomputing
  a(0) … a(2914) at 120 digits and re-evaluating (2.9) at each n₀:

    d       n₀        (2.9) at 60             at 120   rel diff
    8       51   9.98349088063e-1   9.98349088063e-1   8.24e-69
    9      129   9.97065335767e-1   9.97065335767e-1   7.57e-66
   10      251   9.99794970000e-1   9.99794970000e-1   5.85e-64
   11      434   9.99042225448e-1   9.99042225448e-1   3.12e-63
   12      693   9.99606102563e-1   9.99606102563e-1   7.27e-63
   13     1048   9.99239839009e-1   9.99239839009e-1   1.23e-58
   14     1518   9.99524105867e-1   9.99524105867e-1   5.89e-58
   15     2126   9.99801322471e-1   9.99801322471e-1   4.83e-56
   16     2897   9.99903091863e-1   9.99903091863e-1   3.00e-54

  worst 3.00e-54 — the onset is not precision-limited at 60 digits (40 s for the check).

  AND THE GAP. The criterion is sufficient, never necessary. B1/G1
  certify from the discriminant; here is where each route switches on:

    d  J: disc at n=0? J: (2.9) from n₀ P: (8.2) from n₀
    2              yes                0                0
    3              yes                0                0
    4              yes                0                0
    5              yes                0                0
    6              yes                0                0
    7              yes                0                0
    8              yes               51                0

  The headline is the two n = 0 columns read against each other:
  **P's criterion holds at n = 0 for every d ≤ 400; J's only for d ≤ 7.**
  That is H2's finding — P is enormously the cheaper criterion — arriving
  from the opposite direction. H2 measured it as 175× to 6e9× in tolerable
  enclosure width at fixed (d, n); here it is a factor of 57 in the degree
  reachable at no cost in n at all.

  And the discriminant route beats both at small d: it decides every cell
  above at n = 0, including the d = 8 where J's Turán criterion needs 51
  moments. That is the price of a criterion that is uniform in n and
  provable, against one that is a finite check with no uniformity at all.

  Total: 70 s.
```

```
  H4 — γ(n) from two representations that are not the horn
  =========================================================

  precision      60 digits requested, 77 resolvable (E11)
  horn           Γ_Φ(2n)/4 = ∫e^{(w+1)v}Φ(e^v)dv, trapezoid, V₀ = −50, h = 0.002
  uniform-u      4∫₀^∞ u^{2n}Φ(u)du, trapezoid, h = 2^-11 — same integrand, other grid
  [O'S] (7.1)    2^{1−2n}∫₁^∞(log t)^{2n}ω(t)t^{−3/4}dt, Gauss–Legendre 48/panel
  [GOR⁺] (3.1)   M!/(2M)!·[32·C(2M,2)F(2M−2) − F(2M)]/2^{2M−1}, same rule

  ── agreeing digits ───────────────────────────────────────────────────────
    n        γ(n)          u-unif   (7.1)   (3.1)/8    (7.1) vs u-unif
    0  4.97120778188e-1     27.6    27.6        —         71.7
    1  1.14859721576e-2     69.3    69.3     69.3         71.6
    2  2.46904036141e-4     72.8    69.4     69.2         69.4
    3  4.99413288831e-6     73.0    69.2     67.8         69.2
    4  9.58134372323e-8     73.5    68.1     66.4         68.1
    5  1.75392309121e-9     72.8    67.9     65.3         67.9
    6  3.07766883279e-11     72.9    67.4     64.4         67.4
    7  5.19605157185e-13     73.0    66.9     63.7         66.9
    8  8.46627186646e-15     73.0    66.8     62.8         66.8
    9  1.33472384074e-16     72.7    66.5     62.3         66.5
   10  2.04042256129e-18     72.8    67.3     62.0         67.3
   11  3.03038770773e-20     72.8    66.1     61.9         66.1
   12  4.37967586840e-22     72.7    66.7     61.4         66.7

  ── [GOR⁺] (3.1) as printed, divided by γ(M) ──────────────────────────────
  (3.1) is cited to [GORZ19, Eq. 13], whose γ is 8× larger ([O'S], under
  Table 1). Integrating ω = 2t²ψ″+3tψ′ by parts twice gives
  ∫(log t)^{2M}ω t^{−3/4}dt = 4C(2M,2)F(2M−2) − F(2M)/8, so with (7.1) the
  denominator is 2^{2M+2}, not the printed 2^{2M−1} — a factor of exactly 8.

    M =   1   (3.1)/γ(M) = 8.00000000000000000000000000000e0
    M =   2   (3.1)/γ(M) = 8.00000000000000000000000000000e0
    M =   3   (3.1)/γ(M) = 8.00000000000000000000000000000e0
    M =   5   (3.1)/γ(M) = 8.00000000000000000000000000000e0
    M =   8   (3.1)/γ(M) = 8.00000000000000000000000000000e0
    M =  12   (3.1)/γ(M) = 8.00000000000000000000000000000e0

  ── the one place the horn is the one that is wrong ────────────────────────
  At n = 0 the three routes split. [`Mellin::standard`] stops at V₀ = −50,
  where e^{(w+1)v}Φ(e^v) is still e^{V₀}Φ(0), so the trapezoid leaves an
  Euler–Maclaurin boundary term 4·(h²/12)·f′(V₀). For n ≥ 1 the weight is
  e^{(2n+1)V₀} and it vanishes; at n = 0 it does not.

       V₀      γ(0) − (7.1), relative     4(h²/12)e^{V₀}Φ(0)/Γ_Φ(0)     ratio
      -16.0          1.34827e-13                1.34827e-13          1.00000
      -30.0          1.12113e-19                1.12113e-19          1.00000
      -50.0          2.31082e-28                2.31082e-28          1.00000
      -70.0          4.76295e-37                4.76295e-37          1.00000
      -90.0          9.81717e-46                9.81717e-46          1.00000

    V₀ = −110 agrees with (7.1) to 53.7 digits — the horn converges to the
    new routes, not the other way about. Nothing published here is affected:
    the *tightest* tolerance this directory has ever asked of γ(0) is H2's
    1.709e−15 (J at d = 6), thirteen decades above the 2.31e−28 gap.

  ── the rule is converged ─────────────────────────────────────────────────
    n     48 nodes/panel, 1/unit   vs   96 nodes/panel, 2/unit
    0     agree to 71.7 digits
    4     agree to 68.1 digits
    8     agree to 66.8 digits
   12     agree to 66.7 digits

  ── at n = 1000, where H1's answer key sits ───────────────────────────────
    horn        4.84504261127258797718e-2568
    uniform-u   4.84504261127258797718e-2568   (72.9 digits vs horn)
    [O'S] (7.1) 4.84504261127258797718e-2568   (72.9 digits vs horn)
    [O'S] Table 1 prints 4.8450426112725879772e-2568
    (1.9 s)

  (60 digits requested, 77 resolvable; every figure above is computed, none quoted)
```

```
       Running `target/release/h5_asymptotic 60 24`
  H5 — the Lambert-W asymptotic for γ(n)
  =======================================

  w := W(2n/π)   and   [O'S] Theorem 1.4:
    γ(n) = 4π²e^{7w/4}√(w/(w+1))·( e·w²/(16·n·e^{2/w}) )^n·(1 + Σ_{k≥1} c_k(w)/n^k)
  with every c_k built here from partial ordinary Bell polynomials —
  (2.6) ℓ_i, (7.4) a_r, (7.7) μ_r, (7.11) κ_m, (7.13) κ*_k and c_k.

  precision 60 digits requested, 77 resolvable (E11)

  ── the chain, against what [O'S] prints ──────────────────────────────────
  at n = 1000, w = W(2000/π) = 4.87255428106479306986486e0
    c₁ computed   -2.01333686095825947238777e-1
    c₁ from (1.8) -2.01333686095825947238777e-1   (rel 5.04e-76)
    c₂ computed   -4.42840269748019711063669e-1
    c₃ computed   2.45826832270908409990123e-2
    c₆ computed   -2.09438836085866145686701e-2
    (c₂ against the rational function printed under (7.14) is a unit test)

  ── [O'S] Table 1, reproduced ─────────────────────────────────────────────
    K   Theorem 1.4 at n = 1000     [O'S] Table 1                agree
    1   4.8460204243211378239e-2568   4.8460204243211378239e-2568    20.4 digits
    3   4.8450426111532216799e-2568   4.8450426111532216799e-2568    20.7 digits
    5   4.8450426112725884216e-2568   4.8450426112725884216e-2568    20.3 digits
    7   4.8450426112725879772e-2568   4.8450426112725879772e-2568    20.3 digits
        4.8450426112725879772e-2568   γ(1000), this crate (H1)

  ── the asymptotic series' own optimal truncation ──────────────────────────
  An asymptotic series improves to a point and then diverges. Where that
  point is, as a function of n, is what decides whether the expansion could
  ever stand in for the quadrature.

       n      1    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24     best
       3    2.1  2.7  4.0  5.6  5.4  6.9  7.0  6.4  6.4  6.5  6.5  6.4  6.4  6.5  6.5  6.5  6.5  6.5  6.5  6.5  6.5  6.5  6.5  6.5   K = 7 at 7.0 digits
      10    2.1  3.3  5.8  8.0  8.3  9.5 10.1 11.2 11.1 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2 11.2   K = 8 at 11.2 digits
      50    2.6  4.3  7.7  9.4 10.9 12.6 14.5 15.3 16.7 19.7 19.3 20.4 22.1 23.0 23.8 25.1 26.6 27.0 28.0 29.4 29.5 29.7 29.6 29.6   K = 22 at 29.7 digits
     200    3.1  5.2  8.9 11.1 13.1 15.8 17.3 19.1 21.6 22.9 24.5 26.9 28.0 29.5 31.7 32.8 34.2 36.2 37.4 38.7 40.5 41.8 43.0 44.7   K = 24 at 44.7 digits
    1000    3.7  6.4 10.6 13.3 16.0 19.7 21.3 23.9 26.6 28.6 31.3 33.5 35.5 38.4 40.0 42.1 45.9 46.4 48.5 51.2 52.5 54.7 57.0 58.5   K = 24 at 58.5 digits

  (columns are K; entries are agreeing decimal digits)

  ── the bare leading factor (K = 1), across n ──────────────────────────────
       n        w = W(2n/π)         γ(n)            K = 1 relative error
       1   4.187938292248890e-1   1.1485972157573e-2   2.3500e-2
       2   6.588396192491973e-1   2.4690403614064e-4   1.6863e-3
       5   1.080464326478359e0   1.7539230912133e-9   8.9124e-3
      20   1.901504272808375e0   3.6186408980860e-37   5.0723e-3
     100   3.041301825028391e0   8.2221579732276e-206   1.5170e-3
     400   4.123242076208646e0   7.1925902496753e-937   4.6051e-4
    1000   4.872554281064793e0   4.8450426112726e-2568   2.0182e-4

  ── [GOR⁺] (3.2): the same asymptotic in L_M coordinates ───────────────────
  L_M is the positive root of M = L_M(πe^{L_M} + ¾), and K_M := (L_M^{−1} +
  L_M^{−2})M − ¾. [GOR⁺] expand γ(M) in L_(2M−2); [O'S] in W(2n/π). The two
  parameters are *not* the same, and the gap is predictable: eliminating n
  between n = (π/2)we^w and 2n−2 = L(πe^L + ¾) gives
    w − L ≈ (3L/8 + 1)/((π/2)·e^L·(1 + L))

       n        w = W(2n/π)         L_(2n−2)           w − L        predicted
      10   1.467465574120981e0   1.371157825619482e0   9.630775e-2   1.031839e-1
      50   2.531591961492383e0   2.503288582539781e0   2.830338e-2   2.882424e-2
     200   3.573257122242202e0   3.564077876649422e0   9.179246e-3   9.230791e-3
    1000   4.872554281064793e0   4.870206007334786e0   2.348274e-3   2.351504e-3
    5000   6.235372211640914e0   6.234796683694698e0   5.755279e-4   5.757165e-4

  ── (3.2) itself ──────────────────────────────────────────────────────────
  The extracted text of (3.2) does not fix how its factors nest — in
  particular whether K_(2M−2) sits under the same radical as 2π or beside it.
  Both readings are evaluated here rather than chosen:
    (A)  … / √(2π·K)      (B)  … · √(2π/K)
    γ(M) = e^{M−2}·M^{M+½}·L^{2M−2} / [ 2^{2M−5}·(2M−2)^{(2M−2)+½} ] · ⟨root⟩
             · exp( L/4 − (2M−2)/L + ¾ ),      L = L_(2M−2),  K = K_(2M−2)

       M      (A)/γ(M)          (B)/γ(M)        (B)/(8γ) − 1     [O'S] K=1 error
      10     1.252409828942     7.869123035775     -1.6360e-2      7.4522e-3
      20     1.261645360783     7.927151593741     -9.1061e-3      5.0723e-3
      50     1.267924438034     7.966604199671     -4.1745e-3      2.6400e-3
     100     1.270308472162     7.981583527872     -2.3021e-3      1.5170e-3
     200     1.271631335814     7.989895325334     -1.2631e-3      8.4484e-4
     500     1.272517987626     7.995466322972     -5.6671e-4      3.7747e-4
    1000     1.272848320867     7.997541867938     -3.0727e-4      2.0182e-4
    5000     1.273146749925     7.999416953014     -7.2881e-5      4.5502e-5

  (A) tends to 4/π = 1.273239545, which is not a normalisation anyone
  would write. (B) tends to **8** — and 8 is exactly the factor [GORZ19]'s γ
  carries over [GOR⁺]'s own (1.1), the same factor H4 measures in (3.1). Both
  formulas [GOR⁺] quote from [11] are therefore in [11]'s normalisation, and
  (B) is the reading. √(2π/K) is also the factor a Laplace-method saddle
  produces, which (A) is not.

  ── cost, against the quadrature ──────────────────────────────────────────
  H3 needs γ(0) … γ(2914) and H6 needs γ(0) … γ(d). If the asymptotic is
  cheaper *and* accurate enough at the n that matter, it replaces the horn
  there — so time both on the same n.

       n     quadrature        K = 7                   K = 24
                            time    digits     time    digits    speedup
      50      0.0093 s       0.0019 s    14.5    0.0397 s    29.6      0.23×
     200      0.0105 s       0.0019 s    17.3    0.0379 s    44.7      0.28×
    1000      0.0091 s       0.0019 s    21.3    0.0385 s    58.5      0.24×

  (every figure above is computed; γ(n) is the crate's own quadrature)
```

```
  H6 — searching Ω for the criterion with the earliest onset
  ==========================================================

  [O'S] Theorem 3.5.  Φ real entire of genus 1*, Ω ∈ Laguerre–Pólya:
    Φ hyperbolic  ⟺  Σ_j C(d,j)·c_j·g*_(d−j)(Ω; x)  hyperbolic for all d ≥ 1
  Ω = 1 → J^{d,n};  Ω = e^{−z²} → P^{d,n}(x/2), since g*_d(e^{−z²};x) = H_d(x/2).

  Everything below is one formula. With M := Ω(σz)·e^{z²},
    χ_j = Σ_i C(j,i)·γ(n+i)σ^i·M_(j−i),   c_k = C(d,d−k)·χ_(d−k)
    T   = Σ_(k≤d−2) 2^k·k!·c_k² / (2^d·(d−1)!·c_d²)   <  1
  M = 1 is [O'S] (8.2) term for term; M = e^{z²} is Turán on J directly.

  precision 60 digits requested, 77 resolvable (E11)
  γ(0) … γ(1600) built in 17.1 s

  ── validation: both papers' criteria are points of this search ────────────
    ν=0, μ=0, σ=1, g*        vs [O'S] (8.2)   — worst relative gap 6.05e-77
    Ω=1, σ=Δ/ρ, τ=−1/Δ, g    vs [GOR⁺] (2.9)  — worst relative gap 8.39e-69
    (50 cells each; `turan.rs` implements both from the printed formulas and
     never touches Lemma 3.4, so this is two derivations meeting.)

  ── dial 1: ν, the Hermite content of Ω ───────────────────────────────────
  ν = 1 − βσ² interpolates from Ω = 1 (ν = 1) to Ω = e^{−z²} (ν = 0) and
  past it. T depends on the whole Gaussian family only through ν.

          ν       T at (6,10)      T at (8,20)      T at (10,30)
       1.00    8.0677656e1    3.9440877e2    1.7951837e3
       0.50    1.3400780e1    4.2259060e1    1.1628500e2
       0.20    1.8569750e0    4.8260750e0    1.0312425e1
       0.10    4.5455721e-1    1.1431680e0    2.3328369e0
       0.01    4.5994597e-3    1.1363184e-2    2.2748580e-2
       0.00    5.1834078e-7    5.4120419e-7    5.9072856e-7
      -0.01    4.4062228e-3    1.1051609e-2    2.2287052e-2
      -0.10    4.5259613e-1    1.1399360e0    2.3278980e0
      -0.20    1.8528782e0    4.8188928e0    1.0300487e1
      -0.50    1.3387422e1    4.2227045e1    1.1620819e2
      -1.00    8.0626941e1    3.9420001e2    1.7943078e3

  **ν = 0 is a razor-sharp minimum, and it is [O'S]'s Ω exactly.** The reason
  is structural: Turán III is a statement in the Hermite basis, and ν = 0 is
  the one Ω for which the criterion polynomial is *already* in that basis —
  M ≡ 1, so no conversion happens and no extra term is added. Away from it the
  value rises in both directions and nearly symmetrically in |ν|.

  ── dial 2: μ, the translation — and here [O'S]'s choice is not optimal ────
  Ω = e^{−z²−τz} is still in LP, and g*_d(Φ·e^{−τz};x) = g*_d(Φ;x−τ), so a
  shift is an Ω-move rather than an extra freedom. What it buys is visible in
  the term that dominates T:
    χ₂(μ) = γ(n+2) − 2μ·γ(n+1) + μ²·γ(n),
  an upward parabola whose **roots** are
    μ± = γ(n+1)/γ(n) · ( 1 ± √2·Δ(n+2) ),
  with Δ the very uniformizer [GOR⁺] (2.3) introduce for J. So the quantity
  one paper needs to renormalise J is exactly the quantity that locates the
  best translation for the other paper's P — and at μ = μ± the dominant term
  of Turán's sum is annihilated outright.

    at (d,n) = (8,20):  γ(n+1)/γ(n) = 1.1895509e-2,  Δ(n+2) = 9.3581419e-2
          μ / (γ(n+1)/γ(n))         T            T/T(μ=0)
          -0.5000          2.79455e-6     5.164e0
           0.0000          5.41204e-7     1.000e0
           0.2500          1.66521e-7     3.077e-1
           0.5000          3.03029e-8     5.599e-2
           0.7500          1.13456e-9     2.096e-3
           0.8677  ← μ−          2.66225e-16     4.919e-10
           1.0000          1.71992e-10     3.178e-4
           1.1323  ← μ+          9.83711e-16     1.818e-9
           1.2500          1.13456e-9     2.096e-3
           1.5000          3.03029e-8     5.599e-2
           2.0000          5.41204e-7     1.000e0

    at (d,n) = (10,30):  γ(n+1)/γ(n) = 1.0190484e-2,  Δ(n+2) = 8.1209462e-2
          μ / (γ(n+1)/γ(n))         T            T/T(μ=0)
          -0.5000          3.03532e-6     5.138e0
           0.0000          5.90729e-7     1.000e0
           0.2500          1.83040e-7     3.099e-1
           0.5000          3.40178e-8     5.759e-2
           0.7500          1.47494e-9     2.497e-3
           0.8852  ← μ−          1.36415e-16     2.309e-10
           1.0000          1.05533e-10     1.786e-4
           1.1148  ← μ+          4.15405e-16     7.032e-10
           1.2500          1.47493e-9     2.497e-3
           1.5000          3.40178e-8     5.759e-2
           2.0000          5.90728e-7     1.000e0

  ── dial 3: σ, and why d_max at n = 0 is not a scale-invariant number ──────
  Holding ν = 0 while scaling leaves the criterion equal to (8.2) with its
  j-th term multiplied by σ^{2j}, so the j = 2 term — which dominates —
  scales like d³σ⁴ and d_max ∝ σ^{−4/3}. Measured:

          σ      d_max at n = 0     d_max/d_max(σ=1)   σ^{−4/3}
      2.000           159         0.398           0.397
      1.500           233         0.583           0.582
      1.000           400         1.000           1.000
      0.750           588         1.470           1.468
      0.500          1010         2.525           2.520

  **So H3's "d ≤ 400" is a property of [O'S]'s normalisation, not of the
  method.** Nothing is gained by shrinking σ — the criterion at scale σ is the
  criterion at effective degree dσ², with the high-j terms (the ones carrying
  γ's moment ratios, hence RH) suppressed by σ^{2j}. But it means d_max is not
  comparable across Ω unless the scale is pinned. It is pinned at σ = 1 below.

  ── the leaderboard: d_max at n = 0, σ = 1 ────────────────────────────────
    criterion                              d_max at n = 0     T at d = 8, n = 0
    [GOR⁺] (2.9), Ω = 1 renormalised               7          1.3552123e0
    Ω = 1, raw, g form                           < 2          3.0174256e21
    Ω = 1, raw, g* form                          < 2          3.9500155e2
    [O'S] (8.2), Ω = e^(−z²)                     400          6.9079599e-6
    Ω = e^(−z²−τz), τ = γ(1)/γ(0)               1400+         3.8691236e-8
    Ω = e^(−z²−τz), τ = μ− (χ₂ = 0)             1400+         2.5388419e-13
    Ω = J_α, α = −0.5                            < 2          5.6180144e3
    Ω = J_α, α = 0                               < 2          1.6717553e3
    Ω = J_α, α = 2                               < 2          5.2870391e2
    Ω = J_α, α = 8                               < 2          4.0547925e2
    Ω = cos z                                      2          3.4834482e1
    Ω = e^(−½z²)                                   2          4.2343963e1
    Ω = e^(−2z²)                                   2          3.9425559e2

  ── the onset n₀(d), which no scale can move ───────────────────────────────
  d_max at n = 0 moves with σ; the *growth* of n₀(d) does not, because σ only
  shifts the effective degree by a constant factor. This is the quantity
  [GOR⁺] Theorem 1.1 (n ≥ c·e^d) and [O'S] Theorem 1.3 (n/log²n ≥ d^{3/4}/2)
  actually bound, and the one H3 measured.

        d     [O'S] P     shifted τ = μ−       ratio
      400          0               0                 ∞
      500          3               0                 ∞
      600          7               0                 ∞
      700         10               0                 ∞
      800         15               0                 ∞
      900         19               0                 ∞
     1000         23               0                 ∞

  ── why the shift changes the power of d ───────────────────────────────────
  For [O'S]'s P the j = 2 term of Turán's sum dominates, and it carries
  d·C(d,2)/(2²·2!) ~ d³. The shift annihilates that term exactly, so j = 3
  takes over and the power becomes d⁴ — a change of *exponent*, not of
  constant, and the only other move in this search that manages one is
  Ω = 1 → Ω = e^(−z²) itself.

          d       [O'S] P (8.2)      shifted τ = μ−
        100      1.529731e-2       9.163714e-9
        200      1.232765e-1       1.488650e-7
        400      9.931947e-1       2.399932e-6
        800      8.028185e0       3.854514e-5
       1400      4.364039e1       3.621151e-4

    fitted exponent   [O'S] P: d^3.015     shifted: d^4.011
    extrapolated d_max for the shifted criterion: 10095
    ([O'S] P's own d_max = 400, measured. Run `h6_omega 10600 10500` to locate
     the shifted criterion's own crossing directly — it is d = 10141, with
     T = 0.99970 there and 1.000094 at d = 10142, and that run takes 12 min.)

  ── precision is not the obstacle, measured rather than assumed ───────────
  The shift is an exact cancellation by construction — χ₂(μ−) = 0 — so it
  is the one place in this search where a naive argument would predict the
  arithmetic to fail. Recomputing everything at 180 digits:

          d        T at 60 digits     T at 180 digits    relative move
        100       9.1637141195e-9    9.1637141195e-9    0.00e0
        200       1.4886504669e-7    1.4886504669e-7    0.00e0
        400       2.3999317498e-6    2.3999317498e-6    0.00e0

  (total 64.0 s)

  and, run with the cap raised (`h6_omega 10600 10500`), the crossing itself:

  d=10250  T=1.043394449e0  fails
  d=10125  T=9.934026519e-1  holds
  d=10187  T=1.017968455e0  fails
  d=10156  T=1.005629283e0  fails
  d=10140  T=9.993047542e-1  holds
  d=10148  T=1.002463277e0  fails
  d=10144  T=1.000883081e0  fails
  d=10142  T=1.000093684e0  fails
  d=10141  T=9.996991607e-1  holds
  d_max = 10141
```

```
  G6 — K_req(w, k), the truncation law of the Jensen flow
  =======================================================

    A(w)    = Γ_Φ(w)·Γ(w/2+1)/Γ(w+1)                      CONTINUATION (28)
    F(w, y) = Σ_(j≥0) A(w+2j)·y^j/j!                                    (29)

  A K-term truncation is a polynomial of degree K−1. Some of its roots are
  the flow's; the rest are artifacts. K_req(w,k) is the fewest terms at which
  the k-th root sits within a stated tolerance of its converged place **and
  stays there** for every larger K — the second half being what separates a
  law from a coincidence.

  precision 60 digits requested, 77 resolvable (E11); K ≤ 170

  ── the anchor: at w = 0 the answer is known from outside ─────────────────
  CONTINUATION §8.2: F(0, y) = ξ(½ + √y), so the roots are y = −γ_k². Those
  γ_k are the only numbers here from outside the crate, and they are carried
  to twenty digits — so this comparison saturates at *their* precision, as
  H1's did at [O'S]'s.

     k        −γ_k²              F(0,·) at K = 170          relative
     1   -1.99790454832386859e2   -1.99790454832386859e2   6.470e-20
     2   -4.41926150574082490e2   -4.41926150574082490e2   3.535e-20
     3   -6.25542996894331058e2   -6.25542996894331058e2   1.709e-20
     4   -9.25673087273896182e2   -9.25673087273896182e2   2.082e-20
     5   -1.08471828178817347e3   -1.08471828178817347e3   2.221e-20
     6   -1.41272078858698393e3   -1.41272078858698393e3   4.426e-20
     7   -1.67434156559508088e3   -1.67434156559508088e3   4.409e-19
     8   -1.87723527908977846e3   -1.87723527908977846e3   2.143e-18
     9   -2.30449451112362413e3   -2.30449451112362396e3   7.367e-17
    10   -2.47743439951538607e3   -2.47743439951538680e3   2.958e-16

  ── K_req at w = 0, and how it depends on the tolerance ───────────────────
     k      γ_k = √|z_k|     K_req(1e−3)  (1e−6)  (1e−12)   K_req/γ_k at 1e−6
     1        14.13473            16      20       26        1.415
     2        21.02204            28      32       38        1.522
     3        25.01086            36      40       46        1.599
     4        30.42488            46      50       58        1.643
     5        32.93506            52      56       62        1.700
     6        37.58618            64      66       72        1.756
     7        40.91872            70      74       80        1.808
     8        43.32707            78      78       86        1.800
     9        48.00515            86      90       98        1.875
    10        49.77383            92      94      102        1.889

  ── K_req across the flow ─────────────────────────────────────────────────
  For w ≠ 0 there is no external answer key, so the target is the root's own
  converged place — present at K = 170 *and* at K = 158, in the same spot.
  Everything else the truncation reports is discarded as an artifact.

       w   |    K_req at tolerance 1e−6, by root index k
           |     k=1     k=2     k=3     k=4     k=5     k=6
       0   |      20      32      40      50      56      66
       1   |      22      32      40      50      56      66
       2   |      22      34      42      52      58      68
       4   |      24      34      44      52      60      68
       6   |      26      36      46      54      62      70
       8   |      28      38      46      56      64      72
      12   |      30      42      50      60      68      76
      16   |      34      44      54      62      70      78
      24   |      40      50      60      68      78      86

  ── the law ───────────────────────────────────────────────────────────────
  Predicted before measuring, from the coefficient decay alone. A(w+2j) is
  a(j + w/2), which falls like (C/j)^j with C growing only logarithmically
  ([O'S] Theorem 1.4). So |A(w+2j)y^j/j!| ~ (Ce/j²)^j|y|^j, whose largest
  term sits at j* = √(C|y|/e): **K_req should be a function of √|z| alone**,
  with a slow logarithmic drift, and not of w and k separately.

     √|z|      K_req     K_req/√|z|
      14.135        20       1.4150
      14.875        22       1.4790
      15.586        22       1.4115
      16.936        24       1.4171
      18.209        26       1.4278
      19.421        28       1.4417
      21.022        32       1.5222
      21.559        32       1.4843
      22.098        34       1.5386
      23.172        34       1.4673
      23.833        34       1.4266
      24.233        36       1.4856
      25.011        40       1.5993
      25.654        40       1.5592
      26.272        42       1.5986
      27.315        42       1.5376
      27.790        40       1.4394
      28.570        46       1.6101
      29.281        44       1.5027
      29.644        46       1.5518
      30.425        50       1.6434
      30.815        50       1.6226
      31.232        52       1.6650
      31.690        50       1.5778
      32.114        52       1.6192
      32.935        56       1.7003
      33.582        56       1.6675
      33.959        56       1.6491
      35.340        60       1.6978
      35.821        60       1.6750
      36.417        62       1.7025
      37.325        60       1.6075
      38.044        66       1.7349
      38.498        68       1.7663
      39.400        68       1.7259
      40.308        70       1.7366
      40.919        74       1.8085
      43.006        76       1.7672
      44.778        78       1.7419
      48.005        90       1.8748
      49.774        94       1.8885

    fitted exponent over the whole range: K_req ~ (√|z|)^1.229
    K_req/√|z| runs 1.415 → 1.889 while √|z| runs 14.1 → 49.8

  ── which limit binds: truncation or precision ────────────────────────────
  The two bind together, and the driver has to say which. Same measurement at
  three working precisions; if K_req moves, precision is the limit.

    digits   resolvable   K_req(w=0) for k = 1 … 6
        30           38      20    32    40    50    56    66
        45           57      20    32    40    50    56    66
        60           77      20    32    40    50    56    66
        90           96      20    32    40    50    56    66

  ── what §8.3 actually resolved, now that K_req is known ──────────────────
  §8.3 truncated at K = 34 and reported four roots, keeping two. Against the
  law: at w = 0, K = 34 buys everything with K_req ≤ 34 and nothing else.

     k     K_req(1e−6)   §8.3's K = 34      B2's K = 48
     1            20           6.46e-20         6.47e-20
     2            32            1.39e-9         3.53e-20
     3            40            1.95e-3         1.72e-15
     4            50        not present          1.05e-5
     5            56        not present          2.63e-2

  (total 138.9 s)
```

```
  B2 — the Jensen flow, F(w, ·) = Σ_j A(w+2j)·y^j/j!
  ===================================================

  precision 60 digits requested, 77 resolvable (E11); K = 140
  roots by bisection inside one-root brackets, not by a global solve

  ── w = 0 is ξ(½ + √y), so the roots are −γ_k² ────────────────────────────
     z1  -1.997904548323869e2   against −γ² = -1.997904548323869e2   (6.47e-20)
     z2  -4.419261505740825e2   against −γ² = -4.419261505740825e2   (3.53e-20)
     z3  -6.255429968943311e2   against −γ² = -6.255429968943311e2   (1.71e-20)
     z4  -9.256730872738962e2   against −γ² = -9.256730872738962e2   (2.08e-20)
     z5  -1.084718281788173e3   against −γ² = -1.084718281788173e3   (2.22e-20)
     z6  -1.412720788586984e3   against −γ² = -1.412720788586984e3   (4.43e-20)

  ── the flow, resolved ────────────────────────────────────────────────────
  Every entry below is stable between K = 128 and K = 140, and G6's law says
  how many terms each one needed. §8.3's own table is reproduced beside it.

       w        z₁            z₂            z₃            z₄            z₅
       0      -199.7905    -441.9262    -625.5430    -925.6731   -1084.7183
       1      -221.2555    -464.8058    -658.1144    -949.5500   -1127.7697
       2      -242.9143    -488.3206    -690.2310    -975.4251   -1169.1825
       4      -286.8341    -536.9185    -753.5670   -1031.2855   -1248.9157
       8      -377.1699    -638.9887    -878.7527   -1153.1895   -1402.0928
      12      -470.9035    -746.1074   -1004.2606   -1283.1656   -1552.3739

    §8.3 prints, for comparison:
       0     −199.79      −442.41            —             —             —
       1     −221.26      −464.81            —             —             —
       2     −242.91      −488.32            —             —             —
       4     −286.83      −536.92            —             —             —
       8     −377.17      −639.18            —             —             —
      12     −470.90      −739.87            —             —             —

    The z₁ column reproduces everywhere. **The z₂ column does not**: at
    w = 0 the answer is checkable against −γ₂² and §8.3 is off by 0.48,
    and at w = 12 it is off by 6.2 in the other direction.

  ── the derivative §8.3 prints, by central differences on the same data ───
       w     dz₁/dw     §8.3
       0      -21.47    −21.43
       2      -21.76    −21.76
       8      -23.01    −23.01

  ── K_req at w = 0 (G6's measurement), against what §8.3 spent ────────────
     k    K_req(1e−6)   §8.3 had K = 34
     1           20       resolved
     2           32       resolved
     3           40       **not** resolved
     4           50       **not** resolved
     5           56       **not** resolved

    So §8.3's "only z₁ and z₂ are trustworthy" was right, and right for the
    right reason — but "z₄ is a pure truncation artifact" was not: z₄ is the
    fourth zero, and it needs terms §8.3 did not have. See A4 and E5.
```

```
  G4 — does non-integer w add content?
  =====================================

  CONTINUATION §8.2 asks for F(w, ·) ∈ Laguerre–Pólya at **every** w, where
  the classical criterion needs only w = 2n. A genuine complex root at a
  non-integer w would make §8.2 strictly stronger; nothing but real negative
  roots would make it a repackaging.

  precision 60 digits requested, 77 resolvable (E11)
  truncations K = 110 and K = 130; a root counts only if it sits in the same
  place in both. G6's law K_req ≈ 1.9·√|z| makes the **trusted disc**
  |y| ≤ (110/1.9)² = 3352 — outside it a K = 110 truncation says nothing.

  ── regression: at w = 0 the trusted disc must hold exactly the −γ_k² in it ─
    −γ_k² inside the disc: 10   real roots the K = 110 scan finds: 12
      k = 1   -1.9979045483239e2   vs −γ² -1.9979045483239e2   (6.47e-20)
      k = 2   -4.4192615057408e2   vs −γ² -4.4192615057408e2   (3.53e-20)
      k = 3   -6.2554299689433e2   vs −γ² -6.2554299689433e2   (1.71e-20)
      k = 4   -9.2567308727390e2   vs −γ² -9.2567308727390e2   (2.08e-20)
      k = 5   -1.0847182817882e3   vs −γ² -1.0847182817882e3   (2.22e-20)
      k = 6   -1.4127207885870e3   vs −γ² -1.4127207885870e3   (4.43e-20)
      k = 7   -1.6743415655951e3   vs −γ² -1.6743415655951e3   (4.41e-19)
      k = 8   -1.8772352790898e3   vs −γ² -1.8772352790898e3   (2.14e-18)
      k = 9   -2.3044945111236e3   vs −γ² -2.3044945111236e3   (7.37e-17)
      k = 10   -2.4774343995154e3   vs −γ² -2.4774343995154e3   (2.96e-16)

  ── the scan: w from 0 to 12 in 24 steps, integers included ────────────
  At each w and each truncation: **count** the zeros inside |y| ≤ 3352 by the
  argument principle, and count the sign changes on [−3352, 0) by bisection.
  If the two agree, every zero in the disc is real and negative — no
  root-finding, and no artifact can hide. If they differ by 2m, there are m
  conjugate pairs off the axis.

         w     K=110: in disc / real     K=130: in disc / real    off-axis pairs
       0.00            12 / 12                  12 / 12             0 ←int
       0.50            12 / 12                  12 / 12             0
       1.00            12 / 12                  12 / 12             0 ←int
       1.50            12 / 12                  12 / 12             0
       2.00            12 / 12                  12 / 12             0 ←int
       2.50            12 / 12                  12 / 12             0
       3.00            12 / 12                  12 / 12             0 ←int
       3.50            12 / 12                  12 / 12             0
       4.00            11 / 11                  11 / 11             0 ←int
       4.50            11 / 11                  11 / 11             0
       5.00            11 / 11                  11 / 11             0 ←int
       5.50            11 / 11                  11 / 11             0
       6.00            11 / 11                  11 / 11             0 ←int
       6.50            11 / 11                  11 / 11             0
       7.00            11 / 11                  11 / 11             0 ←int
       7.50            11 / 11                  11 / 11             0
       8.00            11 / 11                  11 / 11             0 ←int
       8.50            11 / 11                  11 / 11             0
       9.00            11 / 11                  11 / 11             0 ←int
       9.50            11 / 11                  11 / 11             0
      10.00            11 / 11                  11 / 11             0 ←int
      10.50            11 / 11                  11 / 11             0
      11.00            10 / 10                  10 / 10             0 ←int
      11.50            10 / 10                  10 / 10             0
      12.00            10 / 10                  10 / 10             0 ←int

  ── what the scan says ────────────────────────────────────────────────────
    25 of 25 sample points decided at both truncations; 0 undecided

    **Every zero of F(w, ·) inside the trusted disc is real and negative,
    at every w sampled — at the integers and between them.** The zero
    count from the contour equals the sign-change count on the axis at
    both truncations, everywhere, so there is no room for a conjugate
    pair to hide.

    Within reach, **non-integer w adds no content**: §8.2's "for every w"
    is the same condition as "for every even integer". §8 is a
    repackaging of the integer statement — a useful one, because it
    removes a false problem (the missing degree axis) and replaces it
    with a real one (a domain in ℂ²) — and §8.4 should say so where it
    currently says only that restating is not obtaining.

    What this does **not** establish: anything outside |y| ≤ 3352, and
    anything at complex w. A zero beyond the disc is not absent — it is
    unseen, which is the distinction TODO **D** insists on for B3 and which
    applies here verbatim. G6's law is what puts the boundary where it is.

  (total 191.4 s)
```

```
  G5 — the constant in |w|·(R(w) − 1), derived
  =============================================

  CONTINUATION §4 reads "R − 1 ~ 4/|w|" off a creep through 2.13 … 3.19.
  C3 extended it sixteenfold and reached 3.445 at w = 9600, which settled
  nothing — the data fit a limit of 4 and a slow logarithmic divergence
  equally well. So derive it.

    L(w) := log Γ_Φ(w),   Γ_Φ(w) = 4∫e^{(w+1)v}Φ(e^v)dv
    R(w)  = exp(−Δ²L(w))·R_f(w),   Δ²L = L(w+4) − 2L(w+2) + L(w)
    R_f   = (w+3)(w+4)/((w+1)(w+2)) = 1 + 4/w − 2/w² + …          exact
    L′(w) = ⟨v⟩_w,   L″(w) = Var_w(v)   under ρ_w ∝ e^{(w+1)v}Φ(e^v)   exact
    Δ²L   = ∫_{−2}^{2}(2−|s|)L″(w+2+s)ds = 4L″(w+2) + (4/3)L⁗ + …    exact
    Var_w(v) = 1/(−P″(v*)) + …,  P(v) = log Φ(e^v)              Laplace

  precision 60 digits requested, 77 resolvable (E11)

  ── the identities, checked ───────────────────────────────────────────────
  L′ and L″ are moments of the tilted density. Against Richardson-extrapolated
  differences of log Γ_Φ — the identity is exact, so only the difference
  quotient is approximate, and this says by how much.

         w      L′ vs ⟨v⟩       L″ vs Var_w(v)
           4     5.306e-19        3.676e-6
          20     6.766e-20        8.511e-9
         100     2.127e-21        1.461e-11
        1000     4.660e-24        1.418e-15
       10000     2.262e-26        1.339e-19

  ── the one approximation: Laplace on Var_w(v) ────────────────────────────
  The saddle v* solves (w+1) + P′(v) = 0. Writing U = e^{v*}, the leading
  shell of Φ gives 2πU·e^{2U} = w + 1 + (9/2)U and −P″ = (w+1)(1+2U) + 9U².
  Both are checked against the *full* Φ, not assumed.

         w         U = e^{v*}      Var vs 1/(−P″)     −P″ vs closed form
           30        0.90961       5.490e-2          6.066e-3
          300        1.68598       8.605e-3          2.847e-4
         3000        2.60722       1.188e-3          7.575e-6
        30000        3.59592       1.523e-4          1.513e-7
       300000        4.62151       1.869e-5          2.570e-9
      3000000        5.67049       2.220e-6          3.940e-11

  ── a by-product: the quadrature's own reach, as a formula ────────────────
  The same saddle gives σ = 1/√(−P″), the peak's half-width in v, and the
  integrand is Gaussian to leading order — so Poisson summation puts the
  trapezoid's relative error at **exp(−2π²(σ/h)²)**. The nodes across the
  width are therefore the right diagnostic after all, entering *squared in
  the exponent* rather than as a power (sharpening **E10**), and the law says
  halving h **quadruples** the digits — H1 measured ×3.79 and ×3.29.

          w        σ = 1/√(−P″)   σ/h at h=.002   exp(−2π²(σ/h)²)
         2000       9.2001e-3          4.60         3.99e-182
         9600       3.8006e-3          1.90         1.10e-31
        40000       1.7202e-3          0.86         4.55e-7
       102400       1.0258e-3          0.51         5.56e-3
       400000       4.8787e-4          0.24         3.09e-1
      6400000       1.0947e-4          0.05         9.43e-1

    So `Mellin::standard` stops measuring R and starts measuring its own step
    at about w = 4×10⁴. Below is an **adapted** rule instead: step σ/2.5, and
    V₀ raised to −2 because e^{(w+1)v} has already killed everything under it.

  ── the prediction against the measurement ────────────────────────────────
  w(R−1) = w·[R_f·exp(−4·L″(w+2)) − 1], with L″ from Laplace and everything
  else exact. The residual is Watson's next term, so it must fall like 1/w —
  and be *seen* to, not merely be small.

          w      measured w(R−1)     derived         relative    × per 4× in w
         9600      3.4447869664     3.4450222353    6.830e-5     —
        40000      3.5263999664     3.5264556242    1.578e-5     1.04
       160000      3.5866911136     3.5867048642    3.834e-6     1.03
       640000      3.6340081244     3.6340115284    9.367e-7     1.02
      2560000      3.6720061398     3.6720069839    2.299e-7     1.02
     10240000      3.7031208350     3.7031210446    5.660e-8     1.02

    The last column is the error's fall divided by the growth in w. It sits
    at 1, which is Watson's lemma: the neglected term is O(1/w) relative.
    Three and a half decades past where C3 stopped, and still on the nose.

  ── the answer ────────────────────────────────────────────────────────────
  2πU·e^{2U} = w is solved exactly by **U = ½·W(w/π)**, W the Lambert function
  the crate already owns from **H5**. So 1 + 2U = 1 + W(w/π) and

        w·(R(w) − 1)  =  4  −  4/(1 + W(w/π))  +  O(1/w)

          w        4 − 4/(1+W(w/π))     measured w(R−1)      difference
          600        3.18250824          3.18653216        -4.02e-3
         2400        3.33601398          3.33719084        -1.18e-3
         9600        3.44446034          3.44478697        -3.27e-4
       160000        3.58666880          3.58669111        -2.23e-5
      2560000        3.67200464          3.67200614        -1.50e-6
     10240000        3.70312045          3.70312084        -3.86e-7

    **The limit is 4**, because W(x) → ∞. The approach is 4/W(w/π) ~ 4/log w,
    which is exactly why C3's sixteenfold extension in w bought only 0.26.

  ── what C3's empirical fit was actually seeing ───────────────────────────
  C3 fitted a = 4 − 5.09/ln w. The derivation says the correction is
  4/(1 + W(w/π)), so the fitted numerator should be 4·ln w/(1 + W(w/π)) —
  a slowly drifting quantity that a fit over one decade reads as a constant.

          w      4·ln w/(1 + W(w/π))
          600          5.2294
         1200          5.2018
         2400          5.1680
         4800          5.1313
         9600          5.0940

    It falls from 5.23 to 5.09 across C3's own range and keeps falling — so
    "5.09" was a local reading of a moving quantity, taken at the top of the
    range where it happened to sit. That is why extrapolating it gave 3.68 at
    w ≈ 10⁷ (the truth there is 3.693, and the fit was low because the
    numerator keeps shrinking) and why the number could not settle anything.

  ── how far away the limit actually is ────────────────────────────────────
  Inverting 4 − 4/(1 + W(w/π)) = a, i.e. w = π·W·e^W with W = 4/(4−a) − 1:

     to see w(R−1) reach      you need w ≈
            3.445               10^4.0
            3.500               10^4.4
            3.600               10^5.4
            3.700               10^6.9
            3.800               10^10.0
            3.900               10^19.0
            3.950               10^36.7
            3.990               10^176.4
            3.999               10^1740.8

    C3 reached w = 9600 ≈ 10^4.0 and read 3.445. **One more digit of the
    constant needs w ≈ 10^19; two more, 10^176.** No computation was ever
    going to settle this, which is what G5 was for, and §4's claim now rests
    on a derivation instead of on a creep.

  (total 64.0 s)
```
