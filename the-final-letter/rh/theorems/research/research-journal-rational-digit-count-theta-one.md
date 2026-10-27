# A(N) = Θ(1) for rational θ/π, density 0

**Kind:** Proposition
**Status:** CHECKED (exhaustive finite, exact rationals; 268 of 277 reduced p/q with q ≤ 30 terminate)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 1 Agent A answer, line 121; Round 1 status table, lines 151–152; Round 1 Agent B audit, line 169; Round 1 verdict, line 171; "The ten things that stand" §1, line 614

## Statement

> A(N) = #{n ≤ N : δ_n = 1}. **A(N) = Θ(1) for rational θ/π; density 0**, and the mediator's Θ(N) prediction is dead.

The source's precise forms:

> | A(N) = Θ(1) for rational θ/π; density 0 | **STANDING** | exact arithmetic, 268/277 reduced p/q with q ≤ 30 terminate |

> Salvaged core: *the greedy Egyptian digit string of θ/π terminates for rational θ/π, so A(N) = Θ(1), and A(N)/N → 0 for every real target — no positive digit density exists.*

and later, for the irrational case:

> A(N) ≤ √(2N), so A(N)/N → 0 always.

## Hypotheses and notation

- δ_n ∈ {0,1} is the greedy digit of θ/π in the alphabet 1/(n+2); A(N) = #{n ≤ N : δ_n = 1} is the running digit count.
- "Density 0" means A(N)/N → 0.

## Proof / evidence

Exact rational arithmetic with Python `Fraction` was used throughout. The decisive computation: a θ/π = 1 run terminates with indices **{0,1,4}** and residual identically 0; the exhaustive exact-rational rerun over all reduced p/q with q ≤ 30 gives 268 of 277 terminating, the nine slow cases (4/17, 14/19, 17/19, 7/23, 21/23, 4/25, 9/29, 12/29, 27/29) being slow rather than divergent. Agent B confirms A(N) = Θ(1) and A's claim correct, the mediator's Θ(N) wrong.

## Dependencies and related results

- [Termination of the greedy Egyptian expansion for rational θ/π](research-journal-rational-termination.md) — termination forces finite support, hence Θ(1).
- [A(N) = log₂ log N + O(1) for irrational θ/π](research-journal-digit-count-log-log-law.md) — the sharp irrational counterpart, superseding the weaker mediator bound A(N) = O(log log N) recorded in the same round.

## Notes

- The status is CHECKED (exhaustive finite): the δ_n = 0 for all n ≥ 5 conclusion for θ = π is exact and complete, but the general statement "for rational θ/π" rests on the cited termination theorem plus the q ≤ 30 census.
- The journal records that this row is the correction of the mediator's own earlier and wrong Θ(N) prediction: "A corrected me, and he was right."
- The companion "A(N) = O(log log N) for irrational θ/π" measured bound (3–4 terms below N = 2·10⁵ for 1/π, log 2, e−2) was later sharpened to A(N) = log₂ log N + O(1).
