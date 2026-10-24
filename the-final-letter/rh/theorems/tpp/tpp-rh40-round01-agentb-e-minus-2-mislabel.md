# Misattribution flag: the "e−2" word (10,20,40,80), N=500 is not e−2

**Kind:** Claim
**Status:** VERIFIED (numerical; the true greedy word for e−2 at N = 2000 is (0,3,53))
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[KNOWN]", lines 39–41

## Statement

> Misattribution flag: probes.py's "e-2" word (10,20,40,80), N=500, is *not* e-2 - the true greedy word for e-2 at N=2000 is (0,3,53); the brief's M6 "e-2" row inherits the mislabel.

## Hypotheses and notation

- The greedy harmonic digit word `w(x)` for a target `x` has support equal to the positions of its 1s; the support is a function of `x` and of the truncation length `N`.
- The word labelled "e−2" in `rh40/verify/probes.py` is the support `(10, 20, 40, 80)` at `N = 500`; Agent B reports the true greedy word for the target `e − 2` at `N = 2000` as the support `(0, 3, 53)`.
- The round-1 brief's M6 table row labelled `e−2` (gaps `(10, 20, 40)`, first failure `L = 12`) is said to "inherit the mislabel".

## Proof / evidence

The source states this as a computed correction (`[KNOWN]`: "flag any misattribution"), with the replacement support written out. The README's §5 record uses the true word: "the corrected first-difference identity ... on five words (1/π, log 2, √2−1, (10,20,40,80) and the true e−2 at (0,3,53))", and Agent B's `[TESTED]` (a) lists "true e-2 (0,3,53) N=2000" among the five tested words. The README's four-word tables nonetheless preserve the `(10,20,40,80)` row under the `e−2` label (see [tpp-rh40-readme-m3-plateau-and-decay-boundary.md](tpp-rh40-readme-m3-plateau-and-decay-boundary.md)).

## Dependencies and related results

- [M6 — C1 as stated in §4 is false](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md) — the README's M6 with the `e−2` row.
- [round01-brief M6 — C1 as stated is false](tpp-rh40-round01-brief-m6-c1-regime-false.md) — the brief's M6 table that "inherits the mislabel".
- [On the plateau p(L) = a_m+2](tpp-rh40-round01-agentb-plateau-value-am-plus-2.md) — whose value list includes `55` for the true `e-2` word.

## Notes

- This is a labelling correction about a computational record, not a new theorem about `e − 2`; it is harvested because the source states it as a result with exact content and because the mislabel propagates into other files' tables.
- The numbers computed on the support `(10,20,40,80)`, `N = 500` are unaffected; only the name attached to them is wrong.
