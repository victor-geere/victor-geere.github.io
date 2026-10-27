# Round 19 — one-point versus two-point statistics

Rounds 13–18 studied `max_a I(a)`, the maximum number of irreducibles in a
constant-shift family. This round makes explicit that this is a **one-point**
statistic, while the twin count `T(d;q,2)` is a **two-point** statistic, and
that the gap between them is the concrete form of the 2-D Chebotarev vs 1-D
zeros separation.

---

## 1. Established direction — the table

`checks/round19_one_two_point.py` §[A]:

| `d` | `q` | `T(d;q,2)` | `A_d(q)` (avg) | `max I` | `Σ I(I−1)` |
|---|---|---|---|---|---|
| 3 | 5 | 10 | 10.00 | 2 | 40 |
| 3 | 7 | 35 | 28.00 | 4 | 168 |
| 3 | 11 | 132 | 132.00 | 4 | 1320 |
| 3 | 13 | 247 | 216.67 | 8 | 2600 |
| 4 | 5 | 20 | 22.50 | 2 | 90 |
| 4 | 7 | 112 | 112.00 | 3 | 672 |
| 4 | 11 | 792 | 792.00 | 5 | 7920 |
| 4 | 13 | 1534 | 1592.50 | 6 | 19110 |
| 5 | 5 | 98 | 98.00 | 4 | 392 |
| 5 | 7 | 560 | 560.00 | 4 | 3360 |
| 5 | 11 | 6006 | 5891.60 | 8 | 58916 |
| 5 | 13 | 13676 | 13676.00 | 6 | 164112 |

The second-moment identity is exact (`§[B]`):

```
Σ_{h≠0} T(d;q,h) = Σ_a I(a)(I(a) − 1) ,
```

verified for `d = 3,4,5` and `q = 5,7,11,13`.

**Reading the table.**

* `max_a I(a)` is `O(q)` — a per-family maximum (one-point).
* `T(d;q,2)` is `O(q^d)` — a count of pairs `(f, f+2)` across all families
  (two-point).
* When `d ∤ q−1` (so the twist characters are trivial) the individual `T` equals
  the average `A_d`: `d=3, q=5,11`; `d=4, q=7,11`; `d=5, q=5,7,13`. When the
  character is non-trivial (`d=3, q=7,13`; `d=4, q=5,13`; `d=5, q=11`), the
  individual shifts away from the average.

So the **average** of `T` over `h` is the second moment of the one-point
distribution; the **individual** `h = 2` is a two-point correlation that the
one-point distribution does not determine.

---

## 2. The concrete separation

This is the sharpest form of the round-3 separation:

* the **one-point** data (the family distribution `I(a)`) is a sieve/cohomology
  quantity, computable from the geometry of `V_d`;
* the **two-point** data (`T(d;q,2)`) is a correlation and requires the full
  character sum / the Fourier analysis over the shift.

The second-moment identity is the exact bridge: it says the *average* of the
two-point count is the second moment of the one-point count. It says nothing
about a single `h`.

## 3. Wild guess 19 — the one-point/two-point gap

> **Wild guess 19.** The parity barrier is the **one-point/two-point gap**. A
> sieve (or a cohomological computation) controls one-point statistics — the
> family maximum, the average, the singular series. The twin count at a fixed
> shift is a two-point correlation; no one-point input determines it. Over `ℚ`,
> this is exactly Selberg's parity principle: the sieve controls the one-point
> density but cannot see the two-point correlation that distinguishes `n` from
> `n+2`. The solution would be a genuine two-point input (a Kloosterman/Type-II
> estimate, or an automorphic correlation) — not a refinement of the one-point
> sieve.

**Evidence.**

* The second-moment identity: the one-point second moment is the *average* of
  the two-point count, not its individual values.
* The table shows the individual `T(2)` departing from `A_d` exactly when the
  twist characters are non-trivial.
* Rounds 3–18: every exact formula we found (`d ≤ 4`) was a one-point or
  averaged statement; the open problem is the individual shift.

**Why it is a guess.** It is a diagnosis, not a construction: it says where the
barrier is, not how to cross it. The identification with Selberg's parity
principle is an analogy.

**What would falsify it.** A proof of the twin conjecture from one-point data
alone (e.g. a purely cohomological computation of `T(d;q,2)`) would show the
gap is not fundamental.

---

## 4. Lean — shift independence at `𝔽₅`

`lean/Cubic.lean` now proves

```
cubicTwin5_shift_independent : ∀ h ≠ 0, cubicTwin5h h = 10
```

over `𝔽₅`: for `q ≡ 2 (mod 3)` every nonzero shift gives the same degree-3 twin
count. This is the `d=3, q=5` row of the table, and a finite instance of the
"trivial character ⟹ individual = average" phenomenon. Footprint
`[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the table of `T`, `A_d`, `max I`, second moments;
  the exact second-moment identity for `d=3,4,5`; the one-point/two-point
  reading; Lean shift-independence at `q=5`.
* **The wild guess:** the barrier is the one-point/two-point gap. Coherent,
  supported by the second-moment identity and the whole programme, but a
  diagnosis rather than a method.
* **Not claimed:** that two-point inputs are sufficient; that no one-point
  refinement can help; any new bound on `T(2)`.

## 6. Next round

1. **A two-point input**: compute a genuine two-point correlation (e.g. the
   variance of `T(h)` over `h`) and compare it to the one-point prediction.
2. **The `d=4` cap**: one last attempt at `|Im ∪ Q| ≥ (q+1)/2` via the
   quadratic-factor parametrization.
3. **Wild guess 20 (preview).** *The two-point input is a **Kloosterman sum**:
   the deviation of `T(d;q,2)` from its average is a sum of Kloosterman sums
   `Kl(2; q)`, and the parity barrier is the failure of the Weil bound to give
   the right main term.* Investigate: fit the deviations `T(d;q,2) − A_d(q)`
   against Kloosterman sums.

---

## 7. Reproduction

```
python3 checks/round19_one_two_point.py   # exit 0
python3 -m pytest -q tests/               # 307 passed
cd lean && ./check.sh Cubic.lean Axioms.lean   # OK
```

New files this round: `checks/round19_one_two_point.py`,
`tests/test_round19.py`, and the `cubicTwin5_shift_independent` theorem in
`lean/Cubic.lean`.
