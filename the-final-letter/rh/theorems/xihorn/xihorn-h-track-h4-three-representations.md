# H4 — γ(n) from two representations that are not the horn

**Kind:** Claim
**Status:** VERIFIED (numerical, 60 digits requested / 77 resolvable; 66–73 digits three ways)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H4 "γ(n) from two representations that are not the horn"

## Statement

> H1 compared one number against one number. A transcription error in Φ, in the
> substitution, or in the n!/(2n)! prefactor would have to be shared by [O'S]'s
> table to survive — but the *route* was never tested. H4 computes γ(n) three
> more ways, with a quadrature the crate did not previously own.
>
> ```text
> ξ^{(2n)}(½) = 2^{1−2n}∫₁^∞ (log t)^{2n}·ω(t)·t^{−3/4} dt                [O'S] (7.1)
> γ(M)        = M!/(2M)!·[32·C(2M,2)·F(2M−2) − F(2M)]/2^{2M−1}           [GOR⁺] (3.1)
> F(z)        = ∫₁^∞ (log t)^z·t^{−3/4}·Σ_{k≥1}e^{−πk²t} dt
> ω(t)        = Σ_{k≥1}(2π²k⁴t² − 3πk²t)e^{−πk²t}                        [O'S] (6.1)
> ```
>
> ### They agree to the arithmetic floor
>
> At 60 digits requested (77 resolvable — see E11), agreeing decimal digits:

| n | γ(n) | uniform-u | (7.1) | (3.1)/8 | (7.1) vs uniform-u |
|---|---|---|---|---|---|
| 0 | 4.97120778188e−1 | 27.6 | 27.6 | — | 71.7 |
| 1 | 1.14859721576e−2 | 69.3 | 69.3 | 69.3 | 71.6 |
| 4 | 9.58134372323e−8 | 73.5 | 68.1 | 66.4 | 68.1 |
| 8 | 8.46627186646e−15 | 73.0 | 66.8 | 62.8 | 66.8 |
| 12 | 4.37967586840e−22 | 72.7 | 66.7 | 61.4 | 66.7 |

> and at **n = 1000** all three agree to **72.9 digits** and reproduce [O'S]
> Table 1's twenty printed digits, in 1.8 s.
>
> ### [GOR⁺] (3.1) as printed returns 8γ(M) — see E18
>
> Integrating ω = 2t²ψ″ + 3tψ′ by parts twice against ψ (the derivation [GOR⁺]
> omit) gives
>
> ```text
> ∫₁^∞(log t)^{2M}·ω(t)·t^{−3/4}dt = 4·C(2M,2)·F(2M−2) − F(2M)/8
> ```
>
> so with (7.1) the denominator is 2^{2M+2}, not the printed 2^{2M−1}. The ratio
> is **exactly 8.00000000000000000000000000000** at every M from 1 to 12, to
> thirty digits. … So it is a normalisation carried across without conversion,
> not an error in [GOR⁺]'s proof …
>
> ### The one place the horn is the one that is off
>
> At n = 0 the three routes split, and the two new ones agree with each other to
> 71.7 digits while the horn differs by 2.31e−28. The cause is the horn's own
> documented Euler–Maclaurin boundary term: `Mellin::standard` truncates at
> V₀ = −50, where the integrand e^{(w+1)v}Φ(e^v) is still e^{V₀}Φ(0), so the
> trapezoid leaves +4·(h²/12)·f′(V₀). For n ≥ 1 the weight is e^{(2n+1)V₀} and it
> vanishes; at n = 0 it does not.

| V₀ | γ(0) − (7.1), relative | 4(h²/12)e^{V₀}Φ(0)/Γ_Φ(0) | ratio |
|---|---|---|---|
| −16 | 1.34827e−13 | 1.34827e−13 | 1.00000 |
| −30 | 1.12113e−19 | 1.12113e−19 | 1.00000 |
| −50 | 2.31082e−28 | 2.31082e−28 | 1.00000 |
| −70 | 4.76295e−37 | 4.76295e−37 | 1.00000 |
| −90 | 9.81717e−46 | 9.81717e−46 | 1.00000 |

> Six significant figures at every V₀, over **thirty-three decades** — the
> mechanism is identified, not merely observed. At V₀ = −110 the horn agrees with
> (7.1) to 53.7 digits … **Nothing published in this directory is affected**:
> the tightest tolerance ever asked of γ(0) is H2's 1.709e−15, thirteen decades
> above the gap.
>
> ### The other correction: there is no cancellation here — see E17
>
> ω(t) = Σ πk²t(2πk²t − 3)e^{−πk²t} is **positive for every t ≥ 1**, because
> 2πt > 3 already at t = 1; and ψ(t) = Σe^{−πk²t} is positive by inspection. So
> (7.1) and F(z) integrate positive integrands, and (3.1)'s difference does not
> cancel either — its first term beats the second by ~64M²/(log M)². Φ's famous
> cancellation lives entirely on u < 0, i.e. t < 1, which neither representation
> visits.
>
> Two structural identities are checked as arithmetic rather than asserted:
> **Φ(u) = e^{u/2}·ω(e^{2u})** to sixty digits on both sides of the throat … and
> **ω = 2t²ψ″ + 3tψ′**, which is what the integration by parts behind (3.1)
> rests on.

## Hypotheses and notation

- ψ(t) := Σe^{−πk²t}; ω(t) as displayed ([O'S] (6.1)); F(z) and (7.1) as displayed; the control route is the horn's own integrand 4∫₀^∞u^{2n}Φ(u)du on a **uniform** grid in u.
- (7.1) is the horn's own integral after t = e^{2u} — the source says plainly it "is not a different *identity*"; what differs is everything computational.
- Rule: composite Gauss–Legendre at 48 nodes per panel (`quad.rs`), exact on degree 2m − 1, converging like ρ^{−2m} on a Bernstein ellipse.
- Driver `rust/src/bin/h4_crosscheck.rs`; modules `crossref`, `quad`.

## Proof / evidence

Numerical: three routes (uniform-u control, [O'S] (7.1), [GOR⁺] (3.1)/8) agree to 66–73 digits at 60 digits requested, and at n = 1000 all three agree to 72.9 digits, reproducing [O'S] Table 1's twenty printed digits. The factor-8 of (3.1) is established both numerically (ratio exactly 8.00000000000000000000000000000 at every M = 1…12) and by an independent integration by parts twice against ψ, which puts the denominator at 2^{2M+2}. The n = 0 discrepancy is attributed by prediction against measurement over thirty-three decades of V₀.

## Dependencies and related results

- [O'S] (7.1) and (6.1) are quoted from the paper; [GOR⁺] (3.1) as printed returns 8γ(M) (**E18**).
- [H1 — a(n) at n = 1000](xihorn-h-track-h1-a1000-vs-os-table-1.md) — the comparison H4 was built to test.
- [H5 — the Lambert-W asymptotic](xihorn-h-track-h5-lambert-w-asymptotic.md) — shares the [GORZ19] factor of 8 in (3.2).
- [A3 — Γ_Φ near w = 0](xihorn-rust-results-a3-gamma-phi-near-zero.md) — the same Euler–Maclaurin boundary term.

## Notes

- The source's own hedging: (7.1) is not an independent identity — "(7.1) is the horn's own integral after t = e^{2u}" — so what the check catches is computational, not conceptual.
- **E17**: the item's original specification, that both representations have cancellation in them, is wrong; what 60 digits is for on this route is the *dynamic range* — (log t)^{2n}e^{−πt} spans six hundred decades at n = 1000.
- **E18**: anyone evaluating (3.1) or (3.2) numerically must divide by 8.
