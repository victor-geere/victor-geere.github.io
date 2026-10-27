# Round 87 — Target B: the integer `m` at eight primes

Round 32 of the aggressive goal.  The last unknown in the parity chain — the
integer `m` with `2B = m√q` — is tabulated at eight primes, and its modular
behaviour is pinned.

---

## 1. The data

| `q` | 17 | 41 | 73 | 89 | 97 | 113 | 137 | **193** |
|---|---|---|---|---|---|---|---|---|
| `m` | 1 | 13 | 5 | 13 | 41 | 25 | 61 | **25** |

The `q=193` value was computed independently by a direct even-quartic count
(`|B|` sizes `48,96 = (q−1)/4, (q−1)/2`), confirming the size law.

## 2. The modular pattern

```
m ≡ 1 (mod 4)   always ;        m ≡ 1 (mod 8)  iff  q ≡ 1 (mod 16) ,
                                m ≡ 5 (mod 8)  iff  q ≡ 9 (mod 16) .
```

Verified at all eight primes.

## 3. No class-number match

| `q` | `m` | `h(−4q)` | `h(−8q)` |
|---|---|---|---|
| 17 | 1 | 4 | 4 |
| 41 | 13 | 8 | 4 |
| 73 | 5 | 4 | 16 |
| 89 | 13 | 12 | 8 |
| 97 | 41 | 4 | 20 |
| 113 | 25 | 8 | 8 |
| 137 | 61 | 8 | 12 |
| 193 | 25 | 12 | 12 |

No simple relation (`m/h(−4q)` ranges from `0.25` to `10.25`).

---

## 4. Wild guess 29 — the sum of genus-1 traces

> **Wild guess 29.** `m = Σ_i a_{E_i}` is a sum of Frobenius traces of the
> genus-1 curves attached to the even quartics `x⁴+a₂x²+b`.  The number of terms
> grows with `q`, so `m` is `O(q)`-sized; its `mod 8` pattern reflects the
> parity of the number of terms with `a ≡ 1 (mod 4)`.

**Evidence.** The `√q` scaling; the modular pattern (§2); the failing Weil bound
`m(41)=13 > 2√41`.

**Why it is a guess.** The curves are not identified.

## 5. Honest verdict

* **Target B — `m` is tabulated but not identified.** The parity chain
  (`σ`-involution → `E` → `S_c = A + Bχ₂` → parity law) is complete modulo the
  value of `m`; `A` is closed-form.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

**A final synthesis of the whole programme.**

---

## 7. Reproduction

```
python3 checks/round87_m_data.py   # exit 0
python3 -m pytest -q tests/test_round87.py   # 1 passed
```

New files: `checks/round87_m_data.py`, `tests/test_round87.py`.
