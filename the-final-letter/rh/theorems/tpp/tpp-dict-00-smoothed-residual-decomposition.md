# the residual obeys `S_N^φ−ζ = N^{1−s}J_φ + φ(0)ζ(s) + R_N`

**Kind:** Theorem
**Status:** PROVED (paper argument; source records THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. E — smoothing (`rh044/`) and the explicit formula (`rh45/`)", row E3, line 93

## Statement

The ledger row, verbatim:

> | E3 | the residual obeys `S_N^φ−ζ = N^{1−s}J_φ + φ(0)ζ(s) + R_N` | THEOREM + NUMERICAL | rh044 §2 |

## Hypotheses and notation

- `S_N^φ(s) = Σ_{n≤N} φ(n/N)n^{−s}` is the smoothed partial sum; `ζ = ζ(s)`.
- `N^{1−s}J_φ` is the boundary/truncation term with the smoothing's constant `J_φ`; `φ(0)ζ(s)` is the local term.
- `R_N` is the remainder.

## Proof / evidence

The ledger records `THEOREM + NUMERICAL` with source `rh044 §2` and gives no proof. The same round is the source of [E1 — smoothing does not remove `√N`](tpp-dict-00-smoothing-does-not-remove-sqrt-n.md) and [E4 — exponential accuracy requires the functional equation](tpp-dict-00-exponential-accuracy-needs-functional-equation.md); the zeta-relations chapter records the smoothing law as [the smoothing law](tpp-dict-04-smoothing-law.md).

## Dependencies and related results

- [E1](tpp-dict-00-smoothing-does-not-remove-sqrt-n.md), which reads the `√N` scale off this decomposition.
- [E2 — the sharp constant](tpp-dict-00-sharp-constant-refuted.md), the correction attached to the size of the leading term.

## Notes

- Ledger entry restating round **rh044** (§2).
- The ledger gives the identity without defining `J_φ` or the class of `φ`; those definitions are in `rh044` and are **not** invented here.
