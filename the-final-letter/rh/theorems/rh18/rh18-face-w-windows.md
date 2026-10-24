# (W) — windows

**Kind:** Proposition
**Status:** OPEN (equivalent to the Riemann Hypothesis by Weil's criterion, cited not reproven)
**Area:** rh-html
**Source:** [`rh18.html`](../../html/rh18.html) — §2 "The functional, and the identity", theorem box "The three faces"

## Statement

> For every real compactly supported continuous g with g′ of bounded variation, 𝒲(g ⋆ ǧ) ≥ 0.

## Hypotheses and notation

- The admissible class 𝒜 (fixed in §3): real g, compactly supported, continuous, with g′ of bounded variation.
- 𝒲 is the Weil functional in the arc's normalization, acting on a real even f of compact support:
  𝒲(f) = ∫ f(v)·2cosh(v/2) dv + (1/π)∫₀^∞ f̂(r) ψ̃(r) dr − Σ<sub>n</sub> Λ(n) n<sup>−1/2</sup> [f(log n) + f(−log n)].
- ǧ(v) = g(−v); g ⋆ ǧ is the autocorrelation window.
- The source notes the class is load-bearing: the archimedean term "diverges on merely-continuous g, so the test class itself needs repair", and C<sub>c</sub><sup>∞</sup> ⊂ 𝒜.

## Proof / evidence

Not proved here. The source states the equivalence with (L) and (Bo) in [T — P2, closed](rh18-t-p2-closed.md); the arrow (L) ⟹ (W) is the analytic care of §3, run with the explicit ε(Δ; g) of [T2 — the ε(Δ; g) bound](rh18-t2-epsilon-bound.md), and the arrow (W) ⟹ (Bo) is the identity at arbitrary nodes. Each face is equivalent to RH by the cited Weil criterion (rh15's P3).

## Dependencies and related results

- [(L) — lattice](rh18-face-l-lattice.md) and [(Bo) — Bochner](rh18-face-bo-bochner.md).
- [T1a — the Weil identity at arbitrary nodes](rh18-t1a-weil-identity.md), [T2 — the ε(Δ; g) bound](rh18-t2-epsilon-bound.md), [T — P2, closed](rh18-t-p2-closed.md).
- Cited: A. Weil (1952).

## Notes

- Harvested because the source labels it inside a theorem box as one of the three faces; it is an open statement and the Status says so.
- The source records that "the class 𝒜 — BV derivative, the weakest class where the transform ladder closes — is load-bearing, not decorative", correcting rh15's unspecified "relevant norm".
