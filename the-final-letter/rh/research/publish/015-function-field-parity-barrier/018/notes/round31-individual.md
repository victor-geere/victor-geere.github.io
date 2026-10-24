# Round 31 — the individual `d=4` count, and the cap at larger `q`

First round of the new goal (targets: **A** the general `d=4` cap, **B** the
individual `T(d;q,2)` for `d ≥ 4`, **C** any rigorous step over `ℚ`).  This
round advances A and B.

---

## 1. Target A — the cap at `q = 47, 53, 59, 61`

| `q` | 47 | 53 | 59 | 61 |
|---|---|---|---|---|
| `max I` | 17 | 26 | 21 | 30 |
| `(q−1)/2` | 23 | 26 | 29 | 30 |
| cap | ✓ | ✓ | ✓ | ✓ |
| tight | ✗ | ✓ | ✗ | ✓ |

The cap now holds for **16 primes** (`5 … 61`); it is tight at
`q = 5,7,11,13,17,19,29,37,41,53,61` and slack at `q = 23,31,43,47,59`.

## 2. Target B — the exact individual `d=4` count

Writing `c_4` for the quartic multiplicative-Fourier coefficient
(`k = (q−1)/4`), the exact decomposition is

```
T(4;q,2) = A_4(q) + B_4(q)·χ₂(2) + 2 Re(c_4(q)·χ₄(2)) .
```

The **quartic term vanishes unless `q ≡ 1 (mod 8)`**:

| `q` | 5 | 7 | 11 | 13 | 17 | 19 | 23 | 29 | 31 | 37 | 41 | 53 | 61 | 73 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| `q mod 8` | 5 | 7 | 3 | 5 | 1 | 3 | 7 | 5 | 7 | 5 | 1 | 5 | 5 | 1 |
| quartic residual | 0 | 0 | 0 | 0 | −68 | 0 | 0 | 0 | 0 | 0 | −3280 | 0 | 0 | −7884 |

**Exact coefficients** (`checks/round31_individual.py` §[C]):

| `q` | `c_4` | `c_4/q` | `2 Re(c_4 χ₄(2))` |
|---|---|---|---|
| 17 | `34 + 170i` | `2 + 10i` | −68 |
| 41 | `1640 + 410i` | `40 + 10i` | −3280 |
| 73 | `−3942 + 292i` | `−54 + 4i` | −7884 |

So `|c_4| ~ q^{3/2}` (e.g. `|c_4(73)| ≈ 3953 ≈ 6.3·73^{3/2}`): the quartic
coefficient is a **weight-3** object, not a character value.

---

## 3. Wild guess 1 — the weight-3 quartic twist

> **Wild guess 1.** The quartic coefficient `c_4(q)` is the trace of a
> **weight-3 motive** (a quartic twist of the quartic family), of size
> `O(q^{3/2})`.  The individual count is exactly
> `A_4 + B_4χ₂(2) + 2Re(c_4χ₄(2))`, and the general cap follows from a Weil-type
> bound on `|Im ∪ Q|` obtained from this decomposition: the value set and the
> quadratic-factor set each contribute a main term, and the quartic twist is the
> `O(√q)` correction.  Over `ℚ`, the quartic twist is the
> `GL(2)×GL(2)`-type object whose `L`-function is missing — the barrier.

**Evidence.**

* The exact decomposition, verified at 14 primes (`§2`).
* The weight-3 growth `|c_4| ~ q^{3/2}` (`§2`).
* The cap holds and is tight exactly where the cusp dominates (`§1`).

**Why it is a guess.** No motive is constructed; the weight is inferred from
growth.  The link from the decomposition to `|Im ∪ Q|` is not established.

**What would falsify it.** A `c_4` of size `O(q)` or `O(1)` would break the
weight-3 reading; a cap proof not using the decomposition would undercut the
"correction" picture.

---

## 4. Lean — the one-point/two-point gap, smallest instance

`lean/Gap.lean`:

```
individual_ne_average :
  6 * cubicTwin7h 2 ≠ Σ_{h≠0} cubicTwin7h h       (over 𝔽₇)
```

i.e. `6·35 = 210 ≠ 168`.  The individual twin count at `h=2` is not the average
over `h`.  A formal witness of the round-19 diagnosis (target C's obstruction).
Footprint `[propext, Classical.choice, Quot.sound]`.

---

## 5. Honest verdict

* **Target A — not established.** The cap holds for 16 primes; no general proof.
* **Target B — partial.** For `d=4` the individual count is now an exact
  quadratic + quartic decomposition, with the quartic coefficient pinned at
  `q = 17,41,73`.  No closed form for `c_4`; `d ≥ 5` untouched.
* **Target C — not established.** The Lean gap theorem is a formal witness, not
  a proof over `ℚ`.
* **The wild guess:** `c_4` is a weight-3 trace and the cap is a character-sum
  bound.  Coherent with the data, unproved.

## 6. Next round

1. **Target B**: compute `c_4` for more `q ≡ 1 (mod 8)` (`q = 89, 97, 113`) and
   fit it against Jacobi sums / Hecke eigenvalues.
2. **Target A**: try to bound `|Im ∪ Q|` from below using the decomposition.
3. **Target C**: formalize a parity statement about the twin indicator (beyond
   non-multiplicativity), e.g. that it cannot be a finite sum of the first `k`
   Dirichlet characters.

---

## 7. Reproduction

```
python3 checks/round31_individual.py   # exit 0
python3 -m pytest -q tests/test_round31.py   # 6 passed
cd lean && ./check.sh Gap.lean Axioms.lean    # OK
```

New files: `checks/round31_individual.py`, `tests/test_round31.py`,
`lean/Gap.lean`.
