# Round 58 — Target C: the twin indicator is not a divisor sum (proved)

Round 3 of the aggressive goal.  **Target C takes a real theorem**: the twin
indicator is **unconditionally** not a bounded-support divisor sum — i.e., not
in the Selberg sieve class.

---

## 1. The periodicity lemma

If `S` is a finite set of divisors all dividing `L`, then

```
Σ_{d ∈ S, d ∣ n} g(d)  =  Σ_{d ∈ S, d ∣ n + L} g(d) .
```

Because `d ∣ L`, so `d ∣ n ⇔ d ∣ n+L`.  (Lean
`Periodic.divisor_sum_periodic`.)

A Selberg-type sieve weight `n ↦ Σ_{d|n, d≤D} λ_d` is of exactly this form (with
`S = {1,…,D}` and `L = lcm(1,…,D)`), so **every bounded-support sieve weight is
periodic**.

## 2. The twin indicator is not periodic

For every `L ≥ 1`:

```
twinInd 3 = 1 ,      twinInd (3 + 3L) = 0 ,
```

because `3` and `5` are prime, and `3 + 3L = 3(1+L)` is divisible by `3` and
greater than `3`, hence composite.

If `twinInd` had period `L`, iterating the period would give
`twinInd 3 = twinInd (3+3L)` — contradiction.  (Lean
`NonPeriodic.twinInd_not_periodic`.)

## 3. The theorem

```
¬ ∃ (S finite, L ≥ 1 with ∀ d ∈ S, d ∣ L) (g : ℕ → ℝ),
      ∀ n,  twinInd n = Σ_{d ∈ S, d ∣ n} g(d) .
```

Proof: the right-hand side is `L`-periodic, the left-hand side is not.  (Lean
`NonPeriodic.twinInd_not_divisor_sum`.)

So the twin indicator is **not** a bounded-support divisor sum — no Selberg-type
sieve weight can equal it.

## 4. What this does and does not say

* **Does:** the twin indicator lies outside the entire finite divisor-sum class.
  This is the algebraic content of the parity barrier.
* **Does not:** it does not prove that twins are infinite.  The theorem is about
  the **indicator function**, not about the **count**; the sieve's failure is a
  statement about weights, not about the primes.

---

## 5. Wild guess 3 — the periodicity gap is the barrier

> **Wild guess 3.** The parity barrier **is** the periodicity gap: every
> bounded-support sieve weight is periodic, the twin indicator is not, and the
> missing object is a **non-periodic weight** — an automorphic form (a
> `GL(2)×GL(2)`-type object) whose coefficients are not eventually periodic.
> Over `ℚ`, constructing that weight is exactly the open problem.

**Evidence.**

* The periodicity lemma and the non-periodicity witness (`§1–2`).
* The theorem (`§3`).
* The old programme's finding that the twin count is a weight-4 trace.

**Why it is a guess.** No automorphic weight is constructed.

**What would falsify it.** A bounded-support divisor sum equal to the twin
indicator (impossible by `§3`).

---

## 6. Lean

* `Periodic.divisor_sum_periodic`
* `NonPeriodic.twinInd_not_periodic`
* `NonPeriodic.twinInd_not_divisor_sum`

Footprints `[propext, Classical.choice, Quot.sound]`.

---

## 7. Honest verdict

* **Target C — a theorem.** The twin indicator is unconditionally outside the
  bounded-support divisor-sum class.
* **(A), (B) — unchanged.**
* **The wild guess:** the periodicity gap is the barrier; the fix is a
  non-periodic (automorphic) weight.

## 8. Next round

1. **Attack (A2)** again.
2. **Target B**: `c₄`.
3. **Target C**: the quantitative version (the factor 2).

---

## 9. Reproduction

```
python3 checks/round58_parity_theorem.py   # exit 0
python3 -m pytest -q tests/test_round58.py   # 8 passed
cd lean && ./check.sh Periodic.lean NonPeriodic.lean Axioms.lean  # OK
```

New files: `checks/round58_parity_theorem.py`, `tests/test_round58.py`,
`lean/Periodic.lean`, `lean/NonPeriodic.lean`.
