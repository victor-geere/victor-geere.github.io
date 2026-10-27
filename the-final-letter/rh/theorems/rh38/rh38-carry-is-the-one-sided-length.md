# The carry is ⌈γ/2π − ½⌉: the floor collapses at the square root of the turns per level

**Kind:** Claim
**Status:** VERIFIED (numerical, exactly for all 22,491 cached ordinates; carries sit at 2.42, 2.36, 2.47, 2.63; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh38.html`](../../html/rh38.html) — §7 "The pitch and the functional equation"

## Statement

> One consequence of (10) touches live work. The carry is a function of the torsion alone, and at a zero it is
>
> c(γ) = ⌈γ/2π − ½⌉,
>
> exactly, for every one of rh29's 22,491 cached ordinates: c − γ/2π never leaves (−½, ½] and averages 0.00017 turns. So the number of whole turns the thread makes per level at a zero *is* γ/2π — the one-sided length of the approximate functional equation. It is 2, 8, 38 and 226 at γ<sub>1</sub>, γ<sub>10</sub>, γ<sub>100</sub> and γ<sub>1000</sub>.

> That is the quantity rh36 refuted as the collapse law, its constant moving by 2.54× across four windows. What rh36 confirmed instead was knee = 2.221(γ/2π)<sup>0.531</sup>, the *balanced* length. Divide it by √c and it sits at 2.42, 2.36, 2.47, 2.63 as c runs from 2 to 226 — a spread of 1.11 over a hundredfold range, the drift being rh36's exponent 0.531 against a clean half.

> Stated geometrically: **the floor collapses at the square root of the number of turns the thread makes per level.** Whether that is more than a restatement is not settled here — γ/2π is the natural frequency scale of anything band-limited at height γ, and both quantities inherit it.

## Hypotheses and notation

- c(γ) is the uniform carry at the zero of ordinate γ; γ/2π is the one-sided length of the approximate functional equation.
- The knee is rh36's half-floor point; rh36's fit is knee = 2.221(γ/2π)<sup>0.531</sup>.
- 22,491 cached ordinates are from rh29's table; c runs from 2 to 226.

## Proof / evidence

Numerical: c(γ) = ⌈γ/2π − ½⌉ exactly for all 22,491 cached ordinates, with c − γ/2π in (−½, ½] averaging 0.00017 turns; the carry is 2, 8, 38, 226 at γ<sub>1</sub>, γ<sub>10</sub>, γ<sub>100</sub>, γ<sub>1000</sub>; knee/√c sits at 2.42, 2.36, 2.47, 2.63 over that range (spread 1.11).

## Dependencies and related results

- [rh38-uniform-lift-definition](rh38-uniform-lift-definition.md) — eq. (10), from which the carry formula follows.
- [rh36-collapse-forced-suppression](../rh36/rh36-collapse-forced-suppression.md) — the fitted knee and the refutation of the one-sided length as the collapse law.
- rh39 §9 (a) — the threshold, the sharp statement the source says this reading is handed to.

## Notes


- The source is explicit that it does not settle whether this is more than a restatement: γ/2π is the natural frequency scale of anything band-limited at height γ, and both quantities inherit it.
- §7 leans on rh29's table and rh36's fitted knee and is conditional in the same way every document since rh29 has been.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
