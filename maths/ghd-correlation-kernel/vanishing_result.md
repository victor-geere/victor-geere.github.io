# Investigation of the Greedy Harmonic Decomposition
## as a Spectral Operator for the Riemann Zeta Function

**Victor Geere & Research Collaborator**
May 2026

---

## Abstract

We investigate the Greedy Harmonic Decomposition (GHD), a deterministic
greedy algorithm on [0,π] with harmonic step sizes α_n = π/(n+2), and its
associated correlation kernel

    K(n,m) = ∫_0^π ϕ_n(θ) ϕ_m(θ) dθ,    ϕ_n(θ) = δ_n(θ) − θ/π.

Earlier numerical work observed that the smallest eigenvalue of the weighted
kernel M_{n,m}(s) = K(n,m) (n+2)^{-(s+1/2)} (m+2)^{-(s+1/2)} drops by 7–11
orders of magnitude at the ordinates of the non‑trivial zeros of ζ(s). This
phase‑interference phenomenon suggested that the GHD operator might be a
concrete realisation of the Hilbert–Pólya idea, with a Fredholm determinant
vanishing exactly at the Riemann zeros.

We compute the true, remainder‑tracking GHD kernel exactly for small n, form
the weighted operator, and evaluate its Fredholm determinant on the critical
line. The results are negative: the determinant does not vanish at the
Riemann zeros. The earlier eigenvalue suppression is real but does not force
the full determinant to zero; the remaining eigenvalues compensate.

We also present a universal algebraic result: any partition of an interval
with a square‑integrable centring function yields a Gram matrix of the form
diagonal + rank 2. This framework generates explicit trace‑class operators
and closed‑form Fredholm determinants, but does not prove the Riemann
Hypothesis.

---

## 1. Introduction

The Greedy Harmonic Decomposition (GHD) is defined by the sequential rule

    θ_0 = θ ∈ [0,π],
    α_n = π/(n+2),
    δ_n(θ) = 1 if θ_n ≥ α_n else 0,
    θ_{n+1} = θ_n − δ_n·α_n.

The centred functions ϕ_n(θ) = δ_n(θ) − θ/π have zero mean, and their
Gram matrix K(n,m) = ⟨ϕ_n, ϕ_m⟩_{L^2[0,π]} is symmetric positive
semi‑definite.  Weighting by a Dirichlet factor produces the operator

    M_{n,m}(s) = K(n,m) (n+2)^{-(s+1/2)} (m+2)^{-(s+1/2)}.

It was observed numerically that the smallest eigenvalue of M(s) on the
critical line s = 1/2 + it drops by 7–11 orders of magnitude precisely at
t equal to the ordinates of the non‑trivial zeros of the Riemann zeta
function. This “phase‑interference” phenomenon motivated the conjecture
that det(I − M(s)) vanishes exactly at those zeros, providing a
Hilbert–Pólya operator for ζ(s).

In this note we test that conjecture by computing the true GHD kernel
exactly and evaluating the Fredholm determinant at the first few Riemann
zeros.

---

## 2. The true GHD kernel

The indicator sequence δ_n(θ) is determined by the remainder process.
For each initial θ, the process yields a specific binary sequence.
The support of δ_n(θ) is a finite union of intervals in [0,π] with
rational endpoints. We compute these supports by a recursive splitting
algorithm up to a chosen depth N.

**Algorithm 1 (partition builder)**

    intervals = [(0.0, π, 0.0, [])]      # (a,b,accum,sequence)
    for n = 0 .. N−1:
        α = π/(n+2)
        for each (a,b,accum,seq) in intervals:
            θ_thresh = accum + α
            if θ_thresh ≤ a:   whole interval gets δ=1
            elif θ_thresh ≥ b: whole interval gets δ=0
            else: split at θ_thresh

After N steps the leaves form a partition of [0,π]. On each leaf the
first N indicators are constant. The exact kernel entries for
0 ≤ n,m < N are then obtained by summing the elementary integrals

    ∫_a^b (δ_n − θ/π)(δ_m − θ/π) dθ

over all leaves.

**Exact small‑N values (computed, in units of π):**

    K(0,0) = 1/12
    K(1,1) = 2/9
    K(0,1) = −7/72
    K(2,2) = 23/72
    K(1,2) = 1/48
    …

These differ from the closed‑form kernel that would follow from the
incorrect global indicator δ_n = 1_{[α_n,π]}. The true kernel captures
the full remainder‑tracking correlations.

---

## 3. Fredholm determinant on the critical line

For a fixed truncation N, we form the N×N matrix

    M^{(N)}_{nm}(s) = K(n,m) (n+2)^{-(s+1/2)} (m+2)^{-(s+1/2)},

and compute

    Δ_N(s) = det(I − M^{(N)}(s)).

We evaluate Δ_N(s) at s = 1/2 + it for a non‑zero reference ordinate
t = 5 and for the first three Riemann zeros.

**Parameters:** N = 25.  (N cannot be increased arbitrarily because the
number of leaves in the partition grows rapidly; N=25 is sufficient for
the dominant contribution because the weights decay as ∼1/√n.)

---

## 4. Results
Computing determinant of I - M(s) for true GHD, N=25

t =   5.0000   det = 8.504677e-01-2.880058e-02j   |det| = 8.509552e-01
t =  14.1347251417   det = 5.941414e-01+2.995182e-01j   |det| = 6.653685e-01
t =  21.0220396388   det = 8.864170e-01-6.666613e-02j   |det| = 8.889204e-01
t =  25.0108575801   det = 1.170568e+00-1.680002e-01j   |det| = 1.182562e+00


The determinant does **not** vanish at the Riemann zeros. Its magnitude
at the first zero is somewhat lower than at the non‑zero reference
(0.666 vs 0.851), but at the second and third zeros it is equal to or
larger than the reference. There is no systematic approach to zero.
Increasing N modestly does not change this conclusion; the determinant
stabilises and remains of order unity.

---

## 5. Interpretation

The small‑eigenvalue suppression observed in earlier work is real: one
eigenvalue of M^{(N)}(s) does become extremely small at the zeta zeros.
However, the Fredholm determinant is the product of *all* eigenvalues.
The remaining eigenvalues are close enough to 1 that the product stays
O(1). For the determinant to vanish (or tend to zero as N → ∞), the
operator would require an eigenvalue *exactly* equal to 1 in the limit,
which the GHD kernel does not provide.

Thus, the phase‑interference phenomenon is a genuine spectral feature
of the GHD operator, but it is not sufficient to produce a zero of the
Fredholm determinant at the Riemann zeros.

---

## 6. Universal diagonal + rank‑2 structure

Separately, we established a rigorous algebraic theorem:

**Theorem 1.** Let I_1, I_2, … be a finite or countable partition of
[0,L] and g ∈ L^2[0,L]. Then the Gram matrix of the centred step
functions φ_n = 1_{I_n} − g has the form

    K = diag(ℓ_n) + (rank‑2 correction),

where ℓ_n = |I_n|. The correction involves the integrals
a_n = ∫_{I_n} g and c = ∫_0^L g^2.

**Theorem 2.** With analytic weights w_n(s), the operator
M(s) = D(s) K D(s)^*, D = diag(w_n), is trace‑class on a half‑plane,
and its Fredholm determinant factors as

    det(I − M(s)) = ∏(1 − ℓ_n w_n(s)^2) × det(I_2 − B G(s)),

with explicit 2×2 matrices B and G(s). This yields a closed‑form
determinant for any such partition.

This universal framework is mathematically sound and can be used to
construct operators whose determinants approximate, or even exactly
match, a given entire function of order 1. However, it does not by
itself force the zeros of that function onto any particular line.
Proving the Riemann Hypothesis would require additional properties
(self‑adjointness on the critical line, monotonicity of the argument)
that are not automatically satisfied by an engineered operator.

---

## 7. Conclusion

1. The true Greedy Harmonic Decomposition yields a correlation kernel
   with a rich spectral structure, including a phase‑interference
   effect at the Riemann zeros (one eigenvalue becomes very small).

2. The Fredholm determinant of the weighted GHD operator does **not**
   vanish at the Riemann zeros. The GHD operator is not the
   Hilbert–Pólya operator for ζ(s).

3. The universal diagonal + rank‑2 decomposition is a valid and
   potentially useful piece of mathematics, but it does not prove the
   Riemann Hypothesis.

4. The Riemann Hypothesis remains an open problem.

---

## Acknowledgements

The authors acknowledge the use of numerical computation (Python/numpy)
and the earlier contributions that inspired the Greedy Harmonic
Decomposition framework.

---

## References

[Standard analytic number theory texts, plus the corrected GHD document
and the numerical code developed during this investigation.]