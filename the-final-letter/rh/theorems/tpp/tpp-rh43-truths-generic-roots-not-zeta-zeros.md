# T16″ — the finite-N balance sees generic roots, not zeta zeros

**Kind:** Theorem
**Status:** PROVED + VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) — section headed `### 7.6 Moving to the critical line, \`sigma = 1/2\` (T16)`

## Statement

> **What does *not* improve (VERIFIED).**
>
> * **The partial sum does not see the zero at finite `N`.** At the first zero `t = 14.134725141734693` (`ζ(1/2+it) = 1.2e-16 - 7.3e-16 i`), `|S_N|/√N = 0.0707053, 0.0707037, 0.0707035, 0.07070353` for `N = 10^4, 10^5, 10^6, 10^7` — the constant `1/√(2t) = 0.0707036…`. The partial sum *grows* like `0.0707√N` **at the zero**; the zero lives entirely in the cancellation `ζ - S_N = -0.0707√N + o(√N)`.
> * **The finite-`N` balance condition is a different equation.** `Re S_N(1/2+it) = 0` has its smallest positive root at `0.505, 0.304, 0.214, 0.164, 0.132` for `N = 10^2 … 10^6`, in rough agreement with the scale `1/log N` of the oscillation of the main term `N^{1/2+it}/(1/2+it)` — generic roots of a Dirichlet polynomial, clustering at `t -> 0`, and not the zeta zeros (`14.13, 21.02, …`).
> * **The imbalance does not decay as `N^{-1/2}`.** It is `|Re S_N| ≈ 0.07√N`, so the *relative* gap stays `≈ 0.05` rather than falling (`0.055, 0.074, 0.00075, 0.065, 0.071` for `N = 10^4 … 10^8`). The slow, `O(√N)`, convergence of the Dirichlet series on the critical line dominates the finite-`N` picture.
>
> **Verdict.** `sigma = 1/2` is the right abscissa for radial decay and for a *convergent* difference, but the bridge from this finite-`N` split to the zeta zeros would still require the step this folder does not have: a smoothing/summation method (Euler–Maclaurin or an explicit formula) that unwinds the main term `N^{1/2+it}` and extracts `ζ` to `o(1)` accuracy. With a plain sharp cutoff the error is `O(√N)` and no finite-`N` balance condition can see a zero.

## Hypotheses and notation

- First zeta zero quoted: `t = 14.134725141734693`, with `ζ(1/2+it) = 1.2e-16 - 7.3e-16 i`.
- `|S_N|/√N = 0.0707053, 0.0707037, 0.0707035, 0.07070353` for `N = 10^4, 10^5, 10^6, 10^7`, against the constant `1/√(2t) = 0.0707036…`.
- Finite-`N` smallest positive roots of `Re S_N(1/2+it) = 0`: `0.505, 0.304, 0.214, 0.164, 0.132` for `N = 10^2 … 10^6`; scale `1/log N`; the main term is `N^{1/2+it}/(1/2+it)`.
- Relative gap values `0.055, 0.074, 0.00075, 0.065, 0.071` for `N = 10^4 … 10^8`.

## Proof / evidence

- All three bullets are marked **(VERIFIED)** in the source; the verdict is a statement of what is *not* proved (the missing smoothing/summation step).
- Ledger row T16 carries the whole section under "**PROVED** (identities, radial law) + **VERIFIED** (numerics incl. the `1/√(2t)` coefficient)".

## Dependencies and related results

- Part of [T16 (the critical-line case)](tpp-rh43-truths-critical-line-sigma-half.md); contrast [T16′ (the radial law)](tpp-rh43-truths-radial-law-critical-line.md).
- Related: [Theorem 6 (certified root table)](tpp-rh43-truths-certified-root-table.md) — the roots at `Re(S) = 0`; here the roots are at `sigma = 1/2` and are explicitly *not* zeta zeros.

## Notes

- The source's §9 and README repeat: "No relation is claimed between the roots of `Re S_N(t)` tabulated here and the zeros of `ζ(1/2 + it)` or `ζ(it)`."
- The verdict states a required missing input — a smoothing/summation method that unwinds the main term `N^{1/2+it}` — rather than a proof.
