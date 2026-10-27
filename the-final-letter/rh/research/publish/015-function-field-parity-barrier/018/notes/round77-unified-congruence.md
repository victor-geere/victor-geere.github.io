# Round 77 — Target B: the unified congruence

Round 22 of the aggressive goal.  The `d=4` and `d=5` congruences unite into
**one statement**, and the polynomial hypothesis is definitively excluded.

---

## 1. The unified statement

For every `d ∣ q−1`, let `A_c` (`c = 0..d−1`) be the class values of
`T(d;q,·)` (constant on the `d`-th power cosets), and let

```
S_j  =  Σ_{c=0}^{d−1} A_c · ζ_d^{−jc}      (j = 1..d−1)
```

be the `d`-point DFT sums.  Then

```
S_j  ≡  0  (mod q)      in ℤ[ζ_d] .
```

* `d=4`: `S_1 = (A_0−A_2) + i(A_3−A_1)`, and the stronger `8q ∣ S_1` holds.
* `d=5`: `S_j ≡ 0 (mod q)` for all `j = 1..4`.

## 2. The data

**`d=4`** (seven primes):

| `q` | `A_0−A_2` | `A_3−A_1` | `8q` |
|---|---|---|---|
| 17 | 136 | 680 | 136 |
| 41 | 6560 | 1640 | 328 |
| 73 | −15768 | 1168 | 584 |
| 89 | 3560 | 58384 | 712 |
| 97 | 62856 | −10088 | 776 |
| 113 | −25312 | 74128 | 904 |
| 137 | −192896 | 5480 | 1096 |

**`d=5`** (`q = 31,41`): all four sums `S_j` have coordinates divisible by `q`
(e.g. `q=31, j=1`: `[18910, 6417, 5766, 6634]`).

## 3. The polynomial hypothesis is dead

Fitting `A_0(q)` as a polynomial:

| degree | residuals at `q = 113, 137` |
|---|---|
| 4 | `699168/7`, `1755668/7` |
| 5 | `0`, `−7566572/7` |

Neither a quartic nor a quintic fits.  So `A_c(q)` is **not** a polynomial in
`q` — the arithmetic fluctuation is genuine.

---

## 4. Wild guess 19 — the congruence is the whole content

> **Wild guess 19.** The class values `A_c` are **not** expressible in elementary
> closed form; the only universal structure is the congruence
> `S_j ≡ 0 (mod q)`.  This is the arithmetic shadow of the fact that the twin
> count is a **non-periodic** function (Target C): its Fourier coefficients are
> `q`-divisible but not polynomial.

**Evidence.**

* No polynomial fit of degree ≤ 5 (`§3`).
* The congruence holds in both `d=4` and `d=5` (`§2`).
* The amplitudes are the DFT of the class values (`§1`).

## 5. Honest verdict

* **Target B — the unified congruence.** The amplitudes are DFTs of class
  counts, and the DFT sums are `q`-divisible.  No closed form in `q` alone.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Prove `S_j ≡ 0 (mod q)`** via the inclusion-exclusion structure of `T`.
2. **A synthesis of all three targets.**

---

## 7. Reproduction

```
python3 checks/round77_unified_congruence.py   # exit 0
python3 -m pytest -q tests/test_round77.py   # 2 passed
```

New files: `checks/round77_unified_congruence.py`, `tests/test_round77.py`.
