# The deletion test: the eigenvalue is the instrument, the dip is arithmetic

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh15.html`](../../html/rh15.html) — §3 "The first tail: the instrument's own null" and §4 "The second tail: arithmetic, and unsettled"

## Statement

> **What it does not know:** delete every ordinate below the first null and λ<sub>min</sub> moves by 5.74%, 0.63%, 3.17%. The bottom of the spectrum has essentially never met the low zeros.

and, on the same surgery applied to the optimal-window dip:

> Run the deletion experiment on it. Removing every ordinate below the first null cost λ<sub>min</sub> at most 5.7%; it costs D* **95.1%, 12.2% and 17.5%** at the same three settings — 17×, 19× and 6× more sensitive. One experiment, two verdicts: the eigenvalue is blind to the low zeros and the dip is largely made of them. The two tails are genuinely different objects, and D* is the arithmetic one.

## Hypotheses and notation

- The deletion is: remove every ordinate (zero ordinate) below the first mesh null π/Δ = 2π/(2Δ), then re-read the two margins.
- λ<sub>min</sub> is the bottom eigenvalue of the slice; D*(a, Δ) is rh12's optimal-window dip, computed in §4 as D* = 1/(b₀<sup>T</sup>M<sup>−1</sup>b₀) — a single Levinson pass on the merged kernel.
- The three settings are the three (support, mesh) pairs shared between λ<sub>min</sub> and D* readings.

## Proof / evidence

The source reports both sides of the same surgery: λ<sub>min</sub> moves by at most 5.7% (measured 5.74%, 0.63%, 3.17% in §3), while D* loses 95.1%, 12.2% and 17.5% — ratios 16.6, 19.4, 5.5 in the closing audit (the main text rounds them to "17×, 19× and 6×"). It reads the pair of verdicts as the discriminator between an observable made of arithmetic and one made of the sampling grid.

## Dependencies and related results

- [The notch law: λ_min ≈ (Δ/16π⁴)·(ζ(4)ln(1/Δ) − ζ′(4))/π · λ_min(R_n)](rh15-notch-law-clamped-rod.md) — the law that explains why the eigenvalue is blind.
- [The optimal-window frontier D*(a) = 1/(b₀ᵀM⁻¹b₀)](../rh12/rh12-optimal-window-frontier.md) — the dip measured here.
- [The notch law cannot tell which process it is looking at](../rh16/rh16-notch-law-process-blind.md) — rh16's external confirmation of the same verdict.

## Notes


- The same deletion costs D* its value but leaves λ<sub>min</sub> nearly unmoved; the source uses this as the discriminator, and rh16 §4 later confirms it from outside with surrogate processes.
- The source also records that D* is unconverged at every reachable mesh (halving the mesh divides it by 4.2 to 44.8, ratios not shrinking), so its values must be quoted with the mesh.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
