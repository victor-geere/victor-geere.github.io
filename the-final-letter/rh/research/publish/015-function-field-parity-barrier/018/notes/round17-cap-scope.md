# Round 17 — the `(q−1)/2` cap is special to `d = 4`

Rounds 13–16 read the cap `I(a) ≤ (q−1)/2` as a "`d ≤ 4` good / `d ≥ 5` bad"
dichotomy. This round **corrects that**: at `d = 3` the count already exceeds
the cap. The cap is a `d = 4` phenomenon, not a low-degree one.

---

## 1. Established direction — the exact `d = 3` family maximum

For `d = 3`, a cubic is reducible iff it has a root, so `I(a) = q − |Im(g_a)|`.
The minimal value set of a cubic is known, and the maximum is exactly:

| `q mod 3` | `max I` | extremal `g` |
|---|---|---|
| `1` | `(2q−2)/3` | `x³` (image size `(q+2)/3`) |
| `2` | `(q+1)/3` | `x³ − x` (image size `(2q−1)/3`) |

Verified exactly for `q = 5,7,11,13,17,19,23,29,31,37` (`checks/round17_cap_scope.py`
§[A]). For `q ≡ 1 (mod 3)`,

```
(2q−2)/3 > (q−1)/2      (q > 1) ,
```

so **the cap fails at `d = 3`**. Example: `q = 13`, `max I = 8 > 6 = (q−1)/2`.

## 2. The corrected scope

| `d` | `max I` vs `(q−1)/2` | mechanism |
|---|---|---|
| 2 | `=` (equality) | uniform: `I = (q−1)/2` |
| 3 | `(2q−2)/3 >` for `q≡1 (mod 3)` | `x³` has small image |
| 4 | `≤` (for `q ≤ 23`) | quadratic-factor set `Q` compensates |
| 5,6,7 | `>` | Artin-Schreier / power collapse |

So the correct statement is not "`d ≤ 4`" but **"`d = 4`"**: the quartic's
quadratic-factor set is large enough to compensate for its value set, while at
`d = 3` there is no such compensation (only a linear factor) and at `d ≥ 5` the
collapse is too strong.

## 3. `d = 8, 9`

The null-polynomial collapse persists:

| `d` | `q` | `max I` | `|Im(g)|` | `q − I` |
|---|---|---|---|---|
| 8 | 5 | 4 | 1 | 1 |
| 9 | 5 | 4 | 1 | 1 |

`x^{d−q}(x^q−x)` is again the extremal family.

---

## 4. Wild guess 17 — the compensation guess

> **Wild guess 17.** The family maximum is a **sieve-dimension** quantity:
> `max I = q − (size of the union of the available factor conditions)`. At
> `d = 3` only the linear condition exists, so `max I = q − min|Im(cubic)|`,
> giving `(2q−2)/3` or `(q+1)/3`. At `d = 4` the quadratic condition `Q`
> **compensates** the value set and caps the maximum at `(q−1)/2`. At `d ≥ 5`
> the factor sets are too small (Artin-Schreier/power collapse), so the maximum
> exceeds `(q−1)/2`. Over `ℚ`, the "compensation" is the extra sieve factor that
> Selberg's parity principle forbids: without it, the parity barrier is exactly
> the failure of `Q`-compensation.

**Evidence.**

* The exact `d=3` formulas (`§1`) show the linear-only case.
* The `d=4` cap is tight for `q ≤ 19` (`§2`), with `Q` filling the gap.
* The `d ≥ 5` collapse (`§3`, rounds 15–16) shows what happens when the factor
  sets shrink.

**Why it is a guess.** There is no proof that `Q`-compensation is the mechanism
at `d=4`; it is inferred from the equality cases. The `ℚ` identification with
Selberg's parity principle is an analogy.

**What would falsify it.** A `d=4` family with `I > (q−1)/2` (none for `q ≤ 23`)
would break the compensation reading; a proof that the `d=4` cap follows from a
single character sum would undercut the "factor-set compensation" picture.

---

## 5. Lean — the `d = 3` distribution at `𝔽₇`

`lean/Distribution.lean` now proves

```
cubic_fam_dist_seven :
  #{families with I = 2} = 42  ∧  #{families with I = 4} = 7
```

over `𝔽₇`, i.e. `max I = 4 > 3 = (q−1)/2`. This is a finite Lean witness of the
cap failure at `d = 3`. Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 6. Honest verdict

* **Established this round:** the exact `d=3` family maximum `(2q−2)/3` /
  `(q+1)/3`; the **correction** that the cap is `d=4`-specific (it fails at
  `d=3` for `q≡1 mod 3`); the `d=8,9` collapse; the Lean `d=3` witness at
  `q=7`.
* **The wild guess:** the cap is `Q`-compensation at `d=4`; the `ℚ` analogue is
  the missing sieve factor. Coherent, supported by the exact `d=3` formulas,
  unproved at `d=4`.
* **Not claimed:** a proof of `Q`-compensation; that the cap is the right object
  for the twin problem (it is a family-maximum statement, not a statement about
  the individual `h=2` count).

## 7. Next round

1. **Prove `Q`-compensation at `d=4`**: `|Im ∪ Q| ≥ (q+1)/2` for every quartic.
2. **`d=3` in the twin count**: the individual `T(3;q,2)` is *not* the family
   maximum; clarify the relation between `max_a I(a)` and `T(d;q,2)`.
3. **Wild guess 18 (preview).** *The compensation at `d=4` is a **quadratic
   resolvent** phenomenon: the quartic's resolvent cubic has a root exactly on
   the compensating set. Over `ℚ`, the analogue is the resolvent field, and the
   parity barrier is the failure of the resolvent to control the local
   densities.* Investigate: compute the resolvent cubic and its value set.

---

## 8. Reproduction

```
python3 checks/round17_cap_scope.py   # exit 0
python3 -m pytest -q tests/           # 292 passed
cd lean && ./check.sh Distribution.lean Axioms.lean   # OK
```

New files this round: `checks/round17_cap_scope.py`, `tests/test_round17.py`,
and the `CubicDistributionSeven` section of `lean/Distribution.lean`.
