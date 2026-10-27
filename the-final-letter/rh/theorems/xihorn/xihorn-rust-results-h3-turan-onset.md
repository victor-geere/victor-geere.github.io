# H3 — a table neither paper has

**Kind:** Claim
**Status:** VERIFIED (numerical; 120-digit cross-check moves (2.9) by at most 3.0e−54)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "H3 — done. A table neither paper has"

## Statement

> **H3 — done. A table neither paper has.** Both certify through Turán's
> Theorem III and both bound the onset only asymptotically — n ≥ c·e^d for J
> ([GOR⁺] Thm 1.1, **c never given**) and n/log²n ≥ d^{3/4}/2 for P ([O'S]
> Thm 1.3, "d large"). Where each *actually* starts:
>
> > **[O'S]'s criterion for P holds at n = 0 for every d ≤ 400.
> > [GOR⁺]'s for J holds at n = 0 only for d ≤ 7.**
>
> A factor of **57 in the degree reachable at no cost in n**. That is H2's
> asymmetry — measured there as 175× to 6.0e9× in tolerable enclosure width at
> fixed (d, n) — arriving from the criterion side instead. The P crossing is
> sharp: (8.2) = **0.993195 at d = 400**, **1.000691 at d = 401**.

| d | 2 | 8 | 90 | 303 | 400 | 401 | 454 | 681 | 1021 |
|---|---|---|---|---|---|---|---|---|---|
| **P**: n₀ | 0 | 0 | 0 | 0 | 0 | — | 2 | 10 | 24 |
| **P**: (8.2) at n = 0 | 6.2e−8 | 6.9e−6 | 1.1e−2 | 0.430 | 0.993 | 1.001 | — | — | — |

| d | 3–7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|---|---|---|---|---|---|---|---|---|---|---|
| **J**: n₀ | 0 | 51 | 129 | 251 | 434 | 693 | 1048 | 1518 | 2126 | 2897 |

> Every J row is a genuine first crossing: (2.9) sits at 0.9983…0.9999 at n₀ and
> above 1 at n₀ − 1.
>
> Against the published bounds: [O'S] Thm 1.3 overshoots the true onset by
> **296× to 1602×** where both are defined. [GOR⁺]'s cannot be compared —
> no c is given — but the measured J onset grows *more slowly* than e^d over
> 8 ≤ d ≤ 16, the implied c falling from 0.0171 to 0.0003, so the exponential
> regime their proof needs has not begun at these degrees.
>
> Three things the implementation had to get right:
>
> * **[GOR⁺] Lemma 2.3 is an exact test, and it settles an ambiguity.** A_{d,0} = 1,
>   A_{d,1} = 0, A_{d,2} = −d(d−1), and J̃^{2,n} = H₂(X/2) identically — all four
>   hold to 40 digits across d = 2…12, n = 0…40. They are also what decides that
>   the Δ^d of (2.6) belongs in the **denominator**, which the paper's typography
>   leaves open and which the wrong choice gets wrong by Δ^{2d};
> * **the criterion is checked to be sufficient** — wherever either holds, the
>   discriminant route certifies the same polynomial;
> * **precision is not the obstacle, and the naive metric says it is.** The J
>   renormalisation is an alternating sum whose max-term-over-sum reaches 1e77,
>   which looks fatal. Recomputing a(0) … a(2914) at **120** digits moves (2.9)
>   at every n₀ by at most **3.0e−54**. Those huge ratios are coefficients
>   genuinely near zero, contributing nothing. The metric overstates by seventy
>   decades; only the precision cross-check settles it.
>
> These are onsets of a *sufficient* criterion, not of hyperbolicity. The
> discriminant route decides every small-d cell at n = 0 — including the d = 8
> where J's criterion needs 51 moments — and Chasse settled d ≤ 2 × 10¹⁷ for all
> n in 2013 (**E8**). H3 measures the price of a criterion that is uniform in n
> and provable, against one that is a finite check with no uniformity at all.

## Hypotheses and notation

- n₀ is the first n at which the criterion holds; (8.2) is [O'S]'s P criterion and (2.9) is [GOR⁺]'s J criterion.
- Turán's Theorem III is the common criterion: Σ_{j=0}^{N−2} 2^j·j!·c_j² < 2^N·(N−1)!·c_N² in the Hermite basis.
- Driver `bin/h3_onset`, module `turan`.

## Proof / evidence

Numerical, with three checks recorded: [GOR⁺] Lemma 2.3's four identities hold to 40 digits across d = 2…12, n = 0…40; the criterion is sufficient wherever it holds (the discriminant route certifies the same polynomial); and a 120-digit recomputation of a(0)…a(2914) moves (2.9) at every n₀ by at most 3.0e−54.

## Dependencies and related results

- [[H3 from H_track.md](xihorn-h-track-h3-turan-onset.md) — the track's fuller account, including E19's qualification.
- [Turán's Theorem III](xihorn-h-track-turan-theorem-iii.md), [[GOR⁺] Theorem 1.1](xihorn-h-track-gor-theorem-1-1.md), [[O'S] Theorem 1.3](xihorn-h-track-os-theorem-1-3.md), [[GOR⁺] Lemma 2.3](xihorn-h-track-gor-lemma-2-3.md).
- [H6 — Ω search](xihorn-rust-results-h6-omega-search.md) — changes the reading of "d ≤ 400" (E19).

## Notes

- The source is explicit about the limit of the claim: "These are onsets of a *sufficient* criterion, not of hyperbolicity."
