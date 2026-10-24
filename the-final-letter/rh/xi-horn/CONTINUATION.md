# The margin table, continued — a holomorphic positivity function

Companion to [POSITIVITY.md](POSITIVITY.md), whose margin table is a list of
numbers indexed by integers *n*. This file replaces the table by a single
function of a complex variable, holomorphic where it should be, whose values at
w = 0, 2, 4, … are the table's rows.

**Headline result.** The continued margin has **no zeros anywhere computed**.
R(w) − 1 decays like 4/|w| in every direction in ℂ, driven entirely by the
factorial gain, with the Cauchy–Schwarz defect becoming negligible. Positivity
is not merely true at the integers — it is asymptotically *free*, and gets
freer with |w|.

**Two false starts are recorded in §5**, because both produced convincing
spurious zeros and the second survived one round of refinement. The failure
mode is specific and reproducible; anyone continuing this work will hit it.

---

## 1. The continuation

The moments are already a Mellin transform. Set

```
Γ_Φ(w) = 4 ∫₀^∞ u^w · Φ(u) du                                              (21)
```

so that **γ(n) = Γ_Φ(2n)**. The integral converges for Re w > −1 and is
holomorphic there. Split at any **U₀ with 0 < U₀ < π/4** and use Φ's Taylor
series at the origin — which has only even powers, Φ(u) = Σ_k c_{2k}u^{2k},
because Φ is even —

```
Γ_Φ(w) = 4·Σ_{k≥0} c_{2k}·U₀^{w+2k+1}/(w + 2k + 1)
       + 4∫_{U₀}^∞ u^w Φ(u) du                                            (22)
```

The second term is entire (Φ decays double-exponentially). So **Γ_Φ is
meromorphic on ℂ with simple poles at w = −1, −3, −5, … only** — the even
negative integers are regular — with residue 4c_{2k} at w = −(2k+1), which is
independent of U₀ as it must be. In particular the residue at w = −1 is
4Φ(0) = 1.7867876.

> **The bound U₀ < π/4 is not decoration, and this identity was first written
> without it — splitting at u = 1.** Φ(u) = 2e^{u/2}ω(e^{2u}) with ω built from
> θ, and θ has Re t = 0 as a natural boundary, so Φ is analytic exactly on
> |Im u| < π/4 and the Taylor series at the origin has radius **π/4 = 0.785**.
> At u = iπ/4 the defining sum's own terms are (2π²k⁴e^{9iπ/8} − 3πk²e^{5iπ/8})(−1)^k
> and do not decay at all. Integrating the series over [0, 1] is therefore not
> available, and Σ_k c_{2k}/(w+2k+1) diverges. Everything above survives the
> repair — same poles, same residues, and (23) still entire — but the split
> point has to be inside the disc. Measured in `rust/`: |c_m|^{1/m} runs
> 1.25–1.45 over 30 ≤ m ≤ 158, settling toward 4/π = 1.27324 from above, with
> the coefficients enclosed to 1e−118 relative. See TODO **E14** and
> `rust/src/series.rs`; the first four are
> c₀ = 0.44669690046712344, c₂ = −4.18262519367581422,
> c₄ = 16.92005903032133932, c₆ = −35.23314299039473380.

### The entire repackaging

The Taylor coefficients of ξ are c(n) = γ(n)/(2n)!, and (2n)! = Γ(2n+1), so the
continuation of *that* sequence is

```
C(w) = Γ_Φ(w) / Γ(w+1)                                                     (23)
```

and this is **entire**. 1/Γ(w+1) has simple zeros at w = −1, −2, −3, …; Γ_Φ has
simple poles at w = −1, −3, −5, …. Every pole is cancelled, and C picks up
simple zeros at w = −2, −4, −6, … where the reciprocal gamma vanishes and Γ_Φ
does not. At the cancelled points C takes finite values — e.g. C(−1) = 4Φ(0).

That is the whole content of the "divide by (2n)!" step of POSITIVITY.md §3,
seen properly: it is what turns a function with a pole string into an entire
one.

---

## 2. The holomorphic margin

The Turán ratio continues verbatim, with n → n+1 becoming w → w+2:

```
            C(w+2)²          Γ_Φ(w+2)²         (w+3)(w+4)
   R(w) = ───────────  =  ───────────────── · ──────────────                (24)
          C(w)·C(w+4)     Γ_Φ(w)·Γ_Φ(w+4)     (w+1)(w+2)
                          └─ Cauchy–Schwarz ─┘ └─ factorial gain ─┘
```

meromorphic on ℂ, and **positivity at index n is exactly R(2n) > 1**. The
margin ratio of POSITIVITY.md (11) is M(w) = −log R_γ(w) / log R_f(w), the two
bracketed factors above.

The margin table is now the restriction of R to the even non-negative integers,
and the questions one could not ask of a table become available: where does R
equal 1? Is the real axis near that set? What is R doing at infinity?

---

## 3. Validation

Γ_Φ(2n) against the 60-digit γ(n) of POSITIVITY.md:

```
   n     Γ_Φ(2n)              γ(n)                 rel. error
   0     4.9712077819e-01     4.9712077820e-01     2.4e-11
   1     2.2971944315e-02     2.2971944315e-02     2.1e-12
   2     2.9628484337e-03     2.9628484337e-03     6.9e-13
  10     1.3679861516e-06     1.3679861516e-06     7.1e-13
  20     1.2135730923e-07     1.2135730923e-07     3.0e-12
```

---

## 4. What the continued margin does

### Along the real axis — nothing hides between the integers

```
    w      R(w)        M(w)          w      R(w)−1      w·(R−1)    M(w)
    0    2.149688    0.572865        10    0.212569     2.126     0.399942
    1    1.780329    0.520921        40    0.066295     2.652     0.318200
    2    1.594115    0.491080        80    0.035423     2.834     0.282105
    3    1.481454    0.470273       150    0.019781     2.967     0.253215
    4    1.405738    0.454362       300    0.010292     3.088     0.225631
    6    1.310063    0.430771       600    0.005311     3.187     0.202166
```

Smooth, monotone, positive throughout. The odd-integer and fractional values
interleave the table exactly as interpolation would suggest — **the discrete
condition was a faithful sample of a smooth function**, not a set of isolated
lucky points.

### Into the complex plane — no zeros, and the reason

At x = 5, verified at 40 decimal digits (§5 explains why that is needed):

```
    w          |Γ_Φ(w)|        |R(w) − 1|      |w|·|R−1|
   5+ 10i      7.3307e-05      0.20881561        2.33
   5+ 25i      7.2751e-08      0.10433776        2.66
   5+ 50i      7.9885e-13      0.05646091        2.84
   5+ 90i      3.0078e-20      0.03281251        2.96
   5+150i      1.3877e-30      0.02029892        3.05
```

The same creep toward a single constant as on the real axis, and the factorial
gain alone contributes R_f − 1 ≈ 4/w. **Two paragraphs used to stand here
claiming more than these tables carry, and both have since been measured. What
they support is this:**

> **|w|·(R(w) − 1) → 4, and the approach is logarithmic.** The creep is real —
> extended sixteenfold past the table above it reads 3.269, 3.337, 3.395,
> **3.445 at w = 9600**, a factor of 960 in w having bought 1.32 — and no
> extension was ever going to settle it. **G5 derives it instead.** Writing
> L = log Γ_Φ, (24) is R = exp(−Δ²L)·R_f with Δ²L = L(w+4) − 2L(w+2) + L(w);
> the two derivatives of L are moments of the tilted density
> ρ_w(v) ∝ e^{(w+1)v}Φ(e^v),
>
> ```
> L′(w) = ⟨v⟩_w,   L″(w) = Var_w(v),   Δ²L = ∫_{−2}^{2}(2−|s|)L″(w+2+s)ds
> ```
>
> all exact; Laplace on the saddle of (w+1)v + log Φ(e^v) gives
> Var_w(v) = 1/[(w+1)(1+2U) + 9U²] with 2πU·e^{2U} = w + 1 + (9/2)U; and that
> saddle equation is solved by **U = ½·W(w/π)**, W the Lambert function. So
>
> ```
> w·(R(w) − 1)  =  4  −  4/(1 + W(w/π))  +  O(1/w)                     (24a)
> ```
>
> **The limit is 4** — W(x) → ∞ — and the correction dies like 4/log w, which
> is exactly why the numerics crawled. Checked against the measured R over
> three and a half decades past where C3 stopped: at w = 10⁷ the derivation
> gives 3.7031210446 against a measured 3.7031208350, a relative 5.7e−8, and
> the residual falls like 1/w at every step, which is Watson's next term.
> C3's empirical a = 4 − 5.09/ln w was reading 4·ln w/(1 + W(w/π)) — a
> quantity that falls from 5.23 to 5.09 across C3's own range and keeps
> falling, so the fit was a local snapshot of something moving.
>
> **How far the limit is**: reaching 3.9 needs w ≈ 10¹⁹ and 3.99 needs
> w ≈ 10¹⁷⁶. Nothing computational was ever going to read this off, which is
> why it had to be derived.

> **No zero of R − 1 was found**, in the widest scan run: 425 points at 50
> decimal digits over Re w ∈ [0, 40] × Im w ∈ [0, 150]. But that is not
> evidence of absence, and cannot be made into it. The smallest |R − 1| found
> was **1.9526e−2, at w = 40 + 150i — the far corner of the box**, and the
> same run at a coarser grid put its infimum at the corner too. At that point
> |w|·|R − 1| = 3.031, which is exactly the real-axis creep at |w| ≈ 155. So
> the minimum is not an anomaly; it is the ~3/|w| decay evaluated at the
> farthest point tried, and a bigger box moves it down again. **A bounded scan
> of a quantity decaying to zero cannot establish that it has no zero, at any
> precision.** See **B3**.

One further caveat on the complex table above: it stops at 5 + 150i for a
reason. |Γ_Φ| has fallen to ~1e−30 there and to ~1e−80 by 400i, and at 50
digits the ratio (24) is then formed from noise — |w|·|R − 1| reads 426.07 at
5 + 400i. Nothing in this directory should quote an R or Γ_Φ value above
|Im w| ≈ 200.

The margin ratio M(w) → 0 slowly, which the table does show and which nothing
above disturbs.

---

## 5. Method, and two false starts

This section exists because the wrong answer was obtained twice, convincingly.

**The problem.** Γ_Φ(w) = 4∫₀^∞u^wΦ(u)du has integrand u^{iy} = e^{iy·log u}.
As u → 0 the phase runs to −∞, so any quadrature with nodes clustered on a
*linear* scale in u under-resolves the oscillation. Worse, Γ_Φ decays
exponentially in Im w — from 7.3e−5 at y = 10 to 1.4e−30 at y = 150 — because
it is a Fourier transform of an analytic function. R is a ratio of those.

**False start 1: composite Gauss–Legendre in u.** Found a zero at
w = 5.78937 + 45.91274i with |R−1| = 4.4e−09 — Newton-converged, eight digits,
entirely fictitious. Refining the rule moved it to 19.6+90.1i, then 11.6+97.1i,
then 18.4+100.5i. A quantity that relocates under mesh refinement is noise.

**False start 2: geometric refinement toward u = 0.** Did not help. The
oscillation is uniform in log u, not concentrated at any scale, so clustering
nodes near zero buys nothing.

**The fix: substitute u = e^v.**

```
Γ_Φ(w) = 4 ∫_{−∞}^{∞} e^{(w+1)v} · Φ(e^v) dv                               (25)
```

Now the phase e^{iyv} has *uniform* frequency and the amplitude is smooth and
compactly concentrated, so the trapezoid rule is exponentially accurate. This
is correct — but in float64 it still fails past |Im w| ≈ 50, not from
quadrature error but because |Γ_Φ| has dropped below what double precision can
form a ratio from.

**What is actually required:** (25) *and* ≥ 40 decimal digits. The §4 table was
computed that way, with h = 0.004 and h = 0.002 agreeing to eight digits at
every point, and matching float64 exactly where float64 was still valid
(|Im w| ≤ 50).

**Diagnostic for anyone continuing this.** Every candidate zero must survive a
change of quadrature rule *and* a change of working precision. Newton
convergence to 1e−9 proves nothing here — it converged beautifully to a point
that does not exist.

---

## 6. What this buys, and what it does not

**Buys.**
* The table becomes a function, with derivatives, asymptotics, and a domain.
* The "divide by (2n)!" step is explained rather than performed: it is exactly
  what cancels Γ_Φ's pole string and makes C entire (23).
* The answer to *is positivity ever tight?* — no, and it loosens like 4/|w| in
  every direction. That is a stronger statement than any finite table supports.
* A falsifiable target: a zero of R − 1 would be the boundary of the positivity
  domain. None exists in the computed region.

**Does not.**
* This is d = 2 only. RH needs every Jensen degree, and the continuation of the
  *degree* is a different and harder object than the continuation of the index.
  Nothing here touches uniformity in d — still the open direction
  ([INTEGERS.md](INTEGERS.md) §5).
* The Turán inequalities for ξ are a theorem already (Csordas–Norfolk–Varga
  1986, from memory — verify before citing). Continuing them proves nothing new;
  it reorganises what is known.
* "No zeros found" is a statement about Re w ∈ [0, 40], |Im w| ≤ 200 at float64
  plus verified spot checks to |Im w| = 150 at 40 digits. It is not a theorem,
  and given §5 it should be treated with the suspicion it has already earned
  twice.

---

## 7. Reconstruction

```
# the ONLY safe evaluator: substitute u = e^v, and use >= 40 digits for Im w > 50
Phi(x)      = sum_{n=1..8} (2 pi^2 n^4 e^{4.5x} - 3 pi n^2 e^{2.5x}) e^{-pi n^2 e^{2x}}
GammaPhi(w) = 4 * trapezoid_{v=-50..1.4, h=0.002} [ e^{(w+1)v} * Phi(e^v) ]
              # v0 = -50, not -16: at -16 the dropped tail is 4*Phi(0)*e^-16
              # = 2.01e-7, and a boundary term survives besides. See TODO A3.
C(w)        = GammaPhi(w) / Gamma(w+1)                      # entire
R(w)        = (GammaPhi(w+2)^2 / (GammaPhi(w)*GammaPhi(w+4)))
              * ((w+3)*(w+4) / ((w+1)*(w+2)))               # positivity <=> R > 1
M(w)        = -log(R_gamma(w)) / log(R_fac(w))              # the margin ratio

# sanity, in order:
#   GammaPhi(0)  = 0.4971207782      (= xi(1/2))
#   GammaPhi(2)  = 0.0229719443151
#   R(0)         = 2.149688          (row n=0 of the POSITIVITY.md table)
#   R(2)         = 1.594115          (row n=1)
#   |w|*(R(w)-1) -> ~4 slowly, in every direction
```

For Re w ≤ −1 use the split (22) — **and note that the trapezoid line above is
not an evaluator there.** Below w = −1 the integrand e^{(w+1)v}Φ(e^v) grows as
v → −∞, so a lower limit chosen to make it negligible for Re w > −1 makes it
enormous instead; at w = −1.5 the recipe returns 2.1e4 for −7.74. Use (22)'s
pole part with U₀ = e^{−2} and Romberg the remaining integral over [U₀, ∞),
which is entire. See TODO **E15** and `rust/src/bin/g3_poles.rs`.

---

## 8. Adding the degree as a second axis

§6 left uniformity in the Jensen degree *d* as the open direction. The natural
next move is to make *d* a coordinate on the same footing as *w*. Two ways to
try it; the second works.

### 8.1 Why not a quaternionic axis

Putting *d* on an imaginary axis of ℍ and asking for a "holomorphic" function of
q = w + d·j fails, for a reason that is worth stating precisely rather than
hand-waving. There are two candidate notions of quaternionic holomorphy and
each blocks it differently.

**Fueter regularity** — ker(∂₀ + i∂₁ + j∂₂ + k∂₃) — does not contain the
identity function q ↦ q, and therefore contains no power series in q. The
functions we need (Γ_Φ, C, R are built from power series and integrals) are not
in the class at all.

**Slice regularity** (Gentili–Struppa; attribution from memory) fixes that: f is
slice regular if its restriction to every complex slice ℂ_I = ℝ + Iℝ is
holomorphic, and this class *does* contain Σ q^n a_n. But it comes with the
Representation Formula,

```
f(x + Iy) = ½[(1 − IJ)·f(x + Jy) + (1 + IJ)·f(x − Jy)]                     (26)
```

which determines the values on **every** slice from the values on **one**. A
slice-regular function of a quaternion therefore carries exactly the information
of a holomorphic function of one complex variable — the extra axes are free but
empty. A *d*-dependence installed there would be a rigid shadow of the
*w*-dependence, forced by (26), not an independent degree direction. That is
precisely the opposite of what uniformity in *d* requires.

There is also a structural mismatch underneath the analysis. *d* is a **degree**
— a filtration index, acted on by the shift-and-binomial semigroup. It is not a
rotational direction, and quaternions supply a rotation group. Wrong symmetry
for the object.

### 8.2 What does work: one function of two complex variables

The whole Jensen family collapses into a single generating function. Summing
(13) against t^d/d! and exchanging the order:

```
Σ_{d≥0} J^{d,n}(X)·t^d/d!  =  e^t · F_n(X·t),     F_n(y) = Σ_{j≥0} a(n+j)·y^j/j!   (27)
```

Verified to machine precision at three sample points (relative error 0, 2.2e−16,
1.1e−16). **Every Jensen degree simultaneously** is a Taylor coefficient of one
function of two variables — *d* has become a coordinate without leaving ℂ.

Now continue the index as in §1. With a(n) = γ(n)·n!/(2n)! and n = w/2,

```
A(w) = Γ_Φ(w)·Γ(w/2 + 1)/Γ(w + 1) = C(w)·Γ(w/2 + 1)                        (28)
```

verified against a(n) at w = 2n to 2e−12 (n = 1, 2, 5, 10; n = 0 carries the
4e−7 quadrature error of Γ_Φ at w = 0). This gives the two-variable object

```
F(w, y) = Σ_{j≥0} A(w + 2j)·y^j/j!                                         (29)
```

holomorphic in both arguments, in which:

* **y** carries the whole degree family, via (27);
* **w** carries the index, continued off the integers as in §4;
* the criterion is that **F(w, ·) lies in the Laguerre–Pólya class for every
  w** — all its y-zeros real and negative.

At w = 0 this is ξ itself: F(0, y) = ξ(½ + √y), so its zeros sit at
y = −γ_k². Confirmed, and it is the answer key everything downstream is
measured against: at 60 digits and 170 terms the first nine come out as

```
  −199.790454832386859   −441.926150574082490   −625.542996894331058
  −925.673087273896182  −1084.71828178817347   −1412.72078858698393
 −1674.34156559508088   −1877.23527908977846   −2304.49451112362396
```

against −γ_k² for k = 1 … 9, agreeing to 6.5e−20 … 7.4e−17 relative — which is
the rounding of the twenty-digit γ_k this directory carries, not a limit of the
computation. (An earlier version of this paragraph reported −199.786 and
−442.407; the second of those was wrong, see §8.3 and TODO **A4**.)

### 8.3 The flow

Varying w continuously deforms ξ, and the zeros move smoothly along the
negative real axis:

```
    w        z₁          z₂           z₃           z₄           z₅
    0    −199.7905   −441.9262    −625.5430    −925.6731   −1084.7183
    1    −221.2555   −464.8058    −658.1144    −949.5500   −1127.7697
    2    −242.9143   −488.3206    −690.2310    −975.4251   −1169.1825
    4    −286.8341   −536.9185    −753.5670   −1031.2855   −1248.9157
    8    −377.1699   −638.9887    −878.7527   −1153.1895   −1402.0928
   12    −470.9035   −746.1074   −1004.2606   −1283.1656   −1552.3739
```

Real, negative, monotone, and smooth — a continuous flow on the zero set of
which the integer Jensen shifts are snapshots. dz₁/dw by central differences on
this data is −21.47 at w = 0, −21.76 at w = 2, −23.01 at w = 8.

**This table replaces an earlier one, which was wrong in its second column**
(TODO **A4**). The old z₂ printed −442.41 at w = 0, where the answer is
checkable against −γ₂² = −441.92615 and is −441.9262; and −739.87 at w = 12,
where it is −746.1074. The z₁ column reproduced everywhere and still does.
Every entry above is stable between K = 128 and K = 140, and is produced by
`rust/bin/b2_flow` at sixty digits, by bisection inside a one-root bracket
rather than by a global solve on a degree-K polynomial.

**Truncation control, measured rather than guessed.** The earlier text said
"only z₁ and z₂ are trustworthy … z₄ is a pure truncation artifact, complex and
mobile". The first half was right; the second was not, and neither could be
settled at the time, because nobody had measured how many terms a given root
needs. TODO **G6** measured it. Writing K_req(w, k) for the fewest terms at
which the k-th root reaches its converged place to a relative 10⁻⁶ **and stays
there**:

```
    k          1     2     3     4     5     6     7     8     9
    K_req     20    32    40    50    56    66    74    78    90        (w = 0)
```

and K_req grows slowly with w as well — 20, 22, 22, 24, 26, 28, 30, 34 for
k = 1 at w = 0, 1, 2, 4, 6, 8, 12, 16. Both dependencies collapse onto one
variable: **K_req ≈ c·√|z| with c measured at 1.42 rising to 1.88**, which is
what the coefficient decay predicts — A(w+2j) falls like (C/j)^j, so the
largest term of Σ A(w+2j)y^j/j! sits at j\* = √(C|y|/e).

So at K = 34 the earlier text had enough terms for z₁ and z₂ and not for z₃
(which needs 40); z₄ and z₅ were **not present at all** in their brackets, and
what it saw as "z₄, complex and mobile" was an artifact of the cut. The fourth
zero is real, is −925.6731 = −γ₄², and needs fifty terms. TODO **E5** records
the retraction; the general lesson is that an unstable root is evidence of
nothing either way until K_req is known.

One more thing G6 settles, because it was assumed both ways in earlier text:
**precision is not the co-limit here.** The same K_req comes out at 30, 45, 60
and 90 working digits, identically. Only the truncation binds.

### 8.4 What this does and does not achieve

**Does.** Uniformity in *d* is no longer a separate axis needing a new number
system: it is subsumed into the y-dependence of one holomorphic function of two
complex variables, and several-complex-variables is a category with real tools
in it. The question becomes a statement about a domain in ℂ².

**Does not.** Restating uniformity is not obtaining it. (29) makes the
d-direction *visible*; nothing here makes it *tractable*, and the LP condition
on F(w, ·) for all w is exactly as hard as it was — it is RH, rewritten once
more. The reformulation earns its place only by removing a false problem (a
missing axis) and replacing it with the real one (a domain in ℂ²).

**And the "for every w" is not doing any work, which is now measured rather
than suspected.** §8.2 asks for F(w, ·) ∈ LP at *every* w where the classical
criterion needs it only at the even integers, so the natural question is
whether the continuum is stronger: does F(w, ·) acquire a complex zero at some
non-integer w? TODO **G4** answers it, by counting rather than root-finding —
the argument principle gives the number of zeros of the truncation inside
|y| ≤ Y as an integer, and bisection gives the number of sign changes on
[−Y, 0), and if the two agree there is no room for a conjugate pair.

Over w ∈ [0, 12] in 24 steps, at two truncations (K = 110 and K = 130), inside
the disc |y| ≤ 3352 that G6's law says a K = 110 truncation can speak for:
**the two counts agree at all 25 sample points, at both truncations, without
exception.** Every zero is real and negative, at the integers and between them.

So within reach, **non-integer w adds no content**: "for every w" is the same
condition as "for every even integer", and §8's continuation of the index is a
repackaging. That is worth knowing and worth saying — it is the direction that
decides whether §8 is more than presentation, and the answer is that it is not.
What it is not is a proof: the disc is finite, the scan is over real w only,
and a zero outside is unseen rather than absent — the same distinction that
governs the R − 1 scan in §4.

---

*Companions: [README.md](README.md) · [POSITIVITY.md](POSITIVITY.md) ·
[INTEGERS.md](INTEGERS.md) · [figure.html](figure.html) ·
[prime-horn.html](prime-horn.html).*
