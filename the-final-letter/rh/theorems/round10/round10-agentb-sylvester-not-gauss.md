# (A)7 The greedy map is the Engel/Sylvester map, not the Gauss map

**Kind:** Proposition
**Status:** PROVED (paper argument, definitional identification)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 7, lines 20–22

## Statement

> 7. Sylvester-vs-Gauss: the greedy map r -> r - 1/ceil(1/r) is the Engel/Sylvester map, NOT the
>    Gauss map. Gauss-Kuzmin belongs to x -> 1/x - floor(1/x) and does not apply. Both the
>    mediator's Round-1 guess and A's Round-2 [RECALL] were wrong.

## Hypotheses and notation

- The greedy map is r ↦ r − 1/⌈1/r⌉ (the Engel/Sylvester map of the construction).
- The Gauss map is x ↦ 1/x − ⌊1/x⌋, to which the Gauss–Kuzmin theorem belongs.

## Proof / evidence

The source identifies the greedy map as the Engel/Sylvester map by its definition and contrasts it
with the Gauss map; it concludes that Gauss–Kuzmin "does not apply" and records that both earlier
attributions (the mediator's Round-1 guess and A's Round-2 [RECALL]) were wrong. No proof beyond the
definitional identification is needed or given.

## Dependencies and related results

- [round1-verdict-agentb-sylvester-rational-termination](../round1/round1-verdict-agentb-sylvester-rational-termination.md) — the literature termination theorem for this same greedy algorithm.
- [round10-agentb-an-log-log-with-correction](round10-agentb-an-log-log-with-correction.md) — the invariant discussion that depends on which map is in play.

## Notes

- The source's item is a correction of attribution: it does not assert any new theorem about the
  Engel/Sylvester map, only that it is not the Gauss map.
- Round 10 §(D) item 2 reiterates: "keep the Sylvester-vs-Gauss correction, but the measure statement
  needs irrational orbits."
