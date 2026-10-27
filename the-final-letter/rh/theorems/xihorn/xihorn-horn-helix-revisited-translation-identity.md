# The translation identity — φ_n(u) = n^{−1/2}·φ₁(u + log n) exactly

**Kind:** Theorem
**Status:** PROVED (paper argument; three lines of algebra on INTEGERS.md (14), verified numerically to 1e−41)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §2.3 "The translation identity", equations (6)–(7); §7 dictionary, term "the translation identity"

## Statement

> The centrepiece of this file. The horn's shells (INTEGERS.md §1) are not merely *indexed* by the gears — each one **is the first shell, translated to a gear position and weighted by the critical exponent**. For every n and every u:
>
> ```
> φ_n(u) = n^{−1/2} · φ₁(u + log n)          exactly                          (6)
> hence
> Φ(u)   = Σ_{n≥1} n^{−1/2} · φ₁(u + log n)                                   (7)
> ```
>
> Read (7) as a construction recipe: **take the σ = ½ helix's gear measure — atoms at the gear positions, weights n^{−1/2}, the critical taper — and replace every point-gear by one copy of the archimedean bump φ₁. The result is the horn.**

## Hypotheses and notation

- φ_n(u) = (2π²n⁴e^{9u/2} − 3πn²e^{5u/2})·e^{−πn²e^{2u}} is the n-th shell (source (4) of horn-helix.md, INTEGERS.md §1); Φ = Σ_{n≥1}φ_n.
- The identity is pointwise in u ∈ ℝ, for every n ≥ 1.
- The Fourier side of (7) is the completion identity ξ = C(s)·ζ(s), C(s) = ½s(s−1)π^{−s/2}Γ(s/2), legitimate termwise for σ > 1 and by continuation elsewhere; "pointwise in u, (7) converges absolutely everywhere, so the geometric statement needs no continuation at all."

## Proof / evidence

"The proof is three lines of algebra on (14) of INTEGERS.md (the n⁴ and n² prefactors are absorbed as e^{9·log n/2}·n^{−1/2} and e^{5·log n/2}·n^{−1/2}); verified numerically to 1e−41 at n = 2, 3, 5 and u = −1, 0, 0.7." §6's verified-numbers table gives "translation identity (6), n = 2,3,5, u = −1, 0, 0.7 | residual ≤ 1.3e−41". §2.4 records the mirror side: at u = −1.5 the first forty copies carry ±0.476276 of mass each way and cancel to Σ_{n≤40} n^{−1/2}·φ₁(−1.5 + log n) = 6.488395449e−24 = Φ(1.5) (13 digits).

## Dependencies and related results

- INTEGERS.md §1 (equation (14)) for the shells; INTEGERS.md §2's condition-number table is what §2.4 explains.
- The σ = ½ taper n^{−1/2}: named adelically as |x|^{1/2}, the half-power of the idele norm, in [horn-helix-adelic.md](../../xi-horn/horn-helix-adelic.md) §2.3.
- Generalised to every Dirichlet-character fibre in [horn-helix-adelic.md](../../xi-horn/horn-helix-adelic.md) (10) → [the translation identity on every fibre](xihorn-horn-helix-adelic-translation-identity-every-fibre.md).
- [The prime horn Ψ](xihorn-horn-helix-revisited-rh-iff-psi-bounded.md) (8) applies the same recipe to the primes.

## Notes

- §2.3's honesty note, quoted: "the exponent ½ in (6) is forced by the kernel's normalization — it is why ξ(½ + it), not ξ(σ + it), is the transform of an even weight. It marks the symmetry point of the construction; it is not evidence about where the zeros are."
- §5.3: "The translation identity is a regrouping. (6)–(7) are exact and elementary; their content is identification of this repo's two figures, not new structure in ζ."
