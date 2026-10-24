# 004 — The Riemann zeta function in greedy-harmonic coordinates: the cos and sin of each term

> **Version 2** — the same construction with the zeta amplitude inserted as a radial
> weight on each term (the `1/n` spiral term, its convergent `σ > 1` form, and the
> eta-regularised abscissa of convergence `σ = 1`, which is **not** the critical line
> `σ = 1/2`) — is [`research-v2.md`](research-v2.md).
>
> **Scope (both versions).** As `N → ∞` the reconstructed object is the ordinary
> Dirichlet partial sum `Σ_{n≤M} n^{−s}`, and the recursion consumes the phase it
> reconstructs; so this is a uniform angle-quantisation statement with explicit
> worst-case bounds, **not** a new representation, an algorithm, or a route to the zeros.
> See [`research-v2.md`](research-v2.md) §0 "Scope". Every ingredient is classical —
> Sylvester/Egyptian greedy expansion, CORDIC-style rotation composition, Euler–Maclaurin,
> Cahen's abscissa, Landau–Widder for the eta zeros; see
> [`research-v2.md`](research-v2.md) §7 "External literature".

**Task.** Express `ζ(s)` in terms of the real parts (cosines) and imaginary parts
(sines) of its individual terms, using the greedy harmonic expansion of

> V. Geere, *On the Correlation Structure of a Greedy Harmonic Decomposition of the
> Sine Function* (March 2026),
> <https://victorgeere.co.za/archive/maths/rh/research/greedy-harmonic/greedy-harmonic-decomposition.html>

**Provenance / identification.** The source's alphabet is the **angles**
`α_k = π/(k+2)` on a target `θ ∈ [0,π]` with the take rule
`δ_k = 1 ⟺ θ − θ_k ≥ α_k` (source Definitions 2.1–2.2). Dividing by `π`, this is
*exactly* the unsigned greedy word of the programme dictionary
([`../dictionary/02-greedy-harmonic-sine.md`](../dictionary/02-greedy-harmonic-sine.md) §1)
on the target `x = θ/π ∈ [0,1]` with alphabet `1/(k+2)`. The **signed Tau reading**
(dictionary §2) is a different object and is *not* used here.

Status legend — THEOREM: proved; NUMERICAL: finite computation only; REMARK: no claim.

---

## 0. Summary of the result

For `s = σ + it` with `σ > 1`, writing `φ_n = t log n` and reducing the phase of the
`n`-th term to an angle `θ_n ∈ [0,π]` with a sign `ε_n ∈ {±1}`, the source's greedy
fusion rule reconstructs that phase exactly, and

```
                                   ∞
ζ(σ + it)  =  Σ  n^{-σ} · [ cos(t log n)          −  i · sin(t log n)        ]
             n=1                └── real part ──┘     └── imaginary part ──┘

                  ∞
           =  Σ  n^{-σ} · [   c_{n,∞}            −  i ε_n s_{n,∞}          ]
             n=1

                  ∞
           =  Σ  n^{-σ} · Π  ( cos α_k − i sin α_k )^{ ε_n δ_k(θ_n) } ,
             n=1          k≥0
```

where `c_{n,N} = cos θ_{n,N}`, `s_{n,N} = sin θ_{n,N}`,
`θ_{n,N} = Σ_{k<N} δ_k(θ_n) α_k` is produced by the greedy recursion, and the
`(cos α_k, sin α_k)` are the elementary `(cos, sin)` of the harmonic angles
`α_k = π/(k+2)`. The modulus `n^{-σ}` is **not** produced by the expansion: the
greedy product is a pure rotation and carries the phase only. All three lines are the
same identity in three grades of explicitness.

---

## 1. The expansion (from the source)

**Definitions (source 2.1–2.2).** `α_k = π/(k+2)`, `k = 0,1,2,…`. For `θ ∈ [0,π]` set
`θ_0 = 0`, `c_0 = 1`, `s_0 = 0`, and for `k = 0,1,2,…`

```
δ_k(θ)  = 1  ⟺  θ − θ_k ≥ α_k          (greedy take rule)
θ_{k+1} = θ_k + δ_k α_k
c_{k+1} = c_k cos α_k − δ_k s_k sin α_k        (fusion: angle-addition formula)
s_{k+1} = s_k cos α_k + δ_k c_k sin α_k
```

**Invariant and convergence (source Thm 2.4, Lemma 3.2).** `c_k = cos θ_k`,
`s_k = sin θ_k` for every `k`, and

```
sin θ = lim_{N→∞} s_N(θ) ,        cos θ = lim_{N→∞} c_N(θ) .
```

**Residual bound.** After processing `N` indices (`k = 0,…,N−1`) the residual
`r_N = θ − θ_N` satisfies `r_N ≤ α_{N−1} = π/(N+1)`, hence by the mean value theorem

```
| cos θ − c_N(θ) | ≤ π/(N+1) ,     | sin θ − s_N(θ) | ≤ π/(N+1) .
```

*Proof.* Induction on `N ≥ 1`. `N = 1`: if `θ ≥ α_0 = π/2` then `r_1 = θ − π/2 ≤ π/2`;
otherwise `r_1 = θ < π/2`. Step: assume `r_{N−1} ≤ α_{N−2}`; if index `N−1` is taken then
`r_N = r_{N−1} − α_{N−1} ≤ α_{N−2} − α_{N−1} = π/(N(N+1)) < α_{N−1}`, and if skipped
`r_N = r_{N−1} < α_{N−1}`. ∎

*Index note (minor erratum in the source).* Source Lemma 3.1 states `r_N ≤ π/(N+2)`
(and Lemma 3.2 inherits it for `sin`); its own proof line gives `r_N ≤ α_{n−1} =
π/(n+1)`, which is the sharp constant — `sup_θ r_N = π/(N+1)` for every `N ≥ 1`, since
`θ → (π/(N+1))^−` makes every index skip. We use the safe `π/(N+1)` throughout; the
source's `π/(N+2)` is optimistic by one index. Everything below is unaffected in
substance.

> **Source caveat.** The source's *Lemma 4.1* (selection monotonicity) is **false**: with
> the source's own rule, `δ_1` takes the values `1, 0, 1` at `x = θ/π = 1/3, 1/2, 5/6`
> (exact rational computation). This invalidates the *threshold* machinery — the "first
> selection" angles `θ_n^*` and the closed forms for `K(n,m)` derived from them (source
> Lemmas 4.3, 4.6–4.7, §5) — but not source Proposition 6.3, which holds by the integral
> representation regardless of monotonicity. v1 uses only Definitions 2.1–2.2, the
> fusion recursion and the residual bound above.

**Product form.** Since each fusion multiplies `e^{iθ_k}` by `e^{iδ_k α_k}`,

```
c_N − i s_N = e^{−i θ_N} = Π_{k<N} ( cos α_k − i sin α_k )^{δ_k(θ)} ,     (1.1)
```

a product of `N` elementary rotations; the factors are `1` when `δ_k = 0` and
`cos α_k − i sin α_k` when `δ_k = 1`.

---

## 2. Splitting each zeta term into a real (cos) and imaginary (sin) part

Let `s = σ + it`, `n ≥ 1`. Then

```
n^{−s} = e^{−s log n} = n^{−σ} e^{−it log n}
       = n^{−σ} [ cos(t log n) − i sin(t log n) ] .
```

Hence, for `σ > 1` (absolute convergence),

```
        ∞                                   ∞
Re ζ(s) = Σ n^{−σ} cos(t log n) ,   Im ζ(s) = − Σ n^{−σ} sin(t log n) ,      (2.1)
       n=1                                 n=1
```

so

```
        ∞                                   ∞
ζ(s) =  Σ n^{−σ} cos(t log n)   −   i  Σ n^{−σ} sin(t log n) .               (2.2)
       n=1                                 n=1
```

This is the trivial real/imaginary split; the content of the next section is that the
source's expansion supplies `cos(t log n)` and `sin(t log n)` **term by term**, out of
the cosines and sines of the harmonic angles `α_k = π/(k+2)`.

---

## 3. Phase reduction of the n-th term

The expansion is stated for target angles in `[0,π]`; `φ_n = t log n` is an arbitrary
real. Reduce it by `2π`-periodicity of `cos` and `sin`:

```
r_n  := φ_n mod 2π  ∈ [0, 2π) ,
θ_n  := r_n            if r_n ≤ π ,     ε_n := +1   if r_n ≤ π ,
θ_n  := 2π − r_n       if r_n > π ,     ε_n := −1   if r_n > π .
```

**Lemma 3.1 (reduction).** `θ_n ∈ [0,π]`, `ε_n = sgn(sin φ_n)`, and

```
cos φ_n = cos θ_n ,   sin φ_n = ε_n sin θ_n ,   e^{−iφ_n} = cos θ_n − i ε_n sin θ_n .
```

*Proof.* `cos` is `2π`-periodic and even; `sin` is `2π`-periodic and odd. For
`r_n > π`, `θ_n = 2π − r_n` gives `cos θ_n = cos r_n` and `sin θ_n = −sin r_n`, so
`ε_n sin θ_n = (−1)(−sin r_n) = sin r_n`. ∎

In words: `ε_n = +1` on the upper half of the phase circle and `ε_n = −1` on the lower
half, and the greedy expansion only ever reconstructs angles in the upper half
`[0,π]`; the lower half is carried by the explicit sign `ε_n`.

---

## 4. Main result: the greedy representation of ζ

Notation: for each `n`, run the source's recursion with target `θ_n` and write

```
δ_{n,k} := δ_k(θ_n) ∈ {0,1} ,   θ_{n,N} := Σ_{k<N} δ_{n,k} α_k ,   α_k = π/(k+2) ,
c_{n,N} := c_N(θ_n) ,            s_{n,N} := s_N(θ_n) .
```

**Theorem 4.1 (termwise greedy decomposition of ζ; `σ > 1`).** For every `t ∈ ℝ`,

```
                                                        (A) direct
   ζ(σ+it) = Σ_{n≥1} n^{−σ} [ cos(t log n) − i sin(t log n) ]
                                                        (B) reduced phase
            = Σ_{n≥1} n^{−σ} [ cos θ_n − i ε_n sin θ_n ]
                                                        (C) greedy limits
            = Σ_{n≥1} n^{−σ} [ lim_N c_{n,N} − i ε_n lim_N s_{n,N} ]
                                                        (D) finite-N, then limit
            = lim_{N→∞} Σ_{n≥1} n^{−σ} [ c_{n,N} − i ε_n s_{n,N} ]
                                                        (E) product of rotations
            = Σ_{n≥1} n^{−σ} Π_{k≥0} ( cos α_k − i sin α_k )^{ ε_n δ_{n,k} } ,
```

the product in (E) being the limit of its partial products over `k = 0,…,N−1`
(equation (1.1) with `δ → ε_n δ`, valid since the exponent is an integer).

*Component form.* The real and imaginary parts are, separately,

```
Re ζ(σ+it) =  Σ_{n≥1} n^{−σ} · lim_{N→∞} c_{n,N}                 (cosine of each term)
Im ζ(σ+it) = −Σ_{n≥1} n^{−σ} · ε_n lim_{N→∞} s_{n,N}             (sine of each term)
```

*Proof.* Each term of (2.2) is exact for every `n` by the source's reconstruction
theorem applied to `θ_n` (via Lemma 3.1), giving (A) ⇒ (B) ⇒ (C). For (C) ⇒ (D):
`|c_{n,N}|, |s_{n,N}| ≤ 1`, and `Σ_{n≥1} n^{−σ} < ∞` for `σ > 1`, so the limit
`N → ∞` may be taken inside the sum by dominated convergence. (E) is the product form
(1.1) with the sign `ε_n` absorbed into the exponent:
`e^{−i ε_n θ_{n,N}} = Π_{k<N} (cos α_k − i sin α_k)^{ε_n δ_{n,k}}`. ∎

**Corollary 4.2 (support form).** With `A(θ_n) = {k : δ_k(θ_n) = 1}` the greedy
support of the `n`-th phase,

```
e^{−i ε_n θ_n} = Π_{k ∈ A(θ_n)} ( cos α_k − i sin α_k )^{ε_n} ,
```

i.e. `Π_{k∈A} (cos α_k − i sin α_k)` for `ε_n = +1` (upper half-plane phases) and its
conjugate `Π_{k∈A} (cos α_k + i sin α_k)` for `ε_n = −1`.

**Corollary 4.3 (real `s`).** For `t = 0` every `φ_n = 0`, so `θ_n = 0` for all `n`,
every `δ_{n,k} = 0`, and `c_{n,N} = 1`, `s_{n,N} = 0`; (C) collapses to
`ζ(σ) = Σ_{n≥1} n^{−σ}`, as it must.

**Remark 4.4 (what the expansion does and does not give).** Form (E) exhibits the
`n`-th term as `(external modulus) × (greedy phase rotation)`. The greedy word sees
only the **angle** `θ_n` (unsigned rule, dictionary
[`02`](../dictionary/02-greedy-harmonic-sine.md) §1, Definition 1.1); the **amplitude**
`n^{−σ}` enters the construction from outside and is not a function of the word. The
identity above is a faithful rewriting of ζ's phase in greedy coordinates, not a way to
generate `n^{−σ}` from the word. *(The stronger programme statement that a 0/1 digit
cannot carry the amplitude family `Λ(n)/√n` of the explicit formula belongs to the
rh45/rh47 harvest, not to dictionary 02 §6, which is about factorisation and
`λ`-parity.)*

---

## 5. Truncation: the cos/sin tails and their bound

**Definition 5.1 (the truncated greedy ζ).** For integers `M ≥ 1`, `N ≥ 0` set

```
G_{M,N}(s) = Σ_{n=1}^{M} n^{−σ} [ c_{n,N} − i ε_n s_{n,N} ] .
```

**Theorem 5.2 (two-sided error; `σ > 1`).** With `H_{M,σ} = Σ_{n=1}^{M} n^{−σ}`,

```
| ζ(s) − G_{M,N}(s) |  ≤  Σ_{n>M} n^{−σ}  +  (π / (N+1)) · H_{M,σ}
                      ≤  M^{1−σ}/(σ−1)   +  (π / (N+1)) · H_{M,σ} ,        (5.1)
```

and, sending `M → ∞` (so that the tail vanishes),

```
| ζ(s) − G_{∞,N}(s) |  ≤  (π / (N+1)) · ζ(σ) .                            (5.2)
```

Componentwise, `|Re ζ(s) − Σ_{n≤M} n^{−σ} c_{n,N}| ≤ (π/(N+1)) H_{M,σ} + tail`, and
likewise for the imaginary part.

*Proof.* Each term obeys `|e^{−iε_nθ_n} − (c_{n,N} − i ε_n s_{n,N})| =
|e^{−iε_n r_N} − 1| ≤ r_N ≤ π/(N+1)`, since `|e^{ix} − 1| ≤ |x|`; no coordinate-wise
`√2` is needed. Sum, and bound the zeta tail by
`Σ_{n>M} n^{−σ} ≤ ∫_M^∞ x^{−σ} dx = M^{1−σ}/(σ−1)`. ∎

*What (5.1) does and does not say.* As `N → ∞`, `G_{M,N} → S_M = Σ_{n≤M} n^{−s}`, so
(5.1) is the trivial partial-sum tail **plus a non-negative greedy error**; it is never
smaller than the trivial bound for the ordinary partial sum. Its content is the
*uniformity* in the target angle (§1), not an improvement in evaluating ζ.

**Remark 5.3 (the truncation error is a staircase, not a smooth `1/N`).** For fixed
`n`, `c_{n,N} − i ε_n s_{n,N} = e^{−i ε_n θ_{n,N}}` is *constant* in `N` between
successive take-indices of the word `w(θ_n/π)`, and jumps only when index `N` is
taken. So the termwise error is the greedy residual of `θ_n`, a decreasing staircase.
By the programme's Sylvester-sparsity theorem (dictionary
[`02`](../dictionary/02-greedy-harmonic-sine.md) §4, rh47), the gaps between
consecutive takes grow super-exponentially, so a single term can dominate the total
error and stagnate over a very wide range of `N` before its next take. **Diagnosed
numerically** in §8.3: for `σ = 3`, `t = 7.5`, the term `n = 3` has residual
`≈ 1.45·10⁻⁵`, essentially constant for `2·10⁴ ≤ N ≤ 8·10⁴`, contributing
`3^{−3}·1.45·10⁻⁵ ≈ 5.4·10⁻⁷` — the observed error floor. The bound (5.2) still
holds; it is the *rate* that is staircase-like, and the worst case over all `θ` is
what supplies the uniform `1/N`.

---

## 6. The critical strip `0 < σ ≤ 1`

The series `Σ n^{−σ} e^{−it log n}` does not converge for `0 < σ ≤ 1`; ζ there is the
analytic continuation. The available convergent handle is the alternating (eta)
series, which is index-parity data already used by the programme
([`../dictionary/04-zeta-relations.md`](../dictionary/04-zeta-relations.md) §1):

```
η(s) = Σ_{n≥1} (−1)^{n−1} n^{−s} = (1 − 2^{1−s}) ζ(s)     (s ≠ 1) ,
```

which converges conditionally for `σ > 0` by **Dirichlet's test** (the real-alternating
Leibniz test does not apply to the complex terms once `t ≠ 0`; see the proof of
Prop. 6.1).

**Proposition 6.1 (greedy eta representation in the strip).** For `s ≠ 1`,
`0 < σ ≤ 1`, and all `M ≥ 1`, `N ≥ 0`, set

```
η_{M,N}(s) = Σ_{n=1}^{M} (−1)^{n−1} n^{−σ} [ c_{n,N} − i ε_n s_{n,N} ] .
```

Then

```
| η(s) − η_{M,N}(s) |  ≤  C(σ,s) M^{−σ}  +  (π/(N+1)) · H_{M,σ} ,               (6.1)

C(σ,s) = 1 + |s|/σ ,        H_{M,σ} ≤ 1 + M^{1−σ}/(1−σ)   (σ < 1) ,   H_{M,1} ≤ 1 + log M ,
```

and consequently `ζ(s) = lim η_{M,N}(s)/(1 − 2^{1−s})` along any path with
`M → ∞` and `N ≫ M^{1−σ}` (e.g. `N = M^{2−σ}`), with the error of `ζ` bounded by
`|1 − 2^{1−s}|^{−1}` times (6.1). The prefactor vanishes on `t ∈ (2π/log 2)ℤ`: at
`t = 0` that is the **pole** (`η(1) = log 2 ≠ 0`, so the quotient is `log 2 / 0`), while
for `t ∈ (2π/log 2)ℤ∖{0}` one has `η(1+it) = 0` too and the quotient is a
removable-singularity limit. Divide only off `t = 0`, and only by limits on the rest of
that set.

*Proof.* The alternating tail `Σ_{n>M}(−1)^{n−1} n^{−s}` is **not** a real alternating
series once the phases `e^{−it log n}` are present, so the Leibniz estimate
`(M+1)^{−σ}` does not apply. Pair adjacent terms instead: with `z_n = n^{−s}`,
`|z_n − z_{n+1}| ≤ |s|∫_n^{n+1} x^{−σ−1} dx`, and the paired sum telescopes to
`|s|/σ·(M+1)^{−σ}`; adding the leading omitted term gives `C(σ,s) = 1 + |s|/σ`. The
greedy part is bounded as in Theorem 5.2. Dividing by `1 − 2^{1−s}` gives the
statement. (Counterexample to the old constant-`1` form: `M = 1`, `N = 100`,
`s = 1+10i` gives LHS `= |η(1+10i) − 1| = 1.0452 > 1 + √2π/101 = 1.0440`.) ∎

**Remark 6.2 (pole).** At `s = 1` the prefactor vanishes and `ζ` has its pole; the
representation is necessarily excluded there. `η(1) = log 2`.

**Remark 6.3 (conditional, not absolute).** The bound (6.1) is a genuine convergence
proof for the greedy-reconstructed eta, but it is **conditional** in the sense that
the greedy error and the alternating tail must be balanced: unlike the `σ > 1` case
there is no single `N → ∞` limit of the *ζ* series. This mirrors the programme's
finding that in the strip the partial sum's error grows like `√N` (dictionary
[`04`](../dictionary/04-zeta-relations.md) §4): the greedy expansion fixes the
*phase* of each term, not the divergence of the series.

---

## 7. Remarks and connections

**7.1 The greedy product is amplitude-blind.** Forms (C)–(E) of Theorem 4.1 realise
`e^{−i t log n}` exactly as a product of unit factors: that product has modulus `1` and
carries the phase only. The modulus `n^{−σ}` of the zeta term is external, supplied by
the index. This is a statement about the greedy *product* (and hence about the word), not
about the series `n^{−σ}·(greedy product)`, which of course has amplitude; see
[`research-v2.md`](research-v2.md) §5.1 for the spiral version. This is why the identity
is a **rewriting** of the phase of ζ, not a new analytic continuation.

**7.2 Relation to source Remark 6.5 / §7.3.** The source observes that the Dirichlet
weight `w_n = (n+2)^{−s}` connects the greedy indicators to sub-sums of the shifted
zeta function, and explicitly leaves "identifying it with `ζ(s) − 1` at `θ = π` via
analytic continuation" open. Theorem 4.1 does not close that gap: it is a termwise
phase statement valid at every `θ_n`, not an identification of a single greedy
sub-sum with `ζ`. In particular the greedy word is a function of `θ_n` alone
(unsigned rule, dictionary [`02`](../dictionary/02-greedy-harmonic-sine.md) §1: the rule
reads `x = θ/π`; §3's "height" factorisation is about the *signed* rule). Discarding the
turn count is harmless for ζ's **phase**, because `cos` and `sin` are `2π`-periodic —
that is exactly what makes the phase reduction of §3 legitimate — but it is also why the
word can never see the growth encoded in `t log n`, and hence never the amplitude
`n^{−σ}`.

**7.3 Where the arithmetic is.** The right-hand side of (E) is built from the
transcendental numbers `cos(π/(k+2))`, `sin(π/(k+2))` and the 0/1 digits `δ_{n,k}`.
The programme's parity barrier (dictionary [`03`](../dictionary/03-parity-problem.md))
records that such a word carries no `Ω`-parity signal; nothing in Theorem 4.1 changes
that (the word is derived from the phases, so it adds no independent arithmetic data).
What Theorem 4.1 *does* give is a uniform, term-local evaluation of the `(cos, sin)`
pair of every zeta term with an explicit worst-case error — the "certification" virtue
the programme identified as the transferable content of the greedy construction, with
the cost caveat recorded in [`research-v2.md`](research-v2.md) Remark 5.1c.

**7.4 The sign `ε_n`.** The lower half-plane phases (`r_n > π`) are handled by an
explicit sign, not by the word. Equivalently one may fold the sign into a *signed*
alphabet (the Tau reading of dictionary
[`02`](../dictionary/02-greedy-harmonic-sine.md) §2), but that changes the take rule;
the unsigned source expansion plus `ε_n` is the faithful transcription.

---

## 8. Numerical verification

All checks were run with `python3` + `numpy` 2.5 + `mpmath` 1.3 (40–50 dps for the
exact references). The greedy recursion is vectorised over the phase list; the
reference partial sums `Σ_{n≤M} n^{−s}` are exact to the working precision.

### 8.1 The expansion itself (max error over 4000 random targets, `[0,π]`)

| `N` | `max｜θ−θ_N｜` | `max｜cosθ−c_N｜` | `max｜sinθ−s_N｜` | `π/(N+1)` |
|---|---|---|---|---|
| 50 | 6.159·10⁻² | 6.150·10⁻² | 6.127·10⁻² | 6.160·10⁻² |
| 500 | 6.253·10⁻³ | 6.122·10⁻³ | 6.138·10⁻³ | 6.271·10⁻³ |
| 5000 | 6.279·10⁻⁴ | 6.250·10⁻⁴ | 6.077·10⁻⁴ | 6.282·10⁻⁴ |

The measured maxima sit just below `π/(N+1)`: the constant is sharp.

### 8.2 Partial-sum representation `S_M(s) = Σ_{n≤M} n^{−s}` vs `G_{M,N}(s)`

`σ = 2`, `t = 10`, `M = 20000`:

| `N` | `｜S_M − G_{M,N}｜` | bound (5.1) | ratio |
|---|---|---|---|
| 200 | 1.917·10⁻³ | 2.571·10⁻² | 0.075 |
| 2000 | 7.699·10⁻⁵ | 2.582·10⁻³ | 0.030 |
| 20000 | 2.429·10⁻⁵ | 2.584·10⁻⁴ | 0.094 |

`σ = 3`, `t = 7.5`, `M = 20000`:

| `N` | `｜S_M − G_{M,N}｜` | bound (5.1) | ratio |
|---|---|---|---|
| 100 | 1.541·10⁻⁴ | 3.739·10⁻² | 0.004 |
| 1000 | 7.939·10⁻⁵ | 3.773·10⁻³ | 0.021 |
| 10000 | 7.380·10⁻⁷ | 3.776·10⁻⁴ | 0.002 |

High-precision small-`M` run (`σ = 2`, `t = 10`, `M = 50`), showing the expected decay
(the sequence is not monotone step-by-step, because individual terms pass through their
take-indices):

| `N` | `｜S_50 − G_{50,N}｜` |
|---|---|
| 25 | 9.125·10⁻³ |
| 100 | 6.733·10⁻³ |
| 400 | 6.550·10⁻⁴ |
| 1600 | 8.482·10⁻⁵ |
| 3200 | 4.053·10⁻⁵ |

### 8.3 The full zeta value (`σ = 3`, `t = 7.5`, `M = 20000`, `N = 20000`)

```
ζ(3 + 7.5 i)  =  +1.042657484510  + 0.088357077175 i
G_{20000,20000} =  +1.042658129206  + 0.088356803250 i
｜G − ζ｜        =   7.005·10⁻⁷          (zeta tail beyond M ≈ 1.25·10⁻⁹)
```

The error `≈ 7·10⁻⁷` is *the staircase floor of Remark 5.3*: term `n = 3` has residual
`≈ 1.45·10⁻⁵` and its next take lies near index `π/1.45·10⁻⁵ ≈ 2.2·10⁵`, so
`7.4·10⁻⁷ → 7.0·10⁻⁷ → 6.6·10⁻⁷ → 6.0·10⁻⁷` for `N = 10⁴, 2·10⁴, 4·10⁴, 8·10⁴`.
The uniform bound (5.2) at `N = 8·10⁴` is `π ζ(3)/8·10⁴ ≈ 4.7·10⁻⁵`, comfortably
respected.

### 8.4 Strip representation (Proposition 6.1, `M = N`)

`σ = 0.5`, `t = 14.134725` (first zero height; `ζ ≈ 1.77·10⁻⁸ − 1.11·10⁻⁷ i`):

| `M = N` | `｜η_{M,N} − η｜` | `｜η_{M,N}/(1−2^{1−s}) − ζ｜` |
|---|---|---|
| 500 | 2.315·10⁻² | 9.754·10⁻³ |
| 2000 | 1.093·10⁻² | 4.603·10⁻³ |
| 8000 | 5.361·10⁻³ | 2.259·10⁻³ |

`σ = 0.25`, `t = 6` (`ζ ≈ 0.81357 + 0.38174 i`):

| `M = N` | `｜η_{M,N} − η｜` | `｜η_{M,N}/(1−2^{1−s}) − ζ｜` |
|---|---|---|
| 500 | 1.040·10⁻¹ | 4.394·10⁻² |
| 2000 | 7.068·10⁻² | 2.988·10⁻² |
| 8000 | 5.225·10⁻² | 2.209·10⁻² |

The errors are consistent with `M^{−σ}` up to the constant `C(σ,s) = 1 + |s|/σ` of (6.1)
(roughly `1/√M` at `σ = 1/2`), with the coupling `N = M ≫ M^{1−σ}`; this is a
consistency check, not a rate measurement.

### 8.5 Reproduction

The verification script is self-contained; the essential routine is

```python
import numpy as np
PI = np.pi

def greedy_CS(thetas, N):
    """(theta_N, cos theta_N, sin theta_N) after N greedy steps, for a batch of targets."""
    th = np.zeros_like(thetas); C = np.ones_like(thetas); S = np.zeros_like(thetas)
    for k in range(N):
        a = PI/(k+2); ca, sa = np.cos(a), np.sin(a)
        take = (thetas - th) >= a
        Cn = np.where(take, C*ca - S*sa, C)
        Sn = np.where(take, S*ca + C*sa, S)
        th = np.where(take, th + a, th); C, S = Cn, Sn
    return th, C, S

def reduce_phase(ns, t):
    phi = (t*np.log(ns)) % (2*PI)
    eps = np.where(phi <= PI, 1.0, -1.0)
    th  = np.where(phi <= PI, phi, 2*PI - phi)
    return th, eps
```

then `G = np.sum(ns**(-sigma) * (C - 1j*eps*S))`.

---

## 9. Status

| Item | Status |
|---|---|
| Residual bound `r_N ≤ π/(N+1)` (proof in §1) | THEOREM (sharp; source's `π/(N+2)` corrected) |
| Source Lemma 4.1 (selection monotonicity) underlying the source's §4–§6 | **FALSE** (counterexample in §1; not used here) |
| Termwise identity `n^{−s} = n^{−σ}(cos θ_n − i ε_n sin θ_n)` with the source's greedy `(cos,sin)` | identity/rewriting (source Thm 2.4 + Lemma 3.1 above) |
| Theorem 4.1 (forms A–E for `σ > 1`) | identity/rewriting; its `N → ∞` limit is the ordinary Dirichlet partial sum |
| Truncation bound (5.1)–(5.2) | THEOREM, but only the trivial tail + a non-negative greedy term; never better than the ordinary partial-sum bound |
| Staircase structure of the error; Sylvester-sparse stagnation | THEOREM (sparsity) + NUMERICAL (§8.3) |
| Proposition 6.1 (strip, via eta) | THEOREM with tail constant `C(σ,s)=1+\|s\|/σ`; `t=0` is the pole, `t ∈ (2π/log 2)ℤ∖{0}` removable |
| Identification of a greedy sub-sum with `ζ − 1` (source §7.3) | **OPEN** — not achieved here |
| Computational gain | **NONE** — the recursion consumes the phase it reconstructs (see [`research-v2.md`](research-v2.md) §0 Scope, Remark 5.1c) |
| Arithmetic/parity content of the greedy **word** | **NONE** (dictionary [`03`](../dictionary/03-parity-problem.md)); the series it reconstructs is `ζ` and carries `ζ`'s arithmetic |

**Bottom line.** The greedy harmonic expansion expresses every zeta term exactly as

```
n^{−s} = n^{−σ} · Π_{k≥0} ( cos(π/(k+2)) − i sin(π/(k+2)) )^{ ε_n δ_k(θ_n) } ,
```

so `Re ζ` is a sum of the reconstructed cosines and `−Im ζ` a sum of the reconstructed
sines, each with the explicit uniform bound `π/(N+1)` (the amplitude `n^{−σ}` is external
to the word). The expression adds no arithmetic information beyond the phases `t log n`;
see [`research-v2.md`](research-v2.md) §5.4.
