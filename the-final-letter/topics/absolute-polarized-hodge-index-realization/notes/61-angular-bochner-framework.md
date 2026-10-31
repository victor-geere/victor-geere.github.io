# Note 61 — the Angular Bochner framework: an external normal-form result and its boundary

**Status: No RH proof yet.** This note records an external research note,
*“An Angular Bochner Framework for Mean-Value Positivity of the Riemann Zeta
Function”* (PDF supplied by the author, October 2026), and its bearing on the
absolute-polarized Hodge-index programme. The external note is **limitative**:
it explicitly proves no new fact about the zeros of `ζ` and identifies the
remaining implication with the Weil positivity criterion.

## 1. What the external note constructs

1. **Polar data and angular partitions.** For `s = σ + it`,
   `n^{-s} = n^{-σ}e^{-it log n}`. A probability density on the circle
   determines a finite partition into sectors `I_k`, with sub-series
   `Z_k(s) = Σ_m c_{k,m} ζ(s + imt)` (`c_{k,m}` the Fourier coefficients of the
   sector indicator), and `ζ(s) = Σ_k Z_k(s)` for `Re s > 1`, continuing
   meromorphically.
2. **Bochner kernel and sliced matrices.** The kernel `K(u) = sinc(tu)` has a
   non-negative Fourier transform, hence is positive semi-definite. Compressing
   the associated Gram form to the span of `m` sector indicators gives an
   `m × m` PSD matrix whose entries are explicit linear combinations of
   shifted zeta values. Character twists replace `ζ` by Dirichlet `L`-functions
   and preserve positivity.
3. **Projective system, filtration, monoidal structure.** Partition refinement
   gives a projective system; damping high modes by a Schwartz function `φ`
   gives a filtration indexed by `supp φ̂`; external tensor products give a
   monoidal structure multiplying minimal eigenvalues.
4. **Equivalence with classical estimates.** Every finite-stage inequality
   unwinds, via Fourier expansion and the approximate functional equation, to a
   mean-value bound for a Dirichlet polynomial whose length is governed by the
   damping width; the admissible width is fixed by the zero-density estimate
   used to absorb the tail. Joint distributions, plethystic generating
   functions and Riemann–Siegel substitutions likewise reduce to the large
   sieve or Montgomery–Vaughan theorems.
5. **The missing uniformity.** Removing all damping uniformly in the level and
   the height, tested against the full family of Weil test functions, is
   **equivalent to the classical Weil positivity criterion and hence to RH**.
   Intermediate regimes (`exp((log T)^c)` damping, short-interval Lindelöf
   bounds) correspond to known weakenings.

## 2. Its explicit logical boundary

The note's conclusion is that the angular Bochner calculus is a **canonical
normal form** for the classical mean-value theory surrounding the Weil
criterion: it reorganises but does not enlarge that theory, and “any advance on
the Riemann hypothesis must introduce an idea lying outside the closure
delineated here.”

This is consistent with the dossier's own finding:

- the **finite** cone rungs (2×2, 4×4) are Lean-checked in `Shadow.lean`;
- the 6×6 interval certificate is numerical only (margin `~4·10⁻¹⁰`);
- the **infinite-level** cone positivity is exactly the open, RH-equivalent
  statement (`notes/54-final-assessment.md`, `notes/59-programme-status.md`,
  `notes/60-critical-line-route.md`).

## 3. Bearing on the programme

- The external note **corroborates** that finite-dimensional positivity
  (Bochner/sinc kernels, sector Gram matrices) is unconditional and classical;
  it does not supply the uniform infinite-level positivity.
- It therefore does **not** change the dossier's frontier: the remaining
  formalisation targets are the critical-line/Fourier route to the Weil
  explicit formula (note 60) and the Weil positivity criterion itself.
- No claim in the external note is used as a premise of any Lean theorem in
  this dossier; it is recorded as context and as an independent confirmation
  of the boundary.

**No RH proof yet.**
