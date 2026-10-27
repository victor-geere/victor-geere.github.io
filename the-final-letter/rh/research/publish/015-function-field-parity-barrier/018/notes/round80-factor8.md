# Round 80 — Target B: the `(q−1)` divisibility is a factor `8`

Round 25 of the aggressive goal.  The last unproved piece of the `d=4`
congruence is reduced to the cleanest possible form: a **factor 8** on the
reduced counts.

---

## 1. The reformulation

Since `T(h) = q·T'(h)` (translation orbit, round 78) and `T` is constant on the
quartic classes (round 76),

```
A_c = T(h_c) = q·T'(h_c) ,      c₄ = (1/4)[(A_0−A_2) − i(A_1−A_3)] .
```

Hence

```
c₄/(2q)  =  (1/8) [ (T'(h_0) − T'(h_2)) + i (T'(h_3) − T'(h_1)) ] .
```

So the `(q−1)` divisibility is **exactly**

```
8 ∣ (T'(h_0) − T'(h_2))    and    8 ∣ (T'(h_3) − T'(h_1)) .
```

## 2. Verification — seven primes

| `q` | `(A_0−A_2)/q` | `(A_3−A_1)/q` | quotients `(·/8, ·/8)` |
|---|---|---|---|
| 17 | 8 | 40 | `(1, 5)` |
| 41 | 160 | 40 | `(20, 5)` |
| 73 | −216 | 16 | `(−27, 2)` |
| 89 | 40 | 656 | `(5, 82)` |
| 97 | 648 | −104 | `(81, −13)` |
| 113 | −224 | 656 | `(−28, 82)` |
| 137 | −1408 | 40 | `(−176, 5)` |

The quotients are exactly the Gaussian halves `c₄/(2q)`.

## 3. The 2-adic valuations

```
v₂((A_0−A_2)/q) = 3, 5, 3, 3, 3, 5, 7 ,     v₂((A_3−A_1)/q) = 3, 3, 4, 4, 3, 4, 3 .
```

All `≥ 3`; the divisibility by `8` is **exact** in general (no higher power is
forced).

---

## 4. Wild guess 22 — the three twos

> **Wild guess 22.** The factor `8 = 2³` has three independent sources:
> the even symmetry `T(h) = T(−h)` (one 2, proved in round 74),
> the two-element structure of the quartic class group `μ₄/{±1}` (a second 2),
> and the DFT normalisation `d=4` (a third 2).  Each is a free involution on the
> pair set, so the difference is divisible by `8`.

**Evidence.** The reformulation (`§1`), the seven-prime divisibility (`§2`), the
exact valuations `≥ 3` (`§3`).

**Why it is a guess.** The second and third involutions are not exhibited.

## 5. Honest verdict

* **Target B — the congruence is a factor-8 statement.** All of the structure is
  now proved except the factor `8` on the reduced counts.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Exhibit the three involutions** giving the factor 8.
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round80_factor8.py   # exit 0
python3 -m pytest -q tests/test_round80.py   # 1 passed
```

New files: `checks/round80_factor8.py`, `tests/test_round80.py`.
