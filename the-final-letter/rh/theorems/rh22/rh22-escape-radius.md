# The escape radius (5) — r* = 3.7749×10<sup>-4</sup>, 6.57×10<sup>4</sup>× rh19's best

**Kind:** Theorem
**Status:** PROVED (paper argument; VERIFIED (numerical) — certified floor divided by K<sub>lin</sub>, with all norms charged against the new window)
**Area:** rh-html
**Source:** [`rh22.html`](../../html/rh22.html) — §6 "The certificate, and what the gain buys", equation (5)

## Statement

> rh18's T3 turns a certified floor into a ball of genuinely non-lattice windows around the certified configuration, of radius r* = m₀/K<sub>lin</sub>. K<sub>lin</sub> was derived for the triangle hat, so every C<sub>h</sub>-derived norm inside it is inflated here by Θ = max(1, ‖w‖₁/‖w<sub>hat</sub>‖₁) — the worst-case amplification, charged against every term at once and never allowed to work in the new window's favour. It comes out at Θ = 1, so the improvement is carried entirely by m₀ and by B<sub>i</sub>. The hat's own r* recomputed this way is 5.7424×10<sup>-9</sup> against rh19's published 5.74×10<sup>-9</sup>. The optimum reaches
>
> (5) r* = 3.7749×10<sup>-4</sup> at Δ = 0.24, n = 18, a = 2.28 — 6.57×10<sup>4</sup>× rh19's best.

## Hypotheses and notation

- m₀ is a certified floor (equation (4)); K<sub>lin</sub> is rh18's linearisation constant, derived for the triangle hat; r* = m₀/K<sub>lin</sub>.
- Θ = max(1, ‖w‖₁/‖w<sub>hat</sub>‖₁) is the worst-case amplification charged against every term at once.
- B<sub>i</sub> = ĥ(i/2) is the transform at the pole; a is the half-support (a = 2.28 here).
- The corner is the same one rh19 found: coarsest mesh, smallest support, because K<sub>lin</sub> grows like e<sup>a</sup> while the floor decays.

## Proof / evidence

The computation is arithmetic from the certified floor and rh18's T3, with the inflation factor chosen adversarially:

> The hat's own r* recomputed this way is 5.7424×10<sup>-9</sup> against rh19's published 5.74×10<sup>-9</sup>.

The source's own caveat on what the gain means, quoted verbatim:

> A 6.57×10<sup>4</sup>× escape radius is still 3.7749×10<sup>-4</sup> — a ball around the lattice, not a neighbourhood of the line.

## Dependencies and related results

- rh18's T3 (escape ball of non-lattice windows) and K<sub>lin</sub>.
- [m₀ certified — (4)](rh22-certified-floors-m0.md) supplies the numerator.
- rh19's published best escape radius 5.74×10<sup>-9</sup>.

## Notes

- Θ = 1 in this instance, so no inflation was actually charged; the source still records the inflation rule because it is "never allowed to work in the new window's favour".
- The result is an unconditional statement about a ball around the *lattice* configuration; the source warns it is not a neighbourhood of the critical line.
