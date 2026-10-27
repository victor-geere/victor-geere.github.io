/-
  Rh46 — root module of the rh46 Lean development.

  Importing this file checks that every module of the development elaborates and
  that there are no name clashes.

  * `Rh46.Chowla` — the algebraic/logical layer of the round "two-point Chowla
    and the finite-prefix obstruction": the Liouville function
    `liouville n = (-1)^(Omega n)` with `Omega` Mathlib's prime-factor count
    `ArithmeticFunction.cardFactors` (`Omega_eq_cardFactors`,
    `Omega_eq_factorization_sum`), its identification with Mathlib's
    `ArithmeticFunction.liouville` off zero (`liouville_eq_arithLiouville`), its
    range facts (`liouville_mem`, `liouville_ne_zero`, `liouville_sq`,
    `liouville_abs_le_one`) and its complete multiplicativity on nonzero
    arguments (`liouville_mul`, with the `0`-case refuted in
    `liouville_mul_zero_false`); the correlation
    `corr h N = ∑_{n ≤ N} λ(n) λ(n + h)` with the trivial bound `corr_abs_le`
    (`|corr h N| ≤ N`) and its sharpness witness `corr_zero` (`corr 0 N = N`,
    hence `corrAsymptotic_zero_false`); the non-multiplicativity of the Chowla
    summand (`shiftProd_two_five`,
    `shiftProd_not_completely_multiplicative`); and the finite-prefix / slice
    layer that is the logical core of the round — `slice_self`, `slice_agree`,
    `slice_sub_self`, `slice_abs_le_one`, `slice_ne_self_iff`, `slice_ne`,
    `corrSlice_eq_corr_of_lt`, `corrSliceSqSub`, and
    `corrSlice_ne_corr_self_statement`.

    The `Finset`-level identity identifying the exact perturbation of `corr` by
    one sign flip (`corrSlice_sub_corr_self_eq`) is recorded as a documented
    comment rather than elaborated; this is the single statement in the
    development that is not proved, and it is flagged in place.

    Two-point Chowla (`corrAsymptotic 2`) is **open**; nothing in the
    development asserts it.  There is no `sorry`, no project `axiom`, and no
    `native_decide` anywhere.
-/
import Rh46.Chowla
