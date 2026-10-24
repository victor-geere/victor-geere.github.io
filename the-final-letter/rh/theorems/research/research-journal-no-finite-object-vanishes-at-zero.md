# No canonical finite object vanishes exactly at a zero

**Kind:** Proposition
**Status:** PROVED (paper argument, two-part argument; verified numerically at γ₁)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 6 Agent A answer, line 535; "The ten things that stand" §5, line 618

## Statement

> He then produced the cleanest negative of the dialogue: no canonical finite object vanishes exactly at a zero, because (i) any finite object with finitely many parameters has a finite zero set while {γ_k} is infinite, and (ii) the Riemann–Siegel formula Z(t) = 2Σ_{n≤N}n^{−1/2}cos(θ(t) − t log n) + R(t) with N = ⌊√(t/2π)⌋ has R = O(t^{−1/4}) — small, never zero. He reproduced my AFE numbers exactly and supplied the collapsed form at γ₁: X = Y = 1.4999 leaves only n = 1, so the truncation is **1 + χ(s)**, with |1 + χ(½+iγ₁)| = 0.3144378476. I verified that to eight digits.

## Hypotheses and notation

- {γ_k} is the infinite multiset of non-trivial zeta zero ordinates; a "finite object with finitely many parameters" is one whose vanishing set is finite (or at least not prescribed by the γ_k).
- Z(t) is the Riemann–Siegel function; θ(t) is the Riemann–Siegel theta function; N = ⌊√(t/2π)⌋; R(t) is the remainder term.
- χ(s) = 2^s π^{s−1} sin(πs/2)Γ(1−s).

## Proof / evidence

Part (i) is a counting/degree argument stated in one line. Part (ii) is the classical Riemann–Siegel remainder bound R = O(t^{−1/4}) — "small, never zero". The numerical instance at γ₁: the collapsed AFE truncation is literally **1 + χ(s)**, with |1 + χ(½+iγ₁)| = 0.3144378476, verified to eight digits by the mediator.

## Dependencies and related results

- [The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})](research-journal-afe-truncation-floor.md) — the quantitative version: the error sits at the same floor at every true zero.
- [A finite additive object cannot distinguish a zero from a dip](research-journal-partial-sum-local-minima.md) — the complementary statement for Dirichlet partial sums.
- [The two sides of the explicit formula are dual but exponentially non-equi-truncatable](research-journal-non-equi-truncatability.md) — the truncation asymmetry.

## Notes

- The journal calls this "the cleanest negative of the dialogue" and lists it among the established results: "the zero lives in the limit".
- The claimed vanishing of "any canonical finite object" is not a universal theorem over all finite objects; the source's two-part argument covers objects with finitely many parameters and the Riemann–Siegel truncation.
