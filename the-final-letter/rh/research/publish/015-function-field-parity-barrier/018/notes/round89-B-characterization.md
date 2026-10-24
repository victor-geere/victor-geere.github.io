# Round 89 — Target B: the explicit characterization of `B(a₂)`

Round 34 of the aggressive goal.  The even-quartic irreducibility set gets a
**closed description**, and the sizes and `A` become **proved**.

---

## 1. The characterization

```
x⁴ + a₂x² + b  irreducible   ⟺   χ₂(b) = −1   and   χ₂(a₂²−4b) = −1 .
```

**Proof.**  Write `f = h(x²)` with `h(y) = y²+a₂y+b`.

* `h` irreducible `⟺ χ₂(a₂²−4b) = −1` (the discriminant).
* If `h` is irreducible with root `r ∈ 𝔽_{q²}\𝔽_q`, then `f = h(x²)` is
  irreducible iff `r` is **not a square** in `𝔽_{q²}`.  For `r ≠ 0`,
  `r` is a square in `𝔽_{q²}` `⟺ N(r) = b` is a square in `𝔽_q`
  (both conditions are `r^{(q²−1)/2} = 1`).
* If `h` splits, `f` factors as two quadratics — reducible.

So `f` is irreducible iff `χ₂(b) = −1` and `χ₂(a₂²−4b) = −1`. ∎

Verified at `q = 17,41,73` for every `a₂`.

## 2. The sizes, proved

With `1_{χ₂=−1} = (1−χ₂)/2`, the count is

```
|B(a₂)| = (1/4) [ q + Σ_b χ₂(b)χ₂(a₂²−4b) ] .
```

For `a₂ = 0`: the two conditions coincide, so `|B(0)| = (q−1)/2`.
For `a₂ ≠ 0`: writing `x = a₂²/4` (a nonzero square) and `χ₂(4)=1`,

```
Σ_b χ₂(b)χ₂(x−b) = −1    (the standard quadratic sum),
```

hence `|B(a₂)| = (q−1)/4`. ∎

## 3. `A` is proved

With the sizes `Σ|B| = (q²−1)/4` and `S_0 = (q−1)²/4 + (q−1)³/16`, Parseval and
`Σ_{c≠0}χ₂(c) = 0` give

```
A = (3q²+2q+3)/16 .   ∎
```

---

## 4. Wild guess 31 — the Gauss-sum route to `m`

> **Wild guess 31.** With `B(a₂)` explicit, the Fourier transform
> `B̂(c) = (1/4)Σ_b (1−χ₂(b))(1−χ₂(a₂²−4b))ζ^{cb}` expands into four character
> sums; the `ζ^{ca₂²/4}` factors give a Gauss sum and hence the `√q` term of
> `S_c`.  The integer `m` should then be readable from the `a₂`-sum of the
> `ζ^{ca₂²/4}` terms — a **quadratic Gauss sum** in `a₂`.

**Evidence.** The characterization (`§1`), the `√q` scaling of `B`.

**Why it is a guess.** The expansion is not completed.

## 5. Honest verdict

* **Target B — three proofs**: the characterization, the sizes, and `A`.
  Only `m` remains.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Complete the Gauss-sum expansion** for `m`.
2. **A closing note.**

---

## 7. Reproduction

```
python3 checks/round89_B_characterization.py   # exit 0
python3 -m pytest -q tests/test_round89.py   # 1 passed
```

New files: `checks/round89_B_characterization.py`, `tests/test_round89.py`.
