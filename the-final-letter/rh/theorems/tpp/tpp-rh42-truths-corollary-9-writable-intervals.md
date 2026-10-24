# Corollary 9

**Kind:** Corollary
**Status:** PROVED (paper argument, immediate from Theorem 8)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/truths.md`](../../research/twin-prime-parity/rounds/rh42/truths.md) — §3 "The exact reachable set: Brown's criterion"

## Statement

> Every `x ∈ [0,P(p)]` is writable for `p ≤ p*`, and every `x ∈ [−N(p),0]` for
> `p ≤ q`.

## Hypotheses and notation

- `p > 1`; `P(p)`, `N(p)` are the budgets of §2.
- `p* = 1.7286472389981836181…`, `q = 2.07677517921069…` (Theorem 8).
- "writable" means the target is a sub-sum of the corresponding half-series, i.e. lies in the reachable set.

## Proof / evidence

The source states this immediately after Theorem 8 and gives no separate proof or evidence line: it is the writability reading of the two completeness equivalences of Theorem 8 (`S = [0, P(p)]` for `p ≤ p*`, `S = [0, N(p)]` for `p ≤ q`).

## Dependencies and related results

- [Theorem 8 (completeness thresholds, T10, T13)](tpp-rh42-truths-theorem-8-completeness-thresholds.md).
- The comparison `p* < q` is also recorded in §6's ordering `pN < pP < p* < q`.

## Notes

- The source's own explanation, quoted verbatim: "Since `p* ≈ 1.73 < q ≈ 2.08`, the *negative* half stays complete longer: its first term is `3^{−p}`, not `2^{−p}`."
- This corollary is derived prose in the source rather than a separately evidenced claim; the statements and numbers are copied exactly.
