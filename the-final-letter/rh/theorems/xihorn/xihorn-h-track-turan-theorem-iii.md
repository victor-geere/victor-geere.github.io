# Turán's Theorem III ([GOR⁺] (2.10), [O'S] (8.1))

**Kind:** Theorem
**Status:** CITED (literature — Turán, [Tur59]; quoted as [GOR⁺] (2.10) and [O'S] (8.1))
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H3 "where the Turán criteria actually start to hold"

## Statement

> Both papers certify through the same theorem — Turán's Theorem III, [Tur59],
> quoted as [GOR⁺] (2.10) and [O'S] (8.1): for G(z) = Σ_{j=0}^{N} c_j H_j(z),
>
> ```text
> Σ_{j=0}^{N−2} 2^j·j!·c_j²  <  2^N·(N−1)!·c_N²                        (Tur)
> ```
>
> implies every zero of G is real and simple.

## Hypotheses and notation

- G(z) = Σ_{j=0}^{N} c_j H_j(z) is a combination of Hermite polynomials H_j.
- c_N is the leading Hermite coefficient; the inequality is strict.
- The conclusion is that every zero of G is real **and simple**.
- In the source's use, "for P, (Tur) applies with no transformation at all, because P is already a combination of Hermite polynomials" ([O'S] (8.2)); for J it is applied only after [GOR⁺]'s renormalisation (2.6)–(2.9).

## Proof / evidence

The source states the theorem and attributes it to [Tur59]; it gives no proof. It records that both papers certify through it, that [O'S] (8.2) is its P-form, and that the criterion is checked to be sufficient against the discriminant route: "wherever either criterion holds, the discriminant route certifies the same polynomial."

## Dependencies and related results

- [H3 — where the Turán criteria actually start to hold](xihorn-h-track-h3-turan-onset.md) — the onsets measured for its two instantiations.
- [[O'S] Theorem 1.3](xihorn-h-track-os-theorem-1-3.md) and [[GOR⁺] Theorem 1.1](xihorn-h-track-gor-theorem-1-1.md) — the asymptotic bounds obtained from it.
- Harvested from the same family elsewhere in the workspace as [Turán's Theorem III](xihorn-uniformity-turan-theorem-iii.md).

## Notes

- A bare attribution would not be a harvest; the source sets the criterion out with its display (Tur) and uses it as the rung on which both papers' criteria stand.
- The source's caution: these criteria are **sufficient** — "These are onsets of a *sufficient* criterion, not of hyperbolicity."
