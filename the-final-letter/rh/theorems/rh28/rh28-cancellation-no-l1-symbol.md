# The cancellation, and why there is no L¹ symbol

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh28.html`](../../html/rh28.html) — §5 "The cancellation, and why there is no symbol"

## Statement

> The kernel row is pole + arch − comb. The pole carries 2ĥ(i/2)²cosh(v/2) and rises by cosh 9 = 4,052 from v = 0 to v = 18. The comb carries the gear mass Σ<sub>|ln m − v| ≤ 2Δ′</sub>Λ(m)m<sup>−½</sup>, which by the prime number theorem also rises like e<sup>v/2</sup>, and it does: at v = 18 the two agree to 0.8%. The archimedean term has decayed to 3.5×10⁻⁸ by then and is irrelevant. What is left is the row, and **the row does not grow**: its largest entry over the whole eighteen is the diagonal itself, and at v = 18 it is 7.6×10⁻³ of the pole term that made it.
>
> That is the explicit formula's own balance, seen directly rather than inferred. It is also the answer to the symbol question. Individually the two series diverge; the row is their difference and is bounded but not obviously summable, and the comb's lumpiness — comb/pole is 5.30 at v = 3 and 0.77 at v = 6, one prime power at a time — is what a Fourier series would have to absorb. So there is no L¹ symbol to take an infimum of, and the Szegő route to the depth infinity is closed. The arc works at finite depth because that is the only place the objects exist.

## Hypotheses and notation

- The kernel row is pole + arch − comb; the pole term is 2ĥ(i/2)²cosh(v/2); v is the depth.
- The comb term is Σ<sub>|ln m − v| ≤ 2Δ′</sub>Λ(m)m<sup>−½</sup>, Λ the von Mangoldt function.
- If the row had an L¹ symbol f(θ) = Σ<sub>k∈ℤ</sub>E<sub>h</sub>(kΔ′)e<sup>ikθ</sup>, then λ<sub>min</sub>(T<sub>n</sub>) ≥ ess inf f for every n, collapsing the depth direction into one number.
- The measurement is at Δ′ = 0.12 (Figure 3) and stated for the row generally.

## Proof / evidence

Numerical: the pole rises by cosh 9 = 4,052 from v = 0 to v = 18; the comb rises with it and the two agree to 0.8% at v = 18; the archimedean term has decayed to 3.5×10⁻⁸; the row's largest entry over the whole eighteen is the diagonal itself, and at v = 18 it is 7.6×10⁻³ of the pole term. The check suite reports "the pole–arch–comb decomposition checked to reconstruct the row it came from to machine precision".

## Dependencies and related results

- rh27c §3's ceiling chain; the Szegő limit theorem and Toeplitz–Fejér are cited, not reproved.
- rh28 §7 draws the consequence: "Ruling out a route is worth stating; it is why the finite-depth machinery exists."

## Notes


- The conclusion is a negative one — a route is closed — and the source states it as such rather than as progress towards RH.
- The source notes the shifts in `3.5×10⁻⁸` and `7.6×10⁻³` are quoted exactly as printed.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
