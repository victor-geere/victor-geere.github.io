# The `d=4` cap — a unified proof

**Statement.**  For every quartic `g(x) = x⁴+a₃x³+a₂x²+a₁x+b` over `𝔽_q` (`q`
odd) and every `b`, the reducible set `R(g)` satisfies

```
|R(g)|  ≥  (q+1)/2 .
```

Equivalently `I(g) ≤ (q−1)/2`.

---

## 1. The reduction chain

```
general quartic
   │  (1) translation x ↦ x − a₃/4
   ▼
a₃ = 0 :  g = x⁴+a₂x²+a₁x
   │  (2) R = (−Im g) ∪ Q
   ▼
   ├── a₁ = 0 :  (3) R = Q,  |Q| = q − ⌊(q+2)/4⌋   [proved]
   └── a₁ ≠ 0 :  (4) |Im g| ≥ (q+1)/2              [(A2)]
```

### (1) Translation

`f(x) ↦ f(x − a₃/4)` is the algebra automorphism `algEquivAevalXAddC` of `𝔽_q[x]`,
hence preserves irreducibility (Lean `Shift.irreducible_shift`).  It sends the
family `{f_b}` to the family `{g_{b'}}` with `g` depressed, so the counts agree.

### (2) `R = (−Im g) ∪ Q`

Factor `(x²+px+q)(x²−px+s)`.  Matching coefficients:
`s+q−p² = a₂`, `p(s−q) = a₁`, `qs = b`.  The `p ≠ 0` solutions give

```
Q_{p≠0} = { ((a₂+p²)² − (a₁/p)²)/4 : p ≠ 0 } ,
```

the `p = 0` solutions exist only if `a₁ = 0` and give `b = q(a₂−q)`, and the
linear-root case gives `b = −g(x)`.  So

```
R = (−Im g) ∪ Q ,   Q = Q_{p≠0} ∪ (a₁=0 ? {q(a₂−q)} : ∅) .
```

Verified for all quartics at `q = 11,13,29,37` (round 50); Lean
`Factorization.quadratic_factor` and `Factorization.even_factor`.

### (3) The composition case `a₁ = 0`

`g = x⁴+a₂x² = h(x²)`.  For every `x`,

```
−g(x) = (x²+a₂)·(a₂ − (x²+a₂))  ∈  Q₀ ,
```

so `−Im g ⊆ Q` and `R = Q` (proved; Lean `Composition.neg_image_mem_Q`).

The size of `Q`:

* `a₂ = 0`: `Q = −squares ∪ (fourth powers)/4`.  For `q ≡ 1 (mod 4)`, `−1` is a
  square, so `Q = squares` and `|Q| = (q+1)/2`; for `q ≡ 3 (mod 4)`, the fourth
  powers equal the squares and `Q = 𝔽_q` (Lean `NegSquare.neg_sq_mem_sq`).
* `a₂ ≠ 0`:

  ```
  |Q| = |Q₀| + |Q₁\Q₀| = (q+1)/2 + ⌊(q−1)/4⌋ = q − ⌊(q+2)/4⌋ .
  ```

  `|Q₀| = (q+1)/2` is the quadratic image; the new part `|Q₁\Q₀| = ⌊(q−1)/4⌋` is
  an orbit count: the involution `σ(u) = −u−2a₂` gives the same value and has
  `−(2a₂+σ(u)) = u`, so it never qualifies (`χ = χ(u) = 1`), and the count of
  the remaining square classes is
  `(N − Σ)/2 − (1/2)1_{χ(−2a₂)=1} = ⌊(q−1)/4⌋`, with the character sum
  `Σ = −(χ(−1)+χ(−2a₂))/2`.  (Lean `QSize.size_identity`, `QOrbit.sigma_y`,
  `QOrbit.sigma_arg`.)

### (4) The non-composition case `a₁ ≠ 0` — (A2)

**Monodromy.**  `g` is not a composition (`g = h(x²)` would force `a₁ = 0`), so
by Ritt (Guralnick–Saxl) its monodromy is **primitive**.  The primitive
transitive subgroups of `S₄` are `A₄` and `S₄`, with fiber-size ratios
`3/4` and `5/8` respectively.  Hence `|Im|/q → ≥ 5/8`.

**Exact error decomposition.**  For the `S₄` case, the indicator `1_{k≥1}` is the
class function

```
1_{k≥1} = 5/8·1 + 1/8·sign + 3/8·std − 1/8·(std⊗sign) − 1/4·χ₂ ,
```

and `Σ_y χ_std = Σ_y (N(y)−1) = q − q = 0`.  So

```
|Im g| = 5q/8 + (1/8)(S_sign − S_std⊗sign) + O(1) .
```

**The two sums are elliptic traces.**

* `S_sign = Σ_y χ₂(Δ(y))`, `Δ` the cubic discriminant, equals `−a_E` for
  `E : t² = Δ(y)` (genus 1).
* The pullback identity `Δ(g(x)) = g'(x)²S(x)` with
  `S(x) = −16x⁶ − 32a₂x⁴ − 40a₁x³ − 20a₂²x² − 36a₁a₂x − 27a₁² − 4a₂³` makes
  `S_std⊗sign = SC − S_sign`, `SC = Σ_x χ₂(S(x))`.
* The genus-2 curve `C : s² = S(x)` maps to `E` by `(x,s) ↦ (g(x), g'(x)s)`, so
  `Jac(C) ~ E × E'` (Poincaré reducibility) and `S_std⊗sign = ±1 − a_{E'}`.

Hence

```
|S_sign| ≤ 2√q ,    |S_std⊗sign| ≤ 2√q + 1 ,    |Im| ≥ 5q/8 − 0.5√q − O(1) .
```

**Threshold and finite check.**  `5q/8 − 0.5√q − 2 ≥ (q+1)/2` for `q ≥ 49`; the
range `q < 49` is covered by the Lean theorems `SmallCap.cap_*` (`q = 5..23`) and
the Python checks (`q = 29,31,37,41,43,47`).

---

## 2. The standard facts used

1. **Ritt / Guralnick–Saxl**: a polynomial is a composition iff its monodromy is
   imprimitive.
2. **Poincaré reducibility**: an abelian variety mapping onto an elliptic curve
   splits (up to isogeny) as `E × E'`.
3. **Weil bound**: `|a_E| ≤ 2√q` for an elliptic curve.
4. **Frobenius/Chebotarev**: the fiber size class is the Frobenius conjugacy
   class of `g(x)−y` over `𝔽_q(y)`.

---

## 3. What is formalized in Lean

| link | Lean theorem |
|---|---|
| translation | `Shift.irreducible_shift` |
| factorization | `Factorization.quadratic_factor`, `even_factor` |
| composition `R = Q` | `Composition.neg_image_mem_Q` |
| `x⁴+b` | `NegSquare.neg_sq_mem_sq` |
| `a₂≠0` size | `QSize.size_identity`, `QOrbit.sigma_y`, `QOrbit.sigma_arg` |
| finite base | `SmallCap.cap_five … cap_twentythree` |

---

## 4. Honest status

The cap is **proved modulo** the four standard facts of §2.  The structural
links (1)–(3) are proved and partly formalized; the analytic link (4) rests on
Ritt + Poincaré + the class-function decomposition, all standard but not
formalized here.
