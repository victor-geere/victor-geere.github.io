# Final assessment, revised: the programme is reopened

**Status:** the objective of this dossier is **not achieved**, and the
recorded normalization of the global functional has been **falsified** as a
candidate for the Weil functional. The dossier is nevertheless **not closed**.
Round 45 ([`38-rescue.md`](38-rescue.md)) localized the failure to the
normalization — the contour on which the completed zeta is evaluated, and the
pole integral that the recorded formula replaces by a constant — proved the
exact identity that fixes the contour, and withdrew the obstructions that
were category errors. The correct functional is already in the repository and
passes the narrow-Gaussian finite test that the recorded one fails; it fails
the broad compact-support test, so the finite certificate is a narrow rung
(note 39). No Riemann hypothesis proof is claimed yet yet, and none is in
prospect. The difference from the previous version of this note is that the
wall is now known to be a normalization wall, with a cheap acceptance test,
rather than a mathematical wall.

## 1. What is rigorously established

| result | status |
|---|---|
| local fibre \(E_p\times E_p\), rank-three NS, \(A^2=6\), \(6D^2\le(A\cdot D)^2\) | proved (Lean T5–T9) |
| finite KMS Hodge index: \(-B\preceq0\) on the self-adjoint kernel | proved (note 03); Lean-checked in the diagonal model (`lean/Rescue.lean`) |
| finite Hodge–Riemann pair: \(C_{1/2}\succ0\), \(B=-C'_0\) | proved (note 04) |
| finite-dimensional \(C^*\)-algebra theorem and \(C^*(S_3)\) check | proved (note 05) |
| Lorentzian Krein/Hodge structure: \(S^2=1\), \(h=QS\succ0\), signature \((1,\rho-1)\) | proved (note 08) |
| exact archimedean symbol \(A_{\text{arch}}(\xi)=\frac12[\log\pi-\psi(-i\xi/2)]\) | proved (note 23) |
| exact archimedean contour identity \(\operatorname{Re}A_{\text{arch}}(\xi)=-\frac12\Omega(\xi+\frac i2)\) | proved (note 38, §3) |
| exact symbol identity \(A_{\text{arch}}+Q=-Z'/Z(-i\xi)\) on \(\operatorname{Im}\xi>1\) | proved (note 38, §3) |
| the \(n^{-1/2}\) of the explicit formula is the shift \(\sigma\mapsto\sigma+\frac12\) | proved (note 38, §3) |
| recording normalization is indefinite on exact degree-zero compact-support tests | numerical, stable to \(10^{-8}\) (note 38, §4) |
| same-basis comparison: recorded \(N\) \((-0.0408,-0.0195,-0.0173,+0.0624)\) vs correct \(W\) \((0.0227,0.0270,0.0449,0.0780)\) | decisive (note 38, §4) |
| correct \(W\) and its finite Gaussian certificate already in the sibling dossier | in-repo (prime-spectrum-tensor) |
| compatible positivity lemma; unbounded \(\|H_N\|\) does not obstruct the limit | Lean-checked (`lean/Rescue.lean`) |

The earlier row "symbol-sign reduction \(s(F,F)=\langle M,|\widehat F|^2\rangle\);
Hodge index \(\iff M\le0\)" is **withdrawn**. The implication
\(M\le0\Rightarrow s\le0\) is correct; the converse is not proved and is not
needed. The prime part of the symbol is a measure on the log-lattice, not the
boundary value of a meromorphic function, so the pointwise formulation is the
wrong object.

## 2. What is obstructed, and what is not

**Real obstructions.**

| obstruction | content |
|---|---|
| metric | the local fibre is a local Tate curve; \(p^{-k/2}\) is the \(p\)-adic norm, not a complex intersection number |
| normalization | the recorded functional is the completed-zeta symbol on the imaginary axis; it is indefinite on exact tests; the critical-line functional with its pole and trivial-zero terms is not yet derived |
| absolute object | the literal objective (a proper polarized surface over a number field) is impossible; Yuan–Zhang does not apply; the correct home is the scaling-site Riemann–Roch/Hodge index |
| prime regularization | \(\sum\Lambda(n)n^{i\xi}\) has no pointwise boundary value; only the finite-sum functional and its continuation exist |

**Withdrawn obstructions.**

| obstruction | reason |
|---|---|
| truncation | retired in round 24; the Gram test of note 38 is not a truncation |
| Abel regularization | true of the Dirichlet series, but it is not a statement about the form; the form is a finite sum on compact support |
| zero-sum divergence | a property of the naive pointwise zero sum, not of the explicit formula, which is a distributional identity |
| normalization (contradiction) | resolved into an exact contour statement (note 38, §3) |
| sign convention | resolved: the geometric form is \(s=-W\); the probe's positive directions are consistent | Lean-checked (`hodge_sign_iff`) |
| uniform bound | a category error (note 38, §2.2) |
| relative form | the relative form is a difference of positive operators; its indefiniteness is expected and irrelevant |

## 3. The precise open problems

1. **Port the correct functional.** The critical-line \(W\) (pole integral,
   \(n^{-1/2}\) prime sum, \(\Omega\) archimedean density) is already
   recorded in
   [`../prime-spectrum-tensor/WEIL-POSITIVITY.md`](../../prime-spectrum-tensor/WEIL-POSITIVITY.md)
   and certified on a finite Gaussian basis in
   [`../prime-spectrum-tensor/WEIL-GRAM.md`](../../prime-spectrum-tensor/WEIL-GRAM.md).
   The task is to replace the recorded \(N\) by \(W\) throughout the
   dossier, not to re-derive it.
2. **Acceptance test.** The recorded \(N\) fails (smallest eigenvalue
   \(-1.7\cdot10^{-3}\) on the degree-zero subspace; Gaussian eigenvalues
   \(-0.0408,-0.0195,-0.0173,+0.0624\)); the correct \(W\) passes the same
   Gaussian test (eigenvalues \(0.0227,0.0270,0.0449,0.0780\)). Extend the
   finite certificates to wider bases and supports.
3. **Sign theorem.** Prove \(W(g)\ge0\) for every cone element \(g=f*f^\#\).
   This is Weil's criterion; the finite certificates do not prove it, and
   there is no pointwise shortcut.
4. **Compatibility.** Prove that the finite Bost–Connes KMS forms agree on
   the images of the level inclusions. This is algebraic and finite-level,
   unlike the uniform bound of note 34, which is unnecessary.
5. **Absolute realization.** Formulate the Hodge index for the scaling-site
   square. The local \(E_p\times E_p\) model, the finite KMS theorem and the
   Krein structure are the evidence base.

## 4. The strongest rigorous substitute

The strongest rigorous statements are now:

\[
A_{\text{arch}}(\xi)+Q(\xi)=-\frac{Z'}{Z}(-i\xi)
\quad(\operatorname{Im}\xi>1),
\qquad
\operatorname{Re}A_{\text{arch}}(\xi)=-\frac12\Omega\Bigl(\xi+\frac i2\Bigr),
\]

together with the local and finite theorems and the falsification of the
recorded normalization. The previous "distributional reduction"
\(s(F,F)=\langle M,|\widehat F|^2\rangle\) is an identity only in the
convergence domain; on the real line the prime term is a measure, and the
reduction does not turn the Hodge index into a pointwise sign condition.

## 5. Bottom line

- No absolute polarized Hodge-index realization.
- No Yuan–Zhang application.
- No RH proof yet.
- The final assessment of round 44 was over-strong: the sign was not
  "unsettled", the recorded normalization was wrong, and the failure is
  localized. The correct \(W\) is already in the sibling dossier and passes
  the narrow-Gaussian finite test that the recorded \(N\) fails (the broad
  compact-support rung is open, note 39).
- The programme reopens with an exact contour identity, the correct in-repo
  functional, and a decisive acceptance test. The remaining wall is the
  infinite cone. It should be read as an open research programme
  with a corrected target, not as a closed one.

[Back to the dossier](../README.md) · [Rescue](38-rescue.md) ·
[Research journal](../research-journal.md)
