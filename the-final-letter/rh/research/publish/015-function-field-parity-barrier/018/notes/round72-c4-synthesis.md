# Round 72 — Target B: consolidated structure of `c₄`

Round 17 of the aggressive goal.  A consolidation of everything established
about `c₄`, plus the failed closed-form searches.

---

## 1. The established facts

| fact | evidence |
|---|---|
| `c₄ = 0` for `q ≡ 3 (mod 4)` and `q ≡ 5 (mod 8)` | rounds 33/69 |
| `c₄/q ∈ ℤ[i]` for `q ≡ 1 (mod 8)` | 6 primes |
| `c₄/(2q) ∈ ℤ[i]` (both parts even) | 6 primes |
| `T = A₄ + B₄χ₂(2) + 2Re(c₄χ₄(2))` | 5 primes |

The seven values of `c₄/(2q)`: `1+5i, 20+5i, −27+2i, 5+82i, 81−13i, −28+82i`.

## 2. The failed searches

| hypothesis | outcome |
|---|---|
| Fermat quartic curve trace `a_C` | no (`a_C = 5,29,−19,29,53,−43`) |
| `a_C²` | no |
| Fermat quartic surface trace | no (`t/q = 18.29, 20.46`) |
| octic Gauss sum `G₈²/q` | no (unit, while `c₄/(2q)` is `O(q)`) |
| representation `q = u²+v²` | no |
| single weight-2 Hecke eigenvalue | no (Ramanujan bound `2√q` violated) |

**What the values look like.** `|c₄/(2q)|` grows like `q` (weight 2), so the
object is high-dimensional — a surface or a high-rank motive, not a curve.
Norms: `26, 425, 733, 6749, 6730, 6788`.

## 3. Wild guess 15 — the high-rank surface

> **Wild guess 15.** `c₄/(2q)` is a sum of `~8` weight-2 Hecke eigenvalues
> attached to a high-rank motive (a surface with many elliptic quotients).  Over
> `ℚ`, the `L`-function is a product of `GL(2)` `L`-functions, and the missing
> object for the twin problem is the same product.

---

## 4. Honest verdict

* **Target B — structure only.** Vanishing, Gaussian integrality, evenness, and
  the exact decomposition; no closed form.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **Fit `c₄/(2q)` to a sum of Hecke eigenvalues** (if a basis is available).
2. **The `d=5` quotient** structure.
3. **A synthesis note.**

---

## 6. Reproduction

```
python3 checks/round72_c4_synthesis.py   # exit 0
```

New files: `checks/round72_c4_synthesis.py`.
