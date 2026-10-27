# Round 65 — the pullback identity, and the genus-2 gap

Round 10 of the aggressive goal.  Target (A2): a new exact identity connects the
twisted sum to a genus-2 curve — but the proved bound is weaker than measured.

---

## 1. The pullback identity

```
Δ(g(x))  =  g'(x)² · S(x) ,
```

with `S` a sextic:

```
S(x) = −16x⁶ − 32a₂x⁴ − 40a₁x³ − 20a₂²x² − 36a₁a₂x − 27a₁² − 4a₂³ .
```

Verified exactly (sympy), and the pullback identity

```
Σ_y χ₂(Δ(y))·N(y)  =  Σ_x χ₂(Δ(g(x)))  =  Σ_x χ₂(S(x))
```

holds numerically (`q = 29,41,61`).

## 2. The discriminant of `S`

```
disc(S)  =  −2²⁹ · a₁² · (27a₁² + 8a₂³)⁴ .
```

So `S` is squarefree off the composition locus `a₁=0` and the
**critical-discriminant locus** `27a₁²+8a₂³ = 0` (where the derivative cubic has
a multiple root).  Genetically the curve `s² = S(x)` has genus 2.

## 3. The consequence

```
S_{std⊗sign}  =  Σ_x χ₂(S(x))  −  S_sign .
```

So the twisted sum is the difference of a **genus-2** character sum and a
**genus-1** one.

**Proved bound:** `|Σ_x χ₂(S)| ≤ 4√q` (genus 2) and `|S_sign| ≤ 2√q` (genus 1),
hence

```
|S_{std⊗sign}|  ≤  6√q .
```

**Measured bound:** `|S_{std⊗sign}| ≤ 1.7√q < 2√q`.

So this round **widens** the proved gap (round 64 assumed `2√q`): the proved
bound `6√q` would give a threshold `q ~ 900`, and a finite check to that bound is
infeasible.

## 4. What would close it

The genus-2 curve `s² = S(x)` maps to the elliptic curve `t² = Δ(y)` by
`(x,s) ↦ (g(x), g'(x)s)`, of degree 4.  If its Jacobian split as `E × E'` with
`E'` elliptic, then `S_{std⊗sign} = −a_{E'}` and the `2√q` bound would follow.
But the map has degree 4 (not 2), so the splitting is not automatic.

---

## 5. Wild guess 9 — the extra endomorphism

> **Wild guess 9.** The genus-2 curve `s² = S(x)` has an **extra endomorphism**
> (because `S` comes from the pullback along the degree-4 map `g`), forcing its
> Jacobian to split as `E × E'` with `E'` elliptic.  Then
> `S_{std⊗sign} = −a_{E'}` and `|S_stdxsign| ≤ 2√q`, closing (A2).

**Evidence.**

* The exact pullback identity (`§1`).
* The measured constant `1.7 < 2` (`§3`).
* The discriminant structure (`§2`).

**Why it is a guess.** The endomorphism is not exhibited.

---

## 6. Honest verdict

* **Target A — a new identity, but the proved bound is `6√q`.** (A2) is **not**
  proved by this route; the empirical `2√q` bound stands.
* **(A1) — proved.**
* **(B), (C) — unchanged.**
* **The wild guess:** the genus-2 Jacobian splits, restoring `2√q`.

## 7. Next round

1. **Exhibit the splitting** of `Jac(s²=S)`.
2. **Target B**: extend `c₄`.
3. **Target C**: the quantitative parity theorem.

---

## 8. Reproduction

```
python3 checks/round65_pullback.py   # exit 0
python3 -m pytest -q tests/test_round65.py   # 2 passed
```

New files: `checks/round65_pullback.py`, `tests/test_round65.py`.
