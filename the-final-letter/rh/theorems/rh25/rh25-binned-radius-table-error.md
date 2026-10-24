# (6) The binned radius with the table's own error charged panel by panel — 23%

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — radius 2.4023×10<sup>-11</sup> → 2.9653×10<sup>-11</sup> for the hat)
**Area:** rh-html
**Source:** [`rh25.html`](../../html/rh25.html) — §2 "(b) The certified comb for a smooth window", equation (6)

## Statement

> **What it costs the certificate** is the number that matters, and it has to be charged correctly. The table's error is not a single global bound: it is a per-panel quantity, small where V<sub>c</sub> is small, and it enters the comb row exactly as the arithmetic rounding does — through a local ℓ¹ norm of the weights against the gear mass. Adding a third term to rh23's binned radius,
>
> (6) ρ<sup>bin</sup><sub>p</sub> = δu·Σ<sub>bins</sub> sup|C<sub>h</sub>′|·M<sub>Δ</sub>(p, bin) + ε·Σ<sub>bins</sub> sup Q<sub>h</sub>·M<sub>Δ</sub>(p, bin) + Σ<sub>bins</sub> sup Q<sup>tab</sup><sub>h</sub>·M<sub>Δ</sub>(p, bin),
>
> with Q<sup>tab</sup><sub>h</sub>(u) = Σ<sub>d</sub>|w<sub>d</sub>|·err(panel of u − dδ), the radius at n = 76 goes from 2.4023×10<sup>-11</sup> to 2.9653×10<sup>-11</sup> for the triangle hat — 23% — and by at most 23% over the generators certified here. What is left is not the interpolation, which auto-refinement has driven below the floor, but the double-rounding of the table's own coefficients, which no float table can beat and which the arc's existing ε already charges for the cubic. rh23's 768-bin radius for the hat is reproduced exactly at c = 0 before any of this is used.

## Hypotheses and notation

- ρ<sup>bin</sup><sub>p</sub> is [rh23's binned radius](../rh23/rh23-binned-radius.md), extended by a third summand (the dictionary's "Q<sup>tab</sup><sub>h</sub> = Σ<sub>d</sub>|w<sub>d</sub>|·err(panel of u − dδ)").
- M<sub>Δ</sub>(p, bin) is the gear mass in a bin at node p; Q<sub>h</sub> is the local ℓ¹ norm for arithmetic rounding; Q<sup>tab</sup><sub>h</sub> is the table's contribution, proportional to |V<sub>c</sub>| panel by panel.
- The radius is quoted at n = 76 for the triangle hat: 2.4023×10<sup>-11</sup> → 2.9653×10<sup>-11</sup> (23%).

## Proof / evidence

The table error is bounded per panel and binned against the gear mass exactly as Q<sub>h</sub> is; the source verifies the anchor at c = 0 ("rh23's 768-bin radius for the hat is reproduced exactly at c = 0 before any of this is used"). The residual error is attributed to the double-rounding of the table's own coefficients, which "the arc's existing ε already charges for the cubic".

## Dependencies and related results

- [rh23's binned radius](../rh23/rh23-binned-radius.md) and [rh24's 768-bin refinement](../rh24/rh24-radius-limit-and-horizon.md).
- [The certified table (4)–(5)](rh25-certified-table-cost.md) supplies err(panel).
- Used by [the certified floors of equation (11)](rh25-certified-floors-v18.md).

## Notes

- The charge is 23% on the radius, quoted exactly; the source stresses the interpolant itself is below the floor and that what remains is a floor "no refinement can cross".
- rh24 had priced the smooth comb at "six transcendentals where a cubic costs three multiplications"; this file's route is what makes the smooth window certifiable at all (§1: "until the comb can be evaluated over six and a half million gears both cheaply and certifiably there is nothing to search").
