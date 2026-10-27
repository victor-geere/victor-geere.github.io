# B4 — the support could be the positive-density witness (refuted)

**Kind:** Claim
**Status:** REFUTED
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §2 "The bridges, each disposed of", row B4

## Statement

> | bridge | claim | disposal |
> |---|---|---|
> | **B4** | the support could be the positive-density witness | **REFUTED**: density `≈3.9·10⁻⁵`, so by the corrected sparse bound it moves `S(x)` by `O(log log x) = o(x)` |

## Hypotheses and notation

- "The support" is the greedy support (cf. P18); "the positive-density witness" is the object a proof of `o(x)` would need (see the dictionary's §3 N1 and §4).
- The density quoted is `≈3.9·10⁻⁵`.
- "The corrected sparse bound" is the programme's sparse-support bound (referred to in the dictionary's §3 as "corrected sparse bound, X2"); by it a support of this density moves `S(x)` by `O(log log x) = o(x)`, so it cannot serve as the positive-density witness.

## Proof / evidence

- The ledger records the disposal as **REFUTED**, with the density `≈3.9·10⁻⁵` and the corrected sparse bound as witness. No further derivation is given in the dictionary.

## Dependencies and related results

- P18 (the greedy support is Sylvester-sparse).
- The dictionary's §3 (N1): "A witness needs **positive density** (corrected sparse bound, X2)."
- §4 of the same dictionary lists B4 among "its own structure theorems (P18, B2, B4)".

## Notes

- This entry harvests a *refutation*: the bridge claim is the refuted proposition, and its honest status is REFUTED. It is not a positive theorem of the programme.
- The density is quoted exactly as `≈3.9·10⁻⁵`; the dictionary does not give more digits.
