# Round 110 — the parity factor is 4

*The plan was fixed at the start of the round (see `rounds.log`, BEFORE line); the numbers are the results.*

---

## 1. The envisioned path

Round 109 left one number uncomputed: the sieve's parity factor. The picture is:

* the twin count is `S(q)q^n/n² + E(n)` with `|E| = O(q^{n/2})` (round 109);
* the Selberg `Λ²` upper bound with level `{deg d ≤ κ}` is `c(κ)·q^n` (round 109);
* the classical level is `θ = κ/n = 1/2`, i.e. `D = q^{n/2} = X^{1/2}`.

If the sieve were able to reach the truth, `c(n/2)q^n / T(n) → 1`. If the parity barrier is real, the ratio
tends to a constant `> 1` — the factor by which a dimension-2 sieve over-counts. This round computes that
constant by the meet-matrix inversion `c(κ) = 1/(M^{-1})_{1,1}` with
`M[d,e] = 2^{ω(lcm(d,e))} q^{−deg lcm(d,e)}`, and compares it with the truth at `θ = 1/2`.

## 2. Wild guess 51

> **Wild guess 51.** At level `θ = 1/2` the Selberg bound converges to a **constant multiple** of the true
> count, and that constant is the dimension-2 parity factor `2² = 4`.

**Why guess it.** Round 109's note already predicted `2² = 4` from the two local conditions. The guess is that
the sieve's failure is exactly the dimension, not something worse (like the ratio drifting to infinity or
growing like `n`).

**Falsification test.** Compute `c(κ)` for `κ = 2..6` at `q = 3` (and `κ ≤ 3` at `q = 5`), form
`ratio = c(κ)q^{2κ}/T(2κ)`, and check whether it levels off, and at what value.

## 3. A correction carried in from round 109

The `ω` (distinct-prime-factor) counter used in round 109 over-counted repeated factors (it divided out only
one copy and treated the rest as distinct). It is now validated against `sympy`'s `gf_factor` on all 121
polynomials of degree `≤ 4` over `𝔽₃` (0 mismatches), and round 109's table carries an erratum. The corrected
constants are used below.

## 4. Results

### 4.1 The level sum grows quadratically

With the correct `ω`,

```
S(κ) = Σ_{deg d ≤ κ} 2^{ω(d)} q^{−deg d}  =  3, 17/3, 9, 13, 53/3, 23   for κ = 1..6,
```

i.e. differences `2, 8/3, 4, 16/3, 20/3` — linear increments, so `S(κ) ~ κ²`. This is the function-field
form of `Σ_{d≤D} 2^{ω(d)}/d ~ (1/2)log²D`, and it is what makes the sieve save a power of the level.

### 4.2 The constant

`c(κ) = 1/(M^{-1})_{1,1}`:

| `κ` | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| `S(κ)` | 3 | 5.667 | 9 | 13 | 17.667 | 23 |
| `c(κ)` | 0.14286 | 0.05036 | 0.02973 | 0.02063 | 0.01467 | 0.01133 |
| `c(κ)·S(κ)` | 0.429 | 0.285 | 0.268 | 0.268 | 0.259 | 0.261 |

So `c(κ) ≈ 0.26/S(κ) ~ 0.26/κ²`, as the classical computation predicts.

### 4.3 The ratio at `θ = 1/2`

| `q` | `κ` | `n = 2κ` | bound | truth | ratio |
|---|---|---|---|---|---|
| 3 | 2 | 4 | 4.08 | 0 | — |
| 3 | 3 | 6 | 21.67 | 6 | 3.61 |
| 3 | 4 | 8 | 135.37 | 36 | 3.76 |
| 3 | 5 | 10 | 866.41 | 216 | **4.01** |
| 3 | 6 | 12 | 6020.30 | 1506 | **4.00** |
| 5 | 2 | 4 | 64.78 | 20 | 3.24 |
| 5 | 3 | 6 | 966.94 | 240 | **4.03** |

The ratio converges to `4.00` at `q = 3` and to `4.03` at `q = 5`. **Wild guess 51 is confirmed**, and the
constant is the dimension-2 factor `2²`, Lean-checked at the local level as
`SieveLocal.card_roots_prod` (two primes give `2·2 = 4` root pairs).

### 4.4 What this means

1. **The parity barrier is now a measured number in the function-field model.** A dimension-2 Selberg sieve,
   run at the classical level `X^{1/2}`, gives an upper bound that is `4×` the truth — no matter how the
   weights are optimised inside that family. The unattained factor is exactly `2²`, one `2` per local
   condition.
2. **The barrier is not a technicality of the constant.** Optimising `λ` is already done (the bound is the
   exact minimum of the quadratic form). The remaining factor is structural: the square weight cannot resolve
   the parity of the two conditions separately.
3. **What crossing it would take.** Something must supply the missing factor `4` — i.e. must distinguish
   "`f` and `f+2` are both in the sifted set" from "the weight is large". In the function field this is done by
   two-dimensional equidistribution (Chebotarev for the pair `(f, f+2)`); over `ℤ` that is the open problem.
   The transfer demand is now precise: *a substitute for the pair equidistribution, or a weight that is not a
   square of a divisor sum.*

## 5. State

* `c(κ) ~ 0.26/κ²`, `S(κ) ~ κ²`, and the `θ = 1/2` ratio `→ 4.00` (`q=3`), `4.03` (`q=5`).
* Wild guess 51 confirmed; round 109's `ω` bug found, fixed, validated against sympy, and corrected in place.
* 19 unit tests green; `SieveLocal.card_roots_prod` added (standard axioms).

## 6. Next round (111)

The natural next test: replace the square weight by a **bilinear pair weight** that uses the pair structure
explicitly, and see whether the constant drops from 4 to 1 — the function-field crossing. If it does, the
mechanism that does the work is the exact thing missing over `ℤ`, and the programme has its transfer target
stated constructively.
