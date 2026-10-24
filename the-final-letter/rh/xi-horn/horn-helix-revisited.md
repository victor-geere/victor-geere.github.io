# The horn and the helix, revisited — the prime re-weighting, the log-depth fusion, and a road honestly surveyed

Successor to [horn-helix.md](horn-helix.md). Four questions, taken in order:

1. Re-weight the helix's gears from `n^{−σ}` to `Λ(n)·n^{−σ}` and relate the
   helix to the horn.
2. Put the helix on the log-depth axis and relate it to the horn.
3. Go past the frontier while keeping the rigour.
4. Pave the way to an RH proof.

The first two get exact answers. The third gets one genuinely new object — new
to this arc, assembled from century-old parts — with a theorem attached. The
fourth gets what an honest survey can give: a map of where every road ends,
and the one place this pair of figures makes the terrain simpler.

Every number below reproduces with mpmath (25–50 digits) or float64 as noted;
§6 collects them.

---

## 0. Standing disclaimer

**The mathematics here is classical.** The translation identity of §2 is a
regrouping of Riemann's 1859 kernel; the ledgers of §1 are Hadamard 1893 and
Euler 1737 with their logarithmic derivatives reconciled by the explicit
formula; the prime horn of §3 is a smoothed Chebyshev sum, and the boundedness
criterion attached to it is the standard "ψ(x) − x = O(x^{½+ε}) ⟺ RH"
equivalence in a new dress. What is new is the *identification* — that these
are all statements about the two figures this repository has already drawn,
made exact, term by term, with the constants computed. Nothing in this file
moves the wall of rh28 §7, and §5 says so precisely.

---

## 1. Question 1 — the prime helix, and the two ledgers

### 1.1 What the re-weighting changes

[horn-helix.md](horn-helix.md) §6 defined the prime helix — rh3's construction
with one line changed, `r_n = Λ(n)·n^{−σ}` — and §7 showed that at a zero it
has a pole where the horn has a closure. That was pointwise. The full
relationship is *multiplicative*, and it is a symmetry the pointwise picture
hides:

> The helix is a product over the primes. The horn is a product over its own
> closures. The prime helix is the derivative of the first ledger; the closure
> comb is the derivative of the second; and the explicit formula is the
> statement that the two derivative-ledgers differ by an explicit archimedean
> comb.

All three clauses are computations below.

### 1.2 The closure ledger

The horn is entire of order 1, so Hadamard applies: ξ is determined by its
zeros. Its logarithmic derivative, with the zeros paired ρ = ½ ± iγ (the first
150 verified on the line; the tail in the same form), collapses to an
**absolutely convergent** sum:

```
ξ′/ξ(s) = Σ_γ  2(s−½) / ( (s−½)² + γ² )                                    (1)
```

Verified against the direct derivative:

```
  s        direct ξ′/ξ                    ledger: 150 zeros + tail        |diff|
  2        0.06906623153                  0.06906627302                   4.2e−8
  3+2i     0.1164994564 + 0.0902089923i   0.116499249 + 0.0902093933i     4.5e−7
```

The tail past γ₁₅₀ = 318.85 is not estimated — it is **paid exactly by λ₁**:
Σ_γ 1/(¼+γ²) = λ₁ = 1 + γ_E/2 − ½ln 4π = 0.0230957089661 (rh10 §5's
constant), of which the first 150 zeros supply 0.02064233715, leaving
0.00245337 for the tail. And (1) at s = 1 *is* λ₁:

```
ξ′/ξ(1) = Σ_γ 1/(¼+γ²) = λ₁         (numeric: 0.0230957089661, 12 digits)  (2)
```

rh10 §5 called λ₁ "one constant, three dials." Here it is a fourth: the value
of the closure ledger at the pole's old address.

### 1.3 The bridge, exactly

Log-differentiate ξ = ½s(s−1)π^{−s/2}Γ(s/2)ζ and rearrange:

```
−ζ′/ζ(s) = 1/s + 1/(s−1) − ½ln π + ½ψ(s/2) − ξ′/ξ(s)                       (3)
```

Left side: the prime helix's value, Σ Λ(n)n^{−s}. Right side: two pole terms,
an archimedean comb, minus the closure ledger. Verified as an identity to
1e−31 at s = 2 and s = 3+2i, and with the ledger side computed *from the 150
zeros* to 4e−8. This is the explicit formula in coefficient-free form: **the
prime helix equals a smooth comb minus the horn's closure ledger** — every
gear of one figure accounted against every closure of the other, no test
function in sight.

### 1.4 The horn's gears are its closures

The multiplicative statement behind (1): with the zeros on the line,

```
Ξ(t) = Ξ(0) · Π_k ( 1 − t²/γ_k² )                                          (4)
```

— the horn as a *stack of factors, one per closure*, each vanishing at its own
γ_k. This is the exact analogue of the helix's gear decomposition, with the
zeros in the role of the integers. Rebuilt numerically from 150 factors, tail
again paid through λ₁ (Σ_{k>150} 1/γ_k² ≈ λ₁ − Σ₁₅₀, correction < 3e−6
relative):

```
  t     Π₁₅₀           × tail factor    = product      true Ξ(t)/Ξ(0)   rel. err
  5     0.58935449     0.94050878       0.55429307     0.55429185       2.2e−6
  17   −0.0022217324   0.49212405      −0.001093368   −0.0010930514     2.9e−4
```

So the duality of question 1 closes into a chiasm: **the helix multiplies over
primes and diverges into its zeros; the horn multiplies over zeros and, by
(3), differentiates into the primes.** Each figure is built from the other's
spectrum.

### 1.5 Each is the other's resonance

The chiasm is measurable in both directions.

**Primes → zeros** is rh10 §1's instrument: W(t₀), computed from the
arithmetic side alone, peaks at every zero in range
([horn-helix.md](horn-helix.md) §8 re-verified the identity to 1.3e−7).

**Zeros → primes** is computed here: spin the closure comb along the shared
log-depth axis, T(u) = −Σ_{k≤100} cos(γ_k u), and find its peaks on
u ∈ [0.55, 2.35]:

```
  peak u     height    atom       exact u    offset
  0.6930     17.44     log 2      0.6931     −0.0001
  1.0990     23.21     log 3      1.0986     +0.0004
  1.3870     11.90     log 4      1.3863     +0.0007
  1.6095     26.50     log 5      1.6094     +0.0001
  1.9460     26.25     log 7      1.9459     +0.0001
  2.0815      8.60     log 8      2.0794     +0.0021
  2.1965     12.63     log 9      2.1972     −0.0007
```

Seven peaks found; seven prime-power atoms in range; zero spurious peaks;
controls between atoms read −1.7 to +0.6 against peak heights of 9–27. One
hundred closures locate log 2 to four decimals. **The prime helix's gear set
is the horn's resonance spectrum, and the horn's closure set is the prime
helix's** — that sentence is now two tables.

---

## 2. Question 2 — the log-depth axis, and the translation identity

### 2.1 The profile swap, recalled

[horn-helix.md](horn-helix.md) §1: under u = log x the helix's cone becomes
radius `e^{−σu}`, phase `−t·u` — the horn's law with Φ replaced by an
exponential. That was the coordinate answer. Two structural facts sit deeper.

### 2.2 The lift, linearized

rh3 §5's uniform-pitch lift, ϑ̃(x) = (x−1)p − t·log x, transforms to

```
ϑ̃(u) = p·(e^u − 1) − t·u                                                   (5)
```

Read it: **the horn's phase t·u is the helix's torsion term, exactly** — the
change of variable that straightens the cone into the horn straightens the
torsion into the horn's linear winding. What remains, p·(e^u − 1), is the
half-turn carry: the alternation device that makes η converge, exponential on
the log axis, and absent from the horn because the completion factor does its
job without gauge zeros (horn-helix.md §3). The turning ring x* = t/π lands at
u* = log(t/π) = 1.504 at t = γ₁ — numerically at the horn's edge, but this is
a coincidence of γ₁: u* moves with t while the horn's support does not.

### 2.3 The translation identity

The centrepiece of this file. The horn's shells (INTEGERS.md §1) are not
merely *indexed* by the gears — each one **is the first shell, translated to a
gear position and weighted by the critical exponent**. For every n and every u:

```
φ_n(u) = n^{−1/2} · φ₁(u + log n)          exactly                          (6)
hence
Φ(u)   = Σ_{n≥1} n^{−1/2} · φ₁(u + log n)                                   (7)
```

The proof is three lines of algebra on (14) of INTEGERS.md (the n⁴ and n²
prefactors are absorbed as e^{9·log n/2}·n^{−1/2} and e^{5·log n/2}·n^{−1/2});
verified numerically to 1e−41 at n = 2, 3, 5 and u = −1, 0, 0.7.

Read (7) as a construction recipe: **take the σ = ½ helix's gear measure —
atoms at the gear positions, weights n^{−1/2}, the critical taper — and
replace every point-gear by one copy of the archimedean bump φ₁. The result
is the horn.** The horn is not the helix's *successor*; it is the helix at
σ = ½, smeared by the place at infinity. The Fourier side of (7) is the
completion identity ξ = C(s)·ζ(s) itself, with C(s) = ½s(s−1)π^{−s/2}Γ(s/2) =
the two-sided transform of 2φ₁ ([horn-helix.md](horn-helix.md) (5), n = 1) —
legitimate termwise for σ > 1 and by continuation elsewhere; pointwise in u,
(7) converges absolutely everywhere, so the geometric statement needs no
continuation at all.

One honesty note: the exponent ½ in (6) is forced by the kernel's
normalization — it is why ξ(½ + it), not ξ(σ + it), is the transform of an
even weight. It marks the symmetry point of the construction; it is not
evidence about where the zeros are.

### 2.4 The mirror as overlap

On u ≥ 0 the copies in (7) are disjoint in practice — each new gear's bump
arrives double-exponentially attenuated (the hierarchical shells of
INTEGERS.md §1). On u < 0 the copies *overlap*, because translation pushes
every bump leftward across the throat, and φ₁ has a negative lobe (φ₁ < 0 for
u < ½ln(3/2π) ≈ −0.37). At u = −1.5 the first forty copies carry ±0.476276 of
mass each way and cancel to

```
Σ_{n≤40} n^{−1/2}·φ₁(−1.5 + log n) = 6.488395449e−24 = Φ(1.5)     (13 digits)
```

— cancellation to 1.4e−23 of the mass, which is INTEGERS.md §2's
condition-number table *explained*: the functional equation is the statement
that translated copies of one bump, weighted by the critical taper,
reconstruct their own mirror. The theta miracle, drawn as interference of
gear-positioned bumps.

---

## 3. Question 3 — past the frontier: the prime horn

Questions 1 and 2 hand over their parts: a re-weighting (Λ), a shared axis
(u), a translation recipe (7). Assemble them. The construction below is, to
this arc's knowledge, not in its twenty-nine documents nor standard notation
elsewhere — the *machinery* is classical (smoothed explicit formula), the
*object* and its self-referential constants are this directory's.

### 3.1 The construction

Take the **prime helix's** gear measure — atoms at log n, weights
Λ(n)·n^{−1/2} — and smear it with the **horn's own bump**, exactly as (7):

```
Ψ(u) = Σ_{n≥2} Λ(n)·n^{−1/2} · φ₁(u + log n)                                (8)
```

Absolutely convergent everywhere (double-exponential decay), computable in
float64 from a Λ-sieve. The same recipe that produced the horn from the
integers produces Ψ from the primes. Call it the **prime horn**.

It is violently asymmetric. On u > 0 every atom's bump is attenuated through
the throat: Ψ(+2) ≈ 1.9e−292 — the positive side is empty. Everything happens
on u < 0, where the atoms live; write u = −v, v > 0, and watch Ψ(−v) as v
grows.

### 3.2 The silence of the main term

A smeared Chebyshev sum should flare: the prime number theorem puts
ΣΛ(n) ≈ e^v mass under the bump at depth v, and the weight n^{−1/2}
contributes e^{−v/2}, so Ψ(−v) should grow like e^{v/2}·∫φ₁(w)e^{w/2}dw. But
that moment is **exactly zero**:

```
∫ φ₁(w)·e^{w/2} dw = C(1)/2 = 0        (numeric: −1.6e−44)                  (9)
∫ φ₁(w)·e^{−w/2} dw = C(0)/2 = −½      (numeric: −0.5, exact)
∫ φ₁(w)·e^{3w/2} dw = C(2)/2 = 1/2π    (numeric: 0.15915494)
```

(9) vanishes because C(s) carries the factor (s−1) — **the very factor
Riemann inserted to cancel ζ's pole**. The completion that makes ξ entire is,
verbatim, the balance condition that silences the PNT flare in the prime
horn. Nothing was tuned: the horn's own bump arrives pre-balanced.

### 3.3 The ring

With the main term self-cancelled, shift the contour (the standard smoothed
explicit formula; the s = 1 residue is killed by (9), s = 0 is regular, the
first trivial zero sits at s = −2):

```
Ψ(−v) = − Σ_k Re[ C(ρ_k)·e^{iγ_k v} ]  +  O(v·e^{−5v/2})                   (10)
```

A **bounded, almost-periodic signal whose frequencies are exactly the horn's
closure ordinates**, with amplitude ledger |C(½+iγ_k)| — which is shell 1's
transform at each closure, the number 0.0017433 already computed in
[horn-helix.md](horn-helix.md) §4:

```
  k    γ_k           |C(½+iγ_k)|
  1    14.134725     1.743303e−03
  2    21.022040     1.561327e−05
  3    25.010858     9.223475e−07
  4    30.424876     1.849554e−08
  5    32.935062     2.958626e−09
  6    37.586178     9.660343e−11
                     Σ₁₀ = 1.759860e−03
```

The first mode is 99.1 % of the total: **the prime horn is a nearly
monochromatic sinusoid at frequency γ₁ = 14.134725…** Computed from the
primes alone (Λ-sieve to 170 000) against the ring predicted from ten zeros:

```
   v     Ψ(−v) from primes    ring from closures    difference
   1     +3.49128739e−01      +1.70992701e−03       +3.5e−01
   2     +1.09500025e−01      +2.97446138e−04       +1.1e−01
   3     +1.31264748e−02      −1.72701268e−03       +1.5e−02
   4     +1.36049315e−03      −2.99245245e−04       +1.7e−03
   5     +1.90449629e−03      +1.73293969e−03       +1.7e−04
   6     +3.05494473e−04      +2.88526437e−04       +1.7e−05
   7     −1.72022735e−03      −1.72185686e−03       +1.6e−06
   8     −2.93567986e−04      −2.93721171e−04       +1.5e−07
   9     +1.70184913e−03      +1.70183496e−03       +1.4e−08
```

The near field (v ≲ 4, where only a handful of atoms sit under the bump)
decays into the ring at almost exactly a factor 10 per unit — the
(a·v+b)e^{−5v/2} of (10)'s double pole at s = −2 — and by v = 9 the primes
reproduce the ten-zero prediction to **eight decimal places**. The global
maximum of |Ψ| is 0.349133, at v = 1.002, in the near field; the eventual
oscillation amplitude is Σ|C| ≈ 0.00176.

**The near field, exactly.** That last column is not a leftover: both
constants are residues, so both are closed forms. At s = −2, Γ(s/2) has a pole
and ζ its first trivial zero, so the integrand of (10) has a *double* pole
there, and expanding it gives

```
Ψ(−v) − ring(v) = (a·v + b)·e^{−5v/2} + O(e^{−9v/2}),                       (10′)
a = 3π = 9.4247779608,
b = 3π·ζ″(−2)/(2ζ′(−2)) − (3π/2)(γ_E + 2/3 + ln π) = −1.0781069034
```

(using ζ′(−2) = −ζ(3)/4π² = −0.0304484571, ζ″(−2) = −0.0657635162). Dividing
the difference column above by that curve:

```
  v        1        2        3        4        5        6        7        9
  ratio  0.5071   0.9120   0.9875   0.9983   0.99977  0.99997  0.999996 1.000000
```

The approach to 1 is itself measured: the shortfall falls by a factor 7.4 per
unit of v, which is e^{−2v} — exactly the next trivial zero, at s = −4,
entering as e^{−9v/2} against the envelope's e^{−5v/2}. Past v ≈ 10 the ratio
stops meaning anything in float64: the difference is then 1e−10 extracted from
a sum whose absolute mass is ~10², so seven digits are already gone.

So the difference column is a *predicted* quantity, and §3.3 is a two-sided
check: the ring tests the non-trivial zeros, the residual tests the trivial
ones.

The primes, smeared by the horn's own bump, ring the first zero — at an
amplitude equal to the first shell's transform at that closure, at a frequency
the sieve has no visible access to. This is the "music of the primes" with
every constant identified inside the two figures of this directory.

### 3.4 The criterion

**Claim. RH ⟺ Ψ is bounded on ℝ.**

*Forward (RH ⇒ bounded).* On the line, |C(½+iγ)| decays like the Γ-factor,
e^{−πγ/4}·poly, so Σ_k |C(ρ_k)| < ∞ and (10) converges absolutely and
uniformly: sup|Ψ| ≤ near-field max ≈ 0.35.

*Converse (bounded ⇒ RH).* Let L(z) = ∫₀^∞ Ψ(−v)e^{−zv} dv. Splitting each
atom's integral at its own position gives, for Re z > ½,

```
L(z) = (−ζ′/ζ)(z+½) · C(z+½)/2  −  E(z),        E entire                   (11)
```

(the correction E is Σ Λ(n)n^{−½−z}∫_{log n}^∞ φ₁e^{zw}dw, double-
exponentially convergent for every z). The right side is meromorphic with a
pole at z = ρ − ½ for every zero ρ (C(ρ) ≠ 0 since Γ has no zeros and
ρ ≠ 0, 1). If Ψ is bounded, L is analytic on Re z > 0, so no zero has
β > ½; by the functional-equation pairing ρ ↔ 1−ρ, none has β < ½ either. ∎

Label, honestly: this equivalence is the classical "smoothed ψ-error ⟺ RH"
statement — the machinery would work for many bumps. What φ₁ specifically
buys: the main term cancels *automatically* by (9) rather than by
subtraction; the amplitudes are summable, so boundedness (not
boundedness-after-regularization) is the criterion; and every constant in the
statement is already an object in this directory.

So the figure suite closes:

> The horn closes only when untilted (README §5). The prime horn never flares
> only if every closure is on the line. One criterion per figure, both
> equivalent to RH, joined by the ledger of §1.

### 3.5 Three remarks at the boundary

**Two monoids.** The helix's gear set {log n} is the free abelian monoid on
{log p} — arithmetic's whole content is that its atom set is *free*. The
horn's gear set {γ_k} is, on all evidence (rh8, Montgomery), spectrally
*rigid* — GUE-repelled, nothing free about it. The Fourier transform along
the shared axis exchanges a free system for a rigid one; §1.5 is that
exchange measured. No theorem here — a frame worth having when choosing what
to draw next.

**The adelic completion.** Shell 1 is the Euler factor at infinity
(horn-helix.md §9). The finite places enter Ψ only as atoms — un-smeared,
un-completed. A construction in which *every* place contributes its own
"bump" symmetrically is precisely the adelic/trace-formula program of the
three Connes papers shelved in this directory; the horn is its archimedean
slice, and this file's pairings are the abelian shadow of that trace formula.
— **taken up in [horn-helix-adelic.md](horn-helix-adelic.md)**, which converts
the whole horn/helix structure place by place and answers the symmetric-bump
question in the negative: the finite places are discrete and self-dual, so
smearing has no p-adic analogue and Ψ is necessarily hybrid. What that file does
build is the Weil ledger split by place, reproducing
[positivity-generator.md](positivity-generator.md)'s E(0) and E(10) to 21 digits
one place at a time.

**The derivative tower.** Under RH, Ξ ∈ LP and the Laguerre–Pólya class is
closed under differentiation: every Ξ^{(m)} — the horn re-weighted by u^m —
is real-rooted, with interlacing. The Jensen/Turán certificates of
POSITIVITY.md and INTEGERS.md §5 are finite windows onto exactly this tower.

---

## 4. Question 4 — paving the way, without pretending

There is no route here to a proof, and the arc has already measured why
(rh28/rh29: the certified positivity floor decays worse than any power law).
What a survey *can* do is state where every known road ends, in this
vocabulary, and what the present pair of figures genuinely simplifies.

### 4.1 The map

Every live criterion, its geometric reading here, and where its unbounded
quantifier hides:

| criterion (RH ⟺ …) | in this geometry | the quantifier | measured frontier in this arc |
|---|---|---|---|
| Weil positivity: W(h) ≥ 0 ∀ h = \|f̂\|² | the prime comb paired against every window on the shared axis | all test functions (infinite-dimensional cone) | rh10 §1 instrument; rh19–rh27a certified floors; rh28/29: floor decays worse than power law |
| Li: λ_n ≥ 0 ∀ n | the closure carousel on the rim; λ₁ anchors §1's ledgers | all n | rh10 §2: n ≤ 24, two computations agree to 1.0001 |
| Laguerre–Pólya / Jensen: every J^{d,n} hyperbolic | the horn's silhouette moments, log-concavity in the mouth | all (d, n); per-d exceptions finite (GORZ) but not uniformly | INTEGERS.md §5: certified d ≤ 6, n ≤ 30; margins flat; the gap is uniformity in d |
| Beurling–Nyman / Báez-Duarte: d_N → 0 | translation-completeness of dilates on the log axis — the same skeleton as (7) | the N → ∞ limit | rh10 §4: d₂₀²·ln 20 = 0.0482 vs conjectured 2λ₁ = 0.0461914 |
| de Bruijn–Newman: Λ = 0 | the horn fattened by e^{λu²}, at its threshold | the flow's whole time axis | rh10 §3: collision at λ* = −0.9885; Rodgers–Tao Λ ≥ 0 |
| **this file**: sup\|Ψ\| < ∞ | the prime horn never flares | all v (almost-periodicity: no finite range decides) | §3.3: ring locked to 1.4e−8 at v = 9; sup 0.349 in the near field |

### 4.2 Where every road ends

§4.1 reads the live criteria in this geometry. The wider question — where does
*every* known road end — has four different kinds of answer, and they are worth
separating, because "open" covers three of the four and means something
different in each.

The literature rows below are citation, not computation: the arc has verified
none of them and is reporting each road's own published terminus. Only the rows
marked ‡ are this directory's own measurements.

**A. The road that arrives — over a different base.**

RH is a *theorem* for function fields: Weil 1948 for curves over 𝔽_q, Deligne
1974 for smooth projective varieties. It does not transport, and the reason is
structural rather than technical. Weil's proof is intersection theory on the
surface C × C: correspondences, the Hodge index theorem, and the positivity of
the self-intersection of a correspondence. All of it needs a base field for the
product to exist over. Spec ℤ is not a product of anything, and "Spec ℤ ×_{𝔽₁}
Spec ℤ" names the missing object rather than supplying it — which is what
Deninger's foliated dynamical system and Connes–Consani's arithmetic site are
programmes *for*. Where the adelic route has been pushed furthest it ends at a
positivity statement at the archimedean place (Connes–Consani —
`connes-consani-weil-positivity-archimedean.pdf`, one of the three papers
shelved here), and that statement is about §1.3's archimedean
comb: the exact term this file computes term-by-term and does not bound. So
road A and the top row of §4.1 are one terminus wearing two coordinate systems.

**B. Roads closed by counterexample.**

| statement | would have given | killed by |
|---|---|---|
| Mertens: \|M(x)\| ≤ √x | RH + simple zeros | Odlyzko–te Riele 1985 — existence only; no explicit counterexample is known to this day |
| Pólya: L(x) = Σ λ(n) ≤ 0 for x ≥ 2 | RH | Haselgrove 1958; least counterexample 906 150 257 (Tanaka 1980) |
| Turán: Σ_{n≤N} n^{−s} zero-free in σ ≥ 1 for large N | a quasi-RH | Haselgrove 1958 |
| de Branges' positivity conditions | RH | Conrey–Li 2000 |
| functional equation + growth, without an Euler product | RH for the whole class | Davenport–Heilbronn 1936 (and Potter–Titchmarsh's Epstein zetas): a Riemann-type functional equation with infinitely many zeros off the line |

The last row is [README.md](README.md) §8.3 — "the tilt argument would look
identical for a counterexample if one existed" — proved, in the literature's
own hands, thirty years before the arc restated it. Nothing in the horn, the
helix, or Ψ's construction sees an Euler product; §3's Λ-weighting is the only
place in either figure where one enters, and it enters as a weight, not as a
structure.

The reading the five share: **every convenient strengthening of RH that anyone
proposed is false.** RH is true with no margin, and that is now measured from
two sides — Λ ≥ 0 (Rodgers–Tao) says the zeros are only just real, and
Selberg's central limit theorem for S(T), variance ~ (1/2π²)·log log T, says no
eventual regularity is available either. A road that would prove more than RH
ends in a counterexample. Five data points, and it is the closest thing this
subject has to an empirical law.

**C. Roads that are open, quantified, and short.**

| road | best unconditional | RH needs | the gap |
|---|---|---|---|
| zero-free region | σ > 1 − c/((log t)^{2/3}(log log t)^{1/3}) — Vinogradov–Korobov 1958 | σ > ½ | the *shape* has not improved in 68 years; only the constant has moved |
| proportion on the line | ≥ 5/12 = 41.7 % — Pratt–Robles–Zaharescu–Zeindler 2020 | 100 % | mollifier length: Conrey's θ = 4/7 is a Kloosterman-sum bound, and 100 % needs θ → ∞ |
| zero density N(σ,T) | T^{30(1−σ)/13 + o(1)}, σ ≥ 3/4 — Guth–Maynard 2024, the first gain on Ingham 1940 | N(σ,T) = 0 | density estimates bound exceptions; no such estimate can empty a strip |
| Lindelöf exponent μ(½) | 13/84 — Bourgain 2017 | 0, and LH is *weaker* than RH | ¼ → 13/84 in a century, on the lesser statement |
| verified height | \|t\| ≤ 3.0000175×10¹² — Platt–Trudgian 2021 | all t | measure zero, exactly as the arc says of its own nine points |
| de Bruijn–Newman Λ | 0 ≤ Λ ≤ 0.2 — Rodgers–Tao 2020, Platt–Trudgian 2021 | Λ ≤ 0 | the interval can now only close from above onto a point; the slack the search was built to exploit is gone |
| Jensen uniformity | per-d asymptotics (GORZ 2019); certified d ≤ 6, n ≤ 30 ‡ | all (d, n) | uniformity in d — §4.4 item 2 |
| Beurling–Nyman d_N | no unconditional rate at all | d_N → 0 | the conjectured constant 2λ₁ = 0.0461914 is matched to 4 % at N = 20 ‡ and proves nothing |
| Weil positivity, certified | nine certified points ‡ (rh19–rh27a) | the whole cone | rh30 §7: a certificate's reach grows like n^{1.2}, so seeing as high as the zeros are *already known* to be on the line needs n ≈ 1.8×10¹⁰ against the n = 601 computed |

Every row carries a number, and in every row the number is not close. The last
is the only one this arc can move, and rh30 §7 is the price of moving it.

**D. Roads that are open and not quantified.**

Hilbert–Pólya has no operator: Berry–Keating's xp is a heuristic, and the
self-adjointness of the proposed realizations is not established. Random-matrix
theory is statistics without a mechanism — Montgomery's pair correlation is
conditional on RH in its proof and describes the zeros *given* that they are on
the line; rh39 §3 registered a random-matrix prediction in advance on this
arc's own material and had it refuted by its own measurement, with the
direction of failure pointing at rigidity. The adelic programme is A, unfinished.
And this file's criterion joins them: sup\|Ψ\| < ∞ has no finite scan that
decides it (§4.3). These roads do not end at a number. They end at a missing
object.

**The common terminus.** Sort every road by what its last step actually needs
and they collapse into two:

> **(i) a positivity quantified over a family with no known finite generating
> structure** — §4.1's Weil, Li and Jensen rows, road A's archimedean
> statement, and every certificate in this arc; or
> **(ii) a uniformity in a parameter that the method loses to** — the d of
> Jensen, the θ of mollifiers, the ε of a growth bound, the depth n of a
> certificate.

This directory's own ten-document experiment on (i) is the sharpest local
account of what that terminus is made of, and every step of it is a road
ending: rh31's localisation conjecture (λ_min ≥ c·C_n(μ), measured c = 1/1.81)
refuted by construction in rh32; rh32's remaining quadrature step shown by rh33
to be an *identity* rather than a step, so there was never a gap there to
close; rh34 finding that five documents had measured the wrapped, aliased
matrix and reopening the lemma on the unwrapped Gram; rh35 refuting it there
too, closing the line of attack from the inside; and rh36 finally naming the
object being bounded — the zeta partial sum on the critical line, read at the
zeros — with the verdict that a floor for it uniform in the ladder length *is
asking for something false*. Then rh37 §7 and rh39 §4 arrive from opposite
directions at the same missing lemma: an inequality that binds many atoms
jointly rather than one at a time. rh30 §10 (a) — prove the collapse, the only
statement this arc has ever had with the logical shape a conjunction needs —
has been open for nine documents and is unmoved at rh39.

That is where this road ends, and it is a specialisation of (i), which is why
none of §3's construction reaches it. The prime horn moves neither (i) nor
(ii). §4.3 states precisely what it does move.

### 4.3 What the pair actually contributes

Three things, none of them a proof, all of them pavement.

**The stage is now bounded and shared.** README §6 made the horn's side
decidable from |u| ≤ 1.5; §1–§3 here put the primes, the zeros, and both
ledgers on the *same* axis with the atoms identified and every pairing
verified to stated precision. A future argument in this geometry has no
translation costs left to pay.

**The statement is now one-dimensional.** Weil positivity quantifies over an
infinite-dimensional cone of test functions; sup|Ψ| < ∞ quantifies over one
real variable. That is a genuine structural compression of the *statement* —
and none of the *difficulty*: the quantifier over h became a quantifier over
v. Moved, not removed. Any finite scan of Ψ (§3.3 included) proves exactly
nothing, because a bounded-looking almost-periodic signal betrays an off-line
zero only through a term e^{(β−½)v} that can hide below the ring for
arbitrarily long. The honest gain is that "where the proof must bite" is now
a growth statement about one explicit function with summable, computed
spectral data — the kind of object about which uniform statements
(almost-periodicity theory, mean-value bounds) at least have a language.

**Positivity has a home address.** Combining the ledgers: RH ⟺ the closure
measure Σ δ_γ is the spectrum of the prime comb minus the archimedean comb
(§1.3), and Weil's criterion says the obstruction is exactly the possible
failure of positive-definiteness of that difference. The wall of rh28/29 is
not one bad estimate; it is that this positive-definiteness is being
certified window-by-window against a cone with no known finite generating
structure. Every route in the map above hits the same object wearing a
different coordinate.

### 4.4 Smallest sufficient statements

For the record — the minimal new theorems that would finish it, each stated
in this file's terms, none within reach by these methods:

1. **A growth bound**: Ψ(−v) = O(e^{εv}) for every ε > 0, proved from the
   sieve side. (Equivalent to RH by §3.4. All unconditional prime-side
   methods lose at least a zero-free-region factor; this is the classical
   barrier, restated, not weakened.)
2. **A uniformity**: the number of Jensen exceptions at degree d is bounded
   uniformly in d (closes the GORZ gap; INTEGERS.md §5).
3. **A completeness rate**: d_N² log N → 2λ₁ with an effective error
   (Báez-Duarte with rates; would give zero-free regions converging to the
   line).
4. **A positivity generator**: a finite (or finitely-generated) family of
   test functions whose Weil-positivity implies it for the whole cone. (rh8
   §6 is the statement that no such basis is currently known; this is the
   wall itself.) — **taken up in
   [positivity-generator.md](positivity-generator.md)**, which splits the item
   in two: *finitely generated* is delivered (one Gaussian window and the
   translation group; RH ⟺ one explicit kernel is positive-definite), and
   *finite* is refuted (a family with a positive floor is blind above a
   computable height, so a generating family has no margin at all).

### 4.5 Build list

In order of payoff, in the style of INTEGERS.md §6:

1. `[x]` **Draw the prime horn.** Built: **[prime-horn.html](prime-horn.html)**.
   Two panels: Ψ(−v) from a live Λ-sieve against the ring from K closures on a
   linear axis, with the 2π/γ₁ = 0.444521 grid drawn so the sieve's peaks can
   be seen landing on it; and log₁₀|·| over the whole range, where the residual
   Ψ − ring lies on the exact envelope (10′) for ten decades. Sliders for K, for
   the sieve cutoff N, for the window, and a cursor whose readout is the §3.3
   row — all of §3.3 and the ledger recomputed in float64 in the browser, no
   stored data. Two things the figure adds beyond the spec: the *cancelled
   mass* overlay (Σ Λ(n)n^{−1/2}|φ₁| ≈ 0.462 e^{v/2}, so v = 11 is a
   6.6e+4 : 1 cancellation — the prime horn's answer to INTEGERS.md §2's
   condition-number table), and the sieve's exhaustion left visible as a shaded
   band past v = ln N − 1.5 rather than clipped. This is the arc's first figure
   in which *the primes visibly oscillate at γ₁*.
2. `[ ]` **The two resonance scans side by side.** rh10's W(t₀) (primes → zeros)
   and §1.5's T(u) (zeros → primes) on facing axes, peak tables printed. The
   chiasm of §1.4, drawn.
3. `[ ]` **The translation peel.** The horn's shells rendered as translated copies
   of one bump per (7) — a slider sweeping n peels bump after bump off the
   silhouette; on the mirror side, the same copies shown overlapping and
   cancelling (±0.476 → 6.5e−24 at u = −1.5).
4. `[ ]` **The ledger readout.** ξ′/ξ(s) from (1) with a zeros-used counter, next
   to −ζ′/ζ(s) from the sieve, their difference converging to the archimedean
   comb of (3).
5. `[ ]` **Certify (9) and the ring amplitudes in interval arithmetic** — small,
   finished artefacts in the rh19–27a style: an enclosure of ∫φ₁e^{w/2}
   containing 0, and enclosures of |C(ρ_k)| for k ≤ 10.

---

## 5. What this does not do

**1. It proves nothing and moves no wall.** Every equivalence used is
classical; the certified-floor decay of rh28/29 applies to this file's
pairings verbatim. §4.3's compression changes the shape of the statement, not
the depth of the obstruction.

**2. The prime horn's boundedness cannot be checked.** §3.3's agreement to
1.4e−8 is consistency, not evidence: an off-line zero at height 10⁶ would
leave every row of that table untouched. The criterion's value is
formulation, not falsification.

**3. The translation identity is a regrouping.** (6)–(7) are exact and
elementary; their content is identification of this repo's two figures, not
new structure in ζ. Anyone tempted to see the σ = ½ in (6) as evidence for RH
should reread §2.3's honesty note: it is the transform's centring, full stop.

**4. The survey of §4.2 is second-hand.** Every road end there except the ‡
rows is reported from the literature, not checked here; the dates and constants
are as published and will age. A map of terminal points is orientation for
choosing what to build next — it is not a result, and the only rows this
directory can move are the two it measured.

**5. The creative frame stays a frame.** "Free monoid vs rigid spectrum" and
the adelic remark of §3.5 name programs (Connes–Consani) that are exactly as
unfinished as RH itself. They are included as orientation, not as progress.

---

## 6. Verified numbers

mpmath 25–50 digits except the Ψ table (float64, sieve to 170 000; one row
cross-checked in mpmath).

| quantity | value |
|---|---|
| translation identity (6), n = 2,3,5, u = −1, 0, 0.7 | residual ≤ 1.3e−41 |
| mirror overlap at u = −1.5: mass each way / sum | ±0.476276 / 6.488395449e−24 = Φ(1.5), 13 digits |
| ∫φ₁e^{w/2} (the PNT-flare moment) | −1.6e−44 ≈ 0 = C(1)/2 |
| ∫φ₁e^{−w/2}, ∫φ₁e^{3w/2} | −0.5 = C(0)/2, 0.15915494 = 1/2π = C(2)/2 |
| λ₁ = 1 + γ_E/2 − ½ln 4π | 0.0230957089661 |
| ξ′/ξ(1) numeric | 0.0230957089661 (= λ₁, 12 digits) |
| Σ_{k≤150} 1/(¼+γ_k²) / tail paid by λ₁ | 0.02064233715 / 0.00245337 (γ₁₅₀ = 318.8531) |
| ledger (1) at s = 2 | 0.06906627302 vs direct 0.06906623153 (4.2e−8) |
| ledger (1) at s = 3+2i | diff 4.5e−7 |
| bridge (3) at s = 2 and 3+2i | identity to ≤ 1e−31; −ζ′/ζ(2) = 0.569960993094533 |
| Hadamard (4) at t = 5 / t = 17 | rel. err 2.2e−6 / 2.9e−4 (150 factors + λ₁ tail) |
| T(u) peaks, 100 zeros | 7 peaks ↔ 7 atoms, offsets ≤ 0.0021, no spurious |
| \|C(½+iγ₁)\| … \|C(½+iγ₆)\| | 1.743303e−3, 1.561327e−5, 9.223475e−7, 1.849554e−8, 2.958626e−9, 9.660343e−11 |
| Σ₁₀ \|C(ρ_k)\| / γ₁-mode share | 1.759860e−3 / 99.1 % |
| Ψ(−9) primes vs ring | 1.70184913e−3 vs 1.70183496e−3 (1.4e−8) |
| near-field decay | ≈ ×10 per unit v; (10′) exactly, a = 3π, b = −1.0781069034 |
| (10′) residual / envelope, v = 5, 7, 9 | 0.99977, 0.999996, 1.000000 (shortfall ×7.4 per unit = e^{−2v}) |
| ζ′(−2), ζ″(−2) | −0.0304484570584 (= −ζ(3)/4π²), −0.0657635161874 |
| cancelled mass ΣΛ(n)n^{−1/2}\|φ₁\| at v = 11 | 1.1318e+2 → Ψ = 1.7e−3, a 6.6e+4 : 1 cancellation |
| global sup \|Ψ\| | 0.349133 at v = 1.002271 |
| Ψ(+2) | 1.9e−292 |
| 2λ₁ (Báez-Duarte constant) | 0.0461914179 (rh10 §4 measured 0.0482 at N = 20) |

---

## 7. Dictionary

New terms; folded into [../dictionary.html](../dictionary.html) and README
§10 per the repo rule.

| term | meaning |
|---|---|
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

---

*Companions: [horn-helix.md](horn-helix.md) (the first pass),
[README.md](README.md) (the horn), [../rh3/README.md](../rh3/README.md) (the
helix), [INTEGERS.md](INTEGERS.md) (the shells),
[../rh10.html](../html/rh10.html) (the four instruments). The wall it does not
move: rh28 §7.*
