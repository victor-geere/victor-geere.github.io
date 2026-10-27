# M4 — the offset-tuple count and the bit-string factor count agree everywhere compared

**Kind:** Claim
**Status:** CHECKED (exhaustive finite; agreement on the listed L, including deep in the decay regime)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md) — §1 "Mediator's own findings from this session (recomputed, standing)", item **M4** (lines 76–79)

## Statement

> **M4 — the offset-tuple count and the bit-string factor count agree everywhere they were compared**, including deep into the decay regime (L = 800, 900, 1000, 1200, 1390, 1397, 1398, 1399 at N = 1400). So §3.2 is safe to use as the definition of record; the numbers in §3.3 are not distorted by it.

## Hypotheses and notation

- The two counts are the offset-tuple enumeration `p(L) = # { { a − t : a in ones, t <= a <= t + L − 1 } : 0 <= t <= N − L }` (§0 of the brief, `factor_set` / `p_offset` in `rh40/code/digitword.py`) and the count of distinct length-`L` factors of the bit string (`p_bruteforce`).
- The comparison points are `L = 800, 900, 1000, 1200, 1390, 1397, 1398, 1399` at `N = 1400` — "deep into the decay regime" — together with the earlier sampled comparisons the brief does not list.
- "§3.2 is safe to use as the definition of record" means the offset-tuple enumeration may be taken as the meaning of `p(L)`; "§3.3's numbers" are `HANDOFF.md` §3.3's plateau values.

## Proof / evidence

The source states this as exact recomputation by the mediator; no proof is given and none is needed — the claim is an agreement check between two implementations. Agent B's round-1 audit (d) reports the finer version of the same check: `p_offset == p_bruteforce` "on 43342 exhaustive cases (N<=12, <=4 ones, all L), on all 701 decay-regime L of 1/pi, and on 400 random words" (harvested as [tpp-rh40-round01-agentb-digitword-audit-clean.md](tpp-rh40-round01-agentb-digitword-audit-clean.md)).

## Dependencies and related results

- [digitword.py is computationally clean](tpp-rh40-round01-agentb-digitword-audit-clean.md) — the round-1 audit of the same agreement.
- [The exact structural characterisation of the greedy digit word](../handoff/handoff-offset-tuple-characterisation.md) — the offset-tuple definition being validated.
- [README M3 — the plateau and the decay boundary](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) — whose four-word numbers depend on this agreement holding in the decay regime.

## Notes

- Status CHECKED (exhaustive finite): the claim is a finite agreement check, not a theorem; the brief deliberately tested the decay regime "because that is where the two descriptions are most likely to diverge".
- The brief's §0 records the offset-tuple formula as "Ground truth ... implemented as `factor_set` / `p_offset` in `rh40/code/digitword.py`"; that formula is a definition and is not harvested here.
