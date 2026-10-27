# (3) The binned radius — a measure-weighted Lipschitz bound that beats both

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — 9.9× smaller than rh22's for the hat and 1.93× for the searched window)
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §2 "(ii) The radius, and what governs it", equation (3)

## Statement

> In the recombined sum the twenty-nine terms are evaluated at u<sub>d</sub> = ln m − pΔ + dδ, and the error in each comes from the *same* error in ln m — δu does not depend on d. So the first-order error of the whole sum is δu·Σ<sub>d</sub> w<sub>d</sub>C<sub>δ</sub>′(u<sub>d</sub>) = δu·C<sub>h</sub>′(v), v = ln m − pΔ. The per-term *rounding* does not share a sign pattern and keeps a local ℓ¹ norm, Q<sub>h</sub>(v) = Σ<sub>d</sub>|w<sub>d</sub>C<sub>δ</sub>(v−dδ)|. Splitting the support [0, 2Δ] into twenty-four bins and asking the sieve where the mass actually falls:
>
> (3) ρ<sup>bin</sup><sub>p</sub> = δu · Σ<sub>bins</sub> sup<sub>bin</sub>|C<sub>h</sub>′| · M<sub>Δ</sub>(p, bin) + 1.17×10⁻¹⁵ · Σ<sub>bins</sub> sup<sub>bin</sub>Q<sub>h</sub> · M<sub>Δ</sub>(p, bin).
>
> The result is 9.9× smaller than rh22's for the hat and 1.93× for the searched window — better than either of rh22's bounds, for both windows, at every section size.

## Hypotheses and notation

- u<sub>d</sub> = ln m − pΔ + dδ; δu is the error in ln m, shared by all twenty-nine recombined terms (the dictionary calls this "the shared logarithm error": "correlated first-order error").
- C<sub>h</sub>′(v) is the derivative of the composite spline; Q<sub>h</sub>(v) = Σ<sub>d</sub>|w<sub>d</sub>C<sub>δ</sub>(v−dδ)| is the local ℓ¹ norm multiplying the per-term rounding ("the local ℓ¹ norm").
- M<sub>Δ</sub>(p, bin) is the gear mass the sieve put in that bin at node p; the support [0, 2Δ] is split into twenty-four bins.
- 1.17×10⁻¹⁵ is the per-term rounding constant (same as in [equation (2)](rh23-direct-vs-recombined-bounds.md)).

## Proof / evidence

The mechanism, quoted verbatim:

> The mechanism is visible in the figure: sup|C<sub>h</sub>′| = 11.95 is attained in a narrow band near the spline's steepest point, and that band carries a small fraction of the gear mass. A supremum over a support is the wrong constant when the measure is not uniform.

The certificate is then built with this radius, and the radius is re-checked against the hat's known value (see [the certification of the hat at n = 76](rh23-certified-hat-n76.md)).

## Dependencies and related results

- Supersedes [the recombined bound (1)](rh23-recombined-radius-bound.md) and [the direct bound (2)](rh23-direct-vs-recombined-bounds.md) for both windows.
- rh19's backend α; the certified-float bound; the trapezoid aliasing radius inherited from rh22 and scaled by Σ|w<sub>d</sub>| (rh23 §5).
- Refined from 24 bins to 768 in [rh24's radius to its limit](../rh24/rh24-radius-limit-and-horizon.md).
- Extended with a tabulated-comb term in [rh25's binned radius with table error (6)](../rh25/rh25-binned-radius-table-error.md).

## Notes

- The bound is a *proven radius*; all quoted comparisons are the source's own.
- The source's dictionary glosses this object as "a measure-weighted Lipschitz bound".
