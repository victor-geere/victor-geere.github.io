# Note 57 — the test-function explicit formula and the prime side

**Status: No RH proof yet.** This note records the state after rounds 311–313:
the zero side of the explicit formula is now Lean-checked for an arbitrary test
function, and the pointwise prime-side identity with a test function is in
place. The remaining analytic gap is the Mellin/Fourier integration of `h`
against the prime series.

## 1. What is Lean-checked (test-function zero side)

`test_function_explicit_formula` (`lean/ExplicitFormula.lean`): for `h`
differentiable on an open `U` containing the closed rectangle, with
`F = s(s−1)Z` differentiable on `U`, its zeros in the rectangle exactly a
finite set `S` of simple zeros not containing `0,1`, and `Z` differentiable
off `0,1`,

```
∮ (Z'/Z)(z)·h(z) dz = 2πi·(∑_{ρ∈S} h(ρ) − h(0) − h(1)).
```

The linear case is `test_function_explicit_formula_linear`:
`∮ (Z'/Z)·s = 2πi(∑_ρ ρ − 1)`.

The proof chain (all Lean-checked):

| layer | theorem |
|---|---|
| analytic global remainder | `exists_analyticOnNhd_globalRemainder` |
| remainder differentiability off `S` | `differentiableOn_globalRemainder` |
| local residue subtraction (zero) | `exists_analyticAt_logDeriv_mul_sub_residue` |
| local pole subtraction | `exists_analyticAt_logDeriv_mul_add_residue_pole` |
| finite patching | `exists_analyticOnNhd_of_differentiableOn_compl_finset` |
| boundary decomposition | `logDeriv_mul_eq_remainder_plus_residues` |
| residue sum | `rectIntegral_sum_const_inv_sub` |
| residue assembly | `rectIntegral_logDeriv_mul_eq_residue_sum` |
| Cauchy integral formula (rectangle) | `rectIntegral_mul_inv_sub_eq` |

Numerically the formula is verified on `[−1,2]×[−30,30]` for
`h = 1, s, s², eˢ` (all within `10⁻⁶` or better), and on the second rectangle
`[−1.5,2.5]×[−20,20]` the predicted value `2πi(Σρ − 1) = 0` is confirmed to
`10⁻⁹`.

## 2. The pointwise prime side with a test function (Lean-checked)

`logDeriv_mul_I_eq_neg_arch_add_prime`: on `Re s > 1`,

```
Z'/Z(s)·h(s)·i = −( arch(s)·h(s)·i + L_Λ(s)·h(s)·i ),
arch(s) = (1/2)log π − (1/2)ψ(s/2),
```

obtained by multiplying the Lean-checked symbol identity by `h(s)·i`.

## 3. What remains for the full explicit formula

Integrating the pointwise identity along `Re s = c > 1` gives

```
∫ (Z'/Z)(c+iy)·h(c+iy)·i dy = −∫ arch(c+iy)·h(c+iy)·i dy − ∫ L_Λ(c+iy)·h(c+iy)·i dy.
```

This integrated identity is Lean-checked as
`integral_logDeriv_mul_I_eq_neg_arch_prime` (with the continuity of the
archimedean factor as an explicit hypothesis).

To turn the last term into a prime sum one inserts the absolutely convergent
series `L_Λ(c+iy) = Σ_n Λ(n) n^{-(c+iy)}` and integrates term by term:

```
∫ L_Λ(c+iy)·h(c+iy)·i dy = Σ_n Λ(n) ∫ n^{-(c+iy)}·h(c+iy)·i dy.
```

The inner integral is (up to a factor) the **Mellin/Fourier transform of `h`**
along the vertical line; it is the genuinely new analysis not yet formalised.
The required ingredients are:

1. **Continuity of digamma** along vertical lines `Re s = c > 1`: **done** in
   `AbsoluteHodgeArchimedean.continuousAt_digamma_of_re_pos` (via `Γ` analytic
   and nonzero on the right half-plane), and used in
   `integral_logDeriv_mul_I_eq_neg_arch_prime'`.
2. **Termwise integration with the `h` factor**: **done** in
   `integral_lseries_vonMangoldt_mul` (majorant `Λ(n) n^{-c} · sup|h|`), for
   continuous `h : ℝ → ℂ`.
3. **The Mellin transform** of `h` and its explicit evaluation for concrete
   `h` (e.g. Gaussian or compactly supported smooth test functions).
4. Shifting the contour from `Re = c` to the critical strip, with the
   horizontal sides controlled by decay of `h` — this is where the test
   function's decay enters the classical explicit formula.

## 4. The final frontier: Weil positivity

Even with the full explicit formula in hand, the Riemann hypothesis requires
**Weil's criterion**: positivity of the Weil functional on test functions
whose Fourier transform is supported in `[−1/2, 1/2]` (equivalently, the
infinite-level cone positivity of the arithmetic Hodge-index programme).
That positivity is the genuinely open statement; the contour identities above
are its analytic prelude, not its proof. **No RH proof yet.**
