# Round 107 — Target B: the half-integer arithmetic of `E(h)`, formalized

Round 51 of the aggressive goal.  The arithmetic behind the exact `E(h)` formula
is now **formalized in Lean**.

---

## 1. The two congruences

```
X_cong :  q % 8 = 1   →   (q² − 2q − 7) % 16 = 8
Y_cong :  a % 2 = 1   →   (a² + 1) % 4 = 2
```

Both proved by `omega` after reducing to `q = 8k+1` and `a = 2k+1`, and both in
`lean/HalfInteger.lean` (compiles clean).

## 2. Why they matter

`E(h) = (q²−2q−7)/16 + ((a²+1)/4)·χ₂(2h)` takes the two values

```
E_± = (q²−2q−7)/16 ± (a²+1)/4 .
```

`X_cong` says the first is a **half-integer** (`k + 1/2`), and `Y_cong` says the
second is also a half-integer; their sum and difference are therefore
**integers**.

**Verified** at `q = 17,41,73,89,97,113,137`: the two `E` values are integral.

---

## 3. Wild guess 48 — the parity law is now `ℤ`-valued

> **Wild guess 48.** With `E` proven integral, the parity law
> `T(h) ≡ E(h) (mod 2)` is a statement about honest integers; combined with
> `T ≡ E (mod 2)` (round 29), the `c₄` congruence is an integer congruence.
> The only remaining input is the character-sum identity of round 49.

**Evidence.** The two Lean congruences (§1) and the integrality (§2).

## 4. Honest verdict

* **Target B — the `E(h)` arithmetic is formalized.** 45 Lean files, 0 errors.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 5. Next round

1. **The character-sum identity.**
2. **A final synthesis.**

---

## 6. Reproduction

```
cd lean && ./check.sh HalfInteger.lean   # OK
python3 checks/round107_half.py   # exit 0
python3 -m pytest -q tests/test_round107.py   # 1 passed
```

New files: `lean/HalfInteger.lean`, `checks/round107_half.py`,
`tests/test_round107.py`.
