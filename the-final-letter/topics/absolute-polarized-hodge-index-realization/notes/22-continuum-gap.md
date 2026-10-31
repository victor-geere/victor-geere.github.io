# The spectral gap is not a truncation

**Status:** a methodological correction. The finite-\(K\) gap computations of
notes 14–21 are diagnostics of compressions, not the spectral gap of the CCM
form. The \(K=32\) resonance is a compression artefact. The gap must be
studied on the full test-function space, where the CCM form is a convolution
form and its symbol is governed by the explicit formula.

## 1. Why truncation is the wrong object

Let \(A\) be the unbounded operator associated with the CCM form on the
degree-zero space, and let \(P_K\) be the orthogonal projection onto a
finite-dimensional subspace.  The eigenvalues of the compression
\(P_K A P_K\) need not converge to the spectrum of \(A\):

- eigenvalues can appear and disappear as \(K\) changes (the \(K=32\)
  resonance);
- the compression can have spurious near-kernels created by the boundary;
- a stable-looking plateau over a range of \(K\) is not evidence for a
  spectral gap.

The truncation sequence in notes 14–21 therefore cannot settle the gap
question.  It is recorded as a set of numerical diagnostics, not as evidence
for or against a uniform gap.

## 2. The full-space formulation

Let

\[
V=\left\{f\in C_c^\infty(\mathbb{R}_+^*):
\int f\,d^*u=\int f\,du=0\right\}
\]

be the degree-zero test-function space, with

\[
H(f,g)=\int f g\,d^*u,
\qquad
s(f,g)=N(f\star\tilde g).
\]

The CCM operator is defined by

\[
s(f,g)=H(Af,g),
\]

and the spectral gap is

\[
\gamma=\inf\bigl\{|\lambda|:\lambda\in\sigma(A)\bigr\}.
\]

This is the quantity the construction needs.  It is a property of the
unbounded operator, not of any finite matrix.

## 3. Log coordinates and the Fourier symbol

Put \(x=\log u\), \(F(x)=f(e^x)\), \(G(x)=g(e^x)\).  Then

\[
(f\star\tilde g)(e^x)=(F*G)(x),
\]

and

\[
H(f,g)=\int F G\,dx.
\]

The prime sum is the distribution

\[
\mu_{\text{prime}}=\sum_{n\ge1}\Lambda(n)\,\delta_{\log n},
\]

so

\[
N_{\text{prime}}(F*G)
=\int (F*G)(x)\,d\mu_{\text{prime}}(x).
\]

The archimedean term is another distribution \(K_{\text{arch}}\), and

\[
N(F*G)=\int (F*G)(x)\,d\mu(x),
\qquad
\mu=\mu_{\text{prime}}+K_{\text{arch}}+c\,\delta_0.
\]

In Fourier space,

\[
N(F*G)=\int \widehat F(\xi)\,\widehat G(\xi)\,M(\xi)\,d\xi,
\]

where \(M=\widehat\mu\) is the **symbol**.  Formally,

\[
\widehat{\mu_{\text{prime}}}(\xi)
=\sum_{n\ge1}\Lambda(n)\,n^{i\xi},
\]

whose meromorphic continuation is the logarithmic derivative of the zeta
function,

\[
-\frac{\zeta'}{\zeta}\left(\frac12-i\xi\right)
\]

up to the archimedean factor.  The archimedean term contributes the gamma
factor of the explicit formula.  The zeros of \(\zeta\) are the zeros/poles
of the continued symbol.

## 4. Consequence

The CCM spectral gap is an **arithmetic/spectral** quantity attached to the
symbol \(M\), not a finite-basis number.  The truncation diagnostics of notes
14–21 are retired as evidence.  The next task is to make the symbol
formulation rigorous:

1. define the distribution \(\mu\) and its Fourier transform on a suitable
   test-function space;
2. identify the exact symbol \(M\), including the archimedean factor and the
   normalization;
3. determine the domain of the associated operator \(A\);
4. study \(\gamma\) through the zeros of the continued symbol.

This reconnects the Hodge-index gap to the explicit formula and the zeros,
which is where the arithmetic content lies.

## 5. What remains open

- The rigorous symbol/domain derivation.
- The relation between the gap \(\gamma\) and the zeros.
- The Bost–Connes crossed-product limit at \(\beta=1\).
- The archimedean term.

No RH proof is claimed yet.

[Back to the dossier](../README.md) · [Research journal](../research-journal.md) ·
[Generic resonance](21-generic-resonance.md)
