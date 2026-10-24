# I5 — the number of usable residual-orbit steps is logarithmic in the working precision

**Kind:** Claim
**Status:** VERIFIED (numerical; seven precisions)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §I "Verified constants", register row I5

## Statement

> **The number of usable residual-orbit steps is logarithmic in the working precision.** For `x = 1/π`: dps 60→7 steps, 120→8, 200→9, 400→10, 800→11, 1600→12, 3200→13, i.e. `steps ≈ 2 + log₂(dps)`. Step `k` squares the residual, so it needs `~2^k` digits

## Hypotheses and notation

- dps = decimal digits of working precision; the target is `x = 1/π`.
- "Usable" means the residual orbit remains resolved before precision underflow.

## Proof / evidence

Register row I5's evidence cell reads: "7 precisions".

## Dependencies and related results

- Register rows I6, I7, I8, D6, A4.
- `probes.py` probe 5, the harness the source says can re-derive the table by sweeping `dps`.

## Notes

- The row is a precision law, established numerically; the source gives no symbolic proof.
