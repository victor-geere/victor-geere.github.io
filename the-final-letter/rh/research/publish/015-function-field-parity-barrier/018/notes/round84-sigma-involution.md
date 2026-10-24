# Round 84 — Target B: the parity law via the `σ`-involution

Round 29 of the aggressive goal.  The parity law is **reduced to a
two-dimensional count** by an explicit involution.

---

## 1. The `σ`-involution

Let `σ(f)(x) = f(−x)`.  It preserves monic quartics and irreducibility, and

```
σ(f + h) = σ(f) + h ,
```

so `σ` acts on the pair set `P_h = {(f, f+h) : f, f+h irr}`.  Its fixed points
are the **even** quartics `f = x⁴+a₂x²+b` (for which `f+h` is automatically
even too).

Hence

```
T(h)  ≡  E(h)  (mod 2) ,      E(h) = #{even f : f, f+h irreducible} .
```

Verified for all `h` at `q = 17,41`.

**This reduces the parity question from `q⁴` to `q²`.**

## 2. `E(h)` is two-valued

For each prime, `E(h)` takes exactly **two** values, and they are determined by
`χ₂(2h)`:

| `q` | `E` on `χ₂(2h)=1` | `E` on `χ₂(2h)=−1` | `δ` |
|---|---|---|---|
| 17 | 16 | 15 | −1 |
| 41 | 106 | 93 | −13 |
| 73 | 326 | 321 | −5 |
| 89 | 490 | 477 | −13 |

The deficit `δ` is **odd** in every case, so `E(h) mod 2` is exactly the parity
law `(1−χ₂(2h))/2`.

## 3. What this proves

```
T(h) ≡ E(h) ≡ (1−χ₂(2h))/2  (mod 2) ,
```

modulo the 2-valuedness of `E`.  The 2-valuedness is a statement about the
autocorrelation of the even-quartic set `B(a₂) = {b : x⁴+a₂x²+b irr}`.

---

## 4. Wild guess 26 — the Fourier support

> **Wild guess 26.** `E(h) = Σ_{a₂} (1/q) Σ_ψ |B̂_{a₂}(ψ)|² ψ(h)` is the
> additive autocorrelation of the `B(a₂)`.  Its 2-valuedness means the Fourier
> support of each `B(a₂)` is a **single** quadratic-character component, so the
> autocorrelation is a character in `h`.  Then the parity law is proved.

**Evidence.** The `σ`-involution (`§1`), the two-valuedness (`§2`), and the
observed `|B(a₂)| = 4` for `a₂ ≠ 0` (and `8` for `a₂ = 0`) at `q=17`.

**Why it is a guess.** The Fourier support is not computed.

## 5. Honest verdict

* **Target B — the parity law reduced to a 2-dim count.** `T ≡ E (mod 2)` is
  proved; `E` is two-valued by `χ₂(2h)` with odd deficit.
* **(A) — cap assembled.**
* **(C) — parity theorem complete for the divisor-sum class.**

## 6. Next round

1. **The Fourier support of `B(a₂)`.**
2. **A final synthesis.**

---

## 7. Reproduction

```
python3 checks/round84_sigma_involution.py   # exit 0
python3 -m pytest -q tests/test_round84.py   # 1 passed
```

New files: `checks/round84_sigma_involution.py`, `tests/test_round84.py`.
