# H3 — where the Turán criteria actually start to hold

**Kind:** Claim
**Status:** VERIFIED (numerical; 120-digit precision cross-check moves (2.9) by at most 3.0e−54)
**Area:** xi-horn
**Source:** [`xi-horn/H_track.md`](../../xi-horn/H_track.md) — §H3 "where the Turán criteria actually start to hold"

## Statement

> Both papers certify through the same theorem — Turán's Theorem III, [Tur59],
> quoted as [GOR⁺] (2.10) and [O'S] (8.1) … And both bound the onset only
> asymptotically — **n ≥ c·e^d** for J ([GOR⁺] Theorem 1.1, with **c never
> given**) and **n/log²n ≥ d^{3/4}/2** for P ([O'S] Theorem 1.3, "d large").
> Where it actually starts is a finite computation.
>
> ### The headline, and it is H2 again from the other side
>
> > **[O'S]'s criterion for P holds at n = 0 for every d ≤ 400.
> > [GOR⁺]'s for J holds at n = 0 only for d ≤ 7.**
>
> A factor of **57 in the degree reachable at no cost in n at all**. H2 measured
> the same asymmetry as 175× to 6.0e9× in tolerable enclosure width at fixed
> (d, n); this is the same fact in the currency of the criteria themselves. The
> crossing for P is sharp: (8.2) = **0.993195 at d = 400** and **1.000691 at
> d = 401**.

| d | 2 | 8 | 90 | 303 | 400 | 401 | 454 | 681 | 1021 |
|---|---|---|---|---|---|---|---|---|---|
| **P**: n₀ | 0 | 0 | 0 | 0 | 0 | — | 2 | 10 | 24 |
| **P**: (8.2) at n = 0 | 6.2e−8 | 6.9e−6 | 1.1e−2 | 0.430 | 0.993 | 1.001 | — | — | — |

| d | 3–7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|---|---|---|---|---|---|---|---|---|---|---|
| **J**: n₀ | 0 | 51 | 129 | 251 | 434 | 693 | 1048 | 1518 | 2126 | 2897 |

> Every J row is a genuine first crossing — (2.9) sits at 0.9983…0.9999 at n₀ and
> above 1 at n₀ − 1.
>
> - **Against the published bounds.** Where both are defined, [O'S] Theorem 1.3's
>   sufficient bound overshoots the true onset by **296× to 1602×**. [GOR⁺]'s
>   cannot be compared at all: no c is given. What can be said is that the
>   measured J onset grows *more slowly* than e^d over 8 ≤ d ≤ 16 — the implied c
>   falls from 0.0171 to 0.0003 — so the exponential regime their proof needs has
>   not begun at these degrees.
>
> **What it does not say.** These are onsets of a *sufficient* criterion, not of
> hyperbolicity. The discriminant route decides every cell in the small-d table
> at n = 0 — including the d = 8 where J's criterion needs 51 moments — and
> Chasse settled d ≤ 2 × 10¹⁷ for all n in 2013. What H3 measures is the price of
> a criterion that is *uniform in n and provable* against one that is a finite
> check with no uniformity at all.
>
> **And see E19**: H6 later showed that "d ≤ 400" is a property of [O'S]'s
> particular normalisation rather than of Ω = e^{−z²}. It moves as σ^{−4/3} under
> a rescaling, and to **10141** under a translation — both still legal choices of
> Ω, both leaving the comparison with [GOR⁺]'s 7 intact as a statement about the
> two *published* criteria and not about the two Ω.

## Hypotheses and notation

- (Tur) is Turán's Theorem III for G(z) = Σ_{j=0}^{N} c_j H_j(z): Σ_{j=0}^{N−2} 2^j·j!·c_j² < 2^N·(N−1)!·c_N² implies every zero of G is real and simple.
- For P the criterion is (Tur) with no transformation, [O'S] (8.2): Σ_{j=2}^{d} d/(2^j·j!)·C(d,j)·γ(n+j)²/γ(n)² < 1.
- For J it is applied after the renormalisation (2.3)/(2.6)–(2.9) of [GOR⁺], with Δ(M) := √( ½·(1 − γ(M−2)γ(M)/γ(M−1)²) ).
- n₀ is the first n at which the criterion holds; driver `rust/src/bin/h3_onset.rs`, module `turan`.

## Proof / evidence

Numerical: the onset is located by evaluating the printed criteria, with every J row checked to be a genuine first crossing ((2.9) at 0.9983…0.9999 at n₀, above 1 at n₀ − 1). Three implementation checks are recorded: [GOR⁺] Lemma 2.3's four identities hold to 40 digits across d = 2…12, n = 0…40; wherever either criterion holds the discriminant route certifies the same polynomial; and recomputing γ(0)…γ(2914) at 120 digits moves (2.9) at every n₀ by at most 3.0e−54 (the naive cancellation metric overstates by seventy decades).

## Dependencies and related results

- [Turán's Theorem III](xihorn-h-track-turan-theorem-iii.md) — the quoted criterion.
- [[GOR⁺] Theorem 1.1](xihorn-h-track-gor-theorem-1-1.md) and [[O'S] Theorem 1.3](xihorn-h-track-os-theorem-1-3.md) — the published bounds compared against.
- [[GOR⁺] Lemma 2.3](xihorn-h-track-gor-lemma-2-3.md) — the exact test the implementation is checked against, and what settles the Δ^d ambiguity.
- [H6 — the Ω search](xihorn-h-track-h6-omega-search.md) — E19's qualification of "d ≤ 400".

## Notes

- The source flags that these are onsets of a **sufficient criterion**, not of hyperbolicity; Chasse 2013 already has d ≤ 2 × 10¹⁷ for all n.
- The Δ^d of (2.6) belongs in the **denominator**; the paper's typography leaves it ambiguous and the wrong choice is wrong by a factor of Δ^{2d}.
