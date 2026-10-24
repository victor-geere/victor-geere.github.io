# Evaluation is projection: the numeral collapses to η(s)

**Kind:** Theorem
**Status:** PROVED (paper argument)
**Area:** workspace
**Source:** [`rh3/README.md`](../../rh3/README.md) — §7 "The value: collapse to a chain", equations (13)–(15), lines 205–228

## Statement

> v<sub>n</sub> = r<sub>n</sub> · e^{i·ϑ<sub>n</sub>} = (−1)^{n−1} · λ<sub>n</sub> · r<sub>n</sub> · e^{i·ρ<sub>n</sub>} (13)
>
> val(aaaa…) = Σ<sub>n≥1</sub> (−1)^{n−1} λ<sub>n</sub> r<sub>n</sub> e^{i ρ<sub>n</sub>} (14)
>
> with r<sub>n</sub> = n<sup>−σ</sup>, ρ<sub>n</sub> = −t log n, λ ≡ 1:
>
> val(aaaa…) = Σ<sub>n≥1</sub> (−1)^{n−1} / n<sup>s</sup> = η(s),   s = σ + it (15)
>
> **Evaluation is projection.** The two dials were the two coordinates of *s* all along.

## Hypotheses and notation

- Each level contributes one vector: the displacement from circle *n*'s centre to its *a*-vertex, read in that circle's plane as ℂ.
- r<sub>n</sub> = n<sup>−σ</sup> is the radius of circle *n* (eq. (3)); ϑ<sub>n</sub> = (n−1)π − t·log n is the lab angle (eq. (8)), so e^{iϑ<sub>n</sub>} = (−1)^{n−1} e^{iρ<sub>n</sub>} with ρ<sub>n</sub> = −t·log n (eq. (7)).
- λ<sub>n</sub> ∈ (0, 1] is the **retuning** factor, the construction's one genuinely undetermined structure; it is **set to 1 everywhere** here and in the figure.
- s = σ + i·t; η is the Dirichlet eta function.

## Proof / evidence

The source states the collapse as a substitution, not as a proof: it writes the general chained sum (14), then sets r<sub>n</sub> = n<sup>−σ</sup>, ρ<sub>n</sub> = −t log n, λ ≡ 1 and reads off (15). The identity (−1)^{n−1} n<sup>−σ</sup> e^{−it log n} = (−1)^{n−1} n<sup>−s</sup> is the definition of n<sup>−s</sup>. The source supplies no separate convergence argument in §7; the convergence of the half-turned train is stated in §9.

The partial sums used by the figure are P₀ = 0, P<sub>k</sub> = Σ<sub>j=1..k</sub> v<sub>j</sub>; the source's §11 records the numerical check |P₄₀₀| at ½ + iγ₁ = 0.0250 (still on its way to 0).

## Dependencies and related results

- [rh3-readme-half-turned-train-converges](rh3-readme-half-turned-train-converges.md) — why the half-turned train converges on σ > 0.
- [rh3-readme-digit-independence-of-zero-set](rh3-readme-digit-independence-of-zero-set.md) — the same evaluation for the other eleven digit strings.
- Section §12 leaves the retuning λ<sub>n</sub> undetermined: "With λ unconstrained closures exist at every decay exponent; with λ ≡ 1 the rigidity claim is exactly the Riemann Hypothesis."

## Notes

- The source's remark "Evaluation is projection. The two dials were the two coordinates of *s* all along" is its own reading of the collapse, not additional mathematics.
- The identity Σ<sub>n≥1</sub> (−1)^{n−1} n<sup>−s</sup> = η(s) is standard; the content the source claims here is that its geometric numeral *evaluates* to it.
