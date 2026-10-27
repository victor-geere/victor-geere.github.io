# The term is the principal-branch power

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) — §1 "The Dirichlet term, the sharp sum and the smoothed sum", lines 102–108

## Statement

> **The term is the principal-branch power.** For `n ≥ 1` the two definitions agree: `zetaTerm s n = (n : ℂ) ^ (-s)`.

```lean
theorem zetaTerm_eq (s : ℂ) {n : ℕ} (hn : 1 ≤ n) : zetaTerm s n = (n : ℂ) ^ (-s)
```

with the term defined in the same file (line 71) as

```lean
noncomputable def zetaTerm (s : ℂ) (n : ℕ) : ℂ := Complex.exp (-(s * Real.log n))
```

So the exponential `exp (-(s · log n))` used throughout the development is exactly the principal-branch power `n^{-s}` on the Dirichlet range `n ≥ 1`.

## Hypotheses and notation

- `s : ℂ` — arbitrary complex argument.
- `n : ℕ` with the hypothesis `hn : 1 ≤ n`; the case `n = 0` is excluded by the statement.
- `(n : ℂ) ^ (-s)` is the principal-branch complex power (`Complex.cpow`) of the non-zero base `n ≥ 1`.
- `Real.log` is the real logarithm. The source notes that for `n = 0` the real `log 0 = 0` makes the term `1`, and that this case "is never used".

## Proof / evidence

- **PROVED** in Lean, no `sorry`: declaration `zetaTerm_eq` in [`Rh044/Smoothing.lean`](../../research/twin-prime-parity/rounds/rh044/lean/Rh044/Smoothing.lean) (lines 104–108). The base-non-zero side condition for `Complex.cpow` is discharged with `Nat.cast_ne_zero.mpr` (from `hn`); the proof then rewrites with `Complex.cpow_def_of_ne_zero` and `Complex.natCast_log` and closes with `ring_nf`.
- The file header states: "Everything below is proved from Mathlib alone; there is no `sorry`, no extra axiom and no computation by reflection."

## Dependencies and related results

- Mathlib facts used: `Complex.cpow_def_of_ne_zero`, `Complex.natCast_log`.
- [Radial decay `‖zetaTerm (σ + t·I) n‖ = n^{-σ}`](lean-rh044-smoothing-radial-decay.md) — obtained by taking moduli of this power (`abs_cpow_neg_eq`).

## Notes

- The source presents this as the bridge between its own definition of `zetaTerm` and the classical Dirichlet term `n^{-s}`; it is what allows the later estimates to be read in the classical notation.
- The statement is deliberately only for `n ≥ 1`: at `n = 0` the two sides do not agree, and the source says the `n = 0` term is never used.
