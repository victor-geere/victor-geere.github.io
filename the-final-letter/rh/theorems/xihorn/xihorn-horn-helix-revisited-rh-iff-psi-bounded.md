# RH ⟺ Ψ is bounded on ℝ

**Kind:** Claim
**Status:** PROVED (paper argument; the source labels it the classical "smoothed ψ-error ⟺ RH" statement in this dress)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §3.4 "The criterion"

## Statement

> **Claim. RH ⟺ Ψ is bounded on ℝ.**
>
> *Forward (RH ⇒ bounded).* On the line, |C(½+iγ)| decays like the Γ-factor, e^{−πγ/4}·poly, so Σ_k |C(ρ_k)| < ∞ and (10) converges absolutely and uniformly: sup|Ψ| ≤ near-field max ≈ 0.35.
>
> *Converse (bounded ⇒ RH).* Let L(z) = ∫₀^∞ Ψ(−v)e^{−zv} dv. Splitting each atom's integral at its own position gives, for Re z > ½,
>
> ```
> L(z) = (−ζ′/ζ)(z+½) · C(z+½)/2  −  E(z),        E entire                   (11)
> ```
>
> (the correction E is Σ Λ(n)n^{−½−z}∫_{log n}^∞ φ₁e^{zw}dw, double-exponentially convergent for every z). The right side is meromorphic with a pole at z = ρ − ½ for every zero ρ (C(ρ) ≠ 0 since Γ has no zeros and ρ ≠ 0, 1). If Ψ is bounded, L is analytic on Re z > 0, so no zero has β > ½; by the functional-equation pairing ρ ↔ 1−ρ, none has β < ½ either. ∎

with the prime horn of the same file,

`Ψ(u) = Σ_{n≥2} Λ(n)·n^{−1/2} · φ₁(u + log n)`    (8)

and φ₁ the horn's n = 1 shell (INTEGERS.md (14) at n = 1).

## Hypotheses and notation

- φ₁ is the horn's own bump (the n = 1 shell); Ψ is the **prime horn**, the prime helix's gear measure (atoms at log n, weights Λ(n)·n^{−1/2}) smeared by φ₁.
- C(s) = ½s(s−1)π^{−s/2}Γ(s/2) is the completion factor; ρ runs over the non-trivial zeros of ζ and β = Re ρ.
- L(z) = ∫₀^∞ Ψ(−v)e^{−zv}dv; E is the entire correction defined in (11).
- The criterion is stated for all of ℝ (all v); almost-periodicity means no finite range decides it (§4.3).

## Proof / evidence

Both directions are given in the source, ending with ∎. The source's own hedging, quoted in full: "Label, honestly: this equivalence is the classical 'smoothed ψ-error ⟺ RH' statement — the machinery would work for many bumps. What φ₁ specifically buys: the main term cancels *automatically* by (9) rather than by subtraction; the amplitudes are summable, so boundedness (not boundedness-after-regularization) is the criterion; and every constant in the statement is already an object in this directory." §5.2 adds that the numerical agreement "is consistency, not evidence: an off-line zero at height 10⁶ would leave every row of that table untouched."

## Dependencies and related results

- [The silence of the main term](xihorn-horn-helix-revisited-silence-of-the-main-term.md) (equation (9)) kills the s = 1 residue in the contour shift behind (10).
- [The ring](xihorn-horn-helix-revisited-the-ring.md) (equation (10)) is the explicit form of Ψ whose boundedness is at issue.
- [A growth bound](xihorn-horn-helix-revisited-minimal-growth-bound.md) is the equivalent statement on the sieve side that §4.4 lists as out of reach.
- The Weil criterion and its certified floors (rh10 §1; rh19–rh27a; rh28/rh29) are the same wall in other coordinates (§4.1, §4.3).

## Notes

- The source calls the equivalence classical and presents it as a reformulation, not as new mathematics: "So the figure suite closes ... One criterion per figure, both equivalent to RH."
- The source also records what is *not* gained: "That is a genuine structural compression of the *statement* — and none of the *difficulty*: the quantifier over h became a quantifier over v. Moved, not removed." (§4.3).
- The forward direction assumes RH; the converse is proved under boundedness. No unconditional progress is claimed: §5.1 "It proves nothing and moves no wall."
