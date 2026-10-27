# The counting function of the missing curve: N(q) = 1 + 1/(q²−1) + gear atoms

**Kind:** Proposition
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh12.html`](../../html/rh12.html) — §6 "What would render a base: the three constructions"

## Statement

> <b>The point count.</b> If Spec ℤ were a curve over 𝔽₁, it would count points over "𝔽<sub>q</sub>" for real q > 1 by the Weil recipe N(q) = q + 1 − ∑<sub>ρ</sub>q<sup>ρ</sup> … Computed from our 1517 zeros at a stated band limit, the function is not a mystery object; it *decomposes* … : a smooth baseline 1 + 1/(q²−1); upward atoms <b>exactly at the prime powers</b> with weight Λ(n) — verified at seven gears to 5%: <b>the points of the missing curve are the gears</b>; negative values confined below q = 1.03, the band-limited signature of the "infinite genus" … ; and windowed mean q + 1 to 15% — which is the prime number theorem, re-worn as "the curve has, on average, the point count of a projective line".

## Hypotheses and notation

- The Weil recipe N(q) = q + 1 − ∑<sub>ρ</sub>q<sup>ρ</sup> is taken, following the Connes–Consani program, as the definition of the point count; it is the Hasse–Weil formula inverted.
- The input is the arc's 1517 zeros at a stated band limit (band limit 60 in the figure).
- Λ is the von Mangoldt function; the atoms sit at the prime powers with Landau weights.

## Proof / evidence

The source reports the computation and its checks: the seven gear atoms at Landau weight plus the baseline verified to 5%; the PNT windowed mean at three windows to 15%; positivity beyond q = 1.03. It states plainly that the object "exists, computes, and says nothing the primes did not already say — that is both its beauty and the program's unfinished state in one measurement."

## Dependencies and related results

- [The explicit formula as a Lefschetz ledger](rh12-lefschetz-ledger-balance.md) — the companion computed shadow of the base in the same section.
- [The Riemann–Weil explicit formula](../rh10/rh10-riemann-weil-explicit-formula.md) — the arc's equation that underlies the decomposition.
- [The Lehmer-pair collision bound λ* = −0.00119](../rh11/rh11-lehmer-pair-collision-bound.md) and the 𝔽₁ grammar of rh11 §4–§5 feed the same program.

## Notes


- The reading "Spec ℤ is a curve over 𝔽₁" is hypothetical; what is computed is the counting function built from the arc's zero table at a band limit, not a curve.
- The source's own summary of the program: "What every candidate still owes is the same single clause: positivity on H¹."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
