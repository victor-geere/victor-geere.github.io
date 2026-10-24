# (G1b) — the composite-trapezoid remainder bound

**Kind:** Lemma
**Status:** PROVED (paper argument; derivation in `rust/src/jet.rs` and `rust/src/bounds.rs`)
**Area:** xi-horn
**Source:** [`xi-horn/TODO.md`](../../xi-horn/TODO.md) — §G1 "Turn B1 into a theorem: bound γ(n) instead of measuring it", bound (b)

## Statement

> **(b) the trapezoid error.** The composite-trapezoid remainder,
> |Q − T_h| ≤ (h²/12)·Σ_j h·max|f″| over each subinterval, with
> f″ = e^{av}(a²g + 2a·g′ + g″) enclosed by one interval **jet** per block.
> No Poisson summation, no analyticity — see **E12** for why that matters.

## Hypotheses and notation

- Q is the integral, T_h the composite trapezoid with step h; the sum is over subintervals, with max|f″| on each.
- f″ = e^{av}(a²g + 2a·g′ + g″), enclosed by one interval jet per block.
- No Poisson summation and no analyticity hypothesis is used.
- In the certified run: h = 2⁻¹⁴, 252,317 nodes, 63,079 interval jet blocks, 60 digits, four minutes.

## Proof / evidence

The source states the classical composite-trapezoid remainder and says how it is evaluated: each block's f″ is enclosed by one interval jet. It records that this bound is what binds: "(G1b) dominates at every single n, by between one and four hundred decades" — with the table

```text
    n     rel width     G1b quad      G1c low     G1d high
    0     1.3028e-9     6.30e-10     4.28e-11   6.65e-4542
   36     3.2834e-7      1.64e-7    3.31e-445   1.34e-4492
```

— and two implementation findings: f″'s near-cancellation at the saddle must be kept inside the interval arithmetic (bounding the three terms separately inflates (G1b) by ~40× at n = 36), and the block width has its own scale (L ≈ 350 near the peak, so blocks past ~10⁻³ cost more than the jet evaluations they save). The h² law was checked across the scan: 8× in h and 4× in ω moved (G1b) at n = 36 by 169×, against 64 × 2.6 predicted.

## Dependencies and related results

- [(G1a) — the shell-truncation bound](xihorn-todo-g1a-shell-truncation-bound.md), [(G1c) — the piece below V₀](xihorn-todo-g1c-piece-below-v0.md), [(G1d) — the piece above V₁](xihorn-todo-g1d-piece-above-v1.md).
- [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — the certificate.
- [H2 — P^{d,n} and what it is worth to a certificate](xihorn-h-track-h2-p-jensen-max-width.md) — the demand side this supply is compared against.

## Notes

- **E12** is the source's correction of this bound's original specification: a Poisson-summation route was proposed and abandoned because "**F has no such strip**" — the shell sum converges only where |Im z| < π/4, a region whose half-width shrinks like e^{−Re v}. "**G1 did not need it**".
- The source's own summary: "the *measured* rule converges spectrally (H1 …), and this bound sees only h². The certified enclosure is 3.3e−7 wide where the same quadrature is in fact correct to far more."
