# A2 — p(L) is finite for every L

**Kind:** Claim
**Status:** VERIFIED (elementary)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §A "The object", register row A2

## Statement

> `p(L)` is finite for every `L` even though the word is infinite, because the word is finitely supported in every prefix

## Hypotheses and notation

- `p(L) = #{ distinct length-L factors of w }` — register row A1's definition of record (not harvested: the source labels A1 a definition).
- `w` is the greedy digit word of the programme, finitely supported in every prefix.

## Proof / evidence

Register row A2's evidence cell reads: "direct". The source states this without proof.

## Dependencies and related results

- A1 (definition of `p(L)`).
- Register rows A4, A4b, A4c and [Theorem F — the lower bound on `A(N)`](tpp-rh40-k-remaining-theorem-f-an-lower-bound.md), whose bounds concern the related count `A(N) = #{n ≤ N : δ_n = 1}`.

## Notes

- Register entry A2 of the rh40 ground-truth register; the source's own status word is `VERIFIED (elementary)`.
- The source gives no proof text beyond the evidence cell quoted above.
