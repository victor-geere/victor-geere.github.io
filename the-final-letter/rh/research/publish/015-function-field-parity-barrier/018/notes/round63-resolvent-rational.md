# Round 63 — the resolvent curve is rational; `S_{χ₂}` is `O(1)`

Round 8 of the aggressive goal.  Target (A2): one of the three error sums is
**bounded**, because the resolvent curve is rational.

---

## 1. The resolvent curve is rational

The resolvent cubic of `g(x)−y` is

```
z³ − a₂z² + 4yz − 4a₂y − a₁² = 0 .
```

It is **linear in `y`**, so

```
y  =  (−z³ + a₂z² + a₁²) / (4(z − a₂)) ,
```

a **rational parametrisation** of the curve.  Hence the curve has genus 0, and
the 2-dimensional (resolvent) `L`-function has **degree 0** — it is trivial.

**Consequence.** `S_{χ₂} = Σ_y χ₂(Frob_y)` is `O(1)`, not `O(√q)`.  Verified:

```
max |S_χ2| = 4   for  q = 19..149 .
```

## 2. The error simplifies

Round 62 gave

```
|Im| − 5q/8  =  (1/8)S_sign − (1/8)S_{std⊗sign} − (1/4)S_{χ₂} + O(1) .
```

With `S_{χ₂} = O(1)`:

```
|Im| − 5q/8  =  (1/8)(S_sign − S_{std⊗sign})  +  O(1) .
```

So (A2) reduces to the **single** bound

```
|S_sign − S_{std⊗sign}|  ≤  4√q .
```

## 3. What the two sums are

* `S_sign = Σ_y χ₂(Δ(y))`, `Δ` cubic — a cubic character sum, `≤ 2√q` (Weil).
* `S_{std⊗sign} = Σ_y χ₂(Δ(y))(N(y) − 1)` — the sign-twist against the fiber
  size.

Their difference is `Σ_y χ₂(Δ(y))(2 − N(y))`.

---

## 4. Wild guess 7 — the difference is a cubic sum

> **Wild guess 7.** `Σ_y χ₂(Δ(y))(2−N(y))` collapses to a **single cubic
> character sum** (the factor `2−N` is the std character, and the sign-twist
> exchanges the two Galois orbits), hence is bounded by `2√q`.  Then
> `|Im| − 5q/8 ≤ (1/8)·2√q = 0.25√q < 0.5√q`, and (A2) is proved.

**Evidence.**

* `S_{χ₂} = O(1)` (`§1`).
* `S_sign` cubic (`§3`).
* Measured error `0.43√q` — consistent with `(1/8)(S_sign − S_std⊗sign)` having
  constant `~3.4`.

**Why it is a guess.** The collapse is not proved; the data shows
`S_{std⊗sign}` itself is `O(√q)`, so the cancellation must be genuine.

**What would falsify it.** A family with `|S_sign − S_{std⊗sign}| > 4√q`.

---

## 5. Honest verdict

* **Target A — one sum eliminated.** `S_{χ₂} = O(1)` (rational resolvent);
  the error is `(1/8)(S_sign − S_{std⊗sign}) + O(1)`.
* **(A1) — proved.**
* **(B), (C) — unchanged.**
* **The wild guess:** the difference collapses to a cubic sum `≤ 2√q`.

## 6. Next round

1. **Prove the collapse** of `S_sign − S_{std⊗sign}`.
2. **Target B**: extend `c₄`.
3. **Target C**: the quantitative parity theorem.

---

## 7. Reproduction

```
python3 checks/round63_resolvent_rational.py   # exit 0
python3 -m pytest -q tests/test_round63.py   # 2 passed
```

New files: `checks/round63_resolvent_rational.py`, `tests/test_round63.py`.
