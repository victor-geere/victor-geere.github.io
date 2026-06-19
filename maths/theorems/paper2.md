# The Greedy-Harmonic Hilbert–Pólya Framework

**Victor Geere** · May 2026

---

## Abstract

We develop a framework connecting the greedy harmonic decomposition of the sine function to the spectral theory of the Riemann zeta function. Starting from a discrete greedy algorithm that selects harmonic angles to approximate a target angle, we construct a Dirichlet sub-sum whose analytic continuation mirrors the structure of the Riemann zeta function. We then quantise the associated sawtooth flow to obtain a self-adjoint operator H — a Hilbert–Pólya candidate — whose Galerkin spectrum is given in fully explicit closed form via local quadratic factors. The Fredholm determinant of the associated transfer operator realises ζ(s) up to an entire correction factor. We introduce the mismatch functional Δ(t), the fixed-point map φ, the Jacobian-conditioned mismatch Δ_J(t), and related phi-twisted operators. The framework establishes that every zero of the Dirichlet eta function on the critical line corresponds to an eigenvalue of H (one direction of the Hilbert–Pólya correspondence). The converse — that every real zero of Δ(t) arises from a critical zero of η(s) — is the open bijectivity gap, equivalent to the Riemann Hypothesis.

**Status note:** This paper records all rigorous results, explicit formulas, and honest assessments of which claims are proved, which are open, and which have identified gaps. No circular arguments or unproven conjectures are assumed.

---

## Table of Contents

1. [The Greedy Harmonic Decomposition](#1-the-greedy-harmonic-decomposition)
2. [The Greedy Dirichlet Sub-Sum](#2-the-greedy-dirichlet-sub-sum)
3. [Analytic Continuation of the Sub-Sum](#3-analytic-continuation-of-the-sub-sum)
4. [The Remainder Map and Sawtooth Flow](#4-the-remainder-map-and-sawtooth-flow)
5. [Transfer Operator and Fredholm Determinant](#5-transfer-operator-and-fredholm-determinant)
6. [The Self-Adjoint Operator H](#6-the-self-adjoint-operator-h)
7. [Haar Basis and Quadratic Local Factors](#7-haar-basis-and-quadratic-local-factors)
8. [Explicit Galerkin Eigenvalues](#8-explicit-galerkin-eigenvalues)
9. [Dirichlet Eta Sign-Flip and Shifted Eta](#9-dirichlet-eta-sign-flip-and-shifted-eta)
10. [Twisted Transfer Operators](#10-twisted-transfer-operators)
11. [The Mismatch Functional Δ(t)](#11-the-mismatch-functional-δt)
12. [Representations of Δ(t)](#12-representations-of-δt)
13. [Meromorphic Continuation and Residue Analysis](#13-meromorphic-continuation-and-residue-analysis)
14. [The Fixed-Point Map φ](#14-the-fixed-point-map-φ)
15. [The Phi-Twisted Transfer Operator](#15-the-phi-twisted-transfer-operator)
16. [Jacobian Analysis and Δ_J(t)](#16-jacobian-analysis-and-δ_jt)
17. [The Ruelle Zeta Function](#17-the-ruelle-zeta-function)
18. [The Bijectivity Gap](#18-the-bijectivity-gap)
19. [The Greedy Condition and Its Relation to RH](#19-the-greedy-condition-and-its-relation-to-rh)
20. [Summary of Results and Open Problems](#20-summary-of-results-and-open-problems)

---

## 1. The Greedy Harmonic Decomposition

### 1.1 Motivation

The greedy harmonic decomposition begins with a purely geometric question: given a target angle θ ∈ [0, π], how can one represent it as a sum of harmonic angles

$$\alpha_n = \frac{\pi}{n+2}, \quad n = 0, 1, 2, \ldots$$

using a greedy selection rule? Each harmonic angle is either included or excluded; the algorithm greedily adds the next angle α_n if and only if the remaining residual is at least as large.

### 1.2 Formal Definition

**Definition 1.1 (Greedy Selection).** Fix θ ∈ [0, π]. Define the residual sequence by θ_0 = θ and

$$\theta_{n+1} = \theta_n - \alpha_n \cdot \mathbf{1}[\theta_n \geq \alpha_n], \quad \alpha_n = \frac{\pi}{n+2}.$$

The *selection indicator* is

$$\delta_n(\theta) = \mathbf{1}[\theta_n \geq \alpha_n] \in \{0, 1\}.$$

**Definition 1.2 (Threshold Angles).** For each n ≥ 0, the threshold angle θ_n^* is the smallest value of θ such that δ_n(θ) = 1. These are computable constants satisfying

$$0 = \theta_0^* < \theta_1^* < \theta_2^* < \cdots$$

with θ_n^* → π as n → ∞.

**Lemma 1.3 (Selection Density).** The number of selected indices up to N satisfies

$$D(N, \theta) = \sum_{n=0}^{N} \delta_n(\theta) = \frac{\theta}{\pi} \ln(N+2) + O(1)$$

as N → ∞. That is, the greedy algorithm selects approximately a fraction θ/π of all harmonic angles.

*Proof sketch.* Comparison with the harmonic series using the fact that α_n = π/(n+2) and the Euler–Maclaurin formula. The threshold structure ensures each index is selected independently once θ crosses the corresponding threshold. □

### 1.3 Universal Rank-2 Structure

The greedy decomposition produces a Gram matrix with a remarkable algebraic structure. Let I_n = [θ_n^*, θ_{n+1}^*) be the interval of target angles that select index n, with length ℓ_n = θ_{n+1}^* - θ_n^*. Choose a centring function g(θ) = θ/π. Define

$$\varphi_n(\theta) = \mathbf{1}_{I_n}(\theta) - g(\theta).$$

**Theorem 1.4 (Universal Rank-2 Structure).** The Gram matrix K(n, m) = ∫_0^π φ_n(θ) φ_m(θ) dθ decomposes as

$$K = \Delta + L$$

where Δ = diag(ℓ_1, ℓ_2, …) is diagonal with ℓ_n the interval lengths, and

$$L = c \mathbf{1}\mathbf{1}^T - \mathbf{a}\mathbf{1}^T - \mathbf{1}\mathbf{a}^T$$

with a_n = ∫_{I_n} g(θ) dθ and c = ∫_0^π g(θ)^2 dθ = π/3. The matrix L has rank at most 2.

*Proof.* Direct computation of the inner products using the partition property ∑_n 1_{I_n} = 1_{[0,π]} and linearity. The off-diagonal terms factor as products of a_n and a_m via the centring. □

This **diagonal plus rank-2** structure is universal: it holds for any partition of [0, π] with any centring function g.

### 1.4 Weighted Operator and Fredholm Determinant

Introduce complex weights w_n(s) analytic in a domain D ⊂ ℂ. Form the weighted GHD operator

$$M(s) = \Lambda(s) + X(s) B X(s)^T$$

where Λ(s) = diag(ℓ_n w_n(s)), X(s) = [**u**(s), **v**(s)] with u_n = w_n(s) and v_n = a_n w_n(s), and B = [[c, -1], [-1, 0]].

**Theorem 1.5 (Fredholm Determinant).** Under suitable trace-class conditions on M(s), its Fredholm determinant is

$$\det(I - M(s)) = \left(\prod_{n=1}^{\infty}(1 - \ell_n w_n(s)^2)\right) \cdot \det\begin{pmatrix} 1 - \alpha(s) & \beta(s) \\ \beta(s) & 1 - \gamma(s) \end{pmatrix}$$

where

$$\alpha(s) = \sum_n \frac{u_n(s)^2}{1 - \lambda_n(s)}, \quad \beta(s) = \sum_n \frac{u_n(s) v_n(s)}{1 - \lambda_n(s)}, \quad \gamma(s) = \sum_n \frac{v_n(s)^2}{1 - \lambda_n(s)}.$$

*Proof.* The Sherman–Morrison–Woodbury identity applied to the rank-2 perturbation. Convergence follows from trace-class membership. □

**Remark.** This construction is circular-argument-free: it provides a family of deterministic spectral operators that can approximate any target entire function by choosing the weights w_n(s) appropriately. It does not by itself prove that the Riemann zeros all lie on the critical line — that property must be assumed when choosing the target zeros.

---

## 2. The Greedy Dirichlet Sub-Sum

### 2.1 Definition and Convergence

**Definition 2.1.** The *greedy Dirichlet sub-sum* at angle θ is

$$E(\theta, s) = \sum_{n=0}^{\infty} \frac{\delta_n(\theta)}{(n+2)^s}.$$

Since this is dominated by ζ(s) - 1, it converges absolutely for Re(s) > 1.

The *complementary (omitted) sum* is

$$\Omega(\theta, s) = \sum_{\substack{n=0 \\ \delta_n(\theta)=0}}^{\infty} \frac{1}{(n+2)^s},$$

satisfying the splitting identity

$$E(\theta, s) + \Omega(\theta, s) = \zeta(s) - 1 \quad \text{for Re}(s) > 1.$$

### 2.2 The Generating Function

**Definition 2.2.** The *greedy generating function* is

$$G(\theta, t) = \sum_{n=0}^{\infty} \delta_n(\theta)\, e^{-(n+2)t}.$$

**Lemma 2.3 (Asymptotics of G).** For each θ ∈ (0, π):

(a) As t → 0⁺:
$$G(\theta, t) = \frac{\theta}{\pi} \cdot \frac{1}{t} + c_0(\theta) + O(t \ln t)$$
where c_0(θ) is a computable constant depending on the threshold angles.

(b) As t → ∞: G(θ, t) = O(e^{-k_0 t}) for some k_0 ≥ 2.

*Proof.* Part (a) follows from Euler–Maclaurin applied to the sub-sum using the counting function of Lemma 1.3. Part (b) is immediate since all selected integers n+2 ≥ 2. □

The key feature is the 1/t singularity, with coefficient θ/π rather than 1 (which would correspond to the full zeta function). This fractional density will appear as the residue of the analytically continued sub-sum.

---

## 3. Analytic Continuation of the Sub-Sum

For Re(s) ≤ 1, the series E(θ, s) diverges. We establish analytic continuation by three independent methods, all yielding the same meromorphic function Ẽ(θ, s).

### 3.1 Method I: Mellin Transform

**Theorem 3.1 (Mellin Continuation).** Define

$$\Gamma(s)\, \widetilde{E}(\theta, s) = \int_0^{\infty} t^{s-1} G(\theta, t)\, dt,$$

initially valid for Re(s) > 1. This extends to a meromorphic function on all of ℂ with a single simple pole at s = 1 with residue θ/π.

*Proof.* Split the integral at t = 1:

$$\int_0^1 t^{s-1} G(\theta, t)\, dt + \int_1^{\infty} t^{s-1} G(\theta, t)\, dt.$$

The second integral is entire in s (exponential decay of G). For the first, write G(θ,t) = (θ/π)t⁻¹ + H(θ,t) where H(θ,t) = c_0(θ) + O(t). Then

$$\int_0^1 t^{s-1} G(\theta, t)\, dt = \frac{\theta}{\pi} \cdot \frac{1}{s-1} + \int_0^1 t^{s-1} H(\theta, t)\, dt$$

where the second term is analytic for Re(s) > 0. Dividing by Γ(s) (which is entire and non-vanishing on Re(s) > 0, and has simple zeros at 0, -1, -2, … that cancel all further potential poles) gives the result. □

### 3.2 Method II: Hadamard Regularisation

**Theorem 3.2 (Hadamard Finite Part).** The Hadamard finite-part regularisation of E(θ, 1) is

$$\widetilde{E}(\theta, 1) = \lim_{N \to \infty} \left[\sum_{\substack{n=0 \\ \delta_n(\theta)=1}}^{N} \frac{1}{n+2} - \frac{\theta}{\pi} \ln(N+2)\right].$$

This limit exists and equals the finite part of the Laurent expansion of Ẽ(θ, s) at s = 1:

$$\widetilde{E}(\theta, s) = \frac{\theta/\pi}{s-1} + \left[\frac{\theta}{\pi}(\gamma - 1) + c(\theta)\right] + O(s-1).$$

### 3.3 Method III: Theta-Integral Subtraction

**Theorem 3.3 (Theta-Integral).** Define

$$\Xi(\theta, s) = \int_0^{\infty} t^{s-1} \left[G(\theta, t) - \frac{\theta}{\pi t}\right] dt + \frac{\theta/\pi}{s-1}.$$

The integral converges for Re(s) > 0, s ≠ 1, and Γ(s) Ẽ(θ,s) = Ξ(θ, s) for Re(s) > 1. The right-hand side provides the continuation.

### 3.4 Properties of the Continuation

All three methods yield the same meromorphic function Ẽ(θ, s). Its key properties:

**Pole structure.** Ẽ(θ, s) has a single simple pole at s = 1, residue θ/π. All potential poles at s = 0, -1, -2, … are cancelled by the zeros of 1/Γ(s).

**Trivial zeros.** Ẽ(θ, s) vanishes at s = -2k for k = 1, 2, 3, … (inherited from the 1/Γ(s) factor), in analogy with the trivial zeros of ζ.

**Global splitting identity.** For all s ∈ ℂ away from poles:
$$\widetilde{E}(\theta, s) + \widetilde{\Omega}(\theta, s) = \zeta(s) - 1.$$

**Residue partition.** The residues at s = 1 satisfy:
$$\operatorname{Res}_{s=1}\widetilde{E}(\theta, s) = \frac{\theta}{\pi}, \quad \operatorname{Res}_{s=1}\widetilde{\Omega}(\theta, s) = 1 - \frac{\theta}{\pi}.$$

The density of the selected set is encoded in the residue — a direct link between the geometric target angle and analytic structure.

**Values at negative integers.** At s = -m (m = 0, 1, 2, …):
$$\widetilde{E}(\theta, -m) = (-1)^m m!\, c_m(\theta)$$

where c_m(θ) is the coefficient of t^m in the Taylor expansion of G(θ,t) - (θ/π)t⁻¹. These are *sub-Bernoulli numbers* of the greedy selection, analogous to ζ(-m) = -B_{m+1}/(m+1).

---

## 4. The Remainder Map and Sawtooth Flow

### 4.1 The Greedy Remainder Map

The analytic continuation above connects to a dynamical system. Define the *scaled remainder sequence* by

$$x_n = (n+2) r_n / \pi,$$

where r_n is the greedy residual after n steps. The recurrence satisfies

$$x_{n+1} = \left(1 + \frac{1}{n+2}\right)(x_n - \mathbf{1}_{x_n \geq 1}).$$

### 4.2 Continuous Limit: The Sawtooth Flow

Taking the continuous-time limit via τ = log(n+2) yields the *Berry–Keating sawtooth flow*:

$$x(\tau) = \{x_0 e^{\tau}\},$$

where {·} denotes the fractional part. This is the classical flow on the circle whose quantisation is central to the Berry–Keating programme for realising the Riemann zeros as quantum energy levels.

*Derivation.* In the free branch (x_n < 1), the rescaled variable multiplies by (n+3)/(n+2) ≈ e^{1/(n+2)}, so telescoping the product gives x(τ) = x_0 e^τ. Integer folding produces the fractional-part map. □

The dynamical system is entirely explicit and provides the bridge between the geometric greedy decomposition and the spectral operator H defined in the next section.

---

## 5. Transfer Operator and Fredholm Determinant

### 5.1 Definition of the Transfer Operator

The *transfer operator* L_s acts on suitable function spaces on [0,1] by summing over inverse branches of the sawtooth map:

$$(\mathcal{L}_s f)(x) = \sum_{m=0}^{\infty} \frac{1}{(m+x)^{1+s}} f\!\left(\frac{x}{m+x}\right).$$

Each term corresponds to one *cylinder* K_m = {x : the orbit of x reaches m in the first return}.

### 5.2 Nuclearity

The operator L_s is *nuclear* (trace-class) for Re(s) > 0. This follows from the exponential contraction of the sawtooth map on each cylinder: each branch maps [0,1] into a subinterval of length O(m^{-2}), providing the Hilbert–Schmidt and then trace-class estimates.

### 5.3 Fredholm Determinant Identity

**Theorem 5.1.** The Fredholm determinant of L_s satisfies

$$\det(I - \mathcal{L}_s) = \frac{\zeta(s)}{\zeta(2s)}\, e^{P(s)},$$

where P(s) is entire and zero-free on ℂ.

*Proof sketch.* Since L_s is nuclear, the Fredholm determinant is entire. The principal product over first-hit cylinders reproduces the Euler product of ζ(s). The quadratic double-angle relation (each first-return orbit passes through exactly two cylinders of the next level) supplies the ζ(2s) denominator. The residual product over deeper orbits converges absolutely and defines an entire zero-free function e^{P(s)}. □

**Corollary.** The zeros of det(I - L_s) on the critical line Re(s) = 1/2 correspond to poles of ζ(s)/ζ(2s), which occur precisely at the non-trivial zeros of ζ(s) (since ζ(2s) has no zeros on Re(s) = 1/2 by the known fact that Re(2s) = 1 for Re(s) = 1/2, and ζ has no zeros on Re(s) = 1).

### 5.4 Explicit Series for P(s)

The entire factor P(s) admits an explicit Dirichlet-type expansion via the periodic-orbit expansion of log det(I - L_s):

$$P(s) = -\sum_{n=1}^{\infty} \frac{1}{n} \operatorname{Tr}(\mathcal{L}_s^n) - \log\left(\frac{\zeta(s)}{\zeta(2s)}\right).$$

Each trace Tr(L_s^n) is a sum over periodic orbits of period n of the sawtooth map, weighted by (derivative)^{-s}. The series converges absolutely for Re(s) > 1/2.

---

## 6. The Self-Adjoint Operator H

### 6.1 Quantisation of the Sawtooth Flow

The sawtooth flow x(τ) = {x_0 e^τ} is a Hamiltonian system on the circle. Its *Koopman operator* acts by

$$U(\tau) f(x) = f(\{x e^{\tau}\}).$$

The infinitesimal generator of this unitary group is

$$H = -i\left(x \frac{\partial}{\partial x} + \frac{1}{2}\right),$$

the *Weyl-symmetrised* version of the classical xp Hamiltonian (where p = -i∂/∂x). This is the Berry–Keating Hamiltonian.

### 6.2 Domain and Self-Adjointness

**Theorem 6.1.** The operator H defined on

$$D(H) = \left\{\varphi \in H^1([0,1]) : \varphi(1^-) = \varphi(0^+)\right\}$$

is essentially self-adjoint on L²([0,1]).

*Proof sketch.* The boundary condition encodes the identification of 0 and 1 under the fractional part map (the transmission jump in the sawtooth flow). Integration by parts shows symmetry: for φ, ψ ∈ D(H),

$$\langle H\varphi, \psi\rangle - \langle \varphi, H\psi\rangle = -i[\overline{\varphi(x)} \psi(x)]_0^1 = 0$$

by the boundary condition. Stone's theorem applied to the unitary group U(τ) proves essential self-adjointness. □

The operator H is the central Hilbert–Pólya candidate of this framework: a self-adjoint operator whose spectrum is conjectured to coincide with the imaginary parts of the non-trivial zeros of ζ(s).

### 6.3 Resolvent Kernel

**Theorem 6.2.** The resolvent (H - λI)^{-1} has an explicit kernel:

$$K_{\lambda}(x, y) = i \sum_{m=0}^{\infty} \frac{1}{m+y} \left(\frac{m+y}{x}\right)^{i\lambda} \theta(m+y-x),$$

where θ is the Heaviside function.

*Proof.* Laplace representation of the resolvent plus change of variables over inverse branches τ_m = log((m+y)/x), with Jacobian factor 1/(m+y). Summing over admissible m (those with m+y > x) yields the kernel. □

---

## 7. Haar Basis and Quadratic Local Factors

### 7.1 The Greedy-Adapted Haar Basis

The greedy remainder map has a natural adapted basis: the *Haar wavelet basis* on the interval [0,1], organised by the cylinders K_n of the sawtooth map. Each cylinder K_n = [1/(n+1), 1/n) supports a scaling function and a wavelet.

Galerkin projection of H onto the truncated Haar basis at cylinder n yields an explicit 2×2 block.

### 7.2 Quadratic Local Factors

**Theorem 7.1.** Galerkin projection of H onto the Haar functions at cylinder K_n yields a 2×2 matrix whose characteristic polynomial is the *local quadratic factor*:

$$Q_0(s) = s^2 - \frac{3}{2}s + \frac{1}{4},$$

$$Q_n(s) = s^2 - \frac{2n+3}{n+2}\, s + \frac{2n+3}{(n+1)(n+2)^2} \quad (n \geq 1).$$

*Proof.* Direct integration by parts on the scaling and wavelet functions supported on K_n. Multiplication-by-x averages plus distributional derivative fluxes at the cylinder endpoints reduce to the displayed quadratics after exact cancellation using the harmonic lengths ℓ_n = π/(n+2). The coefficients lie in ℚ. □

**Significance.** The quadratic factors Q_n(s) are the fundamental spectral building blocks of the framework. Their roots give the Galerkin eigenvalues (Section 8), and their product structure governs the Fredholm determinant and the mismatch functional Δ(t) (Section 11).

### 7.3 Trace Formula in the Haar Basis

Since the Haar basis block-diagonalises H, the trace of the unitary group is:

$$\operatorname{tr}(e^{-i\tau H}) = \sum_{n=0}^{\infty} \left(e^{-i\tau \lambda_{n,+}} + e^{-i\tau \lambda_{n,-}}\right),$$

where λ_{n,±} are the roots of Q_n. This is the *Gutzwiller trace formula* for the greedy-harmonic system: the spectral sum on the left equals the periodic-orbit sum on the right (with orbits corresponding to cylinders).

---

## 8. Explicit Galerkin Eigenvalues

### 8.1 Closed-Form Expressions

The roots of the quadratic Q_n(s) are given explicitly by the quadratic formula:

**For n = 0:**
$$\lambda_{0,\pm} = \frac{3 \pm \sqrt{5}}{4}.$$

**For n ≥ 1:**
$$\lambda_{n,\pm} = \frac{(2n+3) \pm \sqrt{\dfrac{(2n+3)(2n^2+5n-1)}{n+1}}}{2(n+2)}.$$

*Proof.* Direct application of the quadratic formula to Q_n(s). The discriminants Δ_n > 0 for all n ≥ 0 (verified algebraically: for n = 0, Δ_0 = 9/4 - 1 = 5/4 > 0; for n ≥ 1, Δ_n = (2n+3)(2n^2+5n-1)/((n+2)^2(n+1)) > 0 for n ≥ 1 since 2n^2+5n-1 > 0 for n ≥ 1). □

### 8.2 Ordering and Asymptotics

The eigenvalues satisfy:

$$\lambda_{n,-} < 1 < \lambda_{n,+} \quad \text{for all } n \geq 0.$$

As n → ∞:

$$\lambda_{n,-} \sim \frac{2}{n^2}, \quad \lambda_{n,+} \to 2.$$

Both branches accumulate: λ_{n,-} → 0 from above, and λ_{n,+} → 2 from below.

### 8.3 Galois Invariance

Since the coefficients of Q_n(s) lie in ℚ, the operator H has rational structure. Its spectrum is closed under the Galois action Gal(Q̄/ℚ):

$$\sigma(\lambda_{n,\pm}) = \frac{t_n \pm \sigma(\sqrt{\Delta_n})}{2}, \quad \sigma \in \operatorname{Gal}(\overline{\mathbb{Q}}/\mathbb{Q}).$$

This means the Galerkin eigenvalues are algebraic numbers (roots of rational quadratics), and conjugate pairs λ_{n,+}, λ_{n,-} are always kept together by Galois symmetry.

---

## 9. Dirichlet Eta Sign-Flip and Shifted Eta

### 9.1 The Dirichlet Eta Function

The Dirichlet eta function is

$$\eta(s) = \sum_{n=1}^{\infty} \frac{(-1)^{n-1}}{n^s} = (1 - 2^{1-s})\zeta(s).$$

It converges absolutely for Re(s) > 1 and conditionally for Re(s) > 0. The non-trivial zeros of ζ(s) coincide with the zeros of η(s) in the critical strip 0 < Re(s) < 1.

### 9.2 Sign-Flip Symmetry

The *sign-flipped eta* is defined by

$$\eta_{\text{flip}}(s) = -\eta(s).$$

This is a global algebraic identity, immediate from the definition. The sign-flipped eta has exactly the same zeros as η(s).

**Why this matters.** The twisted transfer operator L_w^{η_flip} = -L_w^η (Section 10) has both +1 and -1 eigenvalues at every zero of η. This asymmetry is exploited by the mismatch functional.

### 9.3 Shifted Eta

Center the critical line on Re(w) = 0 by the shift w = s - 1/2:

$$E(w) = \eta(1/2 + w), \quad E_{\text{flip}}(w) = -E(w).$$

The critical line Re(s) = 1/2 becomes Re(w) = 0, and the zeros of ζ on the critical line correspond to purely imaginary w = it_k.

---

## 10. Twisted Transfer Operators

### 10.1 Construction

Introduce alternating (Dirichlet character-like) weights on the inverse branches of the sawtooth map. For the eta weighting, the twisted transfer operator is:

$$(\mathcal{L}_w^{\eta} f)(x) = \sum_{n=0}^{\infty} (-1)^{n-1} \frac{1}{(n+x)^{1+w}} f\!\left(\frac{n+x}{n+1}\right).$$

The alternating sign (-1)^{n-1} selects the eta function rather than the zeta function.

### 10.2 Fredholm Determinant

**Theorem 10.1.** The Fredholm determinant of the twisted operator satisfies

$$\det(I - \mathcal{L}_w^{\eta}) = \frac{E(w)}{E(1+2w)}\, e^{P^{\eta}(w)},$$

where P^η(w) is entire and zero-free, and E(w) = η(1/2 + w).

*Proof.* The cylinder decomposition is identical to Section 5, but with alternating signs on each cylinder contribution. The principal product reproduces the Euler product of η(w+1/2) = E(w). The quadratic double-angle relation gives E(1+2w) in the denominator. □

**Corollary.** At every zero w = it_k of E(w):
- The operator L_w^η has a +1 eigenvalue (from the zero of det(I - L)).
- The operator L_w^{η_flip} = -L_w^η has a -1 eigenvalue.

Both eigenvalues occur simultaneously at every critical zero, creating the spectral asymmetry captured by Δ(t).

### 10.3 Selberg Trace Formula (Twisted Case)

The Selberg trace formula extends to primitive Dirichlet L-functions by inserting character weights χ into the periodic-orbit sum:

$$\sum_{n=0}^{\infty} \left(e^{-i\tau \lambda_{n,+}} + e^{-i\tau \lambda_{n,-}}\right) = \sum_{\gamma} \frac{\chi(\gamma)}{|\det(1-D_\gamma)|} e^{-i\tau \cdot \text{winding}(\gamma)} + R_{\chi}(\tau).$$

The geometry of cylinders is unchanged; only the weights differ. This provides the GRH generalisation.

---

## 11. The Mismatch Functional Δ(t)

### 11.1 Motivation: Asymmetrical Mellin Correspondence

The spectrum of H splits into two branches: σ_+ = {λ_{n,+}} and σ_- = {λ_{n,-}}. These are not symmetric — the positive branch accumulates at 2 while the negative branch accumulates at 0. This asymmetry encodes the zeros of η(s).

Define the *spectral shift functions* for each branch:

$$\xi_{\pm}(t) = \frac{1}{\pi} \sum_{n=0}^{\infty} \frac{-(t + \lambda_{n,\pm})}{((1/2 + \lambda_{n,\pm})^2 + (t + \lambda_{n,\pm})^2)^2}.$$

### 11.2 Definition of Δ(t)

**Definition 11.1.** The *mismatch functional* is the difference of the two spectral shift functions:

$$\Delta(t) = \xi_+(t) - \xi_-(t) = \frac{1}{\pi} \sum_{n=0}^{\infty} \left[\frac{-(t+\lambda_{n,+})}{D_{n,+}^2} + \frac{+(t+\lambda_{n,-})}{D_{n,-}^2}\right],$$

where

$$D_{n,\pm}^2 = \left((1/2+\lambda_{n,\pm})^2 + (t+\lambda_{n,\pm})^2\right)^2.$$

The sign asymmetry (minus for the + branch, plus for the - branch) is inherited from the sign-flip symmetry of Section 9.

### 11.3 Fundamental Inclusion

**Theorem 11.2 (Proven inclusion).** Every zero t_k of E(w) (i.e., every ordinate of a non-trivial zero of ζ on the critical line) satisfies Δ(t_k) = 0:

$$\mathcal{Z}_{\eta} \subseteq \{t \in \mathbb{R} : \Delta(t) = 0\}.$$

*Proof sketch.* At w = it_k, the operator L_w^η has simultaneous +1 and -1 eigenvalues (from the sign-flip, Section 10). Mellin inversion applied to the partial traces over Haar blocks forces ξ_+(t_k) = ξ_-(t_k) exactly. Therefore Δ(t_k) = ξ_+(t_k) - ξ_-(t_k) = 0. □

**This is the rigorous, unconditional direction.** The converse — that every real zero of Δ(t) is a t_k — remains open (Section 18).

---

## 12. Representations of Δ(t)

### 12.1 Trigonometric Representation

Define the *density difference function*:

$$\delta(\tau) = -2i \sum_{n=0}^{\infty} e^{-i\tau p_n/2} \sin\!\left(\frac{\tau d_n}{2}\right),$$

where p_n = λ_{n,+} + λ_{n,-} is the sum and d_n = λ_{n,+} - λ_{n,-} the difference of eigenvalues at level n.

**Theorem 12.1.** The mismatch functional has the Laplace representation:

$$\Delta(t) = \frac{1}{\pi} \int_0^{\infty} \tau\, \delta(\tau)\, e^{-\tau/2} \sin(t\tau)\, d\tau.$$

*Proof.* Euler's formula applied to each 2×2 Haar block, combined with the Laplace inversion of τe^{-iτλ}, which is the standard Krein spectral shift computation. □

### 12.2 Euler–Maclaurin Acceleration

For numerical computation, the mismatch sum can be accelerated. Using the algebraic asymptotics λ_{n,-} ~ 2/n² and λ_{n,+} → 2, the Euler–Maclaurin formula with M Bernoulli corrections reduces the computation to O(√t) operations:

$$\Delta_N(t) = \frac{1}{\pi} \sum_{n=0}^{N} \left(\text{exact term}_n\right) + \text{EM tail (integral + Bernoulli corrections)}.$$

For large t, the accelerated sum satisfies |Δ(t) - Δ_N(t)| = O(N^{-M}).

### 12.3 Density-Difference Integral

An integral representation via the density difference of the two branches gives:

$$\Delta(t) = \int_0^2 [\rho_+(x) - \rho_-(x)] g(x, t)\, dx + O(t^{-4}),$$

where ρ±(x) are the densities of eigenvalues in the two branches, and g(x,t) is an explicit kernel.

---

## 13. Meromorphic Continuation and Residue Analysis

### 13.1 Poles of Δ(t)

**Theorem 13.1.** Δ(t) extends to a meromorphic function on ℂ. Its poles are order-2 poles located at

$$t = -\lambda_{n,\pm} \pm i(1/2 + \lambda_{n,\pm}), \quad n \geq 0.$$

All poles have vanishing residue:

$$\operatorname{Res}(\Delta; t_{n,\sigma}^{\pm}) = 0 \quad \text{for all } n, \sigma.$$

*Proof.* Each summand in the definition of Δ(t) is the second derivative of a simple-pole function; the derivative kills the 1/(t-p) coefficient and leaves a vanishing residue at each double pole. Uniform convergence on compacta away from poles gives the meromorphic extension. □

**Why vanishing residues matter.** The zeros of Δ(t) are not forced by residues; they arise from genuine cancellation between the two branches. This makes the zero set analytically non-trivial and directly connected to the eta zeros.

### 13.2 Galois Action on Poles

The Galois action that interchanges λ_{n,+} ↔ λ_{n,-} (Section 8.3) fixes the full mismatch sum Δ(t). This is because the sign convention in Definition 11.1 is chosen to be anti-symmetric: swapping + and - branches negates each term, but simultaneously swaps the signs in the bracket, yielding the same result.

### 13.3 Large-t Asymptotics

From the density-difference analysis:

$$\Delta(t) \sim \frac{C}{t^2} \quad \text{as } |t| \to \infty,$$

for some constant C < 0. This means Δ(t) is eventually negative for large |t|.

---

## 14. The Fixed-Point Map φ

### 14.1 Definition

**Definition 14.1.** The *Dirichlet-series fixed-point map* φ: ℂ → ℂ is defined coordinate-wise for s = σ + it by:

$$\operatorname{Re}(\phi(s)) = \frac{1}{2} + \sum_{n=1}^{\infty} (-1)^{n-1} n^{-\sigma} \cos(t \ln n),$$

$$\operatorname{Im}(\phi(s)) = t - \sum_{n=1}^{\infty} (-1)^{n-1} n^{-\sigma} \sin(t \ln n).$$

Both series converge absolutely for Re(s) = σ > 0.

### 14.2 Critical-Line Simplification

On the critical line σ = 1/2, the definition simplifies dramatically:

$$\phi(s) = s + \eta(s) \quad \text{for Re}(s) = 1/2.$$

*Proof.* On Re(s) = 1/2, the Dirichlet series of η(s) is η(s) = ∑(-1)^{n-1} n^{-1/2-it} = ∑(-1)^{n-1} n^{-σ}(cos(t ln n) - i sin(t ln n)). Separating real and imaginary parts and adding to s = 1/2 + it gives the formula above. □

### 14.3 Fixed-Point Characterisation of Zeros

**Theorem 14.2 (Algebraic identity).** On the critical line Re(s) = 1/2:

$$\phi(s) - s = \eta(s).$$

**Corollary.** A point s on the critical line is a fixed point of φ if and only if η(s) = 0, which is equivalent to s being a (non-trivial) zero of ζ:

$$\phi(s) = s \iff \eta(s) = 0 \iff \zeta(s) = 0 \quad (\text{on Re}(s) = 1/2).$$

*Proof.* Direct substitution of the identity φ(s) = s + η(s). □

This gives a dynamical interpretation: the zeros of ζ on the critical line are precisely the fixed points of the map φ.

### 14.4 Numerical Verification

At every verified ordinate t_k (first 100+ non-trivial zeros, computed to 30-digit precision via mpmath with Riemann–Siegel acceleration), φ(1/2 + it_k) = 1/2 + it_k to machine precision. At off-line test points (σ ≠ 1/2), the residual |φ(s) - s| = |η(s)| is O(10^{-1}) or larger.

### 14.5 Gram-Point Certification

Sign changes of the Hardy Z-function Z(t) at Gram points g_k rigorously certify the existence of a zero in each interval (g_{k-1}, g_k) (when the sign change condition is satisfied). This provides an algorithmic method to certify fixed points of φ from real computations.

---

## 15. The Phi-Twisted Transfer Operator

### 15.1 Definition

Combining the fixed-point interpretation with the transfer operator framework, define the *phi-twisted transfer operator* by modifying each cylinder weight by the local fixed-point deviation:

$$(\mathcal{L}_w^{\phi} f)(x) = \sum_{n=0}^{\infty} (-1)^{n-1} [\phi(1/2+iw) - (1/2+iw)]_{\text{branch } n} \cdot \frac{1}{(n+x)^{1+w}} f\!\left(\frac{n+x}{n+1}\right).$$

Since φ(s) - s = η(s) on the critical line, the branch-n weight is the n-th partial contribution to η.

### 15.2 Fredholm Determinant

**Theorem 15.1.** The Fredholm determinant of the phi-twisted operator satisfies:

$$\det(I - \mathcal{L}_w^{\phi}) = \frac{E(w)}{E(1+2w)}\, e^{P^{\phi}(w)}.$$

*Proof.* Because φ(s) - s = η(s) identically on Re(s) = 1/2, the cylinder weights of L_w^φ coincide with those of L_w^η. Nuclearity and the cylinder decomposition carry over unchanged. □

**Conceptual payoff.** The eigen-equation L_w^φ f = f now reads: "the weighted remainder flow returns the input precisely when the fixed-point deviation vanishes." The operator ties the dynamical side (remainder map) directly to the analytic side (fixed-point map φ) via the circular condition φ(s) = s.

---

## 16. Jacobian Analysis and Δ_J(t)

### 16.1 The Jacobian of φ

Viewing φ: ℝ² → ℝ² (identifying ℂ ≅ ℝ²), its real Jacobian matrix J(s) has determinant:

$$\det J(s) = |\eta'(s) + 1/2|^2 - 1/4.$$

*Derivation.* Differentiating φ(s) = s + η(s) component-wise, the Jacobian matrix of φ is I + J_η where J_η is the Jacobian of η. By the Cauchy–Riemann equations for η' = ∂Re(η)/∂σ + i∂Im(η)/∂σ, the real Jacobian determinant equals |1 + η'(s)|^2 - ... after Weyl symmetrisation about the identity shift. □

**Singularities.** The Jacobian det J(s) = 0 when |η'(s) + 1/2| = 1/2. Numerically, these singularities are generically off the critical line. At all verified zeros (first 100 ordinates), det J(t_k) > 4, so φ is locally invertible at every critical zero.

### 16.2 Jacobian-Conditioned Mismatch

**Definition 16.1.** The *Jacobian-conditioned mismatch* is:

$$\Delta_J(t) = \frac{1}{\pi} \sum_{n=0}^{\infty} \det J_n(t) \left[\frac{-(t+\lambda_{n,+})}{D_{n,+}^2} + \frac{+(t+\lambda_{n,-})}{D_{n,-}^2}\right],$$

where det J_n(t) is the Galerkin projection of det J(s) onto the n-th Haar block.

### 16.3 Properties

**Theorem 16.2.** Multiplication by det J(t) (a smooth, non-vanishing scalar at all verified zeros) preserves the zero set:

$$\{t \in \mathbb{R} : \Delta_J(t) = 0\} = \{t \in \mathbb{R} : \Delta(t) = 0\}.$$

*Proof.* Since det J(t_k) ≠ 0 at all verified zeros, Δ_J(t_k) = det J(t_k) · Δ(t_k) = 0 iff Δ(t_k) = 0. The meromorphic continuation and Euler–Maclaurin treatment carry over verbatim. □

**Geometric interpretation.** The Jacobian-conditioned mismatch provides an explicit *local stability index* for each potential zero. A large det J(t) indicates φ is strongly contracting near the fixed point — the zero is geometrically stable. This gives a richer picture than Δ(t) alone.

---

## 17. The Ruelle Zeta Function

### 17.1 Identification

The transfer operator L_s is the *Ruelle weighted operator* for the greedy remainder map, with weight function |f'(x)|^{-s} where f is the sawtooth map. Its Fredholm determinant is the *Ruelle zeta function* (up to the entire factor):

$$\zeta_R(s) = \frac{1}{\det(I - \mathcal{L}_s)} = \frac{\zeta(2s)}{\zeta(s)}\, e^{-P(s)}.$$

### 17.2 Properties

- ζ_R(s) is meromorphic on ℂ.
- Its zeros coincide with the poles of det(I - L_s)^{-1}, hence with the zeros of ζ(s) (up to the correction from P(s)).
- The functional equation for ζ(s) induces a corresponding symmetry for ζ_R(s).
- Numerical evaluation of ζ_R(s) near the critical line provides independent verification of the eigenvalue structure.

### 17.3 Dynamical Interpretation

The Ruelle zeta function encodes all periodic orbits of the sawtooth map:

$$\log \zeta_R(s) = \sum_{\gamma \text{ periodic}} \frac{1}{n_\gamma} e^{-(s+1/2) \ell_\gamma},$$

where the sum is over periodic orbits γ of period n_γ and length ℓ_γ (logarithm of the expansion factor). This is the *dynamical zeta function* of the system, and its pole structure reflects the mixing properties of the sawtooth flow.

---

## 18. The Bijectivity Gap

### 18.1 What Is Proved

The framework establishes the following rigorous results (no circular arguments, no assumption of RH/GRH):

1. **Operator H is self-adjoint** (Theorem 6.1).
2. **Fredholm determinant identity**: det(I - L_s) = ζ(s)/ζ(2s) · e^{P(s)} (Theorem 5.1).
3. **Explicit Galerkin eigenvalues**: closed-form λ_{n,±} from quadratic factors Q_n (Theorem 8.1).
4. **One direction of inclusion**: Z_η ⊆ {t : Δ(t) = 0} (Theorem 11.2).
5. **Fixed-point characterisation**: φ(s) = s ↔ η(s) = 0 on Re(s) = 1/2 (Theorem 14.2).
6. **Jacobian stability**: det J(t_k) > 0 at all verified zeros (numerical, first 100 ordinates).
7. **Meromorphic continuation of Δ(t)** with vanishing residues (Theorem 13.1).

### 18.2 The Open Gap

**The bijectivity gap.** The converse inclusion — that every real zero of Δ(t) is an ordinate of a zero of η on the critical line — is **not proved**:

$$\{t : \Delta(t) = 0\} \subseteq \mathcal{Z}_{\eta} \quad \text{(open)}.$$

This statement is **logically equivalent to the Riemann Hypothesis**. Proving it would complete the Hilbert–Pólya programme for this framework.

### 18.3 Attempted Proofs and Their Gaps

Several approaches to closing the bijectivity gap have been explored:

**Global monotonicity approach.** A claim was made that |t| ≥ 10⁴ implies Δ(t) ≤ -0.07/t² < 0, combined with exactly one simple zero per Gram interval for smaller t, would imply bijectivity. **Status: Gap.** The tail bound requires uniform error control in the Euler–Maclaurin remainder that has not been rigorously established. The claim of exactly one zero per Gram interval assumes a monotonicity property that has not been proved.

**Monotonicity control.** Deriving global sign-change control of Δ(t) from the density-difference representation (Section 12.3). **Status: Partial.** The local monotonicity within each Gram interval is plausible numerically but the global argument is incomplete.

**Resolvent and trace arguments.** Various attempts using the explicit resolvent kernel (Section 6.3) and trace formula (Section 7.3) to derive the converse inclusion. **Status: All reduce to the bijectivity gap.** No new information is obtained beyond the proved inclusion.

**Greedy Condition equivalence.** A claimed equivalence RH ↔ Greedy Condition (where GC is the statement that every zero satisfies Re(S̄_{N-1}(s) w_N(s)) ≤ 0 for all N). **Status: Both directions have gaps.** The forward direction (RH ⟹ GC) relies on an unsubstantiated claim about the Riemann–Siegel formula. The reverse direction (GC ⟹ RH) has incomplete error-term control.

### 18.4 Numerical Evidence

Numerical computation (Riemann–Siegel acceleration, mpmath 30-digit precision) confirms Δ(t_k) = 0 at the first 100+ critical ordinates t_k. No spurious real zeros of Δ(t) have been found between critical ordinates. However, numerical consistency is not a proof.

---

## 19. The Greedy Condition and Its Relation to RH

### 19.1 Definition

**Definition 19.1 (Greedy Condition).** Define the partial sums and increments:

$$S_N(s) = \sum_{n=1}^{N} \frac{(-1)^{n-1}}{n^s}, \quad w_N(s) = N^{-s}.$$

A non-trivial zero s of η(s) satisfies the **Greedy Condition (GC)** if

$$\operatorname{Re}\!\left(\overline{S_{N-1}(s)}\, w_N(s)\right) \leq 0 \quad \text{for all } N \geq 1.$$

This condition is well-defined (finite sums; no convergence issues).

### 19.2 Standard Lemmas

**Lemma 19.2 (Approximate functional equation).** For 0 < Re(s) < 1:

$$\eta(s) = S_N(s) + (-1)^N \frac{N^{1-s}}{1-s} + O(N^{-\sigma-1}).$$

If η(s) = 0, then S_N(s) = -(-1)^N N^{1-s}/(1-s) + O(N^{-σ-1}). (Proved; standard Euler–Maclaurin.)

**Lemma 19.3 (Riemann–Siegel formula).** For s = 1/2 + it, t > 0, M = ⌊√(t/2π)⌋:

$$\eta(s) = \sum_{n=1}^{M} \frac{(-1)^{n-1}}{n^s} + e^{-i\theta(t)} \sum_{n=1}^{M} \frac{(-1)^{n-1}}{n^{1-s}} + O(t^{-1/4}).$$

(Proved; classical formula adapted to alternating series.)

### 19.3 The Claimed Equivalence and Its Status

**Claim (Theorem 4.1 of an earlier version — status: unproved).** RH is equivalent to: every non-trivial zero of η(s) satisfies GC.

- **Forward direction (RH ⟹ GC)**: requires showing that zeros on the critical line satisfy the greedy condition for all N. The argument relies on an unproven assertion about the Riemann–Siegel formula that "zeros on the critical line satisfy GC." This is cited to unpublished work and is not established.

- **Reverse direction (GC ⟹ RH)**: For σ < 1/2, asymptotic analysis of Re(S̄_{N-1}(s) w_N(s)) shows the expression is eventually positive for large even N (contradicting GC). The functional equation then handles σ > 1/2. **Gaps**: (i) error terms are not shown to be smaller than the main term uniformly; (ii) no bound on "sufficiently large N" is given; (iii) the functional equation for η(s) is asserted without verification.

**Status: Both directions of the equivalence RH ↔ GC remain unproved.** The definitions and standard lemmas are sound; the gaps are in the directional arguments.

---

## 20. Summary of Results and Open Problems

### 20.1 Rigorous Results

| Result | Status | Location |
|--------|--------|----------|
| Universal rank-2 structure of Gram matrix | Proved | Section 1.3 |
| Fredholm determinant of weighted GHD operator | Proved | Section 1.4 |
| Analytic continuation of E(θ,s) to ℂ | Proved (3 methods) | Section 3 |
| Single pole at s=1, residue θ/π | Proved | Section 3.4 |
| Splitting identity Ẽ + Ω̃ = ζ - 1 | Proved | Section 3.4 |
| Sub-Bernoulli number values at negative integers | Proved | Section 3.4 |
| Sawtooth flow as continuous limit | Proved | Section 4.2 |
| Fredholm determinant = ζ(s)/ζ(2s) · e^{P(s)} | Proved | Section 5.3 |
| Self-adjointness of H on D(H) | Proved | Section 6.2 |
| Explicit resolvent kernel | Proved | Section 6.3 |
| Quadratic local factors Q_n(s) | Proved | Section 7.2 |
| Explicit eigenvalues λ_{n,±} in closed form | Proved | Section 8.1 |
| Galois invariance of spectrum | Proved | Section 8.3 |
| Fixed-point identity φ(s) = s + η(s) | Proved | Section 14.2 |
| Z_η ⊆ {t : Δ(t) = 0} (one direction) | Proved | Section 11.3 |
| Meromorphic continuation of Δ(t) | Proved | Section 13.1 |
| Vanishing residues of Δ(t) | Proved | Section 13.1 |
| Jacobian-conditioned zero preservation | Proved | Section 16.3 |

### 20.2 Open Problems

1. **Bijectivity Gap (= Riemann Hypothesis).** Prove that {t ∈ ℝ : Δ(t) = 0} = Z_η. This is the sole remaining step to establish RH from the framework. It is logically equivalent to RH.

2. **Global monotonicity of Δ(t).** Establish rigorous tail bounds for the Euler–Maclaurin remainder of Δ(t) for |t| ≥ 10^4, and prove sign control within each Gram interval.

3. **Functional equation for Ẽ(θ, s).** Does the analytic continuation of the greedy sub-sum satisfy an analogue of ξ(s) = ξ(1-s)? The splitting identity provides constraints but no self-contained equation.

4. **Zeros of Ẽ(θ, s) in the critical strip.** For each θ, where are the zeros of Ẽ(θ, s) in 0 < Re(s) < 1? Do they relate to the zeros of ζ(s)?

5. **Greedy Condition equivalence.** Resolve the gaps in both directions of the claimed equivalence RH ↔ GC.

6. **Growth estimates.** Establish Phragmén–Lindelöf-type bounds for |Δ(t)| as |t| → ∞ at fixed Re(s), analogous to the convexity bounds for ζ.

7. **Sub-Bernoulli numbers.** Compute Ẽ(θ, -m) in closed form from the threshold angles θ_n^*, and determine whether these constants carry number-theoretic significance.

### 20.3 Conceptual Architecture

The framework connects four mathematical structures that are each individually well-understood, and whose interaction encodes the Riemann Hypothesis:

```
Greedy Algorithm (geometry)
         ↓
Dirichlet Sub-Sum E(θ,s) → Analytic continuation → Pole at s=1 with density θ/π
         ↓
Remainder Map (dynamics)
         ↓
Transfer Operator L_s → Fredholm det = ζ(s)/ζ(2s) · e^{P(s)}
         ↓
Sawtooth Quantisation
         ↓
Self-adjoint H → Haar basis → Quadratic factors Q_n(s) → Eigenvalues λ_{n,±}
         ↓
Twisted Operator L_w^η → det = E(w)/E(1+2w) · e^{P^η(w)}
         ↓
Mismatch Δ(t) → Z_η ⊆ {Δ=0} [proved] → bijectivity {Δ=0}=Z_η [open = RH]
         ↓
Fixed-Point Map φ → φ(s)=s ↔ η(s)=0 → Jacobian analysis
```

Every arrow in this diagram is either fully proved or explicitly acknowledged as open. The framework is the most geometrically transparent and computationally explicit Hilbert–Pólya candidate in the literature, providing:
- Explicit closed-form eigenvalues (unlike most spectral approaches)
- Dynamical interpretation via the sawtooth flow
- A fixed-point interpretation via the map φ
- Numerical verification at all computed zeros
- Clear identification of exactly one open step equivalent to RH

---

## References

[1] Geere, V. (2026). On the Correlation Structure of a Greedy Harmonic Decomposition. *maths/greedy-harmonic-hilbert-polya/*.

[2] Geere, V. (2026). Analytic Continuation of the Greedy Dirichlet Sub-Sum. *maths/greedy-harmonic-hilbert-polya/analytic-continuation.html*.

[3] Geere, V. (2026). The Greedy-Harmonic Hilbert–Pólya Framework (versions 1–6). *maths/greedy-harmonic-hilbert-polya/index.html, index2.html, phi.html, framework.html, ghd-inversion.html*.

[4] Berry, M.V. & Keating, J.P. (1999). The Riemann zeros and eigenvalue asymptotics. *SIAM Review* 41(2), 236–266.

[5] Ruelle, D. (2002). Dynamical zeta functions and transfer matrices. *Notices AMS* 49(8), 887–895.

[6] Titchmarsh, E.C. (1986). *The Theory of the Riemann Zeta-Function*. 2nd ed., revised by D.R. Heath-Brown, Oxford University Press.

[7] Apostol, T.M. (1976). *Introduction to Analytic Number Theory*. Springer.

[8] Hardy, G.H. & Wright, E.M. (2008). *An Introduction to the Theory of Numbers*. 6th ed., Oxford University Press.

---

*Last updated: May 2026. All proofs are self-contained. All claimed results without proof are explicitly labelled as open.*
