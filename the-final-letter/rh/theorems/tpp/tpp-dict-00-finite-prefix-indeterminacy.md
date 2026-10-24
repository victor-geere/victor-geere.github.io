# finite-prefix indeterminacy: `λ'' = λ` on `[1,10⁸]`, `1` beyond, has `S''/x → 1`

**Kind:** Theorem
**Status:** PROVED (Lean slice layer; source records THEOREM (Lean slice layer) + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. F — the parity obstruction and the programme's barriers (rh46, rh47)", row F4, line 106

## Statement

The ledger row, verbatim:

> | F4 | **finite-prefix indeterminacy**: `λ'' = λ` on `[1,10⁸]`, `1` beyond, has `S''/x → 1` | THEOREM (Lean slice layer) + NUMERICAL | rh46 |

## Hypotheses and notation

- `λ''` is the modified function that agrees with the Liouville function `λ` on `[1, 10⁸]` and is `1` beyond.
- `S''` is the two-point correlation `Σ_{n≤x} λ''(n)λ''(n+2)` computed with the modified function ([F1](tpp-dict-00-correlation-trivial-bound.md) fixes `S(x) = Σ_{n≤x} λ(n)λ(n+2)`).
- The conclusion is `S''/x → 1`: the modified correlation does **not** decay, although the two functions agree on the tested prefix.

## Proof / evidence

The ledger records `THEOREM (Lean slice layer) + NUMERICAL` with source `rh46` and gives no proof. The capstone chapter records the same as [P16 — finite-prefix indeterminacy](tpp-dict-05-finite-prefix-indeterminacy.md).

## Dependencies and related results

- [F2 — `o(x)` fails for `λ ≡ 1`](tpp-dict-00-correlation-asymptotic-false.md).
- [A5 — the un-averaged two-point Chowla target](tpp-dict-00-un-averaged-two-point-chowla-open.md): this row is the recorded reason no finite computation (`10⁸` here) decides it.
- [F1 — `S(x,0) = x`](tpp-dict-00-correlation-trivial-bound.md) is the analogous trivial case for the constant-`1` pattern.

## Notes

- Ledger entry restating round **rh46**; the Lean leg is the *slice layer*, and that qualifier is preserved.
- The bound `10⁸` is quoted exactly as in the ledger.
