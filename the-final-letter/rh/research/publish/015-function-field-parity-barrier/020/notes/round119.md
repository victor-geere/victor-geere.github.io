# Round 119 — two truncations, and no closed form

*Plan fixed at the start of the round (`rounds.log`, BEFORE line).*

---

## 1. The envisioned path

The synthesis's last open question was a closed form for the boundary stratum. Round 108 showed the boundary
cancels a divergent product; the natural hope is a formula

```
truncated(n) ≈ C · q^n / n² ,      boundary(n) ≈ (S(q) − 4C) · q^n / n² ,
```

with `C = lim_y y² P(y)` and `P(y) = Π_{deg Q ≤ y} (1 − 2/Q)` the partial Euler product. Since
`log P(y) ≈ −2 Σ_{d≤y} 1/d ≈ −2 log y`, one expects `P(y) ≈ C/y²`, hence the `q^n/n²` shape. If true, both
strata have closed forms and the cancellation is quantified.

## 2. Wild guess 60

> **Wild guess 60.** `truncated(n) = q^n P(n/2)·(1+o(1))` and `y²P(y)` converges, so the boundary has the
> closed form `(S − 4C)q^n/n²`.

**Why guess it.** The heuristic `P(y) ≈ C y^{−2}` is a two-line computation from the prime number theorem in
`𝔽_q[x]`.

**Falsification test.** Compute `P(y)` for `y ≤ 12` and compare `q^n P(n/2)` with both the truncated sum and
the true count.

## 3. Results

### 3.1 The two truncations are different objects

The **exact expansion** truncated by *total divisor degree* (`k ≤ n`) is the polynomial partial product
`q^n Σ_{k≤n} c_k q^{−k}`. The **Euler product** truncated by *prime degree* (`deg Q ≤ n/2`) is
`q^n P(n/2)`. They are not the same, and they behave very differently:

| `n` | `truncated(k ≤ n)` | `q^n P(n/2)` | `T(n)` |
|---|---|---|---|
| 6 | −155 | 6.86 | 6 |
| 8 | −723 | 39.39 | 36 |
| 10 | −2523 | 238.40 | 216 |
| 12 | +477 | 1560.06 | 1506 |
| 14 | +17157 | 10553.88 | 9510 |

The `k ≤ n` truncation is off by factors of `10–100` and changes sign; the `n/2` product tracks `T(n)` to about
`10%`. Round 108's "divergent truncation" conclusion is therefore about the *first* truncation only.

### 3.2 But the product has no constant

`y² P(y)` does **not** converge:

| `y` | 2 | 4 | 6 | 8 | 10 | 12 |
|---|---|---|---|---|---|---|
| `y²P(y)` | 0.070 | 0.096 | 0.106 | 0.110 | 0.113 | 0.115 |

It rises slowly (consistent with a `log log y` correction to the `1/y²` heuristic). So the implied constant
`4C ≈ 0.44–0.46` overshoots the true `S(3) = 0.396` by about `15%`, and the ratio
`T(n)/(q^n P(n/2))` fluctuates in `0.73–0.97` without settling.

**Wild guess 60 is refuted**: there is no closed form with a convergent constant. What is true is weaker and
still useful: the `n/2` Euler product captures the `q^n/n²` scale and the constant to roughly `10%`, while the
`k ≤ n` truncation captures nothing.

### 3.3 Why

The expansion's coefficients `c_k` grow, and the `k ≤ n` cut keeps only a small, sign-alternating corner of a
product whose degree is `Σ_{deg Q ≤ n/2} deg Q ≈ q^{n/2}`. The cut is not a natural boundary for the product;
the natural one is the prime-degree cut, which is what `P(n/2)` uses. The two coincide only in the limit
`n → ∞`, where both diverge from each other by a slowly varying factor.

## 4. Lean

`Parity.even_two_pow` and `Parity.two_pow_ge_two`: the dimension factor `2^k` is even and at least `2` for
`k ≥ 1` — the constants of the parity barrier are themselves even. Standard axioms.

## 5. State

* Two truncations distinguished; only the prime-degree one approximates `T`.
* No closed form: `y²P(y)` does not converge (0.070 → 0.115 over `y ≤ 12`).
* Wild guess 60 refuted.
* Lean: `Parity.even_two_pow`, `two_pow_ge_two`; eleven modules green.

## 6. Next round (120)

The phase's questions are now all answered or explicitly closed as intractable with the current tools. Round 120
will update the synthesis with rounds 118–119 and conduct a final audit, unless a new testable idea appears.
