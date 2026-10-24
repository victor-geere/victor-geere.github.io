# Round 47 — the base cases of (V′) in Lean

Round 17 of the new goal.  Target A: the finite base of the Chebotarev route is
now partly a **Lean theorem** — the cap at `q = 5,7,11,13,17` is verified by
`decide`.

---

## 1. The Lean theorems

`lean/SmallCap.lean`:

```
cap_five     : ∀ a2 a1 : ZMod 5,  a1 ≠ 0 →  3 ≤ |Im(x⁴+a2x²+a1x)|
cap_seven    : ... ZMod 7 ...              4 ≤ ...
cap_eleven   : ... ZMod 11 ...             6 ≤ ...
cap_thirteen : ... ZMod 13 ...             7 ≤ ...
cap_seventeen: ... ZMod 17 ...             9 ≤ ...
```

Each is a finite check over all `a₂, a₁ ≠ 0` and all `x`, discharged by
`decide`.  In Python the same minima are `3,4,6,7,10`, all `≥` the thresholds.

## 2. Limitations

`q = 19` and `q = 23` **time out** under `decide` (200 000 heartbeats), so they
remain Python checks (minima `10,13`, thresholds `10,12`, no violations).

## 3. What this means for the Chebotarev route

The route (round 44) is:

| range | status |
|---|---|
| `q = 5,7,11,13,17` | **Lean theorem** (`SmallCap`) |
| `q = 19,23` | Python check |
| `q ≥ 25` | explicit Chebotarev with constant `< 0.5` (unproved) |
| `j = 0` | solved (round 33) |

So the finite base is now half-formalized, and the remaining gap is exactly the
explicit constant.

---

## 4. Wild guess 17 — formalize the base, prove the constant

> **Wild guess 17.** The cap is `decide`-able for `q ≤ 17` and needs only the
> explicit Chebotarev constant for `q ≥ 25`; the middle range `19,23` is a
> small computation.  Over `ℚ`, the same split holds: bounded ranges are
> checkable, and the difficulty is entirely in the uniform error term — the
> parity barrier.

**Evidence.**

* The base cases are Lean theorems (`§1`).
* The threshold is `q = 25` (round 45).
* `j=0` is solved (round 33).

**Why it is a guess.** The explicit constant is not proved.

**What would falsify it.** A `q ≤ 17` failure would contradict the Lean theorem
(impossible); an explicit constant `> 0.5` would reopen the large-`q` gap.

---

## 5. Lean — the base cases

`SmallCap.cap_five … cap_seventeen`, five `decide` theorems.  Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Target A — base formalized.** `q ≤ 17` is Lean; `19,23` Python; `q ≥ 25`
  needs the explicit constant.
* **Target B — unchanged.**
* **Target C — unchanged.**
* **The wild guess:** base checkable, uniform error is the barrier.

## 7. Next round

1. **`q=19,23`**: raise heartbeats or restructure to close them in Lean.
2. **The explicit constant**: bound the splitting-type character sums.
3. **Target B**: the `d=5` residual.

---

## 8. Reproduction

```
python3 checks/round47_small_cap.py   # exit 0
python3 -m pytest -q tests/test_round47.py   # 7 passed
cd lean && ./check.sh SmallCap.lean Axioms.lean  # OK
```

New files: `checks/round47_small_cap.py`, `tests/test_round47.py`,
`lean/SmallCap.lean`.
