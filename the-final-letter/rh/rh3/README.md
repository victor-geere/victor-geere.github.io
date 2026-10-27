# rh3 — the helix, specified

A complete mathematical specification of the construction drawn in
[docs/rh3.html](../html/rh3.html) ("The circles, before the helix"), written so that
the helix, the gears, the spines, the ledger and the chain can be rebuilt
faithfully in any renderer without reading the page's source.

Everything below is a closed form. Nothing in the figure is splined,
interpolated between vertices, or fitted; every curve is evaluated.

---

## 1. Parameters

| symbol | meaning | range | default in the figure |
|---|---|---|---|
| σ | radial decay, `Re s` | (0, ∞), slider 0.1 … 1.2 | 0.5 |
| *t* | torsion, `Im s` | ℝ, slider 0 … 40 | γ₁ = 14.134725141734693 |
| *N* | number of levels drawn | 1 … 200 | 8 |
| *m* | stack ⇄ chain morph | [0, 1] | 0 |
| half | half-turns on/off | bool | on |

The two that carry mathematics are σ and *t*; they are the real and imaginary
parts of one complex number

```
s = σ + i·t
```

*N* and *m* are presentation. `half = off` removes the alternation and turns the
object into the (divergent, for σ ≤ 1) un-alternated ζ train — see §9.

Constants: τ = 2π. The alphabet is `a b c d e f g h i j k l`, index *k* = 0…11.

---

## 2. The clock (level geometry)

One circle per level *n* = 1, 2, 3, …, each carrying twelve **primary digits**
at angular offsets that are integer multiples of π/6, named *a*…*l*
anticlockwise from the circle's own zero direction. Digit *k* sits at offset
*k*π/6 in the circle's frame.

**Phase-opposite rule.** Digit *k* and digit *k*+6 are antipodal, and the
construction identifies the antipode with the additive inverse:

```
a + A = 0,  b + B = 0,  …          g ≡ A,  h ≡ B          (1)
```

Six axes. The whole arc uses only the axis {*a*, *A*}, with one excursion to
{*b*, *B*} (§8).

Twelve is chosen because the divisors of 12 are {1, 2, 3, 4, 6, 12} — the
sub-gears available inside one circle — of which the primes are 2 (the
half-turn, the engine of §4) and 3. Twelve is the smallest station count with
six sub-gears; every prime from 5 up is *foreign* to the clock and reachable
only through the stack of levels. Nothing below depends on the choice: all
twelve digit strings evaluate to `e^{ikπ/6}·η(s)`.

---

## 3. Radii and the depth axis

```
r_n = n^(−σ)              radius of circle n                              (3)
z_n = n − 1               depth of circle n, in units of r₁ = 1           (4)
```

Two consequences that the plane figures of the rest of the arc hide:

* the depth coordinate **is** the level index — reading the numeral is walking
  down the axis at unit speed, one place value per step;
* `r₁ = 1` for every σ, so the unit spacing does not move when σ moves. σ shows
  up as a **taper**, never as an overall scale.

At σ = ½ the first four radii are 1, 0.7071, 0.5774, 0.5.

---

## 4. Orientation: half-turns and torsion

Circle *n* carries a cumulative extra rotation of its frame:

```
α_n = (n − 1)·π                     one half-turn per level                (5)
ρ_n = −t · log n                    the torsion                            (7)
ϑ_n = α_n + ρ_n = (n−1)π − t·log n  lab angle of the a-vertex on circle n  (8)
```

With `half = off`, α_n ≡ 0.

Because the frame turns by π per level, one fixed letter does not name one fixed
direction: the constant string *aaaa…* presents, level by level, as *aAaA…*.
That alternation is not written by the author; it is what a fixed letter looks
like in a turning frame — and analytically it is exactly `e^{iπ} = −1`.

**Vertices.** The *a*-vertex of level *n* is the point of circle *n*'s plane at
radius `r_n`, angle `ϑ_n`, at depth `n − 1`. The *b*-vertex is the same point
rotated rigidly by π/6 about the depth axis. Generally, digit *k* of level *n*
sits at angle `ϑ_n + kπ/6`.

**Turning ring.** Treating the level as continuous, the bare phase velocity of
(8) is `π − t/x`, which vanishes at

```
x* = t/π            (= 4.4992… at t = γ₁)                                  (9)
```

Inside `x*` the torsion dominates the half-turns; past it the half-turns win.
This is where the *bare* angle (8) would reverse. The drawn thread does not
reverse there — see the next section.

---

## 5. The ledger: the uniform-pitch lift

(8) is only defined mod 2π by the clock — a station has no winding memory. A
**gear turns one way**: the picture is a nut on a bolt, which cannot decide
halfway to a level to unscrew. So the whole-turn freedom is fixed once, for the
whole thread, as a single uniform pitch:

```
ϑ̃(x) = (x − 1)·p − t·log x                                              (10)
p     = A + c·τ,        A = π  (half-turns on)  or  0  (off)
c     = max(0, ⌈(t − A)/τ⌉)        whole turns per level (the "carry")
```

Its rate is

```
ϑ̃′(x) = p − t/x         strictly increasing in x, and ≥ 0 everywhere    (11)
```

so the thread never backs off, its rate never jumps at a station, and at the
turning ring `x* = t/π` the rate is exactly *c* turns per level.

`ϑ̃(n) ≡ ϑ_n (mod 2π)` for every *n*: the lift hits every station exactly, and
differs from the bare angle only by *c* whole turns per level — the **carries**.

> **Why uniform and not per-segment.** Booking the minimum forward turn on each
> segment separately (rh6 (2)) is also monotone, but its *rate* is not: at
> *t* = γ₁ the segments then demand 0.94, 0.59, 0.85, 1.00, 0.09 turns, and the
> 1.00 → 0.09 collapse is a residual artefact, not a fact about the numeral.
> A bolt has no such feature.

**The ledger**, in turns:

```
δ_n = ϑ̃(n)/τ                                                            (12)
```

At *t* = γ₁, half-turns on: `c = 2`, `p = π + 2τ = 5π = 15.70796…`,
`p/τ = 2.5` turns per level.

```
δ₁…δ₁₀ =  0.00  0.94  2.53  4.38  6.38  8.47 10.62 12.82 15.06 17.32   (τ)
Δδ     =        0.94  1.59  1.85  2.00  2.09  2.15  2.20  2.24  2.26
```

The increments rise monotonically toward `p/τ = 2.5`: the torsion `t/x` is a
brake that bites hardest at the shallow end. At `x* = 4.4992` the gear turns at
exactly 2.00 turns per level — the carry rate, neither more nor less.

δ is never reduced mod 2π; the figure prints it under each of the first ten
gears (`LEDGER = 10`).

---

## 6. The cone and its spines

The silhouette of the stack, interpolated between levels, is the surface of
revolution

```
r(x) = x^(−σ),   depth x − 1,   x ∈ [1, ∞)                               (19)
```

A **spine** is a digit carried by the turning frame — *not* a meridian, which
would be a fixed lab direction. Spine *k*:

```
angle = ϑ̃(x) + k·π/6,    r = x^(−σ),    z = x − 1                       (20)
```

Because δ only increases, every spine winds one way; none doubles back at `x*`,
they merely climb more slowly below it. The spine leaving *a* on circle 1 meets
*a* on every circle, δ_n turns later.

The figure draws four spines, `k ∈ {0, 3, 6, 9}` (the two orthogonal clock
diameters *a*–*g* and *d*–*j*), cut at the eighth gear because past it the taper
pulls them into the axis.

**The purple thread is spine 0, drawn identically** — not merely at the
stations. It therefore lies on `r = x^(−σ)` at every *x*, hits every
*a*-vertex, and winds one way only.

> The cone is a trap, and the trap is the point of drawing it: replace the sum
> over circles by the integral over the cone and the value becomes a product of
> Γ-factors and exponentials, which has no zeros. The smeared train never
> closes — every closure is an interference effect of the integer lattice.

---

## 7. The value: collapse to a chain

Each level contributes one vector: the displacement from circle *n*'s centre to
its *a*-vertex, read in that circle's plane as ℂ.

```
v_n = r_n · e^{i·ϑ_n} = (−1)^{n−1} · λ_n · r_n · e^{i·ρ_n}               (13)
```

λ_n ∈ (0, 1] is the **retuning** factor, the construction's one genuinely
undetermined structure; it is **set to 1 everywhere** here and in the figure.

The value of the numeral is the chained sum:

```
val(aaaa…) = Σ_{n≥1} (−1)^{n−1} λ_n r_n e^{i ρ_n}                        (14)

with r_n = n^(−σ), ρ_n = −t log n, λ ≡ 1:

val(aaaa…) = Σ_{n≥1} (−1)^{n−1} / n^s = η(s),   s = σ + it               (15)
```

**Evaluation is projection.** The two dials were the two coordinates of *s* all
along.

**Partial sums.**

```
P_0 = 0,        P_k = Σ_{j=1..k} v_j
```

**The morph.** At *m* = 0 each contribution is drawn from its own circle's
centre on the depth axis; at *m* = 1 from the head of its predecessor, with the
depth axis flattened. The tail of level *n* is

```
tail_n(m) = (1 − m)·(0, 0, n−1)  +  m·(Re P_{n−1}, Im P_{n−1}, 0)        (16)
```

exact at both ends, continuous between. At *m* = 1 the purple line has become
the partial-sum path and the figure is rh4's Figure 1.

---

## 8. The b-thread, and why it is off by default

Every *b*-vertex is its *a*-vertex rotated by the same fixed π/6, at every σ, at
every *t*, at every depth. Hence

```
val(bbbb…) = e^{iπ/6}·η(s),    val(k-th digit string) = e^{ikπ/6}·η(s)   (18)
```

The zero set is **digit-independent**: a closure is the simultaneous collapse of
the whole clock frame, all twelve helices returning to the origin together. The
amber thread makes that point once and then carries no further information, so
the figure hides it behind a checkbox.

(The pairing ⟨a,b⟩ = cos(π/6)|η(s)|² ≥ 0 with equality exactly at closures looks
like a missing axiom and is not: its positivity is the free positivity of a
norm-square, true of every Dirichlet series whatsoever.)

---

## 9. η, not ζ — and the gauge closures

```
η(s) = (1 − 2^{1−s})·ζ(s)                                                (17)
```

The half-turns *are* the analytic continuation device. Un-alternated, the train
diverges for σ ≤ 1: at *s* = ½ + iγ₁ the partial sums grow like `√N/|1−s|`
(7.0704 predicted vs 7.0705 measured at N = 10⁴, doubling each time N
quadruples). With the half-turns on, pairing level 2k−1 against 2k leaves a
residue of size O(|s|·k^{−σ−1}), summable for every σ > 0.

The price: the prefactor `1 − 2^{1−s}` has its own zeros at
`s_k = 1 + 2πik/log 2`. At *k* = 1, *t* = 9.064720…, the chain closes exactly
while |ζ| = 1.3511 and nothing arithmetic vanishes. These are **gauge
closures** — artefacts of presenting ζ through half-turns. "Null helix" and
"zero of ζ" are not synonyms.

### Evaluating η

Borwein's alternating-series algorithm, *n* = 32 terms (what the live figure
runs; cross-checked against a 48-term evaluation to 1e-13):

```
T_0 = 1/n,       d_0 = n·T_0
T_i = T_{i−1} · 4(n+i−1)(n−i+1) / ((2i)(2i−1)),      d_i = d_{i−1} + n·T_i
η(s) ≈ −(1/d_n) · Σ_{k=0..n−1} (−1)^k (d_k − d_n) · (k+1)^(−s)
```

Note: η is evaluated by this algorithm, **not** by truncating the visible chain.

---

## 10. Reference construction (pseudocode)

World frame used by the figure: the circle plane is (x, y); depth runs *away*
from the viewer, so world `z = −(x − 1)` (gears then turn anticlockwise on
screen).

```
τ = 2π
A     = half ? π : 0
c     = max(0, ceil((t − A)/τ))
p     = A + c·τ
lift(x)  = (x − 1)·p − t·log(x)          # the ledger angle, radians
rate(x)  = p − t/x

# partial sums, precomputed to GHOST = 800 levels
P[0] = 0
for n in 1..GHOST:
    r  = n^(−σ)
    th = (half ? (n−1)·π : 0) − t·log(n)
    P[n] = P[n−1] + r·(cos th, sin th)

# per-level: gear circle, spoke, vertices, ledger label
for n in 1..N:
    r  = n^(−σ)
    th = (half ? (n−1)·π : 0) − t·log(n)
    C  = ( m·Re P[n−1],  m·Im P[n−1],  −(1−m)·(n−1) )    # centre, eq. (16)
    circle of radius r about C in the z = C.z plane      # 72 segments
    a  = C + (r·cos th, r·sin th, 0)                     # the a-vertex
    b  = ( a.x·cos30 − a.y·sin30,  a.x·sin30 + a.y·cos30,  a.z )
    spoke C → a
    if n ≤ 10 and m < 0.5: label δ_n = lift(n)/τ  "turns"
    if n == 1: mark all twelve digits at angles th + k·π/6, k = 0..11

# the thread: spine 0 blended with the straight chain, 24 samples per level
for j in 0..(N−1)·24:
    x  = 1 + (N−1)·j/((N−1)·24)
    n0 = min(N−1, floor(x));  f = x − n0
    rf = x^(−σ);  tf = lift(x)
    cone  = ( rf·cos tf, rf·sin tf, −(x−1) )             # on the cone, one-way
    chain = P[n0] + f·(P[n0+1] − P[n0])                  # in the value plane
    pt    = ( (1−m)·cone.xy + m·chain,  (1−m)·cone.z )
    b-thread point = pt.xy rotated by π/6, same z

# the spines (optional): k ∈ {0,3,6,9}, x from 1 to min(8, max(2,N))
    angle = lift(x) + k·π/6,  r = x^(−σ),  z = −(1−m)·(x−1)
```

At every integer *x* = *n* the thread sample coincides exactly with the vertex
formula, at every *m*: `(1−m)·cone(n) + m·chain(n)` **is** the vertex. No spline
is needed or wanted.

### Figure-2 rendering constants

| constant | value | role |
|---|---|---|
| `SEG` | 72 | segments per gear circle |
| `SUB` | 24 | thread samples per level |
| `GHOST` | 800 | partial sums precomputed |
| `TRAIL` | 400 | levels of faint trail past *N* when *m* > 0.04 |
| `LEDGER` | 10 | gears carrying a δ label |
| `SPINES` | 0, 3, 6, 9 | drawn spines |
| `SPINE_MAX` | 8 | deepest gear a spine reaches |
| origin ring radius | 0.055 | the ring at 0, and at η(s) once *m* > 0.04 |
| camera | perspective, fov 38° | yaw 0.80 → π/2 and pitch 0.26 → 0 as *m*: 0 → 1 |

The camera interpolation is what makes *m* = 1 face the value plane square on,
reproducing rh4's Figure 1 exactly.

---

## 11. Numerical checks

Reproduce these and the reconstruction is faithful (σ = ½, *t* = γ₁ unless
stated):

| quantity | value |
|---|---|
| γ₁ | 14.134725141734693 |
| carry *c*, pitch *p*/τ | 2, 2.5 turns/level |
| turning ring `x* = t/π` | 4.4992227… |
| δ₂ | 0.9407 τ |
| δ₁₀ | 17.32 τ |
| \|η(½ + iγ₁)\| | ≈ 2e-15 (zero at double precision) |
| \|η(0.8 + iγ₁)\| | 0.44612 (the miss) |
| η(2) | π²/12 = 0.8224670334 |
| η(1) | log 2 = 0.6931471806 |
| gauge point *t* = 2π/log 2 | 9.0647202… — \|η(1 + it)\| = 0 while \|ζ\| = 1.3511 |
| un-alternated \|P_N\|, N = 10⁴ | 7.0705 ≈ √N/\|1−s\| |
| \|P₄₀₀\| at ½ + iγ₁ | 0.0250 (still on its way to 0) |
| r_n at σ=½, n=1..4 | 1, 0.7071, 0.5774, 0.5 |

---

## 12. What is *not* fixed

* **Retuning** λ_n ∈ (0, 1]: undetermined. With λ unconstrained closures exist
  at every decay exponent; with λ ≡ 1 the rigidity claim is exactly the Riemann
  Hypothesis. The admissible class in between is open (rh4 §18).
* Two conditions stated but unused: the growth condition
  `Δϑ_n + Δϑ_{n+1} ≤ Δϑ_{n+2}` on orientation increments, and monotonicity of
  the absolute orientations.

Nothing in rh3 or in this file is a step toward the hypothesis. It is the
construction the rest of the arc argues about, written down so it can be drawn
the same way twice.

---

*Source: [docs/rh3.html](../html/rh3.html). Companion: [docs/rh4.html](../html/rh4.html).
Equation numbers match rh3.*
