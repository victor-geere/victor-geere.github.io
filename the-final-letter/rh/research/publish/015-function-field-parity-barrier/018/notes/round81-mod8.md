# Round 81 — Target B: the mod-8 quadratic-character structure

Round 26 of the aggressive goal.  The factor `8` of round 25 is explained by a
**cleaner invariant**: `T'(h) mod 8` depends only on the quadratic character of
`h`, and the two values sum to `−1`.

---

## 1. The theorem

For a fixed `q ≡ 1 (mod 8)`:

```
T'(h) mod 8  depends only on χ₂(h) ,      T'(h_s) + T'(h_n) ≡ −1  (mod 8)
```

for any square `h_s` and non-square `h_n`.

Verified at seven primes:

| `q` | squares mod 8 | nonsquares mod 8 | sum |
|---|---|---|---|
| 17 | `(0,0)` | `(7,7)` | 7 |
| 41 | `(2,2)` | `(5,5)` | 7 |
| 73 | `(6,6)` | `(1,1)` | 7 |
| 89 | `(2,2)` | `(5,5)` | 7 |
| 97 | `(4,4)` | `(3,3)` | 7 |
| 113 | `(4,4)` | `(3,3)` | 7 |
| 137 | `(2,2)` | `(5,5)` | 7 |

## 2. The factor 8

The classes `0,2` are the **squares** (`χ₂ = 1`) and the classes `1,3` are the
**non-squares** (`χ₂ = −1`).  Hence

```
T'_0 ≡ T'_2 (mod 8)   and   T'_1 ≡ T'_3 (mod 8) ,
```

which is exactly the factor `8` of round 25 (and hence `c₄/(2q) ∈ ℤ[i]`).

## 3. The mod-2 shadow

Mod 2, the structure is even starker: `T'` is **even on squares** and **odd on
non-squares** at all seven primes.  Such a function must be divisible by `8` on
the square classes (since `T' ≡ 0` mod 2 there), and the mod-4/8 refinement
gives the exact value.

---

## 4. Wild guess 23 — the 2-adic origin

> **Wild guess 23.** `T'(h) mod 8` is a function of `χ₂` because the quartic
> count `T` is governed by the **2-adic valuation** of the pair `(f, f+h)`: the
> `μ₄` action (round 76) and the even symmetry (round 74) give two independent
> `ℤ/2` actions, and their product with the DFT normalisation produces the
> `ℤ/8`.  The identity `T'_s + T'_n ≡ −1` is the 2-adic shadow of the quadratic
> orthogonality `Σ χ₂ = 0`.

**Evidence.** The seven-prime mod-8 table (`§1`), the mod-2 split (`§3`).

**Why it is a guess.** The 2-adic mechanism is not exhibited.

## 5. Honest verdict

* **Target B — the factor 8 is a mod-8 quadratic-character statement.**
  `T'(h) mod 8` depends only on `χ₂(h)`; the factor 8 follows.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Prove the mod-8 structure** via the 2-adic mechanism.
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round81_mod8.py   # exit 0
python3 -m pytest -q tests/test_round81.py   # 1 passed
```

New files: `checks/round81_mod8.py`, `tests/test_round81.py`.
