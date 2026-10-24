# (A)6 Three-term unit-fraction uniqueness: 1/a + 1/b + 1/c = 1 has the unique solution (2, 3, 6)

**Kind:** Theorem
**Status:** PROVED (paper argument, unconditional two-line proof; no bound on c)
**Area:** workspace
**Source:** [`round10_agentB.md`](../../research/various/round10_agentB.md) — §(A) "CLOSING VERDICT", standing item 6, lines 16–19

## Statement

> 6. 3-term unit-fraction uniqueness is a theorem, not a computation: 1/a+1/b+1/c=1 needs
>    3/a>=1 so a<=3; a=2 gives 1/b+1/c=1/2 with b>2 => c=2b/(b-2)>b forces b<4 => (2,3,6);
>    a=3 gives 1/b+1/c=2/3 but b>3 => <=1/2. UNIQUE, unconditionally, no bound on c.
>    Therefore the perfect-number observation has no arithmetic content.

## Hypotheses and notation

- a, b, c are positive integers, ordered so that a < b < c; this is the ordering used by the source's argument (3/a ≥ 1, so a ≤ 3).
- The equation is 1/a + 1/b + 1/c = 1.

## Proof / evidence

The source gives the two-line proof verbatim: 1/a + 1/b + 1/c = 1 forces 3/a ≥ 1, so a ≤ 3; for
a = 2, 1/b + 1/c = 1/2 with b > 2 gives c = 2b/(b − 2) > b, which forces b < 4, yielding (2, 3, 6);
for a = 3, 1/b + 1/c = 2/3 but b > 3 gives at most 1/2, a contradiction. Hence the solution is
unique, unconditionally, with no bound on c.

## Dependencies and related results

- [handoff-rational-termination-and-2-3-6](../handoff/handoff-rational-termination-and-2-3-6.md) — the same uniqueness harvested from HANDOFF.md (there stated alongside rational termination).
- [round1-verdict-agentb-alg-e-rational-termination](../round1/round1-verdict-agentb-alg-e-rational-termination.md) — the instance 1/2 + 1/3 + 1/6 = 1 with indices {0, 1, 4}.

## Notes

- The source elevates this above a computation: "a theorem, not a computation … UNIQUE,
  unconditionally, no bound on c", and draws the corollary that "the perfect-number observation has
  no arithmetic content" — the corollary is quoted as part of the item.
- Round 10 §(D) item 1 records the same correction: the uniqueness "is not merely verified to
  200000 — it is a two-line theorem with no bound needed".
