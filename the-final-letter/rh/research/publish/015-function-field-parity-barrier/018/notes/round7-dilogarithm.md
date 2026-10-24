# Round 7 — the generating function is a dilogarithm, not rational

Round 6 previewed the guess that the twin generating function is rational or
algebraic. This round computes the degree densities and **refutes** that guess.
The correct object is the dilogarithm `Li₂`, and this changes the wild guess.

---

## 1. Established direction — the densities `1/d²` and `Li₂`

Write

```
c_d(q) = T(d;q) / q^d ,        G_q(t) = Σ_{d≥1} c_d(q) t^d .
```

**Observation 1 (leading density).** For fixed `d`, as `q → ∞`,

```
c_d(q) = T(d;q)/q^d  →  1/d² .
```

*For `d = 2, 3` this is exact*: the Bary-Soroker–Stix formulas give
`4c₂(q) = 1 − (2−χ)/q` and `9c₃(q) = 1 + (c_q²−3)/q + O(q⁻²)` (the `h`-dependence
of `c₃` is a `1/q` effect only). *For `d ≥ 4`* it follows from the general
Theorem of Bary-Soroker–Stix eq. (1.3),
`π(d,q;h) = q^d/d^k · S_q(h)(1+E)` with `S_q(h) → 1` and `E = O(q^{−1/2})`.

Numerical check (`logs/twin_degrees.log`, `checks/round7_dilog.py` §[A]):
`r_d(q) = d² c_d(q)` at the largest available `q`:

| `d` | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|
| `q_max` | 97 | 97 | 61 | 31 | 19 | 13 |
| `r_d(q_max)` | .9897 | .9709 | .9769 | .9641 | .9425 | .9133 |

all within `O(1/q)` of `1`.

**Consequence (generating function).** Because the limit is term-by-term for
each fixed `d`,

```
G(t) = lim_{q→∞} G_q(t) = Σ_{d≥1} t^d/d² = Li₂(t) ,
```

the **dilogarithm**. At finite `q` the corrections are `O(1/q)`:
coefficient-wise `d² c_d(q) − S(q) = O(1/q)`, and for a fixed truncation
`G_q(t) = S(q)·Li₂(t) + O(1/q)`.

At `q = 61`, `t = 1/2` (`checks/round7_dilog.py` §[B]):

```
G_61(1/2) = 0.0749997 ,      S(61)·Li₂(1/2) = 0.0789353 ,
|G_61(1/2) − S(61)Li₂(1/2)| = 3.9e−3 .
```

The leading density `1/d²` is independent of the shift `h`; the `h`-dependence
sits in the `1/q` corrections (e.g. the cube/non-cube branch at `d = 3`).

---

## 2. The rationality guess is false

**Claim.** `Li₂` is not a rational function.

*Proof.* A rational generating function has C-finite coefficients: a linear
recurrence `a_{n+r} = Σ_{i<r} c_i a_{n+i}` with constant coefficients. Such
sequences are eventually of the form `Σ_j p_j(n) λ_j^n` with polynomials `p_j`.
Since `1/n² → 0`, every `|λ_j| ≤ 1`; a root of unity with a nonzero polynomial
does not tend to `0`, and `|λ_j| < 1` gives exponential decay. Both contradict
the polynomial decay `1/n²`. ∎

So the round-6 preview — "the exact formulas assemble into a rational or
algebraic generating function" — is **refuted**. The function-field object is
`Li₂`, which is *D-finite* but not rational: it satisfies the linear ODE

```
t(1−t)·Li₂''(t) + (1−t)·Li₂'(t) = 1 ,
```

verified symbolically (`checks/round7_dilog.py` §[D]), together with the
functional equation `Li₂(t) + Li₂(1−t) = π²/6 − log t · log(1−t)`.

---

## 3. Wild guess 7 — the barrier is non-holonomy

> **Wild guess 7.** The twin generating function is a **polylogarithm**
> (`S(q)·Li₂(t)` in the `q → ∞` limit), hence D-finite. Over `ℚ` the analogue is
> **not D-finite**: no linear recurrence with polynomial coefficients governs
> the twin density. The parity barrier is this failure of holonomy — the
> `ℚ` twin generating function has no iterated-integral (dilogarithmic)
> representation. Crossing the barrier would be finding one: a functional
> equation / iterated-integral formula for the `ℚ` twin density.

**What is testable.** The function-field side is now concrete: `Li₂` appears as
the limit, it is D-finite, and it satisfies a functional equation. The `d=2,3`
exact formulas show how the arithmetic enters the `1/q` corrections. The guess
predicts that any proof over `ℚ` must produce a *holonomic* structure (a
recurrence or an iterated integral), not merely a better sieve weight.

**Why it is a guess.** There is no known linear recurrence for the `ℚ` twin
counts, no known iterated-integral representation, and no theorem saying one
cannot exist. The guess is a statement about the *shape* of the missing object,
consistent with the "D-finite/period" heuristic and with the dictionary's
"automorphic/spectral" route.

**What would falsify it.** A proof of the twin conjecture by a non-holonomic
route (e.g. a purely sieve-theoretic argument that somehow evades the parity
no-go), or a demonstration that the `ℚ` generating function is D-finite after
all.

---

## 4. Lean — the `χ`-dependence at degree 2

`lean/Curve.lean` now also checks degree 2 over `𝔽₇`:

* `QuadSeven.pair7_shift_one : pairCount = 7`;
* `QuadSeven.pair7_shift_two : pairCount = 7`.

Together with the `𝔽₅` checks in `CurveLift` (`shift 1 → 5`, `shift 2 → 0`),
this exhibits the `q mod 4` (`χ`) dependence of the degree-2 formula:
over `𝔽₅` the two shifts differ, over `𝔽₇` they agree. This is the smallest
instance of the arithmetic corrections that make up the `1/q` terms of `G_q`.

---

## 5. Honest verdict

* **Established this round:** the density limit `T(d;q)/q^d → 1/d²` (exact for
  `d ≤ 3`, general theorem for fixed `d`); the generating function is `Li₂`;
  the round-6 rationality guess is refuted; `Li₂`'s ODE and functional equation
  are verified; degree-2 `χ`-dependence is Lean-checked at `𝔽₅` and `𝔽₇`.
* **The wild guess:** the barrier is non-holonomy. Coherent, consistent with the
  data, not testable over `ℚ`.
* **Not claimed:** that the `ℚ` twin generating function is not D-finite; that
  a dilogarithmic representation exists; that holonomy is necessary.

## 6. Next round

1. **The `1/q` corrections.** Compute the first correction `a_1(d)` for
   `d = 2…7` and see whether it is a finite sum of traces (as at `d = 3`) or
   something new.
2. **Degree 5/6 dichotomy.** With the larger grid, check whether any
   congruence-class split survives beyond `d = 3`.
3. **Wild guess 8 (preview).** *The `1/q` corrections are themselves `L`-values:
   `a_1(d) = −1/d² + (1/d²)·L(M_d, 1)` for a motive `M_d`.* Investigate by
   matching `a_1(2)` to `χ` and `a_1(3)` to `c_q²`.

---

## 7. Reproduction

```
python3 checks/round7_dilog.py     # exit 0
python3 -m pytest -q tests/        # 122 passed
cd lean && ./check.sh Curve.lean Axioms.lean   # OK
```

New files this round: `checks/round7_dilog.py`, `tests/test_round7.py`, and the
`QuadSeven` section of `lean/Curve.lean`.
