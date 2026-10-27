# The conspiracy bound, which closes

**Kind:** Theorem
**Status:** PROVED (paper argument, unconditional)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §6 "The conspiracy bound, which closes", lines 1271–1314 and boxed table at lines 1316–1322

## Statement

> The control exists and it is elementary. An off-line quadruple at ½ ± σ ± iγ contributes 4 Re[ĥ(γ+iσ)<sup>2</sup>cos((γ+iσ)v)] to a row entry, which is at most 4|ĥ(γ+iσ)|<sup>2</sup>cosh(σv).
>
> ...
>
> Put the two together with Gershgorin — a perturbation ε in every row entry moves λ<sub>min</sub> by at most (2n−1)ε — and the result is a height above which the entire off-line population is irrelevant:
>
> Δ′ = 0.48   n = 39   λ<sub>min</sub> = 2.883×10<sup>−2</sup>   immune to everything above T = 4.34×10<sup>4</sup>
> Δ′ = 0.24   n = 76   λ<sub>min</sub> = 4.982×10<sup>−2</sup>   immune to everything above T = 5.02×10<sup>4</sup>
> Δ′ = 0.12   n = 151   λ<sub>min</sub> = 8.546×10<sup>−2</sup>   immune to everything above T = 9.48×10<sup>4</sup>
> Δ′ = 0.06   n = 301   λ<sub>min</sub> = 4.815×10<sup>−2</sup>   immune to everything above T = 2.21×10<sup>5</sup>
> Δ′ = 0.03   n = 601   λ<sub>min</sub> = 2.836×10<sup>−2</sup>   immune to everything above T = 4.81×10<sup>5</sup>
>
> So: above these heights, no configuration of off-line zeros — at any abscissa in the strip, in any arrangement, conspiring or not — can move the certified floor at all.

The source adds: "The worst of the five is 4.81×10<sup>5</sup>, and the zeros are known to lie on the line to 3×10<sup>12</sup>, six decades further up. rh29's obstruction is removed. No density estimate is used anywhere in it."

## Hypotheses and notation

- An off-line quadruple is a set of four zeros ½ ± σ ± iγ with σ ≠ 0, |σ| ≤ ½.
- The contribution to a row entry is 4 Re[ĥ(γ+iσ)<sup>2</sup>cos((γ+iσ)v)], bounded by 4|ĥ(γ+iσ)|<sup>2</sup>cosh(σv).
- Gershgorin: a perturbation ε in every row entry moves λ<sub>min</sub> by at most (2n−1)ε.
- T is the height above which every off-line zero is shown to be irrelevant; λ<sub>min</sub> is the certified floor at the stated support and section length.

## Proof / evidence

Paper argument, unconditional: combine the tail bound [rh30-tail-bound-inverse-fourth-powers](rh30-tail-bound-inverse-fourth-powers.md) with the strip-constant observation (sup γ<sup>4</sup>|ĥ(γ+iσ)|<sup>2</sup> within 0.6% of its on-line value) and Gershgorin, then solve for the height. No zero-density theorem and no hypothesis on where the zeros are is used. The source notes that Ingham's N(α,T) would improve the tail further but is not needed.

## Dependencies and related results

- [rh30-tail-bound-inverse-fourth-powers](rh30-tail-bound-inverse-fourth-powers.md) — the T<sup>−3</sup> / T<sup>−4</sup> tail bound used here.
- [rh29-offline-quadruple-exclusion-test](../rh29/rh29-offline-quadruple-exclusion-test.md) — rh29's single-quadruple test, whose obstruction this removes.
- rh30 §6 closing caveat: "What has not closed is the other direction. This bounds what off-line zeros could hide behind; it is not an argument that there are none."

## Notes

- The source states the result is unconditional ("no hypothesis about where the zeros are — only the counting function"), unlike the measure-picture results of §§2–5.
- The source flags that it does not strengthen rh29's exclusion test: "rh29's single-quadruple test excluded σ > 0.326 at γ = 107.17 and nothing here strengthens that."
