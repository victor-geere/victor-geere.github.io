# Beurling's majorant B: the functional equation B(z) + B(−z) = 2K(z) and a pole-free evaluation

**Kind:** Claim
**Status:** VERIFIED (numerical; functional equation to 5.6×10⁻¹⁷, B ≥ sgn to −1.7×10⁻¹³ over 400,000 samples; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh37.html`](../../html/rh37.html) — §3 "The machinery", boxed equation

## Statement

> Beurling's function B is the extremal majorant of the sign function: entire of exponential type 2π, B(x) ≥ sgn(x) everywhere, meeting sgn at every nonzero integer, with ∫(B − sgn) = 1 and no majorant of that type doing better.

> Two things had to be got right that recollection got wrong, and both were caught by measuring rather than citing. **B is B alone.** Writing B = H + K also majorises — K is the Fejér kernel and nonnegative — but with excess 2, handing away a factor of two before the argument starts; the integral said 1.993 and that is how it was found. And **the poles must be removed analytically**: B's defining bracket has a double pole at every non-positive integer that the sin² factor cancels, and doing that cancellation in floating point costs ten digits near each one. Reflection gives a pole-free form for z &gt; −1, and the functional equation
>
> B(z) + B(−z) = 2 K(z)
>
> carries it to the rest of the line. It holds here to 5.6×10<sup>−17</sup>. With that, B ≥ sgn is verified to −1.7×10<sup>−13</sup> over 400,000 offset samples, and exactly to zero out to |x| = 4000 where the sampled maximum is attained at the integers themselves.

## Hypotheses and notation

- B is Beurling's extremal majorant of sgn: entire of exponential type 2π, B ≥ sgn, touching sgn at every nonzero integer, with ∫(B − sgn) = 1.
- K is the Fejér kernel, nonnegative; H = B − K.
- The defining bracket of B has a double pole at every non-positive integer, cancelled by the sin² factor; reflection gives a pole-free form for z &gt; −1.

## Proof / evidence

Numerical: B = H + K majorises with excess 2 (the integral said 1.993), so B is taken alone; the functional equation B(z) + B(−z) = 2K(z) holds to 5.6×10⁻¹⁷; B ≥ sgn is verified to −1.7×10⁻¹³ over 400,000 offset samples and exactly to zero out to |x| = 4000, where the sampled maximum is attained at the integers.

## Dependencies and related results

- [rh37-selberg-bracket-deficiency](rh37-selberg-bracket-deficiency.md) — the bracket built from B.
- [rh37-worst-case-bounds-all-fail](rh37-worst-case-bounds-all-fail.md) — the two suggestions attached to the majorants, both refuted.
- rh30 §10 (b)'s call for Beurling–Selberg majorants; rh30 §5's three routes (Gershgorin, Koksma, Marcinkiewicz–Zygmund) lose linearly in the degree.
- [rh37-autocorrelation-decays-where-bounds-assume](rh37-autocorrelation-decays-where-bounds-assume.md) — why the machinery does not close the inequality.

## Notes


- §3 is a verified fact about two explicit entire functions and is unconditional.
- The source distinguishes the citation (Beurling's extremal property) from what was measured here (the numerical verification and the excess-2 correction).

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
