# Theorem 4.1 (sharp error at a zero)

**Kind:** Theorem
**Status:** PROVED (paper argument, Euler–Maclaurin; source also NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §4 "The critical line, and the failure of smoothing (rh43 §7.6, rh044)", "Theorem 4.1 (sharp error at a zero)", line 110

## Statement

> **Theorem 4.1 (sharp error at a zero).**
> ```
> S_N(1/2+it) − ζ(1/2+it) = N^{1−s}/(1−s) + ½N^{−s} − (s/12)N^{−s−1} + …
> |S_N(1/2+it) − ζ(1/2+it)| / √N  →  1/|s−1| = 1/√(1/4+t²)
> ```
> At the first zero `|S_N| ≈ 0.07070354·√N` — the partial sum *grows*; the zero exists
> only in the cancellation.  (An earlier draft's constant `1/√(2t)` is **REFUTED** by a
> factor `2.66`.)

## Hypotheses and notation

- `S_N(1/2+it) = Σ_{n≤N} n^{−s}` with `s = 1/2 + it`; the limit is `N → ∞`.
- The expansion terminates as printed with `…`; `½N^{−s}` and `(s/12)N^{−s−1}` are the first correction terms.
- The asymptotic constant is `1/|s−1| = 1/√(1/4+t²)`, evaluated at the first zero for the numerical value `|S_N| ≈ 0.07070354·√N`.

## Proof / evidence

The source's status line, verbatim:

> *Status:* THEOREM (Euler–Maclaurin) + NUMERICAL (coefficients `0.49999959`,
> `1.178630488 = |s|/12` checked at `N = 102400`).

The proof method named by the source is Euler–Maclaurin; the two coefficients and the check at `N = 102400` are the numerical evidence.

## Dependencies and related results

- [Theorem 3.4 (the linear divergence)](tpp-dict-04-linear-divergence.md) — the same `√N` growth of the sharp partial sum.
- [Theorem 4.2 (the smoothing law)](tpp-dict-04-smoothing-law.md) — the smoothed version, whose constant is `|M_φ(s)|`.

## Notes

- Ledger entry for the **rh43 §7.6 / rh044** material named in the section heading.
- The source records that an earlier draft's constant `1/√(2t)` is **REFUTED** by a factor `2.66`; this refutation is stated inside the theorem's own statement and is reproduced, not upgraded.
