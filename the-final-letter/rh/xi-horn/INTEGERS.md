# The integers on the smooth horn — three solutions

Companion to [README.md](README.md) and [POSITIVITY.md](POSITIVITY.md).

Three standing complaints get closed here:

1. **"The integers are hidden in the kernel."** They are not hidden. They are
   the *layers* of the horn, individually resolvable, with computed shares.
   §1.
2. **"Precision is a problem."** It was self-inflicted. The fix costs nothing
   and makes double precision sufficient everywhere. §3 — and it **corrects the
   warning I put in the other two files**.
3. **"You need something like sin(πx) but grown-up."** It exists, it is exact,
   and for this horn it is already built in. §4.

Plus the route that removes precision from the question entirely, §5.

---

## 1. The integers are the horn's layers

Φ is not a smooth blob with the integers summed away. It is, by definition, a
sum of integer-indexed shells:

```
Φ(u) = Σ_{n≥1} φ_n(u),    φ_n(u) = (2π²n⁴e^{9u/2} − 3πn²e^{5u/2})·e^{−πn²e^{2u}}   (14)
```

Each φ_n is a bump. On u ≥ 0 they are **strictly hierarchical and never
cancel** — the integer lattice is not merely present, it is ordered and
separable:

```
  u      Φ(u)             φ₁ share      φ₂ share        φ₃ share
  0.0    0.4466969005     99.7829 %     0.217133 %      1.78e-07 %
  0.3    0.1834871447     99.9999 %     7.055e-05 %     1.38e-16 %
  0.6    0.0074234562     100.000 %     4.634e-11 %     5.37e-33 %
  1.0    1.377813941e-07  100.000 %     9.587e-28 %     1.92e-77 %
  1.4    3.818576539e-19  100.000 %     8.011e-65 %     2.67e-176 %
```

**So: draw the horn as nested shells.** Shell 1 is essentially the whole
silhouette; shell 2 is a 2-parts-per-thousand skin at the throat that thins to
nothing by u = 0.6; shell 3 is a 10⁻⁹ film. On a log-radial axis all of them are
visible, distinct, and labelled by *n*. That is the arithmetic, drawn, on the
smooth object — no selector function required, because the object was built out
of the integers in the first place.

Note the throat is where the integers are *most* visible (shell 2 at 0.217 %)
and they vanish going outward. The magnification of POSITIVITY.md §4 walks the
probe *away* from where the arithmetic is legible. Worth knowing before
choosing where a figure should zoom.

---

## 2. The mirror side: cancellation **is** the functional equation

On u < 0 the same shells no longer stack — they annihilate:

```
    u      Φ(u)              Σ|φ_n|        condition number    digits lost
  −0.5     0.030188726       0.42041659    13.9                 1
  −1.0     1.3778139e-07     0.72471281    5.26e+06             6
  −1.5     6.4883954e-24     0.95255221    1.47e+23            23
```

At u = −1.5 the shells sum to ~0.95 in absolute value and produce 6.5e−24. That
23-digit collapse is not a numerical misfortune — **it is the theta functional
equation being enforced.** The integers on the negative side conspire to
reproduce, exactly, the mirror of the smooth positive side. The cancellation is
the arithmetic, and its magnitude is the content.

This is also the sharpest answer available to the standing "the smoothing kills
the zeros" worry: here the smooth side and the integer side are *the same
function*, related by the mirror, and the exchange between them is quantified
above.

---

## 3. Precision: solved, and a correction

**Correction to README.md §7 and POSITIVITY.md §7.** I told you Φ needs ≥ 50
decimal digits. That diagnosis was wrong in a way that changes what you build.
The precision loss is entirely on u < 0, and Φ is even, so **u < 0 never needs
to be evaluated.**

Evaluate `Φ(|u|)` with 6 terms in ordinary double precision:

```
   u      double, 6 terms            mpmath 60 dps              rel. error
  0.0     4.466969004671235e-01      0.4466969004671234         3.3e-17
  0.4     8.624007926801679e-02      0.08624007926801684        6.5e-16
  0.8     1.140161851518449e-04      0.0001140161851518448      1.3e-15
  1.2     3.815292835622197e-12      3.815292835622206e-12      2.2e-15
  1.6     8.752056431082546e-30      8.752056431082448e-30      1.1e-14
```

Full double-precision accuracy down to Φ ~ 10⁻³⁰. Compare the *same formula* at
negative u in double precision:

```
  −1.0    1.377813939664411e-07      rel. error 7.0e-10
  −1.4    9.296726948523107e-17      rel. error 242
  −1.6    5.604709853449715e-17      rel. error 6.4e+12
```

**Rule for any implementation: `Phi(u) := Phi_series(abs(u))`, 6 terms,
float64.** No arbitrary precision anywhere in the figure. The mpmath in the
other two files was buying nothing but the right to make a sign error.

(The moment integrals of POSITIVITY.md still want extended precision, but for a
different and honest reason — γ(n) at n ≈ 34 is a 10⁻⁷ quantity extracted from
an integrand spanning 30 orders, and the Jensen discriminants of §5 are tiny.)

---

## 4. The grown-up sin(πx)

For the record, since the request was specific: the mature form of "a function
that intersects a smooth object exactly at the integers, at an angle" is not a
sine. It is a **pole comb**, and it comes in three equivalent dresses.

**(a) The cotangent kernel.** π·cot(πz) has a simple pole of residue 1 at every
integer and nowhere else. Hence, for f holomorphic in a strip,

```
Σ_n f(n) = (1/2πi) ∮ f(z)·π cot(πz) dz                                     (15)
```

The contour is the "angle" — it crosses the real axis transversally, and the
integers are picked off as residues. This is exact, not asymptotic.

**(b) Abel–Plana**, the same identity with the contour pushed to the imaginary
direction, giving sum-minus-integral in closed form with kernel
1/(e^{2πiz} − 1). This is the honest version of Euler–Maclaurin: no Bernoulli
asymptotics, no remainder to bound.

**(c) Poisson summation**, which is the one to actually use:

```
Σ_n f(n) − ∫ f  =  Σ_{k≠0} f̂(k)                                            (16)
```

Read that against rh3 §11's warning — "the zeros are the sum minus the
integral". (16) says precisely where the zeros live: **in the non-zero Fourier
modes.** ∫f is the k = 0 mode; everything arithmetic is in k ≠ 0. That is a
location, not an obstruction.

And for this horn specifically, (16) is not an extra structure to bolt on.
**The theta functional equation that makes Φ even *is* Poisson summation** —
θ(1/x) = √x·θ(x) is (16) applied to a Gaussian. So the mirror symmetry of §2,
the shells of §1, and the grown-up sin(πx) are one mechanism seen three ways.
Nothing needs to be added to the construction; it is already the intersection
you asked for.

---

## 5. Beat it in topological space, then bring it back

This is a real route and it dissolves precision entirely.

**The topological statement.** The Laguerre–Pólya class LP — entire functions
that are locally uniform limits of real-rooted polynomials — is **closed** in
the topology of uniform convergence on compact sets. And

```
RH  ⟺  Ξ ∈ LP  ⟺  every Jensen polynomial J^{d,n} is hyperbolic            (17)
```

So RH is a *closedness* assertion: exhibit Ξ as a limit of hyperbolic
polynomials and you are done. No analytic continuation, no zero-counting, no
contour.

**Why that kills the precision problem.** Hyperbolicity of a polynomial is the
**sign of its discriminant** (for d = 2, 3; for d ≥ 4 a finite chain of
subresultant signs). A sign is a topological fact. It is decidable from
*enclosures* of the coefficients — you never need γ(n) exactly, only intervals
tight enough to separate the discriminant from 0. That is exact certified
arithmetic, and it is precisely the technique rh19–rh27a already run.

Computed discriminants of J^{d,n} on a(n) = γ(n)·n!/(2n)!, all strictly
positive:

```
   d   n     discriminant        normalised margin
   2   0     3.6746e-05          1.357e-04
   2  10     9.8744e-41          2.236e-05
   2  30     5.3285e-118         5.261e-06
   3   0     2.0170e-13          2.512e-12
   3  15     7.6910e-123         3.918e-15
   3  30     2.4317e-240         2.276e-16
   4   0     1.5931e-25          6.108e-24
   4  15     8.4217e-191         2.831e-29
   4  30     1.2401e-367         1.057e-31
```

(Normalised by (Σ|coefficients|)^{2d−2} to make the margin scale-free.)

**The bringing-back.** The certificate that returns to the real world is the
margin, and the margin is (11) of POSITIVITY.md — the Cauchy–Schwarz defect of
the horn's profile against the factorial gain, currently at ratio 0.29 and
falling. One inequality, both sides explicit in Φ.

**The margins are flat — an earlier claim here was wrong.** A first pass read
the raw discriminants above (1.4e−4 down to 1.1e−31) as certificates getting
harder with d and n. That was measuring the discriminant's own dimensionality,
not any difficulty: disc is a product over d(d−1)/2 squared root gaps, so it
scales like (gap)^{d(d−1)} — one factor at d = 2, fifteen at d = 6 — and a
perfectly conditioned configuration still plummets.

The scale-free measurement normalises the roots to mean 0, variance 1 and
compares the configuration with Hermite:

```
 d      disc / disc(Hermite)                min gap /
        n=0     n=10    n=20    n=30        Hermite gap
 2      1.000   1.000   1.000   1.000       1.000
 3      0.999   0.995   0.995   0.996       0.962
 4      0.992   0.979   0.981   0.983       0.999   (n=30)
 5      0.971   0.949   0.953    —          0.970
 6      0.930   0.900   0.909    —          0.973
```

Flat in both directions, and the d = 4 row improves with n — consistent with
the Hermite limit arriving. Minimum normalised root gap sits at 0.96–1.00 of
Hermite throughout. The residual d-drift in the discriminant column compounds
30 pair-factors at d = 6 against 1 at d = 2; per pair it is 0.07 % at d = 3
rising to 0.35 % at d = 6, and five points will not support an extrapolation.

**What is actually open**, then, is not margin decay. Griffin–Ono–Rolen–Zagier
proved that for each fixed d, J^{d,n} is hyperbolic for all but finitely many n
(from memory — verify before citing). The gap is those finitely many small-n
exceptions at each d, with no uniform-in-d control of how many. Genuine, and
invisible in any margin table.

**And a conflation to retract:** this is *not* the wall rh28/rh29 measured.
Their decaying quantity is a Weil-positivity floor against support/window
depth. Jensen degree d is a different axis, and neither result bears on the
other. What §5 buys is narrower than first claimed but still real: the
*precision* question is closed — hyperbolicity is a sign, signs are certifiable
from enclosures, and precision will never be why something fails.

---

## 6. Build list

Concrete, in order of payoff:

1. **Re-implement Φ as `Phi_series(abs(u))`, 6 terms, float64.** Delete the
   arbitrary-precision path from the figure. (§3)
2. **Draw the horn as nested shells** on a log-radial axis, with an *n* slider
   that peels them — shell 1, then the 0.217 % skin of shell 2, then the 10⁻⁹
   film of shell 3. The arithmetic, visible, on the smooth surface. (§1)
3. **Put a condition-number readout on the mirror**: at each u, show Σ|φ_n|
   against |Φ|. Sweeping u negative and watching it climb to 10²³ is the
   functional equation as a measurement. (§2)
4. **Replace the closure readout with the margin readout**: defect(n) vs
   gain(n), ratio against 1. (POSITIVITY.md §3)
5. **Certify the discriminant signs in interval arithmetic** rather than
   floating point — a small, finished, checkable artefact in the same style as
   rh19–rh27a. (§5)

**Items 1–4 are built: [figure.html](figure.html).** Self-contained, no CDN, no
three.js, no fallback path — a ~90-line hand-rolled projection on canvas 2D.
All arithmetic float64, validated against the 60-digit references: Ξ at
γ₁…γ₅ returns ~2e−17, Ξ(17) = −5.433786e−04 against −5.433785679e−04, γ(0) to
11 digits, and the Turán margin column reproduces the mpmath values to six
figures. The shells nest as predicted — throat radii 1.000, 0.911, 0.708,
0.407 on the 30-decade log axis, reaching u = 1.615, 0.920, 0.515, 0.225.

Item 5 remains — the one that could stand next to the arc's existing
machinery.

---

*Predecessors: [README.md](README.md) (the closure form),
[POSITIVITY.md](POSITIVITY.md) (the shape form),
[../rh3/README.md](../rh3/README.md) (the helix).*
