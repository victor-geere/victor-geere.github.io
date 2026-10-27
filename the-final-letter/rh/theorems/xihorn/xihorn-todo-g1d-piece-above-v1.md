# (G1d) — the piece above V₁

**Kind:** Lemma
**Status:** PROVED (paper argument; derivation in `rust/src/jet.rs` and `rust/src/bounds.rs`)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §G1 "Turn B1 into a theorem: bound γ(n) instead of measuring it", bound (d)

## Statement

> **(d) the piece above V₁**, which the item did not list and which needs
> a bound of its own. (G1a) at N = 0 majorises Φ, and ρ(u) = w·log u + 9u/2 −
> πe^{2u} has ρ′ ≤ −κ = −(2πe^{2U₁} − 9/2 − w/U₁) < 0 on u ≥ U₁, so
> `T_hi ≤ 4π²e^{ρ(U₁)}/κ`.

## Hypotheses and notation

- V₁ is the upper truncation limit; U₁ := e^{V₁}; the bound applies on u ≥ U₁.
- ρ(u) = w·log u + 9u/2 − πe^{2u}, with ρ′ ≤ −κ = −(2πe^{2U₁} − 9/2 − w/U₁) < 0 on u ≥ U₁.
- (G1a) at N = 0 majorises Φ; T_hi is the piece above V₁.
- At V₀ = −14, V₁ ≈ 1.4 the high piece is 6.65e−4542 at n = 0 and 1.34e−4492 at n = 36.

## Proof / evidence

The source gives the monotonicity argument (ρ′ ≤ −κ < 0 on the range, so the tail is bounded by 4π²e^{ρ(U₁)}/κ) and records that this bound "the item did not list and which needs a bound of its own", i.e. it was added while building G1.

## Dependencies and related results

- [(G1a) — the shell-truncation bound](xihorn-todo-g1a-shell-truncation-bound.md) — used at N = 0 here.
- [(G1b) — the trapezoid remainder bound](xihorn-todo-g1b-trapezoid-remainder-bound.md) and [(G1c) — the piece below V₀](xihorn-todo-g1c-piece-below-v0.md).
- [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — the certificate.

## Notes

- The source's point about it: the two tails are "not merely small, they are irrelevant" — (G1d) is 4492 decades below the binding term at n = 36.
