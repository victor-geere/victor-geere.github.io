# G2 — done. The frontier is a staircase, not a number

**Kind:** Claim
**Status:** VERIFIED (numerical; demand and supply columns from the certified pipeline)
**Area:** xi-horn
**Source:** [`xi-horn/rust/RESULTS.md`](../../xi-horn/rust/RESULTS.md) — Summary, "G2 — done. The frontier is a staircase, not a number"

## Statement

> **G2 — done. The frontier is a staircase, not a number.** G1 made both sides
> of the question numbers: demand is how tight an enclosure each criterion needs,
> supply is how tight one the certified quadrature delivers.
>
> **Demand**, extended from H2's d ≤ 6, n ≤ 30 to **d ≤ 10, n ≤ 140**:

| | at n = 0 | at n = 140 | cost of degree |
|---|---|---|---|
| **P** at d = 10 | 2.042e−12 | **2.085e−12** | 1.45 decades/d |
| **J** at d = 6 | 1.709e−15 | 1.115e−20 | 3.45 decades/d |

> P's demand is **flat in n over the whole range, and rising slightly** — H2 saw
> that to n = 30 and called it the property that decides G1; it holds to n = 140
> at every degree to 10. J's falls five decades over the same span at d = 6.
>
> Four cells are `prec` rather than a number: at d = 10, n ≥ 80, J's discriminant
> is undecidable at 60 digits **even from a zero-width enclosure**. The
> arithmetic's floor, not the criterion's demand, and labelled so —
> `max_tolerable_width_in` returning 0 means "cannot be decided here", not
> "needs nothing".
>
> **Supply** at V₀ = −14, h = 2⁻¹⁴, 252,317 nodes: 1.3028e−9 at n = 0 to
> **8.7396e−6 at n = 140**, rising like **n^2.23**. Pure h²/σ² would give n¹; the
> excess is the block term's extra a² = (2n+1)². The h² half is measured, not
> assumed: against a rule with h four times coarser at the same block width the
> ratio is 15.51, 16.00, 16.00, 16.00 — mean 15.88, **99% of 16**.
>
> **The crossing**, with every failure diagnosed rather than counted (each is
> re-certified from the tightest enclosure the scalar allows, to separate the
> bound from the precision; all of these are the bound):
>
> ```text
>     d  P to n  J to n   P needs @top      supplied
>     2     120     140       1.906e0      5.992e-6
>     4     120       0      6.190e-3      6.263e-6
>     6     120       —      1.087e-5      6.542e-6
>     7      20       —      3.269e-7      1.918e-7
>     8       0       —      8.775e-9      3.268e-8
>     9       —       —     1.979e-10      3.782e-8
> ```
>
> So at one h: **P to d = 6 across n ≤ 120**, d = 7 to n = 20, d = 8 at n = 0
> alone, nothing at d ≥ 9. J reaches d = 2 across the range, d = 3 to n = 40,
> d = 4 at n = 0 only. B1 published d ≤ 6, n ≤ 30 — conditionally.
>
> **The trade law.** Demand flat in n and falling 1.45 decades/d; supply costing
> h² and rising like n^2.23:
>
> ```text
> d_max(n, h)  =  const  −  (2/1.45)·log₁₀h  −  (2.23/1.45)·log₁₀n
> ```
>
> **0.41 degrees per halving of h**, **1.54 degrees lost per decade of n**. n is
> as expensive as d, which is why the frontier is a staircase.
>
> **What the next degrees cost** — h shrinks 5.3× per degree and nodes rise by
> the same factor, from four minutes at d = 6: d = 7 in 23 min, d = 8 in 2.0 h,
> d = 9 in 10.8 h, d = 10 in 2.4 days, d = 11 in 12.9 days.
>
> That is the practical frontier of an integral-to-certified-sign route, and not
> the frontier of hyperbolicity — Chasse settled d ≤ 2 × 10¹⁷ in 2013 (**E8**).
> The gap between d ≈ 8 and 2 × 10¹⁷ is the honest measure of what this pipeline
> is: a route demonstrated end to end, not an extension of what is known.

## Hypotheses and notation

- **Demand**: how tight an enclosure of a(n) each criterion needs, measured as `max width`; **supply**: how tight a one the certified quadrature of G1 delivers.
- d_max(n, h) is the frontier; the trade law is as displayed.
- `prec` marks cells undecidable at 60 digits even from a zero-width enclosure — `max_tolerable_width_in` returning 0 means "cannot be decided here".
- Driver `bin/g2_frontier` (≈ 5 min).

## Proof / evidence

Numerical, from the certified pipeline: demand over d ≤ 10, n ≤ 140; supply measured at 1.3028e−9 (n = 0) to 8.7396e−6 (n = 140), rising like n^2.23, with the h² scaling checked against a coarser rule (mean ratio 15.88, "99% of 16"). Every failure is re-certified from the tightest enclosure the scalar allows so that bound and precision are separated.

## Dependencies and related results

- [G1 — B1 without its conditional](xihorn-rust-results-g1-b1-without-conditional.md) — supplies the certified enclosure.
- [H2 — P^{d,n} and what it is worth to a certificate](xihorn-rust-results-h2-p-jensen-max-width.md) — the demand table extended here.
- [Chasse 2013 and GOR⁺ Corollary 1.3](xihorn-todo-e8-chasse-and-corollary-1-3.md) — **E8**, the reason the frontier is not a contribution.

## Notes

- G2 turned up **E16**: `certify_iv` stored a full relative width where `certify_in` stores a half, so every slack figure read half its true value. No verdict changed.
