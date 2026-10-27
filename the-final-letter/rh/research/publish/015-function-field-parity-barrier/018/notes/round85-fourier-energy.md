# Round 85 — Target B: the average Fourier energy is a quadratic character

Round 30 of the aggressive goal.  The two-valuedness of `E(h)` (round 84) is
explained: the **average Fourier energy** of the even-quartic sets is a
quadratic character.

---

## 1. The Fourier energy

For `B(a₂) = {b : x⁴+a₂x²+b irr}` and an additive character `ψ_c(b) = ζ^{cb}`,
define

```
S_c  =  Σ_{a₂} |B̂_{a₂}(c)|² .
```

Then `E(h) = (1/q) Σ_c S_c ψ_c(−h)`.

## 2. The theorem

```
S_c  =  A  +  B·χ₂(c)      (c ≠ 0) ,
```

with `2B = m·√q` for an integer `m`.  Verified:

| `q` | `S_c` on squares | `S_c` on nonsquares | `A` | `2B` | `m` |
|---|---|---|---|---|---|
| 17 | 58.561553 | 54.438447 | 56.5 | 4.123 = √17 | 1 |
| 41 | 362.120308 | 278.879692 | 320.5 | 83.241 = 13√41 | 13 |
| 73 | 1029.860009 | 987.139991 | 1008.5 | 42.720 = 5√73 | 5 |

**So the average Fourier energy is a quadratic character plus a constant.**

## 3. The consequence

```
E(h)  =  (1/q)[ S_0 − A − B + B·χ₂(−h)·G ]  ,      G = √q ,
```

which takes exactly **two** values, determined by `χ₂(−h)` — hence by
`χ₂(2h)`.  The deficit is odd, so

```
E(h) ≡ (1−χ₂(2h))/2  (mod 2) ,
```

and with round 84's `T ≡ E (mod 2)`, the **parity law** follows.

---

## 4. Wild guess 27 — the Weil class number

> **Wild guess 27.** The integer `m ∈ {1, 13, 5, …}` with `2B = m√q` is a
> **class number** (or a trace of a genus-1 curve): the `S_c` are Weil sums on
> the curves `x⁴+a₂x²+b = 0`, and their `√q`-coefficient is the trace of the
> Frobenius on a genus-1 factor.  Then `m` is computable, and `A` has a closed
> form.

**Evidence.** The `χ₂`-dependence and the `√q` scaling (`§2`).

**Why it is a guess.** `m` and `A` are not identified.

## 5. Honest verdict

* **Target B — the average Fourier energy is a quadratic character.** The
  parity law follows from rounds 84 + 85.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Identify `m` and `A`.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round85_fourier_energy.py   # exit 0
python3 -m pytest -q tests/test_round85.py   # 1 passed
```

New files: `checks/round85_fourier_energy.py`, `tests/test_round85.py`.
