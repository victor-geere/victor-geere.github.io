# The ring — Ψ(−v) = −Σ_k Re[C(ρ_k)·e^{iγ_k v}] + O(v·e^{−5v/2}), with the exact near field

**Kind:** Theorem
**Status:** PROVED (paper argument; contour shift in the standard smoothed explicit formula, verified numerically — the primes reproduce the ten-zero ring to 8 decimals at v = 9)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-revisited.md`](../../xi-horn/horn-helix-revisited.md) — §3.3 "The ring", equations (10) and (10′); §7 dictionary, term "the primes ring the first zero"

## Statement

> With the main term self-cancelled, shift the contour (the standard smoothed explicit formula; the s = 1 residue is killed by (9), s = 0 is regular, the first trivial zero sits at s = −2):
>
> ```
> Ψ(−v) = − Σ_k Re[ C(ρ_k)·e^{iγ_k v} ]  +  O(v·e^{−5v/2})                   (10)
> ```
>
> A **bounded, almost-periodic signal whose frequencies are exactly the horn's closure ordinates**, with amplitude ledger |C(½+iγ_k)| — which is shell 1's transform at each closure, the number 0.0017433 already computed in [horn-helix.md](../../xi-horn/horn-helix.md) §4:
>
> ```
>   k    γ_k           |C(½+iγ_k)|
>   1    14.134725     1.743303e−03
>   2    21.022040     1.561327e−05
>   3    25.010858     9.223475e−07
>   4    30.424876     1.849554e−08
>   5    32.935062     2.958626e−09
>   6    37.586178     9.660343e−11
>                      Σ₁₀ = 1.759860e−03
> ```
>
> The first mode is 99.1 % of the total: **the prime horn is a nearly monochromatic sinusoid at frequency γ₁ = 14.134725…**
>
> **The near field, exactly.** That last column is not a leftover: both constants are residues, so both are closed forms. At s = −2, Γ(s/2) has a pole and ζ its first trivial zero, so the integrand of (10) has a *double* pole there, and expanding it gives
>
> ```
> Ψ(−v) − ring(v) = (a·v + b)·e^{−5v/2} + O(e^{−9v/2}),                       (10′)
> a = 3π = 9.4247779608,
> b = 3π·ζ″(−2)/(2ζ′(−2)) − (3π/2)(γ_E + 2/3 + ln π) = −1.0781069034
> ```
>
> (using ζ′(−2) = −ζ(3)/4π² = −0.0304484571, ζ″(−2) = −0.0657635162).

## Hypotheses and notation

- Ψ is the prime horn, Ψ(u) = Σ_{n≥2} Λ(n)·n^{−1/2}·φ₁(u + log n) (source (8)); v > 0 and Ψ is read at −v.
- C(s) = ½s(s−1)π^{−s/2}Γ(s/2); ρ_k = ½ + iγ_k are the non-trivial zeros; γ_E is Euler's constant.
- The contour shift is the standard smoothed explicit formula; it requires the s = 1 residue to be killed (by (9)), s = 0 to be regular, and the first trivial zero at s = −2.
- Computed from the primes alone with a Λ-sieve to 170 000; the ring is predicted from ten zeros.

## Proof / evidence

The contour-shift derivation is given in one paragraph (quoted above), and the result is checked two ways: against the zeros (the ring: at v = 9, Ψ −9 from primes is 1.70184913e−3 against the ten-zero prediction 1.70183496e−3, difference 1.4e−8 — "by v = 9 the primes reproduce the ten-zero prediction to **eight decimal places**"), and against the trivial zeros (the near-field residual divided by (10′) reads 0.5071, 0.9120, 0.9875, 0.9983, 0.99977, 0.99997, 0.999996, 1.000000 at v = 1, 2, 3, 4, 5, 6, 7, 9, with the shortfall falling by a factor 7.4 per unit of v = e^{−2v}, "exactly the next trivial zero, at s = −4"). §6 collects the numbers; the global maximum of |Ψ| is 0.349133 at v = 1.002271.

## Dependencies and related results

- [The silence of the main term](xihorn-horn-helix-revisited-silence-of-the-main-term.md) (9) kills the s = 1 residue.
- [Shell 1 is the place at infinity](xihorn-horn-helix-shell-1-is-the-place-at-infinity.md) (horn-helix.md §4) supplies the amplitude 0.0017433 = |C(½+iγ₁)|.
- The same content appears in the companion page's theorem box → [the ring and the near field](xihorn-prime-horn-ring-and-near-field.md) (prime-horn.html (10)), where the source marks it as the classical contour shift.
- [RH ⟺ Ψ is bounded](xihorn-horn-helix-revisited-rh-iff-psi-bounded.md) is stated in terms of this Ψ.

## Notes

- The source warns that the agreement is consistency, not evidence: "an off-line zero at height 10⁶ would leave every row of that table untouched" (§5.2). Past v ≈ 10 the ratio stops meaning anything in float64 (the difference is 1e−10 out of a mass ~10²).
- The 1.4e−8 agreement is at one depth (v = 9) with a sieve to 170 000.
