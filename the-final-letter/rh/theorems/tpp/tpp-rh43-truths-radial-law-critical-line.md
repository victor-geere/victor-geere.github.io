# T16′ — the radial law at σ = 1/2: `P_N, |M_N| ~ (2/π)√N`

**Kind:** Theorem
**Status:** PROVED (identities, radial law) + VERIFIED (numerical, measured constants)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — section headed `### 7.6 Moving to the critical line, \`sigma = 1/2\` (T16)`

## Statement

> **What improves (PROVED + VERIFIED).**
>
> * The partial sums converge: `S_N(1/2+it) -> ζ(1/2+it)`, and the split obeys the radial law `P_N, |M_N| ~ (1/2) Σ_{n<=N} n^{-1/2} = √N`, i.e. **half the sign-blind total each**. Measured at `t = 14.134725`: `(P_N+|M_N|)/√N = 1.2602, 1.2848, 1.2704, 1.2643` for `N = 10^5 … 10^8`, i.e. the constant `∫|cos| = 4/π = 1.2732` (each part `~ (2/π)√N = 0.6366√N`).
> * Fitted growth exponents of `P_N`: `0.955, 0.716, 0.477, 0.241, 0.057, 0.0002` at `sigma = 0, 0.25, 0.5, 0.75, 1, 1.5`, against the law `N^{1-sigma}` (`1, 0.75, 0.5, 0.25, 0, <0`) — the radial decay, verified.

## Hypotheses and notation

- `sigma = Re(S) = 1/2`; the radial weight is `n^{-1/2}`.
- **Radial law:** `P_N, |M_N| ~ (1/2) Σ_{n<=N} n^{-1/2} = √N` — half the sign-blind total each; equivalently each part `~ (2/π)√N = 0.6366√N`.
- Measured `(P_N+|M_N|)/√N = 1.2602, 1.2848, 1.2704, 1.2643` at `t = 14.134725` for `N = 10^5 … 10^8`, against `∫|cos| = 4/π = 1.2732`.
- Fitted exponents `0.955, 0.716, 0.477, 0.241, 0.057, 0.0002` against `N^{1-sigma}` values `1, 0.75, 0.5, 0.25, 0, <0`.

## Proof / evidence

- The radial law is the "PROVED (identities, radial law)" component of ledger row T16; the measured constants and fitted exponents are the "VERIFIED" component.
- The source records the measurements without deriving the constants beyond the identification `∫|cos| = 4/π`.

## Dependencies and related results

- Part of [T16 (the critical-line case)](tpp-rh43-truths-critical-line-sigma-half.md).
- Related: [Theorem 12 (linear divergence)](tpp-rh43-truths-linear-divergence.md) — the `Re(S) = 0` contrast, where each part grows like `N` rather than `√N`.

## Notes

- The source states the radial law and prints the measurement; no separate proof of the constant `4/π` is given in this section beyond naming it as `∫|cos|`.
- The `√N` growth here is the picture the source says "belongs to `Re(S) = 1/2`", in contrast to the linear divergence at `Re(S) = 0`.
