# Corollary 3.2

**Kind:** Corollary
**Status:** PROVED (paper argument; stated as a corollary of Theorem 3.1)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md`](../../research/twin-prime-parity/dictionary/02-greedy-harmonic-sine.md) — §3 "The helix, and what the word cannot see", "Corollary 3.2", line 88

## Statement

> **Corollary 3.2.**  No rule reading a **periodic** function of `θ` — in particular not
> `θ mod 1` — can see the turn count; to see it the input must be non-periodic.  This is
> the honest statement of the "the circle forgets the turns" claim.

## Hypotheses and notation

- "Rule" = a take/skip rule of the kind in Definitions 1.1/2.2, whose input is a function of `θ` (an angle measured in turns).
- "Periodic function of `θ`" includes `θ mod 1`.
- "Turn count" is the integer part of `θ` — the quantity the lift `(cos 2πθ, sin 2πθ, θ)` of [Theorem 3.1](tpp-dict-02-factorisation-through-the-height.md) carries.

## Proof / evidence

The source gives no proof text and no separate status line for this corollary. It is printed immediately after [Theorem 3.1 (factorisation through the height)](tpp-dict-02-factorisation-through-the-height.md) and follows from it: the rule reads only `x = sin(2πθ)`, so any input that is a periodic function of `θ` cannot distinguish `θ` from `θ + 1` and hence cannot see the turn count.

## Dependencies and related results

- [Theorem 3.1 (factorisation through the height)](tpp-dict-02-factorisation-through-the-height.md) — the theorem this corollary is drawn from.

## Notes

- The corollary is labelled in the source but carries no status line of its own; the status recorded here (PROVED, paper argument) is the source's own presentation of it as a corollary, and no proof is invented.
- Ledger entry for §3, which the source places in the **rh42** round (the section cites `rh42 §8, T16` for Theorem 3.1).
