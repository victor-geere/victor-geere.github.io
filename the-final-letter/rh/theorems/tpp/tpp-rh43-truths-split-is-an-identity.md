# Theorem 1 (the split is an identity, and balance is a single equation)

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`; also VERIFIED numerically)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §0.3 "The key identity"

## Statement

> ```
> P_N(t) + M_N(t) = Re S_N(t) = 1 + sum_{n=2}^{N} cos(t log n)          (PROVED)
> P_N(t) = -M_N(t)   <=>   Re S_N(t) = 0                               (PROVED)
> P_N(t) = -M_N(t)   <=>   P_N(t)/2 + P_N(t)/2 + M_N(t)/2 + M_N(t)/2 has two equal
>                          positive and two equal negative pieces    (PROVED)
> ```

**PROVED** by splitting the finite sum over the two index sets of the sign of `cos(t log n)` (the terms with `cos = 0` contribute `0`), and by `P >= 0 >= M`.

> **The whole question therefore reduces to a single real equation:**
> `Re S_N(t) = 0`. Everything below is about that equation.

## Hypotheses and notation

- `S_N(t) = sum_{n=1}^{N} n^{-it} = sum_{n=1}^{N} exp(-i t log n)` in `C`, with `t` real (the case `S = i t`, i.e. `Re(S) = 0`).
- `P_N(t) = sum_{n : cos(t log n) > 0} cos(t log n)` ( `>= 0` ), "the positive parts"; `M_N(t) = sum_{n : cos(t log n) < 0} cos(t log n)` ( `<= 0` ), "the negative parts".
- A term with `cos(t log n) = 0` contributes neither a positive nor a negative real part and belongs to neither set; for real `t` this is harmless (it contributes `0` to the real part) — this is **T1**, a definition.
- `<=>` is the source's biconditional symbol.

## Proof / evidence

- **PROVED** in Lean ([`lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean)), declarations: `realPartial_eq_posRe_add_negRe`, `posRe_nonneg`, `negRe_nonpos`, `balanced_iff_realPartial_eq_zero`, `balanced_equal_split`, `equal_split_balanced`, `balanced_iff_equal_split`.
- **VERIFIED** in [`zeta_split.py`](../../research/twin-prime-parity/rounds/rh43/zeta_split.py) §1 (recorded in `verify/zeta_split.log`).
- The auditor's independent recomputation ([`verify/independent_check.py`](../../research/twin-prime-parity/rounds/rh43/verify/independent_check.py)) reports **102/102 checks pass**.

## Dependencies and related results

- Defines the object of the round (truths.md §0.1, ledger row T1, a *definition*, not harvested).
- The reduction `balanced N t ↔ realPartial N t = 0` is the hinge for every later result in this folder (T4, T5, T6, T7).
- Related harvested files: [The numeric split is exact](tpp-rh43-truths-numeric-split-exact.md) (T9), [The term-level split fails](tpp-rh43-truths-term-level-split-fails.md) (T9′).

## Notes

- The Lean theorem `balanced_iff_equal_split` carries the necessary conjunct `p1 + n1 = 0`; without it the statement is false (`N = 2, t = 0` is a counterexample, `not_balanced_two_zero` — see the Lean README).
- The complex split `posPart + negPart = zetaPartial` is deliberately **not** stated in Lean: a term with `cos = 0` has nonzero imaginary part and belongs to neither filter, so the complex identity is false. Everything is done at the real-part level, where the identity is exact.
