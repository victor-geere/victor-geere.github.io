# The uniform lift: ϑ̃(x) = (x − 1)p − t log x with p = π + cτ, c = ⌈(t − π)/τ⌉<sub>+</sub>

**Kind:** Claim
**Status:** PROVED (paper argument, arithmetic on the construction); VERIFIED (numerical against rh3's printed numbers)
**Area:** rh-html
**Source:** [`rh38.html`](../../html/rh38.html) — §2 "The lift", eqs. (10)–(12)

## Statement

> rh3 §6's three new equations. The carry is the smallest whole number of extra turns per level that keeps the rate from ever going negative,
>
> ϑ̃(x) = (x − 1) p − t log x,  p = π + cτ,  c = ⌈(t − π)/τ⌉<sub>+</sub>,
>
> its rate is
>
> ϑ̃′(x) = p − t/x,
>
> strictly increasing in x and ≥ 0 everywhere by the choice of c, and the running total is
>
> δ<sub>n</sub> = ϑ̃(n)/τ turns,  τ = 2π.

> A nut on a bolt: one level deeper advances it by one pitch and turns it by whatever that pitch demands, and it cannot arrive at the next level having decided, halfway, to unscrew.

> Everything rh3 prints reproduces. At t = γ<sub>1</sub> the carry is **2** whole turns per level and the pitch is exactly 5π, so p/τ = **2.5**. The ledger under the first ten gears reads 0, 0.94, 2.53, 4.38, 6.38, 8.47, 10.62, 12.82, 15.06, 17.32 τ — all ten to two decimals, with δ<sub>2</sub> = 0.9407 and δ<sub>10</sub> = 17.320078 in full. Its increments are 0.94, 1.59, 1.85, 2.00, 2.09, 2.15, 2.20, 2.24, 2.26: rising monotonically towards the pitch and never reaching it, still 0.05555 turns short forty levels down. At the turning ring x* = t/π = 4.499223 the rate is **exactly** the carry, 2.000000 turns per level.

> Three properties make it a lift rather than a different thread. It hits every station (8) fixes: ϑ̃ and ϑ agree mod τ to **7.3×10<sup>−12</sup>** turns over eight torsions and two hundred levels, which is the roundoff of differencing angles of size 10<sup>5</sup>. Its rate is non-negative over eight thousand depths at each of those torsions, and strictly increasing in depth. And c is the smallest carry that does it — at c − 1 the rate at x = 1 is negative at every torsion tested.

> And rh3 (20) makes the matched-winding constraint literal. A *spine* is not a lab meridian but a digit carried by the turning frame, at angle ϑ̃(x) + kπ/6, so spine k meets its own digit on every gear having completed exactly δ turns.

## Hypotheses and notation

- Equation (8) of rh3 §6: ϑ<sub>n</sub> = (n − 1)π − t log n, the bare station angle, defined mod 2π.
- τ = 2π; c is the uniform carry in whole turns per level; p = π + cτ is the pitch.
- The lift is a gauge choice fixing the whole-turn part of each step, uniformly over the thread.

## Proof / evidence

Arithmetic plus regression against rh3's printed numbers: at t = γ<sub>1</sub> the carry is 2, the pitch 5π, p/τ = 2.5; the first ten ledger values and their increments are as quoted; the rate at x* = t/π = 4.499223 is exactly the carry. Verification of the three lift properties: agreement mod τ to 7.3×10⁻¹² turns over eight torsions and two hundred levels; non-negative rate over eight thousand depths; minimality of c (at c − 1 the rate at x = 1 is negative at every torsion tested).

## Dependencies and related results

- [rh37-constraints-and-the-half-turn-floor](../rh37/rh37-constraints-and-the-half-turn-floor.md) — the two constraints this lift is built to satisfy.
- [rh38-mirror-conjugation-invariance](rh38-mirror-conjugation-invariance.md) — the mirror of this lift, and the proof that the sign convention is invisible.
- [rh38-carry-is-the-one-sided-length](rh38-carry-is-the-one-sided-length.md) — the carry as a function of the torsion.
- [rh37-constraints-and-the-half-turn-floor](../rh37/rh37-constraints-and-the-half-turn-floor.md) — where the opposed sign was called excluded; §4 corrects that inference.

## Notes

- §§2–5 are arithmetic on the construction and on rh3's own printed numbers: no zero table, nothing conditional.
- The lift keeps rh3 §6's opposed sign exactly where it was; δ<sub>1</sub> = 0 at every torsion, and the spine is the thread (spine 0 and ϑ̃ agree to the last bit).
