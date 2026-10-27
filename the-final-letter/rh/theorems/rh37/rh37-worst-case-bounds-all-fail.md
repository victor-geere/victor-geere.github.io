# The gap idea fails by saturating, and Fejér's √n bound is worse than Gershgorin

**Kind:** Claim
**Status:** REFUTED (both suggestions of rh30 §10 (b), by measurement)
**Area:** rh-html
**Source:** [`rh37.html`](../../html/rh37.html) — §5 "The gap idea", §6 "The q ≥ 0 idea"

## Statement

> rh30 §10 (b)'s first suggestion: a bound "that localises to the largest gap instead of taking a worst case round the whole circle." Its sharp form is an uncertainty principle rather than a variation bound — a nonnegative trig polynomial of degree n − 1 can put nearly all its mass in one arc of length about 1/n, and in no less. So the adversary gets *one* hiding place, and the quantity is the **avoidable mass**: the weight that survives the best window of width 1/n.

> It fails, and it fails by saturating. At the 0.12 window the avoidable mass is 0.9455 at n = 24 and 0.9847 by n = 512, while the truth over the same range falls to 0.0024. The ratio of truth to avoidable mass runs from 2.05 at n = 2 to 0.0024 at n = 512 — three decades, moving the wrong way — and past n = 8 the avoidable mass never drops below 0.858 at any depth.

> The reason is countable. There are 8,616 atoms on the circle, so a window of width 1/n contains almost none of the mass at any depth worth having. The minimising polynomial is not hiding in a gap. It is small at many atoms at once, which is a different thing and not a localisation at all.

> The second suggestion, and the one rh30 wanted most: "an inequality that uses q = |p|² ≥ 0 rather than only its variation." There is a clean one, and it is Fejér's own extremal problem. A nonnegative trig polynomial of degree n − 1 with mean 1 has sup q ≤ n, attained by the Fejér kernel; hence ‖q‖₂² ≤ n, and Cauchy–Schwarz gives
>
> λ<sub>min</sub>/E(0) ≥ 1 − √(n−1) ( 2 ∑<sub>0&lt;k&lt;n</sub> (E(kΔ)/E(0))² )<sup>1/2</sup>
>
> — √n where Gershgorin has n, using nonnegativity and nothing else. It is exactly the shape rh30 asked for.
>
> **It is worse.** At the 0.12 window Gershgorin survives to n = 24 and this dies at 16; at 0.03, where the arc has the most room, Gershgorin reaches 96 and this reaches 64. At no window of the five does it beat Gershgorin. The √n is real, but it is bought by trading max|E| for the ℓ² norm of the whole row, and the row does not decay fast enough to pay for the trade.

## Hypotheses and notation

- The avoidable mass is the weight surviving the best window of width 1/n on the circle; 8,616 atoms.
- q = |p|² ≥ 0 is a nonnegative trig polynomial of degree n − 1 with mean 1; Fejér's extremum sup q = n is attained by the Fejér kernel.
- Five windows compared; Gershgorin's bound is the baseline.

## Proof / evidence

Numerical: avoidable mass 0.9455 at n = 24 and 0.9847 by n = 512 against a truth falling to 0.0024, ratio running from 2.05 to 0.0024, never below 0.858 past n = 8; the Fejér/Cauchy–Schwarz bound dies at n = 16 (0.12 window) and n = 64 (0.03 window) where Gershgorin reaches 24 and 96, and never beats Gershgorin at any of the five windows.

## Dependencies and related results

- [rh37-autocorrelation-decays-where-bounds-assume](rh37-autocorrelation-decays-where-bounds-assume.md) — the common single step this section's two failures share.
- rh30 §10 (b) — the two suggestions tested here; rh30 §5 — the three routes that lose linearly in the degree.
- [rh39-annihilator-is-a-genuine-bound](../rh39/rh39-annihilator-is-a-genuine-bound.md) — rh39's annihilator bound, another bound of the same loose shape.

## Notes

- Both failures are measured, not proved in general; the source says the shared cause is the one-step worst case, and that a fifth attempt of the same kind can now be predicted to fail before it is run.
- §4's regression (§2) rebuilds rh30 from the zeros first: Gershgorin positive at n = 24 (0.1365) and negative at n = 32 (−0.5142); rh30 §3's published point λ<sub>min</sub>/Eh(0) = 0.2846 at n = 151 sits between 0.3265 at n = 128 and 0.1539 at n = 192.
