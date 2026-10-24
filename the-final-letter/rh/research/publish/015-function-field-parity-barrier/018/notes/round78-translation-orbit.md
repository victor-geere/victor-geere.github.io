# Round 78 — Target B: `q ∣ T` is a translation orbit, and the `d=5` congruence is proved

Round 23 of the aggressive goal.  The round-22 congruence is a **corollary of a
one-line orbit argument**, which makes the `d=5` congruence a theorem.

---

## 1. The theorem: `q ∣ T(d;q,h)` for `d < q`

Consider the diagonal translation action on pairs of monic degree-`d` polynomials:

```
t · (f, g)  =  (f + t, g + t) ,     t ∈ 𝔽_q .
```

It preserves `g − f = h`, and it is **free**: `f + t = f` forces `t = 0` (the
constant term changes).  So every orbit has exactly `q` elements, and the set

```
{(f, g) : f, g irreducible, g − f = h}
```

— whose cardinality is `T(d;q,h)` — is a disjoint union of `q`-element orbits.
Hence

```
q ∣ T(d;q,h)      for every h,  whenever d < q .
```

Verified: `d = 3,4,5`, all `q > d` in the scan range (28 pairs).

## 2. The corollary: the congruence is proved

With `A_c = T(d;q,h_c) = q·T'(h_c)` and `S_j = Σ_c A_c ζ_d^{−jc}`:

```
S_j  =  q · Σ_c T'(h_c) ζ_d^{−jc}  ≡  0  (mod q)  in ℤ[ζ_d] .
```

Equivalently, since `c_k = S_k/d`, we get the round-11/22 statement

```
(q−1)·c_k  ≡  0  (mod q) .
```

**So the `d=5` congruence is proved** — it is exactly the translation
divisibility.

## 3. What remains for `d=4`

The `d=4` statement is **stronger**: `8q ∣ S_1`, equivalently
`c₄/(2q) ∈ ℤ[i]`.  The factor `8 = 2·4` splits as

* `2` from the even symmetry `T(h) = T(−h)` (Lean `TwinEven`, round 74),
* `4` from the DFT normalisation `S_1 = 4c₄`.

So the only unproved piece of the `d=4` congruence is the `(q−1)` divisibility
of `S_1` — the `χ₄`-Fourier coefficient of `T'` being a Gaussian integer.

---

## 4. Wild guess 20 — the `(q−1)` factor is the multiplicative orbit

> **Wild guess 20.** The missing `(q−1)` comes from the **multiplicative**
> analogue of the translation orbit: the action `h ↦ a h` has orbits of size
> `(q−1)/gcd(·)`, and the `d`-th power invariance (round 76) makes the
> `χ₄`-sum collapse to `(q−1)` times an integer.  Then `S_1/(q−1) ∈ ℤ[i]` would
> follow.

**Evidence.** `T` is constant on the `d`-th power classes (round 76), so the
`χ₄`-sum is `(q−1)/4` times a Gaussian combination of the four `A_c`; the
`(q−1)` divisibility is then a divisibility of `(A_0−A_2)` and `(A_3−A_1)`.

## 5. Honest verdict

* **Target B — the `d=5` congruence is proved** (translation orbit).
* **Target B — `d=4`**: the factor 2 is proved (round 74), the factor `(q−1)`
  remains verified at seven primes.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The `(q−1)` divisibility** via the multiplicative orbit.
2. **A synthesis of all three targets.**

---

## 7. Reproduction

```
python3 checks/round78_translation_orbit.py   # exit 0
python3 -m pytest -q tests/test_round78.py   # 1 passed
```

New files: `checks/round78_translation_orbit.py`, `tests/test_round78.py`.
