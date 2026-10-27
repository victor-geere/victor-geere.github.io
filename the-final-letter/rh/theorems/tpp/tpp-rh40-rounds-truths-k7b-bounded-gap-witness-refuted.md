# K7b (refuted) — the family's word is 1^{N(p)}0^∞ with every gap 1

**Kind:** Claim
**Status:** REFUTED — for `p = 3/2` the orbit is `{0..8, 34, 954, 77716, …}` with gaps 25, 919, 76 761, … **unbounded**; `N(p)` ends the *initial segment*, not the orbit
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §K "Open problems, ranked", register row K7b

## Statement

> the family's word is `1^{N(p)}0^∞`, so every gap is 1 for every `p`; `α_n=(n+2)^{−3/2}` is a witness with max gap 1

## Hypotheses and notation

- The family is `α_n = (n+2)^{−p}` with unit target; `N(p)` is the length of the initial segment of consecutive selected indices.
- "max gap 1" means the support has no gap between consecutive selected indices.

## Proof / evidence

Register row K7b's state cell reads: "**`REFUTED`** — for `p = 3/2` the orbit is `{0..8, 34, 954, 77716, …}` with gaps 25, 919, 76 761, … **unbounded**. `N(p)` ends the *initial segment*, not the orbit: since `α_k → 0`, the residual keeps selecting a tail"; its evidence cell reads: "§5.2" (`K_remaining.md`).

## Dependencies and related results

- Register rows K7d, K7f (the corrected structure theorem), K6f (the same "the residual keeps selecting a tail" mechanism).
- The ledger records the same error (row 31 of `ledger.md`), including that the delegated agent repeated it in its final report after the mediator had refuted it.

## Notes

- Do not re-propose this claim; the displayed orbit and its unbounded gaps are the source's witness.
