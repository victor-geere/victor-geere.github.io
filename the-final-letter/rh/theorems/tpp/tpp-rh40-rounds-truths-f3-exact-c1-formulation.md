# F3 — exact formulation of the C1 boundary

**Kind:** Claim
**Status:** VERIFIED (derivation + spot checks)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §F "The C1 / prefix regime", register row F3

## Statement

> **Exact formulation.** C1 holds at `L` **iff** `Σ_j min(L−2, d_j−1) = #{j : d_j < L}`, i.e. iff no gap satisfies `L−1 > d_j > L−2`; as the `d_j` are integers this reads *`L − 1 ≤ min_j d_j` or `L − 1 > max_j d_j`*

## Hypotheses and notation

- `d_j = a_j − a_{j−1}` are the consecutive gaps of the support; C1 is `p(L) = L + 1`.
- The derivation is "from the class decomposition: for `L ≤ a_0+1` the count of non-all-zero offset classes is `min(L, a_0) + 1 + Σ_j min(L−2, d_j−1)`" (the source's own evidence cell).

## Proof / evidence

Register row F3's evidence cell reads: "from the class decomposition: for `L ≤ a_0+1` the count of non-all-zero offset classes is `min(L, a_0) + 1 + Σ_j min(L−2, d_j−1)`"; its status cell reads "`VERIFIED` (derivation + spot checks)".

## Dependencies and related results

- Register rows C1, F1, F2, F4, F5.
- The round-1 adjudication ([`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) §5.4) states the same exact formulation as the round-2 agenda item.

## Notes

- The ledger records (row 21 of `ledger.md`) that a *different* equivalence, `L ≤ 1 + min_j d_j or L > max_j d_j` — with `L` where the correct form has `L − 1` — is false on 65.6 % of 1 772 281 cases. This row's form is the corrected one.
