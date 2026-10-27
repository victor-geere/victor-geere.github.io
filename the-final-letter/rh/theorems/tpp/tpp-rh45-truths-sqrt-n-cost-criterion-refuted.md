# C4.1 (`N ≳ T²` suffices) is refuted

**Kind:** Claim
**Status:** REFUTED (numerical: no sign change within `10^{−3}` of `γ₁` for `N` up to `10^6`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh45/truths.md`](../../research/twin-prime-parity/rounds/rh45/truths.md) — §3 "The auditor's four failures — over-strong criteria, not false claims", row C4.1; §2 for the cost figures

## Statement

> | check | verdict | reality |
> |---|---|---|
> | C4.1 (`N ≳ T²` suffices) | REFUTED | the main agent's cost estimate was far too optimistic: no sign change within `10^{−3}` of `γ₁` for `N` up to `10^6` |

The source's §2 cost row gives the witness values:

> `N ≳ 10^6` and still no sign change within `10^{−3}` (auditor C4.1: `Re S_N(t₁)` = `0.644, 6.986, 12.539, 36.052` at `N = 10^3…10^6`, growing like `0.04√N`)

## Hypotheses and notation

- `S_N(s) = Σ_{n≤N} n^{−s}` is the sharp partial sum; `t₁` is the imaginary part of the first zero, `γ₁ = 14.134725141734693790457251983562`.
- The refuted criterion is that `N ≳ T²` partial-sum terms suffice to resolve a zero at height `T` by a sign change.
- The witness values are `Re S_N(t₁) = 0.644, 6.986, 12.539, 36.052` at `N = 10^3, 10^4, 10^5, 10^6`; the growth is like `0.04√N`.

## Proof / evidence

- Numerical witness, auditor C4.1: no sign change within `10^{−3}` of `γ₁` for `N` up to `10^6`, while the real part grows like `0.04√N`.
- The refutation concerns the round's own cost estimate for the **partial-sum** route; the explicit-formula route's cost is `O(T)` `ζ`-evaluations (5 zeros to 32–33 digits, auditor C2).
- The source classifies this among the auditor's four "failures", i.e. "over-strong criteria, not false claims", and it is one of the round's explicit refutations.

## Dependencies and related results

- [How the explicit formula bypasses the rh43/rh044 obstruction (T4)](tpp-rh45-truths-bypasses-sqrt-n-obstruction.md) — the comparison whose cost row carries these numbers.
- [The zeros (T2)](tpp-rh45-truths-first-zeros-32-digits.md) — the five zeros obtained on the `O(T)` route.
- [The counting formula (T2/T3, the robust core)](tpp-rh45-truths-counting-formula.md).

## Notes

- This refutes the main agent's cost estimate, not the explicit formula or the counting formula.
- The digit string `10^{−3}` is the source's own tolerance; the source does not state how the sign change was searched.
