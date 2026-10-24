# H2 — the parity classes on twin-prime candidates stay balanced

**Kind:** Claim
**Status:** VERIFIED (numerical, rh46: ratio `0.9942` at `10⁵`, `0.9989` at `10⁶`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh47/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh47/HANDOFF.md) — §3 "What this round verifies (done — 23/23 probe, 31/31 audit)", item **H2**, line 95

## Statement

> **H2** the parity classes on twin-prime *candidates* stay balanced (rh46: ratio
> `0.9942` at `10⁵`, `0.9989` at `10⁶`).

## Hypotheses and notation

- "Parity classes on twin-prime candidates" means the split of the twin-prime candidates by the parity class under study (index parity vs `Ω`-parity, per the round's B2).
- The ratios `0.9942` (at `10⁵`) and `0.9989` (at `10⁶`) are quoted exactly as the source gives them; the source attributes the measurement to rh46.

## Proof / evidence

The HANDOFF records H2 as verified in this round; the parenthetical attributes the measurement to rh46. The round's probe is [`greedy_parity_probe.py`](../../research/twin-prime-parity/rounds/rh47/greedy_parity_probe.py) → `verify/greedy_parity_probe.log` (**23/23 checks**, exit 0).

## Dependencies and related results

- [H3 — bridges B1, B2, B3 all fail](tpp-rh47-handoff-h3-bridges-fail.md) — the same section's summary of the parity analysis.
- [B2 — index parity is independent of `Ω`-parity](tpp-rh47-handoff-bridge-b2-index-parity-refuted.md) — the structural counterpart of this balance.
- The bucket list in HANDOFF §5 keeps the balance claim as "The parity classes on twin-prime *candidates* stay balanced".

## Notes

- This is a **restatement of an rh46 result** inside the rh47 HANDOFF's list of what the round verifies.
- The source gives no derivation; the evidence is the quoted ratios.
