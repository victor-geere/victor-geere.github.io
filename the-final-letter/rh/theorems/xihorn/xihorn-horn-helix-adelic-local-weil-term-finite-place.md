# The local Weil term at a finite place — W_p(g) = −log p·Σ_{k≥1} p^{−k/2}[g(k log p) + g(−k log p)]

**Kind:** Proposition
**Status:** PROVED (paper argument; derived in the source by splitting ℚ_p^× into shells, with the m = 0 shell taken from Weil's principal-value convention; consistency checked by the 21-digit ledger balance)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §4.1 "The local terms", equation (13); §9 dictionary, term "the local Weil term"

## Statement

> In the convention of [rh10](../../html/rh10.html) §1 and [horn-helix.md](../../xi-horn/horn-helix.md) §8, with h even and `h(r) = ∫g(u)e^{iru}du`,
>
> ```
> Σ_ρ h(γ_ρ) − h(i/2) − h(−i/2) = Σ_v W_v(g)                                (11)
> ```
>
> where the uniform expression for the local term is Weil's principal value
>
> ```
> W_v(g) = − ∫'_{ℚ_v^×}  |w|_v^{1/2}·g(log|w|_v) / |1 − w|_v  d^×w           (12)
> ```
>
> **At a finite place (12) is elementary and is derived here.** Split ℚ_p^× = ⊔_{m ∈ ℤ} p^m·ℤ_p^×, and normalise d^×w so that vol(ℤ_p^×) = log p. On the shell m > 0 we have |w|_p = p^{−m} < 1, hence |1 − w|_p = 1; on the shell m < 0 we have |w|_p = p^{|m|} > 1, hence |1 − w|_p = |w|_p. So
>
> ```
> W_p(g) = − log p · Σ_{k≥1} p^{−k/2} · [ g(k log p) + g(−k log p) ]         (13)
> ```
>
> which is precisely the prime term of (11) regrouped by *p* — the arithmetic side of the explicit formula, split into places. The m = 0 shell is where |1 − w|_p is unbounded, and its value is Weil's principal-value convention; **that convention is adopted here, not derived**, and §4.2's twenty-one-digit balance is the check that it is the right one.

## Hypotheses and notation

- h is even and h(r) = ∫g(u)e^{iru}du, so g is the Fourier partner.
- d^×w is normalised so that vol(ℤ_p^×) = log p.
- The prime term of (11) as a whole is −2Σ_{n≥2} Λ(n)/√n·g(log n) in horn-helix.md (7)'s form; (13) regroups it by place.
- The m = 0 shell (the units) is where |1 − w|_p is unbounded; its value is Weil's principal-value convention.

## Proof / evidence

The source derives (13) in three lines from (12) by splitting ℚ_p^× into shells; the m = 0 principal value is explicitly not derived ("that convention is adopted here, not derived"). The check is the §4.2 per-place ledger, whose totals reproduce E(0) = 0.00316964210539552444 and E(10) = −0.00316792901599199131 "to 21 digits" (see [the per-place ledger](xihorn-horn-helix-adelic-per-place-ledger-to-21-digits.md)), and §7.4 repeats that the convention "is taken on trust; the 21-digit balance is consistency, not a derivation."

## Dependencies and related results

- [The Riemann–Weil explicit formula](xihorn-horn-helix-riemann-weil-explicit-formula.md) (horn-helix.md (7)) — the same pairing in test-function form.
- [Every finite place's term is negative](xihorn-horn-helix-adelic-finite-place-terms-negative.md) uses (13) with a positive window.
- [The per-place ledger](xihorn-horn-helix-adelic-per-place-ledger-to-21-digits.md) is the numerical check.
- The archimedean counterpart is [the archimedean local kernel](xihorn-horn-helix-adelic-archimedean-local-kernel.md) (14)–(15).

## Notes

- The finite-place derivation is the source's own ("derived here"); the principal-value convention at the units is inherited from Weil and flagged as such.
- §7.3 warns that §4's table is "a decomposition, not a new computation": the totals were already in positivity-generator.md §2.1.
