# T16 — the critical-line case σ = 1/2

**Kind:** Theorem
**Status:** PROVED (identities, radial law) + VERIFIED (numerics, including the `1/√(2t)` coefficient)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — §8 ledger row T16 (prose in the section headed `### 7.6 Moving to the critical line, \`sigma = 1/2\` (T16)`)

## Statement

> | id | statement | status | evidence |
> |---|---|---|---|
> | T16 | the critical-line case `σ = 1/2`: radial decay `P_N, \|M_N\| ~ (2/π)√N` (verified), partial sums converge, but finite-`N` balance sees generic roots (scale `1/log N`), not zeta zeros; `\|S_N\| = √N/√(2t)` at a zero | **PROVED** (identities, radial law) + **VERIFIED** (numerics incl. the `1/√(2t)` coefficient) | §7.6 |

The prose section §7.6 states:

> The single change `Re(S): 0 -> 1/2` gives the terms their **radial decay** `n^{-1/2}`, and it changes the character of every object in this folder. What it does *not* do is make the finite-`N` balance condition see the zeros of `zeta`.
>
> **What improves (PROVED + VERIFIED).**
>
> * The partial sums converge: `S_N(1/2+it) -> ζ(1/2+it)`, and the split obeys the radial law `P_N, |M_N| ~ (1/2) Σ_{n<=N} n^{-1/2} = √N`, i.e. **half the sign-blind total each**. Measured at `t = 14.134725`: `(P_N+|M_N|)/√N = 1.2602, 1.2848, 1.2704, 1.2643` for `N = 10^5 … 10^8`, i.e. the constant `∫|cos| = 4/π = 1.2732` (each part `~ (2/π)√N = 0.6366√N`).
> * Fitted growth exponents of `P_N`: `0.955, 0.716, 0.477, 0.241, 0.057, 0.0002` at `sigma = 0, 0.25, 0.5, 0.75, 1, 1.5`, against the law `N^{1-sigma}` (`1, 0.75, 0.5, 0.25, 0, <0`) — the radial decay, verified.
> * So the balance becomes *relative*: the two parts are each half the total, and the arithmetic content sits in the convergent difference `Re ζ(1/2+it)`.
>
> **What does *not* improve (VERIFIED).**
>
> * **The partial sum does not see the zero at finite `N`.** At the first zero `t = 14.134725141734693` (`ζ(1/2+it) = 1.2e-16 - 7.3e-16 i`), `|S_N|/√N = 0.0707053, 0.0707037, 0.0707035, 0.07070353` for `N = 10^4, 10^5, 10^6, 10^7` — the constant `1/√(2t) = 0.0707036…`. The partial sum *grows* like `0.0707√N` **at the zero**; the zero lives entirely in the cancellation `ζ - S_N = -0.0707√N + o(√N)`.
> * **The finite-`N` balance condition is a different equation.** `Re S_N(1/2+it) = 0` has its smallest positive root at `0.505, 0.304, 0.214, 0.164, 0.132` for `N = 10^2 … 10^6`, in rough agreement with the scale `1/log N` of the oscillation of the main term `N^{1/2+it}/(1/2+it)` — generic roots of a Dirichlet polynomial, clustering at `t -> 0`, and not the zeta zeros (`14.13, 21.02, …`).
> * **The imbalance does not decay as `N^{-1/2}`.** It is `|Re S_N| ≈ 0.07√N`, so the *relative* gap stays `≈ 0.05` rather than falling (`0.055, 0.074, 0.00075, 0.065, 0.071` for `N = 10^4 … 10^8`). The slow, `O(√N)`, convergence of the Dirichlet series on the critical line dominates the finite-`N` picture.
>
> **Verdict.** `sigma = 1/2` is the right abscissa for radial decay and for a *convergent* difference, but the bridge from this finite-`N` split to the zeta zeros would still require the step this folder does not have: a smoothing/summation method (Euler–Maclaurin or an explicit formula) that unwinds the main term `N^{1/2+it}` and extracts `ζ` to `o(1)` accuracy. With a plain sharp cutoff the error is `O(√N)` and no finite-`N` balance condition can see a zero.

## Hypotheses and notation

- `sigma = Re(S) = 1/2`; `S_N(1/2+it) = Σ_{n≤N} n^{-1/2-it}`; `P_N`, `M_N` the positive/negative real-part sums with radial weight `n^{-1/2}`.
- Radial law: `P_N, |M_N| ~ (1/2) Σ_{n<=N} n^{-1/2} = √N`, each part `~ (2/π)√N = 0.6366√N`; measured `(P_N+|M_N|)/√N = 1.2602, 1.2848, 1.2704, 1.2643` for `N = 10^5 … 10^8` at `t = 14.134725`, against `∫|cos| = 4/π = 1.2732`.
- First zeta zero quoted: `t = 14.134725141734693`, with `ζ(1/2+it) = 1.2e-16 - 7.3e-16 i`; `|S_N|/√N = 0.0707053, 0.0707037, 0.0707035, 0.07070353` for `N = 10^4, 10^5, 10^6, 10^7`, against `1/√(2t) = 0.0707036…`.
- Finite-`N` roots of `Re S_N(1/2+it) = 0`: `0.505, 0.304, 0.214, 0.164, 0.132` for `N = 10^2 … 10^6`, against the scale `1/log N`.
- Fitted exponents of `P_N`: `0.955, 0.716, 0.477, 0.241, 0.057, 0.0002` at `sigma = 0, 0.25, 0.5, 0.75, 1, 1.5`, against `N^{1-sigma}`.

## Proof / evidence

- Ledger row T16: "**PROVED** (identities, radial law) + **VERIFIED** (numerics incl. the `1/√(2t)` coefficient)", evidence "§7.6".
- The radial law `P_N, |M_N| ~ (1/2) Σ_{n<=N} n^{-1/2} = √N` and the `~ (2/π)√N` per part are the "PROVED (identities, radial law)" component; the numerical constants and exponents are the "VERIFIED" component.
- The source states the verdict as a limit on what can be claimed: no bridge from this finite-`N` split to the zeta zeros is proved here.

## Dependencies and related results

- Related: [Theorem 12 (linear divergence)](tpp-rh43-truths-linear-divergence.md) (the `Re(S) = 0` contrast); [The N -> infinity asymptotic of the split](tpp-rh43-truths-n-to-infinity-asymptotic-split.md) (T15).
- The radial-decay claim is listed among the ledger's `**PROVED** (identities, radial law)` items.

## Notes

- The section containing this material is headed `### 7.6` in the source, although it appears before `## 8.5`; the ledger row T16 points at it as "§7.6".
- The source flags explicitly: the partial sum does **not** see the zero at finite `N`, and "no finite-`N` balance condition can see a zero" with a plain sharp cutoff.
