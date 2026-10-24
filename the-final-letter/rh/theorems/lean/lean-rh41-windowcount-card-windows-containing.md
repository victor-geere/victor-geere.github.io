# TRUTHS.md §2 — the exact window count containing a support point

**Kind:** Theorem
**Status:** PROVED (Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/Rh41/WindowCount.lean`](../../research/twin-prime-parity/rounds/rh41/lean/Rh41/WindowCount.lean) — lines 48–52, declaration `Rh41.card_windows_containing`

## Statement

> **`TRUTHS.md` §2, window count.** The number of windows of length `L` that contain the point `am` is `max(0, min(am, N-L) - max(0, am-L+1) + 1)`.

Quoted from the file header as the checked identity (checked there over 25 044 603 cases):

> `#{ t : window contains a_m } = max(0, min(a_m,N−L) − max(0,a_m−L+1) + 1)` (exactly, all `L`).

Formally (Lean 4 / Mathlib):

```lean
theorem card_windows_containing (N L am : ℕ) (hL : 1 ≤ L) (hLN : L ≤ N) :
    ((((range (N - L + 1)).filter (fun t => t ≤ am ∧ am ≤ t + L - 1)).card : ℤ)
      = max 0 (min (am : ℤ) ((N : ℤ) - L) - max 0 ((am : ℤ) - L + 1) + 1))
```

## Hypotheses and notation

- `N, L, am : ℕ` with `1 ≤ L` and `L ≤ N` — truncation length, window length, and the support point `a_m`; window starts live in `[0, N-L]`, hence `L ≤ N`.
- The left-hand side counts window starts `t ∈ range (N - L + 1)` with `t ≤ am ≤ t + L - 1`, i.e. windows containing `am`.
- The right-hand side is computed in `ℤ` because the Python check's `min − max + 1` can be negative.

## Proof / evidence

Complete Lean proof, no `sorry`/`admit`, no new axioms — declaration `Rh41.card_windows_containing` in `Rh41/WindowCount.lean` (lines 50–74). The set of such window starts is identified with the integer interval `Icc (max 0 (am - (L-1))) (min am (N - L))` (`hset`), and its cardinality is evaluated via the auxiliary lemmas `card_Icc_int` and `cast_max_sub` (same file, lines 19 and 32).

## Dependencies and related results

- [`Rh41.DigitWord`](lean-rh41-digitword-main-complexity-law.md) — only for the shared `Finset` interface; the argument is elementary.

## Notes

- The header states the identity was "checked there over 25 044 603 cases" in the Python layer; this file upgrades it to a theorem for all supports, truncations and window lengths.
- The two auxiliary lemmas (`card_Icc_int`, `cast_max_sub`) are arithmetic bookkeeping used by the proof and are not harvested separately.
