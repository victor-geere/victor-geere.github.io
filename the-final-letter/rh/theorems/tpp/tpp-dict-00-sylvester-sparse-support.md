# the support is Sylvester-sparse: `m_{i+1} ≥ m_i(m_i−1)+1`

**Kind:** Theorem
**Status:** PROVED (paper argument; source records THEOREM + NUMERICAL)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. B — the greedy harmonic sine", row B7, line 56

## Statement

The ledger row, verbatim:

> | B7 | the support is **Sylvester-sparse**: `m_{i+1} ≥ m_i(m_i−1)+1` | THEOREM + NUMERICAL | rh47 `truths.md` §1 |

The sister chapter states the same fact together with its consequence:

> The programme's central structural fact (rh47) is that `A(x)` is **Sylvester-sparse**:
> `m_{i+1} ≥ m_i(m_i−1)+1`, so supports with many elements have astronomically large
> largest index, and the support density is `≈ 3.9·10⁻⁵`.

## Hypotheses and notation

- `A(x)` is the **support** of the greedy harmonic sine: the set of taken indices (source [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §4).
- `m_i` denotes the `i`-th element of the support; the inequality is between consecutive support elements.
- The density figure `≈ 3.9·10⁻⁵` is quoted exactly as in [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md) §4 (and as `≈3.9·10⁻⁵` in the capstone chapter).

## Proof / evidence

The ledger records `THEOREM + NUMERICAL` with source `rh47 truths.md §1` and gives no proof. The capstone chapter's item P18 is [the greedy support is Sylvester-sparse](tpp-dict-05-sylvester-sparse-support.md) (PROVED (paper argument; plus numerical component)).

## Dependencies and related results

- [The word factors through the height `sin(2πθ)`](tpp-dict-00-word-factors-through-height.md) (B5): both are cited by the dictionary's three-line summary (item 1) for "everything the greedy produces is a function of the target alone".
- Used in the disposal of the bridges: [bridge B1](tpp-dict-00-bridge-b1-no-parity-signal.md) records that the density `≈ 3.9·10⁻⁵` makes the support useless as a positive-density witness.

## Notes

- Ledger entry restating round **rh47** (`truths.md` §1).
- The source labels the result `THEOREM + NUMERICAL`; the harvested status keeps both components, and the numerical leg is *not* claimed as a proof of the asymptotic.
