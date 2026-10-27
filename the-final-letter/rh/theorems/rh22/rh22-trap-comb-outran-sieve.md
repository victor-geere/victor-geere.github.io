# Trap 1 — the comb outran the sieve: rows past the sieve's reach are uncancelled pole

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §3 "Two traps, and the instrument", paragraph "Trap 1 · the comb outran the sieve"

## Statement

> The kernel is E(v) = pole + arch − comb, and at v = 18 the pole term 2B<sub>i</sub>²cosh(v/2) reaches 468. What cancels it is the prime comb, and the comb at v needs every prime power below e<sup>v+2δ</sup>. A sieve to 2×10⁵ supplies the δ = 0.03 comb only out to v = ln(2×10⁵) − 2δ = 12.15; past that the comb is simply empty and the row is uncancelled pole. Nothing announces this. Below the horizon the short sieve and the long one agree to 10<sup>−14</sup>, so the row looks entirely normal; the damage is confined to the last few entries, where it is largest. rh19 hit exactly this and fixed it; the fix did not survive into a new script. The section it produces at n = 51 fails its Cholesky at row 49 — precisely where v = 11.76 crosses the sieve's reach — and its true smallest eigenvalue is -1.8681.

## Hypotheses and notation

- E(v) = pole + arch − comb is the kernel; B<sub>i</sub> = ĥ(i/2).
- δ = 0.03; the comb at v needs every prime power below e<sup>v+2δ</sup>.
- "The sieve's reach" for a sieve to 2×10⁵ is v = ln(2×10⁵) − 2δ = 12.15.
- The section in question is n = 51.

## Proof / evidence

The source reports this as a diagnostic of its own first draft: the short and long sieves agree to 10<sup>−14</sup> below the horizon, the Cholesky fails at row 49 "precisely where v = 11.76 crosses the sieve's reach", and the true smallest eigenvalue is -1.8681 (as opposed to the +7.114×10<sup>-9</sup> the Levinson recursion reported — see [Trap 2](rh22-trap-levinson-lie.md)). The source states the mechanism and the numbers; it does not present a proof of a general proposition.

## Dependencies and related results

- [Trap 2 — the Levinson lie](rh22-trap-levinson-lie.md) is the companion instrument error that hid this one.
- rh19 encountered the same truncation and fixed it (source: "rh19 hit exactly this and fixed it; the fix did not survive into a new script").
- The instrument that detects it is the inertia bisection of [the instrument](rh22-instrument-inertia-bisection.md).

## Notes


- This is a diagnostic finding about a *failed draft*, reported "at the same prominence as the result". The source classifies the first draft's reading as "instrument error rather than arithmetic error".
- The exact values -1.8681 and 7.114×10<sup>-9</sup> are quoted as the source writes them.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
