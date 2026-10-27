# `η(s) = (1−2^{1−s})ζ(s)`, `η(1) = ln 2`

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. A — the analytic objects", row A2, line 40

## Statement

The ledger row, verbatim:

> | A2 | `η(s) = (1−2^{1−s})ζ(s)`, `η(1) = ln 2` | THEOREM | rh42 §5.1 |

The sister chapter states the same object in its notation table:

> `η(s)` | the Dirichlet eta function, `Σ_{n≥1} (−1)^{n−1}n^{−s} = (1−2^{1−s})ζ(s)`

## Hypotheses and notation

- `η` is the Dirichlet eta function, `Σ_{n≥1} (−1)^{n−1}n^{−s}`, and `ζ` is the Riemann zeta function.
- The evaluation recorded is `η(1) = ln 2` (the alternating harmonic series).
- No range of `s` is stated in the ledger row.

## Proof / evidence

The ledger row is a one-line index entry: it gives the status `THEOREM` and the source round `rh42 §5.1`, and **no proof**. The sister chapter [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) states the identity as notation (§1) without proof. The source therefore states this without proof in the harvested material.

## Dependencies and related results

- `ζ` from [(P1) Euler product and analytic continuation of `ζ`](tpp-dict-01-euler-product-and-continuation.md).
- Used by ledger row C3 of the same file — [the budget relations](tpp-dict-00-budget-relations.md), which states `P−N = 1−η`.

## Notes

- Ledger entry restating round **rh42** (§5.1); nothing new is claimed by the dictionary itself.
- The row's status is quoted exactly: `THEOREM` (the ledger's own vocabulary; not Lean-qualified here).
