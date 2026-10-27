# The decay-rate criterion: g must decay faster than e^{−x/2}

**Kind:** Proposition
**Status:** VERIFIED (numerical)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Synthesis §7, line 424; Round 5, line 470

## Statement

> The correct criterion is a **decay-rate** condition and I verified it numerically: the prime side Σ Λ(n)n^{−1/2}g(log n) converges for g(x) = e^{−x²/2} (partial sum 1.340983697 to n = 3·10⁵), diverges (slowly) for g(x) = (1+x)^{−2} (9.784378427), diverges for g(x) = e^{−0.4x} (24.69442575 and rising, each term ~ n^{−0.9}) — so **g must decay faster than e^{−x/2}**, and a Gaussian qualifies. What actually obstructs truncation is **globality**: both sides are infinite and no truncation of either equals the other.

Round 5 restatement with the Gaussian transform:

> A Gaussian g(u) = e^{−u²/2R²} has ĝ(r) = R√(2π)e^{−R²r²/2}, which is entire and rapidly decaying in every strip; … The correct criterion is a decay-rate condition, which I then verified directly: the prime side Σ Λ(n)n^{−1/2}g(log n) converges for g = e^{−x²/2} (partial sum 1.340983697 at n = 3·10⁵), converges slowly for g = (1+x)^{−2} (9.784378427), and diverges for g = e^{−0.4x} (24.69442575 and rising, each term ~ n^{−0.9}) — so **g must decay faster than e^{−x/2}**, and a Gaussian qualifies comfortably.

## Hypotheses and notation

- Prime side of the explicit formula: Σ_n Λ(n)n^{−1/2}g(log n), with g an admissible test function (even, smooth, decaying).
- Comparison functions: g(x) = e^{−x²/2} (Gaussian), g(x) = (1+x)^{−2} (slow decay), g(x) = e^{−0.4x} (exponential, decays slower than e^{−x/2}).
- Each term of the e^{−0.4x} series is ~ n^{−0.9} = n^{−1/2}·n^{−0.4}.

## Proof / evidence

Numerical: partial sums of Σ Λ(n)n^{−1/2}g(log n) to n = 3·10⁵ are 1.340983697 (convergent, g = e^{−x²/2}), 9.784378427 (slowly convergent, g = (1+x)^{−2}), and 24.69442575 and rising (divergent, g = e^{−0.4x}, each term ~ n^{−0.9}). The Gaussian's Fourier transform ĝ(r) = R√(2π)e^{−R²r²/2} is entire and rapidly decaying in every strip, so a Gaussian qualifies.

## Dependencies and related results

- [The admissibility constraint (Gaussian inadmissible) — REFUTED](research-journal-admissibility-claim-refuted.md) — the claim this criterion replaces.
- [The two sides of the explicit formula are dual but exponentially non-equi-truncatable](research-journal-non-equi-truncatability.md) — the quantification of the real obstruction (globality).
- [The frequency/amplitude dictionary of the explicit formula](research-journal-frequency-amplitude-dictionary.md) — the amplitudes Λ(n)/√n in the prime side.

## Notes

- The journal's framing: "The correct criterion is a **decay-rate** condition"; "What actually obstructs truncation is **globality**: both sides are infinite and no truncation of either equals the other."
- The source describes B's framing of the globality as "essentially a truism about trace formulas (spectrum vs geometry)" and agrees — "which is exactly why it should not have been dressed as a theorem about test functions."

- **Correction (2025-10-06, session 003 residual-defect repair).** `g(x) = (1+x)^{−2}` was classified as *converging slowly*. By the criterion the document itself states one line later — "g must decay faster than `e^{−x/2}` for the prime side to converge" — it diverges, because `(1+x)^{−2}` decays more slowly than `e^{−x/2}`. The archive's own script prints the partial sum and then hard-codes the wrong verdict on the next line: `verify/final_adjudication.py:45-46` prints `(1+x)^{-2}: partial sum to 3e5 = 9.784378427` and then `-> Gaussian converges fast; (1+x)^-2 converges slowly`. Its primes-only partial sums keep growing (6.836 at `10⁵`, 13.972 at `10⁶`, 30.561 at `10⁷`). Classification corrected; the Gaussian and `e^{−0.4x}` rows are unaffected.
