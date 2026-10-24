# The half-turned train converges on σ > 0

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`rh3/README.md`](../../rh3/README.md) — §9 "η, not ζ — and the gauge closures", lines 269–286

## Statement

> The half-turns *are* the analytic continuation device. Un-alternated, the train diverges for σ ≤ 1: at *s* = ½ + iγ₁ the partial sums grow like `√N/|1−s|` (7.0704 predicted vs 7.0705 measured at N = 10⁴, doubling each time N quadruples). With the half-turns on, pairing level 2k−1 against 2k leaves a residue of size O(|s|·k<sup>−σ−1</sup>), summable for every σ > 0.

## Hypotheses and notation

- The half-turns are the alternation α<sub>n</sub> = (n−1)π of §4 (α<sub>n</sub> ≡ 0 with `half = off`); the un-alternated train is the `half = off` case.
- s = σ + i·t with σ > 0; γ₁ = 14.134725141734693 is the first ordinate of a zero of ζ; N is the truncation index of the partial sums.
- "Grow like √N/|1−s|" is the source's stated asymptotic for the un-alternated partial sums at s = ½ + iγ₁.

## Proof / evidence

The source gives the pairing argument in one sentence: with the half-turns on, pairing level 2k−1 against 2k leaves a residue of size O(|s|·k<sup>−σ−1</sup>), and Σ k<sup>−σ−1</sup> converges for every σ > 0.

The un-alternated divergence is evidenced numerically: at *s* = ½ + iγ₁ the partial sums are 7.0704 predicted against 7.0705 measured at N = 10⁴, doubling each time N quadruples. The source's §11 table repeats the entry "un-alternated |P<sub>N</sub>|, N = 10⁴: 7.0705 ≈ √N/|1−s|".

## Dependencies and related results

- [rh3-readme-evaluation-is-projection](rh3-readme-evaluation-is-projection.md) — the collapse val(aaaa…) = η(s) whose convergence is at stake here.
- η(s) = (1 − 2<sup>1−s</sup>)·ζ(s) (eq. (17)) is stated in the same section.
- The prefactor's own zeros at s<sub>k</sub> = 1 + 2πik/log 2 are the **gauge closures** the same section quarantines: at k = 1, t = 9.064720…, "the chain closes exactly while |ζ| = 1.3511 and nothing arithmetic vanishes."
- [rh3-half-turns-analytic-continuation](rh3-half-turns-analytic-continuation.md) — the same statement as a theorem box in `rh3.html` §9; that harvest preserves the box's own wording.

## Notes

- This is the README's restatement of the material that `rh3.html` presents in a labelled theorem box ("What the half-turns are for"); the HTML harvest is [rh3-half-turns-analytic-continuation](rh3-half-turns-analytic-continuation.md). The README gives the pairing estimate explicitly and the measured divergence figures, which the HTML box's surrounding prose also carries.
- The source's standing disclaimer (§12): "Nothing in rh3 or in this file is a step toward the hypothesis."
