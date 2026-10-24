# T17 — the alphabet's total is `1 − ln 2`, not `ln 2 − 1`

**Kind:** Claim
**Status:** VERIFIED (numerical, `nsum` to 25 digits both ways)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §6 "The rh42 ledger", row T17; §4 row H6 and §5.9

## Statement

> | H6 | "adding every term of this page's alphabet, which starts at 1/2, gives `ln 2 − 1 ≈ −0.307`" | **REFUTED (sign)** | the alphabet sums to `1 − η(1) = 1 − ln 2 = +0.30685281944005469058`; `ln 2 − 1` is the negative of the *alternating tail* `Σ_{n≥2}(−1)^{n−1}/n`. The magnitude is right, the sign is not. Script §1 |

The ledger row states it as: "the alphabet's total is `1 − ln 2`, not `ln 2 − 1`" — **VERIFIED** | `nsum` to 25 digits both ways.

## Hypotheses and notation

- The alphabet is `α_n = (−1)^n/(n+2)`, `n ≥ 0`, i.e. `+1/2, −1/3, +1/4, −1/5, …` (the `p = 1` case).
- `η(1) = ln 2` (row T3 / §4), so the total is `1 − η(1) = 1 − ln 2`.
- "the *alternating tail*" is `Σ_{n≥2}(−1)^{n−1}/n`, whose value is `ln 2 − 1`.

## Proof / evidence

> * **H6 sign** (§4): the alphabet `(−1)^n/(n+2)` sums to `+0.30685281944005469058 = 1 − ln 2`,
>   not to `ln 2 − 1 = −0.30685281944005469058`. The page's `η(1) = ln 2` and its
>   `η(s) = (1−2^{1−s})ζ(s)` are both correct; only the extraction of the alphabet's total has
>   the sign flipped.

The evidence cell gives `nsum` to 25 digits both ways.

## Dependencies and related results

- Uses `η(s) = (1−2^{1−s})ζ(s)` and `η(1) = ln 2` (row T3 / §4 H6).
- Corrects the source pages' H6 claim; listed under §9 "Newly refuted here": "the sign of the source page's alphabet total (§5.9): `+0.30685… = 1 − ln 2`, not `−0.30685…`".
- Restates `rh42/truths.md` row R1 (alphabet-total sign refutation).

## Notes

- The ledger row's `VERIFIED` and the §4 verdict's `REFUTED (sign)` describe the same finding from the two sides: the new value is verified, the pages' value is refuted.
- The magnitude `0.30685281944005469058` is quoted exactly (20 decimal places); the pages' claim is quoted as `ln 2 − 1 ≈ −0.307`.
- Only the sign is corrected; the source says explicitly "The magnitude is right, the sign is not" and that the pages' `η` formulas are correct.
