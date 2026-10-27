# The lift: every increment is positive, in n and in t alike

**Kind:** Claim
**Status:** PROVED (paper argument, arithmetic on the construction; VERIFIED numerically)
**Area:** rh-html
**Source:** [`rh34.html`](../../html/rh34.html) — §2 "The lift, and what the row cannot see"

## Statement

> Count both rotations the same way and every increment is positive. In n: ϑ<sub>n+1</sub> − ϑ<sub>n</sub> = π + t·log(1+1/n), whose least value over n &lt; 4000 and t from γ<sub>1</sub> out to 4800 is 3.1451 — just above π, approaching it only in the limit. In t: dϑ<sub>n</sub>/dt = log n, least at n = 2. The thread climbs and does not come back.

> One correction to the corpus while we are here. rh3 §6 computes a phase velocity π − t/x vanishing at x* = t/π and reads off a reversal — "the first four or five circles turn one way, everything deeper turns the other" — and rh5 §3 repeats it. Both reproduce exactly: x* = 4.4992 at t = γ<sub>1</sub>, with the level increment turning positive at n = 5. But it is a consequence of writing the torsion as −t·log n against half-turns of +π, and the relative sign is a convention, not a fact about the construction. With the signs aligned there is no reversal to explain.

## Hypotheses and notation

- The construction of [rh3](../rh3/rh3-half-turns-analytic-continuation.md) §§5–6: the cumulative angle of gear n is ϑ<sub>n</sub> = (n−1)π + t·log n — the half-turns plus the torsion, one dial driving every gear at its own rate log n.
- Both bookkeeping axes are cumulative and one-way, and the levels sit at increasing depth, so 2π is not 0; it is the next floor up.
- t ranges out to 4800 (rh29's window); γ<sub>1</sub> is the first ordinate.

## Proof / evidence

Arithmetic on the construction: the least increment in n over n &lt; 4000 and t from γ<sub>1</sub> out to 4800 is 3.1451, just above π and approached only in the limit; dϑ<sub>n</sub>/dt = log n, least at n = 2. The opposed-sign reading reproduces exactly (x* = 4.4992 at t = γ<sub>1</sub>, the level increment turning positive at n = 5) and is retired as an artifact of the sign convention.

## Dependencies and related results

- [rh3 §6](../rh3/rh3-half-turns-analytic-continuation.md), [rh5](../rh5/rh5-altitude-of-rh.md) §3 — the reversal claim corrected here.
- rh34 §2's cardbox: "§2's statements about the lift are arithmetic on the construction and are unconditional."

## Notes

- The source presents this as the document's foundational geometric statement; the geometry of the wrap (no mod 2π) is the objection the whole document executes.
- This document reads the construction with the *aligned* sign. rh38 §4 later proves the mirror relation between the two conventions and corrects the inference drawn from this section; see [rh38-mirror-conjugation-invariance](../rh38/rh38-mirror-conjugation-invariance.md).
