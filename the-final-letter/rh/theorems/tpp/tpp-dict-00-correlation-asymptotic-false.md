# `o(x)` fails for `λ ≡ 1` — `o(x)` is not a formal consequence

**Kind:** Theorem
**Status:** PROVED (Lean, `corrAsymptotic_zero_false`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F2, line 104

## Statement

The ledger row, verbatim:

> | F2 | `o(x)` fails for `λ ≡ 1` — `o(x)` is not a formal consequence | THEOREM (Lean `corrAsymptotic_zero_false`) | rh46 |

## Hypotheses and notation

- `λ ≡ 1` is the constant function taking the value `1`, i.e. the *other* sign pattern consistent with the algebraic properties of `λ` used by a purely formal argument.
- "`o(x)`" is the target asymptotic of the two-point correlation ([F1](tpp-dict-00-correlation-trivial-bound.md), [A5](tpp-dict-00-un-averaged-two-point-chowla-open.md)).
- "Not a formal consequence" means: no argument using only those formal properties can derive `o(x)`; the Lean declaration named is `corrAsymptotic_zero_false`.

## Proof / evidence

The ledger records `THEOREM (Lean `corrAsymptotic_zero_false`)` with source `rh46` and gives no proof text. The capstone chapter records the same fact inside [P15 — the trivial two-point bounds](tpp-dict-05-trivial-two-point-bounds.md), whose summary reads "`|S(x)| ≤ x`, `S(x,0) = x`, and `o(x)` fails for `λ ≡ 1`".

## Dependencies and related results

- [F1 — the trivial bound and `S(x,0) = x`](tpp-dict-00-correlation-trivial-bound.md).
- [A5 — the un-averaged two-point Chowla statement](tpp-dict-00-un-averaged-two-point-chowla-open.md) is the target whose derivation this row shows cannot be purely formal.
- [F4 — finite-prefix indeterminacy](tpp-dict-00-finite-prefix-indeterminacy.md) is the companion obstruction.

## Notes

- Ledger entry restating round **rh46**; the Lean declaration name is preserved exactly.
- This is a *negative* result about derivability, not a refutation of the Chowla target itself.
