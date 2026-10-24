# Q&A 001 — How does the rh42 three-thresholds paper relate to the twin-prime parity problem?

**Question asked.** *How does [`theorems/tpp-rh42-three-thresholds-paper.html`](../theorems/tpp-rh42-three-thresholds-paper.html)
relate to the twin-prime parity problem?*

**Answer in one paragraph.**  The paper is an **internal, machine-checked theorem of
the twin-prime parity programme** — the header reads *"Twin-prime-parity · round rh42 ·
ledger row T14"* — and it is **not** a result about twin primes or about the parity
obstruction.  It proves the ordering `pN < pP < p*` of three thresholds of the
ζ-valued *budgets* attached to the signed greedy expansion (the "harmonic sine"), and
by doing so it moves rh42's ledger row **T14** from `VERIFIED` (80-digit numerical
root-finding) to `PROVED` and machine-checked.  The only "parity" in the paper is the
**even/odd split of the harmonic series** (index parity), and the programme's own
harvest proves that exactly this parity is *invisible* to the twin-prime correlation
(`Σ λ(n)λ(n+2)` unchanged by the character `(−1)^n`).  So the relation is:
**a certified component of the programme's barrier map — it hardens the
index/budget side of the theory and leaves the multiplicative (Ω) side, where the
parity problem lives, untouched.**

---

## 1. What the paper is

| | |
|---|---|
| paper | *"Three thresholds of the rh42 budget: a machine-checked proof of `pN < pP < p*`"* — [`theorems/tpp-rh42-three-thresholds-paper.html`](../theorems/tpp-rh42-three-thresholds-paper.html) |
| object | the signed greedy expansion `α_n = (−1)^n/(n+2)^p` (the *Tau* alphabet), and its two ζ-valued budgets |
| claim formalised | ledger row **T14**: `pN < pP < p*` |
| status before | `VERIFIED` — numerical, `findroot` at 80 dps, residuals `< 1e−30` (source document [`../../../theorems/tpp/tpp-rh42-handoff-three-thresholds.md`](../../../theorems/tpp/tpp-rh42-handoff-three-thresholds.md)) |
| status after | `PROVED`, formalised in Lean 4 + Mathlib, 1091 lines, 3 modules, **no `sorry`** |
| formal development | [`../../../lean/TppLean/`](../../../lean/TppLean/) (`Core.lean`, `Budget.lean`, `ThreeThresholds.lean`), build driver `../../../lean/check.sh --all` |
| context | rh42 [`HANDOFF.md`](../rounds/rh42/HANDOFF.md) §5.1–5.3, §6 (rows T10–T15) |

The proof is deliberately **value-free**: it never evaluates ζ, never uses continuity
or the intermediate value theorem, and never locates a root.  It needs only
(i) strict antitonicity of the real Dirichlet series `ζ(p) = Σ n^{−p}` on `(1,∞)`,
(ii) four certified rational brackets for ζ (integer partial sums + integral tail),
and (iii) the **parity separation** `N(p) < P(p)`.  The crossings enter the theorem
as hypotheses, defined by their equations; only their *relative order* is proved.
See the paper's [§2.6](../theorems/tpp-rh42-three-thresholds-paper.html#s2),
[§3](../theorems/tpp-rh42-three-thresholds-paper.html#s3) and
[§7.1](../theorems/tpp-rh42-three-thresholds-paper.html#s7).

*Re-verified while writing this note:* `cd ../../../lean && ./check.sh --all`
exits 0 with `[check] OK` on `Core.lean`, `Budget.lean`, `ThreeThresholds.lean` and
the root module, and `grep -rn 'sorry\|admit' TppLean/ TppLean.lean` finds nothing.
The paper's build and no-`sorry` claims therefore hold on the workspace copy.

## 2. The three thresholds, and what they are thresholds *of*

| threshold | defining equation | value (source, 80 dps) | meaning inside rh42 | row |
|---|---|---|---|---|
| `p*` | `ζ(p) = 2` | 1.7286472389981836181 | the **combined** budget `P+N = ζ−1` reaches 1; equivalently the positive half becomes **complete** (Brown's criterion) | T14, T10 |
| `pP` | `2^{−p} ζ(p) = 1` | 1.4649845878051603837 | the **positive** budget `P(p)` reaches 1, i.e. `sin = +1` becomes writable | T14 |
| `pN` | `(1−2^{−p}) ζ(p) = 2` | 1.3777851698375411838 | the **negative** budget `N(p)` reaches 1, i.e. `sin = −1` becomes writable | T14 |
| `q` | `N(p) = 2·3^{−p}` | 2.07677517921069 | the **negative** half becomes complete — *not* in this paper (T13) | T13 |

These are thresholds in the **helix exponent `p`** along the real axis, not thresholds
in `x` for prime pairs.  The paper proves the first three are ordered; it does not
prove their values (the 19-digit numbers are the source's root-finding, reproduced as
context), and it does not cover `q` (listed as adjacent work,
[paper §13.2](../theorems/tpp-rh42-three-thresholds-paper.html#s13)).

*Normalisation caveat the paper states itself* (its §1.1): the source's negative
equation `(1−2^{−p})ζ(p) = 2` is `N(p) = 1`; the formal objective instead fixes the
negative budget at **level `L = 2`** (`pN = 1.2136…`).  The file also proves the
**level-general** form (`tpp_rh42_three_thresholds_level`, every `L ≥ 1`), so the
source's own `L = 1` value is an instance of the theorem.

## 3. The crux: two different things are called "parity"

The paper's one genuinely budget-specific step is titled **"the parity separation"**
(§6): the negative budget is strictly below the positive one **term by term**,
because every odd denominator `2k+3` exceeds the corresponding even one `2k+2`.

That parity is **index parity** — the even/odd position in the harmonic series.  It is
the analytic counterpart of rh42's *parity lock* (the signed support's gaps are all
even and `≥ 2`).  The programme's separate harvest (rh47) establishes that this is
**not** the parity of the twin-prime problem:

| | the paper's parity | the parity problem's parity |
|---|---|---|
| object | even vs odd **denominator index** | `Ω(n)` mod 2, i.e. `λ(n) = (−1)^{Ω(n)}` |
| carrier | the ζ budgets `P, N` | the multiplicative function `λ` |
| status w.r.t. the target | **REFUTED as a bridge** — the budgets are sign-blind `ζ`/`η` combinations and separate index parity, not `Ω`-parity (`χ²(1) = 2.944`); decisively, `λ(n)(−1)^n · λ(n+2)(−1)^{n+2} = λ(n)λ(n+2)` **identically**, so index parity is invisible to the correlation | **OPEN** — `Σ_{n≤x} λ(n)λ(n+2) = o(x)` |

Sources: dictionary [`03-parity-problem.md`](../dictionary/03-parity-problem.md) §5.4
(bridge **B2**, Theorem 5.5 twist-invariance), [`05-programme-barriers-and-harvest.md`](../dictionary/05-programme-barriers-and-harvest.md)
§2, rh47 [`truths.md`](../rounds/rh47/truths.md) §2.  The paper's own proof uses the
separation in exactly one place
([paper §7.1](../theorems/tpp-rh42-three-thresholds-paper.html#s7), Move 3), and that
place is precisely the index-parity inequality shown to carry no `Ω`-information.

## 4. How the paper is used *inside* the programme

T14 is load-bearing for the **index/budget layer** — the positive ledger of the
programme:

* it is the ordering on which the completeness rows **T10–T13** and the
  **budget-interval claim at `p*`** (row T15) depend, and which any
  *non-circular* "the target is already out of budget here" reachability argument
  must cite ([paper §12.1](../theorems/tpp-rh42-three-thresholds-paper.html#s12));
* it is the quantitative form of "the negative side runs out before the positive
  side", i.e. that the failure at `p*` is a failure of **placement**, not of length
  ([paper §10.2, §10.4](../theorems/tpp-rh42-three-thresholds-paper.html#s10));
* it strengthens the programme's *positive* ledger entries C1–C8 / P2–P4 (budgets,
  Brown's criterion, completeness thresholds) by making their common frame a theorem
  instead of a numerical observation.

None of these is a statement about factorisation.  The paper itself is explicit that
its object is arithmetic-free: the greedy rule reads only the target `sin(2πθ)`
(dictionary [`02-greedy-harmonic-sine.md`](../dictionary/02-greedy-harmonic-sine.md)
§6).

## 5. What the paper does **not** establish

* **Nothing about λ.**  No `Σ λ(n)`, no `Σ λ(n)λ(n+2)`, no statement about `Ω`.
* **Nothing about twin primes.**  No lower bound for `π₂(x)`, no positive
  proportion, no prime gaps.  That is the programme's standing non-claim N3
  ([`05`](../dictionary/05-programme-barriers-and-harvest.md) §3).
* **Not a proof of the parity obstruction either.**  It supplies no new obstruction
  and does not touch the open problem OP-3/R2 ("no sign-blind `log n`-rule can force
  a multiplicative correlation"), which remains **OPEN**
  ([`../open/07-open-problems.md`](../open/07-open-problems.md) §B.1, §B.4).
* **The values themselves are not formalised**, nor are the budget identities
  `P+N = ζ−1`, `P−N = 1−η`
  ([paper §8.3](../theorems/tpp-rh42-three-thresholds-paper.html#s8),
  [§13.1](../theorems/tpp-rh42-three-thresholds-paper.html#s13)).

## 6. The one narrow, genuine connection

The paper's transferable content is the **certified-enclosure technique** for real
Dirichlet series: exact integer partial sums via a verified floor oracle + an integral
tail bound + a rational bridge, plus `ZetaR_strictAnti` and the proved bridge
`ZetaR p = Re riemannZeta(p)` on `(1,∞)`.  The paper states this pattern "applies to
any Dirichlet series with nonnegative coefficients, to polylogarithms on the real
axis, and to `η, β, λ` and friends"
([paper §12.2](../theorems/tpp-rh42-three-thresholds-paper.html#s12),
[§11](../theorems/tpp-rh42-three-thresholds-paper.html#s11)).

That is a real methodological link — the same machinery could *certify numerical
facts* about λ-series and Euler products — but it does not reach the target:
`λ` is not nonnegative, and the two-point object `f(n) = λ(n)λ(n+2)` is **not
multiplicative** (no Euler product; discrepancy `2.0144` against a tail of
`1.84·10⁻⁵`, dictionary [`05`](../dictionary/05-programme-barriers-and-harvest.md)
P17/B3).  The programme's own conclusion is that the two layers **do not meet**
([`../README.md`](../README.md), "the one-paragraph summary").

## 7. Bottom line

1. **Provenance.** The paper *is* a twin-prime-parity artefact: round rh42, ledger row
   T14, part of the programme that set out to use the greedy harmonic sine against the
   parity problem.
2. **Content.** It certifies an ordering of three ζ-budget thresholds along `p`
   (Lean, no `sorry`), lifting a numerical row to a proved one.  It is a genuine
   addition to the programme's *positive ledger*.
3. **Relation to the target.** It strengthens the **index/budget** side of the barrier
   map and is a model illustration of why that side is not the multiplicative side:
   its only parity is index parity, which is provably irrelevant to
   `Σ λ(n)λ(n+2)`.
4. **Net effect on the twin-prime parity problem: none directly** — it neither proves
   nor refutes `o(x)`, and the programme's verdict (not reachable by this programme as
   it stands) is unchanged by it.  Its value is (a) internal rigour, and (b) a
   transferable certified-enclosure method.

---

## 8. Follow-up — what is the significance of proving `pN < pP < p*`?

**Follow-up question.** *What is the significance of "it proves `pN < pP < p*` for the
three ζ-valued budget thresholds of the signed greedy expansion"?*

**One-line answer.**  The **values are not the point; the order is**.  The ordering is
the quantitative form of the fact that the signed harmonic alphabet is *asymmetric* —
the positive (even-index) budget always exceeds the negative (odd-index) one — and it
fixes, in a strictly ordered way, which of the two endpoint targets `sin = ±1` the
greedy rule loses **first**, and how that loss sits relative to rh41's completeness
threshold `p*`.  It is a **structural, frame-setting theorem for the budget /
reachability layer**, and it is deliberately *value-free*: the 19-digit numbers are
not needed for it and are not what it certifies.

### 8.1 What the three crossings are crossings *of*

`P`, `N` and `ζ` are all strictly decreasing on `(1,∞)` (paper
[§2.4](../theorems/tpp-rh42-three-thresholds-paper.html#s2)); a decreasing function
crosses a level once.  So the three equations

```
P(pP) = 1 ,        N(pN) = L  (L ≥ 1) ,        ζ(p*) = 2
```

pick out three points of the same axis, and the theorem says they are ordered.  Read
in terms of the reachable range (the necessary condition of
[HANDOFF §5.4](../rounds/rh42/HANDOFF.md#L261)):

| exponent | positive budget `P` | negative budget `N` | combined `ζ−1` | which endpoints `sin = ±1` are inside budget |
|---|---|---|---|---|
| `p ≤ pN` | `≥ P(pN) > 1` | `≥ 1` | `> 1` | **both** `+1` and `−1` |
| `pN < p ≤ pP` | `≥ 1` | `< 1` | `> 1` | `+1` only; `−1` is out |
| `pP < p ≤ p*` | `< 1` | `< 1` | `≥ 1` (`= 1` at `p*`) | neither |
| `p > p*` | `< 1` | `< 1` | `< 1` | neither; the positive half is no longer complete |

So the ordering is exactly the statement that as the exponent rises (budgets shrink)
the **negative endpoint fails first**, then the positive one, and only afterwards does
the *combined* budget reach its critical length at `p*`.

### 8.2 The content is the asymmetry, not the numerics

Write the separation identically (`P − N = 1 − η(p)`, and `1 − η(p) ∈ (0, 2^{−p})` is
the "half-turn deficit" of ζ's alternating companion; HANDOFF
[§5.1](../rounds/rh42/HANDOFF.md#L186)).  In the source normalisation the two
inequalities of T14 reduce to:

* `pN < pP`  because  `N(pP) < P(pP) = 1 = N(pN)`  and `N` decreases —
  **this is the termwise parity separation evaluated at the single point `pP`, with no
  numerics at all**;
* `pP < p*`  because  `P(p*) = 2^{−p*}ζ(p*) = 2^{1−p*} < 1 = P(pP)`  and `P`
  decreases — one evaluation, using only `ζ(p*) = 2` and `p* > 1`.

That is the whole shape of the proof (the formal file works at level `L = 2` and
discharges the same content by trichotomy; paper
[§7.1](../theorems/tpp-rh42-three-thresholds-paper.html#s7)).  The significance is
that the ordering is **forced by the structure of the harmonic series**, not by
80-digit root-finding: the numbers merely say *where* the forced crossings lie.

### 8.3 It separates "out of budget" from "not complete"

`p*` is not just a budget crossing.  By Brown's criterion the positive half's sub-sums
fill `[0, P]` **iff** `ζ(p) ≥ 2`, i.e. iff `p ≤ p*` (dictionary
[`02`](../dictionary/02-greedy-harmonic-sine.md) §5, [`00`](../dictionary/00-dictionary.md)
row C5).  So `p*` is the *completeness* threshold of the positive half — rh41's
threshold — while `pP` is the *endpoint-budget* threshold.  The inequality `pP < p*`
therefore says:

> the target `+1` runs out of **budget** strictly before the positive half stops being
> **complete**.

Those are two genuinely different failure modes, and T14 places one strictly before
the other.  On the negative side the gap is even wider: `−1` leaves the budget at
`pN`, while the negative half stays complete all the way to `q = 2.0767…`; the full
ledger ordering is the programme's four-threshold row
`pN < pP < p* < q` (rows T13–T14; the paper covers the left three).

### 8.4 It makes the statement at `p*` non-vacuous

At `p*` the budget interval is `[−N(p*), P(p*)] = [−0.3965305…, +0.6034694…]`, of
length exactly `ζ(p*) − 1 = 1`, and it does **not** contain either endpoint.  The
ordering `pN < pP < p*` is what makes that a statement about **placement rather than
length**: the two endpoint thresholds lie strictly inside `(1, p*)`, so — in the
paper's own phrasing — the failure at `p*` is a failure of placement, not of length
(paper [§10.4](../theorems/tpp-rh42-three-thresholds-paper.html#s10); HANDOFF
[§5.3](../rounds/rh42/HANDOFF.md#L245)).  This is also why the result must be a
**strict** ordering, and why the formalisation needs *strict* antitonicity rather than
the one-line non-strict version (paper
[§2.4](../theorems/tpp-rh42-three-thresholds-paper.html#s2)): at `p*` the inequalities
are tight.

### 8.5 Why it is needed downstream: it removes circularity

T14 is the input that lets the reachability theory argue without re-deriving its own
frame: the completeness rows **T10–T13**, the **budget-interval claim at `p*`**
(row T15), and every argument of the form *"this target is already out of budget
here, because the corresponding budget crossed below it earlier"* need a strict
ordering of the crossings (paper
[§12.1](../theorems/tpp-rh42-three-thresholds-paper.html#s12)).  The paper also notes
that any later threshold that must lie between `pN` and `p*` inherits a **proved
frame** ([paper §14.6](../theorems/tpp-rh42-three-thresholds-paper.html#s14)).  That
is the sense in which T14 is *load-bearing*: not because
it is deep, but because other rows may cite it instead of a numerical root-finder.

### 8.6 Why "proved" matters, not just "true to 19 digits"

The programme's own rule is that a finite numerical check is never a proof of an
asymptotic statement.  Here the object being ordered is an *asymptotic* (a limit of
partial sums / a crossing of an infinite series), so an 80-dps `findroot` with
residual `< 1e−30` is evidence about a computation, not a theorem about the limit
(paper [§10.1](../theorems/tpp-rh42-three-thresholds-paper.html#s10)).  Because T14 is
cited by later rows, leaving it numerical would contaminate the proof chain; making it
a Lean theorem (no `sorry`) lets the downstream reachability arguments be *proved*
rather than *calibrated*.  The transferable by-products are the value-free ordering
pattern (strict monotonicity + one anchor per curve + one separating inequality; no
intermediate value theorem, no continuity, no root-finding) and the certified
enclosure machinery for real Dirichlet series (paper
[§10.3](../theorems/tpp-rh42-three-thresholds-paper.html#s10),
[§11](../theorems/tpp-rh42-three-thresholds-paper.html#s11)).

### 8.7 What the significance is **not**

None of the above is significance for the twin-prime parity problem.  The ordering is
a fact about **indices and the real ζ** (`P`, `N` are constants in `p`; the only
"parity" is even/odd index parity), and it carries no information about `Ω`, about
`Σ λ(n)λ(n+2)`, or about twin primes — as §3–§5 above spell out.  So the honest
summary of its significance is:

* **for the ledger:** a load-bearing numerical row becomes a machine-checked theorem,
  and the four-threshold frame `pN < pP < p* < q` gets its left half proved;
* **for the method:** a reusable, value-free way to order crossings of monotone
  ζ-series and to certify Dirichlet-series enclosures in Lean;
* **for the goal (twin primes / parity):** none — it hardens the index/budget side of
  the barrier map and leaves the multiplicative side untouched.

---

## 9. Follow-up — what if the real ζ's radial decay could distinguish `n` from `n+2`?

**Follow-up question.** *What would happen if we gave the real-valued ζ radial decay
the ability to differentiate between `n` and `n+2`, while still not a complex number?*

**Short answer.**  You can do it, and it stays real — but you thereby **leave the
multiplicative world**, and the object you land on is the real two-point Dirichlet
series `D(σ) = Σ λ(n)λ(n+2) n^{−σ}`, whose behaviour as `σ ↓ 1` *is* the open
statement `Σ_{n≤x} λ(n)λ(n+2) = o(x)`.  Realness is **not** what makes the
programme's ζ work: the one-point series `Σ λ(n)n^{−σ} = ζ(2σ)/ζ(σ)` is real-valued
and has an Euler product.  The **additive shift** is what breaks it — `n ↦
λ(n)λ(n+2)` is not multiplicative, so there is no Euler product (programme P17/B3).
A shift-sensitive real radial decay therefore does not open a route; it renames the
target, and if the shift is supplied by `Ω`-data it is circular (bridge B5).  Dropping
complex numbers also drops exactly the tools the known parity-crossings use (analytic
continuation, functional equation, explicit formula, spectral/Hecke input) while
leaving the parity barrier — which is a limitation of the *class of inputs*, not of
`ℝ` versus `ℂ` — exactly where it was.

### 9.1 A shift-sensitive *weight* alone does nothing

If all that changes is the decaying weight `w(n)` — e.g. use `w(n) = (n(n+2))^{−p}`
or a shifted Hurwitz-type profile `(n+a)^{−p}` — then `Σ_n w(n)` is still a
**one-point constant**: no function of `n` alone can couple `n` to `n+2`.  The shift
becomes visible only when the **summand** depends on the pair, i.e. when the series is
`Σ_n f(n) n^{−σ}` with `f(n) = λ(n)λ(n+2)` (or another genuinely two-point object).
Restricted to real, non-circular inputs, the possibilities are:

| what the radial decay sees | example | real? | Euler product? | decides `S(x)=o(x)`? |
|---|---|---|---|---|
| one-point `λ` | `Σ λ(n)n^{−σ} = ζ(2σ)/ζ(σ)` | yes | **yes** | no — shift-blind |
| periodic real weight | `Σ χ(n)n^{−σ}`, `χ` real mod `q` | yes | yes (`L`-function) | no — small-prime residue data cannot see `Ω` (dictionary [`03`](../dictionary/03-parity-problem.md) Theorem 2.2) |
| shift-sensitive two-point | `D(σ) = Σ λ(n)λ(n+2)n^{−σ}` | yes | **no** | equivalently the open statement |
| `Ω`-selected alphabet | `α_p = (−1)^{Ω(p+2)}/(p+2)` | yes | no | circular — imports the correlation (B5) |

### 9.2 Why the shift, not the real/complex choice, is the obstruction

`λ` is completely multiplicative, so its one-point real Dirichlet series factors:
`Σ λ(n)n^{−σ} = ζ(2σ)/ζ(σ)`.  The shifted product `f(n) = λ(n)λ(n+2)` is **not**
multiplicative (programme P17), and the failure is quantitative: the programme's
`D(2) = Σ_{n≤10⁶} f(n)/n² = −1.12681304`, against the naive multiplicative model
`0.88757352`, a discrepancy `2.0144` far above the tail `1.84·10⁻⁵`.  So a
real-valued shift-sensitive zeta has **no local (Euler-product) description**: its
`σ`-behaviour is not computable from the primes, which is precisely why the ζ
machinery — budgets, Brown's criterion, thresholds, the explicit formula — has nothing
to attach to.

### 9.3 What you would actually get: an Abelian reformulation of the open problem

Let `S(x) = Σ_{n≤x} f(n)`.  Partial summation gives, for `σ > 1`,

```
D(σ) = σ ∫_1^∞ S(x) x^{−σ−1} dx .
```

So the real radial decay is the (real) Mellin/Laplace transform of `S`, and the
boundary behaviour at `σ = 1` encodes the answer:

* `S(x) ~ c x` (positive density) `⟹ D(σ) ~ c/(σ−1)` — a pole at `σ = 1`;
* `S(x) = o(x)` `⟹ D(σ) = o(1/(σ−1))` — no pole.

The forward (Abelian) implication is elementary.  The **converse is a Tauberian
statement**, and the classical real-variable engines — Landau's theorem (needs
non-negative coefficients), Wiener–Ikehara (needs positivity), monotone-density
arguments — are exactly unavailable, because `f` is `±1`-valued and `S` is expected to
*oscillate down to* `o(x)`.  This is the same positivity wall the parity problem is
made of.  Two further facts fix the limits:

* the **log-averaged** version (weight `n^{−1}`, i.e. `σ = 1` with a cutoff) is a
  **theorem** (Tao 2016, dictionary [`03`](../dictionary/03-parity-problem.md) §3.4),
  and it does **not** imply the un-averaged `σ ↓ 1` statement (dictionary
  [`03`](../dictionary/03-parity-problem.md) §4.3).  The radial exponent interpolates a
  proved boundary case (`σ = 1`, logarithmic) and an open one (`σ ↓ 1`, un-averaged);
* **finite data cannot decide it.**  A prefix of length `X` determines `D(σ)` only to
  `O(X^{1−σ}/(σ−1))` for fixed `σ > 1`, and the **finite-prefix indeterminacy**
  theorem (programme F4/P16) shows two functions agreeing on `[1,10⁸]` can have
  `S''/x → 1` against a believed `S/x → 0`.  Real inversion formulas such as
  Post–Widder do recover `S` from all real `σ > 1` in principle, but only through
  `σ ↓ 1` and derivatives of arbitrarily high order — precisely the regime that is not
  computable and that F4 rules out as evidence.

### 9.4 What it would break inside the rh42 budget theory

Even before reaching the open problem, a shift-sensitive decay costs the structure the
T14 paper relies on:

* the budget identities `P + N = ζ − 1` and `P − N = 1 − η(p)` come from the
  **even/odd split of the unshifted `ζ`**; a decay that distinguishes `n` from `n+2`
  has no such closed form;
* T14's one clean ingredient — the termwise **parity separation** `N(p) < P(p)` —
  becomes an index-shifted comparison with no term-by-term witness, so the value-free
  ordering proof ([§8.2](#82-the-content-is-the-asymmetry-not-the-numerics)) does not
  apply;
* the thresholds `pN, pP, p*, q` are defined by equations in `ζ`; with a
  shift-sensitive weight they become **two-parameter** (exponent and shift), so
  `pN < pP < p* < q` is no longer a single ordering, and one is back to numerical
  root-finding — the very thing the paper removed.

In short, the modification trades a *proved, arithmetic-free index structure* for a
*numerically probed arithmetic correlation*.

### 9.5 The real/complex point, stated plainly

The parity obstruction (Selberg, sharpened by Polymath8b; dictionary
[`03`](../dictionary/03-parity-problem.md) Theorem 2.1) is a no-go for a **method
class**: bounded-depth sieve weights built from local densities, i.e. non-negative
weights that cannot distinguish `E` from `O`.  It contains no statement about `ℝ`
versus `ℂ`.  Conversely, the arguments that *have* crossed a parity barrier —
Friedlander–Iwaniec on `X² + Y⁴`, and the automorphic/spectral inputs behind it
(dictionary [`03`](../dictionary/03-parity-problem.md) §5.4, HEURISTIC 5.4) — use
complex `L`-functions and Hecke theory.  A real-only radial theory keeps the Abelian
(Mellin with real exponent) and Landau/Tauberian facts; it loses Cauchy/contour
integration, Perron, analytic continuation past the abscissa, the functional
equation, the explicit formula, zero-free regions and spectral decomposition.  So
"still not a complex number" is a real restriction, but not one that buys anything:
it removes tools without removing the barrier.

### 9.6 Bottom line

Either the shift-sensitivity is wired in from `λ`/`Ω` — in which case it is
**circular** (the signal lives in the alphabet, B5, and you have imported the
correlation you are studying) — or it is a genuinely new arithmetic input that couples
a sign-blind rule to `Ω` at positive density, in which case it **is** the programme's
precise missing ingredient ([`05`](../dictionary/05-programme-barriers-and-harvest.md)
§4) and would be a real breakthrough.  There is no third option that keeps the
ζ/Euler-product machinery: any real-valued radial decay able to distinguish `n` from
`n+2` in the summand has already left that world, and its `σ ↓ 1` limit is two-point
Chowla.  Realness is not the obstacle; the additive shift is.

---

## 10. Working forward — the cone: radial decay as an index coordinate

> **Superseded as a standalone note.**  This development has been expanded — with the
> pair-greedy rule, the critical-cone residue numerics (`N = 10⁸`), a Lean development
> and an HTML rendering — into
> [`../cone/cone-critical-pair-greedy.md`](../cone/cone-critical-pair-greedy.md)
> ([HTML](../cone/cone-critical-pair-greedy.html)).  §10 is kept as the Q&A-log trail.

**Follow-up question.** *We don't need complex numbers for radial decay: scale each term
by `1/n` and we get a cone instead of a helix, which makes each point's coordinates
accessible and visible.  What does that buy?*

**Answer up front.**  It is the right move, and it does real work.  Scaling term `n` by
`n^{−p}` opens the unit helix into a **cone whose reciprocal radius is the index `n`**:
the helix is the degenerate `p = 0` cone.  On the cone the additive shift `n ↦ n+2`
is an exact radial map on the *same sheet*, so a pair `(n, n+2)` acquires two canonical
**real** invariants — the symmetric pair weight `r_n r_{n+2}` and the antisymmetric
radial separation `r_n − r_{n+2}`.  The symmetric one turns the two-point correlation
into a real, absolutely convergent **cone pair transform** whose pole sits at the
**critical cone `p = 1/2`** with residue equal to the mean value of `λ(n)λ(n+2)`.  So
in cone coordinates:

> **the parity statement `Σ_{n≤x} λ(n)λ(n+2) = o(x)` is exactly "the cone pair
> transform has no pole at the critical cone `p = 1/2`."**

Everything visible *on* the critical cone (the log-averaged sums) is a theorem
(Tao's log-Chowla); the residue is the open part.  The cone therefore **localizes**
the open problem to one real pole, and it does so without a single complex number.

### 10.1 The cone, with real coordinates only

For a decay exponent `p ≥ 0` and a real angular parameter `t`, place the `n`-th term at

```
C_n(t) = ( n^{−p} cos(t log n),  n^{−p} sin(t log n),  n )   ∈ ℝ³ ,   n = 1, 2, 3, …
```

Equivalently in sheet coordinates `(r, φ, h) = (n^{−p}, t log n, n)`.  The terms live
on the cone `r = h^{−p}`.  Three immediate and useful facts:

* **The index is a coordinate.**  `n ↦ C_n(t)` is injective, and the readout is
  `n = r^{−1/p}` (for `p = 1` simply `n = 1/r`).  Every term has its own radius, so the
  expansion is *decodable term by term*.
* **The helix is the `p = 0` cone.**  At `p = 0`, `r ≡ 1` and the readout is constant:
  no index information.  This is exactly rh42's "the word cannot see the turns"
  (dictionary [`02`](../dictionary/02-greedy-harmonic-sine.md) §3): the helix is the
  zero-decay cone, and adding radial decay is what restores the lost coordinate.
* **No ℂ is used.**  `cos`, `sin` and `n^{−p}` are real functions.  The signed Tau
  alphabet is the case `φ_n = πn + t log n`, since
  `cos(πn + ψ) = (−1)^n cos ψ`.

The user's `1/n` scaling is the case `p = 1`.  On that cone the greedy alphabet is
literally the radius: `Σ_{m∈A} 1/m = x`, the target.  Verified exactly for rational
targets (alphabet `1/m`, `m = n+2`):

| `x` | greedy support `m` | `Σ 1/m` | cone mass `= x`? |
|---|---|---|---|
| `1/3` | `{3}` | `1/3` | ✓ |
| `1/2` | `{2}` | `1/2` | ✓ |
| `2/3` | `{2, 6}` | `2/3` | ✓ |
| `5/9` | `{2, 18}` | `5/9` | ✓ |
| `7/11` | `{2, 8, 88}` | `7/11` | ✓ |
| `1` | `{2, 3, 6}` | `1` | ✓ |

So "each point's coordinates accessible" is literal: the radii are the terms, and they
sum to the target.

### 10.2 The shift is a radial map, and the pair has two real invariants

The map `n ↦ n+2` sends

```
h ↦ h + 2 ,    ρ := 1/r ↦ ρ + 2  (exact) ,    r ↦ r · (n/(n+2))^p ,
```

and on the Tau alphabet the sign is preserved, `(−1)^{n+2} = (−1)^n`: **the pair
`(n, n+2)` lies on the same ray of the cone.**  That is the geometric form of the
programme's twist-invariance identity (dictionary [`03`](../dictionary/03-parity-problem.md)
Theorem 5.5).  The pair then has two canonical real invariants:

* **symmetric** — the pair weight / "area": `r_n r_{n+2} = (n(n+2))^{−p}`;
* **antisymmetric** — the radial separation / sheet derivative:
  `r_n − r_{n+2} = n^{−p} − (n+2)^{−p} ≈ 2p n^{−p−1}`.

### 10.3 The cone pair transform, and why `p = 1/2` is critical

Contracting the symmetric invariant with the correlation gives the **cone pair
transform**

```
C_f(p)  =  Σ_{n≥1} λ(n) λ(n+2) (n(n+2))^{−p} ,      f(n) = λ(n)λ(n+2) ,
```

absolutely convergent exactly for `2p > 1`, i.e. **`p > 1/2`**.  Partial summation
with `S(x) = Σ_{n≤x} f(n)` gives `C_f(p) = 2p ∫_1^∞ S(x) x^{−2p−1}(1 + O(1/x)) dx`,
so:

* `S(x) ~ c x` (positive density) `⟹ C_f(p) ~ 2pc/(2p−1)` — a **pole at `p = 1/2`**;
* `S(x) = o(x)` `⟹ C_f(p) = o(1/(2p−1))` — **no pole**.

The residue at the critical cone is the mean value: `lim_{p↓1/2} (2p−1) C_f(p) = c`.
This is the same pole as the `D(σ)=Σ f(n)n^{−σ}` of §9, re-parametrised (`σ = 2p`);
the cone's contribution is to make `p = 1/2` *geometric*.

**Cone dictionary.**

| cone `p` | one-point weight `n^{−p}` (line `σ = p`) | pair weight `(n(n+2))^{−p}` (line `σ = 2p`) | status |
|---|---|---|---|
| `p = 0` | `1` — the helix; no decay, no index | `1` | index invisible |
| `p = 1` (the `1/n` cone) | `σ = 1`, the pole/log line; `Σ λ(n)/n = 0` (PNT) | `σ = 2`, absolutely convergent | one-point a theorem; pair a computable number |
| `p = 1/2` (**critical cone**) | `σ = 1/2`, the critical line (rh43, `√N` error) | `σ = 1`, the log-average regime | on the cone: theorem (Tao); the residue: **open** |
| `p > 1` | `σ > 1`, the budget range (rh42) | `σ > 1` | budgets/thresholds exist |
| `1/2 < p ≤ 1` | one-point divergent: **no budget theory** | pair convergent | **new window**: the pair is computable where budgets do not exist |

Two consequences worth keeping: (i) the `1/n` cone is the *harmonic* cone where the
expansion lives and the mass equals the target, but the *correlation's* frontier is the
critical cone `p = 1/2`; (ii) since `p = 1/2` is precisely where the one-point budgets
diverge, the cone makes vivid *why* the budget layer and the correlation layer do not
meet — they live on different cones.

### 10.4 Theorem on the critical cone, and why the residue is the only open part

At `p = 1/2` the pair weight is `1/√(n(n+2)) = (1/n)(1 + O(1/n))`, so the
*undifferenced* (symmetric) log-average is the log-Chowla object:

```
Σ_{n≤x} f(n)/√(n(n+2))  =  Σ_{n≤x} f(n)/n  +  O(1)  =  o(log x)      (Tao's theorem) .
```

The antisymmetric invariant behaves differently, and the difference is informative:
the radial separation decays **one power faster** than the pair weight,

```
r_n − r_{n+2} = n^{−p} − (n+2)^{−p} = ∫_n^{n+2} p x^{−p−1} dx  ≤  2p n^{−p−1} ,
```

so the shift-differencing channel

```
B(p) = Σ_{n≥1} f(n) (r_n − r_{n+2}) = Σ n^{−p} ( f(n) − f(n−2) )
```

is **absolutely convergent for every `p > 0`** (bounded by `2p Σ n^{−p−1}`) — before
any cancellation in `f` is used.  For `p = 1` it equals `2 C_f(1)` exactly
(the identity check in §10.5 exhibits the telescoping to `2.5·10⁻⁷`).  Hence:

> **differencing along the shift costs exactly one power of `n`.**  The
> shift-antisymmetric statistic is always in the absolutely convergent (theorem)
> regime and *cannot* see the mean value.  The mean value lives only in the
> shift-symmetric pair weight `r_n r_{n+2}`, whose pole at the critical cone `p = 1/2`
> is the open part.

So the cone delivers a clean dichotomy: the *symmetric* channel carries the mean value
as a pole at `p = 1/2` (open), while the *difference* channel is analytic and trivial
(theorem).  That is the precise sense in which "making `n` and `n+2` distinguishable"
does — and does not — help: it gives an absolutely convergent statistic, i.e. it
discards exactly the residue we are after.

### 10.5 Numerics on the real cone (`N = 4·10⁶`, no ℂ)

Sieve `λ` up to `4·10⁶`, `f(n) = λ(n)λ(n+2)`.

| `p` | `C_f(p) = Σ f(n)(n(n+2))^{−p}` | truncation tail `≈ M^{1−2p}/(2p−1)` |
|---|---|---|
| `1/2` | `−0.863772` (partial sum; log-divergent) | `∞` |
| `0.6` | `−0.7202208504` | `0.239` |
| `0.7` | `−0.6078124265` | `0.0057` |
| `0.8` | `−0.5196978209` | `0.0002` |
| `1` | **`−0.3927555878`** | `2.5·10⁻⁷` |
| `1.5` | `−0.2145524256` | `0` |
| `2` | `−0.1207675238` | `0` |

Only `p ≳ 0.7` is numerically trustworthy at this `N`; approaching `p = 1/2` the
truncation tail swamps the signal (`2.19` at `p=0.55`, `485` at `p=0.501`).  That is
the frontier made concrete: **the residue is not visible in a finite prefix.**

On the critical cone itself, the *log-averages* behave exactly as the theorem predicts:

| `x` | `Σ_{n≤x} f(n)/n` | `÷ log x` | `Σ_{n≤x} λ(n)/n` |
|---|---|---|---|
| `10⁴` | `−1.3614` | `−0.1478` | `0.004280` |
| `10⁵` | `−1.3543` | `−0.1176` | `0.001403` |
| `10⁶` | `−1.3561` | `−0.0982` | `0.000814` |
| `4·10⁶` | `−1.3564` | `−0.0892` | `0.000400` |

The pair ratio drifts to `0` (Tao's `o(log x)`, slowly), the one-point sum drifts to
`0` (PNT).  And the reason real-variable positivity cannot find the residue is visible
in the same run: the **majorant** of the critical cone is `Σ 1/√(n(n+2)) = 14.8972`,
i.e. `0.9800 · log x` — it grows like `log x` *regardless of the mean value*.  The only
pole a non-negativity argument (Landau, Wiener–Ikehara) can force at `p = 1/2` is that
spurious majorant pole; the signed series has none.  **That is the parity obstruction
drawn on the cone.**

Identity checks (all consistent):

* cone-derivative identity:
  `C_f(1) = ½[ f(1) + f(2)/2 + Σ_{n≥3}(f(n) − f(n−2))/n ]`,
  left `−0.3927555878`, right `−0.3927553378` (difference `−2.5·10⁻⁷` = the tail);
* greedy cone mass `Σ_{m∈A} 1/m = x` exact on all seven rational targets above.

### 10.6 What the cone gives the programme

1. **A named critical exponent.**  The open statement becomes a *real* pole question at
   `p = 1/2`: locate (or rule out) the residue of `C_f`.
2. **A new computational window.**  For `1/2 < p ≤ 1` the pair transform converges
   absolutely while the rh42 one-point budgets diverge — so the two-point correlation
   is probeable by a real cone transform in a regime where the budget/threshold theory
   does not exist.
3. **A one-parameter family.**  The programme's helix (`p = 0`), its greedy/budget cone
   (`p > 1`, and the harmonic `p = 1` where mass `= x`) and the critical line of rh43
   (`p = 1/2`) are the same object at different cone angles.
4. **A precise statement of the gap.**  The critical cone's readable data is
   theorem-level (the symmetric log-average is `o(log x)`; the shift-difference channel
   is absolutely convergent `O(1)`); what is missing is a real-variable tool that sees
   the *residue* — and the only pole positivity can force is the spurious majorant pole.

### 10.7 Next steps (falsifiable)

1. **Cone-greedy rule.**  Define the pair-greedy rule (take a radial pair `(n, n+2)`
   iff the pair resultant fits the residual) and compute `C_{f,A}(p)` for its support
   `A`; test the residue proxy against size-matched random supports (the cone version of
   rh47's B1 probe).
2. **Push the numerics toward `p = 1/2`.**  Use a smoothed kernel (or a Richardson /
   tail-subtraction estimate) to estimate `lim (2p−1)C_f(p)` from the reliable range
   `p ∈ [0.7, 1.5]`; the finite-range answer is a *numerical observation only*, by
   house rule.
3. **Write up the one-power dichotomy.**  The shift-difference channel is absolutely
   convergent (`≤ 2p Σ n^{−p−1}` for every `p > 0`), and `B(1) = 2C_f(1)` exactly; this
   is a small clean lemma about the cone and belongs in the ledger, next to the
   observation that the mean value survives only in the undifferenced channel.
4. **Test multiplicativity on the cone.**  Replace `f` by a real-character twist (one
   point) and by `f` (two point); the first has an Euler product and the second does
   not — quantify how much of `C_f` is invisible to any Euler-product model.
5. **The crux.**  Ask whether any positivity-preserving symmetrisation of `C_f`
   (e.g. `Σ (1 + f(n)) w(n)`) can transfer information about `c`; if not, that is
   evidence for the cone form of OP-3: *no sign-blind cone statistic sees the residue*.

## 11. Follow-up — what would `Σ_{n≤x} λ(n)λ(n+2) = o(x)` buy?

**Follow-up question.** *What would `Σ_{n≤x} λ(n)λ(n+2) = o(x)` buy?*

**One-line answer.**  It would buy exactly one thing, and it is a large one: **the
first un-averaged, parity-breaking cancellation across an additive shift** — the
asymptotic equidistribution of the Liouville pair `(λ(n), λ(n+2))`, each of the four
sign patterns having density `1/4`.  It would **not** buy the twin prime conjecture,
Sarnak/Möbius disjointness, the full Chowla conjecture, or anything about the zeros of
`ζ`.

### 11.1 What the statement literally says

By the programme's Theorem 3.5 ([`03`](../dictionary/03-parity-problem.md#L359)), for
`S(x) = Σ_{n≤x} λ(n)λ(n+2)`,

```
S(x) = 2·#{n ≤ x : λ(n) = λ(n+2)} − (x − 2) ,
```

so `S(x) = o(x)` ⟺ `#{n ≤ x : λ(n) = λ(n+2)} = x/2 + o(x)`, and — given the one-point
theorem `k = 1 ⟺ PNT` ([`03`](../dictionary/03-parity-problem.md#L329)) — ⟺ each of the
four patterns `(±1, ±1)` has density exactly `1/4`.  Concretely: the integers `n` for
which both `n` and `n+2` have an odd number of prime factors (with multiplicity) have
density `1/4`, and likewise for the other three parity combinations.  It is a statement
of **statistical independence of `Ω(n) mod 2` and `Ω(n+2) mod 2`**.

### 11.2 What it would buy

1. **The first new case of Chowla.**  `k = 1` is PNT (a theorem); `k = 2` at a fixed
   shift is open ([`03`](../dictionary/03-parity-problem.md#L349)).  A proof for
   `h = 2` would be the first genuinely new instance — and, by 11.1, the first
   un-averaged parity-breaking result for a **non-multiplicative** correlation:
   `f(n) = λ(n)λ(n+2)` has no Euler product ([`05`](../dictionary/05-programme-barriers-and-harvest.md)
   P17/B3), so the `ζ`/Dirichlet-series toolkit cannot even be applied to it.
2. **A new technique, not just a new theorem.**  The barrier ledger says the missing
   ingredient is a sign-blind rule coupled to `Ω` at positive density
   ([`05`](../dictionary/05-programme-barriers-and-harvest.md#L66) §4); the cone
   formulation says the same analytically: the cone pair transform must have **no pole
   at `p = 1/2`**, and the only pole positivity can force is the spurious majorant pole
   ([`../cone/cone-critical-pair-greedy.md`](../cone/cone-critical-pair-greedy.md) §4).
   So a proof must supply a *new positivity structure* or a *new arithmetic input*
   (bilinear/spectral/automorphic).  Whatever it is, it would very likely transfer to
   other shifts `h` — that is the real prize.
3. **The upgrade of a known theorem.**  The logarithmically averaged version is a
   *theorem* (Tao 2015/16, [`03`](../dictionary/03-parity-problem.md) T2, Theorem 3.8),
   and the programme's finite-prefix theorem (F4/P16) shows the upgrade from
   log-averaged to un-averaged cannot come from any finite computation.  So `o(x)`
   would certify a genuinely new mechanism rather than a longer computation.
4. **An immediate combinatorial corollary.**  All four length-2 sign patterns occur in
   the Liouville word with density `1/4`: the shift-2 block entropy of `λ` is maximal at
   block length 2.
5. **Confirmation of the random-sign heuristic's mean.**  The expected `o(x)` would
   become a theorem (not the expected `O(x^{1/2+ε})` size, which is a strictly stronger
   statement; [`03`](../dictionary/03-parity-problem.md#L319) HEURISTIC 3.2).

### 11.3 What it would *not* buy

| would it give … | answer | why |
|---|---|---|
| twin primes, `π₂(x) → ∞` | **no** | the class `λ(n)=λ(n+2)=−1` has density `1/4`, but the twin primes have density `0` inside it (Hardy–Littlewood `~2C₂x/log²x`): the statement is about **parity**, not primality — and the converse also fails ([`03`](../dictionary/03-parity-problem.md#L582) §5.1(b),(c)) |
| removal of the parity no-go | **no** | Selberg's parity principle is a limitation of a *method class* (bounded-depth sieves), not of a correlation, and is untouched by any theorem about `λ`-correlations ([`03`](../dictionary/03-parity-problem.md#L169) §2.1) |
| Sarnak's conjecture / Möbius disjointness | **no** | `Σ_{n≤x} λ(n)e(nα) = o(x)` is governed by the correlations **averaged over shifts**, by Fourier duality; a single shift says nothing about the spectrum.  Sarnak for rotations and nilsystems is already known by other means, and the full (un-averaged) Chowla conjecture is what implies Sarnak ([`03`](../dictionary/03-parity-problem.md#L426) T3/3.10; [`../open/07-open-problems.md`](../open/07-open-problems.md) OP-17) |
| the full Chowla conjecture | **no** | `k ≥ 3` is a separate family; the record also withdraws the claim that `k`-point Chowla "contradicts the twin-prime failure mode" ([`03`](../dictionary/03-parity-problem.md#L600) §5.1, correction X6) |
| anything about `ζ`'s zeros / RH | **no** | the correlation is a statement about `Ω`-parity; unlike `k = 1` (which is *equivalent* to PNT) there is no known zero-free-region equivalence here |
| a finitely checkable certificate | **no** | finite-prefix indeterminacy (F4/P16): two functions agreeing on `[1, 10⁸]` can have `S''(x)/x → 1` while the true `S(x)/x → 0` |

### 11.4 What it would buy *for this programme*

* It would **refute the programme's own heuristic barrier** — not a theorem (OP-3 is
  open), but the working hypothesis that no sign-blind `log n`-rule can force a
  multiplicative correlation.  A proof would exhibit precisely the missing ingredient,
  and the five disposed bridges B1–B5
  ([`05`](../dictionary/05-programme-barriers-and-harvest.md#L39) §2) already say what
  it cannot be: the greedy support (B1, B4), the `ζ` budgets (B2), the `ζ`-machinery
  (B3), or an `Ω`-alphabet imported by hand (B5, circular).
* It would turn the cone note's open problem into a theorem: the cone pair transform's
  residue at the critical cone vanishes, `lim_{ε↓0} ε C_f(1/2 + ε/2) = 0`.
* It would **not** rehabilitate the programme's instruments: the greedy harmonic sine
  remains arithmetic-free, and the theorem would say the *correlation* is tractable, not
  that the sine is the right tool for it.

### 11.5 The honest summary

`S(x) = o(x)` is a **methodological** statement, not a primality statement.  Proving it
would be a landmark — the first un-averaged parity-breaking cancellation across an
additive shift, the first new case of Chowla since PNT, and a technique the whole
"correlations of multiplicative functions" area would absorb.  It would still leave the
twin prime conjecture exactly where it is: the primes are a density-zero subset of the
very class the theorem counts, and no parity statement about `Ω` can manufacture a
prime.

---

*Status legend — THEOREM: proved (Lean where noted); NUMERICAL: finite computation
only, never a proof of an asymptotic; OPEN: no proof known; REFUTED: with a witness.
All links above are relative to this folder.*
