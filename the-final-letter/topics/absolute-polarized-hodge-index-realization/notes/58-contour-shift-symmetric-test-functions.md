# Note 58 — contour shift with symmetric test functions

**Status: No RH proof yet.** This note records the remaining step toward the
full explicit formula: the contour shift for a general test function. The
algebra for a symmetric test function is elementary (text-proof); the `h ≡ 1`
case of each ingredient is already Lean-checked.

## 1. The symmetric class

Let `h : ℂ → ℂ` satisfy

1. **reflection symmetry**: `h(1 − s) = h(s)`,
2. **reality symmetry**: `h(conj s) = conj(h(s))`.

Then `h(0) = h(1)` and `h` is real on the real axis. Write
`Φ(z) = (Z'/Z)(z)·h(z)`.

## 2. The contour identity (Lean-checked for general `h`)

`test_function_explicit_formula` gives, for the rectangle
`[1−c, c] × [−T,T]` with `c > 1` and the appropriate divisor hypotheses,

```
∮ Φ dz = 2πi·(∑_{ρ} h(ρ) − h(0) − h(1)) = 2πi·(∑_ρ h(ρ) − 2h(0)),
```

the last equality by `h(0) = h(1)`.

## 3. The left side (text-proof; `h ≡ 1` Lean-checked)

Substituting `y ↦ −y` and using `1 − (c+iy) = (1−c) − iy`:

```
Left = ∫ Φ((1−c)+iy)·i dy = ∫ Φ(1−(c+iy))·i dy
     = −∫ Φ(c+iy)·i dy = −Right,
```

because `Z'/Z(1−w) = −Z'/Z(w)` (functional equation) and `h(1−w) = h(w)`.
For `h ≡ 1` this is `integral_logDeriv_completedZeta_left_eq_neg_right`
(Lean-checked); the pointwise core for general `h` is Lean-checked as
`logDeriv_mul_one_sub`, and the integrated version at `c = 2` as
`integral_logDeriv_mul_left_eq_neg_right_two`.

## 4. The horizontal sides (text-proof; `h ≡ 1` Lean-checked)

Using `Z'/Z(conj w) = conj(Z'/Z(w))` and `h(conj w) = conj(h(w))`,

```
Φ(x−iT) = conj(Φ(x+iT)),  hence  Bottom = conj(Top),
```

so the horizontal difference is `Bottom − Top = conj(Top) − Top = −2i·Im(Top)`,
purely imaginary. For `h ≡ 1` the precise reflection identities are
Lean-checked (`integral_logDeriv_completedZeta_bottom_eq_neg_top`,
`..._bottom_eq_conj_top`, `..._top_pure_imaginary`); the general-`h` integrated
version is `integral_horizontal_bottom_eq_conj_top_two`.

## 5. The resulting identity

This assembly is Lean-checked as `contour_shift_symmetric'` (with the two
reflection relations discharged and the integrability of the top integrand as
the only analytic hypothesis): `(Σ_ρ h(ρ) − h(0) − h(1))·2πi
= 2i·Right − 2i·Im(Top)`.

Combining §§2–4:

```
2πi·(∑_ρ h(ρ) − 2h(0)) = (conj(Top) − Top) + 2·Right
                       = −2i·Im(Top) + 2·Right.
```

Hence

```
∑_ρ h(ρ) = 2h(0) + Right/(πi) − Im(Top)/π.
```

Now `Right = i·∫_{−T}^{T} Φ(c+iy) dy`, and the prime-side identity
(`integral_logDeriv_mul_I_eq_neg_arch_prime'`, Lean-checked) evaluates it as

```
Right = −i·(∫ arch(c+iy)·h(c+iy)·i dy) − i·(∫ L_Λ(c+iy)·h(c+iy)·i dy),
```

with the second integral equal to the von Mangoldt term sum
(`integral_lseries_vonMangoldt_mul`, Lean-checked).

## 6. The limit `T → ∞`, and why it is not a holomorphic contour limit

The finite-`T` identity is Lean-checked. The passage to the classical explicit
formula is **not** a direct `T → ∞` limit of this identity, for a structural
reason:

- a **holomorphic** test function cannot decay in both horizontal directions
  while remaining bounded on the strip (Liouville-type argument);
- the Gaussian `exp(−(s−1/2)²)` **grows** along horizontal lines:
  `Re(−(s−1/2)²/1000) = (T² − (x−1/2)²)/1000 → +∞`;
- a **Paley–Wiener** function `h(s) = ∫_{−a}^{a} g(u)e^{i(s−1/2)u}du` with
  `g ∈ L¹` is entire of exponential type and also **grows**:
  `|h(x+iT)| ≤ e^{a|T|}·‖g‖₁`.

The classical Weil explicit formula is instead derived with a **test function
on the critical line** (a function `h(t)` of the real variable `t`, compactly
supported or rapidly decaying), by integrating `(ξ'/ξ)(1/2+it)h(t)` over `t`
and using the Fourier transform of the prime measure; see e.g. Weil,
*Sur les formules explicites de la théorie des nombres premiers* (1972), or
Iwaniec–Kowalski, *Analytic Number Theory*, Thm 5.12. The contour-shift
identity above is a finite-`T` contour identity for holomorphic symmetric `h`;
it is a genuine piece of the chain, but it is not the step that produces the
classical formula.

The identity is numerically confirmed for the Paley–Wiener example
`h(s) = 2 sin(s−1/2)/(s−1/2) = ∫_{−1}^{1} e^{i(s−1/2)u} du` to relative
precision `10⁻¹⁷`; this checks the contour identity (finite `T`), not a
`T → ∞` limit.

## 7. What remains

- ~~Formalise the two reflection lemmas for general symmetric `h`~~ — **done**:
  `logDeriv_mul_one_sub`, `logDeriv_mul_conj`,
  `integral_logDeriv_mul_left_eq_neg_right_two`,
  `integral_horizontal_bottom_eq_conj_top_two`, and the assembly
  `contour_shift_symmetric'` (with `contour_shift_gaussian` as a concrete
  finite-`T` instance).
- **Formalise the critical-line route**: a test function `h(t)` on the line,
  the Fourier transform of the prime measure, and the classical Weil explicit
  formula. This is the analytic step that the holomorphic contour identity
  does *not* supply (see §6).
- Then **Weil's criterion / infinite-level cone positivity**, the genuinely
  open statement. **No RH proof yet.**
