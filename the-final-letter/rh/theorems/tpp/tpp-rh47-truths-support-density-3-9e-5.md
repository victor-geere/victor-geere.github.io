# the greedy support density is `≈ 3.9·10⁻⁵`

**Kind:** Corollary
**Status:** VERIFIED (numerical, 0 violations in 53 159 consecutive pairs)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/truths.md`](../../research/twin-prime-parity/rounds/rh47/truths.md) — §1, "Consequences (both VERIFIED numerically, 0 violations in 53 159 consecutive pairs)", line 38

## Statement

> the support **density** is `≈ 3.9·10⁻⁵` (sizes `2.95 → 3.90` for `N = 10² → 10⁵`).

## Hypotheses and notation

- "Support" is the support `A` of the greedy harmonic-sine word (source §1).
- The parenthetical records the measured sizes as `2.95 → 3.90` over `N = 10² → 10⁵`; the source quotes the density as `≈ 3.9·10⁻⁵`.
- The same figure appears in the round's README and HANDOFF as `3.9·10⁻⁵`.

## Proof / evidence

The source tags this consequence "VERIFIED numerically, 0 violations in 53 159 consecutive pairs"; it is a consequence of the Sylvester-sparse inequality [`m_{i+1} ≥ m_i (m_i − 1) + 1`](tpp-rh47-truths-sylvester-sparse-support.md). No separate derivation is given.

## Dependencies and related results

- [The greedy support is Sylvester-sparse](tpp-rh47-truths-sylvester-sparse-support.md).
- Sibling consequence: [`|A| ≥ 20` forces `max A ≥ s₂₀`](tpp-rh47-truths-max-support-sylvester-bound.md).
- Used by the round to argue that the programme "has no object that can even be placed in the regime where such information could live" (truths.md §4).
- Restated elsewhere in this round: [README §1.5](tpp-rh47-readme-sylvester-sparse-support.md), [HANDOFF H1](tpp-rh47-handoff-h1-sylvester-sparse-support.md).

## Notes

- The source writes the figure as `≈ 3.9·10⁻⁵` in truths.md and `3.9·10⁻⁵` in HANDOFF; the exact symbol and precision are preserved here.
- The source's "sizes `2.95 → 3.90` for `N = 10² → 10⁵`" is reproduced verbatim and is not further explained in the source.
