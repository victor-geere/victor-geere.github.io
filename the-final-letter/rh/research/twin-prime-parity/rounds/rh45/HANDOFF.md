# rh45 — the explicit formula: locating zeta zeros from a smoothed count

**The gap this round attacks** (from [`../rh43/truths.md`](../rh43/truths.md) §7.6 and
[`../rh044/truths.md`](../rh044/truths.md)): the finite-`N` balance condition at
`Re(S) = 1/2` cannot see a zero, because the sharp partial sum differs from `ζ` by
`√N/|s−1|` and no smoothing removes that (`|S_N^φ − ζ|/√N → |M_φ(s)|`).  rh044
concluded the missing step is the **functional equation**.  rh45 does what that
conclusion points at — it uses the **explicit formula** explicitly, rather than
trying to smooth the partial sum.

*(The previous round's smoothing detour was not what was asked.  This round uses the
explicit function.)*

---

## 1. The instrument

Riemann–von Mangoldt.  For a suitable test function, the zeros of `ζ` are detected
through the elementary per-zero identity

```
N(T) = #{ρ = 1/2 + iγ : 0 < γ ≤ T}  =  (T/2π) log(T/2πe) + 7/8 + S(T) + O(1/T),
S(T) = (1/π) arg ζ(1/2 + iT)     (continuous branch),
```

and, in its exact form, the **explicit formula**

```
sum_ρ  F(1/2 + iγ)  =  F(1/2 + i/2) + F(1/2 − i/2)  −  Σ_{n≥2} (Λ(n)/√n) [g(log n) + g(−log n)] ,
```

where `g` is the inverse Fourier/Laplace transform of `F` (so that the prime side is
weighted by `Λ`), the sum is over the nontrivial zeros, and the pole terms come from
`s = 1` (and `s = 0` under `s ↔ 1−s`).  The classical quantitative consequence that
this round uses is the **smoothed zero count**:

```
Σ_γ  h(γ − T)  ≈  (1/2π) ∫ h(u) [ log(T/2π) + ψ(1/4 + i(T+u)/2) + ψ(1/4 − i(T+u)/2) ] du ,
```

whose right-hand side is smooth and whose left-hand side is a smoothed `N`.  In
particular the count on any window is computable **without knowing the zeros in
advance**, which is exactly what rh43/rh044 lacked.

## 2. Targets

* **T1 (the formula, exact form).**  Fix a test function `F` (Gaussian
  `F(t) = e^{−t²/2}` and the Cauchy kernel `F(t) = 1/(1/4+t²)`), compute both sides of
  the explicit formula independently, and verify the identity to a stated number of
  digits.  Supply the correct normalisation constants (the reconnaissance below shows
  the naive constant is wrong) and the correct treatment of the trivial zeros.
* **T2 (locate zeros without prior knowledge).**  Using only the smoothed count
  (no `mp.zetazero`), locate the first `N` zeros to ≥ 20 digits by bracketing the
  smoothed count's increment; compare with the tabulated zeros.  Report the
  agreement and the cost (`O(T log T)` versus the partial-sum route's `O(√N)` wall).
* **T3 (count zeros by the argument principle).**  Independently count the zeros of
  `ζ` with `0 < Im < T` inside the critical strip by numerically integrating
  `ζ'/ζ` on a rectangle, and verify against the Riemann–von Mangoldt main term plus
  `S(T)`.  This is the independent audit of T1/T2.
* **T4 (relation to the finite-`N` split).**  State exactly how the explicit formula
  bypasses the `√N` obstruction of rh43/rh044 (the test function replaces the sharp
  cutoff, and the zero information sits in the *pole* `s = 1`), and what it still does
  not give (nothing about the parity problem: the explicit formula is unconditional
  and knows about primes through `Λ`, but it does not separate `Ω`-parity classes).
* **T5 (Lean, algebraic layer).**  The finite-sum identity behind the formula, the
  symmetry `F(1/2+i/2) + F(1/2−i/2)` for even `F`, the evenness/positivity of the
  Gaussian and Cauchy kernels, the classical zero-count main term stated for the
  counting function, and the per-zero window decomposition.  No `sorry`.

## 3. What the round does *not* claim

* No new explicit formula, no improvement of the Riemann–Siegel formula, no new
  zero-free region, no RH progress.
* No advance on the twin-prime parity problem: the explicit formula is
  unconditional and encodes primes via `Λ`; it does not break the parity symmetry
  that blocks sieve lower bounds — that would need a correlation statement such as
  `Σ_{n≤x} λ(n)λ(n+2) = o(x)`.

## 4. Evidence

| evidence | what it is | expected |
|---|---|---|
| `explicit_formula.py` | T1 + T2: both sides of the formula, the smoothed count, the zero table | exit 0, all checks pass |
| `verify/independent_check.py` | T3: `ζ'/ζ` argument-principle count, `Z`-function bracketing, own constants | exit 0 |
| `lean/Rh45/` | T5: the algebraic layer | `check.sh --all` exit 0, no `sorry` |
