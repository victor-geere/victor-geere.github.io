# The translation identity holds on every fibre — with the same exponent

**Kind:** Theorem
**Status:** PROVED (paper argument; from the construction of Φ_χ, the source's worst relative residual 1.2×10⁻³⁸ is asserted by the source, which is prose only — no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §3.3 "The translation identity holds on every fibre — with the same exponent", equation (10)

## Statement

> This is the structural result of §3, and it is exact:
>
> ```
> φ_n^χ(u) = χ(n)·n^{−1/2}·φ₁^χ(u + log n)      for every primitive χ,
>                                               even or odd                 (10)
> ```
>
> Verified at n = 2, 3, 7, 11 (χ₅) and n = 3, 5, 7, 11 (χ₋₄), u = −1 and 0.7: worst relative residual **1.2e−38**.
>
> Read it against (5). Three things vary from fibre to fibre and one does not:
>
> * the **bump** φ₁^χ varies — the archimedean local factor changes with the parity, Γ(s/2) for even χ and Γ((s+1)/2) for odd, so the odd fibres' shells carry the extra factor n;
> * the **twist** χ(n) varies — it is the character evaluated on the depth lattice;
> * the **conductor** q varies, rescaling the throat;
> * the **taper is always n^{−1/2}.**

Dictionary entry, verbatim: "**the taper is fibre-independent** | φ_n^χ(u) = χ(n)·n^{−1/2}·φ₁^χ(u + log n) for every primitive χ, even or odd (worst residual 1.2e−38): the bump changes with the parity, the twist is χ, the conductor rescales the throat, and the exponent −½ never moves".

## Hypotheses and notation

- Φ_χ is the χ-horn: for primitive χ mod q, with δ = 0 if χ is even and δ = 1 if odd, Φ_χ(u) = e^{(2δ+1)u/2}·Σ_{n≥1} n^δ·χ(n)·e^{−πn²e^{2u}/q} (source (8)); Λ(½+it, χ) = 2∫Φ_χ(u)e^{itu}du (source (9)).
- The identity is stated "for every primitive χ, even or odd"; φ_n^χ denotes the n-th shell of the fibre.
- (5) is the predecessor's identity for the trivial fibre, φ_n(u) = n^{−1/2}·φ₁(u + log n) ([the translation identity](xihorn-horn-helix-revisited-translation-identity.md)).
- Two fibres are computed: χ₅ the even real character mod 5, and χ₋₄ the odd real character mod 4.

## Proof / evidence

The source states it as the structural result of §3 and verifies it numerically at n = 2, 3, 7, 11 (χ₅) and n = 3, 5, 7, 11 (χ₋₄), u = −1 and 0.7, worst relative residual 1.2e−38 (§8: "fibre translation identity (10), 8 rows | worst rel. 1.2e−38"). No separate proof lines are given; the statement is presented as following from the construction (8) as (5)–(7) did for the trivial fibre, and its consequence is drawn: "Which is §2.3 again: the exponent is the idele norm's half-power, so it cannot depend on the fibre."

## Dependencies and related results

- [The translation identity](xihorn-horn-helix-revisited-translation-identity.md) (revisited (6)–(7)) is the trivial-fibre case ("Read it against (5)").
- §2.3's reading of n^{−1/2} as |x|^{1/2}, the half-power of the idele norm, and §3.2's fibres.
- §3.4 gives the fibres' first closures: χ₅ (even, q = 5) at t = 6.64845334472771472; χ₋₄ (odd, q = 4) at t = 6.02094890469759665 (the second reproduces the standard first ordinate of L(s, χ₋₄)).
- §3.5: adelic completion's zero set is the union over the fibres, so "every fibre closes only untilted" is GRH, not RH.

## Notes

- "For every primitive χ" is the stated quantifier; the verification covers two fibres only, and the two computed fibres are the real ones (for complex χ the source notes the horn has a mirror *partner*, not a plane: Λ(s, χ) = ε(χ)·Λ(1−s, χ̄)).
- §3.5's cost statement is not a proof of GRH; it is the source's reading that the completion enlarges the hypothesis.

- **Correction (2025-10-06, session 003 residual-defect repair).** The `PROVED (paper argument)` half stands — the identity is a one-line consequence of the source's equation (8). The numerical clause did not: `1.2×10⁻³⁸` appears only in prose (`xi-horn/horn-helix-adelic.md:374` and the source's own §8 table), and no Python or Rust artefact computes the identity (a search for `fibre`/`adelic` across all committed code returns nothing; the eighteen Rust drivers are Jensen/Turán/omega programmes). The clause now says the residual is the source's assertion.
