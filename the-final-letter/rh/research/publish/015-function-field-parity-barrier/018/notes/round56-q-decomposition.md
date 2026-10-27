# Round 56 — the `a₂≠0` composition size decomposes

Round 1 of the aggressive goal (no round limit).  Target (A1) is now
**decomposed** into two computable image counts, one of which is a new lemma.

---

## 1. The decomposition

For `a₁ = 0, a₂ ≠ 0`, `Q = Q₀ ∪ Q₁` with

```
Q₀ = { q(a₂−q) }              (p = 0),
Q₁ = { ((a₂+p²)/2)² : p ≠ 0 }  (p ≠ 0).
```

| `q` | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 37 | 41 | 43 | 47 | 53 | 59 | 61 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `\|Q₀\|` | 4 | 6 | 7 | 9 | 10 | 12 | 15 | 16 | 19 | 21 | 22 | 24 | 27 | 30 | 31 |
| `\|Q₁\Q₀\|` | 1 | 2 | 3 | 4 | 4 | 5 | 7 | 7 | 9 | 10 | 10 | 11 | 13 | 14 | 15 |
| `⌊(q−1)/4⌋` | 1 | 2 | 3 | 4 | 4 | 5 | 7 | 7 | 9 | 10 | 10 | 11 | 13 | 14 | 15 |

So

```
|Q|  =  |Q₀| + |Q₁ \ Q₀|  =  (q+1)/2 + ⌊(q−1)/4⌋  =  q − ⌊(q+2)/4⌋ .
```

Verified for **all** `a₂ ≠ 0` at `q = 7..61`.

## 2. The remaining lemma

`|Q₀| = (q+1)/2` is classical (a nondegenerate quadratic image).  The new
content is

> **(Q1)** `|Q₁ \ Q₀| = ⌊(q−1)/4⌋` for every `a₂ ≠ 0`.

**Character-sum form.** Writing `y = (a₂+u)²/4` with `u = p²`:

```
y ∈ Q₁ \ Q₀  ⇔  u ≠ 0 square  and  χ(−u(2a₂+u)) = −1 ,
```

with `y` constant on the involution `u ↦ −u−2a₂`.  So

```
|Q₁ \ Q₀|  =  #{orbits : χ(−u(2a₂+u)) = −1} .
```

The elementary character sum `Σ_p χ(p²+2a₂) = −1` (standard) is the input; the
orbit count then gives `⌊(q−1)/4⌋`.

---

## 3. Wild guess 1 — the orbit count is exact

> **Wild guess 1.** (Q1) is an **exact orbit count**: the character
> `χ(−u(2a₂+u))` is balanced on the `⌊(q−1)/2⌋` square-class orbits, giving
> `⌊(q−1)/4⌋` negative ones.  The proof should be a two-line computation from
> `Σ_p χ(p²+2a₂) = −1` plus the involution `u ↦ −u−2a₂`.  Over `ℚ`, the same
> orbit count is a `GL(2)`-type character sum.

**Evidence.**

* The formula holds for all `a₂ ≠ 0`, `q = 7..61` (`§1`).
* The character sum is classical.
* The involution is explicit (`§2`).

**Why it is a guess.** The orbit count is not carried out.

**What would falsify it.** A prime with `|Q₁\Q₀| ≠ ⌊(q−1)/4⌋`.

---

## 4. Lean — the arithmetic identity

`QSize.size_identity`:

```
q % 2 = 1  →  (q+1)/2 + (q−1)/4 = q − (q+2)/4
```

(`omega`).  Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **(A1) — decomposed, not proved.** `|Q|` is now `|Q₀| + |Q₁\Q₀|`, with
  `|Q₁\Q₀| = ⌊(q−1)/4⌋` the single remaining image count.
* **(A2), (B), (C) — unchanged.**
* **The wild guess:** an exact orbit count from `Σ_p χ(p²+2a₂) = −1`.

## 6. Next round

1. **Prove (Q1)**: the orbit count.
2. **Attack (A2)**: the explicit constant.
3. **Target B**: `c₄` or the `d=5` amplitudes.

---

## 7. Reproduction

```
python3 checks/round56_q_decomposition.py   # exit 0
python3 -m pytest -q tests/test_round56.py   # 4 passed
cd lean && ./check.sh QSize.lean Axioms.lean  # OK
```

New files: `checks/round56_q_decomposition.py`, `tests/test_round56.py`,
`lean/QSize.lean`.
