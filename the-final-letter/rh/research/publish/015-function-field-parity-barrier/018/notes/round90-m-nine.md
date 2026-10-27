# Round 90 — Target B: `m` at nine primes, and the Fermat trace

Round 35 of the aggressive goal.  The integer `m` gains a ninth value, and a
**partial** relation to the Fermat quartic curve is found.

---

## 1. The data

| `q` | 17 | 41 | 73 | 89 | 97 | 113 | 137 | 193 | **233** |
|---|---|---|---|---|---|---|---|---|---|
| `m` | 1 | 13 | 5 | 13 | 41 | 25 | 61 | 25 | **85** |

`m(233) = 85` was computed by a direct even-quartic count with sympy
factorisation.

## 2. The modular pattern (nine primes)

```
m ≡ 1 (mod 4)   always ;
m ≡ 1 (mod 8)   iff  q ≡ 1 (mod 16) ,
m ≡ 5 (mod 8)   iff  q ≡ 9 (mod 16) .
```

## 3. The Fermat quartic trace

| `q` | 17 | 41 | 73 | 89 | 97 | 113 | 137 | 193 | 233 |
|---|---|---|---|---|---|---|---|---|---|
| `a_C` | 5 | 29 | −19 | 29 | 53 | −43 | −67 | −43 | 77 |
| `(a_C−3)/2` | 1 | 13 | −11 | 13 | 25 | −23 | −35 | −23 | 37 |
| `m` | 1 | 13 | 5 | 13 | 41 | 25 | 61 | 25 | 85 |
| match | ✓ | ✓ | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |

So `m = (a_C−3)/2` at `q = 17, 41, 89` only — a **partial** relation.

---

## 4. Wild guess 32 — the correction term

> **Wild guess 32.** `m = (a_C−3)/2 + c(q)`, where `c(q)` comes from the higher
> cohomology of the Fermat quartic **surface**: the curve trace `a_C` is the
> `H¹` contribution, and the surface's `H²` contributes a correction that
> vanishes exactly when `q` lies in a specific residue class (observed:
> `17,41,89`).

**Evidence.** The nine-prime table (`§3`).

**Why it is a guess.** `c(q)` is not identified.

## 5. Honest verdict

* **Target B — `m` at nine primes**, with a partial Fermat-match.  The parity
  chain remains complete modulo `m`.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The correction `c(q)`.**
2. **A closing note.**

---

## 7. Reproduction

```
python3 checks/round90_m_nine.py   # exit 0
python3 -m pytest -q tests/test_round90.py   # 2 passed
```

New files: `checks/round90_m_nine.py`, `tests/test_round90.py`.
