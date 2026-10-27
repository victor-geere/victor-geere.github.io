# R2 (refuted) — "inside the budget ⟹ writable"

**Kind:** Claim
**Status:** REFUTED (smallest witness below)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §9 "Refuted — do not re-propose", row R2

## Statement

> | # | statement | smallest witness |
> |---|---|---|
> | R2 | "inside the budget ⟹ writable" | `p = 2`, `x = 1/5`: inside `P(2) = 0.4112`, inside the sine range, inside the gap `(0.16123, 0.25)` |

## Hypotheses and notation

- The refuted implication: if a target `x` lies inside the budget interval (i.e. `|x| ≤ P(p)` on the positive side / within `[−N(p), P(p)]`) then `x` is writable by the signed rule.
- Witness: `p = 2`, `x = 1/5`; `P(2) = 0.4112`; the `p = 2` reachable set has the single gap `(0.16123, 0.25)`, which contains `1/5`.

## Proof / evidence

The source cites the §5 `p = 2` verification: "**VERIFIED**: ten rational targets decided exactly, including `1/5 → not reachable`" in [Theorem 12 (p = 2)](tpp-rh42-truths-theorem-12-p-equals-2.md), together with the census structure of [Theorem 10 (census, new)](tpp-rh42-truths-theorem-10-census.md).

## Dependencies and related results

- [Theorem 12 (p = 2)](tpp-rh42-truths-theorem-12-p-equals-2.md) — the exact reachable set and the gap `(0.161233516712…, 0.25)`.
- [R5 — "every rational target terminates" at general p](tpp-rh42-truths-r5-rational-termination-general-p.md) — cites this same witness.
- The budget is only an **outer** bound (§3 opening: "The budgets are only an **outer** bound.").

## Notes

- The gap is printed as `(0.16123, 0.25)` in the §9 row and as `(0.161233516712…, 0.25)` in §5; both are quoted exactly where they occur in this harvest.
