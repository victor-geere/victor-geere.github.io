# The empty-plateau example — max p = 60, not a_m + 2 = 201

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry; `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/DigitWord.lean) — lines 605–610, declaration `Rh41.plateau_empty_example`

## Statement

> The illustrative case of Corollary 4 with an *empty* plateau: for the support `{0,…,199}` and `N = 259 < 2·199 + 2 = 400` the maximum of `p` is `60`, not `a_m + 2 = 201`. (Evaluated by `native_decide`, i.e. by compiled evaluation of the decidable proposition.)

Formally (Lean 4 / Mathlib):

```lean
theorem plateau_empty_example :
    (Icc 1 259).sup (fun L => complexity (range 200) 259 L) = 60
```

## Hypotheses and notation

- `S = range 200 = {0,…,199}`, so `a_m = 199` and `2 a_m + 2 = 400 > N = 259`.
- The maximum is taken over `1 ≤ L ≤ 259`.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.plateau_empty_example` in `Rh41/DigitWord.lean` (lines 609–611), closed by `native_decide`, i.e. by compiled evaluation of the decidable proposition. It is a concrete finite computation, not an analytic argument.

## Dependencies and related results

- [Corollary 4 — the maximum is `a_m + 2`](lean-rh41-digitword-max-complexity-corollary-4.md) — the result whose hypothesis `N ≥ 2 a_m + 2` fails here.
- [Corollary 2 (plateau)](lean-rh41-digitword-plateau-corollary.md) — the plateau is empty for these parameters.

## Notes

- This is a numerical/illustrative theorem: it documents that Corollary 4's hypothesis cannot be dropped. The value `60` is quoted exactly as in the source.
- Status is `PROVED (Lean)`, but the proof is a compiled evaluation (`native_decide`), so it carries less assurance than the other theorems in the file; this is stated in the source itself.
