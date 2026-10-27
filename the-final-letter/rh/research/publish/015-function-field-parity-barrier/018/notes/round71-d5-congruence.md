# Round 71 — Target B: the `d=5` amplitude congruence

Round 16 of the aggressive goal.  Target B: the quintic amplitudes satisfy a
**congruence modulo `q`** in `ℤ[ζ₅]`.

---

## 1. The congruence

For `q = 11,31,41` and every quintic character `k = (q−1)/5 · j`:

```
(q−1)·c_k  ≡  0  (mod q)  in  ℤ[ζ₅] ,
```

i.e. the four integer coordinates of `(q−1)c_k` in the basis `1, ζ, ζ², ζ³` are
all divisible by `q`.  Equivalently

```
c_k / q  ∈  (1/(q−1))·ℤ[ζ₅] .
```

Verified for all four quintic characters at the three primes.

| `q` | `k` | `(q−1)c_k` |
|---|---|---|
| 11 | 2 | `[−88, −572, 88, −572]` |
| 11 | 4 | `[−176, −660, −660, −88]` |
| 31 | 6 | `[−73656, −74958, −113460, −78864]` |
| 41 | 8 | `[53136, −20336, 49856, −114144]` |

## 2. Comparison with `d=4`

For `d=4` the congruence is **stronger**: `c₄/q ∈ ℤ[i]` (rounds 59/69), i.e.
`c₄ ≡ 0 (mod q)` with a Gaussian-integer quotient.  For `d=5` the quotient lives
in `(1/(q−1))ℤ[ζ₅]`, one denominator deeper.

This is consistent with the `d=5` amplitudes being `O(q²)` with an extra `1/(q−1)`
normalisation from the Fourier transform.

---

## 3. Wild guess 14 — the denominator tower

> **Wild guess 14.** The amplitudes satisfy
> `c_k/ q ∈ (1/(q−1))·ℤ[ζ_k]` at degree `d = k`, with the denominator tower
> `(q−1)` at each level.  At `d=4` the tower collapses because `ζ₄ = i` and the
> Galois action is the conjugation `i ↦ −i`, giving the clean `ℤ[i]` quotient.

**Evidence.**

* `d=4`: `c₄/q ∈ ℤ[i]` (six primes).
* `d=5`: `(q−1)c_k ≡ 0 (mod q)` (three primes).
* Both are congruences modulo `q` in the appropriate cyclotomic ring.

---

## 4. Honest verdict

* **Target B — a `d=5` congruence.** No closed form for the amplitudes yet.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **The `(a,b)` pattern** (six data points).
2. **The `d=5` division by `(q−1)`** in detail.
3. **A synthesis**.

---

## 6. Reproduction

```
python3 checks/round71_d5_congruence.py   # exit 0
python3 -m pytest -q tests/test_round71.py   # 1 passed
```

New files: `checks/round71_d5_congruence.py`, `tests/test_round71.py`.
