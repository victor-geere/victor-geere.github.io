# W2/W3 route — a rigorous enclosure of Ω for the O4 certificate

**Status:** route note, no theorem claimed. This file records the analysis done
while completing **W1** ([`lean/Transfer.lean`](lean/Transfer.lean)) and the
assembly skeleton ([`lean/GaussianGram.lean`](lean/GaussianGram.lean)) of
[`../angular-partition-method/HANDOFF-O4.md`](../angular-partition-method/HANDOFF-O4.md).
It supersedes the Binet-only plan of [`WEIL-GRAM.md`](WEIL-GRAM.md) §3.1–3.2 as
the *preferred* route, and it records the two remaining blockers.

Everything numerical below is a checked `mpmath` computation at 30 digits. It
is **not** a proof.

---

## 1. What the certificate needs, exactly

O4 needs

```lean
theorem gaussianGram4_posDef : (gaussianGram4 (1/20)).PosDef
```

and `lean/GaussianGram.lean` reduces this, unconditionally, to a single
entrywise enclosure:

```lean
∀ i j, |gaussianGram4 (1/20) i j − gramCentre4 i j| ≤ ε,   4 ε < 0.0227
```

i.e. **every entry of the exact Gram matrix within `ε < 0.005675`  of the
rational centre**. Each entry is `(W(c) + W(−c))/2` with `W = pole + density +
prime` and `c ∈ {0, ±0.2, ±0.4, ±0.6}`.

The three pieces, numerically (30 digits):

| `c` | pole | density | prime |
|---:|---:|---:|---:|
| 0 | 0.031435567627 | 0.011700390768 | −1.2e−22 |
| 0.2 | 0.031592876491 | −0.048082135113 | −2.4e−12 |
| 0.4 | 0.032066377481 | −0.024035199425 | −1.6e−5 |
| 0.6 | 0.032860809554 | −0.016840432117 | −3.65e−2 |

Two facts drive the whole budget.

* The **pole** and **prime** terms are elementary (π, exp, cosh, log 2, √·) and
  can be enclosed with `norm_num` plus `Real.pi_gt_d20`/`pi_lt_d20`,
  `Real.log_two_gt_d9`/`log_two_lt_d9` and Taylor bounds for `exp`. The prime
  sum is carried by `n = 2` alone: at `c = 0.6` the `n = 3` term is below
  `2e−12`, and the tail is bounded as in C10.
* The **density** term is the whole difficulty. It is `O(0.05)`, so the margin
  `0.005675` is about 10 % of it, but the individual contributions do not
  cancel crudely: a pointwise bound `|Ω| ≤ B` produces an entry error
  `0.0025 · B · 35.45`, which is `0.53` for `B = 6` — two orders of magnitude
  too large. The density term must be **computed**, not merely bounded.

## 2. Binet versus the Euler limit

`WEIL-GRAM.md` §3.1–3.2 proposes the differentiated Binet formula

```
Re ψ(z) = log|z| − Re(1/(2z)) − 2 ∫₀^∞ u(u²+Re z²)/((u²+Re z²)²+(Im z²)²) /(e^{2πu}−1) du.
```

That is correct, and it gives the decomposition `Ω = L − R` with `0 ≤ R`, where
`L` is explicit. But formalising it needs **Binet's formula for `log Γ`**, which
Mathlib does not have; the cheapest proof differentiates the Euler integral,
which requires differentiating under the integral sign against a parameter in
the *exponent* and then controlling an oscillatory integral uniformly. This is
a large stand-alone project.

There is a cheaper route, and it is the one to use.

## 3. The Euler-limit route for `Ω` (recommended)

Mathlib has Euler's limit formula, `Complex.GammaSeq_tendsto_Gamma`:

```
GammaSeq s n = n^s · n! / ∏_{j=0}^{n} (s + j)  →  Γ(s)     (n → ∞),
```

for every `s : ℂ`. Its log-derivative is elementary:

```
logDeriv (GammaSeq · n) s = log n − Σ_{k=0}^{n} 1/(s+k).
```

Two consequences, both classical:

1. (Finiteness.) For `Re s > 0`,
   `ψ(s) = lim_{n→∞} [ log n − Σ_{k=0}^{n} 1/(s+k) ]`.
2. (Real part, `s = 1/4 + it/2`.) With `a_k = k + 1/4`,

```
Re ψ(1/4 + it/2) = lim_n [ log n − Σ_{k=0}^{n} a_k/(a_k² + t²/4) ].
```

Split off the `t`-independent constant using `ψ(1/4) = −γ − 3 log 2 − π/2`
(which follows from `digamma_one_half` together with the reflection and
duplication identities):

```
Ω(t) = ψ(1/4) − log π + Σ_{k≥0} u_k(t),
u_k(t) = 1/a_k − a_k/(a_k² + t²/4) = (t²/4) / (a_k (a_k² + t²/4)) ≥ 0.
``` This was checked at 30 digits
against `mp.digamma` at `t = 0.05, 1, 3, 10`; the truncation error matches the
tail bound below.

### 3.1 Why this is the right form

* **No integrals.** `u_k` is a rational function of `t²`; the only
  transcendental inputs are the single constant `Ω₀ := ψ(1/4) − log π =
  −5.372183…` and `log π`. Both are rational-interval constants.
* **The tail is `t²`-small, not constant.** Since `a_k ≥ 1/4`,

```
Σ_{k>N} u_k(t) ≤ (t²/4) ∫_N^∞ dx/x³ = t²/(8N²).
```

  The `t²` factor is what makes this usable: the induced entry error is

```
σ² ∫_ℝ e^{−σ²t²} · t²/(8N²) dt = √π/(16 σ N²) = 2.216/N²   (σ = 1/20),
```

  i.e. `2.2·10^{−4}` at `N = 100`, `5.5·10^{−5}` at `N = 200`. By contrast the
  Euler–Maclaurin-style constant error (if the `t`-independent part were left
  as the limit) is `O(1/N)` *uniformly in `t`*, which is why the split at
  `ψ(1/4)` matters. This is the single most important observation in this note.
* **A bonus identity.** `∫₀^∞ u(x,t) dx = ½ log(1 + 4t²)` exactly (checked to
  12 digits at `t = 0.3, 1, 5`). This is the `L` of Binet in disguise, and it
  gives an independent cross-check of any implementation.

### 3.2 The constants, all exact

```
ψ(1/4) = −γ − 3 log 2 − π/2 = −4.2274535333762654081…
Ω₀ = ψ(1/4) − log π       = −5.372183419…
```

`γ` is `Real.eulerMascheroniConstant`; Mathlib also has `digamma_one`,
`digamma_one_half` and the reflection/duplication formulae for `Γ`, from which
the `ψ(1/4)` value follows. (Equivalently, quote the closed form and verify it
against `digamma_one_half` by duplication.)

## 4. The remaining blockers

### B1 — differentiating the Euler limit

The limit formula for `ψ` is *not* in Mathlib. The clean proof needs one of:

* **locally uniform convergence** of `GammaSeq · → Γ` on compacts avoiding the
  poles, then `hasDerivAt_of_tendstoLocallyUniformlyOn`
  (`Mathlib/Analysis/Calculus/UniformLimitsDeriv.lean:490`, available). Mathlib
  only proves the pointwise `GammaSeq_tendsto_Gamma`; the locally uniform
  version has to be extracted from the `approx_Gamma_integral` estimates.
* **or** an integration argument that avoids differentiating the limit:
  `(log Γ_n)' = L_n(s) := log n − Σ 1/(s+k)` is explicit, `L_n` converges
  locally uniformly (immediate from `|L_{n+1} − L_n| = O(1/n²)`), and
  `Γ_n(s) = Γ_n(s₀) exp(∫_{s₀}^{s} L_n)` with `Γ_n(s₀) → Γ(s₀)`. Passing to the
  limit gives `Γ(s) = Γ(s₀) exp(∫ L)`, hence `ψ = L`. This second route avoids
  `UniformLimitsDeriv` and is probably the shorter formalisation.

Either way, this is the only genuinely *analytic* gap left in W2. Once the
limit formula is Lean-proved, the remainder of W2 is the closed-form constants
and the tail bound §3.1, both elementary.

### B2 — rigorous quadrature of a 100-term rational integrand

With `N ≈ 100`, the density term is

```
D(c) = σ² ∫_ℝ e^{−σ²t²} cos(ct) [ Ω₀ + Σ_{k=0}^{N} u_k(t) ] dt + O(2.2·10^{−4}).
```

The integrand is explicit and smooth, but it carries ~100 rational terms per
evaluation, and the `t`-range that matters is `|t| ≲ 60` (the Gaussian tail
beyond `t = 60` is `e^{−9}·2.5·…`, contributing `4·10^{−6}` to the entry). A
rigorous midpoint rule with a second-derivative bound needs only about
`n ≈ 300–1000` panels for a `10^{−3}` absolute error on `D` — the accuracy
requirement is mild (`0.005675` on an entry, and the density is multiplied by
`σ² = 0.0025`).

The blocker is therefore *not* accuracy, it is **engineering**: Lean has no
interval-arithmetic library for `exp`/`cos` with rational endpoints. The options
are:

1. **Rational Taylor models.** Bound `exp` and `cos` on each panel by rational
   Taylor polynomials with explicit Lagrange remainders (Mathlib has
   `Real.exp_bound` and Taylor's theorem with Lagrange remainder), and do the
   panel sums with `norm_num` over scaled integers. This is the honest route,
   but it is a small verified-numerics library, not a 200-line lemma.
2. **Shrink `N` and the panel count.** If B1 is proved, note that the tail
   bound already costs only `1.1·10^{−4}` at `N = 100`; nothing forces
   `N = 100` for the *quadrature* if the `k`-sum is integrated term by term.
   Interchanging sum and integral gives
   `D(c) = σ²Ω₀·A(c) + σ² Σ_k I_k(c)` with
   `A(c) = (√π/σ) e^{−c²/(4σ²)}` exact and
   `I_k(c) = ∫ e^{−σ²t²} cos(ct) u_k(t) dt`, a standard erfc-type integral.
   No closed form exists, so this does not remove the numerics; it only
   redistributes them.

A pragmatic intermediate target is the **`3×3` rung** of `WEIL-GRAM.md` §3
(`σ = 0.05`, centres `0, ±0.15`, `λ_min = 8.9·10^{−3}`) or the `σ = 0.03`
five-point rung, where the same `ε`-budget is met with a coarser quadrature.

## 5. What is already Lean-checked

* [`lean/Transfer.lean`](lean/Transfer.lean) — `posDef_of_entry_bound` (the
  corrected `n·ε` Loewner transfer, which is the audit item of
  `HANDOFF-O4.md` §4) and the exact rational certificate
  `gramCentre4_sub_posDef : (gramCentre4 − (227/10000)·I).PosDef`, with the
  exact `L D Lᵀ` factorisation.
* [`lean/GaussianGram.lean`](lean/GaussianGram.lean) — the exact definitions of
  `Ω`, the three terms, `gaussianGram4`, symmetry, and
  `gaussianGram4_posDef_of_enclosure`: the conditional assembly which turns the
  W2/W3 entrywise bound into `(gaussianGram4 σ).PosDef`.

The remaining obligations are exactly **B1** and **B2** above; nothing else in
O4 is open.

---

[Back to the programme](README.md) · [Handoff](../angular-partition-method/HANDOFF-O4.md) ·
[Weil–Gram certificate](WEIL-GRAM.md) · [Lean index](../index-lean.md)
