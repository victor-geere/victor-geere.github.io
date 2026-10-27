# Phase 020 — synthesis

*The consolidated record of rounds 107–117. Written at round 117.*

---

## 1. What phase 020 set out to do

The 018 programme established the parity barrier in `𝔽_q[x]` and reduced its arithmetic to one character sum
(sharpened and partly certified in 019). Phase 020 asked the constructive question:

> can the function-field zeta, read through **degree windows**, supply the bilinear information that the
> linear statistics provably lack — and cross the barrier?

Ten rounds produced eight measurements, six Lean modules, and one clear answer: the barrier is real, it has a
computable size in every standard framework, and the only mechanism that crosses it is two-dimensional
equidistribution — which exists over `𝔽_q[x]` and not over `ℤ`.

---

## 2. The model

* `𝔽_q[x]`, monic polynomials, `I(n)` = qrime count, `T(n)` = twin-qrime count (`T(n;h)` for shift `h`).
* Singular series `S(q) = Π_P (1 − 2/Q)/(1 − 1/Q)²`, `Q = q^{deg P}`.
* Main-term prediction: `T(n) ≈ S(q) q^n / n²`.

---

## 3. Findings

| # | finding | status | round |
|---|---|---|---|
| 1 | `T(n) = S(q)q^n/n² + E(n)`, `|E|/q^{n/2} ∈ [0.008, 0.30]` for `n ≤ 14` | measured (exact counts) | 109, 115 |
| 2 | `T(n)` satisfies no finite linear recurrence — not spectral | measured | 107 |
| 3 | Exact expansion `T(n) = Σ_{d,e|P} μ(d)μ(e)C(d,e)`, boundary `0/1` coefficients | proved + measured | 108 |
| 4 | The `k ≤ n` truncation is a partial product of a **divergent** product | proved (analytically) | 108 |
| 5 | Degree grading makes the Legendre sieve exact at `y = n/2` | proved, formalised | 108, 111 |
| 6 | `Λ²` sieve at level `n/2` is exactly `4×` the truth asymptotically | measured | 110, 112 |
| 7 | Bilinear pair weight is indefinite — no bound exists | proved by eigenvalues | 111 |
| 8 | Degree windows give no `L^{−1/2}` cancellation | measured | 112 |
| 9 | Large sieve slack is of order `n` (bound `≍ q^n/n`) | measured | 114 |
| 10 | `T(n;h)` depends on `h` exactly through the orbit law `⟨(𝔽_q^×)^n, −1⟩` | proved (symmetries) + measured (11/11) | 113, 116 |
| 11 | the parity factor is `2^dim` (`2` for qrimes, `4` for twins); `χ₂(2)` does not enter its magnitude | measured + formalised | 118 |
| 12 | two truncations differ: `k ≤ n` is off by 10–100× and sign-changing, the `deg Q ≤ n/2` product tracks `T` to ~10%; `y²P(y)` has no limit | measured | 119 |
| 13 | polynomial shifts obey the same asymptotic with `S_h = S·Π_{Q|h}(Q−1)/(Q−2)` | measured (`h=x` within 4%) | 121 |
| 14 | the parity factor survives polynomial shifts: `4.05` for `h = x`, and no collapse to `2` for `h` divisible by all linear primes | measured | 122 |

### The four failure modes

| mechanism | failure | factor |
|---|---|---|
| `Λ²` square weight | capped above by the truth | `4 = 2²` |
| bilinear pair weight | indefinite form | undefined |
| degree windows | deterministic, position-dependent error | no decay |
| large sieve | slack in the second moment | `≍ n` |

The sieve's deficiency is dimensional: a `k`-condition problem is bounded `2^k` times above the truth, so a
two-condition problem cannot be reached by a one-condition-strength method. This is the cleanest statement of
the barrier the phase produced, and round 122 sharpened it: the factor depends on the **number of conditions**,
not on the local densities. Absorbing primes into the polynomial shift changes the singular series by a
constant factor and leaves the parity factor at `2^dim`.

They fail for one reason: none resolves the two local conditions **jointly and exactly**. What does is
equidistribution of the pair `(f, f+2)`, which over `𝔽_q[x]` is a theorem (Frobenius / Chebotarev) and over `ℤ`
is the twin prime conjecture.

---

## 4. The transfer demand

The function-field crossing has two ingredients:

1. an **exact growing-support identity** `1_Irr(f) = Σ_{d | gcd(f, P_{n/2})} μ(d)`, exact by the grading lemma;
2. a **canonical truncation**: the support is bounded by degree, and the truncation error is the boundary
   stratum — not an arbitrary cut.

Over `ℤ`:

1. the analogous identity runs through `Λ = μ ∗ log`, whose support has no canonical truncation;
2. the truncation error *is* the two-point Chowla correlation.

**So the demand is a grading substitute**: a canonical, error-controlled truncation of the Möbius sum. Every
`ℤ` method that supplies one — circle method, large sieve — is blocked at exactly this point, and the
measurements of rounds 110–114 say why: the standard truncations lose by factors `4`, `n`, or worse.

---

## 5. Proved versus measured

**Proved (Lean, standard axioms — `020/lean`, eight modules):**

| lemma | content |
|---|---|
| `Shift.not_dvd_C` | no nonconstant polynomial divides a nonzero constant — local factors are shift-free |
| `SieveLocal.card_roots_mul/prod/three` | local factor `2^k`, `k = 1,2,3` |
| `Grading.exists_two_mul_le` / `not_both_large` | every nontrivial factor has degree ≤ half |
| `Boundary.unique_of_deg_lt` | boundary coefficients are `0/1` |
| `Linear.shift_linear` | the degree-one base case `T(1) = q` |
| `Orbit.ne_neg_self` / `card_orbit` | `h ~ −h` orbits have size two in odd characteristic |
| `LargeSieve.class_second_moment` / `geom_support` | Cauchy–Schwarz step; support size |
| `Window.window_shift` / `window_concat` | window sums are shifted range sums and concatenate |
| `Dimension.card_roots_fun` | the `k`-condition local factor is `2^k` |
| `Parity.even_two_pow` / `two_pow_ge_two` / `two_pow_lt_succ` | the dimension factor is even, `≥ 2`, and strictly increasing |
| `PolyShift.card_nonzero` / `factor_gap` / `ratio_gt_one` | the degenerate local factor `Q−1`, its gap of one, and `(Q−1)/(Q−2) > 1` |

**Measured (exact finite computations):** every constant in the table above — the error ratios, the factor `4`,
the orbit counts, the large-sieve ratios, the counts `T(n)` up to `n = 14` at `q = 3`.

**Not proved:** the asymptotic `T(n) ~ S(q)q^n/n²` at fixed `q`. The 018 notes record it as conjectural in the
literature; phase 020 supplies evidence, not proof. The same holds for the polynomial-shift version of
round 121.

---

## 6. Reproduction

```
cd research/twin-prime-parity/020
python3 checks/audit.py                  # 28 claims, 0 failures
python3 -m unittest discover -s tests    # 20 tests
python3 checks/round107.py               # counts, wild guess 48
python3 checks/round108.py               # exact expansion + strata
python3 checks/falsification_test.py     # (019) the χ₂(2c) identity
./check.sh 020                           # 14 modules, standard axioms
```

Data files: `round107.json`, `round108.json`, `round114.json`, `round115.json`.

---

## 7. Open questions carried forward

1. **The asymptotic at fixed `q`** — the central open statement of the model.
2. **A grading substitute over `ℤ`** — the transfer demand, restated constructively.
3. ~~The role of `χ₂(2)`~~ — **answered (negative) in round 118**: the parity factor is `2^dim`, and
   `χ₂(2) = −1` at `q = 3, 5` yet the factors are `+2, +4`. The 019 correction is a Gauss-sum normalisation,
   orthogonal to the sieve deficit.
4. ~~A closed form for the boundary~~ — **answered (negative) in round 119**: `y²P(y)` has no limit
   (`0.070 → 0.115` for `y ≤ 12`), so no constant `C` exists. The `deg Q ≤ n/2` product tracks `T` to ~10%;
   the `k ≤ n` truncation does not track it at all.

---

## 8. Assessment

The phase did not cross the barrier. It did something more useful for the programme's own logic: it measured
every standard crossing mechanism in one model, found a computable failure factor for each, and reduced the
question to a single missing ingredient with a precise statement. That is the same kind of result the 018
programme produced for the parity barrier itself — a map, not a crossing — now with numbers attached.
