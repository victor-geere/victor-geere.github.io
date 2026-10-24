# (G1c) — the piece below V₀, by one interval evaluation of Φ

**Kind:** Lemma
**Status:** PROVED (paper argument; derivation in `rust/src/jet.rs` and `rust/src/bounds.rs`)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §G1 "Turn B1 into a theorem: bound γ(n) instead of measuring it", bound (c)

## Statement

> **(c) the piece below V₀.** Not a Taylor bound at all: since e^{av} > 0
> and Φ(e^v) ∈ Φ([0, e^{V₀}]) for *every* v ≤ V₀, one interval evaluation of Φ
> over that range gives the whole tail exactly, `Φ([0,e^{V₀}])·e^{aV₀}/a`.
> The recipe this item printed does not work as written — **E13**.

## Hypotheses and notation

- V₀ is the lower truncation limit; v ≤ V₀ ranges over the discarded piece.
- Φ(e^v) ∈ Φ([0, e^{V₀}]) — one interval evaluation of Φ over that range — is the whole enclosure; e^{av} > 0 is used for the sign.
- The resulting bound is Φ([0, e^{V₀}])·e^{aV₀}/a; no derivative of Φ appears anywhere in (G1c).
- At V₀ = −14 the low piece is 4.28e−11 at n = 0 and 3.31e−445 at n = 36.

## Proof / evidence

The source gives the argument directly (monotonicity of e^{av} and the range enclosure of Φ). It records that (G1c) is "exact" in the sense that it is one interval evaluation, and that it is nowhere the binding term.

## Dependencies and related results

- [(G1a) — the shell-truncation bound](xihorn-todo-g1a-shell-truncation-bound.md), [(G1b) — the trapezoid remainder bound](xihorn-todo-g1b-trapezoid-remainder-bound.md), [(G1d) — the piece above V₁](xihorn-todo-g1d-piece-above-v1.md).
- [A3 — Γ_Φ near w = 0](xihorn-rust-results-a3-gamma-phi-near-zero.md) — the closed form for the same tail in the *measuring* rule.

## Notes

- **E13** corrects the recipe this bound originally printed: "bounded by sup|Φ′| on (−∞, V₀]" is inconsistent with the order claimed one clause earlier — Φ(u) − Φ(0) = ∫₀^u Φ′ gives |Φ(u) − Φ(0)| ≤ u·sup|Φ′| = **O(e^v)**, one power short of the O(e^{2v}) the same sentence claims. The route actually taken needs neither Φ′ nor Φ″.
- The source notes the importance of the exactness here: "V₀ = −50 is the wrong limit for a certified rule … (G1b) bounds the remainder over the whole range at once, and (G1c) is exact. V₀ = −14 is enough, which is 3.6× fewer nodes."
