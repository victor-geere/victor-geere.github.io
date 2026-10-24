# L2 — the aliasing bound, with its constants shown

**Kind:** Lemma
**Status:** PROVED (paper argument; every constant evaluated as an interval; uses the cited Trefethen–Weideman strip bound)
**Area:** rh-html
**Source:** [`rh17.html`](../../html/rh17.html) — §2 "What stands between a float and a theorem", lemma L2

## Statement

> For a function analytic in the strip |Im r| &lt; ½ (the integrand's poles are those of ψ at ¼ + ir/2) the infinite trapezoid at step h errs by at most 2M₁/(e<sup>2πτ/h</sup> − 1), where M₁ bounds the line integrals of |f| along |Im r| = τ (Trefethen–Weideman). Take τ = 0.4, h = 0.05: the denominator is e<sup>16π</sup> − 1 ≈ 6.8×10²¹. … Folded together (the script evaluates every constant as an interval),

> (3)  |D(v)| ≤ 2K<sub>Δ</sub>e<sup>0.4v</sup>/(e<sup>16π</sup> − 1),   ρ<sub>D</sub> = Σ-row bound ≤ 4.2×10⁻¹⁸  (Δ = 0.015),

## Hypotheses and notation

- The integrand is analytic in the strip |Im r| &lt; ½; its poles are those of ψ at ¼ + ir/2.
- τ = 0.4 is the strip half-width used; h = 0.05 the trapezoid step; M₁ bounds the line integrals of |f| along |Im r| = τ.
- K<sub>Δ</sub> is the folded numerator constant; ρ<sub>D</sub> is the resulting Σ-row (row-sum) bound on the aliasing matrix; D is the aliasing error of the full trapezoid sum against the true integral.
- Δ = 0.015 is the finest mesh for which the displayed ρ<sub>D</sub> is quoted.

## Proof / evidence

The source gives the constant chain explicitly: |sinc(u+iw)|² ≤ cosh²(w) — from sin²u ≤ u², sinh²w ≤ w²cosh²w and the mediant inequality — gives ∫|B(x+ib)|²dx ≤ (16/3)Δcosh⁴(τΔ/2); two recurrence steps and the same Stirling corrections give |g(x+ib)| ≤ ln(3+|x|/2) + C<sub>ψ</sub> with C<sub>ψ</sub> ≤ 22.37 on the whole strip; and |cos((x+ib)v)| ≤ e<sup>τv</sup>. The script evaluates every constant as an interval. The stated outcome is ρ<sub>D</sub> ≤ 4.2×10⁻¹⁸, "five orders below λ<sub>min</sub>".

## Dependencies and related results

- Uses the cited exponentially convergent trapezoidal rule: L. N. Trefethen, J. A. C. Weideman, *The exponentially convergent trapezoidal rule*, SIAM Review 56 (2014).
- Uses the digamma asymptotics with error bounds (NIST DLMF §5.11).
- Bounds the term D appearing in [L1](rh17-l1-tail-never-bounded.md) and in [T2](rh17-t2-exact-sections.md).
- Reused and recomputed in rh19 §2, which states ρ<sub>D</sub> ≤ 4.4×10⁻¹⁷ at Δ = 0.24 for the longer horizon.

## Notes

- The source stresses that halving the step is what makes the certificate possible: at rh15's step h = 0.1 the same bound is 10¹¹ times weaker (e<sup>8π</sup> in the denominator) "and the theorem would fail".
- The source calls this "the one place the certified object differs from rh15's: same kernel, same cuts' side, finer lattice".
- The source's verification paragraph attributes the interval evaluation of every constant to `compute_rh17.py` ("54 named checks"). **That script is not in this repository** — a search of the whole tree finds no `*rh17*` artefact other than the documents and `rh17.html` itself; the source page and this document are therefore the only record of the constants (`ρ_D ≤ 4.2×10⁻¹⁸` included), and nothing here reproduces them. Disclosed, not repaired: the constants are *asserted by the source*, not *reproducible here* (audit repair 2/5).
