# Round 114 — how loose is the large sieve?

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

After round 113, the only untried mechanism was the second-moment/large-sieve route: bound the class counts
`N(a,d) = #{twin f : f ≡ a mod d}` by their second moment, then extract the asymptotic. The large-sieve
inequality in `𝔽_q[x]` reads

```
L(κ) := Σ_{deg d ≤ κ} Σ_{a mod d} N(a,d)²  ≤  (q^n + q^{2κ}) · T(n) =: R(κ) .
```

If `L/R` is close to `1`, the inequality is sharp and would deliver the level of distribution; if it is small,
the bound is lossy and the method loses more than the main term's `1/n²`.

## 2. Wild guess 55

> **Wild guess 55.** At the classical level `κ = n/2` the large sieve is sharp enough — `L/R` comparable to
> `1` — to pin the twin asymptotic at fixed `q`.

**Why guess it.** The large sieve is the standard tool for level-of-distribution statements, and in the
function-field model its constants are clean.

**Falsification test.** Enumerate the twin polynomials directly (there are only `T(n)` of them), reduce each
modulo every `d` of degree `≤ κ`, and compute `L(κ)` and `R(κ)`.

## 3. Results

`q = 3`, all `κ ≤ n/2`:

| `n` | `κ = 1` | `κ = 2` | `κ = 3` | `κ = 4` | `κ = 5` |
|---|---|---|---|---|---|
| 5 | 0.095 | 0.161 | | | |
| 6 | 0.033 | 0.067 | 0.069 | | |
| 7 | 0.027 | 0.058 | 0.077 | | |
| 8 | 0.022 | 0.046 | 0.069 | 0.056 | |
| 9 | 0.021 | 0.045 | 0.069 | 0.076 | |
| 10 | 0.015 | 0.031 | 0.049 | 0.062 | 0.045 |

At the classical level `κ = n/2` the ratio is `0.16, 0.069, 0.077, 0.056, 0.076, 0.045` for `n = 5..10`, and
it decays roughly like `1/n`.

Why: the `d = 1` term alone contributes `T²`, and the level sum multiplies it by about `n/2`, so
`L ≈ T²·n/2`, while `R ≈ 2q^n·T`. Hence

```
L/R ≈ T·n/(4q^n) ≈ S(q)/(4n)  →  0 .
```

**Wild guess 55 is refuted.** The inequality is loose by a factor of order `n`, so a bound extracted from it
is of size `≍ q^n/n` — bigger than the main term `q^n/n²` by a factor `n`. This is the concrete form of the
statement in the 018 notes that the large-sieve error `O(q^{n−1/2})` is useless when `n → ∞` at fixed `q`.

### What this rules out

The large sieve is not a crossing mechanism in this model. The function-field twin asymptotic is *true*, so
something stronger than the large sieve is doing the work: two-dimensional equidistribution (Chebotarev for
the pair `(f, f+2)`), which uses the Frobenius, not just orthogonality over residue classes.

## 4. Lean

Two normalisations behind the inequality, now checked (`lean/LargeSieve.lean`):

```lean
theorem LargeSieve.class_second_moment {ι} [Fintype ι] (N : ι → ℝ) :
    (∑ a, N a) ^ 2 ≤ (Fintype.card ι : ℝ) * ∑ a, N a ^ 2
theorem LargeSieve.geom_support (q : ℤ) (k : ℕ) :
    (Finset.range (k + 1)).sum (fun i => q ^ i) * (q - 1) = q ^ (k + 1) - 1
```

The first is the Cauchy–Schwarz step that makes class counts comparable to their mean; the second is the size
of the level-`κ` support.

## 5. State

* Wild guess 55 refuted: the large sieve is loose by a factor `≍ n` on the twin indicator.
* With rounds 110–114 the four mechanisms are now all measured:
  * `Λ²` square weight: capped at `4×` the truth;
  * bilinear pair weight: indefinite, no bound;
  * windows: no systematic cancellation;
  * large sieve: slack of order `n`.
* What remains is the mechanism that actually proves the function-field asymptotic: 2D equidistribution.

## 6. Next round (115)

Two options, both honest: (a) attempt to formulate the 2D equidistribution input explicitly and measure its
error, or (b) begin the synthesis — the four measurements above already constitute a complete account of why
the barrier is where it is in this model. Round 115 will do (a) in the smallest case where it is meaningful,
and if the measurement is vacuous (as it may be, since the CRT is exact), the round becomes the synthesis.
