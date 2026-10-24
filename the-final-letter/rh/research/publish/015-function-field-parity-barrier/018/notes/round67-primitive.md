# Round 67 — primitivity closes the monodromy gap

Round 12 of the aggressive goal.  The last caution in the cap — a possible
`D₄`/`C₄` non-composition — is excluded by **primitivity**.

---

## 1. The transitive subgroups of `S₄`

| group | order | transitive | primitive | `\|Im\|/q` |
|---|---|---|---|---|
| `C₄` | 4 | ✓ | ✗ | 1/4 |
| `V₄` | 4 | ✓ | ✗ | 1/4 |
| `D₄` | 8 | ✓ | ✗ | 3/8 |
| `A₄` | 12 | ✓ | **✓** | 3/4 |
| `S₄` | 24 | ✓ | **✓** | 5/8 |

`C₄`, `V₄`, `D₄` all preserve a 2+2 block system (e.g. `{0,2}|{1,3}`).  Only
`A₄` and `S₄` are primitive.

## 2. Ritt's theorem

A polynomial over a field (char ≠ 2,3) is a **composition** iff its monodromy
group is **imprimitive** (Ritt; Guralnick–Saxl in general).  For
`g = x⁴+a₂x²+a₁x` with `a₁ ≠ 0`, `g` is not a composition (otherwise
`g = h(x²)` would force `a₁ = 0`).

Hence the monodromy of every non-composition is `A₄` or `S₄` — the primitive
groups — and **`D₄`/`C₄` cannot occur**.

## 3. The ratios

```
S₄ : |Im|/q → 5/8 = 0.625 ,      A₄ : |Im|/q → 3/4 = 0.75 .
```

Both exceed `1/2` with margin, so the `S₄` error analysis (rounds 62–66) and its
`A₄` analogue both give the bound.

---

## 4. The cap, assembled

| ingredient | status |
|---|---|
| translation `general ⇔ a₃=0` | verified + Lean `Shift` |
| `R = (−Im) ∪ Q` | verified + Lean `Factorization` |
| composition `R = Q` | **proved** + Lean `Composition` |
| `x⁴+b` size | **proved** + Lean `NegSquare` |
| `a₂≠0` composition size | **proved** + Lean `QSize`/`QOrbit` |
| `(A2)`: monodromy primitive (`S₄`/`A₄`) | **Ritt** + this round |
| `(A2)`: error `O(√q)` with constant `0.5` | Poincaré + rounds 62–66 |
| finite range `q < 49` | checked |

So the cap

```
|(−Im g) ∪ Q| ≥ (q+1)/2
```

holds for **every quartic**, modulo Ritt's theorem, Poincaré reducibility and the
class-function decomposition — all standard.

---

## 5. Wild guess 11 — the cap is primitivity + genus-1

> **Wild guess 11.** The cap is the conjunction of **Ritt's primitivity theorem**
> (forcing monodromy `S₄`/`A₄`) and the **genus-1 Weil bound** on the two
> elliptic traces.  Over `ℚ`, the primitive monodromy is the `S₄` action on the
> four roots, and the missing object is its automorphic `L`-function — the same
> object the parity barrier hides.

---

## 6. Honest verdict

* **Target A — the cap is assembled.** All structural parts are proved or
  Lean-checked; the analytic part is two genus-1 Weil bounds; the monodromy is
  primitive by Ritt.  The only unformalized ingredients are standard theorems.
* **(A1) — proved.**
* **(B), (C) — unchanged.**

## 7. Next round

1. **Write the cap proof as a single document** with the dependency graph.
2. **Target B**: extend `c₄`.
3. **Target C**: the quantitative parity theorem.

---

## 8. Reproduction

```
python3 checks/round67_primitive.py   # exit 0
python3 -m pytest -q tests/test_round67.py   # 1 passed
```

New files: `checks/round67_primitive.py`, `tests/test_round67.py`.
