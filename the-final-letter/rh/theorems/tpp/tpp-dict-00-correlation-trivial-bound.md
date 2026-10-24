# `S(x) = Σ_{n≤x}λ(n)λ(n+2)`; trivial bound `|S| ≤ x`; `S(x,0) = x`

**Kind:** Theorem
**Status:** PROVED (Lean)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F1, line 103

## Statement

The ledger row, verbatim:

> | F1 | `S(x) = Σ_{n≤x}λ(n)λ(n+2)`; trivial bound `\|S\| ≤ x`; `S(x,0) = x` | THEOREM (Lean) | rh46 `Chowla.lean` |

## Hypotheses and notation

- `S(x) = Σ_{n≤x} λ(n)λ(n+2)` is the two-point correlation at shift `2` (source [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §1).
- `λ` is the Liouville function; `|S| ≤ x` is the trivial bound.
- `S(x,0)` uses a two-argument notation, `S(x, h)` with shift `h`; at `h = 0` the row records `S(x,0) = x`. This row **does not define** the two-argument notation; the Lean file named is rh46 `Chowla.lean`.

## Proof / evidence

The ledger records `THEOREM (Lean)` and names `rh46 Chowla.lean`; it gives no proof. The capstone chapter records the same bounds as [P15 — the trivial two-point bounds](tpp-dict-05-trivial-two-point-bounds.md) (PROVED (Lean)).

## Dependencies and related results

- `λ(n)² = 1` from [Lemma 2.2 (the square)](tpp-dict-01-liouville-square-and-abs-bound.md) is what makes the `h = 0` case evaluate to `x` (the derivation is given in the capstone chapter's harvested file).
- [F2 — `o(x)` fails for `λ ≡ 1`](tpp-dict-00-correlation-asymptotic-false.md) and [F4 — finite-prefix indeterminacy](tpp-dict-00-finite-prefix-indeterminacy.md) are the companion rows of the same index group.

## Notes

- Ledger entry restating round **rh46** (`Chowla.lean`).
- The row bundles three facts (the definition of `S`, the trivial bound, and the `h = 0` evaluation); they are harvested together because the ledger states them as one row, and they are not separated here.
