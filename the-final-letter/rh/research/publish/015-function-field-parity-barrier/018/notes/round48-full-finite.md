# Round 48 — the finite base is complete in Lean

Round 18 of the new goal.  Target A: the **entire finite base** of the
Chebotarev route, `q = 5..23`, is now a Lean theorem.  The cap is one explicit
constant away from a proof.

---

## 1. All seven primes in Lean

Rewriting the `decide` computation with `Finset.image` (instead of a filtered
existential) made `q = 19, 23` feasible:

| `q` | 5 | 7 | 11 | 13 | 17 | 19 | 23 |
|---|---|---|---|---|---|---|---|
| threshold | 3 | 4 | 6 | 7 | 9 | 10 | 12 |
| `min \|Im\|` (Python) | 3 | 4 | 6 | 7 | 10 | 10 | 13 |
| Lean | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `decide` time | — | — | — | — | — | 13s | 24s |

`lean/SmallCap.lean` now proves `cap_five … cap_twentythree`:

```
∀ a2 a1 : ZMod q, a1 ≠ 0 → (q+1)/2 ≤ |Im(x⁴ + a2x² + a1x)| .
```

## 2. The Chebotarev route status

| range | status |
|---|---|
| `q = 5..23` | **Lean theorem** (`SmallCap`) |
| `j = 0` | solved (round 33) |
| `q ≥ 25` | explicit Chebotarev, constant `< 0.5` — **unproved** |

So the cap has exactly **one** unproved input: the explicit error constant for
the `S₄` splitting-type character sums.

---

## 3. Wild guess 18 — one constant away

> **Wild guess 18.** The `d=4` cap is now *one explicit constant* from a proof:
> `|Im| = 5q/8 + O(√q)` with constant `< 0.5`, plus the Lean finite base and
> the solved `j=0` case.  The constant is a Weil bound for the splitting-type
> character sums of the quartic family.  Over `ℚ`, the same structure: the
> finite part is formalizable, the uniform error is the parity barrier.

**Evidence.**

* The finite base is a Lean theorem (`§1`).
* The measured constant is `0.43` (round 44).
* `j=0` is solved (round 33).

**Why it is a guess.** The explicit constant is not proved.

**What would falsify it.** An explicit constant `> 0.5` would reopen the gap.

---

## 4. Lean — the finite base

`SmallCap.cap_five … cap_twentythree`, seven `decide` theorems on
`Finset.image`.  Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Target A — finite base complete in Lean.** Only the explicit constant
  remains.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** one constant away; that constant is the barrier's shadow.

## 6. Next round

1. **The explicit constant**: attempt a Weil-type bound on the splitting-type
   sums.
2. **Target B**: the `d=5` residual.
3. **Target C**: extend the divisor-sum theorem.

---

## 7. Reproduction

```
python3 checks/round48_full_finite.py   # exit 0
python3 -m pytest -q tests/test_round48.py   # 7 passed
cd lean && ./check.sh SmallCap.lean Axioms.lean  # OK
```

New files: `checks/round48_full_finite.py`, `tests/test_round48.py`;
`lean/SmallCap.lean` extended to all seven primes.
