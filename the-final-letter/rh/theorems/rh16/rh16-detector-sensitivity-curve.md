# The detector's sensitivity curve: δ_min = 3×10⁻⁴ at γ₁ rising to 0.092 at γ₁₀₀

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh16.html`](../../html/rh16.html) — §3 "What a disproof would cost", equation (2)

## Statement

> Take the kernel and move one ordinate off the real axis by δ — the Weil-form image of a zero leaving the critical line — keeping the count:
>
> E<sub>δ</sub>(v) = E(v) − 2B(γ)²cos(γv) + 2 Re[B(γ+*i*δ)² cos((γ+*i*δ)v)]
>
> which is even in δ, reduces to E at δ = 0, and carries a part growing like e<sup>δv</sup>. Since a positive-definite function is bounded by its value at 0, E<sub>δ</sub> must eventually fail; the question is when. Run the recursion and record k*, the first index with |ρ<sub>k</sub>| ≥ 1.

and the measured outcome:

> The measured horizon at γ₁₀ is **6.25**. The recursion is more than fifty times sharper than the boundedness bound … What is measured is v* = K(γ)δ<sup>−β</sup> with β itself growing with height (0.15, 0.35, 0.61), and, operationally, a detection threshold at this arc's own horizon: δ ≥ 0.0003 is visible at γ₁, but by γ₁₀₀ nothing under 0.092 is.

## Hypotheses and notation

- E is the merged kernel; B(γ) the mesh profile's transform at the displaced ordinate; δ the displacement off the real axis; the count of ordinates is kept.
- The horizon v = 12 is the document's own reach (a sieve to e¹² = 162754 gears); the fitted slopes are 0.15, 0.35 and 0.61 at three heights.
- The boundedness guess would have δv* constant at log(E(0)/2B(γ)²) ≈ 4, so δ = 0.01 would need horizon v ≈ 400.

## Proof / evidence

The source reports the measured horizons at three heights, the fitted law v* = K(γ)δ<sup>−β</sup>, the failure of universality of β, and the operational threshold curve: δ ≥ 0.0003 at γ₁ rising to 0.092 by γ₁₀₀, "a factor of 300 over a hundred ordinates". The cost statement: "Reaching horizon v requires the gear comb out to log n = v, i.e. a sieve to e<sup>v</sup>: every additional unit of horizon multiplies the arithmetic by e."

## Dependencies and related results

- [RH ⟺ the Schur sequence never leaves the open unit disc](../rh15/rh15-rh-equivalent-schur-sequence.md) — the criterion being used as a detector.
- [The widest positivity certificate](../rh15/rh15-widest-positivity-certificate.md) — the same recursion, at the same horizon 12.
- [The recursion prints the zeros](rh16-inverse-map-zeros-from-primes.md) — the document's other use of the recursion.
- rh15 §5's prediction error σ<sub>k</sub>² ~ 1/v² is what makes inconsistency visible early.

## Notes


- The source is careful with the claim: "That is a modest claim, but it is the first honest one of its kind here: a criterion is only as good as its sensitivity curve, and this is the curve."
- The threshold values are floating-point measurements of the recursion on a kernel known to a stated error bar.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
