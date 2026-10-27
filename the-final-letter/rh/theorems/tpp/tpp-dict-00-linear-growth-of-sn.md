# `|S_N(t)|` grows linearly: `|S_N|/N → 1/√(1+t²)`

**Kind:** Theorem
**Status:** PROVED (paper argument; source records THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. D — the balance split at `Re(S) = 0` (rh43)", row D8, line 84

## Statement

The ledger row, verbatim:

> | D8 | `\|S_N(t)\|` grows **linearly**: `\|S_N\|/N → 1/√(1+t²)` | THEOREM + NUMERICAL | rh43 §4 |

## Hypotheses and notation

- `S_N(t) = Σ_{n≤N} n^{−it}` at `σ = 0`; the limit is in `N → ∞` at fixed real `t`.
- The source writes the absolute value escaped, as `\|S_N(t)\|`; the identity is `|S_N|/N → 1/√(1+t²)`.

## Proof / evidence

The ledger records `THEOREM + NUMERICAL` with source `rh43 §4` and gives no proof. The asymptotic matches the first correction term of [(P2) the partial-sum asymptotic at `σ = 0`](tpp-dict-01-partial-sum-asymptotic-sigma-0.md); the zeta-relations chapter records the same as [linear divergence](tpp-dict-04-linear-divergence.md).

## Dependencies and related results

- [(P2) `S_N(it) = N^{1−it}/(1−it) + ζ(it) + O(N^{−1/2})`](tpp-dict-01-partial-sum-asymptotic-sigma-0.md) gives the leading term `N^{1−it}/(1−it)`, whose modulus is `N/√(1+t²)`.
- [The `σ = 1/2` parts](tpp-dict-00-half-abscissa-parts-asymptotic.md) (D9) is the companion asymptotic at the other abscissa.

## Notes

- Ledger entry restating round **rh43** (§4).
- The source labels the result `THEOREM + NUMERICAL`; the numerical leg is not a proof of the limit and is not reported as one.
