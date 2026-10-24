# the Weil explicit formula needs the archimedean term and poles `2φ(i/2)`

**Kind:** Theorem
**Status:** PROVED (paper argument; the first draft omitting them is REFUTED)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/dictionary/00-dictionary.md`](../../research/twin-prime-parity/dictionary/00-dictionary.md) — "Index. E — smoothing (`rh044/`) and the explicit formula (`rh45/`)", row E5, line 95

## Statement

The ledger row, verbatim:

> | E5 | the Weil explicit formula **needs the archimedean term** and poles `2φ(i/2)` | REFUTED (first draft) + THEOREM | rh45 `truths.md` §1 |

## Hypotheses and notation

- The **Weil explicit formula** is the explicit formula of [(P5)](tpp-dict-01-explicit-formula-rvm.md), whose archimedean term is `(1/2π)∫_ℝ φ(t)Ψ(t)dt` with `Ψ(t) = −log π + Re ψ(1/4 + it/2)`.
- The row adds the **poles** contribution `2φ(i/2)` to the list of terms the formula needs.
- `rh45 truths.md §1` is the source round.

## Proof / evidence

The ledger records the split status `REFUTED (first draft) + THEOREM` with source `rh45 truths.md §1` and gives no proof. The capstone chapter records the corrected formula as [P13 — the explicit formula with the archimedean term](tpp-dict-05-explicit-formula-archimedean-term.md) (PROVED (paper argument; plus numerical ≥ 20 digits on four kernels)); the zeta-relations chapter records [the Weil form with the archimedean term](tpp-dict-04-weil-form-archimedean-term.md).

## Dependencies and related results

- [(P5) The explicit formula (Riemann–von Mangoldt)](tpp-dict-01-explicit-formula-rvm.md) states the same warning ("the archimedean term is not optional").
- [E4](tpp-dict-00-exponential-accuracy-needs-functional-equation.md) — the functional equation of the same round pair.

## Notes

- **Read the status carefully:** the row asserts the *necessity* of the archimedean term and of the poles (status `THEOREM`), and records that the first draft which omitted them was `REFUTED`. Both halves are preserved here; the harvested primary term is PROVED, with the refutation noted.
- The source's own wording in `rh45 §3.6` (quoted in [`01-preliminaries.md`](../../research/twin-prime-parity/dictionary/01-preliminaries.md)) is: "**The archimedean term is not optional** — an earlier draft omitted it and was REFUTED".
