# The horn and the helix, adelically — one figure per place, and the one thing that does not complete

Successor to [horn-helix.md](horn-helix.md) and
[horn-helix-revisited.md](horn-helix-revisited.md). The latter's §3.5 left a
one-paragraph promissory note:

> **The adelic completion.** Shell 1 is the Euler factor at infinity. The finite
> places enter Ψ only as atoms — un-smeared, un-completed. A construction in
> which *every* place contributes its own "bump" symmetrically is precisely the
> adelic/trace-formula program of the three Connes papers shelved in this
> directory.

This file cashes it. The conversion is exact, it is short, and it has a negative
result at its centre.

**Headline.** The adelic object is not a bigger horn. It is a **decomposition** —
one figure per place of ℚ, and the two figures this directory has been drawing
are two of them:

> At **v = ∞** the figure is the **horn**: continuous depth u ∈ ℝ, smooth weight
> Φ, closure decidable from |u| ≤ 1.5.
> At **v = p** the figure is a **helix**: rings at depths k·log p, radius
> p^{−kσ}, phase −t·k log p — which is rh3's cone with its ring set thinned from
> {log n} to the sublattice (log p)ℤ.
>
> **The horn/helix duality of the two predecessors is the ∞/finite dichotomy of
> places, and nothing else.**

And the negative result, which is why the completion buys less than it looks
like it should:

> **Smearing is archimedean.** The operation that made the horn — "replace every
> point-gear by one copy of a bump" ((7) of the predecessor) — needs a depth axis
> that is a line and a weight that is a function on it. At a finite place the
> depth axis is a lattice and the weight is locally constant with compact
> support, so the pushforward of *any* Bruhat–Schwartz function to the depth axis
> is a finitely supported measure. There is no p-adic bump. Every virtue the horn
> has — bounded support, double-exponential decay, decidability from a bounded
> picture — is a property of **one** place, and the adelic object pays for it by
> having infinitely many.

Every number below reproduces with mpmath at 30–40 digits; §8 collects them.

---

## 0. Standing disclaimer

**The mathematics here is classical, and older than most of this directory's
sources.** The local–global decomposition of ζ is Tate's thesis (1950, published
1967); the local functional equations, the local root numbers and the
identification of π^{−s/2}Γ(s/2) as the Euler factor at infinity are all Tate.
The per-place form of the explicit formula is Weil 1952. The programme of making
a *trace* out of it is Connes (`connes-1997-edp-trace-formula.pdf`), and the
archimedean positivity statement at the end of that road is Connes–Consani
(`connes-consani-weil-positivity-archimedean.pdf`). Dates and attributions in
this paragraph are **from memory beyond the two PDFs named** — TODO **A1**
applies to them exactly as it applies to the rest.

What is new here is the same kind of thing that was new in the predecessors: the
*identification*, with the constants computed. Specifically, three things this
directory has been treating as facts about its own construction are shown to be
facts about the place ∞:

* the exponent ½ in the translation identity is the half-power of the idele norm
  (§2.3) — the unitary normalisation, not a quirk of the kernel;
* the horn's smoothness, and hence its decidability, is the archimedean weight
  and has no finite-place counterpart (§5.1);
* the amplitude ledger |C(½+iγ_k)| of the prime horn is the archimedean **local
  factor** read at the closures (§4.6).

And one measurement is new: §4 breaks the Weil pairing of
[positivity-generator.md](positivity-generator.md) §2 into its per-place terms and
reproduces that file's `E(0)` and `E(10)` to **21 digits**, place by place. That
table is the file's main empirical content. **It moves no wall**; §7 says exactly
what it does not do.

---

## 1. The figure at each place

### 1.1 The local data

Tate's decomposition, in this directory's vocabulary. For each place *v* of ℚ
take the local field ℚ_v, the local weight f_v, the **local depth coordinate**
u = log|x|_v, and the local zeta integral

```
Z_v(s) = ∫_{ℚ_v^×} f_v(x)·|x|_v^s d^×x                                     (1)
```

The two standard weights give the two Euler factors:

```
   v      f_v            depth axis log|x|_v      Z_v(s)
   ∞      e^{−πx²}       ℝ, continuous            π^{−s/2}·Γ(s/2)
   p      1_{ℤ_p}        (log p)·ℤ, discrete      (1 − p^{−s})^{−1}
```

and `∏_v Z_v(s) = π^{−s/2}Γ(s/2)ζ(s)` — which is ξ(s) with the factor
½s(s−1) removed. That factor is not a place: it is the pole, and §4.1 gives it
its adelic name.

### 1.2 The finite places: the local horn *is* a helix

Read the p-adic row of (1) as a figure, in the coordinates of
[horn-helix.md](horn-helix.md) §1. The local weight 1_{ℤ_p} is constant on each
shell |x|_p = p^{−k}, so the local zeta integral collapses to a sum over the
depth lattice:

```
Z_p(s) = Σ_{k≥0} p^{−ks}      rings at depth u = k·log p,
                              radius p^{−kσ} = e^{−σu},
                              phase −t·k log p = −t·u                       (2)
```

Compare rh3's cone on the log-depth axis — radius `e^{−σu}`, phase `−t·u`,
rings at u = log n ([horn-helix.md](horn-helix.md) (3)). **They are the same
figure**; only the ring set differs, {log n} for the integer helix against
(log p)ℤ_{≥0} for the local one. The local ladder, at σ = ½:

```
   p    k    depth k·log p     radius p^{−k/2}
   2    1    0.6931471806      0.7071067812
   2    2    1.386294361       0.5
   2    3    2.079441542       0.3535533906
   3    1    1.098612289       0.5773502692
   3    2    2.197224577       0.3333333333
   5    1    1.609437912       0.4472135955
   5    2    3.218875825       0.2
```

Truncation at the local place is governed by the geometric tail, exactly as
rh3's is by the radius of the last drawn gear:

```
   p   K     |Σ_{k≤K} p^{−ks} − Z_p|     bound p^{−(K+1)/2}/(1−p^{−1/2})
   2   16    1.64566e−03                 9.43052e−03
   2   64    9.80891e−11                 5.62103e−10
   3   16    5.59969e−05                 2.08204e−04
   3   64    1.98269e−16                 7.37189e−16
   5   64    1.41231e−23                 3.47470e−23
```

(at s = ½ + iγ₁; the right column is an upper bound, and the measured error sits
a factor of 2.5 to 6 under it because the tail's phases do not align. The K = 256
rows are at the 1e−31 floor of the working precision and are omitted rather than
quoted as a law.)

**No finite place has a closure.** |Z_p| is bounded away from zero on the whole
critical line — it is a geometric series whose ratio has modulus p^{−1/2} < 1:

```
   p        min |Z_p(½+it)|    max |Z_p(½+it)|    ratio
   2        0.585786437627     3.41421356237      5.828
   3        0.633974596216     2.36602540378      3.732
   5        0.690983005625     1.80901699437      2.618
   7        0.725708114823     1.60762521851      2.215
   11       0.768337520964     1.43166247904      1.863
   101      0.909501243789     1.11049875621      1.221
   10007    0.990102439149     1.01009744092      1.020
```

### 1.3 The archimedean place: the horn

The other row of (1) is [horn-helix.md](horn-helix.md) §9's result restated:
`Z_∞(s) = π^{−s/2}Γ(s/2)` is the horn's completion factor, i.e. shell 1's
transform, i.e. the archimedean Euler factor. It is **also** zero-free — Γ has no
zeros anywhere.

So, exactly:

> **Every local figure is zero-free.** No finite place's ladder closes and the
> archimedean place's bump does not either. The closures of Ξ exist only in the
> product over all places, equivalently only in the sum over the whole ℚ^× orbit
> (§2). This is the sharp adelic form of [horn-helix.md](horn-helix.md) §4's "the
> zero at γ₁ is 0.0017 of destructive interference between dilates" — the
> interference is between *places* as well as between shells, and in the place
> decomposition there are infinitely many of them and every one is bounded away
> from zero.

### 1.4 The four differences, one place at a time

README §3's four-difference table between the rh3 cone and the Ξ horn, now read
as a comparison of two places rather than two constructions:

| | v = p | v = ∞ |
|---|---|---|
| depth axis | (log p)·ℤ — a lattice | ℝ — a line |
| local weight | 1_{ℤ_p}, locally constant, compact support | e^{−πx²}, smooth, Schwartz |
| figure | discrete rings, radius e^{−σu} | continuous silhouette, radius Φ(u) |
| extent | infinite depth, geometric decay | effectively \|u\| ≤ 1.5 |
| Fourier self-duality | 1̂_{ℤ_p} = 1_{ℤ_p} — self-dual on the nose | Gaussian, self-dual on the nose |
| local closure | none: \|Z_p\| ≥ (1+p^{−1/2})^{−1} | none: Γ is zero-free |

The two self-duality rows are the reason the theta functional equation works
(§2.4). The two extent rows are the reason §5 is a negative result.

---

## 2. The depth lattice, and the translation identity as adelic Poisson

### 2.1 The finite depth lattice is the helix's gear set

The finite places' depth lattices generate, jointly,

```
⊕_p (log p)·ℤ  ⊃  { Σ_p k_p·log p : k_p ≥ 0 }  =  { log n : n ≥ 1 }        (3)
```

— the helix's gear set, exactly. So
[horn-helix-revisited.md](horn-helix-revisited.md) §3.5's first remark gets its
name: **the free abelian monoid on {log p} is the finite-place depth lattice**,
and its freeness is unique factorisation. The helix's gear *n* is one gear from
each local helix, multiplied; that product is the Euler product, drawn.

The horn's depth axis is the archimedean one, a line. **The pairing the whole
arc keeps computing — comb against silhouette, primes against zeros, §1.5 of the
predecessor in both directions — is the pairing of the finite places' lattice
against the archimedean place's line.** They share a coordinate because both are
log|·| on the same idele class group.

### 2.2 The orbit sum, unweighted

The adelic weight is `f = (⊗_p 1_{ℤ_p}) ⊗ e^{−πx²}`, and the object that plays
theta's role is the **ℚ^×-orbit sum** `E(x) = Σ_{q ∈ ℚ^×} f(qx)`. On the slice
x_fin = 1, x_∞ = e^u, the finite components force q ∈ ℤ, and what is left is a
pure translation orbit of the archimedean bump:

```
θ_n(u) = e^{−πn²e^{2u}} = θ₁(u + log n)     exactly, θ₁(u) = e^{−πe^{2u}}    (4)
```

Verified at n = 2, 3, 5, 17 and u = −1, 0, 0.7: residual ≤ 8.6e−42 (and exactly
0 where the shift is representable). **No weight appears** — the translation is
the whole content, and the translated points are (3)'s lattice.

### 2.3 Where the n^{−1/2} comes from

[horn-helix-revisited.md](horn-helix-revisited.md) (6) carries a weight that (4)
does not:

```
φ_n(u) = n^{−1/2}·φ₁(u + log n)                                            (5)
```

and §2.3 of that file attached an honesty note to the exponent ½ — "it is why
ξ(½ + it), not ξ(σ + it), is the transform of an even weight … it is not
evidence about where the zeros are." That note stands, and it now has a name:

> **n^{−1/2} is |x|^{1/2} — the half-power of the idele norm.** It is the factor
> that turns the regular representation of the idele class group on functions
> into a *unitary* one, i.e. the normalisation under which the multiplicative
> Fourier transform lands on the line Re s = ½. The critical line is the unitary
> axis of C_ℚ. That is a statement about the group, not about ζ, and it explains
> the exponent without predicting anything about the zeros.

Re-verified here at n = 2, 3, 5, 7, 101 and u = −1, 0, 0.7, 1.4: worst relative
residual **2.3e−38**.

The same reading answers a question the predecessor did not ask: *why does the
horn's gear measure have a taper at all when the raw orbit (4) has none?* Because
the horn is a function on C_ℚ and (4) is a function on 𝔸; the taper is the
Jacobian of the descent.

### 2.4 The mirror is adelic Poisson

Both local weights are their own Fourier transforms — the Gaussian at ∞, and
1_{ℤ_p} at every p because ℤ_p is self-dual under the standard additive
character. So the adelic Poisson summation formula applies to *f* with no
correction beyond the constant terms, and on the slice it is exactly

```
θ(1/x) = √x·θ(x),    θ(x) = Σ_{n ∈ ℤ} e^{−πn²x}                            (6)
```

verified to the working precision at x = 0.3, 0.7, 1, 3 (relative residual 0.0 at
40 digits). This is [INTEGERS.md](INTEGERS.md) §4(c)'s point — "the theta
functional equation *is* Poisson summation" — with the summation now taken over
ℚ inside 𝔸 rather than over ℤ inside ℝ, which is what makes the two self-duality
rows of §1.4 the mechanism rather than a coincidence.

### 2.5 The finite direction only translates

Moving along the finite component does nothing new. At x_fin = m (the integer *m*
at every finite place) the orbit condition becomes q ∈ (1/m)ℤ, and

```
Σ_{q ∈ (1/m)ℤ_{>0}} e^{−πq²y²} = Σ_{j≥1} e^{−πj²(y/m)²}                    (7)
```

— the same horn, read at u − log m. Verified at m = 2, 3, 6 (relative residual
≤ 3.5e−41).

E is constant on ℚ^×-orbits by construction, so it descends to C_ℚ. That it
**depends only on |x|** is one step further, and it is a property of the weight,
not of the group: `1_{ℤ̂}` is invariant under the compact factor ℤ̂^×, so E is
too. The horn's single coordinate u is the norm map, and the horn is what the
adelic object looks like after the compact direction has been averaged away. §3
is what was averaged.

---

## 3. The fibres: one horn per Dirichlet character

### 3.1 The compact direction

C_ℚ = 𝔸^×/ℚ^× ≅ ℝ_{>0} × ℤ̂^×. §2 used only the ℝ_{>0} factor. The characters of
the compact factor ℤ̂^× are the Dirichlet characters, and running (1) against a
character χ instead of the trivial one gives the completed Dirichlet L-function.

> **The horn of [README.md](README.md) is the trivial-character fibre of an
> adelic object whose other fibres are the L-horns.**

Which is worth stating precisely because of what it costs — see §3.5.

### 3.2 The χ-horn

Same recipe. For primitive χ mod q, with δ = 0 if χ is even and δ = 1 if odd,

```
Φ_χ(u) = e^{(2δ+1)u/2} · Σ_{n≥1} n^δ·χ(n)·e^{−πn²e^{2u}/q}                 (8)
Λ(½+it, χ) = 2 ∫ Φ_χ(u)·e^{itu} du = 4 ∫₀^∞ Φ_χ(u)·cos(tu) du              (9)
```

**The mirror is not a symmetry of a fibre in general.** The completed functional
equation is Λ(s, χ) = ε(χ)·Λ(1−s, χ̄), so u ↦ −u carries the fibre over χ to the
fibre over χ̄ and multiplies by the root number. Only the **real** characters are
fixed points of that involution, and there ε = 1, so there Φ_χ is even in the
sense the horn is. That is why the two fibres computed below are real ones; for
complex χ the horn does not have a mirror plane, it has a mirror *partner*.

Two fibres, computed — χ₅ the even real character mod 5 and χ₋₄ the odd real
character mod 4:

```
  fibre     u      Φ_χ(u)                    Φ_χ(−u) − Φ_χ(u)
  χ₅       0.2     0.406612897601356         1.1e−41
  χ₅       0.6     0.1672931815128939        2.9e−42
  χ₅       1.0     0.01588020736432123      −7.9e−42
  χ₅       1.4     6.556449145290673e−05     3.3e−42
  χ₋₄      0.2     0.4181432217124752        5.7e−42
  χ₋₄      0.6     0.1812979015054433       −5.7e−42
  χ₋₄      1.0     0.01352316565979404       3.0e−42
  χ₋₄      1.4     2.008383346521512e−05    −2.5e−42
```

and (9) against Λ computed independently from Hurwitz zetas:

```
  fibre     t             transform (9)                Λ(½+it, χ)                   rel
  χ₅        0             0.943751437986687213         0.943751437986687213         0
  χ₅        3             0.450762447627329091         0.450762447627329091         0
  χ₅        6.64845…     −7.13732593620759102e−20     −7.13732593620759102e−20      —
  χ₅       10            0.000193638710524873712      0.000193638710524873712       1.0e−40
  χ₋₄       0             0.980713614057713504         0.980713614057713504         0
  χ₋₄       3             0.464953048105436643         0.464953048105436643         0
  χ₋₄       6.02095…      2.24286830602596924e−19      2.24286830602596924e−19      —
  χ₋₄      10           −0.000774019828794000752     −0.000774019828794000752       1.4e−41
```

(the two zero rows are the first closures of §3.4; both sides agree there at the
1e−19 level, which is the quadrature floor, not a disagreement).

### 3.3 The translation identity holds on every fibre — with the same exponent

This is the structural result of §3, and it is exact:

```
φ_n^χ(u) = χ(n)·n^{−1/2}·φ₁^χ(u + log n)      for every primitive χ,
                                              even or odd                 (10)
```

Verified at n = 2, 3, 7, 11 (χ₅) and n = 3, 5, 7, 11 (χ₋₄), u = −1 and 0.7:
worst relative residual **1.2e−38**.

Read it against (5). Three things vary from fibre to fibre and one does not:

* the **bump** φ₁^χ varies — the archimedean local factor changes with the
  parity, Γ(s/2) for even χ and Γ((s+1)/2) for odd, so the odd fibres' shells
  carry the extra factor n;
* the **twist** χ(n) varies — it is the character evaluated on the depth lattice;
* the **conductor** q varies, rescaling the throat;
* the **taper is always n^{−1/2}.**

Which is §2.3 again: the exponent is the idele norm's half-power, so it cannot
depend on the fibre. The critical line is the unitary axis of the *group*, and
every fibre sits over the same group.

### 3.4 The fibre horns' first closures

```
  fibre                first closure of Ξ_χ(t) = Λ(½+it, χ)
  χ₅   (even, q = 5)   t = 6.64845334472771472
  χ₋₄  (odd,  q = 4)   t = 6.02094890469759665
```

The second reproduces the standard first ordinate of L(s, χ₋₄).

### 3.5 What the completion costs

The finite places' local factors on a nontrivial fibre are
`(1 − χ(p)p^{−s})^{−1}`. So on the local helix at p:

* the **radii are unchanged** — |χ(p^k)|·p^{−k/2} = p^{−k/2} whenever χ(p) ≠ 0;
* the **phases** are shifted by arg χ(p^k) (a sign, for real χ);
* the **ramified places** — p | q — contribute the factor 1: their ladder is
  empty, and they drop out of the figure altogether.

So the fibres are the same figure re-phased, and the closure criterion of
README §5 ("the horn only closes when it is untilted") applies verbatim to each
one. Which is the cost:

> **Adelic completion makes the object canonical and the hypothesis bigger.**
> The horn had one criterion. The adelic object's zero set is the union over the
> fibres, and "every fibre closes only untilted" is GRH for Dirichlet
> L-functions, not RH. Nothing in the completion offers any purchase on the extra
> fibres that it does not already offer on the trivial one — the fibres are
> uncoupled, and the whole family is one criterion per character.

That is not a reason not to do the completion; it is a reason not to expect the
completion, by itself, to be progress. The two-way traffic that would make the
family worth having — a statement about all fibres that is easier than the
statement about one — is exactly what the function-field case has (road A of
[horn-helix-revisited.md](horn-helix-revisited.md) §4.2) and what ℚ does not.

---

## 4. The ledger, one place at a time

The Weil pairing, decomposed. This is the file's main computation.

### 4.1 The local terms

In the convention of [rh10](../html/rh10.html) §1 and
[horn-helix.md](horn-helix.md) §8, with h even and `h(r) = ∫g(u)e^{iru}du`,

```
Σ_ρ h(γ_ρ) − h(i/2) − h(−i/2) = Σ_v W_v(g)                                (11)
```

where the uniform expression for the local term is Weil's principal value

```
W_v(g) = − ∫'_{ℚ_v^×}  |w|_v^{1/2}·g(log|w|_v) / |1 − w|_v  d^×w           (12)
```

**At a finite place (12) is elementary and is derived here.** Split
ℚ_p^× = ⊔_{m ∈ ℤ} p^m·ℤ_p^×, and normalise d^×w so that vol(ℤ_p^×) = log p.
On the shell m > 0 we have |w|_p = p^{−m} < 1, hence |1 − w|_p = 1; on the shell
m < 0 we have |w|_p = p^{|m|} > 1, hence |1 − w|_p = |w|_p. So

```
W_p(g) = − log p · Σ_{k≥1} p^{−k/2} · [ g(k log p) + g(−k log p) ]         (13)
```

which is precisely the prime term of (11) regrouped by *p* — the arithmetic side
of the explicit formula, split into places. The m = 0 shell is where |1 − w|_p is
unbounded, and its value is Weil's principal-value convention; **that convention
is adopted here, not derived**, and §4.2's twenty-one-digit balance is the check
that it is the right one.

**At the archimedean place** the same principal value evaluates to the ψ-comb,

```
W_∞(g) = (1/2π) ∫ h(r)·ψ̃(r) dr,     ψ̃(r) = Re ψ(¼ + ir/2) − ln π          (14)
```

which is Weil's evaluation, cited and not re-derived. Its kernel has an exact
local reading worth recording:

```
ψ̃(r) = 2·Re [ (log Z_∞)′(½ + ir) ]                                        (15)
```

— **the archimedean local term's kernel is the logarithmic derivative of the
archimedean Euler factor on the line**, which is the archimedean comb of
[horn-helix-revisited.md](horn-helix-revisited.md) (3) identified as a local
object.

**The two pole terms h(±i/2) belong to no place.** In Tate's derivation they are
the residues of the global zeta integral at s = 0 and s = 1, carrying the volume
of the compact part of the idele class group. They are the adelic name for the
factor ½s(s−1) that §1.1 set aside, and they enter the ledger as a single
positive **volume term**.

### 4.2 The per-place table

Take [positivity-generator.md](positivity-generator.md) §2's kernel — the Weil
pairing of two translates of one Gaussian window, `φ(u) = e^{−u²/2σ²}` at
σ = 0.15, as a function of the separation *v*. That file computes E(v) two ways
(22,986 prime powers on one side, 30 ordinates on the other) and they agree to
2e−30. Here is the same number **split by place**, at v = 0:

```
   place            contribution                       running total
   volume       +0.28433825159078621253            0.28433825159078621253
   ∞            −0.27991616406062974035            0.0044220875301564721776
   2            −0.0012519397691183105678          0.0031701477610381616098
   3            −5.0565552145051910258e−07         0.0031696421055167110906
   5            −1.2118644107533763414e−13         0.0031696421053955246496
   7            −2.0903356717543403182e−19         0.0031696421053955244405
   11           −6.8978273038693064e−29            0.0031696421053955244405
   13           −6.7771106927742606e−33            0.0031696421053955244405
   …            (all remaining places)             0.0031696421053955244405
   TOTAL                                           0.003169642105395524440539
```

against `E(0) = 0.00316964210539552444` as published — **21 digits, and three
places carry all of it.**

At v = 10 the ledger looks nothing like that:

```
   place            contribution                       running total
   volume       +21.100727014180420256              21.100727014180420256
   ∞            −0.00095792803677548885             21.099769086143644768
   2            −0.00072049357135547880             21.099048592572289289
   3            −0.0018088800841279499              21.097239712488161339
   5            −0.00092359593862780768             21.096316116549533531
   7            −0.0017704909908286171              21.094545625558704914
   11           −0.00082563789777693133             21.093719987660927983
   13           −0.0019061759126581750              21.091813811748269808
   101          −0.000016798992456016531            21.084611430637112001
   1009         −7.7331007033449882e−48             21.018541867179243897
   22027        −0.017913876257501370               11.404522196173173205
   22031        −0.017912566873652531               11.386609629299520675
   TOTAL                                           −0.003167929015991991309161
```

against `E(10) = −0.00316792901599199131` — 21 digits again. (In both tables the
rows shown are a selection; the running-total column is over **all** places in
order up to that row, which is why it moves between printed lines — between
p = 1009 and p = 22027 it falls by 9.6 across the places not shown.)

Two features of that column are the point of the whole section:

* **the volume term is 21.1 and the answer is 3.2e−03**, so the places cancel it
  to four parts in 10⁴ — the balance rh28 §4 measured, now attributed;
* **p = 1009 contributes 7.7e−48 while p = 101 contributes 1.7e−05.** The places
  are not summed uniformly; they are *sampled* by the window. What matters at
  separation v is exactly the places carrying a prime power near e^v — log 101 ×
  2 = 9.23 lands under the bump, log 1009 × 1 = 6.92 does not.

### 4.3 Where the weight sits

The same decomposition across v, with the finite places collected:

```
    v      volume term      W_∞              Σ_p W_p          E(v)                    |Σ_p W_p| / |W_∞|
    0      0.284338251591   −0.279916164061  −0.00125244542   0.003169642105395524     0.00447
    1      0.320627195395   −0.102837171783  −0.217789790492  2.331205694651819e−07    2.12
    2      0.438756849767   −0.053425856423  −0.388491462706  −0.003160469361761614    7.27
    3      0.668880037024   −0.031812523401  −0.637077213888  −9.700265983602851e−06   20.0
    5      1.743644468900   −0.011670558926  −1.731937005890   3.690407645630660e−05   148
    8      7.764775178630   −0.002603918705  −7.759014529590   0.003156730331609184     2980
   10     21.100727014180   −0.000957928037  −21.10293701520  −0.003167929015991991    22030
   12     57.355471293600   −0.000352402030  −57.35195633930   0.003162552253771376   162746
```

Every E(v) column entry reproduces [positivity-generator.md](positivity-generator.md)
§2.1's table to the digits printed there.

**The archimedean place hands the ledger over to the finite ones almost
immediately.** At v = 0 the finite places contribute 0.45 % of what ∞ does; the
crossover is at **v\* = 0.6701618091**, where both sides read −0.1518012429; and
by v = 12 the finite places outweigh the archimedean one by 1.6×10⁵. The ratio
grows like e^{v/2} — the volume term's own cosh(v/2), which the finite places
must cancel and ∞ cannot.

### 4.4 The check that makes the split independent

§4.2's totals were compared against a *published* E(v). The same totals against
the **zeros**, computed here from 30 ordinates by
`E(v) = 2Σ_k Φ̂(γ_k)²cos(γ_k v)`, make the section self-contained:

```
     v      E from the places              E from the zeros              rel. diff
     0      0.0031696421053955244405      0.0031696421053955244405      2.0e−29
     1      2.3312056946518187296e−07     2.3312056946518187296e−07     3.4e−25
     2     −0.0031604693617616135439     −0.0031604693617616135439      1.8e−29
     5      0.000036904076456306597552    0.000036904076456306597552    1.8e−27
    10     −0.0031679290159919913092     −0.0031679290159919913092      2.5e−21
```

So the place-by-place arithmetic side and the closure side agree to between 21
and 29 digits. Every row of §4.2 and §4.3 is a decomposition of a quantity that
has been checked against the zeros, not just against a stored number.

### 4.5 The sign structure, and where positivity actually lives

For a Gaussian window, G — the inverse transform of Φ̂² — is a Gaussian, hence
positive, hence by (13) **every finite place's term is negative**. Checked for
the first 2000 places at v = 0, 5, 10: all strictly negative, without exception.
The volume term is positive by construction. And W_∞ is negative *for this
window*: ψ̃(r) < 0 on |r| ≲ 7 and positive beyond, and the σ = 0.15 Gaussian
carries most of its mass inside that range. **That last sign is measured, not a
theorem** — a much wider window would weight ψ̃'s positive tail more, and nothing
here says where it turns. So, at σ = 0.15,

```
E(v) = volume(v) + W_∞(v) + Σ_p W_p(v),
       volume > 0,   W_∞ < 0,   every W_p < 0                              (16)
```

and the Weil criterion — RH ⟺ E is positive-definite
([positivity-generator.md](positivity-generator.md) §3) — is, adelically, the
statement that **one positive term coming from the pole survives the subtraction
of every place.** That is the shape of Connes–Consani's programme in one line,
and §4.3's crossover says which subtraction is the dangerous one: for a window
placed at separation v the finite places do essentially all of the cancelling,
and what is left over is O(3e−03) out of 21.1.

The honest reading of that: the arithmetic is not "almost" cancelling the pole,
it is cancelling it to four parts in 10⁴ and the residue is the entire content.
No place is negligible and no finite set of places is sufficient — §4.6.

### 4.6 How many places the ledger needs

Counting places whose term exceeds 1e−20 in the same window:

```
    v      places needed     largest term at      e^v            π(e^{v+2})
    0      4                 p = 2                1.0            7
    2      16                p = 7                7.39           54
    5      179               p = 149              148.4          201
   10      13,585            p = 21,647           22,026         14,750
   14      520,050           p = 1,179,637        1,202,604      ≈589,000
```

(scan bound 3×10⁷, i.e. 1,857,859 places — enough to make every row complete
through v = 14; an earlier run bounded at 2×10⁶ returned 133,360 for the last row
and was measuring its own cutoff.)

The count grows like the prime counting function at e^{v+2} — the window's width
in the exponent — i.e. **exponentially in the depth**, and the largest single
contributor sits at a prime power within a window-width of e^v. Compare the horn:
at depth |u| = 1.5 it needs **one** place and the truncation costs 1e−19
(README §6). That contrast is §5.2.

One more identification falls out here. The prime horn's amplitude ledger
([horn-helix-revisited.md](horn-helix-revisited.md) §3.3) is
|C(½+iγ_k)| — 1.743303e−03, 1.561327e−05, 9.223475e−07, … — and C(s) is
½s(s−1)·Z_∞(s). So:

> **The amplitude ledger is the archimedean local factor read at the closures**,
> and its rapid decay (99.1 % of the mass in the γ₁ mode) is the Γ-factor's
> e^{−πγ/4}. The finite local factors do not decay at all: |Z_p(½+it)| stays in
> [0.586, 3.414] for p = 2, for every t (§1.2). **The only place whose figure
> gets small is ∞** — which is exactly why every construction in this directory
> that achieves boundedness achieves it archimedean-side.

---

## 5. What does not complete

### 5.1 Smearing is archimedean

The construction the last two files are built on — (7) of the predecessor,
"replace every point-gear by one copy of the archimedean bump φ₁" — needs two
things: a depth axis that is a line, and a local weight that is a function on it
with a shape. Neither exists at a finite place:

> **Statement.** The Bruhat–Schwartz space of ℚ_p consists of locally constant,
> compactly supported functions, and log|·|_p maps ℚ_p^× onto (log p)ℤ. Hence the
> pushforward of any local test function to the local depth axis is a **finitely
> supported measure on a lattice**. There is no p-adic bump, and no p-adic
> analogue of the smearing that produces Φ from the integers or Ψ from the
> primes.

Three consequences, all of them things this directory has run into without
naming:

1. **The prime horn Ψ is necessarily hybrid.** Its atoms `Λ(n)n^{−1/2}` are the
   finite places' local terms (13); its bump φ₁ is the archimedean weight. There
   is no symmetric version, because there is nothing at p to smear with. The
   promissory note quoted at the top of this file asked for "a construction in
   which every place contributes its own bump symmetrically" — §5.1 is the reason
   there is not one. What exists instead is the trace-formula programme, whose
   local terms (12) are *distributions*, not functions, at every place including
   ∞.
2. **The horn's decidability is a one-place property.** README §6's argument —
   Φ dies double-exponentially, so truncation at |u| = 1.5 costs 1e−19 and
   closure is decidable from the whole picture — is a statement about the
   Gaussian at ∞. §5.2 measures what replaces it.
3. **§2.3's honesty note is complete.** The exponent ½ is |x|^{1/2}; the bump is
   the archimedean weight; the twist is the character. The horn's three
   ingredients are one group-theoretic normalisation and two pieces of local
   data, and none of the three sees the zeros.

### 5.2 The truncation trade, adelically

The horn's one strictly quantitative advantage over the helix (README §6) does
not survive the completion, and here is the trade in numbers.

**Depth truncation, at any single place, is cheap.** Dropping the shells k > K at
place p costs `p^{−(K+1)/2}/(1 − p^{−1/2})`:

```
   p       K for 1e−19     tail at that K
   2       129             9.25e−20
   3       81              6.49e−20
   5       55              4.86e−20
   7       45              5.87e−20
   101     19              1.01e−20
```

A hundred and twenty-nine rings at the worst place. The archimedean place is
cheaper still: |u| ≤ 1.5.

**Place truncation is not cheap, and does not converge at all.** The partial
Euler product at s = ½ + iγ₁ is exactly "the adelic figure with all but finitely
many places dropped". [horn-helix.md](horn-helix.md) §5 sampled it at five
decades and read off "about 0.30 decades per decade", with the explicit caveat
that the sequence is oscillatory and no limit is claimed. Sampled sixteen times
to 2×10⁶ instead of five times to 10⁵:

```
   P            |∏_{p≤P} Z_p(½+iγ₁)|        arg
   10           0.1715783951                −0.0366
   30           0.1252702005                +0.3895
   10²          0.1071044717                +0.0881
   3×10²        0.06874584111               +0.2193
   10³          0.05939348402               −0.1743
   3×10³        0.06165377598               +0.6420
   10⁴          0.02278694606               +0.0604
   3×10⁴        0.1312087507                +0.5602
   10⁵          0.01311774803               +1.7630
   2×10⁵        0.06477301556               −2.3729
   3×10⁵        0.320010771                 −1.9918
   5×10⁵        0.01845550098               +2.6768
   7×10⁵        2.460101622                 −0.7120
   10⁶          0.4177308308                −1.6958
   1.5×10⁶      0.02783910335               −0.0504
   2×10⁶        0.0001377069861             +2.1808
                                            ζ(½+iγ₁) = 3.4e−41
```

Between P = 10⁴ and P = 2×10⁶ the modulus spans **more than four orders of
magnitude, non-monotonically** — 2.46 at P = 7×10⁵ and 1.4e−04 at P = 2×10⁶ —
and the phase wanders over the whole circle. The five-point rate was a fit, which
is what its own caveat said it might be; the flat statement is:

> **The place-truncated figure does not approach the value it is supposed to
> compute, at any rate, and nothing measured here bounds its excursions.**

The last row is the smallest value in the scan and should not be read as
convergence — four samples earlier the modulus is 17,865 times larger.

(Sampling convention: each row is the product up to the first prime ≥ P, so the
10⁵ row carries one factor more than [horn-helix.md](horn-helix.md) §5's
0.013084262 — that single factor is the whole 0.25 % difference between the two
numbers.)

So the trade README §6 struck is reversed by the completion:

> The helix shows you the integers and cannot decide (2.5×10³¹ gears). The horn
> decides and shows you no integers (one place, |u| ≤ 1.5). **The adelic object
> shows you every place and cannot decide from any finite set of them** — the
> divergence has moved from the depth axis, where it was geometric and cheap, to
> the place set, where it is not controlled at all.

### 5.3 Every local root number is unimodular, and their product does not converge

The mirror symmetry of the horn (README §5) is a local statement at every place.
Writing γ_v(s) = Z_v(1−s)/Z_v(s) for the local root number,

```
γ_v(s)·γ_v(1−s) = 1              exactly, at every place                   (17)
|γ_v(½ + it)| = 1                exactly, at every place                   (18)
```

verified at p = 2, 3, 5, 7, 1009 and v = ∞, at s = ½+iγ₁, 0.3+5i, 1.5+2i:
residuals ≤ 2.3e−41 for (17); for (18), **exactly 0** at 17 of the 18 rows and
1.1e−41 at the eighteenth, i.e. at the working precision throughout. So:

> **The functional equation is local.** Each place's figure has its own mirror,
> and the tilt breaks all of them at once — |γ_v| leaves the unit circle at every
> place simultaneously, at a rate that is that place's local log-derivative.

The archimedean one has a name: `arg γ_∞(½+it) = −2θ(t)`, the Riemann–Siegel
theta. Checked at t = 5, γ₁, 20, 50, 100 — the difference is an exact integer
multiple of π in every row (−1, −1, 0, 8, 28; the row at t = 20 agrees to
1.3e−31 with no reduction needed). **The horn's archimedean winding is θ, and θ
is the archimedean local root number's phase.**

But the *global* statement ∏_v γ_v(s) = 1 — which is ξ̃(1−s) = ξ̃(s), the
functional equation itself — is not obtained by multiplying the local ones.
Partial products on the line, all factors unimodular so only the phase moves:

```
    P          |∏_{v ≤ P} γ_v(½+5i) − 1|      |∏_{v ≤ P} γ_v(½+20i) − 1|
    10         0.660                          0.307
    10²        0.233                          0.257
    10³        1.543                          0.689
    10⁴        1.871                          0.627
    10⁵        1.248                          1.347
    10⁶        1.930                          0.855
    3×10⁶      1.952                          0.920
```

(the maximum possible value is 2). No approach to 1, no trend, at either height.
The control at σ = 1.5 shows the two halves of the local data behaving
completely differently: the local *factors* converge there —
|∏_{p≤P} Z_p − ζ| = 3.5e−02, 7.7e−03, 1.7e−03, 4.2e−04 at P = 10, 10², 10³,
10⁴ — while the local *root numbers* run away, |∏_{p≤P} γ_p| = 8.7e−03,
4.3e−20, 4.1e−209, 2.5e−2152.

### 5.4 The strip is exactly the gap between the two domains

The reason is structural and worth stating as the last of the negative results.
The local factor Z_p(s) converges for σ > 0 individually; the product ∏_p Z_p
converges for σ > 1; the reflected product ∏_p Z_p(1−s) converges for σ < 0.
**There is no s at which both sides of the local functional equation converge
absolutely.** The critical strip is precisely the gap.

That is [horn-helix.md](horn-helix.md) §5's obstruction — "the prime figure and
the zero figure cannot be drawn in the same region of the plane" — in its adelic
form, and the adelic form is sharper: it is not a fact about ζ or about how one
chooses to draw it. It is the elementary observation that a product and its
reflection have disjoint half-planes of convergence, with the strip between them.
Everything analytic in the subject happens where neither product exists.

---

## 6. Where this leaves the wall

Road A of [horn-helix-revisited.md](horn-helix-revisited.md) §4.2 said the adelic
route ends at a positivity statement at the archimedean place, and that this is
the same terminus as the top row of that file's §4.1 wearing different
coordinates. §4 here makes the coordinate change explicit and adds one number to
it.

The Weil functional is (16): a positive volume term, minus the archimedean local
term, minus every finite local term. Every finite term is computable, and for a
positive window every one of them is negative and individually harmless. The
question is whether the volume term survives all of them at once, for every
window and every translate — and §4.3's crossover table says that from
v ≈ 0.68 onward the subtraction is being done almost entirely by the finite
places, with the archimedean place contributing less than a thousandth of it by
v = 8.

So the adelic split does **not** localise the difficulty at ∞ in any naive sense —
at large separation ∞ contributes almost nothing. What Connes–Consani's
archimedean statement is about (as this file understands it, from the title and
the road-A reading of the predecessor — **not verified against the PDF here**;
TODO **A1**) is the local term (14) as an operator-theoretic object, not its
numerical size in a particular window. The distinction matters and this file does
not resolve it; what §4 contributes is the ledger those statements are statements
about, computed, place by place, to 21 digits.

The wall is unmoved. Its adelic phrasing is:

> RH ⟺ the volume term dominates the sum over every place, for every window and
> every translate. The places are individually elementary — (13) is three lines —
> and there are infinitely many of them, sampled at e^v, with no finite subset
> sufficient (§4.6) and no convergent product to work in (§5.4). That is
> [horn-helix-revisited.md](horn-helix-revisited.md) §4.2's terminus (i) — a
> positivity quantified over a family with no known finite generating structure —
> with the family now indexed by places rather than by test functions.

And [positivity-generator.md](positivity-generator.md) §4's theorem applies
verbatim: a finite family with a positive margin is blind above a computable
height. In the adelic reading that is the statement that **truncating the place
set is exactly as fatal as truncating the test-function family**, which §5.2's
sixth data point illustrates numerically.

---

## 7. What this does not do

**1. It proves nothing and moves no wall.** Every identity used is Tate or Weil.
The certified-floor decay of rh28/rh29 applies to §4's ledger verbatim — it *is*
that ledger, summed rather than split.

**2. The completion enlarges the hypothesis.** §3.5: the adelic object's zero
set is the union over the character fibres, so its closure criterion is GRH.
Nothing here couples the fibres, and an uncoupled family of criteria is not
progress on any one of them.

**3. §4's table is a decomposition, not a new computation.** The totals were
already in [positivity-generator.md](positivity-generator.md) §2.1, verified
there against the zeros. What §4 adds is the attribution — which place pays what
— and that attribution is a regrouping of a convergent sum, not an independent
result. Its value is §4.3, §4.5 and §4.6, which are statements the collected sum
cannot make.

**4. §4.1's archimedean local term is cited, not derived.** (14) is Weil's
evaluation of (12) at ∞, and the m = 0 principal value at the finite places is
Weil's convention. Both are taken on trust; the 21-digit balance is consistency,
not a derivation. So is (15), which is an identification by inspection.

**5. §5.2 refutes a fit, not a claim.** The partial Euler product's four-and-a-half
order excursion is consistent with everything [horn-helix.md](horn-helix.md) §5
and §11.3 said about the sequence being oscillatory and about no limit being
claimed. Sixteen points establish that the five-point rate was a fit; they
establish nothing about what the sequence does, and in particular the smallest
value in the scan sitting at the largest P is not evidence of convergence.

**6. The attributions are from memory.** §0 says so; TODO **A1** covers it. The
two Connes PDFs in this directory are named but were not read for this file, and
§6 says explicitly where that matters.

---

## 8. Verified numbers

mpmath, 30–40 decimal digits. The Weil-ledger totals use 22,837 primes below
260,000; the place counts of §4.6 use 1,857,859 places below 3×10⁷ in float64.

| quantity | value |
|---|---|
| translation identity (5), n = 2…101, u = −1…1.4 | worst rel. residual 2.3e−38 |
| raw orbit translation (4), n = 2…17 | residual ≤ 8.6e−42 |
| theta functional equation (6), x = 0.3, 0.7, 1, 3 | rel. residual 0.0 at 40 digits |
| finite-direction translation (7), m = 2, 3, 6 | rel. residual ≤ 3.5e−41 |
| local functional equation (17), 5 places × 3 points | residual ≤ 2.3e−41 |
| local unimodularity (18) on the line | exactly 0 in 17 of 18 rows, 1.1e−41 in the eighteenth |
| arg γ_∞(½+it) = −2θ(t) | difference an exact multiple of π (t = 5, γ₁, 20, 50, 100) |
| local ladder truncation, p = 2, K = 64 | 9.80891e−11 against the law's 5.62103e−10 |
| min/max \|Z_2(½+it)\| | 0.585786437627 / 3.41421356237 |
| min/max \|Z_101(½+it)\| | 0.909501243789 / 1.11049875621 |
| χ₅ fibre evenness, u = 0.2…1.4 | ≤ 1.1e−41 |
| χ₋₄ fibre evenness, u = 0.2…1.4 | ≤ 5.7e−42 |
| fibre transform (9) vs Λ(½+it, χ), χ₅ and χ₋₄ | rel. ≤ 1.4e−40 |
| fibre translation identity (10), 8 rows | worst rel. 1.2e−38 |
| first closure, χ₅ (even, q = 5) | t = 6.64845334472771472 |
| first closure, χ₋₄ (odd, q = 4) | t = 6.02094890469759665 |
| Weil ledger at v = 0: volume / ∞ / p = 2 / p = 3 | +0.284338251591 / −0.279916164061 / −1.2519397691e−03 / −5.0565552145e−07 |
| Weil ledger total at v = 0 | 0.003169642105395524440539 (= published E(0), 21 digits) |
| Weil ledger at v = 10: volume / ∞ / p = 22027 | +21.100727014180 / −9.5792803678e−04 / −0.017913876258 |
| Weil ledger total at v = 10 | −0.003167929015991991309161 (= published E(10), 21 digits) |
| places side vs zeros side (30 ordinates), v = 0, 1, 2, 5, 10 | rel. diff 2.0e−29, 3.4e−25, 1.8e−29, 1.8e−27, 2.5e−21 |
| archimedean/finite crossover \|Σ_p W_p\| = \|W_∞\| | v\* = 0.6701618091, both sides −0.1518012429 |
| \|Σ_p W_p\|/\|W_∞\| at v = 0, 5, 12 | 0.00447, 148, 1.63e+05 |
| \|C(½+iγ_k)\|, k = 1…6 (archimedean local factor at the closures) | 1.7433032e−03, 1.561327e−05, 9.2234749e−07, 1.8495538e−08, 2.9586262e−09, 9.6603429e−11 |
| places needed (term > 1e−20) at v = 0, 2, 5, 10, 14 | 4, 16, 179, 13,585, 520,050 (scan bound 3×10⁷ places) |
| largest single place at v = 10, 14 | p = 21,647 and p = 1,179,637 (against e^v = 22,026 and 1.20e+06) |
| sign of W_p, first 2000 places, v = 0, 5, 10 | negative without exception |
| local depth truncation for 1e−19, p = 2, 3, 5, 7, 101 | K = 129, 81, 55, 45, 19 |
| \|∏_{p≤P} Z_p(½+iγ₁)\|, P = 10⁴ … 2×10⁶ | 0.02278694606, 0.01311774803, 2.460101622 (7×10⁵), 0.4177308308 (10⁶), 0.0001377069861 (2×10⁶) — a factor of 17,865 between the last two named, non-monotone |
| \|∏_v γ_v(½+5i) − 1\|, P = 10³ … 3×10⁶ | 1.543, 1.871, 1.248, 1.930, 1.952 (max possible 2) |
| \|∏_{p≤P} γ_p(1.5+2i)\|, P = 10 … 10⁴ | 8.7e−03, 4.3e−20, 4.1e−209, 2.5e−2152 |
| \|∏_{p≤P} Z_p(1.5+2i) − ζ\|, P = 10 … 10⁴ | 0.034733, 0.00766384, 0.00174994, 0.000423521 |

---

## 9. Dictionary

New terms; folded into [../dictionary.html](../dictionary.html) and README §10
per the repo rule.

| term | meaning |
|---|---|
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

*Companions: [horn-helix.md](horn-helix.md) (the first pass),
[horn-helix-revisited.md](horn-helix-revisited.md) (the second, whose §3.5 this
file answers), [README.md](README.md) (the horn),
[../rh3/README.md](../rh3/README.md) (the helix),
[INTEGERS.md](INTEGERS.md) (the shells, and Poisson as the mechanism),
[positivity-generator.md](positivity-generator.md) (the kernel §4 decomposes).
The wall it does not move: rh28 §7.*
