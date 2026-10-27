# No zero of R − 1 was found in the scanned region

**Kind:** Claim
**Status:** VERIFIED (numerical, 50 decimal digits; bounded scan — absence only)
**Area:** xi-horn
**Source:** [`xi-horn/CONTINUATION.md`](../../xi-horn/CONTINUATION.md) — §4 "Into the complex plane — no zeros, and the reason", second box

## Statement

> **No zero of R − 1 was found**, in the widest scan run: 425 points at 50 decimal digits over Re w ∈ [0, 40] × Im w ∈ [0, 150]. But that is not evidence of absence, and cannot be made into it. The smallest |R − 1| found was **1.9526e−2, at w = 40 + 150i — the far corner of the box**, and the same run at a coarser grid put its infimum at the corner too. At that point |w|·|R − 1| = 3.031, which is exactly the real-axis creep at |w| ≈ 155. So the minimum is not an anomaly; it is the ~3/|w| decay evaluated at the farthest point tried, and a bigger box moves it down again. **A bounded scan of a quantity decaying to zero cannot establish that it has no zero, at any precision.** See **B3**.

## Hypotheses and notation

- R(w) = C(w+2)²/(C(w)·C(w+4)) is the holomorphic margin (equation (24)); a zero of R − 1 is the boundary of the positivity domain.
- The scan region is Re w ∈ [0, 40] × Im w ∈ [0, 150]; the grid has 425 points; the working precision is 50 decimal digits.
- |w|·|R − 1| = 3.031 at w = 40 + 150i is compared with the real-axis creep at |w| ≈ 155.

## Proof / evidence

The source reports a bounded numerical scan: 425 points at 50 decimal digits over Re w ∈ [0, 40] × Im w ∈ [0, 150], with no zero of R − 1 located; the smallest |R − 1| = 1.9526e−2 occurs at w = 40 + 150i, the far corner of the box, and a coarser grid puts the infimum at the corner too. The source states the value of |w|·|R − 1| = 3.031 there and matches it to the real-axis creep at |w| ≈ 155. It explicitly refuses to convert the finding into evidence of absence.

## Dependencies and related results

- The holomorphic margin R (24): [xihorn-continuation-holomorphic-margin.md](xihorn-continuation-holomorphic-margin.md).
- The asymptotic law |w|·(R(w) − 1) → 4: [xihorn-continuation-asymptotic-law-limit-four.md](xihorn-continuation-asymptotic-law-limit-four.md).
- The same distinction for the zero count in the y-disc: [xihorn-continuation-non-integer-w-no-content.md](xihorn-continuation-non-integer-w-no-content.md).
- The QR-complex table's reliability caveat: nothing in the directory should quote an R or Γ_Φ value above |Im w| ≈ 200.

## Notes

- The source states plainly in §6: "'No zeros found' is a statement about Re w ∈ [0, 40], |Im w| ≤ 200 at float64 plus verified spot checks to |Im w| = 150 at 40 digits. **It is not a theorem**, and given §5 it should be treated with the suspicion it has already earned twice." Harvested here as a Claim with that disclaimer, not as a theorem.
- The source's §5 records two false starts (composite Gauss–Legendre in u, and geometric refinement toward u = 0) that produced convincing spurious zeros; the diagnostic it gives is that every candidate zero must survive a change of quadrature rule **and** a change of working precision.
- The numerical evidence is float64 plus verified spot checks; the source does not claim a certified enclosure.
