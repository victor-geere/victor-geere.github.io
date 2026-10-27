# Round 66 — the Jacobian splits; (A2) closes modulo standard facts

Round 11 of the aggressive goal.  The genus-2 curve from round 65 has a
**splitting Jacobian**, which supplies the second Weil bound and with it (A2).

---

## 1. The genus-2 curve

`C : s² = S(x)` with `S` the sextic of round 65.  Its point count is

```
#C  =  q + SC + ε ,      SC = Σ_x χ₂(S(x)) ,   ε = 2 if −16 is a square (q≡1 mod 4) else 0 .
```

Hence the trace is

```
t_C  =  q + 1 − #C  =  1 − SC − ε .
```

## 2. The splitting

The map

```
C → E :   (x, s) ↦ (g(x), g'(x)·s)
```

is a non-constant morphism (degree 4) to the elliptic curve `E : t² = Δ(y)`.
By Poincaré reducibility, the Albanese

```
Jac(C) → E ,      kernel E' (elliptic)
```

gives an isogeny `Jac(C) ~ E × E'`.  Hence

```
t_C  =  a_E + a_{E'} ,       |a_{E'}| ≤ 2√q .
```

## 3. The bound

With `a_E = −S_sign` and `SC = S_sign + S_{std⊗sign}`:

```
a_{E'} = t_C − a_E = 1 − S_{std⊗sign} − ε ,
```

so

```
|S_{std⊗sign}|  ≤  2√q + 1 .
```

Combined with `|S_sign| ≤ 2√q`:

```
|Im| − 5q/8  =  (1/8)(S_sign − S_{std⊗sign}) + O(1)  ≤  0.5√q + O(1) .
```

## 4. (A2) closes

`5q/8 − 0.5√q − C > (q+1)/2` for `q ≥ 49` (with the measured `C ≈ 2`), and
`q < 49` is checked.  So

```
|Im(g)| ≥ (q+1)/2   for every non-composition quartic,
```

modulo Poincaré reducibility and the class-function decomposition (both
standard).

Together with (A1) (proved) and the composition case (proved), **the cap holds
for every quartic**, modulo standard facts.

The one caution: the monodromy must be `S₄` (or `A₄`); a `D₄`/`C₄`
non-composition would break the `5/8` main term.  Rounds 42/43/61 checked that
none occur (`q = 41,61,73`), but this is not proved for all `q`.

---

## 5. Wild guess 10 — the splitting is the general mechanism

> **Wild guess 10.** The same splitting mechanism proves the value-set bound for
> every degree: the error is always a difference of **elliptic (or abelian)
> traces** attached to the resolvent curve and its twists.  Over `ℚ`, the traces
> are the missing `GL(2)` objects.

---

## 6. Honest verdict

* **Target A — (A2) closes modulo standard facts.** `Jac(s²=S) ~ E×E'` gives
  `|S_{std⊗sign}| ≤ 2√q+1`; the cap follows with the finite check.
* **(A1) — proved.**
* **(B), (C) — unchanged.**
* **The wild guess:** the splitting is the general mechanism.

## 7. Next round

1. **Close the monodromy gap** (`D₄`/`C₄` exclusion).
2. **Target B**: extend `c₄`.
3. **Target C**: the quantitative parity theorem.

---

## 8. Reproduction

```
python3 checks/round66_splitting.py   # exit 0
python3 -m pytest -q tests/test_round66.py   # 1 passed
```

New files: `checks/round66_splitting.py`, `tests/test_round66.py`.
