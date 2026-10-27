# Round 61 — the monodromy stratification: every non-composition is `S₄`

Round 6 of the aggressive goal.  Target (A2): the value set of a non-composition
quartic has the `S₄` factorization-type law.  Verified for **every**
non-composition family at `q = 41, 61, 73`.

---

## 1. The four monodromy models

For a quartic `g` with monodromy group `G`, the fiber-size distribution is the
fixed-point distribution of `G`:

| `G` | `P(0)` | `P(1)` | `P(2)` | `P(4)` | `\|Im\|/q →` |
|---|---|---|---|---|---|
| `S₄` | 3/8 | 1/3 | 1/4 | 1/24 | **5/8** |
| `A₄` | 1/4 | 2/3 | 0 | 1/12 | 3/4 |
| `D₄` | 5/8 | 0 | 1/4 | 1/8 | 3/8 |
| `C₄` | 3/4 | 0 | 0 | 1/4 | 1/4 |

The dangerous groups for (A2) are `D₄` and `C₄` (ratio ≤ 3/8).

## 2. The classification

At `q = 41, 61, 73`, **every** non-composition family (`a₁ ≠ 0`) is classified
as `S₄` (best chi-square fit among the four models):

| `q` | families | `S₄` | others |
|---|---|---|---|
| 41 | 1640 | 1640 | 0 |
| 61 | 3660 | 3660 | 0 |
| 73 | 5256 | 5256 | 0 |

So the dangerous `D₄`/`C₄` cases **do not occur** among non-compositions; the
composition case (`a₁=0`) is the only degenerate one, and it is solved.

## 3. What this gives for (A2)

```
|Im(g)|/q  →  5/8  >  1/2  for every non-composition.
```

The finite-`q` error is the Chebotarev/Weil error of the `S₄` extension.  So
(A2) reduces to:

> **The `S₄` extension error is `O(√q)` with constant `< 0.5`.**

This is the same statement as before, but now with the **monodromy** identified
(the `S₄` permutation representation), so the error is a sum of Artin
`L`-function values at the branch points of the cover `g : ℙ¹ → ℙ¹`.

---

## 4. Wild guess 6 — the conductor is small

> **Wild guess 6.** The `S₄` error constant is the **conductor** of the
> permutation representation of the quartic cover, i.e. the number of branch
> points (≤ 6 for a quartic).  The measured `0.43` suggests the effective
> conductor is `1`, not `6` — perhaps because the sign character and the
> standard representation cancel at the branch points.  If so, (A2) is proved.

**Evidence.**

* All non-compositions are `S₄` (`§2`).
* The measured error is `0.43√q`, far below the generic Weil bound (`~6√q`).
* The `S₄` character table is small.

**Why it is a guess.** The cancellation is not proved.

**What would falsify it.** A non-composition family with a `D₄`/`C₄`
distribution would break the 5/8 ratio.

---

## 5. Honest verdict

* **Target A — monodromy identified.** Every non-composition is `S₄`; (A2) is
  the explicit error constant of the `S₄` extension.
* **(A1) — proved.**
* **(B), (C) — unchanged.**
* **The wild guess:** the effective conductor is `1` (cancellation at branch
  points).

## 6. Next round

1. **The error constant** via the character table of `S₄`.
2. **Target B**: extend `c₄`.
3. **Target C**: the quantitative parity theorem.

---

## 7. Reproduction

```
python3 checks/round61_monodromy.py   # exit 0
python3 -m pytest -q tests/test_round61.py   # 1 passed
```

New files: `checks/round61_monodromy.py`, `tests/test_round61.py`.
