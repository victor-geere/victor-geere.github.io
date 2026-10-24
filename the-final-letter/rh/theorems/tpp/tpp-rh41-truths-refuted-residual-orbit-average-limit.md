# Refuted — the residual-orbit average has a limit independent of x

**Kind:** Claim
**Status:** REFUTED (counterexample: `q_0=4`, `q_{k+1}=2q_k²` gives limit `log(1/2) = −0.6931…`, not `−1`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> the residual-orbit average has a limit independent of `x`
>
> counterexample: `q_0=4, q_{k+1}=2q_k²` gives limit `log(1/2) = −0.6931…`, not `−1`.

## Hypotheses and notation

- The residual orbit is that of the greedy rule of §3 (residual `r_k`, active steps); the candidate claim is that an average over the orbit converges to a limit that does not depend on the target `x`.
- The witness orbit satisfies `q_0 = 4`, `q_{k+1} = 2q_k²`; its average limit is `log(1/2) = −0.6931…`, whereas the value `−1` is claimed to be universal.

## Proof / evidence

The counterexample is displayed in the source's §5 table, with the limit value `log(1/2) = −0.6931…`; no further proof is given.

Not formalised: the round's Lean README lists this row ("the residual-orbit average limit") under "Not formalised".

## Dependencies and related results

- [Theorem 7 (maps)](tpp-rh41-truths-theorem-7-induced-maps.md) — the exact orbit maps on the same dynamics.
- [The squaring law r_{k+1} ≤ r_k² and the lower bound A(N) = Ω_x(log log N)](tpp-rh41-truths-claim-squaring-law-omega-lower-bound.md), [The ratio r_{k+1}/r_k² has no positive lower bound](tpp-rh41-truths-claim-no-positive-lower-bound-ratio.md) — the §3 results on this orbit.

## Notes

- The value `−0.6931…` is quoted exactly as printed (an approximation of `log(1/2)`).
- The source adds the row under the heading "Refuted — do not re-propose".
