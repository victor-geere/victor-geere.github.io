# J14 (refuted) — "p(L) saturates on [span, N]"

**Kind:** Claim
**Status:** REFUTED (only true on the plateau `[onset, N − a_m − 1]`; outside it `p` is not constant, and past it `p` strictly decreases)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §J "Refuted laws — do not re-propose", register row J14

## Statement

> "`p(L)` saturates on `[span, N]`" (HANDOFF §3.3)

## Hypotheses and notation

- `span = a_m − a_0`; `N` = truncation length; "saturates" means `p` is constant on the interval.
- `onset` is the plateau onset (register rows E8, E8a).

## Proof / evidence

Register row J14's verdict cell reads: "`REFUTED`"; its witness cell reads: "only true on the plateau `[onset, N − a_m − 1]`; outside it `p` is not constant, and past it `p` strictly decreases". The section preamble: "Each was refuted by exact enumeration."

## Dependencies and related results

- Register rows E5 (the decay law), E6 (the plateau end), E7 (the large-`L` law), J10.

## Notes

- Do not re-propose this claim; the true saturation interval is the plateau, and it ends at `N − a_m − 1`.
