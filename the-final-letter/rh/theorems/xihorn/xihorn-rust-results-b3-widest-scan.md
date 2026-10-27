# B3 — the widest scan yet, and it argues for downgrading §4

**Kind:** Claim
**Status:** VERIFIED (numerical, 50 digits; 425 points — a negative result: no zero, and no anomaly)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "B3 — the widest scan yet, and it argues for downgrading §4, not upgrading it"

## Statement

> **B3 — the widest scan yet, and it argues for downgrading §4, not upgrading
> it.** 425 points at 50 digits over Re w ∈ [0,40] × Im w ∈ [0,150], against
> §4's float64 scan valid only to |Im w| ≤ 50. No zero; smallest |R − 1| =
> **1.9526e−2 at w = 40 + 150i**, unmoved by halving the quadrature step (the §5
> diagnostic). But the infimum sat on the *boundary* in both runs (40 + 120i at
> the coarser grid, 40 + 150i here), and there |w|·|R − 1| = 3.031 — exactly
> C3's real-axis value at |w| ≈ 155. The box holds no zero and no anomaly; the
> minimum is just the ~3/|w| decay at the farthest point tried. A bounded scan
> of a quantity decaying to zero cannot establish absence at any precision.

## Hypotheses and notation

- R is the ratio (24) of CONTINUATION; the scan box is Re w ∈ [0,40] × Im w ∈ [0,150], 425 points at 50 digits.
- R "needs **no Γ at all**: the two gamma functions in C(w) = Γ_Φ(w)/Γ(w+1) cancel out of (24) into an explicit rational factor".
- The §5 diagnostic: a candidate zero or anomaly must survive a rule change and a precision change.
- Driver `bin/b3_scan [nx] [ny] [ymax]`.

## Proof / evidence

Numerical: 425 points at 50 digits, no zero; the smallest |R − 1| = 1.9526e−2 at w = 40 + 150i, unmoved by halving the quadrature step. The infimum sits on the boundary of the box in both runs, and there |w|·|R − 1| = 3.031, "exactly C3's real-axis value at |w| ≈ 155" — so the minimum is the decay, not an anomaly.

## Dependencies and related results

- [C3 — the asymptotic constant](xihorn-rust-results-c3-asymptotic-constant.md) — supplies the 3.031 comparison.
- [The noise floor above |Im w| ≈ 200](xihorn-rust-results-noise-floor-above-im-w-200.md) — why the box cannot be extended by precision alone.
- [G5 — done, and the answer is 4](xihorn-rust-results-g5-watson-constant-4.md) — the analytic resolution of the same decay.

## Notes

- The source's conclusion is a downgrade: "A bounded scan of a quantity decaying to zero cannot establish absence at any precision." The same statement appears in TODO.md's dead-end list (§D).
