# The Lehmer-pair collision bound: λ* = −0.00119

**Kind:** Claim
**Status:** VERIFIED (numerical; validated dynamical model; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh11.html`](../../html/rh11.html) — §3 "Dig two — the hunt: pushing λ* toward the wall"

## Statement

> The three tightest pairs in range collide at λ* = −0.00119, −0.00330, −0.00486 — the best is three decades past rh10's reading, and every collision lands on the g²/8 law to 1%.

The source's abstract and summary state the corridor as "the corridor is now [−0.00119, 0] *as measured here*".

## Hypotheses and notation

- The zero table is extended to T = 2000: 1517 ordinates, scanned at step 0.05, audited in every 100-window against the Riemann–von Mangoldt count θ(T)/π + 1 (total expected 1516.99, found 1517), first ten matching published values to 10<sup>−7</sup>.
- The table's tightest pair is γ₁₄₉₆–γ₁₄₉₇ at gap 0.0975 (0.089 of the local mean spacing 2π/ln(t/2π)).
- λ* is the collision value of the backward-heat zero dynamics (equation (1)) for a pair; the wall is Λ ≥ 0 (Rodgers–Tao).

## Proof / evidence

The source describes the computation: the flow run as dynamics of the zeros (RK4 on an active window of 40 zeros with a frozen background field), validated against rh10's direct integral (ODE collision at λ* = −0.98899 against −0.9885 from Ξ, agreement 0.1%, inside the stated 8% acceptance), then applied to the three tightest pairs. The source's own hedge, quoted verbatim: "(Our λ* values are measurements of the validated dynamical model; the ladder's entries are rigorous bounds by construction, which is why they are cited beside our points rather than reproduced.)"

## Dependencies and related results

- [The collision-time law τ* = g₀²/8](rh11-collision-time-gap-law.md) — the law each collision obeys to 1%.
- [The first collision: γ₄, γ₅ merge at λ* = −0.9885](../rh10/rh10-first-collision-lambda-lower-bound.md) — the validation experiment.
- [The de Bruijn–Newman threshold](../rh10/rh10-de-bruijn-newman-threshold.md) — RH ⟺ Λ = 0, with Λ ≥ 0 by Rodgers–Tao.
- rh12 §3 extends the same hunt to t = 10⁶ (λ* = −2.27×10<sup>−5</sup>).

## Notes


- The λ* values are measurements of a validated dynamical model, not rigorous lower bounds; the source says so explicitly and quotes the literature's rigorous ladder separately as cited.
- The source's sober reading: the bound improves quadratically in the rarest gap found, while the rarest gap improves only logarithmically in table size, and the wall itself was reached by theorem, not by climbing.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
