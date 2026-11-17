# Quantum–Egyptian programme — finite core, lattice theta, and certified zeta limit

**Status:** a reconstruction and audit of the QEFE corpus. The finite Egyptian
core, the rank-one and square-lattice theta transformations, the finite Galois
data, root numbers, and the phase-corrected series are Lean-proved. The
χ₄ scalar series is identified with `2β(s)`, and the completed beta functional
equation `Λ_β(s) = Λ_β(1−s)` is proved by the characteristic-theta vector route
(T75–T95). Mathlib's completed `L`-function of `χ₄` is identified with the
completed beta on `Re s > 1` (T96–T116), the T24 functional equation is
re-derived from the theta route (T117), and P1 is now Lean-proved via the
product route and Legendre duplication (T118–T120). The half-spectrum zeta limit is
recorded as propositions with dossier proofs and numerical certificates. The
source's displayed finite functional equation is **refuted** by the
gamma-pole obstruction (T200–T204); its general analytic inputs are cited or
resolved.  
**Source:** [`archive/qefe/quantum-egyptian-functional-equation-v8.html`](../../archive/qefe/quantum-egyptian-functional-equation-v8.html)
(v8; the folder also holds v1–v7, the TeX source, and earlier drafts).  
**Inventory:** [Scraps](../../scraps.html) item 35 · [Topic index](../README.md).  
**Handoff:** [`HANDOFF-GAUSSIAN-IDEAL-COUNT.md`](HANDOFF-GAUSSIAN-IDEAL-COUNT.md)
— extracting the Gaussian-integer/ideal-count library, the class number formula
for `ℚ(i)`, and the quadratic generalisation. Phase 1 is done: the library is
extracted, Mathlib-only, in [`lean/GaussianInt/`](lean/GaussianInt/), with
`#print axioms` clean on `idealCountFormula` and `twoSquaresFormula`. The
`𝓞 (ℚ(i)) ≃ ℤ[i]` bridge is also proved
(`GaussianInt.ringOfIntegersEquiv`); the class number formula itself is **not**,
and the remaining obligations are in
[`CLASS-NUMBER-QI.md`](CLASS-NUMBER-QI.md). Phase 3's two ring-type gates are
also done, in [`lean/QuadraticInt/`](lean/QuadraticInt/): `ℤ[√−2]` is
norm-Euclidean and `𝓞 (ℚ(√−2)) ≃+* ℤ[√−2]`, and a new Eisenstein integer ring
`ℤ[ω]` is built with `w = 6` units, a Euclidean division, and
`𝓞 (ℚ(√−3)) ≃+* ℤ[ω]`. The split-prime theorems — the missing analogues of
`Nat.Prime.sq_add_sq` — are also proved: `p = a² + 2b²` for `p ≡ 1,3 (mod 8)`,
and `p = a² − ab + b²` for `p ≡ 1 (mod 3)`. Both fields are now **complete**, and the capstones are single closed-form
arithmetic identities in `n`: `r2_closed` (`4 Σ χ₄`), `rTwo_closed`
(`2 Σ χ₈'`) and `rThree_closed` (`6 Σ χ₃`), together with the closed forms of the
ideal counts. All three local ideal counts and multiplicativity are proved; see
[`GENERALISATION-QI.md`](GENERALISATION-QI.md).

## Summary

This dossier reconstructs what can be stated and checked from the QEFE corpus,
and separates four kinds of content: Lean theorems, paper propositions with
numerical certificates, software validation, and named literature inputs. It
refutes the source's displayed finite functional equation (T200–T204), does not
prove the general claim, and makes no Riemann-hypothesis claim.

The paper has five layers.

1. **Finite core.** The Egyptian denominators `mᵢ = D²/dᵢ²`, Lemma 2.2, the
   finite categorical Dirichlet polynomial `Ψ`, and the Mellin transform of the
   finite theta. This is the part of the source that is directly checkable; it
   is Lean-proved in T1–T7 and T13–T15, with the categorical form in T19–T20.
2. **Lattice theta and the square-lattice `L`-series.** The rank-one and
   `ℤ²` theta modular transformations (T8–T9), the completed series
   `Λ_ℤ²(s) = 4π^(−s)Γ(s)ζ(s)β(s)`, and its self-duality (P1). The `L`-series
   has a complete paper proof in [`L-SERIES-Z2.md`](L-SERIES-Z2.md) and a
   rational certificate in C2.
3. **Galois signs and root numbers.** The Ising sign datum (T10), the
   `SU(2)₄` `√3` obstruction (T11), the `χ₄` character and its completed
   `L`-function functional equation (T21–T24), and the root numbers
   `W_Ising = e^{πi/8}`, `W_SU(2)₄ = i` (T16–T17).
4. **Phase-corrected series and the zeta limit.** The finite phase-corrected
   `Ψ(σ,t)` with its time-reversal symmetry and decay envelope (T25–T26), the
   exact `SU(2)₄` value at `σ=1/2` (T27), and the half-spectrum limits
   `Σ_{j≤k/2}d_j^(−2s) → ζ(2s)`, signed `→ η(2s)` (P2), with integer zeros
   (P3).
5. **Ledger, certificates, and connections.** The theorem ledger runs
   T1–T219; the paper propositions are P1–P3; the computations are C1 (software
   validation of finite quantum-dimension data) and C2 (rational enclosures for
   `β`, `Γ`, `Λ_ℤ²`, and `Ψ`). The connections section links the angular
   partition method, `zeta-from-theta`, `partial-sum-plus-tail`,
   `geometric-zeta`, and the archimedean/positivity dossiers. **No load-bearing
   named inputs remain**: `LatticeThetaMellinChi4` is closed as T218–T219 (the
   identity, proved by T120), and `RegularizedAnnularLatticeSeries` is retired
   as a headline gap and replaced by the `SU(2)_k` tower-limit question.

## Refutation of the displayed equation

The source's Theorem 3.1 displays a gamma factor `Γ((1-s+a)/2)` in the
numerator. That factor has poles at `s = 1 + a + 2n`, while the categorical
Dirichlet polynomial `Ψ(s) = Σ χ_i m_i^{-s}` is entire. At the pole the identity
cannot hold: the right-hand side is infinite meromorphically, or zero under
Mathlib's `Γ(-n) = 0` convention, while `Ψ` is finite and non-zero.

The dossier formalises the obstruction for the two worked examples:

- `Gamma_neg_one` (T200): Mathlib's value of `Γ(-1)` at the pole is `0`;
- `gammaRatio_ising_pole` (T201): `gammaRatio 0 3 = 0`;
- `qefe_fails_ising` (T202): `isingPsi 3 ≠ qefeRhs 4 0 1 isingPsi 3`;
- `gammaRatio_su2_pole` (T203): `gammaRatio 1 4 = 0`;
- `qefe_fails_su2` (T204): `su2Psi 4 ≠ qefeRhs 12 1 1 su2Psi 4`.

The point-evaluation form uses Mathlib's junk-value convention at the pole. The
structural statement is now proved for both worked examples: the residual
`Ψ(s) − RHS(s)` is unbounded in norm as `s → 3⁻` (Ising, T208–T211) and as
`s → 4⁻` (`SU(2)₄`, T212–T215), so the refutation no longer depends on
Mathlib's `Γ(-n) = 0` convention.

The page is organised in that order: finite data and Lemma 2.2; the Mellin
dictionary; lattice theta and the `L`-series; Galois signs and root numbers; the
zeta limit; lattice realisation; the theorem ledger; the propositions and
their certificates; the Python and Lean layers; proofs and references;
connections to the wider programme; and the named inputs.

## The finite data

The source defines a Dirichlet series from the quantum dimensions of an integral
modular tensor category (MTC). The finite input is a list of positive squared
quantum dimensions `d_i²` with total `D² = Σ_i d_i²` and Galois signs
`χ(m_i) = ε_i(σ) ∈ {±1}`.

| Object | Definition | Role here |
|---|---|---|
| Squared quantum dimensions | `d_i² > 0`, `Σ_i d_i² = D²` | finite input datum |
| Egyptian denominator | `m_i = D² / d_i²` | reconstructed exactly |
| Unit denominator | `m_0 = D²` because `d_0 = 1` | used in Lemma 2.2 |
| Egyptian reciprocal sums | `Σ_i 1/m_i = 1`, `Σ_{i≠0} 1/m_i = 1 - 1/D²` | Theorems T4–T5 |
| Galois signs | `χ(m_i) = ε_i(σ) ∈ {±1}` | character datum |
| Categorical Dirichlet series | `Ψ(s) = Σ_i χ(m_i) m_i^{-s}` | finite entire series |
| Finite theta | `Θ(τ) = Σ_i χ(m_i) exp(-π τ / d_i²)` | Mellin pair with `Ψ` |
| Gamma factor | `Γ((1-s+a)/2) / Γ((s+a)/2)` | exact at `s = 1/2` |
| QEFE prefactor | `(D²/π)^(s-1/2) Γ((1-s+a)/2) / Γ((s+a)/2)` | exact at `s = 1/2` |

## Lemma 2.2 and the finite identity

For a finite integral MTC datum with `d_0² = 1`, the Egyptian denominators
satisfy `Σ_i 1/m_i = 1` and, over the non-unit objects,
`Σ_{i≠0} 1/m_i = 1 - 1/D²`. Both identities are formalised in Lean (T4–T5) and
checked exactly for the Ising and `SU(2)_4` data (T13).

## The Mellin transform of the finite theta

With `Θ(τ) = Σ_i χ(m_i) exp(-π τ / d_i²)` and `Re s > 0`,

```
∫_0^∞ τ^(s-1) Θ(τ) dτ = Γ(s) π^(-s) Σ_i χ(m_i) d_i^(2s)
                       = Γ(s) π^(-s) D^(2s) Ψ(s).
```

This is the exact dictionary between the finite theta and the categorical
Dirichlet polynomial; it is checked symbolically in the Python layer (T15).

## Lattice theta and the square-lattice L-series

For `a > 0`, the rank-one lattice theta is
`Θ_{aℤ}(τ) = Σ_{n∈ℤ} e^{-π a² τ n²}`. Mathlib's Gaussian Poisson summation gives
the weight-`1/2` transformation (T8):

```
Θ_a(1/τ) = (√τ / a) Θ_(1/a)(τ).
```

The square-lattice theta `Θ_{ℤ²}(τ) = Θ_ℤ(τ)²` therefore transforms with weight
`1` (T9):

```
Θ_ℤ²(1/τ) = τ Θ_ℤ²(τ).
```

Its Mellin transform is the Epstein zeta of `ℤ²`. Using
`r₂(n) = 4Σ_{d|n}χ₄(d)`,

```
Λ_ℤ²(s) = 4 π^(-s) Γ(s) ζ(s) β(s),
```

where `β` is the Dirichlet beta function. The completed series is self-dual,
`Λ_ℤ²(s) = Λ_ℤ²(1-s)` (P1); the proof is in
[`L-SERIES-Z2.md`](L-SERIES-Z2.md). This is the concrete model of the categorical
`L`-series; the general even-lattice case is the standard Poisson step.

## Galois signs and root numbers

**Ising.** With `r = √2` and signs `ε = (1,-1,1)`, the normalized `S`-matrix
satisfies `S(-r)_{ij} = ε_i ε_j S(r)_{ij}` for every `r` (T10). Under
`√2 ↦ -√2` this is the Galois sign datum `ε = (1,-1,1)` with identity
permutation (T10).

**`SU(2)_4`.** The nontrivial conjugation `√3 ↦ -√3` admits no real
sign/permutation datum: comparison at the `(1,1)` entry forces `r ∈ {0,-1,2}`,
incompatible with `r² = 3` (T11). The Galois automorphism `σ_13` acts trivially on the
`S`-matrix, swaps objects 2 and 4, and has all signs `+1`; it is detected on the
`T`-matrix, which swaps `θ_2` and `θ_4`.

The normalized Gauss root number is `W = D^{-1} Σ_i d_i² θ_i`. For the standard
`T` data, `W_Ising = e^{πi/8}` and `W_{SU(2)_4} = i` (T16, T17).

## The zeta limit

The correct large-`k` statement uses the half-spectrum of quantum dimensions. For
`s > 1/2`,

```
lim_{k→∞} Σ_{j=0}^{⌊k/2⌋} d_{j,k}^{-2s} = ζ(2s),
lim_{k→∞} Σ_{j=0}^{⌊k/2⌋} (-1)^j d_{j,k}^{-2s} = η(2s) = (1 - 2^(1-2s)) ζ(2s).
```

The unsigned full-spectrum sum gives `2ζ(2s)`; the alternating full-spectrum sum
is zero for odd `k` and `2η(2s)` for even `k`. The convergence is computed at
`k = 2048` (P2); the proof is in [`HALF-SPECTRUM.md`](HALF-SPECTRUM.md).

## Lattice realisation

For an even lattice `L`, the lattice VOA `V_L` has simple modules indexed by
`L*/L`, all of quantum dimension `1`, and `D² = det L = |L*/L|`. Consequently a
single-lattice realisation with `n = D²` forces every `d_i² = 1` (T12).
Non-pointed categories such as Ising and `SU(2)_4` require a non-lattice VOA;
the Dong–Li–Mason lattice-VOA theorem is the cited input
([`REFERENCES.md`](REFERENCES.md)). The dossier does not use a converse
realisation theorem for non-pointed MTCs.

## Connections to the wider programme

None of the other dossiers proves a finite QEFE, but several supply a specific
missing mechanism.

| Dossier | What transfers | Where it stops |
|---|---|---|
| [angular-partition-method](../angular-partition-method/README.md) | phase-carrying tail coil for `n^(-s) = n^(-σ)e^(-it log n)`; Mellin/Laplace radial representation; continuation of the annular Mellin integral to `-3 < Re s`; the §7.6 checklist for the critical strip | a transform, not an evaluation; no Euler product or functional equation automatically |
| [zeta-from-theta](../zeta-from-theta/README.md) | theta-based functional equation with an audited dependency cone (`LambdaTheta`, `zetaTheta`) | needs a lattice/categorical theta input; no MTC construction |
| [partial-sum-plus-tail](../partial-sum-plus-tail/README.md) | certified evaluation of `ζ`, `ζ(s,a)`, `L(s,χ)` with tail bounds | numerical certification, not the structural FE |
| [geometric-zeta](../geometric-zeta/README.md) | Euler/Lambert/Mellin `Γ(s)ζ(s)^2`; finite-product impossibility; additive decomposition | a finite `Ψ` is not `ζ`; the decompositions carry no zero information |
| [archimedean-prime-evaluation](../archimedean-prime-evaluation/README.md), [digamma-contour-shift](../digamma-contour-shift/README.md) | the archimedean gamma factor and contour shift | the archimedean side only; no categorical series |
| [prime-spectrum-tensor](../prime-spectrum-tensor/README.md), [absolute-polarized-hodge-index-realization](../absolute-polarized-hodge-index-realization/README.md), [intersection-form-zeta](../intersection-form-zeta/README.md), [weil-positivity](../weil-positivity/README.md) | positivity/Weil machinery if a zero-exclusion route is wanted | QEFE makes no positivity claim |

Three concrete expansion targets:

1. **Phase-corrected categorical series.** Combine the finite `Ψ` with the
   angular phase coil: `Ψ(s,t) = Σ χ(mᵢ) mᵢ^(-σ) e^(-it log mᵢ)`. The coil
   handles the phase exactly; what is missing is a regularized annular
   representation and a growth bound, precisely the §7.6 list.
2. **Theta-independent `L`-series.** Replace the Mathlib `completedLFunction`
   route of T24 by the `LambdaTheta`/`zetaTheta` architecture of
   `zeta-from-theta`, so P1 has a dependency cone independent of the Hurwitz
   development.
3. **Certified numerical `L`-series.** Use `partial-sum-plus-tail` to enclose
   `β(s)`, `Λ_ℤ²(s)` and finite `Ψ_k(s)`; this would upgrade the P1/P2
   certificates from mpmath checks to rational enclosures.

If the `mᵢ` are integers, a finite `Ψ` is a finite combination of geometric
zetas; `geometric-zeta` then gives a concrete model (and the
`no_finite_euler_product` obstruction) for testing Euler-product claims.

### Expansion targets: status

- **Target 1 — phase-corrected series.** The finite series
  `Ψ(σ,t)=Σχ(mᵢ)mᵢ^(-σ)e^(-it log mᵢ)`, time reversal `Ψ(σ,-t)=conj Ψ(σ,t)`,
  and the decay envelope are formalised (T25–T26). The infinite regularized
  annular representation is reduced to the named input
  `RegularizedAnnularLatticeSeries` is **retired as a headline gap**; the precise
  open question is whether the functional equation survives the `k → ∞` limit of
  the `SU(2)_k` tower. See [`PHASE-ANNULAR.md`](PHASE-ANNULAR.md).
- **Target 2 — theta-independent `L`-series.** Closed. The χ₄ scalar series is
  `2β(s)` (T84), the scalar Mellin transform is `Γℝ(s+1)·2β(s)` (T92), the
  completed beta functional equation is T95, and its extension to all `s` is
  T115. Mathlib's `completedLFunction χ₄` is identified with `Γℝ(s+1)β(s)` on
  the convergence half-plane (T104) and, by analytic continuation from the
  Mellin transform (T106–T114), everywhere (T116). The T24 functional equation
  is then re-derived from T95 alone (T117), with no Hurwitz-zeta functional
  equation in the proof. See [`THETA-INDEPENDENT.md`](THETA-INDEPENDENT.md).
- **Target 3 — rational certificates.** C2 now gives exact-rational enclosures
  for `β(2)`, `Λ_ℤ²(2)=4π^(-2)ζ(2)β(2)`, and `Ψ_4(1/2,0)` from
  `partial-sum-plus-tail`. The same API accepts any rational rectangle; the
  three tests are representative certificates.

## Theorem ledger

Every row marked **Theorem** is proved in [`lean/Topic.lean`](lean/Topic.lean)
with no `sorry`, `axiom`, or `admit`. Every row marked **Computation** has a
test in [`tests/test_programme.py`](tests/test_programme.py).

| # | Kind | Statement | Lean / test |
|---|---|---|---|
| T1 | Theorem | If `D² > 0` and `d² > 0`, the Egyptian denominator `D²/d²` is positive. | `QEFE.egyptianDenom_pos` |
| T2 | Theorem | `(D²/d²)⁻¹ = d²/D²` for non-zero `D²`, `d²`. | `QEFE.inv_egyptianDenom` |
| T3 | Theorem | If `D² > 1`, the non-unit Egyptian mass `1 - 1/D²` is positive. | `QEFE.egyptianUnit_pos` |
| T4 | Theorem | For finite positive `d_i²` summing to `D²`, `Σ_i 1/m_i = 1`. | `QEFE.egyptian_total` |
| T5 | Theorem | **Lemma 2.2:** with `d_0² = 1`, `Σ_{i≠0} 1/m_i = 1 - 1/D²`. | `QEFE.egyptian_fraction_identity` |
| T6 | Theorem | At `s = 1/2`, `Γ((1-s+a)/2)/Γ((s+a)/2) = 1` for `a ≥ 0`. | `QEFE.gammaRatio_center` |
| T7 | Theorem | At `s = 1/2`, the QEFE prefactor is exactly `1` for `D² > 0`, `a ≥ 0`. | `QEFE.qefePrefactor_center` |
| T8 | Theorem | The rank-one lattice theta transforms as `Θ_a(1/τ) = (√τ/a) Θ_(1/a)(τ)`. | `QEFE.thetaL_one_div` |
| T9 | Theorem | The square-lattice theta transforms as `Θ_ℤ²(1/τ) = τ Θ_ℤ²(τ)`. | `QEFE.theta2_one_div` |
| T10 | Theorem | **Ising sign datum:** `S(-r)_{ij} = ε_i ε_j S(r)_{ij}` with `ε = (1,-1,1)`, for every `r`. | `QEFE.ising_galois` |
| T11 | Theorem | The nontrivial `√3` conjugation of `SU(2)_4` admits no real sign/permutation datum. | `QEFE.su2_no_signs` |
| T12 | Theorem | A lattice-coset realisation with `n = Σ_i d_i²` forces every `d_i² = 1`. | `QEFE.lattice_realisation_pointed` |
| T13 | Theorem | The Egyptian sums for Ising and `SU(2)_4`: `Σ isingDsq/4 = 1`, the non-unit sum is `3/4`, `Σ su2Dsq/12 = 1`, the non-unit sum is `11/12`. | `QEFE.egyptian_examples` |
| T14 | Theorem | `Ψ_Ising(0) = 1`, `Ψ_Ising(1) = 0`, `Ψ_SU2(0) = 1`, `Ψ_SU2(1) = 0`. | `QEFE.ising_psi_zero_one`, `QEFE.su2_psi_zero_one` |
| T15 | Theorem | The finite-theta Mellin identity `∫_0^∞ τ^(s-1)Θ(τ)dτ = Γ(s)π^(-s)Σ χ_i d_i^(2s)` for `Re s > 0`. | `QEFE.finiteTheta_mellin` |
| T16 | Theorem | The Ising normalized Gauss root number is `e^{πi/8}`. | `QEFE.ising_root_number` |
| T17 | Theorem | The `SU(2)₄` normalized Gauss root number is `i`. | `QEFE.su2_root_number` |
| T18 | Theorem | `Ψ_SU2(2) = 0` and `Ψ_SU2(3) = 1/144`. | `QEFE.su2_psi_two_three` |
| T19 | Theorem | The bridge `D^(2s) Ψ(s) = Σ_i χ_i d_i^(2s)`. | `QEFE.D2_rpow_mul_categoricalPsi` |
| T20 | Theorem | The categorical Mellin identity `∫_0^∞ τ^(s-1)Θ(τ)dτ = Γ(s)π^(-s)D^(2s)Ψ(s)`. | `QEFE.finiteTheta_mellin_categorical` |
| T21 | Theorem | The character `χ₄` is odd: `χ₄(-1) = -1`. | `QEFE.chi4_neg_one` |
| T22 | Theorem | The conductor of `χ₄` is `4`. | `QEFE.chi4_conductor` |
| T23 | Theorem | `χ₄` is primitive. | `QEFE.chi4_primitive` |
| T24 | Theorem | The functional equation of the completed `L`-function of `χ₄`. | `QEFE.chi4_completedLFunction_one_sub` |
| T25 | Theorem | Phase-corrected series: `Ψ(σ,-t) = conj Ψ(σ,t)` for `Ψ(s,t)=Σχ(mᵢ)mᵢ^(-σ)e^(-it log mᵢ)`. | `QEFE.phasePsi_conj` |
| T26 | Theorem | Phase envelope: `‖Ψ(σ,t)‖ ≤ Σ|χᵢ|exp(-σ log mᵢ)`. | `QEFE.phasePsi_norm_le` |
| T27 | Theorem | Exact `SU(2)₄` value: `Ψ(1/2) = 2/√3 - 1`. | `QEFE.su2_psiR_half` |
| T28 | Theorem | Cubic rank-`n` theta modularity: `Θ_{ℤ^n}(1/τ) = τ^(n/2) Θ_{ℤ^n}(τ)`. | `QEFE.thetaZn_one_div` |
| T29 | Theorem | The integer character `χ₄` has period `4`. | `QEFE.chi4Int_add_four` |
| T30 | Theorem | The integer character `χ₄` is odd. | `QEFE.chi4Int_neg` |
| T31 | Theorem | The Gaussian kernel `Σ n exp(-a n²)` is summable for `a > 0`. | `QEFE.summable_nat_mul_exp_neg_sq` |
| T32 | Theorem | The theta kernel `Σ_{n∈ℤ} n exp(-a n²)` is summable for `a > 0`. | `QEFE.summable_thetaKernel_int` |
| T33 | Theorem | The integer character is bounded: `‖χ₄(n)‖ ≤ 1`. | `QEFE.norm_chi4Int_le_one` |
| T34 | Theorem | The theta-kernel norm `Σ_{n∈ℤ} ‖n exp(-a n²)‖` is summable for `a > 0`. | `QEFE.summable_norm_thetaKernel_int` |
| T35 | Theorem | `twistedTheta4` is summable for `τ > 0`. | `QEFE.summable_twistedTheta4` |
| T36 | Theorem | Theta-kernel norm: `‖n exp(-a n²)‖ = |n| exp(-a n²)`. | `QEFE.norm_thetaKernel` |
| T37 | Theorem | Theta-kernel oddness: `thetaKernel a (-n) = -thetaKernel a n`. | `QEFE.thetaKernel_neg` |
| T38 | Theorem | The `χ₄` Gauss sum is `2i`. | `QEFE.gaussSumChi4_eq` |
| T39 | Theorem | The normalized `χ₄` root number is `i`. | `QEFE.rootNumberChi4_eq` |
| T40 | Theorem | Characteristic-kernel norm: `‖charKernel a b n‖ = |n−b| exp(−a(n−b)²)`. | `QEFE.norm_charKernel` |
| T41 | Theorem | Gaussian summability on `ℤ` for `a > 0`. | `QEFE.summable_gaussian_int` |
| T42 | Theorem | Characteristic kernel is summable on `ℤ` for every shift `b` and `a > 0`. | `QEFE.summable_charKernel` |
| T43 | Theorem | `thetaPlus` is summable for `τ > 0`. | `QEFE.summable_thetaPlus` |
| T44 | Theorem | `thetaMinus` is summable for `τ > 0`. | `QEFE.summable_thetaMinus` |
| T45 | Theorem | `χ₄(n) = sin(πn/2)` for all integers. | `QEFE.chi4Int_eq_sin` |
| T46 | Theorem | Pointwise Jacobi-term difference equals `−4π χ₄(n)n e^(−πa n²)`. | `QEFE.jacobiTheta2'_term_diff` |
| T47 | Theorem | Scalar Jacobi identification: `twistedTheta4(a) = −(1/(4π))[J′(1/4,ia) − J′(−1/4,ia)]`. | `QEFE.twistedTheta4_eq_jacobi` |
| T48 | Theorem | Pointwise `thetaPlus` Jacobi combination equals `(n−1/4)e^(−πc n²+πc n/2)`. | `QEFE.jacobiTheta2'_term_thetaPlus` |
| T49 | Theorem | Characteristic kernel factors as `e^(−πc/16)(n−1/4)e^(−πc n²+πc n/2)`. | `QEFE.charKernel_eq_exp` |
| T50 | Theorem | `thetaPlus` Jacobi assembly with prefactor. | `QEFE.thetaPlus_eq_jacobi` |
| T51 | Theorem | Pointwise `thetaMinus` Jacobi combination. | `QEFE.jacobiTheta2'_term_thetaMinus` |
| T52 | Theorem | `thetaMinus` characteristic-kernel factorization. | `QEFE.charKernel_minus_eq_exp` |
| T53 | Theorem | `thetaMinus` Jacobi assembly with prefactor. | `QEFE.thetaMinus_eq_jacobi` |
| T54 | Theorem | `jacobiTheta₂` quarter-point argument normalisation. | `QEFE.jacobiTheta₂_arg_quarter` |
| T55 | Theorem | `jacobiTheta₂'` quarter-point argument normalisation. | `QEFE.jacobiTheta₂'_arg_quarter` |
| T56 | Theorem | `J''(1/4,i/a) = thetaMinus(1/a)`. | `QEFE.jacobiTheta2''_quarter_minus` |
| T57 | Theorem | Negative `jacobiTheta₂` quarter-point normalisation. | `QEFE.jacobiTheta₂_arg_quarter_neg` |
| T58 | Theorem | Negative `jacobiTheta₂'` quarter-point normalisation. | `QEFE.jacobiTheta₂'_arg_quarter_neg` |
| T59 | Theorem | `J''(−1/4,i/a) = thetaPlus(1/a)`. | `QEFE.jacobiTheta2''_quarter_plus` |
| T60 | Theorem | Vector modular relation: `twistedTheta4(a) = (1/(2a^(3/2)))(thetaMinus(1/a) − thetaPlus(1/a))`. | `QEFE.twistedTheta4_vector_modular` |
| T61 | Theorem | `thetaPlus` Mellin HasSum identity for `Re s > 1`. | `QEFE.hasSum_mellin_thetaPlus` |
| T62 | Theorem | `thetaMinus` summand rewritten with `n+1/4`. | `QEFE.thetaMinus_eq_tsum_plus` |
| T63 | Theorem | `thetaMinus` Mellin HasSum identity for `Re s > 1`. | `QEFE.hasSum_mellin_thetaMinus` |
| T64 | Theorem | `oddIndex` absolute-value formula: `|oddIndex k − 1/4| = (2k+1)/4`. | `QEFE.abs_oddIndex_sub_quarter` |
| T65 | Theorem | Sign formula: `sign(oddIndex k − 1/4) = (−1)^(k+1)`. | `QEFE.sign_oddIndex_sub_quarter` |
| T66 | Theorem | `oddIndex` is injective. | `QEFE.oddIndex_injective` |
| T67 | Theorem | `oddIndex` is surjective, giving `ℕ ≃ ℤ`. | `QEFE.oddIndex_surjective` |
| T68 | Theorem | Cast sign formula for `oddIndex`. | `QEFE.sign_oddIndex_cast` |
| T69 | Theorem | Reindex the signed odd series along `oddIndex`. | `QEFE.betaSeries_reindex` |
| T70 | Theorem | Quarter-denominator cpow factor. | `QEFE.cpow_quarter` |
| T71 | Theorem | `BetaSeriesStatement`: signed odd series = `−4^s β(s)`. | `QEFE.betaSeriesStatement` |
| T72 | Theorem | The `twistedTheta4` summand is even. | `QEFE.twistedTheta4_summand_even` |
| T73 | Theorem | Scalar Mellin HasSum for `twistedTheta4`. | `QEFE.hasSum_mellin_twistedTheta4` |
| T74 | Theorem | `χ₄(2k+1) = (−1)^k`. | `QEFE.chi4Int_two_mul_add_one` |
| T75 | Theorem | `scalarTerm s 0 = 0`. | `QEFE.scalarTerm_zero` |
| T76 | Theorem | The scalar character summand is even: `scalarTerm s (−i) = scalarTerm s i`. | `QEFE.scalarTerm_neg` |
| T77 | Theorem | `χ₄(2k) = 0`. | `QEFE.chi4Int_even` |
| T78 | Theorem | `scalarTerm s (2k) = 0`. | `QEFE.scalarTerm_two_mul` |
| T79 | Theorem | Norm bound `‖scalarTerm s i‖ ≤ 1/|i|^(Re s)`. | `QEFE.norm_scalarTerm_le` |
| T80 | Theorem | The scalar character series is summable for `Re s > 1`. | `QEFE.summable_scalarTerm` |
| T81 | Theorem | The non-zero part of the scalar series on `ℕ` is supported on the odd integers. | `QEFE.support_scalarTerm_nat` |
| T82 | Theorem | `scalarTerm s (2k+1) = (−1)^k/(2k+1)^s`. | `QEFE.scalarTerm_odd` |
| T83 | Theorem | Reindexing `Σ_n scalarTerm s n = Σ_k scalarTerm s (2k+1)`. | `QEFE.tsum_nat_odd` |
| T84 | Theorem | `ScalarBetaStatement`: `Σ_i χ₄(i) sign(i)/|i|^s = 2β(s)` for `Re s > 1`. | `QEFE.scalarBetaStatement` |
| T85 | Theorem | `plusCharTerm s (−i) = −minusCharTerm s i`. | `QEFE.plusCharTerm_neg` |
| T86 | Theorem | `Σ_i plusCharTerm s i = −Σ_i minusCharTerm s i`. | `QEFE.tsum_plus_eq_neg_tsum_minus` |
| T87 | Theorem | `Σ_i minusCharTerm s i = 4^s β(s)` for `Re s > 1`. | `QEFE.tsum_minusCharTerm` |
| T88 | Theorem | `charKernel a (1/4) (−n) = −charKernel a (−1/4) n`. | `QEFE.charKernel_quarter_neg` |
| T89 | Theorem | The characteristic thetas satisfy `thetaPlus τ = −thetaMinus τ`. | `QEFE.thetaPlus_eq_neg_thetaMinus` |
| T90 | Theorem | `twistedTheta4 a = a^(−3/2) thetaMinus(1/a)`. | `QEFE.twistedTheta4_eq_cpow_inv` |
| T91 | Theorem | Mellin change of variables: `mellin twistedTheta4 ((s+1)/2) = mellinThetaMinus (1−s/2)`. | `QEFE.mellin_twistedTheta4_eq` |
| T92 | Theorem | `mellin twistedTheta4 ((s+1)/2) = Γℝ(s+1)·2β(s)` for `Re s > 1`. | `QEFE.mellin_twistedTheta4_eq_gamma_beta` |
| T93 | Theorem | Dual form `mellin twistedTheta4 ((2−s)/2) = Γℝ(s+1)·4^s β(s)` for `Re s > 1`. | `QEFE.mellin_twistedTheta4_eq_gamma_beta_dual` |
| T94 | Theorem | `completedBeta s = 2^(s+1)Γℝ(s+1)β(s)` for `Re s > 1`. | `QEFE.completedBeta_eq_gamma_beta` |
| T95 | Theorem | Completed beta functional equation `completedBeta s = completedBeta (1−s)` for `Re s > 1`. | `QEFE.completedBeta_functional_equation` |
| T96 | Theorem | `χ₄` on natural numbers agrees with `chi4Int`. | `QEFE.chi4_natCast` |
| T97 | Theorem | `χ₄(2m) = 0`. | `QEFE.chi4_two_mul` |
| T98 | Theorem | The `χ₄` Dirichlet-series summand on `ℕ` is supported on the odd integers. | `QEFE.support_chi4_LSeries` |
| T99 | Theorem | The naive Dirichlet series of `χ₄` is `β(s)`. | `QEFE.LSeries_chi4` |
| T100 | Theorem | `χ₄` is a quadratic character. | `QEFE.chi4_isQuadratic` |
| T101 | Theorem | `χ₄⁻¹ = χ₄`. | `QEFE.chi4_inv_eq_self` |
| T102 | Theorem | Mathlib's Gauss sum of `χ₄` equals the computed `gaussSumChi4`. | `QEFE.gaussSum_chi4_eq_std` |
| T103 | Theorem | The normalized root number of `χ₄` is `1`. | `QEFE.rootNumber_chi4_eq_one` |
| T104 | Theorem | `completedLFunction χ₄ s = Γℝ(s+1)·β(s)` for `Re s > 1`. | `QEFE.completedLFunction_chi4_eq` |
| T105 | Theorem | `completedBeta s = 2^(s+1)·completedLFunction χ₄ s` for `Re s > 1`. | `QEFE.completedBeta_eq_two_cpow_completedLFunction` |
| T106 | Theorem | `thetaMinus` is the `oddKernel` at shift `1/4`. | `QEFE.thetaMinus_eq_oddKernel` |
| T107 | Theorem | `twistedTheta4` is the `sinKernel` at shift `1/4`. | `QEFE.twistedTheta4_eq_sinKernel` |
| T108 | Theorem | `twistedTheta4` is continuous on `(0,∞)`. | `QEFE.continuousOn_twistedTheta4` |
| T109 | Theorem | `twistedTheta4` has exponential decay at `+∞`. | `QEFE.isBigO_twistedTheta4_atTop` |
| T110 | Theorem | `twistedTheta4` is `O(t^(−b))` at `0` for every `b`. | `QEFE.isBigO_twistedTheta4_zero` |
| T111 | Theorem | `twistedTheta4` is locally integrable on `(0,∞)`. | `QEFE.locallyIntegrableOn_twistedTheta4` |
| T112 | Theorem | The Mellin transform of `twistedTheta4` is entire. | `QEFE.mellin_twistedTheta4_differentiableAt` |
| T113 | Theorem | The Mellin transform of `twistedTheta4` is differentiable. | `QEFE.differentiable_mellin_twistedTheta4` |
| T114 | Theorem | `completedBeta` is entire. | `QEFE.differentiable_completedBeta` |
| T115 | Theorem | `completedBeta s = completedBeta (1−s)` for all `s`. | `QEFE.completedBeta_functional_equation_all` |
| T116 | Theorem | The bridge `completedBeta s = 2^(s+1)·completedLFunction χ₄ s` for all `s`. | `QEFE.completedBeta_eq_two_cpow_completedLFunction_all` |
| T117 | Theorem | T24 replacement: the completed `L`-function functional equation for `χ₄`, from the theta route. | `QEFE.chi4_completedLFunction_one_sub_theta` |
| T118 | Theorem | Legendre duplication in the form `2^(s+1)Γℝ(s)Γℝ(s+1) = 4π^(−s)Γ(s)`. | `QEFE.gammaR_duplication` |
| T119 | Theorem | P1: `Λ_ℤ²(s) = Λ_ℤ²(1−s)`. | `QEFE.lambdaZ2_self_dual` |
| T120 | Theorem | P1: `Λ_ℤ²(s) = 4π^(−s)Γ(s)ζ(s)β(s)` for `Re s > 1`. | `QEFE.lambdaZ2_product` |
| T121 | Theorem | The divisor-sum L-series `Σ_{d|n}χ₄(d)` equals `ζ(s)β(s)`. | `QEFE.LSeries_divisorSumChi4` |
| T122 | Theorem | The Epstein/lattice-series reduction `LSeries r₂ = 4ζβ`. | `QEFE.epstein_series_eq_four_zeta_beta` |
| T123 | Theorem | `Λ_ℤ²(s) = π^(−s)Γ(s)` times the Epstein series. | `QEFE.LambdaZ2_eq_epstein` |
| T124 | Theorem | `r2 n = 0` iff there is no integer representation `x²+y²=n`. | `QEFE.r2_eq_zero_iff` |
| T125 | Theorem | The algebra norm of a Gaussian integer is its `Zsqrtd.norm`. | `QEFE.algebra_norm_gaussian` |
| T126 | Theorem | The ideal norm of the principal ideal `(z)` is `z.norm.natAbs`. | `QEFE.absNorm_span_gaussian` |
| T127 | Theorem | Every Gaussian unit is one of `1, -1, i, -i`. | `QEFE.gaussian_unit_classification` |
| T128 | Theorem | The Gaussian unit group has cardinality four. | `QEFE.gaussianUnits_card_four` |
| T129 | Theorem | `r2 n` is the number of Gaussian integers of norm `n`. | `QEFE.r2_eq_natCard_gaussian` |
| T130 | Theorem | A norm-`n` Gaussian integer generates an ideal of norm `n`. | `QEFE.absNorm_span_gaussian_of_norm` |
| T131 | Theorem | Two Gaussian integers generate the same principal ideal iff they are associates. | `QEFE.gaussian_span_eq_iff_associated` |
| T132 | Theorem | The Gaussian unit action on norm-`n` elements is free for `n > 0`. | `QEFE.normElements_smul_eq_self_iff` |
| T133 | Theorem | Burnside count: `|NormElements n| = 4 · #orbits` for `n > 0`. | `QEFE.normElements_card_eq_four_mul_orbits` |
| T134 | Theorem | The orbit quotient of norm-`n` Gaussian integers is the set of ideals of norm `n`. | `QEFE.orbitsEquivIdeals` |
| T135 | Theorem | The 4-to-1 generator/ideal count. | `QEFE.normElements_card_eq_four_mul_idealCount` |
| T136 | Theorem | `r2 n` is four times the number of ideals of norm `n`. | `QEFE.r2_eq_four_mul_idealCount` |
| T137 | Theorem | `TwoSquaresFormula` follows from the named input `IdealCountFormula`. | `QEFE.twoSquaresFormula_of_idealCount` |
| T138 | Theorem | A prime `p ≡ 1 mod 4` splits as `π · star π` in `ℤ[i]`. | `QEFE.gaussian_split_prime` |
| T139 | Theorem | The principal ideal `(p)` factors as `(π)(star π)` for `p ≡ 1 mod 4`. | `QEFE.gaussian_span_prime_factorization` |
| T140 | Theorem | `absNorm (n)` in `ℤ[i]` is `n²`. | `QEFE.gaussian_absNorm_span_natCast` |
| T141 | Theorem | A prime `p ≡ 3 mod 4` remains prime in `ℤ[i]`. | `QEFE.gaussian_inert_prime` |
| T142 | Theorem | `1 + i` is prime in `ℤ[i]`. | `QEFE.gaussian_prime_one_add_I` |
| T143 | Theorem | The ramified factorization `(2) = (1+i)²`. | `QEFE.gaussian_ramified_two` |
| T144 | Theorem | The ideal `(p)` is prime for inert `p ≡ 3 mod 4`. | `QEFE.gaussian_inert_span_prime` |
| T145 | Theorem | The ramified ideal `(1+i)` is prime. | `QEFE.gaussian_ramified_span_prime` |
| T146 | Theorem | The unique maximal ideal above an inert prime `p ≡ 3 mod 4`. | `QEFE.gaussian_inert_unique_prime` |
| T147 | Theorem | Every ideal of norm `p^(2e)` is `(p)^e` for inert `p`. | `QEFE.gaussian_inert_ideal_eq_span_pow` |
| T148 | Theorem | The inert even-exponent local ideal count is one. | `QEFE.gaussian_inert_ideal_count_even` |
| T149 | Theorem | There is no ideal of norm `p` for inert `p`. | `QEFE.gaussian_inert_no_ideal_norm_prime` |
| T150 | Theorem | There is no ideal of odd-exponent norm for inert `p`. | `QEFE.gaussian_inert_no_ideal_norm_odd` |
| T151 | Theorem | The inert odd-exponent local ideal count is zero. | `QEFE.gaussian_inert_ideal_count_odd` |
| T152 | Theorem | The unique maximal ideal above `2` is `(1+i)`. | `QEFE.gaussian_ramified_unique_prime` |
| T153 | Theorem | Every ideal of norm `2^k` is `(1+i)^k`. | `QEFE.gaussian_ramified_ideal_eq_span_pow` |
| T154 | Theorem | The ramified local ideal count is one. | `QEFE.gaussian_ramified_ideal_count` |
| T155 | Theorem | Every ideal divides the principal ideal generated by its norm. | `QEFE.gaussian_ideal_dvd_span_absNorm` |
| T156 | Theorem | An ideal of norm `p^k` divides `(p)^k`. | `QEFE.gaussian_ideal_dvd_span_pow_of_absNorm` |
| T157 | Theorem | A maximal ideal above a split prime `p` is `(π)` or `(star π)`. | `QEFE.gaussian_split_maximal_eq` |
| T158 | Theorem | A Gaussian integer of prime norm is prime. | `QEFE.gaussian_prime_of_norm_natAbs` |
| T159 | Theorem | Both `π` and `star π` are prime in the split factorization. | `QEFE.gaussian_split_prime_star` |
| T160 | Theorem | Unconditional classification of maximal ideals above a split prime. | `QEFE.gaussian_split_maximal_eq'` |
| T161 | Theorem | The split factor `π` has norm `p`. | `QEFE.gaussian_split_norm` |
| T162 | Theorem | Both split prime ideals have norm `p`. | `QEFE.gaussian_split_span_norm` |
| T163 | Theorem | The two split prime ideals are distinct. | `QEFE.gaussian_split_span_ne` |
| T164 | Theorem | The split representation has both coordinates nonzero. | `QEFE.gaussian_split_nonzero_data` |
| T165 | Theorem | There is a split factorization with distinct prime ideals. | `QEFE.gaussian_split_prime_star_ne` |
| T166 | Theorem | An ideal of prime norm is maximal. | `QEFE.gaussian_isMaximal_of_absNorm_prime` |
| T167 | Theorem | An ideal of norm `p` is `(π)` or `(star π)`. | `QEFE.gaussian_split_ideal_eq_of_absNorm` |
| T168 | Theorem | There are exactly two ideals of norm `p` for split `p`. | `QEFE.gaussian_split_ideal_count_one` |
| T169 | Theorem | The norm of `(π)^a (star π)^b` is `p^(a+b)`. | `QEFE.gaussian_split_pow_norm` |
| T170 | Theorem | The norm of `(π)^a (star π)^b` is `p^k` when `a+b=k`. | `QEFE.gaussian_split_pow_norm_of_add` |
| T171 | Theorem | The two split prime ideals are coprime. | `QEFE.gaussian_split_isCoprime` |
| T172 | Theorem | Powers of the two split prime ideals are coprime. | `QEFE.gaussian_split_isCoprime_pow` |
| T173 | Theorem | Distinct powers of the two split primes are unequal. | `QEFE.gaussian_split_pow_ne` |
| T174 | Theorem | The `k+1` ideals `(π)^a (star π)^(k-a)` are distinct. | `QEFE.gaussian_split_pow_inj` |
| T175 | Theorem | The split local count follows from exhaustiveness. | `QEFE.gaussian_split_ideal_count_of_exhaustive` |
| T176 | Theorem | Every norm-`p^(k+1)` ideal peels off `(π)` or `(star π)`. | `QEFE.gaussian_split_peel` |
| T177 | Theorem | Every ideal of norm `p^k` is among the `k+1` candidates. | `QEFE.gaussian_split_exhaustive` |
| T178 | Theorem | The split local ideal count is `k+1`. | `QEFE.gaussian_split_ideal_count` |
| T179 | Theorem | The principal ideals `(m)` and `(n)` are coprime for coprime `m, n`. | `QEFE.gaussian_isCoprime_span_nat` |
| T180 | Theorem | A divisor of `(a)(b)` decomposes as `(K⊔(a))(K⊔(b))` when `a, b` are coprime. | `QEFE.gaussian_coprime_dvd_decompose` |
| T181 | Theorem | `chi4Int` is multiplicative. | `QEFE.chi4Int_mul` |
| T182 | Theorem | A divisor of a product of coprime ideals splits as `(K⊔I)(K⊔J)`. | `QEFE.ideal_coprime_dvd_decompose` |
| T183 | Theorem | For `p ≡ 1 mod 4`, `Σ_{j=0}^{k} χ₄(p^j) = k+1`. | `QEFE.divisorSumChi4_prime_pow_one` |
| T184 | Theorem | The raw `χ₄` is multiplicative on `ℤ`. | `QEFE.chi4_mul` |
| T185 | Theorem | `χ₄(p^j) = (-1)^j` for `p ≡ 3 mod 4`. | `QEFE.chi4_pow_three` |
| T186 | Theorem | For `p ≡ 3 mod 4`, the divisor sum is `1` for even `k` and `0` for odd `k`. | `QEFE.divisorSumChi4_prime_pow_three` |
| T187 | Theorem | The ramified divisor sum `Σ_{j=0}^{k} χ₄(2^j)` is `1`. | `QEFE.divisorSumChi4_prime_pow_two` |
| T188 | Theorem | `divisorSumChi4` is multiplicative over coprime `m, n`. | `QEFE.divisorSumChi4_mul` |
| T189 | Theorem | If `a ∣ m²`, `b ∣ n²`, `ab = mn` and `m, n` are coprime, then `a = m`, `b = n`. | `QEFE.nat_eq_of_dvd_sq_mul` |
| T190 | Theorem | For ideals of coprime norms `m, n`, `(K1 K2) ⊔ (m) = K1`. | `QEFE.gaussian_sup_mul_span_eq` |
| T191 | Theorem | The left component of an ideal of norm `mn` has norm `m`. | `QEFE.gaussian_sup_span_absNorm_left` |
| T192 | Theorem | The right component of an ideal of norm `mn` has norm `n`. | `QEFE.gaussian_sup_span_absNorm_right` |
| T193 | Theorem | The ideal-count product equivalence. | `QEFE.gaussianIdealCountEquiv` |
| T194 | Theorem | The ideal count is multiplicative over coprime `m, n`. | `QEFE.gaussian_idealCount_mul` |
| T195 | Theorem | The packaged ideal count is multiplicative. | `QEFE.idealCountFun_isMultiplicative` |
| T196 | Theorem | The packaged divisor sum is multiplicative. | `QEFE.divisorSumFun_isMultiplicative` |
| T197 | Theorem | The ideal count and divisor sum agree on prime powers. | `QEFE.idealCount_prime_pow_eq` |
| T198 | Theorem | The ideal-count formula `# {I // absNorm I = n} = Σ_{d|n}χ₄(d)`. | `QEFE.idealCountFormula` |
| T199 | Theorem | The two-squares formula `r₂(n) = 4Σ_{d|n}χ₄(d)`. | `QEFE.twoSquaresFormula` |
| T200 | Theorem | Mathlib's value of `Γ(-1)` at the pole is `0`. | `QEFE.Gamma_neg_one` |
| T201 | Theorem | The Ising gamma ratio vanishes at `s = 3` (pole). | `QEFE.gammaRatio_ising_pole` |
| T202 | Theorem | The displayed QEFE fails for the Ising data at `s = 3`. | `QEFE.qefe_fails_ising` |
| T203 | Theorem | The `SU(2)₄` gamma ratio vanishes at `s = 4` (pole). | `QEFE.gammaRatio_su2_pole` |
| T204 | Theorem | The displayed QEFE fails for `SU(2)₄` at `s = 4`. | `QEFE.qefe_fails_su2` |
| T205 | Theorem | The real Gamma function has residue `1` at `0`. | `QEFE.Real.tendsto_self_mul_Gamma_nhds_zero` |
| T206 | Theorem | `‖Γ(x)‖ → ∞` as `x → −1` from the right. | `QEFE.tendsto_norm_Gamma_nhdsGT_neg_one` |
| T207 | Theorem | `‖gammaRatio 0 s‖ → ∞` as `s → 3⁻`. | `QEFE.tendsto_norm_gammaRatio_zero_nhdsLT_three` |
| T208 | Theorem | `‖qefeRhs 4 0 1 isingPsi s‖ → ∞` as `s → 3⁻`. | `QEFE.tendsto_norm_qefeRhs_ising_nhdsLT_three` |
| T209 | Theorem | If `‖g‖ → ∞` and `‖f‖` is eventually bounded, then `‖f − g‖ → ∞`. | `QEFE.tendsto_norm_sub_atTop_of_eventually_le` |
| T210 | Theorem | `isingPsi` is eventually bounded near `3` from the left. | `QEFE.isingPsi_eventually_bounded_nhdsLT_three` |
| T211 | Theorem | The Ising QEFE residual is unbounded near `s = 3`. | `QEFE.tendsto_norm_qefeResidual_ising_nhdsLT_three` |
| T212 | Theorem | `‖gammaRatio 1 s‖ → ∞` as `s → 4⁻`. | `QEFE.tendsto_norm_gammaRatio_one_nhdsLT_four` |
| T213 | Theorem | `‖qefeRhs 12 1 1 su2Psi s‖ → ∞` as `s → 4⁻`. | `QEFE.tendsto_norm_qefeRhs_su2_nhdsLT_four` |
| T214 | Theorem | `su2Psi` is eventually bounded near `4` from the left. | `QEFE.su2Psi_eventually_bounded_nhdsLT_four` |
| T215 | Theorem | The `SU(2)₄` QEFE residual is unbounded near `s = 4`. | `QEFE.tendsto_norm_qefeResidual_su2_nhdsLT_four` |
| T216 | Definition | A finite exponential sum `Σ cᵢ exp(−λᵢ τ)`. | `QEFE.finiteThetaSum` |
| T217 | Theorem | A finite exponential sum with non-zero total cannot satisfy any weight-`w` modular relation. | `QEFE.finiteThetaSum_not_modular_of_sum_ne_zero` |
| T218 | Definition | The mathematical content of `LatticeThetaMellinChi4`. | `QEFE.LatticeThetaMellinChi4` |
| T219 | Theorem | `LatticeThetaMellinChi4` holds, by T120. | `QEFE.latticeThetaMellinChi4` |
| C1 | Computation | Finite quantum-dimension data is validated: positive `D²`, positive `dᵢ²`, `Σdᵢ² = D²`, unit `d_unit² = 1`, coefficient-list shape, positive denominators; integral `mᵢ` is an optional extra hypothesis. | `test_egyptian_denominator_validation`, `test_integer_egyptian_denominators_are_optional`, `test_categorical_psi_rejects_mismatched_lengths` |
| C2 | Computation | General rational-enclosure wrappers (`rational_certificates.py`): `β(s)`, `Γ(x)` for every rational `x` except non-positive integers (reflection for negative non-integers), `Λ_ℤ²(s)` for rational `0 < s`, `s ≠ 1` (including the critical strip), and `Ψ(σ,t)` on rational rectangles. These are Python interval certificates; the exact algebraic case `Ψ_4(1/2)=2/√3-1` is Lean-proved as T27. Tests: `β(2)`, `Λ_ℤ²(2)`, `Λ_ℤ²(3/2)`, `Λ_ℤ²(7/4)`, `Λ_ℤ²(1/2)`, `Λ_ℤ²(3/4)`, `Γ(1/3)`, `Γ(-1/2)`, `Ψ(1/2,0)`, `Ψ(1,1)`. | `test_beta_rational_enclosure`, `test_z2_lambda_rational_enclosure`, `test_lambda_z2_half_integer_enclosure`, `test_lambda_z2_rational_enclosure`, `test_lambda_z2_critical_strip`, `test_gamma_rational_enclosure`, `test_psi_phase_rational_enclosure`, `test_phase_psi_nonzero_t_enclosure` |

The computation column now contains only the software-validation check C1. P1 is
a Lean theorem (T119–T120); P2 and P3 remain **Propositions** with dossier
proofs and numerical certificates in the test suite.

### Propositions with dossier proofs

| # | Statement | Proof | Certificate |
|---|---|---|---|
| P1 | The completed `ℤ²` series `Λ_ℤ²(s) = 4π^(-s)Γ(s)ζ(s)β(s)` is self-dual: `Λ(s) = Λ(1-s)`. | **Lean:** `QEFE.lambdaZ2_self_dual`, `QEFE.lambdaZ2_product` (T119–T120); [`L-SERIES-Z2.md`](L-SERIES-Z2.md) | `test_z2_epstein_functional_equation` |
| P2 | The half-spectrum limits `Σ_{j≤k/2} d_j^{-2s} → ζ(2s)` and the signed analogue `→ η(2s)`. | [`HALF-SPECTRUM.md`](HALF-SPECTRUM.md) | `test_su2k_half_spectrum_zeta` |
| P3 | The alternating full-spectrum polynomial vanishes at integer `s` for `k ≥ 2s-1` (certified at `k = 8, 16`; `k = 4` is T18). | [`HALF-SPECTRUM.md`](HALF-SPECTRUM.md) | `test_su2k_integer_zeros` |

The general rank-`n` lattice theta, the general Bantay identity, and the MTC
construction remain the three cited inputs.

## Python layer

[`python/programme.py`](python/programme.py) provides the Egyptian data, the two
examples, the finite theta and Mellin pairs, the `SU(2)_k` data, the root number,
and the square-lattice completed series.
[`python/rational_certificates.py`](python/rational_certificates.py) provides the
reusable exact-rational wrappers `beta_enclosure`, `gamma_enclosure`,
`lambda_z2_integer`, `lambda_z2_half`, `lambda_z2_rational`, and
`phase_psi_enclosure`. `lambda_z2_rational` now covers the critical strip
`0 < s < 1`; the Python enclosure uses the Euler–Maclaurin evaluator there,
while the angular partition method's regularized Mellin section supplies the
formal continuation route. The Lean critical-strip wiring for
`partial-sum-plus-tail` remains a separate task.

```bash
cd the-final-letter/topics/qefe
python3 -m pytest -q tests
```

Current result: **29 passed** in under a minute.

## Lean layer

[`lean/Topic.lean`](lean/Topic.lean) proves T1–T219. There is no `sorry`,
`axiom`, or `admit`. The wrapper `./lean/check.sh` builds against the local
Mathlib.

Two extracted, Mathlib-only module trees sit alongside `Topic.lean`:
[`lean/GaussianInt/`](lean/GaussianInt/) (the ideal-count/two-squares library and
the `𝓞 (ℚ(i)) ≃ ℤ[i]` bridge) and [`lean/QuadraticInt/`](lean/QuadraticInt/)
(`d = 2` and `d = 3`: ring types, bridges, split primes, local ideal counts,
multiplicativity and the closed-form representation formulas). Both are
axiom-audited in their `Audit.lean` files
(`[propext, Classical.choice, Quot.sound]`), and `./lean/check.sh` builds all of
them.

## Proofs and references

There are no load-bearing named inputs left. The two former inputs are
resolved: `LatticeThetaMellinChi4` is T219 (the identity, proved by T120), and
`RegularizedAnnularLatticeSeries` is retired in favour of the `SU(2)_k` tower
question.

1. **Lattice VOAs — Dong–Li–Mason.** For an even lattice `L`, `V_L` is rational,
   its simples are indexed by `L*/L`, and every simple has quantum dimension
   `1`; hence `D² = det L = |L*/L|` (T12). Citations: Dong–Li–Mason, *J. Amer.
   Math. Soc.* **9** (1996); Dong, *J. Algebra* **161** (1993). The dossier does
   not use a converse realisation theorem for non-pointed MTCs.
2. **Galois symmetry — Coste–Gannon and Bantay.** The Galois action on the
   modular `S`-matrix factorises as a permutation times signs. Citations:
   Coste–Gannon, *Phys. Lett. B* **323** (1994); Bantay, *Comm. Math. Phys.*
   **233** (2003). Ising is T10; the `SU(2)_4` `√3` case is T11.
3. **Lattice theta and Epstein zeta.** The rank-`n` Poisson transformation and
   the Mellin transform of the lattice `L`-series are standard (Cassels;
   Conway–Sloane; Iwaniec–Kowalski). Rank one and `ℤ²` are T8–T9; the `ℤ²`
   completed series is P1.
4. **Half-spectrum zeta limit — in-house.** The limit
   `Σ_{j≤k/2} d_j^{-2s} → ζ(2s)` and the signed `η(2s)` analogue are proved in
   [`HALF-SPECTRUM.md`](HALF-SPECTRUM.md) using Jordan's inequality and
   dominated convergence. P2 is the numerical certificate.
5. **MTC definitions — Bakalov–Kirillov; Etingof–Gelaki–Nikshych–Ostrik.**
   T4–T5 take a finite list of positive `d_i²` summing to `D²` as a hypothesis;
   they do not construct the MTC.

Full bibliographic details, DOIs, and the exact statement supported by each
reference are in [`REFERENCES.md`](REFERENCES.md). The in-house limit proof is
in [`HALF-SPECTRUM.md`](HALF-SPECTRUM.md).

## Provenance and related material


- [`scraps.html`](../../scraps.html) — inventory item 35.
- [`topics/README.md`](../README.md) — all topic folders.
- Source corpus: `archive/qefe/quantum-egyptian-functional-equation-v8.html`
  (plus v1–v7, `.tex`, and earlier drafts).
- Duplicate inventory item 36, [`qefe-research-notes`](../qefe-research-notes/README.md),
  covers the same corpus.

[Back to the topic index](../README.md) · [Scraps](../../scraps.html) · [The Final Letter](../../index.html)
