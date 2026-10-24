# (1) The recombined radius bound ρ<sup>rec</sup><sub>p</sub>

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** rh-html
**Source:** [`rh23.html`](../../html/rh23.html) — §2 "(ii) The radius, and what governs it", equation (1)

## Statement

> The composite kernel is E<sub>h</sub>(pΔ) = Σ<sub>d</sub> w<sub>d</sub>E<sub>δ</sub>(8p−d), so it bounded the error of that sum term by term:
>
> (1) ρ<sup>rec</sup><sub>p</sub> = Σ<sub>d</sub> |w<sub>d</sub>| · [ (2/3)·δu + δ·7.8×10⁻¹⁶ ] · M<sub>δ</sub>(8p−d),
>
> with M<sub>δ</sub>(k) the gear mass within 2δ of the node kδ, and 2/3 = sup|C<sub>δ</sub>′| — rh19's Lipschitz constant for the cubic B-spline. rh22 measured that this costs 4.6× more than rh19's own direct rows at Δ = 0.24, and §7 proposed building the composite rows directly to recover it.

## Hypotheses and notation

- E<sub>h</sub> is the composite kernel of [rh22's identity (2)](../rh22/rh22-exact-kernel-linear-form.md), recombined from δ = 0.03 rows: E<sub>h</sub>(pΔ) = Σ<sub>d</sub> w<sub>d</sub>E<sub>δ</sub>(8p−d), Δ = 8δ.
- ρ<sup>rec</sup><sub>p</sub> is the proven radius of the prime comb at node p under recombination.
- M<sub>δ</sub>(k) is the gear mass within 2δ of the node kδ.
- δu is the shared error in ln m; 2/3 = sup|C<sub>δ</sub>′| is rh19's Lipschitz constant for the cubic B-spline; δ·7.8×10⁻¹⁶ is the per-term rounding term.

## Proof / evidence

The bound is assembled term by term from the recombined sum; the source states the construction and quotes the comparison with rh19's direct Δ = 0.24 rows (4.6× more expensive in radius, "which is the number rh22 measured"). The bound is used in rh22's §6 certificate lane and re-analysed in rh23 §2.

## Dependencies and related results

- [rh22's identity (2)](../rh22/rh22-exact-kernel-linear-form.md) is the recombination used.
- rh19's backend α and its certified-float bound; rh19's Lipschitz constant 2/3 = sup|C<sub>δ</sub>′|.
- Corrected interpretation in [The inference was wrong](rh23-direct-vs-recombined-bounds.md) and superseded in [The binned radius (3)](rh23-binned-radius.md).

## Notes

- The source corrects the *interpretation* of this bound: "rh22 read a property of the hat as a property of the route" ([rh23-direct-vs-recombined-bounds.md](rh23-direct-vs-recombined-bounds.md)). The bound (1) itself is not withdrawn.
- Quoted exactly as the source writes it, including the constants 2/3, 7.8×10⁻¹⁶.
