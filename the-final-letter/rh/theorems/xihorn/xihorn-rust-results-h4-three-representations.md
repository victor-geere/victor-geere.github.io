# H4 — two more representations, agreeing to the arithmetic floor, and a factor of 8 in [GOR⁺] (3.1)

**Kind:** Claim
**Status:** VERIFIED (numerical, 60 digits requested / 77 resolvable)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "H4 — done. Two more representations, agreeing to the arithmetic floor, and a factor of 8 in [GOR⁺] (3.1)"

## Statement

> **H4 — done. Two more representations, agreeing to the arithmetic floor, and
> a factor of 8 in [GOR⁺] (3.1).** γ(n) computed three further ways — [O'S]
> (7.1)'s ∫₁^∞(log t)^{2n}ω(t)t^{−3/4}dt, [GOR⁺] (3.1)'s difference of two
> F-moments, and the horn's own integrand on a *uniform* grid in u — with
> composite Gauss–Legendre (`quad.rs`, the crate's first non-trapezoid rule).
> Against the horn at 60 digits requested: uniform-u **69–73** digits, (7.1)
> **66–69**, (3.1)/8 **61–69**, and the two new routes against each other
> **66–72**. At n = 1000 all three agree to **72.9** digits and reproduce [O'S]
> Table 1. **(3.1) as printed returns exactly 8γ(M)** —
> 8.00000000000000000000000000000 at every M from 1 to 12 — the [GORZ19]
> normalisation carried across without conversion (**E18**). And the one place
> the three routes split is n = 0, where **the horn is the one that is off**, by
> 2.31e−28: `Mellin::standard`'s Euler–Maclaurin boundary term at V₀ = −50,
> predicted against measured to 1.00000 over **thirty-three decades** of V₀.

## Hypotheses and notation

- ω(t) = Σ_{k≥1}(2π²k⁴t² − 3πk²t)e^{−πk²t} ([O'S] (6.1)); F(z) = ∫₁^∞ (log t)^z·t^{−3/4}·Σ_{k≥1}e^{−πk²t} dt; (7.1) and (3.1) as displayed above.
- The rule is composite Gauss–Legendre at 48 nodes per panel (`quad.rs`), exact on degree 2m − 1; the control route is the horn's integrand on a **uniform** grid in u.
- "60 digits requested" resolves 77 (E11).
- Driver `bin/h4_crosscheck`; modules `crossref`, `quad`.

## Proof / evidence

Numerical: three routes agree with the horn to 61–73 digits at 60 digits requested, and with each other to 66–72; at n = 1000 all three agree to 72.9 digits and reproduce [O'S] Table 1's twenty printed digits. The factor 8 of (3.1) is measured exactly (8.00000000000000000000000000000 at every M = 1…12). The n = 0 split is attributed to the horn's own Euler–Maclaurin boundary term at V₀ = −50, predicted against measured to 1.00000 over thirty-three decades of V₀.

## Dependencies and related results

- [[H4 from H_track.md](xihorn-h-track-h4-three-representations.md) — the track's fuller account.
- [H1 — a(1000) matches O'S Table 1](xihorn-rust-results-h1-a1000-against-os-table-1.md) — the check H4 was built to test the route of.
- [H5 — the Lambert-W asymptotic](xihorn-rust-results-h5-lambert-w-asymptotic.md) — the same [GORZ19] factor in (3.2).
- [A3 — Γ_Φ near w = 0](xihorn-rust-results-a3-gamma-phi-near-zero.md) — the same boundary term.

## Notes

- **E18**: the factor is a normalisation carried across from [GORZ19], whose γ is eight times larger — "**Anyone evaluating (3.1) or (3.2) numerically must divide by 8.**"
- **E17**: the cancellation the route was expected to have is not there; both ω and ψ are positive on [1, ∞).
