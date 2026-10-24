# P2 — the budgets

**Kind:** Theorem
**Status:** PROVED (Lean at `p=2,4`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P2 (source round rh42)

## Statement

> the budgets `P = 2^{−p}ζ`, `N = (1−2^{−p})ζ−1`, `P+N = ζ−1`, `P−N = 1−η`, `P > N`

## Hypotheses and notation

- `P` is the positive budget and `N` the negative budget of the signed greedy problem.
- `p > 1`; `ζ = ζ(p) = Σ_{n≥1} n^{−p}` and `η = η(p) = Σ_{n≥1} (−1)^{n−1} n^{−p}` (the alternating zeta), with the symbol conventions used in the round-rh42 statement of the same result (harvested as [Theorem 2](tpp-rh42-truths-theorem-2-budget-algebra.md)); the dictionary row itself uses `ζ` and `η` without restating them.
- The Lean coverage recorded by the ledger is at `p = 2, 4`.

## Proof / evidence

- The ledger records the status as **THEOREM** (Lean at `p=2,4`), sourced to round rh42. No proof text or declaration names are given in the dictionary.

## Dependencies and related results

- Round rh42 (cited by the ledger as this row's source).
- Harvested in full from that round as [Theorem 2 (T2, T3)](tpp-rh42-truths-theorem-2-budget-algebra.md) (`P+N = ζ−1`, `P−N = 1−η`) and [Theorem 3 (T4)](tpp-rh42-truths-theorem-3-p-gt-n.md) (`P > N`); the closed forms `P(2) = π²/24`, `N(2) = π²/8 − 1`, `P(4) = π⁴/1440`, `N(4) = π⁴/96 − 1` are [Theorem 5](tpp-rh42-truths-theorem-5-budget-closed-forms.md).

## Notes

- This is a ledger restatement of results of round rh42 (the dictionary's own id for it is P2); it is a compressed row that merges several statements harvested individually from `rh42/truths.md`.
- Used later in §3 (N2) of the same dictionary: "the budgets are sign-blind (P2/rh47 B2)".
