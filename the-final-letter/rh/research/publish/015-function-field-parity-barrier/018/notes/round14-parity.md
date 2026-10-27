# Round 14 — the `d = 4` cap is a sieve-union bound

Round 13 observed `max I(a) = (q−1)/2`. This round identifies the mechanism:
the reducible `b`'s are the **union of two sieve conditions**, and the cap is the
statement that this union always has at least half the residues.

---

## 1. Established direction — the union decomposition

For `a = (a_3,a_2,a_1)` put

```
g_a(x) = x^4 + a_3 x^3 + a_2 x^2 + a_1 x ,
Im(a)  = g_a(𝔽_q) ,
Q(a)   = { b : g_a + b has a quadratic factor } .
```

Then `g_a + b` is reducible iff `b ∈ Im(a) ∪ Q(a)` (a linear or a quadratic
factor), so

```
I(a) = q − |Im(a) ∪ Q(a)| .
```

The cap `I(a) ≤ (q−1)/2` is therefore exactly

```
|Im(a) ∪ Q(a)|  ≥  (q+1)/2      for every a .
```

### The joint distribution

`checks/round14_parity.py` §[A] tabulates `(q − |Im(a)|, I(a))` for `q = 5,7,11,13`.
The union bound `q − I ≥ (q+1)/2` **holds with equality for every extremal
family** (§[B]):

| `q` | `max I` | `(q−1)/2` | `min |Im ∪ Q|` | `(q+1)/2` |
|---|---|---|---|---|
| 5 | 2 | 2 | 3 | 3 |
| 7 | 3 | 3 | 4 | 4 |
| 11 | 5 | 5 | 6 | 6 |
| 13 | 6 | 6 | 7 | 7 |

Two ways equality is attained:

* `q = 11`: 110 families with `|Im(a)| = 6 = (q+1)/2` and `Q(a) ⊆ Im(a)`
  (no-root `b`'s are all irreducible);
* `q = 13`: 13 families with `|Im(a)| = 4` and `|Q(a) \ Im(a)| = 3`, so the
  quadratic condition fills the gap to `7`.

## 2. Honest test of the "character" reading

Round 13's preview suggested the extremal set is a quadratic-character class
`{b : χ(P(b)) = −1}`. Tested explicitly (`§[C]`):

| `q` | extremal families | with a quadratic-character description |
|---|---|---|
| 5 | 45 | 45 |
| 7 | 70 | 70 |
| 11 | 110 | **0** |
| 13 | 65 | **13** |

So the character reading is a **small-`q` coincidence**, not the general
mechanism. The general mechanism is the union bound.

---

## 3. Wild guess 14 — the sieve-parity bound

> **Wild guess 14.** The `d=4` cap `(q−1)/2` is the **sieve-parity bound**: the
> reducible `b`'s are the union of the linear condition (`Im(a)`) and the
> quadratic condition (`Q(a)`), and a two-condition sieve cannot have density
> below `1/2`. Hence the irreducibles have density at most `1/2`, and the cap is
> the function-field shadow of **Selberg's parity principle**. Over `ℚ`, the
> twin problem asks for a density below `1/2` (the twin constant is `≈0.66` of
> the naive `1/2`), so crossing the cap is exactly crossing the parity barrier.

**Evidence.**

* The union bound holds with equality in every case tested (`§[B]`).
* The extremal families are exactly those where the two conditions overlap
  maximally.
* The character reading fails at `q = 11,13`, so the bound is genuinely a
  *union* bound, not a single character sum.

**Why it is a guess.** The union bound `|Im ∪ Q| ≥ (q+1)/2` is observed for
`q ≤ 13`, not proved. The identification with Selberg's parity principle is an
analogy, not a theorem: the function-field sieve and the `ℚ` sieve are different
objects.

**What would falsify it.** A family with `|Im ∪ Q| < (q+1)/2` (i.e. `I > (q−1)/2`)
would break the cap; a proof that the cap follows from a *single* character sum
would undercut the union-bound reading.

---

## 4. Lean — the degree-3 distribution

`lean/Distribution.lean` now also proves, over `𝔽₅`:

```
cubic_fam_dist_five : #{families with I=0} = 5  ∧  #{families with I=2} = 20
sum_cubic_fam_five  : Σ_{families} I(I−1) = 40
```

The second is the degree-3 shift average at `q=5` (matching the exact
Bary-Soroker–Stix value `10` per shift).  Both are finite checks; footprints
`[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Established this round:** the union decomposition `I = q − |Im ∪ Q|`; the
  union bound with equality at the extremal families; the failure of the
  character reading at `q = 11,13`; the `d=3` distribution in Lean.
* **The wild guess:** the cap is the sieve-parity bound. Supported by the union
  structure and the extremal overlap, but the bound itself is unproved and the
  `ℚ` analogy is loose.
* **Not claimed:** a proof of `|Im ∪ Q| ≥ (q+1)/2`; that Selberg's parity
  principle is literally the same mechanism; any `d ≥ 5` analogue.

## 6. Next round

1. **Prove the union bound** for `d = 4`: show `|Im(a) ∪ Q(a)| ≥ (q+1)/2` for
   every quartic `g_a`, perhaps by bounding `|Q(a) \ Im(a)|` below when
   `|Im(a)|` is small.
2. **The `d = 5` analogue**: compute `Im ∪ Q` for quintics and see whether the
   union bound fails (matching `max I > (q−1)/2`).
3. **Wild guess 15 (preview).** *The union bound is the function-field
   incarnation of the parity problem: a two-condition sieve has density ≥ 1/2,
   and the twin constant `0.660…` is the first case where the density dips below
   `1/2`. Over `ℚ`, the "extra" below `1/2` must come from a condition not in
   the sieve — a Type-II / Kloosterman input.* Investigate: compute the
   `d`-dependence of the extremal density for `d = 4,5,6`.

---

## 7. Reproduction

```
python3 checks/round14_parity.py   # exit 0
python3 -m pytest -q tests/        # 258 passed
cd lean && ./check.sh Distribution.lean Axioms.lean   # OK
```

New files this round: `checks/round14_parity.py`, `tests/test_round14.py`, and
the `CubicDistribution` section of `lean/Distribution.lean`.
