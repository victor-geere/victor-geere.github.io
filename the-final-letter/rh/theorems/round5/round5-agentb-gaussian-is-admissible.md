# A Gaussian is admissible: ĝ(r) = R√(2π)e^{−R²r²/2} is entire with rapid decay in |Im r| ≤ 1/2

**Kind:** Proposition
**Status:** PROVED (paper argument; refutes the claim that a Gaussian is inadmissible)
**Area:** workspace
**Source:** [`round5_agentB.md`](../../research/various/round5_agentB.md) — §(1) "ADMISSIBILITY", lines 12–20

## Statement

> A Gaussian g(u)=e^{-u^2/(2R^2)} has ghat(r)=R sqrt(2pi) e^{-R^2r^2/2}, ENTIRE and of rapid
> decay in every horizontal strip |Im r| <= 1/2. It is ADMISSIBLE. [REFUTED] the claim that a
> Gaussian is inadmissible: the mediator's "Fhat(2in)" is the Fourier transform of e^{-x^2/2}
> evaluated at imaginary argument (= gaussian in u, where F is a Mellin-type object), not the
> Fourier pair of the explicit formula. The correct admissibility condition (Guinand/Weil):
> g even, g(u) and ghat(r) both O((1+|u|)^{-1-eps}) / O((1+|r|)^{-1-eps}) with integrability, or
> equivalently g in the Schwartz/rapid-decay class; the sums sum_rho ghat(gamma_rho) and
> sum_n Lambda(n)n^{-1/2}g(log n) must converge and be Abel-summable. Gaussian qualifies.

## Hypotheses and notation

- g(u) = e^{−u²/(2R²)} is the Gaussian test function with width parameter R > 0; ĝ(r) = R√(2π)e^{−R²r²/2} is its Fourier transform.
- "admissible" (Guinand/Weil) means: g even; g(u) and ĝ(r) both O((1+|u|)^{−1−ε}) / O((1+|r|)^{−1−ε}) with integrability, equivalently g of Schwartz/rapid-decay class; and both sums Σ_ρ ĝ(γ_ρ) and Σ_n Λ(n)n^{−1/2}g(log n) converge and are Abel-summable.
- ρ runs over the nontrivial zeros, γ_ρ = Im ρ; Λ is the von Mangoldt function.

## Proof / evidence

The source computes ĝ(r) = R√(2π)e^{−R²r²/2} and observes that it is entire and of rapid decay in
every horizontal strip |Im r| ≤ 1/2, hence that the Gaussian satisfies the stated criterion. It
identifies the mediator's "F̂(2in)" as the Fourier transform of e^{−x²/2} evaluated at imaginary
argument, not the Fourier pair of the explicit formula, and on that basis marks the inadmissibility
claim REFUTED.

## Dependencies and related results

- [round5-agentb-globality-not-admissibility](round5-agentb-globality-not-admissibility.md) — the companion statement that the real obstruction is globality, not admissibility.

## Notes

- The status is PROVED for the admissibility of the Gaussian; the parenthetical "[REFUTED]" is the
  source's verdict on the competing claim that a Gaussian is inadmissible, recorded in the statement.
- The admissibility criterion itself is attributed by the source to Guinand/Weil (literature), and no
  reference is given in this document beyond the names.
