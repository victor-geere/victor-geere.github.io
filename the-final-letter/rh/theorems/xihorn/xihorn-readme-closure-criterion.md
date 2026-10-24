# The closure criterion — a zero of Ξ is where the two dual endpoints are purely imaginary

**Kind:** Corollary
**Status:** PROVED (paper argument; the accompanying table is a float64 illustration)
**Area:** xi-horn
**Source:** [`xi-horn/README.md`](../../xi-horn/README.md) — §4 "The two threads, and what a zero looks like"

## Statement

> **So the closure criterion is not "the chain returns to the origin."** It is:
>
> > A zero of Ξ is where the two dual endpoints are **purely imaginary** — equal and opposite, annihilating on addition.
>
> Write S₊(∞) = A + iB. Then Ξ = 4A, and:
>
> ```
>   t                      A               B            |S₊|
>   γ₁ = 14.134725     2.73e-19      0.036322412     0.0363224
>   γ₂ = 21.022040     3.27e-23      0.022253827     0.0222538
>   γ₃ = 25.010858     2.41e-22      0.018440780     0.0184408
>   γ₄ = 30.424876    -1.27e-24      0.014995615     0.0149956
>   γ₅ = 32.935062    -3.16e-25      0.013808206     0.0138082
>   t = 20            -9.164e-06     0.023510939     0.0235109
>   t = 23             1.405e-06     0.020179170     0.0201792
> ```
>
> At every zero A collapses to numerical noise while B stays O(10⁻²): the endpoints sit at ±0.0363i and cancel. Off a zero there is a residual real part. **This is the rh4 slogan made operational** — "the critical line is where a helix and its dual are congruent rather than merely similar" — with the congruence visible as conjugacy and the closure as annihilation.
>
> The figure should draw: two spiral threads, their endpoints, the segment joining them, and the midpoint of that segment on the real axis. The midpoint *is* Ξ(t)/4. A zero is the segment lying along the imaginary axis with its midpoint on 0.

## Hypotheses and notation

- S₊(∞) = A + iB is the +u thread's endpoint; S₋(∞) = conj(S₊(∞)) is the −u thread's endpoint (equation (5)).
- Ξ(t) = 2(S₊(∞) + S₋(∞)) = 4·Re S₊(∞) = 4A (equation (6)).
- The endpoints are ±iB when A = 0, i.e. purely imaginary, equal and opposite.
- γ₁ … γ₅ are the imaginary parts of the first five non-trivial zeros of ζ; the table is computed on u ∈ [0, 1.6] at float64.

## Proof / evidence

The corollary is immediate from (6): Ξ = 4A, so Ξ = 0 exactly when A = 0, at which point S₊(∞) = iB and S₋(∞) = −iB. The source illustrates this with the float64 table: at γ₁ … γ₅, A is at numerical noise (2.73e−19 … −3.16e−25) while B is O(10⁻²) (0.036322412 … 0.013808206), and at t = 20, 23 the residual real part is nonzero (−9.164e−06, 1.405e−06).

## Dependencies and related results

- The two threads and Ξ = 4·Re S₊(∞) (5)–(6): [xihorn-readme-two-threads-and-xi-real-part.md](xihorn-readme-two-threads-and-xi-real-part.md).
- The tilt that breaks the mirror symmetry: README §5 (not harvested separately; see Notes).
- rh4's slogan "the critical line is where a helix and its dual are congruent rather than merely similar".

## Notes

- The table is a float64 illustration at the known zeros; the source notes the closure criterion itself is exact while the near-zero values are numerical noise.
- The source's §5 tilt equivalence (|t_i| < ½ ⟺ 0 < σ < 1, t_i = 0 ⟺ σ = ½) and the near-γ₁ slope table are not harvested as separate results: the tilt is a parameterisation, and the near-γ₁ table is presented by the source as "a picture of the claim, not evidence for it".
