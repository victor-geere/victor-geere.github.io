# Corollary 4

**Kind:** Corollary
**Status:** VERIFIED (numerical, on the signed supports {0,2,4} and {2,6,38})
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §7 "Statements about the signed word's factors"

## Statement

> `max_L p(L) = a_m + 2` once `N ≥ 2a_m + 2`.

## Hypotheses and notation

- `p(L)` counts the distinct length-`L` factors of a length-`N` truncation of the digit word (§0).
- `a_m` is inherited from rh41's complexity framework and is **not** redefined in this file; the bullet verifies the identity on the signed supports `{0,2,4}` and `{2,6,38}`.
- The hypothesis is `N ≥ 2a_m + 2`.

## Proof / evidence

> **Corollary 4.** `max_L p(L) = a_m + 2` once `N ≥ 2a_m + 2`; **VERIFIED** on
> `{0,2,4}` and `{2,6,38}`.

The source gives no separate proof in this file: the bullet is a restatement of rh41's Corollary 4 for signed supports, verified on the two listed supports.

## Dependencies and related results

- [Plateau and decay (rh41's Theorem 1)](tpp-rh42-truths-plateau-and-decay-signed.md) — the plateau law this corollary follows from.

## Notes

- The source labels this "Corollary 4" (rh41's numbering) without restating rh41's status; the only status given here is **VERIFIED** on the two supports, which is what this file records.
