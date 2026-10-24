# Round 74 — Target B: the factor 2 is a bijection

Round 19 of the aggressive goal.  The factor `2` in `c₄/(2q) ∈ ℤ[i]` is
**proved**: it is the `h ↦ −h` symmetry of the shifted-irreducibility count.

---

## 1. The theorem: `T(h) = T(−h)`

```
T(h)  =  #{(f, g) : f, g irreducible, g − f = h} .
```

The map `(f, g) ↦ (g, f)` is a bijection between the `h`-pairs and the
`(−h)`-pairs, hence

```
T(h) = T(−h) ,      for every h .
```

Equivalently, `f ↦ f + h` is a bijection from `{f : f, f+h irr}` onto
`{g : g, g−h irr}`.  Formalized in Lean:

```
TwinEven.card_twin_even :
  (s.filter (fun f => P f ∧ P (f + h))).card
    = ((s.image (fun f => f + h)).filter (fun g => P g ∧ P (g - h))).card
```

## 2. The factor 2

With `T` even and `χ₄(−1) = 1` (for `q ≡ 1 (mod 8)`), the quartic sum

```
S = Σ_h T'(h) χ₄(h)  =  2 · Σ_{pairs {h,−h}} T'(h) χ₄(h)
```

is **even**, so `S/2 ∈ ℤ[i]` — the factor 2 is explained, unconditionally.

## 3. What remains

```
c₄/(2q) ∈ ℤ[i]   ⇔   S/(2(q−1)) ∈ ℤ[i] .
```

Verified at seven primes (`q = 17,41,73,89,97,113,137`), with values
`1−5i, 20−5i, −27−2i, 5−82i, 81+13i, −28−82i, −176−5i`.

The remaining content is the divisibility by `(q−1)`, i.e. that the `χ₄`-Fourier
coefficient of the **reduced** counts `T'` is a Gaussian integer.

---

## 4. Wild guess 16 (refined) — the reduced counts are a character

> **Wild guess 16.** The reduced counts `T'(h) = T(h)/q` have a `χ₄`-Fourier
> coefficient in `ℤ[i]` because `T'` is a **linear combination of multiplicative
> characters plus a constant** — i.e. `T'(h) = A + Σ_k c_k χ_k(h)` with
> `c_{-4} ∈ ℤ[i]`.  The `(q−1)` divisibility is the orthogonality normalisation.

---

## 5. Honest verdict

* **Target B — the factor 2 is proved.** `T(h) = T(−h)` (Lean `TwinEven`),
  hence `S` is even.  The `(q−1)` divisibility is verified at seven primes.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **Prove `S/(2(q−1)) ∈ ℤ[i]`** via the character decomposition of `T'`.
2. **The `d=5` analogue.**
3. **A synthesis.**

---

## 7. Reproduction

```
python3 checks/round74_even_symmetry.py   # exit 0
python3 -m pytest -q tests/test_round74.py   # 1 passed
cd lean && ./check.sh TwinEven.lean   # OK
```

New files: `checks/round74_even_symmetry.py`, `tests/test_round74.py`,
`lean/TwinEven.lean`.
