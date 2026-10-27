# The prime figure and the zero figure cannot be drawn in the same region of the plane

**Kind:** Proposition
**Status:** PROVED (paper argument; the Euler product converges only for σ > 1, the zero figure lives at σ = ½; the σ = ½ sampling is order-of-magnitude only)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix.md`](../../xi-horn/horn-helix.md) — §5 "Question 2, first half: the helix does **not** draw the primes"

## Statement

> The prime-side object is the Euler product, and it is a **different figure**: one gear per prime, each gear an infinite sub-helix of its own powers, `(1 − p^{−s})^{−1} = Σ_{k≥0} p^{−ks}`. It converges only for σ > 1 — and that is the obstruction, not a technicality:
>
> ```
>   partial Euler product ∏_{p≤P}(1 − p^{−s})^{−1} at s = ½ + iγ₁,
>   where ζ(s) = 6.3e−16:
>
>     P = 10        0.21470184
>     P = 10²       0.11519899
>     P = 10³       0.06113618
>     P = 10⁴       0.022828956
>     P = 10⁵       0.013084262
>
>   control at s = 1.5 + iγ₁ (inside the region of convergence):
>     ∏_{p≤10⁵} = 0.5443977716   vs   ζ = 0.5444038328   (6 digits)
> ```
>
> At σ = 1.5 the product converges to ζ and would show a zero if there were one. At σ = ½ it wanders down at about 0.30 decades per decade of *P*, irregularly; extrapolating that rate to 1e−16 wants **P ~ 10⁵³ primes**, which is the helix's 2.5×10³¹ gears again, worse. (Stated as an order of magnitude only: the sequence is oscillatory, and partial Euler products at σ = ½ are delicate — no limit is claimed here.)
>
> **So the prime figure and the zero figure cannot be drawn in the same region of the plane.**

## Hypotheses and notation

- The Euler product ∏_p (1 − p^{−s})^{−1} converges absolutely for σ > 1 and equals ζ(s) there.
- γ₁ is the first non-trivial zero ordinate; the source quotes ζ(½ + iγ₁) = 6.3e−16.
- "2.5×10³¹ gears" is the helix's truncation count quoted from §3's table (README §6's truncation row).

## Proof / evidence

The obstruction the source names is the region of convergence: the product converges only for σ > 1, while the zero figure is drawn at σ = ½, so the two figures have disjoint regions. The 0.30 decades/decade and the 10⁵³ extrapolation are explicitly marked by the source as a rate read off five oscillating points; §11.3 repeats that "10⁵³ primes is a rate read off five oscillating points ... should not be quoted for anything else." The control at σ = 1.5 (0.5443977716 against ζ = 0.5444038328, 6 digits) shows convergence inside the region of convergence.

## Dependencies and related results

- §6's Λ-reweighting (the prime helix, r_n = Λ(n)·n^{−σ}) → [closure and pole](xihorn-horn-helix-closure-and-pole.md) is the object that *does* draw the primes, one derivative away.
- Adelic restatement: [the strip is the gap](xihorn-horn-helix-adelic-strip-is-the-gap.md) ("It is the elementary observation that a product and its reflection have disjoint half-planes of convergence").

## Notes

- The qualitative conclusion (disjoint regions) rests on the convergence half-plane and is not hedged; the numerical rate and the 10⁵³ figure *are* hedged by the source and must not be read as a limit.
- §11.2 adds that the Λ-weighted helix "is not new mathematics either"; §11.3 is the caveat on the extrapolation.
