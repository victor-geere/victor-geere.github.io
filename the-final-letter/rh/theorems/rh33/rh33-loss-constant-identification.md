# The loss constant ρ and its identification with rh32's death curve

**Kind:** Proposition
**Status:** VERIFIED (numerical; agrees with rh32's stored numbers at K = 1.5, 2.1, 3.1 "to the last bit"; evidence absent; the source is prose only, no committed evaluator)
**Area:** rh-html
**Source:** [`rh33.html`](../../html/rh33.html) — §2 "The loss constant", lines 364–386 and boxed statement at lines 372–377

## Statement

> Fix a mirrored atomic measure μ — atoms at ±t<sub>j</sub> with weights w<sub>j</sub> — and a degree n. Its Toeplitz matrix is T<sub>n</sub>[j][k] = E(j − k) with E(k) = ∑<sub>j</sub> w<sub>j</sub> e<sup>ikt<sub>j</sub></sup> summed over all atoms, and the number this document is about is
>
> ρ(μ) = λ<sub>min</sub>(T<sub>n</sub>) / mass = the largest c with ∑<sub>j</sub> w<sub>j</sub> |p(t<sub>j</sub>)|<sup>2</sup> ≥ c · mass · ‖p‖<sup>2</sup> for every trigonometric polynomial p of degree &lt; n.
>
> This is the one-sided Marcinkiewicz–Zygmund constant: the exact quantity rh32 §8 (a) proposed to bound below. It is 1 when the atoms integrate degree-n polynomials exactly, which is rh32 §2's identity — on the mirrored crystal T<sub>n</sub> = mass · I, and ρ = 1 to 9.9×10<sup>−15</sup>. Puncture the crystal and ρ is rh32's death curve in new clothes: ρ = c(K)·C<sub>n</sub>/mass, checked against rh32's stored numbers at K = 1.5, 2.1 and 3.1 and equal to the last bit. Everything below is a measurement of ρ.

## Hypotheses and notation

- μ is a mirrored atomic measure, atoms at ±t<sub>j</sub> with weights w<sub>j</sub>; T<sub>n</sub> its Toeplitz moment matrix with entries E(j−k).
- ρ(μ) = λ<sub>min</sub>(T<sub>n</sub>)/mass; equivalently the largest c with ∑<sub>j</sub> w<sub>j</sub>|p(t<sub>j</sub>)|<sup>2</sup> ≥ c·mass·‖p‖<sup>2</sup> for every trig polynomial p of degree &lt; n.
- c(K) and C<sub>n</sub> are rh32's death-curve constant and emptiest-arc ceiling; K = nW/2π.

## Proof / evidence

The equality of ρ with the one-sided Marcinkiewicz–Zygmund constant is the source's statement (the box), and the identification ρ = c(K)·C<sub>n</sub>/mass is checked against rh32's stored numbers at K = 1.5, 2.1, 3.1 and reported "equal to the last bit". The crystal case ρ = 1 is verified to 9.9×10<sup>−15</sup>.

## Dependencies and related results

- [rh32-death-of-the-constant](../rh32/rh32-death-of-the-constant.md) — the death curve ρ recasts.
- [rh32-crystal-atom-sum-identity](../rh32/rh32-crystal-atom-sum-identity.md) — the exactness that makes ρ = 1 on the crystal.
- [rh33-jitter-law](rh33-jitter-law.md), [rh33-quadrature-lemma-refuted](rh33-quadrature-lemma-refuted.md) — the rest of "everything below is a measurement of ρ".
- rh32 §8(a) proposed to bound exactly this quantity below.

## Notes


- The box is in part a definition; it is harvested because the source states the identification results in the same breath ("This is the one-sided Marcinkiewicz–Zygmund constant ... ρ is rh32's death curve in new clothes").
- Conditional on RH for the zeta-side measures; the crystal statements are unconditional.

- **Evidence absent (session-003 audit repair 3, 2025-10-06).** No script, log or other evaluator is named in the document or in the source it was harvested from. The number(s) above therefore rest on the source's prose alone: nothing committed in this repository computes them. The label carries `evidence absent` for that reason and for no other — it is **not** a claim that the result is wrong, and it is **not** a demotion of the mathematics. It is the qualifier the archive already uses well elsewhere: `research/twin-prime-parity/checks/06-numerical-checks.md:378` discloses in the same spirit that `explicit_formula.log` "DOES NOT EXIST".
