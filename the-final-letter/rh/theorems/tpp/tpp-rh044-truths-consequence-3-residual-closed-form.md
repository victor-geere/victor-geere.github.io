# Consequence 3 — the residual's closed form

**Kind:** Corollary
**Status:** VERIFIED (numerical; constants and slopes fitted)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §2 "Consequences", item 3, lines 92–99

## Statement

> 3. **The residual's closed form.**  `S_N^φ − ζ = N^{1−s}J_φ(s) + φ(0)ζ(s) + R_N`,
>    with `|R_N|·√N` bounded by a weight-dependent constant: `0.5` exactly for the
>    sharp cutoff (`R_N = ½N^{−s}`), `0.0386` (`u(1−u)`), `1.25·10^{−3}` (raised
>    cosine), `3.3·10^{−7}` (`(u(1−u))^3`), `0.192` (`e^{−u}`), with fitted residual
>    slopes `−0.50, −1.00, −2.00, −3.00, −0.49`.  For the exponential weight *summed
>    to convergence* one has instead `E = Γ(1−s)N^{1−s} + O(1/N)` with
>    `|Γ(1−s)| = √(π/cosh πt) = 5.7·10^{−10}` — exponentially small in `t`, but the
>    hidden `√N` term takes over only beyond `N ≈ 4.6·10^{18}`.

## Hypotheses and notation

- A consequence of [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md); `E = S_N^φ − ζ` is the smoothed error.
- `J_φ(s)` is the source's symbol for the coefficient of the leading term `N^{1−s}` in the residual's closed form; `Γ` is the gamma function.
- The weights named are those of Theorem 2's table; "raised cosine" is `(1−cos 2πu)/2`.
- The boundedness claim is stated for `|R_N|·√N`; the slopes are fitted residual slopes.

## Proof / evidence

Numerical/fitted: the source quotes the residual identity, the weight-dependent bounds `0.5, 0.0386, 1.25·10^{−3}, 3.3·10^{−7}, 0.192`, the fitted slopes `−0.50, −1.00, −2.00, −3.00, −0.49`, and, for the exponential weight summed to convergence, `E = Γ(1−s)N^{1−s} + O(1/N)` with `|Γ(1−s)| = √(π/cosh πt) = 5.7·10^{−10}` and the crossover `N ≈ 4.6·10^{18}`.

## Dependencies and related results

- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the result this consequence follows from.
- [Consequence 2 — smoothing buys only a constant](tpp-rh044-truths-consequence-2-smoothing-buys-only-constant.md).
- [Theorem 3 (Riemann's theta identity)](tpp-rh044-truths-theorem-3-riemann-theta-identity.md) — the alternative route that avoids the hidden `√N` term.

## Notes


- `J_φ(s)` appears only in this item of the source; the statement is quoted verbatim, and the symbol is not defined further there.
- Status VERIFIED (numerical): the constants and slopes are fitted/measured, not proved.
- The last clause is the source's own hedge: the `e^{−πt}`-type smallness is real but the hidden `√N` term dominates until `N ≈ 4.6·10^{18}`.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh044/verify/smoothed_zeta.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
