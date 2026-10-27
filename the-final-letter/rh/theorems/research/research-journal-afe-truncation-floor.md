# The AFE truncation floor: canonical m = √(t/2π) terms, error O(t^{−1/4})

**Kind:** Theorem
**Status:** VERIFIED (numerical; reproduced by both agents and the mediator)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 6, lines 509–533; "The ten things that stand" §5, line 618; Round 9 closing, line 604; Round 10, line 665

## Statement

> So the AFE truncation is **canonical** (m = √(t/2π) terms) and its error is O(t^{−1/4}) with a numerical constant ≈ 0.7–0.9.
>
> **And at the true zeros the error sits at the same floor:**

| t | m = √(t/2π) | terms | \|AFE − ζ\| | m^{−1/2} | ratio |
|---|---|---|---|---|---|
| 100 | 3.989 | 6 | 0.453246 | 0.500662 | 0.905 |
| 300 | 6.910 | 12 | 0.277511 | 0.380421 | 0.729 |
| 1000 | 12.616 | 24 | 0.114310 | 0.281543 | 0.406 |
| 3000 | 21.851 | 42 | 0.134235 | 0.213927 | 0.627 |
| 10000 | 39.894 | 78 | 0.110858 | 0.158323 | 0.700 |
| 30000 | 69.099 | 138 | 0.085762 | 0.120300 | 0.713 |

| zero k | γ_k | \|AFE − ζ\| | \|ζ(½+iγ_k)\| |
|---|---|---|---|
| 1 | 14.1347251417 | 0.314438 | 6.2e−31 |
| 2 | 21.0220396388 | 0.437581 | 4.3e−31 |
| 5 | 32.9350615877 | 0.310274 | 2.0e−30 |
| 10 | 49.7738324777 | 0.341219 | 2.4e−30 |
| 50 | 143.111845808 | 0.238853 | 3.4e−29 |
| 100 | 236.524229666 | 0.262522 | 4.8e−29 |

> **The AFE error does not dip at a zero; it is the same size as its error anywhere else at that height.** Gaussian smoothing removes the sharp-cutoff oscillation but not the floor (0.226, 0.170, 0.165 at t = 100, 1000, 10000).

Final synthesis:

> **No finite truncation can see a zero, and this is now quantitative.** The canonical AFE truncation is m = √(t/2π) terms with error O(t^{−1/4}) ≈ 0.7·m^{−1/2} (measured 0.453, 0.278, 0.114, 0.134, 0.111, 0.0858 at t = 10²…3·10⁴), and **at the true zeros the error sits at the same floor** (0.314, 0.438, 0.310, 0.341, 0.239, 0.263 for k = 1, 2, 5, 10, 50, 100), against |ζ| ~ 10⁻³⁰. At γ₁ the collapsed truncation is literally 1 + χ(s), and |1 + χ| = 0.3144378476. Smoothing does not remove the floor. So "the zero lives in the limit" is a theorem-shaped fact, not a defect of the handoff's approach.

## Hypotheses and notation

- AFE = approximate functional equation ζ(s) = Σ_{n≤X} n^{−s} + χ(s)Σ_{n≤Y} n^{s−1}, XY = t/2π, with χ(s) = 2^s π^{s−1} sin(πs/2)Γ(1−s); canonical balance X = Y = √(t/2π) = m.
- γ_k are the zeta zero ordinates; the AFE is evaluated at s = ½ + iγ_k.
- The valid regime is X ≤ √(t/2π); the source retracts a run that passed the balance point.

## Proof / evidence

Numerical, at 60 dps; the mediator's script `verify/round6_finite_object_v2.py` fixed a normalisation error (the first attempt used π^{−s}, making |χ| ≈ 10⁸ instead of 1; the check |χ(½+it)| = 1 now holds to 8 digits at t = 0, 5, 14.13, 50). The collapsed form at γ₁ (X = Y = 1.4999 leaves only n = 1) gives the truncation **1 + χ(s)** with |1 + χ(½+iγ₁)| = 0.3144378476, verified to eight digits. B's later correction: |ζ(½+iγ₁)| is 2.5e−61 at the exact zero; the mediator's 6.2e−31 used mpmath's zero to ~25 digits and the truncated t = 14.1347251417 gives 2.75e−11 — "the exact-zero evaluation settles it and does not affect the conclusion."

## Dependencies and related results

- [A's certification theorem for the greedy residual](research-journal-certification-theorem.md) — what transfers instead, and why it does not transfer to ζ.
- [No canonical finite object vanishes exactly at a zero](research-journal-no-finite-object-vanishes-at-zero.md) — the companion non-existence statement.
- [The two sides of the explicit formula are dual but exponentially non-equi-truncatable](research-journal-non-equi-truncatability.md) — the number of terms needed is of order t, not √t.

## Notes

- The source retracts its own first AFE run: "My first AFE script ran the truncation X past the balance point √(t/2π), where the conjugate sum has Y < 1 and the formula collapses into a plain Dirichlet polynomial; I briefly concluded the error grows with N. **That was wrong and is retracted.**"
- The journal's conclusion is deliberately terse and honest: the AFE error floor at a zero equals the floor elsewhere at that height, so "the zero lives in the limit" — no finite truncation sees it.
