# F4 — no closed form for the C1 boundary in the gaps alone has been found

**Kind:** Claim
**Status:** REFUTED (all four candidates)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §F "The C1 / prefix regime", register row F4

## Statement

> **No closed form in the gaps alone has been found.** Refuted candidates: A's `1 + min(min_j d_j, min_j(d_j+d_{j+1}))` (4 903 violations *inside* its own claimed range and 449 too early over 17 375 sampled eligible words); `min(a_0−1, 1+min_j d_j)`; `min(N−a_m−1, 1+min_j d_j)`; `min(N−a_m−1, 1+d_(2))`

## Hypotheses and notation

- `d_j = a_j − a_{j−1}`; `d_(2)` denotes the second smallest gap as used by the source.
- "Inside its own claimed range" means the candidate's own `[1, L_max]`.

## Proof / evidence

Register row F4's evidence cell reads: "`verify_agentB.py` A-a1; sweeps"; its status cell reads "`REFUTED` (all four)".

## Dependencies and related results

- Register rows F1, F2, F3, F5, J13.
- [`round01.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01.md) §5 item 4 lists the same four refuted candidates and adds a fifth (`min(N−a_m−1, 1+d_(2))` is listed there among the mediator's).

## Notes

- The row states a negative result: four specific candidate formulas are false, not that no formula can exist. The source notes the candidates were "exact on the four dialogue words only", which is why they looked right.
