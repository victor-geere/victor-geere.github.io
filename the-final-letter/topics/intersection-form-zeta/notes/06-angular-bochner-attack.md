# Attacking the Frobenius alternative with the angular Bochner normal form

**Status:** a critical synthesis. The angular Bochner framework (ABF) is a
source claim (S10–S12), taken from the accompanying note *An Angular Bochner
Framework for Mean-Value Positivity of the Riemann Zeta Function*. The
dictionary of §3 and the no-closure corollary of §6 are this dossier's
interpretation. Nothing here proves the Riemann hypothesis.

## 1. The target

[`05-frobenius-alternative.md`](05-frobenius-alternative.md) replaces the
missing algebraic Frobenius by the scaling correspondence

\[
\mathcal{S}=\{(\lambda x,x)\}\subset X\times X,
\qquad X=\mathbb{A}_{\mathbb{Q}}^{\times}/\mathbb{Q}^{\times},
\]

whose trace formula is the explicit formula. The construction supplies the
correspondence and the functional equation, but leaves open the
**polarization**: a positive-definite form compatible with the scaling flow
and the functional equation. That polarization is the Weil positivity, hence
equivalent to RH.

The question of this note is whether the ABF closes that gap. The short
answer is: **it gives the finite-level polarization and identifies the limit
with the gap; it does not cross the gap.** The ABF is a normal form for the
finite-level theory, not a new positivity.

## 2. The ABF in the form used here

The ABF starts from the polar decomposition

\[
n^{-s}=n^{-\sigma}e^{-it\log n},\qquad s=\sigma+it.
\]

A non-negative continuous density of integral one on the circle determines a
finite measurable partition into sectors `I_k`. The Fourier coefficients
`c_{k,m}` of the sector indicator give the sub-series

\[
Z_k(s)=\sum_{m\in\mathbb{Z}}c_{k,m}\,\zeta(s+imt),
\qquad
\zeta(s)=\sum_k Z_k(s)\quad(\operatorname{Re}s>1),
\]

with meromorphic continuation. The Bochner kernel

\[
K(u)=\operatorname{sinc}(tu)
\]

has non-negative Fourier transform and is therefore positive definite. Its
compression to the span `V_m` of `m` sector indicators is an `m × m` positive
semidefinite matrix `G_m` whose entries are explicit linear combinations of
shifted zeta values. Refinement of the partition gives a projective system;
damping the high modes by a Schwartz function `φ` gives a filtration of the
positive cone indexed by `supp φ̂`.

The three facts we use are recorded as source claims:

- **S10.** For every finite level `m` and every damping `φ`, the ABF matrix
  `G_{m,φ}` is positive semidefinite.
- **S11.** The projective system with the damping filtration is logically
  coextensive with the classical mean-value toolbox: the approximate
  functional equation, mean-value theorems and zero-density estimates.
- **S12.** The statement that the system remains positive after all damping is
  removed, uniformly in the level and the height against the full family of
  Weil test functions, is equivalent to the Weil positivity criterion and
  hence to RH.

These are the PDF's §3, §5 and §6 respectively.

## 3. Dictionary with the scaling correspondence

The ABF and the scaling correspondence are two coordinates on the same
finite-level object:

| angular Bochner framework | scaling correspondence |
|---|---|
| angular sector indicator `1_k` | test function localised in phase |
| sub-series `Z_k(s)` | coordinate of the test function in the sector basis |
| Bochner kernel `sinc(tu)` | positive-definite kernel of the polarization |
| compression `G_m` | finite-level polarization `P_m` |
| refinement `m → m'` | projective system of test-function spaces |
| damping `φ` | filtration of the polarization |
| undamped projective limit | Weil functional `W` |
| missing uniformity (S12) | polarization conjecture (note 05 §5.1) |

**Proposition 1 (finite-level dictionary).** *Under S10–S12, the family
`G_{m,φ}` is a finite-level damped approximation to the Weil functional: each
`G_{m,φ}` is positive semidefinite, and the undamped projective limit is `W`.
The identification of `G_{m,φ}` with the alternative's finite-level
polarization `P_m` is the dictionary of the table, not an independent
identity.*

*Proof.* S10 gives the positivity of each finite-level matrix; the ABF's §3–§4
supplies the projective and damping structure; S12 identifies the undamped
limit with the Weil criterion. The dictionary then matches the level and
damping parameters with the test-function filtration of note 05. ∎

The proposition is conditional on the ABF's normal-form claim. It does not
assert that the Bochner matrices are literally compressions of the Weil form;
it records that the ABF is a coordinate system for the polarization already
isolated in note 05, with the same limit.

## 4. Finite-level positivity is unconditional

**Proposition 2.** *For every `m` and every damping `φ`, `G_{m,φ} ⪰ 0`.*

*Proof.* This is S10. In the sector model the matrix is

\[
G_{kl}=\sum_{j}\lambda_j\,c_{k,j}\overline{c_{l,j}},
\qquad \lambda_j\ge0,
\]

which is a Gram matrix; the general statement is Bochner's theorem applied to
the compressed kernel. ∎

The positivity at finite level is therefore not the difficulty. It is a
theorem for every level and every damping, independent of the zeros.

## 5. The limit is the wall

**Proposition 3.** *The uniform positivity of the ABF projective system after
removing all damping is equivalent to the Weil positivity, hence to RH.*

*Proof.* This is S12 combined with the Weil criterion. The spectral side of
the explicit formula is the undamped limit; its non-negativity on the cone of
squares is Weil positivity. ∎

## 6. The no-closure theorem

**Theorem.** *The Frobenius alternative of note 05 is equivalent to the ABF's
missing uniformity. The ABF supplies the finite-level polarization but does
not close the alternative.*

*Proof.* By Proposition 1, the ABF's undamped projective limit is the Weil
functional. By Proposition 2 the finite-level matrices are positive. By
Proposition 3 the uniform undamped limit is positive iff RH. The alternative's
polarization is the same Weil functional (note 05 §5). Hence the alternative
is equivalent to the ABF's uniform statement.

It remains to see that the finite-level positivity does not yield the uniform
statement inside the framework. By S11 the finite-stage inequalities unwind
to mean-value bounds whose admissible width is controlled by a zero-density
estimate; these are classical, unconditional statements. The uniform
statement is stronger: it is equivalent to RH, while the finite-stage bounds
are classical theorems. Therefore the passage from `G_{m,φ} ⪰ 0` for all
finite `m,φ` to the uniform positivity is not one of the ABF's own moves; it
requires an additional idea outside the closure that S11 describes. This is the same conclusion the ABF reaches for
its own programme. ∎

**Corollary (no closure).** *No argument that uses only the finite-level
Bochner positivity, the projective refinement, and the classical mean-value
toolbox can prove the alternative's polarization. A proof must introduce a
new uniformity or a new positivity outside that closure.*

This is the precise sense in which the ABF **attacks** the alternative: it
does not refute it, but it localises the entire remaining difficulty in one
statement — the uniform undamped positivity — and shows that the finite-level
machinery is conservative over the classical estimates.

## 7. A finite sanity check

[`../python/angular_bochner.py`](../python/angular_bochner.py) builds a finite
sector model of the Bochner compression. The kernel weights are

\[
\lambda_j=|\zeta(\tfrac12+i t(j+1))|^2 e^{-\varepsilon j^2}\ge0,
\]

so the matrix is positive semidefinite by construction. The smallest
eigenvalue for `m = 2, 4, 8, 16, 32` sectors is

```
m =   2   min eigenvalue = 2.710729e-01
m =   4   min eigenvalue = 8.924359e-02
m =   8   min eigenvalue = 4.134494e-02
m =  16   min eigenvalue = 1.882526e-02
m =  32   min eigenvalue = 8.470486e-03
```

In this normalisation the eigenvalue decays roughly like `c/m`: the
finite-level positivity gives no uniform gap. This is a numerical illustration
of the missing uniformity, not a proof of it; the model is not the full
zeta-weighted projective system of the ABF.

## 8. What would count as progress

The theorem reduces the alternative to a single analytic statement. Progress
would be one of:

1. **A uniform lower bound beyond the classical damping range.** This is the
   ABF's missing uniformity and, by S12, RH. It is not a reformulation of the
   problem; it is the problem.
2. **A new positivity outside the closure of S11.** The metaplectic/theta
   polarization of note 05 §5.2 is the natural candidate: the Weil
   representation is unitary, and the theta correspondence is a genuine
   correspondence over `Q`. Whether its unitarity descends to the Weil
   functional on the multiplicative cone is open.
3. **An arithmetic-site construction** that supplies the polarization
   directly, rather than through the finite-level mean-value filtration.

The existing `4 × 4` Gaussian certificate is a different finite shadow: it
compresses the Weil form itself, not the damped mean-value filtration. It
certifies positivity at rank four and says nothing about the uniform limit.
The ABF's finite-level matrices and the `4 × 4` matrix are both positive; both
stop at the same wall.

## 9. Conclusion

The ABF is the right normal form for the finite-level part of the
alternative: it makes the Bochner positivity explicit, organizes the damping
filtration, and identifies the undamped limit with the Weil criterion. It
also shows why the alternative cannot be closed by the finite-level
machinery. The alternative-to-Frobenius is therefore **not** a new route
around the wall; it is a coordinate system in which the wall is a single
uniformity statement.

QED.

## Source claims and computations

- **S10.** Finite-level ABF matrices are positive semidefinite (PDF §3).
- **S11.** The ABF projective system is logically coextensive with the
  classical mean-value toolbox (PDF §5).
- **S12.** Uniform undamped positivity is equivalent to Weil positivity / RH
  (PDF §6).
- **C43.** Sector Fourier coefficients satisfy the expected orthogonality and
  conjugate symmetry.
- **C44.** The finite sector Bochner matrix is Hermitian and positive
  semidefinite for several sector counts.
- **C45.** The smallest eigenvalue decays roughly like `c/m`, so the model
  exhibits no uniform gap.

The computations are in
[`../python/angular_bochner.py`](../python/angular_bochner.py) and
[`../tests/test_angular_bochner.py`](../tests/test_angular_bochner.py).

## References

- *An Angular Bochner Framework for Mean-Value Positivity of the Riemann Zeta
  Function* (the accompanying PDF, October 2026).
- A. Weil, *Sur les formules explicites de la théorie des nombres premiers*
  (1952); the Weil positivity criterion.
- H. Iwaniec and E. Kowalski, *Analytic Number Theory*, for the approximate
  functional equation, mean-value theorems and zero-density estimates.
- Note 05 of this dossier for the scaling correspondence and the Hecke
  shadow.

[Back to the dossier](../README.md) · [Frobenius alternative](05-frobenius-alternative.md) ·
[Certified shadow](04-certified-shadow.md)
