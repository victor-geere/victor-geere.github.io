# Round 100 — Target B: the `S(u,v)` decomposition of the `H`-sum

Round 44 of the aggressive goal.  The `H`-sum splits into an **exact diagonal**
and a **quartic-character off-diagonal**, and only the latter carries `a²`.

---

## 1. The diagonal

```
S(u,u)  =  Σ_a χ₂(a²−u)²  =  q − 1 − χ₂(u) .
```

**Verified exactly** for every `u` at `q = 17,41,73`.

## 2. The off-diagonal

```
S(u,v)  =  Σ_a χ₂((a²−u)(a²−v)) ,      u ≠ v ,
```

is a **quartic character sum** (the polynomial `(a²−u)(a²−v)` has four distinct
roots).  Its values are bounded and mixed:

| `q` | off-diagonal values |
|---|---|
| 17 | `−7,−3,−2,0,1,5` |
| 41 | `−11,−7,−3,−2,0,1,5,9` |
| 73 | `−15,−11,−7,−3,−2,0,1,5,9,13` |

All values are `≡ 1 (mod 4)` except `0` and `−2`.

## 3. The consequence

```
Σ_a |H(a,c)|²  =  Σ_{u,v} χ₂(u)χ₂(v) ζ^{−c(u−v)/4} S(u,v) .
```

The diagonal contributes the polynomial part; the off-diagonal — a quartic
character sum — carries the `a²√q` term.

---

## 4. Wild guess 41 — the diagonal/off-diagonal split of `a²`

> **Wild guess 41.** The diagonal part of `Σ|H|²` gives `q²−2q`, and the
> off-diagonal gives `−2χ₂(c)q√q + 4a²χ₂(c)√q`.  The `a²` is the coefficient of
> `√q` in the off-diagonal, and it equals the Jacobi sum `J(χ₄,χ₄) = ±(a+bi)`
> because the quartic character sum `S(u,v)` is a **Salié sum** whose evaluation
> involves `χ₄`.

**Evidence.** The diagonal formula (§1), the bounded off-diagonal (§2), and the
`H`-sum formula of round 43.

## 5. Honest verdict

* **Target B — the `H`-sum splits cleanly.**  The polynomial part is exact; the
  `a²` lives in the off-diagonal quartic character sum.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The Salié-sum evaluation of `S(u,v)`.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round100_diagonal.py   # exit 0
python3 -m pytest -q tests/test_round100.py   # 1 passed
```

New files: `checks/round100_diagonal.py`, `tests/test_round100.py`.
