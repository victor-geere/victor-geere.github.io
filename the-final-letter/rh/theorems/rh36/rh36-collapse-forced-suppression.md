# The collapse is forced: the floor is a suppression factor, and its length is √(γ/2π)

**Kind:** Claim
**Status:** VERIFIED (numerical; fitted p = 0.531, C = 2.221, residual 0.3% in log); REFUTED (one-sided γ/2π as the collapse law; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh36.html`](../../html/rh36.html) — §5 "Why the collapse is forced"

## Statement

> H<sub>N</sub> is not an arbitrary normaliser: ∑1/n is exactly the mean square a *random-phase* Dirichlet polynomial with those coefficients would have. So the floor is a suppression factor — how far below chance the truncated zeta sits when it is read at the zeros of zeta. At twenty-four gears it is 3.34 times below; at sixty-four, 23.1; at eighty, 90.0.

> Put that way the collapse rh34 measured and could not explain stops being mysterious and starts being obligatory. A partial sum shortened far below the length at which it can resolve a zero knows nothing about that zero, and sits near chance. Lengthen it past that point and it begins to see what it is standing on.

> The length is measurable and it moves. Over four windows whose mean γ runs 91, 159, 331, 661 — a factor 7.3 — the half-floor point runs 9.15, 12.38, 18.28, 26.26. Fitting knee = C·(γ/2π)<sup>p</sup> gives **p = 0.531, C = 2.221**, with a residual of 0.3% in log. That is √(γ/2π), the balanced approximate functional equation's length. The one-sided γ/2π is refuted outright: its constant would have to move by a factor 2.54 across the same four windows, where the square root holds to 6.3%.

> Which settles the programme. A floor uniform in N would assert that the zeta partial sums cannot be small at the zeros. They are small at the zeros, from length ≈2.49√(γ/2π) onward, for the plainest reason available. rh32's lemma was not merely unproven and then refuted twice; it was asking a bounded quantity to stay away from a value it is converging to.

## Hypotheses and notation

- The floor is λ<sub>min</sub>/E(0); H<sub>N</sub> = ∑1/n normalises it to a suppression factor relative to a random-phase polynomial.
- The knee is the half-floor point; four windows with mean γ 91, 159, 331, 661.
- The two candidate lengths: the balanced √(γ/2π) and the one-sided γ/2π.

## Proof / evidence

Numerical: suppression factors 3.34, 23.1, 90.0 at N = 24, 64, 80; half-floor points 9.15, 12.38, 18.28, 26.26 over mean γ 91, 159, 331, 661; fitted p = 0.531, C = 2.221, residual 0.3% in log; the one-sided form would move its constant by a factor 2.54, the square root holds to 6.3%.

## Dependencies and related results

- [rh36-the-vector-is-the-zeta-partial-sum](rh36-the-vector-is-the-zeta-partial-sum.md) — the object whose suppression this is.
- [rh34-no-uniform-dirichlet-floor](../rh34/rh34-no-uniform-dirichlet-floor.md) — the collapse this section explains as obligatory.
- [rh38-carry-is-the-one-sided-length](../rh38/rh38-carry-is-the-one-sided-length.md) — rh38 §7 reads the same carry as the one-sided length and the knee as √c.
- [rh39-profile-one-minus-x](../rh39/rh39-profile-one-minus-x.md) — rh39 fits a profile to the collapse and finds its second variable.

## Notes


- §9 (c) flags the fit as thin: four windows, and the 6% excess over a clean 0.500 is probably real rather than noise but could be an artifact of measuring the knee by half-height.
- The section's conclusion is a negative result about the arc's own programme: any attempt to bound λ<sub>min</sub> of this Gram matrix away from zero, uniformly in ladder length, is asking for something false.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
