# Round 101 — Target B: `S(u,v)` is **not** a universal quartic function

Round 45 of the aggressive goal.  A natural route to the Salié-sum evaluation is
closed off.

---

## 1. The `q = 17` structure

At `q = 17`, `S(u,v)` **is** a function of the triple of quartic characters

```
(χ₄(u), χ₄(v), χ₄(u−v))
```

(56 keys, all single-valued).

This suggested that `S(u,v) = f(χ₄(u),χ₄(v),χ₄(u−v))` for a **universal** `f`.

## 2. The `q = 41` failure

At `q = 41`:

* `S(u,v)` is **not** a function of the triple (68 keys, some multi-valued);
* of the 32 keys that are single-valued at both primes, only **8 agree**.

So there is **no universal quartic function** `f`.

## 3. What this means

The Salié-type sum `S(u,v)` carries genuine `q`-dependence beyond the quartic
characters — consistent with the `χ₂(c)` and `√q` dependence of `Σ|H|²`, but
ruling out the simplest evaluation route.

---

## 4. Wild guess 42 — the `u−v` scaling

> **Wild guess 42.** `S(u,v)` depends on the triple of quartic characters **and**
> a `q`-dependent constant: with `S(u,v) = α(q) + β(q)·(character combination)`,
> the failure is the `α(q)` term.  Equivalently, `S(u,v) − S(1,·)` is universal.

**Evidence.** The `q=17` structure and the `q=41` failure.

## 5. Honest verdict

* **Target B — the quartic-function route is closed.**  The Salié sum needs a
  genuine evaluation, not a character table.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The `S(u,v) − α(q)` decomposition.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round101_nonuniversal.py   # exit 0
python3 -m pytest -q tests/test_round101.py   # 1 passed
```

New files: `checks/round101_nonuniversal.py`, `tests/test_round101.py`.
