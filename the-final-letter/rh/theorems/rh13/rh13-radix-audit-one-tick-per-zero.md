# The ℤ-radix audit: one tick per zero, on average and exactly

**Kind:** Claim
**Status:** VERIFIED (numerical; exact identity; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh13.html`](../../html/rh13.html) — §5 "The ℤ radix, audited"

## Statement

> The first ruling's register was the claim's other half: the phase winding θ/π ticks once per zero — the ℤ radix of the 2π base *is* the zero counter … Gram points are the register's tick marks: θ(g<sub>n</sub>) = nπ. The audit asks: does one tick hold one zero?

and the audit's reading:

> The exactly-one fraction falls from 0.897 (T ≤ 2000) to 0.757 (the 10⁶ band) — Gram's law weakens with height, as it must — while the compensation identity holds exactly at both: #(empty ticks) = #(double ticks) + 2·#(triple ticks); in the band, 7345 = 7161 + 2·92.

## Hypotheses and notation

- θ is the Riemann–Siegel theta function; Gram points g<sub>n</sub> satisfy θ(g<sub>n</sub>) = nπ.
- The phase register's winding is θ/π; one tick per zero is Gram's law.
- The compensation identity is #0 = #2 + 2·#3, where #k counts Gram intervals with k zeros; the source's dictionary row also writes it as 7345 = 7161 + 184.

## Proof / evidence

The source computes per-interval zero counts at both altitudes, reports the exactly-one fraction 0.897 (T ≤ 2000) falling to 0.757 (the 10⁶ band), and reports the compensation identity holding exactly at both heights (7345 = 7161 + 2·92 in the band, 59,994 intervals). It identifies the identity, "run as an algorithm", with Turing's method. The closing audit states: "Gram points by warm-started Newton at both altitudes, the one-tick-per-zero average to 2%, and the compensation identity #0 = #2 + 2·#3 holding exactly at both heights."

## Dependencies and related results

- [The incidence numbers are the von Mangoldt weights](rh13-incidence-numbers-are-von-mangoldt.md) — the other ruling's register, audited in §2.
- [The crossing form: signature (25, 0, 0)](rh13-crossing-form-signature.md) — what the scale register pairs into.
- rh6 §3's carry register and rh12's change-point census are the arc's earlier forms of the same audit.

## Notes


- The compensation identity is an exact bookkeeping statement over the enumerated Gram intervals (59,994 of them); the local law (one tick, one zero) is statistical and degrades with height, which the source attributes to the zeros' GUE repulsion.
- The source writes the identity both as 7345 = 7161 + 2·92 and (in the dictionary) as 7345 = 7161 + 184; these are the same statement.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
