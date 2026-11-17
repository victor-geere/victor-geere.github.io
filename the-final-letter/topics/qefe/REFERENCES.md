# References for the named inputs

Each entry states exactly what the QEFE dossier uses and whether the statement is
a published theorem or an in-house proof.

## 1. Lattice vertex operator algebras

- **C. Dong, H. Li, G. Mason**, *Modular invariance of characters of vertex
  operator algebras*, J. Amer. Math. Soc. **9** (1996), 237–302.
  [doi:10.1090/S0894-0347-96-00182-8](https://doi.org/10.1090/S0894-0347-96-00182-8)
- **C. Dong**, *Vertex algebras associated with even lattices*, J. Algebra
  **161** (1993), 245–265.
  [doi:10.1006/jabr.1993.1217](https://doi.org/10.1006/jabr.1993.1217)

Used for: for an even lattice `L`, the lattice VOA `V_L` is rational, its simple
modules are indexed by the cosets `L*/L`, and every simple has quantum dimension
`1`; hence `D² = det L = |L*/L|`. This is the accepted input behind T12. The
dossier does **not** use a general converse realisation theorem for arbitrary
(non-pointed) MTCs.

- **Y.-Z. Huang**, *Vertex operator algebras, the Verlinde conjecture, and
  modular tensor categories*, Proc. Natl. Acad. Sci. USA **102** (2005),
  5352–5356.
  [doi:10.1073/pnas.0409901102](https://doi.org/10.1073/pnas.0409901102)

Used only for the direction “the representation category of a rational VOA is a
modular tensor category”. It is not used as a converse.

## 2. Galois symmetry of the modular S-matrix

- **A. Coste, T. Gannon**, *Remarks on Galois symmetry in rational conformal
  field theories*, Phys. Lett. B **323** (1994), 316–321.
  [doi:10.1016/0370-2693(94)91226-2](https://doi.org/10.1016/0370-2693(94)91226-2)
- **P. Bantay**, *The kernel of the modular representation and the Galois action
  in RCFT*, Comm. Math. Phys. **233** (2003), 423–438.
  [doi:10.1007/s00220-002-0760-x](https://doi.org/10.1007/s00220-002-0760-x)

Used for: the Galois action on the modular `S`-matrix factorises as a
permutation of labels times signs, `σ(S_{ij}) = ε_i ε_j S_{π(i)π(j)}`. The Ising
instance is T10 and the `SU(2)₄` `√3` obstruction is T11.

## 3. Lattice theta and the Epstein zeta

- **J. W. S. Cassels**, *An Introduction to the Geometry of Numbers*, Springer,
  1959, Ch. III (lattice theta and Poisson summation).
- **J. H. Conway, N. J. A. Sloane**, *Sphere Packings, Lattices and Groups*,
  3rd ed., Springer, 1999, Ch. 2 (theta series of lattices).
- **H. Iwaniec, E. Kowalski**, *Analytic Number Theory*, AMS Colloquium
  Publications **53**, 2004, Ch. 3 (Mellin transforms and completed
  `L`-functions).

Used for: the rank-`n` Poisson transformation
`Θ_L(1/τ) = τ^{n/2} (det L)^{-1/2} Θ_{L*}(τ)` and the Mellin transform of the
lattice `L`-series. T8–T9 are the rank-one and `ℤ²` cases; C7 is the explicit
`ℤ²` completed series. The `ℤ²` case is also proved directly from the functional
equations of `ζ` and the Dirichlet beta function (see below).

## 4. The half-spectrum zeta limit

- **In-house proof:** [`HALF-SPECTRUM.md`](HALF-SPECTRUM.md).

The limit `Σ_{j≤k/2} d_j^{-2s} → ζ(2s)` and its signed analogue are not taken
from the literature. The proof uses Jordan's inequality, dominated convergence
for series, and the Riemann sum of `sin^{2s}`; it is reproduced in full in
`HALF-SPECTRUM.md`. The integer-zero statement is proved there as well.

## 5. Modular tensor categories

- **B. Bakalov, A. Kirillov Jr.**, *Lectures on Tensor Categories and Modular
  Functors*, AMS University Lecture Series **21**, 2001.
- **P. Etingof, S. Gelaki, D. Nikshych, V. Ostrik**, *Tensor Categories*, AMS
  Mathematical Surveys and Monographs **205**, 2015.

Used for: the definitions of modular tensor category, integrality, quantum
dimensions, and the total dimension `D² = Σ d_i²`. The finite identities T4–T5
take the list of positive `d_i²` as a hypothesis; they do not construct the MTC.

## 6. The completed beta function

The `ℤ²` identity

```
Λ_ℤ²(s) = 4 π^{-s} Γ(s) ζ(s) β(s)
```

uses the classical factorisation `r₂(n) = 4 Σ_{d|n} χ₄(d)` and the standard
completed functional equations

```
π^{-s/2} Γ(s/2) ζ(s) = π^{-(1-s)/2} Γ((1-s)/2) ζ(1-s),
(4/π)^{(s+1)/2} Γ((s+1)/2) β(s)
  = (4/π)^{(1-s+1)/2} Γ((1-s+1)/2) β(1-s).
```

Both are the standard functional equations for `ζ` and for the primitive odd
Dirichlet character `χ₄`; the duplication formula turns their product into
`4 π^{-s} Γ(s) ζ(s) β(s)`. C7 checks the resulting self-duality numerically.
