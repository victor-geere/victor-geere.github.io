# Correction 4 — Theorem 1 is stated with a redundant hypothesis

**Kind:** Claim
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) — "Corrections found while formalising", item 4

## Statement

> **Theorem 1 is stated with a redundant hypothesis.** The bound `L ≥ a_m + 1` suffices; `L ≥ span` is not needed for the formula (it is `a_m < L` that rules out windows to the left of `a_m`). `complexity_main` proves the sharper statement, `complexity_main_TRUTHS` matches the printed hypotheses.

## Hypotheses and notation

- `a_m` is the last support point, `span = a_m − a_0`, `L` the factor length, as in [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md).
- The printed hypothesis of Theorem 1 is `L ≥ max(span, a_m + 1)`; the correction removes `L ≥ span`.
- The reason recorded: it is `a_m < L` (equivalently `L ≥ a_m + 1`) that rules out windows lying entirely to the left of `a_m`.

## Proof / evidence

The README names the two declarations: `DigitWord.complexity_main` (sharper form, `L ≥ a_m + 1` only) and `DigitWord.complexity_main_TRUTHS` (the printed hypotheses). Both are in `Rh41/DigitWord.lean`, no `sorry`.

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the theorem being sharpened.

## Notes

- This is a **sharpening**, not a refutation: the formula of Theorem 1 remains correct under either hypothesis. The harvest keeps the source's printed hypothesis in the statement and records the sharper form here.
