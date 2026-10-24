# Closure and pole — where the horn closes, the prime helix blows up

**Kind:** Proposition
**Status:** PROVED (paper argument; simple zero of ζ ⟹ residue −1 of −ζ′/ζ, verified numerically to ε = 1e−5)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix.md`](../../xi-horn/horn-helix.md) — §7 "Where the horn closes, the prime helix blows up"; §13 dictionary, term "closure and pole"

## Statement

> The prime helix does represent the zeros — but as **poles, not closures**. If ζ has a simple zero at ρ then near it `ζ(s) ≈ c(s−ρ)`, so `−ζ′/ζ ≈ −1/(s−ρ)`: residue −1, one pole per zero, multiplicity counted.
>
> ```
>   s = ½ + i(γ₁ + ε)      |−ζ′/ζ(s)|        1/ε
>   ε = 1e−2               100.08239         100
>   ε = 1e−3               1000.0822         1000
>   ε = 1e−4               10000.082         10⁴
>   ε = 1e−5               100000.08         10⁵
>
>   s = ½ + 20i (no zero nearby)   |−ζ′/ζ| = 1.0744507
> ```
>
> So the duality the question was reaching for is real and it is **inverse**:
>
> > At a zero, the horn's two threads annihilate — endpoints purely imaginary, Ξ = 4·Re S₊(∞) = 0 (README §4). At the same point, the prime helix diverges like 1/|s − ρ|.
>
> One closes, the other cannot be drawn at all. This is not a defect of either figure — it is what "the zeros are the poles of the logarithmic derivative" looks like geometrically. And it means the two objects can never be compared pointwise. They have to be compared **paired against a test function**, which is the explicit formula and nothing else.

## Hypotheses and notation

- The prime helix is rh3's figure re-weighted to r_n = Λ(n)·n^{−σ}, i.e. it draws −ζ′/ζ(s) = Σ_{n≥2} Λ(n)n^{−s} (source (6)).
- ρ is a non-trivial zero of ζ, written ρ = ½ + iγ for the measured rows; the residue statement is "multiplicity counted".
- Ξ = 4·Re S₊(∞) is the horn's closure condition (README §4).

## Proof / evidence

The source's one-line reason is quoted above (ζ(s) ≈ c(s−ρ) ⟹ −ζ′/ζ ≈ −1/(s−ρ)); the table verifies the 1/ε + O(1) behaviour from ε = 1e−2 to ε = 1e−5 (100000.08 = 1/ε + 0.08 at the last row), with the control s = ½ + 20i reading 1.0744507. §12 lists |−ζ′/ζ(½ + i(γ₁+ε))| at ε = 1e−5 = 100000.08 (= 1/ε + 0.08) and |−ζ′/ζ(½ + 20i)| = 1.0744507.

## Dependencies and related results

- §6's prime helix (r_n = Λ(n)·n^{−σ}) and the Dirichlet series −ζ′/ζ(s) = Σ Λ(n)n^{−s}.
- README §4's closure condition Ξ = 4·Re S₊(∞) = 0.
- The explicit formula is the only object that pairs the two: [Riemann–Weil explicit formula](xihorn-horn-helix-riemann-weil-explicit-formula.md).
- The measured amplitude ledger |C(½+iγ_k)| of the smeared prime horn is treated in [the ring and the near field](xihorn-prime-horn-ring-and-near-field.md) (from prime-horn.html).

## Notes

- The residue −1 statement is conditional on the zero being simple (the source writes "If ζ has a simple zero at ρ"); multiplicities are counted in general. Every zero known to date is simple, but the source does not assert that here.
- The measurements are conducted on the critical line (s = ½ + i(γ₁ + ε)); the pole statement itself is local and does not assume RH.
- §7's conclusion (no pointwise comparison; pairing only through the explicit formula) is the bridge to §8.
