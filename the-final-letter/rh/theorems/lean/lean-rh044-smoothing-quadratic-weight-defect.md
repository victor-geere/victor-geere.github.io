# The weight defect of the quadratic weight in closed form

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §5 "The quadratic weight `φ u = u (1 - u)`", lines 328–353

## Statement

> The weight defect of the quadratic weight in closed form. With `x = n/N`, `1 - x (1 - x) = 1 - x + x² = (N² - n N + n²) / N²` for `N ≠ 0`.

```lean
theorem quadWeight_defect_eq {n N : ℕ} (hN : N ≠ 0) :
    1 - quadWeight ((n : ℝ) / N)
      = (((N : ℝ) ^ 2 - (n : ℝ) * N + (n : ℝ) ^ 2)) / (N : ℝ) ^ 2
```

The source records the same closed form with the corrected "`u²`-completed" numerator (second declaration, line 347):

```lean
theorem quadWeight_defect_eq' {n N : ℕ} (hN : N ≠ 0) :
    1 - quadWeight ((n : ℝ) / N)
      = (((N : ℝ) - n) ^ 2 + (n : ℝ) * ((N : ℝ) - n) + (n : ℝ) ^ 2) / (N : ℝ) ^ 2
```

The source's doc comment adds the correction verbatim:

> The rearrangement suggested in the brief, `((N - n)² + n (N - n)) / N²`, is *not* this quantity: it simplifies to `(N - n)/N = 1 - n/N`, i.e. it is the defect of the *linear* weight `u`, not of `u (1 - u)` (the two agree only for `n = 0`). The correct `u²`-completing numerator is `(N - n)² + n (N - n) + n² = N² - n N + n²`; both forms are recorded below.

## Hypotheses and notation

- `n N : ℕ` with the hypothesis `hN : N ≠ 0`, which makes `(N : ℝ) ≠ 0` (and hence `N² ≠ 0`).
- `quadWeight u = u (1 - u)` (line 283 of the file); the sampled argument is `(n : ℝ) / N`.
- `1 - quadWeight (n/N)` is the weight defect that appears in the exact decomposition `weighted_decomposition`.

## Proof / evidence

- **PROVED** in Lean, no `sorry`: `quadWeight_defect_eq` (lines 336–342) and `quadWeight_defect_eq'` (lines 347–353) in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean). Both unfold `quadWeight`, convert `hN` to `(N : ℝ) ≠ 0` with `Nat.cast_ne_zero.mpr`, and close with `field_simp` and `ring_nf`.
- No extra axiom and no computation by reflection (file header).

## Dependencies and related results

- [Key exact identity (weight defect)](lean-rh044-smoothing-weighted-decomposition.md) — this defect is the factor summed there; its quadratic-weight instance with the defect replaced by this closed form is `weighted_decomposition_quadWeight_defect` (lines 370–379).
- [Split into `zetaSum`-type pieces](lean-rh044-smoothing-quadratic-weight-split.md) — the companion algebraic computation for the same weight.
- Related declaration in the same file: `linearWeight_defect_eq` (lines 355–362) proves the brief's displayed rearrangement `((N - n)² + n (N - n)) / N²` to equal the defect of the *linear* weight, `1 - n/N` (described here but not harvested separately; see Notes).

## Notes

- The source flags this as a correction: the brief's displayed numerator `(N - n)² + n (N - n)` omits the last summand `n²`, and it equals `1 - n/N` (the defect of the linear weight), agreeing with the quadratic weight's defect only at `n = 0`. The file records both the direct numerator `N² - n N + n²` (`quadWeight_defect_eq`) and the corrected `u²`-completed numerator `(N - n)² + n (N - n) + n²` (`quadWeight_defect_eq'`).
- `quadWeight_defect_eq'` is folded into this file as the same closed form written with the alternative numerator (both equal `1 - quadWeight (n/N)` under `hN`).
- `linearWeight_defect_eq` is an arithmetic clarification of the brief's rearrangement rather than a statement about the quadratic weight; it is named here for traceability but did not receive its own harvested file.
