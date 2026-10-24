# The horn and the helix — one construction, two sides of the Mellin transform

Answers to two questions asked of [README.md](README.md) (the Ξ horn) and
[../rh3/README.md](../rh3/README.md) (the helix):

1. What is the relationship between them?
2. Can one represent the RH zeros and the other the primes?

Both answers are computed, not asserted. Every number below reproduces at 25–40
decimal digits with mpmath; the table in §10 collects them.

---

## 0. Standing disclaimer

Nothing here is new mathematics either. §2–§3 are Riemann 1859 read backwards;
§7 is the logarithmic derivative; §8 is the Riemann–Weil explicit formula, which
[rh10](../html/rh10.html) §1 already implements and verifies. What is new is only
that the two *figures* in this repository are shown to be the same figure, and
that the question "which one has the primes" is given a definite answer instead
of an atmosphere.

The short version, for anyone not reading further:

> The horn is the helix after a Mellin transform and a completion. The helix
> draws the **integers**, not the primes — but re-weight its gears from n^{−σ}
> to Λ(n)·n^{−σ} and it draws the primes exactly, on the same levels. Do that
> and you get the pair you wanted: the horn closes at each zero, and the prime
> helix has a pole there. They are not two pictures of one thing; they are the
> two sides of the explicit formula, which is the only thing that joins them.

---

## 1. The same law, two radial profiles

Both objects are: **a radius, a phase proportional to a depth coordinate, and a
sum or integral along that depth.**

The helix (rh3 §3–§4, §7), with half-turns off — the un-alternated ζ train:

```
radius r_n = n^{−σ}     phase ρ_n = −t·log n     depth z_n = n − 1
value  Σ_{n≥1} r_n·e^{iρ_n} = Σ n^{−s} = ζ(s)                              (1)
```

The horn (README §3, §4):

```
radius ρ(u) = Φ(u)      phase θ(u) = t·u         depth u ∈ ℝ
value  2∫_{−∞}^{∞} Φ(u)·e^{itu} du = ξ(½ + it)                             (2)
```

These look different only because the helix's depth axis is the place-value
index *n* while its phase is proportional to log *n*. Put the helix on a
**log-depth axis**, u = log x — which is exactly the substitution README §3
already uses for the throat ("u = 0 is x = 1 under u = log x") — and rh3's cone
`r(x) = x^{−σ}, depth x − 1` becomes

```
radius e^{−σu}          phase −t·u              depth u ∈ [0, ∞)           (3)
```

which is (2) with `Φ(u)` replaced by `e^{−σu}`. (The sign of the phase is the
conjugation convention: rh3's thread matches the horn's **−u** sheet.)

**So the relationship, geometrically, is one line:** the helix and the horn are
the same conical logarithmic spiral on the same log-depth axis, with two
different radial profiles —

| | profile | support | behaviour |
|---|---|---|---|
| helix | e^{−σu} | u ≥ 0 only | not integrable — the sum diverges for σ ≤ 1 |
| horn | Φ(u) | u ∈ ℝ, even | double-exponentially small both ways |

Everything else in README §3's four-difference table (extent, sheets, throat,
discreteness) follows from that single swap of profile. The swap is not
cosmetic; §2 says exactly what it is.

---

## 2. Shell *n* is gear *n* — the correspondence, term by term

[INTEGERS.md](INTEGERS.md) §1 decomposes the horn into integer shells,

```
Φ(u) = Σ_{n≥1} φ_n(u),  φ_n(u) = (2π²n⁴e^{9u/2} − 3πn²e^{5u/2})·e^{−πn²e^{2u}}  (4)
```

Those shells are not merely *indexed* by the same integers as the helix's
levels. They **are** the helix's levels, transformed. For every *n* and every *s*:

```
2 ∫_{−∞}^{∞} φ_n(u)·e^{(s−½)u} du  =  ½·s(s−1)·π^{−s/2}·Γ(s/2) · n^{−s}    (5)
```

Verified — the left side by quadrature, the right in closed form:

```
  s              n    left side of (5)                     rel. error
  2              1     0.3183098862                        0
  2              2     0.07957747155                       0
  2              3     0.03536776513                       2.0e−41
  ½ + iγ₁        1     0.0002740802466 + 0.001721623049i   2.0e−30
  ½ + iγ₁        2    −0.0006237468371 − 0.001063246366i   1.1e−29
  ½ + iγ₁        3     0.00002164466049 − 0.001006263788i  3.2e−29
  0.3 + 5i       1     0.3507495077 − 0.1516325152i        9.7e−30
  0.3 + 5i       2    −0.2308335143 + 0.2074888i           4.8e−29
  0.3 + 5i       3     0.2550137862 + 0.1024706948i        1.2e−28
```

Read (5) right to left: **the n-th gear of the helix, `n^{−s}`, dressed by the
completion factor `½s(s−1)π^{−s/2}Γ(s/2)`, is the n-th shell of the horn.** That
is the whole relationship in one identity. It is Riemann's 1859 derivation —
`∫₀^∞ e^{−πn²x}x^{s/2−1}dx = π^{−s/2}Γ(s/2)n^{−s}` — with the horn's variable
`x = e^{2u}` and the s(s−1)/2 from the two integrations by parts that turn ω
into Φ.

Two consequences worth stating separately.

**(a) The shells are the gears, so "the integers are gone" is wrong** — README
§8.1 overstates its own caution. INTEGERS.md §1 already showed the shells are
separable and computable; (5) shows *which* helix level each one is. The
correction to make in README §8.1 is not that the integers survive — it is that
they survive **individually and identifiably**, one shell per gear.

**(b) The correspondence is exact term by term and useless summed.** Sum (5)
over *n* at σ = ½ and you recover the divergent ζ series. The partial sums grow
like `√N/|1−s|`, exactly rh3 §9's un-alternated train:

```
   N        |Σ_{n≤N} shell transforms|    |completion|·√N/|1−s|
   1        0.0017433032                  0.00012325768
   4        0.00040479596                 0.00024651537
   100      0.0012366747                  0.0012325768
   10⁴      0.012326077                   0.012325768
   10⁵      0.038977599                   0.038977502
                                          ξ(½ + iγ₁) = 1.09e−18
```

Five-digit agreement with the predicted law by N = 10⁴, heading to infinity,
while the object it is supposed to compute is zero. **The horn's convergence
does not come from the shells.** It comes from doing the *u*-integral of the
whole sum, where Poisson summation folds the divergent tail into the mirror.
That is INTEGERS.md §2's cancellation table seen from the other side: the
23 digits that collapse at u = −1.5 are the 10⁵ gears that never converge.

---

## 3. What the transform moves

Same object, so nothing is created — but four things change address.

| | helix | horn |
|---|---|---|
| **σ lives in** | the radius: a taper, r_n = n^{−σ} | the **tilt**: t_i, with σ = ½ − t_i |
| **σ = ½ is** | one taper value among many, unmarked | the fixed point of the mirror — dead centre of the slider |
| **the functional equation is** | absent; s ↔ 1−s is not a motion of the figure | the mirror plane through the throat |
| **divergence is fixed by** | half-turns — the factor 1 − 2^{1−s} | the completion — Γ(s/2)π^{−s/2} |
| **cost of that fix** | gauge zeros at 1 + 2πik/log 2 (rh3 §9) | none; ξ is entire with no spurious zeros |
| **truncation** | \|P_N − η\| → N^{−σ}/2; N ≳ 2.5×10³¹ to decide at 1e−16 | ∫_{1.5}^∞ Φ ≈ 1e−19 from a bounded picture |

The first two rows are the substantive ones and they are the same row. In the
helix nothing distinguishes σ = ½ — that is why rh3 can draw a closure at
σ = 0.8 (|η| = 0.44612, the miss) without the figure objecting on principle.
Completion moves σ out of the radius and into the symmetry, and once it is in
the symmetry, ½ is *structurally* the special value: it is where the mirror is
a mirror. RH stops being "the taper happens to be ½" and becomes "the object
only closes when it is symmetric."

That is the honest reason to prefer the horn, and it is a different reason from
the truncation argument of README §6.

---

## 4. The zeros are interference between shells — rh3 §6's trap, avoided

rh3 §6 states the trap:

> replace the sum over circles by the integral over the cone and the value
> becomes a product of Γ-factors and exponentials, which has no zeros.

The horn is that integral. So does the horn fall into rh3's trap?

No, and (5) says exactly why. Set n = 1 in (5): **shell 1 of the horn
transforms to the completion factor alone**, `½s(s−1)π^{−s/2}Γ(s/2)`, which is
zero-free in the strip (Γ has no zeros anywhere; the s(s−1) supplies only s = 0
and s = 1). At the first zero:

```
  shell 1 alone at ½ + iγ₁  =  0.00027408025 + 0.0017216230i    |·| = 0.0017433
  all shells                =  1.09e−18
```

Shell 1 is rh3's smeared cone, drawn: one archimedean profile, no arithmetic, no
zeros. The horn escapes the trap because **it is not one cone — it is the
integer-indexed family of cones, shell *n* being shell 1 dilated by *n***
(x → n²x, which is what (5) transforms into n^{−s}). The zero at γ₁ is 0.0017
of destructive interference between dilates.

This is the sharp form of rh3 §6's own warning ("every closure is an
interference effect of the integer lattice") and the sharp answer to README
§8.1. The picture is smooth, the lattice is intact, and the zeros are made of
the lattice — visibly, with the residual computed.

---

## 5. Question 2, first half: the helix does **not** draw the primes

The tempting mapping is "horn = zeros, helix = primes." The first half is right
(§6); the second is wrong, and it is worth being precise about why, because the
error is structural rather than cosmetic.

The helix's levels are `n = 1, 2, 3, …` with **equal status**. Level 4 is not
drawn as level 2 twice; level 6 is not drawn as levels 2 and 3 combined.
Multiplicativity — the entire content of "prime" — is not a motion, a symmetry,
or a marking anywhere in rh3's construction. rh3 §8 makes this explicit from the
other direction: the value is digit-independent, `val(k-th string) =
e^{ikπ/6}·η(s)`, so the figure's whole symmetry group is a rigid rotation of the
clock. Nothing in it multiplies.

The prime-side object is the Euler product, and it is a **different figure**: one
gear per prime, each gear an infinite sub-helix of its own powers,
`(1 − p^{−s})^{−1} = Σ_{k≥0} p^{−ks}`. It converges only for σ > 1 — and that
is the obstruction, not a technicality:

```
  partial Euler product ∏_{p≤P}(1 − p^{−s})^{−1} at s = ½ + iγ₁,
  where ζ(s) = 6.3e−16:

    P = 10        0.21470184
    P = 10²       0.11519899
    P = 10³       0.06113618
    P = 10⁴       0.022828956
    P = 10⁵       0.013084262

  control at s = 1.5 + iγ₁ (inside the region of convergence):
    ∏_{p≤10⁵} = 0.5443977716   vs   ζ = 0.5444038328   (6 digits)
```

At σ = 1.5 the product converges to ζ and would show a zero if there were one.
At σ = ½ it wanders down at about 0.30 decades per decade of *P*, irregularly;
extrapolating that rate to 1e−16 wants **P ~ 10⁵³ primes**, which is the helix's
2.5×10³¹ gears again, worse. (Stated as an order of magnitude only: the sequence
is oscillatory, and partial Euler products at σ = ½ are delicate — no limit is
claimed here.)

**So the prime figure and the zero figure cannot be drawn in the same region of
the plane.** That is the real reason "one shows primes, the other shows zeros,
compare them in the picture" fails, and no amount of redrawing fixes it.

---

## 6. Question 2, second half: what *does* draw the primes — one re-weighting

The primes are nevertheless one derivative away, and the derivative costs the
helix nothing structurally.

```
−ζ′/ζ(s) = Σ_{n≥2} Λ(n)·n^{−s},    Λ(n) = log p if n = p^k, else 0        (6)
```

This is a Dirichlet series on the **same levels** as (1), so it is drawable as
rh3's figure with one line changed:

```
  the prime helix:   r_n = Λ(n)·n^{−σ}     ρ_n = −t·log n     depth  n − 1
```

Every gear whose level is not a prime power has radius **zero**. What remains is
a helix of gears at n = 2, 3, 4, 5, 7, 8, 9, 11, 13, 16, … — the primes and
their powers, sitting at the same depths, turning at the same rate, with the
composites collapsed to the axis. Nothing else about rh3's construction changes:
same ledger, same lift, same spines.

Its radii, on the critical line (σ = ½), are:

```
   n     depth u = log n     radius Λ(n)/√n
   2     0.69314718          0.49012907
   3     1.0986123           0.63428410
   4     1.3862944           0.34657359      (= 2², half-weight)
   5     1.6094379           0.71976252
   7     1.9459101           0.73548490
   8     2.0794415           0.24506454
   9     2.1972246           0.36620410
  11     2.3978953           0.72299263
  13     2.5649494           0.71138896
  16     2.7725887           0.17328680
```

Keep that column. It reappears in §8 as the arithmetic side of the explicit
formula, unchanged — those *are* the same numbers.

**The answer to question 2 is therefore: yes for the primes, but not from the
helix as drawn — from the helix re-weighted by Λ.** The zeta helix draws the
integers; the Λ-weighted helix on identical levels draws the primes; and the
horn draws the zeros. Three figures, not two.

---

## 7. Where the horn closes, the prime helix blows up

The prime helix does represent the zeros — but as **poles, not closures**. If ζ
has a simple zero at ρ then near it `ζ(s) ≈ c(s−ρ)`, so `−ζ′/ζ ≈ −1/(s−ρ)`:
residue −1, one pole per zero, multiplicity counted.

```
  s = ½ + i(γ₁ + ε)      |−ζ′/ζ(s)|        1/ε
  ε = 1e−2               100.08239         100
  ε = 1e−3               1000.0822         1000
  ε = 1e−4               10000.082         10⁴
  ε = 1e−5               100000.08         10⁵

  s = ½ + 20i (no zero nearby)   |−ζ′/ζ| = 1.0744507
```

So the duality the question was reaching for is real and it is **inverse**:

> At a zero, the horn's two threads annihilate — endpoints purely imaginary,
> Ξ = 4·Re S₊(∞) = 0 (README §4). At the same point, the prime helix diverges
> like 1/|s − ρ|.

One closes, the other cannot be drawn at all. This is not a defect of either
figure — it is what "the zeros are the poles of the logarithmic derivative"
looks like geometrically. And it means the two objects can never be compared
pointwise. They have to be compared **paired against a test function**, which is
the explicit formula and nothing else.

---

## 8. The ledger that joins them: the explicit formula

Both objects live on the same axis. The horn's depth *u* and the prime helix's
depth `log n` are the same coordinate — the logarithm of the multiplicative
variable, with the throat u = 0 at x = 1 as the shared origin, and both sides
even under u ↔ −u. The one identity that pairs them is Riemann–Weil, in
[rh10](../html/rh10.html) §1's convention: for even *h* with Fourier partner *g*,

```
Σ_ρ h(γ_ρ) = h(i/2) + h(−i/2)
             + (1/2π)∫ h(r)·[Re ψ(¼ + ir/2) − ln π] dr
             − 2 Σ_{n≥2} Λ(n)/√n · g(log n)                                (7)
```

The last term is §6's radius column, sampled by *g* at the prime-helix depths.
The left side is the horn's closure points, sampled by *h*. Verified here
independently of rh10, with `h(r) = e^{−(r−t₀)²/2w²} + e^{−(r+t₀)²/2w²}`,
w = 0.7, t₀ = 20, and 120 zeros:

```
  zeros side (the horn)              0.688847411525
  ─────────────────────────────────────────────────
  pole term h(±i/2)                  3.4e−179
  archimedean ∫ against Re ψ         0.646283211198
  prime side −2ΣΛ(n)g(log n)/√n      0.042564069146
  arithmetic total                   0.688847280344
  difference                         1.3e−7   (120 zeros + quadrature)
```

rh10 reports 3×10⁻⁶ for the same identity at three test functions; this is the
same computation done from the horn's side of the vocabulary.

**That is the relationship between the two figures, exactly:** they are the two
sides of (7). Not two views of one object — two *columns of one ledger*, and the
ledger is the only place they meet.

---

## 9. The horn is already an Euler factor — the one at infinity

One more piece falls out of (5) and it closes the picture.

The completion factor that (5) attaches to every gear, `π^{−s/2}Γ(s/2)`, is not
bookkeeping. It is the Euler factor of ζ **at the archimedean place** — the
"prime at infinity" (Tate). The finite primes contribute `(1 − p^{−s})^{−1}`
each; the place at infinity contributes `π^{−s/2}Γ(s/2)`; ξ is the product over
all places, which is why ξ, and not ζ, has the clean functional equation.

So:

* **shell 1 of the horn = the archimedean Euler factor**, zero-free (§4);
* **the horn = that factor × the integer lattice**, which is ξ;
* **the primes are the places the horn does not draw**;
* **(7) is the trace formula that makes the finite places pay for the
  archimedean one** — which is precisely the setting of the three Connes papers
  already sitting in this directory.

And with that, README §8.3's complaint sharpens usefully. "Nothing in the
construction distinguishes ζ from any other function with an even weight and a
functional equation — no Euler product appears anywhere" is true, and now
locatable: the horn draws exactly **one** Euler factor. A construction that
drew the finite ones too would be an adelic object, not a horn, and that is the
Connes program, not a figure.

---

## 10. What to draw

Concrete, in the style of INTEGERS.md §6, in order of payoff:

1. **The Λ-weighted helix.** rh3's figure with `r_n = Λ(n)·n^{−σ}` and a toggle
   between the two weightings. Composite gears collapse to the axis; the primes
   and their powers remain. One line of code, and it is the prime side of the
   arc that has never been drawn. (§6)
2. **The shared axis.** Put the horn's silhouette and the prime comb on one
   *u*-axis, throat at u = 0, atoms at u = log n with height Λ(n)/√n. The horn's
   drawn radius at those atoms is 0.485 (n = 2), 0.0863 (n = 3), 0.00652
   (n = 4) at k = 8 — a drawing fact, stated as one: no theorem places the comb
   under the silhouette, only the coordinate does. (§6, §8)
3. **The shell ↔ gear peel.** INTEGERS.md §6 item 2 already asks for an *n*
   slider peeling the shells. Label each peeled shell with the helix gear it is,
   per (5), and print `|Σ_{n≤N} shell transforms|` climbing as `√N/|1−s|` beside
   `|Ξ| = 1e−18`. That single readout is §2 entire. (§2)
4. **The pole/closure pair.** Two panels at the same *t*: the horn's endpoints
   annihilating, and `|−ζ′/ζ|` spiking. Sweep *t* through γ₁ and they move
   together, one to 0 and one to ∞. (§7)
5. **The ledger.** (7)'s four terms as a bar chart at a slider-controlled t₀ —
   zeros side against pole + archimedean + primes. rh10 Figure 1 already scans
   the arithmetic side; this is the same instrument with both columns shown.

Items 1 and 4 are the ones that answer the question that prompted this file.

---

## 11. What this does not do

**1. It moves no wall.** §8 verifies (7); it does not verify positivity of it.
RH ⟺ the right side of (7) is ≥ 0 for every h = |f̂|², and that quantifier over
an infinite-dimensional space is rh8 §6's obstruction, rh19–rh27a's certified
floors, and rh28/rh29's floor decaying worse than a power law. README §8.2
already says this; recognising the helix inside the horn does not change it.

**2. The Λ-weighted helix is not new mathematics either.** It draws −ζ′/ζ, which
is the standard prime side of every explicit-formula argument since 1859. Drawing
it is a presentation improvement, and it will show nothing that (7) does not
already state.

**3. §6's extrapolation is an extrapolation.** 10⁵³ primes is a rate read off
five oscillating points. It is quoted to make one point — that the prime side
truncates no better than the integer side — and should not be quoted for
anything else.

**4. The correspondence (5) is exact and non-summable, and the second half
matters as much as the first.** Anyone tempted to conclude "so the horn contains
the helix, therefore the horn contains everything the helix knows" should read
§2's divergence table first. What the horn contains is the helix's *terms*. What
it does not contain — and what Poisson summation supplies in its place — is any
reason for those terms to add up.

---

## 12. Verified numbers

Computed at 25–40 digits with mpmath; float64 reproduces all of them except the
shell-transform residuals.

| quantity | value |
|---|---|
| shell↔gear identity (5), n = 1,2,3 at s = 2, ½+iγ₁, 0.3+5i | rel. error ≤ 3.2e−29 |
| shell 1 transform at ½ + iγ₁ | 0.00027408025 + 0.0017216230i, \|·\| = 0.0017433 |
| Σ_{n≤10⁴} shell transforms at ½ + iγ₁ | 0.012326077 (predicted √N/\|1−s\|: 0.012325768) |
| Σ_{n≤10⁵} shell transforms | 0.038977599 (predicted 0.038977502) |
| ξ(½ + iγ₁) | 1.09e−18 |
| explicit formula (7), zeros side, w = 0.7, t₀ = 20 | 0.688847411525 |
| — pole term | 3.4e−179 |
| — archimedean term | 0.646283211198 |
| — prime term | 0.042564069146 |
| — arithmetic total | 0.688847280344 |
| — difference (120 zeros) | 1.3e−7 |
| ∏_{p≤10⁵}(1−p^{−s})^{−1} at ½ + iγ₁ | 0.013084262 (ζ = 6.3e−16) |
| ∏_{p≤10⁵} at 1.5 + iγ₁ vs ζ | 0.5443977716 vs 0.5444038328 |
| Euler truncation slope | −0.304 decades per decade of P (oscillatory) |
| \|−ζ′/ζ(½ + i(γ₁+ε))\| at ε = 1e−5 | 100000.08 (= 1/ε + 0.08) |
| \|−ζ′/ζ(½ + 20i)\| | 1.0744507 |
| Λ(n)/√n at n = 2, 3, 4, 5 | 0.49012907, 0.63428410, 0.34657359, 0.71976252 |
| Φ at u = log 2, log 3, log 4 | 1.371686e−3, 1.378207e−9, 1.450176e−18 |
| drawn radius (k = 8) at those u | 0.485183, 0.0863302, 0.00651517 |

---

## 13. Dictionary

New terms introduced here; the directory's full vocabulary is in
[README.md](README.md) §10, and these are folded into
[../dictionary.html](../dictionary.html) per the repo rule in
[../CLAUDE.md](../CLAUDE.md).

| term | meaning |
|---|---|
| the log-depth axis | u = log x — the coordinate the horn's depth and the helix's phase share; rh3's cone r = x^{−σ} on it is radius e^{−σu}, phase −t·u, i.e. the horn's law with Φ replaced by an exponential |
| shell n is gear n | 2∫φ_n(u)·e^{(s−½)u}du = ½s(s−1)π^{−s/2}Γ(s/2)·n^{−s}, verified to 3e−29 — the n-th shell of the horn is the n-th gear of the helix wearing the completion factor; exact term by term, and non-summable at σ = ½ |
| non-summable correspondence | the shell transforms sum like √N/\|1−s\| (0.012326 at N = 10⁴) while ξ(½+iγ₁) = 1.09e−18: the horn's convergence comes from Poisson summation on the whole weight, never from the shells |
| σ moves from the radius to the tilt | in the helix σ is a taper and ½ is unmarked; completion puts σ in the mirror (σ = ½ − t_i) where ½ is the fixed point — RH stops being a claim about which taper value happens to close and becomes a claim that the object closes only when it is symmetric |
| shell 1 is the place at infinity | the n = 1 shell transforms to π^{−s/2}Γ(s/2)·½s(s−1) alone — the archimedean Euler factor, zero-free in the strip; \|shell 1\| = 0.0017433 at γ₁ where the total is 1e−18, so the zero is interference between dilates, which is rh3 §6's trap avoided rather than entered |
| the prime helix | rh3's figure re-weighted r_n = Λ(n)·n^{−σ} on identical levels: it draws −ζ′/ζ = ΣΛ(n)n^{−s}, composites collapsed to the axis, primes and prime powers remaining |
| closure and pole | at a zero the horn annihilates (Ξ = 4·Re S₊(∞) = 0) and the prime helix has a simple pole of residue −1 (\|−ζ′/ζ\| = 1/ε + O(1), verified to ε = 1e−5) — the two figures are inverse there and can never be compared pointwise |
| two columns of one ledger | the only thing joining the horn and the prime helix is the Riemann–Weil formula (7): zeros side 0.688847411525 against pole + archimedean + primes 0.688847280344, difference 1.3e−7 |

---

*Companions: [README.md](README.md) (the horn),
[../rh3/README.md](../rh3/README.md) (the helix),
[INTEGERS.md](INTEGERS.md) (the shells),
[../rh10.html](../html/rh10.html) §1 (the explicit formula as an instrument).*
