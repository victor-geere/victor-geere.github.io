# Structural generalisation #6 — Dirichlet L-functions: replacing the parity sieve by a character sum

**Package** `research/twin-prime-parity/007/`
**Origin** `research/twin-prime-parity/006/handoff.md` §11, item 6, verbatim:

> **Dirichlet L-functions.** Replace the parity sieve by a character sum,
> `a_k = χ(k) k^{−p}`, and study the twisted threshold function
> `Φ_χ(p,n) = n^p Σ_{j≥0} χ(n+j+1)(n+j+1)^{−p}`. The interesting question is how
> much of the OP-5 second-order expansion survives when `χ` is non-principal.

**Status** leading law, threshold criterion, second-order deformation, parity
closed forms and two non-existence theorems established; the positive-direction
asymptotics are numerically established, the algebraic core is machine-checked
(Lean, `lean/`, **0 `sorry`, 0 `axiom`, footprint `propext, Classical.choice,
Quot.sound`**).

---

## 0. One-paragraph answer

The substitution is exact and elementary. Writing `c` for the periodic
coefficient, the twisted boundary functional is a **character-weighted geometric
sum** in `x = e^{−p/n}`:

```
n^p Σ_{m>n} c(m) m^{−p}  =  Σ_{j≥1} c(n+j) (1 + j/n)^{−p}  ⟶  F_r(x),
F_r(x) = Σ_{j≥1} c(r+j) x^j = f_r(x)/(1 − x^q),   r = n mod q.
```

OP-5 is the case `c ≡ 1` (`q = 1`), where `Σ x^j = 1` forces `x = 1/2`,
`a = log 2`, and where the second-order expansion gives
`p = a n + (3/2)log 2 + c₅/n + O(1/n²)` with `c₅ = 3(log 2)² − (25/12)log 2`.

**The whole second-order expansion survives, with `F_r(x) = 1` in place of
`Σ x^j = 1` and character-twisted moments in place of `S_m = Σ j^m 2^{−j}`.**
But the leading equation is no longer guaranteed to have a root: for the trivial
coefficient `F_r → +∞` at `x → 1⁻` (positive period mean), whereas a
non-principal character has **zero period mean** and `F_r` is bounded on
`[0,1]`. Whether the character twist admits a threshold then becomes an
arithmetic condition on `(χ, r)`:

* for `χ₃ (mod 3)` and `χ₄ (mod 4)` we **prove** `F_r(x) < 1` for all `r` and
  all `x ∈ [0,1)`: the threshold is destroyed;
* for the real characters mod 11, 13, 23, 47, … a root exists and the full
  expansion holds with character-determined constants (`a = −log x*`, `g`, `c`);
* across all real characters mod `q ≤ 60` (187 characters, 4537 `(χ,r)` pairs),
  1349 pairs (29.7 %) have a threshold.

---

## 1. The substitution, made exact

For a `q`-periodic `c : ℕ → ℝ` define

```
Φ_c(p,n) = Σ_{j≥1} c(n+j) (1 + j/n)^{−p}          (the twisted boundary functional)
F_r(x)   = Σ_{j≥1} c(r+j) x^j                       (the twisted generating function)
f_r(x)   = Σ_{s=1}^{q} c(r+s) x^s                   (the block polynomial)
```

**Proposition 1 (regrouping / finite Fourier).** For `0 < q`, `c(m+q) = c(m)`,
`0 ≤ x < 1`:

```
F_r(x) = f_r(x) / (1 − x^q).
```

*Proof.* Group `j` by residue mod `q` and sum the resulting geometric series. ∎
(Machine-checked: `Op57.F_eq_fblock`.)

Substituting `x = e^{−a}`, `p = a n`, and expanding
`(1 + j/n)^{−p} = e^{−aj}(1 + O(1/n))`, this gives the **limit law**

```
Φ_c(p,n)  =  F_{n mod q}(e^{−a})  +  O(1/n)      (n → ∞, a = p/n fixed).   (LIMIT)
```

Eq. (LIMIT) is the precise sense in which the parity sieve is replaced by a
character sum: the geometric main term `Σ_{j≥1} x^j` of OP-5 becomes the
character sum `Σ_{j≥1} c(r+j) x^j`.

**Numerical confirmation** (`verify/02_leading_law.py`, `a = 0.7`,
`n ≈ 2·10⁵`, `|Φ_c − F_r(e^{−a})|`):

| `c` | `q` | max over `r` of the error |
|---|---|---|
| `c = 1` (OP-5) | 1 | `1.0·10⁻⁵` |
| parity `1_{2\|m}` | 2 | `5.2·10⁻⁶` |
| `χ₃` | 3 | `3.8·10⁻⁷` |
| `χ₄` | 4 | `6.7·10⁻⁷` |
| `χ₅` | 5 | `1.0·10⁻⁶` |
| principal mod 3 | 3 | `7.0·10⁻⁶` |

and `verify/05_limit_rate.py` shows `n·(Φ_c − F_r(e^{−a}))` converges to a
constant for `c = 1`, the parity sieve, `χ₃` and `χ₁₁` — so the error is exactly
`O(1/n)`, not merely `o(1)`:

```
c = 1:       n(Φ−F) → 2.03885351…
parity q=2:  r=0 → 1.00637547…   r=1 → 1.03247805…
χ₃  q=3:     r=0 → −0.03405277   r=1 → −0.04134778   r=2 → +0.07540055
```

---

## 2. The leading equation, and when it has a root

Set `x = e^{−a}`. The leading order of (LIMIT) is

```
F_r(x) = 1.                                                     (LEAD)
```

**Principal/trivial coefficients** (`c ≡ 1`; residue-class indicators; principal
characters): the period mean `q^{-1}Σ_s c(s)` is positive, so `f_r(1) ≠ 0` and
`F_r(x) → ±∞` as `x → 1⁻`. A root always exists, and OP-5's structure carries
over verbatim.

**Parity sieve** `c = 1_{2|m}` (`q = 2`): (LEAD) regroups into
`x^s/(1 − x^2) = 1`, i.e. `x^s = 1 − x^2`, where `s = 2` for even `r` and `s = 1`
for odd `r`. Hence

```
r even:   x² = 1/2           x = 1/√2          a = (1/2) log 2 = 0.3465735903
r odd:    x² + x = 1         x = (√5−1)/2      a = 0.4812118251
```

Both are quadratic irrationals: the rate is *forced* by the character equation
exactly as `x = 1/2` is forced in OP-5. (Machine-checked:
`Op57.leading_forced_parity_even`, `…_odd`, `…_even_eq`, `…_odd_eq`; the general
case is `Op57.leading_forced_of_hasSum_geom`: `x^s = 1 − x^q`.)

**Non-principal characters**: zero period mean, so `f_r(1) = 0` and `F_r` is
continuous on `[0,1]` with the *endpoint value*

```
F_r(1⁻) = −f_r'(1)/q = −(1/q) Σ_{s=1}^{q} s · c(r+s) .
```

A threshold exists iff `max_{x∈[0,1)} F_r(x) ≥ 1`, an arithmetic condition on
`(χ, r)`. It can fail in two ways: `F_r < 1` throughout (no threshold), or
`F_r` attains a maximum `≥ 1` (threshold exists, with `x*` the largest root).

---

## 3. How much of the OP-5 second-order expansion survives

Wherever (LEAD) has a root `x`, the OP-5 expansion deforms **without change of
shape**. With the twisted moments

```
S_m(r) = Σ_{j≥1} c(r+j) j^m x^j ,     a = −log x ,
g = a S_2(r) / (2 S_1(r)) ,
D₀ = ½(g²S_2 − a g S_3 + (a²/4) S_4) + (g/2) S_2 − (a/3) S_3 ,
c = D₀ / S_1(r) ,
```

the threshold `p(n)` of `Φ_c(p,n) = 1` satisfies

```
p(n)  =  a n  +  g  +  c/n  +  O(1/n²).                          (OP-5′)
```

**Calibration.** `c ≡ 1`, `q = 1` gives `x = 1/2`, `a = log 2`,
`g = (3/2) log 2`, and `c = 3(log 2)² − (25/12) log 2 = −0.00269758441194845…`,
i.e. **exactly the constant `c₅` proved in 006** (agreement to `2·10⁻⁴¹` at
40 dps). The deformation reproduces the known theorem rather than replacing it.
(`verify/04_second_order.py`.)

**Parity sieve**, from (OP-5′) with a direct numerical solve of `Φ_c(p,n) = 1`:

| `r` | `x*` | `a` | `g` | `c` |
|---|---|---|---|---|
| even | `1/√2` | `0.3465735903` | `(3/2)log 2 = 1.0397207708` | `−0.0053951688` |
| odd | `(√5−1)/2` | `0.4812118251` | `0.9684201172` | `+0.0203439630` |

The `n·(p(n) − (a n + g))` column converges to `c` at the expected `O(1/n)` rate
(e.g. `−0.0054016, −0.0053978, −0.0053958, −0.0053954, −0.0053952` for
`n = 2·10³ … 2·10⁵`).

**A non-principal character with a root**, `χ₁₁ = (·|11)` (Legendre symbol),
`r = 2`: `x* = 0.6437333937`, `a = 0.4404706236`, `g = −0.4467569001`,
`c = −0.2454347549`, again with the predicted `O(1/n)` drift. **This is the case
the handoff asked about: the second-order expansion survives in full**, with
constants produced by the character sum. What fails for *other* characters is not
the expansion but its leading equation.

---

## 4. Where the threshold is destroyed (proved)

For `χ₃` (mod 3) and `χ₄` (mod 4) the block polynomials are explicit:

```
χ₃:  f₀ = x − x²,  f₁ = x³ − x,  f₂ = x² − x³      (so F_r = f_r/(1 − x³))
χ₄:  f₀ = x − x³,  f₁ = x⁴ − x²,  f₂ = x³ − x,  f₃ = x² − x⁴   (÷ 1 − x⁴)
```

and each satisfies the strict inequality `F_r(x) < 1` on `[0,1)`:

```
χ₃, r=0 :  x − x² < 1 − x³  ⟺  (1−x)(1+x²) > 0
χ₃, r=1 :  x³ − x < 1 − x³  ⟺  (1−x)(2x²+2x+1) > 0
χ₃, r=2 :  x² − x³ < 1 − x³  ⟺  x² < 1
χ₄, r=0 :  (1−x)(1+x³) > 0        χ₄, r=2 :  (1−x)(1+x)(1+x+x²) > 0
χ₄, r=1 :  (1−x)(1+x)(2x²+1) > 0  χ₄, r=3 :  (1−x)(1+x) > 0
```

**Theorem (machine-checked).** For `c ∈ {χ₃, χ₄}`, every `r` and every
`x ∈ [0,1)`: `F_r(x) < 1`. Consequently the leading equation `F_r(x) = 1` has
**no solution**, and there is no OP-5 threshold to expand.
(`Op57.chi3_F_lt_one`, `Op57.chi4_F_lt_one`,
`Op57.chi3_no_leading_threshold`, `Op57.chi4_no_leading_threshold`.)

This is the sharp structural difference from OP-5: there, positivity of the
alphabet makes `F_r → +∞` and a threshold existence is automatic; for a
zero-mean character, existence is a genuine condition that can fail.

---

## 5. Numerics of the criterion

`verify/03_character_scan.py` enumerates **every** real Dirichlet character mod
`q` for all `q ≤ 60` (homomorphisms `(ℤ/q)^* → {±1}`), and for every residue `r`
finds the exact maximum of `F_r` on `[0,1)` by root-finding on the numerator of
`F_r'` (a polynomial of degree `≤ 2q−1`), together with the endpoint
`−f_r'(1)/q`.

```
real characters scanned               : 187
non-principal among them              : 128
(χ, r) pairs scanned                  : 4537
pairs with a threshold (max F_r ≥ 1)  : 1349   (29.7 %)
global max of max_r max_x F_r         : 5.000  (q = 47, r = 0, at x → 1⁻)
```

The maximum `5.0` at `q = 47` is an endpoint value `−f_r'(1)/q > 1`, so the root
sits near `x = 1` (a slow, `a → 0` threshold). At the other extreme `χ₃` peaks at
`1/3` and `χ₄` at `1/2`, both `< 1`.

**Principal characters** always have a threshold (`F_r → +∞`); their
density-scaled leading constants are, e.g., `q=3: x*=0.5436890127`,
`q=5: x*=0.5086603916`, `q=7: x*=0.5020170552`, `q=12: x*=0.7044075244`.

---

## 6. Status table

| item | status |
|---|---|
| regrouping `F_r = f_r/(1−x^q)` | **PROVED** (Lean `Op57.F_eq_fblock`) |
| forced leading equation `x^s = 1 − x^q` | **PROVED** (Lean `Op57.leading_forced_of_hasSum_geom`) |
| parity sieve constants `1/√2`, `(√5−1)/2` | **PROVED** (Lean, incl. exact roots) |
| `F_r < 1` for `χ₃`, `χ₄`, all `r` (no threshold) | **PROVED** (Lean `Op57.chi3_F_lt_one`, `Op57.chi4_F_lt_one`) |
| limit law `Φ_c → F_r(e^{−a})`, error `O(1/n)` | **NUMERICAL** (stable `n·err`; proof is standard Abel/Euler–Maclaurin) |
| threshold criterion `max F_r ≥ 1` | **NUMERICAL** + proved non-existence for `χ₃`, `χ₄` |
| second-order deformation (OP-5′) and calibration to `c₅` | **NUMERICAL** (calibration is exact at 40 dps; algebraic part is `ring`) |
| exhaustive criterion scan, `q ≤ 60` | **NUMERICAL** |

Nothing here is claimed about the Riemann Hypothesis. The result is a structural
statement about a family of elementary boundary functionals: the parity sieve can
be replaced by a character sum, the OP-5 second-order expansion survives as an
*identity* with character-twisted constants, and the *existence* of the threshold
it expands is governed by whether the character sum `Σ c(r+j)x^j` reaches `1` —
which for a non-principal character it need not.

---

## 7. Relation to the 006 development

* 006's anchor `leadingCoeff_forced` (`Σ_{j≥1} x^{j+1} = 1 ⊢ x = 1/2`) is the
  `c ≡ 1`, `q = 1` case of (LEAD); §2 is its parity/character generalisation.
* 006's `c₅ = 3(log 2)² − (25/12)log 2` is reproduced *by the deformation
  formula* (OP-5′) at `c ≡ 1`, so the twisted expansion is a strict extension of
  the 006 theorem, not a parallel theory.
* 006's parity alphabet `a_k = (2k)^{−p}` becomes `c = 1_{2|m}` here; the
  "character sum" of the handoff is the general periodic `c`, of which the
  Dirichlet characters are the zero-mean (Fourier) atoms.
