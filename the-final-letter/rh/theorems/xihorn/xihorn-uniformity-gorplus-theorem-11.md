# [GOR⁺] Theorem 1.1 — n ≥ ce^d forces hyperbolicity

**Kind:** Theorem
**Status:** CITED (literature — Griffin, Ono, Rolen, Thorner, Tripp, Wagner, Adv. Math. **397** (2022) 108186)
**Area:** xi-horn
**Source:** [`xi-horn/uniformity-in-the-jensen-degree-d.md`](../../xi-horn/uniformity-in-the-jensen-degree-d.md) — §2 "The two theorems, verbatim", subsection "[GOR⁺] Theorem 1.1 — the d-uniformity made effective"

## Statement

> **Theorem 1.1.** *There is a constant c > 0 such that if n ≥ ce^d, then J_{d,n}(X) is hyperbolic.*

## Hypotheses and notation

- J_{d,n}(X) = Σ_{j=0}^{d} C(d,j)·γ(n+j)·X^j ([O'S] (1.3) = POSITIVITY (13)); γ is the papers' γ(n) = the directory's a(n) (source §1).
- c > 0 is an unspecified constant; hyperbolic = all zeros real.
- The source calls this "the effective form of GORZ19's 'hyperbolic for all sufficiently large n'".

## Proof / evidence

The source quotes the theorem and records the proof's sharper internal bound, verbatim: "The proof's own exponent is sharper than the statement: it closes (end of §2.2) with the requirement
```
n  ≥  C̃ · d^{13/3} · (2 + 16C²)^{d/3},        1 < C < 2,
```
whose exponent ⅓·log(2+16C²) + 13·log d/(3d) tends, as C → 1 and d grows, to **⅓·log 18 = 0.9634…** — the number printed in the paper immediately before 'and the desired result follows', and the number C1 quotes."

The source also records the version discrepancy: "([O'S] p. 2 cites the statement in the preprint's form, 'hyperbolic whenever n ≥ e^{8d/9}' — 8/9 = 0.889; the published version trades that for the clean n ≥ ce^d. Either way the threshold is exponential in d.)"

The mechanism, per the source's §3: "J_{d,n} is not a Hermite combination; it has to be renormalised into one. Lemma 2.3 gives the limit exactly … Feeding those bounds into the Turán condition (their (2.9)) costs (2+16C²)^{d/3}: **the exponential is the price of the renormalisation error**".

## Dependencies and related results

- [GOR⁺] Lemma 2.3 ([harvested](xihorn-uniformity-gorplus-lemma-23.md)) and Theorem 2.4 (mentioned in the source but not stated there, so not harvested); Turán's Theorem III ([O'S] Theorem 8.1, [harvested](xihorn-uniformity-turan-theorem-iii.md)).
- Compared with [O'S] Theorem 1.3 ([harvested](xihorn-uniformity-osullivan-theorem-13.md)).
- In the companion source: [xihorn-gorz-gap-gorplus-theorem-11.md](xihorn-gorz-gap-gorplus-theorem-11.md).

## Notes

- The source's reconciliation §7 records: "**0.9634 = ⅓·log 18**, the C → 1 limit of ⅓·log(2+16C²): log 18 = 2.8904, /3 = 0.96345. The paper prints 0.9634…; TODO C1 quotes it."
- The source's framing: C1's `[-]` "stays `[-]` at the end of this file" — this theorem moves the n-axis threshold, it does not touch the fixed-n, all-d direction.
