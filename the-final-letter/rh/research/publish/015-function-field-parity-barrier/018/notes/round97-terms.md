# Round 97 — Target B: the term decomposition of `S_c`

Round 41 of the aggressive goal.  The Gauss-sum expansion of round 40 is now
decomposed into its six terms, and their orders are identified.

---

## 1. The decomposition

```
S_c  =  (1/16)[ A + B + C + D + E + F ]  +  boundary terms ,
```

| term | value | order |
|---|---|---|
| `A = Σ_{a₂}\|T2\|²` | `q²` | `q²` |
| `B = Σ_{a₂}\|T3\|²` | `q²` | `q²` |
| `C = Σ_{a₂}\|T4\|² = Σ\|H(a₂,c)\|²` | numerical | `q²` |
| `D = 2Re Σ T2 conj(T3)` | `2χ₂(−1)χ₂(−c)q√q` | `q^{3/2}` |
| `E = −2Re Σ T2 conj(T4)` | `2q` | `q` |
| `F = −2Re Σ T3 conj(T4)` | `2q` | `q` |

Verified at `q = 17,41,73`:

| `q` | `A` | `B` | `C` | `D` | `E` | `F` |
|---|---|---|---|---|---|---|
| 17 | 289 | 289 | 131.3 | 140.2 | 34 | 34 |
| 41 | 1681 | 1681 | 1714.3 | 525.1 | 82 | 82 |
| 73 | 5329 | 5329 | 4243.2 | 1247.4 | 146 | 146 |

`A = B = q²` and `E = F = 2q` are **exact**.

## 2. The `√q` coefficient

`D` is the only term of order `q^{3/2}` computed so far, and it carries the factor
`χ₂(−c)` — the `χ₂`-dependence of `S_c`.

**But the boundary corrections also enter at order `q^{3/2}`:** each is `O(1)`
per `a₂`, and `|B̂|²` has cross terms between the boundary correction and the
`O(√q)` parts of `T2,T3,T4`.  So the coefficient of `√q` in `S_c` — the integer
`m` — is the sum of `D` and the boundary contribution.

---

## 3. Wild guess 38 — the boundary supplies the `+1`

> **Wild guess 38.** The boundary correction contributes `−2χ₂(−c)q√q·(a²−1)/2`
> or similar, combining with `D = 2χ₂(−1)χ₂(−c)q√q` to give the coefficient
> `m√q/2 = ((a²+1)√q)/4`.  The odd `+1` in `m = (a²+1)/2` comes from the
> **boundary**, not the bulk.

**Evidence.** The exact `E(h)` formula (round 38) and the decomposition (§1).

## 4. Honest verdict

* **Target B — the bulk terms are identified** (`A=B=q²`, `E=F=2q`,
  `D=2χ₂(−1)χ₂(−c)q√q`); the boundary's `q^{3/2}` contribution is the last
  piece.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **The boundary contribution.**
2. **A final synthesis.**

---

## 6. Reproduction

```
python3 checks/round97_terms.py   # exit 0
python3 -m pytest -q tests/test_round97.py   # 1 passed
```

New files: `checks/round97_terms.py`, `tests/test_round97.py`.
