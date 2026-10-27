# Round 13 — the constant-shift distribution

Round 12 showed that the `d = 5` generic count is not polynomial. This round
decomposes the *shift average* into a finer object — the distribution of the
number of irreducibles in a constant-shift family — and finds the combinatorial
shape of the `d ≤ 4` / `d ≥ 5` dichotomy.

---

## 1. Established direction — the distribution

For a monic degree-`d` polynomial with fixed lower-but-constant coefficients
`a = (a_{d-1},…,a_1)`, put

```
I(a) = #{ b ∈ 𝔽_q : x^d + a_{d-1}x^{d-1} + … + a_1 x + b  is irreducible } .
```

The shift average is the **second moment** of this distribution:

```
Σ_{h≠0} T(d;q,h) = Σ_{a ∈ 𝔽_q^{d-1}} I(a)(I(a) − 1) .
```

This identity is exact (an ordered pair of distinct irreducibles in the same
constant-shift family is the same as a pair `(f, f+h)` with `h ≠ 0`).

### The distributions

`checks/round13_distribution.py` computes them by sieve:

| `d` | `q=5` | `q=7` | `q=11` | `q=13` |
|---|---|---|---|---|
| 2 | `{2:5}` | `{3:7}` | `{5:11}` | `{6:13}` |
| 3 | `{0:5, 2:20}` | `{2:42, 4:7}` | `{0:11, 4:110}` | `{4:156, 8:13}` |
| 4 | `{0:20, 1:60, 2:45}` | `{0:21, 1:126, 2:126, 3:70}` | `{0:11, 1:220, 2:220, 3:660, 4:110, 5:110}` | `{0:52, 1:156, 2:312, 3:676, 4:780, 5:156, 6:65}` |

(`{I: #families}`.)

**`d = 2` is uniform.** `I(b) = (q−1)/2` for every `b` (as `c` varies,
`b²−4c` runs over all of `𝔽_q`). Lean: `QuadDistribution.d2_five/seven/eleven/thirteen`.

**`d = 3` is two-valued**, and the two values are `q − |Im(g)|` for
`g(x) = x³ + ax² + bx`:

| `q` | `I`-values | `|Im(g)|` |
|---|---|---|
| 5 | 0, 2 | 5, 3 |
| 7 | 2, 4 | 5, 3 |
| 11 | 0, 4 | 11, 7 |
| 13 | 4, 8 | 9, 5 |

So the `d = 3` distribution is the **value-set distribution of a cubic** — a
genus-1 object. This is the combinatorial face of the elliptic curve that
appears in the exact `d = 3` formula.

**`d = 4` has a clean cap.**

```
max I(a) = (q−1)/2     for q = 5, 7, 11, 13 .
```

**`d = 5, 6` break the cap.**

| `d` | `q` | `max I` | `(q−1)/2` |
|---|---|---|---|
| 5 | 5 | 4 | 2 |
| 5 | 7 | 4 | 3 |
| 5 | 11 | 8 | 5 |
| 6 | 5 | 3 | 2 |
| 6 | 7 | 4 | 3 |

The `d ≥ 5` distributions are already irregular — the combinatorial shadow of
round 12's non-polynomiality.

---

## 2. Wild guess 13 — the distribution guess

> **Wild guess 13.** The twin count's arithmetic is the **second moment of the
> constant-shift distribution** `I(a)`. In `𝔽_q[x]` this distribution is simple
> for `d ≤ 4` (uniform at `d=2`, two-valued cubic value set at `d=3`, capped by
> `(q−1)/2` at `d=4`) and irregular for `d ≥ 5`. The parity barrier is the
> **irregularity of the distribution**: over `ℚ` the analogue is the
> distribution of the number of primes in a shift family `{n + c}`, which is
> exactly what the parity barrier forbids us from controlling.

**Evidence.**

* The second-moment identity is exact.
* The `d ≤ 4` distributions are simple and the exact formulas follow (rounds
  10–12).
* The `d = 5, 6` distributions are irregular and the formulas fail.

**Why it is a guess.** The distribution's regularity at `d ≤ 4` is observed, not
proved; the `d=4` cap `(q−1)/2` has no proof here. Over `ℚ` there is no finite
shift group, so the "distribution" is replaced by an infinite family of shifts.

**What would falsify it.** A proof that the `d=5` distribution is regular for all
`q` (e.g. a closed form for its moments) would undercut the "irregularity"
reading.

---

## 3. Lean — the uniform `d = 2` distribution

`lean/Distribution.lean` proves, over `𝔽₅, 𝔽₇, 𝔽₁₁, 𝔽₁₃`:

```
∀ b, #{c : x² + b x + c irreducible} = (q−1)/2 .
```

(`d2_five : … = 2`, `d2_seven : … = 3`, `d2_eleven : … = 5`,
`d2_thirteen : … = 6`.)  These are finite checks; the general statement is the
elementary fact that `c ↦ b² − 4c` is a bijection.  Footprints
`[propext, Classical.choice, Quot.sound]`.

---

## 4. Honest verdict

* **Established this round:** the second-moment identity; the distributions for
  `d=2..6`; the uniformity at `d=2` (Lean); the two-valued cubic-value-set
  structure at `d=3`; the `(q−1)/2` cap at `d=4` (for `q ≤ 13`); the cap failure
  at `d=5,6`.
* **The wild guess:** the barrier is the irregularity of the constant-shift
  distribution. Coherent, supported by the `d ≤ 4` / `d ≥ 5` contrast, not
  testable over `ℚ`.
* **Not claimed:** a proof of the `d=4` cap; that the `d=5` distribution is
  irregular for all `q`; any distributional limit theorem.

## 5. Next round

1. **Prove the `d=4` cap** `max I(a) ≤ (q−1)/2` from the quadratic-factor
   structure of quartics.
2. **More `d=5,6` primes** to see whether the distribution's moments stabilise.
3. **Wild guess 14 (preview).** *The cap `(q−1)/2` is a **parity bound**: the
   irreducibles in a constant family are split equally between the two values
   of a quadratic character. Over `ℚ`, the analogous parity bound is Selberg's
   parity theorem, and the cap is exactly the factor the sieve cannot cross.*
   Investigate: identify the quadratic character controlling the `d=4` cap.

---

## 6. Reproduction

```
python3 checks/round13_distribution.py   # exit 0
python3 -m pytest -q tests/              # 249 passed
cd lean && ./check.sh Distribution.lean Axioms.lean   # OK
```

New files this round: `checks/round13_distribution.py`,
`tests/test_round13.py`, `lean/Distribution.lean`.
