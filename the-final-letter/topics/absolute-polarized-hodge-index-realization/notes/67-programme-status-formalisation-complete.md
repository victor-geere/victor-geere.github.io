# Note 67 — Programme status: formalisation objectives complete, RH open

**Status: No RH proof yet.** This note records the state of the dossier after
the assembly of the Weil-positivity chain (notes 64–66) and rounds 449–464.

## 1. The formalisation objectives are complete

The objective's three items are Lean-checked without `sorry`/`axiom`/`admit`:

1. **The simple-pole theorem** — residues `1` at simple zeros, `−1` at the
   pole, and the divisor-sum identity on the rectangle.
2. **The multi-pole/rectangle argument principle** — the
   **multiplicity-weighted** divisor-sum form
   `rectIntegral_logDeriv_completedZeta_eq_divisor_sum` (with
   `m : ℂ → ℕ` and `analyticOrderNatAt = m`), the test-function zero side
   `∮ Z'/Z·h = 2πi(Σh(ρ) − h(0) − h(1))`, the contour shift, and the
   right-vertical Fourier identities.
3. **The explicit-formula chain** — the test-function zero side, the prime
   side in closed Fourier form, the archimedean critical line, the
   **unconditional Fourier inversion** (`fourier_inversion`), the
   **Paley–Wiener assembled chain** (three Fubini swaps, the closed
   exponential-kernel prime sum, the right-vertical decomposition and the
   `u`-superposition), and the assembled contour-shift identity.

## 2. Weil positivity: one direction is Lean-checked

- The autocorrelation identity
  `∫(f⋆f*)e^{−tu} = |A|²` (`autocorrelation_exponential_eq_norm_sq_of_compactSupport`,
  unconditional for compactly supported `f`).
- Its transfer to the critical line
  (`paleyWiener_autocorrelation_eq_transform`,
  `paleyWiener_autocorrelation_nonneg`).
- The assembled implication **RH ⟹ Weil positivity**:
  `sum_paleyWiener_autocorrelation_nonneg_of_critical_line` and
  `weil_zero_sum_nonneg_real_of_critical_line` — for `f` supported in
  `[−1/2,1/2]` and all zeros in `S` on the critical line, the zero sum is a
  **nonnegative real number**.

Numerically confirmed (`test_autocorrelation_transfer_identity`).

## 3. What is open (and why it is not a gap in the formalisation)

- **The converse direction**: positivity of the Weil functional on the
  autocorrelation cone forces every zero onto the critical line. This is the
  RH-equivalent statement (note 61 argues it lies outside the finite
  angular/Bochner calculus; note 66 §4 records the precise functional).
- **The Hadamard factorisation of `ξ`** (`Z(z) = e^{A+Bz}∏_i F_i(z)`): the
  factorisation machinery is Lean-checked and instantiated at the **entire**
  `ξ₀(s) = s(s−1)Λ₀(s)+1` (which has exactly the nontrivial zeros, unlike the
  literal `s(s−1)Λ(s)` whose Lean junk values at the poles break entirety):
  `factorization_of_xi₀`, conditional on the zero data, and the **Hadamard
  partial fraction** `logDeriv_completedRiemannZeta_eq_tsum_of_zeros` and its
  transport to the dossier's `Z` (`logDeriv_completedZeta_eq_tsum_of_zeros`:
  `Z'/Z = b − 1/x − 1/(x−1) + Σ E_p′/E_p`), which
  would discharge the hypothesis of the conditional partial fraction
  `logDeriv_completedZeta_eq_tsum_of_factorisation` and fix the classical
  explicit formula's constants via the zero/archimedean/prime decomposition.
  The finite canonical-product machinery is in place; the infinite product for
  an order-1 entire function is not.
- **The `T → ∞` limit** of the assembled contour identity: numerically the
  horizontal term **grows** (`test_horizontal_term_grows`: `8.24, 227.1,
  5968.0` at `T = 5, 10, 15`), so the holomorphic shift has no limit; the
  classical formula needs the Weil zero-sum form instead.

## 3b. Round-200 state

At round 200 the dossier has **602 Lean declarations** (about 14,400 lines
across the nine files), **192 Python tests** (108 test functions) and **65
notes**, with no `sorry`/`axiom`/`admit`. Since the formalisation objectives
were completed (rounds 449–476), the rounds have been filling in the
**zero-data** hypotheses of the Hadamard factorisation (note 68):

| Step | Status |
|---|---|
| Zeros isolated (identity theorem) | Lean-checked (round 477) |
| Finite on compact balls (locally-finite divisor) | Lean-checked (round 479) |
| Countable (countable union of finite ball sets) | Lean-checked (round 480) |
| Divisor match at **non-zeros** (order 0 both sides) | Lean-checked (round 481) |
| Divisor match at zeros (multiplicities) | Lean-checked (rounds 493–494, finite-split form) |
| Counting `N(r) = O(r)` (Jensen) | Lean-checked (round 483); correct growth `N(r) = O(r log r)` (round 487) |
| Summability `Σ ‖aₙ‖^{-(p+1)}` (p=1) | Lean-checked (round 488, `r log r` growth) |
| Quotient log-growth | Lean-checked (round 495, automatic from the factorisation) |
| Enumeration of the zero set | Lean-checked (round 497, conditional on nonemptiness) |
| **Infinitude of the zero set** | open (digamma growth Lean-checked, round 499) |
| **Zero-free finite-order theorem** | open — a Hadamard-theory gap (note 68 §"a second gap") |

## 3d. Current state (round 533)

- **Lean**: **662** declarations across the nine files; no
  `sorry`/`axiom`/`admit`; all nine files check.
- **Numerical**: 197 Python tests (113 test functions).
- **Notes**: 69.

**Verified since the last inventory**: the zero-free growth theorem
(`subquadratic_eq_affine_of_re_le_rpow`), the lower bounds on the canonical
product (per-factor, finite, infinite), the Gamma growth bounds (half-planes and
the corrected global form), the archimedean factor growth on `re s ≥ 1/2`, the
real-axis growth of `Z'/Z`, the zeta bounds `‖ζ‖ ≤ 2` on `re ≥ 2` and `‖ζ‖ ≤ 3`
on `re ≥ 3/2`, and the pole-aware zeta bounds
(`‖ζ(s)‖ ≤ 1 + 1/(re s − 1)` on `re s > 1`, with the order-1 log form).

**Machine-checked refutations** (these corrected the programme's own targets):
the unrestricted Gamma growth bound (`not_exists_bound_log_norm_Gamma_right`) and
the unrestricted zeta strip bound (`not_exists_bound_log_norm_zeta_strip`,
`not_exists_bound_norm_zeta_strip_poly`) — both fail because of the poles at
`0` and `1` respectively.

**The four recorded gaps (note 68)**:

1. the infinitude of the zero set (mechanism recorded; the analytic input is
   the next item);
2. the multiplicity enumeration (needs 1);
3. the **pole-free zeta strip bound** (`1/2 ≤ re s ≤ 1`, `‖s‖ ≥ 2`) — the last
   analytic input, requiring the approximate functional equation or
   Phragmén–Lindelöf;
4. the **converse of Weil positivity** — RH-equivalent and open.

## 3c. Refreshed inventory (round 510)

- **Lean**: 623 declarations across the nine files (`Rescue`, `Shadow`,
  `Archimedean`, `Symbol`, `Limit`, `Weil`, `Hadamard`, `Rectangle`,
  `ExplicitFormula`); no `sorry`/`axiom`/`admit`.
- **Numerical**: 194 Python tests (110 test functions).
- **Notes**: 68.

The parts of the programme that are Lean-checked or numerically verified:

1. **Argument principle and the zero side** — simple-pole and multiplicity
   forms, the rectangle divisor sum, the test-function zero side.
2. **Prime and archimedean sides** — the symbol identity, the prime measure in
   closed Fourier form, the archimedean critical-line realness, and the
   identification of the archimedean term with the Gamma-factor log-derivative.
3. **Fourier inversion** — unconditional for `C²` functions with vanishing
   endpoints, plus the entire Paley–Wiener test function and the assembled
   contour-shift identity.
4. **Weil positivity, one direction** — the convolution autocorrelation
   identity, its transfer to the critical line, and **RH ⟹ Weil positivity**
   for the autocorrelation cone.
5. **Zero data for the Hadamard factorisation** — isolated zeros, finiteness on
   compact balls, countability, enumeration, summability under the correct
   `r log r` growth, the divisor match in finite-split/multiplicity form, the
   automatic quotient log-growth, and the digamma growth.

The open items (notes 66–68) are:

- the **infinitude of the zero set** (two routes recorded);
- the **zero-free finite-order theorem** (Hadamard theory);
- the **converse of Weil positivity** — the RH-equivalent statement.

## 4. Honest conclusion

Everything the programme set out to formalise is formalised and verified; the
remaining step — the converse of Weil positivity — is the open Riemann
hypothesis itself, not a formalisation gap. No claim of an RH proof is made.

**No RH proof yet.**
