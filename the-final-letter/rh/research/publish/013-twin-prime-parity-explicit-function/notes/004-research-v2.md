# 004 (v2) — The zeta amplitude as a radial weight: the `1/n` spiral greedy term

**Task.** Produce a version of note [`research.md`](../../../twin-prime-parity/008/notes/research.md) (v1) in which the
individual term carries the **radial decay / amplitude** one normally sees in a zeta
function, obtained by multiplying the greedy term by `1/n` (with the general
`n^{−σ}`). As confirmed before writing: this is implemented as a **scaling of the
term**, i.e. the reconstructed unit term `c − i ε s` becomes `n^{−1}(c − i ε s)`.

**Why scaling the term and not its phase.** Multiplying the *complex argument* (the
phase angle `φ_n`) by `1/n` leaves `e^{−iφ_n/n}` on the unit circle — modulus `1`,
no radial decay. Radial decay can only come from scaling the term's modulus, so the
operation actually applied is

```
n-th term:   n^{−σ} · ( greedy rotation reconstructing e^{−i t log n} ) ,   σ = 1 for the requested 1/n .
```

**Headline (and one correction to the obvious guess).**

* For the general amplitude `n^{−σ}`, `σ > 1`, the identity is convergent and exact:
  `ζ(σ+it) = Σ n^{−σ}(c_{n,∞} − i ε_n s_{n,∞})`, with the explicit uniform bound of v1
  (the identity is a rewriting; the quantitative content is the bound — see Remark 5.1c).
* For the requested `1/n` (`σ = 1`) the raw series **diverges**: its partial sums
  oscillate with amplitude `1/|t|` and never settle (Theorem 3.2 below). The weight
  `n^{−1}` therefore corresponds to `σ = 1`, the **abscissa of convergence** of the
  Dirichlet series (the boundary `Re s = 1` of its half-plane of convergence) — **not**
  the critical line, which is the line `Re s = 1/2` and corresponds to the weight
  `1/√n`. On `σ = 1`, `ζ` is not the sum but the **analytic continuation**, and the
  identity must be read after eta-regularisation: `ζ(1+it) = η(1+it)/(1 − 2^{−it})` for
  `t ∉ (2π/log 2)ℤ`. We give that regularised statement and its greedy error bound
  `O(log M / M)`.

Version 1 is the unit-modulus phase reconstruction (amplitude external); this v2 is the
radially weighted version. The source expansion is unchanged:

> V. Geere, *On the Correlation Structure of a Greedy Harmonic Decomposition of the
> Sine Function* (March 2026),
> <https://victorgeere.co.za/archive/maths/rh/research/greedy-harmonic/greedy-harmonic-decomposition.html>

**Scope: what this note is *not*.** Two consequences of the definitions bound every
claim below, and are stated first so the note is not read as more than it is.

1. **The object is the ordinary Dirichlet partial sum.** Since `c_{n,N} → cos θ_n` and
   `s_{n,N} → sin θ_n`, one has `G_{M,N} → S_M := Σ_{n≤M} n^{−s}` as `N → ∞`, and for
   `σ > 1` the double limit is the defining series. So this is **not** a new
   representation, an analytic continuation, or a route to the zeros: the identity is
   the Dirichlet series re-expanded term by term, and its bound is the trivial tail
   bound plus a non-negative greedy error (see the caveat under (3.1)).
2. **The word is computed from the phase it reconstructs.** The take rule consumes
   `θ_n = t log n mod 2π`, so running the recursion requires the direct evaluation of
   the phase to the precision of the last decided digit. There is **no computational
   gain** — the construction is strictly more expensive than evaluating `n^{−s}`
   directly, and "certified" below means an explicit worst-case bound, not an algorithm.

What the note does claim, and all it claims: **(i)** a uniform, angle-independent bound
— every phase `t log n` is realised to within `π/(N+1)` by at most `N` elementary
rotations whose angles are the fixed `α_k = π/(k+2)` — and **(ii)** the `σ = 1`
boundary/eta analysis of the radially weighted object. Neither claim bears on the
Riemann hypothesis, and §5 records this.

**Companion computations.** (a) The sine is reconstructed term by term and the
fraction-sets `A_n` of the different terms are compared (disjointness, nesting, shared
fractions, the `O(log log K)` support law): [`sine-harmonics.md`](../../../twin-prime-parity/004/sine-harmonics.md),
figure [`sine_harmonics.png`](../assets/sine_harmonics.png). Its sharp numbers: in the angle
measure 68 % of term-pairs have disjoint supports and nesting has probability `~5·10⁻⁶`
per ordered pair (against `1` for a monotone chain); the `t = 10` sample of 179 700 pairs
sees 0 nested pairs. (b) The *pre-collapse* form of ζ — every term expanded into
products of `sin(π/(k+2))`, `cos(π/(k+2))` over its greedy support, before the
angle-addition collapse: [`deconstructed-zeta.md`](../../../twin-prime-parity/004/deconstructed-zeta.md), figure
[`deconstructed_zeta.png`](../assets/deconstructed_zeta.png).

Status legend — THEOREM: proved; NUMERICAL: finite computation only; REMARK: no claim.

---

## 0. Summary

```
                                                      radial weight
                                                      └────┬────┘
   n-th term of ζ :     n^{−s}  =  n^{−σ}  ·  Π_{k≥0} ( cos α_k − i sin α_k )^{ ε_n δ_k(θ_n) } ,
                                    └───────── greedy rotation (v1) ─────────┘

                                                      radial weight
                                                      └────┬────┘
   greedy term (v2) :   T_n    =  n^{−σ}  ·  ( c_{n,∞} − i ε_n s_{n,∞} )
                                =  n^{−σ}  ·  ( cos θ_n − i ε_n sin θ_n )  =  n^{−s} .
```

* `α_k = π/(k+2)`; `δ_k(θ_n) ∈ {0,1}` is the source's greedy take rule; `θ_n ∈ [0,π]`
  and `ε_n ∈ {±1}` are the reduction of the phase `t log n` (§1).
* With `σ = 1` the radial weight is exactly the requested `1/n`.
* All of `Σ_n T_n` is a **convergent, exact** representation of `ζ(σ+it)` when
  `σ > 1` (§3.1); at `σ = 1` it is `ζ(1+it)` only after eta-regularisation (§3.2,
  §3.3).

Real and imaginary parts, explicitly:

```
Re ζ(σ+it) = Σ_{n≥1} C_{n,∞}        with C_{n,N} = n^{−σ} cos θ_{n,N}   (cosine of each term)
Im ζ(σ+it) = −Σ_{n≥1} ε_n S_{n,∞}    with S_{n,N} = n^{−σ} sin θ_{n,N}   (sine  of each term)
```

so the radial decay is carried by `C_{n,N}, S_{n,N} → 0` like `n^{−σ}` while the
greedy word carries the oscillation.

---

## 1. The source expansion (recap of the pieces used)

`α_k = π/(k+2)`, `k = 0,1,2,…`. For a target `θ ∈ [0,π]` and the accumulated angles
`θ_0 = 0`, `θ_{k+1} = θ_k + δ_k α_k` with

```
δ_k(θ) = 1  ⟺  θ − θ_k ≥ α_k ,          (greedy take rule)
```

the fusion (angle-addition) recursion

```
c_{k+1} = c_k cos α_k − δ_k s_k sin α_k ,      c_0 = 1 ,
s_{k+1} = s_k cos α_k + δ_k c_k sin α_k ,      s_0 = 0 ,
```

maintains `c_k = cos θ_k`, `s_k = sin θ_k`, and

```
cos θ = lim_{N→∞} c_N(θ) ,   sin θ = lim_{N→∞} s_N(θ) ,
```

with the sharp residual bound (v1 §1; the source's Lemma 3.1 states the one-index
optimistic `π/(N+2)`, and its Lemma 3.2 inherits it for `sin`)

```
0 ≤ r_N := θ − θ_N ≤ α_{N−1} = π/(N+1) ,     hence |cos θ − c_N| , |sin θ − s_N| ≤ π/(N+1) .
```

*Proof of the residual bound.* Induction on `N ≥ 1`. `N = 1`: if `θ ≥ α_0 = π/2` then
`r_1 = θ − π/2 ≤ π/2 = α_0`; otherwise `r_1 = θ < α_0`. Step: assume
`r_{N−1} ≤ α_{N−2}`. If index `N−1` is taken then
`r_N = r_{N−1} − α_{N−1} ≤ α_{N−2} − α_{N−1} = π/(N(N+1)) < α_{N−1}`; if it is skipped
then `r_N = r_{N−1} < α_{N−1}`. ∎

*Sharpness.* `sup_θ r_N = π/(N+1)` for **every** `N ≥ 1`: as `θ → (π/(N+1))^−` every
`α_k` with `k ≤ N−1` exceeds `θ`, so all indices are skipped and `r_N = θ →
π/(N+1)`. The supremum is approached but not attained (at `θ = π/(N+1)` exactly, index
`N−1` is taken and `r_N = 0`). The trigonometric bounds follow from the mean value
theorem, `|cos θ − cos θ_N| ≤ |θ − θ_N| = r_N`.

> **Source caveat.** The source's *Lemma 4.1* (selection monotonicity, "`θ ↦ δ_n(θ)` is
> non-decreasing") is **false**: with the source's own rule, `δ_1` takes the values
> `1, 0, 1` at `x = θ/π = 1/3, 1/2, 5/6` (exact rational computation). What this
> invalidates is the *threshold* machinery — the "first selection" angles `θ_n^*` and the
> closed forms for `K(n,m)` derived from them (source Lemmas 4.3, 4.6–4.7, §5). It does
> **not** invalidate source Proposition 6.3 (`K` is positive semi-definite), which holds
> by its integral representation regardless of monotonicity. Neither v1 nor v2 uses
> Lemma 4.1 or the threshold formulas: the only ingredients taken from the source are
> Definitions 2.1–2.2 (the alphabet and take rule), the fusion recursion, and the
> reconstruction/residual statement above.

**Phase reduction.** With `φ_n = t log n`, `r_n = φ_n mod 2π`,

```
θ_n = r_n        if r_n ≤ π ,   ε_n = +1 ;        (upper half of the phase circle)
θ_n = 2π − r_n   if r_n > π ,   ε_n = −1 ;        (lower half)
```

whence `cos φ_n = cos θ_n`, `sin φ_n = ε_n sin θ_n`, i.e.
`e^{−iφ_n} = cos θ_n − i ε_n sin θ_n` (v1 Lemma 3.1).

**Product form (v1 (1.1)).** `e^{−iθ_N} = Π_{k<N}(cos α_k − i sin α_k)^{δ_k(θ)}`.

---

## 2. Inserting the radial weight: the spiral greedy term

The v1 construction is a **rotation** of the unit vector `(1,0)`: every fusion step
has matrix `R(α_k) = [[cos α_k, −sin α_k],[sin α_k, cos α_k]]`, of determinant `1`, and
the radius stays `1`. The zeta amplitude is a **contraction**; composing the two gives
a **spiral similarity** (rotation × homothety).

**Definition 2.1 (radially weighted greedy term).** Fix `σ ≥ 0` and, for each `n ≥ 1`,
start the fusion recursion at **radius** `n^{−σ}`:

```
(C_{n,0}, S_{n,0}) = ( n^{−σ} , 0 ) ,
```

and for `k = 0,1,2,…` apply the *same* rotation as the source, with the *same* greedy
digits `δ_{n,k} = δ_k(θ_n)`:

```
if δ_{n,k} = 1 :
    C_{n,k+1} = C_{n,k} cos α_k − S_{n,k} sin α_k
    S_{n,k+1} = S_{n,k} cos α_k + C_{n,k} sin α_k
else :
    C_{n,k+1} = C_{n,k} ,   S_{n,k+1} = S_{n,k} .
```

Because a rotation is linear and preserves the radius,

```
C_{n,N}  =  n^{−σ} c_N(θ_n)  =  n^{−σ} cos θ_{n,N} ,
S_{n,N}  =  n^{−σ} s_N(θ_n)  =  n^{−σ} sin θ_{n,N} ,
θ_{n,N}  =  Σ_{k<N} δ_{n,k} α_k ,
```

so scaling the term by `n^{−σ}` is exactly **starting the greedy vector at radius
`n^{−σ}`**, and the greedy word is untouched.

**Definition 2.2 (the term).** The radially weighted greedy term is

```
T_{n,N}  :=  C_{n,N} − i ε_n S_{n,N}  =  n^{−σ} ( c_{n,N} − i ε_n s_{n,N} ) ,     T_n := lim_N T_{n,N} ,
```

and in product form

```
T_{n,N}  =  n^{−σ} Π_{k<N} ( cos α_k − i sin α_k )^{ ε_n δ_{n,k} } .                    (2.1)
```

For `σ = 1` this is precisely the requested `(1/n) · (reconstructed term)`.

**Remark 2.3 (the literal phase reading).** Replacing `θ_{n,N}` by `θ_{n,N}/n` inside
`cos`/`sin` is a different operation; every term remains on the unit circle
(`|e^{−iθ/n}| = 1`) and no radial decay appears. The user-facing phrase "multiply the
argument of the term by `1/n`" is therefore realised here as the radial scaling
`n^{−σ}` of Definition 2.2, which is the only reading that introduces the amplitude.

**Remark 2.4 (spiral picture).** In one step the map is the spiral-similarity matrix
`n^{−σ} R(α_k)` when `δ_{n,k}=1` and the identity when `δ_{n,k}=0`; the orbit of
`(1,0)` is a circle of radius `n^{−σ}` traversed by the greedy-selected angles. Across
`n` the radii `n^{−σ}` shrink monotonically: this is the radial decay of the zeta term.

---

## 3. Main results

### 3.1 Convergent case `σ > 1` (the general amplitude)

**Theorem 3.1 (radially weighted greedy representation of ζ).** For `σ > 1` and every
`t ∈ ℝ`,

```
   ζ(σ+it) = Σ_{n≥1} n^{−σ} [ cos θ_n − i ε_n sin θ_n ]
            = Σ_{n≥1} [ C_{n,∞} − i ε_n S_{n,∞} ]
            = lim_{N→∞} Σ_{n≥1} [ C_{n,N} − i ε_n S_{n,N} ]
            = Σ_{n≥1} n^{−σ} Π_{k≥0} ( cos α_k − i sin α_k )^{ ε_n δ_{n,k} } ,
```

the product being the limit of its partial products (2.1). *Proof.* Identical to v1
Theorem 4.1: each term is exact by the source reconstruction theorem, and the
`N → ∞` limit passes inside the sum by dominated convergence, since
`|C_{n,N} − i ε_n S_{n,N}| = n^{−σ}` and `Σ n^{−σ} < ∞` for `σ > 1`. ∎

**Truncation bound.** With `G_{M,N}(s) = Σ_{n≤M}(C_{n,N} − i ε_n S_{n,N})` and
`H_{M,σ} = Σ_{n≤M} n^{−σ}`,

```
| ζ(s) − G_{M,N}(s) |  ≤  Σ_{n>M} n^{−σ}  +  (π/(N+1)) H_{M,σ}
                      ≤  M^{1−σ}/(σ−1)   +  (π/(N+1)) H_{M,σ} ,                        (3.1)
```

and for `M = ∞`, `|ζ(s) − G_{∞,N}(s)| ≤ π ζ(σ)/(N+1)`. (The constant is `π`, not `√2π`:
the termwise error is `|e^{−iεθ} − (c_{N} − iεs_{N})| = |e^{−iεr_N} − 1| ≤ r_N ≤
π/(N+1)`, so no coordinate-wise `√2` is needed.)

*Caveat on what (3.1) says.* `G_{M,N} → S_M` as `N → ∞`, so (3.1) is the trivial partial-
sum tail `Σ_{n>M} n^{−σ}` **plus a non-negative greedy error**; for every finite `N` the
bound is larger, not smaller, than the trivial bound for the ordinary partial sum. The
observed errors in §6 are smaller than the bound only through cancellation across the
phases. What (3.1) does quantify is the *uniform* cost in `N` of realising the phases,
not an improvement in evaluating `ζ`.

### 3.2 The requested `1/n` (`σ = 1`): the raw series diverges

Setting `σ = 1` puts the amplitude exactly on the **abscissa of convergence** of the
Dirichlet series (the boundary `Re s = 1` of its half-plane of convergence; the critical
line `Re s = 1/2` is a different line, reached by `1/√n`). The corresponding
Dirichlet series is **not** convergent.

**Theorem 3.2 (boundary divergence).** For `t ≠ 0`, as `M → ∞`,

```
Σ_{n≤M} n^{−1−it}  =  ζ(1+it)  +  i M^{−it}/t  +  O(M^{−1}) ,                            (3.2)
```

so the partial sums do **not** converge: the displacement `P_M − ζ(1+it) = i M^{−it}/t +
O(M^{−1})` rotates on a circle of radius `1/|t|` centred at `ζ(1+it)`, so `P_M` never
settles. (The statement is for fixed `t ≠ 0`; the constant is not uniform as `t → 0`.)

*Proof.* Euler–Maclaurin: for `s ≠ 1`, `Σ_{n≤M} n^{−s} = ζ(s) + M^{1−s}/(1−s) +
O(M^{−s})`. Put `s = 1+it`: `M^{1−s}/(1−s) = M^{−it}/(−it) = i M^{−it}/t`, of modulus
`1/|t|`, and `M^{−s} = O(M^{−1})`. ∎

*Numerical check* (`t = 10`, `ζ(1+10i) = 1.3902873132 − 0.1097851531 i`):

| `M` | `Re P_M` | `Im P_M` | `｜P_M − ζ｜` |
|---|---|---|---|
| 10² | +1.475652 | −0.161950 | 0.1000 |
| 10³ | +1.387039 | −0.009838 | 0.1000 |
| 10⁴ | +1.306264 | −0.164007 | 0.1000 |
| 10⁵ | +1.479840 | −0.154285 | 0.1000 |
| 10⁶ | +1.382798 | −0.010066 | 0.1000 |
| 10⁷ | +1.308384 | −0.167159 | 0.1000 |

The amplitude is `1/|t| = 0.1`, as (3.2) predicts. At `t = 0` the series is the
harmonic series (`log` divergence), i.e. the pole of `ζ` at `s = 1`.

So the requested `1/n` amplitude does **not** give `ζ(1+it)` as a plain sum: it puts the
sum exactly on the abscissa of convergence `σ = 1`, where `ζ` is defined by analytic
continuation. The convergent handle is the alternating (eta) series, which converges for
`σ > 0`.

**Remark 3.2b (why the weight `1/n` is exactly the boundary — and not the critical
line).** Write the weight as `n^{−σ}`; `1/n` is the case `σ = 1`. For `s ≠ 1`,
Euler–Maclaurin gives

```
Σ_{n≤M} n^{−s}  =  ζ(s)  +  M^{1−s}/(1−s)  +  O(M^{−σ}) .
```

The partial sums converge **iff** the boundary term `M^{1−σ}` tends to `0`, i.e. iff
`σ > 1`; at `σ = 1` that term is `M^{−it}/(−it)`, a bounded oscillation of amplitude
`1/|t|` (never tending to `0`), and for `σ < 1` it grows like `M^{1−σ}`. Equivalently,
the coefficient counting function is `N(x) = #{n ≤ x} = x`, so the abscissa is
`σ_c = limsup log N(x)/log x = 1`. The weight `1/n` is therefore the **marginal decay**
on the divergent side of the convergence boundary — the slowest decay that does not
converge.

The **critical line** is a different line, `σ = 1/2`, reached by the weight
`n^{−1/2} = 1/√n`. Its significance comes from the functional equation
`ξ(s) = ξ(1−s)`, which pairs `σ` with `1−σ` and singles out the fixed line `σ = 1/2`;
it is not visible in the convergence of the Dirichlet series. The correspondence here is
simply `exponent of n = −σ`: `1/n ↔ σ = 1` (convergence boundary),
`1/√n ↔ σ = 1/2` (critical line).

### 3.3 `0 < σ ≤ 1`: eta-regularised representation

```
η(s) = Σ_{n≥1} (−1)^{n−1} n^{−s} = (1 − 2^{1−s}) ζ(s)      (s ≠ 1) ,                    (3.3)
```

convergent for `σ > 0` by **Dirichlet's test** (the partial sums of `Σ(−1)^{n−1}` are
bounded and `n^{−s}` has finite variation; the real-alternating Leibniz test does *not*
apply to the complex terms — see Remark 3.3b). With the radially weighted greedy terms,

```
η_{M,N}(s)  :=  Σ_{n=1}^{M} (−1)^{n−1} n^{−σ} ( c_{n,N} − i ε_n s_{n,N} )  =  Σ_{n=1}^{M} (−1)^{n−1} ( C_{n,N} − i ε_n S_{n,N} )
```

**Proposition 3.3 (radially weighted greedy eta).** For `0 < σ ≤ 1`, `s ≠ 1`,

```
| η(s) − η_{M,N}(s) |  ≤  C(σ,s) M^{−σ}  +  (π/(N+1)) H_{M,σ} ,                        (3.4)

C(σ,s) = 1 + |s|/σ ,        H_{M,σ} ≤ 1 + M^{1−σ}/(1−σ)  (σ<1) ,   H_{M,1} ≤ 1 + log M ,
```

hence `ζ(s) = lim η_{M,N}(s)/(1 − 2^{1−s})` along any path with `M → ∞` and
`N ≫ M^{1−σ}`; the error of `ζ` is (3.4) divided by `|1 − 2^{1−s}|`.

**Remark 3.3b (why the tail constant is `|s|/σ`, not `1`).** The faille here is that
`Σ(−1)^{n−1} n^{−σ}` is *not* a real alternating series once the phases `e^{−it log n}`
are present: the terms are complex and their moduli are not monotone in the required
sense, so the Leibniz remainder estimate `tail ≤ (M+1)^{−σ}` is invalid. The correct
bound pairs adjacent terms: with `z_n = n^{−s}`,
`|z_n − z_{n+1}| ≤ |s|∫_n^{n+1} x^{−σ−1} dx`, and summing the pairs telescopes to
`|s|/σ·(M+1)^{−σ}`. Adding the single omitted leading term gives `C = 1 + |s|/σ`.
Worked counterexample to the old constant-`1` form: `M = 1`, `N = 100`,
`s = 1 + 10i` gives LHS `= |η(1+10i) − 1| = 1.0452` while the old RHS was
`1 + √2π/101 = 1.0440`. The convergence conclusion is unaffected (`C M^{−σ} → 0`), but
the constant must be carried.

**Corollary 3.4 (the requested `1/n`, explicit).** With `σ = 1`, `s = 1+it` and
`t ∉ (2π/log 2)ℤ`,

```
ζ(1+it) = η(1+it)/(1 − 2^{−it}) ,
                                        ⎫
| η(1+it) − η_{M,N}(1+it) | ≤ C(1,s) M^{−1} + (π/(N+1))(1 + log M) ,   ⎬   N = M gives O(log M / M)
                                        ⎭
```

**Remark 3.4b (the excluded set).** The prefactor `1 − 2^{1−s}` vanishes exactly when
`t = 2πk/log 2`. The cases must be separated:

* `k = 0`, i.e. `t = 0`, `s = 1`: this is the **pole** of `ζ`. Here `η(1) = log 2 ≠ 0`
  while `1 − 2^{1−s} = 0`; the quotient is `log 2 / 0`, not `0/0`. The *product*
  identity `η(s) = (1 − 2^{1−s})ζ(s)` does extend to `s = 1` — the zero of the factor
  cancels the pole and both sides equal `log 2` (this is the classical cancellation,
  Titchmarsh p. 17) — but the *division* `ζ = η/(1 − 2^{1−s})` is what fails there.
* `k ≠ 0`: then `η(1+it) = (1 − 2^{−it})ζ(1+it) = 0` as well, so the quotient **is**
  `0/0` — a removable singularity whose limit is `ζ(1+it)`. The displayed division (and
  the bound's division by `|1 − 2^{−it}|`) must not be evaluated there. Example:
  `t_0 = 2π/log 2 = 9.0647202837`, where `1 − 2^{−it_0} = 0`, `η(1+it_0) = 0`, and
  `ζ(1+it_0) = 1.346580129 + 0.109882461 i`.

In both cases `ζ(1+it)` is of course well defined except at `t = 0`.

*Proof of Prop. 3.3.* Write `η(s) − η_{M,N}(s) = T_M + G_{M,N}` where `T_M` is the
alternating tail `Σ_{n>M}(−1)^{n−1} n^{−s}` and `G_{M,N}` is the greedy substitution
error over `n ≤ M`. Then `|G_{M,N}| ≤ (π/(N+1)) H_{M,σ}` as in (3.1), while
`|T_M| ≤ (1 + |s|/σ)(M+1)^{−σ}` by Remark 3.3b. Divide by `1 − 2^{1−s}` off the
exceptional set of Remark 3.4b. ∎

**Remark 3.5 (why `1/n` is special).** The factor `1/n` is exactly the amplitude at
which the geometric decay of the terms stops beating the divergence of the Dirichlet
series: the partial sums are bounded but not convergent (Theorem 3.2). Any `σ > 1`
gives unconditional convergence; `σ = 1` needs regularisation; `σ < 1` diverges faster
(`M^{1−σ}`). The greedy expansion changes none of this — it supplies the phases, not
the convergence.

---

## 4. Real and imaginary parts, and the explicit recursion

Combining §2 and Theorem 3.1, for `σ > 1`:

```
Re ζ(σ+it) =  Σ_{n≥1} lim_{N→∞} n^{−σ} cos θ_{n,N}          (cos of each term, weighted 1/n^σ)
Im ζ(σ+it) = −Σ_{n≥1} ε_n lim_{N→∞} n^{−σ} sin θ_{n,N}       (sin of each term, weighted 1/n^σ)
```

and the term-by-term recursion with the radial weight built in is Definition 2.1:

```
(C_{n,0}, S_{n,0}) = (n^{−σ}, 0)
for k = 0,1,2,…:
    take = [ θ_n − θ_{n,k} ≥ α_k ]                      (the source's greedy rule)
    C_{n,k+1} = C_{n,k} cos α_k − take · S_{n,k} sin α_k
    S_{n,k+1} = S_{n,k} cos α_k + take · C_{n,k} sin α_k
    θ_{n,k+1} = θ_{n,k} + take · α_k
Re ζ ≈ Σ_{n≤M} C_{n,N} ,        −Im ζ ≈ Σ_{n≤M} ε_n S_{n,N} .
```

**Product form (all-in-one).**

```
n^{−s}  =  n^{−σ} · Π_{k≥0} ( cos(π/(k+2)) − i sin(π/(k+2)) )^{ ε_n δ_k(θ_n) } ,
```

i.e. **radial weight `n^{−σ}` × greedy rotation**, with the rotation built only from
the elementary `(cos, sin)` of the harmonic angles.

**Corollary 4.1 (real `s`).** `t = 0` ⇒ `θ_n = 0` for all `n`, all `δ = 0`,
`(C_{n,N}, S_{n,N}) = (n^{−σ}, 0)`, and the representation collapses to
`ζ(σ) = Σ n^{−σ}` for `σ > 1`; at `σ = 1` it is the harmonic series (pole).

---

## 5. Remarks

**5.1 The *word* is amplitude-blind; the *term map* is not.** The digit word
`w(θ_n) = δ_{n,0}δ_{n,1}…` is a function of the angle `θ_n` alone (dictionary
[`02`](../../../twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) §1, Definition 1.1: the unsigned rule
reads `x = θ/π`; §3's "height" factorisation is a statement about the *signed* Tau rule
and is not what is used here). So no rule that reads only that word can manufacture the
Dirichlet profile `n^{−σ}`: the modulus is not a function of the word, nor of its take
count. In v2 the profile is therefore attached **outside** the word, as the initial radius
`n^{−σ}` of each term.

But — correcting an earlier draft of this section — the **construction is not
amplitude-blind**. Each term `T_n = n^{−σ}(c_{n,∞} − i ε_n s_{n,∞})` is the image of
`(1,0)` under a genuine **spiral similarity** (rotation by `ε_n θ_n`, dilation by
`n^{−σ}`); it has amplitude, and for `σ > 1` the resulting series *is* `ζ(σ+it)`. The
barrier is the narrower, word-level statement: the **word cannot generate the
amplitude** — the radial profile has to be supplied as a function of the index `n`
(equivalently of `Re s`), exactly as the Dirichlet series supplies it. Saying that the
spiral object is amplitude-blind would be false; saying that the greedy word is follows
immediately from its being a function of `θ_n` alone. *(Citation note: the stronger
programme statement — that a 0/1 digit cannot carry the unbounded amplitude family
`Λ(n)/√n` of the explicit formula — belongs to the rh45/rh47 harvest kept under
`../rounds/`, not to dictionary 02 §6, which is about factorisation and `λ`-parity. We
do not need that stronger statement here; the word-level observation above is immediate
and sufficient.)*

**Remark 5.1b (can a spiral generate its own amplitude?).** One could try to fold the
dilation into the iteration — multiply the radius by a fixed `λ` at every take — making
the modulus of a term `λ^{m_n}`, a function of the word's take count
`m_n = Σ_{k<N} δ_{n,k}` and hence genuinely word-generated. Two things rule this out
here. (i) It destroys the source's invariant `(c_k, s_k) = (cos θ_k, sin θ_k)`: with a
dilation per step the pair becomes `λ^{m_k}(cos θ_k, sin θ_k)`, so the raw recursion no
longer reconstructs the sine (only the angle). (ii) The law produced is `λ^{#takes}`, a
power of the take count — not the Dirichlet profile `n^{−σ}`. So the radial weight has
to act on the term as a whole, and the greedy word remains the angular part only. A
term's orbit under the iteration is a **circle** of radius `n^{−σ}` (Remark 2.4); the
spiral appearance is across `n`, where the radii decay. The word does not *choose* that
radial law.

**Remark 5.1c (status and cost).** Theorem 3.1's *identity* is a rewriting: polar form
plus an exact phase reconstruction, whose `N → ∞` limit is the ordinary Dirichlet
partial sum (Scope, §0). The claim that is not immediate is the *uniform* one: (3.1)
holds for **every** target angle `θ ∈ [0,π]` with a single `N`, so one fixed schedule
`α_k = π/(k+2)` realises every phase `t log n` to tolerance `π/(N+1)`. On cost: the
recursion **consumes** the phase it reconstructs (the take rule tests `θ_n − θ_{n,k}`
against `α_k`), so it presupposes a direct evaluation of `t log n` to the precision of
the last decided digit, and is strictly more expensive than evaluating `n^{−s}`
directly. The bounds are worst-case: (3.1) is the trivial tail plus a non-negative
greedy term, never smaller than the trivial bound, and the observed §6 errors fall below
it only through cancellation across phases. So "certified" here means "with an explicit
uniform worst-case bound" — not "computable", not "fast", and not a statement about
`ζ`'s zeros.

**5.2 The `1/n` case is the abscissa of convergence, not the critical line.**
Multiplying by `1/n` is the weight `n^{−σ}` at `σ = 1`, i.e. the line `Re s = 1`; that
line is the **abscissa of convergence** of the Dirichlet series (see Remark 3.2b). The
**critical line** is `Re s = 1/2`, reached by the weight `1/√n`. That `σ = 1` is the
convergence boundary is why the plain sum cannot work (Theorem 3.2) and why `ζ(1+it)`
needs the eta prefactor `1/(1−2^{−it})`. This also makes the pole at `s = 1` visible as
the `t = 0` divergence of both the raw and the regularised expression
(`1 − 2^{−it} → 0`).

**5.3 Relation to v1.** v1's §6 already used eta for the strip and its Prop. 6.1 is the
`σ < 1` part of Prop. 3.3 without the radial framing. v2 adds the spiral/scaled term,
the explicit `σ = 1` statement (Corollary 3.4), and the boundary-divergence theorem
(3.2). No error in v1 is being corrected; v1's claim that the Dirichlet series fails
to converge for `0 < σ ≤ 1` is confirmed, and Theorem 3.2 sharpens it at `σ = 1`
(divergent but bounded-oscillatory, amplitude `1/|t|`).

**5.4 Where the arithmetic sits.** The spiral object `Σ_n n^{−σ}(c_{n,∞} − i ε_n s_{n,∞})`
**is** `ζ(σ+it)` for `σ > 1`, so it carries all of `ζ`'s arithmetic — the Euler product,
the zeros, everything. The word-level statement is definitional rather than a theorem:
the word is a deterministic function of the reduced phase `θ_n`, i.e. of the phases
`t log n`, so once those phases and the amplitudes `n^{−σ}` are fixed the word is
determined and cannot contribute independent arithmetic data (equivalently, the map
(phase, truncation `N`) ↦ truncated word is well defined and many-to-one). The
programme's parity barrier ([`03`](../../../twin-prime-parity/dictionary/03-parity-problem.md)) is a statement
about the word/support and index parity; attaching the radial weight does not change it,
and it is not a claim that the weighted spiral cannot be `ζ`.

---

## 6. Numerical verification

`python3` + `numpy` 2.5 + `mpmath` 1.3 (40 dps references). The recursion of §2 is
vectorised over the phase list.

### 6.1 The raw `1/n` series does not converge (Theorem 3.2)

See the table in §3.2: `|P_M − ζ(1+10i)| = 0.1000` for all `M = 10²…10⁷`, matching the
predicted amplitude `1/|t| = 0.1`.

### 6.2 The requested `1/n`, regularised: `η_{M,N}/(1 − 2^{−it})`, `N = M`

| `t` | `M = N` | `｜η_{M,N}/(1−2^{−it}) − ζ(1+it)｜` | bound (3.4)/`｜1−2^{−it}｜` |
|---|---|---|---|
| 10 | 1000 | 6.552·10⁻⁴ | 5.4·10⁻² |
| 10 | 4000 | 1.302·10⁻⁴ | 1.5·10⁻² |
| 10 | 16000 | 1.818·10⁻⁵ | 4.2·10⁻³ |
| 2.5 | 1000 | 1.323·10⁻³ | 1.8·10⁻² |
| 2.5 | 4000 | 5.720·10⁻⁵ | 5.2·10⁻³ |
| 2.5 | 16000 | 1.518·10⁻⁵ | 1.5·10⁻³ |

Observed convergence is `O(M⁻¹)` (slightly better than the `log M / M` bound; the
greedy error cancels across terms). The bounds are worst-case and are ~80× the observed
errors; the tail constant `C(1,s) = 1 + |s|` accounts for most of that at `t = 10`.
The plain eta partial sums (no greedy step) give
`7.8·10⁻³, 7.8·10⁻⁴, 7.8·10⁻⁵, …` at `M = 10², 10³, 10⁴, …`, confirming the eta route.
`t = 10` and `t = 2.5` are both away from the excluded set `(2π/log 2)ℤ` of Remark 3.4b.

### 6.3 Convergent amplitude `σ > 1` (`N = M`)

| `σ`, `t` | `M = N` | `｜G_{M,N} − ζ(σ+it)｜` | bound (3.1) |
|---|---|---|---|
| 1.5, 6.0 | 2000 | 3.949·10⁻³ | 4.9·10⁻² |
| 1.5, 6.0 | 8000 | 1.751·10⁻³ | 2.3·10⁻² |
| 1.5, 6.0 | 32000 | 9.219·10⁻⁴ | 1.1·10⁻² |
| 2.0, 10.0 | 2000 | 1.251·10⁻⁴ | 3.1·10⁻³ |
| 2.0, 10.0 | 8000 | 3.369·10⁻⁵ | 7.7·10⁻⁴ |
| 2.0, 10.0 | 32000 | 2.229·10⁻⁵ | 1.9·10⁻⁴ |

At `σ = 1.5` the bound is dominated by the zeta tail `M^{−1/2}`. At `σ = 2` the observed
errors are non-monotone and fall below both bound summands, consistent with the
staircase of v1 Remark 5.3 (a stagnant term re-taking only at a large index), but that
attribution is not established here.

### 6.4 Strip `0 < σ < 1`, radially weighted eta (`N = M`)

| `σ`, `t` | `M = N` | `｜η_{M,N}/(1−2^{1−s}) − ζ｜` |
|---|---|---|
| 0.5, 14.134725 | 1000 | 6.630·10⁻³ |
| 0.5, 14.134725 | 4000 | 3.511·10⁻³ |
| 0.5, 14.134725 | 16000 | 1.732·10⁻³ |
| 0.8, 5.0 | 1000 | 1.118·10⁻³ |
| 0.8, 5.0 | 4000 | 2.495·10⁻⁴ |
| 0.8, 5.0 | 16000 | 1.240·10⁻⁴ |

The decay is consistent with the corrected tail `C(σ,s)M^{−σ}` up to the greedy term;
the local exponents are noisy (at `σ = 0.8` they run `≈1.1` then `≈0.5`, not a clean
`0.8`), so this is a consistency check, not a rate measurement.

### 6.5 Reproduction (complete script)

Runs as printed; reproduces `3.369·10⁻⁵` (`σ = 2`) and `1.302·10⁻⁴` (`σ = 1`).

```python
import numpy as np
PI = np.pi

def reduce_phase(ns, t):
    phi = (t*np.log(ns)) % (2*PI)
    eps = np.where(phi <= PI, 1.0, -1.0)
    th  = np.where(phi <= PI, phi, 2*PI - phi)
    return th, eps

def spiral_greedy(theta, sigma, ns, N):
    """(C, S) with C + 1j*S = n^-sigma * exp(1j*theta_N); the sign eps is applied outside."""
    ns = ns.astype(float)
    th = np.zeros_like(theta); C = ns**(-sigma); S = np.zeros_like(theta)
    for k in range(N):
        a = PI/(k+2); ca, sa = np.cos(a), np.sin(a)
        take = (theta - th) >= a
        Cn = np.where(take, C*ca - S*sa, C)
        Sn = np.where(take, S*ca + C*sa, S)
        th = np.where(take, th + a, th); C, S = Cn, Sn
    return C, S

def greedy_term(sigma, t, M, N, alternating=False):
    ns = np.arange(1, M+1, dtype=float)
    th, eps = reduce_phase(ns, t)
    C, S = spiral_greedy(th, sigma, ns, N)
    w = ((-1.0)**(ns - 1)) if alternating else 1.0
    return np.sum(w * (C - 1j*eps*S))

# sigma > 1 : G approximates zeta(sigma + i t), no prefactor
G = greedy_term(2.0, 10.0, 8000, 8000)

# sigma <= 1 : eta-regularised,  zeta(s) = eta(s)/(1 - 2^(1-s))   (s off 1 and off (2pi/log2)Z)
sigma, t, M, N = 1.0, 10.0, 4000, 4000
eta  = greedy_term(sigma, t, M, N, alternating=True)
s    = complex(sigma, t)
pref = 1.0 - np.exp((1.0 - s)*np.log(2.0))
zeta_approx = eta / pref
```

---

## 7. External literature: every ingredient is classical

Added after an external-review pass. The short finding: **none of the techniques is
new**, and where a direct comparison exists the note's choice is asymptotically far
worse than the standard one. What could be new is only the application to the phases
`t log n`, which §0 already identifies as a rewriting.

**7.1 The take rule is the greedy Egyptian (Sylvester) expansion.** On `x = θ/π` the
rule `δ_k = 1 ⟺ r ≥ 1/(k+2)` is *verbatim* the classical **greedy algorithm for
Egyptian fractions** with the unit fractions `1/2, 1/3, 1/4, …` — the **Sylvester
expansion** (Fibonacci 1202; Sylvester 1880). The note's "Sylvester-sparsity" bound
`m_{i+1} ≥ m_i(m_i−1) + 1` is the classical **Sylvester sequence** recurrence
`s_{n+1} = s_n² − s_n + 1` (`s_0 = 2`: 2, 3, 7, 43, 1807, …, doubly exponential,
OEIS A000058, [Wikipedia: Sylvester's sequence]), and the "late digits are a numerical
mirage" observation (v1 Remark 5.3) is the standard difficulty of continuing the greedy
Egyptian expansion of an irrational. The programme's "reachability" chapter is the
discrete completeness theory: **Brown's criterion** (Brown 1961, *Amer. Math. Monthly*
68(6), 557–560; [Wikipedia: Complete sequence]) and the source's own citation
**Graham 1964**, *Acta Arithmetica* 10, 63–70. So the greedy-word machinery is
textbook Egyptian-fraction theory, and the source already points at it.

**7.2 Composing elementary rotations is CORDIC.** Realising a target angle by a
digit sequence of precomputed elementary rotations, and reading `(cos θ, sin θ)` off
the accumulated angle, is exactly **CORDIC / Volder's algorithm** (J. E. Volder 1959,
*IRE Trans. Electronic Computers* EC-8, 330–334; [Wikipedia: CORDIC]): "a sequence of
scaled rotations … the scale factors and angles of rotation are known in advance; only
the direction of each rotation is dependent on the input … the rotation directions are
chosen so that the accumulated rotation angle approaches the target." CORDIC is
"digit-by-digit", converging one bit per iteration. The note's `δ_k`, `α_k` and fusion
recursion are a special case with a different angle table; two differences matter.

* **Schedule.** CORDIC uses the *geometric* table `α_k = atan(2^{−k})`, whose sum
  converges to `1.7432866205… rad ≈ 99.883°`, giving **exponential** accuracy: after `N`
  steps the residual is `O(2^{−N})`. The note uses the *harmonic* table `α_k = π/(k+2)`,
  whose sum diverges — so it covers `[0, π]` with no range reduction — but whose uniform
  accuracy is only `O(1/N)`. For a target angle to accuracy `ε` the harmonic schedule
  needs `N ≈ π/ε` terms; the geometric one needs `N ≈ log₂(1/ε)`. At `ε = 10⁻⁶`:
  3.1·10⁶ versus 20. The trade-off (complete range vs exponential rate) is real and
  classical, and the note never states it. Its "certified uniform bound" is therefore a
  bound on a schedule that is asymptotically far worse than the standard one for angle
  quantisation.
* **Scale.** CORDIC carries the fixed precomputed factor `∏_k √(1 + 2^{−2k}) ≈ 1.64676`
  (the "CORDIC gain"). This is precisely the note's "radial weight": a normalisation
  constant, not something generated by the rotation digits — an external confirmation of
  Remark 5.1.

So the note's central object is a **harmonic-alphabet, unsigned variant of CORDIC**, a
known technique from 1959.

**7.3 Euler–Maclaurin and the tail constant.** (3.1)–(3.2) and (3.4) are instances of
the **Euler–Maclaurin formula** (DLMF §2.10.1), of **summation by parts** (DLMF
§2.10.9), and of the standard partial-sum expansion
`Σ_{n≤M} n^{−s} = ζ(s) + M^{1−s}/(1−s) + O(M^{−σ})` used to compute and control `ζ`
(Titchmarsh, *The Theory of the Riemann Zeta-Function*, 2nd ed., Ch. 4). The pairing
estimate `|z_n − z_{n+1}| ≤ |s|∫_n^{n+1} x^{−σ−1} dx` behind the constant `|s|/σ` is
the same summation-by-parts argument, and the "remainder bounded by the first neglected
term" convention is DLMF §2.10(i) (remarks after 2.10.7). None of this is new.

**7.4 Dirichlet series, the abscissa, and the eta zeros.** The convergence boundary
`σ = 1` and the formula `σ_c = limsup log|A(x)| / log x` are **Cahen's formula**
(E. Cahen 1894; standard reference Hardy–Riesz, *The General Theory of Dirichlet's
Series*, 1915). The zeros of `1 − 2^{1−s}`, i.e. `s = 1 + 2πin/log 2`, are the standard
complex zeros contributed by the eta factor; whether `η` vanishes there (equivalently,
that `ζ` is finite there) is **Landau's problem** (Landau 1909), solved by **Widder**
(*The Laplace Transform*) using the next prime `3` in place of `2`
([Wikipedia: Dirichlet eta function], "Landau's problem"). Our Remark 3.4b is an
instance of that solved problem, and the cancellation at `t = 0` is the classical one
noted by Titchmarsh (p. 17). `η` is Abel-summable and entire, and the eta identity is
the standard one.

**7.5 What the external search did not find.** The searches performed for this note
surfaced no work connecting the greedy Egyptian/Sylvester expansion of the phases
`t log n` to `ζ`. The reason is §0: the phases are inputs, so no connection is needed.
If the programme has a novelty claim it can only be the *quantitative uniform statement*
of §3 — a CORDIC-type analysis for a non-standard alphabet — or the negative
results (the amplitude barrier). Both are better described in those terms than as a new
"greedy harmonic sine".

**External references.** Volder 1959 (*IRE Trans. EC-8*, 330–334) · Sylvester 1880
(*Amer. J. Math.*; OEIS A000058) · Brown 1961 (*Amer. Math. Monthly* 68(6), 557–560,
doi:10.2307/2311150) · Graham 1964 (*Acta Arith.* 10, 63–70) · Erdős–Graham 1980,
*Old and New Problems and Results in Combinatorial Number Theory* · Cahen 1894
(*Ann. Sci. Éc. Norm. Supér.*) · Hardy–Riesz 1915, *The General Theory of Dirichlet's
Series* · Titchmarsh 1986, *The Theory of the Riemann Zeta-Function*, 2nd ed. ·
NIST DLMF §2.10, §25.2 · Widder, *The Laplace Transform* · Landau 1909 ·
[arXiv:2503.12277](https://arxiv.org/abs/2503.12277) (Erdős–Graham conjecture on
Sylvester's sequence) · [Wikipedia: CORDIC](https://en.wikipedia.org/wiki/CORDIC) ·
[Wikipedia: Sylvester's sequence](https://en.wikipedia.org/wiki/Sylvester%27s_sequence) ·
[Wikipedia: Complete sequence](https://en.wikipedia.org/wiki/Complete_sequence) ·
[Wikipedia: Dirichlet eta function](https://en.wikipedia.org/wiki/Dirichlet_eta_function).

---

## 8. Status

| Item | Status |
|---|---|
| Spiral term `T_{n,N} = n^{−σ}(c_{n,N} − i ε_n s_{n,N})` = greedy reconstruction at radius `n^{−σ}` | DEFINITION |
| Residual bound `r_N ≤ π/(N+1)` (proof in §1) | THEOREM (sharp; source's `π/(N+2)` corrected) |
| Source Lemma 4.1 (selection monotonicity) underlying the source's §4–§6 | **FALSE** (counterexample in §1; not used here) |
| Theorem 3.1 (`σ > 1`) | identity/rewriting; quantitative content is the bound (3.1) (Remark 5.1c) |
| Truncation bound (3.1) | THEOREM, but only the trivial tail + a non-negative greedy term; never better than the ordinary partial-sum bound |
| Theorem 3.2 (`1/n` raw series divergent, amplitude `1/\|t\|`) | THEOREM (elementary Euler–Maclaurin) + NUMERICAL (§6.1) |
| Proposition 3.3 / Corollary 3.4 (`0 < σ ≤ 1`, eta-regularised; `1/n` case) | THEOREM with tail constant `C(σ,s)=1+\|s\|/σ` (Remark 3.3b); `t=0` is the pole and `t ∈ (2π/log 2)ℤ∖{0}` is removable (Remark 3.4b) |
| Generation of the radial law `n^{−σ}` by the greedy **word** itself | **NOT POSSIBLE** (trivial consequence: the word reads `θ_n` only; dictionary [`02`](../../../twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) §1) |
| Amplitude of the **term map** | **PRESENT**: each term is the image of `(1,0)` under a spiral similarity; the orbit under the iteration is a circle (Remark 2.4) |
| Computational gain | **NONE** — the recursion consumes the phase it reconstructs (Scope, Remark 5.1c) |
| `Ω`-parity signal from the greedy word | **NONE** (dictionary [`03`](../../../twin-prime-parity/dictionary/03-parity-problem.md)); the series, being `ζ`, carries `ζ`'s arithmetic |
| Novelty of the ingredients (§7) | **NONE**: greedy word = Sylvester/Egyptian expansion (Sylvester 1880; Brown 1961; Graham 1964); rotation composition = CORDIC (Volder 1959); bounds = Euler–Maclaurin (DLMF §2.10); abscissa = Cahen 1894; eta zeros = Landau/Widder. The harmonic schedule is `O(1/N)` versus CORDIC's `O(2^{−N})` |

**Bottom line.** Attaching the amplitude by multiplying the greedy term by `1/n`
turns the unit-circle reconstruction into a radially weighted one and gives the exact
identity `ζ(σ+it) = Σ n^{−σ}(c_{n,∞} − i ε_n s_{n,∞})` for `σ > 1` — which, as `N → ∞`,
is nothing but the ordinary Dirichlet partial sum. The requested weight `n^{−1}`
corresponds to `σ = 1`, the **abscissa of convergence** (not the critical line `σ = 1/2`,
which needs `1/√n`): its raw sum diverges (partial sums oscillating with amplitude
`1/|t|`), and `ζ(1+it)` is recovered from the radially weighted **eta** series through
`ζ(1+it) = η(1+it)/(1 − 2^{−it})` for `t ∉ (2π/log 2)ℤ` (at `t = 0` the pole; at
`t ∈ (2π/log 2)ℤ∖{0}` a removable limit), with greedy error `O(log M / M)` up to the tail
constant `1 + |s|`. The radial decay is present in every term, so the object is **not**
amplitude-blind; what the greedy word does not do is generate the radial law — it
supplies the angle `θ_n`, the index supplies the modulus `n^{−σ}`.
