# All 277 reduced p/q with q ≤ 30 terminate

**Kind:** Claim
**Status:** CHECKED (exhaustive finite: all 277 reduced `p/q` with `q ≤ 30`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §3 "The support: greedy orbits"

## Statement

> **Checked.** All 277 reduced `p/q` with `q ≤ 30` terminate; 275 are reached within `n ≤ 5·10⁶` (the two deepest are `4/25` at 53 307 974 and `27/29` at 1 003 066 151).

## Hypotheses and notation

- `p/q` is a reduced rational target with `q ≤ 30`; "terminate" means the residual reaches `0` at some finite step, as in [Theorem 8](tpp-rh41-truths-theorem-8-rational-termination.md).
- "Reached within `n ≤ 5·10⁶`" counts the step index `n` at which the last taking occurs; the two exceptions are listed with their exact step counts `53 307 974` and `1 003 066 151`.

## Proof / evidence

The source's evidence is the exhaustive finite check over all 277 reduced rationals with denominator `q ≤ 30`.

The round's Lean README records the cross-check of `Harmonic.terminates_rat` against this census (`exact fractions`, 277 cases, no violations); `Harmonic.terminates_rat` itself is the general theorem.

## Dependencies and related results

- [Theorem 8 (rational termination)](tpp-rh41-truths-theorem-8-rational-termination.md) — the general theorem this census instantiates numerically.
- Restates [Theorem 8](tpp-rh41-truths-theorem-8-rational-termination.md) on the finite class `q ≤ 30` (same round, §3).

## Notes

- The source gives the census as **Checked** evidence for Theorem 8, not as an independent proof.
- The numbers `277`, `275`, `5·10⁶`, `4/25` at `53 307 974` and `27/29` at `1 003 066 151` are quoted exactly as printed.
