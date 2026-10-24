# The weight at the zeros — the searched optimum reaches a geometric-mean weight of 1.138×10<sup>-2</sup>, 1691× the hat

**Kind:** Theorem
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §6 "The certificate, and what the gain buys", paragraph "The weight at the zeros"

## Statement

> Scored on rh21's own statistic — the geometric mean of |ĥ(γ)|² over the first forty zeros at unit energy — the hat gives 6.729×10<sup>-6</sup>, rh21's Slepian in this family 1.615×10<sup>-4</sup>, and the optimum 1.138×10<sup>-2</sup>: a factor 1691 over the hat, against the 62× rh21 measured for a continuous Slepian. rh21's barrier w ≤ πC(0)/T = 2.5552×10<sup>-2</sup> still holds, as it must for every compactly supported window, but the room under it has almost gone: the hat sat 3797× under, rh21's Slepian 158×, the optimum 2.25×.

## Hypotheses and notation

- |ĥ(γ)|² is the squared transform of the window at the zero height γ; the statistic is the geometric mean over the first forty zeros at unit energy.
- The three windows compared all have the same support Δ = 0.24 and the same energy C<sub>h</sub>(0) = 2Δ/3 = 0.16.
- rh21's barrier is w ≤ πC(0)/T = 2.5552×10<sup>-2</sup>; the source notes it "was proved for every compactly supported window".

## Proof / evidence

The measurement is checked in two ways, quoted verbatim:

> Two things are checked to make sure this is not a normalisation artifact: Parseval, ∫<sub>0</sub><sup>∞</sup>|ĥ|² = πC<sub>h</sub>(0), holds numerically for all three windows; and no single weight exceeds 2Δ, which Cauchy–Schwarz forces on the support.

The source also reports, "without being leaned on", that "The minimum over the forty zeros also improves by more than four orders, and is reported without being leaned on — rh21 showed the minimum is a lottery on where the nulls fall."

## Dependencies and related results

- rh21's zeros-side statistic and its universal barrier πC(0)/T.
- rh21's Slepian gain of 62× for a continuous Slepian, compared against the 1691× found here in the spline family.
- The geometry behind the number: an exactly even spread of |ĥ|² across the low zeros would give a mean weight of 2.887×10<sup>-2</sup>, and the optimum's mean is 2.946×10<sup>-2</sup>, "or 1.02 of even".

## Notes


- This is a *measured* statistic, not a certified one; it is quoted with the source's own figures and no precision claim beyond the decimals printed.
- rh22 §2 classifies exactly this kind of statement as "Class C · measured, not proved", naming "this document's larger one [Slepian gain]" among results that are "Real numbers, honestly fitted, and none of them a theorem."

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
