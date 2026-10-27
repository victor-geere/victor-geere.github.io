# Smearing is archimedean — there is no p-adic bump

**Kind:** Proposition
**Status:** PROVED (paper argument; elementary p-adic analysis: Bruhat–Schwartz functions are locally constant with compact support and log|·|_p lands on a lattice)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §5.1 "Smearing is archimedean"; §9 dictionary, term "smearing is archimedean"

## Statement

> The construction the last two files are built on — (7) of the predecessor, "replace every point-gear by one copy of the archimedean bump φ₁" — needs two things: a depth axis that is a line, and a local weight that is a function on it with a shape. Neither exists at a finite place:
>
> > **Statement.** The Bruhat–Schwartz space of ℚ_p consists of locally constant, compactly supported functions, and log|·|_p maps ℚ_p^× onto (log p)ℤ. Hence the pushforward of any local test function to the local depth axis is a **finitely supported measure on a lattice**. There is no p-adic bump, and no p-adic analogue of the smearing that produces Φ from the integers or Ψ from the primes.
>
> Three consequences, all of them things this directory has run into without naming:
>
> 1. **The prime horn Ψ is necessarily hybrid.** Its atoms `Λ(n)n^{−1/2}` are the finite places' local terms (13); its bump φ₁ is the archimedean weight. There is no symmetric version, because there is nothing at p to smear with. The promissory note quoted at the top of this file asked for "a construction in which every place contributes its own bump symmetrically" — §5.1 is the reason there is not one. What exists instead is the trace-formula programme, whose local terms (12) are *distributions*, not functions, at every place including ∞.
> 2. **The horn's decidability is a one-place property.** README §6's argument — Φ dies double-exponentially, so truncation at |u| = 1.5 costs 1e−19 and closure is decidable from the whole picture — is a statement about the Gaussian at ∞. §5.2 measures what replaces it.
> 3. **§2.3's honesty note is complete.** The exponent ½ is |x|^{1/2}; the bump is the archimedean weight; the twist is the character. The horn's three ingredients are one group-theoretic normalisation and two pieces of local data, and none of the three sees the zeros.

## Hypotheses and notation

- The predecessor's (7) is Φ(u) = Σ_{n≥1} n^{−1/2}·φ₁(u + log n) ([the translation identity](xihorn-horn-helix-revisited-translation-identity.md)); Ψ is the prime horn, Ψ(u) = Σ_{n≥2} Λ(n)·n^{−1/2}·φ₁(u + log n).
- The local depth axis at p is u = log|x|_p; "the pushforward of a local test function to the local depth axis" is the operation that would have to produce a smooth bump.
- The local terms (12) are Weil's principal values, "distributions, not functions, at every place including ∞".

## Proof / evidence

The source's argument is the two-line observation quoted in the Statement: Bruhat–Schwartz functions are locally constant with compact support, and log|·|_p maps ℚ_p^× onto (log p)ℤ, so the pushforward to the depth axis is finitely supported. No numerical evidence is given or needed; the source calls the mathematics classical and older than most of this directory's sources (Tate; Weil).

## Dependencies and related results

- [The local Weil term at a finite place](xihorn-horn-helix-adelic-local-weil-term-finite-place.md) (13) supplies the finite-place atoms of Ψ.
- [Place truncation does not converge](xihorn-horn-helix-adelic-place-truncation-does-not-converge.md) (§5.2) measures the cost that replaces the horn's cheap truncation.
- [The ring](xihorn-horn-helix-revisited-the-ring.md) shows Ψ is the smeared prime horn; this file is the reason no symmetric (all-places) smearing exists.

## Notes

- The source labels this block "**Statement.**" rather than Theorem/Lemma; Kind is recorded here as Proposition.
- §7.1 repeats the file-wide disclaimer: "It proves nothing and moves no wall. Every identity used is Tate or Weil."
