# Consequence 2 — smoothing buys only a constant

**Kind:** Corollary
**Status:** VERIFIED (numerical)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §2 "Consequences", item 2, lines 88–91

## Statement

> 2. **Smoothing buys only a constant.**  Best of the tested weights, `(u(1−u))^3`: `|M_φ| = 1.18·10^{−4}` against the sharp `7.07·10^{−2}` — a factor `600`.  The max of `|E|√N` over `N = 10^2 … 10^5` is `7070` (sharp), `490` (`u(1−u)`), `11.8` (`(u(1−u))^3`), `797` (raised cosine), `2614` (`e^{−u}`).

## Hypotheses and notation

- A consequence of [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md); `E = S_N^φ − ζ` is the smoothed error.
- The weights named are those of Theorem 2's table; "raised cosine" is the weight `(1−cos 2πu)/2`.
- The factor `600` compares the best tested weight `(u(1−u))^3` with the sharp cutoff `φ ≡ 1`.

## Proof / evidence

Numerical: the source quotes `|M_φ| = 1.18·10^{−4}` for `(u(1−u))^3` against the sharp `7.07·10^{−2}` (a factor `600`), and the maxima of `|E|√N` over `N = 10^2 … 10^5` for the five listed weights.

## Dependencies and related results

- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the result this consequence follows from.
- [Consequence 1 — the `√N` growth is universal](tpp-rh044-truths-consequence-1-sqrt-n-growth-universal.md).
- [Consequence 3 — the residual's closed form](tpp-rh044-truths-consequence-3-residual-closed-form.md).

## Notes


- "Buys" refers only to the constant `|M_φ(s)|`; the `√N` growth itself is untouched (Consequence 1).
- The numbers are measurements of the round, quoted exactly; the source gives no proof beyond Theorem 2 and the table.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh044/verify/independent_check.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
