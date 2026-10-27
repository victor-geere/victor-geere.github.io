# E22 — a by-product worth more than the item: the trapezoid error law

**Kind:** Claim
**Status:** PROVED (paper argument — Poisson summation on G5's saddle; VERIFIED numerically, including the grid's failure point)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "And a by-product worth more than the item (E22)"

## Statement

> **And a by-product worth more than the item (E22).** The same saddle gives
> σ = 1/√(−P″), so Poisson summation puts the trapezoid's relative error at
> **exp(−2π²(σ/h)²)** — the node count across the peak *is* the diagnostic,
> squared in the exponent. `Mellin::standard` therefore has a formula for its own
> reach: σ/h = 1.90 at w = 9600 but **0.86 at 4×10⁴** and 0.24 at 4×10⁵, and it
> returns −19.7 at w = 6.4×10⁶ where the truth is 3.693. `watson::adapted_rule`
> replaces it above w ≈ 4×10⁴, which is what let the G5 check run to 10⁷ at all.

## Hypotheses and notation

- σ = 1/√(−P″) is the peak's half-width from G5's saddle; h the trapezoid step.
- The integrand is Gaussian to leading order; the rule's relative error is ≈ exp(−2π²(σ/h)²).
- `Mellin::standard` is the fixed-grid rule; `watson::adapted_rule` replaces it above w ≈ 4×10⁴.
- The rule returns −19.7 at w = 6.4×10⁶ where the truth is 3.693.

## Proof / evidence

Derivation by Poisson summation, with measured checks: σ/h = 1.90 at w = 9600 (predicted error 1e−31), 0.86 at 4×10⁴ (4.6e−7) and 0.24 at 4×10⁵ (0.31); the standard grid agrees with a halved one to ten digits at w = 9600 and to seven at 4×10⁴; and it fails at w = 6.4×10⁶.

## Dependencies and related results

- [G5 — done, and the answer is 4](xihorn-rust-results-g5-watson-constant-4.md) — the saddle this law comes from.
- [H1 — a(1000) matches O'S Table 1](xihorn-rust-results-h1-a1000-against-os-table-1.md) — the digits-per-halving ladder this law corrects (E10's "roughly triples" against the law's ×4).
- [E22 in TODO.md](xihorn-todo-e22-node-count-squared-in-exponent.md) — the same entry, with the two measured consequences worked out.

## Notes

- The source labels this a "by-product worth more than the item"; in TODO.md's register it is explicitly "**not an error but a sharpening**" of E10.
- Consequence for the tables: "**any table of Γ_Φ or R at large w computed on the fixed grid should be re-checked against it**."
