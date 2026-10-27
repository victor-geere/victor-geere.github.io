# (11) The certified floor of the searched notch-free window, 3.72×10<sup>8</sup> over the hat

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical, evidence absent) — direct certified interval route with the table's error charged panel by panel: the source's "62 named checks" are not in this repository)
**Area:** rh-html
**Source:** [`rh25.html`](../../html/rh25.html) — §5 "The certificates", equation (11)

## Statement

> Six, through rh23's direct-interval route with |Û<sub>c</sub>|⁴ in place of |φ̂<sub>δ</sub>|⁴ and §2's certified comb: the triangle hat and the searched notch-free window, at n = 18, 51 and 76. The floor is s − ‖residual‖ − ρ<sub>comb</sub> − ρ<sub>arch</sub> − ρ<sub>D</sub> with the Cholesky at 40 digits and the residual at 90, and ρ<sub>comb</sub> is (6) — the table's own error included.
>
> (11) at v = 18: triangle hat 1.2456×10<sup>-10</sup> · searched notch-free window 4.6287×10<sup>-2</sup> — 3.72×10<sup>8</sup>×.
>
> The deepest certified floor for a window with no notch anywhere is 3.6133×10<sup>-1</sup>. It is the first of its kind in the arc: rh19's, rh22's, rh23's and rh24's certified windows all have transforms that vanish somewhere on the real line, and this one provably does not.

## Hypotheses and notation

- Windows: the triangle hat and the searched notch-free window of [equation (8)](rh25-notch-free-family-searched.md), at n = 18, 51 and 76.
- Route: rh23's direct certified interval arch with |Û<sub>c</sub>|⁴ in place of |φ̂<sub>δ</sub>|⁴, and §2's certified comb; ρ<sub>comb</sub> is [equation (6)](rh25-binned-radius-table-error.md), the table's own error charged panel by panel.
- The floor is s − ‖residual‖ − ρ<sub>comb</sub> − ρ<sub>arch</sub> − ρ<sub>D</sub>; Cholesky at 40 digits, residual at 90.

## Proof / evidence

The certificate lane is rh23's with the smooth generator and the certified table; the source's regression statement:

> The hat's floors at n = 18 and n = 51 still reproduce rh19's to within 3%, now through a fifth independent route — rh19 computed Δ = 0.24 rows directly, rh22 recombined certified δ = 0.03 rows, rh23 used a direct interval arch with a 24-bin radius, rh24 the same arch with a 768-bin one, and this document a tabulated smooth comb with the table's error charged panel by panel. Five implementations, the same two numbers.

§6 adds: "every λ<sub>min</sub> is confirmed by inertia bisection and every positive-definiteness claim by an independent dense Cholesky; the Lanczos eigenpair certifies its own residual at 4.1×10<sup>-16</sup> over 1028 calls."

## Dependencies and related results

- [The hyperbolic hat (7)](rh25-hyperbolic-hat-transform.md); [the certified table](rh25-certified-table-cost.md); [the binned radius with table error (6)](rh25-binned-radius-table-error.md).
- [rh24's certificate equation (5)](../rh24/rh24-certified-floors-v18.md) gives the value compared against (rh24: 2.4855×10<sup>-1</sup> for the 64-coefficient optimum).
- The notch-free property itself is certified by the Lipschitz notch margin ([rh25-notch-free-family-searched.md](rh25-notch-free-family-searched.md)).

## Notes

- The source states the scope: "A notch-free window is not a proof of anything about the zeros; §3's statistic is a property of ĥ, not of ζ … Nothing here is conditional on RH — unlike rh21 and rh24, this document never uses the zeros-side kernel — but nothing here is a step towards it either."
- All figures (1.2456×10<sup>-10</sup>, 4.6287×10<sup>-2</sup>, 3.72×10<sup>8</sup>×, 3.6133×10<sup>-1</sup>) are quoted exactly.

- **Correction (2025-10-06, session 003 residual-defect repair).** As with rh24: the numerical clause rested on `rh25.html`'s "62 named checks in 500 seconds" (`rh25.html:6681`), and the tree contains no evaluator for `1.2456×10⁻¹⁰`, `4.6287×10⁻²`, `3.72×10⁸` or `3.6133×10⁻¹` — no Cholesky, inertia or Lanczos code at all. The qualifier `evidence absent` now says so.
