# The destruction: rh30's collapse fails off the searched family

**Kind:** Proposition
**Status:** REFUTED (rh30's one-coordinate law; it holds on the searched five)
**Area:** rh-html
**Source:** [`rh31.html`](../../html/rh31.html) — §3 "The destruction", lines 402–435 and boxed bin table at lines 964–968

## Statement

The refuted statement (from rh30 §3, as quoted in this document):

> rh30's collapse was measured on five windows — all five produced by the arc's own optimiser. The destruction grid adds eleven families no optimiser touched: the bare envelope (A ≡ const), six random coefficient vectors drawn uniformly from the same sphere, and four interpolations between the searched window and fresh random draws. Sixteen families spanning N<sub>eff</sub> from 7.0 to 467, three meshes, seven depths: 336 certificates-that-could-have-been.

The result of the test:

> bin [0.03, 0.1)   searched 1.14×   all sixteen 2.21×
> bin [0.1, 0.3)   searched 1.93×   all sixteen 4.11×
> bin [0.3, 1.0)   searched 2.97×   all sixteen 7.04×
>
> On the searched family alone the law holds exactly as published — spread 1.93× in the bin [0.1, 0.3), matching rh30's 1.99× on a different grid. Over all sixteen families the same bin spreads 4.11×, and even the early bin [0.03, 0.1) opens from 1.14× to 2.21×. The worst offender is a random window at n/N<sub>eff</sub> = 0.29: λ/E<sub>h</sub>(0) = 0.241, half the searched band's floor at the same coordinate.
>
> So rh30's one-coordinate law is a property of the searched windows, not of the measure. rh30 asked for exactly this test before anyone attempted a proof; the answer is that there is nothing there to prove in one variable. N<sub>eff</sub> is a functional of the *weights* alone. What it cannot see is where the weights land.

## Hypotheses and notation

- The refuted claim is [rh30-collapse-in-n-over-neff](../rh30/rh30-collapse-in-n-over-neff.md): λ<sub>min</sub>/E<sub>h</sub>(0) is a function of n/N<sub>eff</sub> to within 1.99× for n/N<sub>eff</sub> < 0.3.
- A ≡ const is the bare envelope window; the random coefficient vectors are drawn uniformly from the same sphere; the interpolations lie between the searched window and fresh random draws.
- The grid is 16 families × 3 meshes × 7 depths = 336 certificates.

## Proof / evidence

Numerical refutation by construction: the sixteen-family grid spreads the same bins by 2.21×, 4.11×, 7.04× against the searched family's 1.14×, 1.93×, 2.97×, with a random window at n/N<sub>eff</sub> = 0.29 at λ/E<sub>h</sub>(0) = 0.241.

## Dependencies and related results

- [rh30-collapse-in-n-over-neff](../rh30/rh30-collapse-in-n-over-neff.md) — the law this refutes off its native family.
- [rh31-anchored-discrepancy-refuted](rh31-anchored-discrepancy-refuted.md) — §4's attempted repair coordinate, also refuted.
- [rh31-emptiest-arc-law](rh31-emptiest-arc-law.md) — the law that survives the destruction.

## Notes

- The source states the searched-family numbers still hold "exactly as published"; only the generalisation is refuted. The status REFUTED applies to the law as a statement about the measure, not to the five searched windows' readings.
- rh30 §10(a) had asked for this test ("the collapse can be tested to destruction on a much larger grid before anybody tries to prove it").
