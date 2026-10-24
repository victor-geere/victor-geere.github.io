# The functional equation is local — γ_v(s)·γ_v(1−s) = 1 and |γ_v(½ + it)| = 1 at every place

**Kind:** Theorem
**Status:** CITED (literature; the local functional equations of Tate/Weil, verified here at residuals ≤ 2.3×10⁻⁴¹)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §5.3 "Every local root number is unimodular, and their product does not converge"; §9 dictionary, term "the functional equation is local"

## Statement

> The mirror symmetry of the horn (README §5) is a local statement at every place. Writing γ_v(s) = Z_v(1−s)/Z_v(s) for the local root number,
>
> ```
> γ_v(s)·γ_v(1−s) = 1              exactly, at every place                   (17)
> |γ_v(½ + it)| = 1                exactly, at every place                   (18)
> ```
>
> verified at p = 2, 3, 5, 7, 1009 and v = ∞, at s = ½+iγ₁, 0.3+5i, 1.5+2i: residuals ≤ 2.3e−41 for (17); for (18), **exactly 0** at 17 of the 18 rows and 1.1e−41 at the eighteenth, i.e. at the working precision throughout. So:
>
> > **The functional equation is local.** Each place's figure has its own mirror, and the tilt breaks all of them at once — |γ_v| leaves the unit circle at every place simultaneously, at a rate that is that place's local log-derivative.
>
> The archimedean one has a name: `arg γ_∞(½+it) = −2θ(t)`, the Riemann–Siegel theta. Checked at t = 5, γ₁, 20, 50, 100 — the difference is an exact integer multiple of π in every row (−1, −1, 0, 8, 28; the row at t = 20 agrees to 1.3e−31 with no reduction needed). **The horn's archimedean winding is θ, and θ is the archimedean local root number's phase.**

## Hypotheses and notation

- Z_v(s) is the local zeta integral of (1): Z_∞ = π^{−s/2}Γ(s/2), Z_p = (1 − p^{−s})^{−1}.
- γ_v(s) = Z_v(1−s)/Z_v(s) is the local root number; the verification runs over v = ∞ and p = 2, 3, 5, 7, 1009, at s = ½+iγ₁, 0.3+5i, 1.5+2i.
- θ(t) is the Riemann–Siegel theta function; the checked θ-rows are t = 5, γ₁, 20, 50, 100.
- §8 lists "local functional equation (17), 5 places × 3 points | residual ≤ 2.3e−41" and "local unimodularity (18) on the line | exactly 0 in 17 of 18 rows, 1.1e−41 in the eighteenth".

## Proof / evidence

The identities are the local functional equations (Tate's thesis, cited in the source's §0 as "the local functional equations, the local root numbers and the identification of π^{−s/2}Γ(s/2) as the Euler factor at infinity are all Tate"), verified numerically to the working precision. The identification arg γ_∞(½+it) = −2θ(t) is checked by the exact-integer-multiple-of-π differences.

## Dependencies and related results

- [The local root numbers do not multiply](xihorn-horn-helix-adelic-local-root-numbers-do-not-multiply.md) is the companion negative statement: ∏_v γ_v(s) = 1 (the functional equation itself) is not obtained by multiplying the local ones.
- [Every local figure is zero-free](xihorn-horn-helix-adelic-every-local-figure-zero-free.md) for Z_v.
- §1.4's "Fourier self-duality" rows are the mechanism behind the local mirrors.

## Notes

- The source's §0 flags its attributions as "from memory beyond the two PDFs named — TODO **A1** applies to them exactly as it applies to the rest"; the Tate/Weil attributions carry that caveat.
- Only the local statements are proved/verified; the global product's non-convergence is a separate result.
