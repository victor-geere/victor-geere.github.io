# The primes are not where they were

**Kind:** Theorem
**Status:** CITED (literature)
**Area:** rh-html
**Source:** [`rh7.html`](../../html/rh7.html) — §4 "Total ramification, and the seed gear as fixed point", theorem box at lines 421–424

## Statement

> In the 2π base <i>p</i> is **not a prime element at all**: it is a (<i>p</i>−1)-st power. The genuine prime is λ<sub><i>p</i></sub> = 1 − ζ<sub><i>p</i></sub>, and <i>p</i> is **totally ramified** — the ramification index equals the full degree <i>p</i>−1 of the extension. This is classical (Washington, <i>Cyclotomic Fields</i>, Lemma 1.4); what the geometry contributes is the reading: **the modulus of the true prime is the opening chord of the sieve's row**, 2 sin(π/<i>p</i>), the first sample the sieve ever takes of gear <i>p</i>.

## Hypotheses and notation

- ζ<sub><i>p</i></sub> = <i>e</i><sup>2π<i>i</i>/<i>p</i></sup>; λ<sub><i>p</i></sub> = 1 − ζ<sub><i>p</i></sub> is the "genuine prime"; <i>p</i> is a prime integer.
- The relevant extension is ℚ(ζ<sub><i>p</i></sub>)/ℚ of degree <i>p</i>−1; total ramification means the ramification index equals that degree, i.e. (<i>p</i>) = (1 − ζ<sub><i>p</i></sub>)<sup><i>p</i>−1</sup> up to units.
- Equation (6) of §4: <i>p</i> = (unit) · λ<sub><i>p</i></sub><sup><i>p</i>−1</sup>, with |λ<sub><i>p</i></sub>| = 2 sin(π/<i>p</i>).
- "The 2π base" is the base-2π numeral of rh7.

## Proof / evidence

CITED: the source attributes the arithmetic to Washington, <i>Cyclotomic Fields</i>, Lemma 1.4. Its own contribution is the geometric reading (the opening chord 2 sin(π/<i>p</i>)) and the accompanying computations:

- the ratios (1 − ζ<sup><i>k</i></sup>)/(1 − ζ) are units: norm ∏<sub><i>j</i></sub>(1 − ζ<sup><i>jk</i></sup>)/∏<sub><i>j</i></sub>(1 − ζ<sup><i>j</i></sup>) = <i>p</i>/<i>p</i> = 1, "verified numerically to 10<sup>−8</sup> for every <i>k</i> and every <i>p</i> ≤ 13";
- the table of λ<sub><i>p</i></sub> = 2 sin(π/<i>p</i>) against λ<sub><i>p</i></sub><sup><i>p</i>−1</sup> · |units| for <i>p</i> = 2, 3, 5, 7, 11, 13: 2.000000/2, 1.732051/3, 1.175570/5, 0.867767/7, 0.563465/11, 0.478631/13;
- the seed case <i>p</i> = 2: λ₂ = 1 − <i>e</i><sup><i>i</i>π</sup> = 1 − (−1) = 2 exactly, "unramified and unmoved by the change of base";
- <i>x</i><sup><i>n</i></sup> − 1 = ∏<sub><i>d</i>|<i>n</i></sub> Φ<sub><i>d</i></sub>(<i>x</i>), "verified at <i>n</i> = 6, 12, 30, 36".

## Dependencies and related results

- Washington, <i>Introduction to Cyclotomic Fields</i>, 2nd ed., Lemma 1.4 (cited in the source's reference list).
- rh7 §3's identity |1 − ζ<sub><i>p</i></sub><sup><i>k</i></sup>| = 2 sin(π<i>k</i>/<i>p</i>), equation (3).
- rh4 §2's phase-opposite (half-turn) axiom, identified here with 1 − <i>e</i><sup><i>i</i>π</sup>.

## Notes

- CITED: the mathematical content is explicitly attributed to the literature; the source adds the geometric reading and the numerical checks above.
- The half-turn λ₂ = 2 is the one fixed point: "Every other prime disperses into <i>p</i>−1 conjugate chords; the half-turn stands alone."
