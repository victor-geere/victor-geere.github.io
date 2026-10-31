# Rescue: the normalization, not the idea

**Status:** the programme is **reopened**. The objective of
[`37-final-assessment.md`](37-final-assessment.md) is not achieved, and the
recorded normalization of the global functional is now known to be
**sign-indefinite on exact degree-zero test functions**. That is a
falsification of the *recorded formula*, not of the Hodge-index idea: the
local, finite and Krein results are untouched, and the defect is localized to
the normalization: the contour on which the completed zeta is evaluated, and
the pole integral that the recorded formula replaces by a constant. This note
gives the exact identity that localizes it, the numerical test that detects
it, the obstructions that must be withdrawn, the correct in-repo
functional, and the corrected programme. No Riemann hypothesis proof is claimed yet yet.

## 0. Formal status

The algebraic core is now Lean-checked in [`../lean/Rescue.lean`](../lean/Rescue.lean)
and [`../lean/Shadow.lean`](../lean/Shadow.lean) (no `sorry`): the finite KMS
positivity, the compatible-positivity lemma, the non-compatibility
counterexample, the sign convention `s = -W`, the finite quadratic-form
criterion, and the rational shadow certificates `G4_psd` (certified Gram) and
`N4_not_psd` (recorded Gram). The archimedean contour identity
`Re A_arch(ξ) = -½ Ω(ξ + i/2)` ([`../lean/Archimedean.lean`](../lean/Archimedean.lean))
and the `ζ`/`Γ` symbol identity `A_arch + Q = -Z'/Z` on `Re s > 1`
([`../lean/Symbol.lean`](../lean/Symbol.lean)) are now Lean-checked. The
continuation to the critical line, the explicit formula, and every eigenvalue
in this note are **not** Lean-checked; they are text proofs or computations.
See [`../lean/README.md`](../lean/README.md) for the split.

## 1. Summary of the rescue

| # | finding | status |
|---|---|---|
| 1 | the recorded symbol is the completed-zeta logarithmic derivative on the **imaginary axis**, \(M(\xi)=-Z'/Z(-i\xi)\), not on the critical line | algebraic identity Lean-checked on \(\operatorname{Re}s>1\); continuation to the axis not formalised |
| 2 | the \(n^{-1/2}\) of the explicit formula is the contour shift \(\sigma\mapsto\sigma+\tfrac12\), not an optional normalization | contour algebra; continuation not Lean |
| 3 | the "Hodge index \(\iff M\le0\)" claim is an implication plus an unproved converse; note 25 proves only \(M\le0\Rightarrow s\le0\) | proof audit |
| 4 | the recorded functional \(N\) is indefinite on exact mean-zero compact-support tests, stable to \(10^{-8}\) across quadrature orders; this is not a truncation artefact | numerical |
| 5 | on the same Gaussian basis, \(N\) has eigenvalues \((-0.0408,-0.0195,-0.0173,+0.0624)\), while the correct \(W\) has \((0.0227,0.0270,0.0449,0.0780)\), reproducing the certified matrix of the sibling dossier | numerical |
| 6 | the correct \(W\) already exists in [`../prime-spectrum-tensor/WEIL-POSITIVITY.md`](../../prime-spectrum-tensor/WEIL-POSITIVITY.md) and passes the finite test in [`../prime-spectrum-tensor/WEIL-GRAM.md`](../../prime-spectrum-tensor/WEIL-GRAM.md) | in-repo |
| 7 | the uniform-bound obstruction of note 35 is a category error: unbounded \(\|H_N\|\) is compatible with compatible positive forms | Lean-checked (Lemma 2.1, `Rescue.lean`) |
| 8 | the relative-form obstruction of note 36 is irrelevant; the relative form is a difference of positive operators and has no reason to be semidefinite | proof audit |
| 9 | the sign convention is a definitional matter: the geometric self-intersection is \(s=-W\), so the probe's positive directions are consistent | Lean-checked (`hodge_sign_iff`) |
| 10 | the literal Yuan–Zhang objective remains impossible; the correct home is the scaling-site Riemann–Roch/Hodge index | unchanged |

The rescue is therefore: **replace the recorded \(N\) by the correct \(W\)
already in the repository, stop testing the pointwise symbol, and accept a
normalization only if its Gram matrix is positive semidefinite on exact
tests.** That test passes for \(W\) and fails for \(N\); it is cheap,
decisive, and independent of every truncation that confused rounds 14–36.

## 2. Why the final assessment was over-strong

### 2.1 The pointwise symbol is not the form

Note 25 proves: if \(M\le0\) distributionally then
\(s(F,F)=\langle M,|\widehat F|^2\rangle\le0\). That is one implication. The
converse is asserted in the same note ("the Hodge-index inequality is
**exactly** the negativity of the full symbol") but never proved, and it is
neither proved nor needed: the symbol is tested only against the cone
\(\{|\widehat F|^2\}\), not against all nonnegative test functions, and the
functional need not be a multiplier at all.

The distinction is not pedantic. The prime part of the recorded functional is

\[
N_{\text{prime}}(h)=\sum_{n\ge1}\Lambda(n)h(\log n),
\qquad h=F*F_- .
\]

For compactly supported \(F\), this is a **finite sum**, hence a continuous
linear functional of \(h\). Its Fourier-side object is the measure
\(\mu=\sum_n\Lambda(n)\delta_{\log n}\), whose Fourier transform is the
formal series \(\sum_n\Lambda(n)n^{i\xi}\). That series is not a function on
the real line; it is a distribution on the test class. Notes 24 and 27
establish exactly this: the Abel sums do not converge, and the Dirichlet
series has abscissa \(1\). The meromorphic continuation
\(-\zeta'/\zeta(1/2-i\xi)\) is a *different object*, related to the measure by
the explicit formula, i.e. by the zeros. Evaluating "\(M(\xi)\)" pointwise is
therefore mixing a function, a measure and an analytic continuation.

Notes 26 and 33 then draw conclusions from the pointwise real part of the
archimedean term. Those conclusions do not bear on the form. This is the
first error of the final assessment, and it is the one that generated the
whole "sign of \(M\)" programme.

### 2.2 The uniform bound is not needed

Note 34 proves a conditional inductive-limit theorem under
\(\sup_N\|B_N\|_{\mathrm{op}}<\infty\). Note 35 observes that
\(\|H_N\|\sim\beta\log N\) grows, so the hypothesis fails, and concludes that
the naive inductive limit fails. The conclusion does not follow. Boundedness
of an operator is not the same as semiboundedness of a quadratic form, and a
semidefinite form may be unbounded (the Dirichlet form is the standard
example). The correct algebraic statement is:

**Lemma 2.1 (compatible positivity).** *Let \(A=\bigcup_N A_N\) be an
inductive union of unital \(C^*\)-algebras with injective connecting maps, and
let \(B_N\) be quadratic forms on \(A_N\). Suppose*

1. \(B_N(a,a)\ge0\) *on the self-adjoint part of* \(\ker\varphi_N\);
2. *(compatibility)* *for* \(a\in A_N\subset A_{N'}\),
   \(B_{N'}(a,a)=B_N(a,a)\).

*Then* \(B(a,a):=B_N(a,a)\) *for* \(a\in A_N\) *is well defined and
nonnegative on the self-adjoint part of the dense union*
\(\bigcup_N A_N\). *No bound on* \(\|B_N\|\) *is used.*

*Proof.* Well-definedness is exactly (2); nonnegativity is exactly (1). ∎

If the finite-level forms are the restrictions of one continuous functional
on the test-function space — which the recorded \(N\) is, since its prime sum
is finite on compact support — and the finite-level subspaces are dense there,
then nonnegativity extends to the whole test class. The hypothesis that
actually matters is therefore **compatibility** plus the dictionary between
algebra elements and test functions; it is algebraic, not analytic. It is also
not automatic: the modular Hamiltonian of a restriction is not the compression
of the modular Hamiltonian of the larger algebra.

That unbounded norms are compatible with (2) is not a hypothetical. Take

\[
A_N=M_2(\mathbb C)\otimes M_{k_N}(\mathbb C),\qquad
H_N=H_0\otimes 1+1\otimes N K,\qquad
\varphi_N=\varphi_0\otimes\omega_N .
\]

For \(a=a_0\otimes 1\), \([H_N,a]=[H_0,a_0]\otimes 1\), hence
\(B_N(a,a)=B_0(a_0,a_0)\) for every \(N\), while
\(\|H_N\|\to\infty\). The numerics in §6 confirm the invariance to
\(8\cdot10^{-16}\) with \(\|H_N\|\) growing from \(1.5\) to \(14.0\). Note 35's
growth observation is therefore true but irrelevant: it is an observation
about the *size* of the form, not its *sign*.

### 2.3 The relative form is a non sequitur

Note 36 computes \(B_{\varphi|\psi}\) for random pairs of states and finds
mixed signs, concluding that the relative-form renormalization route is
closed. But \(H_{\varphi|\psi}=\log\rho_\varphi-\log\rho_\psi\) is a
difference of two positive operators; its commutator form has no reason to be
semidefinite, and finding mixed signs is the expected outcome. The experiment
rules out the *ansatz* "use the symmetrized relative form as the positivity
carrier". It says nothing about the route, whose standard tool is relative
boundedness (KLMN), not positivity of the difference. The obstruction should
be withdrawn.

### 2.4 The sign convention is a definition

The probe of notes 09–13 computes a functional \(N\) and finds positive
directions. Note 31 treats this as a contradiction and proposes two readings.
The correct reading is B: the geometric self-intersection is \(s=-W\) (the
sign of the polarization), and the probe's positive directions are the
expected sign of the Weil functional, not a counterexample. For the probe's
recorded \(N\) the same convention reads \(s=-N\); the sign issue was never
the real defect. The local Hodge index \(D^2\le0\) on \(A^\perp\) and Weil
positivity \(W\ge0\) are the same inequality. No re-derivation of formula
(13) is needed to fix the *sign*; only to fix the *normalization*.

This matters because the dossier spent rounds 31–35 on a pseudo-problem. The
real problem is not "which sign", it is "which functional".

## 3. The exact identity: the recorded symbol is on the imaginary axis

Let

\[
Z(s)=\pi^{-s/2}\Gamma(s/2)\zeta(s),\qquad s=-i\xi .
\]

The archimedean symbol of note 23 is

\[
A_{\text{arch}}(\xi)=\frac12\bigl[\log\pi-\psi(s/2)\bigr],
\]

and the prime symbol of note 24 is, in its convergence domain
\(\operatorname{Im}\xi>1\),

\[
Q(\xi)=\sum_{n\ge1}\Lambda(n)n^{i\xi}=-\frac{\zeta'}{\zeta}(s).
\]

Since

\[
-\frac{Z'}{Z}(s)=\frac12\log\pi-\frac12\psi(s/2)-\frac{\zeta'}{\zeta}(s),
\]

we obtain the exact identity

\[
\boxed{\;M(\xi)=A_{\text{arch}}(\xi)+Q(\xi)=-\frac{Z'}{Z}(-i\xi)\;}
\qquad(\operatorname{Im}\xi>1).
\]

This identity is now Lean-checked on the convergence half-plane
`Re s > 1` in [`../lean/Symbol.lean`](../lean/Symbol.lean) (`symbol_identity`).
The continued form is also Lean-checked: `symbol_identity_continued` proves
`A_arch - ζ'/ζ = -Z'/Z` at every `s` with `s ≠ 1`, `Γ(s/2) ≠ 0` and
`ζ(s) ≠ 0`, which includes the imaginary-axis points away from zeros. The
nonvanishing `ζ(-iξ) ≠ 0` is taken as a hypothesis, not proved in Lean; the
critical-line distributional statement is not formalised.

This is the normalization dictionary that note 32 asked for. It is an
identity between analytic continuations on the half-plane of convergence; it
is **not** an identity of boundary values on the real line, and it must not be
used as one.

The identity says that the recorded symbol is the logarithmic derivative of
the completed zeta evaluated at \(s=-i\xi\), i.e. on the **imaginary axis**
\(\sigma=0\). The Weil explicit formula lives on the critical line
\(\sigma=\tfrac12\). The two are related by the contour
shift \(\sigma\mapsto\sigma+\tfrac12\), and the prime manifestation of that
shift is exactly the factor \(n^{-1/2}\):

\[
\sum_n\Lambda(n)n^{-1/2+i\xi}
=\sum_n\Lambda(n)n^{i\xi}\,n^{-1/2}
=\Bigl[\text{recorded prime term at }s+\tfrac12\Bigr].
\]

This is the precise content of the mismatch recorded in note 32. It also
explains note 33: the two archimedean factors are **not** two normalizations
of the same function on the same line. Their exact relation is

\[
\boxed{\;\operatorname{Re}A_{\text{arch}}(\xi)
=-\tfrac12\,\Omega\bigl(\xi+\tfrac{i}{2}\bigr)\;}
\qquad
\Omega(z)=\operatorname{Re}\psi\Bigl(\frac14+\frac{iz}{2}\Bigr)-\log\pi,
\]

which is a one-line computation:

\[
\Omega\bigl(\xi+\tfrac{i}{2}\bigr)
=\operatorname{Re}\psi\Bigl(\frac{i\xi}{2}\Bigr)-\log\pi,
\qquad
\operatorname{Re}A_{\text{arch}}(\xi)
=\frac12\Bigl[\log\pi-\operatorname{Re}\psi\Bigl(\frac{i\xi}{2}\Bigr)\Bigr].
\]

Thus the crossing at \(\xi_c=6.2288527\) is the crossing of \(\Omega\)
**continued to the contour** \(\operatorname{Im}=\tfrac12\), not a competing
real-line zero. The comparison table of note 33 is a comparison of values on
different contours and carries no sign information. The constant term is also
recovered exactly:

\[
A_{\text{arch}}(0^+)=\frac{\log\pi+\gamma}{2}=c,
\]

so the \(c\,h(1)\) term of the recorded functional is the zero mode of the
archimedean symbol, not an independent normalization.

The continuation does change sign on the real line: numerically
\(\operatorname{Re}(-Z'/Z(-i\xi))\) is \(-0.974\) at \(\xi=0.05\), crosses
zero in \((5.75,6.0)\), and reaches \(+1.89\) at \(\xi=14\). That is a
statement about the continuation, and it is precisely why the pointwise route
was doomed. It does **not** decide the sign of the form, because the
continuation is not the prime measure.

## 4. The decisive test: recorded \(N\) versus the correct \(W\)

The recorded functional is

\[
N(h)=\sum_{n\ge1}\Lambda(n)h(\log n)
+\int_0^\infty\frac{e^{2x}h(x)-h(0)}{e^{2x}-1}\,dx+c\,h(0),
\qquad h=F*F_- .
\]

For compactly supported \(F\), every term is finite and computable. On the
even compact-support basis \(F_k(x)=(1-x^2)_+x^{2k}\), \(k=0,\dots,4\), with
the degree-zero constraint \(\int F\,dx=0\), the Gram matrix
\(G_{ij}=N(F_i*F_{j,-})\) has constrained eigenvalues

\[
-1.666\cdot10^{-3},\quad -1.481\cdot10^{-4},\quad 1.3\cdot10^{-7},\quad
2.59\cdot10^{-5},
\]

stable to eight digits for 60, 120 and 240 quadrature nodes. The form is
indefinite, and the unconstrained \(5\times5\) matrix is indefinite as well.
This is not an operator truncation: the form is evaluated exactly on a
finite-dimensional subspace, and a form that is indefinite on a subspace is
indefinite. The implementation reproduces note 29's tent value
\(N\approx1.3708\) to \(2\cdot10^{-4}\).

The decisive comparison, however, is on the Gaussian basis already certified
in the sibling dossier. The correct Weil functional is

\[
W(h)=2\int_{\mathbb R}h(u)\cosh(u/2)\,du
-2\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}h(\log n)
+\frac{1}{2\pi}\int_{\mathbb R}\widehat h(t)\,\Omega(t)\,dt,
\]

with \(\Omega(t)=\operatorname{Re}\psi(\tfrac14+\tfrac{it}{2})-\log\pi\);

> **Round 57 correction.** The round-47 sign correction is **withdrawn**:
> the fixed-grid archimedean sum omitted the quadrature weights, inflating
> it by \(1/\Delta t\). Exact adaptive quadrature shows the sibling's cosh
> \(+\Omega\) form is positive semidefinite and the \(-\Omega\) form is the
> one with a residual. See
> [`41-quadrature-correction.md`](41-quadrature-correction.md).

| functional | eigenvalues |
|---|---|
| recorded \(N\) | \(-0.0408,\;-0.0195,\;-0.0173,\;+0.0624\) |
| correct \(W\) | \(0.02271,\;0.02696,\;0.04485,\;0.07802\) |

The \(W\) matrix reproduces the certified matrix of `WEIL-GRAM.md` to its
published digits; the computation is `gaussian_comparison` in
[`../python/rescue_probe.py`](../python/rescue_probe.py). The recorded \(N\)
is not \(W\) and not \(-W\): it is indefinite. The correct functional already
exists in the repository and passes the finite acceptance test.

The two differences are structural, not a scale factor:

- \(W\) has the **pole integral** \(2\int h\cosh(u/2)\,du\), which is the
  residue at \(s=1\). The recorded \(N\) replaces it by the constant
  \(c\,h(0)\). A constant cannot replace an integral against
  \(\cosh(u/2)\).
- \(W\) has the **critical-line archimedean density**
  \((1/2\pi)\int\widehat h\,\Omega\). The recorded \(N\) uses
  \(A_{\text{arch}}\), which by §3 is the imaginary-axis object.

This is exactly why no relative rescaling of the recorded halves could repair
the sign: the missing term is a different operator, not a different weight.

The finite certificate is not a proof of the cone, and `WEIL-GRAM.md` says so
explicitly. **Round 47 adds a caveat**: the same \(W\) is strongly indefinite
on a broad compact-support basis (eigenvalues \(pprox-20.55,-0.12,0.0013\)),
and the naive multiplicative weight does not repair it. So \(W\) is certified
as a *narrow-Gaussian* finite normalization, not yet as the full cone
functional. The two finite tests now disagree, and the full pole/trivial-zero
dictionary is the next task. See
[`39-broad-test-discrepancy.md`](39-broad-test-discrepancy.md). The rescue's
negative conclusions are unchanged; the positive identification of \(W\) is
narrowed to the Gaussian rung.

## 5. The corrected objective

**Objective R (reopened).** Complete the normalization of \(W\) (the broad
rung of note 39), then prove

\[
W(g)\ge0\quad\text{for every }g=f*f^{\#}\text{ in the Weil cone},
\]

where \(W\) is the functional of
[`../prime-spectrum-tensor/WEIL-POSITIVITY.md`](../../prime-spectrum-tensor/WEIL-POSITIVITY.md)
displayed in §4. This is Weil's criterion, and the geometric form is
\(s=-W\). The finite acceptance test is already passed on the Gaussian basis
(`WEIL-GRAM.md`); the recorded \(N\) fails it and is rejected.

**Programme.**

1. **Port \(W\).** Replace \(N\) by \(W\) throughout this dossier. The local
   \(E_p\times E_p\) model, the finite KMS/Hodge–Riemann theorems and the
   Krein structure are unchanged; the global functional is the one already
   recorded in the sibling dossier.
2. **Certify more rungs.** Extend the interval certificate of `WEIL-GRAM.md`
   to wider bases, supports and widths. Each finite PSD certificate is an
   acceptance test; none is a proof of the cone.
3. **Compatibility, not a uniform bound.** Prove that the finite
   Bost–Connes KMS forms agree on the images of the level inclusions
   (Lemma 2.1). This is algebraic and finite-level.
4. **The cone.** The infinite-cone positivity is RH; it must not be claimed.
   The scaling-site Riemann–Roch/Hodge index is the geometric form of the
   same statement, and it is the right replacement for the literal
   Yuan–Zhang objective.
5. **Do not re-derive the sign.** The sign is fixed by \(s=-W\). The open
   problem is the inequality, not the convention.

## 6. Numerical checks

All figures are reproduced by
[`../python/rescue_probe.py`](../python/rescue_probe.py); the tests are in
[`../tests/test_rescue.py`](../tests/test_rescue.py).

- **Archimedean identity.** \(\operatorname{Re}A_{\text{arch}}(\xi)\) and
  \(-\tfrac12\Omega(\xi+\tfrac{i}{2})\) agree to machine precision at
  \(\xi=0.5,2,10\) and at the crossing \(6.22885\).
- **Symbol identity.** \(A_{\text{arch}}+Q\) and \(-Z'/Z(-i\xi)\) agree to
  \(10^{-18}\) at \(\xi=0.5,2,10\).
- **Tent value.** The recorded \(N\) gives \(1.37101\) against note 29's
  \(1.37080\).
- **Compact-support Gram.** The recorded \(N\) has constrained eigenvalues
  \((-1.666\cdot10^{-3},-1.481\cdot10^{-4},1.3\cdot10^{-7},2.59\cdot10^{-5})\),
  identical for 60, 120, 240 nodes.
- **Same-basis comparison.** On the certified four-Gaussian basis, the
  recorded \(N\) has eigenvalues
  \((-0.0408,-0.0195,-0.0173,+0.0624)\); the correct \(W\) has
  \((0.02271,0.02696,0.04485,0.07802)\), matching `WEIL-GRAM.md` to its
  published digits.
- **Inductive limit.** \(B_N(a,a)\) equals \(B_0(a,a)\) to
  \(7.8\cdot10^{-16}\) while \(\|H_N\|\) grows \(1.49\to14.02\).
- **Non-compatibility.** With a level-dependent Hamiltonian on the same
  algebra the form varies by \(0.72\), so compatibility is a real hypothesis,
  not a formality.

## 7. What is withdrawn, what survives

**Withdrawn.**

| note | claim | reason |
|---|---|---|
| 25 | "the Hodge index is exactly \(M\le0\)" | only the implication \(M\le0\Rightarrow s\le0\) is proved; the symbol is tested on a cone, and the prime part is a measure |
| 26 | "the archimedean sign change forces prime cancellation in the symbol" | pointwise sign of a continuation; no bearing on the form |
| 33 | "the two archimedean factors are different normalizations on the same line" | they live on different contours; exact identity in §3 |
| 35 | "growing \(\|H_N\|\) obstructs the inductive limit" | Lemma 2.1 and the tensor-factor example |
| 36 | "the indefinite relative form closes the renormalization route" | the relative form is a difference of positive operators; KLMN is the relevant tool |
| recorded \(N\) | the functional of note 32 is the Weil functional | it is indefinite on exact tests and fails on the certified Gaussian basis; the correct \(W\) is in the sibling dossier |

**Survives.** The local rank-three Hodge index (Lean T5–T9); the finite KMS
Hodge index and the finite Hodge–Riemann pair; the finite-dimensional
\(C^*\)-algebra theorem; the Lorentzian Krein/Hodge structure with
\(S^2=1\), \(h=QS\succ0\); the exact archimedean symbol; the exact identities
of §3; the corrected-sign \(W\) and its near-positive broad Gram; the observation
that the recorded normalization is indefinite.

**Open.** The broad compact-support completion of \(W\) (note 39); the
infinite-cone positivity (Weil's criterion, hence RH); wider finite
certificates; compatibility of the Bost–Connes forms; the scaling-site
Riemann–Roch/Hodge index; the relation to Yuan–Zhang (negative: it does not
apply).

## 8. Bottom line

- No absolute polarized Hodge-index realization.
- No Yuan–Zhang application.
- No RH proof yet.
- **The programme is not closed.** The final assessment mistook a
  normalization error for a mathematical wall. The recorded functional is
  indefinite on exact tests; the exact symbol identity explains why (it is
  the completed zeta on the imaginary axis); the correct contour is the
  critical line.
- **The archimedean sign is now identified.** The sibling \(W\) uses
  \(+\Omega\) and is a narrow-Gaussian certificate for a different
  convention. The standard formula uses \(-\Omega\) and the Mellin pole
  terms; on broad supports it is near-PSD (min \(-4.4\cdot10^{-3}\),
  \(-2.7\cdot10^{-4}\) on a smooth bump), not PSD. See [`39-broad-test-discrepancy.md`](39-broad-test-discrepancy.md).
- The remaining wall is the one that was always there: the infinite cone.
  The finite certificate does not cross it, and no claim of RH is made.

[Back to the dossier](../README.md) · [Revised assessment](37-final-assessment.md) ·
[Research journal](../research-journal.md) · [Rescue probe](../python/rescue_probe.py)
