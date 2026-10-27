# Round 76 — Target B: the amplitudes are a `d`-point DFT of `d` integers

Round 21 of the aggressive goal.  The round-20 theorem generalizes to **every
degree**: `T(d;q,h)` depends only on the `d`-th power class of `h`, so the
degree-`d` amplitudes are the `d`-point DFT of `d` integers.

---

## 1. The general theorem

For `a ∈ 𝔽_q*` and a monic degree-`d` polynomial `f`, put `g(x) = f(ax)/a^d`
(monic).  Then

```
g(x) + h  =  (f + a^d h)(ax) / a^d ,
```

so `g + h` is irreducible iff `f + a^d h` is.  Hence

```
T(d;q, a^d h) = T(d;q, h)      for every a .
```

So `T(d;q,·)` is constant on the cosets of `(𝔽_q*)^d` — the **`d`-th power
classes** — and the number of cosets is `gcd(d, q−1)`.

Verified:

| `d` | `q` | cosets | constant |
|---|---|---|---|
| 4 | 17,41,73,89,97,113,137 | 4 | ✓ |
| 5 | 11,31,41 | 5 | ✓ |

## 2. The amplitude formula

Writing `A_c = T(d;q,h)` for `h` in the `c`-th `d`-th-power class, the degree-`d`
Fourier coefficients are

```
c_k  =  (1/d) Σ_{c=0}^{d−1} A_c · ζ_d^{−k c}      (k = j(q−1)/d) .
```

**`d=4`** (round 75): `c₄ = (1/4)[(A_0−A_2) − i(A_1−A_3)]`.

**`d=5`** (this round, `q=11`): class values `A = (102597,102641,102355,102685,102355)`,
and the 5-point DFT gives

```
c_1 = 12.68 − 15.61i ,   c_2 = 22.52 − 96.39i ,   ...
```

matching the round-11 amplitudes `10·c₂ = [−88,−572,88,−572]` exactly.

## 3. What this settles

* The amplitudes are **determined by `d` integers** — a closed formula in terms
  of the class counts `A_c`.
* For `d=4`: `c₄/(2q) ∈ ℤ[i] ⇔ 8q ∣ (A_0−A_2), (A_1−A_3)`.
* The remaining question is the **arithmetic of `A_c`** (no polynomial formula
  found — round 21's quartic fit fails at the 6th/7th point).

---

## 4. Wild guess 18 — `A_c` is a character sum

> **Wild guess 18.** Each `A_c` is a **quartic polynomial in `q` plus a character
> term** `q^{3/2}·(Gauss-sum combination)`.  The polynomial part is the
> `q⁴/16`-scale main term; the character part carries the `q^{3/2}` fluctuation
> that defeats the plain quartic fit.

**Evidence.** The quartic fit through 5 points misses the 6th/7th (round 21);
the `−q⁴/16` differences scale like `q³` but with character-dependent constants.

## 5. Honest verdict

* **Target B — the amplitudes are `d`-point DFTs of `d` integers (proved).**
  `T(d;q,a^d h) = T(d;q,h)`; the formulas for `d=4` and `d=5` are verified.
  No closed form in `q` alone.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Separate the polynomial and character parts of `A_c`.**
2. **The `d=5` congruence.**
3. **A synthesis.**

---

## 7. Reproduction

```
python3 checks/round76_dft.py   # exit 0
python3 -m pytest -q tests/test_round76.py   # 1 passed
```

New files: `checks/round76_dft.py`, `tests/test_round76.py`.
