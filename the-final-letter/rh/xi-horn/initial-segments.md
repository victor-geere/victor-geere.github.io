# The exception sets are not initial segments — in the ambient class, the witness degree can run backwards

Self-contained up to the definitions of [gorz-gap.md](gorz-gap.md) §1, which
are restated in §1 below. Every witness, proposition and number in this file
is either proved here or computed in exact rational arithmetic; §9 collects
the numbers, §10 the code.

**What is being answered.** [gorz-gap.md](gorz-gap.md) §7.5 proves that the
*union* E_∞ = ∪_d E(d) of the Jensen exception sets is an initial segment
[0, ν), and leaves open whether each **individual** E(d) is one — noting that
for a general positive sequence it need not be, with the four-term example
(1, 2, 1, 100). That example is only a sequence; it is not the Taylor data of
anything in the class the machinery quantifies over. The open question was
whether membership in the class repairs it.

**What this file proves.** It does not. The initial-segment property fails
**inside the ambient class** — real entire, genus 1\*, all Taylor
coefficients positive, exactly the hypotheses of gorz-gap's Theorems 1–3:

* **(z² − 6z + 13)·e^z** has E(2) = {2, 3} and E(3) = {1, 2, 3}: the shift
  n = 0, which carries the hardest information, is *invisible* at degrees
  where later shifts have already failed (§4).
* **(z² − 8z + 73)·cosh(√z)** — **order ½, the same order as ξ's F** — has
  E(2) = {1} with 0 ∉ E(2) (§5).
* **(z² − 60z + 1681)·cosh(√z)** has witness degrees D(n) = 5, 4, 3, 2:
  strictly **decreasing**, the exact mirror of the conjectured monotone
  picture, saturating the unconditional staircase bound of §3 with equality
  at every step (§5).

Around the witnesses, four structural results. (1) Equivalences: all E(d)
initial segments ⟺ the witness-degree function D is non-decreasing ⟺
differentiation shrinks every E(d) (§2). (2) The staircase: unconditionally,
for any positive sequence, D(m) ≤ D(n) + (n − m) — a gap in any E(d) closes
at slope 1 (§3). (3) A dichotomy with proof in the solvable model: center
left of ½ ⟹ every E(d) is an initial segment; and **positivity + the Turán
property together force the center left of ½** — so in the quadratic model
the Turán inequalities *do* repair the property (§6). (4) A confinement
lemma for ξ itself: every zero of every derivative F^(n) has real part
≤ ¼ − γ₁² = −199.54…, unconditionally — the witnesses' mechanism, a defect
center migrating through the origin, is not available to ξ at any shift (§7).

**What this file does not prove.** Whether **ξ's own** E(d) are initial
segments. Under RH the question is vacuous (every E(d) = ∅). Unconditionally
it is open in both directions, and the witnesses close only the cheap route:
no proof can succeed from positivity and genus alone, and — by §6's random
scan, in which 3 923 of 4 000 log-concave positive sequences have a gap —
not from positivity + log-concavity alone either. §8 states what remains.

---

## 0. Standing disclaimer

Nothing here is deep. The equivalences of §2 are bookkeeping on one shift
identity; the staircase is gorz-gap's L3(i) iterated, which is Rolle's
theorem; the dichotomy of §6 is elementary calculus on gorz-gap's closed
form (13); the confinement lemma of §7 is a Laguerre-type argument on a
genus-0 log-derivative, classical in substance. The witnesses are the
content, and they are computations. What is new relative to
[gorz-gap.md](gorz-gap.md) is the *answer to its §7.5 question in the
ambient class*, the final-segment law of §5, and the sharpened form the
question now takes for ξ (§8).

---

## 1. The question, stated exactly

From [gorz-gap.md](gorz-gap.md) §1: a real entire function f of genus 1\*
with Taylor data a(n) = f^(n)(0) > 0 has Jensen polynomials and exception
sets

```
J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j
E(d)  = { n ≥ 0 : J_{d,n} not hyperbolic }
D(n)  = min { d : n ∈ E(d) }          (∞ if none)      the witness degree
ν     = min { n : f^(n) ∈ LP }
```

gorz-gap Theorem 1: E(d) ⊆ E(d+1). Theorem 2: E_∞ = ∪_d E(d) = [0, ν), an
initial segment. The question ([gorz-gap.md](gorz-gap.md) §7.5, last
paragraph):

> Theorem 2 says the *union* E_∞ is an initial segment. It does **not** say
> each E(d) is.

Call a set S ⊆ ℕ an **initial segment** if n ∈ S and m < n imply m ∈ S. A
**gap** in E(d) is a witness against this: m < n with n ∈ E(d), m ∉ E(d).

---

## 2. Three ways to say "initial segment"

**Proposition 1.** For f as above, the following are equivalent:

1. every E(d), d ≥ 1, is an initial segment;
2. D is non-decreasing on E_∞ = [0, ν);
3. E_{f′}(d) ⊆ E_f(d) for every d — *differentiation shrinks every
   exception set*.

*Proof.* (1) ⟺ (2): E(d) = {n : D(n) ≤ d} is the sublevel set of D, and
every sublevel set of a function on an initial segment is an initial segment
iff the function is non-decreasing. (1) ⟺ (3): the Taylor data of f′ is the
shifted sequence a(n+1), so J^{f′}_{d,n} = J^f_{d,n+1} termwise and
E_{f′}(d) = {n : n+1 ∈ E_f(d)}. The inclusion E_{f′}(d) ⊆ E_f(d) says
exactly that n+1 ∈ E_f(d) implies n ∈ E_f(d), which is downward closure. ∎

Reading (3): gorz-gap Theorem 1 says raising the *degree* only reveals
exceptions; the initial-segment property would say raising the *shift* —
differentiating — only heals them. The first is a theorem (Rolle); the
second, this file shows, is false in the class. A per-d signature worth
naming: since N(d) = 1 + max E(d), a gap in E(d) is the same thing as
**#E(d) < N(d)** — gorz-gap Theorem 3's two suprema still agree at ν, but
the witnesses below have #E(2) < N(2) at finite d.

---

## 3. The staircase — how bad a gap can be, unconditionally

**Proposition 2.** For any positive sequence and any m < n:
if n ∈ E(d) then m ∈ E(d + n − m). Equivalently `D(m) ≤ D(n) + (n − m)`.

*Proof.* The contrapositive of gorz-gap L3(i) says: J_{d,n} not hyperbolic ⟹
J_{d+1,n−1} not hyperbolic. Apply it n − m times. (This is the same n-fold
iteration that proves gorz-gap's Corollaries 5 and 6; Corollary 6 is the
m = 0 case.) ∎

So a gap is a strictly bounded defect: a shift missing from E(d) below an
exception joins at latest n − m degrees later, and E(d) always contains the
45°-shadow {n − k : n ∈ E(d−k)}. Stress-tested exactly as a regression, in
the style of gorz-gap §2: over 300 random positive rational sequences
(d ≤ 8, n ≤ 8; 4 339 hyperbolic and 17 261 non-hyperbolic instances, so the
test is not vacuous), **34 016 staircase instances, 0 violations** (§9).

The witnesses below make the bound sharp: each one saturates
D(m) = D(n) + (n − m) with equality along its whole anti-diagonal.

---

## 4. The minimal witness: (z² − 6z + 13)·e^z

Zeros 3 ± 2i — one conjugate pair, **center x₀ = 3 in the right half-plane**,
height β₀ = 2. This is gorz-gap's exactly solvable family §7.1 at
(b, c) = (−6, 13); everything below is both predicted by its closed form
(13) and verified independently by exact Sturm real-root counting on the
sequence (§10). The Taylor data is a(m) = c_m = m² − 7m + 13:

```
m      0   1   2   3   4   5   6   7   8
a(m)  13   7   3   1   1   3   7  13  21      positive for every m (min 1)
```

Exact tables, d ≤ 50, n ≤ 12:

```
E(1) = ∅
E(2) = {2, 3}            <-- 0, 1 ∉ E(2): not an initial segment
E(3) = {1, 2, 3}         <-- 0 ∉ E(3):    not an initial segment
E(d) = {0, 1, 2, 3}      for every 4 ≤ d ≤ 50   ( = E_∞ = [0, ν), ν = 4 )

D(n) = 4, 3, 2, 2        n = 0, 1, 2, 3
```

The closed form says why. From gorz-gap (13), for alive shifts
(Δ_n = −16 + 4n < 0),

```
D(n) = ⌊r(n)⌋ + 1,   r(n) = 4c_n/|Δ_n| = 1 + x₀(n)²/β_n² ,
x₀(n) = 3 − n  (the center, drifting left one unit per derivative),
β_n²  = 4 − n  (the height, sinking to extinction at ν = 4).
```

r(n) = 13/4, 7/3, 3/2, 1: the center **crosses the origin at n = 3**, and
while it crosses, the ratio x₀²/β² — the only thing degree-d Jensen
polynomials can see — collapses. The defect is *easiest* to detect just
before it dies and *hardest* at n = 0. Note the two checks against §2 and
§3: the Turán margin a(n+1)² − a(n)a(n+2) = 10, 2, −2, −2, 2, 10, … fails
exactly on E(2) = {2, 3}; E_{f′}(2) = {1, 2} ⊄ E_f(2) = {2, 3}
(f′ = (z² − 4z + 7)e^z, one shift down), so differentiation *created* an
exception at a shift where f had none; and D(0) = D(2) + 2, D(1) = D(2) + 1
— the staircase attained with equality.

A second instance one street over, (z² − 8z + 21)·e^z (zeros 4 ± i√5,
a(m) = m² − 9m + 21, minimum 3/4 at m = 4.5): exact tables give
D(n) = 5, 4, 3, 2, 2 and E(2) = {3, 4}, E(3) = {2, 3, 4}, E(4) = {1, 2, 3, 4}
— a longer anti-diagonal, same mechanism.

---

## 5. The order-½ witnesses, and the final-segment law

An objection to §4 in the style of gorz-gap §6: ξ's F has order ½, and
witnesses should live in the same house. They do. Both instances below are
order ½ exactly, with positive Taylor data
a(m) = m!·(1/(2m−4)! + b/(2m−2)! + c/(2m)!) (positive for all m: checked
exactly for m ≤ 59, and for larger m the leading term dominates —
|b|/((2m−2)(2m−3)) + c-term < 1 already at m = 4 resp. m = 6). Tables are
exact Sturm counts over d ≤ 14, n ≤ 22; the non-real pair of each f^(n) is
tracked by root-finding an 80-term truncation at 40 digits inside |z| < 400
— a zero beyond that window is unseen, not absent (the same honesty clause
as TODO G4).

**Witness A: (z² − 8z + 73)·cosh(√z)**, zeros 4 ± i√57.

```
E(1) = ∅
E(2) = {1}               <-- 0 ∉ E(2), 1 ∈ E(2): a gap at degree 2
E(d) = {0, 1}            3 ≤ d ≤ 14        D(0) = 3,  D(1) = 2

pair of f^(n):  4 ± 7.55i  →  1.63 ± 4.77i  →  all zeros in window real
                (n = 0)        (n = 1)           (n ≥ 2, so ν = 2)
```

The Turán inequality fails **only at n = 1** — an isolated Turán failure
strictly after a Turán success, which no initial-segment picture permits.

**Witness B: (z² − 60z + 1681)·cosh(√z)**, zeros 30 ± i√781.

```
E(2) = {3}          E(3) = {2, 3}          E(4) = {1, 2, 3}
E(d) = {0, 1, 2, 3}   5 ≤ d ≤ 14

D(n) = 5, 4, 3, 2    strictly decreasing

pair of f^(n):  30 ± 27.9i → 21.5 ± 22.1i → 12.4 ± 16.0i → 2.28 ± 8.49i → real
                (n = 0)      (n = 1)        (n = 2)         (n = 3)        (ν = 4)
```

The pair marches toward the origin at roughly nine units per derivative and
dies just past it; detectability improves monotonically along the walk. The
exact tables and the independently computed trajectory agree on
E_∞ = [0, ν) — Theorem 2 cross-checked two ways.

**The final-segment law.** Witness B's pattern is not accidental. In the
family (z² − 2sz + c)·cosh(√z) **at the positivity binding** — the least c
keeping every a(m) > 0, scanned at s = 30, 40, 60, 90, giving ν = 4, 4, 5, 6
— the exception sets came out

```
E(d) = { ν−d+1, …, ν−1 }   for 2 ≤ d ≤ ν,      i.e.   D(n) = ν − n + 1 :
```

each E(d) is a **final segment** of [0, ν), the exact mirror of the
conjectured picture, and the staircase of §3 is attained with equality
everywhere. The reading: at the binding, the witness degree measures the
defect's **remaining lifetime**, not its size. (A scan observation, not a
theorem, and it deforms away from the binding — at s = 40, c = 2961 the
tables show E(2) = {3} with ν = 5 and an uptick D(4) = 3 > D(3) = 2, still
gapped but no longer the pure anti-diagonal — and it is a right-half-plane
phenomenon: the left-plane instance (z² + 2z + 2)cosh√z of gorz-gap §7.2
has D(0) = 3 = ν + 2, breaking it by one.)

---

## 6. The Turán refinement — what ξ's known coefficient facts do and do not repair

ξ's sequence satisfies the Turán inequalities unconditionally — E(2) = ∅ is
Csordas–Norfolk–Varga 1986 ([turan-inequalities.pdf](turan-inequalities.pdf),
restated as [GOR⁺] Theorem 2.1) — and every witness above has E(2) ≠ ∅. So
the sharpened question is whether **positivity + Turán** forces initial
segments. Three results, one in each direction:

**Proposition 3 (dichotomy in the quadratic model).** In the family
(z² + bz + c)e^z with all a(m) > 0: if b ≥ −1 (center x₀ = −b/2 ≤ ½), every
E(d) is an initial segment.

*Proof.* On alive shifts D(n) = ⌊r(n)⌋ + 1 with r(n) = 1 + x₀(n)²/β_n²
(gorz-gap (13), rewritten as in §4). x₀ ≤ ½ makes x₀(n)² = (x₀ − n)²
non-decreasing over integers n ≥ 0, β_n² is strictly decreasing, so r is
strictly increasing, D is non-decreasing, and sublevel sets of a
non-decreasing function are initial segments. ∎

**Proposition 4 (Turán forces the tame half).** In the same family with all
a(m) > 0 and ν ≥ 1: if the center is right of ½ (b < −1), then E(2) ≠ ∅.
Hence positivity + Turán ⟹ b ≥ −1 ⟹ (Proposition 3) every E(d) is an
initial segment: **in the quadratic model, the Turán property repairs the
initial-segment property.**

*Proof.* Write g = x₀ − β₀² and suppose E(2) = ∅, i.e. x₀(n)² ≥ β_n² at
every alive n.

(i) *The pair cannot cross the origin while alive.* Let n_c = ⌈x₀⌉ be the
first integer with x₀(n_c) ≤ 0; x₀ > ½ gives n_c ≥ 1 and
x₀(n_c) ∈ (−1, 0]. If n_c were alive, then β²_{n_c} > 0, so
β²_{n_c−1} = β²_{n_c} + 1 > 1; but E(2) = ∅ at n_c − 1 demands
β²_{n_c−1} ≤ x₀(n_c−1)² = (x₀(n_c) + 1)² ≤ 1 — contradiction. So
ν ≤ ⌈x₀⌉.

(ii) *Positivity forces g < 0.* a(m) = c_m = (x₀ − m)² + β₀² − m is a
quadratic in m with real minimum −(g + ¼) at m = x₀ + ½ and sub-zero window
of width 2√(g + ¼). If g > 0 the window is an open interval of length > 1,
hence contains an integer m with a(m) < 0. If g = 0 the window is
(x₀, x₀ + 1): either it contains an integer, or x₀ ∈ ℤ and a(x₀) = 0. All
cases contradict a(m) > 0. So g < 0, i.e. β₀² > x₀, and
ν = ⌈β₀²⌉ ≥ ⌈x₀⌉.

(iii) With (i): ν = ⌈x₀⌉ exactly. At the last alive shift, u := x₀(ν−1) ∈
(0, 1], and r(ν−1) − 1 = u²/(u + |g|) < u²/u = u ≤ 1, so r(ν−1) < 2 and
ν − 1 ∈ E(2) — contradicting E(2) = ∅. ∎

Regression: 1 327 positive-data quadratic models scanned exactly, 726 with
E(2) = ∅, **0 gaps** among them (§9) — and every gap witness the searches
ever produced in this family indeed carries a Turán failure.

**But the repair does not survive past the model.** Two measurements:

* **Log-concavity alone is nowhere near sufficient.** Over 4 000 random
  log-concave positive sequences (ratios a(n+1)/a(n) sorted decreasing),
  **3 923 have a gap** in some E(d), d ≤ 7. Gaps are *generic* among
  log-concave sequences; the Turán property as a sequence condition carries
  almost no initial-segment information. (These sequences need not be
  genus-1\* Taylor data, so this bounds the hypothesis, not the class.)
* **In the class, a Turán-respecting gap was not found — and not for lack of
  looking.** One-pair e^z models cannot do it (Proposition 4). Every
  right-plane cosh instance for which full tables were computed — a dozen
  models, s = 4 through 90, at and above the binding — has E(2) ≠ ∅: the
  pair is always maximally visible at some shift before it dies. Quartic
  e^z models with a right-plane defect pair and a ballast factor (z + t)² —
  both death regimes β₀² ≷ x₀, quarter-integer β₀², t up to 512 — yield
  gaps in the nine models that survive positivity, every one with
  E(2) ≠ ∅.

So the refined class question — *does positivity + genus 1\* + Turán imply
every E(d) is an initial segment?* — is **open**: proved in the simplest
family, false just outside the class, no counterexample inside it. It is
exactly the shape of question gorz-gap §6 warns about: whether it is a
theorem or has a witness decides whether CNV86 buys ξ anything here.

---

## 7. The confinement — why ξ cannot run the witnesses' mechanism

Every witness above works the same way: a defect center in or near the right
half-plane **migrates through the origin** under differentiation, and the
visible ratio x₀²/β² collapses on the way. For ξ this road is closed,
unconditionally:

**Lemma (confinement).** Let f be real entire of genus 0 with f(0) ≠ 0 and
zeros {z_k} satisfying R := sup_k Re z_k < ∞. Then every zero of f′ has
real part ≤ R.

*Proof.* f = f(0)·Π(1 − z/z_k) with Σ 1/|z_k| < ∞, so f′/f = Σ 1/(z − z_k)
locally uniformly off the zeros. Let f′(w) = 0. If f(w) = 0, then w is some
z_k. Otherwise Σ_k (Re w − Re z_k)/|w − z_k|² = 0; if Re w > R every
summand is positive — impossible. ∎

**Application to ξ.** F is real entire of order ½ (hence genus 0) with
F(0) = a(0) > 0. Its zeros are z = −t² over the zeros ½ + it of ξ; writing
t = γ − iδ with |δ| < ½ (the strip) and |γ| ≥ γ₁ = 14.1347… (the first
zero's height, classical),

```
Re z = δ² − γ² ≤ ¼ − γ₁² = −199.5404…
```

Each F^(n) is again real entire of order ½ with F^(n)(0) = a(n) > 0, so the
lemma applies inductively: **every zero of every derivative F^(n) — real or
not — has real part ≤ ¼ − γ₁² < −199.5.** For F itself the non-real zeros
are exactly the off-line zeros of ξ, and a hypothetical off-line zero has
|γ| > 3 000 175 332 800 (Platt–Trudgian, as quoted in gorz-gap §1.3), so any
defect of F sits left of ¼ − 9.001 × 10²⁴; the derivatives' defects,
wherever the flow puts them, stay left of −199.5 by the lemma.

What this does and does not close. It closes the *literal* mechanism: no
defect of ξ, at any shift, ever approaches the origin; centers stay pinned
more than 199 units deep (10²⁴ units, for a genuine off-line defect) in the
left half-plane, for every derivative, forever. It does **not** close the
abstract mechanism: the witnesses' D dips because the dimensionless ratio
x₀²/β² falls, and for a defect at Re ≈ −γ² with |Im| ≈ 2|γ|δ nothing here
constrains how that ratio evolves under differentiation. The question for ξ
survives, one story sharper.

---

## 8. Where this leaves the question for ξ

```
RH                        ⟹  every E(d) = ∅: initial segments, vacuously.
positivity + genus alone  ⟹  nothing: §4–§5 witnesses.
+ log-concavity (CNV86)   ⟹  nothing at the sequence level: §6's 3 923/4 000.
+ log-concavity, in class ⟹  open (§6): proved only in the quadratic model.
ξ's confinement (§7)      ⟹  the witnesses' mechanism excluded; the
                              dimensionless dip not excluded.
```

The one-sided facts worth keeping: gaps are bounded by the staircase
(Proposition 2) whatever happens; a gap for ξ at any d would mean
#E(d) < N(d), i.e. GORZ's threshold overstates the count at that degree;
and by Proposition 1(3) the whole question is the question of whether
differentiation can ever *create* a Jensen exception for ξ where none was —
the direction of flow that Rolle's theorem does not govern.

---

## 9. Verified numbers

Exact rational arithmetic (Sturm chains on the squarefree part; hyperbolic
⟺ distinct real roots of the squarefree part = its degree) for every table;
mpmath at 40 digits for the trajectories. The Sturm tester itself is
regression-checked against sympy's real_roots on 400 random polynomials, 0
mismatches.

| quantity | value |
|---|---|
| harness vs gorz-gap §7.1 (b=1, c=3): D(0), D(1), D(2) | 2, 3, 10 — reproduced |
| harness vs gorz-gap §7.2: (z²+1)cosh√z | E(d) = {0}, d = 2…8 — reproduced |
| (z²−6z+13)e^z: E(2), E(3), E(d≥4) | {2,3}, {1,2,3}, {0,1,2,3} (d ≤ 50) |
| (z²−6z+13)e^z: D(n) | 4, 3, 2, 2 = ⌊13/4⌋+1, ⌊7/3⌋+1, ⌊3/2⌋+1, ⌊1⌋+1 — closed form (13) exact |
| (z²−6z+13)e^z: Turán margins n = 0…5 | 10, 2, −2, −2, 2, 10 — fails exactly on E(2) |
| (z²−8z+21)e^z: D(n) | 5, 4, 3, 2, 2; E(2) = {3,4} |
| (z²−8z+73)cosh√z: E(2), E(d) 3 ≤ d ≤ 14 | {1}, {0,1} (n ≤ 22) |
| (z²−8z+73)cosh√z: pair of f^(n) | 4 ± 7.5498i → 1.6335 ± 4.7734i → real (ν = 2) |
| (z²−60z+1681)cosh√z: D(n) | 5, 4, 3, 2 — strictly decreasing |
| (z²−60z+1681)cosh√z: pair of f^(n) | 30±27.95i → 21.45±22.10i → 12.44±16.00i → 2.28±8.49i → real |
| final-segment law at the binding, s = 30, 40, 60, 90 | E(d) = {ν−d+1,…,ν−1}, ν = 4, 4, 5, 6 — exact; deforms above the binding (s = 40, c = 2961: E(2) = {3}, ν = 5) |
| staircase stress | 34 016 instances, **0** violations (4 339 hyp / 17 261 non-hyp) |
| column-chain stress (J_{d+n,0} hyp ⟹ J_{d,n} hyp) | 213 instances, **0** violations |
| Prop 4 regression: positive quadratic models / E(2) = ∅ / gaps | 1 327 / 726 / **0** |
| log-concave random sequences with a gap, d ≤ 7 | **3 923 / 4 000** |
| quartic e^z search (both regimes, ballast to t = 512) | 9 gap models survive positivity, all with E(2) ≠ ∅ |
| γ₁, γ₁², ¼ − γ₁² | 14.13472514173469379, 199.79045483238685946, −199.54045483238685946 |
| Sturm tester vs sympy real_roots | 400 random polynomials, 0 mismatches |

---

## 10. Reproduction

```python
# ---- hyperbolicity, exactly: Sturm on the squarefree part ------------------
# hyperbolic(p)  <=>  # distinct real roots of p/gcd(p,p') == deg(p/gcd(p,p'))
# (all arithmetic in Fractions; signs at +-infinity from leading coefficients)

# ---- the quadratic family (gorz-gap 7.1), b < -1 ---------------------------
a[m]   = c + m*b + m*m - m               # = (x0-m)^2 + (beta0^2 - m),  x0 = -b/2
r(n)   = 1 + (x0-n)**2 / (beta0**2 - n)  # alive n;  D(n) = floor(r(n)) + 1
# witness: b, c = -6, 13  ->  r = 13/4, 7/3, 3/2, 1  ->  D = 4, 3, 2, 2
# cross-check every witness by direct Sturm on J(d,n) built from a[.]

# ---- the order-1/2 family --------------------------------------------------
a[m]   = fact(m) * ( 1/fact(2m-4) + b/fact(2m-2) + c/fact(2m) )   # 1/(neg)! := 0
# witness A: b, c = -8, 73     witness B: b, c = -60, 1681
J(d,n) = [ C(d,j)*a[n+j] for j in 0..d ] ;  E(d) = { n : not hyperbolic(J(d,n)) }

# ---- pair trajectory (numerical, honesty-bounded) --------------------------
# roots of sum_{k<=K} a[n+k] z^k/k!,  K = 80, mpmath 40 dps, window |z| < 400

# ---- staircase / column-chain stress ---------------------------------------
# random positive rational sequences; check
#   n in E(d), m < n  =>  m in E(d+n-m)         (Prop 2)
#   J_{d+n,0} hyperbolic  =>  J_{d,n} hyperbolic (gorz-gap Cor 5 engine)

# ---- log-concave scan -------------------------------------------------------
# ratios = sorted 4000x [rand rationals], decreasing; a = cumprod(ratios);
# count sequences with a hole below max E(d) for some d in 3..7
```

---

## 11. What this does not do

**1. It says nothing about ξ's own exception sets.** All computed scans of
ξ's sequence show E(d) ∩ [0, 30] = ∅ (gorz-gap §7.5), consistent with
[GOR⁺] Corollary 1.3's d ≤ 9 × 10²⁴; a gap for ξ, if one exists, lives
beyond every computable degree. The witnesses locate the *question*, not
ξ's answer.

**2. The witnesses are not evidence about ζ.** As in gorz-gap §10: they
calibrate what the Jensen machinery can express, and they say where a proof
cannot come from — positivity, genus, and (at the sequence level)
log-concavity. They do not say the property fails for ξ.

**3. The final-segment law is a scan, not a theorem.** It held in every
right-half-plane cosh instance tested and already fails by one unit for a
left-plane instance. No claim beyond the table.

**4. ν for the cosh witnesses is window-certified, not proved.** The gaps
themselves are unconditional (each cell is an exact Sturm count); the
statements "E(d) stabilises at {0,1} resp. {0,1,2,3}" rest on d ≤ 14,
n ≤ 22 plus the tracked death of the pair inside |z| < 400. A defect beyond
the window is unseen, not absent.

**5. The confinement lemma does not prove ξ's E(d) are initial segments.**
It closes one mechanism. §7's last paragraph is the honest boundary.

---

*Sources, all local:* [gorz-gap.md](gorz-gap.md) (definitions, L1–L3,
Theorems 1–3, the solvable family and its closed form (13), the §7.5
question); **[CNV86]** Csordas–Norfolk–Varga, *The Riemann hypothesis and
the Turán inequalities*, Trans. AMS **296** (1986) —
[turan-inequalities.pdf](turan-inequalities.pdf), restated as [GOR⁺]
Theorem 2.1; **[GOR⁺]** [jensens-polynomials.pdf](jensens-polynomials.pdf)
(Corollary 1.3 and the Platt–Trudgian height, quoted via gorz-gap §1.3);
**[O'S]** [zeros-jensens-polynomials.pdf](zeros-jensens-polynomials.pdf)
(the Jensen criterion, Corollary 3.2, used through gorz-gap Theorem 2).
