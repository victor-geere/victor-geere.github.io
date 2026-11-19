# O1 — the `L²` bridge

**Status.** O1 is closed in density form by T44–T46. The isometry `hst_isometry`
remains as the corollary. The route below records how the density was assembled.

The uniform half of O1 is now proved: the constant-plus-Haar span is uniformly
dense in \(C[0,1]\) (`HST.haarSpan_dense`). What remains is the passage from
uniform density to `L²` density and Haar completeness. This note fixes the
precise statement and the Lean targets so the remaining work is unambiguous.

## Setting

Let \(\mu\) be Lebesgue measure restricted to \([0,1]\), and let
\[
V_n=\operatorname{span}_{\mathbb R}\bigl(\{1\}\cup\{\text{Haar differences of depth }<n\}\bigr)
\]
be the span represented in Lean by `HST.haarSpan n`. The Haar differences are
the unnormalised functions `HST.haarDiff`; the normalised Haar wavelets are
scalar multiples, so they span the same space.

## Target statement

**O1-L2.** \(V=\bigcup_n V_n\) is dense in \(L^2([0,1],\mu)\).

Equivalently, the closure of the image of \(V\) in `MeasureTheory.Lp ℝ 2 μ` is
the whole space. Haar completeness is the corresponding statement for the
normalised wavelets, and the HST isometry follows by identifying the coefficient
map with the `L²` expansion.

## Proof route

1. **Continuous functions are dense in \(L²\).** Mathlib provides
   `ContinuousMap.toLp_denseRange` for a compact domain and a finite weakly
   regular measure. Apply it to `C(Set.Icc 0 1, ℝ)` and \(\mu\).
2. **Uniform density of \(V\) in \(C[0,1]\).** This is `HST.haarSpan_dense`:
   for \(f\in C[0,1]\) and \(\varepsilon>0\), there are \(n\) and \(g\in V_n\)
   with \(\sup_{[0,1)}|f-g|\le\varepsilon\).
3. **Uniform-to-\(L²\) estimate.** Since \(\mu([0,1])=1\),
   \[
   \|f-g\|_{L^2}^2=\int_0^1|f-g|^2\,d\mu\le \varepsilon^2.
   \]
   Thus \(V\) is dense in the image of \(C\) inside \(L²\).
4. **Two-step density.** Approximate an arbitrary \(L²\) class by a continuous
   class, then approximate that class by \(V\). This gives O1-L2.
5. **Haar normalisation.** The repaired Haar wavelet is a scalar multiple of
   `haarDiff` on each split, so the normalised Haar span equals \(V_n\). This
   yields `haar_complete`.
6. **Isometry.** The coefficient map is the orthogonal projection onto the
   closed Haar span; density makes it an isometry onto its image and the inverse
   expansion converges in \(L²\). This yields `hst_isometry`.

## Lean targets

| Target | Intended statement |
|---|---|
| `haarSpan_dense_Lp` | the image of `⋃ n, haarSpan n` is dense in `Lp ℝ 2 μ` |
| `haar_complete` | the normalised Haar system has dense span in `L²[0,1]` |
| `hst_isometry` | the coefficient map is an isometric isomorphism onto its image |

Supporting work:

- `MemLp` instances for `cylInd c` and for finite sums of cylinder indicators;
- the `Lp` image of `haarSpan n` as a submodule;
- the uniform-to-`L²` estimate above, with the measure of `[0,1]` normalised to
  one;
- a.e. equality handling for the half-open cylinders (endpoints have measure
  zero).

## Risks

- The `Lp` API uses a.e. equivalence classes, while `haarSpan` is a space of
  concrete functions. The bridge must be stated through `MemLp.toLp` and a.e.
  equality, not definitional equality.
- The half-open convention means boundary points are measure zero; this is
  harmless but must be recorded.
- The normalised Haar wavelet differs from `haarDiff` by a scalar depending on
  the child lengths; the span is unchanged, but `haar_complete` should state the
  normalised version explicitly.

## What is already proved

- Real partition: tiling, coverage, uniqueness, mesh (T25–T28).
- Uniform oscillation and cylinder-step approximation (T29–T30).
- Cylinder step functions uniformly dense in `C[0,1]` (T31).
- Dimension count and local Haar algebra (T32–T35).
- Global cylinder-to-Haar span induction (T36).
- Indicator-span inclusion and Haar-span uniform density (T37–T38).
- Continuous-function \(L^2\) approximation by the Haar span (T39).

The remaining measure-theoretic step is the composition with the density of
continuous functions in \(L^2\), followed by the final isometry.
