# P4 — completeness thresholds

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md`](../../research/twin-prime-parity/dictionary/05-programme-barriers-and-harvest.md) — §1 "What the programme proved (the positive ledger)", row P4 (source round rh42)

## Statement

> completeness thresholds: positive half ⟺ `ζ(p) ≥ 2` (i.e. `p ≤ p*`); negative ⟺ `p ≤ q`

## Hypotheses and notation

- "Positive half complete" means every `x ∈ [0,P(p)]` is writable; "negative" means every `x ∈ [−N(p),0]` is writable (per the matching result harvested from rh42).
- `ζ(p) = Σ_{n≥1} n^{−p}`; `p*` is the initial exponent at which `ζ(p) = 2`; `q` is the corresponding threshold for the negative half.
- The thresholds are those of the signed greedy problem at exponent `p`.

## Proof / evidence

- The ledger records the status as **THEOREM**, sourced to round rh42; no proof text or Lean note is given in the dictionary.

## Dependencies and related results

- Round rh42 (cited by the ledger as this row's source).
- Harvested in full from that round as [Theorem 8 (completeness thresholds, T10, T13)](tpp-rh42-truths-theorem-8-completeness-thresholds.md), and its immediate consequence [Corollary 9](tpp-rh42-truths-corollary-9-writable-intervals.md).

## Notes

- This is a ledger restatement of a result of round rh42 (the dictionary's own id for it is P4).
- The ledger records the status only as "THEOREM" and does not note Lean for this row; the qualifier `paper argument` here follows the source's own legend, "THEOREM: proved (Lean where noted)".
