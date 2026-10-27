# THEOREM 4.6 (the almost-all statements are also insufficient)

**Kind:** Theorem
**Status:** PROVED (paper argument, meta-level: immediate from the quantifier structure of T4 and T7)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/03-parity-problem.md`](../../research/twin-prime-parity/dictionary/03-parity-problem.md) — §4.3

## Statement

> **THEOREM 4.6 (the almost-all statements are also insufficient).** T4 (almost all *shifts*) and T7 (almost all *scales*, outside a set of zero logarithmic density) are averaged statements. Neither yields `S(x) = o(x)` at the single shift `h = 2` and the prescribed scale `x`. In T4 the average over `H` shifts can vanish while individual shifts do not; in T7 the exceptional set of scales is not excluded at a prescribed scale.

The file's status line: *Status:* THEOREM (immediate from the quantifier structure of T4 and T7), and stated explicitly because the rounds' phrasing of "almost all shifts" invites the opposite reading.

## Hypotheses and notation

- Row **T4** is the almost-all-shifts statement [`THEOREM 3.11`](tpp-dict-03-mrtt-almost-all-shifts.md); row **T7** is the almost-all-scales statement [`THEOREM 3.12`](tpp-dict-03-almost-all-scales.md).
- `S(x) := Σ_{n≤x} λ(n) λ(n+2)` (OPEN 3.4); `h = 2` is the twin-prime shift; `x` is the prescribed scale.

## Proof / evidence

- The source's argument is the quantifier structure of the two averaged statements: an average over `H` shifts can vanish while individual shifts do not (T4); the exceptional set of scales is not excluded at a prescribed scale (T7).

## Dependencies and related results

- [THEOREM 3.11](tpp-dict-03-mrtt-almost-all-shifts.md) (T4); [THEOREM 3.12](tpp-dict-03-almost-all-scales.md) (T7); [THEOREM 4.4](tpp-dict-03-log-averaged-no-implication.md) (the log-averaged analogue); [OPEN 3.4](tpp-dict-03-two-point-chowla-open.md).
- Restated in the §7 ledger row "4.4–4.6".

## Notes

- A **meta-level** theorem about what the averaged results do and do not give; the status keeps that explicit. The source labels it THEOREM (immediate from the quantifier structure of T4 and T7).
- The source states it explicitly "because the rounds' phrasing of 'almost all shifts' invites the opposite reading".
