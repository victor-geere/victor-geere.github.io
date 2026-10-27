# The bridge — −ζ′/ζ(s) = 1/s + 1/(s−1) − ½ln π + ½ψ(s/2) − ξ′/ξ(s)

**Kind:** Theorem
**Status:** PROVED (paper argument; log-differentiation of ξ = ½s(s−1)π^{−s/2}Γ(s/2)ζ, verified to ≤ 1e−31)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §1.3 "The bridge, exactly", equation (3); §7 dictionary, term "the two ledgers"

## Statement

> Log-differentiate ξ = ½s(s−1)π^{−s/2}Γ(s/2)ζ and rearrange:
>
> ```
> −ζ′/ζ(s) = 1/s + 1/(s−1) − ½ln π + ½ψ(s/2) − ξ′/ξ(s)                       (3)
> ```
>
> Left side: the prime helix's value, Σ Λ(n)n^{−s}. Right side: two pole terms, an archimedean comb, minus the closure ledger. Verified as an identity to 1e−31 at s = 2 and s = 3+2i, and with the ledger side computed *from the 150 zeros* to 4e−8. This is the explicit formula in coefficient-free form: **the prime helix equals a smooth comb minus the horn's closure ledger** — every gear of one figure accounted against every closure of the other, no test function in sight.

## Hypotheses and notation

- ξ = ½s(s−1)π^{−s/2}Γ(s/2)ζ(s) (the completed zeta function).
- ψ is the digamma function; Σ Λ(n)n^{−s} = −ζ′/ζ(s) is the prime helix's value (the source's (6) of horn-helix.md).
- ξ′/ξ(s) is the closure ledger of [the closure ledger](xihorn-horn-helix-revisited-closure-ledger.md) (1).

## Proof / evidence

The source's derivation is one line — log-differentiate the completed zeta function and rearrange. §6 records: "bridge (3) at s = 2 and 3+2i | identity to ≤ 1e−31; −ζ′/ζ(2) = 0.569960993094533". With the ledger side computed from the 150 zeros, the agreement is 4e−8.

## Dependencies and related results

- [The closure ledger](xihorn-horn-helix-revisited-closure-ledger.md) (1) is the last term.
- [The silence of the main term](xihorn-horn-helix-revisited-silence-of-the-main-term.md) (9) is the analogue for the prime horn's contour shift.
- §1.3 calls the bridge "the explicit formula in coefficient-free form"; the test-function version is [the Riemann–Weil explicit formula](xihorn-horn-helix-riemann-weil-explicit-formula.md).
- The archimedean comb is identified as the log-derivative of the archimedean Euler factor in [horn-helix-adelic.md](../../xi-horn/horn-helix-adelic.md) (15).

## Notes

- The identity is stated and checked as an exact algebraic rearrangement (to 1e−31); the 4e−8 figure applies only when the ledger is truncated to the first 150 zeros.
- §4.3 draws the consequence: "RH ⟺ the closure measure Σ δ_γ is the spectrum of the prime comb minus the archimedean comb (§1.3)".
