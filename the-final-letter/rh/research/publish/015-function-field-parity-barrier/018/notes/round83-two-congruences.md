# Round 83 — Target B: the two 2-adic congruences

Round 28 of the aggressive goal.  The square/non-square class values satisfy
**two exact congruences** that pin down the 2-adic behaviour.

---

## 1. The congruences

Let `T'_s` be the value on the square classes (`c = 0,2`) and `T'_n` on the
non-square classes (`c = 1,3`).  Then

```
T'_s + T'_n  ≡  −1  (mod 8)        and        T'_s − T'_n  ≡  1  (mod 4) .
```

Verified at seven primes:

| `q` | `T'_s` | `T'_n` | `T'_s+T'_n` | `T'_s−T'_n` |
|---|---|---|---|---|
| 17 | 296 | 255 | 551 ≡ 7 | 41 ≡ 1 |
| 41 | 4250 | 4189 | 8439 ≡ 7 | 61 ≡ 1 |
| 73 | 23878 | 23921 | 47799 ≡ 7 | −43 ≡ 1 |
| 89 | 43658 | 43109 | 86767 ≡ 7 | 549 ≡ 1 |
| 97 | 56700 | 56523 | 113223 ≡ 7 | 177 ≡ 1 |
| 113 | 89132 | 89123 | 178255 ≡ 7 | 9 ≡ 1 |
| 137 | 159010 | 159253 | 318263 ≡ 7 | −243 ≡ 1 |

## 2. The consequence

`T'_s` is `0` or `2` mod `4`, and `T'_n` is `1` or `3` mod `4`.  Combined with
the within-class constancy `T'_0 ≡ T'_2`, `T'_1 ≡ T'_3 (mod 8)`, this gives the
factor `8` — i.e. `c₄/(2q) ∈ ℤ[i]`.

## 3. The mod-8 line

In `(ℤ/8)²`, the pair `(T'_s, T'_n)` lies on the line `x + y = 7`, with the
values determined by `q`:

```
(0,7), (2,5), (6,1), (2,5), (4,3), (4,3), (2,5) .
```

Only four of the eight possible pairs occur.

---

## 4. Wild guess 25 — the 2-adic completion

> **Wild guess 25.** The pair `(T'_s, T'_n)` is the image of a **2-adic
> character**: `T'_s, T'_n` are the values of a `ℤ/8`-valued function on the
> square classes, and the congruences `x+y = −1`, `x−y = 1 (mod 4)` are its
> definition.  If so, the factor `8` is proved by 2-adic descent.

**Evidence.** The seven-prime table (`§1`), the four occurring pairs (`§3`).

**Why it is a guess.** The `ℤ/8`-valued character is not exhibited.

## 5. Honest verdict

* **Target B — the two congruences** pin the 2-adic structure; the factor `8`
  follows.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Exhibit the `ℤ/8`-valued character.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round83_two_congruences.py   # exit 0
python3 -m pytest -q tests/test_round83.py   # 1 passed
```

New files: `checks/round83_two_congruences.py`, `tests/test_round83.py`.
