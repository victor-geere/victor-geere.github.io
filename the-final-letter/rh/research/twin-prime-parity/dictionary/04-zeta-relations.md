# 04 — Zeta relations: budgets, the balance split, smoothing, the explicit formula

Part of the **twin-prime parity programme** dictionary.
See also: [`00-dictionary.md`](00-dictionary.md), [`02-greedy-harmonic-sine.md`](02-greedy-harmonic-sine.md),
[`../checks/06-numerical-checks.md`](../checks/06-numerical-checks.md).

This chapter collects everything the programme has proved about `ζ` — the part that
was *supposed* to build the bridge to parity, and the part that shows it does not.

---

## 1. The sign budgets (rh42)

**Theorem 1.1 (the even/odd split of ζ).**
```
P(p) = Σ_{k≥1} (2k)^{−p}    = 2^{−p} ζ(p)
N(p) = Σ_{k≥1} (2k+1)^{−p}  = (1 − 2^{−p}) ζ(p) − 1
η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p} = (1 − 2^{1−p}) ζ(p)   (p ≠ 1),   η(1) = ln 2
```
**Theorem 1.2 (the algebra).**  For every `p > 1`,
```
P + N = ζ(p) − 1 ,   P − N = 1 − η(p) ,   P = (ζ−η)/2 ,   N = (ζ+η−2)/2 ,
```
and `P(p) > N(p)` for all `p > 0` (the asymmetry is exactly `1 − η(p)`).
**Theorem 1.3 (the pole, halved).**  `P(p) ~ N(p) ~ 1/(2(p−1))` as `p ↓ 1`: the pole of
`ζ` appears **once on each side**.
*Status:* THEOREM (`rh42/lean/Rh42/Budget.lean` proves the closed forms
`P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`,
`P(2)+N(2) = π²/6 − 1` from Mathlib's `hasSum_zeta_two/four`) + NUMERICAL
(`rh42/verify/helix_zeta.log`).

> **The parity caveat — proved in rh47.**  These budgets separate **index** parity
> (even vs odd denominators).  They are *sign-blind* combinations of `ζ(p)`, i.e.
> constants, and they carry **no information about `Ω`-parity**.  Measured: the four
> cells `(n even/odd) × (Ω even/odd)` at `N = 10⁷` give `χ²(1) = 2.944` (`z = 0.99`),
> i.e. independence.  Moreover `Σ λ(n)(−1)^n λ(n+2)(−1)^{n+2} = Σ λ(n)λ(n+2)`
> exactly, so index parity is invisible to the correlation under study.

## 2. The exact reachable set (rh42)

**Theorem 2.1 (Brown's criterion).**  Let `a_1 ≥ a_2 ≥ … > 0` with `A = Σa_n < ∞`,
`T_n = Σ_{k≥n}a_k`, and `S` the set of sub-sums over arbitrary subsets.  Then
```
S = [0, A]   ⟺   a_n ≤ T_{n+1}   for every n .
```
*Proof (⟸).*  Run the greedy at `y ∈ [0,A]`; its residual decreases to `r ≥ 0`.  If
`r > 0`, choose `m` with `a_k < r` for all `k ≥ m`.  Every term from `m` on is taken.
Let `k₁` be the largest skipped index below `m` (it exists).  Then
`r_{k₁} = r + T_{k₁+1} > T_{k₁+1}` while the skip gives `a_{k₁} > r_{k₁}`, so
`a_{k₁} > T_{k₁+1}` — contradiction.
*(⟹).*  If `a_k > T_{k+1}`, any sub-sum `s < a_k` avoids `a_k` and all earlier
indices, so `s ≤ T_{k+1}`: the interval `(T_{k+1}, a_k)` is a gap.  ∎
*Status:* THEOREM (one-step lemmas machine-checked: `Rh42/Reachable.lean`).
*Warning (recorded):* the "one-step" form "*a non-increasing positive sequence whose
first term is at most the sum of the rest is complete*" is **REFUTED**
(`(1/2, 2/5, 1/20, 1/20)` has `a_1 = A − a_1 = 1/2` and misses `1/5`;
`single_condition_not_sufficient`).

**Theorem 2.2 (completeness thresholds).**
```
positive half complete (S = [0,P])  ⟺  ζ(p) ≥ 2            ⟺  p ≤ p* = 1.7286472389981836…
negative half complete (S = [0,N])  ⟺  N(p) ≥ 2·3^{−p}     ⟺  p ≤ q  = 2.0767751792…
```
**Theorem 2.3 (census).**  For `n < n_min(p)` the two pieces of
`S_n = S_{n+1} ∪ (a_n + S_{n+1})` are disjoint, so `S_1` is a union of exactly
`2^{n_min(p)−1}` intervals of total measure `2^{n_min−1} T_{n_min}`; the reachable
fraction of the budget collapses to `0` as `p → ∞`.
*Status:* THEOREM + NUMERICAL (`rh42/verify/reachable.log`, 70/70 checks).

## 3. The balance split at `Re(S) = 0` (rh43)

**Theorem 3.1 (the identity).**  With `S_N(t) = Σ_{n≤N} n^{−it}`, and `P_N, M_N` the
sums of the positive/negative real parts of the terms,
```
P_N + M_N = Re S_N(t) ,        P_N = |M_N|  ⟺  Re S_N(t) = 0 .
```
*Status:* THEOREM (Lean: `realPartial_eq_posRe_add_negRe`,
`balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`).

**Theorem 3.2 (attainability).**  For every `N ≥ 2` there is `t` with `Re S_N(t) = 0`:
`N = 2` balances exactly at `t = π/log 2` (a **tangential** zero — the first draft's
"N = 2 has no root" is REFUTED), and `N = 3` via `Re S_3(5/2) < 0 < 3 = Re S_3(0)`
(IVT; the certified value is `−0.084335758298…`).  Certified 47-digit root brackets
exist for `N = 3…50`; roots for all `N ≥ 3` follow from equidistribution
(PROOF-SKETCH + VERIFIED to `N = 200`).
*Status:* THEOREM (`N=3,4`, Lean) + NUMERICAL (brackets) + PROOF-SKETCH (all `N`).

**Theorem 3.3 (the complex split is a different question).**  `S_2(π/log 2) = 0`
exactly, while `S_3(t) ≠ 0` for **every** real `t` (reduce to `m log 2 = n log 3`,
i.e. `3^{|m|} = 2^{|n|}`).
*Status:* THEOREM (Lean: `zetaPartial_two_pi_div_log_two`,
`zetaPartial_three_ne_zero`).

**Theorem 3.4 (the linear divergence).**  `|S_N(t)|/N → 1/√(1+t²)`; equivalently
`S_N(t) = N^{1−it}/(1−it) + O(1)` is the dominant term at every fixed `t`.  So the
question is only well posed for **finite** partial sums.
*Status:* THEOREM (Euler–Maclaurin) + NUMERICAL (`|S_{10⁴}(1)| = 7071.771405`).

**Theorem 3.5 (the term-level split fails).**  At a balance point the *numbers*
`P/2, P/2, M/2, M/2` are two equal positive and two equal negative pieces, but the
*terms* usually cannot be partitioned into two equal sub-sums: at `N = 6`,
`P/2 = 0.830037…` while the best subset sums to `0.660075…` (exact defect
`0.169962576…`); at `N = 20` the exact defect is `0.005557721…`.
*Status:* NUMERICAL (exhaustive exact subset-sum).
*The obstruction:* `cos(t log 1) = 1` is the largest positive term; it exceeds `P/2`
whenever `P < 2`.

## 4. The critical line, and the failure of smoothing (rh43 §7.6, rh044)

**Theorem 4.1 (sharp error at a zero).**
```
S_N(1/2+it) − ζ(1/2+it) = N^{1−s}/(1−s) + ½N^{−s} − (s/12)N^{−s−1} + …
|S_N(1/2+it) − ζ(1/2+it)| / √N  →  1/|s−1| = 1/√(1/4+t²)
```
At the first zero `|S_N| ≈ 0.07070354·√N` — the partial sum *grows*; the zero exists
only in the cancellation.  (An earlier draft's constant `1/√(2t)` is **REFUTED** by a
factor `2.66`.)
*Status:* THEOREM (Euler–Maclaurin) + NUMERICAL (coefficients `0.49999959`,
`1.178630488 = |s|/12` checked at `N = 102400`).

**Theorem 4.2 (the smoothing law — the round's main result).**  For a weight `φ` with
convergent Mellin transform `M_φ(s) = ∫_0^1 φ(u)u^{−s}du`,
```
|S_N^φ(1/2+it) − ζ(1/2+it)| / √N   →   |M_φ(s)| ,
S_N^φ − ζ = N^{1−s}J_φ(s) + φ(0)ζ(s) + R_N .
```
**Smoothing does not remove the `√N`**; it rescales the constant.  Measured at
`N = 10⁵`, `t = 14.134725`:

| weight `φ(u)` | `\|E\|/√N` | `\|M_φ(s)\|` | ratio |
|---|---|---|---|
| `1` (sharp) | 0.070703705 | 0.070703528 | 1.0000025 |
| `u(1−u)` | 0.0049012629 | 0.0049012243 | 1.00001 |
| `(u(1−u))³` | 0.00011771845 | 0.00011771845 | 1.000000 |
| `(1−cos2πu)/2` | 0.0079729835 | 0.0079729835 | 1.000000 |
| `e^{−u}` | 0.026142297 | 0.026142378 | 0.999997 |

*Status:* THEOREM (asymptotic) + NUMERICAL (5–7 digits).
*Consequence:* bounded error would need `M_φ(s) = 0`, impossible for a nonnegative
weight — so no one-sided smoothing reaches `o(1)`.

**Theorem 4.3 (exponential accuracy needs the functional equation).**  Riemann's theta
identity
```
π^{−s/2}Γ(s/2)ζ(s) = 1/(s(s−1)) + ½[A(s)+A(1−s)] ,   A(s) = ∫_1^∞ x^{s/2−1}(θ(x)−1)dx
```
is verified to `5.7·10⁻⁶⁹` (`s=2`), `1.0·10⁻⁶⁴` (at `t = 14.13`), with tail bound
`e^{−πX}X^{−3/4}` (`X_min = 25` for `10⁻³⁰`).
*Status:* THEOREM (classical) + NUMERICAL.

## 5. The explicit formula (rh45)

**Theorem 5.1 (Weil form — with the archimedean term).**  For `g` even with
`φ(t) = ∫g(u)e^{itu}du` and `Φ(s) = φ((s−1/2)/i)`,
```
Σ_ρ Φ(ρ) = Φ(1) + Φ(0) − Σ_{n≥2}(Λ(n)/√n)[g(log n)+g(−log n)] + (1/2π)∫_ℝ φ(t)Ψ(t)dt ,
Ψ(t) = −log π + Re ψ(1/4+it/2) ,     Φ(1)+Φ(0) = 2φ(i/2) for even g .
```
*Status:* THEOREM (classical) + NUMERICAL (≥20 digits on four kernels:
residuals `1.6·10⁻⁴⁴`, `9.6·10⁻⁴⁶`, `−1.1·10⁻⁶³`).
**Draft errors, recorded as REFUTED:** omitting the archimedean term (size
`−1.196346718078`) and using pole arguments `F(1)+F(0)` instead of `2φ(i/2)` (size
`−0.659766246421`); the first Cauchy test had both, and a divergent prime side.

**Theorem 5.2 (counting).**  `N(T) = θ(T)/π + 1 + S(T)` exactly, and
`N(T) = (T/2π)log(T/2πe) + 7/8 + S(T) + O(1/T)`, `S(T) = (1/π)arg ζ(1/2+iT)`.
*Status:* THEOREM + NUMERICAL (residuals `3.32·10⁻⁴, 1.33·10⁻⁴, 6.63·10⁻⁵,
3.32·10⁻⁵, 2.21·10⁻⁵` at `T = 20, 50, 100, 200, 300`; exact form to `10⁻²⁰`;
independent `ζ'/ζ` count).

**Theorem 5.3 (zeros from the formula, not from the partial sum).**  With `ζ`
evaluations alone (sign changes of `Z(t)`) the first five zeros are located to
**32–33 digits**; the sharp partial sum cannot do this at any feasible `N`
(`|Re S_N(γ₁)| = 0.644, 6.986, 12.539, 36.052` at `N = 10³…10⁶`, growing).
*Status:* NUMERICAL (auditor, independent route).

## 6. The bottom line of this chapter

Every `ζ`-based structure in the programme — budgets, Brown completeness, the balance
split, smoothing, the explicit formula — is either **sign-blind** (index parity) or
**additive in `log n`**.  None of them couples to the multiplicative function `λ`, and
the correlation `Σλ(n)λ(n+2)` is not multiplicative, so none of the `ζ` machinery
applies to it (rh46).  That is the zeta-side content of the barrier
([`03`](03-parity-problem.md) §5).

*Status legend — THEOREM: proved (Lean where noted); NUMERICAL: finite computation
only; HEURISTIC: unproved; OPEN: no proof known; REFUTED: with a witness.*
