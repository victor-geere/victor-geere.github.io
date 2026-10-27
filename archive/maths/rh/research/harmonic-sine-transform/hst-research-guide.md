# Research Guide: Harmonic–Categorical Approach to ζ(s)

*Synthesising the HST Programme — maths/rh/geo/*

---

## 1. Purpose and Scope

This guide is a companion to the suite of papers in `maths/rh/geo/`. Its purpose is threefold:

- Give a **linear reading path** through the four source documents, explaining what each one contributes and what prerequisites it assumes.
- State the key definitions and theorems in **unified notation**, so a reader does not need to reconcile notation across papers.
- Map the open problems onto a **dependency graph**, so it is clear which problems unlock which.

The long-range goal of the programme is a Hilbert–Pólya realisation of the non-trivial zeros of the Riemann zeta function ζ(s) as the spectrum of a self-adjoint operator. No problem stated below assumes the Riemann Hypothesis; every one is independently well-posed.

---

## 2. Reading Order and Document Map

Read the source papers in this order. Each entry lists the central new object introduced and the main theorem proved.

| # | File | Phase | Central contribution |
|---|------|-------|----------------------|
| [1] | `harmonic-tree-haar.tex` | Foundations I | Greedy harmonic tree, Haar basis B, HST isometric isomorphism onto ℓ²(B) |
| [2] | `hst-research-programme.tex` | Foundations II | Eight precisely-stated open problems; logical dependency map |
| [3] | `harmonic-sine-transform-vs-fourier.tex` | Analytic comparison | HST vs Fourier; arithmetic sensitivity; resonance structure of zeros |
| [4] | `greedy-harmonic-zeta-function.tex` | Analytic core | Transfer operator ℒ_s, Fredholm determinant identity, Weil explicit formula |
| [5] | `hst-further-research.tex` | Synthesis | Full 11-problem programme across three phases |

### Prerequisites per document

- **[1]** Haar wavelets, Riesz bases, Hilbert–Schmidt operators.
- **[2]** Document [1]; classical Dirichlet series.
- **[3]** Documents [1]–[2]; Poisson summation.
- **[4]** All above; thermodynamic formalism, Ruelle zeta functions.

---

## 3. Unified Notation and Key Definitions

### 3.1 The greedy harmonic expansion

For θ ∈ [0,π], define binary digits δₙ(θ) ∈ {0,1} and remainders rₙ(θ) by

```
r₀ = θ/π,    δₙ = ⌊(n+2)rₙ⌋,    rₙ₊₁ = (n+2)rₙ − δₙ.
```

The **greedy harmonic expansion** is

```
θ/π = Σ_{n=0}^∞  δₙ(θ) / (n+2).
```

The map T: rₙ ↦ (n+2)rₙ mod 1 is uniformly expanding with a countable Markov partition. This is the dynamical system underlying the transfer operator.

### 3.2 The Haar basis and the HST

The **greedy harmonic tree** is the binary tree whose nodes at depth n are the intervals

```
I_{n,k} = { θ ∈ [0,π] : δ₀,…,δₙ₋₁ prescribed, δₙ = k },  k ∈ {0,1}.
```

For each internal node I_{n,k} with left child L and right child R, the **Haar wavelet** is

```
ψ_{n,k}(θ) = (1/√|L|) 1_L(θ) − (1/√|R|) 1_R(θ).
```

The collection B = {ψ_{n,k}} is an orthonormal basis of L²[0,π].

The **Harmonic Sine Transform** is the isometric isomorphism

```
H : L²[0,π] → ℓ²(B),    Hf = ( ⟨f, ψ⟩ )_{ψ ∈ B}.
```

> **⚠️ Pitfall.** An earlier version used the non-orthogonal centred basis
> eₙ(θ) = δₙ(θ) − θ/π and incorrectly claimed it formed a Riesz basis.
> The synthesis operator for {eₙ} is in fact **unbounded**.
> All current work uses the Haar basis B.

### 3.3 The greedy harmonic zeta function

For θ ∈ [0,π] and Re(s) > 1:

```
Φ(θ, s) = Σ_{n=0}^∞  δₙ(θ) / (n+2)^s.
```

This Dirichlet series continues meromorphically to ℂ via the resolvent of the transfer operator (Section 3.4). Its poles in the critical strip are exactly the non-trivial zeros of ζ(s).

### 3.4 The transfer operator

For Re(s) > 1, the **transfer operator** ℒ_s acts on a Hardy space by

```
(ℒ_s f)(z) = Σ_{n≥1}  f(Tₙ(z)) / (n+2)^s · Tₙ'(z),
```

where Tₙ ranges over the inverse branches of the Markov map T.

**Theorem (Trace-class).** For Re(s) > 1, ℒ_s is trace-class.

**Theorem (Fredholm determinant identity).**

```
det₍₁₎(I − ℒ_s) = ζ(s)/ζ(2s) · exp(P(s)),
```

where P(s) is entire and non-vanishing on the critical strip. Consequently, the zeros of ζ(s) in the critical strip are precisely the values of s for which 1 is an eigenvalue of ℒ_s.

**Theorem (Weil explicit formula).** For a suitable test function f, the smoothed sum of HST coefficients satisfies a Guinand–Weil formula summing over the non-trivial zeros ρ of ζ(s).

### 3.5 The quantum-Egyptian Dirichlet series

For an integral **modular tensor category** (MTC) C with global dimension D² and simple objects of quantum dimensions dᵢ, the Egyptian denominators are mᵢ = D²/dᵢ² and the associated Dirichlet series is

```
Ψ_{C,χ}(s) = Σᵢ χ(mᵢ) · mᵢ^{-s},
```

with Galois signs χ(mᵢ) ∈ {±1}. This series satisfies a Riemann-type functional equation (Geere 2026) via Poisson summation on the lattice realisation of C.

---

## 4. Logical Dependency Graph

An arrow A → B means a solution to A is expected to be an ingredient in B.

```
Phase I (Analytic Consolidation)
  P1 (Rigorous Fredholm identity)
    ├─→ P2 (Explicit residues)
    └─→ P3 (Trace-class extension)
              └─→ P8 (Spectral flow)
  P4 (Functional equation for HST)
    └─→ P7 (Universal limit)

Phase II (Categorical Synthesis)
  P5 (Limit Ψ_k → ζ)
    ├─→ P6 (Greedy–MTC bijection)
    │         └─→ P7
    └─→ P10 (Finite-dim approx)

Phase III (Operator Theory)
  P8 ──→ P9 (Unitary group / Hilbert–Pólya)
  P9,P10 ─→ P11 (Dirac operator)
```

**Recommended attack order within Phase I:** P1 → P3 → P2 → P4. Problem P1 is the load-bearing result for everything that follows.

---

## 5. Phase I: Analytic Consolidation

### Problem 1 — Rigorous Fredholm determinant identity

**Statement.** Provide a complete, self-contained proof that

```
det(I − ℒ_s) = ζ(s)/ζ(2s) · exp(P(s))    for Re(s) > 1,
```

and identify the entire factor exp(P(s)) explicitly.

**Background.** The corresponding result for the Gauss map was established by Mayer (1991) and Efrat (1993) via a comparison of the continued-fraction Markov partition with the spectral theory of SL(2,ℤ). The greedy harmonic map T has a *different* partition (one branch per positive integer rather than per rational), so a fresh calculation is required.

**Approach.**

1. Write down the full Markov partition of T (the preimages Tₙ⁻¹[0,1] for n ≥ 0) and compute the transition matrix.
2. Apply the Grothendieck–Lidskii trace formula:  log det(I−ℒ_s) = −Σ_{m≥1} (1/m) tr(ℒ_s^m).
3. Evaluate tr(ℒ_s^m) via the periodic orbits of T; this reduces to ζ(ms)/ζ(2ms) after summing over primitive orbits (Lüroth-type identification).
4. Show the entire factor arises from a convergent Euler product over primes of order ≥ 3 that cancels in the ratio.

> **Key identity.** tr(ℒ_s^m) = Σ_{period-m orbits} Π_{Tᵏx=x} |(Tᵐ)'(x)|^{-s}.
> For the greedy map each orbit gives a product of integers (nⱼ+2), leading to ζ(ms).

**References.** Mayer (1991), Ruelle (1994), Reed–Simon Vol. IV §XIII.17.

---

### Problem 2 — Explicit residues of Φ(θ,s)

**Statement.** Compute R(θ,ρ) = Res_{s=ρ} Φ(θ,s) for a non-trivial zero ρ, and express the pairing c_f(ρ) = ∫ f(θ) R(θ,ρ) dθ in terms of classical arithmetic data.

**Approach.**

1. Show Φ(θ,s) = ℒ_s(I−ℒ_s)⁻¹ **1**(θ) + g(s) where g(s) is holomorphic.
2. Compute the residue via R(θ,ρ) = ℒ_s Π_ρ **1**(θ), where Π_ρ is the Riesz spectral projector of ℒ_s at s = ρ.
3. Express Π_ρ **1** in terms of the left and right eigenfunctions ψ_ρ, ψ̃_ρ of ℒ_s at eigenvalue 1.
4. Relate c_f(ρ) to the von Mangoldt function via comparison with the Perron formula.

---

### Problem 3 — Trace-class extension to Re(s) > 1/2

**Statement.** Prove that ℒ_s is trace-class (or that ℒ_s² is trace-class) for all s with Re(s) > 1/2.

**Why this matters.** Without the extension to the critical strip, the Fredholm determinant is only defined on Re(s) > 1, and the identity det(I−ℒ_s) = ζ(s)/ζ(2s)·exp(P(s)) cannot be analytically continued to where the zeros of ζ live.

**Approach.**

1. Estimate singular values σⱼ(ℒ_s) via the Cauchy–Hadamard formula for the inverse branches. For the Gauss map the estimate σⱼ = O(j^{−Re(s)}) gives trace-class for Re(s) > 1 and Hilbert–Schmidt for Re(s) > 1/2.
2. For ℒ_s²: use ‖ℒ_s²‖₁ ≤ ‖ℒ_s‖₂² and show ℒ_s is Hilbert–Schmidt for Re(s) > 1/2.
3. Alternatively, use nuclear operator estimates on H²(D) via composition operator theory.

**Expected outcome.** ℒ_s² trace-class for Re(s) > 1/2 is likely achievable; full trace-class for ℒ_s itself may require the regularised determinant det₍₂₎.

---

### Problem 4 — Functional equation for the HST Dirichlet series

**Statement.** Derive a functional equation for D_f(s) = Σ_ψ ⟨f,ψ⟩ ‖ψ‖^{−2s} directly from the symmetries of the greedy tree.

**Approach.**

1. Construct a theta function Θ_f(t) = Σ_ψ |⟨f,ψ⟩|² exp(−t‖ψ‖²) using the Haar norms as the "length" substitute in a classical theta series.
2. Apply Poisson summation on the greedy tree (which, as a regular binary tree, carries natural automorphism symmetries).
3. Compare with the Quantum-Egyptian functional equation of Ψ_{C,χ} to identify the analogue of the Γ-factor.

---

## 6. Phase II: Categorical Synthesis

### Problem 5 — Rigorous limit Ψ_k → ζ

**Statement.** For the tower C_k = SU(2)_k, prove that Ψ_k(s)/Ψ_k(1/2) → ζ(2s)/ζ(1) locally uniformly as k → ∞.

**Background.** The simple objects of SU(2)_k are labelled j = 0, 1/2, …, k/2 with quantum dimensions dⱼ = sin((2j+1)π/(k+2)) / sin(π/(k+2)). The Egyptian denominators mⱼ = (k+2)²/dⱼ² become dense in ℝ_{>0} for large k.

**Approach.**

1. Express Ψ_k(s) as a Riemann-sum approximation to an integral over [0,π] and bound the error uniformly on compact subsets of Re(s) > 1.
2. Analyse the distribution of the Galois signs χ(mⱼ) using explicit formulae for the S-matrix of SU(2)_k (these are related to Gauss sums and equidistribute for large k).
3. Conclude by standard Dirichlet series convergence arguments.

---

### Problem 6 — Greedy–MTC correspondence

**Statement.** Find a bijection between nodes of the greedy harmonic tree and simple objects in the tower C_k, such that harmonic fractions π/(n+2) correspond to scaled Egyptian denominators.

**Heuristic.** The angle π/(n+2) labels the n-th level of the greedy tree; the principal angle of SU(2)_k at simple object j is (j+1)π/(k+2). Matching j+1 ↔ n+2 at level k = n suggests a diagonal correspondence.

**What to prove.**

1. Under the bijection, show Haar norms ‖ψ_{n,k}‖_{L²} match Egyptian denominators mⱼ^{-1/2} up to a scalar.
2. Show the resolvent of the transfer operator ℒ_s appears as the k → ∞ limit of the MTC resolvents (I − Ψ_k(s))⁻¹.

---

### Problem 7 — Universal attractor of categorical Dirichlet series

**Statement.** Determine whether ζ(s) is a universal attractor among limits of normalised categorical Dirichlet series over arbitrary towers of integral MTCs.

**Strategy.** By abstract ergodic theory, if the Egyptian denominators of C_k become equidistributed in ℝ_{>0} and the Galois signs converge to the Möbius function (or a Dirichlet character), then the limit should be a product over primes, i.e. a Dirichlet L-function. The precise universality statement would mirror Voronin's universality theorem for ζ(s).

---

## 7. Phase III: Operator Theory

### Problem 8 — Spectral flow of ℒ_{1/2+it}

**Statement.** Study the eigenvalues λⱼ(t) of ℒ_{1/2+it} as functions of t ∈ ℝ. Prove that each crossing λⱼ(t) = 1 occurs at a zero of ζ(1/2+it) and that crossings are simple.

**Approach.**

1. By the Fredholm identity, Π_j(1−λⱼ(t)) = det(I−ℒ_{1/2+it}) vanishes at zeros of ζ(1/2+it). One needs to separate which factor vanishes.
2. Use Rellich–Kato analytic perturbation theory to show λⱼ(t) is analytic in t and compute λⱼ'(t) in terms of the eigenvectors.
3. Simplicity of crossings would follow from non-degeneracy of eigenfunctions at s = 1/2+it₀.

> **Remark on RH.** If all eigenvalue paths λⱼ(t) remain real for t ∈ ℝ, this would imply all crossings occur on the line Re(s) = 1/2, proving the Riemann Hypothesis. Proving reality of eigenvalues is therefore a central goal.

---

### Problem 9 — Unitary group and its generator (Hilbert–Pólya)

**Statement.** Define U_t = ℒ_{1/2+it} ℒ_{1/2−it}⁻¹ and prove it is a strongly continuous one-parameter unitary group. Identify the generator H via Stone's theorem and show

```
Spec(H) = { γ : ζ(1/2 + iγ) = 0 }.
```

**This is the Hilbert–Pólya conjecture.** Achieving this would prove the Riemann Hypothesis, as the self-adjointness of H forces its spectrum to be real.

**Prerequisite.** Problem 3 is essential: without the trace-class extension to Re(s) = 1/2, the operator ℒ_{1/2−it} may not be invertible.

**Partial result available.** `harmonic-tree-haar.tex` establishes that H(t) = ℒ_{1/2+it} (ℒ_{1/2+it})* is self-adjoint and eigenvalue 1 of H(t) occurs exactly at Riemann zeros. This weaker statement gives a concrete self-adjoint family to work with.

---

### Problem 10 — Finite-dimensional approximations

**Statement.** For each k, construct a self-adjoint matrix Hₖ from MTC data of SU(2)_k whose eigenvalues approximate the imaginary parts of zeros of Ψ_k(1/2+it). Prove convergence of spectral measures.

**Construction strategy.**

1. Let Ψ_k(1/2+it) be the finite Dirichlet polynomial from Problem 5. Its zeros are computable numerically for small k.
2. Define Hₖ = (1/i)(d/dt) log Ψ_k(1/2+it) evaluated at a suitable discretisation, giving an (Nₖ × Nₖ) matrix where Nₖ = k/2 + 1.
3. Prove convergence of spectral measures μₖ = Σⱼ δ_{tⱼ^(k)} to μ = Σ_ρ δ_γ via moment calculations using Problem 5.

---

### Problem 11 — Dirac operator on the greedy harmonic tree

**Statement.** Construct a Dirac-type operator on the greedy harmonic tree (viewed as a metric graph) whose spectrum encodes the zeros of ζ(s).

**Background.** Connes–Consani associate a spectral triple (A, H, D) to the adèle class space, and the zeros of ζ appear absorbed into the spectrum of D. The greedy harmonic tree is a simpler geometric object that may admit a more explicit construction.

**Ingredients needed.**

1. A metric on the tree: assign length (n+2)⁻¹ to the edge at depth n, giving a tree of finite total length.
2. A Dirac operator D on L²(tree edges): on each edge D = −i d/dx with suitable boundary conditions at vertices.
3. Show the zeta function of D (i.e. tr(|D|^{−s})) has analytic properties related to ζ(s).

---

## 8. Numerical Verification Roadmap

Before tackling any analytic proofs, numerical checks provide essential evidence and intuition.

| # | What to compute | Tests which problem |
|---|-----------------|---------------------|
| N1 | Eigenvalues of truncated ℒ_s at s = 1/2+it; check crossings near γ₁ ≈ 14.13, γ₂ ≈ 21.02 | P8 |
| N2 | Zeros of Ψ_k(1/2+it) for k = 5,10,20,50 vs zeros of ζ | P5, P10 |
| N3 | Residue c_f(ρ₁) by numerical integration vs von Mangoldt prediction | P2 |
| N4 | Gram matrix K(n,m) = ⟨eₙ,eₘ⟩ for centred basis; verify it is NOT invertible | Pitfall check |

Starter code is in `riemann.py` in the same folder.

---

## 9. Prerequisites and Background Reading

### Essential

- **Analytic number theory:** Dirichlet series, Perron's formula, explicit formulae — Davenport, *Multiplicative Number Theory*.
- **Spectral theory:** Hilbert–Schmidt and trace-class operators, Fredholm determinants — Reed–Simon, *Methods of Modern Mathematical Physics*, Vol. IV.
- **Thermodynamic formalism:** Transfer operators, Ruelle zeta functions, Markov maps — Parry–Pollicott, *Zeta Functions and Periodic Orbit Structure*.
- **Wavelets:** Haar wavelets, multiresolution analysis — Daubechies, *Ten Lectures on Wavelets*.

### Useful but not essential

- Modular tensor categories — Turaev, *Quantum Invariants of Knots and 3-Manifolds*.
- Noncommutative geometry — Connes, *Noncommutative Geometry*.
- L-functions and automorphic forms — Iwaniec–Kowalski, *Analytic Number Theory*.

---

## 10. Summary Table

| P# | Short name | Key technique | Phase |
|----|------------|---------------|-------|
| P1 | Rigorous Fredholm identity | Ruelle zeta, Grothendieck trace | I |
| P2 | Explicit residues | Spectral projectors, Riesz | I |
| P3 | Trace-class extension | Singular value estimates | I |
| P4 | HST functional equation | Tree symmetry, theta series | I |
| P5 | Limit Ψ_k → ζ | Riemann sum, Galois sums | II |
| P6 | Greedy–MTC bijection | Fusion graphs, quantum dims | II |
| P7 | Universal attractor | Ergodic theory, Voronin | II |
| P8 | Spectral flow of ℒ_s | Analytic perturbation theory | III |
| P9 | Unitary group / Hilbert–Pólya | Stone's theorem | III |
| P10 | Finite-dim approximations | Spectral measures | III |
| P11 | Dirac operator | Metric graphs, spectral triples | III |

---

## 11. Epilogue

The programme is structured so that each phase delivers results of independent mathematical interest, regardless of whether the Riemann Hypothesis is ultimately resolved. Phase I produces a rigorous spectral theory of an explicit dynamical system. Phase II establishes deep connections between quantum topology and classical analytic number theory. Phase III, if completed, yields a concrete Hilbert–Pólya operator whose self-adjointness would imply the Riemann Hypothesis as a theorem.

> *The Riemann Hypothesis is the north star of this programme, not its prerequisite. Every problem along the way is worth solving on its own terms.*

---

## References

1. V. Geere, *harmonic-tree-haar.tex*, maths/rh/geo/, 2026.
2. V. Geere, *hst-research-programme.tex*, maths/rh/geo/, 2026.
3. V. Geere, *harmonic-sine-transform-vs-fourier.tex*, maths/rh/geo/, 2026.
4. V. Geere, *greedy-harmonic-zeta-function.tex*, maths/rh/geo/, 2026.
5. V. Geere, *hst-further-research.tex*, maths/rh/geo/, 2026.
6. D. H. Mayer, *The thermodynamic formalism approach to Selberg's zeta function for PSL(2,ℤ)*, Bull. Amer. Math. Soc. (N.S.) **25** (1991), 55–60.
7. I. Efrat, *Dynamics of the continued fraction map and the spectral theory of SL(2,ℤ)*, Invent. Math. **114** (1993), 207–218.
8. D. Ruelle, *Dynamical Zeta Functions for Piecewise Monotone Maps of the Interval*, CRM Monograph Series, AMS, 1994.
9. H. Davenport, *Multiplicative Number Theory*, 3rd ed., Springer, 2000.
10. M. Reed and B. Simon, *Methods of Modern Mathematical Physics*, Vol. IV, Academic Press, 1978.
11. W. Parry and M. Pollicott, *Zeta Functions and the Periodic Orbit Structure of Hyperbolic Dynamics*, Astérisque **187–188**, 1990.
12. I. Daubechies, *Ten Lectures on Wavelets*, SIAM, 1992.
13. A. Connes and C. Consani, *Schemes over 𝔽₁ and zeta functions*, Compos. Math. **146** (2010), 1383–1415.
14. H. Iwaniec and E. Kowalski, *Analytic Number Theory*, AMS, 2004.
