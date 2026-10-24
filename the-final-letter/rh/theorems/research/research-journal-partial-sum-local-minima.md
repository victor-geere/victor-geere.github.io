# A finite additive object cannot distinguish a zero from a dip

**Kind:** Proposition
**Status:** VERIFIED (numerical)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 4(c), lines 334–345; Synthesis §9, line 428

## Statement

> **(c) Near-zeros of Dirichlet partial sums (Round 6 prep), measured.** Local minima of |Σ_{n≤N} n^{−1/2−it}| over t ∈ [1,60], matched against the 13 true zeros in that range:

| N | local minima | true zeros matched within 1.0 |
|---|---|---|
| 10 | 17 | 13 of 13 |
| 20 | 20 | 13 of 13 |
| 40 | 25 | 13 of 13 |
| 80 | 31 | 13 of 13 |
| 160 | 41 | 13 of 13 |
| 400 | 54 | 13 of 13 |

> **Every partial sum has a local minimum within 1.0 of every true zero — and generates 4 to 41 spurious minima besides.** Increase of N adds spurious minima faster than it sharpens the true ones (17 → 54). So a finite additive object does "know" the zeros in a weak, uninformative sense, and **cannot distinguish a zero from a dip.** This is the honest, computable content of handoff 2's closing paragraph, and it is stronger than the handoff's own claim.

Synthesis restatement:

> Every partial sum Σ_{n≤N} n^{−1/2−it} has a local minimum within 1.0 of every true zero, **and** 17 (N=10) to 54 (N=400) spurious minima besides. Increasing N adds spurious minima faster than it sharpens real ones. The Dirichlet polynomial "knows" the zeros only in a sense that cannot distinguish a zero from a dip.

## Hypotheses and notation

- Partial sums Σ_{n≤N} n^{−1/2−it} for t ∈ [1,60]; local minima of the modulus.
- "True zeros" are the 13 zeta zeros in that range; "matched within 1.0" means a local minimum lies within 1.0 in t of the zero ordinate.
- "Spurious minima" are local minima of the partial sum not matched to a zero.

## Proof / evidence

Numerical table as above: all 13 true zeros matched for every N from 10 to 400; local minima counts 17, 20, 25, 31, 41, 54, i.e. an excess of 4 to 41 spurious minima that grows with N.

## Dependencies and related results

- [No canonical finite object vanishes exactly at a zero](research-journal-no-finite-object-vanishes-at-zero.md) — the companion statement (a partial sum has no zeros at all; it has local minima).
- [The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — the truncation error that stays at the floor.
- [Measured GUE level repulsion in the zeta zeros](research-journal-zero-level-repulsion.md) — the statistics the partial sums do not reproduce.

## Notes

- The source's verdict: this is "the honest, computable content of handoff 2's closing paragraph, and it is stronger than the handoff's own claim."
- This is a numerical finding on t ∈ [1,60] and N ≤ 400; the journal does not claim it beyond that range.
