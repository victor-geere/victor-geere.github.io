# The trivial bound: |corr h N| ≤ N

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean`](../../research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean) — `corr_abs_le`, lines 206–222

## Statement

> `theorem corr_abs_le (h N : ℕ) : |corr h N| ≤ N`

where `corr h N = ∑ n ∈ Finset.Icc 1 N, liouville n * liouville (n + h)`, i.e.
`S(x, h) = ∑_{1 ≤ n ≤ x} λ(n) λ(n + h)` with `x = N`.

The file's docstring: "**The trivial bound.** Each of the `N` summands has absolute
value `≤ 1`, so `|corr h N| ≤ N`."

## Hypotheses and notation

- `λ(n) = (-1)^{Ω(n)}`, `Ω` = prime factors counted with multiplicity; `corr h N` is the two-point Chowla correlation sum over `1 ≤ n ≤ N`.
- No hypotheses on `h, N : ℕ`; in particular `h = 0` is allowed.
- README §1.1 states the same row as `|S(x,h)| ≤ x` for every `h, x` (each of the `x` summands lies in `{−1,+1}`).

## Proof / evidence

Lean declaration `corr_abs_le` in `research/twin-prime-parity/rounds/rh46/lean/Rh46/Chowla.lean` (lines 210–222): the triangle inequality `Finset.abs_sum_le_sum_abs`, the per-summand bound `|λ(n)λ(n+h)| ≤ 1` from `liouville_abs_le_one`, and `card (Icc 1 N) = N`. The proof is complete; the file has no `sorry` (certification `[check] OK   Rh46/Chowla.lean (23s)` in `verify/lean_check.log`; README §5 row: "`|Σ_{n≤x}λ(n)λ(n+2)| ≤ x`; `Σ λ(n)λ(n) = x` | **PROVED** (Lean: `corr_abs_le`, `corr_zero`)").

## Dependencies and related results

- Uses [|λ n| ≤ 1 for every n](lean-rh46-chowla-liouville-abs-le-one.md).
- Sharpness: [Sharpness of the trivial bound: corr 0 N = N](lean-rh46-chowla-corr-zero-sharpness.md).
- The README harvest of this row is [§1.1 — the trivial two-point bounds `|S(x,h)| ≤ x`, `S(x,0) = x`](../tpp/tpp-rh46-readme-trivial-two-point-bounds.md).

## Notes

- The bound is the only estimate the file obtains for free; it does not assert `o(N)` for any `h`, and in particular nothing here approaches two-point Chowla (`corrAsymptotic 2` is open and not asserted).
