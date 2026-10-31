# Capturing Weil positivity — route assessment and a concrete first target

**Status:** investigation note. No theorem is claimed, and nothing here asserts RH.
This note assesses the five mechanisms proposed for capturing Weil positivity,
separates what is provable from what is RH-equivalent, and recommends a concrete
first target. It is a companion to [`README.md`](README.md) and to
[`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md) §7.

**The object.** For `g = f * f̌` in the Weil cone, Weil's current is

```
⟨W, g⟩ = 2∫ g(u) cosh(u/2) du − 2 Π(g) + (1/2π) ∫ ĝ(t) Ω(t) dt,
Π(g)   = Σ_{n≥2} Λ(n)/√n · g(log n),
Ω(t)   = Re ψ(1/4 + it/2) − log π,
```

and Theorem C of `tensor.md` gives, unconditionally on the cone,
`⟨W, g⟩ = Σ_ρ ĝ(γ_ρ)`. Positivity of this form on the whole cone is Weil's
criterion, i.e. RH. The question is what can be *captured* without assuming RH.

---

## 0. Executive summary

1. **Uniform versions of all five mechanisms are RH-equivalent, not softer.** Any
   argument that bounds the form below uniformly on the cone — an SOS identity with
   an operator-norm remainder, a coercive block diagonal with controlled cross terms,
   a bounded positive operator, or a truncation whose tail is smaller than its gap —
   already proves that no zero is off the line. The reason is the modulated-Gaussian
   family of the converse direction: an off-line zero drives the form to `−∞` while
   the test function's norm stays bounded, so *any finite lower bound* rules it out.
   A uniform mechanism is therefore a proof of RH, not a step toward one.
2. **What is provable is positivity on sub-cones.** The natural filtration is by the
   support of the test function. On the `L`-th rung, `Π(g)` has only the finitely
   many terms with `log n ≤ L`; the statement is finite. The first rung, `L < log 2`,
   has no prime term at all and reduces to an archimedean inequality.
3. **Only the Euler-product mechanism can plausibly upgrade finite rungs to the cone**,
   because it is the only one that fails for Davenport–Heilbronn. But no candidate
   factorization is known, and the function-field analogue (Hodge index) has no known
   number-field counterpart.
4. **Recommended first target:** certify `⟨W, f_σ * f_σ⟩ > 0` for the Gaussian
   `f_σ(u) = exp(−u²/2σ²)` in the prime-free regime `σ ≈ 0.03–0.05`, where the
   numerical margin is `≈ 0.043` and the prime side is `< 10^{−20}`. This needs one
   new analytic layer — a rigorous enclosure of `Ω`, i.e. of `Re ψ(1/4+it/2)` — and
   would be the programme's first certified instance of Weil positivity.
5. **The margin law.** For the Gaussian family the form is dominated by the first
   zero, `⟨W, g_σ⟩ ≈ 4πσ² e^{−σ²γ₁²}`. The margin collapses exponentially as the
   support widens, which is the quantitative reason a fixed-precision ladder stalls
   and why operator-norm tails must be exponentially accurate.

---

## 1. The object, and the three ways to state positivity

Write `Q(f) := ⟨W, f * f̌⟩ = Σ_ρ ĝ(γ_ρ)`, `ĝ(z) = f̂(z) conj(f̂(conj z))`, so that
`ĝ = |f̂|²` on the real axis. Three distinct statements must be kept apart:

| statement | quantification | logical status | provable? |
|---|---|---|---|
| **Cone positivity** | every `f` in the cone | equivalent to RH (Theorem C(3), classical) | no, and it *is* RH |
| **Sub-cone positivity** | every `f` with `supp f ⊂ [−L/2, L/2]` | finite statement (finitely many primes) | in principle: finite, but a whole rung needs a uniform inequality |
| **Single-test-function positivity** | one explicit `f` | a finite computation | yes, and it is the first rung of the ladder |

The companion `tensor.md` already contains the two extremes: the *negative* single
witness of Theorem B (`⟨P, f₀*f₀⟩ = −0.6773…`) and the *equivalence* of Theorem C.
What is missing is everything between: a positive certificate for an explicit `f`,
and a sub-cone theorem.

### 1.1 A technical caveat on the cone

The cone `W_δ` of `tensor.md` §1 asks `f̂` to be holomorphic in `|Im z| ≤ 1/2 + δ`
with polynomial decay there. This class is **not invariant under the shift
`f ↦ f(·−c) + f(·+c)`**, because `f̂_c(z) = 2 cos(cz) f̂(z)` grows like `e^{c|Im z|}`
in the strip. The standard proof of the converse direction uses exactly such shifted
packets. So the cone is a convenient class for the contour shift but not the natural
class for the equivalence. Any uniformity theorem must first fix a shift-invariant
test class (compactly supported `f`, or Schwartz with the horizontal estimates
carried by the zero density) and re-prove the explicit formula there. This is a
genuine gap in the source sketch, not a defect of the object `W`.

---

## 2. The no-go that constrains every uniform mechanism

**Proposition (uniform lower bound ⇒ RH; conditional on the standard converse).**
Let `Q` be the Weil form on a shift-invariant test class, and suppose there are a
norm `‖·‖` and a constant `C < ∞` with

```
Q(f) ≥ −C ‖f‖²      for every f in the class.
```

Then every non-trivial zero lies on the critical line.

*Proof sketch.* Suppose `γ₀ = β + iθ`, `θ ≠ 0`, is a zero frequency. Take `f` real,
even, with `f̂` a narrow Gaussian pair at `±β`, and set `f_c(u) = f(u−c) + f(u+c)`.
Then `‖f_c‖² → 2‖f‖²`, so the norm stays bounded, while the zero sum splits into the
quadruple `{±γ₀, ±γ̄₀}` and the real zeros. The quadruple contributes
`≍ e^{2θc}(cos(2cβ − φ) + o(1))·|f̂(γ₀)|²`, the real zeros contribute `O(1)` uniformly
in `c`; choosing `c → ∞` along a sequence with `cos(2cβ − φ) ≤ −1/2` gives
`Q(f_c) = −Ω(e^{2θc}) → −∞`. The bound `Q(f_c) ≥ −2C‖f‖²` is violated. ∎

**Consequences, route by route.** Each of the listed mechanisms, in its uniform form,
supplies such a bound:

- **Sum of squares + operator-norm remainder.** `Q = Σ ‖A_j f‖² + R` with
  `|R(f)| ≤ C‖f‖²` gives `Q ≥ −C‖f‖²`. So a *uniform* SOS with a bounded remainder is
  RH. (A finite SOS is a different object; see §3.)
- **Orthogonal blocks with coercive diagonal.** If cross terms vanish and the diagonal
  is coercive (`≥ c‖f‖²`), the form is uniformly positive, hence RH; if the cross terms
  are merely controlled, the same lower bound results. Partitioning alone changes
  nothing: the obstruction is the exponential family, which is *not* block-diagonal in
  any arithmetic partition.
- **Bounded positive operator.** `Q(f) = ⟨f, Af⟩` with `A ≥ 0` bounded is exactly
  `Q ≥ 0`, hence RH. A finite block matrix can refute a candidate (a negative
  eigenvalue is a finitely checkable certificate) but cannot prove `A ≥ 0` on an
  infinite-dimensional cone: positivity is a limit statement.
- **Operator-norm tails.** A truncation `Q_N` with gap `δ_N` and `‖Q − Q_N‖ < δ_N`
  gives `Q ≥ δ_N − ‖Q_N − Q‖ > 0` on the cone, hence RH. So an operator-norm tail
  bound is not a soft analytic estimate: at *any* `N`, success proves RH.
- **Euler-product input.** Not a uniform lower bound by itself; it is the only one of
  the five that can supply the *reason* the bound is true (see §4).

The practical reading: **do not look for a uniform mechanism that is weaker than RH.**
The only statements that are theorems are sub-cone statements. This is the same
finite/infinite separation the programme already records as the finite-prefix theorem,
transposed to the Weil form.

---

## 3. The support ladder — the survivable route

Let `P_L` be: `Q(f) ≥ 0` for every `f` with `supp f ⊂ [−L/2, L/2]`. Then:

- **`P_L` is finite.** `g = f*f̌` is supported in `[−L,L]`, so
  `Π(g) = Σ_{log n ≤ L} Λ(n)/√n (g(log n) + g(−log n))` has finitely many terms; the
  archimedean term is a one-dimensional integral of a compactly supported `ĝ`.
- **`P_{log 2}` is prime-free.** For `L < log 2`, `Π(g) = 0` and `P_L` reduces to
  `2∫g cosh(u/2) + (1/2π)∫ĝΩ ≥ 0`: an inequality about `Ω` alone. Whether it holds for
  *every* such `f` is a genuine question (the numerics below support it); what is certain
  is that it no longer involves the zeros or the primes.
- **The ladder is strictly increasing in difficulty.** A Gaussian of width `σ` has
  effective support `≈ σ`, and its form is dominated by the first zero:
  `Q ≈ 4πσ² e^{−σ²γ₁²}`. The margin decays like `e^{−σ²γ₁²}`, so widening the window by
  a factor `k` costs a factor `e^{−(k²−1)σ²γ₁²}` in the certificate's precision.
- **`∀L P_L ⇒ RH`,** by approximating cone functions with compactly supported ones
  (standard, not formalised here). The ladder has no uniform bound — which is exactly
  why it is a ladder and not a proof.

This gives a clean research programme with measurable progress: prove `P_L` for
larger and larger `L`. It also gives an honest reading of the programme's finite
certificates: they are rungs, not shadows of the whole cone.

### 3.1 What each of the five mechanisms becomes on a rung

| mechanism | on a fixed rung | what it buys |
|---|---|---|
| SOS | Cholesky factor of the finite Gram matrix (already proved generically: T8, T10) | a *verifier* for a finite certificate |
| orthogonal blocks | block Cholesky; cross terms are entries of the same finite matrix | numerical stability, no logical gain |
| positive operator | finite PSD test; a negative vector refutes (T9) | refutation engine, not a proof engine |
| Euler product | absent on `P_{log2}`; enters at `log 2` and beyond | the only route to a cone theorem |
| operator-norm tail | for a fixed `f`, the prime tail is a scalar; for a block, a matrix | the bridge from PST's scalar enclosures to a block bound |

---

## 4. The Euler-product input: what it must look like

The Davenport–Heilbronn litmus is decisive: DH has a functional equation and the same
functional-equation symmetry, but **no Euler product**. Any positivity proof that would
also run for DH is wrong. So the missing input must use complete multiplicativity.

Three candidate shapes, and their status:

1. **A positive factorization of the prime side.** Write `Π(g)` as a sum of squares of
   multiplicative functionals. The difficulty is structural: the explicit formula
   couples primes *additively*, through `g(log n)`, so there is no tensor factorization
   over `p`; `Λ` is not multiplicative, only `log p` on prime powers. No such
   factorization is known.
2. **A local-to-global positivity.** Over `F_q(t)` the corresponding positivity is the
   Hodge index theorem. The number-field analogue would be an intersection form on an
   arithmetic surface, and there is no such surface over `Spec Z`.
3. **A Hadamard-product positivity.** `ξ`'s product converges; positivity of the
   quadratic form would follow from the zeros being real, which is the statement.

The sharpest known separator short of the wall is hypothesis **(M)** (no zeros in
`σ > 1`): it removes the DH obstruction but does not reach `σ = 1/2` (R3). A successful
input must be strictly stronger than (M) and still fail for a sum of two Euler products.
No candidate is currently on the table. This is the honest content of route 4: it is
*necessary* (the litmus) and *absent*.

---

## 5. Operator-norm tails, concretely

Take a finite-dimensional space `V = span{φ_1, …, φ_m}` of test functions (shifted
Gaussians, say). The Gram matrix is `G_{ij} = Q(φ_i + φ_j) − Q(φ_i) − Q(φ_j)` (twice
the real part of the cross form). Split

```
G = G_N + T_N,
```

where `G_N` uses only the prime terms with `log n ≤ N` and the truncated archimedean
integral, and `T_N` is the tail. If `λ_min(G_N) > ‖T_N‖`, then `G ≻ 0`.

- **Why a scalar interval is not enough.** PST's `Expr`/`IBox` layer certifies entries
  to rational intervals. That gives `|(T_N)_{ij}| ≤ ε_{ij}`, but positivity of the
  matrix needs the *operator* norm. The bridge is a Schur test:
  `‖T_N‖ ≤ max_i Σ_j ε_{ij}` (or the sharper `√(‖T‖_1 ‖T‖_∞)`). Each `ε_{ij}` is a
  scalar enclosure; the bound is an operator norm. This is a concrete way to use the
  existing certified-evaluation layer inside a Weil-positivity certificate.
- **Why it cannot be uniform.** By §2, a bound that works for every `m` and every
  choice of `φ_j` is RH. The Schur bound must therefore degrade as the block grows —
  and indeed `‖T_N‖` grows with the number of shifts, while `λ_min` decays like
  `e^{−σ²γ₁²}`.

This is the most honest form of route 5: it is a transfer mechanism between a finite
certificate and a slightly larger subspace, never a mechanism for the cone.

---

## 6. Recommended first target: a certified positive Gaussian

**The test function.** `f_σ(u) = exp(−u²/2σ²)`, so

```
f̂_σ(t) = σ√(2π) e^{−σ²t²/2},   ĝ_σ(t) = 2πσ² e^{−σ²t²},
g_σ(v) = √π σ e^{−v²/4σ²},     2∫g_σ cosh(u/2) du = 4πσ² e^{σ²/4}.
```

**Why it is the right first rung.** For `σ ≤ 0.05`, `g_σ(log n) ≤ √π σ e^{−0.119/σ²} ≤
10^{−20}` for every `n ≥ 2`, so the prime side is *provably* negligible with crude
bounds; the certificate is an archimedean inequality. The numerical margins are
comfortable (`≈ 0.043`). Note carefully what is and is not being claimed: the *fixed*
Gaussian is a finite computation; the *whole* rung `P_{log 2}` (all small-support `f`)
is a uniform archimedean inequality that is not proved here and may itself be a real
theorem — the numerics below are evidence, not a proof.

**The numerical table** (exploratory; see the appendix for the script). `W(σ)` is
computed from the arithmetic side only, with 20000 prime powers and 25-digit
quadrature:

| `σ` | `W(σ)` | `2∫g cosh` | `−2Π(g)` | density |
|---|---|---|---|---|
| 0.03 | **0.046429** | 0.011312 | `−6·10^{−60}` | 0.035117 |
| 0.05 | **0.043136** | 0.031436 | `−1·10^{−22}` | 0.011700 |
| 0.07 | **0.034116** | 0.061651 | `−3·10^{−12}` | −0.027535 |
| 0.10 | **0.018812** | 0.125978 | `−1·10^{−6}` | −0.107166 |
| 0.15 | **0.003170** | 0.284338 | −1.25·10^{−3} | −0.279916 |
| 0.20 | **1.70·10^{−4}** | 0.507707 | −1.75·10^{−2} | −0.490045 |
| 0.30 | 1.76·10^{−8} | 1.156709 | −0.163196 | −0.993513 |

Two readings. First, positivity holds throughout, but the *margin collapses* like
`4πσ²e^{−σ²γ₁²}`: at `σ = 0.3` it is `10^{−8}`, at `σ = 0.5` it is `10^{−21}`. A
certificate for a wide window must resolve a cancellation to that precision.
Second, the sign pattern is not what naive positivity would suggest: the density is
negative for `σ ≥ 0.07` and the prime term is *negative*, so positivity is carried by
the pole term against both. The Weil form is not a sum of positive pieces.

### 6.1 A finite smooth-basis Gram matrix (numerical)

The single Gaussian has now been extended to a 4-point Gaussian basis in
[`WEIL-GRAM.md`](WEIL-GRAM.md). For `σ = 0.05`, centres `−0.3, −0.1, 0.1, 0.3`,
the numerical Gram matrix is

```
0.04313596  −0.01648926   0.00802313  −0.00222044
−0.01648926  0.04313596  −0.01648926   0.00802313
0.00802313  −0.01648926   0.04313596  −0.01648926
−0.00222044  0.00802313  −0.01648926   0.04313596
```

with eigenvalues `0.02270974, 0.02696128, 0.04485248, 0.07802034`. The prime
side is active at separation `c = 0.6`, where `−2Π(h) = −0.03648163…`; this is
not the prime-free small-`σ` regime. The numerical Cholesky factor has positive
pivots and reconstructs the matrix to `6.2·10^{−33}` (C8).

This is a **numerical rung**, not a certificate: `Ω` is quadrature, not an
interval enclosure, and the prime sum is truncated. The T8/T10 finite algebra is
ready to certify a rational shadow once the entrywise intervals exist.

**What the Lean certificate needs.**

1. **`Ω` enclosure** (new layer): `Re ψ(1/4 + it/2)` for `t` in a compact range. Use
   `ψ(z) = log z − 1/(2z) − ∫_0^∞ (1/2 − 1/u + 1/(e^u−1)) e^{−zu} du` (or Stirling with
   an explicit error), with `z = 1/4 + it/2`. The sibling PST layer already has
   `π, log, exp, sin, cos`; `Γ`/`ψ` is the missing transcendental.
2. **Interval quadrature** of `∫ ĝ_σ Ω` over `|t| ≤ T` with a Gaussian tail bound.
3. **Prime tail bound**: `|Π(g_σ)| ≤ e^{−0.119/σ²} Σ_n Λ(n)/√n`, or simply
   `g_σ(log n) ≤ g_σ(log 2)` for `n ≥ 2` and `Σ Λ(n)/√n` truncated geometrically.
4. **Assembly**: `W(σ) ≥ pole − 2|Π| − |density error|`, and `0.043 > 0` at `σ = 0.05`.

**What it buys.** The first unconditional, kernel-checked instance of
`⟨W, f*f̌⟩ > 0`, i.e. the first rung of the ladder, plus a reusable template for
every later rung. It does not prove RH and is not DH-sensitive; it is a finite
theorem, labelled as such.

**The stronger companion.** The same `f₀` of Theorem B has `W(g₀) =
2.000000000100144866826` (from the arithmetic side) and the same value from the zero
side, agreeing to `4.3·10^{−28}` (appendix). Certifying *that* number would make the
repair explicit: the naive current gives `−0.6773`, the repaired one `+2` on the same
witness. It requires the full `f₀` prime sum (already computed by C5) and the `Ω`
integral.

---

## 7. Falsifiers and decision points

- **Against a uniform mechanism.** By §2, a claimed uniform proof is a claimed proof of
  RH. It must either be wrong or be RH; there is no third option. Any argument that
  "controls" the form on the cone uniformly can be tested against the modulated family,
  and will fail there unless all zeros are on the line.
- **Against a candidate Euler-product input.** Run it on DH. If it applies, it is not
  the missing input. (This is the litmus of `bridges.md` B1.)
- **Against a finite certificate.** A negative vector is a refutation (T9 is the
  template). The Theorem B witness is such a refutation for `P`; the same machinery
  would refute any specific claimed-positive finite Gram matrix.
- **For the ladder.** The measurable question is: what is the largest `L` (or `σ`) for
  which `P_L` can be certified? If the answer stalls at `log 2`, that is evidence —
  not proof — that an arithmetic input is essential.

---

## 8. Appendix: numerical probe (exploratory, not a ledger computation)

Two checks, reproducible with `mpmath` at 25–30 digits.

**(a) The repaired current on the Theorem B witness.** With
`f₀(u) = (2/√π)e^{−u²}cos(γ₁u)`, `γ₁ = 14.1347251417…`,

```python
fhat = lambda t: exp(-((t-g)**2)/4) + exp(-((t+g)**2)/4)   # f̂₀
W_zero_side  = 2 * sum(abs(fhat(im(zetazero(k))))**2 for k in 1..20)
W_arith_side = 2*∫g₀ cosh(u/2) − 2·Σ Λ(n)/√n g₀(log n) + (1/2π)∫|f̂₀|²Ω
```

gives, at 30 digits,

```
zero side   2.000000000100144866826
arith side  2.000000000100144866826
difference  4.3·10^{-28}
```

with `Π(g₀) = −0.67764514730316915219` (matching C5) and the density term
`0.644709705493806562`. The identity of Theorem C is thereby verified on the witness
where the naive current fails (`−0.6773`): the repair flips the sign and the value is
`+2`. The book-keeping is worth recording: the pole term is `3.2·10^{−43}` here, the
prime term contributes `−2Π(g₀) = +1.3553` (because `Π(g₀) < 0`), and the density
contributes `+0.6447`; the zero sum is dominated by `2|f̂₀(γ₁)|² ≈ 2`.

**(b) The Gaussian scan** of §6, using `g_σ`, `Π` over `n ≤ 20000`, and
`Ω(t) = Re ψ(1/4+it/2) − log π`. The table in §6 is this scan. Rows at `σ ≥ 0.3` are
within a few digits of the quadrature floor and are indicative only.

---

## 9. Scope and honesty

- Nothing here proves, assumes, or approaches RH. The equivalence is quoted from
  `tensor.md` Theorem C (classical: Weil 1952, Bombieri 2000).
- The §2 proposition is stated for a shift-invariant test class; the current cone
  `W_δ` is not shift-invariant (§1.1), so the proposition is a constraint on uniform
  *claims*, not a theorem about the specific cone. Fixing the class is a prerequisite
  for any formal uniformity statement.
- The Gaussian scan is exploratory. The finite Gram matrix is now C8 in
  `tests/test_programme.py`, but C8 is a numerical PSD probe and **not** a
  certified enclosure; the distinction is kept in
  [`WEIL-GRAM.md`](WEIL-GRAM.md).
- The recommended target is a finite theorem about one test function. It is a rung,
  not a bridge: it does not fail for DH, because it does not claim the cone.

**One-sentence conclusion.** The five mechanisms are not five routes to positivity but
five ways of organising the same RH-strength input; the only thing that can be proved
outright is positivity on a support window, and the first such certificate is a
Gaussian with an archimedean budget of about `0.043`; the finite Gram matrix in
[`WEIL-GRAM.md`](WEIL-GRAM.md) is a numerical rung toward it, not the certificate.
