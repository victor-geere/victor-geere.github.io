# smoothing does not remove `√N`: `|S_N^φ−ζ|/√N → |M_φ(s)|`

**Kind:** Theorem
**Status:** PROVED (paper argument, asymptotic; source records THEOREM (asymptotic) + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. E — smoothing (`rh044/`) and the explicit formula (`rh45/`)", row E1, line 91

## Statement

The ledger row, verbatim:

> | E1 | **smoothing does not remove `√N`**: `\|S_N^φ−ζ\|/√N → \|M_φ(s)\|` | THEOREM (asymptotic) + NUMERICAL | [`../../../rh044/truths.md`](../../research/twin-prime-parity/rounds/rh044/truths.md) |

## Hypotheses and notation

- `S_N^φ(s) = Σ_{n≤N} φ(n/N)n^{−s}` is the smoothed partial sum (source [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §1).
- `ζ = ζ(s)`; `M_φ(s)` is the smoothing's Mellin-type factor (the source's symbol; its definition is in `rh044/truths.md`, to which the ledger points).
- The limit is in `N → ∞` at fixed `s`; the conclusion is that smoothing leaves the `√N` scale intact.

## Proof / evidence

The ledger records `THEOREM (asymptotic) + NUMERICAL` with source `rh044/truths.md` (`../rounds/rh044/truths.md` from the dictionary) and gives no proof. The zeta-relations chapter records the smoothing law as [the smoothing law](tpp-dict-04-smoothing-law.md); the capstone chapter records the same conclusion as [P11 — smoothing does not remove √N](tpp-dict-05-smoothing-cannot-remove-sqrt-n.md).

## Dependencies and related results

- [E2 — the sharp constant](tpp-dict-00-sharp-constant-refuted.md) and [E3 — the residual decomposition](tpp-dict-00-smoothed-residual-decomposition.md).
- [P3/P2 of the preliminaries](tpp-dict-01-partial-sum-asymptotic-sigma-0.md) supply the `√N` scale in the unsmoothed case.

## Notes

- Ledger entry restating round **rh044** (`truths.md`).
- The source labels the result `THEOREM (asymptotic) + NUMERICAL`; the qualifier "asymptotic" is preserved, and the numerical leg is not treated as a proof.
