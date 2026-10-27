# Theorem 3.4 (the linear divergence)

**Kind:** Theorem
**Status:** PROVED (paper argument, Euler–Maclaurin; source also NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/04-zeta-relations.md`](../../research/twin-prime-parity/dictionary/04-zeta-relations.md) — §3 "The balance split at `Re(S) = 0` (rh43)", "Theorem 3.4 (the linear divergence)", line 94

## Statement

> **Theorem 3.4 (the linear divergence).**  `|S_N(t)|/N → 1/√(1+t²)`; equivalently
> `S_N(t) = N^{1−it}/(1−it) + O(1)` is the dominant term at every fixed `t`.  So the
> question is only well posed for **finite** partial sums.

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}` as in [Theorem 3.1](tpp-dict-04-balance-split-identity.md); `t` is fixed and real as `N → ∞`.
- `O(1)` is with respect to `N → ∞` at fixed `t`.
- The conclusion drawn by the source is that the balance question of §3 "is only well posed for **finite** partial sums".

## Proof / evidence

The source's status line, verbatim:

> *Status:* THEOREM (Euler–Maclaurin) + NUMERICAL (`|S_{10⁴}(1)| = 7071.771405`).

The proof method named by the source is Euler–Maclaurin; the numerical value `|S_{10⁴}(1)| = 7071.771405` is the source's check.

## Dependencies and related results

- [Theorem 3.1 (the identity)](tpp-dict-04-balance-split-identity.md) and [Theorem 3.2 (attainability)](tpp-dict-04-attainability-of-balance.md) — the finite-`N` balance results that this divergence says cannot be pushed to `N → ∞`.
- [Theorem 4.1 (sharp error at a zero)](tpp-dict-04-sharp-error-at-a-zero.md) — the same growth mechanism at a zero on the critical line.

## Notes

- Ledger entry for the **rh43** round (section headed "(rh43)").
