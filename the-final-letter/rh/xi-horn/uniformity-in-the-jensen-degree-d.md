# Uniformity in the Jensen degree d — the frontier, and what is past it

Companion to [TODO.md](TODO.md) item **C1**, which marks this problem `[-]`:
the one genuine mathematical obstruction in the directory, untouchable by
arithmetic. This file is the map of that obstruction — what is actually proved,
quoted from the two papers that sit in this directory; where their exponents
come from, traced to the equation that manufactures each one; and what "past
the frontier" could mean, separated into the part that is measurable here, the
part that is a plausible derivation, and the part that is invariant under
everything either paper does.

**Framing, unchanged from the README:** none of this is a route to the Riemann
Hypothesis. Farmer says so at title length (arXiv:2008.07206, cited by [GOR⁺]
as their [10]), and [GOR⁺]'s own Remark (3) says it from the inside. A map is
not a vehicle. What a map is good for is not driving off the road — and C1's
`[-]` stays `[-]` at the end of this file.

Sources, both local: **[GOR⁺]**
[jensens-polynomials.pdf](jensens-polynomials.pdf) — Griffin, Ono, Rolen,
Thorner, Tripp, Wagner, *Jensen polynomials for the Riemann xi-function*,
Adv. Math. **397** (2022) 108186; **[O'S]**
[zeros-jensens-polynomials.pdf](zeros-jensens-polynomials.pdf) — O'Sullivan,
*Zeros of Jensen polynomials and asymptotics for the Riemann xi function*,
arXiv:2007.13582v2. Quotes were extracted from these PDFs directly; §7 records
how, and every reconciliation of notation is a checkable identity.

---

## 1. The problem, stated exactly

Both papers write γ(n) for what [POSITIVITY.md](POSITIVITY.md) (12) calls
a(n) = γ(n)·n!/(2n)! — their γ(m) := m!/(2m)!·ξ^(2m)(½), no rescaling.
(GORZ19, the 2019 PNAS paper, used a normalisation 8× larger; the two papers
here agree with this directory exactly, which is what makes their tables answer
keys — [TODO.md](TODO.md) header, **H1**.) In the papers' notation the Jensen
polynomial of degree d and shift n is

```
J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j        ([O'S] (1.3) = POSITIVITY (13))
```

and the criterion is two-sided:

> **[O'S] Theorem 1.1.** *The Riemann hypothesis is true if and only if
> J_{d,n}(X) is hyperbolic for all d ≥ 1, n ≥ 0.*

The two axes of that "for all" are not the same kind of hard, and everything in
this file turns on the asymmetry:

- **Fixed n, all d.** [O'S] Corollary 3.2: ξ^(n) is hyperbolic ⟺ J_{d,n} is
  hyperbolic for every d ≥ 1. So the d-direction at a single shift is the
  hyperbolicity of the n-th derivative — the statement [GOR⁺] call RH_n, with
  RH = RH₀ implying every RH_m. The all-d limit at fixed n **is** the theorem
  being sought, one derivative at a time.
- **Fixed d, all n.** Tractable, and the only direction in which anything has
  ever moved: d ≤ 3 (Csordas–Norfolk–Varga + Dimitrov–Lucas), d ≤ 2×10¹⁷
  (Chasse 2013), d ≤ 9×10²⁴ ([GOR⁺] Corollary 1.3).

Uniformity in d is C1 because the first axis is the problem and the second is
the progress, and no amount of the second sums to the first.

---

## 2. The two theorems, verbatim

### [GOR⁺] Theorem 1.1 — the d-uniformity made effective

> **Theorem 1.1.** *There is a constant c > 0 such that if n ≥ ce^d, then
> J_{d,n}(X) is hyperbolic.*

This is the effective form of GORZ19's "hyperbolic for all sufficiently large
n". The proof's own exponent is sharper than the statement: it closes
(end of §2.2) with the requirement

```
n  ≥  C̃ · d^{13/3} · (2 + 16C²)^{d/3},        1 < C < 2,
```

whose exponent ⅓·log(2+16C²) + 13·log d/(3d) tends, as C → 1 and d grows, to
**⅓·log 18 = 0.9634…** — the number printed in the paper immediately before
"and the desired result follows", and the number C1 quotes. ([O'S] p. 2 cites
the statement in the preprint's form, "hyperbolic whenever n ≥ e^{8d/9}" —
8/9 = 0.889; the published version trades that for the clean n ≥ ce^d. Either
way the threshold is exponential in d.)

### [O'S] Theorem 1.3 — the exponential made polynomial

First the family it is about ([O'S] (1.4)), Hermite from the start:

```
P_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·H_{d−j}(X)
```

> **Theorem 1.2.** *The Riemann hypothesis is true if and only if P_{d,n}(X)
> is hyperbolic for all d ≥ 1, n ≥ 0.*
>
> **Theorem 1.3.** *For all d sufficiently large, P_{d,n}(X) is hyperbolic
> whenever n/log²n ≥ d^{3/4}/2.*

Same equivalence, threshold e^{0.9634·d} → d^{3/4}·log²n. And the per-instance
comparison is strict ([O'S] Corollary 3.8: J_{d,n} hyperbolic ⟹ P_{d,n}
hyperbolic, never the converse): at d = 2 the J-instance is the Turán
inequality γ(n+1)² ≥ γ(n)γ(n+2) ([O'S] (1.5), CNV 1986), while the P-instance
is γ(n+1)² **+ 2γ(n)²** ≥ γ(n)γ(n+2) ([O'S] (1.6)) — the same inequality with
a free positive term added. Weaker one instance at a time; identical in
conjunction. That trade — weaken every instance, keep the conjunction
equivalent to RH — is the entire mechanism of the improvement, and §5 shows it
is the *only* degree of freedom this family of criteria has.

---

## 3. Where each exponent is manufactured

Both proofs certify hyperbolicity with the same tool, Turán's Theorem III
([O'S] Theorem 8.1): a Hermite combination G = Σ c_j·H_j has real simple zeros
when

```
Σ_{j=0}^{d−2} 2^j·j!·c_j²   <   2^d·(d−1)!·c_d².                        (8.1)
```

**The e^d, in [GOR⁺].** J_{d,n} is not a Hermite combination; it has to be
renormalised into one. Lemma 2.3 gives the limit exactly — the renormalised
J̃_{d,n} equals H_d(X/2) up to a defect of degree ≤ d−3 — and Theorem 2.4
bounds the defect's coefficients A_{d,k}(n). Feeding those bounds into the
Turán condition (their (2.9)) costs (2+16C²)^{d/3}: **the exponential is the
price of the renormalisation error**, the distance between J and its Hermite
limit at finite n, compounding across d coefficients.

**The d^{3/4}, in [O'S].** P is a Hermite combination already, so (8.1) applies
with c_j = C(d,j)·γ(n+d−j) directly and becomes ([O'S] (8.2), the identity
(d−j)!·C(d,j)²/(2^j(d−1)!) = d·C(d,j)/(2^j·j!) doing the bookkeeping):

```
Σ_{j=2}^{d}  d/(2^j·j!) · C(d,j) · γ(n+j)²/γ(n)²   <   1.               (8.2)
```

The engine is the moment-ratio bound (Lemma 8.2, from the Lambert-W asymptotic
of Theorem 1.4): γ(n+j)/γ(n) < 1.01·(3c²·log²n/16n)^j on 0 ≤ j ≤ n^c − n,
c > 4/3 — the ratio γ(n+1)/γ(n) ≍ log²n/16n is the small parameter that the
J-route never gets to use raw. Assembling ((8.5)): the sum is at most
1.03·Σ_{j≥2} d/(j!)²·(9d·log⁴n/32n²)^j, and the j = 2 term decides it:

```
d · (d·log⁴n/n²)²  ≲  1     ⟺     (n/log²n)⁴  ≳  d³     ⟺     n/log²n ≳ d^{3/4}.
```

**So 3/4 is literally 3 over 4**: three powers of d in the dominant term — two
from C(d,2), *one from the factor d that Turán's criterion itself inserts* —
against four powers of n/log²n from the squared, squared ratio. The /2 in the
theorem is (27/1024)^{1/4} = 0.403 rounded generously. Every constant in that
chain is slack except C(d,2), which is the polynomial's actual coefficient.

**The measured shadow.** The crate sees exactly this asymmetry from the other
side. **H2** certified both families through the same interval LDLᵀ:
J's `max width` tightens ~3.5 decades per unit of d and one to three more
decades as n grows to 30; P's tightens ~1.3 decades per unit of d and is
**flat in n** — 175× looser at (2,0), 6.0e9× at (5,30)
([rust/RESULTS.md](rust/RESULTS.md)). Flat-in-n is the certification-side
image of "one bound covers every shift", which is the same fact as the onset
threshold collapsing from e^{cd} to a polynomial. Theory and arithmetic agree
about where the cost lives.

---

## 4. The map

What is actually proved, as regions of the (d, n) quarter-plane:

| region | all shifts? | source | mechanism |
|---|---|---|---|
| d ≤ 3 | all n ≥ 0 | CNV 1986 + Dimitrov–Lucas | explicit Turán-type inequalities |
| d ≤ 2×10¹⁷ | all n ≥ 0 | Chasse 2013 | Laguerre multiplier sequences (Borcea–Brändén, Obreschkoff) |
| d ≤ 9×10²⁴ | all n ≥ 0 | [GOR⁺] Cor. 1.3 | RH verified to height T (Platt–Trudgian), d ≤ T² |
| all d | n ≥ c·e^d (proof: e^{0.9634…d}) | [GOR⁺] Thm 1.1 | renormalise J to Hermite, Turán III |
| all d large | n/log²n ≥ d^{3/4}/2, for P | [O'S] Thm 1.3 | Hermite basis from the start, Turán III |

The finite-d band and the large-n wedge. Verbatim, the two theorems that pin
the band's outer edge:

> **[GOR⁺] Theorem 1.2.** *If RH_m(T) is true and d ≤ T², then J_{d,n}(X) is
> hyperbolic for all n ≥ m.*
>
> **[GOR⁺] Corollary 1.3.** *If d ≤ 9 × 10²⁴ and n ≥ 0, then J_{d,n}(X) is
> hyperbolic.*

Theorem 1.2 is the only mechanism in either paper that converts knowledge
*about zeros* into coverage *in d*, and its exchange rate is d ≤ T²: the
corollary's 9×10²⁴ is Platt–Trudgian's T = 3 000 175 332 800, squared. Covering
all d at that rate needs T = ∞ — i.e. the input is RH itself. That is the
precise sense in which C1 is the whole difficulty and not a technical gap.

What remains uncovered is the corner **d > 9×10²⁴ with n below the wedge** —
shifts small relative to the degree. [GOR⁺] Remark (3) says what lives there:
a converse to their Theorem 1.2 is "highly unlikely … unless one has
hyperbolicity for all n ≥ m and all d ≥ 1", and Jensen polynomials "are
ultimately quite inefficient at detecting zeros that violate RH_n". The corner
is not small, it is not shrinking toward empty, and by §1's asymmetry its
fixed-n slices are the theorem itself.

---

## 5. The criterion is the free parameter — and what it cannot buy

The most consequential thing in [O'S] is not Theorem 1.3 but the theorem that
explains why a Theorem 1.3 was available at all:

> **[O'S] Theorem 3.5.** *Let Φ(z) = Σ_{j≥0} c_j·z^j/j! be a real entire
> function of genus 1\* and let Ω(z) be in the Laguerre–Pólya class. Then Φ(z)
> is hyperbolic if and only if the polynomials*
>
> ```
> Σ_{j=0}^{d} C(d,j) · c_j · g*_{d−j}(Ω; x)                             (3.5)
> ```
>
> *are hyperbolic for all d ≥ 1.*

Here g*_d(Ω; x) is the reciprocal Jensen polynomial of Ω, and Lemma 3.4
identifies (3.5) as g*_d(Φ·Ω; x): **every choice of Ω is the classical Jensen
family of the product Φ·Ω**, and multiplying by an LP factor neither adds nor
removes real-zero content. Ω = 1 returns J_{d,n}. Ω = e^{−z²} — whose Jensen
polynomials are Hermite: g*_d(e^{−z²}; x) = H_d(x/2) — returns P_{d,n}.
Ω = 𝒥_ν (Bessel) returns a Laguerre family with a *continuous* parameter:

> **[O'S] Theorem 3.9.** *The Riemann hypothesis is true if and only if the
> polynomials Q_{d,n,ν}(x) := Σ_{j=0}^{d} C(d+ν, j)·γ(n+j)·x^j·L^(ν)_{d−j}(x)
> are hyperbolic for all d ≥ 1, all n ≥ 0 and all real ν ≥ −2.*

So the criterion has one genuine dial, Ω ranging over the Laguerre–Pólya
class; every setting is equivalent to RH; and one turn of it — 1 to e^{−z²} —
moved the effective threshold from e^{0.9634d} to d^{3/4}log²n. This is
**H6**'s reframing of C2, stated with its source: what differs between
settings is never content, only cost of verification.

**And here is the invariance that bounds the dial.** Fix the shift n and apply
Theorem 3.5 to Φ = the shifted series itself (c_j = γ(n+j)): for *every*
Ω ∈ LP,

```
{ Ω-family hyperbolic at (n, d) for all d ≥ 1 }   ⟺   ξ^(n)-hyperbolicity,
```

and the right-hand side does not mention Ω. The all-d conjunction at fixed n
is the same statement at every setting of the dial. Instances re-price
(Corollary 3.8's strict implication; H2's twelve decades of measured slack);
the conjunction is a gauge invariant, and the conjunction is the hard
direction. In the language of [CONTINUATION.md](CONTINUATION.md) §8.2: the
Ω-families are coefficient multipliers on the y-series of the one two-variable
function F(w, y) — different reading frames of the same object, which is why
§8.4's sentence ("restating uniformity is not obtaining it") was always going
to survive any choice of frame. No Ω closes the corner. Ω chooses how cheaply
the wedge is certified, and that is all it chooses.

---

## 6. Past the frontier — sorted the way this directory sorts things

### `[ ]` Measure the true onset, then fit its exponent. — The tractable one.

Theorem 1.3's d^{3/4} is an *upper bound manufactured by (8.2)*, and §3 showed
the manufacture: one of its three powers of d is Turán III's own crude factor,
and the constants (1.01, e < 3, c = 2) are all absorptions. Nobody — either
paper included — knows where P_{d,n} hyperbolicity *actually* switches on at
small d, and it is a finite computation with an O(1), scale-free margin
(**H3**; the d = 2 row already exists — POSITIVITY §3's margin ratio starts at
0.573 at n = 0, so the d = 2 onset is n = 0). Produce the onset table, fit
T(d), and read the exponent. If the fit says d^{1/2}·polylog, the gap is in
the certificate; if it says d^{3/4}, the criterion itself is spent. Either
answer directs the next move, which is the definition of worth measuring.
**Cost: an afternoon; the driver exists (`bin/h2_pjensen` computes the family,
H3 is its scan).**

### `[ ]` Sharpen the certificate below Turán III. — Plausible, unproven.

The factor d that (8.1) inserts is the price of comparing every coefficient
against the leading one alone. A certificate that sees the whole coefficient
sequence — the Hermite–Hankel LDLᵀ the crate already runs (**B1**, **H2**) is
exactly such an object, as is any interlacing argument — removes that factor
from the j = 2 term, and three-over-four becomes two-over-four:
**n/log²n ≳ d^{1/2}** is the reachable prize, with C(d,2) the first honest
wall. This is a derivation, not a computation, and it should be attempted only
after the measurement above says the room exists. **Cost: unknown; it is
analysis. Label it what it is — a route someone should walk, not a result.**

### `[ ]` Optimise the dial. — H6, now with its cost function named.

Search Ω over e^{−αz²}, the Bessel/Laguerre line ν ≥ −2 (Theorem 3.9), and
products, scoring each by H3's measured onset. Expect constants and perhaps a
log; §5's invariance is the ceiling and it is strict. The interesting output
is not the winner but the *shape* of onset-versus-Ω — whether Hermite is a
basin or a boundary point. **Cost: a day, after H3.**

### `[-]` Any assault on the fixed-n, all-d direction through this machinery.

Invariant under Ω (§5), fed only by verified zeros at rate d ≤ T² ([GOR⁺]
Theorem 1.2), and equal at each n to RH_n (§1). The frontier moves along the
n-axis; the d-limit is the theorem. Recorded here so the next reader does not
spend a week rediscovering which axis is which.

### `[-]` Treating any of the above as a route to RH.

The measurable item calibrates a bound; the derivation item improves an
exponent *inside the wedge*; the optimisation item re-prices certificates.
The corner — where RH lives — is untouched by all three, which is Farmer's
point, [GOR⁺]'s Remark (3), and this directory's framing paragraph, three
times over. C1 keeps its `[-]`.

---

## 7. Sources, extraction, and the reconciliations

The PDFs' text was pulled by decompressing their FlateDecode streams directly
(no pdftotext on this machine); math glyphs degrade, so every formula above
was reconciled by identity rather than trusted by eye:

- **γ_paper = a(directory):** their γ(m) = m!/(2m)!·ξ^(2m)(½); POSITIVITY (7)
  has ξ^(2n)(½) = γ_dir(n), and (12) has a(n) = γ_dir(n)·n!/(2n)!. Equal, no
  rescaling. H1 checked it to 20 digits at n = 1000.
- **0.9634 = ⅓·log 18**, the C → 1 limit of ⅓·log(2+16C²): log 18 = 2.8904,
  /3 = 0.96345. The paper prints 0.9634…; TODO C1 quotes it.
- **The /2 in Theorem 1.3:** (8.5)'s closing condition (9d·log⁴n/32n²)² ≤ 3/d
  is n/log²n ≥ (27/1024)^{1/4}·d^{3/4} = 0.403·d^{3/4} ≈ d^{3/4}/2.48.
- **(8.1) ⟹ (8.2):** with c_j = C(d,j)·γ(n+d−j), the weight is
  (d−j)!·C(d,j)²/(2^j·(d−1)!) = d·C(d,j)/(2^j·j!). One line of algebra;
  it is where Turán's extra factor of d enters.
- **g\*_d(e^{−z²}; x) = H_d(x/2):** e^{−z²} = Σ_i (−1)^i·(2i)!/i!·z^{2i}/(2i)!,
  so g*_d = Σ_i C(d,2i)·(−1)^i·(2i)!/i!·x^{d−2i} = d!·Σ_i
  (−1)^i·x^{d−2i}/(i!·(d−2i)!) = H_d(x/2).
- **[O'S] vs [GOR⁺] on the exponential:** [O'S] p. 2 quotes the preprint's
  n ≥ e^{8d/9}; the published [GOR⁺] states n ≥ ce^d with proof exponent
  0.9634. Recorded so a cross-reader does not mistake the discrepancy for an
  error in either file.

Quotes are from: [GOR⁺] §1 (Theorems 1.1, 1.2, Corollary 1.3, Remarks),
§2.1–2.2 (Lemma 2.3, Theorem 2.4, Lemma 2.5, the closing bound); [O'S] §1
(Theorems 1.1–1.4, (1.3)–(1.6)), §3 (Theorem 3.1, Lemma 3.4, Theorems 3.5,
3.9, Corollaries 3.2, 3.8), §8 (Theorem 8.1, (8.2), Lemma 8.2, (8.5)).

---

*Companions: [TODO.md](TODO.md) (C1, C2, H2, H3, H6) ·
[POSITIVITY.md](POSITIVITY.md) §3, §5 · [CONTINUATION.md](CONTINUATION.md) §8 ·
[rust/RESULTS.md](rust/RESULTS.md) (B1, H1, H2). Papers:
[jensens-polynomials.pdf](jensens-polynomials.pdf) ·
[zeros-jensens-polynomials.pdf](zeros-jensens-polynomials.pdf).*

- **Primary-source correction (2025-10-06, session 003 citation audit).** The range quoted here for [O'S] Theorem 3.9 was `ν > −2` (open); the paper reads **`all real α ≥ −2`**, closed, in both v1 and v2, with its `d = 2` discriminant computation confirming the endpoint. Corrected in this file and in the harvested document `theorems/xihorn-uniformity-osullivan-theorem-39.md`.

