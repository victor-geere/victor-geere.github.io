# Theorem 7 (the u-map and the induced map on s)

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/GreedyResidual.lean) — lines 581–587 (`Rh41.Harmonic.u_map`); lines 607–615 (`Rh41.Harmonic.induced_map`); lines 643–648 (`Rh41.Harmonic.induced_map_int`)

## Statement

> **Theorem 7, first identity.** With `u = 1/r` and `q = n+2`, the next inverse residual is `u' = q²/s - q` where `s = q - u`. The hypothesis `1/(n+2) < r` is strict: when `r = 1/(n+2)` the residual vanishes and `s = 0` (termination), so the identity has no meaning there.

Formally (Lean 4 / Mathlib):

```lean
theorem u_map (n : ℕ) (r : ℚ) (hr : 0 < r) (hact : (1 : ℚ) / (n + 2) < r) :
    1 / (r - 1 / (n + 2)) =
      ((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r) - ((n : ℚ) + 2)
```

> **Theorem 7, induced map (non-integral case).** With `t = q²/s`, the new `q' - u'` equals `1 - {t}` (the fractional part is `Int.fract`), provided `t` is not an integer. When `t` is an integer the left side is `0` — this is exactly the termination case, see `induced_map_int`.

```lean
theorem induced_map (n : ℕ) (r : ℚ) (hr : 0 < r) (hact : (1 : ℚ) / (n + 2) < r)
    (hfract : Int.fract (((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r)) ≠ 0) :
    ((⌈1 / (r - 1 / (n + 2))⌉ : ℤ) : ℚ) - 1 / (r - 1 / (n + 2)) =
      1 - Int.fract (((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r))
```

> **Theorem 7, induced map (integral / terminating case).** When `t = q²/s` is an integer (i.e. `{t} = 0`) the next residual is `0`, so the new `s' = q' - u'` is `0`. This is the missing case of `induced_map`.

```lean
theorem induced_map_int (n : ℕ) (r : ℚ) (hr : 0 < r) (hact : (1 : ℚ) / (n + 2) < r)
    (hfract : Int.fract (((n : ℚ) + 2)^2 / (((n : ℚ) + 2) - 1 / r)) = 0) :
    ((⌈1 / (r - 1 / (n + 2))⌉ : ℤ) : ℚ) - 1 / (r - 1 / (n + 2)) = 0
```

## Hypotheses and notation

- `n : ℕ` — the step index, `q = n + 2`; `r : ℚ` with `0 < r` — the current residual; `u = 1/r`, `s = q - u`.
- `hact : 1/(n+2) < r` — **strict** activity; at equality the residual vanishes and `s = 0`.
- `t = q²/s = ((n:ℚ)+2)^2 / (((n:ℚ)+2) - 1/r)`.
- `Int.fract` is used as the `ℚ`-valued fractional part; the non-integral case assumes `Int.fract t ≠ 0` and the integral case assumes `Int.fract t = 0`.
- `q' = ⌈1/(r - 1/(n+2))⌉` and `u' = 1/(r - 1/(n+2))`, so the new `s' = q' - u'`.

## Proof / evidence

Complete Lean proofs, no `sorry`/`admit`, no new axioms, no `native_decide` — declarations `Rh41.Harmonic.u_map` (lines 585–605), `induced_map` (lines 612–641) and `induced_map_int` (lines 646–660) in `Rh41/GreedyResidual.lean`.

- `u_map`: algebra in `ℚ` after establishing `0 < r - 1/(n+2)` and `0 < (n+2) - 1/r`; closed by `field_simp; ring`.
- `induced_map`: rewrites `1/(r - 1/(n+2)) = t - (n+2)`, uses `Int.ceil_sub_natCast` and `⌈t⌉ = ⌊t⌋ + 1` (valid because `Int.fract t ≠ 0`), then `Int.self_sub_floor`; closed by `ring`.
- `induced_map_int`: when `t = ⌊t⌋` is integral, `u = t - (n+2)` is an integer, so `q' - u' = 0`.

## Dependencies and related results

- [Theorem 8 (first half) — rational termination](lean-rh41-greedyresidual-rational-termination.md) — the orbit whose maps these are.
- [The exact squaring identity](lean-rh41-greedyresidual-squaring-identity.md) — the companion exact identity at an active step.

## Notes

- The file header's coverage note: "§3 **Theorem 7 (maps)** `u' = q²/s − q` and `s' = 1 − {q²/s}` — `u_map`, `induced_map`, `induced_map_int`."
- `induced_map_int` supplies the case missing from `induced_map`; the two together cover all steps.
- The strict hypotheses are recorded as correction 5 in `research/twin-prime-parity/rounds/rh41/lean/README.md`: "`u' = q²/s - q` is only meaningful while the step does not terminate (`1/(n+2) < r`); `s' = 1 - {q²/s}` needs `{q²/s} ≠ 0`, the integral case being exactly the terminating step (where `s' = 0`), proved as `Harmonic.induced_map_int`."
