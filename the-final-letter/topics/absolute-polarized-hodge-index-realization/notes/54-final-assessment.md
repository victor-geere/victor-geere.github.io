# Final assessment (round 172)

**Status: No RH proof yet.** This note consolidates what the rescued programme
has established, what is Lean-checked, what is numerical, and what remains
open.

## 1. What the programme set out to do

The rescued dossier (notes 38–53) sought an absolute, polarised Hodge-index
realisation through the Bost–Connes scaling site: a rank-three local
Hodge-index theorem, a global cone positivity, and a scaling-site
Riemann–Roch statement. The RH-relevant input is the cone positivity, which
is equivalent to Weil's criterion.

## 2. Lean-checked layers

### Hadamard/Weierstrass (`lean/Hadamard.lean`)

The canonical product is entire; the quotient normal form and the global
identity `f = P·Q` are proved; `f = P·exp g` follows; the affine refinement
`f = P·exp(a+bz)` is proved conditional on `HasLogGrowthOne (f/P)`. The
order-1 class is closed under products, finite products, powers, scalar
multiples, controlled division, affine reparametrisation, zero-free sums, and
constant shifts, and contains every complex polynomial
(`polynomial_hasLogGrowthOne`).

### Symbol and completed zeta (`lean/Symbol.lean`, `lean/Archimedean.lean`)

The symbol identity is proved on `Im ξ > 1`, continued to `s ≠ 1`, and stated
explicitly on the critical line: `M(1/2+it) = -(Z'/Z)(1/2+it)`. The symbol is
conjugation-symmetric, anti-symmetric (`M(1-s) = -M(s)`), and purely
imaginary on the critical line. The completed zeta has residues `1` at `s = 1` and `-1` at `s = 0`
(`completedZeta_residue_one`, `completedZeta_residue_zero` — the two pole
terms of the explicit formula),
satisfies the functional equation, is conjugation-symmetric, produces the zero quadruple
`s, 1-s, conj s, 1-conj s`, is real on the critical line, and its
log-derivative is conjugation-symmetric, anti-symmetric under `1-s`, and
purely imaginary on the critical line.

### Zero sums

A finite sum paired by conjugation is real
(`finset_sum_real_of_conj`, via `Finset.sum_bij`), and a finite zero sum of a
conjugate-pairing test function is real (`zero_sum_real_of_finite`). The
genuine trivial zeros of zeta, `ζ(-2m)=0`, are Lean-checked; the
completed-zeta trivial-zero statement is documented as a Gamma junk-value
convention, not a claim about the meromorphic continuation.

### RH formulations

Three equivalent formulations are Lean-checked: the definition, the
critical-line form, and the absence of zeros in `0 < Re s < 1/2`.

### Finite cone positivity (`lean/Shadow.lean`)

The box-positivity machinery of the sibling `intersection-form-zeta` dossier
was imported and generalised to an arbitrary finite index type: the row-sum
bound, the box inequality `A ⪰ P`, positive definiteness from a box, and the
exact rational LDLᵀ certificate. It is instantiated for the 4×4 Gaussian Weil
Gram shadow: `W4m_posDef` proves the shadow positive definite from the
rational centre `G4`, the exact LDLᵀ factorisation of `G4 − (1/12500)·1`, and
the interval box with entrywise slack `1/50000`. See
[`notes/55-cone-positivity-import.md`](55-cone-positivity-import.md).

The rank-three Hodge defect is also formalised:
`(A·D)² - 6D² = 2((a-b)² + (b-c)² + (c-a)²)`, so the positivity gap is a sum
of squares (`hodge_defect_identity`, `hodge_index_explicit`). The abstract
finite shape is captured by `gram_quadFormR_nonneg` (every finite Gram matrix
of an inner product is PSD) and `gram_quadFormR_pos_iff` (positive
definiteness is linear independence). The scaling-site limit form covers both
signs (`limitForm_nonpos`, `limitForm_nonneg`).

This is the **finite** rung of the cone positivity; the infinite cone, and
hence Weil's criterion, remain open.

## 3. Numerical certificates

- Tail-bounded von Mangoldt partial sums at real and complex points.
- The completed-zeta functional equation at 30-digit precision.
- The symbol's pure-imaginary property on the critical line to `1e-25`.
- The completed-zeta log-derivative symmetries to `1e-20`.
- The zero quadruple for the first zero to `1e-15`.
- The critical-line reality of the completed zeta to `1e-20`.
- Interval-certified Gaussian Gram matrices: 4×4 automated; 6×6 one-off at
  `h=0.004`, `T=100` with uncertainty `1.60e-3` and smallest leading minor
  `3.33e-10 > 0`. The margin is thin.

All numerics are finite high-precision evaluations or explicit tail bounds;
no truncated series is used where a bound is available.

## 4. What remains open

1. The general order-1 growth of `f/P` (the polynomial case is covered).
2. **Global cone positivity (Weil's criterion)**, which needs the
   distributional explicit formula. This is the RH-relevant step.
3. Bost–Connes level compatibility beyond the finite Krawtchouk/Morita
   equivalences.
4. The scaling-site Riemann–Roch/Hodge index.

## 5. Honest conclusion

The structural layers leading to the explicit formula are formalised and
verified. The explicit formula itself — the identity between the zero sum and
the pole/prime/archimedean terms — is not formalised, and without it the cone
positivity and hence Weil's criterion are not proved. **No RH proof yet.**

[Back to the dossier](../README.md) · [Priorities](53-priorities.md) ·
[Hadamard status](52-hadamard-status.md) · [Journal](../research-journal.md)
