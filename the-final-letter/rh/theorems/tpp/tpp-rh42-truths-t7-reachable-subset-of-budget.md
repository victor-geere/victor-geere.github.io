# T7 — reachable ⊆ budget; above it, residual → x − P(p)

**Kind:** Claim
**Status:** PROVED (from Theorem 6 + Theorem 11)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §11 "The handoff ledger, item by item", row T7

## Statement

> | id | statement | was | now | where |
> |---|---|---|---|---|
> | T7 | reachable ⊆ budget; above it, residual → `x − P(p)` | PROVED+VERIFIED | **PROVED** (Theorem 6 + 11) | §3, §4 |

## Hypotheses and notation

- "Reachable" = the set `S` of sub-sums (of the positive half, `a_k = (2k)^{−p}`); "budget" = `P(p) = Σ_{k≥1} (2k)^{−p}`.
- "Above it" = targets `x` exceeding the budget `P(p)`; the residual then tends to `x − P(p)`.
- `x` is the target height (`x = sin(2πθ)`, §0/§8).

## Proof / evidence

The ledger row cites Theorem 6 and Theorem 11:
- [Theorem 6 (Brown's criterion, T10/T13 core)](tpp-rh42-truths-theorem-6-brown-criterion.md) — sub-sums lie in `[0, A]`, giving reachable ⊆ budget;
- [Theorem 11 (greedy optimality, new)](tpp-rh42-truths-theorem-11-greedy-optimality.md) — the greedy limit is `max{s ∈ S : s ≤ x}`, so for `x > P(p)` the residual tends to `x − P(p)`.

§3 also states the framing: "The budgets are only an **outer** bound."

## Dependencies and related results

- [Theorem 6 (Brown's criterion, T10/T13 core)](tpp-rh42-truths-theorem-6-brown-criterion.md), [Theorem 11 (greedy optimality, new)](tpp-rh42-truths-theorem-11-greedy-optimality.md).
- The refutation of the converse direction ("inside the budget ⟹ writable") is [R2](tpp-rh42-truths-r2-inside-budget-not-writable.md).
- Companion ledger row [T6 (§11)](tpp-rh42-truths-t6-budget-test-at-p-1.md).

## Notes

- The ledger records the status as upgraded from PROVED+VERIFIED to **PROVED** (Theorem 6 + 11); this file records the upgrade as the source states it.
- The row is a compact ledger statement; the source's precise witnesses are the two theorems it names.
