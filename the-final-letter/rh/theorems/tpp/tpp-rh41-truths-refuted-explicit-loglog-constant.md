# Refuted — A(N) = log₂ log N + O(1) with an explicit constant

**Kind:** Claim
**Status:** REFUTED (the per-step factor `r'/r²` has no positive lower bound, minimum 1.58·10⁻⁴)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `A(N) = log₂ log N + O(1)` with an explicit constant
>
> counterexample: the per-step factor `r'/r²` has no positive lower bound (min 1.58·10⁻⁴), so only `Ω_x(log log N)` follows.

## Hypotheses and notation

- `A(N) := #{k : n_k ≤ N}` is the counting function of [the squaring-law claim](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md).
- `r'/r²` denotes the ratio of consecutive residuals `r_{k+1}/r_k²` at an active step.
- The refuted claim is a two-sided asymptotic for `A(N)` with an explicit constant in the `O(1)` term.

## Proof / evidence

The source's counterexample is the absence of a positive lower bound for `r'/r²`, with observed minimum `1.58·10⁻⁴`; consequently only the lower bound `A(N) = Ω_x(log log N)` follows.

The underlying absence of a positive lower bound is machine-checked as `Harmonic.no_positive_lower_bound`; the asymptotic passage itself is not formalised.

## Dependencies and related results

- [The ratio r_{k+1}/r_k² has no positive lower bound](tpp-rh41-truths-claim-no-positive-lower-bound-ratio.md) — the §3 result this row cites.
- [The squaring law r_{k+1} ≤ r_k² and the lower bound A(N) = Ω_x(log log N)](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md) — the surviving one-sided statement.
- [Theorem 12 (inverse problem, impossibility half)](tpp-rh41-truths-theorem-12-inverse-impossibility.md) — the companion impossibility for linear profiles.

## Notes

- The source adds the row under the heading "Refuted — do not re-propose".
- The minimum `1.58·10⁻⁴` is quoted exactly as printed and is listed under "Not formalised" in the round's Lean README.
