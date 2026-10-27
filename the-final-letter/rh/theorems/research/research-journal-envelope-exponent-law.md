# The envelope law: Σ_{n≤N} n^{−σ} sin(t log n) ≈ N^{1−σ}/|1−σ+it|

**Kind:** Proposition
**Status:** VERIFIED (numerical; σ = 0.25 and 0.5 to 2–4 significant figures, σ = 0.75 only to one — 0.23223 measured against 0.25 predicted, 7.1 % off)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 3, "Measured: the rotation picture fails… Correction 1 — my exponent", line 288

## Statement

> *Correction 1 — my exponent.* I had claimed the envelope of Σ_{n≤N} n^{−σ}sin(t log n) grows like N^{1/2−σ}. **Wrong, and wrong by exactly ½.** By partial summation, with A(x) = Σ_{n≤x} n^{−σ−it}, one gets Σ_{n≤N} n^{−σ}sin(t log n) = Im[N^{1−σ+it}/(1−σ+it)] + O(log N), so the envelope grows like **N^{1−σ}/|1−σ+it|**. Measured envelope exponents (monotone envelope, N = 100 … 10⁵): **0.74995, 0.4985, 0.23223** for σ = 0.25, 0.5, 0.75 — against predicted 1−σ = 0.75, 0.50, 0.25. Three significant figures, so the corrected law is confirmed. Consequence worth recording: on the critical line σ = ½ the envelope grows like **N^{1/4}** — which is precisely the exponent I originally and wrongly attributed to the *typical size* of the weighted partial sums.

## Hypotheses and notation

- σ real, t real fixed; the summand is n^{−σ} sin(t log n); "envelope" means the monotone envelope over the oscillation.
- The partial-summation identity is Σ_{n≤N} n^{−σ} sin(t log n) = Im[N^{1−σ+it}/(1−σ+it)] + O(log N), i.e. the mediator's leading term is written with σ replaced by 1−σ in A(x) = Σ_{n≤x} n^{−σ−it}; the source's own display is verbatim above.
- |1−σ+it| is the prefactor modulus.

## Proof / evidence

Numerical: envelope exponents measured over N = 100 … 10⁵ are 0.74995, 0.4985, 0.23223 for σ = 0.25, 0.5, 0.75, against the predicted 1−σ = 0.75, 0.50, 0.25, i.e. agreement to three significant figures. The source offers the partial-summation computation as the derivation.

## Dependencies and related results

- [The 1/√(¼+t²) growth law for both additive families](research-journal-growth-law-shared-prefactor.md) — the weighted family's typical size N^{1/2}/|½+it|, to be distinguished from this envelope.
- [The three-distance theorem (Sós 1958, Surányi 1958)](research-journal-three-distance-theorem.md) — the rigidity that prevents this sine sum from settling.

## Notes

- This result corrects the mediator's own Round 3 statement; the source records the correction explicitly ("my Round 3 exponent was wrong") and notes that the two errors (N^{1/4} as typical size, ½−σ as envelope exponent) "were of the same ½ and cancel into a consistent picture."
- The Round 0d height-family table for Σ_{n≤N} n^{−σ} sin(t log n) at t = 14.1347 (σ = 0.5, 0.75, 1.0, 1.5; N = 10³, 10⁴, 10⁵) is the earlier, cruder instance of the same family.

- **Correction (2025-10-06, session 003 residual-defect repair).** The qualifier "three significant figures" holds for `σ = 0.25` and `0.5` and fails for `σ = 0.75`: the measured `0.23223` against the predicted `0.25` is 7.1 % off — one significant figure. The measurement itself is a hard-coded reprint of an earlier run (`verify/round3_corrections.py:15` prints it with no computation), so nothing here re-derives it. The qualifier now states what holds.
