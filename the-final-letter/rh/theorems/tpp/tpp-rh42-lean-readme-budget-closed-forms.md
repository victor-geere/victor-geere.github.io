# `Rh42/Budget.lean` — the budget closed forms (`hasSum_even_zeta_two`, `positiveBudget_two`, …)

**Kind:** Theorem
**Status:** PROVED (Lean, machine-checked; no `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — "What is proved, item by item", `### Rh42/Budget.lean — truths.md §2`

## Statement

> | `truths.md` | Lean | statement |
> |---|---|---|
> | `P(2) = π²/24` | `hasSum_even_zeta_two`, `positiveBudget_two` | `HasSum (fun k => 1/(2k)^2) (π²/24)` and the `k ≥ 1` budget `∑' k, 1/(2(k+1))^2 = π²/24` |
> | `N(2) = π²/8 − 1` | `tsum_odd_zeta_two`, `negativeBudget_two` | `∑' k, 1/(2k+1)^2 = π²/8` and the budget from the denominator `3` on |
> | `P(4) = π⁴/1440` | `hasSum_even_zeta_four`, `positiveBudget_four` | |
> | `N(4) = π⁴/96 − 1` | `tsum_odd_zeta_four`, `negativeBudget_four` | |
> | `P(2) + N(2) = π²/6 − 1` | `budget_two_sum` | the budget interval's length at `p = 2` |

## Hypotheses and notation

- `HasSum f a` is the Mathlib predicate for the series of `f` summing to `a`; `∑' k, …` is `tsum`.
- `P(p) = 2^{−p}ζ(p)` and `N(p) = (1−2^{−p})ζ(p) − 1` are the budgets of the round (`truths.md` §2).
- The README's file row: "`Rh42/Budget.lean` | the budget closed forms".

## Proof / evidence

> All from Mathlib's `hasSum_zeta_two` / `hasSum_zeta_four`, splitting the `ζ` series into its even and odd parts (`HasSum.mul_left`, `tsum_even_add_odd`, `Summable.comp_injective`).

The README's preamble adds: "No `sorry`, no `admit`, no project-specific `axiom`, no `native_decide`. Everything is stated about the same objects as the Python ground truth (`../reachable.py`, `../helix_zeta.py`)." and building is `cd rh42/lean && ./check.sh --all`.

## Dependencies and related results

- Depends on Mathlib's `hasSum_zeta_two`, `hasSum_zeta_four`.
- The same closed forms are stated in the round's HANDOFF §5.1 (`P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1`) and in `rh42/truths.md` §2 (harvested separately as the budget closed forms).
- `Rh42/Tau.lean` imports `Rh41.DigitWord` from `../../rh41/lean` for the factor-complexity reuse.

## Notes

- The README states these as Lean declarations with their `HasSum`/`tsum` statements; two cells are left blank in the source table (`P(4)`, `N(4)` rows) and are reproduced blank.
- This entry restates the closed forms already recorded for `rh42/truths.md` §2 and for the HANDOFF ledger row T2; the Lean names are new information here.
- The README's `check.sh --all` contract and the no-`sorry` claim are the source's own build claims; this harvest did not re-run the toolchain.
