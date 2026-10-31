# Rounds 1–2: the archimedean sign and the near-positive broad form

**Status:** rounds 1–2 of the continued programme (journal rounds 47–48), with the formal status recorded in [`../lean/README.md`](../lean/README.md). The finite KMS/compatibility/sign/quadratic-form statements, the rational Gram shadows (`G4_psd`, `N4_not_psd`), the archimedean contour identity (`arch_contour_identity`) and the `ζ`/`Γ` symbol identity on `Re s > 1` (`symbol_identity`) are Lean-checked; the crossover table, the choice of the `-Ω` sign in the explicit formula, and every analytic eigenvalue below are **not** Lean-checked. The

> **Round 57 correction.** The sign conclusion below is **withdrawn**.
> The fixed-grid archimedean sum omitted the quadrature weights, so the
> archimedean term was inflated by \(1/\Delta t\). With exact adaptive
> quadrature the sibling's **cosh \(+\Omega\)** form is positive
> semidefinite and the \(-\Omega\) form is the one with a residual. See
> [`41-quadrature-correction.md`](41-quadrature-correction.md). The table
> and numbers below are preserved as the round-47 record; use note 41 for the
> corrected values.
broad compact-support discrepancy is traced to the **archimedean sign**. The
standard explicit formula carries \(-\Omega\), while the sibling dossier's
\(W\) carries \(+\Omega\). With the standard sign the broad Gram matrix is
**nearly positive semidefinite**: smallest eigenvalue
\(-4.4\cdot10^{-3}\) on the \(C^0\) basis and \(-2.7\cdot10^{-4}\) on a
\(C^\infty\) bump basis, against \(-2.06\cdot10^{1}\) for the \(+\Omega\)
convention. A small, smoothness-dependent residual remains; it is the new open
problem. No RH proof is claimed yet.

## 1. The standard formula

For a compactly supported \(g\) on \(\mathbb R\) put
\(\widehat g(t)=\int g(x)e^{-itx}dx\). The Riemann–Weil explicit formula, with
\(\rho=\tfrac12+i\gamma\) and
\(\Omega(t)=\operatorname{Re}\psi(\tfrac14+\tfrac{it}{2})-\log\pi\), is

\[
\sum_\rho \widehat g(\rho)
=\widehat g(0)+\widehat g(1)
-\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}\bigl(g(\log n)+g(-\log n)\bigr)
-\frac{1}{2\pi}\int_{\mathbb R}\widehat g(t)\,\Omega(t)\,dt .
\]

For \(g=F*F_-\) with real even \(F\),

\[
\widehat g(t)=|\widehat F(t)|^2,\qquad
\widehat g(0)=\Bigl(\int F\Bigr)^2,\qquad
\widehat g(1)=|\widehat F(1)|^2,
\]

so the candidate functional is

\[
\boxed{
W(h)=\Bigl(\int F\Bigr)^2+\bigl|\widehat F(1)\bigr|^2
-2\sum_{n\ge2}\frac{\Lambda(n)}{\sqrt n}h(\log n)
-\frac{1}{2\pi}\int_{\mathbb R}\bigl|\widehat F(t)\bigr|^2\Omega(t)\,dt ,
}
\qquad h=F*F_- .
\]

There is no \(e^{x/2}\) weight in this additive convention. The Mellin
convention shifts the contour and replaces the pole terms by
\(|Mf(0)|^2+|Mf(1)|^2\); it gives the same qualitative result
(\(-5.9\cdot10^{-3}\) on the \(C^0\) basis at \(4\times4\)) and is recorded in
`weil_compact_gram_corrected` in
[`../python/rescue_probe.py`](../python/rescue_probe.py).

The two differences from the sibling dossier's \(W\) are:

- the archimedean sign: standard \(-\Omega\), sibling \(+\Omega\);
- the pole terms: standard \(\widehat g(0)+\widehat g(1)\), sibling
  \(2\int h\cosh(u/2)=\widehat g(i/2)+\widehat g(-i/2)\).

## 2. The two signs on the broad basis

Basis \(F_k(x)=(1-x^2)_+x^{2k}\) on \([-1,1]\); Gram \(W_{ij}=W(F_i*F_{j,-})\):

| convention | \(3\times3\) | \(4\times4\) | \(5\times5\) |
|---|---|---|---|
| \(+\Omega\), cosh pole (sibling) | \(-20.6,\dots\) | \(-20.57,\dots\) | \(-20.6,\dots\) |
| \(-\Omega\), additive pole (standard) | \(-1.96\cdot10^{-3}\) | \(-4.44\cdot10^{-3}\) | \(-6.89\cdot10^{-3}\) |
| \(-\Omega\), smooth bump basis | \(-1.62\cdot10^{-4}\) | \(-2.69\cdot10^{-4}\) | \(-3.24\cdot10^{-4}\) |

The full \(4\times4\) spectrum on the \(C^0\) basis is

\[
-4.441\cdot10^{-3},\quad -1.95\cdot10^{-4},\quad 2.446\cdot10^{-1},\quad
3.628\cdot10^{1}.
\]

The negative residual is not a quadrature artefact: it is stable under
refinement (800, 1600, 3000 nodes; \(t_{\max}\) 150, 200, 300) and grows
slowly with the basis. It is also pole-independent: replacing
\((\int F)^2+|\widehat F(1)|^2\) by the Mellin squares changes it at the
\(10^{-3}\) level, and the negative eigenvector is nearly orthogonal to the
pole.

## 3. What the residual is

The residual is relatively small: on the archimedean scale of the form
(\(\sim4\)) the smooth-bump value is \(-2.7\cdot10^{-4}\), a relative error of
about \(10^{-4}\). Three explanations remain:

1. **A small missing term.** The completed explicit formula may carry a
   boundary or constant term that the \(\widehat g(0)+\widehat g(1)\)
   shorthand hides. The trivial-zero sum \(\sum_{n\ge1}\widehat g(-2n)\) is
   divergent for compact support (\(\sim10^{14}\) on this basis) and is
   already absorbed in the archimedean factor; it is not the fix.
2. **Smoothness.** The \(C^0\) basis has a \(16\times\) larger residual than the
   \(C^\infty\) bump. A residual that survives in the smooth limit is not a
   kink artefact, but the comparison shows the test class matters.
3. **The exact constant.** A missing factor of order \(1+10^{-4}\) in the
   archimedean term would close the gap, but no such constant is known, and
   fitting one is not a derivation.

The residual is the precise open problem, and it is computable: the negative
direction is concentrated on the high-\(k\) modes, where the archimedean term
is \(\sim4\) and the pole/prime terms are \(\sim10^{-4}\).

## 4. Consequences for the earlier claims

- **The sibling's \(+\Omega\) certificate is a different convention.** It is a
  valid finite PSD statement for its functional, but that functional is not
  the standard explicit formula. The narrow Gaussian basis is also additive
  in a different variable; it is not a multiplicative-cone rung.
- **The recorded normalization \(N\) is still rejected.** The exact symbol
  identity of note 38 and the contour shift stand; the recorded \(N\) is not
  the standard \(W\).
- **Note 38's positive identification is revised.** The missing pole integral
  was the right diagnosis; the archimedean sign was wrong. The corrected
  candidate is the standard formula of §1, and it is near-PSD, not PSD.
- **No RH claim.** A near-PSD Gram matrix is not a positivity theorem, and the
  residual is not understood.

## 5. Next computation (round 3)

1. Re-derive the standard formula from a primary source with all constants and
   compare term by term with §1. Resolve the residual analytically on the
   \(4\times4\) basis if possible.
2. Test smaller supports and the degree-zero constraint; determine whether the
   residual is a boundary term.
3. Test a multiplicative Gaussian \(f(u)=e^{-(\log u)^2/(2\sigma^2)}\), which
   is in the cone, alongside the additive bump.
4. Only after both the narrow and broad tests pass: the cone, the
   Bost–Connes compatibility, and the scaling-site Hodge index.

## 6. Bottom line

- The archimedean sign is the main broad-test error; correcting it brings the
  form from \(-20.6\) to \(-4.4\cdot10^{-3}\) (\(C^0\)) and
  \(-2.7\cdot10^{-4}\) (smooth).
- A small, stable, smoothness-dependent residual remains; it is the new
  target.
- The recorded \(N\) remains rejected; the sibling's \(+\Omega\) certificate is
  a different convention, not a cone certificate.
- No RH proof yet; the programme is closer to a well-posed finite conjecture than
  at any earlier round.

[Back to the dossier](../README.md) · [Rescue](38-rescue.md) ·
[Revised assessment](37-final-assessment.md) ·
[Research journal](../research-journal.md)
