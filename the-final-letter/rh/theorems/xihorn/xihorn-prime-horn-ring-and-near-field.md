# (10) The ring, and the exact near field

**Kind:** Theorem
**Status:** CITED (literature; contour shift past the zeros to the double pole at s = −2, constants are residues)
**Area:** xi-horn
**Source:** [`xi-horn/prime-horn.html`](../../xi-horn/prime-horn.html) — §1 "The construction", theorem box "the silence, and the ring", item (10)

## Statement

> **(10)** Ψ(−v) = −Σ<sub>k</sub> Re[C(ρ<sub>k</sub>)e<sup>iγ<sub>k</sub>v</sup>] + (3πv + b)e<sup>−5v/2</sup> + O(e<sup>−9v/2</sup>), shifting the contour left past the zeros to the double pole at s = −2.

The constants of the near-field term are given immediately below (10) in the source:

> a = 3π = 9.4247779608, b = 3π·ζ″(−2)/(2ζ′(−2)) − (3π/2)(γ<sub>E</sub> + 2/3 + log π) = −1.0781069034

## Hypotheses and notation

- Ψ(u) = Σ<sub>n≥2</sub> Λ(n)·n<sup>−1/2</sup>·φ<sub>1</sub>(u + log n): the prime helix's gear measure (atoms at log n, weights Λ(n)·n<sup>−1/2</sup>) smeared with the horn's own bump. The expansion is for Ψ(−v) with v > 0.
- φ<sub>1</sub>(u) = (2π²e<sup>9u/2</sup> − 3πe<sup>5u/2</sup>)·e<sup>−πe<sup>2u</sup></sup>.
- C(s) = ½s(s−1)π<sup>−s/2</sup>Γ(s/2); ρ<sub>k</sub> runs over the non-trivial zeros and γ<sub>k</sub> are their ordinates (the page uses the first twenty, beginning 14.1347251417347, 21.0220396387716, 25.0108575801457).
- γ<sub>E</sub> is Euler's constant; the source gives ζ′(−2) = −ζ(3)/(4π²) = −0.0304484570584 and ζ″(−2) = −0.0657635161874.
- The double pole is at s = −2: Γ(s/2) has a pole there and ζ has its first trivial zero there.
- §3 identifies the O(e<sup>−9v/2</sup>) remainder as the next trivial zero, at s = −4, entering as e<sup>−9v/2</sup> against the envelope's e<sup>−5v/2</sup>.

## Proof / evidence

The source presents this as one of "two facts … both classical", with the mechanism rather than a written proof: the contour is shifted left past the zeros to the double pole at s = −2, and "both constants are residues, so both are closed forms". The page recomputes the identity live in float64 from a Λ-sieve and twenty ordinates; the footer reports verification against mpmath at 30 digits. The source reports the figure's residual divided by the exact envelope is 1.000000 at v = 9, "which is what makes the difference column of §3.3 a *predicted* quantity rather than a leftover", and that by v = 9 the sieve reproduces the ten-zero prediction to eight decimals.

## Dependencies and related results

- Item (9) of the same box: [the silence of the main term](xihorn-prime-horn-silence-of-the-main-term.md).
- [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) §3.3, whose table this page recomputes; [horn-helix.md](../../xi-horn/horn-helix.md) §4 (the number 0.0017433 of shell 1's transform at the first closure); [figure.html](../../xi-horn/figure.html), the companion figure built on the integers instead of the primes.

## Notes

- The source states the middle term more sharply here than in [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) §3.3, "which only claimed consistency with a shape O(v e<sup>−5v/2</sup>)"; here both constants are exact residues, "not a fit". It is the source's own sharpening, but the source still calls the fact classical.
- §4's warning applies: "RH ⇔ sup|Ψ| < ∞ is a statement about all v"; an off-line zero at height 10<sup>10</sup> would leave every pixel of the figure and every digit of every table on it untouched, and "the agreement is consistency, not confirmation" — the purple (sieve) and amber (ring) curves agreeing to 1.4×10<sup>−8</sup> at v = 9 "tests the arithmetic of this page, not the hypothesis".
- Figure 1's ceiling is Σ|C| = 1.76×10<sup>−3</sup>, and the abstract reports that the first closure carries 99.06 % of the ring.
