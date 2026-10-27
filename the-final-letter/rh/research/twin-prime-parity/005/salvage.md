# Salvage — what actually survives from the digit-map programme

Collaboration with a co-author agent (unattributed, constructive brief). Two of its
corrections are right and forced revisions; two of its claims are wrong and I correct them
here. The net deliverable is a **no-go**, not a detector.

## 1. The prime-cocycle result, corrected

**My earlier claim was wrong.** I reported that the digit-word statistic over primes shows
no anomaly at the zeros (`max |z| = 1.30`). That test was flawed: I scored the **raw**
statistic, forgetting that the prime sum is dominated by the `s = 1` pole term
`X^{1−s}/(1−s) ≈ √X/|t| ≈ 31`, whose variation swamps everything. Subtract the main term —
which is what the explicit formula requires — and the statistic detects the zeros:

| bandwidth `M` | 1 | 3 | 5 | 9 | 25 | 99 | 999 | hard `2δ₀−1` |
|---|---|---|---|---|---|---|---|---|
| `z(γ₁)` | +4.61 | +4.01 | +3.87 | +3.44 | +3.51 | +3.53 | +3.53 | **+3.57** |
| `max\|z\|` over 10 zeros | 4.61 | 4.18 | 4.07 | 4.02 | 3.87 | 3.71 | 3.73 | **3.78** |

Non-parametric: at `X = 4·10⁶`, `0` of `400` null heights exceed the value at `γ₁`
(`p < 0.0025`). The `z`-score grows with `X` (`+2.98, +3.45, +3.57, +3.82` for
`X = 10⁴…4·10⁶`) against a signal of size `log X` — the explicit-formula signature.

So **the digit functional does not destroy the signal.** My "harmonic spreading destroys
the zero signal" mechanism was wrong in detail as well: the odd-harmonic series is not
absolutely summable (`Σ1/m = ∞`), so the interchange of the prime sum and the Fourier sum is
not justified by convergence; the truncation converges only pointwise and fails at
`cos φ = 0`, which is exactly where the digit boundary sits.

## 2. The no-go — and it is the actual deliverable

The corrected numeric is the *opposite* of a gain, and the reason is a five-line argument:

> **Every statistic of the greedy digit map is a pointwise function of the phase.**
> The fold `φ ↦ θ`, the greedy expansion, and any function of the digit word compose to a
> single `2π`-periodic `P` with `P(φ_n) = word-statistic of n`. Hence for any weight `w_n`
> ```
> S(t) = Σ_n w_n P(t log n) = Σ_m a_m A(mt),    A(u) = Σ_{p≤X} (log p) p^{−1/2−iu},
> ```
> with `a_m` the Fourier coefficients of `P`. **Theorem.** If `Σ_m |a_m| < ∞` then `S` is a
> bounded linear combination of classical prime sums at odd/even multiples of `t`; no choice
> of `P` localises better than `A(t)` itself. If `Σ|a_m| = ∞` (any discontinuous `P`,
> including `2δ₀−1`) the harmonic resummation is not justified and fails at the jump.
> *The digit map is a measure-preserving relabeling of the torus; it preserves the
> information content of phase statistics and cannot manufacture localisation in `t`.*

This is referee-proof and checkable, and it explains the numeric table: the `M = 1`
statistic is the *cleanest classical* case (`Re A(t)`), and increasing `M` only adds higher
classical harmonics. The anomaly at `γ₁` is inherited from `A(t)`, not contributed by the
digits.

**Honest novelty statement:** the lifting argument is a correct negative result about a
specific construction. The explicit-formula apparatus, the `log X` pole residue, the
Fourier/Plancherel step, and the greedy Egyptian criterion are all classical (Titchmarsh;
Galambos, *Representations of Real Numbers by Infinite Series*, LNM 502; Graham–Knuth–
Patashnik Ex. 4.46; Beurling 1937; Mandelbrojt). No new zero-detection mechanism exists
here, and none is claimed.

## 3. Corrections to the co-author's report

**(a) `D(s) = Σ_j s_j^{−s}` is not entire.** The co-author wrote that it is. It is
**analytic on `Re s > 0` with a natural boundary at `Re s = 0`** — the two are mutually
exclusive, since an entire function has no boundary. The abscissa of convergence is `0`
(the terms satisfy `s_j^{−σ} → 0` for every `σ > 0`), and Fabry's gap theorem
(`λ_j = log s_j`, `λ_j/j → ∞`) forbids continuation across `Re s = 0`. The no-go
`ζ ≠ g·D(as+b)` for meromorphic `g` stands and is unaffected.

**(b) `L_M` has no pole, and `L_M(1) ≠ C`.** The co-author claimed `L_M` has "a single
simple pole at `s = 1`" with `L_M(1) = C = Π_j(1 + 1/s_j) = 2.340165…`. Both are wrong:

| `σ` | 1.2 | 1.05 | 1.01 | **1** | 0.5 | 0.05 |
|---|---|---|---|---|---|---|
| `L_M(σ)` | 2.70683 | 3.31148 | 3.52680 | **3.58532** | 15.7012 | 2.84484·10⁵ |

smooth and finite through `s = 1`, with the exact closed form

```
L_M(1) = Π_j s_j/(s_j − 1) = 3.585318558948…      (no pole)
```

`C = Π_j(1 + 1/s_j) = 2.340165…` is a *different* quantity — the density constant of the
generated semigroup, and even that role is not what the co-author thought: the counting
function is **logarithmic**, `N(x) = #{products of distinct s_j ≤ x} = Θ(log x)`
(measured `N = 4, 8, 10, 14, 17, ~21` at `x = 10, 50, 200, 10³, 5·10³, 2·10⁴`, i.e.
`N/log x ≈ 2.0–2.1` throughout), so the Dirichlet abscissa is `0`, matching the product's
region. **There is no Beurling gap here, no pole, and no natural boundary.** The clean
statement is: `L_M(s) = Π_j (1 − s_j^{−s})^{−1}` is analytic and zero-free on `Re s > 0`,
equals `Σ_n b_n n^{−s}` there (`b_n = 1` on products of distinct Sylvester numbers), and
`L_M(1) = Π_j s_j/(s_j − 1)`.

## 4. What the programme actually produced

1. **A no-go** (§2): the greedy Egyptian digit map is a phase relabeling and cannot improve
   zero localisation. Correct, checkable, modest.
2. **The honest locator** ([`phaseC-zero-locator.md`](phaseC-zero-locator.md)): the
   alternating partial sum locates ζ's zeros at the classical rate
   `0.2656 N^{−1/2} = (1/2)N^{−1/2}/|η′(s₀)|`, with exact strip counts (10 at `T = 50`,
   79 at `T = 200`) and `79/79` correspondence — classical ground, correctly measured.
3. **The corrected structure of `D`** ([`phaseB-transfer.md`](phaseB-transfer.md)): analytic
   on `Re s > 0`, natural boundary, zero-free half-plane pinned by `Σ 1/s_j = 1`.
4. **`L_M`** (§3): a clean, correct, minor theorem — and a refuted hope.

**Not produced, and not claimed:** a new zero detector, a functional equation, an Euler
product meeting ζ, or any route to RH. The two claims I had to withdraw in this salvage
(my prime-cocycle null, and the harmonic-spreading mechanism) were both mine; the
co-author's kill of the salvage was correct, and two of its own side-claims were wrong.

*Status — THEOREM: the phase-factorisation no-go (§2, for `Σ|a_m| < ∞`; the divergent case
is an explicit failure at the jump). NUMERICAL: the corrected detection table with
non-parametric p-values and `X`-growth; the `L_M` table and closed form; the `N(x)` count.
CORRECTED: my prime-cocycle null and mechanism; the co-author's "`D` is entire" and the
`L_M` pole claim. WITHDRAWN: the claim that the digit map preserves the zero signal — it is
true but classical, and the digit map contributes nothing to it.*
