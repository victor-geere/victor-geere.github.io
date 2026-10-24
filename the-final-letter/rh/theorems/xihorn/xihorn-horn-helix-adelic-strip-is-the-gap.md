# The strip is the gap — no s has both sides of the local functional equation absolutely convergent

**Kind:** Proposition
**Status:** PROVED (paper argument; elementary statement about half-planes of convergence of a product and its reflection)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §5.4 "The strip is exactly the gap between the two domains"; §9 dictionary, term "the strip is the gap"

## Statement

> The reason is structural and worth stating as the last of the negative results. The local factor Z_p(s) converges for σ > 0 individually; the product ∏_p Z_p converges for σ > 1; the reflected product ∏_p Z_p(1−s) converges for σ < 0. **There is no s at which both sides of the local functional equation converge absolutely.** The critical strip is precisely the gap.
>
> That is [horn-helix.md](../../xi-horn/horn-helix.md) §5's obstruction — "the prime figure and the zero figure cannot be drawn in the same region of the plane" — in its adelic form, and the adelic form is sharper: it is not a fact about ζ or about how one chooses to draw it. It is the elementary observation that a product and its reflection have disjoint half-planes of convergence, with the strip between them. Everything analytic in the subject happens where neither product exists.

## Hypotheses and notation

- Z_p(s) = (1 − p^{−s})^{−1} is the local factor; ∏_p Z_p(s) = ζ(s) converges absolutely for σ > 1.
- The reflected product ∏_p Z_p(1−s) converges for σ < 0.
- "The critical strip" is 0 < σ < 1, the gap between the two half-planes.

## Proof / evidence

The source states it as the last of the file's negative results and gives the reason in the same paragraph: a product and its reflection have disjoint half-planes of absolute convergence, with the strip between them. It is presented as an elementary observation; no numerical evidence is required or given, and §7.1 repeats that "Every identity used is Tate or Weil."

## Dependencies and related results

- horn-helix.md §5 → [the prime figure and the zero figure cannot be drawn in the same region](xihorn-horn-helix-prime-and-zero-figures-disjoint.md) is the same obstruction in the predecessor's vocabulary.
- [The local root numbers do not multiply](xihorn-horn-helix-adelic-local-root-numbers-do-not-multiply.md) is the numerical face of this gap.
- [Every local figure is zero-free](xihorn-horn-helix-adelic-every-local-figure-zero-free.md): each local factor exists individually for σ > 0, which is why the failure is a global-product phenomenon.

## Notes

- The claim is about *absolute* convergence of the two products; it does not assert anything about meromorphic continuation of ζ, which exists across the strip.
- The source calls this the sharper adelic form of the predecessor's obstruction — "a fact about products rather than about ζ".
