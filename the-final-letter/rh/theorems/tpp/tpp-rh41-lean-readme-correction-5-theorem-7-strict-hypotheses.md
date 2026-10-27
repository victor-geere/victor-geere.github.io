# Correction 5 — Theorem 7 needs strict hypotheses

**Kind:** Claim
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/lean/README.md`](../../research/twin-prime-parity/rounds/rh41/lean/README.md) — "Corrections found while formalising", item 5

## Statement

> **Theorem 7 needs strict hypotheses.** `u' = q²/s - q` is only meaningful while the step does not terminate (`1/(n+2) < r`); `s' = 1 - {q²/s}` needs `{q²/s} ≠ 0`, the integral case being exactly the terminating step (where `s' = 0`), proved as `Harmonic.induced_map_int`. Likewise the general-index termination statement `Harmonic.terminates_from` keeps the invariant `r < 1/(i+1)`: the numerator-decrease measure fails for arbitrary `(i, r)`, while `Harmonic.terminates_rat` (Theorem 8) needs no extra hypothesis.

## Hypotheses and notation

- `u = 1/r`, `q = ⌈u⌉`, `s = q − u`, `{·}` the fractional part, prime the next step, as in [Theorem 7 (maps)](tpp-rh41-truths-theorem-7-induced-maps.md).
- First identity: valid under the strict hypothesis `1/(n+2) < r` (the step does not terminate).
- Second identity: valid under `{q²/s} ≠ 0`; the integral case `{q²/s} = 0` is exactly the terminating step, where `s' = 0`, proved separately as `Harmonic.induced_map_int`.
- General-index termination `Harmonic.terminates_from` keeps the invariant `r < 1/(i+1)`; the numerator-decrease measure fails for arbitrary `(i, r)`.
- `Harmonic.terminates_rat` ([Theorem 8](tpp-rh41-truths-theorem-8-rational-termination.md)) needs no extra hypothesis.

## Proof / evidence

The README records that these hypotheses are required and that the corresponding declarations are `Harmonic.u_map`, `Harmonic.induced_map`, `Harmonic.induced_map_int`, `Harmonic.terminates_from` and `Harmonic.terminates_rat` (all in `Rh41/GreedyResidual.lean`, namespace `Rh41.Harmonic`, no `native_decide`).

## Dependencies and related results

- [Theorem 7 (maps)](tpp-rh41-truths-theorem-7-induced-maps.md) — the theorem whose hypotheses are made strict.
- [Theorem 8 (rational termination)](tpp-rh41-truths-theorem-8-rational-termination.md) — the statement that needs no extra hypothesis.

## Notes

- The README's own wording on `u_map`: at equality (`1/(n+2) = r`) the residual vanishes and `s = q - 1/r` becomes `0`; hence the strict inequality.
