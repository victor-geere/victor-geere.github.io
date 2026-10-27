# Shell 1 is the place at infinity — the archimedean Euler factor, and the zeros are interference between dilates

**Kind:** Proposition
**Status:** PROVED (paper argument; equation (5) at n = 1 with Γ zero-free; magnitudes VERIFIED numerically)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix.md`](../../xi-horn/horn-helix.md) — §4 "The zeros are interference between shells", §9 "The horn is already an Euler factor — the one at infinity"; §13 dictionary, term "shell 1 is the place at infinity"

## Statement

> Set n = 1 in (5): **shell 1 of the horn transforms to the completion factor alone**, `½s(s−1)π^{−s/2}Γ(s/2)`, which is zero-free in the strip (Γ has no zeros anywhere; the s(s−1) supplies only s = 0 and s = 1). At the first zero:
>
> ```
>   shell 1 alone at ½ + iγ₁  =  0.00027408025 + 0.0017216230i    |·| = 0.0017433
>   all shells                =  1.09e−18
> ```
>
> Shell 1 is rh3's smeared cone, drawn: one archimedean profile, no arithmetic, no zeros. The horn escapes the trap because **it is not one cone — it is the integer-indexed family of cones, shell *n* being shell 1 dilated by *n*** (x → n²x, which is what (5) transforms into n^{−s}). The zero at γ₁ is 0.0017 of destructive interference between dilates.

And §9: "**shell 1 of the horn = the archimedean Euler factor**, zero-free (§4); **the horn = that factor × the integer lattice**, which is ξ; **the primes are the places the horn does not draw**".

## Hypotheses and notation

- (5) is `2∫φ_n(u)e^{(s−½)u}du = ½s(s−1)π^{−s/2}Γ(s/2)·n^{−s}`; at n = 1 the right side is the completion factor alone.
- π^{−s/2}Γ(s/2) is the Euler factor at the archimedean place ("the prime at infinity", Tate — cited in §9).
- γ₁ is the first non-trivial zero ordinate; ξ(½ + iγ₁) = 1.09e−18 as quoted in §2 and §12.
- rh3 §6's trap: "replace the sum over circles by the integral over the cone and the value becomes a product of Γ-factors and exponentials, which has no zeros."

## Proof / evidence

The zero-freeness is the source's one-line argument: Γ has no zeros anywhere and s(s−1) vanishes only at s = 0 and s = 1. The two magnitudes (shell 1 alone 0.0017433; all shells 1.09e−18) are taken from the source's computed table (§4, repeated in §12); the dilation reading x → n²x is the same statement as (5) transforming into n^{−s}. §11.1 records that this moves no wall.

## Dependencies and related results

- [Shell *n* is gear *n*](xihorn-horn-helix-shell-n-is-gear-n.md) (equation (5)) is the identity specialised here.
- rh3 §6 (the trap: the smeared cone has no zeros) and §8 (digit-independence) are the results answered.
- The dictionary's companion entry "closure and pole" → [closure and pole](xihorn-horn-helix-closure-and-pole.md).
- Restated on the adelic side in [horn-helix-adelic.md](../../xi-horn/horn-helix-adelic.md) §1.3 → [every local figure is zero-free](xihorn-horn-helix-adelic-every-local-figure-zero-free.md).

## Notes

- "Zero-free in the strip" is stated for the completion factor; the source also notes the completion "is not bookkeeping" but the Euler factor of ζ at the archimedean place.
- The claim that the zero is "0.0017 of destructive interference" is a reading of the two computed magnitudes (0.0017433 against 1.09e−18), not a separate proof.
- §11.1: "It moves no wall" — this is an identification of one Euler factor, not an approach to RH.
