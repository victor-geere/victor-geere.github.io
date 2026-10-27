# Round 46 — the finite check, and the parity step in Lean

Round 16 of the new goal.  Target A: the finite part of the Chebotarev route is
**complete**.  Target C: the twin indicator is now proved **not** to be a
divisor sum of a multiplicative function.

---

## 1. The finite check of (V′) for `q = 5..23`

| `q` | 5 | 7 | 11 | 13 | 17 | 19 | 23 |
|---|---|---|---|---|---|---|---|
| `min \|Im\|` (a₁≠0) | 3 | 4 | 6 | 7 | 10 | 10 | 13 |
| `(q+1)/2` | 3 | 4 | 6 | 7 | 9 | 10 | 12 |
| violations | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

So the small-`q` range of the Chebotarev route (`q < 25`) is **fully checked**.
Combined with round 44:

* `q ≥ 25`: explicit Chebotarev with constant `< 0.5`;
* `q < 25`: finite check (this round);
* `j = 0`: solved (round 33).

## 2. The `d=5` correction

`25T = q⁵ − N`:

| `q` | 7 | 17 | 37 | 47 |
|---|---|---|---|---|
| `N` | 2807 | 91307 | 1881857 | 4788407 |
| `N/q⁴` | 1.169 | 1.093 | 1.004 | 0.981 |

`N/q⁴ → 1`, so `T = q⁴(q−1)/25 + O(q³)`, but the residual `N − q⁴` is not
polynomial (`406, 7786, 7696, −91274`) — consistent with round 45.

## 3. Target C — the divisor-sum step

`lean/DivisorSum.lean`:

```
zeta_mul_isMult (hg : g.IsMultiplicative) : (zeta * g).IsMultiplicative
twinInd_not_zeta_mul (hg : g.IsMultiplicative) : twinIndAF ≠ zeta * g
```

So **no multiplicative function `g` gives `twinInd = ζ * g`**: the twin
indicator is not a divisor sum with multiplicative weights.  This is a precise
algebraic statement in the direction of the parity barrier: a Selberg-type sieve
weight is a divisor sum, and the twin indicator is not one of this form.

**Caveat.** The theorem excludes *multiplicative* `g`; a general (non-
multiplicative) divisor sum is not excluded.  The parity barrier proper is the
statement about **all** finite sieve weights, which this theorem does not reach.

---

## 4. Wild guess 16 — the finite/small-`q` split is the whole gap

> **Wild guess 16.** The cap is now the explicit Chebotarev constant alone: the
> finite range is checked, `j=0` is solved, and only the numerical size of the
> Weil error for `S₄` splitting types (measured `< 0.5`) is unproved.  Over
> `ℚ`, the same split appears: the "small" cases are handled by hand and the
> "large" cases need the error term — which is the parity barrier.

**Evidence.**

* The finite range is clean (`§1`).
* The measured constant is `0.43` (round 44).
* `j=0` is solved (round 33).

**Why it is a guess.** The explicit constant is not proved.

**What would falsify it.** An explicit Chebotarev constant `> 0.5` for these
character sums would reopen the gap.

---

## 5. Lean — the divisor-sum theorem

`DivisorSum.zeta_mul_isMult` and `DivisorSum.twinInd_not_zeta_mul`, on
`ArithmeticFunction ℕ` (Dirichlet convolution).  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — finite part complete.** The Chebotarev route needs only the
  explicit constant.
* **Target B — correction identified.** `T = q⁴(q−1)/25 + O(q³)`, non-polynomial
  residual.
* **Target C — one algebraic step.** The twin indicator is not a multiplicative
  divisor sum.  The full parity barrier is not reached.
* **The wild guess:** the gap is the explicit Chebotarev constant.

## 7. Next round

1. **The explicit constant**: bound the `S₄` splitting-type character sums.
2. **The full parity statement**: extend the divisor-sum theorem to
   non-multiplicative weights with bounded support.
3. **Target B**: the `d=5` residual.

---

## 8. Reproduction

```
python3 checks/round46_finite_parity.py   # exit 0
python3 -m pytest -q tests/test_round46.py   # 8 passed
cd lean && ./check.sh DivisorSum.lean Axioms.lean  # OK
```

New files: `checks/round46_finite_parity.py`, `tests/test_round46.py`,
`lean/DivisorSum.lean`.
