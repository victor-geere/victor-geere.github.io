# Consequence 1 — the `√N` growth is universal

**Kind:** Corollary
**Status:** VERIFIED (numerical, last-decade exponent `0.5000` for every weight tested)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) — §2 "Consequences", item 1, lines 86–87

## Statement

> 1. **The `√N` growth is universal.**  No bounded weight removes it; the last-decade log–log exponent is `0.5000` for every weight tested.

## Hypotheses and notation

- A consequence of [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md): for a bounded weight `φ` with convergent Mellin transform, `|S_N^φ(1/2+it) − ζ(1/2+it)|/√N → |M_φ(s)|`.
- "Last-decade" means the log–log exponent fitted over `N = 10^4 → 10^5`; the tested weights are those of Theorem 2's table.

## Proof / evidence

Numerical: the source reports the exponent `0.5000` for every weight tested, and presents the statement as a consequence of [Theorem 2](tpp-rh044-truths-theorem-2-weight-law.md).

## Dependencies and related results

- [Theorem 2 (weight law)](tpp-rh044-truths-theorem-2-weight-law.md) — the result this consequence follows from.
- [R2 — "smoothing removes the `√N` fluctuation"](tpp-rh044-truths-r2-smoothing-removes-sqrt-n.md) — the refuted contrary claim.
- [Consequence 2 — smoothing buys only a constant](tpp-rh044-truths-consequence-2-smoothing-buys-only-constant.md).

## Notes


- Stated by the source as a numbered consequence, not as a separate theorem; the universality rests on Theorem 2's limit together with the tested weights.
- The source's hedging is "for every weight tested" in the numerical part and "No bounded weight removes it" in the headline.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh044/verify/independent_check.log`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
