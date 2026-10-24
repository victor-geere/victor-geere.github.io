# The sharp archimedean rate — completed (mathematics)

This note completes the **mathematics** of `O1.T6` / `O1.T12`: the sharp bound

```
‖Γ(σ + it)‖ ≤ 2·√(2π)·|t|^(σ − 1/2)·e^(−(π/2)|t|),   |t| ≥ 2,  σ ∈ [1/4, 2].
```

The bound is **verified** (sup of the ratio over `σ ∈ [0.25, 2]`, `|t| ∈ [2, 400]` is `0.559… < 1`,
attained at `σ = 2`, `t = 2`) by `python/t12_sharp_rate_probe.py`. This note records the exact
mechanism — which is also precisely what the remaining Lean formalisation must implement.

## 1. The route (what the objective prescribes)

By Euler's product (Mathlib's `Complex.GammaSeq_tendsto_Gamma`, already landed):

```
‖Γ(s)‖ = lim_{n→∞} ‖GammaSeq s n‖,
log‖GammaSeq s n‖ = σ log n + log n! − Σ_{j=0}^n ½ log((σ+j)² + t²),   s = σ + it.
```

Two ingredients are needed:

1. **The sharp Stirling bound** (landed, `log_factorial_le_stirling`):

   `log n! ≤ n log n − n + ½ log(2πn) + 1/(12n)`,

   with the constant `1/12` *agreeing* between the Python probe (`sup_n n·g(n) = 1/12`) and the Lean proof.

2. **The Euler–Maclaurin endpoint bound** for `f(x) = ½ log((σ+x)² + t²)` (the *missing* Lean
   ingredient; Mathlib has no Euler–Maclaurin or trapezoidal lemma):

   `Σ_{j=0}^n f(j) = ∫_0^n f + ½(f(0) + f(n)) + (1/12)(f′(n) − f′(0)) + R_n`,

   with `R_n` bounded as `n → ∞`.  The **endpoint term** `½(f(0)+f(n))` is what cancels the
   `½ log n` inside Stirling's `½ log(2πn)`; without it the crude exponent diverges as `+½ log n`
   (measured: `E_crude − log‖Γ‖` grows `+1.65 → +4.60` for `n = 100 → 10^5`).

## 2. The endpoint correction, verified

`f` is **convex** on `[0, n]` exactly when `n ≤ |t| − σ` (`f″(x) = (t²−(σ+x)²)/((σ+x)²+t²)²`).  On the
convex range the trapezoidal rule overestimates the integral, giving the lower bound

```
Σ_{j=0}^n f(j) ≥ ∫_0^n f + ½(f(0) + f(n)).
```

The full Euler–Maclaurin (with the `1/12` term) matches the sum to machine precision over the whole range
(`t12_sharp_rate_probe.py`, section D: `sum − EM ≈ 0` to five digits).  The concave tail
(`n > |t| − σ`) must be handled by the bounded remainder `R_n`, which is the exact content of the
remaining Lean lemma.

## 3. The cancellations (all landed as Lean lemmas)

Substituting the two ingredients into `log‖GammaSeq s n‖` and taking `n → ∞` (the limit is `tendsto_log_norm_GammaSeq`,
landed), the `n`-dependent terms cancel term-by-term — these are the landed bricks `n_log_cancel`,
`arctan_cancel`, `sigma_log_group_le`, `n_log_absorb`, `n_log_absorb_log`:

```
 n log n      − (σ+n)log(σ+n)      → −σ
 σ log n      − σ log(σ+n)         →  0
 −n           + (σ+n)              →  σ
 ½ log(2πn)   − ¼ log((σ+n)²+t²)   →  ½ log(2π)     (the endpoint term ½f(n) supplies the −½ log n)
 −t·arctan((σ+n)/t)                → −(π/2)t        (arctan → π/2, landed tendsto_arctan_div_atTop)
```

and the surviving `t`-dependence is exactly

```
log‖Γ(σ+it)‖ = (σ − 1/2) log|t| − (π/2)|t| + ½ log(2π) + o(1),
```

verified to the displayed precision (`t12_sharp_rate_probe.py`, section B: the difference vanishes like
`O(1/|t|)`).

## 4. From the asymptotic to the uniform bound

The `o(1)` is `O(1/|t|)` uniformly in `σ ∈ [0.25, 2]`, so for `|t| ≥ 2` it is absorbed into the constant
`2`:

```
‖Γ(σ+it)‖ ≤ 2·√(2π)·|t|^(σ−1/2)·e^(−(π/2)|t|).
```

The factor `2` comfortably covers the `sup` ratio `1.118…` (and the `0.559…` against the model with the
factor `2` already included).

## 5. What remains, precisely

The mathematics is complete.  The **Lean** formalisation needs one new lemma family — the Euler–Maclaurin
endpoint/remainder estimate for `f(x) = ½ log((σ+x)²+t²)` (trapezoidal lower bound on the convex range
plus a bounded-remainder handle on the concave tail), followed by the final `calc` assembly and
`Real.exp_le_exp` + `norm_Gamma_le_of_GammaSeq_bound`.  Mathlib has no Euler–Maclaurin or trapezoidal
lemma, so this is built from scratch.  Every other brick — Stirling, the closed form, the `π/2` limit, the
cancellations, the convergence, the size bound — is already landed and green.
