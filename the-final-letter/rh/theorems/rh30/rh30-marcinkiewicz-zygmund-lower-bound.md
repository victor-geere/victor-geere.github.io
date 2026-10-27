# Route two: Marcinkiewicz–Zygmund, through the arcs

**Kind:** Proposition
**Status:** PROVED (paper argument, using Bernstein's inequality; classical)
**Area:** rh-html
**Source:** [`rh30.html`](../../html/rh30.html) — §5, subsection "Route two: Marcinkiewicz–Zygmund, through the arcs", lines 1139–1155

## Statement

> Compare the atoms to the uniform measure through their own arcs instead. If the retained atoms cut the circle into arcs ℓ<sub>j</sub> with η = max ℓ<sub>j</sub>, then ∑ℓ<sub>j</sub>q(θ<sub>j</sub>) ≥ 2π(1 − (n−1)η) by the same Bernstein inequality, and
>
> λ<sub>min</sub>(T<sub>n</sub>) ≥ 2π · min<sub>j</sub>(w<sub>j</sub>/ℓ<sub>j</sub>) · (1 − (n−1)η).
>
> This has a genuine trade-off in it: keeping more atoms shrinks η and extends the reach, but drags min(w/ℓ) down towards the lightest atom kept. Sweeping the retention threshold, it reaches n = 228 at Δ′ = 0.12, against Gershgorin's 28 and Koksma's 12 — three to eight times further than anything the arc has had.

The source's later verdict on its reach: "Its reach is roughly constant in the window — 228 to 319 — while the certified depth is 18/Δ′ + 1 and runs to 601, so it survives at the three widest supports and dies before the certificate at the two narrowest. Where it does survive, its value is between 7.8×10<sup>−6</sup> and 1.7×10<sup>−4</sup> of the truth."

## Hypotheses and notation

- The retained atoms cut the circle into arcs ℓ<sub>j</sub>; η = max ℓ<sub>j</sub>; w<sub>j</sub> are the atom weights.
- q is a trig polynomial of degree n−1 with unit coefficients (the same class as in route one).
- T<sub>n</sub> is the Toeplitz section.

## Proof / evidence

Paper argument, from the same Bernstein inequality as route one, via the arcs rather than the discrepancy. The reach figures (n = 228 at Δ′ = 0.12; 228 to 319 across the window) and the value ratios are numerical.

## Dependencies and related results

- [rh30-koksma-lower-bound](rh30-koksma-lower-bound.md) — route one, with its reach 1 + N<sub>eff</sub>/π.
- [rh30-loss-splits-into-weights-and-positions](rh30-loss-splits-into-weights-and-positions.md) — the arc picture this route uses.
- rh30 §5 "The verdict" — both routes lose linearly in n; that verdict is the source's stated negative result.

## Notes

- The source states that this bound also loses linearly in n and dies before the certificate at the two narrowest supports, so the reach figures are not a win over the certified depth everywhere.
