# [GOR⁺] Theorem 1.1 — the d-uniformity made effective

**Kind:** Theorem
**Status:** CITED (literature — Griffin, Ono, Rolen, Thorner, Tripp, Wagner, *Jensen polynomials for the Riemann xi-function*, Adv. Math. **397** (2022) 108186)
**Area:** xi-horn
**Source:** [`xi-horn/gorz-gap.md`](../../xi-horn/gorz-gap.md) — §1.3 "The exception sets, and the gap", quoted theorem box; also quoted in [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) §2

## Statement

> **[GOR⁺] Theorem 1.1.** *There is a constant c > 0 such that if n ≥ ce^d, then J_{d,n}(X) is hyperbolic.*

## Hypotheses and notation

- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·a(n+j)·X^j (equation (4)); hyperbolic = all zeros real.
- c > 0 is an unspecified constant (the companion source calls this "the effective form of GORZ19's 'hyperbolic for all sufficiently large n'").
- N(d) := 1 + max E(d) is the threshold the paper names; the source writes that their main result "provides an effective upper bound for N(d)".

## Proof / evidence

The source quotes the theorem without proof, but records the proof's own sharper exponent: "The proof of Theorem 1.1 closes with the requirement n ≥ C̃·d^{13/3}(2 + 16C²)^{d/3}, whose exponent tends to ⅓·log 18 = 0.9634… as C → 1."

The companion source §2 states the same closing bound as "n ≥ C̃ · d^{13/3} · (2 + 16C²)^{d/3}, 1 < C < 2", and adds that [O'S] p. 2 cites the preprint's form "hyperbolic whenever n ≥ e^{8d/9}" (8/9 = 0.889), while "the published version trades that for the clean n ≥ ce^d. Either way the threshold is exponential in d."

## Dependencies and related results

- Sharpens [GORZ19] Theorem 1 ([harvested](xihorn-gorz-gap-gorz19-theorem-1.md)).
- Used by [GOR⁺] Theorem 1.2 and Corollary 1.3 ([harvested](xihorn-gorz-gap-gorplus-corollary-13.md)).
- The source's structural answer to it is [Theorem 3 (the uniformity constant)](xihorn-gorz-gap-t3-uniformity-constant.md): "Their bound is N(d) ≤ ce^d. The truth is that N(d) is *monotone and bounded*, increasing to ν. The exponential is therefore never tight for large d — it is an artifact of the certificate, not a feature of the family."
- Companion harvest: [xihorn-uniformity-gorplus-theorem-11.md](xihorn-uniformity-gorplus-theorem-11.md).

## Notes

- The source's status table records "N(d) ≤ ce^d | [GOR⁺] Theorem 1.1".
- The source's §10 note: "**4. Nothing here is deep.** … The content is that neither local paper puts them together"; this file records the cited theorem only.
- The two local papers are in the source directory: [jensens-polynomials.pdf](../../xi-horn/jensens-polynomials.pdf) ([GOR⁺]) and [zeros-jensens-polynomials.pdf](../../xi-horn/zeros-jensens-polynomials.pdf) ([O'S]).
