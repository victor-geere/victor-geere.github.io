# On a finite group, multiplicative and additive Fourier theory coincide (the bridge, q = 31)

**Kind:** Theorem
**Status:** PROVED (paper argument; verified numerically to ~3e−15)
**Area:** workspace
**Source:** [`research-journal.md`](../../research-journal.md) — Round 4 framing, line 310; Round 4(a), line 349; Synthesis §2, line 414

## Statement

> **Mediator's framing, with the bridge made exact.** The user's question about multiplicative versus additive systems has an exact and classical answer on a *finite* group, and I verified it. For q = 31 with primitive root g = 3, the discrete logarithm ind_g : (Z/31)^* → Z/30 is a group **isomorphism**, so every multiplicative character is *literally* an additive character of Z/30 composed with ind_g: χ_j(v) = e^{2πij·ind_g(v)/30}. Verified: Σ_v χ_j(v) = 0 to 3e−15 for every nontrivial j, and = φ(31) = 30 for j = 0. The multiplicative and additive Fourier theories are the *same* theory, related by a change of coordinates. **Multiplicativity is not lost by taking logarithms; it is transported.**

Restated in Round 4(a):

> **The correct statement: a multiplicative character *is* an additive character of Z/n composed with the discrete logarithm. On a finite group, "multiplicative vs additive" is a change of coordinates.**

and in the Synthesis:

> For (Z/31)^*, ind_g : (Z/31)^* ≅ Z/30, and multiplicative characters are additive characters composed with it — verified orthonormal to 3.7e−15, with Σ_v χ_j(v) = 0 to 3e−15 for nontrivial j and φ(31) = 30 for the trivial one.

## Hypotheses and notation

- q = 31 prime, g = 3 a primitive root; ind_g : (Z/31)^* → Z/30 the discrete logarithm; φ(31) = 30.
- χ_j(v) = e^{2πij·ind_g(v)/30}, j = 0, …, 29.
- The orthogonality relations checked: Σ_v χ_j(v) = 0 for j ≠ 0 and = φ(31) for j = 0; the character matrix orthonormal to 3.7e−15.

## Proof / evidence

The isomorphism statement is the standard cyclic-group duality and is given as an exact argument (the discrete logarithm is a group isomorphism, so composition transports characters). Independent numerical verification: Σ_{v=1}^{30} e^{2πij·ind_g(v)/30} = 0 for j = 1, 2, 3, 4 with magnitudes 2.5e−15, 3.2e−15, 1.3e−15, 3.2e−15, and = 30 = φ(31) for j = 0.

## Dependencies and related results

- [The frequency/amplitude dictionary of the explicit formula](research-journal-frequency-amplitude-dictionary.md) — the infinite-case structure that replaces the missing finite character expansion.
- [Differentiation converts the frequency k log p into the amplitude log p](research-journal-derivative-mechanism.md) — the operation that survives in the infinite case.

## Notes

- The journal records a retraction attached to this result: "**I first claimed the DFT of the log table is a single spike — false, its spectrum is spread.**" The correct statement is the character-transport statement above.
- The infinite case is stated to differ in exactly one way: log : (Q_{>0}, ×) → (R, +) is a homomorphism but its image is *dense*, not discrete, so the dual is not a circle and there is no finite character expansion; the primes are not a cyclic group, so there is no inverse index map. "That density is the prime-phase equidistribution and the honest form of the obstruction."
