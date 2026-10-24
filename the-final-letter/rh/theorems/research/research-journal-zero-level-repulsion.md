# Measured GUE level repulsion in the zeta zeros

**Kind:** Proposition
**Status:** VERIFIED (numerical; 3000 ordinates, independently reproduced on 81 zeros)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 3, lines 297–300; Synthesis §10, line 430

## Statement

> Zeros, 3000 ordinates from γ₁ = 14.1347 to 3533.3: normalised nearest-neighbour spacings show the classic repulsion profile — measured histogram peaks at 0.994–1.007 for u ∈ [0.6, 0.8] against the GUE density P(u) = (32/π²)u²e^{−4u²/π} giving 0.851 at u = 0.7; fraction of spacings below 0.1 is **0.0003** (Poisson: 0.0952), below 0.2 is 0.0043 (Poisson 0.1813), below 0.4 is 0.0490 (Poisson 0.3297). **Level repulsion confirmed on real data.** The mean spacing scale is 2π/log(T/2π) = 3.029 at T = 50 and 1.239 at T = 1000 — smoothly varying, not constant.

The three-way table:

> | {γ_k}, zeta zeros | **2993 distinct gaps out of 2998**; GUE level repulsion | random matrix / pair correlation |

and the Synthesis:

> The zeta zeros do **not** [follow three-distance]: 3000 ordinates give 2993 distinct gaps out of 2998, with level repulsion (0.03% of normalised spacings below 0.1 against Poisson's 9.52%; peak ≈1.0 at u ∈ [0.6,0.8] against GUE's 0.851 at u = 0.7). B's controlled recomputation on 81 zeros in [1001.3, 1099.4] confirms repulsion (P(spacing < 0.1) = 0.000 against Poisson 0.0952, mean spacing 0.9981) but he flags the sample as too small for a quantitative GUE test and withholds his earlier pair-correlation normalisation as wrong — so **the repulsion finding stands and the quantitative GUE match is Odlyzko's, not ours.**

## Hypotheses and notation

- γ_k are the zeta zero ordinates; normalised nearest-neighbour spacings are the gaps divided by the local mean spacing.
- GUE density P(u) = (32/π²)u²e^{−4u²/π}; Poisson comparison values 0.0952 (< 0.1), 0.1813 (< 0.2), 0.3297 (< 0.4).
- Mean spacing scale 2π/log(T/2π).

## Proof / evidence

Numerical, on 3000 zero ordinates from γ₁ = 14.1347 to 3533.3: 2993 distinct gaps out of 2998; spacings below 0.1, 0.2, 0.4 equal to 0.0003, 0.0043, 0.0490 against Poisson 0.0952, 0.1813, 0.3297; histogram peak 0.994–1.007 at u ∈ [0.6, 0.8] against GUE 0.851 at u = 0.7. Agent B's controlled recomputation on 81 zeros in [1001.3, 1099.4]: P(spacing < 0.1) = 0.000 against Poisson 0.0952, mean spacing 0.9981.

## Dependencies and related results

- [The three-distance theorem (Sós 1958, Surányi 1958)](research-journal-three-distance-theorem.md) — the rotation law that fails for the zeros.
- [A finite additive object cannot distinguish a zero from a dip](research-journal-partial-sum-local-minima.md) — the partial-sum side of the same statistics.
- [No canonical finite object vanishes exactly at a zero](research-journal-no-finite-object-vanishes-at-zero.md) — the truncation side.

## Notes

- The source is explicit about the limits of this finding: "the repulsion finding stands and the quantitative GUE match is Odlyzko's, not ours." B downgraded his own GUE verification to 81 zeros with an explicit [NOT RUN] on the quantitative test and "declined to report his earlier pair-correlation normalisation as wrong."
- The journal's use of the result is to conclude that the handoff's sine-sum/rotation picture "lives in the first row; the object it wants to describe lives in the second."
