# Identity (2) — the composite kernel is an exact linear form in the coefficient autocorrelation

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) against an independent sieve at all seventy-six nodes to 4.91×10<sup>-10</sup> relative)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §4 "The family, and a ceiling over it", equation (2)

## Statement

> Write Δ = 0.24 as 8δ with δ = 0.03, and let the window be a piecewise-linear function on the δ-grid:
>
> (1) h = Σ<sub>|k| ≤ 7</sub> a<sub>k</sub> φ<sub>δ</sub>(· − kδ), a<sub>k</sub> = a<sub>−k</sub>, φ<sub>δ</sub> = the triangle hat of half-width δ.
>
> Then h is supported in [−Δ, Δ] automatically, C<sub>h</sub> = h⋆ȟ in [−2Δ, 2Δ], and — writing w<sub>d</sub> = Σ<sub>j−k=d</sub> a<sub>j</sub>a<sub>k</sub> for the autocorrelation of the coefficients —
>
> (2) E<sub>h</sub>(v) = Σ<sub>|d| ≤ 14</sub> w<sub>d</sub> · E<sub>δ</sub>(v − dδ).

## Hypotheses and notation

- Δ = 0.24 = 8δ with δ = 0.03; φ<sub>δ</sub> is the triangle hat of half-width δ.
- The window h is piecewise linear on the δ-grid with coefficients a<sub>k</sub>, |k| ≤ 7, symmetric: a<sub>k</sub> = a<sub>−k</sub> (eight free coefficients after symmetry).
- C<sub>h</sub> = h⋆ȟ is the Weil test function, supported in [−2Δ, 2Δ].
- w<sub>d</sub> = Σ<sub>j−k=d</sub> a<sub>j</sub>a<sub>k</sub> is the (discrete) autocorrelation of the coefficients.
- E<sub>h</sub>(v) is the composite kernel; E<sub>δ</sub> is the kernel at the δ = 0.03 mesh; A(r) = Σ<sub>k</sub>a<sub>k</sub>cos(krδ).

## Proof / evidence

> The new kernel is an exact linear form in w applied to the *old* kernel on the δ-lattice. It holds piece by piece — pole, archimedean integral and prime comb separately — because w is symmetric, so every sine term cancels and each piece factors through Σ<sub>d</sub>w<sub>d</sub>cos(rdδ) = A(r)².

Check against an independent computation, quoted verbatim:

> Identity (2) is the one thing that must not be taken on trust, so it is checked against an independent computation. rh19's stored stream sieved 7.24×10⁸ prime powers at Δ = 0.24; this document sieves 6,448,870 at δ = 0.03. The two share no arithmetic beyond the interval kit. Reconstructing the hat's Δ = 0.24 kernel from the δ rows and comparing at all seventy-six nodes gives a worst relative difference of 4.91×10<sup>-10</sup>. The reconstructed energy is C<sub>h</sub>(0) = 2Δ/3 = 0.16 exactly, which is the constraint the search holds fixed.

## Dependencies and related results

- rh18's identity T1a, "a Fubini argument valid for any h", is invoked in the source so that the whole (L)⟺(W)⟺(Bo) chain carries over with no re-derivation; it is cited there, not reproved in rh22.
- Certified interval rows for E<sub>δ</sub> at δ = 0.03 are built out to v = 18.48 — 617 rows — and identity (2) carries them to the composite window (§6).
- Used by [The ceiling (3)](rh22-ceiling-for-every-window.md) and by [m₀ certified — (4)](rh22-certified-floors-m0.md).

## Notes

- The triangle hat is *in* the family, at a<sub>k</sub> = 1 − |k|/8, "so the search can only improve on it"; δ = 0.03 is a mesh rh17 already certified, so E<sub>h</sub>'s rows are exact combinations of certified interval rows and rh19's backend α applies unchanged.
- The source's own comment on the family identity: "Three things follow, and all three are what make this document cheap."
