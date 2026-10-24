# Round 44 — the Chebotarev route to (V′)

Round 14 of the new goal.  (V′) now has a **proof strategy**: the explicit
Chebotarev main term `5q/8` clears the cap `(q+1)/2` by more than the Weil error
for `q ≥ 25`, leaving a finite check.

---

## 1. The main term at the extremisers

| `q` | 13 | 17 | 19 | 29 | 31 | 37 | 41 | 43 | 47 | 53 | 59 | 61 | 67 | 71 | 73 | 79 | 83 | 89 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `dev/√q` | −.31 | .09 | −.43 | .16 | −.07 | −.19 | .06 | −.29 | .09 | .12 | .02 | −.14 | −.35 | −.40 | −.31 | −.38 | −.32 | −.28 |

`max |dev|/√q = 0.430`, so numerically

```
|Im(g)|  =  5q/8 + O(√q),      constant < 0.5 .
```

## 2. The threshold

`5q/8 − 0.5√q > (q+1)/2` first holds at `q = 25` (`13.12 > 13.00`), and holds for
all larger `q`.  So:

* **`q ≥ 25`**: the Chebotarev main term plus a `0.5√q` error proves (V′);
* **`q < 25`**: a finite check (already done for `q = 5..23`).

## 3. The proof strategy

> **(Chebotarev route.)** For a quartic `g` whose `g(x)−y` has Galois group `S₄`
> over `𝔽_q(y)`, the splitting-type count is
> `#{y : g(x)=y has a root} = 5q/8 + O(√q)`
> by the explicit Chebotarev/Weil bound for the associated character sums.  For
> `q ≥ 25` this exceeds `(q+1)/2`.  The remaining `q < 25` are checked, and the
> `j=0` composition case is solved separately (round 33).

This is the first route that would **prove** the cap (given the explicit error
constant), as opposed to reducing it to another empirical statement.

## 4. Caveats

* The explicit Chebotarev constant is **not established** here: only the
  numerical value `0.43` is measured.
* The Galois group must be `S₄`; the `j=0` case (composition) is excluded and
  solved.
* The `O(√q)` error is a Weil bound for the splitting-type character sums; its
  precise form is the content of the effective Chebotarev theorem.

---

## 5. Wild guess 14 — the Chebotarev theorem is the cap

> **Wild guess 14.** The cap *is* the explicit Chebotarev theorem for `S₄`
> splitting types: `|Im| = 5q/8 + O(√q)`, and the constant in the error is small
> enough (`< 0.5`) that the cap clears for `q ≥ 25`.  Over `ℚ`, the analogue is
> that the splitting types are equidistributed with `S₄` — the missing input is
> the **error term** for a fixed `y`-family, which is the parity barrier.

**Evidence.**

* `|Im| = 5q/8 + O(√q)` with constant `0.43` (`§1`).
* The threshold `q ≥ 25` (`§2`).
* The `S₄` law fits at every `j ≠ 0` (round 42).

**Why it is a guess.** The explicit constant is not proved; the `ℚ` reading is
an analogy.

**What would falsify it.** A family with `dev/√q → ` a constant `> 0.5` would
break the route; an explicit Chebotarev constant `> 0.5` would too.

---

## 6. Lean — the main-term implication

`lean/Chebotarev.lean`:

```
cap_from_main_term (hm : 5q/8 - C√q ≤ m) (h : C√q + 1/2 < q/8) : (q+1)/2 < m
s4_density, s4_ratio, s4_margin
```

The arithmetic core of the route: main term plus error bound gives the cap.
Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 7. Honest verdict

* **Target A — a proof strategy.** (V′) ⇐ explicit Chebotarev with constant
  `< 0.5` and `q ≥ 25`, plus a finite check.  The constant is not proved.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** the cap *is* the explicit Chebotarev theorem.

## 8. Next round

1. **The explicit constant**: derive a bound on the splitting-type character
   sums for `q < 25` and check the finite range.
2. **The `S₄` character sums**: write the splitting-type indicator as a linear
   combination of permutation characters.
3. **Target B**: the `d=5` coordinates.

---

## 9. Reproduction

```
python3 checks/round44_chebotarev.py   # exit 0
python3 -m pytest -q tests/test_round44.py   # 2 passed
cd lean && ./check.sh Chebotarev.lean Axioms.lean  # OK
```

New files: `checks/round44_chebotarev.py`, `tests/test_round44.py`,
`lean/Chebotarev.lean`.
