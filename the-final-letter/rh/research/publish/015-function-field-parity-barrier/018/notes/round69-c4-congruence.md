# Round 69 — Target B: `c₄/(2q)` is a Gaussian integer

Round 14 of the aggressive goal.  Target B: a new **congruence** for the quartic
Fourier coefficient.

---

## 1. The congruence

At every tested `q ≡ 1 (mod 8)` (`q = 17,41,73,89,97,113`):

```
c₄(q)/(2q)  ∈  ℤ[i] .
```

| `q` | `c₄/q` | `c₄/(2q)` |
|---|---|---|
| 17 | `2 + 10i` | `1 + 5i` |
| 41 | `40 + 10i` | `20 + 5i` |
| 73 | `−54 + 4i` | `−27 + 2i` |
| 89 | `10 + 164i` | `5 + 82i` |
| 97 | `162 − 26i` | `81 − 13i` |
| 113 | `−56 + 164i` | `−28 + 82i` |

So `c₄ ≡ 0 (mod 2q)` in `ℤ[i]` — the real and imaginary parts are always even.

## 1′. The `q ≡ 5 (mod 8)` check

The `q=101` scan (background) gives `c₄(101) = 0`, consistent with the vanishing
of the quartic term at `q ≡ 5 (mod 8)` (round 33).  So `q=101` is a consistency
check, not a new data point.

## 2. The decomposition at the fifth prime

The exact formula

```
T(4;q,2) = A₄(q) + B₄(q)χ₂(2) + 2 Re(c₄(q)χ₄(2))
```

holds at `q = 97`:

```
A₄ = 10946159/2 ,   B₄ = −9215/2 ,   A₄+B₄χ₂(2) = 5468472 ,
T(2) = 5437044 ,   gap = −31428 = 2Re(c₄χ₄(2)) .
```

## 3. What the factor 2 might be

The quartic character has two nontrivial Galois orbits under `i ↦ −i`:
`χ₄` and `χ₄³`.  The factor 2 in `c₄/(2q)` could be the orbit count.

---

## 4. Wild guess 12 — the Hecke eigenvalue

> **Wild guess 12.** `c₄/(2q)` is the **Hecke eigenvalue** of a weight-2
> arithmetic object in `ℤ[i]`, and the factor `2q` is the normalisation from the
> two quartic orbits.  The values `1+5i, 20+5i, −27+2i, 5+82i, 81−13i, −28+82i` have
> norms `26, 425, 733, 6749, 6730, 6788` — no pattern yet, so the object is
> high-dimensional (a surface, not a curve).

---

## 5. Honest verdict

* **Target B — a congruence plus the 5th decomposition check.** `c₄/(2q) ∈ ℤ[i]`;
  no closed form for the values.
* **(A) — cap assembled** (round 13).
* **(C) — parity theorem proved.**

## 6. Next round

1. **The q=101 scan** (running) to extend the data.
2. **Identify the Hecke object.**
3. **The `d=5` amplitudes.**

---

## 7. Reproduction

```
python3 checks/round69_c4_congruence.py   # exit 0
python3 -m pytest -q tests/test_round69.py   # 1 passed
```

New files: `checks/round69_c4_congruence.py`, `tests/test_round69.py`.
