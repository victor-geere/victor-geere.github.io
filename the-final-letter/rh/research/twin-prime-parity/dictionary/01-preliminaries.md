# 01 — Preliminaries: the objects, notation, and elementary lemmas

Part of the **twin-prime parity programme** dictionary.
See also: [`00-dictionary.md`](00-dictionary.md) (index), [`02-greedy-harmonic-sine.md`](02-greedy-harmonic-sine.md),
[`03-parity-problem.md`](03-parity-problem.md), [`04-zeta-relations.md`](04-zeta-relations.md).

---

## 1. Notation

| symbol | meaning |
|---|---|
| `s = σ + it` | a complex variable; the programme's two abscissae are `σ = 0` (rh43) and `σ = 1/2` (rh43 §7.6, rh044) |
| `ζ(s)` | the Riemann zeta function, `Σ n^{−s}` for `σ > 1`, continued |
| `η(s)` | the Dirichlet eta function, `Σ_{n≥1} (−1)^{n−1}n^{−s} = (1−2^{1−s})ζ(s)` |
| `θ(x)` | the Jacobi theta function, `Σ_{n∈ℤ} e^{−πn²x}` |
| `Λ(n)` | the von Mangoldt function: `log p` if `n = p^k`, else `0` |
| `Ω(n)` | the number of prime factors of `n` **with multiplicity** |
| `ω(n)` | the number of **distinct** prime factors |
| `λ(n)` | the **Liouville** function, `(−1)^{Ω(n)}` |
| `μ(n)` | the **Möbius** function, `(−1)^{ω(n)}` if `n` is squarefree, else `0` |
| `S_N(t)` | the zeta partial sum at `σ = 0`: `Σ_{n≤N} n^{−it}` (rh43) |
| `S_N^φ(s)` | the smoothed partial sum `Σ_{n≤N} φ(n/N)n^{−s}` (rh044) |
| `P_N(t), M_N(t)` | the positive and negative real parts of `S_N(t)` (rh43) |
| `S(x)` | the two-point correlation `Σ_{n≤x} λ(n)λ(n+2)` (rh46) |
| `α_n` | the signed *Tau* alphabet `(−1)^n/(n+2)^p` (rh42) |
| `P(p), N(p)` | the positive and negative ζ budgets (rh42) |
| `p*`, `q` | the completeness thresholds `ζ(p*) = 2`, `N(q) = 2·3^{−q}` (rh42) |

## 2. Arithmetic functions: the elementary facts

**Lemma 2.1 (multiplicativity).**  `λ` is **completely** multiplicative:
`λ(mn) = λ(m)λ(n)` for all `m, n ≥ 1`.  `μ` is multiplicative but not completely.
*Proof.*  `Ω(mn) = Ω(m) + Ω(n)`, and `(−1)^{a+b} = (−1)^a(−1)^b`.  ∎
*Status:* THEOREM.  *Source:* rh46 `Rh46/Chowla.lean` (`liouville_mul`, for nonzero
arguments; `liouville_mul_zero_false` refutes the `m = 0` case under the convention
`λ(0) = 1`).

**Lemma 2.2 (the square).**  `λ(n)² = 1` and `|λ(n)| ≤ 1` for every `n`.
*Proof.*  `λ(n) = ±1`.  ∎
*Status:* THEOREM.  *Source:* rh46 (`liouville_sq`, `liouville_abs_le_one`).

**Lemma 2.3 (the divisor identity).**  `Σ_{d | n} λ(d)` equals `1` if `n` is a perfect
square, and `0` otherwise.  Hence the Dirichlet series of `λ` is
```
Σ_{n≥1} λ(n) n^{−s} = ζ(2s)/ζ(s)        (σ > 1) .
```
*Verified numerically:* `Σ_{n≤2·10⁵} λ(n)n^{−2} = 0.657973629903` against
`ζ(4)/ζ(2) = 0.657973626739` (tail-consistent).

*Proof.*  Complete multiplicativity gives the local factors
`Σ_{k≥0} λ(p^k)p^{−ks} = Σ_k (−1)^k p^{−ks} = (1 + p^{−s})^{−1}`; multiplying over `p`
gives `Π_p(1+p^{−s})^{−1} = Π_p(1−p^{−s})/(1−p^{−2s}) = ζ(2s)/ζ(s)`.  ∎
*Status:* THEOREM.  *Source:* classical; used in rh46 §5 and [`03`](03-parity-problem.md).

**Lemma 2.4 (the one-point average — a THEOREM).**  `Σ_{n≤x} λ(n) = o(x)`.  Indeed
`λ = 1_squares ∗ μ` (i.e. `Σ_{n≥1}λ(n)n^{−s} = ζ(2s)/ζ(s)`), so
`Σ_{n≤x}λ(n) = Σ_{d≤√x} M(x/d²)`, and `M(y) = Σ_{n≤y}μ(n) = o(y)` — which is
**equivalent to PNT** — gives `o(x)·Σ_d d^{−2} = o(x)`.
*Status:* THEOREM (unconditional; the `k = 1` Chowla case is equivalent to PNT).
*Recorded correction:* rh46 §1.3 and rh47 §5.1 mislabel this **OPEN**; it is not.
*Citation:* Tao, [arXiv:1605.04628](https://arxiv.org/abs/1605.04628).
*Verified here:* `Σ_{d≤√x}M(x/d²) = Σ_{n≤x}λ(n)` exactly for `x = 100, 1000`, and
`L(x)/x = −0.01400, −0.00940, −0.00288, −0.00053` at `x = 10³…10⁶`.

> **Warning (rh46/rh47 gotcha).**  `λ(6) = +1` because `Ω(6) = 2` is even; and the
> convention `λ(0) = 1` breaks many natural-looking identities.  The rounds' Lean
> files record both traps explicitly.

## 3. Prerequisites: what the programme uses from analysis

**(P1) Euler product and analytic continuation of `ζ`.**  `ζ(s) = Π_p (1−p^{−s})^{−1}`
for `σ > 1`, with a simple pole at `s = 1` of residue `1`, and the functional equation
`π^{−s/2}Γ(s/2)ζ(s) = π^{−(1−s)/2}Γ((1−s)/2)ζ(1−s)`.
*Status:* THEOREM (classical).

**(P2) The partial-sum asymptotic at `σ = 0` (Euler–Maclaurin).**  For fixed `t`,
```
S_N(it) = N^{1−it}/(1−it) + ζ(it) + O(N^{−1/2}) .
```
*Status:* THEOREM.  *Verified numerically:* rh43 §4 and rh044 §1; the record here
re-measures `|S_N − N^{1−s}/(1−s) − ζ|·√N = 0.499996, 0.500000` at `N = 10⁴, 10⁵`
(`t = 14.1347`), confirming the `1/2` constant of the first correction term.

**(P3) The Dirichlet series on the critical line.**  For `σ = 1/2` the series converges
conditionally; the partial sums satisfy `|S_N(1/2+it) − ζ(1/2+it)| = √N/|s−1| + O(1)`,
so a sharp truncation *always* has error `Θ(√N)` at the zero.  *Verified:* rh43 §7.6,
with the constant `1/√(1/4+t²)` (an earlier draft's `1/√(2t)` is REFUTED, rh044 §0 R1).

**(P4) Abel/partial summation.**  If `D(s) = Σ a_n n^{−s}` converges for `σ > β` then
`Σ_{n≤x} a_n = O(x^{β+ε})`.  *Status:* THEOREM (one-directional only; the converse
fails — that failure is exactly why the correlation's Euler-product route is dead,
rh46 §5).

**(P5) The explicit formula (Riemann–von Mangoldt).**  For a suitable test pair
`(g, φ)` with `φ(t) = ∫ g(u)e^{itu}du` and `Φ(s) = φ((s−1/2)/i)`,
```
Σ_ρ Φ(ρ) = Φ(1) + Φ(0) − Σ_{n≥2} (Λ(n)/√n)[g(log n)+g(−log n)] + (1/2π)∫_ℝ φ(t)Ψ(t)dt ,
Ψ(t) = −log π + Re ψ(1/4 + it/2) .
```
*Status:* THEOREM (classical).  **The archimedean term is not optional** — an earlier
draft omitted it and was REFUTED (rh45 §3.6, with the decomposition of the error).

**(P6) Counting formula.**  `N(T) = θ(T)/π + 1 + S(T)` exactly, and
`N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + O(1/T)` asymptotically, with
`S(T) = (1/π)arg ζ(1/2+iT)`.  *Status:* THEOREM.  *Verified:* rh45 §4 (residuals
`3.3·10⁻⁴ … 2.2·10⁻⁵` for `T = 20 … 300`).

## 4. The greedy harmonic sine: a one-paragraph preliminary

For `x ∈ (0,1)` let `r_0 = x` and, at step `n ≥ 0`, take `1/(n+2)` if `r_n ≥ 1/(n+2)`
and subtract it (otherwise skip, permanently).  The set of taken indices is the
**support** `A(x)`; the resulting 0/1 word is the **greedy word**.  Its signed
variant — the *Tau alphabet* `α_n = (−1)^n/(n+2)^p` with a sign-matched, no-overshoot
rule — is the object of [`02`](02-greedy-harmonic-sine.md).  The programme's central
structural fact (rh47) is that `A(x)` is **Sylvester-sparse**:
`m_{i+1} ≥ m_i(m_i−1)+1`, so supports with many elements have astronomically large
largest index, and the support density is `≈ 3.9·10⁻⁵`.

## 5. What the preliminaries do *not* give

* No relation between `A(x)` and `Ω(n)` — the greedy rule reads only `x`, and its
  indices are additive in the sense of `log`; there is no arithmetic input
  ([`03`](03-parity-problem.md) §5, rh47 §2).
* No route from the correlation `Σλ(n)λ(n+2)` to `ζ` — the correlation is not
  multiplicative (rh46, P4's converse fails).
* No proof of `o(x)` at two points — that is open ([`03`](03-parity-problem.md) §4).

*Status legend — THEOREM: proved; NUMERICAL: finite computation only; HEURISTIC:
unproved but plausible; OPEN: no proof known; REFUTED: with a witness.*
