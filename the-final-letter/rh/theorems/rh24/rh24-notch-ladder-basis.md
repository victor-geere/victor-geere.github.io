# The notch ladder belongs to the basis — no window in the spline family can be notch-free

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh24.html`](../../html/rh24.html) — §4 "(c) The notch ladder", equation (3)

## Statement

> That coincidence is the explanation. For any window in the M-family,
>
> (3) |ĥ(γ)|² = |φ̂<sub>δ</sub>(γ)|² · A(γ)², A(γ) = Σ<sub>k</sub> a<sub>k</sub> cos(kγδ), φ̂<sub>δ</sub>(γ) = 4 sin²(γδ/2)/(γ²δ),
>
> and φ̂<sub>δ</sub> vanishes at γ = 2πq/δ = 2πqM/Δ *whatever the coefficients are*. The M = 8 family's basis notches sit at γ = 209.44q — a sub-ladder of the hat's own 2πq/Δ = 26.18q, M times sparser — and A contributes its own zeros on top, wherever the search happened to leave them. Refining the family pushes the basis ladder out by M and never removes it, which is why the M = 8 optimum and the hat are starved at the very same γ: it is a basis notch of one and an ordinary notch of the other. **The holes are put there by the basis, not by the search**, and no amount of searching inside the family can close them.
>
> It does not persist. On the scale-free statistic γ⁴|ĥ(γ)|²/C<sub>h</sub>(0) … the M = 8 optimum's worst zero over all 1517 is 2.25×10<sup>-12</sup>, against the triangle hat's 1.04×10<sup>-9</sup>. It is not merely no better; it is 462× worse. And the two are starved at *the same* γ = 628.326.

## Hypotheses and notation

- The M-family is h = Σ<sub>|k| ≤ M−1</sub> a<sub>k</sub>φ<sub>δ</sub>(· − kδ) with δ = Δ/M.
- φ̂<sub>δ</sub>(γ) = 4 sin²(γδ/2)/(γ²δ) is the triangle-hat transform on a cell; A(γ) = Σ<sub>k</sub> a<sub>k</sub> cos(kγδ).
- "Starved zero" (dictionary): a γ sitting near a notch of |ĥ|², so the certificate spends nothing there.
- The arc has 1517 zeros cached to height 2000; the statistic is γ⁴|ĥ(γ)|²/C<sub>h</sub>(0) ("the scale-free statistic … which has a finite nonzero limsup for every window").

## Proof / evidence

The identity (3) is exact for every window in the family. Since φ̂<sub>δ</sub> vanishes at γ = 2πq/δ independently of the coefficients, every such γ is a zero of ĥ for every member of the family; refinement moves the ladder out by M but cannot remove it. The numerical part is measured over the 1517 cached zeros, and the source notes that "the question costs no sieve, only rh21's zeros-side kernel" — its dictionary gloss for the notch ladder is "the zeros of |ĥ|², at 2πqM/Δ for every window in the M-family" / "the real zeros of a Paley–Wiener function".

## Dependencies and related results

- The same identity |ĥ|² = |φ̂<sub>δ</sub>|²A² used in [rh23's starved-zeros result](../rh23/rh23-starved-zeros-hat-specific.md).
- rh21's zeros-side kernel supplies the measurement.
- The way out is to change the generator, done in [rh25's hyperbolic hat (7)](../rh25/rh25-hyperbolic-hat-transform.md); rh24 itself exhibits an out-of-family window with no notches ([the sinh window (4)](rh24-sinh-window.md)).

## Notes

- This is a *negative structural* result about the family the arc had been searching; the source says it is worth more than the flatness would have been "because it says where to look next".
- All figures (2.25×10<sup>-12</sup>, 1.04×10<sup>-9</sup>, 462×, γ = 628.326, 209.44q, 26.18q) are quoted exactly.
