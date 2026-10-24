# OPEN 4.3 (a genuinely open "intermediate" statement, for calibration)

**Kind:** Claim
**Status:** OPEN
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.2

## Statement

> **OPEN 4.3 (a genuinely open "intermediate" statement, for calibration).** It is not known whether `Σ_{n≤x} λ(n)λ(n+2) = O(x/(log x)^A)` for any `A > 0`; the only unconditional decay-free bound of this shape known to the programme is 3.6 (`≪ (1−δ)x`).

## Hypotheses and notation

- `λ` is the Liouville function (Definition 1.2).
- `A > 0` is any fixed power; `O(x/(log x)^A)` is the intermediate decay shape between `O(x)` and `o(x)`.
- The comparison bound 3.6 is `Σ_{n≤x} λ(n) λ(n+1) ≪ (1 − δ) x` (note the shift `h = 1`), which has **no decay**.

## Proof / evidence

- The source states this as **OPEN**: "It is not known whether …".
- The source identifies the only unconditional bound of this shape known to the programme as [`THEOREM 3.6`](tpp-dict-03-matomaki-radziwill-bound.md) (`≪ (1−δ)x`).

## Dependencies and related results

- [`THEOREM 3.6`](tpp-dict-03-matomaki-radziwill-bound.md) (the best bound known to the programme); [`OPEN 3.4`](tpp-dict-03-two-point-chowla-open.md) (the full target `o(x)`).
- The UNVERIFIED 2.3 truncated-weight difficulty is the same obstruction in the sieve setting.
- Restated in the §7 ledger row "4.3".

## Notes

- The source offers this as a calibration statement — "a genuinely open 'intermediate' statement" — and it is harvested with Status **OPEN** exactly as labelled. It must not be read as a claim that such a bound is false.
- Note the mismatch of shifts in the source's own sentence: the open statement is about `λ(n)λ(n+2)`, whereas the cited unconditional bound 3.6 is about `λ(n)λ(n+1)`. The source states it that way and this harvest does not alter it.
