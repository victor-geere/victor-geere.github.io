# The place-truncated figure does not approach the value it is supposed to compute

**Kind:** Claim
**Status:** VERIFIED (numerical; sixteen samples to 2×10⁶, non-monotone excursions over more than four orders of magnitude; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/horn-helix-adelic.md`](../../xi-horn/horn-helix-adelic.md) — §5.2 "The truncation trade, adelically"; §9 dictionary, term "the truncation trade, reversed"

## Statement

> **Place truncation is not cheap, and does not converge at all.** The partial Euler product at s = ½ + iγ₁ is exactly "the adelic figure with all but finitely many places dropped". [horn-helix.md](../../xi-horn/horn-helix.md) §5 sampled it at five decades and read off "about 0.30 decades per decade", with the explicit caveat that the sequence is oscillatory and no limit is claimed. Sampled sixteen times to 2×10⁶ instead of five times to 10⁵:
>
> ```
>    P            |∏_{p≤P} Z_p(½+iγ₁)|        arg
>    10           0.1715783951                −0.0366
>    30           0.1252702005                +0.3895
>    10²          0.1071044717                +0.0881
>    3×10²        0.06874584111               +0.2193
>    10³          0.05939348402               −0.1743
>    3×10³        0.06165377598               +0.6420
>    10⁴          0.02278694606               +0.0604
>    3×10⁴        0.1312087507                +0.5602
>    10⁵          0.01311774803               +1.7630
>    2×10⁵        0.06477301556               −2.3729
>    3×10⁵        0.320010771                 −1.9918
>    5×10⁵        0.01845550098               +2.6768
>    7×10⁵        2.460101622                 −0.7120
>    10⁶          0.4177308308                −1.6958
>    1.5×10⁶      0.02783910335               −0.0504
>    2×10⁶        0.0001377069861             +2.1808
>                                             ζ(½+iγ₁) = 3.4e−41
> ```
>
> Between P = 10⁴ and P = 2×10⁶ the modulus spans **more than four orders of magnitude, non-monotonically** — 2.46 at P = 7×10⁵ and 1.4e−04 at P = 2×10⁶ — and the phase wanders over the whole circle. The five-point rate was a fit, which is what its own caveat said it might be; the flat statement is:
>
> > **The place-truncated figure does not approach the value it is supposed to compute, at any rate, and nothing measured here bounds its excursions.**
>
> The last row is the smallest value in the scan and should not be read as convergence — four samples earlier the modulus is 17,865 times larger.

with the sampling convention stated by the source: "each row is the product up to the first prime ≥ P, so the 10⁵ row carries one factor more than [horn-helix.md](../../xi-horn/horn-helix.md) §5's 0.013084262 — that single factor is the whole 0.25 % difference between the two numbers."

## Hypotheses and notation

- The partial product ∏_{p≤P} Z_p(½+iγ₁) is "the adelic figure with all but finitely many places dropped"; each row is the product up to the first prime ≥ P.
- ζ(½+iγ₁) = 3.4e−41 is the value the truncated figure is supposed to approach.
- The earlier five-point sample and its "about 0.30 decades per decade" rate are horn-helix.md §5's.

## Proof / evidence

Numerical (float64, sixteen samples to 2×10⁶): the modulus is non-monotone over more than four orders of magnitude and the phase wanders; §8 lists the same rows. The source's §7.5 restricts the claim precisely: "§5.2 refutes a fit, not a claim. The partial Euler product's four-and-a-half order excursion is consistent with everything horn-helix.md §5 and §11.3 said about the sequence being oscillatory ... Sixteen points establish that the five-point rate was a fit; they establish nothing about what the sequence does, and in particular the smallest value in the scan sitting at the largest P is not evidence of convergence."

## Dependencies and related results

- horn-helix.md §5 → [the prime figure and the zero figure cannot be drawn in the same region](xihorn-horn-helix-prime-and-zero-figures-disjoint.md).
- [Smearing is archimedean](xihorn-horn-helix-adelic-smearing-is-archimedean.md) (§5.1) is the structural reason the truncation trade is reversed.
- §5.2 also records the cheap side: depth truncation for 1e−19 needs K = 129, 81, 55, 45, 19 shells at p = 2, 3, 5, 7, 101.

## Notes


- The refuted object is the fitted rate, not a stated claim: the source is explicit that no limit was claimed by the earlier file and none is established here.
- The minimal value at the largest P must not be read as convergence.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
