# The truncation trade — the horn decides from a bounded picture, the helix cannot

**Kind:** Claim
**Status:** VERIFIED (numerical; evidence absent; the source is prose only, no committed evaluator)
**Area:** xi-horn
**Source:** [`xi-horn/README.md`](../../xi-horn/README.md) — §6 "Why bother — the truncation argument"

## Statement

> This is the one place the new object is strictly, quantitatively better than the helix, and the reason to build it.
>
> The helix's partial sums satisfy `|P_N − η(s)| → N^{−σ}/2` exactly, independent of *t* — half the radius of the last drawn gear. To decide closure to 1e−16 at σ = ½ requires
>
> ```
> N ≳ 2.5 × 10^31 gears.
> ```
>
> No finite drawing decides anything; the miss and the residual are always the same size.
>
> The Ξ horn's integrand dies double-exponentially. Truncating at |u| = 1.5 costs
>
> ```
> ∫_{1.5}^{∞} Φ ≈ 1e−19 ,
> ```
>
> so the object is **bounded, and closure is decidable from the whole picture.** The table in §4 was computed on u ∈ [0, 1.6].
>
> That is the entire trade: the helix shows you the integers and cannot decide; the horn decides and shows you no integers.

## Hypotheses and notation

- P_N are the helix's partial sums, η(s) the alternating (Dirichlet eta) series; the miss satisfies |P_N − η(s)| → N^{−σ}/2 exactly, independent of t.
- σ = Re s; at σ = ½ the decision tolerance quoted is 1e−16, requiring N ≳ 2.5×10^31 gears.
- The horn's truncation cost is ∫_{1.5}^{∞} Φ ≈ 1e−19, from the double-exponential decay of Φ.
- The §4 table is computed on u ∈ [0, 1.6].

## Proof / evidence

The source compares two truncation behaviour: the helix's exact miss law |P_N − η(s)| → N^{−σ}/2 (from the arc's earlier work on rh3), giving N ≳ 2.5×10^31 for a 1e−16 decision at σ = ½; and the horn's tail ∫_{1.5}^{∞}Φ ≈ 1e−19, which makes closure decidable from a bounded picture. Both quantities are stated numerically.

## Dependencies and related results

- The double-exponential decay of Φ: [xihorn-readme-phi-positive-and-double-exponentially-small.md](xihorn-readme-phi-positive-and-double-exponentially-small.md).
- The companion warning in §8 that the trade removes the integers from view: "the horn decides and shows you no integers".
- The dictionary's restatement of the same comparison ("effectively |u| ≤ 1.5"): README §10.

## Notes


- This is a comparison of two methods with numerical estimates, not a theorem; the source presents it as "the entire trade".
- The source's §8 also records the four things the construction does not do, including "**2. Positivity is still the wall**" — the Weil pairing and the certified floors of rh19–rh27a are unaffected.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
