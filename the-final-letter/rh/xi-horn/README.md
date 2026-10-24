# The Ξ horn — a two-sided construction, specified

A build spec for the figure the arc does not have: a geometric construction of
the **completed** zeta function, in which the functional equation is present as
a mirror symmetry rather than asserted in prose, and in which closure is
decidable from a bounded picture.

This is the object proposed at the end of the rh3 conversation as the successor
to [the helix](../rh3/README.md). It is written to the same standard: every
curve in closed form, every number verified, and an explicit statement of what
it does *not* achieve.

Numbering is left open — call it rh38 if it earns the slot.

**Built: [figure.html](figure.html)** — the live construction. Nested integer
shells on a 30-decade log-radial horn, the two conjugate threads with their
annihilating endpoints, a tilt slider sweeping the critical strip, and the
positivity margin as a readout. Self-contained, float64, no external
dependency.

**Built: [prime-horn.html](prime-horn.html)** — the companion figure, on the
primes. The same smearing recipe with Λ(n)·n^{−1/2} in place of n^{−1/2}: the
PNT main term cancels itself, and what is left rings at γ₁ with the amplitude
ledger |C(½+iγ_k)|. Live Λ-sieve, ten closures, the exact near-field envelope,
and [horn-helix-revisited.md](horn-helix-revisited.md) §3.3 recomputed as a
readout. Self-contained, float64, no external dependency.

**See also [POSITIVITY.md](POSITIVITY.md)** — the same horn with the phase
modded out. There the criterion stops being "a curve closes" and becomes
"the silhouette's moments are log-concave", which removes *t* entirely and
tames the needle of §3 honestly rather than by root-scaling the radius.

---

## 0. Standing disclaimer, up front

**Nothing here is new mathematics.** The object is Riemann's Ξ as the Fourier
transform of Φ, which is 1859 material; the idea of attacking RH through the
positivity or the log-concavity of Φ is Pólya's, and the modern descendants are
de Branges spaces, Weil positivity, and the Connes program. The arc already
lives on this side analytically — rh10/rh11 built Weil positivity as an
instrument, rh19–rh27a certified floors in interval arithmetic, rh28/rh29
report the floor decaying worse than a power law.

What is missing is **a picture**. Twenty-odd documents draw the numeral; none
draws the object the machinery actually operates on. That gap is what this
spec fills, and filling it proves nothing.

Compared with the helix, this construction trades away the visible arithmetic
for decidability. See §8 before building.

---

## 1. The weight

```
Φ(u) = Σ_{n≥1} ( 2π²n⁴·e^{9u/2} − 3πn²·e^{5u/2} ) · e^{−πn²·e^{2u}}          (1)
```

Three properties, all verified numerically below:

* **Even.** Φ(u) = Φ(−u) exactly. This *is* the theta functional equation
  θ(1/x) = √x·θ(x), and hence the functional equation of ζ. It is not imposed
  on the construction; it is a property of the weight.
* **Positive.** Φ(u) > 0 on ℝ.
* **Double-exponentially small.** Φ(u) ~ 2π²e^{9u/2}e^{−πe^{2u}} as u → +∞.

```
   u      Φ(u)                Φ(−u) − Φ(u)
  0.0     0.4466969005        0
  0.2     0.3042748527        0
  0.4     0.08624007927       0
  0.6     0.007423456244      0
  0.8     0.0001140161852     0
  1.0     1.377813941e-07     0
  1.2     3.815292836e-12     0
  1.4     3.818576539e-19     0
  1.6     8.752056431e-30     0
```

**The entire object lives in |u| ≤ 1.5.** That is the point of the whole
exercise; see §6.

Also useful: `∫₀^∞ Φ(u) du = 0.1242801945`.

---

## 2. Normalisation

With ξ(s) = ½·s(s−1)·π^{−s/2}·Γ(s/2)·ζ(s) and Φ as in (1):

```
ξ(½ + it) = 2 ∫_{−∞}^{∞} Φ(u)·e^{itu} du = 4 ∫₀^{∞} Φ(u)·cos(ut) du        (2)
```

The imaginary part vanishes identically by evenness, so the left side is real
for real *t*. Verified against an independent ξ at *t* = 0, 5, 17 to ten
digits.

The constant 2 is convention-dependent (sources differ on whether the factor
sits in Φ or in ξ). The geometry does not care; fix one convention and state
it, as here.

Write **Ξ(t) = ξ(½ + it)** throughout.

---

## 3. The horn

The construction is a surface of revolution in (x, y, u):

```
radius  ρ(u) = Φ(u)          depth  u ∈ ℝ          angle  θ(u) = t·u         (3)
```

Compare rh3's cone `r = x^{−σ}`, depth `x − 1`, `x ∈ [1, ∞)`. Four differences,
and all four are the argument for building this:

| | rh3 cone | Ξ horn |
|---|---|---|
| extent | infinite depth | effectively \|u\| ≤ 1.5 |
| sheets | one | **two**, mirror-congruent |
| throat | none — the wide end is a boundary | u = 0, an interior maximum |
| discreteness | rings at integer levels | continuous — genuine partial integrals |

**The throat** at u = 0 is x = 1 under u = log x: the self-dual point of the
multiplicative group. The mirror plane through it is the functional equation.

**Drawing it.** Φ falls six orders of magnitude over one unit of depth, so a
horn drawn with radius Φ is a needle. Use a root:

```
R(u) = ( Φ(u) / Φ(0) )^{1/k}                                                (4)
```

which is monotone in Φ, so it distorts no ordering and no symmetry.

```
  k      u=0     u=0.4    u=0.8    u=1.2     u=1.6
   1     1.0     0.1931   0.000255 8.54e-12  1.96e-29
   4     1.0     0.6629   0.1264   0.00171   6.65e-08
   8     1.0     0.8142   0.3555   0.04135   0.000258
  12     1.0     0.8719   0.5019   0.1196    0.004052
```

**Recommended: k = 8 over u ∈ [−1.5, 1.5]** — a fat throat pinching to nothing
at both ends. State the exponent in the caption; a rendered radius that is not
the mathematical radius must be declared.

**Winding.** At *t* = γ₁ the phase sweeps `t·(u_max − u_min)/2π` = **7.20
turns** across u ∈ [−1.6, 1.6]. Comparable to the helix's ledger, and bounded.

---

## 4. The two threads, and what a zero looks like

Draw the **one-sided partial integral** on each sheet:

```
S₊(U) = ∫₀^U Φ(u)·e^{itu} du            the +u thread
S₋(U) = ∫₀^U Φ(u)·e^{−itu} du = conj(S₊(U))     the −u thread                (5)
```

By evenness the −u sheet's thread is the **complex conjugate** of the +u
sheet's, pointwise. That is the dual, drawn — not asserted. Both threads start
at the throat, spiral outward with speed |Φ(u)|, and terminate at conjugate
endpoints. Total arc length of each is `∫₀^∞Φ = 0.12428`, independent of *t*.

The value is the sum of the pair:

```
Ξ(t) = 2·( S₊(∞) + S₋(∞) ) = 4·Re S₊(∞)                                     (6)
```

**So the closure criterion is not "the chain returns to the origin."** It is:

> A zero of Ξ is where the two dual endpoints are **purely imaginary** — equal
> and opposite, annihilating on addition.

Write S₊(∞) = A + iB. Then Ξ = 4A, and:

```
  t                      A               B            |S₊|
  γ₁ = 14.134725     2.73e-19      0.036322412     0.0363224
  γ₂ = 21.022040     3.27e-23      0.022253827     0.0222538
  γ₃ = 25.010858     2.41e-22      0.018440780     0.0184408
  γ₄ = 30.424876    -1.27e-24      0.014995615     0.0149956
  γ₅ = 32.935062    -3.16e-25      0.013808206     0.0138082
  t = 20            -9.164e-06     0.023510939     0.0235109
  t = 23             1.405e-06     0.020179170     0.0201792
```

At every zero A collapses to numerical noise while B stays O(10⁻²): the
endpoints sit at ±0.0363i and cancel. Off a zero there is a residual real part.
**This is the rh4 slogan made operational** — "the critical line is where a
helix and its dual are congruent rather than merely similar" — with the
congruence visible as conjugacy and the closure as annihilation.

The figure should draw: two spiral threads, their endpoints, the segment
joining them, and the midpoint of that segment on the real axis. The midpoint
*is* Ξ(t)/4. A zero is the segment lying along the imaginary axis with its
midpoint on 0.

---

## 5. The tilt — where RH enters

Let *t* be complex, `t = t_r + i·t_i`. The phase becomes
`e^{i t_r u}·e^{−t_i u}`, which multiplies the +u sheet by `e^{−t_i u}` and the
−u sheet by `e^{+t_i u}`: **the tilt breaks the mirror symmetry.** The two
threads stop being conjugates, Ξ goes complex, and the annihilation of §4 has
no reason to occur.

The tilt parameter is bounded and meaningful:

```
s = ½ + i·t,     t = t_r + i·t_i     ⟹     σ = Re s = ½ − t_i
|t_i| < ½  ⟺  0 < σ < 1  (the critical strip)
t_i = 0    ⟺  σ = ½      (the critical line, mirror-symmetric)
```

So **one slider from −0.5 to 0.5 sweeps the strip**, with the symmetric
configuration at dead centre. RH, in this figure:

> The horn only closes when it is untilted.

Behaviour near γ₁ (a simple zero):

```
  t_i        |Ξ(γ₁ + i·t_i)|      |Ξ|/t_i
  0.001      6.9136e-07           6.9136e-04
  0.01       6.9136e-06           6.9136e-04
  0.05       3.4571e-05           6.9142e-04
  0.10       6.9159e-05
  0.25       1.7321e-04
  0.40       2.7804e-04
```

The slope is `|Ξ′(γ₁)| = 6.9136e-04`, matching the derivative along the real
direction exactly — Cauchy–Riemann, since Ξ is entire. Tilting moves you off
the zero linearly, at a rate the figure can print.

Honest note on what this shows: it demonstrates the *local* behaviour at one
zero. It is a picture of the claim, not evidence for it. Every zero anyone has
ever computed does this.

---

## 6. Why bother — the truncation argument

This is the one place the new object is strictly, quantitatively better than
the helix, and the reason to build it.

The helix's partial sums satisfy `|P_N − η(s)| → N^{−σ}/2` exactly, independent
of *t* — half the radius of the last drawn gear. To decide closure to 1e−16 at
σ = ½ requires

```
N ≳ 2.5 × 10^31 gears.
```

No finite drawing decides anything; the miss and the residual are always the
same size.

The Ξ horn's integrand dies double-exponentially. Truncating at |u| = 1.5 costs

```
∫_{1.5}^{∞} Φ ≈ 1e−19 ,
```

so the object is **bounded, and closure is decidable from the whole picture.**
The table in §4 was computed on u ∈ [0, 1.6].

That is the entire trade: the helix shows you the integers and cannot decide;
the horn decides and shows you no integers.

---

## 7. Reconstruction

```
# --- the weight -------------------------------------------------------
Phi(u) = sum_{n=1..N}  (2*pi^2*n^4*exp(4.5*u) - 3*pi*n^2*exp(2.5*u))
                       * exp(-pi*n^2*exp(2*u))
# CORRECTED (see INTEGERS.md §3): call this ONLY as Phi(abs(u)). On u >= 0 the
# shells never cancel and 6 terms in float64 give ~1e-15 relative accuracy down
# to Phi ~ 1e-30. The catastrophic cancellation is entirely on u < 0 — where
# evenness means you never need to evaluate. No arbitrary precision required.

# --- the horn ---------------------------------------------------------
UMAX = 1.5 ;  KROOT = 8
for u in linspace(-UMAX, UMAX, 400):
    R = (Phi(u)/Phi(0))^(1/KROOT)          # drawn radius, eq. (4) — declare it
    ring of radius R at depth u            # 72 segments, as rh3

# --- the two threads (partial integrals, cumulative trapezoid) --------
S = 0
for u in 0 .. UMAX step h:                 # h = 0.002 is plenty
    S += Phi(u) * exp(i*t*u) * h
    plus_thread.append(  ( Re S, Im S, +u ) )
    minus_thread.append( ( Re S, -Im S, -u ) )      # the conjugate sheet
# endpoints
Ep = S ;  Em = conj(S) ;  Xi = 4*Re(S)

# --- the tilt ---------------------------------------------------------
# t complex: t = t_r + i*t_i,  slider t_i in [-0.5, 0.5]
# the two sheets are then weighted Phi(u)*exp(-t_i*u) and Phi(u)*exp(+t_i*u);
# they are no longer conjugate and Ep + Em is no longer real.
```

Draw, at minimum: the two sheets, the two threads, the two endpoints, the
chord between them, its midpoint, and the real axis. Print Ξ(t), t_i, and the
truncation error.

Controls worth having: `t_r` (with snaps to γ₁…γ₅), `t_i` (the tilt, −0.5…0.5),
`U` (how far out the threads have been integrated — the analogue of rh3's
depth *N*), and a mirror toggle that hides the −u sheet.

---

## 8. What this does not do

Four things, stated plainly, because the figure is seductive and the seduction
is the same one §11 of rh3 warned about.

**1. The integers are gone.** Φ's defining sum over *n* is a theta series — the
integers are inside the weight, already summed, before any drawing begins. The
horn is smooth *because* the arithmetic has been performed. rh3 §11's warning
generalises: whatever makes the picture smooth has hidden what the zeros are
made of, not removed it. You get a decidable picture of an object whose zeros
nothing in the picture explains.

**2. Positivity is still the wall.** The reason to want this object is that it
has a Hilbert space — Plancherel gives a genuine inner product, which is
precisely what rh5 says the ℤ/12 clock has nowhere to put. But the pairing that
lives there is the Weil pairing, RH ⟺ its positivity, and that is exactly where
rh19–rh27a's certified floors are, and exactly where rh28/rh29 report the floor
decaying worse than a power law. Moving the picture does not move the wall.

**3. It is one function.** The horn is built from a specific Φ. Nothing in the
construction distinguishes ζ from any other function with an even weight and a
functional equation — no Euler product appears anywhere. The tilt argument
would look identical for a counterexample if one existed.

**4. Pólya got here first.** The natural next move — "Φ is positive and even,
so if it were also log-concave…" — is a century old and does not close. Anyone
reaching for it should read what has already been ruled out before building on
it.

---

## 9. Verified numbers

Everything above, in one table. Computed at 40–50 decimal digits with mpmath;
reproduce these and the reconstruction is faithful.

| quantity | value |
|---|---|
| Φ(0) | 0.4466969005 |
| Φ(1) | 1.377813941e−07 |
| Φ(1.5) | ~6.5e−24 |
| Φ(u) − Φ(−u) | 0 at u = 0, 0.2 … 1.6 |
| ∫₀^∞ Φ | 0.1242801945 |
| ξ(½) via (2) | 0.4971207782 |
| Ξ(5) | 0.2755499973 |
| Ξ(17) | −0.0005433785679 |
| Ξ(γ₁) | 1.09e−18 (zero) |
| Ξ(γ₂) | 1.31e−22 (zero) |
| Ξ(γ₃) | 9.66e−22 (zero) |
| S₊(∞) at γ₁ | 2.73e−19 + 0.036322412 i |
| S₊(∞) at t = 20 | −9.164e−06 + 0.023510939 i |
| Ξ′(γ₁) | −6.9136e−04 |
| tilt slope at γ₁ | 6.9136e−04 (matches, by Cauchy–Riemann) |
| arc length of each thread | 0.1242801945 |
| winding at γ₁ over \|u\| ≤ 1.6 | 7.19876 turns |
| truncation at \|u\| = 1.5 | ~1e−19 |

---

## 10. Dictionary

The directory's terms and their analytic counterparts, in the series
convention — the vocabulary of the whole directory, not this file's alone:
this README, [POSITIVITY.md](POSITIVITY.md), [INTEGERS.md](INTEGERS.md),
[CONTINUATION.md](CONTINUATION.md), [horn-helix.md](horn-helix.md),
[horn-helix-revisited.md](horn-helix-revisited.md),
[horn-helix-adelic.md](horn-helix-adelic.md),
[positivity-generator.md](positivity-generator.md), and the
certification layer in
[rust/](rust/). Folded verbatim into [../dictionary.html](../dictionary.html)
per the repo rule in [../CLAUDE.md](../CLAUDE.md); keep the two in sync.

| term | meaning |
|---|---|
| the horn | Riemann's Ξ as the Fourier transform of Φ — 1859 material — drawn as a surface of revolution: radius Φ(u), depth u ∈ ℝ, angle t·u |
| the weight Φ(u) | Σ_{n≥1} (2π²n⁴·e^{9u/2} − 3πn²·e^{5u/2})·e^{−πn²·e^{2u}} — a theta derivative, twice [O'S]'s ω-based Φ; even (= the functional equation), positive, double-exponentially small |
| the throat | u = 0 — x = 1 under u = log x, the self-dual point of the multiplicative group; the mirror plane through it is the functional equation |
| effectively \|u\| ≤ 1.5 | truncation there costs ~1e−19, so closure is decidable from a bounded picture; the helix needs N ≳ 2.5×10³¹ gears for the same decision at 1e−16 |
| the two threads S₊, S₋ | the one-sided partial integrals ∫₀^U Φ(u)·e^{±itu} du; conjugate pointwise by evenness — rh4's dual, drawn rather than asserted |
| annihilating endpoints | a zero of Ξ: the dual endpoints purely imaginary, equal and opposite, so Ξ(t) = 4·Re S₊(∞) = 0 |
| the tilt t_i | Im t, i.e. σ = ½ − t_i: one slider over \|t_i\| < ½ sweeps the critical strip, and t_i = 0 is the line. RH in this figure: the horn only closes when it is untilted |
| the drawn radius (Φ(u)/Φ(0))^{1/k} | display only (k = 8) — monotone in Φ, so it distorts no ordering and no symmetry; a rendered radius that is not the mathematical radius, declared in the caption |
| the integers are gone | Φ's defining sum over n is a theta series — the arithmetic is performed inside the weight before any drawing begins; the horn is smooth because of it, and the picture explains nothing about what the zeros are made of |
| the silhouette's moments γ(n) | γ(n) = 4∫₀^∞ u^{2n}·Φ(u) du = ξ^(2n)(½) — the even Taylor data of Ξ at the symmetry point; log-convex by Cauchy–Schwarz for any positive weight, necessarily |
| a(n) = γ(n)·n!/(2n)! | the Laguerre–Pólya sequence of Ξ(t) = F(−t²), F(x) = Σ a(n)·x^n/n!; its log-concavity is the Turán inequality, a theorem since Csordas–Norfolk–Varga 1986 |
| the magnification knob | the Jensen/Turán index n: the probe u^{2n} peaks further out along the horn as n rises, where Φ is smaller — positivity at n reads a thinner slice of the mouth |
| Jensen polynomial J^{d,n}(X) | Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j; RH ⟺ every J^{d,n} hyperbolic (all roots real) — certified here for d ≤ 6, n ≤ 30 by interval LDLᵀ, inside Chasse 2013's d ≤ 2×10¹⁷ |
| P^{d,n}(X) | Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X) — [O'S]'s Hermite family: the same equivalence to RH at a 175× to 6.0e9× looser certification tolerance, flat in n where J's tightens |
| max width | the largest relative enclosure width on the coefficients at which an interval LDLᵀ still decides hyperbolicity — the scale-free cost of degree, and exactly how good a bound on γ(n) a certificate needs |
| Γ_Φ(w) = 4∫₀^∞ u^w·Φ(u) du | the horn's Mellin transform: γ(n) = Γ_Φ(2n), continued by Γ_Φ(w) = 4·Σ_{k≥0} c_{2k}/(w+2k+1) + entire — simple poles on the odd negative integers only, because Φ is even |
| R(w) | the Turán ratio with the index made continuous: Γ_Φ(w+2)²/(Γ_Φ(w)·Γ_Φ(w+4)) · (w+3)(w+4)/((w+1)(w+2)); positivity at index n is exactly R(2n) > 1 |
| F(w, y) = Σ_{j≥0} A(w+2j)·y^j/j! | the Jensen family with the shift made continuous — A(w) = Γ_Φ(w)·Γ(w/2+1)/Γ(w+1); the criterion F(w, ·) ∈ Laguerre–Pólya for every real w is RH rewritten once, and at w = 0 the zeros are exactly −γ_k² |
| K_req(w, k) | the truncation order at which the k-th zero of F(w, ·) is resolved; grows in both w and k, and until it is measured an unstable root is evidence of nothing either way |
| the log-depth axis | u = log x — the coordinate the horn's depth and the helix's phase share; rh3's cone r = x^{−σ} on it is radius e^{−σu}, phase −t·u, i.e. the horn's law with Φ replaced by an exponential |
| shell n is gear n | 2∫φ_n(u)·e^{(s−½)u}du = ½s(s−1)π^{−s/2}Γ(s/2)·n^{−s}, verified to 3e−29 — the n-th shell of the horn is the n-th gear of the helix wearing the completion factor; exact term by term, and non-summable at σ = ½ |
| non-summable correspondence | the shell transforms sum like √N/\|1−s\| (0.012326 at N = 10⁴) while ξ(½+iγ₁) = 1.09e−18: the horn's convergence comes from Poisson summation on the whole weight, never from the shells |
| σ moves from the radius to the tilt | in the helix σ is a taper and ½ is unmarked; completion puts σ in the mirror (σ = ½ − t_i) where ½ is the fixed point — RH stops being a claim about which taper value happens to close and becomes a claim that the object closes only when it is symmetric |
| shell 1 is the place at infinity | the n = 1 shell transforms to π^{−s/2}Γ(s/2)·½s(s−1) alone — the archimedean Euler factor, zero-free in the strip; \|shell 1\| = 0.0017433 at γ₁ where the total is 1e−18, so the zero is interference between dilates, which is rh3 §6's trap avoided rather than entered |
| the prime helix | rh3's figure re-weighted r_n = Λ(n)·n^{−σ} on identical levels: it draws −ζ′/ζ = ΣΛ(n)n^{−s}, composites collapsed to the axis, primes and prime powers remaining |
| closure and pole | at a zero the horn annihilates (Ξ = 4·Re S₊(∞) = 0) and the prime helix has a simple pole of residue −1 (\|−ζ′/ζ\| = 1/ε + O(1), verified to ε = 1e−5) — the two figures are inverse there and can never be compared pointwise |
| two columns of one ledger | the only thing joining the horn and the prime helix is the Riemann–Weil formula: zeros side 0.688847411525 against pole + archimedean + primes 0.688847280344, difference 1.3e−7 |
| the lift, linearized | on u = log x the helix's ledger angle is p·(e^u−1) − t·u: the horn's phase t·u is the helix's torsion term exactly, and the exponential carry is the alternation device the horn replaces with completion |
| the translation identity | φ_n(u) = n^{−1/2}·φ₁(u + log n), exactly — the horn is the σ = ½ helix's gear measure with every point-gear replaced by one copy of the archimedean bump; the mirror side is the copies overlapping and cancelling (±0.476 of mass to 6.5e−24 at u = −1.5) |
| the two ledgers | the prime helix is the derivative of the Euler product; the horn's is the closure ledger ξ′/ξ(s) = Σ_γ 2(s−½)/((s−½)²+γ²), absolutely convergent, verified from 150 zeros to 4e−8; −ζ′/ζ = pole terms + archimedean comb − closure ledger is the bridge |
| the horn's gears are its closures | Hadamard: Ξ(t) = Ξ(0)·Π(1 − t²/γ_k²) — one factor per closure, Ξ(5) rebuilt from 150 factors to 2.2e−6 with the tail paid exactly by λ₁ |
| λ₁ = ξ′/ξ(1) | rh10 §5's constant as the closure ledger read at the pole's old address; also pays the Hadamard and ledger tails, and 2λ₁ = 0.0461914 is the Báez-Duarte constant |
| the prime horn Ψ(u) | Σ Λ(n)n^{−1/2}·φ₁(u + log n) — the prime helix's gears smeared by the horn's own bump, the same recipe that builds Φ from the integers; empty on u > 0, ringing on u < 0 |
| the silence of the main term | ∫φ₁·e^{w/2} = 0 exactly, because C(s) carries the factor (s−1) that cancels ζ's pole — the completion that makes ξ entire is verbatim the balance that stops the prime horn's PNT flare |
| the primes ring the first zero | Ψ(−v) = −Σ Re[C(ρ_k)e^{iγ_k v}] + O(v·e^{−5v/2}): amplitudes \|C(½+iγ_k)\| = shell 1's transform at each closure, 99.1 % in the γ₁ mode — the sieve reproduces the ten-zero ring to 1.4e−8 by v = 9 |
| RH ⟺ the prime horn never flares | sup\|Ψ\| < ∞ ⟺ RH (classical smoothed-ψ equivalence in this dress): bounded at ≈ 0.35 if true, an off-line zero forces e^{(β−½)v} growth; the quantifier over test functions becomes a quantifier over v — moved, not removed |
| where every road ends | the four terminus types: one theorem over a base ℤ has not got (Weil/Deligne, and the adelic route ending at archimedean positivity); five strengthenings killed by counterexample; nine quantified roads whose numbers are not close (zero-free shape unimproved since 1958, 5/12 of the zeros, μ(½) = 13/84, height 3×10¹², 0 ≤ Λ ≤ 0.2, certificate reach n^{1.2} against n ≈ 1.8×10¹⁰ needed); and the unquantified ones, which end at a missing object rather than a number |
| the two last steps | every road's final step is either a positivity quantified over a family with no known finite generating structure, or a uniformity in a parameter the method loses to (Jensen's d, the mollifier's θ, a growth bound's ε, a certificate's depth n) — §4.1's rows, the adelic programme and this arc's certificates are all the first |
| RH has no margin | every convenient strengthening anyone proposed is false — Mertens (Odlyzko–te Riele), Pólya (Haselgrove), Turán's partial sums, de Branges' positivity, and functional-equation-only arguments (Davenport–Heilbronn) — with Λ ≥ 0 and Selberg's unbounded S(T) confirming it from both sides: a road that would prove more than RH ends in a counterexample |
| the three grades of generation | spanning (G1: dense span, positivity transports by continuity), conic (G2: every test function a nonnegative combination), finite (G3: §4.4 item 4). G2 is closed by §1.1, G3 by Theorem 2, and G1 is what Theorem 1 delivers with one member |
| the extreme rays are outside the domain | Bochner makes the Weil cone the closed hull of the characters, whose extreme rays are explicit — and W on a character is a divergent prime sum, so the Choquet decomposition converges in no topology W is continuous in. That, exactly, is "no known finite generating structure" |
| the Weil kernel E(v) | 2Φ̂(i/2)²cosh(v/2) + arch − comb = Σ_ρ Φ̂(γ_ρ)²cos(γ_ρ v) — the Weil pairing of two translates of one window as a function of their separation; verified prime-side against zero-side to 1.9e−23, and 99.56 % one sinusoid at γ₁ when σ = 0.15 |
| one generator, one group | RH ⟺ E positive-definite ⟺ E bounded ⟺ W ≥ 0 on the ℝ-translation orbit of a single Gaussian window — §4.4 item 4 met in its finitely-generated reading, with the smallest generating set there is |
| the generator generates the wall | the reduction to one function is exact and changes nothing: boundedness of an almost-periodic signal is not decidable from a bounded window of it, and E comes within 9.3e−5 of violating its own bound |
| the margin is the blindness | a finite family with floor λ_min > 0 survives any zero quadruple whose damage is smaller — so it is blind above a computable height, and a family that generates must have infimum 0. A bigger certified floor is a smaller reach |
| the lattice is not the group | sampling E on Δℤ spans only the functions measurable for r mod 2π/Δ; the section is the Toeplitz matrix of the *wrapped* measure (rh34's aliased matrix, identified), and at Δ = 0.5 every zero is folded — γ₃ and γ₆ land 0.004475 rad apart, needing n ≈ 1,404 to separate |
| the floor's decay is Szegő | λ_min(T_n) ↓ 0 unconditionally for any atomic spectrum; the collapse tracks N_eff and nothing else, and ζ's ordinates sit between an arithmetic progression and a √-lattice on the same weights. Only the rate could be arithmetic |
| the window must be Laguerre–Pólya | Φ̂ zero-free on \|Im z\| ≤ ½ (the strip the weight e^{\|u\|/2} forces) or the family is exactly blind to a zero at ½ + iz₀; a window can test for LP failure only if it is itself LP. rh19's notch at Δ* = 2π/γ₁ is the harmless real-axis case of this |
| the blind window | φ = 1_{[−1,1]} + 0.46·1_{[−2,2]}: Φ̂ = (2/r)sin r(1 + 0.92 cos r) vanishes at kπ ± 0.4141i, k odd — a certificate on it stays positive definite even if ζ had zeros at β = 0.914 all the way up the line |
| the moment tower | m_n = (−1)ⁿE^{(2n)}(0) = window-regularised power sums of the ordinates, computed from primes and zeros to 9.3e−41; RH ⟺ both Hankel forms [m_{i+j}] and [m_{i+j+1}] are PSD for every N — the shift is what excludes a real zero in (0,1) |
| one measure read three ways | Li's power sums (unregularised), the moment tower (regularised at the identity), and the arc's Toeplitz certificates (sampled on a subgroup) are the same zero measure at three resolutions; Jensen is the same shape on Φ's moments instead of the zeros' |
| one figure per place | the adelic object is a decomposition, not a bigger horn: at v = ∞ the figure is the horn (continuous depth, smooth weight), at v = p it is a helix (rings at k·log p, radius p^{−kσ}, phase −t·u) — rh3's cone with its ring set thinned to (log p)ℤ. The horn/helix duality is the ∞/finite dichotomy of places |
| the local horn is a helix | Z_p(s) = Σ_k p^{−ks} is rh3's construction on the sublattice (log p)ℤ: same radial profile e^{−σu}, same phase law, truncation geometric (\|Σ_{k≤64} − Z_2\| = 9.8e−11 against the law's 5.6e−10) |
| no local closure | \|Z_p(½+it)\| ∈ [(1+p^{−1/2})^{−1}, (1−p^{−1/2})^{−1}] — 0.5858 to 3.4142 at p = 2 — and Γ is zero-free, so **every** local figure is zero-free: the closures exist only in the product over all places |
| the finite depth lattice | ⊕_p (log p)ℤ, whose positive cone is {log n} — the helix's gear set is the finite places' depth lattice, and its freeness is unique factorisation; the pairings this arc computes are that lattice against the archimedean line |
| n^{−1/2} is \|x\|^{1/2} | the taper in the translation identity is the half-power of the idele norm — the unitary normalisation on C_ℚ, which is why the transform lands on Re s = ½. The critical line is the unitary axis of the group, a fact about C_ℚ and not about ζ |
| the χ-fibres | C_ℚ ≅ ℝ_{>0} × ℤ̂^×, and the characters of the compact factor are the Dirichlet characters: the horn is the trivial-character fibre of a family of L-horns, each with the same criterion. Adelic completion makes the object canonical and the hypothesis GRH |
| the mirror is an involution on the fibres | Λ(s, χ) = ε(χ)Λ(1−s, χ̄), so u ↦ −u carries the fibre over χ to the fibre over χ̄ with the root number as its phase — a horn has a mirror *plane* only on the real fibres, which are the involution's fixed points; elsewhere it has a mirror *partner* |
| the taper is fibre-independent | φ_n^χ(u) = χ(n)·n^{−1/2}·φ₁^χ(u + log n) for every primitive χ, even or odd (worst residual 1.2e−38): the bump changes with the parity, the twist is χ, the conductor rescales the throat, and the exponent −½ never moves |
| ramified places drop out | on the fibre χ mod q the local factor at p \| q is 1 — the ladder is empty and the place is absent from the figure; the unramified fibres are the same ladders re-phased by arg χ(p^k) |
| the local Weil term | W_p(g) = −log p·Σ_k p^{−k/2}[g(k log p) + g(−k log p)], derived from Weil's principal value by splitting ℚ_p^× into shells: \|1−w\|_p = 1 below the units and = \|w\|_p above them. The prime side of the explicit formula, regrouped by place |
| the volume term | the two pole terms h(±i/2) belong to no place — they are the residues of the global zeta integral at s = 0, 1, carrying the volume of the compact idele class group, and they are the adelic name for the factor ½s(s−1) |
| the ledger, place by place | positivity-generator.md's E(v) split by place and reproduced to 21 digits: at v = 0 three places carry all of it; at v = 10 the volume term is 21.1 and the places cancel it to four parts in 10⁴ |
| the places are sampled, not summed | at separation v only the places carrying a prime power within a window-width of e^v contribute: p = 101 gives 1.7e−05 at v = 10 while p = 1009 gives 7.7e−48. The count grows like π(e^{v+2}) — 4, 16, 179, 13,585, 520,050 at v = 0, 2, 5, 10, 14 |
| the archimedean handover | \|Σ_p W_p\|/\|W_∞\| crosses 1 at v\* = 0.6701618091 (both sides −0.1518012429) and reaches 1.6e+05 by v = 12 — the archimedean place hands the ledger to the finite ones almost immediately, and the ratio grows like the volume term's own cosh(v/2) |
| only ∞ gets small | \|C(½+iγ_k)\| — the prime horn's amplitude ledger — is the archimedean local factor at the closures, decaying like e^{−πγ/4}; the finite local factors never decay, staying in [0.586, 3.414] at p = 2 for every t. Every construction here that achieves boundedness achieves it archimedean-side |
| smearing is archimedean | the Bruhat–Schwartz space of ℚ_p is locally constant with compact support and log\|·\|_p lands on a lattice, so any local test function pushes forward to a finitely supported measure: **there is no p-adic bump.** The prime horn is therefore necessarily hybrid — finite-place atoms, archimedean smearing — and the horn's decidability is a one-place property |
| the truncation trade, reversed | depth truncation is cheap at every place (K = 129 shells at p = 2 for 1e−19) and place truncation is not: over sixteen samples to 2×10⁶, \|∏_{p≤P} Z_p(½+iγ₁)\| moves non-monotonically over more than four orders — 2.46 at P = 7×10⁵ against 1.4e−04 at 2×10⁶ — so the fitted 0.30 decades/decade of horn-helix.md §5 was a fit, exactly as its own caveat warned, and nothing measured bounds the excursions |
| the functional equation is local | γ_v(s)γ_v(1−s) = 1 and \|γ_v(½+it)\| = 1 at **every** place, both to the working precision (≤ 2.3e−41): each place has its own mirror and the tilt breaks all of them at once. arg γ_∞(½+it) = −2θ(t) — the horn's archimedean winding is the Riemann–Siegel theta |
| the local root numbers do not multiply | ∏_v γ_v(s) = 1 is the functional equation, but the partial products on the line do not converge: \|∏ − 1\| reads 1.543, 1.871, 1.248, 1.930, 1.952 out of a maximum 2. The local *factors* converge at σ = 1.5 while the local *root numbers* run to 2.5e−2152 |
| the strip is the gap | ∏_p Z_p(s) converges for σ > 1, ∏_p Z_p(1−s) for σ < 0, and no s has both — the critical strip is exactly the gap between the two domains. horn-helix.md §5's obstruction, in a form that is a fact about products rather than about ζ |

---

*Successor to [docs/rh3/README.md](../rh3/README.md). The construction it
replaces is the helix; the wall it does not move is rh28 §7.*
