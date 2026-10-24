# Round 86 — Target B: the closed form of `A`

Round 31 of the aggressive goal.  The constant `A` in the Fourier-energy
decomposition has a **closed form**, derived from Parseval and the sizes of the
even-quartic sets.

---

## 1. The sizes of `B(a₂)`

For `B(a₂) = {b : x⁴+a₂x²+b irr}`:

```
|B(0)|  =  (q−1)/2 ,        |B(a₂)|  =  (q−1)/4   (a₂ ≠ 0) .
```

Verified at seven primes (`q = 17,41,73,89,97,113,137`).

## 2. Parseval and the closed form

```
Σ_{a₂} |B(a₂)|  =  (q−1)/2 + (q−1)²/4  =  (q²−1)/4 ,
Σ_c S_c  =  q·Σ|B|  =  q(q²−1)/4 ,
S_0  =  ((q−1)/2)² + (q−1)·((q−1)/4)²  =  (q−1)²/4 + (q−1)³/16 .
```

Since `Σ_{c≠0} χ₂(c) = 0`, the `B`-term drops out of the class sum, so

```
Σ_{c≠0} S_c  =  (q−1)·A  =  q(q²−1)/4 − S_0 ,
```

hence

```
A  =  [q(q²−1)/4 − (q−1)²/4 − (q−1)³/16] / (q−1)
   =  (3q² + 2q + 3)/16 .
```

Verified exactly at all seven primes.

## 3. What remains: the integer `m`

```
2B  =  m·√q ,      m = 1, 13, 5, 13, 41, 25, 61    (q = 17,41,73,89,97,113,137) .
```

Note `m = 13 > 2√41 ≈ 12.8` — so `m` is **not** a single Frobenius trace; it must
be a sum of at least two.

---

## 4. Wild guess 28 — the sum of traces

> **Wild guess 28.** `m = Σ_i a_{E_i}` is a sum of Frobenius traces of finitely
> many genus-1 curves attached to the family `x⁴+a₂x²+b`.  The number of terms
> grows with `q`, so `m` is `O(q)`-sized, not `O(√q)` — explaining
> `m(41) = 13 > 2√41`.

**Evidence.** The `√q` scaling (`§3`); the `A` formula (`§2`).

**Why it is a guess.** The curves are not identified.

## 5. Honest verdict

* **Target B — `A` is closed-form**: `(3q²+2q+3)/16`.
* The only remaining unknown in `S_c = A + Bχ₂(c)` is the integer `m`.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Identify `m`** (the last unknown in the parity-law chain).
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round86_A_formula.py   # exit 0
python3 -m pytest -q tests/test_round86.py   # 1 passed
```

New files: `checks/round86_A_formula.py`, `tests/test_round86.py`.
