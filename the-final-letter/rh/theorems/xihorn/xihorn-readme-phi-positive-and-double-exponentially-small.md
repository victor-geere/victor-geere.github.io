# The weight is positive on ℝ and double-exponentially small

**Kind:** Claim
**Status:** VERIFIED (numerical; asymptotic form as stated; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/README.md`](../../xi-horn/README.md) — §1 "The weight", second and third properties

## Statement

> * **Positive.** Φ(u) > 0 on ℝ.
> * **Double-exponentially small.** Φ(u) ~ 2π²e^{9u/2}e^{−πe^{2u}} as u → +∞.
>
> ...
>
> **The entire object lives in |u| ≤ 1.5.** That is the point of the whole exercise; see §6.
>
> Also useful: `∫₀^∞ Φ(u) du = 0.1242801945`.

## Hypotheses and notation

- Φ(u) = Σ_{n≥1} (2π²n⁴·e^{9u/2} − 3πn²·e^{5u/2})·e^{−πn²·e^{2u}} is the horn's weight (equation (1)); it is even.
- The asymptotic Φ(u) ~ 2π²e^{9u/2}e^{−πe^{2u}} is the u → +∞ behaviour, dominated by the n = 1 shell.
- ∫₀^∞ Φ(u)du = 0.1242801945 is the total mass of the one-sided weight, equal to the arc length of each thread (§4).

## Proof / evidence

The source lists these as two of the three properties of the weight, "all verified numerically below", and gives the table of Φ(u) at u = 0.0 … 1.6 (0.4466969005 down to 8.752056431e−30) from which positivity over the drawn range and the double-exponential decay are read. The total mass ∫₀^∞ Φ = 0.1242801945 is quoted in the same section and used in §4 as the arc length of each thread.

## Dependencies and related results

- The weight's definition and evenness: [xihorn-readme-phi-even-is-theta-functional-equation.md](xihorn-readme-phi-even-is-theta-functional-equation.md).
- The truncation consequence of the double-exponential decay: [xihorn-readme-truncation-trade-bounded-picture.md](xihorn-readme-truncation-trade-bounded-picture.md).
- The threads whose arc length is ∫₀^∞Φ: [xihorn-readme-two-threads-and-xi-real-part.md](xihorn-readme-two-threads-and-xi-real-part.md).

## Notes


- The source says "all verified numerically below" for the three properties; positivity and the asymptotic are numerical/analytic observations here, not certified interval statements.
- The property list is presented under the heading of equation (1), which is a definition; only the two stated properties are harvested.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
