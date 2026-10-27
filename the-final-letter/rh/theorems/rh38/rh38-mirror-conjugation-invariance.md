# The sign convention is a conjugation and the half-turns a similarity: G<sub>ij</sub> = (−1)<sup>i−j</sup> E(log i − log j)

**Kind:** Claim
**Status:** PROVED (paper argument; cosine is even); VERIFIED (numerical, 1.1×10⁻¹⁵ between the two Grams, identity to 9.1×10⁻¹²)
**Area:** rh-html
**Source:** [`rh38.html`](../../html/rh38.html) — §§4–5 "The mirror, and a correction" / "What the convention costs"

## Statement

> rh35_helix fixed the sign the other way, writing ϑ(n, t) = (n − 1)π + t log n and reporting that every increment is then positive. That is true, and it is worth being exact about what it is. Since −(n − 1)π ≡ (n − 1)π mod 2π, flipping the torsion's sign negates the whole angle:
>
> ϑ<sub>mirror</sub>(n, t) ≡ −ϑ<sub>rh3</sub>(n, t) (mod 2π),
>
> measured to **5.7×10<sup>−14</sup>** turns over three torsions and three hundred levels. The arc has been drawing rh3's thread *reflected through the a–A diameter*. Its chain sums (−1)<sup>n−1</sup>n<sup>−σ+it</sup> = η(s̄) where rh3's sums η(s); the two partial sums are conjugate at every level, so their moduli agree to 2×10<sup>−14</sup> and the zero set is identical.

> Build the Gram matrix straight off the a-vertex phases, with no intermediary. The entry for gears i and j is the weighted mean of the cosine of their phase difference over the zeros, and that difference is (i − j)π ∓ γ(log i − log j) — the two conventions differing only in the sign of the second term. Cosine is even, so:
>
> G<sub>ij</sub> = (−1)<sup>i−j</sup> E(log i − log j),
>
> the same matrix either way. Measured on rh33's window at Δ = 0.12 over a sixteen-gear ladder, the two Grams differ by **1.1×10<sup>−15</sup>** — float noise, not structure — and the identity above holds to 9.1×10<sup>−12</sup>. The half-turns survive only as the diagonal similarity diag((−1)<sup>i</sup>), so they do not touch the spectrum either: λ<sub>min</sub> with them and without them agree to 5.8×10<sup>−13</sup>, and at four, eight, twelve and sixteen gears the two conventions give the same λ<sub>min</sub> to 2×10<sup>−16</sup>.

> So the torsion's sign is a complex conjugation and the half-turns are a similarity, and neither is visible to an eigenvalue. The whole convention question is a question about *drawing*.

## Hypotheses and notation

- The two conventions: rh3 §6's ϑ = (n − 1)π − t log n and rh35_helix's ϑ = (n − 1)π + t log n.
- The phase difference of gears i and j is (i − j)π ∓ γ(log i − log j); its cosine is even in that difference.
- η(s) = ∑(−1)<sup>n−1</sup>n<sup>−s</sup>; the chain sums of the two conventions are conjugate.

## Proof / evidence

Proof: cosine is even, so the ∓ in the phase difference does not change the Gram entries, giving G<sub>ij</sub> = (−1)<sup>i−j</sup>E(log i − log j). Numerical: the mirror relation holds to 5.7×10⁻¹⁴ turns over three torsions and three hundred levels; partial-sum moduli agree to 2×10⁻¹⁴; the two Grams differ by 1.1×10⁻¹⁵ on rh33's window at Δ = 0.12 over sixteen gears; the identity holds to 9.1×10⁻¹²; λ<sub>min</sub> agrees to 5.8×10⁻¹³ and to 2×10⁻¹⁶ at four, eight, twelve and sixteen gears; the two eigensolvers to 2.1×10⁻¹³.

## Dependencies and related results

- [rh34-the-lift-has-no-mod-2pi](../rh34/rh34-the-lift-has-no-mod-2pi.md) — the aligned-sign convention this section mirrors.
- [rh38-uniform-lift-definition](rh38-uniform-lift-definition.md) — rh3's lift, the thread being drawn reflected.
- [rh34-counterexample-needs-the-alias](../rh34/rh34-counterexample-needs-the-alias.md) — the fold and aliasing the source says are disqualified as carriers.

## Notes

- The source calls this a genuine correction: it proves the convention question could never have mattered numerically, and that "the arc has spent parts of four documents on a choice that cannot affect a single number it has computed."
- The correction to the *exclusion* claim (rh34 §2, rh35 §2, rh37 §2) is stated in §4: carry-proof monotonicity does not exclude rh3 §6's opposed sign; what has no floor is the bare increment read as a winding, and (8) is not a winding.
