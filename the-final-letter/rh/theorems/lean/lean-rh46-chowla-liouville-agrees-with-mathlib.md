# The bridge to Mathlib: λ agrees with ArithmeticFunction.liouville at every nonzero argument

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `liouville_eq_arithLiouville`, lines 152–156

## Statement

> `theorem liouville_eq_arithLiouville {n : ℕ} (hn : n ≠ 0) :`
> `    liouville n = ArithmeticFunction.liouville n`

The file's docstring states it as: "**The bridge to Mathlib.** `liouville` is Mathlib's
`ArithmeticFunction.liouville` at every nonzero argument."

## Hypotheses and notation

- `liouville n = (-1) ^ Omega n : ℤ` with `Omega n = ArithmeticFunction.cardFactors n`; the file's convention gives `liouville 0 = 1`.
- Hypothesis `hn : n ≠ 0`. The two functions differ exactly at `0`, where Mathlib's value is `0` and the file's is `1` (file header, lines 20–22).

## Proof / evidence

Lean declaration `liouville_eq_arithLiouville` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 154–156), proved by `rw [liouville, ArithmeticFunction.liouville_apply hn, Omega_eq_cardFactors]`. The proof is complete; the file has no `sorry` (round certification: `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §4 records exit 0 with no `sorry`/`admit`/`axiom`/`native_decide`).

## Dependencies and related results

- Mathlib's `ArithmeticFunction.liouville_apply`; the local `Omega_eq_cardFactors` (`rfl`, not harvested).
- Used in `arithLiouville_multiplicative` (lines 306–310), which the README §1.5 turns into the statement that the shifted product `n ↦ λ(n)λ(n+2)` has no Euler product while Mathlib's `liouville` is completely multiplicative.
- Contrast: [Complete multiplicativity of λ, nonzero form](lean-rh46-chowla-liouville-completely-multiplicative.md) is the analogous multiplicativity statement for the workspace's own `liouville`.

## Notes

- The `hn : n ≠ 0` hypothesis is essential to the statement's truth *as an identity*: at `n = 0` the two sides are `1` and `0`.
- The declaration is `theorem`, hence Kind Theorem.
