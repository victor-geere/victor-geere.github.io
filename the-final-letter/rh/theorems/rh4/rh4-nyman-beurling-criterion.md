# Theorem (Nyman–Beurling)

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh4.html`](../../html/rh4.html) — §16 "Gap-filling is the Beurling–Nyman criterion", theorem box at lines 650–653

## Statement

> RH ⟺ the indicator function of (0, 1] lies in the <i>L</i>²-closure of the span of the functions ρ<sub>θ</sub>(<i>x</i>) = {θ/<i>x</i>} − θ{1/<i>x</i>}, 0 &lt; θ ≤ 1.

## Hypotheses and notation

- {·} is the fractional part; the functions ρ<sub>θ</sub> are indexed by 0 &lt; θ ≤ 1.
- The closure is taken in <i>L</i>²; the target is the indicator function of (0, 1].
- RH = Riemann Hypothesis.
- The source's reading: {θ/<i>x</i>} "is exactly the gap the integer gear train leaves at scale θ: what remains of θ/<i>x</i> after the integers have taken their full turns".

## Proof / evidence

CITED: the source attributes the theorem to Nyman (1950) and Beurling (1955) and gives no proof. It records the sharpening:

> Báez-Duarte (2003) sharpened it: integer dilations θ = 1/<i>k</i> suffice.

and the quantitative rate: with dilations 1/<i>k</i>, <i>k</i> ≤ <i>N</i>, the best mean-square error is known to be at least (<i>C</i> + o(1))/log <i>N</i> with <i>C</i> = Σ<sub>ρ</sub> |ρ|<sup>−2</sup> = 2 + γ<sub>Euler</sub> − log 4π ≈ 0.0231, and conjecturally exactly that.

## Dependencies and related results

- Axiom 7 of the construction introduces the retuning factors λ<sub><i>n</i></sub> "solely to close gaps on the number line"; §16 identifies that demand with this criterion: "the retuning axiom, which looked like bookkeeping, is in fact a restatement of the hypothesis itself".
- rh4 §18 lists this among the dictionary entries that are "an exact restatement of RH".

## Notes

- CITED: attributed to Nyman (1950) and Beurling (1955), with the Báez-Duarte (2003) sharpening; no proof is given.
- The source warns that even under RH the gaps close at rate 1/log <i>N</i>, "slower than any power", with the constant governed by a sum over the closures.
- The constant is quoted exactly: <i>C</i> = 2 + γ<sub>Euler</sub> − log 4π ≈ 0.0231.
