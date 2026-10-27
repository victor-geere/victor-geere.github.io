# The two sides of the explicit formula are dual but exponentially non-equi-truncatable

**Kind:** Proposition
**Status:** PROVED (paper argument; quantified numerically)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Synthesis §7, line 424; "What is worth keeping as live and open" §1, line 450; Round 5, line 470

## Statement

> And the asymmetry is now quantified, which is the useful replacement for the retracted claim: at a common scale X, the prime side needs ≈ e^X/X terms (29.7 at X=5; 2202 at X=10; 2.4e7 at X=20; 5.9e15 at X=40) while the zero side needs ≈ (X/2π)log(X/2π) (0.74 at X=10; 3.69 at X=20; 11.8 at X=40). **The two sides are dual but not equi-truncatable — exponentially so.** This also reconciles with the approximate-functional-equation measurement: the number of terms needed is of order t, not √t.

Restated:

> **The non-equi-truncatability asymmetry, quantified (which replaces the retracted admissibility claim).** At a common scale X: prime side needs ≈ e^X/X terms (29.7, 2202, 2.4e7, 5.9e15 at X = 5, 10, 20, 40); zero side needs ≈ (X/2π)log(X/2π) (0, 0.74, 3.69, 11.8). **The two sides of the explicit formula are dual but exponentially non-equi-truncatable.** This is a truism about trace formulas once stated (spectrum versus geometry, per B) but it is the correct diagnosis of every failed truncation in this journal, and stating it with numbers is more useful than the false theorem I first offered.

## Hypotheses and notation

- X is a common scale for both sides of the explicit formula (zero side: heights up to X; prime side: Λ(n) terms with log n up to X).
- Prime side term count ≈ e^X/X; zero side term count ≈ (X/2π)log(X/2π).
- The comparison is between the two truncation costs at the same X.

## Proof / evidence

The counts are stated and tabulated (prime side: 29.7, 2202, 2.4e7, 5.9e15 at X = 5, 10, 20, 40; zero side: 0, 0.74, 3.69, 11.8 at the same X). The source gives the analytic shapes ≈ e^X/X and ≈ (X/2π)log(X/2π) rather than a proof, and explicitly characterises the statement as "a truism about trace formulas once stated (spectrum versus geometry, per B)". It also reconciles the count with the AFE measurement: the number of terms needed is of order t, not √t.

## Dependencies and related results

- [The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — the measurement this reconciles with.
- [The frequency/amplitude dictionary of the explicit formula](research-journal-frequency-amplitude-dictionary.md) — the prime-indexed side being counted.
- [The decay-rate criterion: g must decay faster than e^{−x/2}](research-journal-decay-rate-admissibility.md) — the replacement for the retracted admissibility claim.

## Notes

- The source presents this as "the correct replacement result" for the retracted "admissibility theorem" about Gaussian test functions, and is candid that it is not a deep theorem: "This is a truism about trace formulas once stated … but it is the correct diagnosis of every failed truncation in this journal."
- The status PROVED (paper argument) reflects the elementary counting statement; the numerical tables are the quantification. The source does not claim a rate theorem beyond the displayed shapes.
