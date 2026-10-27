# The harmonic monotone sum in closed form — and what it determines

Script: [`closed_form.py`](closed_form.py) (arbitrary precision, `decimal`, 60 digits).
Ladder: the Sylvester sequence `s_0 = 2`, `s_{j+1} = s_j² − s_j + 1`. Series:
`D(s) = Σ_{j≥0} s_j^{−s}`.

## 1. The closed form (exact, rational)

Two classical identities do all the work:

```
s_{j+1} − 1 = s_j (s_j − 1)              and, by induction,   s_{j+1} − 1 = s_0 s_1 ⋯ s_j ,
1/s_j = 1/(s_j − 1) − 1/(s_{j+1} − 1)    (the telescoping step)
```

Therefore

```
Σ_{j=0}^{k} 1/s_j  =  1 − 1/(s_{k+1} − 1)  =  1 − 1/(s_0 s_1 ⋯ s_k)      EXACT
Σ_{j≥0}    1/s_j  =  1                                                   EXACT
```

Verified exactly in rationals for `k = 1,2,3,4,5,8`, difference `0`:

```
k=8 :  Σ_{j≤8} 1/s_j = (N−1)/N ,   N = s_9 − 1 =
       165506647324519964198468195444439180017513152706377497841851388766535868639572406808911988131737645185442
```

So the **harmonic sum over the monotone (greedy) ladder is exactly `1`**, and every partial
sum is the rational `1 − 1/(s_0⋯s_k)`. This is the s=1 case of the Dirichlet series:

> **`D(1) = Σ_{j≥0} 1/s_j = 1` exactly.** (Computed at 60 digits:
> `1.0000000000000000000000000000000000000000`.)

That is the closed form. It is not a truncation and not an approximation; the tail
`1/(s_{k+1}−1)` is `6.04·10⁻¹⁰⁵` at `k = 8`.

## 2. What the closed form determines: the zero-free half-plane

`D(s) = Σ_j s_j^{−s}` converges exactly for `Re s > 0` (terms `s_j^{−σ}`, and `s_j → ∞`),
and at `Re s = 0` every term has modulus `1`, so the line is a natural boundary. Write
`σ = Re s`. The first term dominates when

```
Σ_{j≥1} (2/s_j)^σ  <  1 .
```

By the closed form, `Σ_{j≥1} 1/s_j = 1 − 1/s_0 = 1/2`, so **at `σ = 1` the sum equals
exactly `1`**, and it is strictly `< 1` for `σ > 1` because each `(2/s_j)^σ < (2/s_j)`.
Hence `|D(s)| ≥ 2^{−σ} − 2^{−σ}·(that sum) > 0`:

> **`D(s) ≠ 0` for `Re s ≥ 1`**, and the boundary `σ = 1` is *exact*, set by the
> telescoping closed form. (Strictness at `σ = 1` uses `ln 3/ln 2 ∉ ℚ`: equality in the
> triangle inequality would force `7^{1+2ℓ}2^{2k} = 3^{…}`, impossible by unique
> factorisation.)

This is the analogue of the Euler-product zero-free region `Re s > 1` for `ζ` — but here
it comes from the closed form, not from multiplicativity (the support has no Euler product,
[`phase2-arithmetic.md`](phase2-arithmetic.md) §(i)).

## 3. The zeros — in a strip, and computed to 60 digits

Since `D` is zero-free for `Re s ≥ 1` and undefined for `Re s ≤ 0`, all zeros lie in the
**strip `0 < Re s < 1`** — the analogue of the critical strip, with its edge at `σ = 1`.

**There is no canonical "first N zeros" here, and the earlier list of four was
incomplete.** Both facts have the same cause: the zeros **accumulate on the natural
boundary `Re s = 0`**, so the count in a box depends on how close to `0` the box is
allowed to come. For `Im s ∈ [0, 40]`, the rigorous argument-principle count is

| box | `Re s ≥ 0.30` | `≥ 0.15` | `≥ 0.08` | `≥ 0.04` | `≥ 0.02` |
|---|---|---|---|---|---|
| zeros with `Im s ≤ 40` | 3 | 5 | 9 | 14 | 18 |

(grid-stable: the `≥ 0.15` count is 5 at every resolution `n = 1200 … 3200`). So "the
lowest zeros" is not a well-defined list the way "the first zeta zeros" is; it grows as
the box approaches `Re s = 0`.

All zeros with `Re s ≥ 0.15`, `Im s ≤ 40` — argument-principle isolation, not a grid
search (an earlier heuristic grid found only four and **missed the fourth row here**):

| # | `Re s` | `Im s` | `\|D\|` |
|---|---|---|---|
| 1 | 0.199540315 | 3.247706177 | 6.5·10⁻¹⁶ |
| 2 | 0.954407453 | 7.544937313 | 7.3·10⁻¹⁷ |
| 3 | 0.829170729 | 22.942732184 | 2.1·10⁻¹⁶ |
| 4 | 0.189032493 | 27.208406632 | 2.8·10⁻¹⁵ |
| 5 | 0.900472653 | 38.045210905 | 3.0·10⁻¹⁵ |

All five are unchanged when the truncation is raised from `J = 12` to `J = 17` (the tail
`s_12^{−σ}` is already `~10⁻¹⁶⁶` at `σ ≈ 0.2`), so they are zeros of the full series.

The real parts are scattered across `(0.19, 0.95)`, not on any line: there is no Riemann
hypothesis here, and none is claimed. The missed zero to 60 digits:

```
0.189032493007384312051385227263988251468618534034613168121967
+ 27.2084066319251914941404421027271089222340987027643470368660 i     |D| = 1.7·10⁻⁵⁸
``` The two-term truncation `2^{−s} + 3^{−s}`
has its zeros exactly on the boundary `Re s = 0` (at `iπ(2k+1)/ln(1.5)` = 7.7481i,
23.2444i, …), but those are **not** zeros of `D`: at `s = 7.748120839i`, `|D| = 2.4051`.
Adding the further terms moves the zeros strictly inside the strip.

**Arbitrary precision** (this is the part I previously refused to do): Newton in
`decimal` at 60-digit working precision, with the analytic derivative
`D′(s) = −Σ_j ln(s_j)·s_j^{−s}`, converges to

```
s = 0.954407453375382029817860242791165227965565090214484953654803
  + 7.5449373131967416008436413419172624409498508470475590962724 i

|D(s)| = 5.4·10⁻⁶⁰      (i.e. zero to the full working precision)
```

Also at 60 digits: `D(1) = 1.0000000000000000000000000000000000000000` and
`D(2) = 0.3820604135145079238711218749813269823790`.

## 4. Corrections to what I said before

Two claims in [`phase2-arithmetic.md`](phase2-arithmetic.md) were wrong and are corrected
here:

1. **"the zeros live in `Re s < 0` and need high precision because `n_j^{|σ|}` overflows
   float64."** Wrong on both counts. The series **diverges** for `Re s ≤ 0` (there is no
   function there — that line is the natural boundary), and for `Re s > 0` the terms
   *decay*, so float64 locates the zeros with no overflow at all. High precision is needed
   for accurate *values*, not to avoid overflow.
2. **"zeros accumulate on `Re s = 0`."** They do not accumulate there; the zeros sit
   strictly inside the strip `0 < Re s < 1`, and the boundary is zero-free for the full
   series (`|D(7.748i)| = 2.4`).

The Mahler relation `D(s) − D(2s) = 2^{−s}` for the geometric model, and its asymptotic
form for the true ladder, stand as in Phase 2.

## 5. The general-`s` sum: no elementary closed form, but an exact functional equation

For general `s` there is no telescoping: the sum satisfies the **Mahler equation**

```
g(x) − g(x² − x + 1) = x^{−s} ,      D(s) = g(2) − g(∞) .
```

For the model substitution `x → x²` the solution is the lacunary series
`g(x) = Σ_j x^{−s 2^j}`, i.e. `D_model(s) = Σ_j (q^{2^j})^{−s}` — closed in the sense of
being a Mahler function, and that is what forces the natural boundary at `Re s = 0`. The
true ladder differs by `O(s Σ_j s_j^{−2s−1})` (the measured `ε(s)` of Phase 2).

*Status — THEOREM: the telescoping identity and the closed forms `Σ_{j≤k}1/s_j =
1 − 1/(s_{k+1}−1)`, `Σ_{j≥0}1/s_j = 1`; the zero-free half-plane `Re s ≥ 1`; zeros confined
to `0 < Re s < 1`; the Mahler equation. NUMERICAL/ARBITRARY-PRECISION: `D(1) = 1` and
`D(2)` to 60 digits; one zero to 60 digits (`|D| = 5.4·10⁻⁶⁰`); the four lowest zeros.
CORRECTED: two claims of Phase 2 (see §4).*

---

## 6. Adversarial audit — and the corrections it forced

An independent adversarial agent (mpmath 1.3 on miniforge, its own scripts, no access to
my runs) audited every claim. I re-verified each hit myself in mpmath. **All of them stand.**

### 6.1 The "critical line" claim is FALSE (independently confirmed)

The advisor's `N(a,T)` = number of zeros with `Re s ≥ a`, `0 < Im s ≤ T`, by winding
numbers (its own step-refinement, clean integers):

| `a` \ `T` | 40 | 80 | 120 | 200 |
|---|---|---|---|---|
| 0.30 | 3 | 8 | 14 | 19 |
| 0.15 | 5 | 12 | 19 | 30 |
| 0.08 | 9 | 22 | 35 | 63 |
| 0.04 | 21 | 40 | 64 | 110 |
| 0.02 | 43 | 77 | 113 | 187 |
| 0.01 | 74 | 138 | 207 | 323 |

Positive density at **every** fixed `a`, growing in `T`, with real parts spread — no line,
no curve, no drift to one. I independently reproduced the counts `9, 21, 43` for
`a = 0.08, 0.04, 0.02` at `T = 40` by my own mpmath winding integral (stable under step
`4·10⁻³ → 2·10⁻³`). The only concentration is on the **natural boundary** `Re s = 0`:
`N(a,40) = 21, 43, 74, 115, 149` for `a = 0.04, 0.02, 0.01, 0.005, 0.004`, unbounded as
`a → 0⁺`. `D` is not even defined on that line. There is no critical line.

### 6.2 My zero counts were wrong

| `Re s ≥` | 0.30 | 0.15 | 0.08 | 0.04 | 0.02 |
|---|---|---|---|---|---|
| I claimed | 3 | 5 | 9 | **14** | **18** |
| **true** | 3 | 5 | 9 | **21** | **43** |

And my "41 zeros" was short. The audit's own Newton enumeration found 42 of the 43 in
`Re ≥ 0.02, Im ≤ 40`, including **three I had missed**:

```
0.02214481356445842832384014 + 5.239251109090609221155957i
0.02435051916791447566174284 + 10.78128716487203132513111i
0.02389191477597297464370324 + 19.14112244115680523483089i
```

I verified all three in mpmath to `|D| ~ 10⁻³⁹` at 40 dps: **genuine**. The cause of my
shortfall was exactly what the audit says — a mesh of size `h` only sees `|D| ~ |D′|·h`,
and `|D′| ~ O(10²)` here, so `h ~ 10⁻²` is blind to zeros unless a node lands within
`~10⁻³` of one. My "stable as `J = 12 → 17`" check was worthless as validation: the
truncation error is `~10⁻¹⁶⁰⁰`, not the error source.

### 6.3 C3's proof was a non-sequitur

"Diverges on `Re s = 0`, hence a natural boundary" is **false as an inference**: the
alternating series `Σ(−1)^{n−1}n^{−s}` also diverges everywhere on `Re s = 0` yet continues
to `(1−2^{1−s})ζ(s)`. The correct input is **Fabry's gap theorem**: with `z = e^{−s}`,
`D = Σ_j z^{λ_j}` with `λ_j = ln s_j` and `λ_j/j → ∞` (`λ_j ~ c·2^j`), so `|z| = 1` is a
natural boundary. Conclusion unchanged; the proof must cite Fabry.

### 6.4 C4's argument at `σ = 1` was sloppy

The triangle bound gives `|D| ≥ 2^{−1} − 1/2 = 0` — vacuous, so "strictness" does not
follow from it. It needs a separate equality-case analysis: if `D(1+iτ) = 0` then
`|Σ_{j≥1}a_j| = 1/2 = Σ_{j≥1}|a_j|`, so all tail terms are parallel; comparing the `j=0,1,2`
phases gives `τ ln(3/2) ≡ π` and `τ ln(7/3) ≡ 0 (mod 2π)`, forcing `ln(3/2)/ln(7/3) ∈ ℚ`,
i.e. `(3/2)^q = (7/3)^p`, impossible by unique factorisation. Note the pair I cited,
`ln3/ln2`, was the wrong one. Conclusion (`D ≠ 0` for `Re s ≥ 1`) stands.

### 6.5 C8's error term was wrong

The exact identity is `D(s) − D(2s) = 2^{−s} − E(s)` with
`E(s) = Σ_j (s_j^{−2s} − s_{j+1}^{−s})`. That is **not** `O(s Σ_j s_j^{−2s−1})`: the `j=0`
term alone is `2^{−2s} − 3^{−s}`, of size `3^{−s}`. Verified in mpmath:

| `s` | 1 | 2 | 4 | 8 | 16 | 32 |
|---|---|---|---|---|---|---|
| true correction | 0.11793959 | 0.056797949 | 8.7036·10⁻³ | 1.3731·10⁻⁴ | 2.2998·10⁻⁸ | 5.3961·10⁻¹⁶ |
| my claimed bound `s·Σs_j^{−2s−1}` | 0.164965 | 0.070849 | 8.0158·10⁻³ | 6.1097·10⁻⁵ | 1.8626·10⁻⁹ | 8.6736·10⁻¹⁹ |

The true correction **exceeds** my bound for `s ≥ 4` and tends to `3^{−s}`
(`3^{−32} = 5.3966·10⁻¹⁶` vs measured `5.3961·10⁻¹⁶`). My earlier "0.236 / 2.3·10⁻⁶" were
the *relative* corrections `(2/3)^s`, a different quantity — reported without saying so.
The model relation `D(s) − D(2s) = q^{−s}` remains exact.

### 6.6 C9 was overstated

"No Euler product, no classical functional equation" is right. "The only structure is the
Mahler self-similarity / no arithmetic" is too strong: the `σ = 1` zero-free proof *uses
unique factorisation*, the telescoping identity is arithmetic in `s_j`, the Sylvester
numbers are pairwise coprime (`s_{j+1} ≡ 1 mod s_j`), and Vardi's closed form
`s_j = ⌊θ^{2^{j+1}} + 1/2⌋` holds. Arithmetic enters the analytic structure.

### 6.7 What survived

`C1`, `C2`, `C5`, and C4's **conclusion** are untouched. `C7`'s conclusion stands but for a
sharper reason: `N(a,T) → ∞` as `a → 0⁺` at fixed `T` puts infinitely many zeros in a
compact height window, so imaginary parts accumulate and no ordered list is well founded
past the first few — though a lowest-lying zero does exist (`N(0.001, T) = 0` for `T ≤ 0.5`).
