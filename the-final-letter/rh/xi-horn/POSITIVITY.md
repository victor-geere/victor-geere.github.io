# The horn, modded into positivity — and the needle under a microscope

Companion to [README.md](README.md). That file specifies the Ξ horn as a
*closure* object: two conjugate threads, a tilt, an endpoint annihilation. This
one performs the change of variables that removes the threads entirely.

**The result: RH becomes a statement about the horn's silhouette alone.** No
phase, no winding, no *t*, no integration to a limit. Just the shape of Φ, and
whether one explicit inequality holds at every magnification.

All numbers below computed at 60 decimal digits with mpmath. Reproduction
recipes in §7.

---

## 1. The move

Expand the transform instead of evaluating it. From (2) of the README,

```
ξ(½ + z) = Σ_{n≥0}  γ(n) · z^{2n} / (2n)! ,      γ(n) = 4∫₀^∞ u^{2n}·Φ(u) du   (7)
```

γ(n) > 0 for every *n*, because Φ > 0. Verified against an independent ξ:

```
  z      Σ γ(n)z^{2n}/(2n)!     ξ(½+z)              rel. error
  0.1    0.49723565025592       0.49723565025592    1.6e-61
  0.9    0.50650585657646       0.50650585657646    0
  2.0    0.54509420701213       0.54509420701213    0
  4.0    0.71618708371159       0.71618708371159    2.3e-61
```

(34 terms; γ(0) = ξ(½) = 0.4971207782.)

**γ(n) is the sequence of even moments of the horn's profile about the throat.**
Everything from here is a statement about that sequence — i.e. about the
silhouette — and *t* never reappears.

---

## 2. The trap: γ carries no information on its own

The first thing to try is log-concavity of γ, and it fails — necessarily.

By Cauchy–Schwarz with f = uⁿ√Φ and g = u^{n+2}√Φ:

```
γ(n+1)² ≤ γ(n)·γ(n+2)          for ANY positive weight whatsoever            (8)
```

So the moment sequence of the horn is **forced log-convex**, and the observed
Δ²log γ > 0 at every n up to 32 is not a fact about ζ. It is the same free
positivity as rh3 §10's ⟨a,b⟩ = cos(π/6)|η|² — true of everything, therefore
about nothing.

This is worth stating loudly because it is the third time in this arc that an
attractive inequality has turned out to be Cauchy–Schwarz in costume.

---

## 3. Where the content actually is

The Taylor coefficients of Ξ are not γ(n) but

```
c(n) = γ(n) / (2n)!                                                         (9)
```

and *these* are log-concave. Verified for **all n = 0 … 33**:

```
   n     c(n+1)²/(c(n)c(n+2))      Δ²log c(n)
   0        2.149687885            −0.765323   OK
   1        1.594115499            −0.466319   OK
   2        1.405737775            −0.340562   OK
   3        1.310063099            −0.270075   OK
   5        1.212569287            −0.192741   OK
  10        1.121044533            −0.114261   OK
  15        1.085425112            −0.081972   OK
  20        1.066295169            −0.064190   OK
  25        1.054301221            −0.052878   OK
  30        1.046055488            −0.045026   OK
```

That is the **Turán inequality**, and it is a theorem — Csordas–Norfolk–Varga,
1986, from memory; check the citation before publishing it. Nothing is being
discovered here. What is being *obtained* is the explicit form below.

### The margin identity

Dividing (9) into the ratio splits it exactly:

```
  c(n+1)²        γ(n+1)²        (2n+3)(2n+4)
 ─────────  =  ───────────  ×  ──────────────                              (10)
 c(n)c(n+2)    γ(n)γ(n+2)      (2n+1)(2n+2)
```

The first factor is ≤ 1 always, by (8). The second is > 1 always, and ≈ 1 + 2/n.
So:

> **Turán positivity holds at n ⟺ the horn's Cauchy–Schwarz defect is smaller
> than the factorial gain:**
>
> ```
> Δ²log γ(n)  <  log[ (2n+3)(2n+4) / ((2n+1)(2n+2)) ]   ≈  2/n           (11)
> ```

A contest between two explicit quantities, both computable from Φ alone. Define
the **margin ratio** as the left side over the right; positivity is `< 1`.

```
   n    C–S defect Δ²log γ     factorial gain     margin ratio
   0        1.026436807         1.791759469        0.5729
   1        0.4499716953        0.9162907319       0.4911
   2        0.2835920375        0.6241543091       0.4544
   4        0.1583657953        0.3829922523       0.4135
   8        0.0804389016        0.2165861508       0.3714
  10        0.0637222861        0.1779831552       0.3580
  15        0.0411732598        0.1231449788       0.3343
  20        0.0299578831        0.0941480646       0.3182
  25        0.0233284112        0.0762066088       0.3061
  30        0.0189831488        0.0640095605       0.2966
  32        0.0176418349        0.0601583127       0.2933
```

Both sides decay like const/n; the defect's constant is ≈ 0.57 against the
gain's 2, and the ratio drifts *down* — the inequality gets safer with depth
over the range computed.

**Continued to ℂ in [CONTINUATION.md](CONTINUATION.md).** γ(n) = Γ_Φ(2n) for
the Mellin transform Γ_Φ(w) = 4∫u^wΦ du, and c(n) continues to the *entire*
function Γ_Φ(w)/Γ(w+1) — the factorial division is exactly what cancels Γ_Φ's
pole string. The margin ratio then has no zeros anywhere computed: R(w) − 1 ~
4/|w| in every direction, so positivity is not tight but asymptotically free.

**Do not over-read that.** It is 33 values of one d = 2 condition, it is not a
proof, and it is not the same quantity as the certified floors of rh19–rh27a.
rh28/rh29's "worse than a power law" is about a different object; nothing here
softens it.

---

## 4. The microscope — and what n is

Here is why this reformulation *is* the answer to the needle problem rather
than a separate topic.

The probe in (7) is u^{2n}. As *n* rises, u^{2n}Φ(u) peaks further out along the
horn, where Φ is smaller. **The Jensen/Turán index n is the magnification
knob.**

```
   n    peak u*(n)      Φ(u*)              drawn radius (Φ/Φ₀)^{1/8}
   1     0.309194       0.1730768          0.888
   2     0.419792       0.0718395          0.796
   3     0.497412       0.0311498          0.717
   5     0.609135       0.0064011          0.588
   8     0.725417       0.00069206         0.445
  12     0.835617       4.2737e-05         0.314
  16     0.919014       3.0419e-06         0.226
  20     0.986497       2.4022e-07         0.165
  25     1.056280       1.1251e-08         0.112
  30     1.114920       5.8186e-10         0.0775
  34     1.155980       5.7696e-11         0.0581
```

By n = 34 the probe is sampling the horn where the radius is 5.8e−11 of the
throat — eleven orders down the needle, in a region no linear rendering can
show at all. And the criterion evaluated there is still an O(1) number.

**That is the scale-back-down.** The magnified quantity is γ(n), which spans
0.497 → 1.2e−7 → back up. The de-needled quantity is the margin ratio of §3:
bounded, smooth, monotone, and carrying the entire question in its comparison
against 1.

So the two requests turn out to be one operation:

| | |
|---|---|
| "mod it into positivity" | replace closure of a curve by log-concavity of the profile's moments |
| "blow the needle up" | raise n — the probe walks out the horn |
| "scale it back down" | divide by the factorial gain; read the margin ratio |

---

## 5. Beyond d = 2 — the Jensen polynomials

The full criterion is not Turán alone. Put Ξ in Laguerre–Pólya form: with
x = −t²,

```
Ξ(t) = F(−t²),      F(x) = Σ γ(n) x^n/(2n)! = Σ a(n) x^n/n! ,
a(n) = γ(n)·n!/(2n)!                                                       (12)
```

RH ⟺ F has only real (negative) zeros ⟺ every Jensen polynomial

```
J^{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j                                  (13)
```

is hyperbolic. Computed for d = 2, 3, 4, 5 and n = 0, 4, 8, …, 28 — **every
one hyperbolic, max |Im root| = 0 exactly at 60 digits.** a(n) is also
log-concave throughout (ratios 1.0748 at n = 0 falling to 1.0134 at n = 30).

Roots normalized to mean 0, variance 1, compared with the same normalization of
the Hermite roots H_d:

```
   d    n=0      n=8      n=12     n=20     n=28
   2    —        —        —        —        —        (vacuous: two points → ±1)
   3    0.0143   0.0334   0.0339   0.0329   0.0314
   4    0.0259   0.0347   0.0350   0.0337   0.0321
   5    0.0389   0.0518   0.0518   0.0498   0.0474
```

The deviation peaks near n ≈ 12 and then declines — the Hermite limit of
Griffin–Ono–Rolen–Zagier (2019, from memory; verify before citing), arriving
slowly. The d = 2 row is struck out because any two points normalized to mean 0
and variance 1 are ±1 regardless of their values; it proves nothing and should
not be reported as agreement.

---

## 6. What this buys, and what it does not

**Buys.**
* The phase is gone. No *t*, no threads, no tilt, no truncation of an integral
  toward a limit. RH is a property of a static profile.
* The needle is tamed honestly rather than cosmetically: no root-scaling of the
  radius for drawing, the criterion is genuinely O(1) at every magnification.
* The criterion is *local in n* — it can be checked at one magnification without
  reference to any other. Contrast the helix, which decides nothing at any
  finite depth (README §6).
* It has a margin, (11), which is exactly the shape of object the arc's
  machinery already certifies.

**Does not.**
* Still no integers in the picture. They are inside Φ's theta series, summed
  before anything is drawn. rh3 §11's warning is unmoved.
* Still not new. Turán for ξ is 1986; Jensen/Laguerre–Pólya is classical; the
  Hermite limit is 2019. This file computes; it does not discover.
* **Finitely many conditions verified.** d ≤ 5, n ≤ 33. RH needs all d and all
  n, and the hard part is uniformity in d, which no amount of this table
  touches.
* The margin ratio's downward drift is an observation over 33 points, not a
  trend with a proof, and not transferable to rh28/rh29's floors.

---

## 7. Reconstruction

```
# --- moments (needs 50+ dps; double precision is useless past u ~ 1.2) ------
Phi(u) = sum_{n=1..24} (2 pi^2 n^4 e^{9u/2} - 3 pi n^2 e^{5u/2}) e^{-pi n^2 e^{2u}}
gamma(n) = 4 * quad(u -> u^{2n} Phi(u), nodes=[0, .5, 1, 1.5, 2, 3])
# sanity: gamma(0) = xi(1/2) = 0.4971207782
#         sum_n gamma(n) z^{2n}/(2n)! == xi(1/2+z)   to 60 digits

c(n) = gamma(n)/factorial(2n)             # Taylor coefficients — log-CONCAVE
a(n) = gamma(n)*factorial(n)/factorial(2n)  # Laguerre-Polya sequence

# --- the two sides of the margin -------------------------------------------
defect(n) = log gamma(n+2) - 2 log gamma(n+1) + log gamma(n)      # > 0, forced
gain(n)   = log( (2n+3)(2n+4) / ((2n+1)(2n+2)) )                  # ~ 2/n
margin(n) = defect(n)/gain(n)             # Turan holds iff < 1

# --- Jensen ----------------------------------------------------------------
J(d,n) = polynomial with coefficients [C(d,j)*a(n+j) for j in 0..d]
roots must all be real and negative

# --- the microscope --------------------------------------------------------
u*(n) = argmax_u [ 2n log u + log Phi(u) ]     # where probe n samples the horn
```

**Precision — corrected, see [INTEGERS.md](INTEGERS.md) §3.** The earlier
warning here said Φ needs ≥ 50 dps. Wrong diagnosis: the cancellation is
entirely on u < 0, and Φ is even, so evaluate `Φ(|u|)` with 6 terms in float64
and the relative error stays ~1e−15 down to Φ ~ 1e−30. The first pass that
returned Ξ(γ₁) = −2.5e−3 instead of 0 was reading the negative side, not
running out of digits.

Extended precision is still wanted for the *moment integrals* γ(n) and for the
Jensen discriminants — those are genuinely small quantities, not cancellation
artefacts.

### Suggested figure

The horn from README §3, plus:

* a **probe ring** at u\*(n) that slides outward as an *n* slider is raised —
  the microscope, visible;
* two bars for defect(n) and gain(n), and the margin ratio between them, so the
  positivity contest is the readout rather than a curve closing;
* the *d* and *n* Jensen roots on a line, with the normalized Hermite roots
  ghosted behind them.

No tilt slider. Positivity does not need one — that is the whole point of the
reformulation.

---

*Companion: [README.md](README.md) — the closure form of the same object.
Predecessor: [../rh3/README.md](../rh3/README.md) — the helix.*
