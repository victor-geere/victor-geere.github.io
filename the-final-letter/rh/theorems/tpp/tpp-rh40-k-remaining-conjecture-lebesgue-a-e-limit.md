# Conjecture: the limit −1 for Lebesgue-a.e. x

**Kind:** Claim
**Status:** CONJECTURED
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/K_remaining.md`](../../research/twin-prime-parity/rounds/rh40/K_remaining.md) — §4.5 "What remains true"

## Statement

> * **`[CONJECTURE]`:** the same limit `−1` for Lebesgue-a.e. `x`. The reduction is
>   written out but its key correlation lemma is stated, not proved.

## Hypotheses and notation

- `x` ranges over `(0,1)` with Lebesgue measure; "Lebesgue-a.e. `x`" means off a Lebesgue-null set.
- "The same limit `−1`" refers to the limit of `(1/K)Σ_{k<K} log c_k` whose expectation over uniform `x` is `−1 + O(1/K)` ([the L¹ statement](tpp-rh40-k-remaining-conjecture-l1-convergence-uniform-x.md)).
- `c_k` is the squaring constant `r_{k+1} = c_k r_k²`; the reduction referred to is the one using `log c_k = log s_k − log(1 + s_k r_k)` with `Σ r_k < ∞` (§4.3), which "reduces the whole problem to `Σ log s_k`".

## Proof / evidence

No proof: the source labels it `[CONJECTURE]` and says explicitly that "the reduction is written out but its key correlation lemma is stated, not proved." Harvested because the source presents it as a labelled claim.

## Dependencies and related results

- [L¹ convergence of the orbit average to −1 for uniform x](tpp-rh40-k-remaining-conjecture-l1-convergence-uniform-x.md) — the proved expectation statement this strengthens.
- [The residual-orbit limit depends on x](tpp-rh40-k-remaining-theorem-limit-depends-on-x.md) — §4.4's refutation of a limit independent of `x`; the almost-sure statement here does not contradict it (a null set of exceptions is allowed).
- [Conjecture: x with no limit at all](tpp-rh40-k-remaining-conjecture-family-without-limit.md) — the companion conjecture in §4.5.

## Notes

- The source's §0 summary labels K6 as "`REFUTED` as posed — the limit depends on `x`; replaced by `L¹` result + conjecture" — the "conjecture" being this item.
- The key correlation lemma is not printed in `K_remaining.md`; per the source it is "stated, not proved".
- The status `CONJECTURED` is used here because the source's own tag is `[CONJECTURE]`, and the source gives no proof.
