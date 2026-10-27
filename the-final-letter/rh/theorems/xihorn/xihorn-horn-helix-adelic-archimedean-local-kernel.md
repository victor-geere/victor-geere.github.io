# The archimedean local kernel — W_∞(g) = (1/2π)∫h(r)·ψ̃(r)dr with ψ̃(r) = 2·Re[(log Z_∞)′(½ + ir)]

**Kind:** Proposition
**Status:** CITED (literature; (14) is Weil's evaluation cited and not re-derived; (15) is an identification by inspection, per the source's own §7.4)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §4.1 "The local terms", equations (14) and (15)

## Statement

> **At the archimedean place** the same principal value evaluates to the ψ-comb,
>
> ```
> W_∞(g) = (1/2π) ∫ h(r)·ψ̃(r) dr,     ψ̃(r) = Re ψ(¼ + ir/2) − ln π          (14)
> ```
>
> which is Weil's evaluation, cited and not re-derived. Its kernel has an exact local reading worth recording:
>
> ```
> ψ̃(r) = 2·Re [ (log Z_∞)′(½ + ir) ]                                        (15)
> ```
>
> — **the archimedean local term's kernel is the logarithmic derivative of the archimedean Euler factor on the line**, which is the archimedean comb of [horn-helix-revisited.md](../../xi-horn/horn-helix-revisited.md) (3) identified as a local object.

## Hypotheses and notation

- ψ is the digamma function; ψ̃(r) = Re ψ(¼ + ir/2) − ln π is the archimedean comb's kernel.
- Z_∞(s) = π^{−s/2}Γ(s/2) is the archimedean Euler factor (see [every local figure is zero-free](xihorn-horn-helix-adelic-every-local-figure-zero-free.md)).
- W_∞ is the v = ∞ term of the decomposition Σ_ρ h(γ_ρ) − h(i/2) − h(−i/2) = Σ_v W_v(g) (source (11)); h even, h(r) = ∫g(u)e^{iru}du.

## Proof / evidence

(14) is quoted as "Weil's evaluation, cited and not re-derived"; (15) is stated as a local reading and the source's §7.4 classifies it explicitly: "(14) is Weil's evaluation of (12) at ∞, and the m = 0 principal value at the finite places is Weil's convention. Both are taken on trust; the 21-digit balance is consistency, not a derivation. So is (15), which is an identification by inspection." Making the identification explicit: (log Z_∞)′(s) = −½ln π + ½ψ(s/2), so at s = ½ + ir the right side of (15) is Re ψ(¼ + ir/2) − ln π = ψ̃(r).

## Dependencies and related results

- [The local Weil term at a finite place](xihorn-horn-helix-adelic-local-weil-term-finite-place.md) (13) is the finite-place counterpart; (11)–(12) are the shared decomposition.
- [The bridge](xihorn-horn-helix-revisited-the-bridge.md) (revisited (3)) contains the same archimedean comb, here identified as a local object.
- [The Riemann–Weil explicit formula](xihorn-horn-helix-riemann-weil-explicit-formula.md) — the archimedean integral in test-function form.
- The two pole terms h(±i/2) "belong to no place": they are the residues of the global zeta integral at s = 0 and s = 1, "the adelic name for the factor ½s(s−1)" (§4.1, dictionary term "the volume term").

## Notes

- The file states plainly that neither (14) nor (15) is derived here; both are taken on trust from Weil, with the 21-digit ledger balance offered only as consistency.
- §6 records what is *not* resolved: what Connes–Consani's archimedean statement is about "as this file understands it, from the title and the road-A reading of the predecessor — **not verified against the PDF here**; TODO **A1**".
