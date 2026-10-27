# counting: `N(T) = θ(T)/π + 1 + S(T) = (T/2π)log(T/2πe)+7/8+S(T)+O(1/T)`

**Kind:** Theorem
**Status:** PROVED (paper argument; source records THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. E — smoothing (`rh044/`) and the explicit formula (`rh45/`)", row E6, line 96

## Statement

The ledger row, verbatim:

> | E6 | counting: `N(T) = θ(T)/π + 1 + S(T) = (T/2π)log(T/2πe)+7/8+S(T)+O(1/T)` | THEOREM + NUMERICAL | rh45 §4 |

## Hypotheses and notation

- `N(T)` is the zero-counting function; `S(T) = (1/π)arg ζ(1/2+iT)`; `θ(T)/π` is the Riemann–von Mangoldt phase term as in [(P6)](tpp-dict-01-zero-counting-formula.md).
- The first equality is **exact**; the second is the asymptotic form with constant term `7/8` and error `O(1/T)`.

## Proof / evidence

The ledger records `THEOREM + NUMERICAL` with source `rh45 §4` and gives no proof. The preliminaries chapter states the identical formula as [(P6) Counting formula](tpp-dict-01-zero-counting-formula.md) (CITED (literature; verified in rh45 §4)); the zeta-relations chapter records [zero counting](tpp-dict-04-zero-counting.md) and the capstone chapter [P14 — the counting function, exact and asymptotic](tpp-dict-05-counting-function-exact-and-asymptotic.md).

## Dependencies and related results

- [(P6) Counting formula](tpp-dict-01-zero-counting-formula.md) — **the same statement**, harvested from the preliminaries chapter.
- [E7 — zeros located from `ζ` evaluations](tpp-dict-00-zeros-from-zeta-evaluations.md) is the numerical companion from the same round's audit.

## Notes

- Ledger entry restating round **rh45** (§4); it **duplicates** [(P6)](tpp-dict-01-zero-counting-formula.md) of [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md). Both files are kept because the two sources state it independently; the ledger version is labelled `THEOREM + NUMERICAL` and attributes it to `rh45 §4`.
