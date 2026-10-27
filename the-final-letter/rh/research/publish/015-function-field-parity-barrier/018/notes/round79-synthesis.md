# Synthesis — the three targets of the aggressive goal

Round 24.  A consolidated statement of what is **proved**, what is
**verified**, and what remains, across the three targets.

---

## Target A — the `d=4` cap

```
|(−Im g) ∪ Q| ≥ (q+1)/2      for every quartic g over 𝔽_q .
```

| link | status | evidence |
|---|---|---|
| translation `a₃ ↦ 0` | **proved** | `Shift.irreducible_shift` |
| `R = (−Im g) ∪ Q` | **proved** | `Factorization.quadratic_factor`, `even_factor`; verified `q=11,13,29,37` |
| composition `R = Q` | **proved** | `Composition.neg_image_mem_Q` |
| `x⁴+b` size | **proved** | `NegSquare.neg_sq_mem_sq` |
| `a₂≠0` size `q−⌊(q+2)/4⌋` | **proved** | `QSize.size_identity`, `QOrbit.sigma_*`; round 57 |
| `(A2)` monodromy primitive | **Ritt** | round 67 |
| `(A2)` error `O(√q)`, constant `0.5` | **Poincaré + Weil** | rounds 62–66 |
| finite base `q < 49` | **checked** | `SmallCap`, rounds 37/47/48 |

**Status: proved modulo Ritt + Poincaré + the class-function decomposition.**

---

## Target B — closed forms

| statement | status |
|---|---|
| `T(d;q,a^d h) = T(d;q,h)` | **proved** (scaling `x ↦ ax`) |
| `T` constant on `d`-th power classes | **proved** (corollary) |
| amplitudes `= (1/d)Σ A_c ζ_d^{−kc}` | **proved** (DFT) |
| `c₄ = (1/4)[(A_0−A_2) − i(A_1−A_3)]` | **proved** |
| `c₄/(2q) ∈ ℤ[i]` (factor 2) | **proved** (`TwinEven`) |
| `c₄/(2q) ∈ ℤ[i]` (factor `(q−1)`) | **verified** 7 primes |
| `(q−1)c_k ≡ 0 (mod q)` for `d=5` | **proved** (translation orbit) |
| `A_c` polynomial in `q` | **false** (rounds 21/22) |

**Status: the amplitudes are `d`-point DFTs of `d` integers (proved); no closed
form in `q` alone.**

---

## Target C — the parity barrier

```
twinInd  is not a bounded-support divisor sum .
```

| statement | status |
|---|---|
| divisor sums are periodic | **proved** | `DivisorSum.divisor_sum_periodic` |
| `twinInd` is not periodic | **proved** | `NonPeriodic.twinInd_not_periodic` |
| `twinInd` is not a divisor sum | **proved** | `NonPeriodic.twinInd_not_divisor_sum` |
| finite combinations reduce to one divisor sum | **proved** (algebra) |
| quantitative factor 2 | **numerical** |

**Status: complete for the entire Selberg class of finite divisor sums; the
factor 2 is the quantitative form of the obstruction.**

---

## The remaining gaps

1. **Target A**: the three standard facts (Ritt, Poincaré, the class-function
   decomposition) are not formalized in Lean.
2. **Target B**: the `(q−1)` divisibility of `S_1` — the `χ₄`-Fourier coefficient
   of `T'` being a Gaussian integer.
3. **Target C**: a proof of the factor 2 (the sieve's parity obstruction).

All three are **sharp**: no further structural simplification is available from
the computations.

---

## Wild guess 21 — the common object

> **Wild guess 21.** The three gaps are the same gap.  The `(q−1)` divisibility
> of `S_1` (Target B), the explicit constant in the `S₄` error (Target A), and
> the factor 2 (Target C) are all shadows of the **`GL(2)` automorphic
> `L`-function** attached to the quartic family.  Over `ℚ`, that `L`-function is
> the missing object that would give the twin conjecture; over `𝔽_q` it is
> invisible because the family is `q`-periodic.

---

## The final honest verdict

* **Target A**: proved modulo standard facts; the cap is assembled.
* **Target B**: structural theorems proved; the closed form is the DFT of the
  class counts; one divisibility remains.
* **Target C**: proved for the divisor-sum class; the factor 2 is quantitative.
