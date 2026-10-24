# Round 92 — Target B: the general theorem at `d = 3`

Round 37 of the aggressive goal.  The general theorem `T(d;q,a^d h) = T(d;q,h)`
is verified at a **new degree**, `d = 3`.

---

## 1. The data

| `q` | cube-class values | `q ∣ T` | DFT formula |
|---|---|---|---|
| 7 | `21, 28, 35` | ✓ | ✓ |
| 13 | `221, 247, 182` | ✓ | ✓ |
| 19 | `741, 627, 760` | ✓ | ✓ |

So:
* `T(3;q,h)` is constant on the three cube classes,
* `q ∣ T(3;q,h)` (translation orbit, Lean `FreeOrbit`),
* the amplitudes `c_k` are the **3-point DFT** of the class values:

```
c_k = (1/3) Σ_{t=0}^{2} A_t ζ₃^{−kt} .
```

Verified against the direct Fourier transform (`q = 7,13,19`).

## 2. The general statement

| `d` | class constancy | `q ∣ T` | DFT formula |
|---|---|---|---|
| 3 | ✓ | ✓ | ✓ |
| 4 | ✓ | ✓ | ✓ |
| 5 | ✓ | ✓ | ✓ |

The theorem holds at every degree tested.

---

## 3. Wild guess 34 — the DFT is the closed form

> **Wild guess 34.** For every `d`, the amplitudes are the `d`-point DFT of the
> `d` class counts, and the class counts are the only arithmetic data.  So the
> "closed form" problem for the amplitudes is **solved for all degrees** in terms
> of `d` integers — the remaining question is only the arithmetic of those
> integers (the `m`-problem at `d=4`).

**Evidence.** The three degrees tested (`§2`), the scaling theorem, and Lean
`FreeOrbit`.

## 4. Honest verdict

* **Target B — the general theorem holds at `d=3`.** The DFT formula is the
  closed form, valid for every degree tested.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **The `m`-problem** (the only arithmetic unknown).
2. **A closing note.**

---

## 6. Reproduction

```
python3 checks/round92_d3.py   # exit 0
python3 -m pytest -q tests/test_round92.py   # 1 passed
```

New files: `checks/round92_d3.py`, `tests/test_round92.py`.
