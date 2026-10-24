# Round 75 — Target B: `T` depends only on `χ₄`; `c₄` from four integers

Round 20 of the aggressive goal.  **The strongest Target B result**: the shifted
irreducibility count depends only on the quartic character of the shift, which
gives a **closed formula for `c₄` in terms of four integers**.

---

## 1. The theorem: `T(a⁴h) = T(h)`

For `a ∈ 𝔽_q*` and monic quartic `f`, put `g(x) = f(ax)/a⁴` (again monic).  Then

```
g(x) + h  =  (f + a⁴h)(ax) / a⁴ ,
```

so `g + h` is irreducible iff `f + a⁴h` is.  As `f` runs over monic quartics,
so does `g`.  Hence

```
T(a⁴h) = T(h)      for every a ∈ 𝔽_q* .
```

So `T` is constant on the cosets of the fourth-power subgroup `(𝔽_q*)⁴` — which
are exactly the **quartic classes** `χ₄(h) = 1, i, −1, −i`.

**Corollary.** `T(h) = T_c` depends only on `c = χ₄(h)`.

Verified at seven primes: `T` takes exactly **four** values.

## 2. The closed formula

The quartic Fourier coefficient is

```
c₄  =  (1/(q−1)) Σ_h T(h)·conj(χ₄(h))
    =  (1/4) [ (T_0 − T_2) − i (T_1 − T_3) ] ,
```

where `T_c = T(h)` for `χ₄(h) = i^c`.

The character orthogonality is Lean-checked (`FourClass.four_class_sum`).

## 3. The congruence, refined

```
c₄/(2q) ∈ ℤ[i]   ⇔   8q ∣ (T_0 − T_2)  and  8q ∣ (T_1 − T_3) .
```

## 4. The data

| `q` | `T_0` | `T_1` | `T_2` | `T_3` | `c₄` | `8q ∣` |
|---|---|---|---|---|---|---|
| 17 | 5032 | 4335 | 4896 | 5015 | `34+170i` | ✓ |
| 41 | 174250 | 171749 | 167690 | 173389 | `1640+410i` | ✓ |
| 73 | 1743094 | 1746233 | 1758862 | 1747401 | `−3942+292i` | ✓ |
| 89 | 3885562 | 3836701 | 3882002 | 3895085 | `890+14596i` | ✓ |
| 97 | 5499900 | 5482731 | 5437044 | 5472643 | `15714−2522i` | ✓ |
| 113 | 10071916 | 10070899 | 10097228 | 10145027 | `−6328+18532i` | ✓ |
| 137 | 21784370 | 21817661 | 21977266 | 21823141 | `−48224+1370i` | ✓ |

---

## 5. Wild guess 17 — `T_c` is a quadratic in `q`

> **Wild guess 17.** Each `T_c` is a **quartic polynomial in `q`** (degree 4, since
> `T ~ q⁴/16`), with coefficients depending on `c`.  Then `T_0 − T_2` and
> `T_1 − T_3` are cubic polynomials in `q`, and the congruence `8q ∣` forces the
> constant term to vanish.  If so, `c₄` has an **explicit polynomial formula**.

**Evidence.** `T_c ~ q⁴/16` (main term), and `T` depends only on `c` (`§1`).

**Why it is a guess.** The polynomiality of `T_c` is not proved; the values are
too large for a naive fit at small `q`.

## 6. Honest verdict

* **Target B — a closed formula from four integers, and a proved symmetry.**
  `T(a⁴h) = T(h)` (proved); `c₄ = (1/4)[(T_0−T_2) − i(T_1−T_3)]` (proved);
  `8q ∣` (verified at seven primes).  Still no closed form in `q` alone.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 7. Next round

1. **Fit `T_c(q)`** as a polynomial (needs more primes or a structural argument).
2. **The `d=5` analogue** (quintic classes).
3. **A synthesis.**

---

## 8. Reproduction

```
python3 checks/round75_four_values.py   # exit 0
python3 -m pytest -q tests/test_round75.py   # 1 passed
cd lean && ./check.sh FourClass.lean   # OK
```

New files: `checks/round75_four_values.py`, `tests/test_round75.py`,
`lean/FourClass.lean`.
